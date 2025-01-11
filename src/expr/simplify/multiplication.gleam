import expr/expr.{type Expr, type Factors, Exponenation, Number, multiply}
import gleam/bool
import gleam/list
import utils.{first_or_return_acc}

pub fn simplify_factors(factors: Factors) -> Expr {
  use <- bool.guard(list.contains(factors, any: Number(0)), Number(0))

  let constant_product =
    list.fold(factors, 1, fn(product, factor) {
      case factor {
        Number(n) -> n * product
        _ -> product
      }
    })

  let factors =
    factors
    |> list.filter(fn(factor) { !expr.is_number(factor) })
    |> group_factors([])
    |> simplify_exponentation_factors([])

  case constant_product, factors {
    1, [] -> Number(1)
    1, [single_factor] -> single_factor
    1, factors -> multiply(factors)
    _, _ -> multiply([Number(constant_product), ..factors])
  }
}

fn simplify_exponentation_factors(
  remaining: Factors,
  processed: Factors,
) -> Factors {
  case remaining {
    [] -> processed
    [Exponenation(base, exp) as curr_exponenation, ..remaining] -> {
      let #(same_exp_different_base, others) =
        list.fold(remaining, #([], []), fn(tuple, expr) {
          case expr {
            Exponenation(base_bis, exp_bis) -> {
              case expr.eq(exp_bis, exp) {
                True -> #([base_bis, ..tuple.0], tuple.1)
                False -> #(tuple.0, [expr, ..tuple.1])
              }
            }
            _ -> #(tuple.0, [expr, ..tuple.1])
          }
        })

      case same_exp_different_base {
        [] ->
          simplify_exponentation_factors(remaining, [
            curr_exponenation,
            ..processed
          ])
        _ -> {
          same_exp_different_base
          |> list.prepend(base)
          |> multiply()
          |> Exponenation(base: _, exp: exp)
          |> list.prepend(processed, _)
          |> simplify_exponentation_factors(others, _)
        }
      }
    }

    [non_exponentation, ..remaining] -> {
      simplify_exponentation_factors(remaining, [non_exponentation, ..processed])
    }
  }
}

fn group_factors(remaining: Factors, processed: Factors) -> Factors {
  use curr_factor, remaining <- first_or_return_acc(remaining, processed)

  let #(same_factors, different_factors) =
    list.partition(remaining, expr.eq(curr_factor, _))

  let simplified_factor = case same_factors {
    [] -> curr_factor
    _ ->
      Exponenation(
        base: curr_factor,
        exp: Number(list.length(same_factors) + 1),
      )
  }

  group_factors(different_factors, [simplified_factor, ..processed])
}
