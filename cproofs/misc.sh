#!/bin/bash
set -ex

cbmc --trace --function clmul_gray     misc.cc
# cbmc --trace --function clmul_fanout misc.cc

gcc -Wall -o misc misc.cc
./misc
rm -f misc

echo OK
