from flask import Blueprint, request
from utils import prepare_input_data, expand_contractions, get_named_entities, response_with_data, respond_with_error

ner = Blueprint("ner", __name__)


@ner.route('/ner', methods=['POST'])
def analyze_ner():
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

    print("Expanding contractions...")
    processed_data = expand_contractions(processed_data)

    print("Getting named entities...")
    processed_data = get_named_entities(processed_data)

    return response_with_data(processed_data, 200)
