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

DIGIT [0-9]
ID [a-zA-Z][a-zA-Z0-9]*
STRING \"([^\\\"]|\\.)*\"
FLOAT {DIGIT}+"."{DIGIT}*([eE][+-]?{DIGIT}*)?


%%


"cin"                           { return CCIN;                                    }
"cout"                          { return CCOUT;                                   }
{DIGIT}+                        { yylval.int_val = atoi(yytext); return (NUMBER);   }
{STRING}                        { size_t len = strlen(yytext) - 2; 
                                    strncpy(yylval.str_val, yytext + 1, len);
                                    yylval.str_val[len] = '\0';
                                    return STRING;}

";"                             { return SEMICOLON;                              }
{FLOAT}                         { yylval.double_val = atof(yytext);  return FLOAT;     }
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
\n                              { lineno += 1; return NEWLINE;                                }
[ \t]+                          { /*ignore whitespaces*/                         }
.                               { printf("Unexpected character: %s\n", yytext);  }

%%

int yywrap() {
    return 1;

}


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
