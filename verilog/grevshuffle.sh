#!/bin/bash
set -ex
yosys -v3 -l grevshuffle_grev.log -p 'chparam -set ENABLE_ZIP 0 -set ENABLE_SHUFFLE 0 grevshuffle; synth; ' \
	-p 'dfflibmap -liberty cells.lib; abc -liberty cells.lib;; stat -liberty cells.lib;' grevshuffle.v
yosys -v3 -l grevshuffle_nozip.log -p 'chparam -set ENABLE_ZIP 0 -set ENABLE_SHUFFLE 1 grevshuffle; synth; ' \
	-p 'dfflibmap -liberty cells.lib; abc -liberty cells.lib;; stat -liberty cells.lib;' grevshuffle.v
yosys -v3 -l grevshuffle_shuffle.log -p 'chparam -set ENABLE_ZIP 1 -set ENABLE_SHUFFLE 1 grevshuffle; synth; ' \
	-p 'dfflibmap -liberty cells.lib; abc -liberty cells.lib;; stat -liberty cells.lib;' grevshuffle.v

area_grev=$((    $(grep 'Chip area for this module:' grevshuffle_grev.log    | cut -f2- -d: | cut -f1 -d.) / 2))
area_nozip=$((   $(grep 'Chip area for this module:' grevshuffle_nozip.log   | cut -f2- -d: | cut -f1 -d.) / 2))
area_shuffle=$(( $(grep 'Chip area for this module:' grevshuffle_shuffle.log | cut -f2- -d: | cut -f1 -d.) / 2))

set +x
{
	printf 'Area of GREV in multiples of NAND/NOR:    %5d\n' $area_grev
	printf 'Area of NOZIP in multiples of NAND/NOR:   %5d\n' $area_nozip
	printf 'Area of SHUFFLE in multiples of NAND/NOR: %5d\n' $area_shuffle
} | tee grevshuffle.log
