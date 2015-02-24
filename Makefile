bootstrap: .image

.image: Dockerfile $(shell ls mount/*)
	docker build -t validator .
	touch $@
