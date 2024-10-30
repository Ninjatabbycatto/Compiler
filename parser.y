%{

#include "semantics.c"
#include "symtab.c"
#include "ast.h"
#include "ast.c"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
	list_t* symtab_item;
	AST_Node* node;

}


%token <int_val> NUMBER
%token NEWLINE
%token <symtab_item> VARIABLE
%token <int_val> STRING
%token <int_val> LPAREN
%token <int_val> RPAREN
%token <int_val> LBRACK
%token <int_val> RBRACK
%token <int_val> EQ
%token <int_val> COMMA
%token <double_val> FLOAT
%token <int_val> OPERATOR
%token <int_val> KEYWORD
%token <int_val> CIN
%token <int_val> COUT
%token <int_val> SEMICOLON
%token <int_val> QUOMARK;


%type <int_val> exp
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


AST_Node *new_ast_decl_node(int data_type, list_t **names, int names_count){
    AST_Node_Decl *v = malloc(sizeof(AST_Node_Decl));
    v->type = DECL_NODE;
    v->data_type = data_type;
    v->names = names;
    //v->names_count = names_count;

    return (struct AST_Node *) v;
}

AST_NODE *new_ast_const_node(int const_type, Value val) {
    AST_Node_Const *v = malloc(sizeof(AST_Node_Const));
    v->type = CONST_NODE;
    v->data_type = const_type;
    v->val = val;
    return (struct AST_Node *) v;
}
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


