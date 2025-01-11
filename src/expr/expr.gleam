import gleam/list
import utils.{equal_order_independant}

pub type Factors =
  List(Expr)

pub type Terms =
  List(Expr)

/// `Multiplication` and `Addition` should never be created with this type,
/// instead use `multiply` and `add` in order to avoid nested mutliplication/addition
pub type Expr {
  Addition(terms: Terms)
  Multiplication(factors: Factors)
  Exponenation(base: Expr, exp: Expr)
  Var(String)
  Number(Int)
}

pub fn multiply(factors: Factors) -> Expr {
  case factors {
    [single_value] -> single_value
    _ -> {
      factors
      |> list.fold([], fn(acc, factor) {
        case factor {
          Multiplication(mul_factors) ->
            mul_factors |> list.reverse() |> list.append(acc)
          _ -> [factor, ..acc]
        }
      })
      |> list.reverse()
      |> Multiplication
    }
  }
}

pub fn add(terms: Terms) -> Expr {
  case terms {
    [single_value] -> single_value
    _ -> {
      terms
      |> list.fold([], fn(acc, term) {
        case term {
          Addition(add_terms) -> add_terms |> list.reverse() |> list.append(acc)
          _ -> [term, ..acc]
        }
      })
      |> list.reverse()
      |> Addition
    }
  }
}

pub fn squared(expr: Expr) -> Expr {
  Exponenation(expr, Number(2))
}

pub fn is_number(expr: Expr) -> Bool {
  case expr {
    Number(_) -> True
    _ -> False
  }
}

/// Check if two Exprs are equal, regardless of their terms/factors order
/// This function isn't tail-rec recursive 
pub fn eq(a: Expr, b: Expr) -> Bool {
  case a, b {
    Number(j), Number(k) -> j == k
    Var(j), Var(k) -> j == k

    Exponenation(base_a, exp_a), Exponenation(base_b, exp_b) ->
      eq(base_a, base_b) && eq(exp_a, exp_b)

    Addition(terms_a), Addition(terms_b) ->
      equal_order_independant(terms_a, terms_b, eq)

    Multiplication(factors_a), Multiplication(factors_b) ->
      equal_order_independant(factors_a, factors_b, eq)

    _, _ -> False
  }
}
