"""Module for Py-Mood-Marker application.

This module contains functions and logic to analyze sentiments and emotions from text data.
It includes capabilities to read data, process and analyze it for sentiment and emotional content,
and output the results with enhanced metadata.
"""
import contractions
import spacy
import re
from flask import Flask, request
from nrclex import NRCLex
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

app = Flask(__name__)

MIN_WORD_COUNT = 5

nlp = spacy.load("en_core_web_sm")


def respond_with_error(message, status_code=400):
    print("Error: ", message)

    return {
        "error": message,
    }, status_code


def response_with_data(data, status_code=200):
    print("Success. Data: ", data)

    return data, status_code


@app.route('/ner', methods=['POST'])
def analyze_ner():
    print("Request received")

    # Extracting the body from the event
    body = request.form.get("text")

    if not body:
        print("No body found in the request.")

        return respond_with_error("No body found in the request.", 400)

    # Processing the input data
    processed_data = prepare_input_data(body)

    print("Expanding contractions...")
    processed_data = expand_contractions(processed_data)

    print("Getting named entities...")
    processed_data = get_named_entities(processed_data)

    return response_with_data(processed_data, 200)


@app.route('/sentiment', methods=['POST'])
def analyze_sentiment():
    print("Request received")

    # Extracting the body from the event
    body = request.form.get("text")

    if not body:
        print("No body found in the request.")

        return respond_with_error("No body found in the request.", 400)

    # Processing the input data
    processed_data = prepare_input_data(body)

    if processed_data is None:
        return respond_with_error("Processing failed or the text was too short.", 400)

    # Processing the input data
    print("Expanding contractions...")
    processed_data = expand_contractions(processed_data)

    print("Getting emotion scores...")
    processed_data = get_emotion(processed_data)

    print("Getting VADER emotion scores...")
    processed_data = get_vader_emotion(processed_data)

    return response_with_data(processed_data, 200)


def strip_date_prefix(input_string):
    """
    Remove the date prefix from the text of a JSON line.

    ex: 2024-03-05 21:19:36 +0000 UTC

    """
    date_pattern = r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \+\d{4}(?: UTC)?'
    return re.sub(date_pattern, '', input_string).strip()


def expand_contractions(json_line):
    """Expand contractions in the text of a JSON line."""
    json_line['text'] = contractions.fix(json_line['text'])
    return json_line


def get_named_entities(json_line):
    """Extract named entities from the text of a JSON line."""
    doc = nlp(json_line['text'])

    entities = []
    for ent in doc.ents:
        entities.append({'text': ent.text, 'label': ent.label_})

    json_line['named_entities'] = entities
    return json_line


def get_emotion(json_line):
    """Analyze and add emotion scores to a JSON line."""
    emotion_analysis = NRCLex(json_line['text'])
    sorted_emotion_score_values = sorted(emotion_analysis.raw_emotion_scores.items(), key=lambda x: x[1], reverse=True)
    sorted_emotions_dict = dict(sorted_emotion_score_values)
    json_line['emotion_scores'] = sorted_emotions_dict
    return json_line


def get_vader_emotion(json_line):
    """Analyze text sentiment using VADER and add the scores to a JSON line."""
    analyzer = SentimentIntensityAnalyzer()
    vader_scores = analyzer.polarity_scores(json_line['text'])
    json_line['vader_emotion_scores'] = vader_scores
    return json_line


def prepare_input_data(input_text):
    """Process a line of text to analyze sentiment and emotions."""
    if not input_text.strip():
        return None

    input_text = strip_date_prefix(input_text.strip())

    json_row = {"text": input_text}
    word_count = len(json_row['text'].split())

    if word_count < MIN_WORD_COUNT:
        return {"message": "Text too short for analysis."}

    return json_row
