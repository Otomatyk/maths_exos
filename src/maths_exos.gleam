import exercices/develop
import gleam/io
import latex/latex
import simplifile

pub fn main() {
  let file_path = "C:/Users/Soacramea/Documents/Dev/latex/generated.tex"

  let str =
    develop.generate()
    |> latex.from_exercice_sheet()

  let assert Ok(_) =
    str
    |> simplifile.write(to: file_path)
  // let ex =
  //   expr.Addition(terms: [
  //     expr.Multiplication(factors: [expr.Number(10), expr.Variable("x")]),
  //     expr.Number(4),
  //   ])

  // (-10 + x) + (x + 15)
  //  -10 + x  +  x + 15
  //   2x + 5

  // (-10 * x) + (x + 15)
  // (-10 * x) +  x + 15
  //  -9x + 15

  // 5(x + 8) + x + 10
  // 5x + 40  + x + 10
  // 6x + 50
}
