#!/bin/bash

# Path to the Nginx access log
ACCESS_LOG="/var/log/nginx/access.log"

# Check if the log file exists
if [[ ! -f "$ACCESS_LOG" ]]; then
  echo "Nginx access log not found at $ACCESS_LOG"
  exit 1
fi

# Extract and list only the IP addresses from the log
# Assumes IP is the first field in the log
awk '{print $1}' "$ACCESS_LOG" | sort | uniq


