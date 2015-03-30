Feature: Ensuring a short read assembler matches the bioboxes specification
  
  Scenario: No assembler.yaml file is provided
    When I run the bash command:
    """
	docker run	${IMAGE} ${TASK}
	"""
    Then the exit status should be 1
    And the stderr should contain exactly:
    """
    No input data found at: "/bbx/input/assembler.yaml".
    """

  Scenario: An empty assembler.yaml file
    Given an empty file named "input/assembler.yaml"
    When I run the bash command:
    """
    docker run --volume="$(pwd)/input:/bbx/input" ${IMAGE} ${TASK}
    """
    Then the exit status should be 1
    And the stderr should contain exactly:
    """
    Unable to parse: "/bbx/input/assembler.yaml".
    """

  Scenario: A garbled assembler.yaml file.
    Given a file named "input/assembler.yaml" with:
    """
   'nonsense"/4*
   """
    When I run the bash command:
    """
   docker run \
   --volume="$(pwd)/input:/bbx/input" ${IMAGE} ${TASK}
   """
    Then the exit status should be 1
    And the stderr should contain exactly:
    """
   Error parsing the YAML file: /bbx/input/assembler.yaml\n
   """

  Scenario: An assembler.yaml missing the version number.
    Given a file named "input/assembler.yaml" with:
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

  Scenario: An assembler.yaml with a missing patch version number.
    Given a file named "input/assembler.yaml" with:
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
   ${IMAGE} ${TASK}
   """
    Then the exit status should be 1
    And the stderr should contain exactly:
    """
   Value '0.9' for field '<obj>.version' does not match regular expression '^0.9.\d+$'

   """

  Scenario: An assembler.yaml with a wrong version number.
    Given a file named "input/assembler.yaml" with:
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
  Scenario: An assembler.yaml with a missing arguments field.
    Given a file named "input/assembler.yaml" with:
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

  Scenario: An assembler.yaml with an additional unknown field
    Given a file named "input/assembler.yaml" with:
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
    Given a file named "input/assembler.yaml" with:
    """
   ---
   version: 0.9.0
   arguments:
    - fastq:
      - id: "pe"
        value: "/reads.fastq.gz"
        type: paired
    - fragment_size:
      - id: "pe"
        value: 123
   """
    When I run the bash command:
    """
   docker run --volume="$(pwd)/input:/bbx/input:ro" \
              --volume="/root/output:/bbx/output:rw" \
   ${IMAGE} ${TASK}
   """
    Then a file named "/root/output/bbx/output.yaml" should exist
