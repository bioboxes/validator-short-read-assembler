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
   Error parsing: "/bbx/input/assembler.yaml".
   This file is not valid YAML.
   """

  Scenario: An assembler.yaml missing the version number.
    Given a file named "input/assembler.yaml" with:
    """
   arguments: {}
   """
    When I run the bash command:
    """
   docker run --volume="$(pwd)/input:/bbx/input" ${IMAGE} ${TASK}
   """
    Then the exit status should be 1
    And the stderr should contain exactly:
    """
   Error parsing: "/bbx/input/assembler.yaml".
   u'version' is a required property
   """

  Scenario: An assembler.yaml with a missing patch version number.
    Given a file named "input/assembler.yaml" with:
    """
   version: "0.9"
   arguments: {}
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
   Error parsing: "/bbx/input/assembler.yaml".
   '0.9' does not match u'^0.9.\\d+$'
   """

  Scenario: An assembler.yaml with a wrong version number.
    Given a file named "input/assembler.yaml" with:
    """
   version: "0.8.0"
   arguments: {}
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
   Error parsing: "/bbx/input/assembler.yaml".
   '0.8.0' does not match u'^0.9.\\d+$'
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
   Error parsing: "/bbx/input/assembler.yaml".
   u'arguments' is a required property
   """

  Scenario: An assembler.yaml with an additional unknown field
    Given a file named "input/assembler.yaml" with:
    """
   version: "0.9.0"
   arguments: {}
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
    And the stderr should contain exactly:
    """
   Error parsing: "/bbx/input/assembler.yaml".
   Additional properties are not allowed ('unknown' was unexpected)
   """
