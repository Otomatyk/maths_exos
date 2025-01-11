import gleeunit
import gleeunit/should.{be_false, be_true, equal}
import utils.{eq, equal_order_independant, only_commons, remove_commons}

pub fn main() {
  gleeunit.main()
}

pub fn equal_order_independant_test() {
  equal_order_independant([], [], eq)
  |> be_true

  equal_order_independant([], [1], eq)
  |> be_false

  equal_order_independant([1], [], eq)
  |> be_false

  equal_order_independant([1], [1], eq)
  |> be_true

  equal_order_independant([1], [2], eq)
  |> be_false

  equal_order_independant([1], [1, 1], eq)
  |> be_false

  equal_order_independant([1, 1], [1, 1], eq)
  |> be_true

  equal_order_independant([1, 2, 3], [3, 1, 2], eq)
  |> be_true

  equal_order_independant([1, 1, 1, 2], [2, 2, 1, 1], eq)
  |> be_false
}

pub fn only_commons_two_test() {
  only_commons([[], []], eq)
  |> equal([[], []])

  only_commons([[1], []], eq)
  |> equal([[], []])

  only_commons([[], [1]], eq)
  |> equal([[], []])

  only_commons([[1], [1]], eq)
  |> equal([[1], [1]])

  only_commons([[2], [2, 2]], eq)
  |> equal([[2], [2, 2]])

  only_commons([[2, 3, 3, 5], [5, 2, 3]], eq)
  |> equal([[2, 3, 3, 5], [5, 2, 3]])

  only_commons([[3, 3, 1, 2], [3, 2]], eq)
  |> equal([[3, 3, 2], [3, 2]])

  only_commons([[1, 2, 3], [4, 5, 6]], eq)
  |> equal([[], []])

  only_commons([[1, 2, 8, 3], [8, 4, 5, 6]], eq)
  |> equal([[8], [8]])
}

pub fn only_commons_three_test() {
  only_commons([[], [], []], eq)
  |> equal([[], [], []])

  only_commons([[1], [], []], eq)
  |> equal([[], [], []])

  only_commons([[1], [1], [1]], eq)
  |> equal([[1], [1], [1]])

  only_commons([[2], [2, 2], [2, 2, 2]], eq)
  |> equal([[2], [2, 2], [2, 2, 2]])

  only_commons([[2, 3, 5], [5, 3, 2, 2], [5, 5, 2, 3, 3]], eq)
  |> equal([[2, 3, 5], [5, 3, 2, 2], [5, 5, 2, 3, 3]])

  only_commons([[1, 2, 3], [3, 2, 1], [1, 2, 3, 2, 4]], eq)
  |> equal([[1, 2, 3], [3, 2, 1], [1, 2, 3, 2]])

  only_commons([[1, 2, 3], [4, 5, 6], [7, 8, 9]], eq)
  |> equal([[], [], []])

  only_commons([[1, 2, 8, 3], [8, 4, 5, 6], [7, 8, 9]], eq)
  |> equal([[8], [8], [8]])
}

pub fn remove_commons_two_test() {
  remove_commons([[], []], eq)
  |> equal([[], []])

  remove_commons([[1], []], eq)
  |> equal([[1], []])

  remove_commons([[], [1]], eq)
  |> equal([[], [1]])

  remove_commons([[1], [1]], eq)
  |> equal([[], []])

  remove_commons([[2], [2, 2]], eq)
  |> equal([[], []])

  remove_commons([[2, 3, 3, 5], [5, 2, 3]], eq)
  |> equal([[], []])

  remove_commons([[3, 3, 1, 2], [3, 2]], eq)
  |> equal([[1], []])

  remove_commons([[1, 2, 3], [4, 5, 6]], eq)
  |> equal([[1, 2, 3], [4, 5, 6]])

  remove_commons([[1, 2, 8, 3], [8, 4, 5, 6]], eq)
  |> equal([[1, 2, 3], [4, 5, 6]])
}

pub fn remove_commons_three_test() {
  remove_commons([[], [], []], eq)
  |> equal([[], [], []])

  remove_commons([[1], [], []], eq)
  |> equal([[1], [], []])

  remove_commons([[1], [1], [1]], eq)
  |> equal([[], [], []])

  remove_commons([[2], [2, 2], [2, 2, 2]], eq)
  |> equal([[], [], []])

  remove_commons([[2, 3, 5], [5, 3, 2, 2], [5, 5, 2, 3, 3]], eq)
  |> equal([[], [], []])

  remove_commons([[1, 2, 3], [3, 2, 1], [1, 2, 3, 2, 4]], eq)
  |> equal([[], [], [4]])

  remove_commons([[1, 2, 3], [4, 5, 6], [7, 8, 9]], eq)
  |> equal([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

  remove_commons([[1, 2, 8, 3], [8, 4, 5, 6], [7, 8, 9]], eq)
  |> equal([[1, 2, 3], [4, 5, 6], [7, 9]])
}
