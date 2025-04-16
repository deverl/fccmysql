#!/bin/bash

# Path to the Nginx access log
ACCESS_LOG="/var/log/nginx/access.log"

# Check if the log file exists
if [[ ! -f "$ACCESS_LOG" ]]; then
  echo "Nginx access log not found at $ACCESS_LOG"
  exit 1
fi

# Tail the log and print only the IP addresses
tail -F "$ACCESS_LOG" | awk '{print $1}'

