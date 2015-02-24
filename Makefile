bootstrap: .image

.image:
	docker build -t validator .
	touch $@
