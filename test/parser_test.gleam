import gleeunit
import gleeunit/should
import ch1/parser
import ch1/ast
import ch1/lexer

pub fn main() {
  gleeunit.main()
}

pub fn simple_parse_test() {
  let input = "((10))"
  let expected = ast.Def("", ast.Int(10))
  let parser = parser.make(lexer.new(input))
  parser.parse(parser)
  |> should.equal(expected)
}

pub fn simple_parse2_test() {
  let input = "(+ (10) (10))"
  let expected = ast.Def("", ast.Prim(ast.Add, [ast.Int(10), ast.Int(10)]))
  let parser = parser.make(lexer.new(input))
  parser.parse(parser)
  |> should.equal(expected)
}

pub fn simple_parse3_test() {
  let input = "(+ (read) 3)"
  let expected =
    ast.Def("", ast.Prim(ast.Add, [ast.Prim(ast.Read, []), ast.Int(3)]))
  parser.make(lexer.new(input))
  |> parser.parse
  |> should.equal(expected)
}

pub fn sub_parse_test() {
  let input = "(- 3 5)"
  let expected = ast.Def("", ast.Prim(ast.Subtract, [ast.Int(3), ast.Int(5)]))
  parser.make(lexer.new(input))
  |> parser.parse
  |> should.equal(expected)
}

pub fn complicated_parse1_test() {
  let input = "(+ (read) (- (+ 5 3)))"
  let expected =
    ast.Def(
      "",
      ast.Prim(ast.Add, [
        ast.Prim(ast.Read, []),
        ast.Prim(ast.Negate, [ast.Prim(ast.Add, [ast.Int(5), ast.Int(3)])]),
      ]),
    )
  parser.make(lexer.new(input))
  |> parser.parse
  |> should.equal(expected)
}
