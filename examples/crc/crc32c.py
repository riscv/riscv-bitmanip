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

P = 0x11edc6f41
print("P  0x%X" % P)
print("mu 0x%X" % (polydiv(1<<64, P)))
print("mu1 0x%X" % (polydiv(1<<64, P) >> 1))

print("k1  0x%X" % (polymod(1<<128, P)))
print("k2  0x%X" % (polymod(1<< 96, P)))
print("k3  0x%X" % (polymod(1<< 64, P)))

#################################################

def rev32(a):
    return int('{:032b}'.format(a & 0xFFFFFFFF)[::-1], 2)

def crc32c(a, n):
    a &= 0xFFFFFFFF
    for i in range(n):
        a <<= 1
        if a >> 32:
            a ^= P
    return a

data = list(b"123456789")
state = 0xFFFFFFFF

for b in data:
    state ^= rev32(b)
    state = crc32c(state, 8)

state ^= 0xFFFFFFFF
state = rev32(state)

print("check 0x%08x" % state)
assert state == 0xe3069283

#################################################

print()
print("uint32_t crc32c_table[256] = {")

for i in range(256):
    if i % 8 == 0:
        print("    ", end="")
    print("0x%08x" % rev32(crc32c(rev32(i), 8)), end="")
    if i % 8 != 7:
        print(", ", end="")
    else:
        print("," if i != 255 else "")

print("};")
