url = 'https://www.dropbox.com/s/uxgn6cqngctqv74/reads.fq.gz?dl=1'

bootstrap: .image mount/reads.fq.gz

ssh: .image
	docker run \
		--privileged \
		--interactive \
		--tty \
		validator \
		bash

mount/reads.fq.gz:
	wget $(url) --quiet --output-document $@

.image: Dockerfile $(shell find mount)
	docker build -t validator .
	touch $@
