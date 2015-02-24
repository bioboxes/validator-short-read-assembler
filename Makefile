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

mount/input/listing.txt:
	echo "/input/reads.fq.gz" > $@

.image: Dockerfile $(shell find mount) mount/input/reads.fq.gz mount/input/listing.txt
	docker build -t validator .
	touch $@
