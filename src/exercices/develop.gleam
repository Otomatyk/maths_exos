import exercice
import expr/distributivity
import expr/expr.{Var, add, multiply}
import expr/simplify

// import gleam/io
import gleam/list
import latex/latex
import random_numbers
import utils.{int_to_uppercase_letter, int_to_var}

const default_develop_prompt = "Developper les expressions suivantes"

pub fn first_degree_exercice(
  max_terms_number max_terms: Int,
  random_numbers_fn generate_number: random_numbers.GenerateIntFn,
) -> exercice.Exercice {
  let first_degree_question = fn(i: Int) {
    let assert [first_factor, ..terms] =
      [generate_number(), generate_number()]
      |> list.append(
        list.range(0, max_terms - 2) |> list.map(int_to_var) |> list.map(Var),
      )
      |> list.shuffle()

    let factors = [first_factor, add(terms)]
    let assert Ok(developped) = distributivity.develop(factors)
    let developped = developped |> simplify.deep_expr()

    let starts = int_to_uppercase_letter(i) <> " = "

    exercice.Question(
      prompt: starts <> { multiply(factors) |> latex.from_expr() },
      solution: starts <> latex.from_expr(developped),
    )
  }

  exercice.Exercice(
    prompt: default_develop_prompt,
    questions: list.range(0, 4) |> list.map(first_degree_question),
  )
}
