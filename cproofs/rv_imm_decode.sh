#!/bin/bash
set -ex

cbmc --trace --function check_s_imm    rv_imm_decode.cc

echo OK
