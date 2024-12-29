import exercices/types.{type CompiledExercice, type Exercice, CompiledExercice}
import gleam/int
import gleam/list
import gleam/string
import latex/latex_expr
import latex/latex_utils.{
  begin, extra_large_vspace, large_vspace, medium_vspace, ordered_list,
  small_vspace,
}
import utils

const par = "\n\n"

const documentclass = "\\documentclass[12pt, a4paper]{report}"

const preambul = "\\usepackage{lmodern}
\\usepackage[T1]{fontenc}
\\usepackage[french]{babel}
\\usepackage{amsmath}
\\usepackage{array}
\\usepackage[legalpaper, portrait, left=1cm, top=2cm]{geometry}"

fn sheet_title(title: String) -> String {
  "\\textbf{\\Huge " <> title <> " }" <> extra_large_vspace()
}

fn exercice_title(idx: Int) -> String {
  par
  <> "\\textbf{\\Large Exercice "
  <> int.to_string(idx)
  <> "}"
  <> small_vspace()
  <> par
}

fn equality_list_exercice(prompt, equalities: List(types.Equality)) {
  let body =
    equalities
    |> list.index_map(fn(eq, eq_idx) {
      utils.int_to_uppercase_letter(eq_idx)
      <> " = $"
      <> latex_expr.from(eq.initial_expr)
      <> "$"
    })
    |> string.join(par <> small_vspace())

  let solutions =
    equalities
    |> list.index_map(fn(eq, eq_idx) {
      begin("flalign*", {
        utils.int_to_uppercase_letter(eq_idx)
        <> {
          eq.solution_steps
          |> list.map(latex_expr.from)
          |> list.map(string.append(" & = ", _))
          |> string.join("&&\\\\")
        }
      })
    })
    |> string.join("\n")

  #(prompt, body, solutions)
}

fn questions_exercice(prompt, questions: List(types.Question)) {
  let body =
    questions
    |> list.map(fn(q) { q.prompt })
    |> ordered_list()

  let solutions = questions |> list.map(fn(q) { q.solution }) |> ordered_list()

  #(prompt, body, solutions)
}

fn true_or_false_exercice(affirmations) {
  let body =
    affirmations
    |> list.map(fn(affirmation_tuple) {
      let #(affirmation, _) = affirmation_tuple

      [affirmation, " V / F"]
    })
    |> latex_utils.table(
      "w{l}{0.9\\columnwidth} | w{c}{0.1\\columnwidth}",
      row_divider: True,
      padding_factor: 2.5,
    )

  let solutions =
    affirmations
    |> list.map(fn(affirmation_tuple) {
      let #(affirmation, truthfullness) = affirmation_tuple

      [
        affirmation,
        "$\\rightarrow$",
        case truthfullness {
          True -> "Vrai"
          False -> "Faux"
        },
      ]
    })
    |> latex_utils.table("l l l", row_divider: False, padding_factor: 1.1)

  #(
    "Pour chaque affirmaton, sans justification entourer le V si elle est vraie sinon entourer le F",
    body,
    solutions,
  )
}

fn solution_and_prompt_exercice(ex: Exercice, idx: Int) -> CompiledExercice {
  let #(prompt, body, solution) = case ex {
    types.EqualityListExercice(prompt, equalities) ->
      equality_list_exercice(prompt, equalities)

    types.QuestionsExercice(prompt, questions) ->
      questions_exercice(prompt, questions)

    types.TrueOrFalseExercice(affirmations) ->
      true_or_false_exercice(affirmations)
  }

  let exercice_title = exercice_title(idx + 1)

  CompiledExercice(
    problems: exercice_title <> prompt <> medium_vspace() <> par <> body,
    solutions: exercice_title <> solution,
  )
}

///  Generate the latex document of an `exercice.ExerciceSheet`
pub fn from(sheet: types.ExerciceSheet) -> String {
  let compiled_exercices =
    list.index_map(sheet.exercices, solution_and_prompt_exercice)

  let #(problems, solutions) =
    compiled_exercices
    |> list.map(fn(i) { #(i.problems, i.solutions) })
    |> list.unzip()

  documentclass
  <> par
  <> preambul
  <> par
  <> begin("document", {
    par
    <> sheet_title(sheet.title)
    <> string.join(problems, large_vspace())
    <> par
    <> "\\newpage
\\textbf{\\Huge Solutions}"
    <> large_vspace()
    <> par
    <> string.join(solutions, large_vspace())
    <> par
  })
}
