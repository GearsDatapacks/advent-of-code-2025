import gleam/dict.{type Dict}
import gleam/list
import gleam/option
import gleam/set.{type Set}

pub fn pt_1(input: String) {
  let #(grid, start_position, height) = parse_grid(input, 0, 0, set.new(), 0)

  simulate([start_position], grid, 0, height, 0)
}

fn simulate(
  beams: List(Int),
  grid: Set(#(Int, Int)),
  y: Int,
  height: Int,
  total: Int,
) -> Int {
  let #(beams, total) = simulate_beams(beams, grid, y, total, [])
  case y >= height {
    True -> total
    False -> simulate(list.unique(beams), grid, y + 1, height, total)
  }
}

fn simulate_beams(
  beams: List(Int),
  grid: Set(#(Int, Int)),
  y: Int,
  total: Int,
  out: List(Int),
) -> #(List(Int), Int) {
  case beams {
    [] -> #(out, total)
    [beam, ..beams] ->
      case set.contains(grid, #(beam, y)) {
        False -> simulate_beams(beams, grid, y, total, [beam, ..out])
        True ->
          simulate_beams(beams, grid, y, total + 1, [beam - 1, beam + 1, ..out])
      }
  }
}

fn parse_grid(
  input: String,
  x: Int,
  y: Int,
  grid: Set(#(Int, Int)),
  start_position: Int,
) -> #(Set(#(Int, Int)), Int, Int) {
  case input {
    "" -> #(grid, start_position, y)
    "S" <> input -> parse_grid(input, x + 1, y, grid, x)
    "." <> input -> parse_grid(input, x + 1, y, grid, start_position)
    "^" <> input ->
      parse_grid(input, x + 1, y, set.insert(grid, #(x, y)), start_position)
    "\n" <> input -> parse_grid(input, 0, y + 1, grid, start_position)

    _ -> panic
  }
}

pub fn pt_2(input: String) {
  let #(grid, start_position, height) = parse_grid(input, 0, 0, set.new(), 0)

  simulate2(dict.from_list([#(start_position, 1)]), grid, 0, height)
}

fn simulate2(
  beams: Dict(Int, Int),
  grid: Set(#(Int, Int)),
  y: Int,
  height: Int,
) -> Int {
  let beams =
    dict.fold(beams, dict.new(), fn(beams, beam, count) {
      case set.contains(grid, #(beam, y)) {
        False -> insert_or_add(beams, beam, count)
        True ->
          beams
          |> insert_or_add(beam - 1, count)
          |> insert_or_add(beam + 1, count)
      }
    })
  case y >= height {
    True -> dict.fold(beams, 0, fn(total, _, count) { total + count })
    False -> simulate2(beams, grid, y + 1, height)
  }
}

fn insert_or_add(dict: Dict(a, Int), key: a, count: Int) -> Dict(a, Int) {
  dict.upsert(dict, key, fn(option) {
    case option {
      option.None -> count
      option.Some(c) -> c + count
    }
  })
}
