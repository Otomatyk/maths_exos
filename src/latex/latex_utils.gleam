import gleam/float
import gleam/list
import gleam/string

pub type LatexUnit {
  Mm(Float)
}

fn unit_to_string(unit: LatexUnit) -> String {
  case unit {
    Mm(n) -> float.to_string(n) <> "mm"
  }
}

pub fn ordered_list(list: List(String)) -> String {
  "\\begin{enumerate}\n"
  <> list.map(list, fn(s) { "    \\item \\hspace{5pt} " <> s })
  |> string.join("\n")
  <> "\n\\end{enumerate}"
}

pub fn begin(env: String, inner: String) -> String {
  "\\begin{" <> env <> "}\n" <> inner <> "\n\\end{" <> env <> "}"
}

pub fn math(inner: String) -> String {
  "$" <> inner <> "$"
}

pub fn table(
  rows: List(List(String)),
  pattern: String,
  row_divider row_divider: Bool,
  padding_factor padding_factor: Float,
) -> String {
  let row_divider = case row_divider {
    True -> " \\hline"
    False -> ""
  }

  "{\\renewcommand{\\arraystretch}{"
  <> float.to_string(padding_factor)
  <> "}"
  <> begin("tabular", {
    "{ "
    <> pattern
    <> " } \n"
    <> rows
    |> list.map(string.join(_, " & "))
    |> list.map(string.append(_, "\\\\"))
    |> string.join(row_divider <> "\n")
  })
  <> "}"
}
