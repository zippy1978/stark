  
%option c++ noyywrap yylineno 

%{
    #include <iostream>
    #include <cstdlib>
    #include <list>
    #include "../ast/AST.h"
    #include "parser.hpp"

    using namespace yy;
%}

%x COMMENT

%%

"/*"                    { BEGIN(COMMENT); }
<COMMENT>"*/"           { BEGIN(INITIAL); }
<COMMENT>\n             { }
<COMMENT>.              { }
[ \t\r\n]                 // Whitespaces skipped.
"//".*                  // Comments skipped.

extern                  return parser::token::EXTERN;
declare                 return parser::token::DECLARE;
func                    return parser::token::FUNC;
struct                  return parser::token::STRUCT;
return                  return parser::token::RETURN;
true                    return parser::token::TRUE;
false                   return parser::token::FALSE;
if                      return parser::token::IF;
else                    return parser::token::ELSE;
while                   return parser::token::WHILE;
as                      return parser::token::AS;
module                  return parser::token::MODULE;

[a-zA-Z_][a-zA-Z0-9_]*  return parser::token::IDENTIFIER;

[0-9]+\.[0-9]*          return parser::token::DOUBLE;
[0-9]+                  return parser::token::INTEGER;
\"(\\.|[^"\\])*\"       return parser::token::STRING;

"=="				    return parser::token::COMP_EQ;
"!="			        return parser::token::COMP_NE;
"<"				        return parser::token::COMP_LT;
"<="	          		return parser::token::COMP_LE;
">"				        return parser::token::COMP_GT;
">="					return parser::token::COMP_GE;

"+"		        		return parser::token::PLUS;
"-"		   				return parser::token::MINUS;
"*"		   				return parser::token::MUL;
"/"			       		return parser::token::DIV;

"&&"                    return parser::token::AND;
"||"                    return parser::token::OR;

"="                     return parser::token::EQUAL;
"("                     return parser::token::LPAREN;
")"                     return parser::token::RPAREN;
"{"                     return parser::token::LBRACE;
"}"                     return parser::token::RBRACE;
"["                     return parser::token::LBRACKET;
"]"                     return parser::token::RBRACKET;
"[]"                    return parser::token::EMPTYBRACKETS;
","                     return parser::token::COMMA;
":"                     return parser::token::COLON;
"."                     return parser::token::DOT;

.                       { std::cerr << "Line " << lineno() << ": Unexpected character: '" << YYText() << "'." << std::endl; exit(1); }
