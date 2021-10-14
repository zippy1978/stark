%language "c++"
%locations

//%parse-param { stark::ASTBlock *programBlock }
//%lex-param { stark::ASTBlock *programBlock }

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
    stark::ASTFunctionSignature *func_signature;
    stark::ASTVariableDeclaration *var_decl;
    std::vector<stark::ASTVariableDeclaration*> *varvec;
    std::vector<stark::ASTExpression*> *exprvec;
    std::vector<stark::ASTIdentifier*> *identvec;
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
%token LBRACKET RBRACKET EMPTYBRACKETS
%token COMMA
%token COLON
%token DOT
%token ARROW
%token FUNC EXTERN RETURN STRUCT DECLARE
%token PLUS MINUS MUL DIV OR AND
%token TRUE FALSE
%token COMP_EQ COMP_NE COMP_LT COMP_LE COMP_GT COMP_GE
%token IF ELSE
%token WHILE
%token AS
%token MODULE IMPORT
%token NULL_VALUE

%type <ident> ident
%type <func_signature> func_signature
%type <identvec> chained_ident
%type <expr> numeric expr str comparison array type_conversion null_value anon_func
%type <block> program stmts block
%type <stmt> stmt var_decl func_def struct_decl extern_decl if_else_stmt while_stmt func_decl module_decl module_import return_stmt
%type <varvec> decl_args
%type <exprvec> expr_args
%type <identvec> ident_args

/* Operator precedence */
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
            $$->addStatement($<stmt>1); 
      }
| 
      stmts stmt 
      { 
            $1->addStatement($<stmt>2); 
      }
;

stmt: 
      var_decl
|
      module_decl
|
      module_import
| 
      func_def
|
      struct_decl
| 
      extern_decl
|
      func_decl
| 
      expr 
      { 
            $$ = new stark::ASTExpressionStatement($1);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      if_else_stmt
|
      while_stmt
|
      return_stmt
;

return_stmt:
      RETURN expr 
      { 
            $$ = new stark::ASTReturnStatement($2);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
;

while_stmt:
      WHILE expr block
      {
            $$ = new stark::ASTWhileStatement($2, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
;

if_else_stmt:
      IF expr block
      {
            $$ = new stark::ASTIfElseStatement($2, $3, nullptr);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      IF expr block ELSE block
      {
            $$ = new stark::ASTIfElseStatement($2, $3, $5);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
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
     ident COLON ident EMPTYBRACKETS
      { 
            $3->setArray(true);
            $$ = new stark::ASTVariableDeclaration($3, $1, nullptr);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
| 
      ident COLON ident EMPTYBRACKETS EQUAL expr 
      { 
            $3->setArray(true);
            $$ = new stark::ASTVariableDeclaration($3, $1, $6);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
| 
      ident COLON ident 
      { 
            $$ = new stark::ASTVariableDeclaration($3, $1, nullptr);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      ident COLON func_signature 
      {
            $$ = new stark::ASTVariableDeclaration(nullptr, $3, $1, nullptr);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
| 
      ident COLON LPAREN func_signature RPAREN EMPTYBRACKETS
      {
            $4->setArray(true);
            $$ = new stark::ASTVariableDeclaration(nullptr, $4, $1, nullptr);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
| 
      ident COLON func_signature EQUAL expr
      {
            $$ = new stark::ASTVariableDeclaration(nullptr, $3, $1, $5);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
| 
      ident COLON LPAREN func_signature RPAREN EMPTYBRACKETS EQUAL expr
      {
            $4->setArray(true);
            $$ = new stark::ASTVariableDeclaration(nullptr, $4, $1, $8);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
| 
      ident COLON ident EQUAL expr 
      { 
            $$ = new stark::ASTVariableDeclaration($3, $1, $5);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      ident COLON EQUAL expr 
      { 
            $$ = new stark::ASTVariableDeclaration(nullptr, $1, $4);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
;

extern_decl:
      EXTERN ident LPAREN decl_args RPAREN ARROW ident
      { 
            $$ = new stark::ASTFunctionDeclaration($7, $2, *$4, true); 
            delete $4;
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      EXTERN ident LPAREN decl_args RPAREN
      { 
            $$ = new stark::ASTFunctionDeclaration(nullptr, $2, *$4, true); 
            delete $4;
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      EXTERN ident LPAREN decl_args RPAREN ARROW ident EMPTYBRACKETS
      { 
            $7->setArray(true);
            $$ = new stark::ASTFunctionDeclaration($7, $2, *$4, true);
            delete $4;
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
;

module_import:
      IMPORT ident
      {
            $$ = new stark::ASTImportDeclaration($2); 
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
;

module_decl:
      MODULE ident
      { 
            $$ = new stark::ASTModuleDeclaration($2); 
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
;

func_decl:
      DECLARE ident LPAREN decl_args RPAREN ARROW ident
      { 
            $$ = new stark::ASTFunctionDeclaration($7, $2, *$4);
            delete $4;
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      DECLARE ident LPAREN decl_args RPAREN
      { 
            $$ = new stark::ASTFunctionDeclaration(nullptr, $2, *$4);
            delete $4;
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      DECLARE ident LPAREN decl_args RPAREN ARROW ident EMPTYBRACKETS
      { 
            $7->setArray(true);
            $$ = new stark::ASTFunctionDeclaration($7, $2, *$4);
            delete $4;
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
;

func_def: 
      FUNC ident LPAREN decl_args RPAREN ARROW ident block
      { 
            $$ = new stark::ASTFunctionDefinition($7, $2, *$4, $8);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $4; 
      }
|
      FUNC ident LPAREN decl_args RPAREN block
      { 
            $$ = new stark::ASTFunctionDefinition(nullptr, $2, *$4, $6);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $4; 
      }
|
      FUNC ident LPAREN decl_args RPAREN ARROW ident EMPTYBRACKETS block
      { 
            $7->setArray(true);
            $$ = new stark::ASTFunctionDefinition($7, $2, *$4, $9);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $4; 
      }
;
    
decl_args: 
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
      decl_args COMMA var_decl 
      { 
            $1->push_back($<var_decl>3); 
      }
;

struct_decl:
      STRUCT ident LBRACE decl_args RBRACE
      { 
            $$ = new stark::ASTStructDeclaration($2, *$4);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $4; 
      }
|
      STRUCT ident
      { 
            stark::ASTVariableList arguments; // Empty arguments
            $$ = new stark::ASTStructDeclaration($2, arguments);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
;

func_signature: 
      FUNC LPAREN ident_args RPAREN ARROW ident
      {
            $$ = new stark::ASTFunctionSignature($6, *$3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      FUNC LPAREN ident_args RPAREN ARROW ident EMPTYBRACKETS
      {
            $6->setArray(true);
            $$ = new stark::ASTFunctionSignature($6, *$3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      LPAREN ident_args RPAREN ARROW ident
      {
            $$ = new stark::ASTFunctionSignature($5, *$2);
            $$->setClosure(true);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      LPAREN ident_args RPAREN ARROW ident EMPTYBRACKETS
      {
            $5->setArray(true);
            $$ = new stark::ASTFunctionSignature($5, *$2);
            $$->setClosure(true);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
;

ident: 
      IDENTIFIER 
      { 
            $$ = new stark::ASTIdentifier(*$1, nullptr, nullptr);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $1; 
      }
|
      IDENTIFIER DOT chained_ident
      {
            $$ = new stark::ASTIdentifier(*$1, nullptr, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $1;
            delete $3;
      }
|
      IDENTIFIER LBRACKET expr RBRACKET
      {
            $$ = new stark::ASTIdentifier(*$1, $3, nullptr);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $1; 
      }
|
      IDENTIFIER LBRACKET expr RBRACKET DOT chained_ident
      {
            $$ = new stark::ASTIdentifier(*$1, $3, $6);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $1; 
            delete $6;
      }

;

chained_ident:
      /*blank*/  
      { 
            $$ = new stark::ASTIdentifierList(); 
      }
| 
      ident 
      { 
            $$ = new stark::ASTIdentifierList(); 
            $$->push_back($1); 
      }
| 
      chained_ident DOT ident  
      {
            $1->push_back($3); 
      }


;

str:
      STRING
      {
            $$ = new stark::ASTString(*$1);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $1; 
      }
;

null_value:
      NULL_VALUE
      {
            $$ = new stark::ASTNull();
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }

array:
      LBRACKET expr_args RBRACKET
      {

            $$ = new stark::ASTArray(*$2);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $2; 
      }
;

numeric: 
      TRUE 
      { 
            $$ = new stark::ASTBoolean(true);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
| 
      FALSE 
      { 
            $$ = new stark::ASTBoolean(false);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
| 
      INTEGER 
      { 
            $$ = new stark::ASTInteger(atol($1->c_str()));
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $1; 
      }
| 
      MINUS INTEGER 
      { 
            $$ = new stark::ASTInteger(-atol($2->c_str()));
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $2; 
      }
| 
      DOUBLE 
      { 
            $$ = new stark::ASTDouble(atof($1->c_str()));
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $1; 
      }
| 
      MINUS DOUBLE 
      { 
            $$ = new stark::ASTDouble(-atof($2->c_str()));
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $2; 
      }
;

type_conversion:
      expr AS ident
      {
            $$ = new stark::ASTTypeConversion($1, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
;

comparison:
      expr COMP_EQ expr 
      { 
            $$ = new stark::ASTComparison($1, stark::EQ, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|     
      expr COMP_NE expr 
      { 
            $$ = new stark::ASTComparison($1, stark::NE, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      expr COMP_LT expr 
      { 
            $$ = new stark::ASTComparison($1, stark::LT, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      expr COMP_LE expr 
      { 
            $$ = new stark::ASTComparison($1, stark::LE, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      expr COMP_GT expr 
      { 
            $$ = new stark::ASTComparison($1, stark::GT, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      expr COMP_GE expr 
      { 
            $$ = new stark::ASTComparison($1, stark::GE, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
;

anon_func:
      FUNC LPAREN decl_args RPAREN ARROW ident block
      { 
            $$ = new stark::ASTAnonymousFunction($6, *$3, $7);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $3; 
      } 
|
      FUNC LPAREN decl_args RPAREN ARROW ident EMPTYBRACKETS block
      { 
            $6->setArray(true);
            $$ = new stark::ASTAnonymousFunction($6, *$3, $8);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $3; 
      } 
|
      FUNC LPAREN decl_args RPAREN block
      { 
            $$ = new stark::ASTAnonymousFunction(nullptr, *$3, $5);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
            delete $3; 
      }
;
    
expr: 
      ident EQUAL expr 
      { 
            $$ = new stark::ASTAssignment($<ident>1, $3); 
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
| 
      ident 
      { 
            $<ident>$ = $1; 
      }
|
      ident LPAREN expr_args RPAREN 
      { 
            $$ = new stark::ASTFunctionCall($1, *$3);
            delete $3;
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|
      array
| 
      numeric
| 
      str
|
      null_value
|
      comparison
|
      type_conversion
|     
      anon_func
|
      expr MUL expr 
      { 
            $$ = new stark::ASTBinaryOperation($1, stark::MUL, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
| 
      expr DIV expr 
      { 
            $$ = new stark::ASTBinaryOperation($1, stark::DIV, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|     
      expr PLUS expr 
      { 
            $$ = new stark::ASTBinaryOperation($1, stark::ADD, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
| 
      expr MINUS expr 
      { 
            $$ = new stark::ASTBinaryOperation($1, stark::SUB, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|    
      expr AND expr 
      { 
            $$ = new stark::ASTBinaryOperation($1, stark::AND, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|    
      expr OR expr 
      { 
            $$ = new stark::ASTBinaryOperation($1, stark::OR, $3);
            $$->location.line = @1.begin.line;
            $$->location.column = @1.begin.column;
      }
|     
      LPAREN expr RPAREN 
      { 
            $$ = $2; 
      }
;

expr_args: 
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
      expr_args COMMA expr  
      {
            $1->push_back($3); 
      }
;

ident_args: 
      /*blank*/  
      { 
            $$ = new stark::ASTIdentifierList(); 
      }
| 
      ident 
      { 
            $$ = new stark::ASTIdentifierList(); 
            $$->push_back($1); 
      }
| 
      ident EMPTYBRACKETS
      { 
            $$ = new stark::ASTIdentifierList(); 
            $1->setArray(true);
            $$->push_back($1); 
      }
| 
      ident_args COMMA ident  
      {
            $1->push_back($3); 
      }
;

%%