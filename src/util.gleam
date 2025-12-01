import gleam/int

pub fn unwrap(x: Result(a, b)) -> a {
  let assert Ok(x) = x
  x
}

pub fn parse(x: String) -> Int {
  unwrap(int.parse(x))
}
