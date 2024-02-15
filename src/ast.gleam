pub type Ast {
  Def(String, body: Expression)
}

pub type Op {
  Read
  Subtract
  Negate
  Add
}

pub type Expression {
  Int(Int)
  Prim(Op, List(Expression))
}

pub fn is_leaf(e: Expression) -> Bool {
  case e {
    Int(_) -> True
    Prim(Read, []) -> True
    Prim(Negate, [_]) -> False
    Prim(Subtract, [_, _]) -> False
    Prim(Add, [_, _]) -> False
    _ -> False
  }
}

pub fn is_valid(e: Expression) -> Bool {
  case e {
    Int(_) -> True
    Prim(Read, []) -> True
    Prim(Negate, [e]) -> is_valid(e)
    Prim(Subtract, [e1, e2]) -> is_valid(e1) && is_valid(e2)
    Prim(Add, [e1, e2]) -> is_valid(e1) && is_valid(e2)
    _ -> False
  }
}
