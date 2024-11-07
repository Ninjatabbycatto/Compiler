%{
//chekc this out: https://www.reddit.com/r/Compilers/comments/wok89g/resources_to_understand_code_generation_from_ast/?rdt=32827

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "parser.tab.h"

//#include "symbols.c"
void yyerror(const char *s);
int type_of(const char *name);


extern FILE *yyin;
extern FILE *yyout;
extern int yylex();
extern int lineno;
void yyerror(const char *s);

void generateAssembly(const char *code) {
    printf("%s\n", code);
}
FILE *fptr;

%}

%union {

	char char_val;
	int int_val;
	char *str_val;

}

%token <str_val> CCOUT CCIN 
%token <str_val> ADDOP MULTOP INCR DIVOP RELOP EQUOP
%token <str_val> ASSIGN COMMA DOT SEMI RBRACE LBRACE RBRACK LBRACK RPAREN LPAREN LEFTSHIFT RIGHTSHIFT
%token <str_val> VARIABLE
%token <int_val> ICONST
%token <char_val> CCONST
%token <str_val> STRING

%left ADDOP
%right ASSIGN
%left COMMA

%type <int_val> expression
%type <str_val> term
%type <str_val> program statements statement assignment cin_statement cout_statement

%start program

%%
program: 
       statements			{						}
;



statements: statements statement	{						}
	  | statement			{						}
;

statement: assignment SEMI		{ 				}
	 | cin_statement SEMI		{ 						}
	 | cout_statement SEMI		{						}
;

assignment: VARIABLE ASSIGN expression  {    }
	  | VARIABLE ASSIGN STRING	{			}
;

cin_statement: CCIN RIGHTSHIFT VARIABLE {						}
;

cout_statement: CCOUT LEFTSHIFT expression {						}
	      | CCOUT LEFTSHIFT VARIABLE {						}
	      | CCOUT LEFTSHIFT STRING	 {						}
;

expression: expression ADDOP term	{					    	}
	  | term			{						}
;

term: VARIABLE				{ printf("Variable: %s\n", $1);}
    | ICONST				{	 			}
;


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

	    	    // Specify the filename
	    const char *filename = "MachLan.asm";
    
	    // Open the file in write mode ("w")
	    fptr = fopen(filename, "w");
	
	    // Check if the file was opened successfully
	    if (fptr == NULL) {
		printf("Error opening file!\n");
		exit(1);
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


