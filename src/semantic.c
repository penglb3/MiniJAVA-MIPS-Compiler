#include "proj2.h"
#include "proj3.h"
#include "proj4.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <assert.h>

int offset = 0, expr_result = 0, init_type, type_decl, branch_num=0, top=0, field_base=0;
char inst_buffer[128];
extern int nesting, in_main;
# define is_local (nesting==2)

Expr arr_offset;
InClassVars class_stack[32]; // stack to hold declaration subtrees in classes, used for object generation
extern char* reg[], *next_inst;

extern tree (*Dummy)();
extern char str_table[];
extern int stidx_table[];
extern int num_str;
extern int string_table[];
extern int num_string;

int insertAndConvertToSymbol(tree* rootptr);
int builtin(int nSymIdx){
    return nSymIdx && IsAttr(nSymIdx, PREDE_ATTR) && GetAttr(nSymIdx, PREDE_ATTR);
}

void traverse(tree root);
void processClassDefOp(tree root);
void traverseBodyOp(tree root);
void traverseDeclOp(tree root);
void processVarDecl(tree root);
void processMethodDeclOp(tree root);
int traverseArrayTypeOp(tree root); 
void traverseStmtOp(tree root);
void processStmt(tree root);
int traverseIfElse(tree);
void processRoutineCall(tree);

int traverseMethodArgs(tree root);
int processVarInit(tree root); 
Expr processExpr(tree);
int processVariable(tree);
int processTypeId(tree root);
Expr traverseSimpleExpr(tree root);
Expr processSimpleExprWithSign(tree root);

/*  try inserting IDNode's ID into symbol table, 
        and convert it into an STNode if insertion successful.

    ARGS:       address of an IDNode rootptr, 
    RETURNS:    0,                      if insertion failed;
                index of the symbol,    if insertion succeeded.
*/
int insertAndConvertToSymbol(tree* rootptr){
    if ( (*rootptr)->NodeKind == STNode )
        return (*rootptr)->IntVal;
    int nStrIdx = (*rootptr)->IntVal;//Class name's idx
    int nSymIdx = InsertEntry(nStrIdx);
    if (nSymIdx != 0){
        free(*rootptr);
        *rootptr = MakeLeaf(STNode, nSymIdx);
        return nSymIdx;
    }
    else 
        return 0; // TODO: Report Error.
}

// traverse nodes with NodeOpType = ArrayTypeOp
// **RETURNS: Total length of array, if any**
int traverseArrayTypeOp(tree root){
    if (IsNull(root)) return 0;
    int length = traverseArrayTypeOp(root->LeftC);
    Expr expr;
    switch (root->NodeOpType){
        case BoundOp:
            expr = processExpr(root->RightC);
            return (length?length:1)*expr.value;
        case CommaOp:
            processVarInit(root->RightC);
            return 0;
        case ArrayTypeOp:
            if(root->RightC->NodeKind!=INTEGERTNode)
                processTypeId(root->RightC);
            return length;
    }
    return printf("# (%s:%d): Invalid control sequenc in traverseArrayTypeOp \n", __FILE__, __LINE__);
}

// process a node for VarInit
// **SETS:   init_type, could be ARR, VARIABLE, EXPR, INT
// **RETURN: ESTIMATED SIZE of the variable**
int processVarInit(tree root){
    Expr expr;

    if (root->NodeOpType != ArrayTypeOp){
        expr = processExpr(root);
        init_type = expr.type;
        if (is_local) {
            gen("  li $t0,%d", expr.value);
            gen("  addiu $sp,$sp,-4");
            gen("  sw $t0,0($sp)");
        }
        else
            gen(".word %d", expr.value);
        return 1;
    }
    int size = traverseArrayTypeOp(root);
    if (!is_local)
        gen(".space %d # ARRAY SPACE.", size*4);
    else{
        gen("  addiu $sp,$sp,%d",-4*size);
    }
    init_type = ARR;
    return size;
}

/*  traverse and process nodes for SimpleExpr 
    (processing the whole subtree in this function) 
    **RETURN: An Expr representing the SimpleExpr ***/
Expr traverseSimpleExpr(tree root){
    Expr lhs, rhs, result;
    int nSymIdx;
    result.type = EXPR;
    switch (root->NodeOpType){
    // Following cases for **SimpleExpr**
        case AddOp:
        case SubOp:
        case OrOp:
    // Following cases for **Term**
        case MultOp:
        case DivOp:
        case AndOp:
            lhs = traverseSimpleExpr(root->LeftC);
            gen_get_lhs(lhs, 8);
            rhs = traverseSimpleExpr(root->RightC);
            pop(9);
            gen_get_rhs(rhs, 8);
            result.value = gen_alu(root->NodeOpType, 8, 9, 8);
            break;
        
    // Not in above cases? Then it must be **Factor**
        // Variable
        case VarOp: 
            result.value = processVariable(root);
            result.type = VARIABLE;
            break;
        // Logical Not
        case NotOp: 
            result = traverseSimpleExpr(root->LeftC);
            if (result.type == INT)
                result.value = ! result.value;
            else 
                gen_get_rhs(result, 8),
                result.value = gen_alu(NotOp, 8, 9, 8);
            result.type = result.type==INT?INT:EXPR;
            break;
        // MethodCallStmt
        case RoutineCallOp: 
            processRoutineCall(root); // after routine call, return value is in $v0
            result.value = 8;
            gen("  move $t0, $v0");
            break;
        // UnsignedConst, because I initialized NodeOp of leaf node to 0
        case 0: 
            if (root->NodeKind == STRINGNode) {
                result.value = root->IntVal;
                result.type = STRING;
            }
            else{ 
                result.value = root->IntVal;
                result.type = INT;
            }
            break;
        // Expr
        default: 
            return processExpr(root);
    }
    return result;
}

/* traverse a node for SimpleExprWithSign
 **RETURN: An Expr representing the SimpleExprWithSign ***/
Expr processSimpleExprWithSign(tree root){
    Expr result;
    if (!IsNull(root) && root->NodeOpType == UnaryNegOp){
        result = traverseSimpleExpr(root->LeftC);
        if (result.type == INT)
            result.value = - result.value;
        else 
            gen_get_rhs(result, 8),
            result.value = gen_alu(UnaryNegOp, 8, 8, 10);
        result.type = (result.type==INT?INT:EXPR);
        return result;
    }
    return traverseSimpleExpr(root);
}

// traverse nodes for IfStatement, i.e., nodes with NodeOpType = IfElseOp
// **RETURN: the number of if/else 's - for internal use only **
int traverseIfElse(tree root){
    if (IsNull(root)) return 0;
    int depth = traverseIfElse(root->LeftC);
    Expr expr;
    if (root->RightC->NodeOpType == CommaOp) {// If-Stmt
        gen("# %s IF #%d_%d", depth?"ELSE":"", branch_num, depth);
        expr = processExpr(root->RightC->LeftC);
        gen("  beqz $%s, false_%d_%d", reg[expr.value], branch_num, depth);
        traverseStmtOp(root->RightC->RightC);
        gen("  j next_%d", branch_num);
        gen("false_%d_%d:", branch_num, depth);
    } else {// Else-Stmt
        gen("# ELSE #%d", branch_num);
        traverseStmtOp(root->RightC);
    }
    return depth+1;
}

// process a node for MethodCall, i.e., NodeOpType = RoutineCallOp
void processRoutineCall(tree root){
    int func_name_id = processVariable(root->LeftC);
    int argc_call = 0, argc = 0, arg_symbol;
    if (IsAttr(func_name_id, ARGNUM_ATTR)) 
        argc = GetAttr(func_name_id, ARGNUM_ATTR);
    Expr arg, arg_stack[argc]; // this works as a stack
    //printf("[I] GetAttr('%s', ARGNUM) = %d\n", str_table+GetAttr(func_name_id, NAME_ATTR), argc);
    root = root->RightC;
    if (!builtin(func_name_id) && argc) gen("  addiu $sp, $sp, -%d", argc*4);
    while(!IsNull(root)){
        arg = processExpr(root->LeftC);
        arg_stack[argc_call++]=arg;
        
        if (!builtin(func_name_id)) {
            gen_get_rhs(arg, 8);
            gen("  sw $t0, %d($sp)", (argc_call-1)*4);
        }
        root = root->RightC;
    }
    if(argc_call != argc)
        error_msg(ARGUMENTS_NUM2, CONTINUE, GetAttr(func_name_id, NAME_ATTR), 0);
    if (!builtin(func_name_id)) {
        if (inst_buffer[0]!='#')
        gen(inst_buffer);
        gen("  jal symbol_%d", func_name_id);
        // Write back all ref-args.
        for (int i=0;i<argc;i++){
            arg_symbol = func_name_id+i+1;
            if (GetAttr(arg_symbol, KIND_ATTR)==REF_ARG){
                assert(arg_stack[i].type == VARIABLE);
                gen_get_var_addr(arg_stack[i].value, 6);
                gen("  lw $t3, %d($sp)", i*4);
                gen("  sw $t3, 0($a2)");
            }
        }
        if(argc) gen("  addiu $sp, $sp, %d", argc*4);
        return;
    }
    if (strcmp("println",str_table+GetAttr(func_name_id, NAME_ATTR))==0){
        if (arg.type==STRING)
            gen("  li $v0, 4"),gen("  la $a0, S%d", arg.value);
        else{
            gen("  li $v0, 1");
            gen_get_rhs(arg, 4);
            gen("  syscall");
            gen("  li $v0, 0xB");
            gen("  li $a0, 0xA");
        }
        gen("  syscall");
    }
    if (strcmp("readln",str_table+GetAttr(func_name_id, NAME_ATTR))==0){
        if (arg.type != VARIABLE)
            gen("# DEBUG: In processRoutineCall, readln got an non-var.");
        gen("  li $v0,5");
        gen("  syscall");
        gen_get_var_addr(arg.value, 8);
        gen("  sw $v0,0($t0)");
    }
    
}

// process a node for Expression
// **RETURN: An Expr representing the SimpleExpr **
Expr processExpr(tree root){
    Expr lhs, rhs, result;
    result.type = EXPR;
    switch (root->NodeOpType){
        case LTOp:
        case LEOp:
        case EQOp:
        case NEOp:
        case GEOp:
        case GTOp:
            lhs = processSimpleExprWithSign(root->LeftC);
            gen_get_lhs(lhs, 8);
            rhs = processSimpleExprWithSign(root->RightC);
            pop(9);
            gen_get_rhs(rhs, 8);
            result.value = gen_alu(root->NodeOpType, 8, 9, 8);
            if (lhs.type == STRING || rhs.type == STRING) 
                error_msg(TYPE_MIS, CONTINUE, (lhs.type==STRING?lhs.type:rhs.type), 0);
            return result;
        default:
            return processSimpleExprWithSign(root);
    }
}

// process a node for variable, i.e. NodeOpType = VarOp
// ... which is damn complicated if you want all functionality.
// **SETS  : arr_offset, an Expr representing the offset for array
//           inst_buffer, the instruction that generates the base address for an object.
// **RETURN: Last symbol's index in symbol table**
int processVariable(tree root){
    int nStrIdx, // FIRST ID's index in string table
        nSymIdx, // current ID's index in symbol table
        id = 0,  // current ID's index in string table
        var_kind=0, // KIND_ATTR of current ID/Symbol
        dim_use=0, // the dimension actually used by IndexOps
        has_base = 0, // whether the variable contains field base
        field_offset = 0, // the offset of field ops.
        self = field_base; // the base address of an object.
    // Acquire current ID's index in symbol table and string table.
    if(root->LeftC->NodeKind == IDNode) 
        nStrIdx = root->LeftC->IntVal,
        nSymIdx = LookUp(nStrIdx);
    else 
        nSymIdx = root->LeftC->IntVal,
        nStrIdx = GetAttr(nSymIdx, NAME_ATTR);

    sprintf(inst_buffer, "#");

    // If found in symbol table, convert the corresponding IDNode to STNode
    if (nSymIdx!=0)
        free(root->LeftC), root->LeftC = MakeLeaf(STNode, nSymIdx);

    tree selectOp = root->RightC,   // currently processing SelectOp node
        index = NULL,               // indexOp 
        field = NULL,               // fieldOp
        sym_type = NULL;            // current symbol's type tree.

    // TRAVERSE THROUGH SelectOps
    while(!IsNull(selectOp)){
        int class_symbol=0, // current ID's class name, if available
            field_symbol=0; // the symbol behind . operator
        // Get the KIND OF VARIABLE.
        var_kind = GetAttr(nSymIdx, KIND_ATTR);
        // Check if symbol is class name, get its class name
        switch (var_kind){
            // If the variable has TYPE_ATTR, then just get it!
            case VAR:
            case ARR:
            case FUNC:
                sym_type = (tree)GetAttr(nSymIdx, TYPE_ATTR);   // Get the type tree of Symbol
                if (sym_type->LeftC->NodeKind == STNode)        // If the type tree has an ID, and it's in symbol table
                    class_symbol = sym_type->LeftC->IntVal;     // then this is the class name of current symbol
                break;
            // If the variable name is a class itself, then set it!
            case CLASS:
                class_symbol = nSymIdx; 
                break;
            default:
                break;
        }
        
        // process current selectOp
        switch (selectOp->LeftC->NodeOpType){
            case IndexOp:
                // current node is index
                index = selectOp->LeftC;
                // If current variable is NOT an ARRAY or has NO DIMENSION ATTRIBUTE
                if (var_kind != ARR || !IsAttr(nSymIdx, DIMEN_ATTR))
                    // Then you must have misused [] operator.
                    // Note that, ACCORDING to STANDARD OUTPUT, 
                    //     we report class name instead of var name whenever it's available
                    error_msg(TYPE_MIS, CONTINUE, nStrIdx, 0);
                // otherwise, check if dimension used is greater than defined dimensions
                else if (GetAttr(nSymIdx, DIMEN_ATTR)<++dim_use)
                    // if it's true, then you must have made a dimension error.
                    error_msg(INDX_MIS, CONTINUE, nStrIdx, 0);
                // At this point, if no error reported, we consider the usage of [] is CORRECT.
                // Next, we TRAVERSE all IndexOps, processing the expressions inside.
                while (!IsNull(index)){
                    arr_offset = processExpr(index->LeftC); //When generating code, assume only 1-D array for simplicity.
                    // gen("  # [I] arr_offset(%d) = %d set by %s", arr_offset.type, arr_offset.value, str_table+GetAttr(nSymIdx, NAME_ATTR));
                    index = index->RightC;
                }
                break;
            case FieldOp:
                // current action is field
                field = selectOp->LeftC;
                // Get id from its IDNode at left branch of FieldOp node
                id = field->LeftC->IntVal; 
                // (just in case this node is already converted to STNode, 
                //      which really shouldn't happen - it's the first time we come here!)
                id = field->LeftC->NodeKind==IDNode ? id : GetAttr(id, NAME_ATTR);

                // If current variable is NOT declared as an VARIABLE, CLASS OR FUNCTION
                if (var_kind != VAR && var_kind != CLASS && var_kind != FUNC)
                    // Then you must have misused . operator.
                    error_msg(TYPE_MIS, CONTINUE, nStrIdx, 0);
                // Otherwise, we check if the symbol behind . operator is declared within the field.
                else{
                    // If this variable is not builtin and has a class symbol
                    if (class_symbol && !builtin(nSymIdx))
                        // look up in the symbol specified by class_symbol.
                        field_symbol = LookUpField(class_symbol, id); //look for id in class field.
                    else // Otherwise,
                        // look up directly using the symbol before . operator 
                        field_symbol = LookUpField(nSymIdx, id);
                    // If nothing found,
                    if (field_symbol==0)
                        // well, you must have used sth not in field.
                        error_msg(FIELD_MIS, CONTINUE, id, 0);
                }
                // if you have a legitimate field_symbol
                if (field_symbol != 0)
                    // then don't forget to convert IDNode into STNode!
                    free(field->LeftC), field->LeftC = MakeLeaf(STNode, field_symbol);
                if (!has_base)
                    self = nSymIdx, has_base = 1;
                else
                    field_offset += GetAttr(nSymIdx, OFFSET_ATTR);
                // Set the current symbol as field_symbol, this is VITAL for processing nested field ops.
                nSymIdx = field_symbol;
                break;
            default:
                break;
        }
        selectOp = selectOp->RightC;
    }
    if (has_base && !builtin(self)){
        if (in_main){
            if (is_global_var(self))
                sprintf(inst_buffer, "  la $a0, symbol_%d+%d", self, field_offset);
            else
                sprintf(inst_buffer, "  move $a0, $fp");;
        }
        else
            sprintf(inst_buffer, "  lw $a0, 0($fp)\n  addiu $a0, $a0, %ld", GetAttr(self, OFFSET_ATTR)+field_offset);
    }
    // AFTER MAIN LOOP, we know the total [] used, and we can check if it corresponds with declared dims
    // ... that is, on condition that the variable IS ARRAY.
    if (var_kind == ARR && IsAttr(nSymIdx, DIMEN_ATTR) && GetAttr(nSymIdx, DIMEN_ATTR)>dim_use)
        // so you didn't use adequate dims, did you?
        error_msg(INDX_MIS, CONTINUE, nStrIdx, 0);

    // return current symbol, which is last fielded id.
    return nSymIdx;
}

// process a single statement
void processStmt(tree root){
    if (IsNull(root)) return;
    tree var=NULL, expr=NULL;
    Expr exp;
    int nSymIdx;
    static int loop_num = 0;
    switch (root->NodeOpType){
        case AssignOp:
            var = root->LeftC->RightC;
            expr = root->RightC;
            nSymIdx = processVariable(var);
            gen_get_var_addr(nSymIdx, 17);
            push(17);
            exp = processExpr(expr);
            gen_get_rhs(exp, 18);
            pop(17);
            gen("  sw $s2, 0($s1)");
            break;
        case RoutineCallOp:
            processRoutineCall(root);
            break;
        case ReturnOp:
            exp = processExpr(root->LeftC);
            gen_get_rhs(exp, 2);
            break;
        case IfElseOp:
            traverseIfElse(root);
            gen("next_%d:", branch_num++);
            break;
        case LoopOp:
            expr = root->LeftC;
            gen("loop_%d:", loop_num);
            exp = processExpr(expr);
            gen("  beqz $%s, loop_%d_end", reg[exp.value], loop_num);
            traverseStmtOp(root->RightC);
            gen("  j loop_%d", loop_num);
            gen("loop_%d_end:", loop_num);
            loop_num++;
            break;
        default:
            break;
    }
}

// traverse nodes for FormalParameterList, i.e., nodes with NodeOpType = R/VArgTypeOp
// **RETURN: # of args**
int traverseMethodArgs(tree root){
    int argc = 0, nSymIdx = 0, offset = 12;
    tree arg = NULL;
    while(!IsNull(root)){
        argc++;
        arg = root->LeftC;
        nSymIdx = insertAndConvertToSymbol(&(arg->LeftC));
        SetAttr(nSymIdx, KIND_ATTR, (root->NodeOpType==VArgTypeOp?VALUE_ARG:REF_ARG));
        SetAttr(nSymIdx, TYPE_ATTR, (uintptr_t)arg->RightC);
        SetAttr(nSymIdx, OFFSET_ATTR, offset);
        offset += 4;
        root = root->RightC;
    }
    return argc;
}

// process a node for Block
void processBlock(tree root){
    traverseBodyOp(root->LeftC);
    traverseStmtOp(root->RightC);
}

// process a node for MethodDecl, i.e., NodeOpType = MethodOp
void processMethodDeclOp(tree root){

    tree head = root->LeftC,
        return_type = head->RightC->RightC;
    // IDNode
    int nSymIdx = insertAndConvertToSymbol(&(head->LeftC));
    
    uintptr_t kind = (IsNull(return_type))?PROCE:FUNC;
    SetAttr(nSymIdx, KIND_ATTR, kind);  
    gen_func_head(nSymIdx);
    SetAttr(nSymIdx, TREE_ATTR, (uintptr_t)root->RightC);
    if (!IsNull(return_type)){
        SetAttr(nSymIdx, TYPE_ATTR, (uintptr_t)return_type);
        // Return Type
        processTypeId(return_type);
    }
    // Args
    OpenBlock();
    // is_local = 1;
    signed int global_offset = offset,
        argc = traverseMethodArgs(head->RightC->LeftC);
    offset = 0;
    SetAttr(nSymIdx, ARGNUM_ATTR, argc);
    // Body
    processBlock(root->RightC);
    CloseBlock();
    offset = global_offset;
    // is_local = 0;
    
    gen_func_tail(nSymIdx);
};

// process a node for TypeId / Type, i.e., NodeOpType = TypeIdOp
// **SETS:  type_decl, the declared type of the variable, 0 if INT, non-zero if is an object.
// **RETURN: # of dimensions (for array)**
int processTypeId(tree root){
    int nSymIdx = 0, dim = 0;
    
    if (root->LeftC->NodeKind == IDNode)
        nSymIdx = LookUp(root->LeftC->IntVal);
    if (nSymIdx != 0){
        free(root->LeftC);
        root->LeftC = MakeLeaf(STNode, nSymIdx);
        type_decl = nSymIdx;
    }
    root = root->RightC; 
    while(!IsNull(root)){
        if (root->NodeOpType == FieldOp){
            processTypeId(root->LeftC);
        }
        else{
            root = root->RightC;
            dim++;
        }
    }
    return dim;
}

// process a node for a single variable's declaration
// **SETS:  offset, the beginning offset of current variable.
void processVarDecl(tree root){
    tree id = root->LeftC, 
        type = root->RightC->LeftC,
        var_init = root->RightC->RightC;
    // id
    int nSymIdx = insertAndConvertToSymbol(&(root->LeftC));
    SetAttr(nSymIdx, TYPE_ATTR, (uintptr_t)type);
    // typeid
    type_decl = 0;
    int n_dims = processTypeId(type), // this process will set type_decl.
        length = 0, size = 0;
    if (n_dims){
        SetAttr(nSymIdx, KIND_ATTR, ARR);
        SetAttr(nSymIdx, DIMEN_ATTR, n_dims);
    } else
        SetAttr(nSymIdx, KIND_ATTR, VAR);
    gen_label(nSymIdx);
    if (type_decl){
        length = GetAttr(type_decl, OFFSET_ATTR);
        int i = 0;
        for (;i<top;i++)
            if (class_stack[i].nSymIdx==type_decl)
                break;
        gen_object(class_stack[i].decl);
    }
    else{ // var_init
        size = processVarInit(var_init);
        length = size * 4;
    }
    SetAttr(nSymIdx, OFFSET_ATTR, is_local?offset-length:offset);
    offset += length * (is_local?-1:1);

    if (init_type == STRING){
        error_msg(STRING_ASSIGN, CONTINUE, GetAttr(nSymIdx, NAME_ATTR), 0);
    }
}

// traverse FieldDecl, i.e., nodes with NodeOpType = DeclOp
void traverseDeclOp(tree root){
    if (IsNull(root)) return;
    traverseDeclOp(root->LeftC);
    processVarDecl(root->RightC);
}

// traverse StmtList, i.e., nodes with NodeOpType = StmtOp
void traverseStmtOp(tree root){
    if(IsNull(root)) return;
    traverseStmtOp(root->LeftC);
    processStmt(root->RightC);
}

// traverse ClassBody and Decls, i.e., nodes with NodeOpType = StmtOp
// **SETS:  class_stack[top].decl, the tree pointer pointing to the whole subtree of all declarations in class.
//          top, the top of the class_stack
void traverseBodyOp(tree root){ 
    // NEED TO RECURSIVELY CALL ITSELF TO GET THE RIGHT ORDER!
    if(IsNull(root)) return;

    traverseBodyOp(root->LeftC);

    tree rightC = root->RightC;
    switch(rightC->NodeOpType){
        case MethodOp: 
            gen(".text");
            processMethodDeclOp(rightC); 
            break;
        case DeclOp: 
            if (!is_local) 
                class_stack[top].decl=root;
            traverseDeclOp(rightC);
            break;
        case StmtOp: 
            traverseStmtOp(rightC); 
            break;
    }

}

// process a node for ClassDecl, i.e., NodeOpType = ClassDefOp
// **SETS:  field_base, the (default) base class we are in currently.
//          class_stack[top].nSymIdx, the class's index in symbol table.
//          top, the top of the class_stack
void processClassDefOp(tree root){
    int nSymIdx = insertAndConvertToSymbol(&(root->RightC));
    class_stack[top].nSymIdx = nSymIdx;
    field_base = nSymIdx;
    SetAttr(nSymIdx, KIND_ATTR, CLASS);
    gen("# %s BEGINS", str_table + GetAttr( nSymIdx, NAME_ATTR) );
    gen(".data");

    gen_label(nSymIdx);
    offset = 0;
    OpenBlock();
    traverseBodyOp(root->LeftC);
    top++;
    CloseBlock();
    // You can use offset for class as the length
    SetAttr(nSymIdx, OFFSET_ATTR, offset);
    gen("# %s ENDS", str_table + GetAttr( nSymIdx, NAME_ATTR));
    field_base = 0;
}

// traverse ClassDecl, i.e., nodes with NodeOpType = ClassOp
void traverse(tree root) {
    // NEED TO RECURSIVELY CALL ITSELF TO GET THE RIGHT ORDER!
    if(IsNull(root)) return;
    traverse(root->LeftC);
    processClassDefOp(root->RightC);
}

void do_semantic(tree parseTree) {
    gen(".data");
    for(int i=0;i<num_string;i++){
        gen("S%d: .asciiz \"%s\"", string_table[i], str_table+string_table[i]);
    }
    gen(".text");
    gen(".globl main");
    STInit();           		// Initialize the symbol table
    free(parseTree->RightC);
    parseTree->RightC = Dummy();
    traverse(parseTree->LeftC);     // Traverse tree
    STPrint();          		// Print the symbol table
}
