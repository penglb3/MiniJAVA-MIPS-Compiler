# ifndef _PROJ4_H_
# define _PROJ4_H_

# include "proj3.h"

#define VARIABLE 3
#define EXPR 2
#define INT 1
#define STRING 0

typedef struct E{
    int type;
    int value;
} Expr;

typedef struct S{
    int nSymIdx;
    tree decl;
} InClassVars;

int gen_func_head(int nSymIdx);
int gen_func_tail(int nSymIdx);
int gen(const char* format, ...);
int gen_label(int nSymIdx);
int gen_alu(int op, int rd, int rs, int rt);
int gen_expr(Expr type, int rd, int is_lhs);
void gen_object(tree root);
int processVarInit(tree root);
# define gen_lhs( expr, rd ) gen_expr((expr), (rd), 1)
# define gen_rhs( expr, rd ) gen_expr((expr), (rd), 0)
int pop(int rd);
int push(int rd);
int gen_get_var(int nSymIdx, int rd, int mode);
# define gen_get_var_value(nSymIdx, rd) gen_get_var((nSymIdx), (rd), 1)
# define gen_get_var_addr(nSymIdx, rd) gen_get_var((nSymIdx), (rd), 0)

# define is_global_var(nSymIdx) GetAttr((nSymIdx), NEST_ATTR)<2
int builtin(int);

# endif