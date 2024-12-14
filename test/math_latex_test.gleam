import gleeunit
import gleeunit/should.{equal}
import expr/expr.{Addition, Exponenation, Multiplication, Number, Var}
import latex/latex

pub fn main() {
  gleeunit.main()
}

fn latex_equal(expr: expr.Expr, latex: String) -> Nil {
  latex.from_expr(expr)
  |> equal("$" <> latex <> "$")
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
  Addition([Number(5), Number(8)])
  |> latex_equal("5 + 8")

  Addition([Var("x"), Number(0), Number(74)])
  |> latex_equal("x + 0 + 74")

  Multiplication([Number(4), Number(15)])
  |> latex_equal("4 \\times 15")

  Multiplication([Var("x"), Number(3)])
  |> latex_equal("3x")

  Multiplication([Number(4), Var("y")])
  |> latex_equal("4y")

  Multiplication([Number(-8), Var("x")])
  |> latex_equal("-8x")

  Multiplication([Number(-1), Var("x")])
  |> latex_equal("-x")

  Multiplication([Var("x"), Number(0), Number(74)])
  |> latex_equal("0 \\times 74 \\times x")

  Exponenation(base: Number(5), exp: Number(8))
  |> latex_equal("{5} ^ {8}")

  Exponenation(base: Var("x"), exp: Number(-1))
  |> latex_equal("{x} ^ {-1}")
}

pub fn complex_operations_test() {
  Multiplication([Exponenation(base: Var("x"), exp: Number(2)), Number(8)])
  |> latex_equal("8{x} ^ {2}")

  Exponenation(
    base: Addition([Number(4), Number(5)]),
    exp: Multiplication([Var("x"), Number(2)]),
  )
  |> latex_equal("{(4 + 5)} ^ {2x}")

  Multiplication([
    Addition([Number(8), Var("x")]),
    Addition([Var("x"), Number(2)]),
  ])
  |> latex_equal("(8 + x)(x + 2)")

  Addition([
    Exponenation(base: Var("x"), exp: Number(5)),
    Exponenation(base: Var("y"), exp: Number(2)),
  ])
  |> latex_equal("{x} ^ {5} + {y} ^ {2}")
}
