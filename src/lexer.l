%option yylineno
/*  This sinlge option will help us keep track of the line number.
    Namely, lex will keep an integer named 'yylineno' recording the line number.
*/
/*###########################################################*/
/*#INCLUDES, VARIABLES and other DEFINITIONS*/
/*###########################################################*/
%{
#include "proj2.h"
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* TODO: declare variables here */

char str_table[LIMIT2]={0};  // Our string/id table, 1D because the document implies so.
int stidx_table[LIMIT1]={0}, string_table[LIMIT1]={0}; // Table of beginning index of strings already met.

extern YYSTYPE yylval;

int yycolno=1,  //column number.
    next_ptr=0, //the offset of next free position in str_table.
    num_str=0,  //number of strings already met.
    num_string=0;

//This macro is sort of a black magic that implicitly keep track of the column number.
#define YY_USER_ACTION         \
    yycolno += yyleng;            

//function heads and pointers
int loc_str(const char*);  // this function used to be 'is_in_str_table()'
char* escape_seq(char*);
int (*report_error)(FILE*, const char*, ...) = fprintf;


%}


/*###########################################################*/
/*#PATTERN variables*/
/*###########################################################*/
alpha   [a-zA-Z]
digit   [0-9]

/* TODO: define regular expressions */
AND     (&&)
ASSGN   (:=)
DECLARATIONS    (declarations)
DOT     (".")
ENDDECLARATIONS (enddeclarations)
EQUAL   (=)
GT      (>)
ID      ({alpha}({alpha}|{digit})*)
INT     (int)
LBRAC   "["
LPAREN  "("
METHOD  (method)
NE      (!=)
OR      ("||")
PROGRAM (program)
RBRAC   "]"
RPAREN  ")"
SEMI    ";"
VAL     ([vV][aA][lL])
WHILE   (while)
CLASS   (class)
COMMA   ,
DIVIDE  "/"
ELSE    (else)
EQ      (==)
GE      (>=)
ICONST  ([1-9]{digit}*|0)
IF      (if)
LBRACE  "{"
LE      "<="
LT      "<"
MINUS   (-)
NOT     (!)
PLUS    "+"
RBRACE  "}"
RETURN  (return)
SCONST  '([^'\n]|\\')*'
TIMES   "*"
VOID    (void)
COMMENTS    ("/*"([^*"]*|\".*\"|\*+[^/])*"*/")
END_OF_LINE \n
WSPACES     [ \f\r\t\v]+
WRONGID     ({digit}+{alpha}+{digit}*)
UNCLOSED_STR '([^'\n]|\\')*\n
UNDEFINED   .
UNCLOSED_COMMENT "/*"([^*"]*|\".*\"|\*+[^/])*



/*###########################################################*/
/*#RULES and ACTIONS*/
/*###########################################################*/
/* TODO: define translation rules: pattern and action */
%%
{AND}           {return (ANDnum);}/* OPERATORS with 2 chars. */
{ASSGN}         {return (ASSGNnum);}
{NE}            {return (NEnum);}
{OR}            {return (ORnum);}
{EQ}            {return (EQnum);}
{GE}            {return (GEnum);}
{LE}            {return (LEnum);}

{DECLARATIONS}  {return (DECLARATIONSnum);}/*KEYWORDS*/
{ENDDECLARATIONS}            {return (ENDDECLARATIONSnum);}
{INT}           {return (INTnum);}
{PROGRAM}       {return (PROGRAMnum);}
{METHOD}        {return (METHODnum);}
{VAL}           {return (VALnum);}
{WHILE}         {return (WHILEnum);}
{CLASS}         {return (CLASSnum);}
{IF}            {return (IFnum);}
{ELSE}          {return (ELSEnum);}
{RETURN}        {return (RETURNnum);}
{VOID}          {return (VOIDnum);}

{DOT}           {return (DOTnum);}/*OPERATORS with 1 char*/
{EQUAL}         {return (EQUALnum);}
{GT}            {return (GTnum);}
{LBRAC}         {return (LBRACnum);}
{LPAREN}        {return (LPARENnum);}
{RBRAC}         {return (RBRACnum);}
{RPAREN}        {return (RPARENnum);}
{SEMI}          {return (SEMInum);}
{COMMA}         {return (COMMAnum);}
{DIVIDE}        {return (DIVIDEnum);}
{LBRACE}        {return (LBRACEnum);}
{LT}            {return (LTnum);}
{MINUS}         {return (MINUSnum);}
{NOT}           {return (NOTnum);}
{PLUS}          {return (PLUSnum);}
{RBRACE}        {return (RBRACEnum);}
{TIMES}         {return (TIMESnum);}

<<EOF>>         {return 0;}/*INVISIBLE characters.*/
{WSPACES}       {;}
{END_OF_LINE}   {yycolno = 1; }

{ICONST}        {
                    /*Convert the str to int and put it in yylval.intg*/
                    yylval.intg=atoi(yytext);
                    return (ICONSTnum);
                }
{ID}            {   
                    if((yylval.intg=loc_str(yytext))!=-1)        // detect whether current ID is already saved,
                        return IDnum;                               //     and return with yylval.intg set to its index if it is. 
                    strcpy(str_table + next_ptr, yytext);           // copy ID to free space in str_table.
                    yylval.intg = next_ptr;                              // set yylval.intg as its beginning offset
                    next_ptr += yyleng + 1;                         // set next_ptr to point at the next free space
                    stidx_table[num_str]=yylval.intg;                    // record current ID's beginning index in stidx_table
                    num_str++;                                      // count.
                    return (IDnum);                                 // return.
                }
{SCONST}        {
                    escape_seq(yytext);         // detect and process escape sequences.
                    int length = yyleng - 2;    // -2 because we need to get rid of the leading and trailing "'"
                    char str[length];           // temp variable saving string content
                    strcpy(str, yytext+1);      // copy all content, including trailing "'"
                    str[length]=0;              // get rid of trailing "'" and set \0 flag

                    // The following codes are basically the same as the process in ID, so we will not explain them.
                    if((yylval.intg=loc_str(str))!=-1) 
                        return SCONSTnum;
                    strcpy(str_table + next_ptr, str);
                    yylval.intg = next_ptr;
                    next_ptr += length + 1;
                    stidx_table[num_str]=yylval.intg;
                    num_str++;
                    string_table[num_string]=yylval.intg;
                    num_string++;
                    return (SCONSTnum);
                }
{COMMENTS}      {
                    char* rest = strrchr(yytext, '\n'); // try to extract the substring after the last \n .
                    if(rest!=NULL)                      // if it exists:
                        yycolno = strlen(rest);         //      set yycolno as its length.             
                }

{UNCLOSED_COMMENT}  {
                    char* rest = strrchr(yytext, '\n'); //identical to COMMENTS part
                    if(rest!=NULL) 
                        yycolno = strlen(rest); 
                    // except that we need to report error.
                    report_error(yyout,"Error: EOF found in comment, at line %d column %d\n", yylineno, yycolno);
                }
{UNCLOSED_STR}  {   
                    report_error(yyout,"Error: Unmatched string constant, at line %d column %d\n", yylineno-1, yycolno-yyleng);
                    yycolno = 1; //set yycolno as 1
                }
{WRONGID}       {
                    report_error(yyout,"Error: Malformed identifier '%s', at line %d column %d\n", yytext, yylineno, yycolno-yyleng);
                }
{UNDEFINED}     {   //!!!THIS RULE MUST BE THE LAST RULE!!! Otherwise it will cause problem!
                    report_error(yyout,"Error: Undefined symbol '%s', at line %d column %d\n", yytext, yylineno, yycolno-yyleng);
                }
%%
/*###########################################################*/
/*#FUNCTION IMPLEMENTATION*/
/*###########################################################*/

#if (YY_FLEX_MAJOR_VERSION == 2 && ((YY_FLEX_MINOR_VERSION > 5)||(YY_FLEX_MINOR_VERSION == 5 && YY_FLEX_SUBMINOR_VERSION >= 9)))
int (*clean_yy_mem)() = yylex_destroy;
#else
int (*clean_yy_mem)() = NULL;
#endif

int loc_str(const char* str){
    /*  detect whether a given string is in the str_stable.

        in:     Any string, presumably you don't know whether it's in the table. 
        out:    -1                      ,if not in str_table;
                its beginning offset    ,if in str_table
    */
    for(int i=0;i<num_str;i++){
        int idx = stidx_table[i];
        char* str_i = str_table + idx;
        if(strcmp(str, str_i)==0)
            return idx;
    }
    return -1;
}

char* escape_seq(char* yytext){
    /*  process escape sequences. input string will be modified INPLACE.
        
        in:     The string containing unprocessed escape sequences
        out:    The same string with escape sequences processed. 
    */
    int has_escape = 0;
    for(int i=0; yytext[i]; i++){
        if(yytext[i]=='\\'){
            int no_match=0;
            switch(yytext[i+1]){
                case '\\': yytext[i]='\\';break;
                case 'n': yytext[i]='\n';break;
                case 't': yytext[i]='\t';break;
                case '\'': yytext[i]= '\'';break;
                default: no_match = 1;
            }
            if(no_match) continue;
            has_escape = 1;
            yytext[1+i] |= 0x80;
            yyleng -= 1;
        }
    }
    int i_target=0;
    if (has_escape){
        for(int i=0; yytext[i]; i++){
            if((yytext[i]&0x80)==0)
                yytext[i_target++] = yytext[i];
        }
        yytext[yyleng] = 0; //Set final flag.
    }
    return yytext;
}

int yywrap() {
    return 1;
}
