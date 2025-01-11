import expr/distributivity
import expr/expr.{Number, Var, add, multiply}
import gleeunit
import gleeunit/should.{be_ok}

pub fn main() {
  gleeunit.main()
}

fn factorized_equal(terms: List(expr.Expr), excepted: expr.Expr) -> Nil {
  terms
  |> distributivity.factor_with_one()
  |> be_ok()
  |> should.equal(excepted)
  // `equal_expr` wasn't used because the order matters with factorization
}

pub fn factor_with_one_test() {
  [multiply([Var("x"), Number(8)]), multiply([Var("x"), Number(4)])]
  |> factorized_equal(multiply([Var("x"), add([Number(8), Number(4)])]))

  [multiply([Var("y"), Number(4)]), multiply([Var("x"), Number(4)])]
  |> factorized_equal(multiply([Number(4), add([Var("y"), Var("x")])]))

  [
    multiply([Var("x"), Number(1)]),
    multiply([Number(2), Var("x")]),
    multiply([Number(3), Var("x")]),
  ]
  |> factorized_equal(
    multiply([Var("x"), add([Number(1), Number(2), Number(3)])]),
  )

  [multiply([Var("x"), Number(2), Var("y")]), multiply([Number(3), Var("x")])]
  |> factorized_equal(
    multiply([Var("x"), add([multiply([Number(2), Var("y")]), Number(3)])]),
  )

  [multiply([Var("x"), Number(5)]), Var("x"), multiply([Var("x"), Var("y")])]
  |> factorized_equal(
    multiply([Var("x"), add([Number(5), Number(1), Var("y")])]),
  )

  [
    multiply([Var("x"), Number(4)]),
    multiply([Var("y"), Number(4)]),
    multiply([Var("z"), Number(4)]),
    Number(4),
  ]
  |> factorized_equal(
    multiply([Number(4), add([Var("x"), Var("y"), Var("z"), Number(1)])]),
  )

  [Var("x"), Var("x")]
  |> factorized_equal(multiply([Var("x"), add([Number(1), Number(1)])]))
}

pub fn factor_with_one_failures_test() {
  [multiply([Var("x"), Number(8)]), multiply([Var("y"), Number(4)])]
  |> distributivity.factor_with_one()
  |> should.be_error()

  [Var("x"), Var("y"), Var("z")]
  |> distributivity.factor_with_one()
  |> should.be_error()

  [
    multiply([Var("x"), Number(4)]),
    multiply([Var("y"), Number(4)]),
    multiply([Var("y"), Number(8)]),
  ]
  |> distributivity.factor_with_one()
  |> should.be_error()
}
