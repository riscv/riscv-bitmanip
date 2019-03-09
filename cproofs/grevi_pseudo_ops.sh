#!/bin/bash
set -ex

cbmc --trace --function rv32_brev     grevi_pseudo_ops.cc
cbmc --trace --function rv32_brev_h   grevi_pseudo_ops.cc
cbmc --trace --function rv32_brev_b   grevi_pseudo_ops.cc
cbmc --trace --function rv32_bswap    grevi_pseudo_ops.cc
cbmc --trace --function rv32_bswap_h  grevi_pseudo_ops.cc
cbmc --trace --function rv32_hswap    grevi_pseudo_ops.cc

cbmc --trace --function rv64_brev     grevi_pseudo_ops.cc
cbmc --trace --function rv64_brev_w   grevi_pseudo_ops.cc
cbmc --trace --function rv64_brev_h   grevi_pseudo_ops.cc
cbmc --trace --function rv64_brev_b   grevi_pseudo_ops.cc
cbmc --trace --function rv64_bswap    grevi_pseudo_ops.cc
cbmc --trace --function rv64_bswap_h  grevi_pseudo_ops.cc
cbmc --trace --function rv64_bswap_w  grevi_pseudo_ops.cc
cbmc --trace --function rv64_hswap    grevi_pseudo_ops.cc
cbmc --trace --function rv64_hswap_w  grevi_pseudo_ops.cc
cbmc --trace --function rv64_wswap    grevi_pseudo_ops.cc

echo OK
