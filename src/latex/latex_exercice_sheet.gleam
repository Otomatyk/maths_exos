import exercices/types.{type ExerciceSheet}
import gleam/list
import gleam/string
import latex/latex_exercice
import latex/latex_utils.{begin, extra_large_vspace, large_vspace, par}

const documentclass = "\\documentclass[12pt, a4paper]{report}"

const preambul = "\\usepackage{lmodern}
\\usepackage[T1]{fontenc}
\\usepackage[french]{babel}
\\usepackage{amsmath}
\\usepackage{array}
\\usepackage[legalpaper, portrait, left=1cm, top=2cm]{geometry}"

fn sheet_title(title: String) -> String {
  "\n\\textbf{\\Huge " <> title <> " }" <> extra_large_vspace() <> par()
}

///  Generate the latex document of an `exercice.ExerciceSheet`
pub fn from(sheet: ExerciceSheet) -> String {
  let compiled_exercices =
    list.index_map(sheet.exercices, latex_exercice.compile_exercice)

  let #(problems, solutions) =
    compiled_exercices
    |> list.map(fn(i) { #(i.problems, i.solutions) })
    |> list.unzip()

  documentclass
  <> preambul
  <> begin("document", {
    sheet_title(sheet.title)
    <> string.join(problems, "\n")
    <> par()
    <> "\\newpage"
    <> "\n\\textbf{\\Huge Solutions}"
    <> large_vspace()
    <> par()
    <> string.join(solutions, "\n")
    <> par()
  })
}
