import exercices/types.{
  type Exercice, Equality, EqualityListExercice, MapExercice,
  TrueOrFalseExercice,
}
import expr/distributivity
import expr/expr.{Var, add, multiply}
import expr/order
import expr/simplify
import gleam/list
import gleam/option
import latex/latex_expr
import latex/latex_utils.{math}
import random_numbers
import utils.{int_to_var}

const default_develop_prompt = "Developper les expressions suivantes"

pub fn first_degree_exercice(
  max_terms_number max_terms: Int,
  random_numbers_fn generate_number: random_numbers.GenerateIntFn,
) -> Exercice {
  let first_degree_question = fn(_) {
    let assert [first_factor, ..terms] =
      [generate_number(), generate_number()]
      |> list.append(
        list.range(0, max_terms - 2) |> list.map(int_to_var) |> list.map(Var),
      )
      |> list.shuffle()

    let factors = [first_factor, add(terms)]
    let assert Ok(developped_1) = distributivity.develop(factors)
    let developped_2 = developped_1 |> simplify.deep_expr()

    Equality(initial_expr: multiply(factors), solution_steps: [
      developped_1,
      developped_2,
    ])
  }

  EqualityListExercice(
    prompt: default_develop_prompt,
    questions: list.range(0, 4) |> list.map(first_degree_question),
  )
}

pub fn second_degree_exercice(
  random_numbers_fn generate_number: random_numbers.GenerateIntFn,
) -> Exercice {
  let second_degree_question = fn(_) {
    let factors = [
      add(
        [generate_number(), multiply([Var("x"), generate_number()])]
        |> list.shuffle(),
      ),
      add(
        [generate_number(), multiply([Var("x"), generate_number()])]
        |> list.shuffle(),
      ),
    ]

    let assert Ok(developped_1) = distributivity.develop(factors)
    let assert expr.Addition(terms) = developped_1 |> simplify.deep_expr()
    let developped_2 = terms |> order.terms() |> expr.Addition()

    Equality(initial_expr: multiply(factors), solution_steps: [
      developped_1,
      developped_2,
    ])
  }

  EqualityListExercice(
    prompt: default_develop_prompt,
    questions: list.range(0, 4) |> list.map(second_degree_question),
  )
}

pub fn true_or_false_first_dregree_exercice(
  max_terms_number max_terms: Int,
  random_numbers_fn generate_number: random_numbers.GenerateIntFn,
) -> Exercice {
  let question = fn(_) {
    let truthfullness = utils.random_bool()

    let assert [first_factor, ..terms] =
      [generate_number(), generate_number()]
      |> list.append(
        list.range(0, max_terms - 2) |> list.map(int_to_var) |> list.map(Var),
      )
      |> list.shuffle()

    let assert [false_first_factor, ..false_terms] = case truthfullness {
      True -> [first_factor, ..terms]

      False -> [first_factor, ..terms] |> list.shuffle()
    }

    let false_factors = [false_first_factor, add(false_terms)]
    let true_factors = [first_factor, add(terms)]

    let assert Ok(developped) = distributivity.develop(false_factors)
    let developped = developped |> simplify.deep_expr()

    let assert Ok(developped_true) = distributivity.develop(true_factors)
    let developped_true = developped_true |> simplify.deep_expr()

    let true_factors_math =
      multiply(true_factors) |> latex_expr.from() |> math()

    #(
      { true_factors_math }
        <> " = "
        <> { developped |> latex_expr.from() |> math() },
      case truthfullness {
        True -> option.None
        False ->
          option.Some(
            true_factors_math
            <> " = "
            <> developped_true |> latex_expr.from() |> math(),
          )
      },
    )
  }

  TrueOrFalseExercice(affirmations: list.range(0, 4) |> list.map(question))
}

pub fn map_exercice(
  max_terms_number max_terms: Int,
  random_numbers_fn generate_number: random_numbers.GenerateIntFn,
) {
  let map_pairs = fn(_) {
    let assert [first_factor, ..terms] =
      [generate_number(), generate_number()]
      |> list.append(
        list.range(0, max_terms - 2) |> list.map(int_to_var) |> list.map(Var),
      )
      |> list.shuffle()

    let factors = [first_factor, add(terms)]
    let assert Ok(developped_1) = distributivity.develop(factors)
    let developped_2 = developped_1 |> simplify.deep_expr()

    #(
      multiply(factors) |> latex_expr.from() |> math(),
      developped_2 |> latex_expr.from() |> math(),
    )
  }

  MapExercice(
    prompt: "Relier chaque produit à sa version developpée",
    pairs: list.range(0, 4) |> list.map(map_pairs),
  )
}
