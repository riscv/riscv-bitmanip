long test_zbe(uint64_t *argp, int argc)
{
	long cksum = 123456789LL;
#define CK(_expr) do { cksum = _rv_crc32c_d(cksum ^ (_expr)); } while (0)

	for (int i = 0; i < argc; i++)
	for (int j = 0; j < argc; j++)
	{
		CK(_rv64_bext(argp[i], argp[j]));
		CK(_rv64_bdep(argp[i], argp[j]));

		CK(_rv32_bext(argp[i], argp[j]));
		CK(_rv32_bdep(argp[i], argp[j]));
	}

	return cksum;
}
