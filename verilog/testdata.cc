// clang++ -Wall -Os -std=c++11 -o testdata testdata.cc && ./testdata
#include <stdio.h>
#include "../cproofs/common.h"

int main()
{
	FILE *f;

	f = fopen("testdata_grev.hex", "w");
	for (int i = 0; i < 1000; i++) {
		uint32_t din = xorshift32();
		uint32_t shamt = xorshift32() & 31;
		uint32_t dout = grev32(din, shamt);
		fprintf(f, "%08x%02x%08x\n", din, shamt, dout);
	}
	fclose(f);

	f = fopen("testdata_shuffle.hex", "w");
	for (int i = 0; i < 1000; i++) {
		uint32_t din = xorshift32();
		uint32_t mask = xorshift32() & 0xffff;
		uint32_t mode = xorshift32() & 15;
		uint32_t ctrl = (mask << 16) | (mode << 12);
		uint32_t dout = shuffle(din, ctrl);
		fprintf(f, "%08x%08x%08x\n", din, ctrl, dout);
	}
	fclose(f);

	return 0;
}
