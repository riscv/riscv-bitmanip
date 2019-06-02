#!/bin/bash
set -ex

cbmc --trace --function check_rv32_basic    rvintrin.cc
cbmc --trace --function check_rv64_basic    rvintrin.cc
cbmc --trace --function check_rv32_single   rvintrin.cc
cbmc --trace --function check_rv64_single   rvintrin.cc
cbmc --trace --function check_rv32_shift    rvintrin.cc
cbmc --trace --function check_rv64_shift    rvintrin.cc
cbmc --trace --function check_rv32_funnel   rvintrin.cc
cbmc --trace --function check_rv64_funnel   rvintrin.cc
cbmc --trace --function check_rv_ternary    rvintrin.cc
cbmc --trace --function check_rv64_bitmat   rvintrin.cc

gcc -Wall -o rvintrin rvintrin.cc
./rvintrin
rm -f rvintrin

echo OK
