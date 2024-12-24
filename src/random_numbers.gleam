import expr/expr.{type Expr, Number}
import gleam/int

/// This number is inclusive
const largest_number = 11

/// This function is used for an injection-pattern with exercices functions
pub type GenerateIntFn =
  fn() -> Expr

/// Generate a Number included in the interval ]0, MAX]
pub fn non_null_positive_int() -> Expr {
  Number(int.random(largest_number) + 1)
}

/// Generate a Number included in the interval [-MAX, MAX] / {0}
pub fn non_null_relatif_int() -> Expr {
  let n = int.random(largest_number * 2 + 1) - largest_number

  case n {
    0 -> non_null_relatif_int()
    _ -> Number(n)
  }
}
