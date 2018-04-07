#!/bin/bash
set -ex
pandoc --verbose -f markdown -t latex bext.md -o bext.tex
sed -i '/tightlist/ s/^/% /;' bext.tex
# pdflatex xbitmap
# bibtex xbitmap
pdflatex xbitmap
pdflatex xbitmap
