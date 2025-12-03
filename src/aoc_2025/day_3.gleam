import gleam/int
import gleam/list
import gleam/string

pub fn pt_1(input: String) {
  input
  |> string.split("\n")
  |> list.map(fn(bank) {
    bank |> string.to_graphemes |> list.filter_map(int.parse)
  })
  |> list.map(max_from_bank)
  |> int.sum
}

fn max_from_bank(bank: List(Int)) -> Int {
  let #(first_digit, rest) = find_highest_first_digit(0, bank, bank)
  let assert Ok(second_digit) = list.max(rest, int.compare)
  first_digit * 10 + second_digit
}

fn find_highest_first_digit(
  highest: Int,
  bank: List(Int),
  after: List(Int),
) -> #(Int, List(Int)) {
  case bank {
    [] | [_] -> #(highest, after)
    [first, ..rest] ->
      case first > highest {
        True -> find_highest_first_digit(first, rest, rest)
        False -> find_highest_first_digit(highest, rest, after)
      }
  }
}

pub fn pt_2(input: String) {
  input
  |> string.split("\n")
  |> list.map(fn(bank) {
    bank |> string.to_graphemes |> list.filter_map(int.parse)
  })
  |> list.map(max_12_from_bank)
  |> int.sum
}

fn max_12_from_bank(bank: List(Int)) -> Int {
  let #(_, digits) =
    list.map_fold(list.range(11, 0), bank, fn(bank, remaining_batteries) {
      find_highest_digit(0, remaining_batteries, bank, bank)
    })
  list.fold(digits, 0, fn(total, digit) { total * 10 + digit })
}

fn find_highest_digit(
  highest: Int,
  remaining_batteries: Int,
  bank: List(Int),
  after: List(Int),
) -> #(List(Int), Int) {
  case bank {
    [] -> #(after, highest)
    [first, ..rest] ->
      case list.length(rest) < remaining_batteries {
        True -> #(after, highest)
        False ->
          case first > highest {
            True -> find_highest_digit(first, remaining_batteries, rest, rest)
            False ->
              find_highest_digit(highest, remaining_batteries, rest, after)
          }
      }
  }
}
