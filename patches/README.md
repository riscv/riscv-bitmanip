## Building tools with draft B-extension instructions support

Make sure your current user can write to `/opt/riscv64b`, then run:

```
bash binutils-build.sh
bash gcc-build.sh
```

This will also install `<rvintrin.h>`. Testing the tools:

```
bash binutils-demo.sh
bash gcc-demo.sh
```

Building a more complete environment, including libc (newlib) and spike (isa sim):

```
bash newlib-build.sh
bash spike-build.sh
```

Testing the environment:

```
bash spike-demo.sh
```

Running B-extension tests:

```
cd ../tests
bash run.sh
```
