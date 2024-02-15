import gleam/int

pub type Token {
  Int(Int)
  Identifier(String)
  LParen
  RParen
  LBracket
  RBracket
  Plus
  Minus
  Read
  Eof
}

pub fn to_string(token) -> String {
  case token {
    Int(int) -> int.to_string(int)
    Identifier(id) -> id
    LParen -> "("
    RParen -> ")"
    LBracket -> "["
    RBracket -> "]"
    Plus -> "+"
    Minus -> "-"
    Read -> "read"
    Eof -> ""
  }
}

pub fn from_string(input) {
  case input {
    "read" -> Read
    _ -> Identifier(input)
  }
}
