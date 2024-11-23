#!/bin/bash

# Check if a directory path is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <directory_path> [--delete-lower-revisions]"
    exit 1
fi

# Set the directory path
DIR_PATH="$1"
DELETE_LOWER=false

# Check if the delete flag is set
if [ "$2" == "--delete-lower-revisions" ]; then
    DELETE_LOWER=true
fi

# Ensure the directory exists
if [ ! -d "$DIR_PATH" ]; then
    echo "Error: Directory $DIR_PATH does not exist."
    exit 1
fi

# Associative arrays to track highest revisions
declare -A rev_map
declare -A file_map

# Scan files in the directory
for file in "$DIR_PATH"/*; do
    # Extract the filename only, without the path
    filename=$(basename "$file")

    # Use regex to match filenames with "Rev" followed by a number, or no revision
    if [[ "$filename" =~ (.*)\(Rev[[:space:]]([0-9]+)\)(.*) ]]; then
        # File with revision
        base_name="${BASH_REMATCH[1]}${BASH_REMATCH[3]}"
        revision="${BASH_REMATCH[2]}"
    else
        # File without revision, treated as revision 0
        base_name="$filename"
        revision=0
    fi

    # Keep only the highest revision for each base_name
    if [[ -z "${rev_map[$base_name]}" || "$revision" -gt "${rev_map[$base_name]}" ]]; then
        rev_map[$base_name]=$revision
        file_map[$base_name]="$file"
    fi
done

# Output the files with the highest revision
echo "Files with the highest revisions in $DIR_PATH:"
for base_name in "${!file_map[@]}"; do
    echo "${file_map[$base_name]}"
done

# Optionally delete lower revisions if the delete flag is set
if [ "$DELETE_LOWER" = true ]; then
    echo "Deleting lower revisions..."
    for file in "$DIR_PATH"/*; do
        filename=$(basename "$file")
        if [[ "$filename" =~ (.*)\(Rev[[:space:]]([0-9]+)\)(.*) ]]; then
            base_name="${BASH_REMATCH[1]}${BASH_REMATCH[3]}"
            revision="${BASH_REMATCH[2]}"
            # Delete file if it's a lower revision
            if [[ "$revision" -lt "${rev_map[$base_name]}" ]]; then
                echo "Deleting $file (lower revision)"
                rm "$file"
            fi
        fi
    done
fi
