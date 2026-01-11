# CSE351 Term Project Report
## Dead Code Elimination Using Lex and Yacc


I have successfully implemented the dead code elimination using lex and yacc. 
I have designed project as lex parsing tokens and sending them to yacc and yacc process them. Let’s take a detailed look. 

This one code block is from my lex file:

```c
    {letter}({letter}|{digit})*	{         	
        yylval.str = strdup(yytext);      	
        return VARIABLE;
		}
```
defining VARIABLE token as a single letter with optional letters or digits following 
using strdup here to copy the text as text (not pointer) and pass it to yacc

```c
    -?{digit}+		{                                 
            yylval.str = strdup(yytext);
            return CONSTANT;
            }
```
 defining CONSTANT token as some number of digits with optional leading minus (-)

```c
    "="	return EQL;                   
    "+"	return PLUS;
    "-"	return MINUS;
    "*"	return STAR;
    "/"	return DIV;
    "^"	return POW;
    "{"	return LCURL;
    "}"	return RCURL;
    "("	return LPAREN;
    ")"	return RPAREN;
    ","	return COMMA;
    ";"	return SEMCLN;
    [ \t\n]+	;
```
defining various tokens like arithmetic symbols or parenthesis 


The lex file is the simple part, it just parses text to tokens and pass them to yacc with their values.
To see the where the real job done we must look at the yacc file.



```c
%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#include <iostream>
	#include <string>
	#include <vector> 
	#include <set>
	using namespace std;

	extern int yylex();
	extern FILE* yyin;

	void yyerror(const char *s);
	set<string> liveVariables;
	vector<string> tempVars;
	string currentOp = "";
%}
```

This part is where we declare our imports and data structures. I have declared three additional thing on top of default yacc skeleton.

These additions are:
- **liveVariables**
- **tempVars**
- **currentOp**

Let me explain each one:

### liveVariables
liveVariables is a set of variables, it holds the latest live variables so dead code elimination can be done right.

### tempVars
tempVars is a vector of variables and constants, it is used to compare variables with liveVariables set and decide if the code will be eliminated or not. It is also used for the printing of undead code lines.

### currentOp
It is only used to keep the operator in the processed, in order to print that line right.

---

And let's continue to yacc rules:

```yacc
%%
program: liveVars statements;

statements: statement
		  | statements statement;

statement:	VARIABLE EQL expression SEMCLN {
				if (liveVariables.find($1) != liveVariables.end()) {
					liveVariables.erase($1);
					for (string var : tempVars) {
						if(isalpha(var[0])) liveVariables.insert(var);
					}
					cout<<$1<<" = ";
					if (tempVars.size() == 1) {
						cout<<tempVars[0];
					} else if (tempVars.size() == 2) {
						cout<<tempVars[0]<<" "<<currentOp<<" "<<tempVars[1];
					}
					cout<<";"<<endl;
				}
				tempVars.clear();
			};

expression:	term {
				if ($1 != NULL) tempVars.push_back($1);
				}
		  | term operator term {
				if ($1 != NULL)	tempVars.push_back($1);
				if ($3 != NULL) tempVars.push_back($3);
			};

term: VARIABLE {$$ = $1;} 
	|	CONSTANT {$$ = $1;};

operator: PLUS {currentOp = "+";} | MINUS {currentOp = "-";} | STAR {currentOp = "*";}
| DIV {currentOp = "/";} | POW {currentOp = "^";};

liveVars:	LCURL varList RCURL	{};
	
varList: VARIABLE	{liveVariables.insert($1);}
	   |
	   varList COMMA VARIABLE	{liveVariables.insert($3);};


%%
```

---

## Explanation of Grammar Rules

These rules are the main part of project. The top rule is **program** it is created form a **liveVars** and then a **statements**.

**liveVars** is the first line of the reversed code. It includes the initial (or actually final) live variables. We do start dead code elimination using that set. The the other important part of program is **statements** which is composed of one or multiple "statement"s.

Each statement includes a **VARIABLE** an **EQL** token and an **expression**, also finally a **SEMCLN**. The important ones here are **VARIABLE** and **expression**.

**VARIABLE** is the left hand side of an assignment, we look at that for if it is in `liveVariables`. If it is, then we say that code line is valid and it should be included in final code. We remove that variable from live list and append the ones from right hand side (expression).

**Expression** is the right hand side of an assignment, it includes some variables and constants. We use it in order to track new live variables and print the line properly. An expression is created from a `term` or two `term`s with an `operator`. We take the value from these terms and push the value to the `tempVars`.

Then in `statement` we look if LHS `VARIABLE` is in `liveVariables` list, if it is then the code line is valid and we remove this `VARIABLE` from `liveVariables`. After that we check if those `tempVars` in RHS are `VARIABLE`s or `CONSTANT`s, if they are variables we add them to `liveVars` set and then we print out the legitimate code line.

---

**Ali Arda Fincan - 20230702099**  
**January 2026**

