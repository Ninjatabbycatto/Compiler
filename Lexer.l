%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "ast.h"
#include "parser.tab.h"

bool is_keyword(const char *str);

const char *keywords[] = {
    "if",
    "else",
    "while",
    "for",
    "do",
    "cin",
    "cout",

};

int lineno = 1;
void ret_print(char *token_type);
void yyerror();

%}

word [a-zA-Z]
digit [0-9]
wodig {word}|{digit}
print		[ -~]

ID {word}+{digit}*
ICONST "0"|[0-9]{digit}*
FCONST "0"|{digit}*"."{digit}+
CCONST (\'{print}\')|(\'\\[nftrbv]\')
STRING \"{print}*\"

%%
"cin"                           { return CCIN;                                    }
"cout"                          { return CCOUT;                                   }
"<<"                            { return LEFTSHIFT; } // Token for output stream operator
">>"                            { return RIGHTSHIFT; } // Token for input stream operator

"+"|"-"                         { return ADDOP;                                   }
"*"                             { return MULTOP;                                  }
"/"                             { return DIVOP;                                   }
"++"|"--"                       { return INCR;                                    }
"=="|"!="                       { return EQUOP;                                   }
">"|"<"|">="|"<="               { return RELOP;                                   }

"("			        { return LPAREN; }
")" 			        { return RPAREN; }
"]"			        { return RBRACK; }
"["			        { return LBRACK; }
"{"			        { return LBRACE; }
"}"			        { return RBRACE; }
";"			        { return SEMI; }
"."			        { return DOT; }
","			        { return COMMA; }
"="			        { return ASSIGN; }


{ID}                            { return VARIABLE;                               }

{ICONST} 	        	{ yylval.int_val   = atoi(yytext); return ICONST; }
{FCONST} 		        { yylval.double_val = atof(yytext); return FCONST; }
{CCONST} 		        { yylval.char_val  = yytext[0];    return CCONST; }
{STRING} 		        { yylval.str_val = malloc(yyleng * sizeof(char));
				  strcpy(yylval.str_val, yytext);  return STRING; }


"\n"			        { lineno += 1; }
[ \t\r\f]+		        {           }

.			        { yyerror("Unrecognized character"); }

%%



int yywrap() {
    return 1;

}






/*
int main(int argc, char **argv) {
    yylex();
    return 0;

}
*/
