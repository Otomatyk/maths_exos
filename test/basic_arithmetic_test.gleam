import expr/expr.{
  Addition, Exponenation, Multiplication, Number, Var, add, multiply, squared,
}
import gleeunit/should

pub fn multiply_test() {
  multiply([Number(8), Number(4), Var("x")])
  |> should.equal(Multiplication([Number(8), Number(4), Var("x")]))

  multiply([Number(8)])
  |> should.equal(Multiplication([Number(8)]))

  multiply([
    Multiplication([Number(4), Number(5)]),
    Number(6),
    Multiplication([Var("y"), Addition([Var("z"), Number(5)])]),
  ])
  |> should.equal(
    Multiplication([
      Number(4),
      Number(5),
      Number(6),
      Var("y"),
      Addition([Var("z"), Number(5)]),
    ]),
  )
}

pub fn add_test() {
  add([Number(8), Number(4), Var("x")])
  |> should.equal(Addition([Number(8), Number(4), Var("x")]))

  add([Number(8)])
  |> should.equal(Addition([Number(8)]))

  add([
    Addition([Number(4), Number(5)]),
    Number(6),
    Addition([Var("y"), Multiplication([Var("z"), Number(5)])]),
  ])
  |> should.equal(
    Addition([
      Number(4),
      Number(5),
      Number(6),
      Var("y"),
      Multiplication([Var("z"), Number(5)]),
    ]),
  )
}

pub fn exponentation_test() {
  squared(Number(4))
  |> should.equal(Exponenation(base: Number(4), exp: Number(2)))

  squared(add([Number(5), Var("x")]))
  |> should.equal(Exponenation(base: add([Number(5), Var("x")]), exp: Number(2)))
}
