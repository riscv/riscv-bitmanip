long test_stdc(uint64_t *argp, int argc)
{
	long cksum = 123456789LL;
#define CK(_expr) do { cksum = _rv_crc32c_d(cksum ^ (_expr)); } while (0)

	for (int i = 0; i < argc; i++)
	for (int j = 0; j < argc; j++)
	{
		int mask32 = 0x1f;
		int mask64 = 0x3f;
		unsigned int di = argp[i];
		unsigned long dl = argp[i];
		// rolw, rorw, rol, ror
		CK((di << (j & mask32)) | (di >> (-j & mask32)));
		CK((di >> (j & mask32)) | (di << (-j & mask32)));
		CK((dl << (j & mask64)) | (dl >> (-j & mask64)));
		CK((dl >> (j & mask64)) | (dl << (-j & mask64)));
	}

	return cksum;
}
