image = validator-test-image
dist  = dist/short-read-validator.tar.gz
build = validate-short-read-assembler

.PHONY: build test bootstrap

files   = reads.fq.gz schema/output.yaml schema/input.yaml README.md
objects = $(addprefix $(build)/,$(files))

##############################
#
# Test and push the package
#
##############################

all: test

publish: ./plumbing/push-to-s3 VERSION $(dist)
	bundle exec $^

test: $(dist)
	mkdir -p $@
	tar -xzf $< -C $@ --strip-components 1
	./$@/validate $(image) default

$(dist): $(objects)
	mkdir -p $(dir $@)
	tar -czf $@ --exclude '$(build)/tmp' --exclude 'Gemfile.lock' $(dir $<)

##############################
#
# Build the distributable
#
##############################

build: $(objects)

$(build)/README.md: doc/short-read-assembler-validator.md
	cp $< $@

$(build)/schema/output.yaml: $(build)
	wget $(output) --quiet --output-document $@

$(build)/schema/input.yaml: $(build)
	wget $(input) --quiet --output-document $@

$(build)/reads.fq.gz: $(build)
	wget $(reads) --quiet --output-document $@

$(build): $(shell find src)
	cp -R src $@
	mkdir -p $@/schema
	touch $@

##############################
#
# Bootstrap initial resources
#
##############################

bootstrap: image Gemfile.lock

Gemfile.lock: Gemfile
	bundle install --path vendor/bundle

image:
	git clone git@github.com:bioboxes/velvet.git $@
	./plumbing/cache_docker $@ $(image)

clean:
	rm -rf $(build) dist

##############################
#
# Urls
#
##############################

reads  = 'https://www.dropbox.com/s/uxgn6cqngctqv74/reads.fq.gz?dl=1'
input  = 'https://raw.githubusercontent.com/bioboxes/rfc/master/container/short-read-assembler/input_schema.yaml'
output = 'https://raw.githubusercontent.com/bioboxes/validator-short-read-assembler/aa0ac0ca2bbb274a83693f7dfb2bd66668d40abe/mount/schema/output.yaml'
