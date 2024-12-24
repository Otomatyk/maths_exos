import expr/expr.{Exponenation, Number, Var, add, multiply, squared}
import expr/order
import gleeunit
import gleeunit/should

fn ordered_equal(terms: expr.Terms, excepted: expr.Terms) -> Nil {
  terms
  |> order.terms()
  |> should.equal(excepted)
}

fn order_shouldnt_change(terms: expr.Terms) -> Nil {
  ordered_equal(terms, terms)
}

pub fn main() {
  gleeunit.main()
}

pub fn order_terms_test() {
  [Number(8), Var("x"), Number(5)]
  |> order_shouldnt_change()

  [multiply([Var("y"), Var("x")]), multiply([Var("a"), Var("b")])]
  |> order_shouldnt_change()

  [multiply([Number(5), Var("x")]), multiply([Number(4), Number(1), Var("b")])]
  |> order_shouldnt_change()

  [
    Var("x"),
    multiply([Number(5), Var("x")]),
    Number(10),
    multiply([Number(10), Var("b")]),
  ]
  |> ordered_equal([
    multiply([Number(10), Var("b")]),
    multiply([Number(5), Var("x")]),
    Var("x"),
    Number(10),
  ])

  [multiply([Var("y"), Var("x")]), multiply([Number(10), Var("b")])]
  |> ordered_equal([
    multiply([Number(10), Var("b")]),
    multiply([Var("y"), Var("x")]),
  ])
}

pub fn order_terms_exponentation_test() {
  [
    Exponenation(base: Number(100), exp: Number(5)),
    Number(8),
    Var("x"),
    Number(5),
  ]
  |> order_shouldnt_change()

  [
    Exponenation(base: add([Var("d"), Number(8)]), exp: Number(8)),
    Exponenation(base: add([Number(1), Var("x")]), exp: Number(1)),
    Exponenation(base: add([Var("x"), Number(1)]), exp: Number(10)),
  ]
  |> ordered_equal([
    Exponenation(base: add([Var("x"), Number(1)]), exp: Number(10)),
    Exponenation(base: add([Var("d"), Number(8)]), exp: Number(8)),
    Exponenation(base: add([Number(1), Var("x")]), exp: Number(1)),
  ])

  [
    Number(4),
    multiply([Var("x"), Number(5)]),
    Exponenation(base: add([Var("d"), Number(8)]), exp: Number(8)),
    Var("x"),
    Exponenation(base: Number(1), exp: add([Number(1), Var("x")])),
    multiply([Var("x"), Number(78)]),
  ]
  |> ordered_equal([
    Exponenation(base: add([Var("d"), Number(8)]), exp: Number(8)),
    Exponenation(base: Number(1), exp: add([Number(1), Var("x")])),
    multiply([Var("x"), Number(78)]),
    multiply([Var("x"), Number(5)]),
    Number(4),
    Var("x"),
  ])

  // -385{x} ^ {3} + 539{x} ^ {2} + 330{x} ^ {2} + 70{x} ^ {2} - 462x - 98x - 60x + 84
  [
    multiply([Number(-98), Var("x")]),
    multiply([Number(-385), Exponenation(base: Var("x"), exp: Number(3))]),
    multiply([Number(-60), Var("x")]),
    multiply([Number(539), squared(Var("x"))]),
    Number(84),
    multiply([Number(70), squared(Var("x"))]),
    multiply([Number(-462), Var("x")]),
    multiply([Number(-330), squared(Var("x"))]),
  ]
  |> ordered_equal([
    multiply([Number(-385), Exponenation(base: Var("x"), exp: Number(3))]),
    multiply([Number(539), squared(Var("x"))]),
    multiply([Number(-330), squared(Var("x"))]),
    multiply([Number(70), squared(Var("x"))]),
    multiply([Number(-462), Var("x")]),
    multiply([Number(-98), Var("x")]),
    multiply([Number(-60), Var("x")]),
    Number(84),
  ])
}
