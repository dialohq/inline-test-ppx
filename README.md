# inline-test-ppx

[![Actions Status](https://github.com/dialohq/inline-test-ppx/workflows/CI/badge.svg)](https://github.com/dialohq/inline-test-ppx/actions)
[![NPM Version](https://badge.fury.io/js/%40dialo%2Finline-test-ppx.svg)](https://badge.fury.io/js/%40dialo%2Finline-test-ppx)

A PPX to write inline tests in ReScript.

```rescript
// Math.res
let sum = (a, b) => {
  a + b
}

@inline_test
test("adds 1 + 2 to equal 3", () => {
  expect(sum(1, 2)).toBe(3);
});
```

The test will be erased in compilation phase for production builds.

## Installation

We provide an NPM package with prebuilt binaries.

```bash
yarn add @dialo/inline-test-ppx
# Or
npm install --save @dialo/inline-test-ppx
```

And add the PPX in your `bsconfig.json` file:

```json
{
  "ppx-flags": [
    "ppx-flags": ["inline-test-ppx"]
  ]
}
```

## Usage

1. Install the testing framework of your choice (like [jest](https://github.com/glennsl/rescript-jest), [zora](https://github.com/dusty-phillips/rescript-zora), [rescript-test](https://github.com/bloodyowl/rescript-test) or other)
2. Write some inline tests:

   ```rescript
   // Math.res
   let sum = (a, b) => {
     a + b
   }

   @inline_test
   Jest.test("adds 1 + 2 to equal 3", () => {
     expect(sum(1, 2)).toBe(3);
   });
   ```

   > Note: our PPX assumes that the testing framework is designed similarly to jest or zora. I.e. that tests are simply defined as top level expressions in arbitrary files. At the time of writing this readme we are not aware of testing frameworks for rescript that are designed differently.

3. Make test runner aware of the tests. All tests are indirectly accessible through `lib/bs/__inline_test.*`:

   ### Jest

   In your jest config

   ```
   testMatch: [
     "lib/bs/__inline_test.*.cjs", // use .mjs if you have es6 output configured in bsconfig
     // other test locations ...
   ]
   ```

   ### Zora (with pta):

   ```
   // scripts in package.json
   "test": "NODE_ENV=test pta 'lib/bs/__inline_test.*.cjs'" // add other locations as you see fit
   ```

   Please note that in order for tests to be run, `NODE_ENV` has to be set to `test`, which is done by default by Jest but not by some other frameworks.

   ### Others

   Other frameworks usually have similar configurations which allow you to point to the location of JavaScript files containing case. In the case of our ppx all tests are referenced by artifacts located in `lib/bs/` prefixed with `__inline_test`.

4. Compile your sources with `INLINE_TEST=1` to compile the tests
   ```
   // scripts in package.json
   "watch": "INLINE_TEST=1 rescript build  -with-deps -w"
   ```
   #### Caveat
   Beaware that now all of the modules which contain inline tests will have inline tests present in `.js` artifacts. If you run:
   ```
   INLINE_TEST=0 yarn rescript build
   ```
   your modules **will not** be recompiled. In order to get rid of the testing code in js files clean the project first using:
   ```
   yarn rescript clean
   ```
   and then recompile them with the `INLINE_TEST` environment variable simply undefined or defined as `0` or `false`.

## How it works

The PPX compiles any top level expression in a module conditionally based on the existence of `INLINE_TEST` env variable in the build environment. It means that:

```
@inline_test
Js.Console.log("hello")
```

will be only compiled by rescript if the variable is present. Otherwise it's simply ommited and not present in the resulting `.js` file.

## Contributing

Take a look at our [Contributing Guide](CONTRIBUTING.md).
