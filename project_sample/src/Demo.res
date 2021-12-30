let add = (x, y) => x + y + 1

let foo = 3

Js.log(foo)

Js.log(add(1, 2))

@inline_test
Test.test("add", () => {
  open Test
  let intEqual = (~message=?, a: int, b: int) =>
    assertion(~message?, ~operator="intEqual", (a, b) => a === b, a, b)
  intEqual(~message="1 + 2 + 1 = 4", add(1, 2), 4)
})
