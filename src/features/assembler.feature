Feature: Ensuring a short read assembler matches the bioboxes specification

  Scenario: An empty biobox.yaml file
    Given an empty file named "input/biobox.yaml"
    When I run the bash command:
      """
      docker run \
        --volume="$(pwd)/input:/bbx/input" \
        ${IMAGE} \
        ${TASK}
      """
    Then the exit status should be 1
     And the stderr should contain:
      """
      None is not of type 'object'\n
      """

  Scenario: A garbled biobox.yaml file.
    Given a file named "input/biobox.yaml" with:
      """
      'nonsense"/4*
      """
    When I run the bash command:
      """
      docker run \
        --volume="$(pwd)/input:/bbx/input" \
        ${IMAGE} \
        ${TASK}
      """
    Then the exit status should be 1
     And the stderr should contain:
      """
      Error parsing the YAML file: /bbx/input/biobox.yaml\n
      """

  Scenario: An biobox.yaml missing the version number.
    Given a file named "input/biobox.yaml" with:
      """
      arguments:
        - fastq:
          - id: "pe"
            value: "/reads.fastq.gz"
            type: paired
      """
    When I run the bash command:
      """
      docker run --volume="$(pwd)/input:/bbx/input" ${IMAGE} ${TASK}
      """
    Then the exit status should be 1
     And the stderr should contain:
      """
      'version' is a required property\n
      """

  Scenario: An biobox.yaml with a missing patch version number.
    Given a file named "input/biobox.yaml" with:
      """
      version: "0.9"
      arguments:
        - fastq:
          - id: "pe"
            value: "/reads.fastq.gz"
            type: paired
      """
    When I run the bash command:
      """
      docker run \
        --env="TASK=default" \
        --volume="$(pwd)/input:/bbx/input:ro" \
        ${IMAGE} \
        ${TASK}
      """
    Then the exit status should be 1
     And the stderr should contain:
      """
      '0.9' does not match '^0.9.\\d+$'\n
      """

  Scenario: An biobox.yaml with a wrong version number.
    Given a file named "input/biobox.yaml" with:
      """
      version: "0.8.0"
      arguments:
        - fastq:
          - id: "pe"
            value: "/reads.fastq.gz"
            type: paired
     """
    When I run the bash command:
      """
      docker run \
        --env="TASK=default" \
        --volume="$(pwd)/input:/bbx/input:ro" \
        ${IMAGE} ${TASK}
      """
    Then the exit status should be 1
     And the stderr should contain:
      """
      '0.8.0' does not match '^0.9.\\d+$'\n
      """

  Scenario: An biobox.yaml with a missing arguments field.
    Given a file named "input/biobox.yaml" with:
      """
      version: "0.9.0"
      """
    When I run the bash command:
      """
      docker run \
        --env="TASK=default" \
        --volume="$(pwd)/input:/bbx/input" \
        ${IMAGE} ${TASK}
      """
    Then the exit status should be 1
     And the stderr should contain:
      """
      'arguments' is a required property\n
      """

  Scenario: An biobox.yaml with an additional unknown field
    Given a file named "input/biobox.yaml" with:
      """
      version: "0.9.0"
      arguments:
        - fastq:
          - id: "pe"
            value: "/reads.fastq.gz"
            type: paired
      unknown: {}
      """
    When I run the bash command:
      """
      docker run \
        --env="TASK=default" \
        --volume="$(pwd)/input:/bbx/input:ro" \
        ${IMAGE} ${TASK}
      """
    Then the exit status should be 1
     And the stderr should contain:
      """
      Additional properties are not allowed ('unknown' was unexpected)\n
      """

  Scenario: Run assembler with basic input
    Given a directory named "output"
      And a directory named "input"
      And I successfully run `cp ../../reads.fq.gz input`
      And a file named "input/biobox.yaml" with:
      """
      ---
      version: 0.9.0
      arguments:
        - fastq:
          - id: "pe"
            value: "/bbx/input/reads.fq.gz"
            type: single
        - fragment_size:
          - id: "pe"
            value: 123
      """
    When I run the bash command:
      """
      docker run \
        --volume="$(pwd)/input:/bbx/input:ro" \
        --volume="$(pwd)/output:/bbx/output:rw" \
        ${IMAGE} ${TASK}
      """
    Then the exit status should be 0
     And a file named "output/bbx/biobox.yaml" should exist
