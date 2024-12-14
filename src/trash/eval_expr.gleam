// import gleam/list
// import gleam/result
// import gleam/io
// import gleam/dict
// import gleam/int
// import compile_expr.{type CompiledExpr}
// import expr.{type Expr, type Instr}

// pub fn eval_compiled(
//   program: CompiledExpr,
//   stack: List(Expr),
// ) -> Result(Expr, String) {
//   case list.first(program) {
//     Ok(curr) -> {
//       let new_program = list.drop(program, 1)

//       case curr {
//         expr.InstrExpr(ex) -> eval_compiled(new_program, [ex, ..stack])

//         expr.InstrAdd(arrity) -> {
//           let sum = add_exprs(list.take(stack, arrity))

//           eval_compiled(new_program, [sum, ..list.take(stack, arrity)])
//         }

//         expr.InstrMul(arrity) -> {
//           let product = mul_exprs(list.take(stack, arrity))

//           eval_compiled(new_program, [product, ..list.take(stack, arrity)])
//         }
//       }
//     }
//     Error(_) -> final_stack_value(stack)
//   }
// }

// fn final_stack_value(stack: List(Expr)) -> Result(Expr, String) {
//   list.first(stack)
//   |> result.replace_error(
//     "Fatal error : The stack is empty and there isn't anything to compile anymore",
//   )
// }

// // f([2x, 2a, x], [])
// // f([2x, 2a, x], [#(2x, 2a), [2x, x], [2a, x]])
// // f([2x, 2a, x], [#(2x, x), #(2a, x)])
// // f([3x, a], [#(3x, a)])
// // -> [3x, a]

// fn mul_exprs(factors: List(Expr)) -> Expr {
//   let number_factor =
//     factors
//     |> list.fold(1, fn(acc, factor) {
//       case factor {
//         expr.Number(n) -> acc * n
//         _ -> acc
//       }
//     })
//     |> expr.Number

//   let other_factors =
//     factors
//     |> list.filter(fn(factor) {
//       case factor {
//         expr.Number(_) -> False
//         _ -> True
//       }
//     })

//   case number_factor {
//     expr.Number(1) -> {
//       expr.Multiplication(other_factors)
//     }
//     _ -> {
//       expr.Multiplication([number_factor, ..other_factors])
//     }
//   }
// }

// // fn develop_multiplication(facors: List(expr.Expr)) -> List(expr.Expr) {

// // }

// // fn simplify_addition(stack: expr.Expr) -> Result(expr.Expr, String) {

// // }

// fn add_exprs(stack: List(Expr)) -> Expr {
//   todo
//   // case list.first(stack) {
//   //   Ok(curr) -> {
//   //     let new_stack = list.drop(stack, 1)

//   //     case curr {
//   //       expr.Addition(terms) -> {
//   //         terms
//   //         |> list.append(new_stack)
//   //         |> add_exprs()
//   //       }

//   //       expr.Multiplication(_) -> panic

//   //       expr.Number(_) | expr.Variable(_) -> panic

//   //       expr.UsedExpr(_) -> add_exprs(new_stack)
//   //     }

//   //     expr.Number(10)
//   //   }
//   //   Error(_) -> panic
//   // }
// }
