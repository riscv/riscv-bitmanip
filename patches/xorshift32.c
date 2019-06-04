#include <rvintrin.h>

#if 0
uint32_t xorshift32(uint32_t x)
{
	x ^= x << 13;
	x ^= x >> 17;
	x ^= x << 5;
	return x;
}

uint32_t xorshift32_inv_simple(uint32_t x)
{
	uint32_t t;
	t = x ^ (x << 5);
	t = x ^ (t << 5);
	t = x ^ (t << 5);
	t = x ^ (t << 5);
	t = x ^ (t << 5);
	x = x ^ (t << 5);
	x = x ^ (x >> 17);
	t = x ^ (x << 13);
	x = x ^ (t << 13);
	return x;

}
#endif

uint32_t xorshift32_inv_clmul(uint32_t x)
{
	x = _rv32_clmul(x, 0x42108421);
	x = x ^ (x >> 17);
	x = _rv32_clmul(x, 0x04002001);
	return x;
}
