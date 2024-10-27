%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Symbol {
    char name[30];
    int type;
    struct Symbol *next;
} Symbol;

Symbol *symbol_table = NULL;


void add_symbol (const char *name, int type);
Symbol* lookup_sybol(const char *name);
void yyerror(const char *s);
int type_of(const char *name);


extern FILE *yyin;
extern int yylex();
void yyerror(const char *s);

%}



%union {
	int ival;
	double fval;
	char sval[30] ;
	char strval[100];
}


%token <ival> NUMBER
%token NEWLINE
%token <sval> VARIABLE
%token <sval> STRING
%token <sval> LPAREN
%token <sval> RPAREN
%token <sval> LBRACK
%token <sval> RBRACK
%token <sval> EQ
%token <sval> COMMA
%token <fval> FLOAT
%token <sval> OPERATOR
%token <sval> KEYWORD
%token <sval> CIN
%token <sval> COUT
%token <sval> SEMICOLON
%token <sval> QUOMARK;


%type <ival> exp
%right '='
%left '-' '+'
%left '*' '/'
%right RIGHTSHIFT
%right LEFTSHIFT
/*
%type <name> VARIABLE
%type <number> NUMBER
%union{
	char name [20];
	int number;
}
*/

%%
input:
     |input line
;


line: NEWLINE
    | exp SEMICOLON NEWLINE		{ printf ("\t%.10g\n", $1);			}
    | out SEMICOLON NEWLINE		{ printf("cout line\n");			} 
    | asgn SEMICOLON NEWLINE		{ printf("assignment line\n");			}
    | error NEWLINE			{ yyerror(" Error detected in input`");		}
;

exp: NUMBER				{
					  printf("Number: %d\n", $1);
					}
    | FLOAT				{ $$ = $1;
					  printf("Float: %f\n", $1); 
					}
    | exp OPERATOR exp			{ printf("expression operator expression\n");	}
    | LPAREN exp RPAREN			{printf("expression in a Parenthesis\n");	}
;

in:  CIN				
  | in RIGHTSHIFT			{printf("CIN Command\n");}


out:  COUT				{						}
   | out LEFTSHIFT			{printf("COUT Command\n");}
   | out VARIABLE			{						}
   | out exp				{						}
;

asgn: VARIABLE COMMA
    | VARIABLE EQ exp			{						}
    | VARIABLE EQ group			{						}
    | VARIABLE EQ VARIABLE		{						}
    | VARIABLE EQ STRING		{printf("STRING");				}

group: exp COMMA
     | group exp


%%

void yyerror(const char *s) {
	fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
	if (argc == 1) {
	    yyparse();

	}
	
	else if (argc == 2) {	
	    FILE *file = fopen(argv[1], "r");
	    if (!file) {
		perror("Failed to open file");
		return 1;
	    }
	    yyin = file;
	    yyparse();

	    fclose(file);
	    return 0;
	}
	else {
	    fprintf(stderr, "Usage: %s [filename]\n", argv[0]);
	    return 1;	
	}
	return 0;
}


