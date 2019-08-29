long test_zbp(uint64_t *argp, int argc)
{
	long cksum = 123456789LL;
#define CK(_expr) do { cksum = _rv_crc32c_d(cksum ^ (_expr)); } while (0)

	for (int i = 0; i < argc; i++)
	{
		CK(_rv64_gorc(argp[i], 1));
		CK(_rv64_gorc(argp[i], 2));
		CK(_rv64_gorc(argp[i], 4));
		CK(_rv64_gorc(argp[i], 8));
		CK(_rv64_gorc(argp[i], 16));
		CK(_rv64_gorc(argp[i], 32));

		CK(_rv64_gorc(argp[i], -1));
		CK(_rv64_gorc(argp[i], -4));

		CK(_rv64_grev(argp[i], 1));
		CK(_rv64_grev(argp[i], 2));
		CK(_rv64_grev(argp[i], 4));
		CK(_rv64_grev(argp[i], 8));
		CK(_rv64_grev(argp[i], 16));
		CK(_rv64_grev(argp[i], 32));

		CK(_rv64_grev(argp[i], -1));
		CK(_rv64_grev(argp[i], -4));

		CK(_rv64_shfl(argp[i], 1));
		CK(_rv64_shfl(argp[i], 2));
		CK(_rv64_shfl(argp[i], 4));
		CK(_rv64_shfl(argp[i], 8));
		CK(_rv64_shfl(argp[i], 16));

		CK(_rv64_shfl(argp[i], -1));
		CK(_rv64_shfl(argp[i], -4));

		CK(_rv64_unshfl(argp[i], 1));
		CK(_rv64_unshfl(argp[i], 2));
		CK(_rv64_unshfl(argp[i], 4));
		CK(_rv64_unshfl(argp[i], 8));
		CK(_rv64_unshfl(argp[i], 16));

		CK(_rv64_unshfl(argp[i], -1));
		CK(_rv64_unshfl(argp[i], -4));

		CK(_rv32_gorc(argp[i], 1));
		CK(_rv32_gorc(argp[i], 2));
		CK(_rv32_gorc(argp[i], 4));
		CK(_rv32_gorc(argp[i], 8));
		CK(_rv32_gorc(argp[i], 16));
		CK(_rv32_gorc(argp[i], 32));

		CK(_rv32_gorc(argp[i], -1));
		CK(_rv32_gorc(argp[i], -4));

		CK(_rv32_grev(argp[i], 1));
		CK(_rv32_grev(argp[i], 2));
		CK(_rv32_grev(argp[i], 4));
		CK(_rv32_grev(argp[i], 8));
		CK(_rv32_grev(argp[i], 16));
		CK(_rv32_grev(argp[i], 32));

		CK(_rv32_grev(argp[i], -1));
		CK(_rv32_grev(argp[i], -4));

		CK(_rv32_shfl(argp[i], 1));
		CK(_rv32_shfl(argp[i], 2));
		CK(_rv32_shfl(argp[i], 4));
		CK(_rv32_shfl(argp[i], 8));
		CK(_rv32_shfl(argp[i], 16));

		CK(_rv32_shfl(argp[i], -1));
		CK(_rv32_shfl(argp[i], -4));

		CK(_rv32_unshfl(argp[i], 1));
		CK(_rv32_unshfl(argp[i], 2));
		CK(_rv32_unshfl(argp[i], 4));
		CK(_rv32_unshfl(argp[i], 8));
		CK(_rv32_unshfl(argp[i], 16));

		CK(_rv32_unshfl(argp[i], -1));
		CK(_rv32_unshfl(argp[i], -4));
	}

	for (int i = 0; i < argc; i++)
	for (int j = 0; j < argc; j++)
	{
		CK(_rv64_gorc(argp[i], argp[j]));
		CK(_rv64_grev(argp[i], argp[j]));
		CK(_rv64_shfl(argp[i], argp[j]));
		CK(_rv64_unshfl(argp[i], argp[j]));

		CK(_rv32_gorc(argp[i], argp[j]));
		CK(_rv32_grev(argp[i], argp[j]));
		CK(_rv32_shfl(argp[i], argp[j]));
		CK(_rv32_unshfl(argp[i], argp[j]));
	}

	return cksum;
}
