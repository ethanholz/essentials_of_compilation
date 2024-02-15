import gleeunit
import gleeunit/should
import lexer
import token

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn lexer_basic_test() {
  let input = "(+ 1 2)"

  let expected = [
    token.LParen,
    token.Plus,
    token.Int(1),
    token.Int(2),
    token.RParen,
  ]

  lexer.new(input)
  |> lexer.lex
  |> should.equal(expected)
}

pub fn lexer_skip_whitespace_test() {
  let input = "      "
  let expected = []
  lexer.new(input)
  |> lexer.lex
  |> should.equal(expected)
}

pub fn lexer_read_token_test() {
  let input = "read"
  let expected = [token.Read]
  lexer.new(input)
  |> lexer.lex
  |> should.equal(expected)
}

pub fn lexer_read_ident_test() {
  let input = "foobar"
  let expected = [token.Identifier("foobar")]
  lexer.new(input)
  |> lexer.lex
  |> should.equal(expected)
}

pub fn read_digits_test() {
  let input = "123"
  let expected = [token.Int(123)]
  lexer.new(input)
  |> lexer.lex
  |> should.equal(expected)
}

pub fn lexer_new_test() {
  let input = "(- (+ 3(-5)))"
  let expected = [
    token.LParen,
    token.Minus,
    token.LParen,
    token.Plus,
    token.Int(3),
    token.LParen,
    token.Minus,
    token.Int(5),
    token.RParen,
    token.RParen,
    token.RParen,
  ]
  lexer.new(input)
  |> lexer.lex
  |> should.equal(expected)
}
