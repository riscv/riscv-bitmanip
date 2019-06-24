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

int clz(int i)
{
	return __builtin_clz(i);
}

int ctz(int i)
{
	return __builtin_ctz(i);
}

int popcount(int i)
{
	return __builtin_popcount(i);
}

int andn(int i, int j)
{
	return i &~j;
}

int orn(int i, int j)
{
	return i | ~j;
}

int xnor(int i, int j)
{
	return i ^ ~j;
}

unsigned int zexth(short s)
{
	return (unsigned short)
		s;
}

unsigned long zexth2(short s)
{
	return (unsigned short)
		s;
}

unsigned long zextw(int i)
{
	return (unsigned int)
		i;
}

int min(int i, int j)
{
	return i < j ? i:
	j;
}

int max(int i, int j)
{
	return i > j ? i : j;
}

long umin(unsigned long i, unsigned long j)
{
	return i < j ? i : j;
}

long umax(unsigned long i, unsigned long j)
{
	return i > j ? i : j;
}

unsigned int rot(unsigned int i, unsigned int j)
{
	int mask = 0x1f;
	return (i << (j & mask)) | (i >> (-j & mask));
}

unsigned int rotr(unsigned int i, unsigned int j)
{
	int mask = 0x1f;
	return (i >> (j & mask)) | (i << (-j & mask));
}

int rev8(int i)
{
	return __builtin_bswap32(i);
}

long cmix(long i, long j, long k)
{
	return (i & j) | (k & ~j);
}

int addwu(char *p, unsigned int i, unsigned int j)
{
	return p[i + j];
}

int subwu(char *p, unsigned int i, unsigned int j)
{
	return p[i - j];
}

long adduw(long i, long j)
{
	return i + (long)(unsigned int)j;
}

long subuw(long i, long j)
{
	return i - (long)(unsigned int)j;
}

/* ??? See the slliuw pattern in bitmanip.md.  */
long slliuw(long i)
{
	return (long)(unsigned int)
		i << 10;
}
