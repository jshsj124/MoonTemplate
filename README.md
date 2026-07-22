# MoonTemplate

A Handlebars-style template engine for MoonBit. It supports variable interpolation, raw output, conditionals, `unless`, loops, comments, and safe-by-default HTML escaping.

## Package metadata

| Field | Value |
|---|---|
| MoonBit package | `oilleelssq-wq/moontemplate` |
| Version | `0.1.0` |
| Repository | `https://github.com/oilleelssq-wq/moontemplate` |
| License | MIT |

> The package name above matches `moon.mod`; publishing and importing must use this exact namespace. Older namespaces are not substitutes.

## Installation

```bash
moon add oilleelssq-wq/moontemplate
```

Add the package to your app's `moon.pkg`:

```moonbit
import {
  "oilleelssq-wq/moontemplate"
}
```

## Complete runnable example

Create `cmd/main/moon.pkg`:

```moonbit
import {
  "oilleelssq-wq/moontemplate"
}

pkgtype(kind: "executable")
```

Create `cmd/main/main.mbt`:

```moonbit
///|
fn main {
  let template = "<h1>{{ title }}</h1>\n" +
    "<ul>{{#each items}}<li>{{ this }}</li>{{/each}}</ul>"
  let ctx = [
    ("title", "MoonTemplate <demo>"),
    ("items", "lexer,parser,renderer"),
  ]
  let html = @moontemplate.render_template(template, ctx)
  println(html)
}
```

Run it:

```bash
moon run cmd/main
```

Expected output:

```html
<h1>MoonTemplate &lt;demo&gt;</h1>
<ul><li>lexer</li><li>parser</li><li>renderer</li></ul>
```

## API

| Function | Description |
|---|---|
| `render_template(template, ctx)` | Parse and render a template string in one call. |
| `compile(template) -> @types.Node` | Compile a template to a reusable AST. |
| `render(ast, ctx) -> String` | Render a compiled AST with context. |
| `render_enhanced(template, ctx, partials, helpers)` | Render with partial/helper arrays. |
| `escape_html(text)` | Escape HTML-sensitive characters: `&`, `<`, `>`, `"`, `'`, and backtick. |

Context is an `Array[(String, String)]` of variable name-value pairs.

## Template features

- Variable interpolation: `{{ name }}`
- Raw/unescaped output: `{{{ html }}}`
- Conditionals: `{{#if show}}visible{{/if}}`
- If/else: `{{#if flag}}yes{{else}}no{{/if}}`
- Unless: `{{#unless hide}}visible{{/unless}}`
- Loops: `{{#each items}}{{ this }}{{/each}}`
- Comments: `{{! inline }}` and `{{!-- block --}}`
- Automatic HTML escaping for normal interpolation

## Development checks

```bash
moon fmt --check
moon check --deny-warn
moon test
moon build
moon info
```

## License

MIT
