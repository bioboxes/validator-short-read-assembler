url = 'https://www.dropbox.com/s/uxgn6cqngctqv74/reads.fq.gz?dl=1'

bootstrap: input/reads.fq.gz

input/reads.fq.gz:
	mkdir -p $(dir $@)
	wget $(url) --quiet --output-document $@
