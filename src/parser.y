%language "c++"
%locations

%code top {
      #include "ast.hh"
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
%token EQUAL
%token LPAREN RPAREN
%token LBRACE RBRACE
%token COMMA
%token COLON
%token FUNC

%type <ident> ident
%type <expr> numeric expr 
%type <block> program stmts block
%type <stmt> stmt var_decl func_decl
%type <varvec> func_decl_args
%type <exprvec> call_args

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
            $$ = new ASTVariableDeclaration(*$3, *$1); 
      }
| 
      ident COLON ident EQUAL expr 
      { 
            $$ = new ASTVariableDeclaration(*$3, *$1, $5); 
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

numeric : 
      INTEGER 
      { 
            $$ = new ASTInteger(atol($1->c_str()));
            delete $1; 
      }
| 
      DOUBLE 
      { 
            $$ = new ASTDouble(atof($1->c_str())); 
            delete $1; 
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