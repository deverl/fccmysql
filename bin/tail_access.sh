#!/bin/bash

ACCESS_LOG="/var/log/nginx/access.log"

if [[ ! -f "$ACCESS_LOG" ]]; then
  echo "Nginx access log not found at $ACCESS_LOG"
  exit 1
fi

tail -F "$ACCESS_LOG" | awk '
{
  ip = $1

  # Extract timestamp in brackets
  match($0, /\[([^]]+)\]/, time)
  timestamp = time[1]

  # Extract request line (e.g. "GET /something?x=1 HTTP/1.1")
  match($0, /"[^"]+"/, request)
  split(request[0], parts, " ")
  path = parts[2]

  # Skip styles.css requests
  if (path ~ /styles\.css/) {
    next
  }

  # Extract query string
  split(path, urlParts, "?")
  query = (length(urlParts) > 1) ? urlParts[2] : "-"

  printf "[%s] %s  |  Query: %s\n", timestamp, ip, query
}'


