# MoonTemplate

A Handlebars-style template engine for MoonBit.

## Installation

```bash
moon add JshsJ/moontemplate
```

## Quick Start

```moonbit
let ctx = [("name", "MoonBit")]
let html = @moontemplate.render_template("Hello {{ name }}!", ctx)
// html == "Hello MoonBit!"
```

## Features

- **Variable interpolation**: `{{ name }}`
- **Raw/unescaped output**: `{{{ html }}}`
- **Conditionals**: `{{#if show}}visible{{/if}}`
- **If/Else**: `{{#if flag}}yes{{else}}no{{/if}}`
- **Loops**: `{{#each items}}{{ this }}{{/each}}`
- **Automatic HTML escaping** (safe by default)

## API

| Function | Description |
|----------|-------------|
| `render_template(template, ctx)` | Parse and render in one call |
| `compile(template) -> AST` | Compile template to reusable AST |
| `render(ast, ctx) -> String` | Render a compiled AST with context |

Context is an `Array[(String, String)]` of variable name-value pairs.

## License

MIT

## New in 0.2.0

- **Comments**: `{{! inline }}` and `{{!-- block --}}`
- **Unless**: `{{#unless hide}}...{{/unless}}` with `{{else}}` support
