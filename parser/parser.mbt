///|
/// Parser: converts tokens into an AST.
priv struct ParseState {
  tokens : Array[@types.Token]
  len : Int
  mut pos : Int
}

///|
/// Parse tokens into an AST.
pub fn parse(tokens : Array[@types.Token]) -> @types.Node {
  let state = ParseState::{ tokens, len: tokens.length(), pos: 0 }
  let nodes = parse_until(state, "")
  @types.Node::Root(nodes)
}

///|
/// Parse nodes until we hit a Close token with the given name, or an else Open token.
fn parse_until(state : ParseState, end_tag : String) -> Array[@types.Node] {
  let nodes = Array::new(capacity=8)
  while state.pos < state.len {
    let token = state.tokens[state.pos]
    match token {
      @types.Token::Comment(_) =>
        // Comments produce no output
        state.pos = state.pos + 1
      @types.Token::Close(name) => {
        if name == end_tag {
          state.pos = state.pos + 1
          break
        }
        state.pos = state.pos + 1
      }
      @types.Token::Open("else", "") => {
        if end_tag == "if" || end_tag == "unless" {
          // Don't consume - let the handler deal with it
          break
        }
        state.pos = state.pos + 1
      }
      @types.Token::Text(text) => {
        nodes.push(@types.Node::Text(text))
        state.pos = state.pos + 1
      }
      @types.Token::Var(name) => {
        nodes.push(@types.Node::Var(name))
        state.pos = state.pos + 1
      }
      @types.Token::Unescaped(name) => {
        nodes.push(@types.Node::Unescaped(name))
        state.pos = state.pos + 1
      }
      @types.Token::Open(cmd, arg) => {
        state.pos = state.pos + 1
        if cmd == "if" {
          let body = parse_until(state, "if")
          let mut else_body = Array::new(capacity=0)
          if state.pos < state.len {
            match state.tokens[state.pos] {
              @types.Token::Open("else", "") => {
                state.pos = state.pos + 1
                else_body = parse_until(state, "if")
              }
              _ => ()
            }
          }
          if else_body.length() > 0 {
            nodes.push(@types.Node::IfElse(arg, body, else_body))
          } else {
            nodes.push(@types.Node::If(arg, body))
          }
        } else if cmd == "unless" {
          let body = parse_until(state, "unless")
          let mut else_body = Array::new(capacity=0)
          if state.pos < state.len {
            match state.tokens[state.pos] {
              @types.Token::Open("else", "") => {
                state.pos = state.pos + 1
                else_body = parse_until(state, "unless")
              }
              _ => ()
            }
          }
          if else_body.length() > 0 {
            nodes.push(@types.Node::UnlessElse(arg, body, else_body))
          } else {
            nodes.push(@types.Node::Unless(arg, body))
          }
        } else if cmd == "each" {
          let body = parse_until(state, "each")
          nodes.push(@types.Node::Each(arg, "this", body))
        } else {
          // Unknown block, consume until matching close
          parse_until(state, cmd) |> ignore
        }
      }
    }
  }
  nodes
}
