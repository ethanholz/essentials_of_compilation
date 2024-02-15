import gleam/io
import gleam/string
import gleam/list.{map}
import lexer.{lex, new}
import token.{to_string}
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
  let input = "(+ 1234 1234)"
  // let assert Ok(data) = simplifile.read(from: input)
  // read(data)
  lexer.new(input)
  |> lex
  |> map(to_string(_))
  |> io.debug
  // new(input)
  // |> map(to_string(_))
  // |> io.debug
}
