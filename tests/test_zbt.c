long test_zbt(uint64_t *argp, int argc)
{
	long cksum = 123456789LL;
#define CK(_expr) do { cksum = _rv_crc32c_d(cksum ^ (_expr)); } while (0)

	for (int i = 0; i < argc; i++)
	for (int j = 0; j < argc; j++)
	{
		CK(_rv64_fsr(argp[i], argp[j], 1));
		CK(_rv64_fsr(argp[i], argp[j], 7));
		CK(_rv64_fsr(argp[i], argp[j], 28));
		CK(_rv64_fsr(argp[i], argp[j], 31));
		CK(_rv64_fsr(argp[i], argp[j], 52));
		CK(_rv64_fsr(argp[i], argp[j], 63));

		CK(_rv32_fsr(argp[i], argp[j], 1));
		CK(_rv32_fsr(argp[i], argp[j], 7));
		CK(_rv32_fsr(argp[i], argp[j], 28));
		CK(_rv32_fsr(argp[i], argp[j], 31));
	}

	for (int i = 0; i < argc; i++)
	for (int j = 0; j < argc; j++)
	for (int k = 0; k < argc && k < 50; k++)
	{
		CK(_rv64_fsl(argp[i], argp[j], argp[k]));
		CK(_rv64_fsr(argp[i], argp[j], argp[k]));

		CK(_rv32_fsl(argp[i], argp[j], argp[k]));
		CK(_rv32_fsr(argp[i], argp[j], argp[k]));

		CK(_rv_cmix(argp[i], argp[j], argp[k]));
		CK(_rv_cmov(argp[i], argp[j], argp[k]));
	}

	return cksum;
}
