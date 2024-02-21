import gleam/io
import gleam/string
import gleam/list.{map}
import ch1/lexer.{lex, new}
import ch1/parser
import ch1/interpreter
import ch1/token.{to_string}
import simplifile

pub fn read(from: String) -> String {
  let split = string.pop_grapheme(from)
  case split {
    Ok(#(first, rest)) -> {
      io.println(first)
      read(rest)
    }
    Error(_) -> from
  }
}

pub fn main() {
  let input = "(- (+ 3 (- 5)))"
  // let assert Ok(data) = simplifile.read(from: input)
  // read(data)
  let parsed =
    lexer.new(input)
    |> parser.make
    |> parser.parse

  let interpreted =
    parsed
    |> interpreter.interpret
  let partial =
    parsed
    |> interpreter.partial_eval
  // new(input)
  // |> map(to_string(_))
  // |> io.debug
}
