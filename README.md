# inline-test-ppx

[![Actions Status](https://github.com/tsnobip/inline-test-ppx/workflows/CI/badge.svg)](https://github.com/tsnobip/inline-test-ppx/actions)
[![NPM Version](https://badge.fury.io/js/%40tsnobip%2Finline-test-ppx.svg)](https://badge.fury.io/js/%40tsnobip%2Finline-test-ppx)

A PPX to write inline tests in rescript

## Features

- Deploy prebuilt binaries to be consumed from Bucklescript projects

## Installation

### With `opam` on native projects

```bash
opam install inline-test-ppx
```

### With `esy` on native projects

```bash
esy add @opam/inline-test-ppx
```

### With `npm` on Bucklescript projects

The recommended way to use PPX libraries in Bucklescript projects is to use `esy`.

Create an `esy.json` file with the content:

```json
{
  "name": "test_bs",
  "version": "0.0.0",
  "dependencies": {
    "@opam/inline-test-ppx": "*",
    "ocaml": "~4.6.1000"
  }
}
```

And add the PPX in your `bsconfig.json` file:

```json
{
  "ppx-flags": [
    "ppx-flags": ["esy x inline-test-ppx"]
  ]
}
```

However, if using `esy` bothers you, we also provide a NPM package with prebuilt binaries.

```bash
yarn global add @tsnobip/inline-test-ppx
# Or
npm -g install @tsnobip/inline-test-ppx
```

And add the PPX in your `bsconfig.json` file:

```json
{
  "ppx-flags": [
    "ppx-flags": ["@tsnobip/inline-test-ppx"]
  ]
}
```

## Usage

`inline_test_ppx` implements a ppx that transforms the `[%inline_test_ppx]` extension into an expression that adds 5 to the integer passed in parameter.

The code:

```ocaml
[%inline_test_ppx 5]
```

Will transform to something like:

```ocaml
5 + 5
```

## Contributing

Take a look at our [Contributing Guide](CONTRIBUTING.md).
