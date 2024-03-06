# Mood Marker API 🃏

- [Mood Marker API 🃏](#mood-marker-api-)
  - [Analyze Sentiment](#analyze-sentiment)
  - [Extract Named Entities](#extract-named-entities)
  - [Noun Phrases](#noun-phrases)
- [Getting Started 🏠](#getting-started-)
- [Deploying Docker to AWS ECR 📦](#deploying-docker-to-aws-ecr-)
  - [Authenticate with AWS ECR 🔑](#authenticate-with-aws-ecr-)
  - [Build and deploy the Docker image to AWS 🚀](#build-and-deploy-the-docker-image-to-aws-)
- [Deploying Task to AWS ECS 🌐](#deploying-task-to-aws-ecs-)


**The Mood Marker API is a powerful, lightweight Natural Language
Processing (NLP) API** tailored for seamless integration and deployment on AWS.

It offers a suite of endpoints for conducting essential NLP tasks, including
sentiment analysis and Named Entity Recognition (NER), designed to enhance
your applications with the capability to understand and interpret the
emotional and factual content of text data.

## 🚀 Analyze Sentiment

To perform sentiment analysis, use the curl command as follows:

```bash
curl -X POST http://localhost/sentiment -d "text=this is text to be analyzed"
```

This endpoint expects a form `POST` with the `text` field containing the text
you wish to analyze. It returns a detailed JSON object with the original text,
a comprehensive VADER sentiment score, and emotion scores to quantify the
sentiment of the input text accurately.

Example of a successful response:

```json
{
  "emotion_scores": {
    "anticipation": 1,
    "joy": 3,
    "positive": 5,
    "surprise": 1
  },
  "text": "Despite the grey skies, John and Maria's wedding in Seattle was filled with joy, laughter, and an overwhelming sense of love, truly a heartwarming event.",
  "vader_emotion_scores": {
    "compound": 0.952,
    "neg": 0.031,
    "neu": 0.509,
    "pos": 0.461
  }
}
```

Errors will be returned in the following format:

```json
{
  "error": "No body found in the request."
}
```

## 🚀 Extract Named Entities

To extract named entities from text, use the following curl command:

```bash
curl -X POST http://localhost/ner -d "text=this is text to be analyzed"
```

This endpoint accepts a URL Encoded Form post with the `text` property set
to the text you wish to analyze for entities. It returns a JSON object
containing the identified entities, enhancing your text's understanding.

Example response:

```json
{
  "named_entities": [
    {
      "label": "PERSON",
      "text": "John"
    },
    {
      "label": "PERSON",
      "text": "Maria"
    },
    {
      "label": "GPE",
      "text": "Seattle"
    }
  ],
  "text": "Despite the grey skies, John and Maria's wedding in Seattle was filled with joy, laughter, and an overwhelming sense of love, truly a heartwarming event."
}
```

Errors will follow this format:

```json
{
  "error": "No body found in the request."
}
```

## Noun Phrases

To extract the nouns and their roots:

```bash
curl -X POST http://localhost/nouns -d "text=The quick brown fox..."
```

```json
{
  "noun_phrases": [
    {
      "root_dep": "nsubj",
      "root_text": "fox",
      "text": "The quick brown fox"
    },
    {
      "root_dep": "pobj",
      "root_text": "dog",
      "text": "the lazy dog"
    }
  ],
  "text": "The quick brown fox jumped over the lazy dog"
}
```

---

## Getting Started 🏠

Clone the repository, then navigate to the root directory.

```bash
git clone git@github.com:kmesiab/mood-marker-api.git && \
cd mood-marker-api
```

To initiate the Mood Marker API and its dependencies on your local machine,
execute the following command:

```bash
make docker-up
```

This command spins up the application, making it ready for local development
and testing.  You can now access the API at `http://localhost`.

---

## Deploying Docker to AWS ECR 📦


Authenticate with AWS ECR 🔑:

```bash
make ecr-auth
```

Build and deploy the Docker image to AWS 🚀:

```bash
make ecr-deploy
```

## Deploying Task to AWS ECS 🌐

```bash
cd terraform && tf init && tf apply
```

See the ./terraform/README.md for more information on the 
AWS infrastructure deployment.