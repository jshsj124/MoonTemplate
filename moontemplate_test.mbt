/// Blackbox tests for MoonTemplate.

test "plain text passthrough" {
  let result = @moontemplate.render_template("Hello World", [])
  assert_eq!(result, "Hello World")
}

test "variable interpolation" {
  let result = @moontemplate.render_template("Hello {{ name }}!", [("name", "MoonBit")])
  assert_eq!(result, "Hello MoonBit!")
}

test "multiple variables" {
  let result = @moontemplate.render_template("{{ first }} {{ last }}", [("first", "Hello"), ("last", "World")])
  assert_eq!(result, "Hello World")
}

test "unescaped output" {
  let result = @moontemplate.render_template("{{{ html }}}", [("html", "<b>bold</b>")])
  assert_eq!(result, "<b>bold</b>")
}

test "HTML escaping" {
  let result = @moontemplate.render_template("{{ code }}", [("code", "<script>alert(1)</script>")])
  assert_eq!(result, "&lt;script&gt;alert(1)&lt;/script&gt;")
}

test "if block true" {
  let result = @moontemplate.render_template("{{#if show}}visible{{/if}}", [("show", "yes")])
  assert_eq!(result, "visible")
}

test "if block false" {
  let result = @moontemplate.render_template("{{#if show}}visible{{/if}}", [])
  assert_eq!(result, "")
}

test "if else block true" {
  let result = @moontemplate.render_template("{{#if flag}}yes{{else}}no{{/if}}", [("flag", "1")])
  assert_eq!(result, "yes")
}

test "if else block false" {
  let result = @moontemplate.render_template("{{#if flag}}yes{{else}}no{{/if}}", [])
  assert_eq!(result, "no")
}

test "unless block false" {
  let result = @moontemplate.render_template("{{#unless hide}}shown{{/unless}}", [])
  assert_eq!(result, "shown")
}

test "unless block true" {
  let result = @moontemplate.render_template("{{#unless hide}}shown{{/unless}}", [("hide", "1")])
  assert_eq!(result, "")
}

test "unless else block" {
  let result = @moontemplate.render_template("{{#unless hide}}visible{{else}}hidden{{/unless}}", [])
  assert_eq!(result, "visible")
}

test "unless else block hidden" {
  let result = @moontemplate.render_template("{{#unless hide}}visible{{else}}hidden{{/unless}}", [("hide", "1")])
  assert_eq!(result, "hidden")
}

test "comment removed" {
  let result = @moontemplate.render_template("before{{! this is a comment }}after", [])
  assert_eq!(result, "beforeafter")
}

test "comment with dashes" {
  let result = @moontemplate.render_template("start{{!-- block comment --}}end", [])
  assert_eq!(result, "startend")
}

test "each loop" {
  let result = @moontemplate.render_template("{{#each items}}{{ this }}{{/each}}", [("items", "a,b,c")])
  assert_eq!(result, "abc")
}

test "each with separator" {
  let result = @moontemplate.render_template("{{#each items}}{{ this }}, {{/each}}", [("items", "a,b")])
  assert_eq!(result, "a, b, ")
}

test "mixed template" {
  let ctx = [("title", "Page"), ("show", "1"), ("items", "x,y")]
  let tpl = "<h1>{{ title }}</h1>{{#if show}}<p>visible</p>{{/if}}<ul>{{#each items}}<li>{{ this }}</li>{{/each}}</ul>"
  let result = @moontemplate.render_template(tpl, ctx)
  assert_eq!(result, "<h1>Page</h1><p>visible</p><ul><li>x</li><li>y</li></ul>")
}

test "empty template" {
  assert_eq!(@moontemplate.render_template("", []), "")
}

test "undefined variable" {
  assert_eq!(@moontemplate.render_template("{{ missing }}", []), "")
}

test "ampersand escape" {
  assert_eq!(@moontemplate.render_template("{{ text }}", [("text", "a & b")]), "a &amp; b")
}

test "compile and render" {
  let ast = @moontemplate.compile("Hello {{ name }}!")
  assert_eq!(@moontemplate.render(ast, [("name", "Alice")]), "Hello Alice!")
  assert_eq!(@moontemplate.render(ast, [("name", "Bob")]), "Hello Bob!")
}

test "nested if inside each" {
  let ctx = [("items", "a,b"), ("highlight", "1")]
  let tpl = "{{#each items}}{{#if highlight}}*{{/if}}{{ this }}{{/each}}"
  let result = @moontemplate.render_template(tpl, ctx)
  assert_eq!(result, "*a*b")
}

test "comment between tags" {
  let result = @moontemplate.render_template("{{ name }}{{! comment }}{{ name }}", [("name", "X")])
  assert_eq!(result, "XX")
}

test "unless with context variable" {
  let result = @moontemplate.render_template("{{#unless empty}}content{{/unless}}", [("empty", "")])
  assert_eq!(result, "content")
}
