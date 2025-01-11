import expr/expr.{type Expr, add, multiply}
import gleam/bool
import gleam/list
import utils

/// Returns an error if it can't be factorized
pub fn factor_with_one(terms: expr.Terms) -> Result(Expr, Nil) {
  let factors =
    terms
    |> list.map(fn(expr) {
      case expr {
        expr.Multiplication(factors) -> factors
        _ -> [expr]
      }
    })

  let common_factors =
    factors
    |> utils.only_commons(expr.eq)
    |> list.flatten()
    |> list.unique()

  use <- bool.guard(common_factors == [], Error(Nil))

  let other_factors =
    factors
    |> utils.remove_commons(expr.eq)
    |> list.map(fn(i) {
      case i {
        [ele] -> ele
        [] -> expr.Number(1)
        _ -> multiply(i)
      }
    })

  Ok(
    common_factors
    |> list.append([add(other_factors)])
    |> multiply(),
  )
}

/// A dependence of `develop`
fn terms_combinations(terms: List(List(Expr)), acc: List(Expr)) -> List(Expr) {
  use curr_terms, others_terms <- utils.first_or_return_acc(terms, acc)

  let others_terms = list.flatten(others_terms)

  curr_terms
  |> list.map(fn(term) {
    use other_term <- list.map(others_terms)

    multiply([term, other_term])
  })
  |> list.flatten()
  |> list.append(acc, _)
  |> terms_combinations(list.drop(terms, 1), _)
}

/// Returns an error if it can't be developed
/// This function isn't tail-recursive
pub fn develop(factors: expr.Factors) -> Result(Expr, Nil) {
  let #(addition_factors, non_addition_factors) =
    factors
    |> list.partition(fn(expr) {
      case expr {
        expr.Addition(_) -> True
        _ -> False
      }
    })

  // A factor that will be each term
  let constant_factor = multiply(non_addition_factors)

  let simplified_factors = case constant_factor {
    expr.Multiplication([]) -> addition_factors
    _ -> [constant_factor, ..addition_factors]
  }

  case simplified_factors {
    [] | [_] -> Error(Nil)

    [_, _] -> {
      let nested_factors =
        factors
        |> list.filter_map(fn(expr) {
          case expr {
            expr.Addition(terms) -> Ok(terms)
            _ -> Error(Nil)
          }
        })

      Ok(
        case constant_factor {
          expr.Multiplication([]) -> nested_factors
          _ -> [[constant_factor], ..nested_factors]
        }
        |> terms_combinations([])
        |> add(),
      )
    }

    [a, b, ..rest] -> {
      let assert Ok(result) = [a, b] |> develop()

      develop([result, ..rest])
    }
  }
}
