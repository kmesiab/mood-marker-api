.PHONY: all docker-up docker-build docker-run

docker-up: docker-build docker-run

docker-build:
	@echo "Building the Docker image..."
	@docker build -t mood-marker-api .

docker-run:
	@echo "Running the Docker container..."
	@docker run -p 80:443 mood-marker-api:latest

ecr-deploy: ecr-auth ecr-build-push

ecr-auth:
	@echo "Authenticating with AWS ECR..."
	@aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 462498369025.dkr.ecr.us-west-2.amazonaws.com

ecr-build-push:
	@echo "Building and pushing the Docker image to AWS ECR..."
	@docker buildx build --platform linux/amd64,linux/arm64 -t 462498369025.dkr.ecr.us-west-2.amazonaws.com/mood-marker-api:latest --push .
