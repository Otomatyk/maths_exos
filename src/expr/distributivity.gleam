import expr/expr.{type Expr, type Terms, Multiplication, add, multiply}
import gleam/list
import utils

/// Returns an error if it can't be factorized
pub fn factor_with_one(terms: Terms) -> Result(Expr, Nil) {
  let factors =
    terms
    |> list.map(fn(expr) {
      case expr {
        Multiplication(factors) -> factors
        _ -> [expr]
      }
    })

  let other_factors =
    factors
    |> utils.remove_commons()
    |> list.map(fn(i) {
      case i {
        [ele] -> ele
        [] -> expr.Number(1)
        _ -> multiply(i)
      }
    })

  let common_factors =
    factors
    |> utils.only_commons()
    |> list.flatten()
    |> list.unique()

  use <- utils.return_if(common_factors == [], Error(Nil))

  Ok(
    common_factors
    |> list.append([add(other_factors)])
    |> multiply(),
  )
}
