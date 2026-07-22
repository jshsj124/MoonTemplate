///|
/// Blackbox tests for MoonTemplate.
test "plain text passthrough" {
  let result = @moontemplate.render_template("Hello World", [])
  assert_eq(result, "Hello World")
}

///|
test "variable interpolation" {
  let result = @moontemplate.render_template("Hello {{ name }}!", [
    ("name", "MoonBit"),
  ])
  assert_eq(result, "Hello MoonBit!")
}

///|
test "multiple variables" {
  let result = @moontemplate.render_template("{{ first }} {{ last }}", [
    ("first", "Hello"),
    ("last", "World"),
  ])
  assert_eq(result, "Hello World")
}

///|
test "unescaped output" {
  let result = @moontemplate.render_template("{{{ html }}}", [
    ("html", "<b>bold</b>"),
  ])
  assert_eq(result, "<b>bold</b>")
}

///|
test "HTML escaping" {
  let result = @moontemplate.render_template("{{ code }}", [
    ("code", "<script>alert(1)</script>"),
  ])
  assert_eq(result, "&lt;script&gt;alert(1)&lt;/script&gt;")
}

///|
test "if block true" {
  let result = @moontemplate.render_template("{{#if show}}visible{{/if}}", [
    ("show", "yes"),
  ])
  assert_eq(result, "visible")
}

///|
test "if block false" {
  let result = @moontemplate.render_template("{{#if show}}visible{{/if}}", [])
  assert_eq(result, "")
}

///|
test "if else block true" {
  let result = @moontemplate.render_template(
    "{{#if flag}}yes{{else}}no{{/if}}",
    [("flag", "1")],
  )
  assert_eq(result, "yes")
}

///|
test "if else block false" {
  let result = @moontemplate.render_template(
    "{{#if flag}}yes{{else}}no{{/if}}",
    [],
  )
  assert_eq(result, "no")
}

///|
test "unless block false" {
  let result = @moontemplate.render_template(
    "{{#unless hide}}shown{{/unless}}",
    [],
  )
  assert_eq(result, "shown")
}

///|
test "unless block true" {
  let result = @moontemplate.render_template(
    "{{#unless hide}}shown{{/unless}}",
    [("hide", "1")],
  )
  assert_eq(result, "")
}

///|
test "unless else block" {
  let result = @moontemplate.render_template(
    "{{#unless hide}}visible{{else}}hidden{{/unless}}",
    [],
  )
  assert_eq(result, "visible")
}

///|
test "unless else block hidden" {
  let result = @moontemplate.render_template(
    "{{#unless hide}}visible{{else}}hidden{{/unless}}",
    [("hide", "1")],
  )
  assert_eq(result, "hidden")
}

///|
test "comment removed" {
  let result = @moontemplate.render_template(
    "before{{! this is a comment }}after",
    [],
  )
  assert_eq(result, "beforeafter")
}

///|
test "comment with dashes" {
  let result = @moontemplate.render_template(
    "start{{!-- block comment --}}end",
    [],
  )
  assert_eq(result, "startend")
}

///|
test "each loop" {
  let result = @moontemplate.render_template(
    "{{#each items}}{{ this }}{{/each}}",
    [("items", "a,b,c")],
  )
  assert_eq(result, "abc")
}

///|
test "each with separator" {
  let result = @moontemplate.render_template(
    "{{#each items}}{{ this }}, {{/each}}",
    [("items", "a,b")],
  )
  assert_eq(result, "a, b, ")
}

///|
test "mixed template" {
  let ctx = [("title", "Page"), ("show", "1"), ("items", "x,y")]
  let tpl = "<h1>{{ title }}</h1>{{#if show}}<p>visible</p>{{/if}}<ul>{{#each items}}<li>{{ this }}</li>{{/each}}</ul>"
  let result = @moontemplate.render_template(tpl, ctx)
  assert_eq(result, "<h1>Page</h1><p>visible</p><ul><li>x</li><li>y</li></ul>")
}

///|
test "empty template" {
  assert_eq(@moontemplate.render_template("", []), "")
}

///|
test "undefined variable" {
  assert_eq(@moontemplate.render_template("{{ missing }}", []), "")
}

///|
test "ampersand escape" {
  assert_eq(
    @moontemplate.render_template("{{ text }}", [("text", "a & b")]),
    "a &amp; b",
  )
}

///|
test "HTML escaping covers quotes used in attributes" {
  let payload = "' onmouseover='alert(1)`"
  let result = @moontemplate.render_template(
    "<button data-name='{{ name }}'>x</button>",
    [("name", payload)],
  )
  assert_eq(
    result, "<button data-name='&#39; onmouseover=&#39;alert(1)&#96;'>x</button>",
  )
  assert_false(result.contains("data-name=''"))
  assert_false(result.contains("onmouseover='alert(1)"))
}

///|
test "escape_html public function escapes all dangerous HTML characters" {
  assert_eq(
    @moontemplate.escape_html("&<>\"'`"),
    "&amp;&lt;&gt;&quot;&#39;&#96;",
  )
}

///|
test "compile and render" {
  let ast = @moontemplate.compile("Hello {{ name }}!")
  assert_eq(@moontemplate.render(ast, [("name", "Alice")]), "Hello Alice!")
  assert_eq(@moontemplate.render(ast, [("name", "Bob")]), "Hello Bob!")
}

///|
test "nested if inside each" {
  let ctx = [("items", "a,b"), ("highlight", "1")]
  let tpl = "{{#each items}}{{#if highlight}}*{{/if}}{{ this }}{{/each}}"
  let result = @moontemplate.render_template(tpl, ctx)
  assert_eq(result, "*a*b")
}

///|
test "comment between tags" {
  let result = @moontemplate.render_template(
    "{{ name }}{{! comment }}{{ name }}",
    [("name", "X")],
  )
  assert_eq(result, "XX")
}

///|
test "unless with context variable" {
  let result = @moontemplate.render_template(
    "{{#unless empty}}content{{/unless}}",
    [("empty", "")],
  )
  assert_eq(result, "content")
}

///|
test "render_enhanced with helper and partial args" {
  let helpers = [@types.Helper::{ name: "upper", func: fn(s) { s.to_upper() } }]
  let partials = [
    @types.Partial::{
      name: "wrap",
      template: "[" + @moontemplate.escape_html("text") + "]",
    },
  ]
  let template = "{{ title }}"
  let ctx = [("title", "my page")]
  let ast = @moontemplate.compile(template)
  let result = @render.render_enhanced(ast, ctx, partials, helpers)
  assert_eq(result, "my page")
}

///|
test "render_enhanced with partial" {
  let partials = [
    @types.Partial::{ name: "header", template: "<h1>{{ title }}</h1>" },
  ]
  let template = "start-{{ title }}-end"
  let ctx = [("title", "MyPage")]
  let result = @moontemplate.render_enhanced(template, ctx, partials, [])
  assert_eq(result, "start-MyPage-end")
}

///|
test "find_partial returns template by name" {
  let partials = [@types.Partial::{ name: "nav", template: "<nav>{{}}</nav>" }]
  assert_eq(@moontemplate.find_partial("nav", partials), "<nav>{{}}</nav>")
  assert_eq(@moontemplate.find_partial("missing", partials), "")
}

///|
test "apply_helper returns transformed value" {
  let helpers = [
    @types.Helper::{ name: "reverse", func: fn(s) { reverse_str(s) } },
  ]
  match @moontemplate.apply_helper("reverse", "abc", helpers) {
    Some(v) => assert_eq(v, "cba")
    None => assert_false(true)
  }
  match @moontemplate.apply_helper("missing", "abc", helpers) {
    Some(_) => assert_false(true)
    None => ()
  }
}

///|
fn reverse_str(s : String) -> String {
  let chars = s.iter().to_array()
  let mut result = ""
  let mut i = chars.length()
  while i > 0 {
    i = i - 1
    result = result + s[i:i + 1].to_owned()
  }
  result
}

///|
test "escape_html public function" {
  let result = @moontemplate.escape_html("<script>alert('x')</script>")
  assert_true(result.contains("&lt;"))
  assert_true(result.contains("&gt;"))
  assert_false(result.contains("<script>"))
}

///|
test "compile and render separately" {
  let ast = @moontemplate.compile("Hello {{ who }}!")
  let html = @moontemplate.render(ast, [("who", "MoonBit")])
  assert_eq(html, "Hello MoonBit!")
}

///|
test "context_from_pairs converts flat pairs" {
  let ctx = @types.context_from_pairs([("a", "1"), ("b", "2")])
  assert_eq(ctx.length(), 2)
  assert_eq(ctx[0].0, "a")
}

///|
test "context_lookup finds values" {
  let ctx = @types.context_from_pairs([("x", "42")])
  assert_eq(@types.context_lookup("x", ctx), "42")
  assert_eq(@types.context_lookup("y", ctx), "")
}

///|
test "template_error format includes location" {
  let err = @types.template_error("bad syntax", 5, 12)
  let msg = @types.format_template_error(err)
  assert_true(msg.contains("line 5"))
  assert_true(msg.contains("col 12"))
}

///|
test "nested conditional each with else" {
  let template = "{{#each items}}{{#if active}}{{name}},{{else}}(none),{{/if}}{{/each}}"
  let ctx = [("items", "a,b"), ("active", "yes"), ("name", "Test")]
  let result = @moontemplate.render_template(template, ctx)
  assert_eq(result, "Test,Test,")
}
