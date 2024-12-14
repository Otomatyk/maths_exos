import exercices/develop
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
}
