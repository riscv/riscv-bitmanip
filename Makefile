DATE=$(shell date  +%Y%m%d)
VERSION=$(shell git describe --tag --always --dirty)

bitmanip-$(VERSION).pdf: bitmanip/bitmanip.adoc \
			 bitmanip/*.adoc \
			 bitmanip/insns/*.adoc \
			 bitmanip/autogenerated/revision.adoc-snippet
	asciidoctor-pdf -r asciidoctor-diagram \
			-D . \
			-a toc \
			-a compress \
			-a pdf-style=resources/themes/risc-v_spec-pdf.yml \
			-a pdf-fontsdir=resources/fonts \
			-o $@ \
			$<
	asciidoctor-pdf-optimize --quality printer $@

DATE=$(shell date  +%Y.%m.%d)
VERSION=$(shell git describe --tag --always --dirty)
COMMITDATE=$(shell git show -s --format=%ci | cut -d ' ' -f 1)

bitmanip/autogenerated:
	-mkdir $@

STAGE ?= "Release candidate"

bitmanip/autogenerated/revision.adoc-snippet: Makefile bitmanip/autogenerated FORCE
	echo ":revdate: ${COMMITDATE}" > $@
	echo ":revnumber: ${VERSION}" >> $@
	echo ":revremark: ${STAGE}" >> $@

clean:
	rm -f bitmanip-*.pdf

FORCE: 

