#!/bin/bash
set -ex

# cbmc --trace --function twelfth_bit_check  twelfth_bit.cc
gcc -Wall -o twelfth_bit twelfth_bit.cc
./twelfth_bit
rm twelfth_bit

echo OK
