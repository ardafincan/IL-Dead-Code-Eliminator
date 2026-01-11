# Makefile for Dead Code Elimination Project

# Compiler and flags
LEX = flex
YACC = yacc
CC = g++
CFLAGS = -std=c++11 -Wall

# Source files
LEX_SOURCE = lexRules.l
YACC_SOURCE = yaccRules.y

# Generated files
LEX_OUTPUT = lex.yy.c
YACC_OUTPUT = y.tab.c
YACC_HEADER = y.tab.h

# Executable
TARGET = dce

# Default target
all: $(TARGET)

# Compile the executable
$(TARGET): $(LEX_OUTPUT) $(YACC_OUTPUT)
	@echo "Compiling $(TARGET)..."
	$(CC) $(CFLAGS) -o $(TARGET) $(LEX_OUTPUT) $(YACC_OUTPUT)
	@echo "Build successful! Executable: $(TARGET)"

# Generate lex output
$(LEX_OUTPUT): $(LEX_SOURCE)
	@echo "Generating lexer from $(LEX_SOURCE)..."
	$(LEX) $(LEX_SOURCE)

# Generate yacc output
$(YACC_OUTPUT): $(YACC_SOURCE)
	@echo "Generating parser from $(YACC_SOURCE)..."
	$(YACC) -d $(YACC_SOURCE)

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	rm -f $(LEX_OUTPUT) $(YACC_OUTPUT) $(YACC_HEADER) $(TARGET)
	rm -f *.temp *.reversed
	@echo "Clean complete!"

# Clean everything including output files
cleanall: clean
	@echo "Cleaning all output files..."
	rm -f *_deadCodeEliminated.txt
	@echo "All clean!"

# Rebuild from scratch
rebuild: clean all

# Help message
help:
	@echo "Available targets:"
	@echo "  make          - Build the project (default)"
	@echo "  make all      - Build the project"
	@echo "  make clean    - Remove generated files"
	@echo "  make cleanall - Remove all generated and output files"
	@echo "  make rebuild  - Clean and rebuild from scratch"
	@echo "  make help     - Show this help message"

.PHONY: all clean cleanall rebuild help
