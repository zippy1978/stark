%language "c++"
%locations

%code top {
      #include "node.hh"
      NBlock *programBlock;
}

%code provides {
      int yylex(yy::parser::semantic_type* yylval, yy::parser::location_type* yylloc);
}

%union {
    Node *node;
    NBlock *block;
    NExpression *expr;
    NStatement *stmt;
    NIdentifier *ident;
    NVariableDeclaration *var_decl;
    std::vector<NVariableDeclaration*> *varvec;
    std::vector<NExpression*> *exprvec;
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
            $$ = new NBlock(); 
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
            $$ = new NExpressionStatement(*$1); 
      }
;

block : 
      LBRACE stmts RBRACE 
      { 
            $$ = $2; 
      }
|     
      LBRACE RBRACE { $$ = new NBlock(); }
;

var_decl : 
      ident ident 
      { 
            $$ = new NVariableDeclaration(*$1, *$2); 
      }
| 
      ident ident EQUAL expr 
      { 
            $$ = new NVariableDeclaration(*$1, *$2, $4); 
      }
;

func_decl : 
      ident ident LPAREN func_decl_args RPAREN block 
      { 
            $$ = new NFunctionDeclaration(*$1, *$2, *$4, *$6); 
            delete $4; 
      }
;
    
func_decl_args : 
      /*blank*/  
      { 
            $$ = new VariableList(); 
      }
| 
      var_decl 
      { 
            $$ = new VariableList(); 
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
            $$ = new NIdentifier(*$1); 
            delete $1; 
      }
;

numeric : 
      INTEGER 
      { 
            $$ = new NInteger(atol($1->c_str()));
            delete $1; 
      }
| 
      DOUBLE 
      { 
            $$ = new NDouble(atof($1->c_str())); 
            delete $1; 
      }
;
    
expr : 
      ident EQUAL expr 
      { 
            $$ = new NAssignment(*$<ident>1, *$3); 
      }
| 
      ident 
      { 
            $<ident>$ = $1; 
      }
|
      ident LPAREN call_args RPAREN 
      { 
            $$ = new NMethodCall(*$1, *$3); 
            delete $3; 
      }
| 
      numeric
;

call_args : 
      /*blank*/  
      { 
            $$ = new ExpressionList(); 
      }
| 
      expr 
      { 
            $$ = new ExpressionList(); 
            $$->push_back($1); 
      }
| 
      call_args COMMA expr  
      {
            $1->push_back($3); 
      }
;

%%