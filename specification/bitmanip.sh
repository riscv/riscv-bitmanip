#!/bin/bash
set -ex

if [ ! -f bextcref-printperm.dat ] || [ bextcref-printperm -ot ../cproofs/common.h ] || [ bextcref-printperm -ot ../cproofs/printperm.cc ]; then
	clang++ -Wall -o bextcref-printperm.exe ../cproofs/printperm.cc
	./bextcref-printperm.exe > bextcref-printperm.dat
fi

python3 bextcref.py
for ((i=0; i<${1:-1}; i++)); do
	pdflatex bitmanip
	bibtex bitmanip
done
