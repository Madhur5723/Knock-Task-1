#!/bin/bash

# Define the log file and threshold
LOG_FILE="/home/einfochips/Desktop/All/Knock/Task/Shell/cpu_usage.log"
THRESHOLD=80  # CPU usage threshold in percentage

# Define email parameters
EMAIL="madhurshinde007@gmail.com.com"
SUBJECT="High CPU Usage Alert"
SMTP_SERVER="smtp.example.com"
SMTP_PORT=587
USERNAME="madhurshinde007@gmail.com"
PASSWORD="Madhur007@"

# Function to get the current CPU usage
get_cpu_usage() {
    # Use top to get the current CPU usage and filter the line with "Cpu(s)"
    # Calculate the sum of all CPU usages (user, system, iowait, etc.)
    top -b -n2 -d 0.5 | grep "Cpu(s)" | tail -1 | awk '{print $2 + $4 + $6 + $10 + $11 + $12}'  # Add other CPU usages if needed
}

# Function to send an email notification
send_email() {
    local current_cpu_usage=$1
    echo "CPU usage is high: $current_cpu_usage%" | mail -s "$SUBJECT" -r "$EMAIL" "$EMAIL"
}

# Main loop to monitor CPU usage every 5 minutes
while true; do
    # Get the current CPU usage
    current_cpu_usage=$(get_cpu_usage)

    # Log the current CPU usage to the log file
    echo "$(date): CPU usage: $current_cpu_usage%" >> "$LOG_FILE"

    # Check if the current CPU usage exceeds the threshold
    if (( $(echo "$current_cpu_usage > $THRESHOLD" | bc -l) )); then
        # Send an email notification
        send_email "$current_cpu_usage"
    fi

    # Sleep for 5 minutes before checking again
    sleep 10
done

