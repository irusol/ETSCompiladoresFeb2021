%{
    #include <math.h>
    #include <string.h>
    float modulof(float a,float b);
    int modulo(int a,int b);
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
%token ADD
%token SUB
%token MUL
%token DIV
%token MOD
%token PARA
%token COMMA
%token PARB
%token QUOTE

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
    |exp '\n' {printf("\tResultado Entero: %d\n",$1);}
    |expf '\n' {printf("\tResultado Flotante: %f\n",$1);}
    |str '\n' {printf("\tResultado Cadena: %s\n",$1);}
;
exp: ENTERO {$$ = $1;}
    |exp ADD exp {$$ = $1 + $3;}
    |exp MUL exp {$$ = $1 * $3;}
    |exp SUB exp {$$ = $1 - $3;}
    |exp DIV exp {$$ = $1 / $3;}
    |MOD PARA exp COMMA exp PARB {$$ = modulo($3,$5);}
;
expf: FLOTANTE {$$ = $1;}
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
%%

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