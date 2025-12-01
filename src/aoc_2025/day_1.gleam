import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import util

pub fn pt_1(input: String) -> Int {
  input
  |> string.split("\n")
  |> list.scan(50, process_instruction)
  |> list.count(fn(x) { x == 0 })
}

fn process_instruction(dial: Int, instruction: String) -> Int {
  let increment = case instruction {
    "L" <> n -> -util.parse(n)
    "R" <> n -> util.parse(n)
    _ -> panic
  }

  { dial + increment } % 100
}

pub fn pt_2(input: String) -> Int {
  input
  |> string.split("\n")
  |> list.map_fold(50, count_each_click)
  |> pair.second
  |> int.sum
}

fn count_each_click(dial: Int, instruction: String) -> #(Int, Int) {
  let #(change, past) = case instruction {
    "L" <> n -> {
      let change = -util.parse(n)

      let past = case dial {
        0 -> -change / 100
        _ -> { 100 - dial - change } / 100
      }

      #(change, past)
    }
    "R" <> n -> {
      let change = util.parse(n)

      let past = { dial + change } / 100
      #(change, past)
    }
    _ -> panic
  }

  let dial = modulo(dial + change, 100)
  #(dial, past)
}

fn modulo(dividend: Int, divisor: Int) -> Int {
  let remainder = dividend % divisor
  case dividend >= 0 {
    False if remainder != 0 -> remainder + divisor
    _ -> remainder
  }
}
