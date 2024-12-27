import exercices/types.{
  type CompiledExercice, type Exercice, type ExerciceSheet, CompiledExercice,
}
import gleam/int
import gleam/list
import gleam/string

const par = "\n\n"

const documentclass = "\\documentclass[12pt, a4paper]{report}"

const preambul = "\\usepackage{lmodern}
\\usepackage[french]{babel}
\\usepackage[legalpaper, portrait, left=1cm, top=2cm]{geometry}"

fn generate_title(title: String) -> String {
  "\\textbf{\\Huge " <> title <> " }\n\\vspace{10mm}"
}

fn ordered_list(list: List(String)) -> String {
  "\\begin{enumerate}\n"
  <> list.map(list, fn(s) { "    \\item \\hspace{5pt} " <> s })
  |> string.join("\n")
  <> "\n\\end{enumerate}"
}

fn solution_and_prompt_exercice(ex: Exercice, idx: Int) -> CompiledExercice {
  let questions_prompt = list.map(ex.questions, fn(q) { q.prompt })
  let questions_solutions = list.map(ex.questions, fn(q) { q.solution })

  let exercice_title =
    par
    <> "\\textbf{\\Large Exercice "
    <> int.to_string(idx + 1)
    <> "}\n\\vspace{2mm}"
    <> par

  let prompt =
    exercice_title
    <> ex.prompt
    <> "\\vspace{4mm}"
    <> par
    <> ordered_list(questions_prompt)

  let solution = exercice_title <> ordered_list(questions_solutions)

  CompiledExercice(problems: prompt, solutions: solution)
}

pub fn generate(sheet: ExerciceSheet) -> String {
  let compiled_exercices =
    list.index_map(sheet.exercices, solution_and_prompt_exercice)

  let solutions = list.map(compiled_exercices, fn(i) { i.solutions })
  let problems = list.map(compiled_exercices, fn(i) { i.problems })

  documentclass
  <> par
  <> preambul
  <> par
  <> "\\begin{document}"
  <> par
  <> generate_title(sheet.title)
  <> string.join(problems, "\\vspace{10mm}")
  <> par
  <> "\\newpage
\\textbf{\\Huge Solutions}
\\vspace{8mm}"
  <> par
  <> string.join(solutions, "\\vspace{10mm}")
  <> par
  <> "\\end{document}"
}
