#!/bin/bash

# reverse.sh - Reverses a file line by line
# Usage: ./reverse.sh <input_file> <output_file>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_file> <output_file>"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="$2"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found!"
    exit 1
fi

# Reverse the file line by line using tac (reverse of cat)
# If tac is not available (macOS), use tail -r or perl
if command -v tac &> /dev/null; then
    tac "$INPUT_FILE" > "$OUTPUT_FILE"
elif command -v tail &> /dev/null && tail -r /dev/null &> /dev/null 2>&1; then
    tail -r "$INPUT_FILE" > "$OUTPUT_FILE"
else
    # Fallback for systems without tac or tail -r (like macOS)
    awk '{a[i++]=$0} END {for (j=i-1; j>=0;) print a[j--] }' "$INPUT_FILE" > "$OUTPUT_FILE"
fi

echo "Reversed: $INPUT_FILE -> $OUTPUT_FILE"
