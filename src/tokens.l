  
%option c++ noyywrap yylineno 

%{
    #include <iostream>
    #include <cstdlib>
    #include <list>
    #include "node.hh"
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
[a-zA-Z_][a-zA-Z0-9_]*  return parser::token::IDENTIFIER;
[0-9]+\.[0-9]*          return parser::token::DOUBLE;
[0-9]+                  return parser::token::INTEGER;
"="                     return parser::token::EQUAL;
"("                     return parser::token::LPAREN;
")"                     return parser::token::RPAREN;
"{"                     return parser::token::LBRACE;
"}"                     return parser::token::RBRACE;
","                     return parser::token::COMMA;
.                       { std::cerr << "Line " << lineno() << ": Unexpected character: '" << YYText() << "'." << std::endl; exit(1); }
