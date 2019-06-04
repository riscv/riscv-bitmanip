int demo_asm(int val)
{
	int cnt = __builtin_riscv_pcntw(val);
	__asm__ ("pcntw %0, %1" : "=r"(cnt) : "r"(val));
	return cnt;
}

int demo_builtin(int val)
{
	return __builtin_riscv_pcntw(val);
}
