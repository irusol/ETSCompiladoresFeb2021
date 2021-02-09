ejemplo2: bison flex
	gcc ejemplo2.tab.c lex.yy.c -o ejemplo2
flex: ejemplo2.l
	flex ejemplo2.l
bison: ejemplo2.y
	bison -d ejemplo2.y
clean:
	rm ejemplo2 ejemplo2.tab.c ejemplo2.tab.h lex.yy.c