#!/bin/bash

SIM=/home/moore/Imperas/lib/${IMPERAS_ARCH}/ImperasLib/imperas.ovpworld.org/platform/riscvOVPsim/1.0/platform.${IMPERAS_ARCH}.exe
SIM=/home/moore/Imperas/fixedPlatform/riscvOVPsim/bin/${IMPERAS_ARCH}/riscvOVPsim.exe 


$SIM \
  --variant RV32GC \
  --program /home/moore/git/eroom1966/riscv-compliance/work/rv32ib/random.elf \
  --signaturedump \
  --customcontrol \
  --extensionb \
  --trace \
  --tracemode \
  --traceshowicount \
  --traceregs \
  --override riscvOVPsim/cpu/simulateexceptions=T \
  --override riscvOVPsim/cpu/defaultsemihost=F
