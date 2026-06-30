/// Lexer: converts template string into tokens.

/// Tokenize a template string into a list of tokens.
pub fn tokenize(input : String) -> Array[@types.Token] {
  let tokens = Array::new(capacity=8)
  let len = input.length()
  let mut pos = 0
  let mut buf = ""

  while pos < len {
    if input[pos] == '{' && pos + 1 < len && input[pos + 1] == '{' {
      if buf != "" {
        tokens.push(@types.Token::Text(buf))
        buf = ""
      }
      pos = pos + 2

      // Check for comment: {{! or {{!--
      let is_comment = pos < len && input[pos] == '!'
      if is_comment {
        pos = pos + 1
        if pos < len && input[pos] == '-' && pos + 1 < len && input[pos + 1] == '-' {
          pos = pos + 2
        }
        let comment_start = pos
        let mut comment_end = pos
        while comment_end < len {
          if input[comment_end] == '}' && comment_end + 1 < len && input[comment_end + 1] == '}' {
            break
          }
          comment_end = comment_end + 1
        }
        let comment_text = input.substring(start=comment_start, end=comment_end)
        tokens.push(@types.Token::Comment(trim_both(comment_text)))
        pos = comment_end
        pos = skip_closing_braces(input, comment_end, len)
        continue
      }

      let is_unescaped = pos < len && input[pos] == '{'
      if is_unescaped {
        pos = pos + 1
      }
      // Skip whitespace
      while pos < len && (input[pos] == ' ' || input[pos] == '\t') {
        pos = pos + 1
      }
      // Read until }}
      let tag_start = pos
      let mut tag_end = pos
      while tag_end < len {
        if input[tag_end] == '}' && tag_end + 1 < len && input[tag_end + 1] == '}' {
          break
        }
        tag_end = tag_end + 1
      }
      let tag_content = input.substring(start=tag_start, end=tag_end)
      pos = tag_end

      if tag_content != "" && tag_content[0] == '#' {
        let rest = ltrim(tag_content.substring(start=1))
        let space_idx = find_space(rest)
        if space_idx > 0 {
          let cmd = rest.substring(start=0, end=space_idx)
          let arg = rtrim(ltrim(rest.substring(start=space_idx + 1)))
          tokens.push(@types.Token::Open(cmd, arg))
        } else {
          tokens.push(@types.Token::Open(rest, ""))
        }
      } else if tag_content == "else" {
        tokens.push(@types.Token::Open("else", ""))
      } else if tag_content != "" && tag_content[0] == '/' {
        let name = ltrim(tag_content.substring(start=1))
        tokens.push(@types.Token::Close(name))
      } else {
        let cleaned = trim_both(tag_content)
        if is_unescaped {
          tokens.push(@types.Token::Unescaped(cleaned))
        } else {
          tokens.push(@types.Token::Var(cleaned))
        }
      }

      // Skip whitespace and closing }}
      while pos < len && (input[pos] == ' ' || input[pos] == '\t') {
        pos = pos + 1
      }
      if pos < len && input[pos] == '}' {
        pos = pos + 1
        if pos < len && input[pos] == '}' {
          pos = pos + 1
        }
      }
      if is_unescaped && pos < len && input[pos] == '}' {
        pos = pos + 1
      }
      continue
    }
    buf = buf + input.substring(start=pos, end=pos + 1)
    pos = pos + 1
  }
  if buf != "" {
    tokens.push(@types.Token::Text(buf))
  }
  tokens
}

fn skip_closing_braces(input : String, pos : Int, len : Int) -> Int {
  let mut result = pos
  while result < len && (input[result] == ' ' || input[result] == '\t') {
    result = result + 1
  }
  if result < len && input[result] == '}' {
    result = result + 1
    if result < len && input[result] == '}' {
      result = result + 1
    }
  }
  result
}

fn find_space(s : String) -> Int {
  let mut i = 0
  while i < s.length() {
    if s[i] == ' ' || s[i] == '\t' {
      return i
    }
    i = i + 1
  }
  -1
}

fn ltrim(s : String) -> String {
  let mut i = 0
  while i < s.length() && (s[i] == ' ' || s[i] == '\t') {
    i = i + 1
  }
  s.substring(start=i)
}

fn rtrim(s : String) -> String {
  let mut end = s.length()
  while end > 0 && (s[end - 1] == ' ' || s[end - 1] == '\t') {
    end = end - 1
  }
  s.substring(start=0, end=end)
}

fn trim_both(s : String) -> String {
  rtrim(ltrim(s))
}
