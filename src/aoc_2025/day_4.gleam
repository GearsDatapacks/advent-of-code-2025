import gleam/bool
import gleam/dict.{type Dict}
import gleam/list

pub fn pt_1(input: String) {
  let grid = parse_grid(input, dict.new(), 0, 0)
  dict.fold(grid, 0, fn(count, coordinate, space) {
    use <- bool.guard(space == Empty, count)
    let #(x, y) = coordinate
    case can_be_picked_up(grid, x, y) {
      True -> count + 1
      False -> count
    }
  })
}

fn can_be_picked_up(grid: Dict(#(Int, Int), Space), x: Int, y: Int) -> Bool {
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
    fn(pair) { dict.get(grid, pair) == Ok(Occupied) },
  )
  < 4
}

type Space {
  Occupied
  Empty
}

fn parse_grid(
  input: String,
  grid: Dict(#(Int, Int), Space),
  x: Int,
  y: Int,
) -> Dict(#(Int, Int), Space) {
  case input {
    "" -> grid
    "." <> input ->
      parse_grid(input, dict.insert(grid, #(x, y), Empty), x + 1, y)
    "@" <> input ->
      parse_grid(input, dict.insert(grid, #(x, y), Occupied), x + 1, y)
    "\n" <> input -> parse_grid(input, grid, 0, y + 1)
    _ -> panic
  }
}

pub fn pt_2(input: String) {
  let grid = parse_grid(input, dict.new(), 0, 0)
  remove_all(grid, 0)
}

fn remove_all(grid: Dict(#(Int, Int), Space), total_removed: Int) -> Int {
  let #(grid, count) =
    dict.fold(grid, #(grid, 0), fn(acc, coordinate, space) {
      use <- bool.guard(space == Empty, acc)
      let #(grid, count) = acc
      let #(x, y) = coordinate
      case can_be_picked_up(grid, x, y) {
        True -> #(dict.delete(grid, coordinate), count + 1)
        False -> acc
      }
    })

  case count {
    0 -> total_removed
    _ -> remove_all(grid, total_removed + count)
  }
}
