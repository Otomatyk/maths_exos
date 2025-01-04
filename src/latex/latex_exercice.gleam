import exercices/types.{type CompiledExercice, type Exercice, CompiledExercice}
import gleam/int
import gleam/list
import gleam/option
import gleam/pair
import gleam/string
import latex/latex_expr
import latex/latex_utils.{
  begin, bullet, extra_large_hspace, large_vspace, medium_vspace, ordered_list,
  par, small_vspace, unbreakable_block,
}
import utils

fn exercice_title(idx: Int) -> String {
  "\n\\textbf{\\Large Exercice " <> int.to_string(idx) <> "}" <> small_vspace()
}

fn map_exercice(prompt: String, pairs: List(#(String, String))) {
  let #(left_ones, right_ones) = list.unzip(pairs)

  let body =
    left_ones
    |> list.shuffle()
    |> list.map2(right_ones, fn(a, b) {
      [
        a,
        bullet() <> extra_large_hspace() <> extra_large_hspace() <> bullet(),
        b,
      ]
    })
    |> latex_utils.table("l c l", padding_factor: 1.2, row_divider: False)

  let solution = latex_utils.table_map(pairs)

  #(prompt, body, solution)
}

fn equality_list_exercice(prompt, equalities: List(types.Equality)) {
  let body =
    equalities
    |> list.index_map(fn(eq, eq_idx) {
      utils.int_to_uppercase_letter(eq_idx)
      <> " = $"
      <> latex_expr.from(eq.initial_expr)
      <> "$"
    })
    |> string.join(par() <> small_vspace())

  let solutions =
    equalities
    |> list.index_map(fn(eq, eq_idx) {
      begin("flalign*", {
        utils.int_to_uppercase_letter(eq_idx)
        <> {
          eq.solution_steps
          |> list.map(latex_expr.from)
          |> list.map(string.append(" & = ", _))
          |> string.join("&&\\\\")
        }
      })
    })
    |> string.join("\n")

  #(prompt, body, solutions)
}

fn questions_exercice(prompt, questions: List(types.Question)) {
  let body =
    questions
    |> list.map(fn(q) { q.prompt })
    |> ordered_list()

  let solutions =
    questions
    |> list.map(fn(q) { q.solution })
    |> ordered_list()

  #(prompt, body, solutions)
}

fn true_or_false_exercice(affirmations) {
  let body =
    affirmations
    |> list.map(fn(affirmation_tuple) {
      let #(affirmation, _) = affirmation_tuple

      [affirmation, " V / F"]
    })
    |> latex_utils.table(
      "w{l}{0.9\\columnwidth} | w{c}{0.1\\columnwidth}",
      row_divider: True,
      padding_factor: 2.5,
    )

  let solutions =
    affirmations
    |> list.map(pair.map_second(_, fn(correction) {
      case correction {
        option.None -> "Vrai"
        option.Some(correction) -> "Faux ; " <> correction
      }
    }))
    |> latex_utils.table_map()

  #(
    "Pour chaque affirmaton, sans justification entourer le V si elle est vraie sinon entourer le F",
    body,
    solutions,
  )
}

pub fn compile_exercice(ex: Exercice, idx: Int) -> CompiledExercice {
  let #(prompt, body, solution) = case ex {
    types.EqualityListExercice(prompt, equalities) ->
      equality_list_exercice(prompt, equalities)

    types.QuestionsExercice(prompt, questions) ->
      questions_exercice(prompt, questions)

    types.TrueOrFalseExercice(affirmations) ->
      true_or_false_exercice(affirmations)

    types.MapExercice(prompt, pairs) -> map_exercice(prompt, pairs)
  }

  let exercice_title = exercice_title(idx + 1)

  CompiledExercice(
    problems: unbreakable_block({
      exercice_title
      <> par()
      <> prompt
      <> medium_vspace()
      <> par()
      <> body
      <> large_vspace()
      <> par()
    }),
    solutions: unbreakable_block(
      exercice_title <> solution <> large_vspace() <> par(),
    ),
  )
}
