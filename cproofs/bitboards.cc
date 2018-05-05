#include "common.h"

void print(uint64_t x[64], bool show_original = true)
{
	for (int i = 0; i < 8; i++) {
		if (show_original) {
			for (int j = 0; j < 8; j++) {
				printf(" %2d", 63 - 7 + j - 8*i);
			}
			printf("    ");
		}
		for (int j = 0; j < 8; j++) {
			for (int k = 0;; k++) {
				assert(k < 64);
				if (x[k] != (uint64_t(1) <<(63 - 7 + j - 8*i)))
					continue;
				printf(" %2d", k);
				break;
			}
		}
		printf("\n");
	}
}

int main()
{
	uint64_t x[64], y[64];

	for (int i = 0; i < 64; i++)
		x[i] = uint64_t(1) << i;
	
	printf("Original:\n");
	print(x);

	// ----------------------------------------

	for (int i = 0; i < 64; i++) {
		y[i] = rv64b::gzip(x[i], 62);
		y[i] = rv64b::gzip(y[i], 62);
		y[i] = rv64b::gzip(y[i], 62);
	}

	printf("\nTranspose:\n");
	print(y);

	// ----------------------------------------

	for (int i = 0; i < 64; i++) {
		y[i] = rv64b::gzip(x[i], 14);
		y[i] = rv64b::gzip(y[i], 28);
		y[i] = rv64b::gzip(y[i], 56);
	}

	printf("\nTranspose (alt):\n");
	print(y);

	// ----------------------------------------

	for (int i = 0; i < 64; i++)
		y[i] = rv64b::grev(x[i], 63);

	printf("\nRotate 180:\n");
	print(y);

	// ----------------------------------------

	for (int i = 0; i < 64; i++)
		y[i] = rv64b::grev(x[i], 7);

	printf("\nFlip horizontal:\n");
	print(y);

	// ----------------------------------------

	for (int i = 0; i < 64; i++)
		y[i] = rv64b::grev(x[i], 56);

	printf("\nFlip vertical:\n");
	print(y);

	// ----------------------------------------

	for (int i = 0; i < 64; i++) {
		y[i] = rv64b::grev(x[i], 56);
		y[i] = rv64b::gzip(y[i], 62);
		y[i] = rv64b::gzip(y[i], 62);
		y[i] = rv64b::gzip(y[i], 62);
	}

	printf("\nRotate left:\n");
	print(y);

	// ----------------------------------------

	for (int i = 0; i < 64; i++) {
		y[i] = rv64b::grev(x[i], 7);
		y[i] = rv64b::gzip(y[i], 62);
		y[i] = rv64b::gzip(y[i], 62);
		y[i] = rv64b::gzip(y[i], 62);
	}

	printf("\nRotate right:\n");
	print(y);

	// ----------------------------------------

	printf("\n===============================\n");
	printf("Original:\n");
	print(x, false);

	for (int i = 0; i < 64; i++)
		y[i] = rv64b::gzip(x[i], 62);

	printf("\nzip\n");
	print(y, false);

	for (int i = 0; i < 64; i++)
		y[i] = rv64b::gzip(y[i], 62);

	printf("\nzip\n");
	print(y, false);

	for (int i = 0; i < 64; i++)
		y[i] = rv64b::gzip(y[i], 62);

	printf("\nzip\n");
	print(y, false);

	// ----------------------------------------

	printf("\n===============================\n");
	printf("Original:\n");
	print(x, false);

	for (int i = 0; i < 64; i++)
		y[i] = rv64b::gzip(x[i], 14);

	printf("\nzip.h\n");
	print(y, false);

	for (int i = 0; i < 64; i++)
		y[i] = rv64b::gzip(y[i], 28);

	printf("\nzip2.w\n");
	print(y, false);

	for (int i = 0; i < 64; i++)
		y[i] = rv64b::gzip(y[i], 56);

	printf("\nzip4\n");
	print(y, false);

	// ----------------------------------------

	return 0;
}
