# include "proj2.h"
# include "proj3.h"
# include "proj4.h"
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <assert.h>

extern char str_table[], inst_buffer[], *kind_name[];
extern Expr arr_offset;
extern InClassVars class_stack[];
extern int top, field_base;

char* reg[] = {
    "zero","at","v0","v1","a0","a1","a2","a3",
    "t0","t1","t2","t3","t4","t5","t6","t7",
    "s0","s1","s2","s3","s4","s5","s6","s7",
    "t8","t9","k0","k1","gp","sp","fp","ra"
};

char* ops[] = {
    "add", "sub", "mul", "div", "slt", 
    "sgt", "seq", "sne", "sle", "sge",
    "and", "or", "neg", "not"};

int in_main=0;

char assembly[1024*16]={0}, *next_inst=assembly;

// Generate the entering code of a function.
int gen_func_head(int nSymIdx){
    gen_label(nSymIdx);
    gen("  addiu $sp, $sp, -12");
    gen("  sw $ra, 8($sp)");
    gen("  sw $fp, 4($sp)");
    if (strcmp(str_table+GetAttr(nSymIdx, NAME_ATTR), "main")==0)
        gen("  la $a0, symbol_%d", field_base), in_main = 1;
    gen("  sw $a0, 0($sp)"); // a3 saves the base address of the OBJECT.
    gen("  move $fp, $sp");
    return 0;
}

// Generate the exiting code of a function.
int gen_func_tail(int nSymIdx){
    gen("  move $sp, $fp");
    gen("  lw $ra, 8($sp)");
    gen("  lw $fp, 4($sp)");
    gen("  lw $a3, 0($sp)");
    gen("  addiu $sp, $sp, 12");
    if ( strcmp(str_table+GetAttr(nSymIdx, NAME_ATTR), "main") )
        gen("  jr $ra");
    else
        gen("  li $v0, 10\n  syscall");
    in_main = 0;
    return 0;
}

// General/Base code generating function, used just like printf, 
// AUTOMATICALLY generates a newline at the end.
int gen(const char* format, ...){
    va_list argptr;
    va_start(argptr, format);
    char format_[strlen(format)+1];
    strcpy(format_, format);
    strcat(format_, "\n");
    int len = vsprintf(next_inst, format_, argptr);
    next_inst = assembly + strlen(assembly);
    va_end(argptr);
    return len;
}

// Generate a label of symbol table entry 'nSymIdx'
int gen_label(int nSymIdx){
    if( strcmp(str_table+GetAttr(nSymIdx, NAME_ATTR), "main") )
        return gen("symbol_%d: # [%s] %s", nSymIdx, kind_name[GetAttr(nSymIdx, KIND_ATTR)-1], str_table+GetAttr(nSymIdx, NAME_ATTR));
    else
        return gen("main:");
}

// Generate an ALU operation code
int gen_alu(int op, int rd, int rs, int rt){
    if (op < UnaryNegOp) // For anything other than neg / not
        gen("  %s $%s, $%s, $%s", ops[op-AddOp], reg[rd], reg[rs], reg[rt]);
    else    // for neg and not
        gen("  %s $%s, $%s", ops[op-AddOp], reg[rd], reg[rs]);
    return rd;
}

// Post processing of an expr, generates lhs or rhs for following expression
int gen_get_expr(Expr expr, int rd, int is_lhs){
    
    switch (expr.type){
        case INT: 
            gen("  li $%s, %d", reg[rd], expr.value); 
            break;
        case STRING: 
            gen("  la $%s, S%d", reg[rd], expr.value); 
            break;
        case EXPR: 
            if (rd!=expr.value)
                gen("  move $%s, $%s", reg[rd], reg[expr.value]);
            break;
        case VARIABLE: 
            gen_get_var_value(expr.value, rd);
            break;
    }
    if (is_lhs)
        gen("  addiu $sp, $sp, -4"),
        gen("  sw $%s, 0($sp)", reg[rd]);
    return rd;
}

// stack pop.
int pop(int rd){
    gen("  lw $%s, 0($sp)\n  addiu $sp, $sp, 4", reg[rd]);
    return rd;
}

// stack push
int push(int rs){
    gen("  addiu $sp, $sp, -4\n  sw $%s, 0($sp)", reg[rs]);
    return rs;
}

// Generate codes to get an variable's value or address.
int gen_get_var(int nSymIdx, int rd, int as_value){
    int offset = GetAttr(nSymIdx, OFFSET_ATTR),
        arr_type = (GetAttr(nSymIdx, KIND_ATTR)==ARR)?4:0,
        arr_offset_int = 0, arr_offset_reg = 0;
    if (arr_type){
        switch (arr_offset.type)
        {
        case INT:
            arr_offset_int = arr_offset.value;
            break;
        case EXPR:
            arr_offset_reg = arr_offset.value;
            gen("  sll $%s, $%s, 2", reg[arr_offset_reg], reg[arr_offset_reg]);
            break;
        case VARIABLE:
            arr_offset_reg = 16; // $s0 reserved for array offset.
            gen_get_var_value(arr_offset.value, 16);
            gen("  sll $%s, $%s, 2", reg[arr_offset_reg], reg[arr_offset_reg]);
            break;
        default:
            break;
        } 
    }

    if (is_global_var(nSymIdx)){
        if (strcmp(inst_buffer,"#") && rd!=16) // if rd==16, then we are processing the array offset.
            gen(inst_buffer), gen("  move $t7, $a0");
        else
            gen("  lw $t7, 0($fp)"); // 0($fp) has base address of self.
    }
    else
        gen("  move $t7, $fp");
    if (arr_offset_reg)
        gen("  add $t7, $t7, $%s", reg[arr_offset_reg]);
    if (as_value)
        gen("  lw $%s, %d($t7)", reg[rd], offset + arr_offset_int * arr_type);
    else 
        gen("  addiu $%s, $t7, %d", reg[rd], offset + arr_offset_int * arr_type);
    return 0;
}

// Generate code to allocate space for an object.
void gen_object(tree root){
    if (IsNull(root)) return;
    gen_object(root->LeftC);
    if (root->NodeOpType==BodyOp){
        gen_object(root->RightC);
        return;
    }
    tree type = root->RightC->RightC->LeftC,
        var_init = root->RightC->RightC->RightC;

    int type_decl = 0; // this process will set type_decl.

    if (type->LeftC->NodeKind == STNode){
        type_decl = type->LeftC->IntVal;
        int i = 0;
        for (;i<top;i++)
            if (class_stack[i].nSymIdx==type_decl)
                break;
        gen_object(class_stack[i].decl);
    }
    // var_init
    else processVarInit(var_init);
}

/*  ********************************************************
    Just in case you are wondering where are the code generating traverse, 
    it is along with the semantic traverse in `semantic.c`, where you will find 
    all the calls of gen() and other code generation related funcion.

    The reasons of doing so are straightforward:
    1. You do not need to write another bunch of traverse codes, since you already have one,
    2. You can utilize all the information in the semantic analysis, 
    3. Better performance because we don't need to traverse it yet again, and
    4. This feels a lot like Syntax Directed Translation baby! 

    ******************************************************** */