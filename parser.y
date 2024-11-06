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

%}

%union {
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
%token <symtab_item> VARIABLE
%token <int_val> ICONST
%token <double_val> FCONST
%token <char_val> CCONST
%token <str_val> STRING


%left LBRACK RBRACK LPAREN RPAREN
%left MULTOP DIVOP
%left ADDOP
%left RELOP
%left EQUOP
%right ASSIGN
%left COMMA


%type <node> program statements statement assignment cin_statement cout_statement expression term

%start program

%%
program: 
       statements			{ main_func_tree = $1;	ast_traversal($1);	}
;

statements: statements statement	{ AST_Node_Statements *temp = (AST_Node_Statements*) $1;
					  $$ = new_statements_node(temp->statements, temp->statement_count $2);
					}
	  | statement			{ $$ = new_statements_node(NULL, 0, $1);	}
;

statement: assignment SEMI		{ $$ = $1;			    		}
	 | cin_statement SEMI		{ 						}
	 | cout_statement SEMI		{						}
;

assignment: VARIABLE ASSIGN expression  { 				}
	  | VARIABLE ASSIGN STRING	{						}
;

cin_statement: CCIN RIGHTSHIFT VARIABLE {						}
;

cout_statement: CCOUT LEFTSHIFT expression {						}
	      | CCOUT LEFTSHIFT VARIABLE {						}
	      | CCOUT LEFTSHIFT STRING	 {						}
;

expression: expression ADDOP term	{ $$ = new_ast_arithm_node($2.ival, $1, $3);	}
	  | expression MULTOP term	{ $$ = new_ast_arithm_node(MUL, $1, $3);	}
	  | term			{ $$ = $1;					}
;

term: VARIABLE				{ 			    	}
    | ICONST				{   						}
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


