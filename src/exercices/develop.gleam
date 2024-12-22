import exercice
import expr/expr.{add, multiply}
import expr/simplify
import gleam/int
import gleam/list
import latex/latex

fn random_number() -> Int {
  let n = int.random(21) - 10

  case n {
    0 -> random_number()
    _ -> n
  }
}

fn generate_one_exerice() -> exercice.Question {
  let generate = fn() {
    let n = random_number()
    case n {
      1 -> #(1, expr.Var("x"))
      _ -> #(n, multiply([expr.Var("x"), expr.Number(n)]))
    }
  }

  let #(x_factor_1, a) = generate()
  let b = random_number()
  let #(x_factor_2, c) = generate()
  let d = random_number()

  let prompt =
    multiply([
      add(
        [a, expr.Number(b)]
        |> list.shuffle(),
      ),
      add(
        [c, expr.Number(d)]
        |> list.shuffle(),
      ),
    ])

  let solution =
    add([
      simplify.expr(multiply([a, c])),
      simplify.expr(
        multiply([expr.Var("x"), expr.Number(x_factor_1 * d + b * x_factor_2)]),
      ),
      simplify.expr(multiply([expr.Number(b), expr.Number(d)])),
    ])

  exercice.Question(
    prompt: latex.from_expr(prompt),
    solution: latex.from_expr(solution),
  )
}

pub fn generate() -> exercice.ExerciceSheet {
  let exercices =
    list.range(0, 2)
    |> list.map(fn(_) {
      exercice.Exercice(
        prompt: "Developper les expressions suivantes",
        questions: list.range(0, 2)
          |> list.map(fn(_) { generate_one_exerice() }),
      )
    })

  exercice.ExerciceSheet(exercices, title: "Developpement")
}
