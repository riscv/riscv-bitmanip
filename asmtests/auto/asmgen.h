/*
 *  Copyright (C) 2019 Imperas Software Ltd
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

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
