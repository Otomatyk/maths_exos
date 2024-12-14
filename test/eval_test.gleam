import gleeunit
import gleeunit/should.{equal}
import expr.{Multiplication, Number, Var}
import eval.{simplify}

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
  Multiplication([Var("x"), Number(0), Number(10)])
  |> simplified_equal(Number(0))

  Multiplication([Number(0)])
  |> simplified_equal(Number(0))

  // Constant -> Product
  Multiplication([Number(1)])
  |> simplified_equal(Number(1))

  Multiplication([Number(1), Var("y"), Number(1), Number(77)])
  |> simplified_equal(Multiplication([Var("y"), Number(77)]))

  Multiplication([Number(5), Number(10)])
  |> simplified_equal(Number(50))

  Multiplication([Number(-8), Var("x"), Number(5)])
  |> simplified_equal(Multiplication([Var("x"), Number(-40)]))

  // Vars regrouping

  Multiplication([Var("x"), Var("x")])
  |> simplified_equal(expr.Exponenation(base: Var("x"), exp: Number(2)))

  Multiplication([Var("x"), Var("y"), Var("x"), Var("y")])
  |> simplified_equal(
    Multiplication([
      expr.Exponenation(base: Var("y"), exp: Number(2)),
      expr.Exponenation(base: Var("x"), exp: Number(2)),
    ]),
  )

  Multiplication([Var("x"), Number(8), Var("x"), Var("x")])
  |> simplified_equal(
    Multiplication([
      expr.Exponenation(base: Var("x"), exp: Number(3)),
      Number(8),
    ]),
  )

  Multiplication([Var("x")])
  |> simplified_equal(Var("x"))

  Multiplication([Var("x"), Number(10), Var("x"), Number(8)])
  |> simplified_equal(
    Multiplication([
      expr.Exponenation(base: Var("x"), exp: Number(2)),
      Number(80),
    ]),
  )

  // Can't be more simplified
  Multiplication([Number(-4), Var("x")])
  |> simplified_equal(Multiplication([Var("x"), Number(-4)]))
}
