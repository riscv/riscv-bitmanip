/*
 *  Copyright (C) 2019  Clifford Wolf <clifford@clifford.at>
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

#define RVINTRIN_EMULATE
#define RVINTRIN_NOBUILTINS
#include "rvintrin.h"
#include "common.h"

#define ASSERT_RV32_1(_name) assert(_rv32_ ## _name(a) == rv32b::_name(a));
#define ASSERT_RV32_2(_name) assert(_rv32_ ## _name(a, b) == rv32b::_name(a, b));

#define ASSERT_RV64_1(_name) assert(_rv64_ ## _name(a) == rv64b::_name(a));
#define ASSERT_RV64_2(_name) assert(_rv64_ ## _name(a, b) == rv64b::_name(a, b));

#define ASSERT_RV_1(_name) assert(_rv_ ## _name(a) == rv64b::_name(a));
#define ASSERT_RV_2(_name) assert(_rv_ ## _name(a, b) == rv64b::_name(a, b));

void check_rv32_basic(int32_t a, int32_t b)
{
	ASSERT_RV32_1(clz);
	ASSERT_RV32_1(ctz);
	ASSERT_RV32_1(pcnt);
	ASSERT_RV32_2(pack);
	ASSERT_RV32_2(min);
	ASSERT_RV32_2(minu);
	ASSERT_RV32_2(max);
	ASSERT_RV32_2(maxu);
}

void check_rv64_basic(int64_t a, int64_t b)
{
	ASSERT_RV64_1(clz);
	ASSERT_RV64_1(ctz);
	ASSERT_RV64_1(pcnt);
	ASSERT_RV64_2(pack);
	ASSERT_RV64_2(min);
	ASSERT_RV64_2(minu);
	ASSERT_RV64_2(max);
	ASSERT_RV64_2(maxu);
}

void check_rv32_single(int32_t a, int32_t b)
{
	ASSERT_RV32_2(sbset);
	ASSERT_RV32_2(sbclr);
	ASSERT_RV32_2(sbinv);
	ASSERT_RV32_2(sbext);
}

void check_rv64_single(int64_t a, int64_t b)
{
	ASSERT_RV64_2(sbset);
	ASSERT_RV64_2(sbclr);
	ASSERT_RV64_2(sbinv);
	ASSERT_RV64_2(sbext);
}

void check_rv32_shift(int32_t a, int32_t b)
{
	ASSERT_RV32_2(sll);
	ASSERT_RV32_2(srl);
	ASSERT_RV32_2(sra);
	ASSERT_RV32_2(slo);
	ASSERT_RV32_2(sro);
	ASSERT_RV32_2(rol);
	ASSERT_RV32_2(ror);
	ASSERT_RV32_2(grev);
	ASSERT_RV32_2(shfl);
	ASSERT_RV32_2(unshfl);
}

void check_rv64_shift(int64_t a, int64_t b)
{
	ASSERT_RV64_2(sll);
	ASSERT_RV64_2(srl);
	ASSERT_RV64_2(sra);
	ASSERT_RV64_2(slo);
	ASSERT_RV64_2(sro);
	ASSERT_RV64_2(rol);
	ASSERT_RV64_2(ror);
	ASSERT_RV64_2(grev);
	ASSERT_RV64_2(shfl);
	ASSERT_RV64_2(unshfl);
}

int main()
{
	printf("testing rv32 bext/bdep..\n");
	for (int i = 0; i < 100000; i++) {
		int32_t a = xorshift32();
		int32_t b = xorshift32();
		ASSERT_RV32_2(bext);
		ASSERT_RV32_2(bdep);
	}

	printf("testing rv64 bext/bdep..\n");
	for (int i = 0; i < 100000; i++) {
		int64_t a = xorshift64();
		int64_t b = xorshift64();
		ASSERT_RV64_2(bext);
		ASSERT_RV64_2(bdep);
	}

	printf("testing rv32 clmul[h[x]]..\n");
	for (int i = 0; i < 100000; i++) {
		int32_t a = xorshift32();
		int32_t b = xorshift32();
		ASSERT_RV32_2(clmul);
		ASSERT_RV32_2(clmulh);
		ASSERT_RV32_2(clmulhx);
	}

	printf("testing rv64 clmul[h[x]]..\n");
	for (int i = 0; i < 100000; i++) {
		int64_t a = xorshift64();
		int64_t b = xorshift64();
		ASSERT_RV64_2(clmul);
		ASSERT_RV64_2(clmulh);
		ASSERT_RV64_2(clmulhx);
	}

	printf("testing crc32/crc32c..\n");
	for (int i = 0; i < 100000; i++) {
		int64_t a = xorshift64();
		int64_t b = xorshift64();
		ASSERT_RV_1(crc32_b);
		ASSERT_RV_1(crc32_h);
		ASSERT_RV_1(crc32_w);
		// ASSERT_RV_1(crc32_d);
		ASSERT_RV_1(crc32c_b);
		ASSERT_RV_1(crc32c_h);
		ASSERT_RV_1(crc32c_w);
		// ASSERT_RV_1(crc32c_d);
	}

	printf("OK.\n");
	return 0;
}
