import expr/expr.{type Expr, Number}
import gleam/int
import gleam/list
import utils

/// This number is inclusive
const largest_number = 11

/// This function is used for an injection-pattern with exercices functions
pub type GenerateIntFn =
  fn() -> Expr

pub type GenerateNumberFeature {
  Negative
  NonNull
  NonPositiveOne
  NonNegativeOne
}

fn generate_number(features: List(GenerateNumberFeature)) -> Int {
  let n = int.random(largest_number)

  let n = case list.contains(features, Negative), utils.random_bool() {
    False, _ | True, False -> n
    True, True -> -n
  }

  let n = case list.contains(features, NonNull) {
    True if n == 0 -> generate_number(features)
    _ -> n
  }

  let n = case list.contains(features, NonPositiveOne) {
    True if n == 1 -> generate_number(features)
    _ -> n
  }

  let n = case list.contains(features, NonNegativeOne) {
    True if n == -1 -> generate_number(features)
    _ -> n
  }

  n
}

pub fn int_number_generator(
  features: List(GenerateNumberFeature),
) -> GenerateIntFn {
  fn() { Number(generate_number(features)) }
}
