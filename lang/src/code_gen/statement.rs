use crate::ast;

use super::{CodeGenError, Generable, GenerableResult, Generator};

impl<'a> Generable<'a> for ast::Stmt {
    fn generate(&'a self, generator: &'a Generator) -> GenerableResult<'a> {
        match &self.node {
            ast::StmtKind::Declaration { variable, var_type } => {
                gen_declaration(generator, &variable,&var_type)
            }
            _ => Result::Err(CodeGenError::new()),
        }
    }
}

pub(crate) fn gen_declaration<'a>(
    generator: &'a  super::Generator,
    variable: &'a  str,
    var_type: &'a  str,
) -> GenerableResult<'a> {
    let context = generator.context();
    let i64_type = context.i64_type();
    let builder = generator.builder();
    Result::Ok(builder.build_alloca(i64_type, variable))
}
