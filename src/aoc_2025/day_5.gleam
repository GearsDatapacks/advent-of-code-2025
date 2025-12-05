import gleam/list
import gleam/string
import util

pub fn pt_1(input: String) {
  let assert Ok(#(fresh, all)) = string.split_once(input, "\n\n")
  let fresh =
    fresh
    |> string.split("\n")
    |> list.map(fn(line) {
      let assert Ok(#(start, end)) = string.split_once(line, "-")
      #(util.parse(start), util.parse(end))
    })

  let all =
    all
    |> string.split("\n")
    |> list.map(util.parse)

  list.count(all, fn(ingredient) {
    list.any(fresh, fn(range) { ingredient >= range.0 && ingredient <= range.1 })
  })
}

pub fn pt_2(input: String) {
  let assert Ok(#(fresh, _)) = string.split_once(input, "\n\n")
  let fresh =
    fresh
    |> string.split("\n")
    |> list.map(fn(line) {
      let assert Ok(#(start, end)) = string.split_once(line, "-")
      #(util.parse(start), util.parse(end))
    })

  count_all_fresh(fresh, 0, [])
}

fn count_all_fresh(
  fresh: List(#(Int, Int)),
  count: Int,
  counted: List(#(Int, Int)),
) -> Int {
  case fresh {
    [] -> count
    [#(start, end) as range, ..fresh] -> {
      let n = end - start + 1
      let overlap = count_overlap(start, end, counted, 0)
      count_all_fresh(fresh, count + n - overlap, [range, ..counted])
    }
  }
}

fn count_overlap(
  start: Int,
  end: Int,
  counted: List(#(Int, Int)),
  overlap: Int,
) -> Int {
  case counted {
    [] -> overlap
    [#(s, e), ..rest] if s >= start && e <= end ->
      overlap
      + e
      - s
      + 1
      + count_overlap(start, s - 1, rest, 0)
      + count_overlap(e + 1, end, rest, 0)
    [#(s, e), ..] if s <= start && e >= end -> end - start + 1 + overlap
    [#(_, e), ..rest] if e >= start && e <= end ->
      count_overlap(e + 1, end, rest, overlap + e - start + 1)
    [#(s, _), ..rest] if s >= start && s <= end ->
      count_overlap(start, s - 1, rest, overlap + end - s + 1)
    [_, ..rest] -> count_overlap(start, end, rest, overlap)
  }
}
