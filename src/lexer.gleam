import token.{type Token}
import gleam/int
import gleam/float
import gleam/io
import gleam/string

// pub fn lex(input: String) -> List(Token) {
//   case input {
//     "(" <> rest -> [token.LParen, ..lex(rest)]
//     ")" <> rest -> [token.RParen, ..lex(rest)]
//     "[" <> rest -> [token.LBracket, ..lex(rest)]
//     "]" <> rest -> [token.RBracket, ..lex(rest)]
//     "+" <> rest -> [token.Plus, ..lex(rest)]
//     "-" <> rest -> [token.Minus, ..lex(rest)]
//     "read" <> rest -> [token.Read, ..lex(rest)]
//     _ -> []
//   }
// }

// type t = { input : string; position : int; ch : char option }
pub type Lexer {
  State(input: String, position: Int, ch: Result(String, Nil))
}

pub fn new(input: String) -> Lexer {
  State(input: input, position: 0, ch: Ok(string.slice(input, 0, 1)))
}

pub fn lex(lexer) -> List(Token) {
  let #(lexer, token) = next_token(lexer)
  case token {
    token.Eof -> []
    _ -> [token, ..lex(lexer)]
  }
}

pub fn advance(lexer: Lexer) -> Lexer {
  let position = lexer.position + 1
  case position >= string.length(lexer.input) {
    True -> State(..lexer, ch: Error(Nil))
    False ->
      State(
        ..lexer,
        position: position,
        ch: Ok(string.slice(lexer.input, position, 1)),
      )
  }
}

pub fn advance_while(lexer: Lexer, f: fn(String) -> Bool) -> Lexer {
  case lexer.ch {
    Ok(state) -> {
      case f(state) {
        True -> advance_while(advance(lexer), f)
        False -> lexer
      }
    }
    Error(_) -> lexer
  }
}

pub fn skip_whitespace(lexer: Lexer) -> Lexer {
  advance_while(lexer, fn(ch) { ch == " " })
}

pub fn next_token(lexer: Lexer) -> #(Lexer, Token) {
  let lexer = skip_whitespace(lexer)
  case lexer.ch {
    Ok(state) -> {
      case state {
        "-" -> #(advance(lexer), token.Minus)
        "+" -> #(advance(lexer), token.Plus)
        "(" -> #(advance(lexer), token.LParen)
        ")" -> #(advance(lexer), token.RParen)
        "[" -> #(advance(lexer), token.LBracket)
        "]" -> #(advance(lexer), token.RBracket)
        " " -> #(advance(lexer), token.Eof)
        "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ->
          read_digit(lexer)
        _ -> read_identifier(lexer)
      }
    }
    Error(_) -> {
      #(lexer, token.Eof)
    }
  }
}

pub fn take_while(lexer: Lexer, f: fn(String) -> Bool) -> #(Lexer, String) {
  case lexer.ch {
    Ok(state) -> {
      case f(state) {
        True -> {
          let #(lexer, token) = take_while(advance(lexer), f)
          #(lexer, string.concat([state, token]))
        }
        False -> #(lexer, "")
      }
    }
    Error(_) -> {
      #(lexer, "")
    }
  }
}

pub fn read_identifier(lexer: Lexer) -> #(Lexer, Token) {
  let #(advance_lexer, acc) = take_while(lexer, fn(input) { !is_symbol(input) })

  #(advance_lexer, token.from_string(acc))
}

pub fn read_digit(lexer: Lexer) -> #(Lexer, Token) {
  let #(advance_lexer, acc) = take_while(lexer, fn(input) { is_digit(input) })
  let assert Ok(parsed) = int.parse(acc)
  #(advance_lexer, token.Int(parsed))
}

pub fn is_digit(ch: String) -> Bool {
  case int.parse(ch) {
    Ok(_) -> True
    Error(_) -> False
  }
}

pub fn is_symbol(ch: String) -> Bool {
  case ch {
    "(" | ")" | "[" | "]" | "+" | "-" -> True
    _ -> False
  }
}
// pub fn lex_int(input: String, acc: List(String)) -> List(Token) {
//   case input {
//     "0" <> rest -> {
//       lex_int(rest, ["0", ..acc])
//     }
//     "1" <> rest -> {
//       lex_int(rest, ["1", ..acc])
//     }
//     "2" <> rest -> {
//       lex_int(rest, ["2", ..acc])
//     }
//     "3" <> rest -> {
//       lex_int(rest, ["3", ..acc])
//     }
//     "4" <> rest -> {
//       lex_int(rest, ["4", ..acc])
//     }
//     "5" <> rest -> {
//       lex_int(rest, ["5", ..acc])
//     }
//     "6" <> rest -> {
//       lex_int(rest, ["6", ..acc])
//     }
//     "7" <> rest -> {
//       lex_int(rest, ["7", ..acc])
//     }
//     "8" <> rest -> {
//       lex_int(rest, ["8", ..acc])
//     }
//     "9" <> rest -> {
//       lex_int(rest, ["9", ..acc])
//     }
//     rest -> {
//       lex(rest)
//     }
//   }
// }
