all:
	bison -d parser.y
	flex Lexer.l
	gcc -o program parser.tab.c lex.yy.c
	rm lex.yy.c parser.tab.c

