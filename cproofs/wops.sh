#!/bin/bash
set -ex

cbmc --trace --function check_clzw    wops.cc
cbmc --trace --function check_ctzw    wops.cc
cbmc --trace --function check_pcntw   wops.cc
cbmc --trace --function check_rolw    wops.cc
cbmc --trace --function check_rorw    wops.cc
cbmc --trace --function check_packw   wops.cc
cbmc --trace --function check_packuw  wops.cc

cbmc --trace --function check_grevw   wops.cc
cbmc --trace --function check_gorcw   wops.cc
cbmc --trace --function check_shflw   wops.cc
cbmc --trace --function check_unshflw wops.cc

cbmc --trace --function check_sbsetw  wops.cc
cbmc --trace --function check_sbclrw  wops.cc
cbmc --trace --function check_sbinvw  wops.cc
cbmc --trace --function check_sbextw  wops.cc

#cbmc --trace --function check_bextw   wops.cc
#cbmc --trace --function check_bdepw   wops.cc
#cbmc --trace --function check_bfpw    wops.cc

#cbmc --trace --function check_clmulw  wops.cc
#cbmc --trace --function check_clmulhw wops.cc
#cbmc --trace --function check_clmulrw wops.cc

cbmc --trace --function check_fslw    wops.cc
cbmc --trace --function check_fsrw    wops.cc

gcc -Wall -o wops wops.cc
./wops
rm -f wops
