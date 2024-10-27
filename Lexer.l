%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
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

%}

DIGIT [0-9]
ID [a-zA-Z][a-zA-Z0-9]*
STRING \"([^\\\"]|\\.)*\"
FLOAT {DIGIT}+"."{DIGIT}*([eE][+-]?{DIGIT}*)?


%%


"cin"                           { return CIN;                                    }
"cout"                          { return COUT;                                   }
{DIGIT}+                        { yylval.ival = atoi(yytext); return (NUMBER);   }
{STRING}                        { size_t len = strlen(yytext) - 2; 
                                    strncpy(yylval.sval, yytext + 1, len);
                                    yylval.sval[len] = '\0';
                                    return STRING;}

";"                             { return SEMICOLON;                              }
{FLOAT}                         { yylval.fval = atof(yytext);  return FLOAT;     }
"+"                             { return OPERATOR;                               }
"-"                             { return OPERATOR;                               }
"*"                             { return OPERATOR;                               }
"/"                             { return OPERATOR;                               }
"="                             { return EQ;                                     }
","                             { return COMMA;                                  }
"("                             { return LPAREN;                                 }
")"                             { return RPAREN;                                 }
"{"                             { return LBRACK;                                 }
"}"                             { return RBRACK;                                 }
"<<"                            { return LEFTSHIFT; } // Token for output stream operator
">>"                            { return RIGHTSHIFT; } // Token for input stream operator
{ID}+                           { return VARIABLE;                               }
\n                              { return NEWLINE;                                }
[ \t]+                          { /*ignore whitespaces*/                         }
.                               { printf("Unexpected character: %s\n", yytext);  }

%%


bool is_keyword(const char *str) {
    for (int i = 0; i < sizeof(keywords) / sizeof(keywords[0]); i++) {
        if (strcmp(str, keywords[i]) == 0) {
            return true;
        }
    }
    return false;
}




/*
int main(int argc, char **argv) {
    yylex();
    return 0;

}
*/
