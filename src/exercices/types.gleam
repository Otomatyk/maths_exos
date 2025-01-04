import expr/expr.{type Expr}
import gleam/option.{type Option}

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

  /// The second element being None means the affirmation's true
  /// The String in the Some represents the correction (meaning the affirmation's false)
  TrueOrFalseExercice(affirmations: List(#(String, Option(String))))

  MapExercice(prompt: String, pairs: List(#(String, String)))
}

pub type ExerciceSheet {
  ExerciceSheet(title: String, exercices: List(Exercice))
}
