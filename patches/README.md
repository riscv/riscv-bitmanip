## Building tools with draft B-extension instructions support

Make sure your current user can write to `/opt/riscv64b`, then run:

```
bash binutils-build.sh
bash gcc-build.sh
bash newlib-build.sh
```

This will also install `<rvintrin.h>`. Testing the tools:

```
bash xorshift.sh
```
