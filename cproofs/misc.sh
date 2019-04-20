#!/bin/bash
set -ex

cbmc   --trace --function clmul_gray1    misc.cc
cbmc   --trace --function clmul_gray2    misc.cc
# cbmc --trace --function clmul_gray3    misc.cc
# cbmc --trace --function clmul_fanout   misc.cc
cbmc   --trace --function crc_equiv_h_bb misc.cc
# cbmc --trace --function crc_equiv_w_hh misc.cc
# cbmc --trace --function crc_equiv_d_ww misc.cc
cbmc   --trace --function pack_test      misc.cc

gcc -Wall -o misc misc.cc
./misc
rm -f misc

echo OK
