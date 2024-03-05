# Use an official Python runtime as a parent image
FROM python:3.11-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

RUN apk add --no-cache gcc musl-dev python3-dev

# Install any needed packages specified in requirements.txt first to leverage caching
# Copy only the requirements file initially
COPY ./app/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Then copy the rest of the application
COPY ./app .

# Download NLTK data
# Consider moving this to a script that runs when the container starts if this data updates frequently,
# or manage data downloading separately if feasible.
RUN python -m nltk.downloader all

# Make port 80 available to the world outside this container
EXPOSE 80

# Run gunicorn and bind it to port 80
CMD ["gunicorn", "--bind", "0.0.0.0:80", "app:app"]
