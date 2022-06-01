#[cfg(test)]
use crate::ast;
use crate::parser::Parser;

type TestError = String;

fn assert_variable_declaration(stmt: &ast::StmtKind) -> Result<(), TestError> {
    match stmt {
        ast::StmtKind::VarDecl {
            name: _,
            var_type: _,
        } => Result::Ok(()),
        _ => Result::Err(String::from("Failed to parse variable declaration")),
    }
}

fn assert_function_definition(stmt: &ast::StmtKind) -> Result<(), TestError> {
    match stmt {
        ast::StmtKind::FuncDef {
            name: _,
            args: _,
            body: _,
            returns: _,
        } => Result::Ok(()),
        _ => Result::Err(String::from("Failed to parse function declaration")),
    }
}

fn assert_assign(stmt: &ast::StmtKind) -> Result<(), TestError> {
    match stmt {
        ast::StmtKind::Assign {
            target: _,
            value: _,
        } => Result::Ok(()),
        _ => Result::Err(String::from("Failed to parse assign")),
    }
}

fn assert_identifier(stmt: &ast::StmtKind) -> Result<(), TestError> {
    let error = Result::<(), TestError>::Err(String::from("Failed to parse identifier"));
    match stmt {
        ast::StmtKind::Expr { value } => match &value.node {
            ast::ExprKind::Name { id: _ } => Result::Ok(()),
            _ => error,
        },
        _ => error,
    }
}

fn assert_integer(stmt: &ast::StmtKind) -> Result<(), TestError> {
    let error = Result::<(), TestError>::Err(String::from("Failed to parse integer"));
    match stmt {
        ast::StmtKind::Expr { value } => match &value.node {
            ast::ExprKind::Constant { value } => match value {
                ast::Constant::Int(_) => Result::Ok(()),
                _ => error,
            },
            _ => error,
        },
        _ => error,
    }
}

fn assert_float(stmt: &ast::StmtKind) -> Result<(), TestError> {
    let error = Result::<(), TestError>::Err(String::from("Failed to parse float"));
    match stmt {
        ast::StmtKind::Expr { value } => match &value.node {
            ast::ExprKind::Constant { value } => match value {
                ast::Constant::Float(_) => Result::Ok(()),
                _ => error,
            },
            _ => error,
        },
        _ => error,
    }
}

fn assert_call(stmt: &ast::StmtKind) -> Result<(), TestError> {
    let error = Result::<(), TestError>::Err(String::from("Failed to parse call"));
    match stmt {
        ast::StmtKind::Expr { value } => match &value.node {
            ast::ExprKind::Call { id: _, params: _ } => Result::Ok(()),
            _ => error,
        },
        _ => error,
    }
}

fn assert_boolean(stmt: &ast::StmtKind) -> Result<(), TestError> {
    let error = Result::<(), TestError>::Err(String::from("Failed to parse boolean"));
    match stmt {
        ast::StmtKind::Expr { value } => match &value.node {
            ast::ExprKind::Constant { value } => match value {
                ast::Constant::Bool(_) => Result::Ok(()),
                _ => error,
            },
            _ => error,
        },
        _ => error,
    }
}

fn assert_statment(
    input: &str,
    assert_fn: fn(stmt: &ast::StmtKind) -> Result<(), TestError>,
) -> Result<(), TestError> {
    let error = Result::<(), TestError>::Err(String::from("Failed to parse identifier"));

    let parser = Parser::new();

    match parser.parse("-", input) {
        Ok(stmts) => {
            let stmt = stmts.get(0).unwrap();
            return assert_fn(&stmt.node);
        }
        Err(_) => error,
    }
}

#[test]
fn parse_statments() {
    let input = r#"

            123
            // single line comment
            abc
            /* multi line 
             * comment */
        "#;
    let parser = Parser::new();
    let stmts = parser.parse("-", input).unwrap();
    assert_eq!(stmts.len(), 2);
}

#[test]
fn parse_integer() {
    assert!(assert_statment("123", assert_integer).is_ok());
    assert!(assert_statment("-123", assert_integer).is_ok());
    assert!(assert_statment("1.23", assert_integer).is_err());
    assert!(assert_statment("abc", assert_integer).is_err());
}

#[test]
fn parse_float() {
    assert!(assert_statment("1.23", assert_float).is_ok());
    assert!(assert_statment("-1.23", assert_float).is_ok());
    assert!(assert_statment("123", assert_float).is_err());
    assert!(assert_statment("abc", assert_float).is_err());
}

#[test]
fn parse_boolean() {
    assert!(assert_statment("true", assert_boolean).is_ok());
    assert!(assert_statment("false", assert_boolean).is_ok());
    assert!(assert_statment("123", assert_boolean).is_err());
    assert!(assert_statment("abc", assert_boolean).is_err());
}

#[test]
fn parse_identifier() {
    assert!(assert_statment("abc", assert_identifier).is_ok());
    assert!(assert_statment("123", assert_identifier).is_err());
    assert!(assert_statment(",", assert_identifier).is_err());
}

#[test]
fn parse_variable_declaration() {
    assert!(assert_statment("name: string", assert_variable_declaration).is_ok());
    assert!(assert_statment("name: ", assert_variable_declaration).is_err());
}

#[test]
fn parse_assign() {
    assert!(assert_statment("age = 1", assert_assign).is_ok());
    assert!(assert_statment("age = ", assert_assign).is_err());
}

#[test]
fn parse_function_definition() {
    assert!(assert_statment(
        r#"
    func test() {
        a = 1
    }
    "#,
        assert_function_definition
    )
    .is_ok());
    assert!(assert_statment(
        r#"
    func test() => int {
        a = 1
    }
    "#,
        assert_function_definition
    )
    .is_ok());
    assert!(assert_statment(
        r#"
    func test(a: float, b: int) => int {
        a = 1
    }
    "#,
        assert_function_definition
    )
    .is_ok());
}

#[test]
fn parse_call() {
    assert!(assert_statment(
        r#"
        myFunc()
        "#,
        assert_call
    )
    .is_ok());
    assert!(assert_statment(
        r#"
        myFunc(123)
        "#,
        assert_call
    )
    .is_ok());
}
