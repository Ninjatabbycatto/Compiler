typedef enum Node_Type {
	BASIC_NODE,
	DECL_NODE,
	CONST_NODE,
	ASSIGN_NODE,
	INCR_NODE,
	ARITHM_NODE,
	BOOL_NODE,
	REL_NODE,
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
	list_r **names;
}AST_Node_Decl;

typedef struct AST_Node_Const{
	enum Node_Type type;
	int const_type;
	Value val;
}AST_Node_Const;

typedef struct AST_Node_Assign {
	enum Node_Type type;
	list_t *entry;
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
	list_t *entry;
	int incr_type;
	int pf_type;
}AST_Node_Incr;

typedef struct AST_Node_Arithm{
	enum Node_Type type;
	enum Arithm_op op;
	struct AST_Node *left;
	struct AST_Node *right;
}AST_Node_Arithm;

typedef struct AST_Node_Stream {
	Stream_Node_Type type;
	Stream_Op op;
	struct AST_Node *left;
	struct AST_Node *right;
}AST_Node_Stream;

typedef struct AST_Node_Equ {
	enum Node_Type type;
	enum Equ_op op;
	struct AST_Node *left;
	struct AST_Node *right;
}AST_Node_Equ;




