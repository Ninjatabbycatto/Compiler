#ifndef SYMBOLS_H
#define SYMBOLS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Define types for variable data types
typedef enum {
    INT_TYPE,
    REAL_TYPE,
    CHAR_TYPE,
    ARRAY_TYPE,
    POINTER_TYPE,
    FUNCTION_TYPE
} VarType;

// Union to hold variable values
typedef union {
    int ival;
    double fval;
    char cval;
    // Add more types if needed
} Value;

// Structure for a symbol table entry
typedef struct symbol_table_entry {
    char *name;               // Variable name
    VarType type;             // Variable type
    Value value;              // Variable value
    struct symbol_table_entry *next; // Pointer to next entry `in the list
} SymbolTableEntry;

// Function prototypes
SymbolTableEntry* create_entry(const char *name, VarType type, Value value);
void add_variable(SymbolTableEntry **table, const char *name, VarType type, Value value);
SymbolTableEntry* lookup_variable(SymbolTableEntry *table, const char *name);
void free_symbol_table(SymbolTableEntry *table);
void print_symbol_table(SymbolTableEntry *table);

#endif // SYMBOLS_H
