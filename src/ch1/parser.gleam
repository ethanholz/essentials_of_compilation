import ch1/lexer
import ch1/token
import ch1/ast
import gleam/io

pub type Parser {
  Parser(lexer: lexer.Lexer, token: token.Token)
}

pub fn make(lexer) {
  let #(lexer, token) = lexer.next_token(lexer)
  Parser(lexer, token)
}

pub fn advance(parser: Parser) {
  let #(lexer, token) = lexer.next_token(parser.lexer)
  Parser(lexer, token)
}

pub fn peek(parser: Parser) -> token.Token {
  let #(_, token) = lexer.next_token(parser.lexer)
  token
}

pub fn parse(parser) {
  let #(_, body) = parse_exp(parser)
  ast.Def("", body)
}

pub fn parse_exp(parser: Parser) {
  case parser.token, peek(parser) {
    token.Int(n), _ -> #(advance(parser), ast.Int(n))
    token.LParen, token.Int(_) | token.LParen, token.LParen -> {
      let #(parser2, exp) =
        parser
        |> advance
        |> parse_exp
      #(advance(parser2), exp)
    }
    token.LParen, _ -> {
      let #(parser2, op) = parse_operation(advance(parser))
      let #(parser2, args) = parse_arguments(parser2)
      #(advance(parser2), ast.Prim(op, args))
    }
    _, _ -> {
      // io.println(token.to_string(parser.token))
      io.println(
        "Expected LParen or Int(n) but got " <> token.to_string(parser.token),
      )
      panic("unexpected token")
    }
  }
}

pub fn parse_arguments(parser: Parser) {
  case parser.token {
    token.RParen -> #(parser, [])
    _ -> {
      let #(parser2, exp) = parse_exp(parser)
      let #(parser3, exps) = parse_arguments(parser2)
      #(parser3, [exp, ..exps])
    }
  }
}

pub fn parse_operation(parser: Parser) -> #(Parser, ast.Op) {
  case parser.token {
    token.Read -> #(advance(parser), ast.Read)
    token.Plus -> #(advance(parser), ast.Add)
    token.Minus -> {
      case peek(parser) {
        token.LParen | token.Int(_) -> {
          let #(parser2, _) = parse_exp(advance(parser))
          case parser2.token {
            token.LParen | token.Int(_) -> #(advance(parser), ast.Subtract)
            _ -> #(advance(parser), ast.Negate)
          }
        }
        // TODO: Cleanup
        _ -> panic("unexpected token")
      }
    }
    // TODO: Cleanup
    _ -> {
      io.print(token.to_string(parser.token))
      panic("unexpected token" <> token.to_string(parser.token))
    }
  }
}
