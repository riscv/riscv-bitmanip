#!/bin/bash
set -ex
python3 bextcref.py
# pdflatex xbitmanip
# bibtex xbitmanip
pdflatex xbitmanip
pdflatex xbitmanip
