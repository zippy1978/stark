use num_bigint::BigInt;

#[derive(Debug, PartialEq)]
pub enum Constant {
    None,
    Bool(bool),
    Str(String),
    Int(BigInt),
    Double(f64),
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
