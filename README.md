# Dead Code Elimination - CSE 351 Term Project

A compiler optimization tool that implements dead code elimination for an intermediate language (IL) using Lex and Yacc.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [How It Works](#how-it-works)
- [Examples](#examples)
- [Testing](#testing)
- [Author](#author)

---

## 🎯 Overview

This project implements a **dead code elimination algorithm** that removes unused assignment statements from intermediate language code. The algorithm uses **live variable analysis** to determine which statements affect the final program output.

**Algorithm Steps:**
1. Reverse the input IL code
2. Apply dead code elimination using backward dataflow analysis
3. Reverse the output to restore original order

---

## ✨ Features

- ✅ Parses intermediate language (IL) with assignment statements
- ✅ Identifies and eliminates dead code assignments
- ✅ Supports arithmetic operations: `+`, `-`, `*`, `/`, `^`
- ✅ Handles signed integer constants (positive and negative)
- ✅ Implements live variable analysis
- ✅ Automated build system (Makefile)
- ✅ Complete workflow script (reversal + elimination + output)

---

## 🛠️ Requirements

- **Flex** (Fast Lexical Analyzer)
- **Yacc/Bison** (Parser Generator)
- **GCC/G++** (C++ Compiler with C++11 support)
- **Bash** (for shell scripts)
- **macOS/Linux** (Unix-like environment)

### Check if installed:

```bash
flex --version
yacc --version  # or: bison --version
g++ --version
```

---

## 📦 Installation

### Clone or Download

```bash
cd CSE351-TP
```

### Build the Project

```bash
make
```

This will:
1. Generate lexer from `lexRules.l`
2. Generate parser from `yaccRules.y`
3. Compile to create `dce` executable

---

## 🚀 Usage

### Quick Start

```bash
./run.sh <input_file.il>
```

**Example:**
```bash
./run.sh test1.il
```

**Output:**
- Result saved to: `test1_deadCodeEliminated.txt`
- Optimized code displayed on screen

---

### Manual Execution (Step by Step)

```bash
# Step 1: Reverse the input
./reverse.sh input.il input.reversed

# Step 2: Run dead code elimination
./dce input.reversed > output.temp

# Step 3: Reverse output back
./reverse.sh output.temp output.txt

# Step 4: View result
cat output.txt
```

---

### Build Commands

```bash
make              # Build the project
make clean        # Remove generated files
make rebuild      # Clean and rebuild
make cleanall     # Remove all generated and output files
make help         # Show available commands
```

---

## 📁 Project Structure

```
CSE351-TP/
├── lexRules.l                      # Lexical analyzer (tokenizer)
├── yaccRules.y                     # Parser and dead code elimination logic
├── Makefile                        # Build automation
├── reverse.sh                      # File reversal script
├── run.sh                          # Main workflow script
├── README.md                       # This file
├── projectReport.md                # Detailed project report
├── EXPLANATION.md                  # Algorithm explanation
├── TESTING_GUIDE.md                # Testing instructions
│
├── test1.il                        # Test case 1 (PDF example)
├── test2.il                        # Test case 2 (simple chain)
├── test3.il                        # Test case 3 (all dead)
├── test4.il                        # Test case 4 (all live)
├── test5.il                        # Test case 5 (self-reference)
│
├── expected_test1.txt              # Expected output for test1
├── expected_test2.txt              # Expected output for test2
└── ...                             # More test files
```

---

## 🔍 How It Works

### Intermediate Language Syntax

```
a = 5;              // Simple assignment
b = a + 3;          // Binary operation
c = d;              // Variable assignment
{ r, s }            // Live variables declaration (last line)
```

**Rules:**
- Maximum 2 operands per statement
- Operators: `+`, `-`, `*`, `/`, `^`
- Last line lists final live variables (1-5 variables)

---

### Dead Code Elimination Algorithm

**Step 1: Initialize**
- Parse `{ r, s }` → Initialize live variable set

**Step 2: Process (Reverse Order)**

For each statement `dest = src1 op src2`:

```
IF dest is in LiveSet:
    ✅ Statement is LIVE
    - Output the statement
    - Add src1 and src2 to LiveSet (if variables)
    - Remove dest from LiveSet
ELSE:
    ❌ Statement is DEAD
    - Skip (don't output)
```

**Step 3: Output**
- Reverse the optimized code back to original order

---

### Data Structures

| Structure | Type | Purpose |
|-----------|------|---------|
| `liveVariables` | `set<string>` | Tracks currently live variables |
| `tempVars` | `vector<string>` | Temporary storage for expression operands |
| `currentOp` | `string` | Current operator for output formatting |

---

## 📝 Examples

### Example 1: Basic Dead Code Elimination

**Input (`example.il`):**
```
a = 2 + 2;
b = 2 ^ 9;    // DEAD - b is never used
c = d ^ 3;    // DEAD - c is never used
e = 5;
p = 0;
r = e * p;
s = a;
{ r, s }
```

**Output (`example_deadCodeEliminated.txt`):**
```
a = 2 + 2;
e = 5;
p = 0;
r = e * p;
s = a;
```

**Result:** 2 dead statements eliminated (b, c removed)

---

### Example 2: All Live

**Input:**
```
a = 5;
b = a;
c = b;
{ a, b, c }
```

**Output:**
```
a = 5;
b = a;
c = b;
```

**Result:** 0 statements eliminated (all variables are live)

---

### Example 3: All Dead

**Input:**
```
x = 10;
y = 20;
z = 30;
{ a }
```

**Output:**
```
(empty - all statements eliminated)
```

**Result:** 3 statements eliminated (x, y, z never contribute to 'a')

---

## 🧪 Testing

### Run All Tests

```bash
./run.sh test1.il
./run.sh test2.il
./run.sh test3.il
./run.sh test4.il
./run.sh test5.il
```

### Verify Results

```bash
diff test1_deadCodeEliminated.txt expected_test1.txt
```

If no output → Test passed! ✅

### Test All at Once

```bash
for i in {1..5}; do
    echo "Testing test$i.il..."
    ./run.sh test$i.il
    diff test${i}_deadCodeEliminated.txt expected_test${i}.txt && echo "✓ PASS" || echo "✗ FAIL"
done
```

---

## 📚 Documentation

- **`README.md`** (this file) - Quick start and usage guide
- **`projectReport.md`** - Detailed technical report
- **`EXPLANATION.md`** - Algorithm explanation and walkthrough
- **`TESTING_GUIDE.md`** - Comprehensive testing instructions

---

## 🐛 Troubleshooting

### Build Errors

```bash
make clean
make
```

### Permission Denied (Scripts)

```bash
chmod +x reverse.sh run.sh
```

### Library Not Found (-lfl)

Already handled in Makefile - no action needed on macOS.

### Unexpected Output

Check that:
- Input file has spaces around operators: `a = 5 + 3;` ✅ not `a=5+3;` ❌
- Last line is properly formatted: `{ r, s }`
- All statements end with semicolon

---

## 🎓 Course Information

**Course:** CSE 351 - Programming Languages
**Project:** Dead Code Elimination using Lex and Yacc
**Deadline:** January 12, 2026

---

## 👤 Author

**Ali Arda Fincan**
Student ID: 20230702099
January 2026

---

## 📄 License

This project is for educational purposes as part of CSE 351 coursework.

---

## 🙏 Acknowledgments

- Project specification provided by CSE 351 course instructors
- Algorithm based on compiler optimization techniques
- Implementation uses Flex and Yacc/Bison tools

---

**Happy Code Eliminating! 🚀**
