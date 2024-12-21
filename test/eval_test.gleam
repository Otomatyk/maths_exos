import expr/eval.{simplify}
import expr/expr.{Number, Var, multiply}
import gleeunit
import gleeunit/should.{equal}

pub fn main() {
  gleeunit.main()
}

fn simplified_equal(expr: expr.Expr, excepted: expr.Expr) -> Nil {
  expr
  |> simplify()
  |> equal(excepted)
}

pub fn simplify_multiplication_test() {
  // Zero
  multiply([Var("x"), Number(0), Number(10)])
  |> simplified_equal(Number(0))

  multiply([Number(0)])
  |> simplified_equal(Number(0))

  // Constant -> Product
  multiply([Number(1)])
  |> simplified_equal(Number(1))

  multiply([Number(1), Var("y"), Number(1), Number(77)])
  |> simplified_equal(multiply([Var("y"), Number(77)]))

  multiply([Number(5), Number(10)])
  |> simplified_equal(Number(50))

  multiply([Number(-8), Var("x"), Number(5)])
  |> simplified_equal(multiply([Var("x"), Number(-40)]))

  // Vars regrouping

  multiply([Var("x"), Var("x")])
  |> simplified_equal(expr.Exponenation(base: Var("x"), exp: Number(2)))

  multiply([Var("x"), Var("y"), Var("x"), Var("y")])
  |> simplified_equal(
    multiply([
      expr.Exponenation(base: Var("y"), exp: Number(2)),
      expr.Exponenation(base: Var("x"), exp: Number(2)),
    ]),
  )

  multiply([Var("x"), Number(8), Var("x"), Var("x")])
  |> simplified_equal(
    multiply([expr.Exponenation(base: Var("x"), exp: Number(3)), Number(8)]),
  )

  multiply([Var("x")])
  |> simplified_equal(Var("x"))

  multiply([Var("x"), Number(10), Var("x"), Number(8)])
  |> simplified_equal(
    multiply([expr.Exponenation(base: Var("x"), exp: Number(2)), Number(80)]),
  )

  // Can't be more simplified
  multiply([Number(-4), Var("x")])
  |> simplified_equal(multiply([Var("x"), Number(-4)]))
}
