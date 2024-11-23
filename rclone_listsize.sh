#!/bin/bash

# Function to convert bytes to a human-readable format
convert_to_human_readable() {
    local bytes=$1
    if [[ $bytes -ge $((1024**3)) ]]; then
        echo "$(awk "BEGIN {printf \"%.2f GB\", $bytes/1024/1024/1024}")"
    elif [[ $bytes -ge $((1024**2)) ]]; then
        echo "$(awk "BEGIN {printf \"%.2f MB\", $bytes/1024/1024}")"
    elif [[ $bytes -ge 1024 ]]; then
        echo "$(awk "BEGIN {printf \"%.2f KB\", $bytes/1024}")"
    else
        echo "$bytes bytes"
    fi
}

# Check if an HTTP URL is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <http_url> [additional filters]"
    echo "Example: $0 http://example.com + \"*Japan*\" - \"*Europe*\""
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

# Default filter options
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
item_list=$(rclone ls \
    "${FILTER_OPTIONS[@]}" \
    --ignore-case \
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

# Calculate the total file size by iterating through sizes in item_list
total_size=0
while IFS= read -r line; do
    # Extract size from each line and convert to bytes if needed
    size=$(echo "$line" | awk '{print $1}')
    
    # Check if the size is in human-readable format and convert it to bytes
    if [[ "$size" =~ [0-9]+[KMG] ]]; then
        multiplier=1
        case "${size: -1}" in
            K) multiplier=1024 ;;
            M) multiplier=$((1024**2)) ;;
            G) multiplier=$((1024**3)) ;;
        esac
        size=${size%[KMG]}  # Remove the suffix
        size=$((size * multiplier))
    fi

    # Add the size to the total if it's a valid number
    if [[ "$size" =~ ^[0-9]+$ ]]; then
        total_size=$((total_size + size))
    fi
done <<< "$item_list"

# Display the total file size in bytes and human-readable format
echo "Total Disc Space Required: $(convert_to_human_readable $total_size)"
