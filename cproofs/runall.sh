#!/bin/bash
set -ex
bash bextdep.sh
bash bmi_emulate.sh
bash examples.sh
bash grevi_pseudo_ops.sh
bash rv_imm_decode.sh
bash zip_unzip.sh
bash bit_matrix.sh
echo ALL_TESTS_PASSED
