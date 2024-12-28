import exercices/types.{type CompiledExercice, type Exercice, CompiledExercice}
import gleam/int
import gleam/list
import gleam/string
import latex/latex_expr
import latex/latex_utils.{begin, ordered_list}
import utils

const par = "\n\n"

const list_vspace = "\\vspace{2mm}"

const documentclass = "\\documentclass[12pt, a4paper]{report}"

const preambul = "\\usepackage{lmodern}
\\usepackage[T1]{fontenc}
\\usepackage[french]{babel}
\\usepackage{amsmath}
\\usepackage[legalpaper, portrait, left=1cm, top=2cm]{geometry}"

fn sheet_title(title: String) -> String {
  "\\textbf{\\Huge " <> title <> " }\n\\vspace{10mm}"
}

fn exercice_title(idx: Int) -> String {
  par
  <> "\\textbf{\\Large Exercice "
  <> int.to_string(idx)
  <> "}\n\\vspace{2mm}"
  <> par
}

fn solution_and_prompt_exercice(ex: Exercice, idx: Int) -> CompiledExercice {
  let exercice_title = exercice_title(idx + 1)

  let #(prompt, solution) = case ex {
    types.EqualityListExercice(prompt, equalities) -> {
      let prompt =
        prompt
        <> "\\vspace{4mm}"
        <> par
        <> {
          equalities
          |> list.index_map(fn(eq, eq_idx) {
            utils.int_to_uppercase_letter(eq_idx)
            <> " = $"
            <> latex_expr.from(eq.initial_expr)
            <> "$"
          })
          |> string.join(par <> list_vspace)
        }

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

      #(prompt, solutions)
    }

    types.QuestionsExercice(prompt, questions) -> {
      let prompt =
        prompt
        <> "\\vspace{4mm}"
        <> par
        <> {
          questions
          |> list.map(fn(q) { q.prompt })
          |> ordered_list()
        }

      let solutions =
        list.map(questions, fn(q) { q.solution }) |> ordered_list()

      #(prompt, solutions)
    }
  }

  CompiledExercice(
    problems: exercice_title <> prompt,
    solutions: exercice_title <> solution,
  )
}

///  Generate the latex document of an `exercice.ExerciceSheet`
pub fn from(sheet: types.ExerciceSheet) -> String {
  let compiled_exercices =
    list.index_map(sheet.exercices, solution_and_prompt_exercice)

  let solutions = list.map(compiled_exercices, fn(i) { i.solutions })
  let problems = list.map(compiled_exercices, fn(i) { i.problems })

  documentclass
  <> par
  <> preambul
  <> par
  <> begin("document", {
    par
    <> sheet_title(sheet.title)
    <> string.join(problems, "\\vspace{10mm}")
    <> par
    <> "\\newpage
\\textbf{\\Huge Solutions}
\\vspace{8mm}"
    <> par
    <> string.join(solutions, "\n\\vspace{10mm}")
    <> par
  })
}
