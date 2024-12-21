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

pub fn remove_commons(a: List(a), b: List(a)) -> #(List(a), List(a)) {
  #(
    list.filter(a, fn(i) { !list.contains(b, i) }),
    list.filter(b, fn(i) { !list.contains(a, i) }),
  )
}
