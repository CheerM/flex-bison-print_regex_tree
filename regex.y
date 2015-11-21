/* Infix notation calculator. */

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
void yyerror (char const *);

int count_paren = 0;

char* twoNode(char* name, char* first, char* second) {
      char* res = (char*)malloc((int)strlen(name) + (int)strlen(first) + (int)strlen(second) + 100);
      strcpy(res, name);
      strcat(res, "(");
      strcat(res, first);
      strcat(res, ", ");
      strcat(res, second);
      strcat(res, ")");
      return res;
}

char* oneNode(char* name, char* str) {
  int len;
  if (str == NULL)len = 0;
  else len = (int)strlen(str);
  char* res = (char*)malloc((int)strlen(name) + len + 100);
  strcpy(res, name);
  if (str == NULL)return res;
  strcat(res, "(");
  strcat(res, str);
  strcat(res, ")");
  return res;
}

char* parenNode(int number, char* str) {
  char ss[5];
  sprintf(ss,"%d", number);
  char* res = (char*)malloc((int)strlen(str) + 100);
  strcpy(res, "Paren(");
  strcat(res, ss);
  strcat(res, ", ");
  strcat(res, str);
  strcat(res, ")");
  return res;
}



%}

%union{
  char ccType;
  char* cpType;
  int count;
}


%token LETTER DOT 
%left  '|' '(' ')' Ignore
%right '+' '*' '?' NgStar NgPlus NgQuest 

%% 
/* Grammar rules and actions follow.  */

input : /* empty */
      | input line
;

line  : '\n'
      | exp '\n'            { printf("%s\n", $<cpType>$); free($<cpType>$); count_paren=0;}
;

exp   :exp '|' term              {$<cpType>$ = twoNode("Alt", $<cpType>1, $<cpType>3);/*printf("%s\n", $<cpType>$);*/}
        |term                           {$<cpType>$=$<cpType>1;}

term: term factor               {$<cpType>$ = twoNode("Cat", $<cpType>1, $<cpType>2);/*printf("%s\n", $<cpType>$);*/}
        |factor                       {$<cpType>$=$<cpType>1;}
;

factor: LETTER                    {$<cpType>$=oneNode("Lit", &$<ccType>1);/*printf("%s\n", $<cpType>$);*/}
      |DOT                            {$<cpType>$=oneNode("Dot", NULL);/*printf("%s\n", $<cpType>$);*/}
      |factor '+'                     {$<cpType>$=oneNode("Plus", $<cpType>1); /*printf("%s\n", $<cpType>$);*/}
      | factor '*'                     {$<cpType>$=oneNode("Star", $<cpType>1);/*printf("%s\n", $<cpType>$);*/}
      | factor '?'                     {$<cpType>$=oneNode("Quest", $<cpType>1); /*printf("%s\n", $<cpType>$);*/}
      | factor NgStar             {$<cpType>$=oneNode("NgStar", $<cpType>1);/*printf("%s\n", $<cpType>$);*/}
      | factor NgPlus             {$<cpType>$=oneNode("NgPlus", $<cpType>1);/*printf("%s\n", $<cpType>$);*/}
      | factor NgQuest           {$<cpType>$=oneNode("NgQuest", $<cpType>1);/*printf("%s\n", $<cpType>$);*/} 
      |Ignore exp ')'               {$<cpType>$= $<cpType>2;}
      |'(' exp ')'                    {$<cpType>$=parenNode($<count>1, $<cpType>2); /*printf("%s\n", $<cpType>$);*/}
;

%%

int main() 
{
    return yyparse();
}

/* Called by yyparse on error.  */
void yyerror (char const *s)
{
    fprintf (stderr, "%s\n", s);
}

