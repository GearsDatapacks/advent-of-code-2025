import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import util

pub fn pt_1(input: String) {
  let rows = string.split(input, "\n")

  parse_rows(rows, dict.new())
}

fn parse_rows(rows: List(String), problems: Dict(Int, List(Int))) -> Int {
  case rows {
    [] -> panic
    [last_row] -> parse_operations(problems, last_row, 0, 0)
    [row, ..rows] -> parse_rows(rows, parse_row(problems, row, 0, 0))
  }
}

fn parse_operations(
  problems: Dict(Int, List(Int)),
  row: String,
  index: Int,
  total: Int,
) -> Int {
  case row {
    "" -> total
    " " <> row -> parse_operations(problems, row, index, total)
    "*" <> row ->
      parse_operations(
        problems,
        row,
        index + 1,
        total + perform_operation(problems, index, int.multiply),
      )
    "+" <> row ->
      parse_operations(
        problems,
        row,
        index + 1,
        total + perform_operation(problems, index, int.add),
      )

    _ -> panic
  }
}

fn perform_operation(
  problems: Dict(Int, List(Int)),
  index: Int,
  operation: fn(Int, Int) -> Int,
) -> Int {
  case dict.get(problems, index) {
    Error(_) -> panic
    Ok(numbers) -> list.reduce(numbers, operation) |> util.unwrap
  }
}

fn parse_row(
  problems: Dict(Int, List(Int)),
  row: String,
  current_number: Int,
  index: Int,
) -> Dict(Int, List(Int)) {
  case row {
    "" if current_number == 0 -> problems
    "" ->
      dict.upsert(problems, index, fn(option) {
        case option {
          None -> [current_number]
          Some(list) -> [current_number, ..list]
        }
      })

    " " <> row if current_number == 0 ->
      parse_row(problems, row, current_number, index)
    " " <> row ->
      parse_row(
        dict.upsert(problems, index, fn(option) {
          case option {
            None -> [current_number]
            Some(list) -> [current_number, ..list]
          }
        }),
        row,
        0,
        index + 1,
      )

    "0" <> row -> parse_row(problems, row, current_number * 10, index)
    "1" <> row -> parse_row(problems, row, current_number * 10 + 1, index)
    "2" <> row -> parse_row(problems, row, current_number * 10 + 2, index)
    "3" <> row -> parse_row(problems, row, current_number * 10 + 3, index)
    "4" <> row -> parse_row(problems, row, current_number * 10 + 4, index)
    "5" <> row -> parse_row(problems, row, current_number * 10 + 5, index)
    "6" <> row -> parse_row(problems, row, current_number * 10 + 6, index)
    "7" <> row -> parse_row(problems, row, current_number * 10 + 7, index)
    "8" <> row -> parse_row(problems, row, current_number * 10 + 8, index)
    "9" <> row -> parse_row(problems, row, current_number * 10 + 9, index)

    _ -> panic
  }
}

pub fn pt_2(input: String) {
  input
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> list.transpose
  |> list.filter_map(parse_column(_, 0))
  |> total_operations(Add, 0, 0)
}

fn total_operations(
  columns: List(#(Int, Option(Operation))),
  operation: Operation,
  subtotal: Int,
  total: Int,
) -> Int {
  case columns {
    [] -> total + subtotal
    [#(number, op), ..columns] -> {
      let #(operation, subtotal, total) = case op {
        None -> #(operation, subtotal, total)
        Some(Add) -> #(Add, 0, total + subtotal)
        Some(Multiply) -> #(Multiply, 1, total + subtotal)
      }

      let subtotal = case operation {
        Add -> subtotal + number
        Multiply -> subtotal * number
      }

      total_operations(columns, operation, subtotal, total)
    }
  }
}

type Operation {
  Multiply
  Add
}

fn parse_column(
  column: List(String),
  number: Int,
) -> Result(#(Int, Option(Operation)), Nil) {
  case column {
    [] if number == 0 -> Error(Nil)
    [] -> Ok(#(number, None))
    ["*"] -> Ok(#(number, Some(Multiply)))
    ["+"] -> Ok(#(number, Some(Add)))

    [" ", ..column] -> parse_column(column, number)

    ["0", ..column] -> parse_column(column, number * 10)
    ["1", ..column] -> parse_column(column, number * 10 + 1)
    ["2", ..column] -> parse_column(column, number * 10 + 2)
    ["3", ..column] -> parse_column(column, number * 10 + 3)
    ["4", ..column] -> parse_column(column, number * 10 + 4)
    ["5", ..column] -> parse_column(column, number * 10 + 5)
    ["6", ..column] -> parse_column(column, number * 10 + 6)
    ["7", ..column] -> parse_column(column, number * 10 + 7)
    ["8", ..column] -> parse_column(column, number * 10 + 8)
    ["9", ..column] -> parse_column(column, number * 10 + 9)

    _ -> panic as string.inspect(column)
  }
}
