#include <rvintrin.h>

int demo_asm(int val)
{
	int cnt;
	__asm__ ("pcntw %0, %1" : "=r"(cnt) : "r"(val));
	return cnt;
}

int demo_intrin(int val)
{
	return _rv32_pcnt(val);
}

int demo_builtin(int val)
{
	return __builtin_riscv_pcntw(val);
}
