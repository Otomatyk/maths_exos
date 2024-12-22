import gleam/list

pub fn eq(a: a, b: a) -> Bool {
  a == b
}

pub fn return_if(condition: Bool, value: a, otherwise: fn() -> a) -> a {
  case condition {
    True -> value
    False -> otherwise()
  }
}

/// Used to simplify a recursive function
pub fn first_or_return_acc(list: List(a), acc: b, if_first: fn(a) -> b) -> b {
  case list.first(list) {
    Ok(curr) -> if_first(curr)
    Error(_) -> acc
  }
}

pub fn equal_order_independant(
  a: List(a),
  b: List(a),
  eq_fn: fn(a, a) -> Bool,
) -> Bool {
  use curr <- first_or_return_acc(a, a == b)

  let #(a_are_curr, a_arent_curr) = list.partition(a, eq_fn(_, curr))
  let #(b_are_curr, b_arent_curr) = list.partition(b, eq_fn(_, curr))

  case a_are_curr == b_are_curr {
    True -> equal_order_independant(a_arent_curr, b_arent_curr, eq_fn)
    False -> False
  }
}

/// To be consired as a "common", a value should be contained in ALL lists
pub fn remove_commons(values: List(List(a))) -> List(List(a)) {
  use curr_list <- list.map(values)

  curr_list
  |> list.filter(fn(ele_of_curr) {
    !list.all(values, fn(other_list) { list.contains(other_list, ele_of_curr) })
  })
}

/// To be consired as a "common", a value should be contained in ALL lists
pub fn only_commons(values: List(List(a))) -> List(List(a)) {
  use curr_list <- list.map(values)

  curr_list
  |> list.filter(fn(ele_of_curr) {
    list.all(values, fn(other_list) { list.contains(other_list, ele_of_curr) })
  })
}
