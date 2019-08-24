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
	"t0", "t1", "t2", "t3", "t4", "t5",
	"a0", "a1", "a2", "a3", "a4", "a5", "a6", "a8",
	"s0", "s1", "s2", "s3", "s4", "s5", "s6", "s8", "s9", "s10", "s11"
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
	/* Algorithm "xor" from p. 4 of Marsaglia, "Xorshift RNGs" */
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
		cmd += regargs[i] ? stringf(",%s", regs[i+1].c_str()) : stringf(",%d", int(args[i]));
	testcode[op].push_back(cmd);

#ifdef RV32
	testcode[op].push_back(stringf("    sw %s,0(t6)", regs[0].c_str()));
	testcode[op].push_back(stringf("    addi t6,t6,4"));
#endif
#ifdef RV64
	testcode[op].push_back(stringf("    sd %s,0(t6)", regs[0].c_str()));
	testcode[op].push_back(stringf("    addi t6,t6,8"));
#endif

	testdata[op].push_back(rd);
}

#define OP2(_insn)                                                   \
if (op == #_insn) {                                                  \
	if (nargs != 2) abort();                                     \
	if (!regargs[0]) abort();                                    \
	if (!regargs[1]) abort();                                    \
	rd = _insn(args[0], args[1]);                                \
	add_op();                                                    \
}

int main()
{
	char buffer[1024];
	while (fgets(buffer, 1024, stdin))
	{
		op = strtok(buffer, " \t\n");
		nargs = 0;

		while (nargs < 3) {
			char *a = strtok(NULL, " \t\n");
			if (a == NULL) break;
			regargs[nargs] = a[0] == '0' && a[1] == 'x';
			args[nargs++] = strtoll(a, NULL, 0);
		}

		OP2(andn)
		OP2(orn)
		OP2(xnor)
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
		testname += "-01";

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
		for (auto v : testdata[op])
			fprintf(f, "%016lx\n", long(v));
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
		fprintf(f, "    la t6,test_results\n");
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
