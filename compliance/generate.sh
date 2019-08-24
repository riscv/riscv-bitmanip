#!/bin/bash
set -ev
rm -rf rv{32,64}b/{references,src}
mkdir -p rv{32,64}b/{references,src}
g++ -Wall -Os -D RV32 -o generate32 generate.cc
g++ -Wall -Os -D RV64 -o generate64 generate.cc
./generate32 < vectors32.txt
./generate64 < vectors64.txt
