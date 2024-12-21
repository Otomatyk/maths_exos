import expr/expr.{type Expr, Number}
import gleam/list
import utils.{first_or_return_acc, return_if}

fn simplify_vars(factors: expr.Factors, acc: List(Expr)) -> expr.Factors {
  use curr <- first_or_return_acc(factors, acc)

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

fn simplify_multiplication(factors: expr.Factors) -> Expr {
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
        _, Number(1) -> expr.multiply(without_numbers)
        _, _ -> expr.multiply(list.append(without_numbers, [number_product]))
      }
    }
    Error(_) -> number_product
  }
}

pub fn develop(factors: expr.Factors) -> expr.Terms {
  todo
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
