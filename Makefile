reads = 'https://www.dropbox.com/s/uxgn6cqngctqv74/reads.fq.gz?dl=1'

all: build/reads.fq.gz

build/reads.fq.gz:
	wget $(reads) --quiet --output-document $@

build: $(shell find src)
	cp -R src $@
	touch $@
