#ifndef AST_H
#define AST_H

typedef enum Node_Type {
	BASIC_NODE,
	DECL_NODE,
	CONST_NODE,
	ASSIGN_NODE,
	INCR_NODE,
	ARITHM_NODE,
	BOOL_NODE,
	REL_NODE,
	CHAR_NODE,
	STREAM_NODE,
	EQU_NODE
}Node_Type;


typedef enum Arithm_op{
	ADD,
	SUB,
	MUL,
	DIV,

	INC,
	DEC
}Arithm_op;

typedef enum Bool_op {
	OR,
	AND,
	NOT

}Bool_op;

typedef enum Equ_op {
	EQUAL,
	NOT_EQUAL
}Equ_op;


typedef enum Rel_op {
	GREATER,
	LESS,
	GREATER_EQUAL,
	LESS_EQUAL
}Rel_op;

typedef enum Char_op {
	CIN,
	COUT
}Char_op;

typedef enum Stream_op {
	INS,
	EXT
}Stream_op;


//--------HELP structs-------------//

typedef union Value{
	int ival;
	double fval;
	char cval;
	char *sval;
}Value;


///--------------tree nodes-------------
///
typedef struct AST_Node{
	enum Node_Type type;
	struct AST_Node *left;
	struct AST_Node *right;
}AST_Node;


typedef struct AST_Node_Decl {
	enum Node_Type type;
	int data_type;
	char **names;
}AST_Node_Decl;

typedef struct AST_Node_Const{
	enum Node_Type type;
	int const_type ;
	Value val;
}AST_Node_Const;

typedef struct AST_Node_Assign {
	enum Node_Type type;
	char *entry;
	struct AST_Node *assign_val;
}AST_Node_Assign;


typedef struct AST_Node_Rel{
	enum Node_Type type;
	enum Rel_op op;
	struct AST_Node *left;
	struct AST_Node *right;
}AST_Node_Rel;

typedef struct AST_Node_Incr{
	enum Node_Type type;
	char *entry;
	int incr_type;
	int pf_type;
}AST_Node_Incr;

typedef struct AST_Node_Arithm{
	enum Node_Type type;
	enum Arithm_op op;
	struct AST_Node *left;
	struct AST_Node *right;
}AST_Node_Arithm;

typedef struct AST_Node_Bool{
	enum Node_Type type;
	enum Bool_op op;
	struct AST_Node *left;
	struct AST_Node *right;
}AST_Node_Bool;



typedef struct AST_Node_Stream {
	enum Node_Type type;
	enum Stream_op op;
	struct AST_Node *left;
	struct AST_Node *right;
}AST_Node_Stream;


typedef struct AST_Node_Char {
	enum Node_Type type;
	enum Char_op op;
	struct AST_Node *left;
	struct AST_Node *right;

} AST_Node_Char;

typedef struct AST_Node_Equ {
	enum Node_Type type;
	enum Equ_op op;
	struct AST_Node *left;
	struct AST_Node *right;
}AST_Node_Equ;


// AST node management...--------------------------------------------------
AST_Node *new_ast_node(Node_Type type, AST_Node *left, AST_Node *right);
AST_Node *new_ast_decl_node(int data_type, char **names);
AST_Node *new_ast_const_node(int const_type, Value val);
AST_Node *new_ast_assign_node(char *entry, AST_Node *assign_val);
AST_Node *new_ast_incr_node(char *entry, int incr_type, int pf_type);
AST_Node *new_ast_arithm_node(enum Arithm_op op, AST_Node *left, AST_Node *right);
AST_Node *new_ast_bool_node(enum Bool_op op, AST_Node *left, AST_Node *right);
AST_Node *new_ast_rel_node(enum Rel_op op, AST_Node *left, AST_Node *right);
AST_Node *new_ast_equ_node(enum Equ_op op, AST_Node *left, AST_Node *right);
AST_Node *new_ast_stream_node(enum Stream_op op, AST_Node *left, AST_Node *right);
AST_Node *new_ast_char_node(enum Char_op op, AST_Node *left, AST_Node *right);


#endif
