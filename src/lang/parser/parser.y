%language "c++"
%locations

%code top {
      #include "../ast/AST.h"
      stark::ASTBlock *programBlock;
}

%code provides {
      int yylex(yy::parser::semantic_type* yylval, yy::parser::location_type* yylloc);
}

%union {
    stark::ASTNode *node;
    stark::ASTBlock *block;
    stark::ASTExpression *expr;
    stark::ASTStatement *stmt;
    stark::ASTIdentifier *ident;
    stark::ASTVariableDeclaration *var_decl;
    std::vector<stark::ASTVariableDeclaration*> *varvec;
    std::vector<stark::ASTExpression*> *exprvec;
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
%token WHILE

%type <ident> ident
%type <expr> numeric expr str comparison
%type <block> program stmts block
%type <stmt> stmt var_decl func_decl extern_decl if_else_stmt while_stmt
%type <varvec> func_decl_args
%type <exprvec> call_args

/* Operator precedence for mathematical operators */
%left PLUS MINUS MUL DIV OR AND
%left COMP_EQ COMP_NE COMP_LT COMP_LE COMP_GT COMP_GE

%start program

%%

program: 
      stmts 
      {
            programBlock = $1; 
      }
;
        
stmts: 
      stmt 
      { 
            $$ = new stark::ASTBlock(); 
            $$->statements.push_back($<stmt>1); 
      }
| 
      stmts stmt 
      { 
            $1->statements.push_back($<stmt>2); 
      }
;

stmt: 
      var_decl
| 
      func_decl
| 
      extern_decl
| 
      expr 
      { 
            $$ = new stark::ASTExpressionStatement(*$1); 
      }
|
      if_else_stmt
|
      while_stmt
;

while_stmt:
      WHILE expr block
      {
            $$ = new stark::ASTWhileStatement(*$2, *$3); 
      }

if_else_stmt:
      IF expr block
      {
            $$ = new stark::ASTIfElseStatement(*$2, *$3, NULL); 
      }
|
      IF expr block ELSE block
      {
            $$ = new stark::ASTIfElseStatement(*$2, *$3, $5); 
      }
;

block: 
      LBRACE stmts RBRACE 
      { 
            $$ = $2; 
      }
|     
      LBRACE RBRACE { $$ = new stark::ASTBlock(); }
;

var_decl: 
      ident COLON ident 
      { 
            $$ = new stark::ASTVariableDeclaration(*$3, *$1, NULL); 
      }
| 
      ident COLON ident EQUAL expr 
      { 
            $$ = new stark::ASTVariableDeclaration(*$3, *$1, $5); 
      }
|
      RETURN expr 
      { 
            $$ = new stark::ASTReturnStatement(*$2); 
      }
;

extern_decl:
      EXTERN ident LPAREN func_decl_args RPAREN COLON ident
      { 
            $$ = new stark::ASTExternDeclaration(*$7, *$2, *$4); delete $4; 
      }
;

func_decl: 
      FUNC ident LPAREN func_decl_args RPAREN COLON ident block
      { 
            $$ = new stark::ASTFunctionDeclaration(*$7, *$2, *$4, *$8); 
            delete $4; 
      }
;
    
func_decl_args: 
      /*blank*/  
      { 
            $$ = new stark::ASTVariableList(); 
      }
| 
      var_decl 
      { 
            $$ = new stark::ASTVariableList(); 
            $$->push_back($<var_decl>1); 
      }
| 
      func_decl_args COMMA var_decl 
      { 
            $1->push_back($<var_decl>3); 
      }
;

ident: 
      IDENTIFIER 
      { 
            $$ = new stark::ASTIdentifier(*$1); 
            delete $1; 
      }
;

str:
      STRING
      {
            $$ = new stark::ASTString(*$1);
            delete $1; 
      }
;

numeric: 
      TRUE 
      { 
            $$ = new stark::ASTBoolean(true);
      }
| 
      FALSE 
      { 
            $$ = new stark::ASTBoolean(false);
      }
| 
      INTEGER 
      { 
            $$ = new stark::ASTInteger(atol($1->c_str()));
            delete $1; 
      }
| 
      MINUS INTEGER 
      { 
            $$ = new stark::ASTInteger(-atol($2->c_str()));
            delete $2; 
      }
| 
      DOUBLE 
      { 
            $$ = new stark::ASTDouble(atof($1->c_str())); 
            delete $1; 
      }
| 
      MINUS DOUBLE 
      { 
            $$ = new stark::ASTDouble(-atof($2->c_str())); 
            delete $2; 
      }
;

comparison:
      expr COMP_EQ expr 
      { 
            $$ = new stark::ASTComparison(*$1, stark::EQ, *$3); 
      }
|     
      expr COMP_NE expr 
      { 
            $$ = new stark::ASTComparison(*$1, stark::NE, *$3); 
      }
|
      expr COMP_LT expr 
      { 
            $$ = new stark::ASTComparison(*$1, stark::LT, *$3);
      }
|
      expr COMP_LE expr 
      { 
            $$ = new stark::ASTComparison(*$1, stark::LE, *$3);
      }
|
      expr COMP_GT expr 
      { 
            $$ = new stark::ASTComparison(*$1, stark::GT, *$3);
      }
|
      expr COMP_GE expr 
      { 
            $$ = new stark::ASTComparison(*$1, stark::GE, *$3);
      }
;
    
expr: 
      ident EQUAL expr 
      { 
            $$ = new stark::ASTAssignment(*$<ident>1, *$3); 
      }
| 
      ident 
      { 
            $<ident>$ = $1; 
      }
|
      ident LPAREN call_args RPAREN 
      { 
            $$ = new stark::ASTMethodCall(*$1, *$3); 
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
            $$ = new stark::ASTBinaryOperator(*$1, stark::MUL, *$3); 
      }
| 
      expr DIV expr 
      { 
            $$ = new stark::ASTBinaryOperator(*$1, stark::DIV, *$3); 
      }
|     
      expr PLUS expr 
      { 
            $$ = new stark::ASTBinaryOperator(*$1, stark::ADD, *$3); 
      }
| 
      expr MINUS expr 
      { 
            $$ = new stark::ASTBinaryOperator(*$1, stark::SUB, *$3); 
      }
|    
      expr AND expr 
      { 
            $$ = new stark::ASTBinaryOperator(*$1, stark::AND, *$3); 
      }
|    
      expr OR expr 
      { 
            $$ = new stark::ASTBinaryOperator(*$1, stark::OR, *$3); 
      }
|     
      LPAREN expr RPAREN 
      { 
            $$ = $2; 
      }
;

call_args: 
      /*blank*/  
      { 
            $$ = new stark::ASTExpressionList(); 
      }
| 
      expr 
      { 
            $$ = new stark::ASTExpressionList(); 
            $$->push_back($1); 
      }
| 
      call_args COMMA expr  
      {
            $1->push_back($3); 
      }
;

%%