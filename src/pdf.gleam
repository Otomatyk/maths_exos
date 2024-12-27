import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

type FileUUID =
  String

@external(erlang, "call_cmd", "callCmd")
fn call_cmd(cmd: List(UtfCodepoint)) -> Nil

fn generate_file_uuid() -> FileUUID {
  list.range(1, 16)
  |> list.map(fn(_) {
    int.random(36)
    |> int.to_base36()
  })
  |> string.join("")
}

pub fn latex_to_pdf(latex_src: String) -> Result(Nil, simplifile.FileError) {
  use cwd <- result.try(simplifile.current_directory())
  let cwd = cwd <> "/tmp/output"

  case simplifile.is_directory(cwd) {
    Error(err) -> Error(err)
    Ok(False) -> {
      use _ <- result.try(simplifile.create_directory(cwd))

      latex_to_pdf(latex_src)
    }

    Ok(True) -> {
      let file_path = cwd <> "/generated_" <> generate_file_uuid()

      use _ <- result.try(simplifile.write(latex_src, to: file_path <> ".tex"))

      { "pdflatex " <> file_path <> ".tex --output-directory=" <> cwd }
      |> string.to_utf_codepoints()
      |> call_cmd()

      case simplifile.is_file(file_path <> ".pdf") {
        Error(err) -> Error(err)

        Ok(False) -> {
          Error(simplifile.Enoent)
        }

        Ok(True) -> {
          use _ <- result.try(simplifile.delete(file_path <> ".aux"))
          use _ <- result.try(simplifile.delete(file_path <> ".tex"))
          use _ <- result.try(simplifile.delete(file_path <> ".log"))

          Ok(Nil)
        }
      }
    }
  }
}
