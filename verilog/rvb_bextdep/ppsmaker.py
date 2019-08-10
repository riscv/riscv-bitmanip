#!/usr/bin/env python3
#
#  Copyright (C) 2017  Clifford Wolf <clifford@clifford.at>
#
#  Permission to use, copy, modify, and/or distribute this software for any
#  purpose with or without fee is hereby granted, provided that the above
#  copyright notice and this permission notice appear in all copies.
#
#  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
#  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
#  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
#  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
#  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
#  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

import sys, getopt, math

modname = "pps"
num_elements = 64
input_width = 1
output_width = 8
input_split = False
output_split = False
simple_chain = False
simple_adder = False
ffstage = False

def usage():
    print("""
python3 ppsmaker.py [options]

    Generate Verilog module for parallel prefix sum.

    -m <modname>
        set name of the generated module

    -n <int>
        number of elements in the input/output vectors
        (this number must be a power of two)

    -i <int>
        bits per element in the input vector

    -o <int>
        bits per element in the output vector

    -I
        create individual input ports per element

    -O
        create individual output ports per element

    -s
        don't generate a parallel structure, just a simple adder chain

    -a
        use simple adder trees instead for carry-save adders

    -f
        add a flip-flop stage in the middle of the data path
""")
    sys.exit(1)

try:
    opts, args = getopt.getopt(sys.argv[1:], "m:n:i:o:IOsaf", [])
except:
    usage()

for o, a in opts:
    if o == "-m":
        modname = a
    elif o == "-n":
        num_elements = int(a)
    elif o == "-i":
        input_width = int(a)
    elif o == "-o":
        width = int(a)
    elif o == "-I":
        input_split = True
    elif o == "-O":
        output_split = True
    elif o == "-s":
        simple_chain = True
    elif o == "-a":
        simple_adder = True
    elif o == "-f":
        ffstage = True
    else:
        usage()

def is_power_of_two(x):
    return (x & (x - 1)) == 0

assert not simple_chain or not simple_adder
assert input_width <= output_width
assert is_power_of_two(num_elements)

stages = int(math.log2(num_elements))

portlist = list()

if ffstage:
    portlist.append("  input clock")
    portlist.append("  input enable")

if input_split:
    for i in range(num_elements):
        portlist.append("  input [%d:0] din%d" % (input_width-1, i))
else:
    portlist.append("  input [%d:0] din" % (num_elements*input_width-1))

if output_split:
    for i in range(num_elements):
        portlist.append("  output [%d:0] dout%d" % (output_width-1, i))
else:
    portlist.append("  output [%d:0] dout" % (num_elements*output_width-1))

def get_input_expr(i):
    w = output_width if simple_adder else 2*output_width
    if input_width < w:
        if input_split:
            return "{%d'b0, din%d}" % (w - input_width, i)
        return "{%d'b0, din[%d +: %d]}" % (w - input_width, i*input_width, input_width)
    else:
        if input_split:
            return "din%d" % i
        return "din[%d +: %d]" % (i*input_width, input_width)

def get_output_expr(i):
    if output_split:
        return "dout%d" % i
    return "dout[%d +: %d]" % (i*output_width, output_width)

print("module %s (" % modname)
print(",\n".join(portlist))
print(");")

if simple_chain:
    for i in range(num_elements):
        if i == 0:
            print("  assign %s = %s;" % (get_output_expr(0), get_input_expr(0)))
        else:
            print("  assign %s = %s + %s;" % (get_output_expr(i), get_input_expr(i), get_output_expr(i-1)))

else:
    def get_add_expr(a, b):
        if not simple_adder:
            return "carry_save_add(%s, %s)" % (a, b)
        return "%s + %s" % (a, b)

    def get_val_expr(a):
        if not simple_adder:
            return "carry_save_get(%s)" % a
        return "%s" % a

    if not simple_adder:
        range_lo = "%d:0" % (output_width-1)
        range_hi = "%d:%d" % (2*output_width-1, output_width)

        print("  function [%d:0] carry_save_add;" % (2*output_width-1))
        print("    input [%d:0] a, b;" % (2*output_width-1))
        print("    reg [%d:0] x, y;" % (output_width-1))
        print("    begin")
        print("      x = a[%s] ^ a[%s] ^ b[%s];" % (range_hi, range_lo, range_lo))
        print("      y = ((a[%s] & a[%s]) | (a[%s] & b[%s]) | (a[%s] & b[%s])) << 1;" %
                (range_hi, range_lo, range_hi, range_lo, range_lo, range_lo))
        print("      carry_save_add[%s] = x ^ y ^ b[%s];" % (range_lo, range_hi))
        print("      carry_save_add[%s] = ((x & y) | (x & b[%s]) | (y & b[%s])) << 1;" % (range_hi, range_hi, range_hi))
        print("    end")
        print("  endfunction")
        print("  function [%d:0] carry_save_get;" % (output_width-1))
        print("    input [%d:0] a;" % (2*output_width-1))
        print("    begin")
        print("      carry_save_get = a[%d:0] + a[%d:%d];" % (output_width-1, 2*output_width-1, output_width))
        print("    end")
        print("  endfunction")

    state = [None] * num_elements
    state_type = [None] * num_elements
    state_reg = [None] * num_elements

    def make_wire(element_index, stage, expr, stype):
        n = "e%ds%d" % (element_index, stage)
        w = output_width if simple_adder else 2*output_width
        print("  wire [%d:0] %s = %s;" % (w-1, n, expr))
        state[element_index] = n
        state_type[element_index] = stype

    def get_reg(element_index):
        if not ffstage:
            return state[element_index]

        if state_type[element_index] not in ("i", "f"):
            return state[element_index]

        if state_reg[element_index] is not None:
            return state_reg[element_index]

        n = "r%d" % element_index
        w = output_width if simple_adder else 2*output_width
        print("  reg [%d:0] %s;" % (w-1, n))
        print("  always @(posedge clock) if (enable) %s <= %s;" % (n, state[element_index]))
        state_reg[element_index] = n
        return n

    print("  // inputs")

    for i in range(num_elements):
        make_wire(i, 0, get_input_expr(i), "i")

    print("  // forward pass")

    for stage in range(1, stages+1):
        step = 1 << stage
        half_step = step // 2
        for i in range(step-1, num_elements, step):
            make_wire(i, stage, get_add_expr(state[i], state[i-half_step]), "f")

    print("  // backward pass")

    for stage in range(stages-1, 0, -1):
        stage_index = 2*stages-stage
        step = 1 << stage
        half_step = step // 2
        for i in range(step+half_step-1, num_elements, step):
            make_wire(i, stage_index, get_add_expr(get_reg(i), get_reg(i-half_step)), "b")

    print("  // outputs")

    for i in range(num_elements):
        print("  assign %s = %s;" % (get_output_expr(i), get_val_expr(get_reg(i))))


print("endmodule")

