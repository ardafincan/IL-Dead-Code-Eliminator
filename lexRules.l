digit [0-9]
letter [A-Za-z]
%{
#include <iostream>
#include <cstdlib>
#include "y.tab.h"
%}
%%

{letter}({letter}|{digit})*	{
		yylval.str = strdup(yytext);
		return VARIABLE;
		}

-?{digit}+		{
		yylval.str = strdup(yytext);
		return CONSTANT;
		}

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

%%

int yywrap() {
	return 1;
}
