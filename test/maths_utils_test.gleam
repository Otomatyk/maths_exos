import gleeunit
import gleeunit/should
import maths_utils.{decompose_in_prime_factors}

pub fn main() {
  gleeunit.main()
}

pub fn decompose_in_prime_factors_test() {
  decompose_in_prime_factors(1)
  |> should.equal([])

  decompose_in_prime_factors(10)
  |> should.equal([5, 2])

  decompose_in_prime_factors(3)
  |> should.equal([3])

  decompose_in_prime_factors(80)
  |> should.equal([5, 2, 2, 2, 2])

  decompose_in_prime_factors(66)
  |> should.equal([11, 3, 2])
}
