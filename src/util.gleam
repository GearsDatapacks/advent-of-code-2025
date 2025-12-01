pub fn unwrap(x: Result(a, b)) -> a {
  let assert Ok(x) = x
  x
}
