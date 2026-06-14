/// Blackbox tests for MoonTemplate.

test "plain text passthrough" {
  let ctx = []
  let result = @moontemplate.render_template("Hello World", ctx)
  assert_eq!(result, "Hello World")
}

test "variable interpolation" {
  let ctx = [("name", "MoonBit")]
  let result = @moontemplate.render_template("Hello {{ name }}!", ctx)
  assert_eq!(result, "Hello MoonBit!")
}

test "multiple variables" {
  let ctx = [("first", "Hello"), ("last", "World")]
  let result = @moontemplate.render_template("{{ first }} {{ last }}", ctx)
  assert_eq!(result, "Hello World")
}

test "unescaped output" {
  let ctx = [("html", "<b>bold</b>")]
  let result = @moontemplate.render_template("{{{ html }}}", ctx)
  assert_eq!(result, "<b>bold</b>")
}

test "HTML escaping" {
  let ctx = [("code", "<script>alert(1)</script>")]
  let result = @moontemplate.render_template("{{ code }}", ctx)
  assert_eq!(result, "&lt;script&gt;alert(1)&lt;/script&gt;")
}

test "if block true" {
  let ctx = [("show", "yes")]
  let result = @moontemplate.render_template("{{#if show}}visible{{/if}}", ctx)
  assert_eq!(result, "visible")
}

test "if block false" {
  let ctx = []
  let result = @moontemplate.render_template("{{#if show}}visible{{/if}}", ctx)
  assert_eq!(result, "")
}

test "if else block" {
  let ctx = [("flag", "1")]
  let result = @moontemplate.render_template("{{#if flag}}yes{{else}}no{{/if}}", ctx)
  assert_eq!(result, "yes")
}

test "if else block false" {
  let ctx = []
  let result = @moontemplate.render_template("{{#if flag}}yes{{else}}no{{/if}}", ctx)
  assert_eq!(result, "no")
}

test "each loop" {
  let ctx = [("items", "a,b,c")]
  let result = @moontemplate.render_template("{{#each items}}{{ this }}{{/each}}", ctx)
  assert_eq!(result, "abc")
}

test "mixed template" {
  let ctx = [("title", "Page"), ("show", "1"), ("items", "x,y")]
  let template = "<h1>{{ title }}</h1>{{#if show}}<p>visible</p>{{/if}}<ul>{{#each items}}<li>{{ this }}</li>{{/each}}</ul>"
  let result = @moontemplate.render_template(template, ctx)
  assert_eq!(result, "<h1>Page</h1><p>visible</p><ul><li>x</li><li>y</li></ul>")
}

test "empty template" {
  let ctx = []
  let result = @moontemplate.render_template("", ctx)
  assert_eq!(result, "")
}

test "undefined variable" {
  let ctx = []
  let result = @moontemplate.render_template("{{ missing }}", ctx)
  assert_eq!(result, "")
}

test "ampersand escape" {
  let ctx = [("text", "a & b")]
  let result = @moontemplate.render_template("{{ text }}", ctx)
  assert_eq!(result, "a &amp; b")
}

test "compile and render" {
  let ast = @moontemplate.compile("Hello {{ name }}!")
  assert_eq!(@moontemplate.render(ast, [("name", "Alice")]), "Hello Alice!")
  assert_eq!(@moontemplate.render(ast, [("name", "Bob")]), "Hello Bob!")
}
