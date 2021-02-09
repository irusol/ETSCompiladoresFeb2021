typedef struct symrec
{
  char *name;  /* nombre del símbolo */
  int type;    /* Tipo del símbolo: 0.-String 1.-float 2.-integer */
  union Value
  {
    char* stringval;    /* Cadena */
    float floatval;    /* Valor float */
    int intval;   /* Valor entero */
  }value;
  struct symrec *next;  /* Enlazamiento */
} symrec;

symrec *putSym (char const *name, int sym_type);
symrec *getSym (char const *name);
void printsym ();