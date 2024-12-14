import gleam/list

pub type Instr {
  InstrAdd(arrity: Int)
  InstrMul(arrity: Int)
  InstrPow
  InstrExpr(Expr)
}

pub type Expr {
  /// Intern value used for expression compilation, it can be simply ignored since it shouldn't be used anywhere else 
  UsedExpr(op: Instr)

  Addition(terms: List(Expr))
  Multiplication(factors: List(Expr))
  Exponenation(base: Expr, exp: Expr)
  Var(String)
  Number(Int)
}

pub fn multiply(a: Expr, b: Expr) -> Expr {
  let factors_a = case a {
    Multiplication(factors) -> factors
    _ -> [a]
  }

  let factors_b = case b {
    Multiplication(factors) -> factors
    _ -> [b]
  }

  Multiplication(list.append(factors_a, factors_b))
}

pub fn is_number(expr: Expr) -> Bool {
  case expr {
    Number(_) -> True
    _ -> False
  }
}
