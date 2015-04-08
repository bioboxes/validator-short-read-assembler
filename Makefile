test: .image velvet
	docker run \
		--privileged \
		--env IMAGE=velvet \
		--env TASK=default \
		--volume $(shell pwd)/velvet:/build \
		validator

ssh: .image
	docker run \
		--privileged \
		--interactive \
		--tty \
		validator \
		bash

bootstrap: velvet
build:     .image

.image: Dockerfile $(shell find mount)
	docker build -t validator .
	touch $@


velvet:
	git clone git@github.com:bioboxes/velvet.git $@

.PHONY: test ssh bootstrap
