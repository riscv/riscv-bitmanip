// #define RVINTRIN_EMULATE
#include <rvintrin.h>

#undef VERBOSE_TESTS
#include "tests.h"

void printc(int c)
{
	volatile char *p = (void*)0x10000000;
	*p = c;
}

void prints(char *p)
{
	while (*p)
		printc(*(p++));
}

void printh(unsigned int v)
{
	prints("0x");
	for (int i = 0; i < 8; i++, v <<= 4) {
		int d = v >> 28;
		if (d < 10)
			printc('0' + d);
		else
			printc('A' + d - 10);
	}
}

#ifdef VERBOSE_TESTS
int check(uint32_t *b, uint32_t *e, uint32_t *r)
{
	int errcnt = 0;
	for (uint32_t *p = b; p != e; p++) {
		uint32_t v = r[p - b];
		prints("SIG=");
		printh(*p);
		prints(" REF=");
		printh(v);
		prints(*p == v ? " OK\n" : " ERROR\n");
		errcnt += *p != v;
	}
	return errcnt;
}

#define RUNTEST(_name) prints("--- " #_name " ---\n"); testcode_##_name(); \
  errcnt += check(begin_signature_##_name, end_signature_##_name, reference_##_name);

#else

int check(uint32_t *b, uint32_t *e, uint32_t *r)
{
	int errcnt = 0;
	for (uint32_t *p = b; p != e; p++) {
		uint32_t v = r[p - b];
		errcnt += *p != v;
	}
	prints(errcnt ? " ERROR" : " OK\n");
	return errcnt;
}

#define RUNTEST(_name) prints("" #_name ":"); testcode_##_name(); \
  errcnt += check(begin_signature_##_name, end_signature_##_name, reference_##_name);

#endif

int main()
{
	int errcnt = 0;

	prints("Hello World!\n");
	printh(_rv32_clmul(123456789, 12345678));
	printc('\n');
	printh(_rv32_clmulr(123456789, 12345678));
	printc('\n');
	printh(_rv32_clmulh(123456789, 12345678));
	printc('\n');
	printh(_rv32_ror(123456789, 12));
	printc('\n');
	printh(_rv32_rol(123456789, 12));
	printc('\n');
	printh(_rv32_fsr(123456789, 12345678, 12));
	printc('\n');
	printh(_rv32_fsl(123456789, 12345678, 12));
	printc('\n');
	printh(_rv_cmix(123456789, 12345678, 1234567));
	printc('\n');

	RUN_ALL_TESTS

	prints(errcnt ? "*** FAIL ***\n" : "*** PASS ***\n");

	return 0;
}
