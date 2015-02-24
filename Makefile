bootstrap: .image

ssh: .image
	docker run \
		--privileged \
		--interactive \
		--tty \
		validator \
		bash

.image: Dockerfile $(shell find mount)
	docker build -t validator .
	touch $@
