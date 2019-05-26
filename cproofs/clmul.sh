#!/bin/bash
set -ex

cbmc --trace --function check_xorshift32_inv clmul.cc
cbmc --trace --function check_xorshift5_inv  clmul.cc
cbmc --trace --function check_gray_inv       clmul.cc

gcc -Wall -o clmul clmul.cc
./clmul
rm -f clmul

echo OK
