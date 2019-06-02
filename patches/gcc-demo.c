long demo(long val)
{
	long cnt;
	__asm__ ("pcnt %0, %1" : "=r"(cnt) : "r"(val));
	return cnt;
}
