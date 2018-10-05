#!/bin/bash
set -ex

gcc -Wall -o clmul clmul.cc
./clmul
rm -f clmul

echo OK
