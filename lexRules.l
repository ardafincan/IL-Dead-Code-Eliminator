digit [0-9]
letter [A-Za-z]
%{
#include <iostream>
#include <cstdlib>
extern char* yylval;
%}
%%

{letter}({letter}|{digit})*	{
		yylval = strdup(yytext);
		return VARIABLE;
		}

-?{digit}+		{
		yylval = strdup(yytext);
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
