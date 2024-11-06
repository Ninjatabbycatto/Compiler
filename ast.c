#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

AST_Node *new_ast_node(Node_Type type, AST_Node *left, AST_Node *right) {
	AST_Node *v = malloc (sizeof (AST_Node));
	v->type = type;
	v->left = left;
	v->right = right;

	return v;
}


AST_Node *new_ast_decl_node(int data_type, char **names){
	AST_Node_Decl *v = malloc (sizeof (AST_Node_Decl));
	v->type = DECL_NODE;
	v->data_type = data_type;
	v->names = names;
	return (struct AST_Node *) v;
}

AST_Node *new_ast_const_node(int const_type, Value val){
	
	AST_Node_Const *v = malloc (sizeof (AST_Node_Const));
	v->type = CONST_NODE;
	v->const_type = const_type;
	v->val = val;
	return (struct AST_Node *) v;
}



AST_Node *new_statements_node(AST_Node **statements, int statement_count, AST_Node *statement){
	// allocate memory
	AST_Node_Statements *v = malloc (sizeof (AST_Node_Statements));
	
	// set node type
	v->type = STATEMENTS;
	
	// first statement
	if(statements == NULL){
		statements = (AST_Node**) malloc (sizeof (AST_Node*));
		statements[0] = statement;
		statement_count = 1;
	}
	// add new statement
	else{
		statements = (AST_Node**) realloc (statements, (statement_count + 1) * sizeof (AST_Node*));
		statements[statement_count] = statement;
		statement_count++;
	}
	
	// set entries
	v->statements = statements;
	v->statement_count = statement_count;
	
	// return type-casted result
	return (struct AST_Node *) v;
}


AST_Node *new_ast_assign_node(char *entry, AST_Node *assign_val) {
	AST_Node_Assign *v = malloc (sizeof(AST_Node_Assign));

	v->type = ASSIGN_NODE;
	v->entry = entry;
	v->assign_val = assign_val;

	return (struct AST_Node *) v;

}

AST_Node *new_ast_incr_node(char *entry, int incr_type, int pf_type) {
	
	AST_Node_Incr *v = malloc (sizeof(AST_Node_Incr));
	v->type = INCR_NODE;
	v->entry = entry;
	v->incr_type = incr_type;
	v->pf_type = pf_type;

	return (struct AST_Node *) v;
}


AST_Node *new_ast_ref_node(char *entry, int ref){
	// allocate memory
	AST_Node_Ref *v = malloc (sizeof (AST_Node_Ref));
	
	// set entries
	v->type = REF_NODE;
	v->entry = entry;
	v->ref = ref;
	
	// return type-casted result
	return (struct AST_Node *) v;	
}



AST_Node *new_ast_arithm_node (enum Arithm_op op, AST_Node *left, AST_Node * right) {
	AST_Node_Arithm *v = malloc(sizeof(AST_Node_Arithm));

	v->type = ARITHM_NODE;
	v->op = op;
	v->left = left;
	v->right = right;

	return(struct AST_Node *) v;

}

AST_Node *new_ast_bool_node(enum Bool_op op, AST_Node *left, AST_Node *right) {
	AST_Node_Bool *v = malloc (sizeof (AST_Node_Bool));

	v->type = BOOL_NODE;
	v->op = op;
	v->left = left;
	v->right = right;

	return (struct AST_Node *) v;

}

AST_Node *new_ast_rel_node(enum Rel_op op, AST_Node *left, AST_Node *right) {
	AST_Node_Rel *v = malloc (sizeof (AST_Node_Rel));

	v->type = REL_NODE;
	v->op = op;
	v->left = left;
	v->right = right;

	return (struct AST_Node *) v;

}


AST_Node *new_ast_equ_node(enum Equ_op op, AST_Node *left, AST_Node *right) {
	AST_Node_Equ *v = malloc (sizeof (AST_Node_Equ));

	v->type = EQU_NODE;
	v->op = op;
	v->left = left;
	v->right = right;

	return (struct AST_Node *) v;

}



AST_Node *new_ast_stream_node(enum Stream_op op, AST_Node *left, AST_Node *right) {
	AST_Node_Stream *v = malloc (sizeof (AST_Node_Stream));

	v->type = STREAM_NODE;
	v->op = op;
	v->left = left;
	v->right = right;

	return (struct AST_Node *) v;
}

AST_Node *new_ast_char_node(enum Char_op op, AST_Node *left, AST_Node *right) {
	AST_Node_Char *v = malloc (sizeof (AST_Node_Char));

	v->type = CHAR_NODE;
	v->op = op;
	v->left = left;
	v->right = right;

	return (struct AST_Node *) v;
}




void ast_print_node(AST_Node *node) {
	AST_Node_Decl * temp_decl;	
	AST_Node_Const *temp_const;
	AST_Node_Assign *temp_assign;
	AST_Node_Incr *temp_incr;
	AST_Node_Arithm *temp_arithm;
	AST_Node_Bool *temp_bool;
	AST_Node_Rel *temp_rel;
	AST_Node_Equ *temp_equ;
	AST_Node_Stream *temp_stream;
	AST_Node_Char *temp_char;



	switch(node->type) {
		case BASIC_NODE:
			printf("Basic Node");
			break;
		case DECL_NODE:
			temp_decl = (struct AST_Node_Decl *) node;
			printf("Declaration Node of data-type %d for names\n",
				temp_decl->data_type);
			break;
		case CONST_NODE:
			temp_const = (struct AST_Node_Const *) node;
			printf("Constant Node of const-type %d\n", temp_const->const_type);
			break;
		case ASSIGN_NODE:
			temp_assign = (struct AST_Node_Assign *) node;
			printf("Assign Node of entry\n");
			break;
		case INCR_NODE:
			temp_incr = (struct AST_Node_Incr *) node;
			printf("Increment Node of entry being %d %d\n", 
				temp_incr->incr_type, temp_incr->pf_type);
			break;
		case ARITHM_NODE:
			temp_arithm = (struct AST_Node_Arithm *) node;
			printf("Arithmetic Node of operator %d\n", temp_arithm->op);
			break;
		case BOOL_NODE:
			temp_bool = (struct AST_Node_Bool *) node;
			printf("Boolean Node of operator %d\n", temp_bool->op);
			break;
		case REL_NODE:
			temp_rel = (struct AST_Node_Rel *) node;
			printf("Relational Node of operator %d\n", temp_rel->op);
			break;
		case EQU_NODE:
			temp_equ = (struct AST_Node_Equ *) node;
			printf("Equality Node of operator %d\n", temp_equ->op);
			break;
		case STREAM_NODE:
			temp_stream = (struct AST_Node_Stream *) node;
			printf("stream node of operator %d\n", temp_stream->op);
			break;
		case CHAR_NODE:
			temp_char = (struct AST_Node_Char *) node;
			printf("character operation of operator %d\n", temp_char->op);
			break;
		defeault:
			fprintf(stderr, "Error in node selection!\n");
			exit(1);
	}
}


void ast_traversal(AST_Node *node){

	int i;
	if (node == NULL) return;


	if(node->type == BASIC_NODE || node->type == ARITHM_NODE || node->type == BOOL_NODE
	|| node->type == REL_NODE || node->type == EQU_NODE || node->type == CHAR_NODE || node->type == STREAM_NODE){
		ast_traversal(node->left);
		ast_traversal(node->right);
		ast_print_node(node); // postfix
	}

	else{
		ast_print_node(node);
	}
	

}
