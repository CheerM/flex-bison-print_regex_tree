cc=gcc
regex:regex.y regex.l
	bison -d regex.y
	flex -o regex.lex.c regex.l
	cc -o $@ regex.tab.c regex.lex.c -lfl

regex.lex: regex.y regex.l
	bison -d regex.y
	flex -o regex.lex.c regex.l
	cc -D REGEX_LEX -o $@ regex.lex.c -lfl
clean:
	rm regex.lex.c
	rm regex.tab.c
	rm regex.tab.h
	rm regex