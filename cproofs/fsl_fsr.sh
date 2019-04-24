#!/bin/bash
set -ex

cbmc --trace --function test_fsl     fsl_fsr.cc
cbmc --trace --function test_fsr     fsl_fsr.cc

cbmc --trace --function fsl_via_fsr  fsl_fsr.cc
cbmc --trace --function fsl_imm      fsl_fsr.cc

cbmc --trace --function shift32_ids  fsl_fsr.cc
cbmc --trace --function shift64_ids  fsl_fsr.cc
cbmc --trace --function shift64w_ids fsl_fsr.cc

echo OK
