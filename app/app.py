"""Module for Py-Mood-Marker application.

This module contains functions and logic to analyze sentiments and emotions from text data.
It includes capabilities to read data, process and analyze it for sentiment and emotional content,
and output the results with enhanced metadata.
"""
import contractions
import nltk
from flask import Flask, request
from nrclex import NRCLex
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

app = Flask(__name__)

MIN_WORD_COUNT = 5

""" 
nltk.data.path.append("../data")
"""


def respond_with_error(message, status_code=400):
    print("Error: ", message)

    return {
        "error": message,
    }, status_code


def response_with_data(data, status_code=200):
    print("Success. Data: ", data)

    return data, status_code


@app.route('/sentiment', methods=['POST'])
def analyze():
    print("Request received")

    # Extracting the body from the event
    body = request.form.get("text")

    if not body:
        print("No body found in the request.")

        return respond_with_error("No body found in the request.", 400)

    # Processing the input data
    processed_data = process_line(body)

    # Ensure the processed data is returned
    if processed_data is not None:
        return response_with_data(processed_data, 200)
    else:
        return respond_with_error("Processing failed or the text was too short.", 400)


def expand_contractions(json_line):
    """Expand contractions in the text of a JSON line."""
    json_line['text'] = contractions.fix(json_line['text'])
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


def process_line(input_text):
    """Process a line of text to analyze sentiment and emotions."""
    if not input_text.strip():
        return None

    json_row = {"text": input_text}
    word_count = len(json_row['text'].split())

    if word_count < MIN_WORD_COUNT:
        return {"message": "Text too short for analysis."}

    print("Expanding contractions...")
    json_row = expand_contractions(json_row)

    print("Getting emotion scores...")
    json_row = get_emotion(json_row)

    print("Getting VADER emotion scores...")
    json_row = get_vader_emotion(json_row)

    return json_row
