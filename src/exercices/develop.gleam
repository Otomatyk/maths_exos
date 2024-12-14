import gleam/int
import gleam/list
import latex/latex
import expr.{multiply}
import eval.{simplify}
import exercice

fn random_number() -> Int {
  int.random(10) 
}

pub fn generate_one_exerice() -> exercice.Question {
  let a_ = random_number()
  let a = expr.Multiplication([expr.Var("x"), expr.Number(a_)])
  let b = random_number()
  let c_ = random_number()
  let c = expr.Multiplication([expr.Var("x"), expr.Number(c_)])
  let d = random_number()

  let step0 =
    expr.Multiplication([
      expr.Addition([a, expr.Number(b)]),
      expr.Addition([c, expr.Number(d)]),
    ])

  let solution =
    expr.Addition([
      simplify(multiply(a, c)),
      simplify(multiply(expr.Var("x"), expr.Number(a_ * d + b * c_))),
      simplify(multiply(expr.Number(b), expr.Number(d))),
    ])

  exercice.Question(
    prompt: latex.from_expr(step0),
    solution: latex.from_expr(solution),
  )
}

pub fn generate() -> exercice.ExerciceSheet {
  let jaaj =
    list.range(0, 2)
    |> list.map(fn(_) {
      exercice.Exercice(
        prompt: "Developper les expressions suivantes",
        questions: list.range(0, 2)
          |> list.map(fn(_) { generate_one_exerice() }),
      )
    })

  exercice.ExerciceSheet(title: "Developpement", exercices: jaaj)
}
