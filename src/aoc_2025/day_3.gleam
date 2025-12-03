import gleam/int
import gleam/list
import gleam/string

pub fn pt_1(input: String) {
  input
  |> string.split("\n")
  |> list.map(fn(bank) {
    bank |> string.to_graphemes |> list.filter_map(int.parse)
  })
  |> list.map(max_from_bank(_, 2))
  |> int.sum
}

pub fn pt_2(input: String) {
  input
  |> string.split("\n")
  |> list.map(fn(bank) {
    bank |> string.to_graphemes |> list.filter_map(int.parse)
  })
  |> list.map(max_from_bank(_, 12))
  |> int.sum
}

fn max_from_bank(bank: List(Int), n: Int) -> Int {
  let #(_, digits) =
    list.map_fold(list.range(n - 1, 0), bank, fn(bank, remaining_batteries) {
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
        False if first > highest ->
          find_highest_digit(first, remaining_batteries, rest, rest)
        False -> find_highest_digit(highest, remaining_batteries, rest, after)
      }
  }
}
