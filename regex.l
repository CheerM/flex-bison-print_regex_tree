%{
    #include <stdlib.h>
    #include "regex.tab.h"
    int num = 1;
%}

%%

"."                             {yylval.ccType = *yytext; return DOT;}
"|"                             return '|';
"("                              {yylval.count = num++;return '(';}
")"                              return ')';
"*"                             return '*';
"+"                             return '+';
"?"                             return '?';
"(?:"                            {return Ignore;}
"*?"                            return NgStar;
"+?"                            return NgPlus;
"??"                            return NgQuest;
"\n"                            {num = 1; return '\n';}
(.)	         	      {yylval.ccType = *yytext; return LETTER; }

%%

int yywrap(void) {
    return 1;
}