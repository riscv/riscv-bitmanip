#!/bin/bash
set -ex
pandoc --verbose -f markdown -t latex bext.md -o xbitmap.pdf
