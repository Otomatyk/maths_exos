import gleam/int

/// This number is inclusive
const largest_number = 11

pub fn non_null_negative_int() -> Int {
  int.random(largest_number) + 1
}

pub fn non_null_relatif_int() -> Int {
  let n = int.random(largest_number * 2 + 1) - largest_number

  case n {
    0 -> non_null_relatif_int()
    _ -> n
  }
}

pub fn non_null_int_relatif_if(when: Bool) -> Int {
  case when {
    True -> non_null_negative_int()
    False -> non_null_relatif_int()
  }
}
