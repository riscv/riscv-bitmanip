#!/bin/bash
set -ex
# make -C picorv32
make -C rvb_bextdep
make -C rvb_bitcnt
make -C rvb_bmatxor
make -C rvb_clmul
make -C rvb_crc
make -C rvb_full
make -C rvb_shifter
make -C rvb_simple
make -C rvb_zbb32
echo OKAY
