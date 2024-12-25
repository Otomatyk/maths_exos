import exercice
import exercices/develop
import gleam/io
import latex/latex
import pdf
import random_numbers.{non_null_positive_int, non_null_relatif_int}

pub fn main() {
  io.debug("Running...")

  exercice_sheet()
  |> latex.from_exercice_sheet()
  |> pdf.latex_to_pdf()
}

fn exercice_sheet() {
  exercice.ExerciceSheet(title: "Developpement", exercices: [
    develop.second_degree_exercice(random_numbers_fn: non_null_relatif_int),
  ])
}
