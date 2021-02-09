%{
    #include "symboltable.h"
    #include <math.h>
    #include <stdbool.h>
    #include "ejemplo2.tab.h"
    #include <stdio.h>
    #include <string.h>

    char *removeQuotes(char *a);
%}
NUM [0-9]+
ABC [a-zA-Z0-9\ ]+
VARN [a-zA-Z_]
VOC [a-zA-Z0-9]*
%%
[-]?{NUM} {
    printf("Número entero %s\n",yytext);
    yylval.entero = atoi(yytext);
    return (ENTERO);
}
[-]?{NUM}?"."{NUM} {
    printf("Número flotante %s\n",yytext);
    yylval.flotante = atof(yytext);
    return (FLOTANTE);
}
";" {
    printf("Fin de instruccion\n");
    return(FINST);
}
"^" {
    printf("Signo de potencia\n");
    return(POT);
}
"=" {
    printf("Signo de asignacion\n");
    return(EQUALS);
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
"pow" {
    printf("Operacion potencia\n");
    return (POW);
}
"if" {
    printf("Operacion if\n");
    return (IF);
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
"<" {
    printf("Simbolo Menor que\n");
    return (LT);
}
">" {
    printf("Simbolo Mayor que\n");
    return (MT);
}
"==" {
    printf("Simbolo de comparacion\n");
    return (COMP);
}
\"{ABC}\" {
    printf("Cadena %s\n", yytext);
    yylval.cadena = removeQuotes(yytext);
    return (CADENA);
}
"true" {
    printf("Valor verdadero\n");
    yylval.booleano = true;
    return (BOOLEANO);
}
"false" {
    printf("Valor falso\n");
    yylval.booleano = false;
    return (BOOLEANO);
}
"int" {
    printf("Declaracion de tipo entero\n");
    return (INTEGER);
}

"float" {
    printf("Declaracion de tipo flotante\n");
    return (FLOATING);
}

"string" {
    printf("Declaracion de tipo cadena\n");
    return (STRING);
}
{VARN}{VOC} {
    printf("Nombre de Variable %s\n", yytext);
    char* aux = (char*)malloc(sizeof(char) * strlen(yytext));
    strcpy(aux,yytext);
    symrec* var = getSym(yytext);
    if(var != NULL){
        yylval.nodo = var;
        printf("Variable %s ya existe\n",yytext);
        switch(var->type){
            case 0:
                return(STRINGVAR);
            case 1:
                return(FLOATVAR);
            case 2:
                return(INTVAR);
            default:
                printf("\tError en el tipo\n");
        }
    }
    else{
        yylval.cadena = aux;
        return (VARNAME);
    }
}
%%
char *removeQuotes(char *a){
    char *b = a;
    a++;
    a[strlen(a)-1] = '\0';
    return a;
}
