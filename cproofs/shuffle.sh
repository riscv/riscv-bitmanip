#!/bin/bash
set -ex

cbmc --trace --function omega_flip_invcheck  shuffle.cc
# cbmc --trace --function flip_alt_check     shuffle.cc

echo OK
