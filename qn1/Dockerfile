# Base image
FROM python:3.9

# Set the working directory
WORKDIR /app

# Copy your script and requirements file
COPY data_cleaning.py /app/
COPY requirements.txt /app/

# Install project dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set the cron schedule
RUN echo "0 * * * * root python /app/data_cleaning.py >> /var/log/cron.log 2>&1" > /etc/cron.d/data_cleaning

# Give execution permissions to the cron job file
RUN chmod 0644 /etc/cron.d/data_cleaning

# Create a log file for cron job output
RUN touch /var/log/cron.log

# Run the cron job
CMD cron && tail -f /var/log/cron.log
