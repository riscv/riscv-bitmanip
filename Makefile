
bitmanip.pdf: riscv-branded/bitmanip/bitmanip.adoc \
				   riscv-branded/bitmanip/*.adoc
	asciidoctor-pdf -r asciidoctor-diagram \
			-D . \
			-a pdf-style=riscv-branded/bitmanip/resources/themes/risc-v_spec-pdf.yml \
			-a pdf-fontsdir=riscv-branded/bitmanip/resources/fonts \
			$<

clean:
	rm -f bitmanip.pdf
