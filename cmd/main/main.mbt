/// MoonTemplate CLI demo.

fn main {
  println("<html><body>")
  println("<h1>MoonTemplate Demo</h1>")

  let ctx1 = [("name", "MoonBit"), ("lang", "pure MoonBit")]
  println("<h2>Variables</h2>")
  let r1 = @moontemplate.render_template("<p>Hello <strong>{{ name }}</strong>! Built in {{ lang }}.</p>", ctx1)
  println(r1)

  println("<h2>Conditionals</h2>")
  let ctx2 = [("logged_in", "yes"), ("user", "Alice")]
  let r2 = @moontemplate.render_template("{{#if logged_in}}<p>Welcome back, {{ user }}!</p>{{else}}<p>Please log in.</p>{{/if}}", ctx2)
  println(r2)

  println("<h2>Loops</h2>")
  let ctx3 = [("items", "apple,banana,cherry")]
  let r3 = @moontemplate.render_template("<ul>{{#each items}}<li>{{ this }}</li>{{/each}}</ul>", ctx3)
  println(r3)

  println("<h2>HTML Escaping</h2>")
  let ctx4 = [("script", "<script>alert('xss')</script>")]
  let r4 = @moontemplate.render_template("<p>Escaped: {{ script }}</p>", ctx4)
  println(r4)

  println("</body></html>")
}
