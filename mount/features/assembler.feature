Feature: Ensuring a short read assembler matches the bioboxes specification


  Scenario: No assembler.yaml file is provided
    When I run the bash command:
    """
	docker run	${IMAGE}
	"""
    Then the exit status should be 1
    And the stderr should contain exactly:
    """
    No input data found at: "/bbx/input/assembler.yaml".
    """