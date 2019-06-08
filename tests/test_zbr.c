uint64_t test_zbr(uint64_t *argp, int argc)
{
	uint64_t cksum = 123456789LL;

	for (int i = 0; i < argc; i++) {
		cksum = _rv_crc32_b(cksum ^ argp[i]);
		cksum = _rv_crc32_h(cksum ^ argp[i]);
		cksum = _rv_crc32_w(cksum ^ argp[i]);
		cksum = _rv_crc32_d(cksum ^ argp[i]);
		cksum = _rv_crc32c_b(cksum ^ argp[i]);
		cksum = _rv_crc32c_h(cksum ^ argp[i]);
		cksum = _rv_crc32c_w(cksum ^ argp[i]);
		cksum = _rv_crc32c_d(cksum ^ argp[i]);
	}

	return cksum;
}
