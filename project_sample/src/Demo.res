let sum = (x, y) => x + y

@inline_test
Zora.zora("sum", t => {
  open Zora
  t->equal(sum(1, 2), 3, "simple test: 1 + 2 = 3")
  done()
})
