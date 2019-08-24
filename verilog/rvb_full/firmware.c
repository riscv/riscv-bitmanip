// #define RVINTRIN_EMULATE
#include <rvintrin.h>

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

int main()
{
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
	return 0;
}
