#!/bin/bash
set -ex

cbmc --function rv32_bmi1_bextr    bmi_emulate.cc
cbmc --function rv32_bmi1_blsi     bmi_emulate.cc
cbmc --function rv32_bmi1_blsmsk   bmi_emulate.cc
cbmc --function rv32_bmi1_blsr     bmi_emulate.cc

cbmc --function rv32_bmi2_bzhi     bmi_emulate.cc

cbmc --function rv32_tbm_bextr     bmi_emulate.cc
cbmc --function rv32_tbm_blcfill   bmi_emulate.cc
cbmc --function rv32_tbm_blci      bmi_emulate.cc
cbmc --function rv32_tbm_blcic     bmi_emulate.cc
cbmc --function rv32_tbm_blcmsk    bmi_emulate.cc
cbmc --function rv32_tbm_blcs      bmi_emulate.cc
cbmc --function rv32_tbm_blsfill   bmi_emulate.cc
cbmc --function rv32_tbm_blsic     bmi_emulate.cc
cbmc --function rv32_tbm_t1mskc    bmi_emulate.cc
cbmc --function rv32_tbm_t1msk     bmi_emulate.cc

echo OK
