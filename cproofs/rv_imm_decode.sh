#!/bin/bash
set -ex

cbmc --trace --function check_s_imm        rv_imm_decode.cc
cbmc --trace --function check_b_imm        rv_imm_decode.cc
cbmc --trace --function check_j_imm        rv_imm_decode.cc
cbmc --trace --function check_j_imm2       rv_imm_decode.cc
cbmc --trace --function check_cj_imm       rv_imm_decode.cc
cbmc --trace --function check_cj_imm2      rv_imm_decode.cc

echo OK
