Feature: Ensuring a short read assembler matches the bioboxes specification

  Scenario: Assembling a set of short reads
    When I run the bash command:
    """
    docker run \
      --env="CONT_FASTQ_FILE_LISTING=/input/listing.txt" \
      --env="CONT_CONTIGS_FILE=/output/contigs.fa" \
      --volume="/root/input:/input:ro" \
      --volume="$(pwd)/output:/output:rw" \
      ${IMAGE} ${TASK}
    """
    Then the exit status should be 0
     And a file named "output/contigs.fa" should exist
     And the file "output/contigs.fa" should match /^>.*\n[ATGCatgcNn\n]+/
