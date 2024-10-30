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


