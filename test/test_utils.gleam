import expr/expr
import gleeunit/should

pub fn equal_expr(expr: expr.Expr, excepted: expr.Expr) -> Nil {
  expr.eq(expr, excepted)
  |> should.be_true()
}
