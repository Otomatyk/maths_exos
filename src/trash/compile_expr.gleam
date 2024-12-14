// import gleam/list
// import expr.{type Expr, type Instr, InstrExpr, UsedExpr}

// pub type CompiledExpr =
//   List(Instr)

// type UnplacedInstr {
//   InstrForCompiled(Instr)
//   InstrsForStack(List(Expr))
// }

// fn expr_to_instr(ex: Expr) -> UnplacedInstr {
//   case ex {
//     expr.Number(_) | expr.Var(_) -> InstrForCompiled(InstrExpr(ex))

//     UsedExpr(op) -> InstrForCompiled(op)

//     expr.Addition(terms) ->
//       InstrsForStack(
//         list.append(terms, [UsedExpr(expr.InstrAdd(arrity: list.length(terms)))]),
//       )

//     expr.Multiplication(factors) ->
//       InstrsForStack(
//         list.append(factors, [
//           UsedExpr(expr.InstrMul(arrity: list.length(factors))),
//         ]),
//       )

//     expr.Exponenation(base, exp) ->
//       InstrsForStack(list.append([base, exp], [UsedExpr(expr.InstrPow)]))
//   }
// }

// fn compile_expr_(stack: List(Expr), compiled: CompiledExpr) -> CompiledExpr {
//   let curr = list.first(stack)

//   case curr {
//     Ok(curr) -> {
//       let new_stack = list.drop(stack, 1)

//       case expr_to_instr(curr) {
//         InstrForCompiled(instr) ->
//           list.append(compiled, [instr])
//           |> compile_expr_(new_stack, _)

//         InstrsForStack(instrs) ->
//           list.append(instrs, new_stack)
//           |> compile_expr_(compiled)
//       }
//     }
//     Error(_) -> compiled
//   }
// }

// pub fn compile_expr(expr: Expr) -> List(Instr) {
//   compile_expr_([expr], [])
// }
