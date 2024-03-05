# Mood Marker API


## Running Locally 🏠

Run `make docker-up` to start the application and its dependencies.

```bash
make docker-up
```

You can now analyze sentiment:

```bash
curl -X POST http://localhost/sentiment -d "body=this is text to be analyzed" 
```

The endpoint expects a URL Encoded Form post with the `text` property being
set to the text to be analyzed for sentiment.

The response is a JSON object containing the analyzed text, a VADER score,
and the emotion scores returned in JSON:

```json
{
  "emotion_scores": {
    "positive": 3,
    "trust": 2
  },
  "vader_emotion_scores": {
    "compound": 0.5106,
    "neg": 0.0,
    "neu": 0.915,
    "pos": 0.085
  },
  "text": "To automate the Docker build and push process with Terraform..."
}
```

Errors will be returned in the following format:

```json
{
  "error": "No body found in the request."
}
```

---

## Deploying Docker to AWS ECR 📦

Create a builder instance for multi-arch builds 🏗️:

Authenticate with AWS ECR 🔑:

```bash
make ecr-auth
```

Build and deploy the Docker image to AWS 🚀:

```bash
make ecr-deploy
```

## Deploying Task to AWS ECS 🌐

Executing the terraform in the `./terraform` folder will create 
an ECS cluster with a load balancer and a task that
runs the deployed docker container from the steps above 📈.

```bash
cd terraform && tf init && tf apply
```
