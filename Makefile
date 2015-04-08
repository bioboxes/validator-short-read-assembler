ci_test: Gemfile.lock
	IMAGE=velvet TASK=default bundle exec cucumber

Gemfile.lock: Gemfile
	bundle install

Gemfile:
	mkdir -p $(dir $@)
	docker export $(shell docker run --detach --entrypoint ls validator) \
		| tar xvf - \
		  --exclude='root/.gem' \
		  --exclude='root/Gemfile.lock' \
		  --exclude='root/Makefile' \
		  --strip-components 1 \
		  root

test: .image velvet
	docker run \
		--privileged \
		--rm \
		--env IMAGE=velvet \
		--env TASK=default \
		--volume $(shell pwd)/velvet:/build \
		validator

ssh: .image
	docker run \
		--privileged \
		--interactive \
		--tty \
		--rm \
		validator \
		bash

build:     .image
bootstrap: velvet .base

.image: Dockerfile $(shell find mount)
	docker build -t validator .
	touch $@

.base: Dockerfile
	docker pull $(shell head -n 1 $^ | cut -f 2 -d ' ')
	touch $@

velvet:
	git clone git@github.com:bioboxes/velvet.git $@
	docker build -t velvet $@

.PHONY: test ssh bootstrap
