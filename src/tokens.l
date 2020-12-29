  
%option c++ noyywrap yylineno 

%{
    #include <iostream>
    #include <cstdlib>
    #include <list>
    #include "ast.hh"
    #include "parser.hh"

    using namespace yy;
%}

%x COMMENT

%%

"/*"                    { BEGIN(COMMENT); }
<COMMENT>"*/"           { BEGIN(INITIAL); }
<COMMENT>\n             { }
<COMMENT>.              { }
[ \t\n]                 // Whitespaces skipped.
"//".*                  // Comments skipped.

extern                  return parser::token::EXTERN;
func                    return parser::token::FUNC;
return                  return parser::token::RETURN;

[a-zA-Z_][a-zA-Z0-9_]*  return parser::token::IDENTIFIER;

[0-9]+\.[0-9]*          return parser::token::DOUBLE;
[0-9]+                  return parser::token::INTEGER;

"+"		        		return parser::token::PLUS;
"-"		   				return parser::token::MINUS;
"*"		   				return parser::token::MUL;
"/"			       		return parser::token::DIV;

"="                     return parser::token::EQUAL;
"("                     return parser::token::LPAREN;
")"                     return parser::token::RPAREN;
"{"                     return parser::token::LBRACE;
"}"                     return parser::token::RBRACE;
","                     return parser::token::COMMA;
":"                     return parser::token::COLON;
.                       { std::cerr << "Line " << lineno() << ": Unexpected character: '" << YYText() << "'." << std::endl; exit(1); }
