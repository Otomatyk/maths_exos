const first_prime_numbers = [
  2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 67, 71, 73, 79,
  83, 89, 97,
]

pub fn decompose_in_prime_factors(i: Int) -> List(Int) {
  decompose_in_prime_factors_loop(i, [], first_prime_numbers)
}

fn decompose_in_prime_factors_loop(
  i: Int,
  i_prime_factors: List(Int),
  prime_numbers_list: List(Int),
) -> List(Int) {
  case i {
    1 -> i_prime_factors
    _ -> {
      let assert [prime_number, ..other_prime_numbers] = prime_numbers_list

      case i % prime_number {
        0 ->
          decompose_in_prime_factors_loop(
            i / prime_number,
            [prime_number, ..i_prime_factors],
            prime_numbers_list,
          )
        _ ->
          decompose_in_prime_factors_loop(
            i,
            i_prime_factors,
            other_prime_numbers,
          )
      }
    }
  }
}
