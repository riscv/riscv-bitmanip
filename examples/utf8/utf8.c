#include <rvintrin.h>
#include <assert.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

static inline long rdinstret() { int64_t rd; asm volatile ("rdinstret %0" : "=r"(rd) : : "memory"); return rd; }

#define NUM 1234

uint32_t din[NUM];

uint8_t dout_utf8_encode_reference[8*NUM];
uint8_t dout_utf8_encode_bitmanip[8*NUM];

long len_utf8_encode_reference;
long len_utf8_encode_bitmanip;

uint32_t dout_utf8_decode_reference[NUM];
uint32_t dout_utf8_decode_bitmanip[NUM];

long len_utf8_decode_reference;
long len_utf8_decode_bitmanip;

long utf8_encode_reference(const uint32_t *in, uint8_t *out, long len)
{
	long k = 0;

	for (int i = 0; i < len; i++)
	{
		uint32_t v = in[i];

		if (v <= 0x7f) {
			out[k++] = v;
			continue;
		}

		if (v <= 0x7ff) {
			out[k++] = 0xc0 | ((v >> 6) & 0x1f);
			out[k++] = 0x80 | ((v >> 0) & 0x3f);
			continue;
		}

		if (v <= 0xffff) {
			out[k++] = 0xe0 | ((v >> 12) & 0x0f);
			out[k++] = 0x80 | ((v >>  6) & 0x3f);
			out[k++] = 0x80 | ((v >>  0) & 0x3f);
			continue;
		}

		if (v <= 0x10ffff) {
			out[k++] = 0xf0 | ((v >> 18) & 0x07);
			out[k++] = 0x80 | ((v >> 12) & 0x3f);
			out[k++] = 0x80 | ((v >>  6) & 0x3f);
			out[k++] = 0x80 | ((v >>  0) & 0x3f);
			continue;
		}

		assert(0);
	}

	return k;
}

long utf8_encode_bitmanip(const uint32_t *in, uint8_t *out, long len)
{
	uint32_t *p = (void*)out;
	uint64_t outbuf = 0;
	long outcursor = 0;

	uint64_t mask = 0x3f3f3f3f;
	uint64_t pf16 = 0x0000c080;
	uint64_t pf24 = 0x00e08080;
	uint64_t pf32 = 0xf0808080;

	for (int i = 0; i < len; i++)
	{
		uint32_t v = in[i];

		if (outcursor >= 32)
		{
			*(p++) = outbuf;
			outbuf >>= 32;
			outcursor -= 32;
		}

		if (v < 0x80)
		{
			outbuf |= v << outcursor;
			outcursor += 8;
			continue;
		}

		if (v < 0x800)
		{
			outbuf |= _rv64_rev8_h(pf16 | _rv64_bdep(v, mask)) << outcursor;
			outcursor += 16;
			continue;
		}

		if (v < 0x10000)
		{
			outbuf |= _rv64_rev8_w(pf24 | _rv64_bdep(v, mask)) >> 8 << outcursor;
			outcursor += 24;
			continue;
		}

		outbuf |= _rv64_rev8_w(pf32 | _rv64_bdep(v, mask)) << outcursor;
		outcursor += 32;
	}

	for (int i = 0; i < outcursor; i += 8)
		((uint8_t*)p)[i/8] = outbuf >> i;

	return (void*)p - (void*)out + outcursor / 8;
}

long utf8_decode_reference(const uint8_t *in, uint32_t *out, long len)
{
	long k = 0;

	for (int i = 0; i < len; i++)
	{
		uint64_t v = in[i];

		if ((v & 0x80) == 0x00) {
			out[k++] = v;
			continue;
		}

		if ((v & 0xe0) == 0xc0) {
			v  = (v       & 0x1f) << 6;
			v |= (in[++i] & 0x3f) << 0;
			out[k++] = v;
			continue;
		}

		if ((v & 0xf0) == 0xe0) {
			v  = (v       & 0x0f) << 12;
			v |= (in[++i] & 0x3f) << 6;
			v |= (in[++i] & 0x3f) << 0;
			out[k++] = v;
			continue;
		}

		v  = (v       & 0x07) << 18;
		v |= (in[++i] & 0x3f) << 12;
		v |= (in[++i] & 0x3f) << 6;
		v |= (in[++i] & 0x3f) << 0;
		out[k++] = v;
	}

	return k;
}

long utf8_decode_bitmanip(const uint8_t *in, uint32_t *out, long len)
{
	return utf8_decode_reference(in, out, len);
}

#define TEST(_name, _iter, _code) \
  do { \
    printf("testing %s..\n", #_name); \
    long icnt = rdinstret(); \
    _code \
    icnt = rdinstret() - icnt; \
    p += sprintf(p, "%-25s %5ld instructions  (%2.1f inst / word)\n", #_name, icnt, (float)icnt / _iter); \
  } while (0)

uint64_t xs64()
{
	static uint64_t x = 123456789;
	x ^= x << 13;
	x ^= x >> 7;
	x ^= x << 17;
	return x;
}

int main()
{
	char buffer[16*1024];
	char *p = buffer;

	long expected_len_utf8_encode = 0;

	for (int i = 0; i < NUM; i++)
	{
		uint32_t v;

		do {
			v = xs64();
			v >>= xs64() & 31;
		} while (v > 0x10ffff);

		if (v <= 0x7f)
			expected_len_utf8_encode += 1;
		else if (v <= 0x7ff)
			expected_len_utf8_encode += 2;
		else if (v <= 0xffff)
			expected_len_utf8_encode += 3;
		else
			expected_len_utf8_encode += 4;

		// printf("U+%06x%c", v, i % 8 == 7 || i == NUM-1 ? '\n' : ' ');
		din[i] = v;
	}

	TEST(utf8_encode_reference, NUM, {
		len_utf8_encode_reference = utf8_encode_reference(din, dout_utf8_encode_reference, NUM);
	});

	assert(len_utf8_encode_reference == expected_len_utf8_encode);

	TEST(utf8_encode_bitmanip, NUM, {
		len_utf8_encode_bitmanip = utf8_encode_bitmanip(din, dout_utf8_encode_bitmanip, NUM);
	});

	p += sprintf(p, "\n");

#if 0
	{
		int cursor = 0;

		for (int i = 0; i < NUM; i++)
		{
			uint32_t v = din[i];

			if (v <= 0x7f) {
				printf("U+%06x | %02x          | %02x\n", v,
						dout_utf8_encode_reference[cursor], dout_utf8_encode_bitmanip[cursor]);
				assert(dout_utf8_encode_reference[cursor] == dout_utf8_encode_bitmanip[cursor]);
				cursor += 1;
				continue;
			}

			if (v <= 0x7ff) {
				printf("U+%06x | %02x %02x       | %02x %02x\n", v,
						dout_utf8_encode_reference[cursor], dout_utf8_encode_reference[cursor+1],
						dout_utf8_encode_bitmanip[cursor], dout_utf8_encode_bitmanip[cursor+1]);
				assert(dout_utf8_encode_reference[cursor] == dout_utf8_encode_bitmanip[cursor]);
				assert(dout_utf8_encode_reference[cursor+1] == dout_utf8_encode_bitmanip[cursor+1]);
				cursor += 2;
				continue;
			}

			if (v <= 0xffff) {
				printf("U+%06x | %02x %02x %02x    | %02x %02x %02x\n", v,
						dout_utf8_encode_reference[cursor], dout_utf8_encode_reference[cursor+1], dout_utf8_encode_reference[cursor+2],
						dout_utf8_encode_bitmanip[cursor], dout_utf8_encode_bitmanip[cursor+1], dout_utf8_encode_bitmanip[cursor+2]);
				assert(dout_utf8_encode_reference[cursor] == dout_utf8_encode_bitmanip[cursor]);
				assert(dout_utf8_encode_reference[cursor+1] == dout_utf8_encode_bitmanip[cursor+1]);
				assert(dout_utf8_encode_reference[cursor+2] == dout_utf8_encode_bitmanip[cursor+2]);
				cursor += 3;
				continue;
			}

			printf("U+%06x | %02x %02x %02x %02x | %02x %02x %02x %02x\n", v,
					dout_utf8_encode_reference[cursor], dout_utf8_encode_reference[cursor+1],
					dout_utf8_encode_reference[cursor+2], dout_utf8_encode_reference[cursor+3],
					dout_utf8_encode_bitmanip[cursor], dout_utf8_encode_bitmanip[cursor+1],
					dout_utf8_encode_bitmanip[cursor+2], dout_utf8_encode_bitmanip[cursor+3]);
			assert(dout_utf8_encode_reference[cursor] == dout_utf8_encode_bitmanip[cursor]);
			assert(dout_utf8_encode_reference[cursor+1] == dout_utf8_encode_bitmanip[cursor+1]);
			assert(dout_utf8_encode_reference[cursor+2] == dout_utf8_encode_bitmanip[cursor+2]);
			assert(dout_utf8_encode_reference[cursor+3] == dout_utf8_encode_bitmanip[cursor+3]);
			cursor += 4;
		}
	}
#endif

	assert(len_utf8_encode_reference == len_utf8_encode_bitmanip);
	assert(!memcmp(dout_utf8_encode_reference, dout_utf8_encode_bitmanip, sizeof(len_utf8_encode_bitmanip)));

	TEST(utf8_decode_reference, NUM, {
		len_utf8_decode_reference = utf8_decode_reference(dout_utf8_encode_reference,
				dout_utf8_decode_reference, len_utf8_encode_reference);
	});

	assert(len_utf8_decode_reference == NUM);
	assert(!memcmp(din, dout_utf8_decode_reference, sizeof(din)));

	TEST(utf8_decode_bitmanip, NUM, {
		len_utf8_decode_bitmanip = utf8_decode_bitmanip(dout_utf8_encode_bitmanip,
				dout_utf8_decode_bitmanip, len_utf8_encode_bitmanip);
	});

	assert(len_utf8_decode_reference == len_utf8_decode_bitmanip);
	assert(!memcmp(dout_utf8_decode_reference, dout_utf8_decode_bitmanip, sizeof(din)));

	printf("\n%s\n", buffer);

	return 0;
}
