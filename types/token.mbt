/// Token and AST types for the template engine.

/// A token produced by the lexer.
pub(all) enum Token {
  /// Raw text content (HTML outside of {{ }})
  Text(String)
  /// Variable interpolation: {{ name }}
  Var(String)
  /// Block open: {{#if condition}} or {{#unless condition}}
  Open(String, String)
  /// Block close: {{/if}} or {{/unless}} or {{/each}}
  Close(String)
  /// Raw/unescaped interpolation: {{{ html }}}
  Unescaped(String)
  /// Comment: {{!-- text --}}
  Comment(String)
}

/// An AST node produced by the parser.
pub(all) enum Node {
  /// Raw text, rendered as-is
  Text(String)
  /// Escaped variable: {{ name }}
  Var(String)
  /// Unescaped variable: {{{ html }}}
  Unescaped(String)
  /// Conditional block: {{#if condition}}...{{/if}}
  If(String, Array[Node])
  /// Conditional block with else: {{#if condition}}...{{else}}...{{/if}}
  IfElse(String, Array[Node], Array[Node])
  /// Negated conditional: {{#unless condition}}...{{/unless}}
  Unless(String, Array[Node])
  /// Negated conditional with else
  UnlessElse(String, Array[Node], Array[Node])
  /// Loop block: {{#each items}}...{{/each}}
  Each(String, String, Array[Node])
  /// Root node
  Root(Array[Node])
}

/// Template context is an array of (key, value) pairs.
/// Use `[("name", "value")]` to construct.
