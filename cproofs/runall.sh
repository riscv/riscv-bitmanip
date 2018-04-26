#!/bin/bash
set -ex
bash bextdep.sh
bash bmi_emulate.sh
bash grevi_pseudo_ops.sh
bash prefix_sum.sh
bash rv_imm_decode.sh
bash tenth_bit.sh
bash zip_unzip.sh
echo ALL_TESTS_PASSED
