#!/usr/bin/env python3

from BitVector import BitVector

numbers = [
    0xed6ec1f3fc25004e,
    0x5007e519477777ff,
    0xb62987e4fdc1917e,
    0xa305727b2936f98f,
    0x9468618b03d2151f,
    0xfd71d1a69de07e74,
    0xb5b8f96f00ca4cc3,
    0x88da54c054759441,
    0x2783ccb8dcd01a7c,
    0x8eae85ca44a20054,
    0x58a4baad8dc616cd,
    0xd52d7a7a01e70678,
    0x3520c48ab58fef90,
    0x0f9414fe1ebbd107,
    0xa61f7ebbe0f89ad9,
    0x4101f312a1f21323,
    0xb4de0ee77a55d8fa,
    0xe9cbbe6ceac8c874,
    0xfbfff2d7ff45e220,
    0xba8f264812088fdc
]

for a in numbers:
    for b in numbers:
        a_bv = BitVector(intVal=a)
        b_bv = BitVector(intVal=b)
        ab = int(a_bv.gf_multiply(b_bv))
        ab_hi = ab >> 64
        ab_lo = ab & 0xffffffffffffffff
        print("check(0x%016xLL, 0x%016xLL, 0x%016xLL, 0x%016xLL);" % (a, b, ab_hi, ab_lo))
