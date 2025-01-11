import expr/expr.{type Expr, Number}

pub fn simplify_exponentation(base: Expr, exp: Expr) -> Expr {
  case exp {
    Number(0) -> Number(1)
    Number(1) -> base
    _ -> expr.Exponenation(base:, exp:)
  }
}
