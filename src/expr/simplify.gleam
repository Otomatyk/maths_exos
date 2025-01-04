import expr/distributivity
import expr/expr.{type Expr, Number}
import gleam/bool
import gleam/list
import utils.{first_or_return_acc}

fn simplify_vars(factors: expr.Factors, acc: List(Expr)) -> expr.Factors {
  use curr <- first_or_return_acc(factors, acc)

  case curr {
    expr.Var(_) -> {
      let #(are_curr, arent_curr) = list.partition(factors, fn(i) { i == curr })

      case are_curr {
        [_] -> simplify_vars(arent_curr, [curr, ..acc])

        _ ->
          simplify_vars(arent_curr, [
            expr.Exponenation(base: curr, exp: Number(list.length(are_curr))),
            ..acc
          ])
      }
    }

    _ ->
      list.drop(factors, 1)
      |> simplify_vars(acc)
  }
}

fn simplify_factors(factors: expr.Factors) -> Expr {
  use <- bool.guard(list.contains(factors, Number(0)), Number(0))

  let without_numbers = simplify_vars(factors, [])

  let number_product =
    Number(
      factors
      |> list.fold(1, fn(acc, i) {
        case i {
          Number(n) -> acc * n
          _ -> acc
        }
      }),
    )

  case list.first(without_numbers) {
    Ok(expr) -> {
      case list.length(without_numbers), number_product {
        1, Number(1) -> expr
        _, Number(1) -> expr.multiply(without_numbers)
        _, _ -> expr.multiply(list.append(without_numbers, [number_product]))
      }
    }
    Error(_) -> number_product
  }
}

fn simplify_terms(terms: expr.Terms) -> Expr {
  let numbers_sum =
    Number(
      terms
      |> list.fold(0, fn(acc, term) {
        case term {
          Number(n) -> acc + n
          _ -> acc
        }
      }),
    )

  let other_terms =
    terms
    |> list.unique()
    |> list.filter_map(fn(term) {
      use <- bool.guard(expr.is_number(term), Error(Nil))

      let count = list.count(terms, fn(i) { i == term })

      case count {
        1 -> Ok(term)
        _ -> Ok(expr.multiply([Number(count), term]))
      }
    })

  case numbers_sum, other_terms {
    Number(0), [term] -> term
    Number(0), _ -> expr.add(other_terms)
    _, [] -> numbers_sum
    _, _ -> expr.add([numbers_sum, ..other_terms])
  }
}

pub fn expr(expr: Expr) -> Expr {
  case expr {
    expr.Multiplication(mul_factors) -> simplify_factors(mul_factors)

    expr.Addition(add_terms) -> simplify_terms(add_terms)

    _ -> panic
  }
}

/// Simplify an expr until can't be anymore
/// This function isn't tail recursive
pub fn deep_expr(expr: Expr) -> Expr {
  case expr {
    expr.Multiplication(factors) -> {
      factors |> list.map(deep_expr) |> simplify_factors()
    }

    expr.Addition(terms) -> {
      terms |> list.map(deep_expr) |> simplify_terms()
    }

    _ -> expr
  }
}
