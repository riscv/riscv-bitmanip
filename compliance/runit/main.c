#define VERBOSE 0
#define KEEP_RUNNING 0
#include <stdio.h>

#if __riscv_xlen == 32
#include "tests32.h"
#endif

#if __riscv_xlen == 64
#include "tests64.h"
#endif

#if VERBOSE

int check(uint32_t *s, uint32_t *r, int n)
{
	int errcnt = 0;
	while (n--) {
		printf("SIG=%08x REF=%08x %s\n", (int)*s, (int)*r, *s == *r ? " OK" : " ERROR");
		errcnt += *s != *r;
		s++, r++;
	}
	return errcnt;
}

#define RUNTEST(_name) if (KEEP_RUNNING || !errcnt) { \
  printf("--- %s ---\n", #_name); testcode_##_name(); \
  errcnt += check(signature_##_name, reference_##_name, sizeof(reference_##_name)/4); }

#else

int check(uint32_t *s, uint32_t *r, int n)
{
	int errcnt = 0;
	while (n--) errcnt += (*(s++) != *(r++));
	printf("%s\n", errcnt ? "ERROR" : "OK");
	return errcnt;
}

#define RUNTEST(_name) if (KEEP_RUNNING || !errcnt) { \
  printf("%-17s", #_name); testcode_##_name(); \
  errcnt += check(signature_##_name, reference_##_name, sizeof(reference_##_name)/4); }

#endif

int main()
{
	int errcnt = 0;

	printf("Hello World!\n");

	RUN_ALL_TESTS

	printf("*** %s ***\n", errcnt ? "FAIL" : "PASS");

	return errcnt != 0;
}
