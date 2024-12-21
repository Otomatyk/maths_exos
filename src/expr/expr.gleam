import gleam/list

pub type Instr {
  InstrAdd(arrity: Int)
  InstrMul(arrity: Int)
  InstrPow
  InstrExpr(Expr)
}

pub type Factors =
  List(Expr)

pub type Terms =
  List(Expr)

/// `Multiplication` and `Addition` should never be created with this type,
/// instead use `multiply` and `add` in order to avoid nested mutliplication/addition
pub type Expr {
  /// Intern value used for expression compilation, it can be simply ignored since it shouldn't be used anywhere else 
  UsedExpr(op: Instr)

  Addition(terms: Terms)
  Multiplication(factors: Factors)
  Exponenation(base: Expr, exp: Expr)
  Var(String)
  Number(Int)
}

pub fn multiply(factors: Factors) -> Expr {
  let factors =
    factors
    |> list.fold([], fn(acc, factor) {
      case factor {
        Multiplication(mul_factors) -> list.append(acc, mul_factors)
        _ -> list.append(acc, [factor])
      }
    })

  Multiplication(factors)
}

pub fn add(terms: Terms) -> Expr {
  let terms =
    terms
    |> list.fold([], fn(acc, term) {
      case term {
        Addition(add_terms) -> list.append(acc, add_terms)
        _ -> list.append(acc, [term])
      }
    })

  Addition(terms)
}

pub fn is_number(expr: Expr) -> Bool {
  case expr {
    Number(_) -> True
    _ -> False
  }
}
