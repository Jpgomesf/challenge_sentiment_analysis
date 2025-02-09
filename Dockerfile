# Use an official lightweight Python image.
FROM python:3.10-slim

# Set the working directory inside the container.
WORKDIR /app

# Copy the requirements file from the app folder.
COPY app/requirements.txt .

# Install dependencies.
RUN pip install --no-cache-dir -r requirements.txt

# Copy all application files from the app folder.
COPY app/ .

# Copy the .env file from the project root into the container.
COPY .env .

# Set the command to run your analysis script.
CMD ["python", "run_analysis.py"]
