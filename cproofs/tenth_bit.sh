#!/bin/bash
set -ex

cbmc --trace --function tenth_bit_check  tenth_bit.cc

echo OK
