#!/bin/bash
set -ex

cbmc --trace --function prefix_byte_nibbles_check  examples.cc
cbmc --trace --function index_byte_nibbles_check   examples.cc
cbmc --trace --function tenth_bit_check            examples.cc
cbmc --trace --function zip_fanout                 examples.cc
cbmc --trace --function check_bytes                examples.cc

echo OK
