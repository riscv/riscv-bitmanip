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
cbmc   --trace --function min_max_test   misc.cc
cbmc   --trace --function check_vectadd  misc.cc
cbmc   --trace --function check_avgint   misc.cc
cbmc   --trace --function check_overflow misc.cc
cbmc   --trace --function check_bigadd   misc.cc

gcc -Wall -o misc misc.cc
./misc
rm -f misc

echo OK
