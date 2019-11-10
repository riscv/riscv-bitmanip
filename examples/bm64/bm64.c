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

uint64_t dout_reference[64];
uint64_t dout_baseisa[64];
uint64_t dout_bitmanip[64];

uint64_t dout2_reference[64];
uint64_t dout2_baseisa[64];
uint64_t dout2_bitmanip[64];

// convert a 64x64 bit matrix (with rows in 64-bit words) to a
// 8x8 block matrix of 8x8 bit matrices (in row major form)
void bm64_reference(const uint64_t in[64], uint64_t out[64])
{
	for (int i = 0; i < 64; i++)
		out[i] = 0;

	for (int i = 0; i < 64; i++) // in[] rows = word index
	for (int j = 0; j < 64; j++) // in[] columns  = bit index
		if ((in[i] >> j) & 1)
			out[j/8 + 8*(i/8)] |= 1L << (j%8 + 8*(i%8));
}

// optimized non-bitmanip version of bm64_reference, TBD
void bm64_baseisa(const uint64_t in[64], uint64_t out[64])
{
	bm64_reference(in, out);
}

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

// optimized bitmanip version of bm64_reference
void bm64_bitmanip(const uint64_t in[64], uint64_t out[64])
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

// optimized non-bitmanip version of bm64t_reference, TBD
void bm64t_baseisa(const uint64_t in[64], uint64_t out[64])
{
	bm64t_reference(in, out);
}

// optimized bitmanip version of bm64t_reference
void bm64t_bitmanip(const uint64_t in[64], uint64_t out[64])
{
	uint64_t t1[64], t2[64];

	for (int i = 0; i < 64; i += 8)
		conv8x8(in+i, t1+i);

	for (int i = 0; i < 64; i ++)
		t2[((i << 3)|(i >> 3)) & 63] = _rv64_bmatflip(t1[i]);

	for (int i = 0; i < 64; i += 8)
		conv8x8(t2+i, out+i);
}

int main()
{
	for (int i = 0; i < 64; i++) { // rows
		printf("  ");
		for (int j = 0; j < 64; j++) // columns
			printf("%c", ((din[i] >> j) & 1) ? 'X' : '.');
		printf("\n");
	}

	printf("\n");
	printf("running bm64_reference..\n");
	long t_reference = rdinstret();
	bm64_reference(din, dout_reference);
	t_reference = rdinstret() - t_reference;

	for (int i = 0; i < 64; i++) { // rows
		printf("  ");
		for (int j = 0; j < 64; j++) // columns
			printf("%c", ((dout_reference[j/8 + 8*(i/8)] >> (j%8 + 8*(i%8))) & 1) ? 'X' : '.');
		printf("\n");
	}

	printf("\n");
	printf("running bm64_baseisa..\n");
	long t_baseisa = rdinstret();
	bm64_baseisa(din, dout_baseisa);
	t_baseisa = rdinstret() - t_baseisa;

	for (int i = 0; i < 64; i++) { // rows
		printf("  ");
		for (int j = 0; j < 64; j++) // columns
			printf("%c", ((dout_baseisa[j/8 + 8*(i/8)] >> (j%8 + 8*(i%8))) & 1) ? 'X' : '.');
		printf("\n");
	}

	assert(!memcmp(dout_reference, dout_baseisa, sizeof(dout_reference)));

	printf("\n");
	printf("running bm64_bitmanip..\n");
	long t_bitmanip = rdinstret();
	bm64_bitmanip(din, dout_bitmanip);
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
	printf("running bm64_baseisa..\n");
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
	printf("running bm64_bitmanip..\n");
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
	printf("bm64_reference:  %5ld instructions\n", t_reference);
	printf("bm64_baseisa:    %5ld instructions\n", t_baseisa);
	printf("bm64_bitmanip:   %5ld instructions\n", t_bitmanip);

	printf("\n");
	printf("bm64t_reference: %5ld instructions\n", t2_reference);
	printf("bm64t_baseisa:   %5ld instructions\n", t2_baseisa);
	printf("bm64t_bitmanip:  %5ld instructions\n", t2_bitmanip);

	return 0;
}
