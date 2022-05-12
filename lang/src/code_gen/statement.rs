use crate::ast::{self, Location};

use super::{CodeGenError, Generable, GenerableResult, Generator};

impl<'a> Generable<'a> for ast::Stmt {
    fn generate(&'a self, generator: &'a Generator) -> GenerableResult<'a> {
        match &self.node {
            ast::StmtKind::Declaration { variable, var_type } => {
                gen_declaration(generator, &variable, &var_type, self.location)
            }
            _ => Result::Err(CodeGenError::new()),
        }
    }
}

pub(crate) fn gen_declaration<'a>(
    generator: &'a super::Generator,
    variable: &'a str,
    var_type: &'a str,
    location: Location,
) -> GenerableResult<'a> {

    // TODO someday...
    /*match generator.type_registry().lookup_type(var_type) {
        Some(ty) => match generator.symbol_table_mut().insert(variable, ty, location) {
            Ok(_) => todo!(),
            Err(_) => todo!(),
        },
        None => Err(CodeGenError::new()),
    }*/

    let context = generator.context();
    let i64_type = context.i64_type();
    let builder = generator.builder();
    Result::Ok(builder.build_alloca(i64_type, variable))
}
