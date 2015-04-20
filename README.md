## Short Read Assembler Validator

This repository containers the code to build the short read assembler validator
package. The created package contains the [cucumber][] feature tests used to
test the inputs and outputs of a biobox assembler. Documentation of how the
validator is used can be found in the `doc` folder. This README.md describes
how to develop and build the package.

### Building

The cucumber features, a ruby dependency Gemfile, and a wrapper script are in
the `src` directory. When the package is built these are copied to the `build`
folder. Biobox schema files and test data are then downloaded into the `build`
folder. Finally a `.tar.gz` is created from this package.

### Development

  * `./script/bootstrap`: Fetches an example Docker image used for testing
    validation.

  * `./script/build`: Builds the package using the `src` dir, and downloading
    required schema and data files.

  * `./script/test`: Runs the validator against the reference Docker image. All
    tests should pass indicating both the validator and reference image work as
    expected.

[cucumber]: https://cukes.info/
