#ifndef _PROJ2_H
#define _PROJ2_H

/* proj2.h */
typedef struct treenode
        {       /* syntax tree node struct */
                int NodeKind, NodeOpType, IntVal;
                struct treenode *LeftC, *RightC;
        } ILTree, *tree;

tree Root;

typedef union
{
  int intg;
  tree tptr;
} YYSTYPE;

#define YYSTYPE_IS_DECLARED

//Uncommented Op is ALU Op by default.
//Also, some Op is never used in my implementation.

#define ProgramOp       100 // program, root node operator
#define BodyOp          101 // class body, method body, decl body, statmentlist body
#define DeclOp          102 // each declaration has this operator 
#define CommaOp         103 // connected by “,”
#define ArrayTypeOp     104 // array type 
#define TypeIdOp        105 // type id operator
#define BoundOp         106 // bound for array variable declaration 
#define RecompOp        107 // 
#define ToOp            108 // 
#define DownToOp        109 //
#define ConstantIdOp    110 //
#define ProceOp         111 //
#define FuncOp          112 //
#define HeadOp          113 // head of method, 
#define RArgTypeOp      114 // arguments 
#define VArgTypeOp      115 // arguments specified by “VAL”, e.g., abc(VAL int x)
#define StmtOp          116 // statement 
#define IfElseOp        117 // if-else-then
#define LoopOp          118 // while statement 
#define SpecOp          119 // specification of parameters 
#define RoutineCallOp   120 // routine call 
#define AssignOp        121 // assign operator 
#define ReturnOp        122 // return statement
#define AddOp           123 //
#define SubOp           124 //
#define MultOp          125 //
#define DivOp           126 //
#define LTOp            127 //
#define GTOp            128 //
#define EQOp            129 //
#define NEOp            130 //
#define LEOp            131 //
#define GEOp            132 //
#define AndOp           133 //
#define OrOp            134 //
#define UnaryNegOp      135 //
#define NotOp           136 //
#define VarOp           137 // variables 
#define SelectOp        138 // to access a field/index variable
#define IndexOp         139 // follow “[]” to access a variable
#define FieldOp         140 // follow “.” To access a variable
#define SubrangeOp      141 //
#define ExitOp          142 //
#define ClassOp         143 // for each class 
#define MethodOp        144 // for each method 
#define ClassDefOp      145 // for each class definition
 
#define IDNode          200 // 
#define NUMNode         201 //
#define CHARNode        202 //
#define STRINGNode      203 //
#define DUMMYNode       204 //
#define EXPRNode        205 //
#define INTEGERTNode	206 //
#define CHARTNode	207 //
#define BOOLEANTNode	208 //
#define STNode		209 //

/* Dummy Node Related*/
tree NullExp();         //Get a new dummy node.
int IsNull(tree T);     //Check if a node T is dummy.

/* Tree Manipulations*/
tree MakeLeaf(int Kind, int Value);
tree MakeTree(int NodeOp, tree left, tree right);
tree MkLeftC(tree child, tree parent);
tree MkRightC(tree child, tree parent);

/*Get actions*/
tree LeftChild(tree);
tree RightChild(tree); 
int NodeKind(tree T);
int NodeOp(tree T);
int NodeKind(tree T);
int IntVal(tree T);

/*Set actions*/
void SetNode(tree, tree);
void SetNodeOp(tree, int NodeOp);
void SetLeftTreeOp(tree, int NodeOp);
void SetRightTreeOp(tree, int NodeOp);
void SetLeftChild(tree parent, tree child);
void SetRightChild(tree parent, tree child); 

/*Tree Printer*/
void printtree (tree nd, int depth);

/*Garbage Collect.*/
void deleteTree(tree* T);

/*Array limits for lexer.*/
#define LIMIT1  500
#define LIMIT2  4096

// for semantic use.
int loc_str(const char* str);


#endif
