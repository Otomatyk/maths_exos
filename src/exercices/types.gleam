import expr/expr.{type Expr}

/// An exercice after being compiled to latex
pub type CompiledExercice {
  CompiledExercice(problems: String, solutions: String)
}

pub type Question {
  Question(prompt: String, solution: String)
}

pub type Equality {
  Equality(initial_expr: Expr, solution_steps: List(Expr))
}

pub type Exercice {
  QuestionsExercice(prompt: String, questions: List(Question))

  /// Each equality is in the format $A = ...$
  /// The left part will be added automaticly (don't add $A =$)
  EqualityListExercice(prompt: String, questions: List(Equality))

  TrueOrFalseExercice(affirmations: List(#(String, Bool)))

  MapExercice(prompt: String, pairs: List(#(String, String)))
}

pub type ExerciceSheet {
  ExerciceSheet(title: String, exercices: List(Exercice))
}
