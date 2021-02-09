%{
    #include "ejemplo2.tab.h"
    #include <string.h>
    char *removeQuotes(char *a);
%}
NUM [0-9]+
ABC [a-zA-Z0-9\ ]+
%%
{NUM} {
    printf("Número entero %s\n",yytext);
    yylval.entero = atoi(yytext);
    return (ENTERO);
}
{NUM}"."{NUM} {
    printf("Número flotante %s\n",yytext);
    yylval.flotante = atof(yytext);
    return (FLOTANTE);
}

"+" {
    printf("Signo Suma\n");
    return (ADD);
}
"*" {
    printf("Signo Multiplicacion\n");
    return (MUL);
}
"-" {
    printf("Signo Resta\n");
    return (SUB);
}
"/" {
    printf("Signo Division\n");
    return (DIV);
}
"mod" {
    printf("Operacion Modulo\n");
    return (MOD);
}
"(" {
    printf("Parentesis Abierto\n");
    return(PARA);
}
"," {
    printf("Simbolo coma\n");
    return (COMMA);
}
")" {
    printf("Parentesis Cerrado\n");
    return (PARB);
}

"\n" {
    printf("Salto de línea\n");
    return (yytext[0]);
}

\"{ABC}\" {
    printf("Cadena %s\n", yytext);
    yylval.cadena = removeQuotes(yytext);
    return (CADENA);
}
%%
char *removeQuotes(char *a){
    char *b = a;
    a++;
    a[strlen(a)-1] = 0;
    return a;
}