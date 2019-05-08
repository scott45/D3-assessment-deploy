# Use an official Python image as a base image
FROM python:3.6.4

# labels
LABEL MAINTAINER="Scott B <businge.scott@andela.com>"
LABEL application="assessmentd3"

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 8000

# Run app.py when the container launches
CMD ["python", "run.py"]