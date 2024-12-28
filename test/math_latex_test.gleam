import expr/expr.{Exponenation, Number, Var, add, multiply}
import gleeunit
import gleeunit/should.{equal}
import latex/latex_expr

pub fn main() {
  gleeunit.main()
}

fn latex_equal(expr: expr.Expr, latex: String) -> Nil {
  latex_expr.from(expr)
  |> equal(latex)
}

pub fn litteral_test() {
  Number(10)
  |> latex_equal("10")

  Number(0)
  |> latex_equal("0")

  Number(-0)
  |> latex_equal("0")

  Number(-42)
  |> latex_equal("-42")

  Var("x")
  |> latex_equal("x")

  Var("var")
  |> latex_equal("var")
}

pub fn basic_operations_test() {
  add([Number(5), Number(8)])
  |> latex_equal("5 + 8")

  add([Number(-2), Number(-3), Number(-5)])
  |> latex_equal("-2 - 3 - 5")

  add([Var("x"), Number(0), Number(74)])
  |> latex_equal("x + 0 + 74")

  multiply([Number(4), Number(15)])
  |> latex_equal("4 \\times 15")

  multiply([Var("x"), Number(3)])
  |> latex_equal("3x")

  multiply([Number(4), Var("y")])
  |> latex_equal("4y")

  multiply([Number(-8), Var("x")])
  |> latex_equal("-8x")

  multiply([Number(-1), Var("x")])
  |> latex_equal("-x")

  multiply([Var("x"), Number(0), Number(74)])
  |> latex_equal("0 \\times 74 \\times x")

  Exponenation(base: Number(5), exp: Number(8))
  |> latex_equal("{5} ^ {8}")

  Exponenation(base: Var("x"), exp: Number(-1))
  |> latex_equal("{x} ^ {-1}")
}

pub fn complex_operations_test() {
  multiply([Exponenation(base: Var("x"), exp: Number(2)), Number(8)])
  |> latex_equal("8{x} ^ {2}")

  Exponenation(
    base: add([Number(4), Number(5)]),
    exp: multiply([Var("x"), Number(2)]),
  )
  |> latex_equal("{(4 + 5)} ^ {2x}")

  multiply([add([Number(8), Var("x")]), add([Var("x"), Number(2)])])
  |> latex_equal("(8 + x)(x + 2)")

  add([multiply([Number(-1), Var("x")]), Number(-5), Var("y")])
  |> latex_equal("-x - 5 + y")

  multiply([
    add([multiply([Number(2), Var("x")]), Number(3)]),
    add([Number(-5), multiply([Number(-4), Var("y")])]),
  ])
  |> latex_equal("(2x + 3)(-5 - 4y)")

  add([
    Exponenation(base: Var("x"), exp: Number(5)),
    Exponenation(base: Var("y"), exp: Number(2)),
  ])
  |> latex_equal("{x} ^ {5} + {y} ^ {2}")
}
