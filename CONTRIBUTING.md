# Contributing

## Setup your development environment

You need Esy, you can install the latest version from [npm](https://npmjs.com):

```bash
yarn global add esy@latest
# Or
npm install -g esy@latest
```

Then run the `esy` command from this project root to install and build depenencies.

```bash
esy
```

This project uses [Dune](https://dune.build/) as a build system, if you add a dependency in your `package.json` file, don't forget to add it to your `dune` and `dune-project` files too.

### Running Binary

After building the project, you can run the main binary that is produced.

```bash
esy start
```

### Running Tests

You can run the test compiled executable:

```bash
esy test
```

### Building documentation

Documentation for the libraries in the project can be generated with:

```bash
esy doc
open-cli $(esy doc-path)
```

This assumes you have a command like [open-cli](https://github.com/sindresorhus/open-cli) installed on your system.

> NOTE: On macOS, you can use the system command `open`, for instance `open $(esy doc-path)`

### Repository Structure

The following snippet describes inline-test-ppx's repository structure.

```text
.
├── bin/
|   Source for inline-test-ppx's binary. This links to the library defined in `lib/`.
│
├── lib/
|   Source for inline-test-ppx's library. Contains inline-test-ppx's core functionnalities.
│
├── test/
|   Unit tests and integration tests for inline-test-ppx.
│
├── dune-project
|   Dune file used to mark the root of the project and define project-wide parameters.
|   For the documentation of the syntax, see https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
│
├── LICENSE
│
├── package.json
|   Esy package definition.
|   To know more about creating Esy packages, see https://esy.sh/docs/en/configuration.html.
│
├── README.md
│
└── inline-test-ppx.opam
    Opam package definition.
    To know more about creating and publishing opam packages, see https://opam.ocaml.org/doc/Packaging.html.
```
