import gleam/list

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

pub fn equal_order_independant(a: List(a), b: List(a)) -> Bool {
  case list.first(a) {
    Ok(curr) -> {
      let is_curr = fn(i) { i == curr }
      let isnt_curr = fn(i) { i != curr }

      case list.count(a, is_curr) == list.count(b, is_curr) {
        True -> {
          equal_order_independant(
            list.filter(a, isnt_curr),
            list.filter(b, isnt_curr),
          )
        }
        False -> False
      }
    }
    Error(_) -> a == b
  }
}

/// To be consired as a "common", a value should be contained in ALL lists
pub fn remove_commons(values: List(List(a))) -> List(List(a)) {
  values
  |> list.map(fn(curr) {
    let assert Ok(#(_, without_curr)) = list.pop(values, fn(a) { a == curr })

    curr
    |> list.filter(fn(ele_of_curr) {
      !{
        without_curr
        |> list.all(fn(other_list) { list.contains(other_list, ele_of_curr) })
      }
    })
  })
}
