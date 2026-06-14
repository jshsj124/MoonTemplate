/// Token and AST types for the template engine.

/// A token produced by the lexer.
pub(all) enum Token {
  /// Raw text content (HTML outside of {{ }})
  Text(String)
  /// Variable interpolation: {{ name }}
  Var(String)
  /// Block open: {{#if condition}}
  Open(String, String)
  /// Block close: {{/if}}
  Close(String)
  /// Raw/unescaped interpolation: {{{ html }}}
  Unescaped(String)
}

/// An AST node produced by the parser.
pub(all) enum Node {
  /// Raw text, rendered as-is
  Text(String)
  /// Escaped variable: {{ name }}
  Var(String)
  /// Unescaped variable: {{{ html }}}
  Unescaped(String)
  /// Conditional block
  If(String, Array[Node])
  /// Conditional block with else
  IfElse(String, Array[Node], Array[Node])
  /// Loop block
  Each(String, String, Array[Node])
  /// Root node
  Root(Array[Node])
}

/// Template context is Map[String, String]
