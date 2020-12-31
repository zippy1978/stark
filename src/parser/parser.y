%language "c++"
%locations

%code top {
      #include "../ast/AST.h"
      ASTBlock *programBlock;
}

%code provides {
      int yylex(yy::parser::semantic_type* yylval, yy::parser::location_type* yylloc);
}

%union {
    ASTNode *node;
    ASTBlock *block;
    ASTExpression *expr;
    ASTStatement *stmt;
    ASTIdentifier *ident;
    ASTVariableDeclaration *var_decl;
    std::vector<ASTVariableDeclaration*> *varvec;
    std::vector<ASTExpression*> *exprvec;
    std::string *string;
    int token;
}

%token <string> IDENTIFIER 
%token <string> INTEGER 
%token <string> DOUBLE
%token <string> STRING
%token EQUAL
%token LPAREN RPAREN
%token LBRACE RBRACE
%token COMMA
%token COLON
%token FUNC EXTERN RETURN
%token PLUS MINUS MUL DIV OR AND
%token TRUE FALSE
%token COMP_EQ COMP_NE COMP_LT COMP_LE COMP_GT COMP_GE
%token IF ELSE

%type <ident> ident
%type <expr> numeric expr str comparison
%type <block> program stmts block
%type <stmt> stmt var_decl func_decl extern_decl
%type <varvec> func_decl_args
%type <exprvec> call_args

/* Operator precedence for mathematical operators */
%left PLUS MINUS MUL DIV OR AND
%left COMP_EQ COMP_NE COMP_LT COMP_LE COMP_GT COMP_GE

%start program

%%

program : 
      stmts 
      {
            programBlock = $1; 
      }
;
        
stmts : 
      stmt 
      { 
            $$ = new ASTBlock(); 
            $$->statements.push_back($<stmt>1); 
      }
| 
      stmts stmt 
      { 
            $1->statements.push_back($<stmt>2); 
      }
;

stmt : 
      var_decl
| 
      func_decl
| 
      extern_decl
| 
      expr 
      { 
            $$ = new ASTExpressionStatement(*$1); 
      }
;

block : 
      LBRACE stmts RBRACE 
      { 
            $$ = $2; 
      }
|     
      LBRACE RBRACE { $$ = new ASTBlock(); }
;

var_decl : 
      ident COLON ident 
      { 
            $$ = new ASTVariableDeclaration(*$3, *$1, NULL); 
      }
| 
      ident COLON ident EQUAL expr 
      { 
            $$ = new ASTVariableDeclaration(*$3, *$1, $5); 
      }
|
      RETURN expr 
      { 
            $$ = new ASTReturnStatement(*$2); 
      }
;

extern_decl :
      EXTERN ident LPAREN func_decl_args RPAREN COLON ident
      { 
            $$ = new ASTExternDeclaration(*$7, *$2, *$4); delete $4; 
      }
;

func_decl : 
      FUNC ident LPAREN func_decl_args RPAREN COLON ident block
      { 
            $$ = new ASTFunctionDeclaration(*$7, *$2, *$4, *$8); 
            delete $4; 
      }
;
    
func_decl_args : 
      /*blank*/  
      { 
            $$ = new ASTVariableList(); 
      }
| 
      var_decl 
      { 
            $$ = new ASTVariableList(); 
            $$->push_back($<var_decl>1); 
      }
| 
      func_decl_args COMMA var_decl 
      { 
            $1->push_back($<var_decl>3); 
      }
;

ident : 
      IDENTIFIER 
      { 
            $$ = new ASTIdentifier(*$1); 
            delete $1; 
      }
;

str :
      STRING
      {
            $$ = new ASTString(*$1);
            delete $1; 
      }
;

numeric : 
      TRUE 
      { 
            $$ = new ASTBoolean(true);
      }
| 
      FALSE 
      { 
            $$ = new ASTBoolean(false);
      }
| 
      INTEGER 
      { 
            $$ = new ASTInteger(atol($1->c_str()));
            delete $1; 
      }
| 
      MINUS INTEGER 
      { 
            $$ = new ASTInteger(-atol($2->c_str()));
            delete $2; 
      }
| 
      DOUBLE 
      { 
            $$ = new ASTDouble(atof($1->c_str())); 
            delete $1; 
      }
| 
      MINUS DOUBLE 
      { 
            $$ = new ASTDouble(-atof($2->c_str())); 
            delete $2; 
      }
;

comparison :
      expr COMP_EQ expr 
      { 
            $$ = new ASTComparison(*$1, EQ, *$3); 
      }
|     
      expr COMP_NE expr 
      { 
            $$ = new ASTComparison(*$1, NE, *$3); 
      }
|
      expr COMP_LT expr 
      { 
            $$ = new ASTComparison(*$1, LT, *$3);
      }
|
      expr COMP_LE expr 
      { 
            $$ = new ASTComparison(*$1, LE, *$3);
      }
|
      expr COMP_GT expr 
      { 
            $$ = new ASTComparison(*$1, GT, *$3);
      }
|
      expr COMP_GE expr 
      { 
            $$ = new ASTComparison(*$1, GE, *$3);
      }
;
    
expr : 
      ident EQUAL expr 
      { 
            $$ = new ASTAssignment(*$<ident>1, *$3); 
      }
| 
      ident 
      { 
            $<ident>$ = $1; 
      }
|
      ident LPAREN call_args RPAREN 
      { 
            $$ = new ASTMethodCall(*$1, *$3); 
            delete $3; 
      }
| 
      numeric
| 
      str
|
      comparison
|     
      expr MUL expr 
      { 
            $$ = new ASTBinaryOperator(*$1, MUL, *$3); 
      }
| 
      expr DIV expr 
      { 
            $$ = new ASTBinaryOperator(*$1, DIV, *$3); 
      }
|     
      expr PLUS expr 
      { 
            $$ = new ASTBinaryOperator(*$1, ADD, *$3); 
      }
| 
      expr MINUS expr 
      { 
            $$ = new ASTBinaryOperator(*$1, SUB, *$3); 
      }
|    
      expr AND expr 
      { 
            $$ = new ASTBinaryOperator(*$1, AND, *$3); 
      }
|    
      expr OR expr 
      { 
            $$ = new ASTBinaryOperator(*$1, OR, *$3); 
      }
|     
      LPAREN expr RPAREN 
      { 
            $$ = $2; 
      }
;

call_args : 
      /*blank*/  
      { 
            $$ = new ASTExpressionList(); 
      }
| 
      expr 
      { 
            $$ = new ASTExpressionList(); 
            $$->push_back($1); 
      }
| 
      call_args COMMA expr  
      {
            $1->push_back($3); 
      }
;

%%