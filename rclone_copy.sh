#!/bin/bash

# Enable verbose output for debugging
# set -x

# Check if an HTTP URL and destination directory are provided as arguments
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <http_url> <destination_directory> [additional filters]"
    echo "Example: $0 http://example.com /path/to/destination + \"*Japan*\" - \"*Europe*\""
    exit 1
fi

# Assign the HTTP URL and destination directory
HTTP_URL="$1"
DEST_DIR="$2"
shift 2  # Move past the HTTP_URL and DEST_DIR arguments to process remaining arguments as filters

# Initialize an array for user-provided filters
USER_FILTERS=()

# Add any additional filters provided by the user, handling any filters that start with '-' or '+' safely
for filter in "$@"; do
    # Check if filter starts with - or + and add it as an option to --filter
    if [[ "$filter" =~ ^[-\+]\ .* ]]; then
        USER_FILTERS+=(--filter="$filter")
    else
        USER_FILTERS+=(--filter "$filter")
    fi
done

# Default filter options. Remove or modify as desired.
DEFAULT_FILTERS=(
    --filter '- *beta*'
    --filter '- *proto*'
    --filter '- *aftermarket*'
    --filter '- *demo*'
    --filter '- *pirate*'
    --filter '- *virtual console*'
	--filter '- *rev*'
	--filter '- *unl*'
    --filter '+ *USA*'
    --filter '- *'
)

# Combine user-provided filters and default filters, with user filters first
FILTER_OPTIONS=("${USER_FILTERS[@]}" "${DEFAULT_FILTERS[@]}")

# Run rclone with copy command to transfer files from the HTTP URL to the local directory
rclone copy -v \
    "${FILTER_OPTIONS[@]}" \
    --http-no-head \
    --ignore-case \
    --human-readable \
    --http-url="$HTTP_URL" :http: "$DEST_DIR"

# Check if the rclone copy command succeeded
if [ $? -ne 0 ]; then
    echo "Error: rclone copy command failed."
    exit 1
fi

# Count and print the total number of items copied
total_items=$(rclone ls \
    "${FILTER_OPTIONS[@]}" \
    --http-no-head \
    --ignore-case \
    --http-url="$HTTP_URL" :http: | sed '/^$/d' | wc -l)

echo "Total ROMs copied: $total_items"
