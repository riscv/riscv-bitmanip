#!/bin/bash
set -ex

cbmc --trace --function prefix_byte_nibbles_check prefix_sum.cc

echo OK
