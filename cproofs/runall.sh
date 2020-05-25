#!/bin/bash
set -ex
bash clmul.sh
bash bextdep.sh
bash bmi_emulate.sh
bash examples.sh
bash grevi_pseudo_ops.sh
bash rv_imm_decode.sh
bash zip_unzip.sh
bash bit_matrix.sh
bash misc.sh
bash fsl_fsr.sh
bash xperm.sh
bash rvintrin.sh
echo ALL_TESTS_PASSED
