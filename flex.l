%{
#include "stdio.h"
#include "stdlib.h"
enum {
    LOOKUP = 0,
    SHORT,
    INT,
    LONG,
    CHAR,
    FLOAT,
    DOUBLE,
    SIGNED,
    UNSIGNED    	
};
int state;
int line = 0;
%}

KEYWORD auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while|main
INT_DEX [1-9][0-9]*|[0]
INT_HEX [0][Xx]([1-9][0-9]*|[0])
INT_OCT [0][0-7]
FLOAT [0-9]*[.][0-9]+([eE][+-]?[0-9]*|[0])?f?
SEMI [;]
COMMA [,]
ASSIGNOP [=]
RELOP [>]|[<]|[>][=]|[<][=]|[=][=]|[!][=](^[=])
PLUS [+]
MINUS [-]
STAR [*]
DIV [/]
AND [&][&]
OR [|][|]
DOT [.]
NOT [!]
LP \(
RP \)
LB \[
RB \]
LC \{
RC \}
SPACE [ \n\t]
ID [a-zA-Z_][a-zA-Z_0-9]*
NOTNUM [0-9][a-zA-Z_0-9]*
/*end of definition*/
%%

\n {
	state = LOOKUP;
	line ++;
}
"//" comment2(yytext);
"/*" comment(yytext);
"int" {
	state = INT;
	upper(yytext, yyleng);
	printf("%-10s  ", yytext);
	downer(yytext, yyleng);
	printf("%-10s\n", yytext);
}
"double" {
	state = DOUBLE;
	upper(yytext, yyleng);
	printf("%-10s  ", yytext);
	downer(yytext, yyleng);
	printf("%-10s\n", yytext);
}
"long" {
	state = LONG;
	upper(yytext, yyleng);
	printf("%-10s  ", yytext);
	downer(yytext, yyleng);
	printf("%-10s\n", yytext);
}
"char" {
	state = CHAR;
	upper(yytext, yyleng);
	printf("%-10s  ", yytext);
	downer(yytext, yyleng);
	printf("%-10s\n", yytext);
}
"float" {
	state = FLOAT;
	upper(yytext, yyleng);
	printf("%-10s  ", yytext);
	downer(yytext, yyleng);
	printf("%-10s\n", yytext);
}
"short" {
	state = SHORT;
	upper(yytext, yyleng);
	printf("%-10s  ", yytext);
	downer(yytext, yyleng);
	printf("%-10s\n", yytext);
}
"signed" {
	state = SIGNED;
	upper(yytext, yyleng);
	printf("%-10s  ", yytext);
	downer(yytext, yyleng);
	printf("%-10s\n", yytext);
}
"unsigned" {
	state = UNSIGNED;
	upper(yytext, yyleng);
	printf("%-10s  ", yytext);
	downer(yytext, yyleng);
	printf("%-10s\n", yytext);
}
{KEYWORD} {
        upper(yytext, yyleng);
	printf("%-10s  ", yytext);
	downer(yytext, yyleng);
	printf("%-10s\n", yytext);
}
{INT_DEX} |
{INT_HEX} |
{INT_OCT} {
        printf("%-10s  %-10s  %-10s\n", "INT" ,yytext, yytext);
}
{NOTNUM} {
	printf("%-10s  ERROR IN IDENTIFIER!  %-10s\n","NOTNUMBER", yytext);
}
{FLOAT} {
        printf("%-10s  %-10s  %-10s\n", "FLOAT", yytext, yytext);
}
{SEMI} {
        printf("%-10s  %-10s\n", "SEMI", yytext);

}
{COMMA} {
        printf("%-10s  %-10s\n", "COMMA", yytext);
}
{ASSIGNOP} {
        printf("%-10s  %-10s\n", "ASSIGNOP", yytext);
}
{RELOP} {
        printf("%-10s  %-10s\n", "RELOP", yytext);
}
{PLUS} | 
{MINUS} |
{STAR} |
{DIV} {
        printf("%-10s  %-10s\n", "OP", yytext);
}
{AND} |
{OR} |
{NOT} {
        printf("%-10s  %-10s\n", "LOP", yytext);
}
{DOT} {
        printf("%-10s  %-10s\n", "DOT", yytext);
}
{LP} {
        printf("%-10s  %-10s\n", "LP", yytext);
}
{RP} {
        printf("%-10s  %-10s\n", "RP", yytext);
}
{LB} {
        printf("%-10s  %-10s\n", "LB", yytext);
}
{RB} {
        printf("%-10s  %-10s\n", "RB", yytext);
}
{LC} {
        printf("%-10s  %-10s\n", "LBRACE", yytext);
}
{RC} {
        printf("%-10s  %-10s\n", "RBRACE", yytext);
}
{ID} {
	if(state != LOOKUP) {
	add_word(state, yytext);
	} else {
		if(lookup_word(yytext)!=1000000){}
		else
			printf("%-10s:  don't recognize\n", yytext);
	}
}
{SPACE} |
. {
/*ABANDON THESE CHARACTERS*/
}
%%

int yywrap() {
  return 1;
}
void upper(char* str,int len)
{
  for(int i = 0; i < len; i++)
  {
    if('a' <= str[i] && str[i] <= 'z')
    {
      str[i] = str[i] - 32;
    }
  }
}
void downer(char* str,int len)
{
  for(int i = 0; i < len; i++)
  {
    if('A' <= str[i] && str[i] <= 'Z')
    {
      str[i] = str[i] + 32;
    }
  }
}
void comment(char* str) {
	char c, prev = 0;
	while ((c = input()) != EOF)      /* (EOF maps to 0) */
	{
    if (c == '/' && prev == '*')
			return;
		prev = c;
	}
  printf("unterminated comment");
}
void comment2(char* str) {
	char c;
	while ((c = input()) != EOF)      /* (EOF maps to 0) */
	{
    if (c == '\n')
			return;
	}
  printf("unterminated comment");
}
int main()
{
yylex(); /* 进行分析 */
return 0;
}
struct word {
	char *word_name;
	int word_type;
	double word_value;
	struct word *next;
};
struct word *word_list;
extern void *malloc();
int add_word(int type,char *word)
{
	struct word *wp;
	if(lookup_word(word) != 1000000) {
		return 0;
	}

	wp = (struct word *) malloc (sizeof(struct word));
	wp->next = word_list;
	
	wp->word_name = (char *) malloc(strlen(word)+1);
	strcpy(wp->word_name,word);
	wp->word_type = type;
	word_list = wp;
	printf("%-10s  %-10s%u\n", "ID", wp->word_name,wp);
	return 1;
}
int lookup_word(char *word)
{
	struct word *wp = word_list;
	for(;wp;wp = wp->next) {
		if(strcmp(wp->word_name, word) == 0){
			printf("%-10s  %-10s%u\n", "ID", wp->word_name,wp);
			return wp->word_value;
		}
			
	}
	return 1000000;	/* not found */
}
