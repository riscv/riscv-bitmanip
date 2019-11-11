Encoding and decoding Variable Length Unary (VLU) integers.
https://github.com/michaeljclark/vlu

Encoding and decoding Little Endian Base 128 (LEB128) integers.
https://en.wikipedia.org/wiki/LEB128

In both cases we assume the integers to fit in the unsigned 56-bit range.

In the benchmark examples we omit returning the size of the encoded and/or
decoded VLU/LEB128 integer, as it is merely an excercise in returning multiple
values and is not really relevant for distinguishing the performance of
different implementations of these encodings.
