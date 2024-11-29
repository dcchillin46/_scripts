#!/bin/bash

# Check if the directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Get the target directory from the first argument
target_dir="$1"

# Check if the directory exists
if [ ! -d "$target_dir" ]; then
    echo "Error: Directory '$target_dir' does not exist."
    exit 1
fi

# Change to the target directory
cd "$target_dir" || exit

# Check if any .chd files exist in the directory
if ! ls *.chd >/dev/null 2>&1; then
    echo "No .chd files found in the directory '$target_dir'. Exiting."
    exit 0
fi

# Initialize approve all flag
approve_all=false

# Loop through .chd files and remove related files
for chd_file in *.chd; do
    # Skip if no .chd files are found
    [ -e "$chd_file" ] || continue

    # Get the base name of the .chd file without the extension
    base_name="${chd_file%.chd}"

    # Find and delete all related files except .chd
    for ext in bin cue iso; do
        file="${base_name}.${ext}"
        if [ -f "$file" ]; then
            if [ "$approve_all" = false ]; then
                echo "Found: $file. Delete? [y/n/a (approve all)]"
                read -r response
                case "$response" in
                    y|Y) 
                        echo "Deleting $file"
                        rm "$file"
                        ;;
                    a|A) 
                        echo "Approving all deletions."
                        approve_all=true
                        rm "$file"
                        ;;
                    n|N) 
                        echo "Skipping $file"
                        ;;
                    *) 
                        echo "Invalid input. Skipping $file."
                        ;;
                esac
            else
                echo "Deleting $file"
                rm "$file"
            fi
        fi
    done
done

# Check if any non-CHD files remain in the directory
if ls *.bin *.cue *.iso >/dev/null 2>&1; then
    echo "Script completed, but some non-CHD files remain."
else
    echo "Only completed .chd files remain. No remnant files to clean."
fi
