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
/// - Automatic HTML escaping

/// Render a template string with context pairs.
pub fn render_template(template : String, ctx : Array[(String, String)]) -> String {
  let tokens = @lexer.tokenize(template)
  let ast = @parser.parse(tokens)
  @render.render(ast, ctx)
}

/// Compile a template string into an AST for reuse.
pub fn compile(template : String) -> @types.Node {
  let tokens = @lexer.tokenize(template)
  @parser.parse(tokens)
}

/// Render a compiled AST with context.
pub fn render(ast : @types.Node, ctx : Array[(String, String)]) -> String {
  @render.render(ast, ctx)
}
