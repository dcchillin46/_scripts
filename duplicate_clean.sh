#!/bin/bash

# Check if directory is passed as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

DIRECTORY="$1"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Error: Directory '$DIRECTORY' does not exist."
    exit 1
fi

# Find all files in the directory
files=$(find "$DIRECTORY" -type f)
if [ -z "$files" ]; then
    echo "No files found in the directory."
    exit 0
fi

# Group similar files by fuzzy matching prefixes
declare -A file_groups
while IFS= read -r file; do
    base_name=$(basename "$file" | sed 's/\.[^.]*$//')
    matched=false

    for key in "${!file_groups[@]}"; do
        if [[ "$base_name" == *"$key"* || "$key" == *"$base_name"* ]]; then
            file_groups["$key"]+="$file\n"
            matched=true
            break
        fi
    done

    if [ "$matched" = false ]; then
        file_groups["$base_name"]="$file\n"
    fi
done <<< "$files"

# Process groups with more than one file
found_similar=false
for base_name in "${!file_groups[@]}"; do
    group_files=$(echo -e "${file_groups[$base_name]}")
    file_count=$(echo "$group_files" | wc -l)

    if (( file_count > 1 )); then
        found_similar=true
        echo "Similar files found for base name: $base_name"

        # Display group files with numeric options
        count=1
        declare -a file_list
        file_list=() # Reset file_list for each group
        while IFS= read -r file; do
            echo "[$count] $file"
            file_list+=("$file")
            ((count++))
        done <<< "$group_files"

        echo ""
        echo "Enter the numbers of the files you want to delete (separate by space), or press Enter to keep all:" >&2
        read -rp "Your choice: " delete_choices

        if [ -n "$delete_choices" ]; then
            for choice in $delete_choices; do
                if [[ $choice =~ ^[0-9]+$ ]] && ((choice > 0 && choice <= ${#file_list[@]})); then
                    file_to_delete="${file_list[$((choice - 1))]}"
                    echo "Attempting to delete: \"$file_to_delete\""
                    rm -f "$file_to_delete" 2>/dev/null
                    if [ $? -eq 0 ]; then
                        echo "Deleted: \"$file_to_delete\""
                    else
                        echo "Failed to delete: \"$file_to_delete\""
                    fi
                else
                    echo "Invalid selection: $choice"
                fi
            done
        else
            echo "Keeping all files in this group."
        fi
        echo ""
    fi
done

if ! $found_similar; then
    echo "No similar file names found in the directory."
fi

echo "No more duplicates remain!" 