## Short Read Assembler Validator

This repository containers the code for building a Docker image that may be
used to validate bioboxes short read assembler images. Documentation of how the
validator is used can be found in the `doc` folder. This README describes how
to develop and build the image.

### Development

  * `./script/bootstrap`: Fetches an example Docker image used for testing
    validation.

  * `./script/build`: Builds or rebuilds the image if the Dockerfile or the
    mount directory has changed.

  * `./script/test`: Runs the validator against the reference Docker image. All
    tests should pass indicating both the validator and reference image work as
    expected.


