import gleam/list
import expr/expr.{type Expr, Number}

fn return_if(condition: Bool, return: a, otherwise: fn() -> a) -> a {
  case condition {
    True -> return
    False -> otherwise()
  }
}

fn simplify_vars(factors: List(Expr), acc: List(Expr)) -> List(Expr) {
  case list.first(factors) {
    Ok(curr) -> {
      case curr {
        expr.Var(_) -> {
          let count = list.count(factors, fn(i) { i == curr })

          case count {
            1 ->
              list.drop(factors, 1)
              |> simplify_vars([curr, ..acc])

            _ ->
              list.filter(factors, fn(i) { i != curr })
              |> simplify_vars([
                expr.Exponenation(base: curr, exp: Number(count)),
                ..acc
              ])
          }
        }

        _ ->
          list.drop(factors, 1)
          |> simplify_vars(acc)
      }
    }
    Error(_) -> acc
  }
}

fn simplify_multiplication(factors: List(Expr)) -> Expr {
  use <- return_if(list.contains(factors, Number(0)), Number(0))

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
        _, Number(1) -> expr.Multiplication(without_numbers)
        _, _ ->
          expr.Multiplication(list.append(without_numbers, [number_product]))
      }
    }
    Error(_) -> number_product
  }
}

pub fn simplify(expr: Expr) -> Expr {
  case expr {
    expr.Multiplication(factors) -> {
      factors
      |> simplify_multiplication()
    }

    _ -> panic
  }
}