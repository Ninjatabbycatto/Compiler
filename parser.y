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

char *decl;
char *states;

void appendToDecs(const char *newDecl) {
    size_t currentLength = decl ? strlen(decl) : 0; // Check if decl is initialized
    size_t newDeclLength = strlen(newDecl);

    decl = realloc(decl, currentLength + newDeclLength + 1); // +1 for null terminator
    if (decl == NULL) {
        fprintf(stderr, "Memory reallocation failed\n");
        exit(EXIT_FAILURE);
    }

    if (currentLength > 0) {
        strcpy(decl + currentLength, newDecl); // Append new declaration
    } else {
        strcpy(decl, newDecl); // First time initializing decl
    }
}


void appendToassgn(const char *newDecl) {
    size_t currentLength = decl ? strlen(states) : 0; // Check if decl is initialized
    size_t newDeclLength = strlen(newDecl);

    states= realloc(states, currentLength + newDeclLength + 1); // +1 for null terminator
    if (states == NULL) {
        fprintf(stderr, "Memory reallocation failed\n");
        exit(EXIT_FAILURE);
    }

    if (currentLength > 0) {
        strcpy(states + currentLength, newDecl); // Append new declaration
    } else {
        strcpy(states, newDecl); // First time initializing decl
    }
}

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
%type <str_val> program statements statement assignment cin_statement cout_statement declarations

%start program

%%
program: 
       assignments			{
					    char buffer[256]; 
					    snprintf(buffer, sizeof(buffer), "   result db 0\n\nsection .bss\n	sum resb1\n\nsection .text\n    global _start\n\n");
					    appendToDecs(buffer); 
					    fprintf(fptr, "%s", decl);
					}
       statements			{   					}

;



statements: statements statement	{						}
	  | statement			{						}
;

assignments: assignments assignment 	{    					    	}	
	    | assignment SEMI	        {		    }

statement: cin_statement SEMI		{ 						}
	 | cout_statement SEMI		{						}
;

assignment: VARIABLE ASSIGN expression  {  char buffer[256]; 
					    snprintf(buffer, sizeof(buffer), "   %s db %d\n", $1, $3);
					    appendToDecs(buffer);   }
	  | VARIABLE ASSIGN STRING 	{   			}
;

cin_statement: CCIN RIGHTSHIFT VARIABLE {						}
;

cout_statement: CCOUT LEFTSHIFT expression {						}
	      | CCOUT LEFTSHIFT VARIABLE {						}
	      | CCOUT LEFTSHIFT STRING	 {						}
;

expression: expression ADDOP term	{					    	}
	    term ADDOP term		{						}
	  | term			{						}
;

term: VARIABLE				{ $$ = $1; }
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

	    decl = malloc(100);
	    if (decl== NULL) {
		fprintf(stderr, "Memory allocation failed\n");
		exit(EXIT_FAILURE);
	    }
	    strcpy(decl, "section .data\n");
	    states = malloc(100);
	    if (stats== NULL) {
		fprintf(stderr, "Memory allocation failed\n");
		exit(EXIT_FAILURE);
	    }
	    strcpy(states, "_start:\n");

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


