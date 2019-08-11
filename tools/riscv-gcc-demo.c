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

int clz2(int i)
{
	return i ? __builtin_clz(i) : 0;
}

int clz3(int i)
{
	return i ? __builtin_clz(i) : 32;
}

int clz4(long i)
{
	return i ? __builtin_clzl(i) : 64;
}

int ctz(int i)
{
	return __builtin_ctz(i);
}

int ctz2(int i)
{
	return i ? __builtin_ctz(i) : 0;
}

int ctz3(int i)
{
	return i ? __builtin_ctz(i) : 32;
}

int ctz4(long i)
{
	return i ? __builtin_ctzl(i) : 64;
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
	return (unsigned short)s;
}

unsigned long zexth2(short s)
{
	return (unsigned short)s;
}

unsigned long zextw(int i)
{
	return (unsigned int) i;
}

int min(int i, int j)
{
	return i < j ? i : j;
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
	return (long)(unsigned int)i << 10;
}

long addiwu_li(void)
{
	return 0xffffffff;
}

long sbset(long i, int index)
{
	return i | (1L << index);
}

int sbsetw(int i, int index)
{
	return i | (1 << index);
}

long sbseti(long i)
{
	return i | (1L << 20);
}

int sbsetiw(int i)
{
	return i | (1 << 20);
}

long sbclr(long i, int index)
{
	return i & ~(1L << index);
}

int sbclrw(int i, int index)
{
	return i & ~(1 << index);
}

long sbclri(long i)
{
	return i & ~(1L << 20);
}

int sbclriw(int i)
{
	return i & ~(1 << 20);
}

long sbinv(long i, int index)
{
	return i ^ (1L << index);
}

int sbinvw(int i, int index)
{
	return i ^ (1 << index);
}

long sbinvi(long i)
{
	return i ^ (1L << 20);
}

int sbinviw(int i)
{
	return i ^ (1 << 20);
}

long sbext(long i, int index)
{
	return (i >> index) & 1;
}

int sbextw(int i, int index)
{
	return (i >> index) & 1;
}

long sbexti(long i)
{
	return (i >> 20) & 1;
}

int sbextiw(int i)
{
	return (i >> 20) & 1;
}

long sbseti_li(void)
{
	return 0x200000000L;
}

// https://github.com/riscv/riscv-bitmanip/issues/36
unsigned int issue36(unsigned int a)
{
        return a & ~(1 << 29);
}
