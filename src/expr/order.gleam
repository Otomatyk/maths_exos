import expr/expr
import gleam/int
import gleam/list

pub fn terms(terms: expr.Terms) {
  terms |> list.sort(compare_exprs)
}

fn compare_exprs(a, b) {
  int.compare(expr_score(b), expr_score(a))
}

fn expr_score(expr) -> Int {
  case expr {
    expr.Exponenation(base: _, exp: expr.Number(n)) -> 100 + n
    expr.Exponenation(_, _) -> 100

    expr.Multiplication(factors) -> {
      let score =
        factors
        |> list.fold(10, fn(acc, expr) {
          case expr {
            expr.Number(n) -> acc + n
            _ -> acc
          }
        })

      let exp =
        factors
        |> list.find(fn(expr) {
          case expr {
            expr.Exponenation(_, _) -> True
            _ -> False
          }
        })

      case exp {
        Ok(exp) -> score + expr_score(exp)
        Error(Nil) -> score
      }
    }

    expr.Addition(_) -> 2
    expr.Number(_) | expr.Var(_) -> 1
  }
}
