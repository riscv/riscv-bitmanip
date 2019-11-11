#include <rvintrin.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>

static inline long rdinstret() { int64_t rd; asm volatile ("rdinstret %0" : "=r"(rd)); return rd; }

uint64_t din[64] = {
	// for i in {1..64}; do echo $i | sha1sum; done | sed -r 's/(.{16}).*/0x\1,/' | fmt -w 80
	0xe5fa44f2b31c1fb5, 0x7448d8798a438016, 0xa3db5c13ff90a369, 0x9c6b057a2b9d96a4,
	0x5d9474c0309b7ca0, 0xccf271b7830882da, 0xd3964f9dad9f6036, 0x136571b41aa14adc,
	0xb6abd567fa79cbe0, 0x4143d3a341877154, 0xdd71038f3463f511, 0xad552e6dc057d1d8,
	0xfeee44ad365b6b1e, 0x030514d80869744a, 0x587b596f04f7db9c, 0x3596ea087bfdaf52,
	0xad48103e4fc71796, 0x24b9c1f3fddff798, 0xba9f376fa71904cc, 0xd0758565fd06c37a,
	0x8eecbb71d418ef8c, 0xa66ca4290ebaf525, 0xaec46dc0de48f39f, 0xb31990eea1cee9f4,
	0xc6e4ffdb7e1f4c73, 0xa0361d509d714f50, 0x9c7ba4b1689f7c1f, 0x29581e412c0981bf,
	0xc6112fc247276d82, 0x97ea7ec8a6bb8ab9, 0x22980f6cd0807e71, 0x69340613d824dc2a,
	0x37e3ecf5f468d8af, 0xeeec021898eec14f, 0x45c20f2147e030b0, 0x5bf6e5357bd42a6b,
	0x02ede1eec131f84e, 0x6643b1a6b884eb62, 0xe6fdd81a2e7aee78, 0xb0ee9cc6bd7c6035,
	0x05df01e327042694, 0x34973274ccef6ab4, 0x23e182506f4b883d, 0xf54ee8e79bad1e59,
	0xa06b1ef93d78fd34, 0x8031facf4b264d62, 0x5de163e1f7435780, 0xf75209253756ecae,
	0x4c80a26e33c2886d, 0x1fb45e0b8e830ad8, 0x1f33b8494a3d4e25, 0xb5728b43aa396c41,
	0xb811797a045f456d, 0x2debea01ac55a6db, 0x4888920a568af4ef, 0xffb80d10ea87ad58,
	0x8349778b6c4574bd, 0x77347fb359409b5e, 0x389e4ccf12377707, 0xb4297d8ba77b0d20,
	0xd514562e9d3e1580, 0xa4d3c742290b20b5, 0x052da9125cb1b6aa, 0x7838b9004b44d6b1
};

uint64_t din2[8] = {
	// for i in {1..8}; do echo x$i | sha1sum; done | sed -r 's/(.{16}).*/0x\1,/' | fmt -w 80
	0x04358ba4b61baf28, 0x581de19c31fbfbf5, 0x16bdb32c19cc3ea1, 0xb4f4540df8aecf1c,
	0x6cc2ce0ec07716b7, 0x1592710a875d7d08, 0x3d20b6e7409ca822, 0x6da037a01a5083c3
};

uint64_t dout_reference[64];
uint64_t dout_baseisa[64];
uint64_t dout_bitmanip[64];

uint64_t dout2_reference[64];
uint64_t dout2_baseisa[64];
uint64_t dout2_baseisa2[64];
uint64_t dout2_bitmanip[64];
uint64_t dout2_bitmanip_ideal[64];

uint64_t dout3_reference[8];
uint64_t dout3_baseisa[8];
uint64_t dout3_bitmanip[8];
uint64_t dout3_bitmanip_ideal[8];

// convert a 64x64 bit matrix (with rows in 64-bit words) to a
// 8x8 block matrix of 8x8 bit matrices (in row major form)
void bm64c_reference(const uint64_t in[64], uint64_t out[64])
{
	for (int i = 0; i < 64; i++)
		out[i] = 0;

	for (int i = 0; i < 64; i++) // in[] rows, word index
	for (int j = 0; j < 64; j += 8) // in[] columns, bit index
		out[j/8 + 8*(i/8)] |= ((in[i] >> j) & 255) << (j%8 + 8*(i%8));
}

// optimized non-bitmanip version of bm64c_reference
void bm64c_baseisa(const uint64_t in[64], uint64_t out[64])
{
	const uint64_t *q = in;
	uint8_t *p = (void*)out;
	for (int i = 0; i < 8; i++)
	{
		for (int j = 0; j < 8; j++)
		{
			uint64_t v = *(q++);

			#pragma GCC unroll 8
			for (int k = 0; k < 64; k += 8)
				p[k] = v >> k;

			p++;
		}
		p += 56;
	}
}

// bitmanip code for block-transmorming a 8x64 row major (or 64x8
// column major) matrix. this transformation is its own inverse.
void conv8x8(const uint64_t x[8], uint64_t y[8])
{
	uint64_t x0_x1_31_00 = _rv64_pack (x[0], x[1]);
	uint64_t x2_x3_31_00 = _rv64_pack (x[2], x[3]);
	uint64_t x4_x5_31_00 = _rv64_pack (x[4], x[5]);
	uint64_t x6_x7_31_00 = _rv64_pack (x[6], x[7]);
	uint64_t x0_x1_63_32 = _rv64_packu(x[0], x[1]);
	uint64_t x2_x3_63_32 = _rv64_packu(x[2], x[3]);
	uint64_t x4_x5_63_32 = _rv64_packu(x[4], x[5]);
	uint64_t x6_x7_63_32 = _rv64_packu(x[6], x[7]);

	uint64_t x0_x1_31_00_z = _rv64_unzip16(x0_x1_31_00);
	uint64_t x2_x3_31_00_z = _rv64_unzip16(x2_x3_31_00);
	uint64_t x4_x5_31_00_z = _rv64_unzip16(x4_x5_31_00);
	uint64_t x6_x7_31_00_z = _rv64_unzip16(x6_x7_31_00);
	uint64_t x0_x1_63_32_z = _rv64_unzip16(x0_x1_63_32);
	uint64_t x2_x3_63_32_z = _rv64_unzip16(x2_x3_63_32);
	uint64_t x4_x5_63_32_z = _rv64_unzip16(x4_x5_63_32);
	uint64_t x6_x7_63_32_z = _rv64_unzip16(x6_x7_63_32);

	uint64_t x0_x1_x2_x3_15_00 = _rv64_pack (x0_x1_31_00_z, x2_x3_31_00_z);
	uint64_t x4_x5_x6_x7_15_00 = _rv64_pack (x4_x5_31_00_z, x6_x7_31_00_z);
	uint64_t x0_x1_x2_x3_31_16 = _rv64_packu(x0_x1_31_00_z, x2_x3_31_00_z);
	uint64_t x4_x5_x6_x7_31_16 = _rv64_packu(x4_x5_31_00_z, x6_x7_31_00_z);
	uint64_t x0_x1_x2_x3_47_32 = _rv64_pack (x0_x1_63_32_z, x2_x3_63_32_z);
	uint64_t x4_x5_x6_x7_47_32 = _rv64_pack (x4_x5_63_32_z, x6_x7_63_32_z);
	uint64_t x0_x1_x2_x3_63_48 = _rv64_packu(x0_x1_63_32_z, x2_x3_63_32_z);
	uint64_t x4_x5_x6_x7_63_48 = _rv64_packu(x4_x5_63_32_z, x6_x7_63_32_z);

	uint64_t x0_x1_x2_x3_15_00_z = _rv64_unzip8(x0_x1_x2_x3_15_00);
	uint64_t x4_x5_x6_x7_15_00_z = _rv64_unzip8(x4_x5_x6_x7_15_00);
	uint64_t x0_x1_x2_x3_31_16_z = _rv64_unzip8(x0_x1_x2_x3_31_16);
	uint64_t x4_x5_x6_x7_31_16_z = _rv64_unzip8(x4_x5_x6_x7_31_16);
	uint64_t x0_x1_x2_x3_47_32_z = _rv64_unzip8(x0_x1_x2_x3_47_32);
	uint64_t x4_x5_x6_x7_47_32_z = _rv64_unzip8(x4_x5_x6_x7_47_32);
	uint64_t x0_x1_x2_x3_63_48_z = _rv64_unzip8(x0_x1_x2_x3_63_48);
	uint64_t x4_x5_x6_x7_63_48_z = _rv64_unzip8(x4_x5_x6_x7_63_48);

	y[0] = _rv64_pack (x0_x1_x2_x3_15_00_z, x4_x5_x6_x7_15_00_z);
	y[1] = _rv64_packu(x0_x1_x2_x3_15_00_z, x4_x5_x6_x7_15_00_z);
	y[2] = _rv64_pack (x0_x1_x2_x3_31_16_z, x4_x5_x6_x7_31_16_z);
	y[3] = _rv64_packu(x0_x1_x2_x3_31_16_z, x4_x5_x6_x7_31_16_z);
	y[4] = _rv64_pack (x0_x1_x2_x3_47_32_z, x4_x5_x6_x7_47_32_z);
	y[5] = _rv64_packu(x0_x1_x2_x3_47_32_z, x4_x5_x6_x7_47_32_z);
	y[6] = _rv64_pack (x0_x1_x2_x3_63_48_z, x4_x5_x6_x7_63_48_z);
	y[7] = _rv64_packu(x0_x1_x2_x3_63_48_z, x4_x5_x6_x7_63_48_z);
}

// optimized bitmanip version of bm64c_reference
void bm64c_bitmanip(const uint64_t in[64], uint64_t out[64])
{
	for (int i = 0; i < 64; i += 8)
		conv8x8(in+i, out+i);
}

// transpose a 64x64 bit matrix
void bm64t_reference(const uint64_t in[64], uint64_t out[64])
{
	for (int i = 0; i < 64; i++)
		out[i] = 0;

	for (int i = 0; i < 64; i++)
	for (int j = 0; j < 64; j++)
		if ((in[i] >> j) & 1)
			out[j] |= 1L << i;
}

// optimized non-bitmanip version of bm64t_reference
void bm64t_baseisa(const uint64_t in[64], uint64_t out[64])
{
#if 0
	for (int j = 0; j < 64; j++)
	{
		uint64_t v = 0;

		#pragma GCC unroll 64
		for (int i = 0; i < 64; i++)
			v |= ((in[i] >> j) & 1) << i;

		out[j] = v;
	}
#else
	// https://twitter.com/Jepjoh2/status/1193614458100363264
	// https://gist.github.com/Laksen/a9cc0a81b4f2943f7df49233f26ee530#file-test-c-L49
	for (int j = 0; j < 64; j+=8)
	{
		uint64_t res0 = 0;
		uint64_t res1 = 0;
		uint64_t res2 = 0;
		uint64_t res3 = 0;
		uint64_t res4 = 0;
		uint64_t res5 = 0;
		uint64_t res6 = 0;
		uint64_t res7 = 0;

		for (int i = 0; i < 64; i++)
		{
			uint64_t in_tmp = in[i];
			res0 |= ((in_tmp >> (j+0)) & 1) << i;
			res1 |= ((in_tmp >> (j+1)) & 1) << i;
			res2 |= ((in_tmp >> (j+2)) & 1) << i;
			res3 |= ((in_tmp >> (j+3)) & 1) << i;
			res4 |= ((in_tmp >> (j+4)) & 1) << i;
			res5 |= ((in_tmp >> (j+5)) & 1) << i;
			res6 |= ((in_tmp >> (j+6)) & 1) << i;
			res7 |= ((in_tmp >> (j+7)) & 1) << i;
		}

		out[j+0] = res0;
		out[j+1] = res1;
		out[j+2] = res2;
		out[j+3] = res3;
		out[j+4] = res4;
		out[j+5] = res5;
		out[j+6] = res6;
		out[j+7] = res7;
	}
#endif
}

// another optimized non-bitmanip version of bm64t_reference
void bm64t_baseisa2(const uint64_t in[64], uint64_t out[64])
{
	uint64_t t1[64], t2[64];

	bm64c_baseisa(in, t1);

	for (int i = 0; i < 64; i ++)
	{
		uint64_t v = t1[i];

		#define X(maskL, maskR, N) v = (v & ~(maskL | maskR)) | ((v <<  N) & maskL) | ((v >>  N) & maskR);

		X(0x0000ffff00000000LL, 0x00000000ffff0000LL, 16)
		X(0x00ff000000ff0000LL, 0x0000ff000000ff00LL,  8)
		X(0x0f000f000f000f00LL, 0x00f000f000f000f0LL,  4)
		X(0x3030303030303030LL, 0x0c0c0c0c0c0c0c0cLL,  2)
		X(0x4444444444444444LL, 0x2222222222222222LL,  1)

		X(0x0000ffff00000000LL, 0x00000000ffff0000LL, 16)
		X(0x00ff000000ff0000LL, 0x0000ff000000ff00LL,  8)
		X(0x0f000f000f000f00LL, 0x00f000f000f000f0LL,  4)
		X(0x3030303030303030LL, 0x0c0c0c0c0c0c0c0cLL,  2)
		X(0x4444444444444444LL, 0x2222222222222222LL,  1)

		X(0x0000ffff00000000LL, 0x00000000ffff0000LL, 16)
		X(0x00ff000000ff0000LL, 0x0000ff000000ff00LL,  8)
		X(0x0f000f000f000f00LL, 0x00f000f000f000f0LL,  4)
		X(0x3030303030303030LL, 0x0c0c0c0c0c0c0c0cLL,  2)
		X(0x4444444444444444LL, 0x2222222222222222LL,  1)

		#undef X

		t2[((i << 3)|(i >> 3)) & 63] = v;
	}

	bm64c_baseisa(t2, out);
}

// optimized bitmanip version of bm64t_reference
void bm64t_bitmanip(const uint64_t in[64], uint64_t out[64])
{
	uint64_t t1[64], t2[64];

	bm64c_bitmanip(in, t1);

	#pragma GCC unroll 64
	for (int i = 0; i < 64; i ++)
		t2[((i << 3)|(i >> 3)) & 63] = _rv64_bmatflip(t1[i]);

	bm64c_bitmanip(t2, out);
}

// with input and output in block matrix form
void bm64t_bitmanip_ideal(const uint64_t in[64], uint64_t out[64])
{
	#pragma GCC unroll 64
	for (int i = 0; i < 64; i ++)
		out[((i << 3)|(i >> 3)) & 63] = _rv64_bmatflip(in[i]);
}

// multiply a 64x64 bit matrix (row major) with a 64x8 bit matrix (column major)
// producing a 64x8 (column major) result
void bm64m_reference(const uint64_t in1[64], const uint64_t in2[8], uint64_t out[8])
{
	for (int i = 0; i < 8; i++)
		out[i] = 0;

	for (int i = 0; i < 64; i++) // in1[] rows, word index
	for (int j = 0; j < 8; j++) // in2[] columns, word index
		if (__builtin_popcountll(in1[i] & in2[j]) & 1)
			out[j] |= 1L << i;
}

// optimized non-bitmanip version of bm64t_reference
void bm64m_baseisa(const uint64_t in1[64], const uint64_t in2[8], uint64_t out[8])
{
	for (int j = 0; j < 8; j++)
	{
		uint64_t v = 0;
		for (int i = 0; i < 64; i++) {
	#if 1
			v |= (uint64_t)(__builtin_popcountll(in1[i] & in2[j]) & 1) << i;
	#else
			v |= (_rv64_clmulr(in1[i] & in2[j], ~(uint64_t)0) & 1) << i;
	#endif
		}
		out[j] = v;
	}
}

// optimized bitmanip version of bm64t_reference
// in this version in1[] is expected in the block matrix form produced by bm64()
void bm64m_bitmanip(const uint64_t in1[64], const uint64_t in2[8], uint64_t out[8])
{
	uint64_t in2_b[8], out_b[8];

	conv8x8(in2, in2_b);

#if 1
	extern void bm64m_bitmanip_kernel(const void*, const void*, void*);
	bm64m_bitmanip_kernel(in1, in2_b, out_b);
#else
	for (int j = 0; j < 8; j++) {
		uint64_t v = 0;
		for (int i = 0; i < 8; i++)
			v ^= _rv64_bmatxor(in2_b[i], _rv64_bmatflip(in1[8*j+i]));
		out_b[j] = v;
	}
#endif

	conv8x8(out_b, out);
}

// with both inputs and output in block matrix form
void bm64m_bitmanip_ideal(const uint64_t in1[64], const uint64_t in2[8], uint64_t out[8])
{
#if 1
	extern void bm64m_bitmanip_kernel_ideal(const void*, const void*, void*);
	bm64m_bitmanip_kernel_ideal(in1, in2, out);
#else
	for (int j = 0; j < 8; j++) {
		uint64_t v = 0;
		for (int i = 0; i < 8; i++)
			v ^= _rv64_bmatxor(in1[8*j+i], in2[i]);
		out[j] = v;
	}
#endif
}

int main()
{
	printf("\n");
	printf("in1\n");
	for (int i = 0; i < 64; i++) { // rows
		printf("  ");
		for (int j = 0; j < 64; j++) // columns
			printf("%c", ((din[i] >> j) & 1) ? 'X' : '.');
		printf("\n");
	}

	printf("\n");
	printf("in2 (transposed)\n");
	for (int i = 0; i < 8; i++) {
		printf("  ");
		for (int j = 0; j < 64; j++)
			printf("%c", ((din[i] >> j) & 1) ? 'X' : '.');
		printf("\n");
	}

	printf("\n");
	printf("running bm64c_reference..\n");
	long t_reference = rdinstret();
	bm64c_reference(din, dout_reference);
	t_reference = rdinstret() - t_reference;

	for (int i = 0; i < 64; i++) { // rows
		printf("  ");
		for (int j = 0; j < 64; j++) // columns
			printf("%c", ((dout_reference[j/8 + 8*(i/8)] >> (j%8 + 8*(i%8))) & 1) ? 'X' : '.');
		printf("\n");
	}

	printf("\n");
	printf("running bm64c_baseisa..\n");
	long t_baseisa = rdinstret();
	bm64c_baseisa(din, dout_baseisa);
	t_baseisa = rdinstret() - t_baseisa;

	for (int i = 0; i < 64; i++) { // rows
		printf("  ");
		for (int j = 0; j < 64; j++) // columns
			printf("%c", ((dout_baseisa[j/8 + 8*(i/8)] >> (j%8 + 8*(i%8))) & 1) ? 'X' : '.');
		printf("\n");
	}

	assert(!memcmp(dout_reference, dout_baseisa, sizeof(dout_reference)));

	printf("\n");
	printf("running bm64c_bitmanip..\n");
	long t_bitmanip = rdinstret();
	bm64c_bitmanip(din, dout_bitmanip);
	t_bitmanip = rdinstret() - t_bitmanip;

	for (int i = 0; i < 64; i++) { // rows
		printf("  ");
		for (int j = 0; j < 64; j++) // columns
			printf("%c", ((dout_bitmanip[j/8 + 8*(i/8)] >> (j%8 + 8*(i%8))) & 1) ? 'X' : '.');
		printf("\n");
	}

	assert(!memcmp(dout_reference, dout_bitmanip, sizeof(dout_reference)));

	printf("\n");
	printf("running bm64t_reference..\n");
	long t2_reference = rdinstret();
	bm64t_reference(din, dout2_reference);
	t2_reference = rdinstret() - t2_reference;

	for (int i = 0; i < 64; i++) { // rows
		printf("  ");
		for (int j = 0; j < 64; j++) // columns
			printf("%c", ((dout2_reference[j/8 + 8*(i/8)] >> (j%8 + 8*(i%8))) & 1) ? 'X' : '.');
		printf("\n");
	}

	printf("\n");
	printf("running bm64t_baseisa..\n");
	long t2_baseisa = rdinstret();
	bm64t_baseisa(din, dout2_baseisa);
	t2_baseisa = rdinstret() - t2_baseisa;

	for (int i = 0; i < 64; i++) { // rows
		printf("  ");
		for (int j = 0; j < 64; j++) // columns
			printf("%c", ((dout2_baseisa[j/8 + 8*(i/8)] >> (j%8 + 8*(i%8))) & 1) ? 'X' : '.');
		printf("\n");
	}

	assert(!memcmp(dout2_reference, dout2_baseisa, sizeof(dout2_reference)));

	printf("\n");
	printf("running bm64t_baseisa2..\n");
	long t2_baseisa2 = rdinstret();
	bm64t_baseisa2(din, dout2_baseisa2);
	t2_baseisa2 = rdinstret() - t2_baseisa2;

	for (int i = 0; i < 64; i++) { // rows
		printf("  ");
		for (int j = 0; j < 64; j++) // columns
			printf("%c", ((dout2_baseisa2[j/8 + 8*(i/8)] >> (j%8 + 8*(i%8))) & 1) ? 'X' : '.');
		printf("\n");
	}

	assert(!memcmp(dout2_reference, dout2_baseisa2, sizeof(dout2_reference)));

	printf("\n");
	printf("running bm64t_bitmanip..\n");
	long t2_bitmanip = rdinstret();
	bm64t_bitmanip(din, dout2_bitmanip);
	t2_bitmanip = rdinstret() - t2_bitmanip;

	for (int i = 0; i < 64; i++) { // rows
		printf("  ");
		for (int j = 0; j < 64; j++) // columns
			printf("%c", ((dout2_bitmanip[j/8 + 8*(i/8)] >> (j%8 + 8*(i%8))) & 1) ? 'X' : '.');
		printf("\n");
	}

	assert(!memcmp(dout2_reference, dout2_bitmanip, sizeof(dout2_reference)));

	printf("\n");
	printf("running bm64t_bitmanip_ideal..\n");
	long t2_bitmanip_ideal = rdinstret();
	bm64t_bitmanip_ideal(din, dout2_bitmanip_ideal);
	t2_bitmanip_ideal = rdinstret() - t2_bitmanip_ideal;
	printf("  ~~dontcare~~\n");

	printf("\n");
	printf("running bm64m_reference..\n");
	long t3_reference = rdinstret();
	bm64m_reference(din, din2, dout3_reference);
	t3_reference = rdinstret() - t3_reference;

	for (int i = 0; i < 8; i++) {
		printf("  ");
		for (int j = 0; j < 64; j++)
			printf("%c", ((dout3_reference[i] >> j) & 1) ? 'X' : '.');
		printf("\n");
	}

	printf("\n");
	printf("running bm64m_baseisa..\n");
	long t3_baseisa = rdinstret();
	bm64m_baseisa(din, din2, dout3_baseisa);
	t3_baseisa = rdinstret() - t3_baseisa;

	for (int i = 0; i < 8; i++) {
		printf("  ");
		for (int j = 0; j < 64; j++)
			printf("%c", ((dout3_baseisa[i] >> j) & 1) ? 'X' : '.');
		printf("\n");
	}

	assert(!memcmp(dout3_reference, dout3_baseisa, sizeof(dout3_reference)));

	printf("\n");
	printf("running bm64m_bitmanip..\n");
	long t3_bitmanip = rdinstret();
	bm64m_bitmanip(dout_reference, din2, dout3_bitmanip);
	t3_bitmanip = rdinstret() - t3_bitmanip;

	for (int i = 0; i < 8; i++) {
		printf("  ");
		for (int j = 0; j < 64; j++)
			printf("%c", ((dout3_bitmanip[i] >> j) & 1) ? 'X' : '.');
		printf("\n");
	}

	assert(!memcmp(dout3_reference, dout3_bitmanip, sizeof(dout3_reference)));

	printf("\n");
	printf("running bm64m_bitmanip_ideal..\n");
	long t3_bitmanip_ideal = rdinstret();
	bm64m_bitmanip_ideal(dout_reference, din2, dout3_bitmanip_ideal);
	t3_bitmanip_ideal = rdinstret() - t3_bitmanip_ideal;

#if 1
	printf("  ~~dontcare~~\n");
#else
	for (int i = 0; i < 8; i++) {
		printf("  ");
		for (int j = 0; j < 64; j++)
			printf("%c", ((dout3_bitmanip_ideal[i] >> j) & 1) ? 'X' : '.');
		printf("\n");
	}
#endif

	printf("\n");
	printf("bm64c_reference: %5ld instructions\n", t_reference);
	printf("bm64c_baseisa:   %5ld instructions\n", t_baseisa);
	printf("bm64c_bitmanip:  %5ld instructions\n", t_bitmanip);

	printf("\n");
	printf("bm64t_reference: %5ld instructions\n", t2_reference);
	printf("bm64t_baseisa:   %5ld instructions\n", t2_baseisa);
	printf("bm64t_baseisa2:  %5ld instructions\n", t2_baseisa2);
	printf("bm64t_bitmanip:  %5ld instructions\n", t2_bitmanip);
	printf("bm64t_bitmanip*: %5ld instructions\n", t2_bitmanip_ideal);

	printf("\n");
	printf("bm64m_reference: %5ld instructions\n", t3_reference);
	printf("bm64m_baseisa:   %5ld instructions   (%3ld instr / dword)\n", t3_baseisa, t3_baseisa / 8);
	printf("bm64m_bitmanip:  %5ld instructions   (%3ld instr / dword)\n", t3_bitmanip, t3_bitmanip / 8);
	printf("bm64m_bitmanip*: %5ld instructions   (%3ld instr / dword)\n", t3_bitmanip_ideal, t3_bitmanip_ideal / 8);

	return 0;
}
