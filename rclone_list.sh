#!/bin/bash

# Enable verbose output for debugging
# set -x

# Check if an HTTP URL is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <http_url> [ optional additional filters]"
    echo "Example: $0 http://example.com \"+ *Japan*\" \"- *Europe*\""
    exit 1
fi

# Assign the HTTP URL and shift to capture additional filters as arguments
HTTP_URL="$1"
shift 1  # Move past the HTTP_URL argument to process remaining arguments as filters

# Initialize an array for user-provided filters
USER_FILTERS=()

# Add any additional filters provided by the user
for filter in "$@"; do
    USER_FILTERS+=(--filter "$filter")
done

# Starting filter options
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

# Run rclone with specified filters and HTTP URL, capturing output
item_list=$(rclone ls -v \
    "${FILTER_OPTIONS[@]}" \
    --http-no-head \
    --ignore-case \
    --human-readable \
    --http-url="$HTTP_URL" :http: 2>&1)

# Check if the rclone command succeeded
if [ $? -ne 0 ]; then
    echo "Error: rclone command failed."
    exit 1
fi

# Display the list of items
echo "$item_list"

# Count and print the total number of items, filtering out empty lines
total_items=$(echo "$item_list" | sed '/^$/d' | wc -l)
echo "Total ROMs: $total_items"
