test:
	IMAGE=$(image) TASK=default ./build/validate

image = validator-test-image

##############################
#
# Build the distributable
#
##############################

dist/short-read-validator.tar.gz: build/reads.fq.gz build/schema/output.yaml build/schema/input.yaml
	mkdir -p $(dir $@)
	tar -czf $@ $(dir $<)

build/schema/output.yaml: build
	wget $(output) --quiet --output-document $@

build/schema/input.yaml: build
	wget $(input) --quiet --output-document $@

build/reads.fq.gz: build
	wget $(reads) --quiet --output-document - |\
		xz --decompress |\
		gzip > $@

build: $(shell find src)
	cp -R src $@
	mkdir -p $@/schema
	touch $@

##############################
#
# Bootstrap initial resources
#
##############################

bootstrap: image

image:
	git clone git@github.com:bioboxes/velvet.git $@
	docker build --tag $(image) $@

clean:
	rm -rf build dist

##############################
#
# Urls
#
##############################

reads  = 'https://www.dropbox.com/s/uxgn6cqngctqv74/reads.fq.gz?dl=1'
input  = 'https://raw.githubusercontent.com/bioboxes/rfc/master/container/short-read-assembler/input_schema.yaml'
output = 'https://raw.githubusercontent.com/bioboxes/validator-short-read-assembler/aa0ac0ca2bbb274a83693f7dfb2bd66668d40abe/mount/schema/output.yaml'
