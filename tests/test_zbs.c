long test_zbs(uint64_t *argp, int argc)
{
	long cksum = 123456789LL;
#define CK(_expr) do { cksum = _rv_crc32c_d(cksum ^ (_expr)); } while (0)

	for (int i = 0; i < argc; i++)
	{
		CK(_rv64_sbset(argp[i], 1));
		CK(_rv64_sbset(argp[i], 16));
		CK(_rv64_sbset(argp[i], 24));
		CK(_rv64_sbset(argp[i], 32));
		CK(_rv64_sbset(argp[i], 48));

		CK(_rv64_sbclr(argp[i], 1));
		CK(_rv64_sbclr(argp[i], 16));
		CK(_rv64_sbclr(argp[i], 24));
		CK(_rv64_sbclr(argp[i], 32));
		CK(_rv64_sbclr(argp[i], 48));

		CK(_rv64_sbinv(argp[i], 1));
		CK(_rv64_sbinv(argp[i], 16));
		CK(_rv64_sbinv(argp[i], 24));
		CK(_rv64_sbinv(argp[i], 32));
		CK(_rv64_sbinv(argp[i], 48));

		CK(_rv64_sbext(argp[i], 1));
		CK(_rv64_sbext(argp[i], 16));
		CK(_rv64_sbext(argp[i], 24));
		CK(_rv64_sbext(argp[i], 32));
		CK(_rv64_sbext(argp[i], 48));

		CK(_rv32_sbset(argp[i], 1));
		CK(_rv32_sbset(argp[i], 16));
		CK(_rv32_sbset(argp[i], 24));
		CK(_rv32_sbset(argp[i], 31));

		CK(_rv32_sbclr(argp[i], 1));
		CK(_rv32_sbclr(argp[i], 16));
		CK(_rv32_sbclr(argp[i], 24));
		CK(_rv32_sbclr(argp[i], 31));

		CK(_rv32_sbinv(argp[i], 1));
		CK(_rv32_sbinv(argp[i], 16));
		CK(_rv32_sbinv(argp[i], 24));
		CK(_rv32_sbinv(argp[i], 31));

		CK(_rv32_sbext(argp[i], 1));
		CK(_rv32_sbext(argp[i], 16));
		CK(_rv32_sbext(argp[i], 24));
		CK(_rv32_sbext(argp[i], 31));
	}

	for (int i = 0; i < argc; i++)
	for (int j = 0; j < argc; j++)
	{
		CK(_rv64_sbset(argp[i], argp[j]));
		CK(_rv64_sbclr(argp[i], argp[j]));
		CK(_rv64_sbinv(argp[i], argp[j]));
		CK(_rv64_sbext(argp[i], argp[j]));

		CK(_rv32_sbset(argp[i], argp[j]));
		CK(_rv32_sbclr(argp[i], argp[j]));
		CK(_rv32_sbinv(argp[i], argp[j]));
		CK(_rv32_sbext(argp[i], argp[j]));
	}

	return cksum;
}
