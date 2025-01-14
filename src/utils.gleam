import gleam/bool
import gleam/int
import gleam/list
import gleam/string

const alphabet = "abcdefghijklmnopqrstuvwxyz"

const var_names = "xyzabcdefigjklmnophsturvqw"

pub fn random_bool() -> Bool {
  case int.random(2) {
    0 -> False
    _ -> True
  }
}

pub fn eq(a: a, b: a) -> Bool {
  a == b
}

fn list_eq(list_a: List(a), list_b: List(a), eq_fn: fn(a, a) -> Bool) {
  use <- bool.guard(list.length(list_a) != list.length(list_b), False)

  list.map2(list_a, list_b, eq_fn)
  |> list.all(eq(_, True))
}

/// Each number is mapped to one letter.
/// If `n` exceeds 26, the cycle re-starts
pub fn int_to_uppercase_letter(n: Int) -> String {
  string.slice(alphabet, { n % 26 }, 1) |> string.uppercase()
}

/// Each number is mapped to one letter.
/// If `n` exceeds 26, the cycle re-starts
pub fn int_to_var(n: Int) -> String {
  string.slice(var_names, { n % 26 }, 1)
}

/// Used to simplify a recursive function
pub fn first_or_return_acc(
  list: List(a),
  acc: b,
  if_first: fn(a, List(a)) -> b,
) -> b {
  case list {
    [curr, ..rest] -> if_first(curr, rest)
    [] -> acc
  }
}

pub fn equal_order_independant(
  a: List(a),
  b: List(a),
  eq_fn: fn(a, a) -> Bool,
) -> Bool {
  use curr, _ <- first_or_return_acc(a, list.is_empty(b))

  let #(a_are_curr, a_arent_curr) = list.partition(a, eq_fn(_, curr))
  let #(b_are_curr, b_arent_curr) = list.partition(b, eq_fn(_, curr))

  case list_eq(a_are_curr, b_are_curr, eq_fn) {
    True -> equal_order_independant(a_arent_curr, b_arent_curr, eq_fn)
    False -> False
  }
}

/// To be consired as a "common", a value should be contained in ALL lists
pub fn remove_commons(
  lists: List(List(a)),
  eq_fn: fn(a, a) -> Bool,
) -> List(List(a)) {
  use curr_list <- list.map(lists)
  use ele_of_curr <- list.filter(curr_list)

  !{
    use other_list <- list.all(lists)
    use other_ele <- list.any(other_list)
    eq_fn(other_ele, ele_of_curr)
  }
}

/// To be consired as a "common", a value should be contained in ALL lists
pub fn only_commons(
  lists: List(List(a)),
  eq_fn: fn(a, a) -> Bool,
) -> List(List(a)) {
  use curr_list <- list.map(lists)
  use ele_of_curr <- list.filter(curr_list)
  use other_list <- list.all(lists)
  use other_ele <- list.any(other_list)

  eq_fn(other_ele, ele_of_curr)
}

/// Update only the first element that the function returns Ok
/// # Exemples : 
/// ```gleam
/// map_only_first([-10, 81, 20, -3], int.square_root)
/// // -> [-10, 9, 20, -3]
/// ```
pub fn map_only_first(
  in: List(a),
  with: fn(a) -> Result(a, Nil),
) -> Result(List(a), Nil) {
  map_only_first_loop(in, [], with)
}

fn map_only_first_loop(
  remaining: List(a),
  processed: List(a),
  with: fn(a) -> Result(a, Nil),
) -> Result(List(a), Nil) {
  use curr, remaining <- first_or_return_acc(remaining, Error(Nil))

  case with(curr) {
    Error(_) -> map_only_first_loop(remaining, [curr, ..processed], with)

    Ok(mapped) -> {
      Ok(processed |> list.append([mapped, ..remaining]))
    }
  }
}
