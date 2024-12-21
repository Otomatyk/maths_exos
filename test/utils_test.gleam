import gleeunit
import gleeunit/should.{be_false, be_true, equal}
import utils.{equal_order_independant, remove_commons}

pub fn main() {
  gleeunit.main()
}

pub fn equal_order_independant_test() {
  equal_order_independant([], [])
  |> be_true

  equal_order_independant([], [1])
  |> be_false

  equal_order_independant([1], [])
  |> be_false

  equal_order_independant([1], [1])
  |> be_true

  equal_order_independant([1], [2])
  |> be_false

  equal_order_independant([1], [1, 1])
  |> be_false

  equal_order_independant([1, 1], [1, 1])
  |> be_true

  equal_order_independant([1, 2, 3], [3, 1, 2])
  |> be_true

  equal_order_independant([1, 1, 1, 2], [2, 2, 1, 1])
  |> be_false
}

pub fn remove_commons_two_test() {
  remove_commons([[], []])
  |> equal([[], []])

  remove_commons([[1], []])
  |> equal([[1], []])

  remove_commons([[], [1]])
  |> equal([[], [1]])

  remove_commons([[1], [1]])
  |> equal([[], []])

  remove_commons([[2], [2, 2]])
  |> equal([[], []])

  remove_commons([[2, 3, 3, 5], [5, 2, 3]])
  |> equal([[], []])

  remove_commons([[3, 3, 1, 2], [3, 2]])
  |> equal([[1], []])

  remove_commons([[1, 2, 3], [4, 5, 6]])
  |> equal([[1, 2, 3], [4, 5, 6]])

  remove_commons([[1, 2, 8, 3], [8, 4, 5, 6]])
  |> equal([[1, 2, 3], [4, 5, 6]])
}

pub fn remove_commons_three_test() {
  remove_commons([[], [], []])
  |> equal([[], [], []])

  remove_commons([[1], [], []])
  |> equal([[1], [], []])

  remove_commons([[1], [1], [1]])
  |> equal([[], [], []])

  remove_commons([[2], [2, 2], [2, 2, 2]])
  |> equal([[], [], []])

  remove_commons([[2, 3, 5], [5, 3, 2, 2], [5, 5, 2, 3, 3]])
  |> equal([[], [], []])

  remove_commons([[1, 2, 3], [3, 2, 1], [1, 2, 3, 2, 4]])
  |> equal([[], [], [4]])

  remove_commons([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
  |> equal([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

  remove_commons([[1, 2, 8, 3], [8, 4, 5, 6], [7, 8, 9]])
  |> equal([[1, 2, 3], [4, 5, 6], [7, 9]])
}
