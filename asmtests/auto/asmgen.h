/// RISC-V Bit Manipulation Instruction Support
//
// Copyright (c) 2019, Imperas Software Ltd. Additions
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//      * Redistributions of source code must retain the above copyright
//        notice, this list of conditions and the following disclaimer.
//      * Redistributions in binary form must reproduce the above copyright
//        notice, this list of conditions and the following disclaimer in the
//        documentation and/or other materials provided with the distribution.
//      * the name of Imperas Software Ltd. nor the
//        names of its contributors may be used to endorse or promote products
//        derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Codasip Ltd., Imperas Software Ltd.
// BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#include <stdio.h>

//
// ASM rd(s0), rs1(s1), rs2(s2)
// x0 = zero
// x1 = ra
// x2 = sp
//

FILE * asmBegin(const char *asmfile) {
    FILE * out = fopen(asmfile, "w");
    fprintf(out,
        "#include \"compliance_test.h\"\n"
        "#include \"compliance_io.h\"\n"
        "#include \"test_macros.h\"\n"
        "#include \"extB.S.include\"\n"
        "\n"
        "# Test Virtual Machine (TVM) used by program.\n"
        "RV_COMPLIANCE_RV32M\n"
        "\n"
        "# Test code region.\n"
        "RV_COMPLIANCE_CODE_BEGIN\n"
        "\n"
        "    RVTEST_IO_INIT\n"
        "    RVTEST_IO_WRITE_STR(x31, \"Start Test\\n\");\n"
        "    la      x1, test_result\n"
        "    li      t0, 0xffffffff\n"
        "    sw      t0, 0(x1)\n"
        "\n"
    );
    return out;
}

void asmEnd(FILE *out) {
    fprintf(out,
        "    RVTEST_IO_WRITE_STR(x31, \"End Test\\n\");\n"
        "    la      x1, test_result\n"
        "    li      t0, 1\n"
        "    sw      t0, 0(x1)\n"
        "\n"
        "    # HALT\n"
        "    RV_COMPLIANCE_HALT\n"
        "\n"
        "RV_COMPLIANCE_CODE_END\n"
        "\n"
        "# Input data section.\n"
        "    .data\n"
        "\n"
        "# Output data section.\n"
        "RV_COMPLIANCE_DATA_BEGIN\n"
        "\n"
        "test_result:\n"
        ".fill 1, 4, -1\n"
        "\n"
        "RV_COMPLIANCE_DATA_END\n"
    );
    fclose(out);
}

void asmRR (FILE *out, const char *op, uint32_t rd, uint32_t rs1) {
    fprintf(out, "    li t1, 0x%08X\n", rs1);
    fprintf(out, "    %s 5 6\n", op); // t0=5, t1=6, t2=7
    fprintf(out, "    RVTEST_IO_ASSERT_GPR_EQ(sp, t0, 0x%08X);\n", rd);
}

void asmRRR (FILE *out, const char *op, uint32_t rd, uint32_t rs1, uint32_t rs2) {
    fprintf(out, "    li t1, 0x%08X\n", rs1);
    fprintf(out, "    li t2, 0x%08X\n", rs2);
    fprintf(out, "    %s 5 6 7\n", op); // t0=5, t1=6, t2=7
    fprintf(out, "    RVTEST_IO_ASSERT_GPR_EQ(sp, t0, 0x%08X);\n", rd);
}
