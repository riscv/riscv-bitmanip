#!/bin/bash
set -ex

cbmc --trace --function omega_flip_invcheck  shuffle.cc

echo OK
