## Building tools with draft B-extension instructions support

First make sure your current user can write to `/opt/riscv64b`:

```
sudo mkdir /opt/riscv64b
sudo chown $USER: /opt/riscv64b
```

Then run:

```
bash build-all.sh
```

This builds and installs binutils, gcc, newlib, riscv-pk, and riscv-isa-sim.
It will also install `<rvintrin.h>` and run some simple tests on the tools.

Finally, running the B-extension tests:

```
cd ../tests
bash run.sh
```
