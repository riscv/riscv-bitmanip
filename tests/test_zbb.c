long test_zbb(uint64_t *argp, int argc)
{
	long cksum = 123456789LL;
#define CK(_expr) do { cksum = _rv_crc32c_d(cksum ^ (_expr)); } while (0)

	for (int i = 0; i < argc; i++)
	{
		CK(_rv32_clz(argp[i]));
		CK(_rv32_ctz(argp[i]));
		CK(_rv32_pcnt(argp[i]));

		CK(_rv32_grev(argp[i], -1));
		CK(_rv32_grev(argp[i], -8));

		CK(_rv32_slo(argp[i], 2));
		CK(_rv32_sro(argp[i], 3));
		CK(_rv32_slo(argp[i], 5));
		CK(_rv32_sro(argp[i], 7));

		CK(_rv32_rol(argp[i], 2));
		CK(_rv32_ror(argp[i], 3));
		CK(_rv32_rol(argp[i], 5));
		CK(_rv32_ror(argp[i], 7));

		CK(_rv64_clz(argp[i]));
		CK(_rv64_ctz(argp[i]));
		CK(_rv64_pcnt(argp[i]));

		CK(_rv64_grev(argp[i], -1));
		CK(_rv64_grev(argp[i], -8));

		CK(_rv64_slo(argp[i], 2));
		CK(_rv64_sro(argp[i], 3));
		CK(_rv64_slo(argp[i], 5));
		CK(_rv64_sro(argp[i], 7));

		CK(_rv64_rol(argp[i], 2));
		CK(_rv64_ror(argp[i], 3));
		CK(_rv64_rol(argp[i], 5));
		CK(_rv64_ror(argp[i], 7));
	}

	for (int i = 0; i < argc; i++)
	for (int j = 0; j < argc; j++)
	{
		CK(_rv32_pack(argp[i], argp[j]));
		CK(_rv64_pack(argp[i], argp[j]));

		CK(_rv32_slo(argp[i], argp[j]));
		CK(_rv32_sro(argp[i], argp[j]));

		CK(_rv32_min(argp[i], argp[j]));
		CK(_rv32_max(argp[i], argp[j]));

		CK(_rv32_minu(argp[i], argp[j]));
		CK(_rv32_maxu(argp[i], argp[j]));

		CK(_rv32_rol(argp[i], argp[j]));
		CK(_rv32_ror(argp[i], argp[j]));

		CK(_rv64_slo(argp[i], argp[j]));
		CK(_rv64_sro(argp[i], argp[j]));

		CK(_rv64_min(argp[i], argp[j]));
		CK(_rv64_max(argp[i], argp[j]));

		CK(_rv64_minu(argp[i], argp[j]));
		CK(_rv64_maxu(argp[i], argp[j]));

		CK(_rv64_rol(argp[i], argp[j]));
		CK(_rv64_ror(argp[i], argp[j]));

		CK(_rv_andn(argp[i], argp[j]));
		CK(_rv_orn (argp[i], argp[j]));
		CK(_rv_xnor(argp[i], argp[j]));
	}

	return cksum;
}
