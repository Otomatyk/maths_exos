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
  begin("enumerate", {
    list
    |> list.map(fn(ele) { "\\item \\hspace{5pt} " <> ele })
    |> string.join("\n")
  })
}

pub fn begin(env: String, inner: String) -> String {
  "\\begin{" <> env <> "}\n" <> inner <> "\n\\end{" <> env <> "}"
}

pub fn math(inner: String) -> String {
  "$" <> inner <> "$"
}

fn vspace(unit) {
  "\n\\vspace{" <> unit_to_string(unit) <> "}\n"
}

pub fn small_vspace() {
  vspace(Mm(2.0))
}

pub fn medium_vspace() {
  vspace(Mm(4.0))
}

pub fn large_vspace() {
  vspace(Mm(8.0))
}

pub fn extra_large_vspace() {
  vspace(Mm(12.0))
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
