%{
//chekc this out: https://www.reddit.com/r/Compilers/comments/wok89g/resources_to_understand_code_generation_from_ast/?rdt=32827

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"
#include "ast.c"
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

typedef struct {
    char *name;        // Name of the variable
    int int_value;     // Integer value (you can expand this for other types)
} Symbol;

#define MAX_VARIABLES 100

Symbol symbol_table[MAX_VARIABLES]; // Example symbol table
int symbol_count = 0;

// Function to add a variable to the symbol table
void add_variable(const char *name, int value) {
    if (symbol_count >= MAX_VARIABLES) {
        fprintf(stderr, "Error: Symbol table full\n");
        exit(EXIT_FAILURE);
    }
    symbol_table[symbol_count].name = strdup(name); // Duplicate string for storage
    symbol_table[symbol_count].int_value = value;
    symbol_count++;
}

// Function to get variable value from the symbol table
int get_variable_value(const char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return symbol_table[i].int_value; // Return the integer value
        }
    }
    fprintf(stderr, "Error: Variable '%s' not found\n", name);
    exit(EXIT_FAILURE);
}

%}

%union {
	Value val;
	char char_val;
	int int_val;
	double double_val;
	char *str_val;
	char* symtab_item;
	AST_Node* node;

}

%token <int_val> CCOUT CCIN 
%token <int_val> ADDOP MULTOP INCR DIVOP RELOP EQUOP
%token <int_val> ASSIGN COMMA DOT SEMI RBRACE LBRACE RBRACK LBRACK RPAREN LPAREN LEFTSHIFT RIGHTSHIFT
%token <str_val> VARIABLE
%token <int_val> ICONST
%token <double_val> FCONST
%token <char_val> CCONST
%token <str_val> STRING
%token <val> REFER

%left LBRACK RBRACK LPAREN RPAREN
%left MULTOP DIVOP
%left ADDOP
%left RELOP
%left EQUOP
%right ASSIGN
%left COMMA

%type <int_val> expression
%type <node> program statements statement assignment cin_statement cout_statement  term

%start program

%%
program: 
       statements			{						}
;



statements: statements statement	{						}
	  | statement			{						}
;

statement: assignment SEMI		{						}
	 | cin_statement SEMI		{ 						}
	 | cout_statement SEMI		{						}
;

assignment: VARIABLE ASSIGN expression  { printf(" %d %d %d ", $1, $2, $3);		}
	  | VARIABLE ASSIGN STRING	{						}
;

cin_statement: CCIN RIGHTSHIFT VARIABLE {						}
;

cout_statement: CCOUT LEFTSHIFT expression {						}
	      | CCOUT LEFTSHIFT VARIABLE {						}
	      | CCOUT LEFTSHIFT STRING	 {						}
;

expression: expression ADDOP term	{					    	}
	  | expression MULTOP term	{						}
	  | term			{						}
;

term: VARIABLE				{   
					    }
    | ICONST				{						}
    | FCONST				{						}
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


