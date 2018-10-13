#!/bin/bash
set -ex

cbmc --trace --function clmul_gray1    misc.cc
cbmc --trace --function clmul_gray2    misc.cc
# cbmc --trace --function clmul_gray3  misc.cc
# cbmc --trace --function clmul_fanout misc.cc

gcc -Wall -o misc misc.cc
./misc
rm -f misc

echo OK
