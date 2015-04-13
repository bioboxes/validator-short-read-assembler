# Bioboxes Assembler Validator

This validator tool is provided to help developers ensure that their short read
assembler biobox matches the specification. You can run the validator image to
test your biobox images, and the output should help you identify any mismatches
with the specification.

## Example usage

~~~ bash 
# Fetch an example assembler biobox for testing
git clone git@github.com:bioboxes/velvet.git

docker run \
  --privileged \
  --rm \
  --env IMAGE=velvet \
  --env TASK=default \
  --volume $(pwd)/velvet:/build \
  bioboxes/validator-short-read-assembler
~~~

This example illustrates using the assembler validator to test the `default`
task of the `bioboxes/velvet` image we cloned. The name of the assembler image
and the task to test are specified through environment variables using `--env`.
The directory containing the assembler is mounted in `build` using `--volume`.
This directory is where the validator expects the your biobox Dockerfile to be. 

As the validator is also a Docker image you do not need to provide anything
else. All the commands and data are needed to test the image are included in
inside the validator container.

## How the validator works

The validator builds your biobox image from the directory you mount onto
`/build`. This is possible because the validator contains a docker daemon
within itself. As long as your image builds successfully, the validator then
runs a series of scenarios simulating different user behaviour. The validator
then ensures the container gives the expected response to each. These scenarios
[include missing FASTQ files, bad input data, and all the correct data to
produce an assembly][scenarios].

[scenarios]: https://github.com/bioboxes/validator-short-read-assembler/blob/master/mount/features/assembler.feature

## Privileged flag

The validator container requires the use of the `--privileged` flag. The reason
is because a Docker daemon is required inside the validator to start an
instance of your biobox for testing. This is unfortunately a security issue as
[the --privileged flag gives extended access to devices][priv]. Please bear
this in mind when using the validator.

[priv]: http://blog.docker.com/2013/09/docker-can-now-run-within-docker/
