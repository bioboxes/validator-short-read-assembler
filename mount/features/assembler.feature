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
     And the stderr should contain exactly:
      """
      Value None for field '<obj>' is not of type object

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
     And the stderr should contain exactly:
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
     And the stderr should contain exactly:
      """
      Required field 'version' is missing

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
     And the stderr should contain exactly:
      """
      Value '0.9' for field '<obj>.version' does not match regular expression '^0.9.\d+$'

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
     And the stderr should contain exactly:
      """
      Value '0.8.0' for field '<obj>.version' does not match regular expression '^0.9.\d+$'

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
     And the stderr should contain exactly:
      """
      Required field 'arguments' is missing

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
      contains additional property 'unknown' not defined by 'properties' or 'patternProperties'
      """

  Scenario: Run assembler with basic input
    Given a file named "/root/input/biobox.yaml" with:
      """
      ---
      version: 0.9.0
      arguments:
        - fastq:
          - id: "pe"
            value: "/reads.fq.gz"
            type: single
        - fragment_size:
          - id: "pe"
            value: 123
      """
    When I run the bash command:
      """
      docker run \
        --volume="/root/input:/bbx/input:ro" \
        --volume="/root/output:/bbx/output:rw" \
        ${IMAGE} ${TASK}
      """
    Then the exit status should be 0
     And a file named "/root/output/biobox.yaml" should exist.
     And the output from "python /root/bin/output_validator.py -i /root/output/output.yaml -s /root/schema/output.yaml -o /root/output" should contain exactly "valid"

