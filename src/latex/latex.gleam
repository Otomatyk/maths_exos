import exercices/types.{type ExerciceSheet}
import expr/expr
import gleam/list
import gleam/string
import latex/latex_exercice_sheet
import latex/latex_expr

/// Generate the latex code of an expression, wrapped with `$`
pub fn from_expr(expr: expr.Expr) -> String {
  latex_expr.generate(expr)
}

/// Generate the latex document of an `exercice.ExerciceSheet`, wrapped with `$`
pub fn from_exercice_sheet(sheet: ExerciceSheet) -> String {
  latex_exercice_sheet.generate(sheet)
}

pub fn ordered_list(list: List(String)) -> String {
  "\\begin{enumerate}"
  <> list.map(list, fn(s) { "\\item " <> s })
  |> string.join("\n")
  <> "\\end{enumerate}"
}
