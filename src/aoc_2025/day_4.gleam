import gleam/list
import gleam/set.{type Set}

pub fn pt_1(input: String) {
  let grid = parse_grid(input, set.new(), 0, 0)
  set.fold(grid, 0, fn(count, coordinate) {
    let #(x, y) = coordinate
    case can_be_picked_up(grid, x, y) {
      True -> count + 1
      False -> count
    }
  })
}

fn can_be_picked_up(grid: Set(#(Int, Int)), x: Int, y: Int) -> Bool {
  list.count(
    [
      #(x + 1, y + 1),
      #(x + 1, y),
      #(x + 1, y - 1),
      #(x - 1, y + 1),
      #(x - 1, y),
      #(x - 1, y - 1),
      #(x, y + 1),
      #(x, y - 1),
    ],
    set.contains(grid, _),
  )
  < 4
}

fn parse_grid(
  input: String,
  grid: Set(#(Int, Int)),
  x: Int,
  y: Int,
) -> Set(#(Int, Int)) {
  case input {
    "" -> grid
    "." <> input -> parse_grid(input, grid, x + 1, y)
    "@" <> input -> parse_grid(input, set.insert(grid, #(x, y)), x + 1, y)
    "\n" <> input -> parse_grid(input, grid, 0, y + 1)
    _ -> panic
  }
}

pub fn pt_2(input: String) {
  let grid = parse_grid(input, set.new(), 0, 0)
  remove_all(grid, 0)
}

fn remove_all(grid: Set(#(Int, Int)), total_removed: Int) -> Int {
  let #(grid, count) =
    set.fold(grid, #(grid, 0), fn(acc, coordinate) {
      let #(grid, count) = acc
      let #(x, y) = coordinate
      case can_be_picked_up(grid, x, y) {
        True -> #(set.delete(grid, coordinate), count + 1)
        False -> acc
      }
    })

  case count {
    0 -> total_removed
    _ -> remove_all(grid, total_removed + count)
  }
}
