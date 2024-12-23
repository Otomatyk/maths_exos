import expr/expr
import gleam/io
import gleeunit/should

pub fn equal_expr(expr: expr.Expr, excepted: expr.Expr) -> Nil {
  case expr.eq(expr, excepted) {
    False -> {
      io.println_error("`equal_expr` failed")
      should.equal(expr, excepted)
    }
    True -> {
      io.print("")
    }
  }
}
