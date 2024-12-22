import expr/expr.{Number, Var, add, multiply}
import gleeunit
import gleeunit/should.{be_false, be_true}

pub fn main() {
  gleeunit.main()
}

pub fn expr_eq_basic_values_test() {
  expr.eq(Number(2), Number(2))
  |> be_true()

  expr.eq(Var("x"), Var("x"))
  |> be_true()

  expr.eq(Number(0), Number(2))
  |> be_false()

  expr.eq(Var("x"), Var("y"))
  |> be_false()

  expr.eq(Var("x"), Number(2))
  |> be_false()
}

pub fn expr_eq_addition_test() {
  expr.eq(add([Number(2), Var("x")]), add([Number(2), Var("x")]))
  |> be_true()

  expr.eq(add([Number(2), Var("x")]), add([Var("x"), Number(2)]))
  |> be_true()

  expr.eq(add([]), add([]))
  |> be_true()

  expr.eq(add([Number(2)]), add([]))
  |> be_false()

  expr.eq(add([Number(2)]), add([Number(5)]))
  |> be_false()
}

pub fn expr_eq_multiplication_test() {
  expr.eq(multiply([Number(2), Var("x")]), multiply([Number(2), Var("x")]))
  |> be_true()

  expr.eq(multiply([Number(2), Var("x")]), multiply([Var("x"), Number(2)]))
  |> be_true()

  expr.eq(multiply([]), multiply([]))
  |> be_true()

  expr.eq(
    multiply([Number(2), Var("x"), Var("x")]),
    multiply([Var("x"), Number(2), Var("x")]),
  )
  |> be_true()

  expr.eq(
    multiply([Number(2), Var("x"), Var("x")]),
    multiply([Number(2), Var("x")]),
  )
  |> be_false()

  expr.eq(multiply([Number(2)]), multiply([]))
  |> be_false()

  expr.eq(multiply([Number(2)]), multiply([Number(5)]))
  |> be_false()
}

pub fn expr_eq_complex_test() {
  expr.eq(
    multiply([add([Number(2), Var("x")]), add([Number(3), Var("y")])]),
    multiply([add([Var("y"), Number(3)]), add([Var("x"), Number(2)])]),
  )
  |> be_true()

  expr.eq(
    multiply([add([Number(2), Var("x")]), add([Number(3), Var("y")])]),
    multiply([
      add([Var("y"), Number(3)]),
      add([Var("x"), Number(2)]),
      add([Var("x"), Number(2)]),
    ]),
  )
  |> be_false()

  expr.eq(
    add([
      Var("x"),
      multiply([Var("y"), Number(5), add([Var("z"), Number(2)])]),
      Number(3),
    ]),
    add([
      multiply([Number(5), add([Number(2), Var("z")]), Var("y")]),
      Number(3),
      Var("x"),
    ]),
  )
  |> be_true()
}
