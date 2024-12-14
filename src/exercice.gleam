/// An exercice after being compiled to latex
pub type CompiledExercice {
  CompiledExercice(problems: String, solutions: String)
}

pub type Question {
  Question(prompt: String, solution: String)
}

pub type Exercice {
  Exercice(prompt: String, questions: List(Question))
}

pub type ExerciceSheet {
  ExerciceSheet(title: String, exercices: List(Exercice))
}
