#!/bin/bash

# Configuration variables
# ENDPOINT="https://railway-api-demo-production.up.railway.app/api/edwin"
# ENDPOINT="https://railway-api-demo-production-aa9c.up.railway.app/api/edwin"
ENDPOINT="https://bun-api-demo.connectware.xyz/api/edwin"
INTERVAL=0.5

# Function to call the API
call_api() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] Calling API: $ENDPOINT"
    
    # Make the API call
    response=$(curl -s -o /dev/null -w "%{http_code}|%{time_total}" "$ENDPOINT" 2>&1)
    http_code=$(echo "$response" | cut -d'|' -f1)
    time_total=$(echo "$response" | cut -d'|' -f2)
    
    # Convert seconds to milliseconds
    time_ms=$(awk "BEGIN {printf \"%.2f\", $time_total * 1000}")
    
    echo "[$timestamp] Status Code: $http_code | Response Time: ${time_ms}ms"
    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
        echo "[$timestamp] ✓ Success"
    else
        echo "[$timestamp] ✗ Failed"
    fi
    echo ""
}

# Main loop
echo "Starting API polling..."
echo "Endpoint: $ENDPOINT"
echo "Interval: $INTERVAL seconds"
echo "Press Ctrl+C to stop"
echo ""

# Trap Ctrl+C to exit gracefully
trap 'echo ""; echo "Stopping API polling..."; exit 0' INT

# Infinite loop
while true; do
    call_api
    sleep "$INTERVAL"
done

