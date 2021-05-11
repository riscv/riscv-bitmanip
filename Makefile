DATE=$(shell date  +%Y%m%d)
VERSION=$(shell git describe --tag --always --dirty)

bitmanip-$(VERSION).pdf: bitmanip/bitmanip.adoc \
			 bitmanip/*.adoc \
			 bitmanip/insns/*.adoc
	asciidoctor-pdf -r asciidoctor-diagram \
			-D . \
			-a toc \
			-a pdf-style=resources/themes/risc-v_spec-pdf.yml \
			-a pdf-fontsdir=resources/fonts \
			-o $@ \
			$<

clean:
	rm -f bitmanip-*.pdf
