import gleam/bool
import gleam/float
import gleam/int
import gleam/list
import gleam/string
import gleam_community/maths
import util

pub fn pt_1(input: String) {
  input
  |> string.split(",")
  |> list.filter_map(string.split_once(_, "-"))
  |> list.flat_map(find_invalid)
  |> int.sum
}

fn find_invalid(range: #(String, String)) -> List(Int) {
  let start = util.parse(range.0)
  let end = util.parse(range.1)

  list.range(start, end) |> list.filter(is_invalid)
}

fn is_invalid(value: Int) -> Bool {
  let power =
    value
    |> int.to_float
    |> maths.logarithm_10
    |> util.unwrap
    |> float.add(1.0)
    |> float.divide(2.0)
    |> util.unwrap
    |> float.floor
    |> int.power(10, _)
    |> util.unwrap
    |> float.truncate

  let upper_half = value / power
  let lower_half = value % power
  upper_half == lower_half
}

pub fn pt_2(input: String) {
  input
  |> string.split(",")
  |> list.filter_map(string.split_once(_, "-"))
  |> list.flat_map(find_invalid2)
  |> int.sum
}

fn find_invalid2(range: #(String, String)) -> List(Int) {
  let start = util.parse(range.0)
  let end = util.parse(range.1)

  list.range(start, end) |> list.filter(is_invalid2)
}

fn is_invalid2(value: Int) -> Bool {
  let length =
    value
    |> int.to_float
    |> maths.logarithm_10
    |> util.unwrap
    |> float.truncate
    |> int.add(1)

  use <- bool.guard(length == 1, False)

  list.any(list.range(1, length / 2), fn(n) {
    use <- bool.guard(length % n != 0, False)
    let power =
      n |> int.to_float |> int.power(10, _) |> util.unwrap |> float.truncate

    check_number(value, power)
  })
}

fn check_number(value: Int, power: Int) -> Bool {
  let first = value % power
  let rest = value / power
  check_number_loop(first, rest, power)
}

fn check_number_loop(first: Int, value: Int, power: Int) -> Bool {
  case value {
    0 -> True
    _ -> {
      let part = value % power
      let rest = value / power
      case part == first {
        True -> check_number_loop(first, rest, power)
        False -> False
      }
    }
  }
}
