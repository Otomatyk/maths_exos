import gleam/list
import gleam/string

pub fn ordered_list(list: List(String)) -> String {
  "\\begin{enumerate}\n"
  <> list.map(list, fn(s) { "    \\item \\hspace{5pt} " <> s })
  |> string.join("\n")
  <> "\n\\end{enumerate}"
}

pub fn begin(env: String, inner: String) -> String {
  "\\begin{" <> env <> "}\n" <> inner <> "\\end{" <> env <> "}"
}

pub fn math(inner: String) -> String {
  "$" <> inner <> "$"
}
