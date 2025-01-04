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
  "\n\\begin{" <> env <> "}\n" <> inner <> "\n\\end{" <> env <> "}"
}

pub fn begin_param(env: String, param: String, inner: String) {
  "\n\\begin{"
  <> env
  <> "}{"
  <> param
  <> "}\n"
  <> inner
  <> "\n\\end{"
  <> env
  <> "}"
}

pub fn math(inner: String) -> String {
  "$" <> inner <> "$"
}

pub fn par() {
  "\n\n"
}

pub fn bullet() {
  "$\\bullet$"
}

pub fn rightarrow() {
  "$\\rightarrow$"
}

fn hspace(unit) {
  "\n\\hspace{" <> unit_to_string(unit) <> "}"
}

pub fn extra_large_hspace() {
  hspace(Mm(12.0))
}

fn vspace(unit) {
  "\n\\vspace{" <> unit_to_string(unit) <> "}"
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

  "\n\n{\\renewcommand{\\arraystretch}{"
  <> float.to_string(padding_factor)
  <> "}"
  <> begin_param("tabular", pattern, {
    rows
    |> list.map(string.join(_, " & "))
    |> list.map(string.append(_, "\\\\"))
    |> string.join(row_divider <> "\n")
  })
  <> "}"
}

pub fn table_map(pairs: List(#(String, String))) -> String {
  pairs
  |> list.map(fn(pair) { [pair.0, rightarrow(), pair.1] })
  |> table("l c l", row_divider: False, padding_factor: 1.1)
}

pub fn unbreakable_block(inner: String) {
  begin_param("minipage", "\\linewidth", inner)
}
