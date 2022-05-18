use num_bigint::BigInt;

/// Represents a language constant.
#[derive(Debug, PartialEq)]
pub enum Constant {
    Bool(bool),
    Str(String),
    Int(BigInt),
    Float(f64),
}

impl Clone for Constant {
    fn clone(&self) -> Self {
        match self {
            Constant::Bool(b) => Constant::Bool(*b),
            Constant::Str(s) => Constant::Str(s.clone()),
            Constant::Int(i) => Constant::Int(i.clone()),
            Constant::Float(f) => Constant::Float(*f),
        }
    }
}

impl From<String> for Constant {
    fn from(s: String) -> Constant {
        Self::Str(s)
    }
}

impl From<bool> for Constant {
    fn from(b: bool) -> Constant {
        Self::Bool(b)
    }
}
impl From<BigInt> for Constant {
    fn from(i: BigInt) -> Constant {
        Self::Int(i)
    }
}
