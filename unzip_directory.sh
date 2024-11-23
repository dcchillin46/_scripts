#!/bin/bash

# Check if both source and destination directories are provided as arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

# Assign arguments to source and destination directories
SOURCE_DIR="$1"
DEST_DIR="$2"

# Create the destination directory if it doesn’t exist
mkdir -p "$DEST_DIR"

# Loop through each .zip file in the source directory and unzip it in the background
for file in "$SOURCE_DIR"/*.zip; do
    # Check if the file exists (in case there are no zip files)
    if [ -f "$file" ]; then
        # Unzip the file to the destination directory in the background
        unzip -o "$file" -d "$DEST_DIR"
		rm "$file"
		echo "$(basename "$file") Unzipped and Deleted"
    fi
done

# Wait for all background unzip processes to finish
wait

echo "All files have been unzipped to $DEST_DIR"

