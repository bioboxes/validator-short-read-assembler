url = 'https://www.dropbox.com/s/uxgn6cqngctqv74/reads.fq.gz?dl=1'

test: .image soap
	docker run \
		--privileged \
		--env IMAGE=soap \
		--env TASK=default \
		--volume $(shell pwd)/soap:/build \
		validator

bootstrap: .image soap

ssh: .image
	docker run \
		--privileged \
		--interactive \
		--tty \
		validator \
		bash

soap:
	git clone git@github.com:bioboxes/soap.git $@

mount/input/reads.fq.gz:
	mkdir -p $(dir $@)
	wget $(url) --quiet --output-document $@

mount/input/listing.txt:
	echo "/input/reads.fq.gz" > $@

.image: Dockerfile $(shell find mount) mount/input/reads.fq.gz mount/input/listing.txt
	docker build -t validator .
	touch $@

.PHONY: test ssh bootstrap
