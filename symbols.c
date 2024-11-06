#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbols.h"



void add_variable(char *name, int type, Value value) {
	int index = hash_function(name);
	symbol_table_entry *new_entry = malloc(sizeof(symbol_table_entry));
	new_entry->st_name = strdup(name);
	new_entry->st_type = type;
	new_entry->val = value;
	new_entry->next = hash_table[index];
	hash_table[index] = new_entry;
}




void generate_data_declarations(FILE *fp) {
    fprintf(fp, ".data\n");
    fprintf(fp, "# variables\n");
    
    for (int i = 0; i < SIZE; i++) {
        if (hash_table[i] != NULL) {
            symbol_table_entry *entry = hash_table[i];
            while (entry != NULL) {
                if (entry->st_type == INT_TYPE) {
                    fprintf(fp, "%s: .word %d\n", entry->st_name, entry->val.ival);
                } else if (entry->st_type == REAL_TYPE) {
                    fprintf(fp, "%s: .double %f\n", entry->st_name, entry->val.fval);
                } else if (entry->st_type == CHAR_TYPE) {
                    fprintf(fp, "%s: .byte '%c'\n", entry->st_name, entry->val.cval);
                } else if (entry->st_type == ARRAY_TYPE) {
                    // Handle arrays similarly as shown in your provided code
                }
                entry = entry->next;
            }
        }
    }
}

