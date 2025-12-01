import gleam/bool
import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import util

fn modulo(a: Int, b: Int) -> Int {
  util.unwrap(int.modulo(a, b))
}

pub fn pt_1(input: String) -> Int {
  input
  |> string.split("\n")
  |> list.fold(#(50, 0), fn(pair, instruction) {
    let #(dial, count) = pair
    process_instruction(instruction, dial, count)
  })
  |> pair.second
}

fn process_instruction(
  instruction: String,
  dial: Int,
  count: Int,
) -> #(Int, Int) {
  let increment = case instruction {
    "L" <> n -> util.unwrap(int.parse(n))
    "R" <> n -> -util.unwrap(int.parse(n))
    _ -> panic
  }

  let new_value = modulo(dial + increment, 100)

  let count = case new_value {
    0 -> count + 1
    _ -> count
  }

  #(new_value, count)
}

pub fn pt_2(input: String) -> Int {
  input
  |> string.split("\n")
  |> list.fold(#(50, 0), fn(pair, instruction) {
    let #(dial, count) = pair
    process_each_click(instruction, dial, count)
  })
  |> pair.second
}

fn process_each_click(instruction: String, dial: Int, count: Int) -> #(Int, Int) {
  let #(direction, increment) = case instruction {
    "L" <> n -> #(1, util.unwrap(int.parse(n)))
    "R" <> n -> #(-1, util.unwrap(int.parse(n)))
    _ -> panic
  }

  loop(dial, count, increment, direction)
}

fn loop(dial: Int, count: Int, increment: Int, direction: Int) -> #(Int, Int) {
  use <- bool.guard(increment == 0, #(dial, count))

  let new_value = modulo(dial + direction, 100)

  let count = case new_value {
    0 -> count + 1
    _ -> count
  }

  loop(new_value, count, increment - 1, direction)
}
