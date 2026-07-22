/// Renderer: evaluates the AST with context to produce output.

///|
/// Render an AST node with a key-value context.
pub fn render(node : @types.Node, ctx : Array[(String, String)]) -> String {
  match node {
    @types.Node::Root(children) => render_nodes(children, ctx)
    @types.Node::Text(text) => text
    @types.Node::Var(name) => resolve_var(name, ctx, true)
    @types.Node::Unescaped(name) => resolve_var(name, ctx, false)
    @types.Node::If(condition, body) =>
      if lookup(condition, ctx) != "" {
        render_nodes(body, ctx)
      } else {
        ""
      }
    @types.Node::IfElse(condition, body, else_body) =>
      if lookup(condition, ctx) != "" {
        render_nodes(body, ctx)
      } else {
        render_nodes(else_body, ctx)
      }
    @types.Node::Unless(condition, body) =>
      if lookup(condition, ctx) == "" {
        render_nodes(body, ctx)
      } else {
        ""
      }
    @types.Node::UnlessElse(condition, body, else_body) =>
      if lookup(condition, ctx) == "" {
        render_nodes(body, ctx)
      } else {
        render_nodes(else_body, ctx)
      }
    @types.Node::Each(collection, item_name, body) => {
      let val = lookup(collection, ctx)
      if val != "" {
        let items = split_items(val)
        let mut result = ""
        let mut i = 0
        while i < items.length() {
          let item_ctx = Array::new(capacity=ctx.length() + 1)
          let mut j = 0
          while j < ctx.length() {
            item_ctx.push(ctx[j])
            j = j + 1
          }
          item_ctx.push((item_name, items[i]))
          result = result + render_nodes(body, item_ctx)
          i = i + 1
        }
        result
      } else {
        ""
      }
    }
  }
}

///|
fn render_nodes(
  nodes : Array[@types.Node],
  ctx : Array[(String, String)],
) -> String {
  let mut result = ""
  let mut i = 0
  while i < nodes.length() {
    result = result + render(nodes[i], ctx)
    i = i + 1
  }
  result
}

///|
fn resolve_var(
  name : String,
  ctx : Array[(String, String)],
  escape : Bool,
) -> String {
  let val = lookup(name, ctx)
  if escape {
    html_escape(val)
  } else {
    val
  }
}

///|
fn lookup(key : String, ctx : Array[(String, String)]) -> String {
  let mut i = 0
  while i < ctx.length() {
    if ctx[i].0 == key {
      return ctx[i].1
    }
    i = i + 1
  }
  ""
}

///|
fn html_escape(s : String) -> String {
  let mut result = ""
  let mut i = 0
  while i < s.length() {
    let ch = s[i:i + 1].to_owned()
    match s[i] {
      '&' => result = result + "&amp;"
      '<' => result = result + "&lt;"
      '>' => result = result + "&gt;"
      '"' => result = result + "&quot;"
      '\'' => result = result + "&#39;"
      '`' => result = result + "&#96;"
      _ => result = result + ch
    }
    i = i + 1
  }
  result
}

///|
fn split_items(s : String) -> Array[String] {
  let items = Array::new(capacity=4)
  let len = s.length()
  let mut start = 0
  let mut i = 0
  while i < len {
    if s[i] == ',' {
      items.push(ltrim(s[start:i].to_owned()))
      start = i + 1
    }
    i = i + 1
  }
  if start < len {
    items.push(ltrim(s[start:].to_owned()))
  }
  items
}

///|
fn ltrim(s : String) -> String {
  let mut i = 0
  while i < s.length() && (s[i] == ' ' || s[i] == '\t') {
    i = i + 1
  }
  s[i:].to_owned()
}

///|
/// Enhanced renderer with partial and helper support.
pub fn render_enhanced(
  node : @types.Node,
  ctx : Array[(String, String)],
  partials : Array[@types.Partial],
  helpers : Array[@types.Helper],
) -> String {
  match node {
    @types.Node::Root(children) =>
      render_nodes_enhanced(children, ctx, partials, helpers)
    @types.Node::Text(text) => text
    @types.Node::Var(name) => {
      let val = lookup_enhanced(name, ctx, helpers)
      html_escape(val)
    }
    @types.Node::Unescaped(name) => lookup_enhanced(name, ctx, helpers)
    @types.Node::If(condition, body) =>
      if lookup(condition, ctx) != "" {
        render_nodes_enhanced(body, ctx, partials, helpers)
      } else {
        ""
      }
    @types.Node::IfElse(condition, body, else_body) =>
      if lookup(condition, ctx) != "" {
        render_nodes_enhanced(body, ctx, partials, helpers)
      } else {
        render_nodes_enhanced(else_body, ctx, partials, helpers)
      }
    @types.Node::Unless(condition, body) =>
      if lookup(condition, ctx) == "" {
        render_nodes_enhanced(body, ctx, partials, helpers)
      } else {
        ""
      }
    @types.Node::UnlessElse(condition, body, else_body) =>
      if lookup(condition, ctx) == "" {
        render_nodes_enhanced(body, ctx, partials, helpers)
      } else {
        render_nodes_enhanced(else_body, ctx, partials, helpers)
      }
    @types.Node::Each(collection, item_name, body) =>
      render_each_enhanced(collection, item_name, body, ctx, partials, helpers)
  }
}

///|
fn render_nodes_enhanced(
  nodes : Array[@types.Node],
  ctx : Array[(String, String)],
  partials : Array[@types.Partial],
  helpers : Array[@types.Helper],
) -> String {
  let mut result = ""
  for i in 0..<nodes.length() {
    result = result + render_enhanced(nodes[i], ctx, partials, helpers)
  }
  result
}

///|
fn render_each_enhanced(
  collection : String,
  item_name : String,
  body : Array[@types.Node],
  ctx : Array[(String, String)],
  partials : Array[@types.Partial],
  helpers : Array[@types.Helper],
) -> String {
  let val = lookup(collection, ctx)
  if val != "" {
    let items = split_items(val)
    let mut result = ""
    for i in 0..<items.length() {
      let item_ctx = Array::new(capacity=ctx.length() + 1)
      for j in 0..<ctx.length() {
        item_ctx.push(ctx[j])
      }
      item_ctx.push((item_name, items[i]))
      result = result + render_nodes_enhanced(body, item_ctx, partials, helpers)
    }
    result
  } else {
    ""
  }
}

///|
fn lookup_enhanced(
  key : String,
  ctx : Array[(String, String)],
  helpers : Array[@types.Helper],
) -> String {
  let val = lookup(key, ctx)
  for helper in helpers {
    if helper.name == key {
      return (helper.func)(val)
    }
  }
  val
}
