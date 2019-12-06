#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <map>
#include <set>
#include <vector>
#include <string>

#include "../cproofs/common.h"

#ifdef RV32
using namespace rv32b;
#endif

#ifdef RV64
using namespace rv64b;
#endif

using std::map;
using std::set;
using std::vector;
using std::string;

map<string, vector<string>> testcode;
map<string, vector<uint_xlen_t>> testdata;

string op;
uint_xlen_t rd;
uint_xlen_t args[3];
bool regargs[3];
int nargs;

vector<string> regs = {
	"t0", "t1", "t2", "t3", "t4", "t5", "t6",
	"a0",/*a1*/ "a2", "a3", "a4", "a5", "a6", "a7",
	"s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11"
};

std::string vstringf(const char *fmt, va_list ap)
{
	string string;
	char *str = NULL;

#if defined(_WIN32 )|| defined(__CYGWIN__)
	int sz = 64, rc;
	while (1) {
		va_list apc;
		va_copy(apc, ap);
		str = (char *)realloc(str, sz);
		rc = vsnprintf(str, sz, fmt, apc);
		va_end(apc);
		if (rc >= 0 && rc < sz)
			break;
		sz *= 2;
	}
#else
	if (vasprintf(&str, fmt, ap) < 0)
		str = NULL;
#endif

	if (str != NULL) {
		string = str;
		free(str);
	}

	return string;
}

int sext_imm(int imm)
{
	return imm << (8*sizeof(int)-12) >> (8*sizeof(int)-12);
}

string stringf(const char *fmt, ...)
{
	std::string string;
	va_list ap;

	va_start(ap, fmt);
	string = vstringf(fmt, ap);
	va_end(ap);

	return string;
}

uint32_t xorshift32(uint32_t n)
{
	static uint32_t x = 12345678;
	x ^= x << 13;
	x ^= x >> 17;
	x ^= x << 5;
	return x % n;
}

void shuffle_regs()
{
	for (int i = 0; i < int(regs.size()); i++) {
		int j = xorshift32(regs.size());
		if (i != j) std::swap(regs[i], regs[j]);
	}
}

void add_op()
{
	shuffle_regs();

	for (int i = 0; i < nargs; i++)
		if (regargs[i]) {
#ifdef RV32
			testcode[op].push_back(stringf("    li %s, 0x%08x", regs[i+1].c_str(), int(args[i])));
#endif
#ifdef RV64
			testcode[op].push_back(stringf("    li %s, 0x%016lx", regs[i+1].c_str(), long(args[i])));
#endif
		}

	string cmd = stringf("    %s %s", op.c_str(), regs[0].c_str());
	for (int i = 0; i < nargs; i++)
		cmd += regargs[i] ? stringf(",%s", regs[i+1].c_str()) : stringf(",%d", int(sext_imm(args[i])));
	testcode[op].push_back(cmd);

#ifdef RV32
	testcode[op].push_back(stringf("    sw %s,%d(a1)", regs[0].c_str(), 4*testdata[op].size()));
#endif
#ifdef RV64
	testcode[op].push_back(stringf("    sd %s,%d(a1)", regs[0].c_str(), 8*testdata[op].size()));
#endif

	testdata[op].push_back(rd);
}

#define OP1(_insn)                              \
if (op == #_insn) {                             \
  if (nargs != 1) abort();                      \
  if (!regargs[0]) abort();                     \
  rd = _insn(args[0]);                          \
  add_op();                                     \
  continue;                                     \
}

#define OP1F(_insn, _func)                      \
if (op == #_insn) {                             \
  if (nargs != 1) abort();                      \
  if (!regargs[0]) abort();                     \
  rd = _func(args[0]);                          \
  add_op();                                     \
  continue;                                     \
}

#define OP1W(_insn)                             \
if (op == #_insn "w") {                         \
  if (nargs != 1) abort();                      \
  if (!regargs[0]) abort();                     \
  rd = int32_t(rv32b::_insn(args[0]));          \
  add_op();                                     \
  continue;                                     \
}

#define OP2(_insn)                              \
if (op == #_insn) {                             \
  if (nargs != 2) abort();                      \
  if (!regargs[0]) abort();                     \
  if (!regargs[1]) abort();                     \
  rd = _insn(args[0], args[1]);                 \
  add_op();                                     \
  continue;                                     \
}

#define OP2F(_insn, _func)                      \
if (op == #_insn) {                             \
  if (nargs != 2) abort();                      \
  if (!regargs[0]) abort();                     \
  if (!regargs[1]) abort();                     \
  rd = _func(args[0], args[1]);                 \
  add_op();                                     \
  continue;                                     \
}

#define OP2W(_insn)                             \
if (op == #_insn "w") {                         \
  if (nargs != 2) abort();                      \
  if (!regargs[0]) abort();                     \
  if (!regargs[1]) abort();                     \
  rd = int32_t(rv32b::_insn(args[0], args[1])); \
  add_op();                                     \
  continue;                                     \
}

#define OP2I(_insn)                             \
if (op == #_insn "i") {                         \
  if (nargs != 2) abort();                      \
  if (!regargs[0]) abort();                     \
  if (regargs[1]) abort();                      \
  rd = _insn(args[0], sext_imm(args[1])); \
  add_op();                                     \
  continue;                                     \
}

#define OP2IF(_insn, _func)                     \
if (op == #_insn) {                             \
  if (nargs != 2) abort();                      \
  if (!regargs[0]) abort();                     \
  if (regargs[1]) abort();                      \
  rd = _func(args[0], sext_imm(args[1])); \
  add_op();                                     \
  continue;                                     \
}

#define OP2IW(_insn)                            \
if (op == #_insn "iw") {                        \
  if (nargs != 2) abort();                      \
  if (!regargs[0]) abort();                     \
  if (regargs[1]) abort();                      \
  rd = int32_t(rv32b::_insn(args[0], sext_imm(args[1]))); \
  add_op();                                     \
  continue;                                     \
}

#define OP3(_insn, A, B, C)                     \
if (op == #_insn) {                             \
  if (nargs != 3) abort();                      \
  if (!regargs[A]) abort();                     \
  if (!regargs[B]) abort();                     \
  if (!regargs[C]) abort();                     \
  rd = _insn(args[A], args[B], args[C]);        \
  add_op();                                     \
  continue;                                     \
}

#define OP3I(_insn, A, B, C)                    \
if (op == #_insn "i") {                         \
  if (nargs != 3) abort();                      \
  if (!regargs[A]) abort();                     \
  if (regargs[B]) abort();                      \
  if (!regargs[C]) abort();                     \
  rd = _insn(args[A], sext_imm(args[B]), args[C]); \
  add_op();                                     \
  continue;                                     \
}

#define OP3W(_insn, A, B, C)                    \
if (op == #_insn "w") {                         \
  if (nargs != 3) abort();                      \
  if (!regargs[A]) abort();                     \
  if (!regargs[B]) abort();                     \
  if (!regargs[C]) abort();                     \
  rd = int32_t(rv32b::_insn(args[A], args[B], args[C])); \
  add_op();                                     \
  continue;                                     \
}

#define OP3IW(_insn, A, B, C)                   \
if (op == #_insn "iw") {                        \
  if (nargs != 3) abort();                      \
  if (!regargs[A]) abort();                     \
  if (regargs[B]) abort();                      \
  if (!regargs[C]) abort();                     \
  rd = int32_t(rv32b::_insn(args[A], sext_imm(args[B]), args[C])); \
  add_op();                                     \
  continue;                                     \
}

int main()
{
	char buffer[1024];
	while (fgets(buffer, 1024, stdin))
	{
		char *op_p = strtok(buffer, " \t\n");
		nargs = 0;

		if (op_p == NULL || *op_p == '#')
			continue;

		while (nargs < 3) {
			char *a = strtok(NULL, " \t\n");
			if (a == NULL) break;
			if (*a == '=') {
				regargs[nargs] = false;
				args[nargs++] = strtoll(a+1, NULL, 0);
			} else {
				regargs[nargs] = true;
				args[nargs++] = strtoull(a, NULL, 16);
			}
		}

		op_p = strtok(op_p, ",");

		while (op_p != NULL)
		{
			op = op_p;
			op_p = strtok(NULL, ",");

			OP1(clz)
			OP1(ctz)
			OP1(pcnt)
			OP1(bmatflip)

			OP1W(clz)
			OP1W(ctz)
			OP1W(pcnt)

			OP1F(sext.b, sextb)
			OP1F(sext.h, sexth)

			OP1F(crc32.b, crc32_b)
			OP1F(crc32.h, crc32_h)
			OP1F(crc32.w, crc32_w)
			OP1F(crc32c.b, crc32c_b)
			OP1F(crc32c.h, crc32c_h)
			OP1F(crc32c.w, crc32c_w)
		#ifdef RV64
			OP1F(crc32.d, crc32_d)
			OP1F(crc32c.d, crc32c_d)
		#endif

			OP2(andn)
			OP2(orn)
			OP2(xnor)
			OP2(pack)
			OP2(packh)
			OP2(packu)
			OP2(bfp)
			OP2(min)
			OP2(minu)
			OP2(max)
			OP2(maxu)
			OP2(sbset)
			OP2(sbclr)
			OP2(sbinv)
			OP2(sbext)
			// OP2(sll)
			// OP2(srl)
			// OP2(sra)
			OP2(slo)
			OP2(sro)
			OP2(rol)
			OP2(ror)
			OP2(gorc)
			OP2(grev)
			OP2(shfl)
			OP2(unshfl)
			OP2(bext)
			OP2(bdep)
			OP2(clmul)
			OP2(clmulh)
			OP2(clmulr)
			OP2(bmator)
			OP2(bmatxor)

			OP2W(pack)
			OP2W(packu)
			OP2W(bfp)
			OP2W(sbset)
			OP2W(sbclr)
			OP2W(sbinv)
			OP2W(sbext)
			// OP2W(sll)
			// OP2W(srl)
			// OP2W(sra)
			OP2W(slo)
			OP2W(sro)
			OP2W(rol)
			OP2W(ror)
			OP2W(gorc)
			OP2W(grev)
			OP2W(shfl)
			OP2W(unshfl)
			OP2W(bext)
			OP2W(bdep)
			OP2W(clmul)
			OP2W(clmulh)
			OP2W(clmulr)

			OP2I(gorc)
			OP2I(grev)
			OP2I(slo)
			OP2I(sro)
			OP2I(ror)
			OP2I(sbset)
			OP2I(sbclr)
			OP2I(sbinv)
			OP2I(sbext)
			OP2I(shfl)
			OP2I(unshfl)

			OP2IW(gorc)
			OP2IW(grev)
			OP2IW(slo)
			OP2IW(sro)
			OP2IW(ror)
			OP2IW(sbset)
			OP2IW(sbclr)
			OP2IW(sbinv)

			OP3(fsl, 0, 2, 1)
			OP3(fsr, 0, 2, 1)
			OP3(cmix, 1, 0, 2)
			OP3(cmov, 1, 0, 2)

			OP3I(fsr, 0, 2, 1)

			OP3W(fsl, 0, 2, 1)
			OP3W(fsr, 0, 2, 1)

			OP3IW(fsr, 0, 2, 1)

			OP2F(addwu, rv64b::addwu)
			OP2F(subwu, rv64b::subwu)
			OP2F(addu.w, rv64b::adduw)
			OP2F(subu.w, rv64b::subuw)

			OP2IF(addiwu, rv64b::addwu)
			OP2IF(slliu.w, rv64b::slliuw)

			printf("> %s\n", op.c_str());
			abort();
		}
	}

	for (auto it : testdata)
	{
		auto op = it.first;
		string testname = "B-";
		for (char c : op) {
			if ('a' <= c && c <= 'z')
				c -= 'a' - 'A';
			testname.push_back(c);
		}

#ifdef RV32
		string filename = stringf("rv32b/references/%s.reference_output", testname.c_str());
		FILE *f = fopen(filename.c_str(), "w");
		for (auto v : testdata[op])
			fprintf(f, "%08x\n", int(v));
		fclose(f);
#endif

#ifdef RV64
		string filename = stringf("rv64b/references/%s.reference_output", testname.c_str());
		FILE *f = fopen(filename.c_str(), "w");
		for (auto v : testdata[op]) {
			fprintf(f, "%08x\n", int(v));
			fprintf(f, "%08x\n", int(v >> 32));
		}
		fclose(f);
#endif

#ifdef RV32
		filename = stringf("rv32b/src/%s.S", testname.c_str());
#endif
#ifdef RV64
		filename = stringf("rv64b/src/%s.S", testname.c_str());
#endif
		f = fopen(filename.c_str(), "w");

		fprintf(f, "#include \"compliance_test.h\"\n");
		fprintf(f, "#include \"compliance_io.h\"\n");
		fprintf(f, "#include \"test_macros.h\"\n");
		fprintf(f, "\n");
		fprintf(f, "RV_COMPLIANCE_RV32M\n");
		fprintf(f, "\n");
		fprintf(f, "RV_COMPLIANCE_CODE_BEGIN\n");
		fprintf(f, "    la a1,test_results\n");
		for (auto s : testcode[op])
			fprintf(f, "%s\n", s.c_str());
		fprintf(f, "    RV_COMPLIANCE_HALT\n");
		fprintf(f, "RV_COMPLIANCE_CODE_END\n");
		fprintf(f, "\n");
		fprintf(f, ".data\n");
		fprintf(f, "RV_COMPLIANCE_DATA_BEGIN\n");
		fprintf(f, "test_results:\n");
#ifdef RV32
		fprintf(f, ".fill %d,4,-1\n", int(testdata[op].size()));
#endif
#ifdef RV64
		fprintf(f, ".fill %d,8,-1\n", int(testdata[op].size()));
#endif
		fprintf(f, "RV_COMPLIANCE_DATA_END\n");

		fclose(f);
	}
}
