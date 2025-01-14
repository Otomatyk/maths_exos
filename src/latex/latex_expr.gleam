import expr/expr.{type Expr}
import gleam/int
import gleam/list
import gleam/string
import utils.{first_or_return_acc}

const exponenation_priority = 3

const multiplication_priority = 2

const addition_priority = 1

const new_context_priority = -999

type StackElement =
  #(Expr, Int, Int)

/// Generate the latex code of an expression, use `latex/latex_utils.math` to wrap with `$`
pub fn from(expr: Expr) -> String {
  latex(placeholder(0), [#(expr, 0, new_context_priority)], 1)
  |> string.replace(each: "+ -", with: "- ")
}

fn placeholder(id: Int) -> String {
  "@" <> int.to_string(id)
}

fn placeholder_list(list: List(Expr), next_id: Int) -> List(String) {
  list.index_map(list, fn(_, idx) { placeholder(next_id + idx) })
}

fn id_for_each(
  next_id: Int,
  a: List(Expr),
  parent_order: Int,
) -> List(StackElement) {
  list.index_map(a, fn(expr, idx) { #(expr, next_id + idx, parent_order) })
}

fn put_parenthesis_if(s: String, when: Bool) -> String {
  case when {
    True -> "(" <> s <> ")"
    False -> s
  }
}

// {{3 + x} \\ times {8} \\times -{-10}}
fn factors_to_string_and_stack(
  factors: expr.Factors,
  next_id: Int,
  parent_order: Int,
) -> #(String, List(StackElement)) {
  let #(numbers, non_numbers) = list.partition(factors, expr.is_number)

  let non_numbers_part =
    non_numbers
    |> placeholder_list(next_id)
    |> string.join("")

  let stack_non_numbers = id_for_each(next_id, non_numbers, parent_order)

  let next_id = next_id + list.length(non_numbers)

  let stack =
    id_for_each(next_id, numbers, parent_order)
    |> list.append(stack_non_numbers)

  let result = case list.length(numbers) {
    0 -> non_numbers_part
    1 -> {
      let assert Ok(expr.Number(n)) = list.first(numbers)

      case n {
        -1 -> "-" <> non_numbers_part
        _ -> placeholder(next_id) <> non_numbers_part
      }
    }
    _ -> {
      numbers
      |> placeholder_list(next_id)
      |> string.join(" \\times ")
      |> string.append(case non_numbers_part {
        "" -> ""
        _ -> " \\times " <> non_numbers_part
      })
    }
  }

  #(result, stack)
}

fn latex(compiled: String, stack: List(StackElement), next_id: Int) -> String {
  use #(curr, curr_id, parent_order), stack <- first_or_return_acc(
    stack,
    compiled,
  )

  let replace = placeholder(curr_id)

  case curr {
    expr.Number(n) -> {
      compiled
      |> string.replace(each: replace, with: int.to_string(n))
      |> latex(stack, next_id + 1)
    }

    expr.Var(litteral) -> {
      compiled
      |> string.replace(each: replace, with: litteral)
      |> latex(stack, next_id + 1)
    }

    expr.Addition(terms) -> {
      let stack =
        id_for_each(next_id, terms, addition_priority)
        |> list.append(stack)

      let compiled =
        list.index_map(terms, fn(_, idx) { placeholder(next_id + idx) })
        |> string.join(" + ")
        |> put_parenthesis_if(parent_order > addition_priority)
        |> string.replace(compiled, each: replace, with: _)

      latex(compiled, stack, next_id + list.length(terms))
    }

    expr.Multiplication(factors) -> {
      let #(result, stack_to_add) =
        factors_to_string_and_stack(factors, next_id, multiplication_priority)

      string.replace(compiled, each: replace, with: result)
      |> latex(
        stack
          |> list.append(stack_to_add),
        next_id + list.length(factors),
      )
    }

    expr.Exponenation(base, exp) -> {
      let stack =
        [
          #(base, next_id, exponenation_priority),
          #(exp, next_id + 1, new_context_priority),
        ]
        |> list.append(stack)

      let compiled =
        {
          "{"
          <> placeholder(next_id)
          <> "} ^ {"
          <> placeholder(next_id + 1)
          <> "}"
        }
        |> string.replace(compiled, each: replace, with: _)

      latex(compiled, stack, next_id + 2)
    }
  }
}
