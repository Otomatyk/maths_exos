import expr/distributivity
import expr/expr.{Number, Var, add, multiply}
import gleeunit
import gleeunit/should.{be_ok}
import test_utils.{equal_expr}

pub fn main() {
  gleeunit.main()
}

fn developped_equal(factors: List(expr.Expr), excepted: expr.Expr) -> Nil {
  factors
  |> distributivity.develop()
  |> be_ok()
  |> equal_expr(excepted)
}

pub fn develop_simple_test() {
  [add([Number(3), Var("x")]), Var("a")]
  |> developped_equal(
    add([multiply([Number(3), Var("a")]), multiply([Var("x"), Var("a")])]),
  )

  [Number(7), add([Number(3), Number(5)])]
  |> developped_equal(
    add([multiply([Number(3), Number(7)]), multiply([Number(5), Number(7)])]),
  )

  [Var("a"), add([Number(3), Var("x")]), Var("b")]
  |> developped_equal(
    add([
      multiply([Var("x"), Var("a"), Var("b")]),
      multiply([Number(3), Var("a"), Var("b")]),
    ]),
  )

  [
    add([Number(3), Var("x")]),
    expr.Exponenation(base: Number(8), exp: Number(2)),
  ]
  |> developped_equal(
    add([
      multiply([expr.Exponenation(base: Number(8), exp: Number(2)), Number(3)]),
      multiply([expr.Exponenation(base: Number(8), exp: Number(2)), Var("x")]),
    ]),
  )
}

pub fn develop_double_test() {
  [add([Number(3), Var("x")]), add([Var("x"), Number(5)])]
  |> developped_equal(
    add([
      multiply([Number(3), Var("x")]),
      multiply([Number(3), Number(5)]),
      multiply([Number(5), Var("x")]),
      multiply([Var("x"), Var("x")]),
    ]),
  )

  [add([Number(3), Var("x"), Var("y")]), add([Var("z"), Var("x"), Number(5)])]
  |> developped_equal(
    add([
      multiply([Number(3), Var("z")]),
      multiply([Number(3), Var("x")]),
      multiply([Number(3), Number(5)]),
      multiply([Var("x"), Var("z")]),
      multiply([Var("x"), Var("x")]),
      multiply([Var("x"), Number(5)]),
      multiply([Var("y"), Var("z")]),
      multiply([Var("y"), Var("x")]),
      multiply([Var("y"), Number(5)]),
    ]),
  )
}

pub fn develop_three_test() {
  [
    add([Number(3), Var("x")]),
    add([Var("y"), Number(5)]),
    add([Var("z"), Number(3)]),
  ]
  |> developped_equal(
    add([
      multiply([Number(3), Var("y"), Var("z")]),
      multiply([Number(3), Number(5), Var("z")]),
      multiply([Var("x"), Var("y"), Var("z")]),
      multiply([Number(5), Var("x"), Var("z")]),
      multiply([Number(3), Number(3), Var("y")]),
      multiply([Number(3), Number(3), Number(5)]),
      multiply([Number(3), Var("x"), Var("y")]),
      multiply([Number(3), Number(5), Var("x")]),
    ]),
  )

  [Var("a"), add([Number(2), Var("x")]), Number(3)]
  |> developped_equal(
    add([
      multiply([Var("a"), Number(3), Number(2)]),
      multiply([Var("a"), Number(3), Var("x")]),
    ]),
  )

  [Var("a"), add([Number(2), Var("x"), Var("y")]), add([Number(3), Var("z")])]
  |> developped_equal(
    add([
      multiply([Number(2), Number(3), Var("a")]),
      multiply([Number(3), Var("x"), Var("a")]),
      multiply([Number(3), Var("a"), Var("y")]),
      multiply([Number(2), Var("a"), Var("z")]),
      multiply([Var("a"), Var("x"), Var("z")]),
      multiply([Var("a"), Var("y"), Var("z")]),
    ]),
  )
}

pub fn develop_failure() {
  [Number(3), Var("x"), Var("a")]
  |> distributivity.develop()
  |> should.be_error()

  [Number(3)]
  |> distributivity.develop()
  |> should.be_error()

  []
  |> distributivity.develop()
  |> should.be_error()
}
