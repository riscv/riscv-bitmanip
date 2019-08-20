These are 32-bit and 64-bit MulDiv cores from
[rocket-chip](https://github.com/chipsalliance/rocket-chip) for size
comparison. The following configurations were used to generate these cores.

```
class MulDivConfig64 extends Config(new WithFastMulDiv ++ new DefaultConfig)
class MulDivConfig32 extends Config(new WithRV32 ++ new WithFastMulDiv ++ new DefaultConfig)
```
