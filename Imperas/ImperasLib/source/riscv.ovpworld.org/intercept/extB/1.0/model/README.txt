
Ken Dockser - Initial requirements

2 RISC-V XBitmanip Extension all (except pseudo instruction)
    2.1 Count Leading/Trailing Zeros (clz, ctz)
    2.2 Count Bits Set (pcnt)
    2.3 And-with-complement (andc)
    2.4 Shift Ones (Left/Right) (slo, sloi, sro, sroi)
    2.5 Rotate (Left/Right) (rol, ror, rori)
    2.6 Generalized Reverse (grev, grevi)
    2.7 Generalized Shuffle (shfl, unshfl, shfli, unshfli)
    2.8 Bit Extract/Deposit (bext, bdep)
    2.9 Compressed instructions (c.not, c.neg, c.brev)

3 RISC-V XBit field Extension none
4 RISC-V XTernarybits Extension all
    4.1 Conditional mix (cmix)
    4.2 Conditional move (cmov)
    4.3 Funnel shift (fsl, fsr)

5 Additional Instructions all
    5.1 Min/max instructions (min, max, minu, maxu)
    5.2 Carry-less multiply (clmul, clmulh)
    5.3 CRC instructions (crc32.[bhwd], crc32c.[bhwd])
    5.4 Bit-matrix operations (bmatxor, bmator, bitmatflip)

    
    

90 lines (85 sloc) 5.25 KB
\chapter{Opcode Encodings}
\label{opcodes}

This chapter contains proposed encodings for most of the instructions described
in this document. {\bf DO NOT IMPLEMENT THESE OPCODES YET.} We are trying to get
official opcodes assigned and will update this chapter soon with the official
opcodes.

% Opcodes:
% 0010011 OP-IMM
% 0110011 OP
% 0011011 OP-IMM-32
% 0111011 OP-32

% Shift Opcodes:
%         | SLL  SRL  SRA | GREV | SLO SRO ROL ROR
%  op[30] |   0    0    1 |    1 |   0   0   1   1
%  op[29] |   0    0    0 |    0 |   1   1   1   1
%  funct3 | 001  101  101 |  001 | 001 101 001 101
%
% (Unary operations are using the ROLI encoding space)


https://github.com/cliffordwolf/xbitmanip/blob/master/opcodes.tex

i - Imperas Implemented Skeleton
I - Imperas Implemented
T - testdata.cc test exists

\begin{verbatim}
|  3                   2                   1                    |
|1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0|
|---------------------------------------------------------------|
|    funct7   |   rs2   |   rs1   |  f3 |    rd   |    opcode   |  R-type
|   rs3   | f2|   rs2   |   rs1   |  f3 |    rd   |    opcode   |  R4-type
|          imm          |   rs1   |  f3 |    rd   |    opcode   |  I-type
|---------------------------------------------------------------|
|  0110000       00000  |   rs1   | 001 |    rd   |   0010011   |  CLZ          *IT
|  0110000       00001  |   rs1   | 001 |    rd   |   0010011   |  CTZ          *IT
|  0110000       00010  |   rs1   | 001 |    rd   |   0010011   |  PCNT         *IT
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0110011   |  ANDC         *I
|  0010000    |   rs2   |   rs1   | 001 |    rd   |   0110011   |  SLO          *I
|  0010000    |   rs2   |   rs1   | 101 |    rd   |   0110011   |  SRO          *I
|  00100  |     imm     |   rs1   | 001 |    rd   |   0010011   |  SLOI         *I
|  00100  |     imm     |   rs1   | 101 |    rd   |   0010011   |  SROI         *I
|  0110000    |   rs2   |   rs1   | 001 |    rd   |   0110011   |  ROL          *I
|  0110000    |   rs2   |   rs1   | 101 |    rd   |   0110011   |  ROR          *I
|  01100  |     imm     |   rs1   | 101 |    rd   |   0010011   |  RORI         *I
|  0100000    |   rs2   |   rs1   | 001 |    rd   |   0110011   |  GREV         *IT
|  01000  |     imm     |   rs1   | 001 |    rd   |   0010011   |  GREVI        *I
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0110011   |  SHFL         *IT
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0110011   |  UNSHFL       *IT
|  ??????   |    imm    |   rs1   | ??? |    rd   |   0010011   |  SHFLI        *I
|  ??????   |    imm    |   rs1   | ??? |    rd   |   0010011   |  UNSHFLI      *I
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0110011   |  BEXT         *IT
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0110011   |  BDEP         *IT
|   rs3   | 00|   rs2   |   rs1   | ??? |    rd   |   ???????   |  CMIX         *I
|   rs3   | 01|   rs2   |   rs1   | ??? |    rd   |   ???????   |  CMOV         *I
|   rs3   | 10|   rs2   |   rs1   | ??? |    rd   |   ???????   |  FSL          *i
|   rs3   | 11|   rs2   |   rs1   | ??? |    rd   |   ???????   |  FSR          *i
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0110011   |  MIN          *I
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0110011   |  MAX          *I
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0110011   |  MINU         *I
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0110011   |  MAXU         *I
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0110011   |  CLMUL        *i
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0110011   |  CLMULH       *i
|  0110000       10000  |   rs1   | 001 |    rd   |   0010011   |  CRC32.B      *
|  0110000       10001  |   rs1   | 001 |    rd   |   0010011   |  CRC32.H      *
|  0110000       10010  |   rs1   | 001 |    rd   |   0010011   |  CRC32.W      *
|  0110000       10011  |   rs1   | 001 |    rd   |   0010011   |  CRC32.D      *
|  0110000       11000  |   rs1   | 001 |    rd   |   0010011   |  CRC32C.B     *
|  0110000       11001  |   rs1   | 001 |    rd   |   0010011   |  CRC32C.H     *
|  0110000       11010  |   rs1   | 001 |    rd   |   0010011   |  CRC32C.W     *
|  0110000       11011  |   rs1   | 001 |    rd   |   0010011   |  CRC32C.D     *
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0110011   |  BMATXOR      *
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0110011   |  BMATOR       *
|  0110000       00011  |   rs1   | 001 |    rd   |   0010011   |  BMATFLIP     *
|---------------------------------------------------------------|
|  0110000       00000  |   rs1   | 001 |    rd   |   0011011   |  CLZW         *
|  0110000       00001  |   rs1   | 001 |    rd   |   0011011   |  CTZW         *
|  0110000       00010  |   rs1   | 001 |    rd   |   0011011   |  PCNTW        *
|  0010000    |   rs2   |   rs1   | 001 |    rd   |   0111011   |  SLOW         *
|  0010000    |   rs2   |   rs1   | 101 |    rd   |   0111011   |  SROW         *
|  00100  |     imm     |   rs1   | 001 |    rd   |   0011011   |  SLOIW        *
|  00100  |     imm     |   rs1   | 101 |    rd   |   0011011   |  SROIW        *
|  0110000    |   rs2   |   rs1   | 001 |    rd   |   0111011   |  ROLW         *
|  0110000    |   rs2   |   rs1   | 101 |    rd   |   0111011   |  RORW         *
|  01100  |     imm     |   rs1   | 101 |    rd   |   0011011   |  RORIW        *
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0111011   |  BEXTW        *
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0111011   |  BDEPW        *
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0111011   |  MINW         *
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0111011   |  MAXW         *
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0111011   |  MINUW        *
|  ???????    |   rs2   |   rs1   | ??? |    rd   |   0111011   |  MAXUW        *
|---------------------------------------------------------------|
\end{verbatim}