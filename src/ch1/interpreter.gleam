import ch1/ast

pub fn interpret(ast: ast.Ast) {
  intepret_expression(ast.body)
}

pub fn intepret_expression(exp) {
  case exp {
    ast.Int(n) -> n
    // TODO: We can't read from stdin in this context yet
    ast.Prim(ast.Read, []) -> 10
    ast.Prim(ast.Negate, [exp]) -> -intepret_expression(exp)
    ast.Prim(ast.Subtract, [exp1, exp2]) ->
      intepret_expression(exp1) - intepret_expression(exp2)
    ast.Prim(ast.Add, [exp1, exp2]) ->
      intepret_expression(exp1) + intepret_expression(exp2)
    _ -> panic("Unexpected expression")
  }
}

pub fn partial_eval_negate(exp) {
  case exp {
    ast.Int(n) -> ast.Int(-n)
    _ -> ast.Prim(ast.Negate, [exp])
  }
}

pub fn partial_eval_subtract(exp1, exp2) {
  case exp1, exp2 {
    ast.Int(a), ast.Int(b) -> ast.Int(a - b)
    _, _ -> ast.Prim(ast.Subtract, [exp1, exp2])
  }
}

pub fn partial_eval_add(exp1, exp2) {
  case exp1, exp2 {
    ast.Int(a), ast.Int(b) -> ast.Int(a + b)
    _, _ -> ast.Prim(ast.Add, [exp1, exp2])
  }
}

pub fn partial_eval_expression(exp) {
  case exp {
    ast.Int(n) -> ast.Int(n)
    ast.Prim(ast.Read, []) -> ast.Prim(ast.Read, [])
    ast.Prim(ast.Negate, [exp]) ->
      partial_eval_negate(partial_eval_expression(exp))
    ast.Prim(ast.Subtract, [exp1, exp2]) ->
      partial_eval_subtract(
        partial_eval_expression(exp1),
        partial_eval_expression(exp2),
      )
    ast.Prim(ast.Add, [exp1, exp2]) ->
      partial_eval_add(
        partial_eval_expression(exp1),
        partial_eval_expression(exp2),
      )
    _ -> {
      panic("failed")
    }
  }
}

pub fn partial_eval(ast: ast.Ast) {
  ast.Def("", partial_eval_expression(ast.body))
}
