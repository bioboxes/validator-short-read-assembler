url = 'https://www.dropbox.com/s/uxgn6cqngctqv74/reads.fq.gz?dl=1'

bootstrap: .image

ssh: .image
	docker run \
		--privileged \
		--interactive \
		--tty \
		validator \
		bash

mount/input/reads.fq.gz:
	mkdir -p $(dir $@)
	wget $(url) --quiet --output-document $@

.image: Dockerfile $(shell find mount) mount/input/reads.fq.gz
	docker build -t validator .
	touch $@
