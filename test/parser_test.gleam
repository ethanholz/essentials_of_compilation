import gleeunit
import gleeunit/should
import parser
import ast
import lexer

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
// pub fn complicated_parse1_test() {
//   let input = "(- (+ 3(-5)))"
//   let expected =
//     ast.Def(
//       "",
//       ast.Prim(ast.Subtract, [
//         ast.Prim(ast.Add, [ast.Int(3), ast.Prim(ast.Subtract, [ast.Int(5)])]),
//       ]),
//     )
//   parser.make(lexer.new(input))
//   |> parser.parse
//   |> should.equal(expected)
// }
