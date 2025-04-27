#!/bin/bash

# Simple help message
if [[ "$1" == "--help" ]]; then
    echo "Usage: $0 [-n] [-v] search_string filename"
    exit 0
fi

# Handle options
show_line_number=false
invert_match=false

while [[ "$1" == -* ]]; do
    case "$1" in
        -n) show_line_number=true ;;
        -v) invert_match=true ;;
        -vn|-nv)
            show_line_number=true
            invert_match=true
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

# Now $1 is search string, $2 is filename
search_string=$1
filename=$2

# Check arguments
if [[ -z "$search_string" || -z "$filename" ]]; then
    echo "Error: Missing search string or filename."
    echo "Usage: $0 [-n] [-v] search_string filename"
    exit 1
fi

# Check if file exists
if [[ ! -f "$filename" ]]; then
    echo "Error: File '$filename' not found."
    exit 1
fi

# Read file line-by-line
line_number=0
while IFS= read -r line; do
    ((line_number++))
    echo "$line" | grep -iq "$search_string"
    match=$?

    if [[ $match -eq 0 && $invert_match == false ]]; then
        [[ $show_line_number == true ]] && echo "${line_number}:$line" || echo "$line"
    elif [[ $match -ne 0 && $invert_match == true ]]; then
        [[ $show_line_number == true ]] && echo "${line_number}:$line" || echo "$line"
    fi
done < "$filename"
