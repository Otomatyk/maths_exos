import gleam/int
import gleam/list
import gleam/string
import gleam/io
import utils
import expr.{type Expr}

// "$1" [Add(Mul(3, 2), Sub(10, 3))]
// "($2) + ($3)" [Mul(3, 2), Sub(10, 3)]
// "($4 * $5) + ($2)" [3, 2, Sub(10, 3)]
//

type StackElement = #(Expr, Int)

pub fn generate(expr: Expr) -> String {
  "$" <> latex(placeholder(0), [#(expr, 0)], 1) <> "$"
}

fn placeholder(id: Int) -> String {
  "@" <> int.to_string(id)
}

fn id_for_each(next_id: Int, a: List(Expr)) -> List(StackElement) {
  list.index_map(a, fn(expr, idx) { #(expr, next_id + idx) })
}

fn operation_priority(expr: Expr) -> Int {
  case expr {
    expr.Exponenation(_, _) -> 3
    expr.Multiplication(_) -> 2
    expr.Addition(_) -> 1

    expr.Number(_) -> 0
    expr.Var(_) -> 0

    expr.UsedExpr(_) -> -1
  }
}

fn is_prioriter_than(a: Expr, than: Expr) -> Bool {
  operation_priority(a) > operation_priority(than)
}

fn latex(
  compiled: String,
  stack: List(StackElement),
  next_id: Int,
) -> String {
  let curr = list.first(stack)

  case curr {
    Ok(#(curr, curr_id)) -> {
      let stack = list.drop(stack, 1)
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
            id_for_each(next_id, terms)
            |> list.append(stack)

          let compiled =
            list.index_map(terms, fn(_, idx) { placeholder(next_id + idx) })
            |> string.join(" + ")
            |> fn(e) {"(" <> e <> ")"}
            |> string.replace(compiled, each: replace, with: _)

          latex(compiled, stack, next_id + list.length(terms))
        }

        expr.Multiplication(factors) -> {
          let stack =
            id_for_each(next_id, factors)
            |> list.append(stack)

          let factors_ =
            list.index_map(factors, fn(_, idx) { placeholder(next_id + idx) })

          case factors {
            [expr.Number(_), expr.Number(_)] -> string.join(factors_, " \\times ")

            [expr.Number(_), _] -> {
              placeholder(next_id) <> placeholder(next_id + 1)
            }
            [_, expr.Number(_)] -> {
              placeholder(next_id + 1) <> placeholder(next_id)
            }
            _ -> string.join(factors_, " \\times ")
          }
          |> string.replace(compiled, each: replace, with: _)
          |> latex(stack, next_id + list.length(factors))
        }

        expr.Exponenation(base, exp) -> {
          let stack =
            [#(base, next_id), #(exp, next_id + 1)]
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

        expr.UsedExpr(_) -> latex(compiled, stack, next_id)
      }
    }

    Error(_) -> compiled
  }
}
