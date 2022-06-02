mod constant_expr;
mod name_expr;
mod func_def;
mod func_decl;
mod stmts;
mod var_decl;
mod assign;
mod call_expr;
mod import;

#[cfg(test)]
mod test_util;

#[cfg(test)]
mod assign_tests;
#[cfg(test)]
mod var_decl_tests;
#[cfg(test)]
mod constant_expr_tests;
#[cfg(test)]
mod name_expr_tests;
#[cfg(test)]
mod stmts_tests;
#[cfg(test)]
mod func_def_tests;
#[cfg(test)]
mod call_expr_tests;