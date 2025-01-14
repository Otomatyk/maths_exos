import expr/expr.{Exponenation, Multiplication, Number}
import gleam/int
import gleam/list
import gleam/order

const at_beggining = order.Lt

const at_end = order.Gt

pub fn terms(terms: expr.Terms) {
  terms |> list.sort(compare_exprs)
}

// Note : When using `int.compare`, args should be swapped (e.g : int.compare(expr, with) becomes int.compare(with, expr))
fn compare_exprs(expr, with) {
  case expr, with {
    Exponenation(_, Number(exp_expr)), Exponenation(_, Number(exp_with)) ->
      int.compare(exp_with, exp_expr)

    Exponenation(_, Number(_)), Exponenation(_, _) -> at_beggining
    Exponenation(_, _), Exponenation(_, Number(_)) -> at_end
    Exponenation(_, _), Exponenation(_, _) -> order.Eq
    Exponenation(_, _), _ -> at_beggining
    _, Exponenation(_, _) -> at_end

    Multiplication(a_factors), Multiplication(b_factors) -> {
      let a_constant_sum =
        list.fold(a_factors, 0, fn(acc, expr) {
          case expr {
            expr.Number(n) -> acc + n
            _ -> acc
          }
        })

      let b_constant_sum =
        list.fold(b_factors, 0, fn(acc, expr) {
          case expr {
            expr.Number(n) -> acc + n
            _ -> acc
          }
        })

      let a_exposant =
        list.find(a_factors, fn(expr) {
          case expr {
            expr.Exponenation(_, _) -> True
            _ -> False
          }
        })

      let b_exposant =
        list.find(b_factors, fn(expr) {
          case expr {
            expr.Exponenation(_, _) -> True
            _ -> False
          }
        })

      case a_exposant, b_exposant {
        Ok(a_exposant), Ok(b_exposant) ->
          order.break_tie(
            compare_exprs(a_exposant, b_exposant),
            int.compare(b_constant_sum, a_constant_sum),
          )

        Ok(_), Error(_) -> at_beggining
        Error(_), Ok(_) -> at_end
        Error(_), Error(_) -> int.compare(b_constant_sum, a_constant_sum)
      }
    }
    Multiplication(_), _ -> at_beggining
    _, Multiplication(_) -> at_end

    _, _ -> order.Eq
  }
}
