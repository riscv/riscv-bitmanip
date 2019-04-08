# compile & execute this program
make && asmgen.exe 10000 | tee random.asm

# compile (lnx6471)
cd /home/moore/git/eroom1966/riscv-compliance
. ../../setup.env
make RISCV_DEVICE=rv32ib RISCV_ISA=rv32ib

# run for real
./run.sh

# run for real
./run.sh
