import exercices/develop
import exercices/types.{ExerciceSheet, QuestionsExercice}

// import expr/expr
// import expr/simplify/simplify
import gleam/io
import latex/latex_exercice_sheet
import pdf
import random_numbers.{Negative, NonNull, NonPositiveOne, int_number_generator}

pub fn main() {
  io.println("Running...")

  exercice_sheet()
  |> latex_exercice_sheet.from()
  |> pdf.latex_to_pdf()
  |> io.debug()
}

fn exercice_sheet() {
  ExerciceSheet(title: "Developpement", exercices: [
    develop.second_degree_exercice(
      random_numbers_fn: int_number_generator([
        NonNull,
        Negative,
        NonPositiveOne,
      ]),
    ),
    develop.first_degree_exercice(
      random_numbers_fn: int_number_generator([
        NonNull,
        Negative,
        NonPositiveOne,
      ]),
      max_terms_number: 3,
    ),
    develop.true_or_false_first_dregree_exercice(
      random_numbers_fn: int_number_generator([NonNull, NonPositiveOne]),
      max_terms_number: 2,
    ),
    develop.map_exercice(
      random_numbers_fn: int_number_generator([
        NonNull,
        Negative,
        NonPositiveOne,
      ]),
      max_terms_number: 2,
    ),
    QuestionsExercice("Repondre aux questions suivantes", [
      types.Question("Quel est le théorème de Pythagore ?", "[flemme d'écrire]"),
      types.Question("Qu'est ce que le temps ?", "En fait [...]"),
      types.Question(
        "De le couleur était le cheval blanc d'Henri IV ?",
        "Blanc, évidemment",
      ),
    ]),
  ])
}
