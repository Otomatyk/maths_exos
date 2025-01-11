import expr/expr.{Exponenation, Number, Var, add, multiply}
import expr/simplify/simplify.{
  simplify_exponentation, simplify_factors, simplify_terms,
}
import gleeunit
import test_utils.{equal_expr}

pub fn main() {
  gleeunit.main()
}

pub fn simplify_exponentation_test() {
  simplify_exponentation(Var("x"), Number(3))
  |> equal_expr(Exponenation(Var("x"), Number(3)))

  simplify_exponentation(Var("x"), Number(1))
  |> equal_expr(Var("x"))

  simplify_exponentation(Var("x"), Number(0))
  |> equal_expr(Number(1))
}

pub fn simplify_factors_test() {
  [Number(0)]
  |> simplify_factors()
  |> equal_expr(Number(0))

  [Number(0), Var("x"), Number(1)]
  |> simplify_factors()
  |> equal_expr(Number(0))

  [Number(1), Var("x"), Number(1)]
  |> simplify_factors()
  |> equal_expr(Var("x"))

  [Var("x")]
  |> simplify_factors()
  |> equal_expr(Var("x"))

  [Var("y"), Number(8), Var("x"), Number(5)]
  |> simplify_factors()
  |> equal_expr(multiply([Number(40), Var("y"), Var("x")]))

  [Var("x"), Var("x")]
  |> simplify_factors()
  |> equal_expr(Exponenation(base: Var("x"), exp: Number(2)))

  [add([Number(3), Var("y")]), Var("x"), add([Var("y"), Number(3)])]
  |> simplify_factors()
  |> equal_expr(
    multiply([
      Exponenation(base: add([Var("y"), Number(3)]), exp: Number(2)),
      Var("x"),
    ]),
  )

  [
    Number(10),
    add([Number(3), Var("y")]),
    Var("x"),
    add([Var("a"), Var("b")]),
    add([Var("b"), Var("a")]),
    Number(8),
    add([Var("y"), Number(3)]),
    add([Var("b"), Var("a")]),
  ]
  |> simplify_factors()
  |> equal_expr(
    multiply([
      Exponenation(base: add([Var("y"), Number(3)]), exp: Number(2)),
      Exponenation(base: add([Var("b"), Var("a")]), exp: Number(3)),
      Var("x"),
      Number(80),
    ]),
  )
}

pub fn simplify_exponentation_factors_test() {
  [Exponenation(Var("x"), Number(5)), Exponenation(Var("y"), Number(6))]
  |> simplify_factors()
  |> equal_expr(
    multiply([
      Exponenation(Var("x"), Number(5)),
      Exponenation(Var("y"), Number(6)),
    ]),
  )

  [Exponenation(Var("x"), Number(5)), Exponenation(Var("y"), Number(5))]
  |> simplify_factors()
  |> equal_expr(Exponenation(multiply([Var("x"), Var("y")]), Number(5)))

  [
    Exponenation(add([Number(5), Var("y")]), multiply([Var("x"), Number(3)])),
    Exponenation(Var("z"), multiply([Number(3), Var("x")])),
    Exponenation(
      multiply([Number(8), Number(5)]),
      multiply([Number(3), Var("x")]),
    ),
  ]
  |> simplify_factors()
  |> equal_expr(Exponenation(
    multiply([add([Number(5), Var("y")]), Var("z"), Number(8), Number(5)]),
    multiply([Number(3), Var("x")]),
  ))
}

pub fn simplify_terms_simple_test() {
  [Number(0)]
  |> simplify_terms()
  |> equal_expr(Number(0))

  [Number(0), Number(5), Number(-6)]
  |> simplify_terms()
  |> equal_expr(Number(-1))

  [Var("x"), Var("x"), Var("y"), Number(10), Number(8)]
  |> simplify_terms()
  |> equal_expr(add([multiply([Number(2), Var("x")]), Var("y"), Number(18)]))

  [Var("x"), Number(0)]
  |> simplify_terms()
  |> equal_expr(Var("x"))

  [
    Var("x"),
    multiply([Var("x"), Number(6)]),
    multiply([Var("x"), Number(10)]),
    multiply([Number(-100), Var("x")]),
    multiply([Number(10), Var("y")]),
    multiply([Number(-100), Var("x"), Number(5)]),
    Var("y"),
    Number(42),
    Var("z"),
  ]
  |> simplify_terms()
  |> equal_expr(
    add([
      multiply([Number(17 - 100), Var("x")]),
      multiply([Number(-100), Var("x"), Number(5)]),
      multiply([Number(11), Var("y")]),
      Number(42),
      Var("z"),
    ]),
  )

  [multiply([Var("x"), Number(3)]), multiply([Var("x"), Number(3)])]
  |> simplify_terms()
  |> equal_expr(multiply([Var("x"), Number(6)]))

  [
    multiply([Var("x"), Number(3)]),
    Var("x"),
    Var("x"),
    multiply([Var("y"), Number(3)]),
    multiply([Var("x"), Number(3)]),
  ]
  |> simplify_terms()
  |> equal_expr(
    add([multiply([Var("x"), Number(8)]), multiply([Var("y"), Number(3)])]),
  )
}
