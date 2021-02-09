%{
    #include "symboltable.h"
    #include <math.h>
    #include <string.h>
    #include <stdio.h>
    float modulof(float a,float b);
    int modulo(int a,int b);
    void setString (symrec* p, char* cad);
    char* potenciaString (char* source, int num);
%}

/*Declaraciones de BISON*/

%union{
    int entero;
    float flotante;
    char* cadena;
}
%token <entero> ENTERO
%token <flotante> FLOTANTE
%token <cadena> CADENA
%token <cadena> VARNAME
%token <cadena> STRINGVAR
%token <cadena> FLOATVAR
%token <cadena> INTVAR
%token ADD
%token POT
%token SUB
%token MUL
%token DIV
%token MOD
%token EQUALS
%token PARA
%token COMMA
%token PARB
%token QUOTE
%token INTEGER
%token FLOATING
%token STRING
%token FINST

%type <entero> exp
%type <flotante> expf
%type <cadena> str

%left ADD SUB
%left MUL DIV MODA MODB
/*Gramática*/

%%
input: /*cadena vacia*/
    |input line
;

line: '\n' 
    |exp FINST '\n' {printf("\tResultado Entero: %d\n",$1);}
    |expf FINST '\n' {printf("\tResultado Flotante: %f\n",$1);}
    |str FINST '\n' {printf("\tResultado Cadena: %s\n",$1);}
    |varn FINST '\n' {printsym();}
;
exp: ENTERO {$$ = $1;}
    |INTVAR {printf("Variable Entera: %s\n",strtok($1,"=,*/-+\n ;"));$$ = getSym(strtok($1,",*/-+\n ;"))->value.intval;}
    |INTVAR EQUALS exp {printf("%s",strtok($1,"=,*/-+\n ;"));getSym(strtok($1,",*/-+\n ;"))->value.intval = $3; $$ = $3;}
    |INTVAR EQUALS expf {printf("%s",strtok($1,"=,*/-+\n ;"));getSym(strtok($1,",*/-+\n ;"))->value.intval = $3; $$ = $3;}
    |exp ADD exp {$$ = $1 + $3;}
    |exp MUL exp {$$ = $1 * $3;}
    |exp SUB exp {$$ = $1 - $3;}
    |exp DIV exp {$$ = $1 / $3;}
    |MOD PARA exp COMMA exp PARB {$$ = modulo($3,$5);}
;
expf: FLOTANTE {$$ = $1;}
    |FLOATVAR {printf("Variable Flotante: %s\n",strtok($1,"=,*/-+\n ;"));$$ = getSym(strtok($1,",*/-+\n ;"))->value.floatval;}
    |FLOATVAR EQUALS expf {printf("%s",strtok($1,"=,*/-+\n ;"));getSym(strtok($1,",*/-+\n ;"))->value.floatval = $3; $$ = $3;}
    |expf ADD expf {$$ = $1 + $3;}
    |expf MUL expf {$$ = $1 * $3;}
    |expf SUB expf {$$ = $1 - $3;}
    |expf DIV expf {$$ = $1 / $3;}
    |MOD PARA expf COMMA expf PARB {$$ = modulof($3,$5);}
    |expf ADD exp {$$ = $1 + $3;}
    |expf MUL exp {$$ = $1 * $3;}
    |expf SUB exp {$$ = $1 - $3;}
    |expf DIV exp {$$ = $1 / $3;}
    |MOD PARA expf COMMA exp PARB {$$ = modulof($3,$5);}
    |exp ADD expf {$$ = $1 + $3;}
    |exp MUL expf {$$ = $1 * $3;}
    |exp SUB expf {$$ = $1 - $3;}
    |exp DIV expf {$$ = $1 / $3;}
    |MOD PARA exp COMMA expf PARB {$$ = modulof($3,$5);}
;

str: CADENA  {$$ = $1;}
    |STRINGVAR {printf("Variable Cadena: %s\n",strtok($1,"=,*/-+\n ^;"));$$ = getSym(strtok($1,",*/-+\n ^;"))->value.stringval;}
    |STRINGVAR EQUALS str {printf("%s",strtok($1,"=,*/-+\n ^;"));setString(getSym(strtok($1,"=,*/-+\n ^;")),$3); $$ = $3;}
    |str ADD str {char* temp = (char* )malloc(sizeof(char) * strlen($1));strcpy(temp,$1);$$ = strcat(temp,$3);}
    |str POT exp {char* temp = (char* )malloc(sizeof(char) * strlen($1)*$3);strcpy(temp,potenciaString($1,$3));$$ = temp;}
;

varn: INTEGER VARNAME {putSym(strtok($2,"=,*/-+\n ;"),2);}
    |INTEGER VARNAME EQUALS exp {putSym(strtok($2,"=,*/-+\n ;"),2);getSym(strtok($2,"=,*/-+\n ^;"))->value.intval = $4;}
    |STRING VARNAME {putSym(strtok($2,"=,*/-+\n ^;"),0);}
    |STRING VARNAME EQUALS str {putSym(strtok($2,"=,*/-+\n ^;"),0);setString(getSym(strtok($2,"=,*/-+\n ^;")),$4);}
    |FLOATING VARNAME {putSym(strtok($2,"=,*/-+\n ;"),1);}
    |FLOATING VARNAME EQUALS expf {putSym(strtok($2,"=,*/-+\n ;"),1);getSym(strtok($2,"=,*/-+\n ;"))->value.floatval = $4;}
    |FLOATING VARNAME EQUALS exp {putSym(strtok($2,"=,*/-+\n ;"),1);getSym(strtok($2,"=,*/-+\n ;"))->value.floatval = $4;}
;
%%
symrec *sym_table;
int main(){
    yyparse();
}

yyerror(char *s)
{
    printf("-%s-\n",s);
}

int yywrap()
{
    return 1;
}

int modulo(int a,int b)
{
    if(a < b)
        return a;
    a -= b;
    return modulo(a,b);
}
float modulof(float a,float b)
{
    if(a < b)
        return a;
    a -= b;
    return modulof(a,b);
}
symrec *putSym (char const *name, int sym_type)
{
    if(getSym(name) != NULL)
        return NULL;
    symrec *res = (symrec *) malloc (sizeof (symrec));
    res->name = strdup (name);
    res->type = sym_type;
    switch(sym_type){
        case 0:
            res->value.stringval = NULL;
            break;
        case 1:
            res->value.floatval = 0;
            break;
        case 2:
            res->value.intval = 0;
            break;
        default:
            printf("\tError en el tipo\n");
    }
    res->next = sym_table;
    sym_table = res;
    return res;
}


symrec *getSym (char const *name)
{
    for (symrec *p = sym_table; p; p = p->next)
        if (strcmp (p->name, name) == 0)
        return p;
    printf("\nVARIABLE %s NO DECLARADA\n",name);
    return NULL;
}

void setString (symrec* p, char* cad){
    p->value.stringval = (char*)malloc(sizeof(char) * strlen(cad));
    strcpy(p->value.stringval,cad);
}
void printsym ()
{
    printf("\nTabla de Símbolos\n");
    for (symrec *p = sym_table; p; p = p->next){
        printf("\tNombre: %s\n",p->name);
        switch(p->type){
            case 0:
                printf("\tTipo: String\n\tValor: %s\n",p->value.stringval);
                break;
            case 1:
                printf("\tTipo: Float\n\tValor: %f\n",p->value.floatval);
                break;
            case 2:
                printf("\tTipo: Int\n\tValor: %d\n",p->value.intval);
                break;
            default:
                printf("\tError en el tipo\n");
        }
    }
}

char* potenciaString (char* source, int num){
    int x;
    char* result;
    if (num <= 0)
        return NULL;
    result = (char*)malloc(sizeof(char) * (strlen(source) * num));
    strcpy(result,"");
    for( x = num; x > 0; x--){
        strcat(result,source);
        printf("%s\n",result);
    }
    return result;
}
