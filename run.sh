#!/bin/bash

# run.sh - Dead Code Elimination Workflow
# Usage: ./run.sh <input_file.il>

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

if [ $# -ne 1 ]; then
    echo -e "${RED}Usage: $0 <input_file.il>${NC}"
    exit 1
fi

INPUT_FILE="$1"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo -e "${RED}Error: Input file '$INPUT_FILE' not found!${NC}"
    exit 1
fi

# Extract filename without extension
BASENAME=$(basename "$INPUT_FILE" .il)
DIRNAME=$(dirname "$INPUT_FILE")

# Define file names
REVERSED_FILE="${BASENAME}.reversed"
OUTPUT_TEMP="${BASENAME}.temp"
FINAL_OUTPUT="${DIRNAME}/${BASENAME}_deadCodeEliminated.txt"

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}Dead Code Elimination - Starting${NC}"
echo -e "${BLUE}=====================================${NC}"
echo -e "Input file: ${GREEN}$INPUT_FILE${NC}"
echo ""

# Step 0: Make sure reverse.sh is executable
chmod +x reverse.sh

# Step 1: Build the project if needed
if [ ! -f "./dce" ]; then
    echo -e "${YELLOW}[Step 0] Executable not found. Building project...${NC}"
    make
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Build failed!${NC}"
        exit 1
    fi
    echo ""
fi

# Step 1: Reverse the input file
echo -e "${YELLOW}[Step 1] Reversing input file...${NC}"
./reverse.sh "$INPUT_FILE" "$REVERSED_FILE"
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to reverse input file!${NC}"
    exit 1
fi
echo ""

# Step 2: Run dead code elimination on reversed file
echo -e "${YELLOW}[Step 2] Applying dead code elimination...${NC}"
./dce "$REVERSED_FILE" > "$OUTPUT_TEMP"
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Dead code elimination failed!${NC}"
    rm -f "$REVERSED_FILE" "$OUTPUT_TEMP"
    exit 1
fi
echo ""

# Step 3: Reverse the output to restore original order
echo -e "${YELLOW}[Step 3] Reversing output to restore order...${NC}"
./reverse.sh "$OUTPUT_TEMP" "$FINAL_OUTPUT"
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to reverse output file!${NC}"
    rm -f "$REVERSED_FILE" "$OUTPUT_TEMP"
    exit 1
fi
echo ""

# Clean up temporary files
echo -e "${YELLOW}[Step 4] Cleaning up temporary files...${NC}"
rm -f "$REVERSED_FILE" "$OUTPUT_TEMP"
echo ""

# Success message
echo -e "${BLUE}=====================================${NC}"
echo -e "${GREEN}✓ Dead Code Elimination Complete!${NC}"
echo -e "${BLUE}=====================================${NC}"
echo -e "Output saved to: ${GREEN}$FINAL_OUTPUT${NC}"
echo ""

# Show the optimized code
echo -e "${BLUE}Optimized code:${NC}"
echo -e "${BLUE}-------------------------------------${NC}"
cat "$FINAL_OUTPUT"
echo -e "${BLUE}-------------------------------------${NC}"
