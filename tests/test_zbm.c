long test_zbm(uint64_t *argp, int argc)
{
	long cksum = 123456789LL;
#define CK(_expr) do { cksum = _rv_crc32c_d(cksum ^ (_expr)); } while (0)

	for (int i = 0; i < argc; i++)
	{
		CK(_rv64_bmatflip(argp[i]));
	}

	for (int i = 0; i < argc; i++)
	for (int j = 0; j < argc; j++)
	{
		CK(_rv64_bmator(argp[i], argp[j]));
		CK(_rv64_bmatxor(argp[i], argp[j]));
	}

	return cksum;
}
