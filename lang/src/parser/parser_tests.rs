#[cfg(test)]
mod parser_tests {

    use crate::{ast, parser};

    type TestError = String;

    fn assert_declaration(stmt: &ast::StmtKind) -> Result<(), TestError> {
        return match stmt {
            ast::StmtKind::Declaration {
                variable: _,
                var_type: _,
            } => Result::Ok(()),
            _ => Result::Err(String::from("Failed to parse declaration")),
        };
    }

    fn assert_identifier(stmt: &ast::StmtKind) -> Result<(), TestError> {
        let error = Result::<(), TestError>::Err(String::from("Failed to parse identifier"));
        return match stmt {
            ast::StmtKind::Expr { value } => match &value.node {
                ast::ExprKind::Name { id: _ } => Result::Ok(()),
                _ => error,
            },
            _ => error,
        };
    }

    fn assert_integer(stmt: &ast::StmtKind) -> Result<(), TestError> {
        let error = Result::<(), TestError>::Err(String::from("Failed to parse integer"));
        return match stmt {
            ast::StmtKind::Expr { value } => match &value.node {
                ast::ExprKind::Constant { value } => match value {
                    ast::Constant::Int(_) => Result::Ok(()),
                    _ => error,
                },
                _ => error,
            },
            _ => error,
        };
    }

    fn assert_statment(
        input: &str,
        assert_fn: fn(stmt: &ast::StmtKind) -> Result<(), TestError>,
    ) -> Result<(), TestError> {
        let error = Result::<(), TestError>::Err(String::from("Failed to parse identifier"));

        match parser::parse(input) {
            Ok(unit) => {
                let stmt = unit.get(0).unwrap();
                return assert_fn(&stmt.node);
            }
            Err(_) => error,
        }
    }

    #[test]
    fn parse_statements() {
        let input = r#"

            123
            // single line comment
            abc
            /* multi line 
             * comment */
        "#;
        let unit = parser::parse(input).unwrap();
        assert_eq!(unit.len(), 2);
    }

    #[test]
    fn parse_declaration() {
        assert!(assert_statment("name: string", assert_declaration).is_ok());
        assert!(assert_statment("name: ", assert_declaration).is_err());
    }

    #[test]
    fn parse_integer() {
        assert!(assert_statment("123", assert_integer).is_ok());
        assert!(assert_statment("1.23", assert_integer).is_err());
        assert!(assert_statment("abc", assert_integer).is_err());
    }

    #[test]
    fn parse_identifier() {
        assert!(assert_statment("abc", assert_identifier).is_ok());
        assert!(assert_statment("123", assert_identifier).is_err());
        assert!(assert_statment(",", assert_identifier).is_err());
    }
}
