import gleeunit
import gleeunit/should
import ast
import interpreter
import parser
import lexer

pub fn main() {
  gleeunit.main()
}

pub fn interp_exp_test() {
  interpreter.intepret_expression(ast.Prim(ast.Add, [ast.Int(60), ast.Int(9)]))
  |> should.equal(69)
}

pub fn inteprt_test() {
  let input = ast.Def("", ast.Prim(ast.Add, [ast.Int(60), ast.Int(9)]))
  interpreter.interpret(input)
  |> should.equal(69)
}

pub fn partial_eval_test() {
  interpreter.partial_eval_expression(
    ast.Prim(ast.Add, [
      ast.Prim(ast.Read, []),
      ast.Prim(ast.Subtract, [ast.Prim(ast.Add, [ast.Int(5), ast.Int(3)])]),
    ]),
  )
  |> should.equal(ast.Prim(ast.Add, [ast.Prim(ast.Read, []), ast.Int(-8)]))
}

pub fn partial_eval_add_test() {
  let input = "(+ 1 2)"
  let ast =
    parser.make(lexer.new(input))
    |> parser.parse
  interpreter.interpret(interpreter.partial_eval(ast))
  |> should.equal(3)
}

pub fn partial_eval_sub_test() {
  let input = "(- 1 2)"
  let ast =
    parser.make(lexer.new(input))
    |> parser.parse
  interpreter.interpret(interpreter.partial_eval(ast))
  |> should.equal(-1)
}

pub fn partial_eval_complete_test() {
  let initial =
    ast.Def(
      "",
      ast.Prim(ast.Add, [
        ast.Prim(ast.Read, []),
        ast.Prim(ast.Subtract, [ast.Prim(ast.Add, [ast.Int(5), ast.Int(3)])]),
      ]),
    )
  let expected =
    ast.Def("", ast.Prim(ast.Add, [ast.Prim(ast.Read, []), ast.Int(-8)]))

  interpreter.partial_eval(initial)
  |> should.equal(expected)
}

pub fn partial_eval_complete_2_test() {
  let initial =
    ast.Def(
      "",
      ast.Prim(ast.Add, [
        ast.Int(10),
        ast.Prim(ast.Subtract, [ast.Prim(ast.Add, [ast.Int(5), ast.Int(3)])]),
      ]),
    )
  interpreter.interpret(initial)
  |> should.equal(interpreter.interpret(interpreter.partial_eval(initial)))
}
