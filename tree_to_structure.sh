#!/bin/bash

create_structure() {
    local line="$1"
    local base_path="$2"
    
    # Remove any ANSI color codes and leading/trailing whitespace
    line=$(echo "$line" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,3})*)?[mGK]//g" | sed 's/^[ \t]*//;s/[ \t]*$//')
    
    # Remove leading tree characters
    local clean_line=$(echo "$line" | sed -E 's/^[ │├└─]*//g')
    
    # Construct the full path
    local full_path="${base_path}/${clean_line}"
    
    if [[ "$clean_line" == *"/" ]]; then
        # It's a directory
        mkdir -p "$full_path"
        echo "Created directory: $full_path"
    elif [[ -n "$clean_line" ]]; then
        # It's a file
        mkdir -p "$(dirname "$full_path")"
        touch "$full_path"
        echo "Created file: $full_path"
    fi
}

process_structure() {
    local input_file="$1"
    local base_path="$2"
    local current_path="$base_path"
    local prev_indent=0
    
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ -n "$line" ]]; then
            # Calculate indent level
            indent=$(echo "$line" | sed -E 's/[^ ].*//' | wc -c)
            
            # Remove leading/trailing whitespace
            clean_line=$(echo "$line" | sed 's/^[ \t]*//;s/[ \t]*$//')
            
            # Remove tree characters
            item=$(echo "$clean_line" | sed -E 's/^[ │├└─]*//g')
            
            if [ $indent -le $prev_indent ]; then
                # Go up in the directory structure
                levels_up=$(( (prev_indent - indent) / 2 + 1 ))
                for ((i=0; i<levels_up; i++)); do
                    current_path=$(dirname "$current_path")
                done
            fi
            
            if [[ "$item" == *"/" ]]; then
                # It's a directory
                current_path="${current_path}/${item}"
                mkdir -p "$current_path"
                echo "Created directory: $current_path"
            else
                # It's a file
                file_path="${current_path}/${item}"
                mkdir -p "$(dirname "$file_path")"
                touch "$file_path"
                echo "Created file: $file_path"
            fi
            
            prev_indent=$indent
        fi
    done < "$input_file"
}

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File not found: $input_file"
    exit 1
fi

# Create a temporary directory for the structure
temp_dir=$(mktemp -d)
echo "Creating structure in temporary directory: $temp_dir"

# Process the structure
process_structure "$input_file" "$temp_dir"

echo "File structure created successfully in $temp_dir"
echo "You can move the contents to your desired location using:"
echo "mv $temp_dir/* /path/to/your/destination/"