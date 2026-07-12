/// Token and AST types for the template engine.

///|
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

///|
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

// ------- Enhanced Context -------

///|
/// A template context value: either a string or a nested array.
pub(all) enum ContextValue {
  Str(String)
  List(Array[ContextValue])
  Object(Array[(String, ContextValue)])
} derive(Eq)

///|
/// Build context from a flat array of string pairs.
pub fn context_from_pairs(
  pairs : Array[(String, String)],
) -> Array[(String, ContextValue)] {
  let result : Array[(String, ContextValue)] = []
  for pair in pairs {
    result.push((pair.0, ContextValue::Str(pair.1)))
  }
  result
}

///|
/// Lookup a key in a context array (returns empty string if not found).
pub fn context_lookup(
  key : String,
  ctx : Array[(String, ContextValue)],
) -> String {
  for i in 0..<ctx.length() {
    if ctx[i].0 == key {
      match ctx[i].1 {
        Str(v) => return v
        _ => return "[complex]"
      }
    }
  }
  ""
}

///|
/// Flatten a ContextValue to a simple key-value array (for nested each).
pub fn context_flatten(value : ContextValue) -> Array[(String, ContextValue)] {
  match value {
    Str(_) => []
    List(items) => {
      let result : Array[(String, ContextValue)] = []
      for item in items {
        result.push(("this", item))
      }
      result
    }
    Object(_) => []
  }
}

// ------- Error Diagnostics -------

///|
/// A template error with location info.
pub(all) struct TemplateError {
  message : String
  line : Int
  column : Int
} derive(Eq)

///|
/// Create a template error.
pub fn template_error(
  message : String,
  line : Int,
  column : Int,
) -> TemplateError {
  { message, line, column }
}

///|
/// Format a template error for display.
pub fn format_template_error(err : TemplateError) -> String {
  "line \{err.line}, col \{err.column}: \{err.message}"
}

// ------- Partial & Helper Support -------

///|
/// A partial template loaded by name.
pub(all) struct Partial {
  name : String
  template : String
} derive(Eq)

///|
/// A helper function that takes a string argument and returns a string.
pub(all) struct Helper {
  name : String
  func : (String) -> String
}
