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

%union {
	char* str;
}

%token <str>	VARIABLE	CONSTANT
%token	EQL PLUS MINUS STAR DIV POW LCURL RCURL LPAREN RPAREN COMMA SEMCLN
%type <str> term

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

operator: PLUS {currentOp = "+";} | MINUS {currentOp = "-";} | STAR {currentOp = "*";} | DIV {currentOp = "/";} | POW {currentOp = "^";};

liveVars:	LCURL varList RCURL	{};
	
varList: VARIABLE	{liveVariables.insert($1);}
	   |
	   varList COMMA VARIABLE	{liveVariables.insert($3);};


%%

void yyerror(const char *s) {
  fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
	  fprintf(stderr, "Usage: %s <reversed_input_file>\n", argv[0]);
	  return 1;
  }

  yyin = fopen(argv[1], "r");
  if (!yyin) {
	  fprintf(stderr, "Cannot open file: %s\n", argv[1]);
	  return 1;
  }

  yyparse();

  fclose(yyin);
  return 0;
}
