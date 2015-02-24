Feature: Ensuring a short read assembler matches the specification

  Scenario: Assembling a set of short reads
    When I run the bash command:
    """
    docker run \
      --env="TASK=default" \
      --env="CONT_FASTQ_FILE_LISTING=/input/listing.txt" \
      --env="CONT_CONTIGS_FILE=/output/contigs.fa" \
      --volume="$(pwd)/input:/input:ro" \
      --volume="$(pwd)/output:/output:rw" \
      ${IMAGE}
    """
    Then the stderr should not contain anything
     And the exit status should be 0
