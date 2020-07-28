#!/bin/bash
set -ex

cbmc --trace --function check_lut1  xperm.cc
cbmc --trace --function check_lut2  xperm.cc
cbmc --trace --function check_lut8  xperm.cc

gcc -Wall -o xperm xperm.cc
./xperm
rm -f xperm

echo OK
