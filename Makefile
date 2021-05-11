DATE=$(shell date  +%Y%m%d)
VERSION=$(shell git describe --tag --always --dirty)

bitmanip-$(VERSION).pdf: riscv-branded/bitmanip/bitmanip.adoc \
				   riscv-branded/bitmanip/*.adoc
	asciidoctor-pdf -r asciidoctor-diagram \
			-D . \
			-a pdf-style=riscv-branded/bitmanip/resources/themes/risc-v_spec-pdf.yml \
			-a pdf-fontsdir=riscv-branded/bitmanip/resources/fonts \
			-o $@ \
			$<

clean:
	rm -f bitmanip-*.pdf
