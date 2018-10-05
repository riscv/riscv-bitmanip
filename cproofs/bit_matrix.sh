#!/bin/bash
set -ex

cbmc --trace --function identity_check   bit_matrix.cc
cbmc --trace --function bswap_check      bit_matrix.cc
cbmc --trace --function brevb_check      bit_matrix.cc

echo OK
