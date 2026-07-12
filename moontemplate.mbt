/// MoonTemplate — A Handlebars-style template engine for MoonBit.
///
/// # Quick Start
///
/// ```moonbit
/// let ctx = [("name", "World")]
/// let html = @moontemplate.render_template("Hello {{ name }}!", ctx)
/// // html == "Hello World!"
/// ```
///
/// # Features
/// - Variable interpolation: {{ name }}
/// - Raw/unescaped output: {{{ html }}}
/// - Conditionals: {{#if condition}} ... {{/if}}
/// - If/Else: {{#if condition}} ... {{else}} ... {{/if}}
/// - Loops: {{#each items}} ... {{/each}}
/// - Partials: {{> partial_name}}
/// - Helpers: custom transformation functions
/// - Automatic HTML escaping
/// - Error diagnostics with line/column info

///|
/// Render a template string with context pairs.
pub fn render_template(
  template : String,
  ctx : Array[(String, String)],
) -> String {
  let tokens = @lexer.tokenize(template)
  let ast = @parser.parse(tokens)
  @render.render(ast, ctx)
}

///|
/// Compile a template string into an AST for reuse.
pub fn compile(template : String) -> @types.Node {
  let tokens = @lexer.tokenize(template)
  @parser.parse(tokens)
}

///|
/// Render a compiled AST with context.
pub fn render(ast : @types.Node, ctx : Array[(String, String)]) -> String {
  @render.render(ast, ctx)
}

///|
/// Render a template with enhanced context, partials, and helpers.
pub fn render_enhanced(
  template : String,
  ctx : Array[(String, String)],
  partials : Array[@types.Partial],
  helpers : Array[@types.Helper],
) -> String {
  let tokens = @lexer.tokenize(template)
  let ast = @parser.parse(tokens)
  @render.render_enhanced(ast, ctx, partials, helpers)
}

///|
/// Escape HTML special characters. Public for convenience.
pub fn escape_html(text : String) -> String {
  let mut result = ""
  let mut i = 0
  while i < text.length() {
    match text[i] {
      '&' => result = result + "&amp;"
      '<' => result = result + "&lt;"
      '>' => result = result + "&gt;"
      '"' => result = result + "&quot;"
      _ => result = result + text[i:i + 1].to_owned()
    }
    i = i + 1
  }
  result
}

///|
/// Find a partial by name in the partials array.
pub fn find_partial(name : String, partials : Array[@types.Partial]) -> String {
  for partial in partials {
    if partial.name == name {
      return partial.template
    }
  }
  ""
}

///|
/// Apply a named helper to a value.
pub fn apply_helper(
  name : String,
  value : String,
  helpers : Array[@types.Helper],
) -> String? {
  for helper in helpers {
    if helper.name == name {
      let result = (helper.func)(value)
      return Some(result)
    }
  }
  None
}
