//// Here are the rules used for simplifying :
//// ✅ I. Add numbers into a sum in an addition (e.g : x + 4 + 3 becomes x + 7)
//// ✅ II. Multiply numbers into a production in a multiplication(e.g : 7 * x * 5 becomes 35 * x)
//// ✅ III. When a term is present several times in an addition, transform it into a multiplication 
////     (e.g : x^2 + x^2 + 8 becomes 2 * x^2 + 8)
//// 
//// ✅ IV. When a factor is present several times in a mutliplciation, transform it into an exponentation
////     (e.g : (x + 1) * (x + 1) * y becomes (x + 1)^2 * y )
//// 
//// V. Factorize terms (e.g : 3 * x + 8 * x + 5 becomes 11 * x + 5
//// ✅ VI.   a^0           -> 1
//// ✅ VII.  a^1           -> a
//// ✅ VIII. 0 * [...]     -> 0
//// ✅ IIX.  1 * [...]     -> [...]
//// ✅ IX    0 + [...]     -> [...]
//// X.    a^p * a^q * [...] -> a^{p + q} * [...]
//// ✅ XI.   a^n * b^n * [...] -> (ab)^n * [...]
//// 

import expr/expr
import expr/simplify/addition.{simplify_terms as simplified_term_internal}
import expr/simplify/exponentation.{
  simplify_exponentation as simplify_exponentation_internal,
}
import expr/simplify/multiplication.{
  simplify_factors as simplify_factors_internal,
}
import gleam/list

pub fn simplify_factors(factors) {
  simplify_factors_internal(factors)
}

pub fn simplify_exponentation(base, exp) {
  simplify_exponentation_internal(base, exp)
}

pub fn simplify_terms(terms) {
  simplified_term_internal(terms)
}

pub fn deep_simplify(expr) {
  case expr {
    expr.Number(_) | expr.Var(_) -> expr
    expr.Addition(terms) ->
      simplified_term_internal(terms |> list.map(deep_simplify))

    expr.Multiplication(factors) ->
      simplify_factors_internal(factors |> list.map(deep_simplify))

    expr.Exponenation(base, exp) ->
      simplify_exponentation_internal(
        base |> deep_simplify(),
        exp |> deep_simplify(),
      )
  }
}

pub fn total_simplify(expr) {
  let simplified = deep_simplify(expr)

  case expr.eq(simplified, expr) {
    True -> simplified
    False -> total_simplify(simplified)
  }
}
