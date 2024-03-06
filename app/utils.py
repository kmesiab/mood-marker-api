import json
import re
import contractions
import spacy
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
from nrclex import NRCLex

MIN_WORD_COUNT = 5
nlp = spacy.load("en_core_web_sm")


def respond_with_error(message, status_code=400):
    print("Error: ", message)
    return {"error": message}, status_code


def response_with_data(data, status_code=200):
    print("Success. Data: ", data)
    return data, status_code


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


def get_nouns(json_line):
    """Extract named entities from the text of a JSON line."""
    doc = nlp(json_line['text'])
    phrases = []

    for noun_chunk in doc.noun_chunks:
        phrases.append({
            'text': noun_chunk.text,
            'root_text': noun_chunk.root.text,
            'root_dep': noun_chunk.root.dep_
        })

    json_line['noun_phrases'] = phrases

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
        return None

    return json_row
