#include <rvintrin.h>

int pcntw_asm(int val)
{
	int cnt;
	__asm__ ("pcntw %0, %1" : "=r"(cnt) : "r"(val));
	return cnt;
}

int pcntw_intrin(int val)
{
	return _rv32_pcnt(val);
}

int pcntw_builtin(int val)
{
	return __builtin_riscv_pcntw(val);
}

int find_nth_set_bit(unsigned int value, int cnt)
{
	return _rv32_ctz(_rv32_bdep(1 << cnt, value));
}
