#!/usr/bin/env python3

def polydiv(dividend, divisor):
    quotient = 0
    while dividend.bit_length() >= divisor.bit_length():
        i = dividend.bit_length() - divisor.bit_length()
        dividend = dividend ^ (divisor << i)
        quotient |= 1 << i
    return quotient

def polymod(dividend, divisor):
    quotient = 0
    while dividend.bit_length() >= divisor.bit_length():
        i = dividend.bit_length() - divisor.bit_length()
        dividend = dividend ^ (divisor << i)
        quotient |= 1 << i
    return dividend

def clmul(a, b):
    product = 0
    while b:
        x = b & ~(b - 1)
        product ^= a * x
        b ^= x
    return product

P = 0x1814141AB
print("P  0x%X" % P)
print("mu 0x%X" % (polydiv(1<<64, P)))
print("mu1 0x%X" % (polydiv(1<<64, P) >> 1))

print("k1  0x%X" % (polymod(1<<128, P)))
print("k2  0x%X" % (polymod(1<< 96, P)))
print("k3  0x%X" % (polymod(1<< 64, P)))

#################################################

def crc32q(a, n):
    a &= 0xFFFFFFFF
    for i in range(n):
        a <<= 1
        if a >> 32:
            a ^= P
    return a

data = list(b"123456789")
state = 0

for b in data:
    state ^= b << 24
    state = crc32q(state, 8)

print("check 0x%08x" % state)
assert state == 0x3010bf7f

#################################################

def clmul32(a, b):
    a &= 0xFFFFFFFF
    b &= 0xFFFFFFFF
    return clmul(a, b) & 0xFFFFFFFF

def clmulr32(a, b):
    a &= 0xFFFFFFFF
    b &= 0xFFFFFFFF
    return clmul(a, b) >> 31

data = list(b"123456789")

while len(data) % 4:
    data = [0] + data

data = [(data[i] << 24) | (data[i+1] << 16) | (data[i+2] << 8) | data[i+3] for i in range(0, len(data), 4)]
state = 0

mu1 = polydiv(1<<64, P) >> 1

for w in data:
    state ^= w
    state = clmulr32(state, mu1)
    state = clmul32(state, P)

print("check 0x%08x" % state)
assert state == 0x3010bf7f

#################################################

print()
print("uint32_t crc32q_table[256] = {")

for i in range(256):
    if i % 8 == 0:
        print("    ", end="")
    print("0x%08x" % crc32q(i << 24, 8), end="")
    if i % 8 != 7:
        print(", ", end="")
    else:
        print("," if i != 255 else "")

print("};")
