# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Install any needed packages specified in requirements.txt first to leverage caching
# Update apt package lists and install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libc6-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy only the requirements file initially
COPY ./app/requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

# Download the en_core_web_sm model
RUN python -m spacy download en_core_web_sm

# Then copy the rest of the application
COPY ./app .

# Download NLTK data
# Consider moving this to a script that runs when the container starts if this data updates frequently,
# or manage data downloading separately if feasible.
RUN python -m nltk.downloader vader_lexicon punkt

# Make port 80 available to the world outside this container
EXPOSE 80

# Run gunicorn and bind it to port 80
CMD ["gunicorn", "--bind", "0.0.0.0:80", "main:app"]
