import expr/distributivity
import expr/expr.{
  type Expr, type Terms, Addition, Multiplication, Number, add, multiply,
}
import gleam/list
import gleam/result
import utils.{first_or_return_acc}

pub fn simplify_terms(terms: Terms) -> Expr {
  let constant_sum =
    list.fold(terms, 0, fn(product, factor) {
      case factor {
        Number(n) -> n + product
        _ -> product
      }
    })

  let terms =
    terms
    |> list.filter(fn(term) { !expr.is_number(term) })
    |> group_terms([])
    |> factorize_terms([])

  case constant_sum, terms {
    0, [single_term] -> single_term
    _, [] -> Number(constant_sum)
    0, terms -> add(terms)
    _, _ -> add([Number(constant_sum), ..terms])
  }
}

fn factorize_terms(remaining: List(Expr), processed: Terms) -> Terms {
  use curr_factors, remaining <- first_or_return_acc(remaining, processed)

  let maybe_factorized_terms =
    utils.map_only_first(remaining, fn(factors) {
      let factorized =
        [factors, curr_factors]
        |> distributivity.factor_with_one()

      case factorized {
        Ok(Multiplication([Number(_), _])) -> Error(Nil)
        Ok(Multiplication([common_factor, Addition([Number(j), Number(k)])])) ->
          Ok(multiply([common_factor, Number(j + k)]))
        _ -> Error(Nil)
      }
    })

  case maybe_factorized_terms {
    Error(_) -> factorize_terms(remaining, [curr_factors, ..processed])

    Ok(terms_including_factorized_one) ->
      factorize_terms(terms_including_factorized_one, processed)
  }
}

fn group_terms(remaining: Terms, processed: Terms) -> Terms {
  use curr_term, remaining <- first_or_return_acc(remaining, processed)

  let #(same_terms, different_terms) =
    list.partition(remaining, expr.eq(curr_term, _))

  let same_terms_number = list.length(same_terms) + 1

  let simplified_term = case same_terms_number, curr_term {
    1, _ -> curr_term
    _, Multiplication(curr_term_factors) -> {
      curr_term_factors
      |> utils.map_only_first(fn(factor) {
        case factor {
          Number(n) -> Ok(Number(n * same_terms_number))
          _ -> Error(Nil)
        }
      })
      |> result.unwrap(or: [Number(same_terms_number), curr_term])
      |> multiply
    }
    _, _ -> multiply([Number(same_terms_number), curr_term])
  }

  group_terms(different_terms, [simplified_term, ..processed])
}
