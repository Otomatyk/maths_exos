import exercices/develop
import exercices/types.{ExerciceSheet}

// import expr/expr.{Number, Var, add, multiply}
import gleam/io
import latex/latex_exercice_sheet
import pdf
import random_numbers.{non_null_positive_int, non_null_relatif_int}

pub fn main() {
  io.println("Running...")

  exercice_sheet()
  |> latex_exercice_sheet.from()
  |> pdf.latex_to_pdf()
  |> io.debug()
}

fn exercice_sheet() {
  ExerciceSheet(title: "Developpement", exercices: [
    develop.second_degree_exercice(random_numbers_fn: non_null_relatif_int),
    develop.first_degree_exercice(
      random_numbers_fn: non_null_positive_int,
      max_terms_number: 3,
    ),
  ])
}
