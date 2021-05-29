%{ 
/*###########################################################*/
/*#INCLUDES, VARIABLES and other DEFINITIONS*/
/*###########################################################*/
    #include "proj2.h"
    #include "proj3.h"
    #include <stdio.h>
	#include <unistd.h>
    #define RIGHT 	1
    #define LEFT	-1

    extern FILE* yyin;						// input file stream
    extern int yycolno, yylineno, yyleng;	// lexer variables 
	extern int yylexver;
    FILE *treelst;							// output file stream
	extern char assembly[];

	int argType = 0;
    tree typeIdPtr;					// the pointer to latest TypeId Node
    tree parseTree;                 // the pointer to PARSE TREE

    tree (*Dummy)(void) = NullExp;	// Renaming dummy address getter.

    void yyerror(char *str) ;		
    int yylex();
    int main() ;
    tree* find_mostLeaf(tree* T, int direction);// Finds LEFTmost or RIGHTmost leaf.
    extern void do_semantic(tree);  // DO SEMANTIC ANALYSIS!
	extern int (*clean_yy_mem)();
%}
/*###########################################################*/
/*TOKENS, NON-TERMINALS, Precedence & Associativity*/
/*###########################################################*/
// TERMINALS, i.e. TOKENS
%token <intg> ANDnum ASSGNnum DECLARATIONSnum DOTnum ENDDECLARATIONSnum 
%token <intg> EQUALnum GTnum IDnum INTnum LBRACnum 
%token <intg> LPARENnum METHODnum NEnum ORnum PROGRAMnum 
%token <intg> RBRACnum RPARENnum SEMInum VALnum WHILEnum 
%token <intg> CLASSnum COMMAnum DIVIDEnum ELSEnum EQnum 
%token <intg> GEnum ICONSTnum IFnum LBRACEnum LEnum 
%token <intg> LTnum MINUSnum NOTnum PLUSnum RBRACEnum 
%token <intg> RETURNnum SCONSTnum TIMESnum VOIDnum LESS_PREC

// NON-TERMINALS
%type <tptr> Program ID ClassDecl ClassDecls
%type <tptr> Body Decl Decl_MethodDecls FieldDecls FieldDecl
%type <tptr> TypeId VarDeclID VarDecls VarDecl VarInit
%type <tptr> BracPairs Type UnsignedConst Select
%type <tptr> Expr Exprs Factor MethodCallStmt SimpleExpr
%type <tptr> Term UnsignedSimpleExpr Var ArrayInit ArrayCreation
%type <tptr> VarInits Bound MethodDecl FormalParameterList Block 
%type <tptr> StmtList Stmts Stmt AssignStmt ReturnStmt 
%type <tptr> WhileStmt IfStmt Specs INTIDs Index 
%type <tptr> Field IfElseOps IfElseStmt ArgType

// Associativity of tokens
%right EQUALnum
%left ORnum
%left ANDnum 
%left GTnum LTnum LEnum GEnum EQnum NEnum
%left PLUSnum MINUSnum
%left TIMESnum DIVIDEnum
%left NOTnum 
%left DOTnum COMMAnum

%% 
/*###########################################################*/
/* PRODUCTION RULES */
/*###########################################################*/

/* ==========================NOTICE!=========================
Yacc will set a DEFAULT RULE {$$ = $1;} for a non-null production if no action specified!
This feature is utilized below to save time and avoid programmer errors.
=============================================================*/

Program : 	PROGRAMnum ID SEMInum ClassDecls
				{ 	
					$$ = MakeTree(ProgramOp, $4, $2); 
                    parseTree = $$;
				}
        	;

ClassDecls: ClassDecls ClassDecl 			{ $$ = MakeTree(ClassOp, $1, $2);}
			| ClassDecl 					{ $$ = MakeTree(ClassOp, Dummy() , $1); }
			;

ClassDecl: 	CLASSnum ID Body 				{ $$ = MakeTree(ClassDefOp, $3, $2);}
			;

Body:		LBRACEnum Decl_MethodDecls RBRACEnum 			{$$ = $2;}
			;
Decl_MethodDecls:
			Decl_MethodDecls MethodDecl		{$$ = MakeTree(BodyOp, $1, $2);}
			|Decl							
			|								{$$ = Dummy();}
			;
Decl:		DECLARATIONSnum FieldDecls ENDDECLARATIONSnum 	{$$ = $2;}
			;

FieldDecls:	FieldDecls FieldDecl 			{$$ = MakeTree(BodyOp, $1, $2);}
			| 								{$$ = Dummy();}
			;

FieldDecl:	TypeId VarDecls SEMInum			{$$ = $2;}
			;

VarDecls:	VarDecls COMMAnum VarDecl 		{$$ = MakeTree(DeclOp, $1, $3);}
			|VarDecl						{$$ = MakeTree(DeclOp, Dummy(), $1);}
			;

VarDecl:	VarDeclID EQUALnum VarInit 
				{
					// Notice here we get the subtree for TypeId from typeIdPtr, which is set by the latest TypeId action.
					// This can be done because we are doing bottom-up parsing.
					tree varInitSection = MakeTree(CommaOp,typeIdPtr,$3);
					// Merge 2 subtrees as children for $$.
					$$ = MakeTree(CommaOp, $1, varInitSection);
					// Feedback info
					//printf("[I] (line %d col %d) Found VarDecl w/INIT, type := %p.\n", yylineno, yycolno - yyleng, typeIdPtr);
				}
			|VarDeclID				
				{	// Basically the same as above, except that we don't have a VarInit subtree this time.
					tree varInitSection = MakeTree(CommaOp,typeIdPtr,Dummy());
					$$ = MakeTree(CommaOp, $1, varInitSection);
					//printf("[I] (line %d col %d) Found VarDecl, type := %p.\n", yylineno, yycolno - yyleng, typeIdPtr);
				}
			;

VarDeclID:	ID BracPairs 					{$$ = $1;}
			;

BracPairs:	LBRACnum RBRACnum BracPairs		{$$ = MakeTree(IndexOp, Dummy(), $3);}
			| 								{$$ = Dummy();}
			;

VarInit:	Expr
			|ArrayInit
			|ArrayCreation 
			;

ArrayInit:	LBRACEnum VarInits RBRACEnum 
				{
					// Get typeId from typeIdPtr
					$$ = MakeTree(ArrayTypeOp, $2, typeIdPtr);
					// Feedback Info.
					//printf("[I] (line %d col %d) Found ArrayInit, type := %p.\n",yylineno, yycolno - yyleng, typeIdPtr);
				}
			;
VarInits:	VarInits COMMAnum VarInit		{$$ = MakeTree(CommaOp, $1, $3);}
			|VarInit						{$$ = MakeTree(CommaOp, Dummy(), $1);}
			;

ArrayCreation:	
			INTnum Bound 					{$$ = MakeTree(ArrayTypeOp, $2, MakeLeaf(INTEGERTNode, 0));}

Bound:		Bound LBRACnum Expr RBRACnum 	{$$ = MakeTree(BoundOp, $1, $3);}
			|LBRACnum Expr RBRACnum			{$$ = MakeTree(BoundOp, Dummy(), $2);}

MethodDecl:	METHODnum VOIDnum ID LPARENnum FormalParameterList RPARENnum Block 
				{
					tree fparam = MakeTree(SpecOp, $5, Dummy()),// subtree for function parameter
						fhead = MakeTree(HeadOp, $3, fparam);	// subtree for function head
					$$ = MakeTree(MethodOp, fhead, $7);			// subtree for whole function
				}
			|METHODnum TypeId ID LPARENnum FormalParameterList RPARENnum Block 
				{
					tree fparam = MakeTree(SpecOp, $5, $2),		// subtree for function parameter
						fhead = MakeTree(HeadOp, $3, fparam);	// subtree for function head
					$$ = MakeTree(MethodOp, fhead, $7);			// subtree for whole function
				}
			;
FormalParameterList:	
			ArgType Specs SEMInum FormalParameterList{$$ = $2; *find_mostLeaf(&$$,RIGHT) = $4; }
			|ArgType Specs							{$$ = $2; }
			|										{$$ = Dummy();}
			;

ArgType:	VALnum	{argType = VArgTypeOp; $$ = Dummy();}
			|		{argType = RArgTypeOp; $$ = Dummy();}

Specs:		INTnum INTIDs					{$$ = $2;}

INTIDs:		ID COMMAnum INTIDs				{$$ = MakeTree(argType, MakeTree(CommaOp, $1, MakeLeaf(INTEGERTNode,0)), $3);}
			|ID								{$$ = MakeTree(argType, MakeTree(CommaOp, $1, MakeLeaf(INTEGERTNode,0)), Dummy());}
			;

Block:		Decl StmtList					{$$ = MakeTree(BodyOp, $1, $2);}
			|StmtList						{$$ = MakeTree(BodyOp, Dummy(), $1);}
			;

TypeId:		Type BracPairs DOTnum TypeId
				{
					// In order to implement the tree as in documentary, we need to put subtree for field and TypeId($4) 
					// at the RIGHTMOST leaf of the Index Ops($2). So first we need to find it...
					tree* ptr = find_mostLeaf(&$2, RIGHT);		
					// Then, we expand that dummy branch to accomodate $4.
					*ptr = MakeTree(FieldOp, $4, Dummy());
					// Here we save the subtree for TypeId ($$) in typeIdPtr, so that following VarInit or ArrayInit can get it. 
					typeIdPtr = $$ = MakeTree(TypeIdOp, $1, $2);
					// Feedback info.
					//printf("[I] (line %d col %d) Found TypeId, typeIdPtr := %p.\n",yylineno, yycolno - yyleng, typeIdPtr);
				}
			|Type BracPairs					
				{
					// Here we save the subtree for TypeId ($$) in typeIdPtr, so that following VarInit or ArrayInit can get it. 
					typeIdPtr = $$ = MakeTree(TypeIdOp, $1, $2);
					// Feedback info.
					//printf("[I] (line %d col %d) Found TypeId, typeIdPtr := %p.\n",yylineno, yycolno - yyleng, typeIdPtr);
				}

Type:		INTnum							{$$ = MakeLeaf(INTEGERTNode, 0);}// LEAF NODE: (keyword) int
			|ID								{$$ = $1;}
			;


			
StmtList:	LBRACEnum Stmts RBRACEnum		{$$ = $2;}

// Stmts = Stmt+ (i.e., one or more Stmt)
Stmts:		Stmts SEMInum Stmt 				{$$ = IsNull($3)?$1:MakeTree(StmtOp, $1, $3);}	// omit null Stmt behind last ';'
			|Stmt  							{$$ = MakeTree(StmtOp, Dummy(), $1);};			// At least one Stmt

Stmt:		AssignStmt
			|MethodCallStmt
			|ReturnStmt
			|IfElseStmt
			|WhileStmt
			|								{$$ = Dummy();}

AssignStmt:	Var ASSGNnum Expr				{$$ = MakeTree(AssignOp, MakeTree(AssignOp, Dummy(), $1), $3);} 

MethodCallStmt:	
			Var LPARENnum Exprs RPARENnum 	{$$ = MakeTree(RoutineCallOp, $1 ,$3);}
			|Var LPARENnum RPARENnum 		{$$ = MakeTree(RoutineCallOp, $1 , Dummy());}

ReturnStmt:	RETURNnum Expr					{$$ = MakeTree(ReturnOp, $2, Dummy());}
			|RETURNnum 						{$$ = MakeTree(ReturnOp, Dummy(), Dummy());}

IfElseStmt:	IfElseOps						
			|IfElseOps ELSEnum StmtList		{$$ = MakeTree(IfElseOp, $1, $3);}

IfElseOps:	IfElseOps ELSEnum IfStmt		{$$ = MakeTree(IfElseOp, $1, $3);}
			|IfStmt							{$$ = MakeTree(IfElseOp, Dummy(), $1);}

IfStmt:		IFnum Expr StmtList 			{$$ = MakeTree(CommaOp, $2, $3);}

WhileStmt:	WHILEnum Expr StmtList			{$$ = MakeTree(LoopOp, $2, $3);}


Expr:		SimpleExpr 
			|SimpleExpr LTnum SimpleExpr 	{$$ = MakeTree(LTOp, $1, $3);}
			|SimpleExpr GTnum SimpleExpr 	{$$ = MakeTree(GTOp, $1, $3);}
			|SimpleExpr EQnum SimpleExpr 	{$$ = MakeTree(EQOp, $1, $3);}
			|SimpleExpr NEnum SimpleExpr 	{$$ = MakeTree(NEOp, $1, $3);}
			|SimpleExpr LEnum SimpleExpr 	{$$ = MakeTree(LEOp, $1, $3);}
			|SimpleExpr GEnum SimpleExpr 	{$$ = MakeTree(GEOp, $1, $3);}
			;

Exprs:		Expr COMMAnum Exprs				{$$ = MakeTree(CommaOp, $1, $3);}
			|Expr							{$$ = MakeTree(CommaOp, $1, Dummy());}
			;

SimpleExpr:	PLUSnum UnsignedSimpleExpr 		{$$ = $2;}
			|MINUSnum UnsignedSimpleExpr 	{$$ = MakeTree(UnaryNegOp, $2, Dummy());}
			|UnsignedSimpleExpr 			{$$ = $1;}
			;

/*Notice the LEFT RECURSION here, it is due to the left associativity of +,-,||.*/
UnsignedSimpleExpr:	
			UnsignedSimpleExpr PLUSnum Term		{$$ = MakeTree(AddOp, $1, $3);}
			|UnsignedSimpleExpr MINUSnum Term	{$$ = MakeTree(SubOp, $1, $3);}
			|UnsignedSimpleExpr ORnum Term		{$$ = MakeTree(OrOp, $1, $3);}
			|Term
			;

/*Notice the LEFT RECURSION here, it is due to the left associativity of *,/,&&.*/
Term:		Term TIMESnum Factor 			{$$ = MakeTree(MultOp, $1, $3);}
			|Term DIVIDEnum Factor 			{$$ = MakeTree(DivOp, $1, $3);}
			|Term ANDnum Factor 			{$$ = MakeTree(AndOp, $1, $3);}
			|Factor
			;

Factor:		UnsignedConst	
			|Var
			|MethodCallStmt
			|LPARENnum Expr RPARENnum		{$$ = $2;}
			|NOTnum Factor					{$$ = MakeTree(NotOp, $2, Dummy());}
			;

// LEAF NODE: Integer constant | String constant
UnsignedConst:	
			ICONSTnum						{$$ = MakeLeaf(NUMNode, yylval.intg);}
			|SCONSTnum						{$$ = MakeLeaf(STRINGNode, yylval.intg);}
			;

Var:		ID Select 						{$$ = MakeTree(VarOp, $1, $2);}
			;

Select:		LBRACnum Index RBRACnum Select 	{$$ = MakeTree(SelectOp, $2, $4);}
			|Field Select 					{$$ = MakeTree(SelectOp, $1, $2);}
			|								{$$ = Dummy();}
			;

Index:		Expr COMMAnum Index				{$$ = MakeTree(IndexOp, $1, $3);}
			|Expr							{$$ = MakeTree(IndexOp, $1, Dummy());}
			;
Field:		DOTnum ID						{$$ = MakeTree(FieldOp, $2, Dummy());}
			;

// LEAF NODE: ID
ID:			IDnum 							{$$ = MakeLeaf(IDNode, yylval.intg); }
			;

%%
int yycolumn, yyline;
FILE *treelst;

tree* find_mostLeaf(tree* Tptr, int direction){
	/*	find leftmost / rightmost leaf of a tree.

		in:		address of the tree to search, and the desired direction
		out: 	address of the node desired
	*/
	while(*Tptr!=NULL && !IsNull(*Tptr)){
		if(direction==LEFT)
			Tptr = &((*Tptr)->LeftC);
		else
			Tptr = &((*Tptr)->RightC);
	}
	return Tptr;
}

int main(int argc, char* argv[]) {
    treelst = stdout;
    yyparse();
	
    do_semantic(parseTree);  // Do semantic analysis

    // printtree(parseTree, 0); // Print the parse tree
	printf("%s", assembly);
    // Here we are deleting the tree, since we shouldn't need it later.
    // (Moreover, not deleting it causes memory leak.)
    // But if it causes any problem, just delete this line.
    deleteTree(&parseTree);	
	// The following function pointer calls "yylex_destroy()" to clean up memory used by flex,
	// which demands flex has version >= 2.5.9.
	// But don't worry, I have added some conditional compiling technique so that 
	// you should have no problem compiling and running even with lower flex version.
	if (clean_yy_mem)
		clean_yy_mem();
}

void yyerror(char *str) { printf("yyerror: '%s' at line %d col %d, next symbol %d\n", str, yylineno, yycolno, yychar); }
