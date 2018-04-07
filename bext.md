---
ifdef::study[]
title: XBitmanip Group
subtitle: Bit Manipulation Study
author: Rex McCrary, Steven Braeger
email: rmccrary@amd.com, sbraeger@amd.com
organization: xbitmanip
security: Copyright 2017 
revision: 0.32
date: November 30, 2017
legal: none
logoA: xb.png
logoB: none.png
contributors: Steven Braeger, Rex McCrary, Clifford Wolf
template: 2
preamble: 1
endif::[]

ifdef::spec[]
title: XBitmanip Group
subtitle: Bit Manipulation Draft Spec
author: Rex McCrary, Steven Braeger
email: rmccrary@amd.com, sbraeger@amd.com
organization: xbitmanip
security: Copyright 2017 
revision: 0.32
date: November 30, 2017
legal: none
logoA: xb.png
logoB: none.png
contributors: Steven Braeger, Po-wei Huang, Rex McCrary, Clifford Wolf
template: 2
preamble: 1
endif::[]
...




# Introduction                                                    

## ISA Extension Proposal Scoring Criteria

Any proposed changes to the ISA should be evaluated or scored according to the following criteria.  Proposals which score higher according to the criteria should be considered as higher priority than proposals that score lower.  Proposals that score consistently low should be rejected. Each of he five categories have equal weighting and each contribute up to 20 points toward an instructions total score from 0 to 100.

* Architecture Consistency: Decisions must be consistent with RISC-V philosophy.  ISA changes should deviate as little as possible from existing RISC-V standards (such as instruction encodings), and should not re-implement features that are already found in the base specification or other extensions.

* Threshold Metric: The proposal should provide a _significant_ savings in terms of clocks or instructions. As a heuristic, any proposal should replace at least four instructions. An instruction that only replaces three may be considered, but only if the frequency of use is very high.

* Data-Driven Value: Usage in real world applications, and corresponding benchmarks showing a performance increase, will contribute to the score of a proposal.  A proposal will not be accepted on the merits of its _theoretical_ value alone, unless it is used in the real world.

* Hardware Simplicity: Though instructions saved is the primary benefit, proposals that dramatically increase the hardware complexity and area, or are difficult to implement, should be penalized and given extra scrutiny.  The final proposals should only be made if a test implementation can be produced.

* Compiler Support: ISA changes that can be natively detected by the compiler, or are already used as intrinsics, will score higher than instructions which do not fit that criteria.

## B Extension Adoption Strategy

The overall goal of this extension is pervasive adoption by minimizing potential barriers and ensuring the instructions can mapped to the largest number of ops, either direct or pseudo, that are supported by the most popular processors and compilers. By adding generic instructions and taking advantage of the RISC-V base instruction that already operate on bits, the minimal set of instructions need to added while at the same time enabling a rich of operations.  

The instructions cover the four major categories of bit manipulation: Count, Extract, Insert, Swap.  The set supports from RV32 through future RV1024 without new instruction formats. "Clever" obscure instructions are avoided in favor of more straight forward, fast, generic ones. Coordination with other emerging RISC-V ISA extensions groups is required to ensure our instruction sets are architecturally consistent.

## Summary of Instructions

The following machine instruction are listed below, followed by a table that lists pseudo instructions.

| Instructions | Primary Applications                                                 |
| -----        | -------------------------------------------------------------------- |
| clz(w,d)     | Count Leading Zeros                                                  |
| pcnt         | Population Count                                                     |
| grevi        | Generalized Reverse                                                  |
| slo          | Shift left Ones                                                      |
| sloi         | Shift left Ones Immediate                                            |
| sro          | Shfit Right Ones                                                     |
| sroi         | Shift Right Ones Immediate                                           |
| andc         | AND Complement                                                       |
| bsca         | Bit Scatter                                                          |
| bgat         | Bit Gather                                                           |
| rol          | Rotate Left                                                          |
| ror          | Rotate Right                                                         |
| rori         | Rotate Right Immediate                                               |

Table: Machine Instructions

## Summary of Psuedo Ops

The following ops are supported by replacing with one or more machine operations.  See instruction details for examples. 

| Instructions | Primary Applications                                          | No. of Instr |
| -----        | ---------------------------------------------------           | ------       |
| flb, fls     | Find Last Bit Set, Find Last Set: clz, sub                    | 2            |
| ctz          | Count Trailing Zeros: grevi, clz                              | 2            |
| fbs, ffs     | First Bit Set, Find First Set:  grevi, clz                    | 2            |
| roli[w,d]    | Rotate Left Immediate: rori[w,d] with adjusted immedate value | 1            |
| bfdep        | Bit Field Deposit                                             | 1            |
| bfext        | Bit Field Extract                                             | 1            |
| bdep         | Bit Depsoit                                                   | 1            |
| bext         | Bit Extract                                                   | 1            |


Table: Psuedo Ops


# RISC-V B Hardware Instructions                             

In the proposals provided in this section, the C code examples are for illustration purposes. They are not optimal implementations, but are intended to specify the desired functionality.

## Count Leading Zeros (`clz`ifdef::study[,`ilog2`,`fls`,`bsr`,`lzcnt`])

This operation counts the number of 0 bits  before the first 1 bit (counting from the most significant bit) in the source register. This is related to the "integer logarithm". It takes a single register as input and operates on the entire register.

The 12 bit immediate is sign-extended to XLEN bits and added to the count. If the input is 0, the output is XLEN+immed. If the input is ~0, the output is 0+immed.


	// clz C implementation
	uint_xlen_t clz(uint_xlen_t rs1,int12_t immed)
	{
		unsigned int count;
		for(count=0;count < XLEN;count++)
		{
       		if((rs1 << count) & XLEN) break;
    	}
    	return count+sign_extend_xlen(immed);
	}

### Encoding


include::[fig/bextclz.tex]

`clz` is encoded as a standard I-type opcode, with a single source register and a 12-bit signed immediate. There is no `clzi`, because it only has one argument, so it would be redundant.



Implementation Commentary

This can be implemented in a very similar way to the logic for `addi`. In fact, it can be implemented in hardware as a prefix on the `rs1` operand to the `addi` implementation. Although this is not found in other instruction sets which do not have this second operand, the inclusion of the 'immed' parameter which is added after the count is taken allows for efficient implementation of doing clz operations on sub-XLEN length data-types with no additional encoding complexity. For example, on RV64IB, we can implement a 32-bit `clz.w` as a single-instruction pseudo-instruction:
 
    clz.w rOut,rIn:
    	clz rOut,rIn,-32
   
Similarly, on RV32IB, counting the 64-bit clz can be implemented as a `mux` and two 32-bit clz with a positive offset.
 
    //64-bit clz on RV32IB
    clz rHighCount,rSrcHigh,0
    clz rLowCount,rSrcLow,32
    mux rCountOut,rSrcHigh,rHighCount,rLowCount
   
Finally, the common operation of 'finding the index of the highest bit set' (also called `ilog2` or `bsr` or `find last set`) is normally computed as `XLEN-clz(rs1)`. The addition of the offset parameter doesn't cost anything in the encoding complexity and minimal cost for hardware complexity, but allows a 2 instruction pseudo-instruction for many of these operations where there would typically be 4.

These patterns extend to RV128B+.

### Related Pseudo-instructions:

    clz.w rOut,rIn,<immed>:
        clz rOut,rIn,<immed-(XLEN-32)>
    clz.d rOut,rIn,<immed>:
        clz rOut,rIn,<immed-(XLEN-64)>

    ctz rOut,rIn:
        brev rInReversed,rIn
        clz rOut,rIn,0

    fls rOut,rIn:
        clz rNegOut,rIn,<1-XLEN>
        sub rOut,r0,rNegOut

    ilog2 rOut,rIn:
        clz rNegOut,rIn,<-XLEN>
        sub rOut,r0,rNegOut
   
### Criteria

The criteria evaluation is shown below:

* These operations all fit easily into the RISCV instruction encoding and philosophy.
* The hardware to implement them is fairly simple, and can be done in a logarithmic number of stages in parallel.
* They all have current compiler and standard library support, and are standardized intrinsics in many of those.
* The threshold criteria gets a little complicated: Every one of these operations can be implemented in 2-3 instructions in terms of each-other, so we only need one of them in hardware, and the rest can be pseudo-instructions.

However, implementing any of these instructions can also be done with a combination of `ctz` and a bitwise reverse (`brev`) in 1-2 instructions.  Similarly, `ctz` can be implemented in terms of these functions with a `brev` in 1-2 instructions.
 
Without `brev` AND `ctz`, however, there is no simple way to construct this without a lot of instructions.  The algorithm above in C is a nearly asymptotically optimal implementation.  It seems to pass the threshold criteria in this case.

#### Benchmarks and Applications

TBD

### References

https://en.wikipedia.org/wiki/Find\_first\_set#CLZ

https://fgiesen.wordpress.com/2013/10/18/bit-scanning-equivalencies/

ifdef::study[]

## Count Trailing Zeros (ctz,ffs,bsf,tzcnt)

The purpose of these instructions is to compute the number of least-significant zeros in a register before a `1` appears.  They take a single register as input and operate on the entire register.

### Status

This instruction is not finalized, but is still open for inclusion.

### Functionality

This operation appears in several variants that all have slightly different functionality, summarized below.  All of these operations can trivially be implemented in terms of each-other with very few instructions.

#### `ctz`: count-trailing-zeros:

This operation counts the number of 0 bits before the first 1 bit counting from the least significant bit.  Equivalently, it returns the _index_ of the least-significant 1 bit in the register.   If the input is 0, the output can either be the register size, or it can be left undefined, but the register size is the most logical result, (not included in code example below).

    // ctz C implementation
	uint_xlen_t ctz(uint_xlen_t v)
	{
	  if(v & 1) return 0;
	  uint_xlen_t c=0;
	  if(!(v & 0xFFFF)){ c+=16; v>>=16;}
	  if(!(v & 0x00FF)){ c+=8;  v>>=8;}
	  if(!(v & 0x000F)){ c+=4;  v>>=4;}
	  if(!(v & 0x0003)){ c+=2;  v>>=2;}
	  if(!(v & 0x0001)){ c+=1;  v>>=1;}
	  return c;
	}

https://graphics.stanford.edu/~seander/bithacks.html#ZerosOnRightParallel

### `ffs,bsf`: Find first set

This operation finds the _index_ (starting from 1 as the least-significant-bit) of the least-significant 1 bit set in the register. This is the same as `ffs(a)=ctz(a)+1`.  If the input is 0, the result is 0.  (which is consistent with overflow in the `ctz(x)+1` definition)

### Justification

This operation is useful for several other operations, as well as appearing in various cryptographic algorithms.  One of these operations is supported as an intrinsic on every major compiler and standard library and is supported in hardware on a plethora of platforms. See links below:

https://en.wikipedia.org/wiki/Find\_first\_set#Tool%20and%20library%20support[source]

https://en.wikipedia.org/wiki/Find\_first\_set#Hardware%20support[source])

### Open Questions

1. All the standard instruction encodings accept two input registers and one destination register, or a 12-bit immediate, an input register, and the destination register.  This instruction maps most simply to the 1 input 1 immediate input, but does not use the immediate in any way.  Should this be the encoding? Should the immediate be ignored?  Should we form a new encoding?

### Implementation Alternatives:

	ctz rdst,rsrc:
	<if 'pcnt' is available>
		sub rdst,r0,rsrc
		and rdst,rdst,rsrc
		addi rdst,rdst,-1
		pcnt rdst,rdst
	<if 'clz' and 'bitrev' are available>
		bitrev rdst,rsrc
		clz rdst,rdst
	<if 'clz' is available>
		xori rdst,rsrc,-1
		and rdst,rdst,rsrc
		clz rdst,rdst
		addi rtmp,r0,<XLENGTH>
		sub rdst,rtmp,rdst
	<if 'ilog2' is available>
		xori rdst,rsrc,-1
		and rdst,rdst,rsrc
		ilog2 rdst,rdst
   
### Criteria

* These operations all fit easily into the RISC-V instruction encoding and philosophy.
* The hardware to implement this is fairly simple, and can be done in a logarithmic number of stages in parallel.

* They all have current compiler and standard library support, and are standardized intrinsics in many of those.

* The threshold criteria gets a little complicated.  `ctz` and `ffs` has no simple low-instruction count implementation in the base spec.

This seems to imply that neither variant of this operation passes the threshold criteria for a machine that has `pcnt` or `clz`

#### Benchmarks and Applications

TBD

### References

https://en.wikipedia.org/wiki/Find\_first\_set#FFS

endif::[]

## Count Bits Set (`pcnt`)

The purpose of this instruction is to compute the number of 1 bits in a register. It takes a single register as input and operates on the entire register.

### Functionality definition.

This operation counts the total number of set bits in the register.
 
 	// popcount C implementation
	uint_xlen_t pcnt(uint_xlen_t rs1)
	{
   		unsigned int count=0;
    	for(unsigned int index=0;index < XLEN;index++)
    	{
        	count+=(rs1 >> index) & 0x1;
   		}
    	return count;
	}
   
### Encoding


include::[fig/bextpcnt.tex]

`pcnt` is encoded as a standard I-type opcode, with one source register and an immediate. There is no `pcnti`, because it only has one argument, so it would be redundant.

Implementation Commentary

`pcnt` can be implemented in parallel, similarly to an adder.

### Related Pseudo-Instructions:
 
    //odd parity
    parity rOut,rIn:
        pcnt rPopulation,rIn
        andi rOut,rPopulation,0x1
   
### Extensions: `pcnt.w` (R64I+),`pcnt.d` (R128I+)

On RV64B+, the appropriate versions of pcnt that operate on sub-portions of the register are defined. On these platforms, the input source is set to zero for the high portions of the register. See `addi.w` and `addi.d` in the R64I/R128I specifications.

### Justification

This operation is one of the 'core' bitwise instructions that is nearly universal on other ISAs. It is supported as an intrinsic on GCC, LLVM, and MSVC, and is supported in hardware on a plethora of platforms.

### References

https://en.wikipedia.org/wiki/Hamming\_weight

https://graphics.stanford.edu/~seander/bithacks.html

## Generalized Reverse (`grevi`)

The purpose of this instruction is to provide a single hardware instruction that can implement all of byte-order swap, bitwise reversal, short-order-swap, word-order-swap (RV64I), nibble-order swap, bitwise reversal in a byte, etc, all from a single hardware instruction.  It takes in a single register value and an immediate that controls which function occurs, through controlling the levels in the recursive tree at which reversals occur.

### Functionality definition.

This operation iteratively checks each bit immed_i from i=0 to XLEN-1, in XLEN stages, and if the corresponding bit of the 'function_select' immediate is true for the current stage, swaps each adjacent pair of 2^i bits in the register.

`grevi` 'butterfly' implementation in C on various architectures
 
    uint32_t grevi32(uint32_t rs1,int12_t immed)
	{
   		uint32_t x=rs1;
    	uint5_t k=(uint12_t)immed;
    	if(k &  1) x = ((x & 0x55555555) << 1) | ((x & 0xAAAAAAAA) >> 1);
    	if(k &  2) x = ((x & 0x33333333) << 2) | ((x & 0xCCCCCCCC) >> 2);
    	if(k &  4) x = ((x & 0x0F0F0F0F) << 4) | ((x & 0xF0F0F0F0) >> 4);
    	if(k &  8) x = ((x & 0x00FF00FF) << 8) | ((x & 0xFF00FF00) >> 8);
    	if(k & 16) x = ((x & 0x0000FFFF) <<16) | ((x & 0xFFFF0000) >> 16);
    	return x;
	}

    uint64_t grevi64(uint32_t rs1,int12_t immed)
	{
   	    uint64_t x=rs1;
        uint6_t k=(uint12_t)immed;
        if(k &  1) x = ((x & 0x5555555555555555) << 1) | ((x & 0xAAAAAAAAAAAAAAAA) >> 1);
        if(k &  2) x = ((x & 0x3333333333333333) << 2) | ((x & 0xCCCCCCCCCCCCCCCC) >> 2);
        if(k &  4) x = ((x & 0x0F0F0F0F0F0F0F0F) << 4) | ((x & 0xF0F0F0F0F0F0F0F0) >> 4);
        if(k &  8) x = ((x & 0x00FF00FF00FF00FF) << 8) | ((x & 0xFF00FF00FF00FF00) >> 8);
        if(k & 16) x = ((x & 0x0000FFFF0000FFFF) <<16) | ((x & 0xFFFF0000FFFF0000) >> 16);
        if(k & 32) x = ((x & 0x00000000FFFFFFFF) <<32) | ((x & 0xFFFFFFFF00000000) >> 32);
	    return x;
	}
   
The above pattern should be intuitive to understand in order to extend this definition in an obvious manner for RV128+.

### Encoding


include::[fig/bextgrev.tex]

`grevi` is encoded as a standard I-type opcode with one source register and one immediate.

There is no similar `grev`, R-type opcode with a dynamic argument for the function select, because it seems unlikely that functionality would ever be useful compared to the hardware implementation complexity required, and since the function select parameter only ranges from `0:XLEN-1`, it could be easily implemented as an XLEN-sized jump table by the compiler.

Implementation Commentary

When implementing this circuit, the masks and shifts should be used to select wires and the k bits should be used to AND out the computation at each stage. It uses log2(XLEN) stages of parallel circuitry (e.g., a "butterfly circuit").

### Related Pseudo-Instructions

Related Pseudoinstruction List

    //reverse the bits in a register (this works on all platforms)
    rev rOut,rIn:
        grevi rOut,rIn,-1

    //reverse the bits in each byte, but leave the bytes in the same order.
    rev.b rOut,rIn:
        grevi rOut,rIn,7

    //reverse the bits in each halfword, but leave the halfwords in the same order
    rev.h rOut,rIn:
        grevi rOut,rIn,15

    //reverse the bits in each word, but leave the words in the same order (e.g. RV64IB+)
    rev.w rOut,rIn:
        grevi rOut,rIn,31

    //reverse the bits in each dword, but leave the dwords in the same order (e.g. RV128IB+)
    rev.d rOut,rIn:
        grevi rOut,rIn,63

    //reverse the byte order of an entire register
    bswap rOut,rIn:
        grevi rOut,rIn,-8

    //reverse the byte order of each halfword in the register, but leave them in the same
	//order (e.g, on RV32IB, this reverses the byte order of the high and lo halfwords)
    bswap.h rOut,rIn:
        grevi rOut,rIn,8

    //reverse the byte order each word in the register (e.g, on RV64IB/RV128IB, this reverses
	//the byte order of each of the 2/4 words)
    bswap.w rOut,rIn:
        grevi rOut,rIn,24

    //reverse the byte order of each dword in the register (e.g, on RV128IB, reverse the byte
	//order of the high and lo words)
    bswap.d rOut,rIn:
        grevi rOut,rIn,56

    //reverse the halfword order of an entire register
    hswap rOut,rIn:
        grevi rOut,rIn,-16

    //reverse the halfword order of each word in the register
    hswap.w rOut,rIn:
        grevi rOut,rIn,16

    //reverse the halfword order of each dword in the register (e.g. RV128IB+, there are 2
	//dwords)
    hswap.d rOut,rIn:
        grevi rOut,rIn,48

    //reverse the word order of an entire register (only meaningful on RV64IB+)
    wswap rOut,rIn:
        grevi rOut,rIn,-32

    //reverse the word order of each dword in the register (e.g. RV128IB+, there are 2 dwords)
    wswap.d rOut,rIn:
        grevi rOut,rIn,32

    //swap the nibbles of each byte in the whole register (useful for converting to/from
	//bigendian hex)
    nswap.b rOut,rIn:
        grevi rOut,rIn,4

    //Etc.  A total of XLEN different possible operations can be constructed.
   
### Justification

Quoted from page 102 of Hacker's Delight: 

https://books.google.com/books?id=iBNKMspIlqEC&amp;lpg=PP1&amp;pg=RA1-SL20-PA2#v=onepage&amp;q&amp;f=false

> For k=31, this operation reverses the bits in a word. For k=24, it reverses the bytes in a word. For k=7, it reverses the bits in each byte, without changing the positions of the bytes. For k=16, it swaps the left and right halfwords of a word, and so on. In general, it moves the bit at positing m to position m XOR k. It can be implemented in hardware very similarly to the way a rotate shifter is usually implemented (five stages of MUX, with each stage controlled by a bit of the shift amount k)
>
> This strongly suggests that this generic instruction could allow us to use a great deal of other bitwise operations as pseudo-instructions.

### References

Hackers Delight, Chapter 7.1, "Generalized Bit Reversal" in

https://books.google.com/books?id=iBNKMspIlqEC&amp;lpg=PP1&amp;pg=RA1-SL20-PA2#v=onepage&amp;q&amp;f=false

http://hackersdelight.org/


## Shift Ones (Left/Right) (`slo, sloi, sro, sroi`)

These instructions are similar to shift-logical operations from the base spec, except instead of shifting in zeros, it shifts in ones. This can be used in mask creation or bit-field insertions, for example.

### Functionality definition.

These instructions are exactly the same as the equivalent logical shift operations, except the shift shifts in ones values.

    // Implementation of `slo(i)` in C
    uint_xlen_t sloi(uint_xlen_t rs1,int12_t immed)
	{
   	    int12_t amount=(immed & (XLEN-1));
        uint_xlen_t mask=((1 << amount)-1);
        return (rs1 << amount) | mask;
    }
    uint_xlen_t slo(uint_xlen_t rs1,uint_xlen_t rs2)
    {
        int12_t amount=(rs2 & (XLEN-1));
        uint_xlen_t mask=((1 << amount)-1);
	    return (rs1 << amount) | mask;
	}
   
    // Implementation of `sro(i)` in C
    uint_xlen_t sroi(uint_xlen_t rs1,int12_t immed)
	{
   	    int12_t amount=(immed & (XLEN-1));
        uint_xlen_t mask=~((1 << (XLEN-amount))-1);
        return (rs1 >> amount) | mask;
    }
    uint_xlen_t sro(uint_xlen_t rs1,uint_xlen_t rs2)
    {
        int12_t amount=(rs2 & (XLEN-1));
        uint_xlen_t mask=~((1 << (XLEN-amount))-1);
	    return (rs1 >> amount) | mask;
	}

### Encoding:

include::[fig/bextsxo.tex]

`s(l/r)o(i)` is encoded similarly to the logical shifts in the base spec. However, the spec of the entire family of instructions is changed so that the high bit of the instruction indicates the value to be inserted during a shift. This means that a `sloi` instruction can be encoded similarly to an `slli` instruction, but with a 1 in the highest bit of the encoded instruction. This encoding is backwards compatible with the definition for the shifts in the base spec, but allows for simple addition of a ones-insert.

Implementation Commentary

When implementing this circuit, the only change in the ALU over a standard logical shift is that the value shifted in is not zero, but is a 1-bit register value that has been forwarded from the high bit of the instruction decode. This creates the desired behavior on both logical zero-shifts and logical ones-shifts.

### Extensions: `s(l/r)o(i).w` (R64I+),`s(l/r)o(i).d` (R128I+)

On RV64B+, the appropriate versions of shift-ones that operate on sub-portions of the register are defined. On these platforms, the input source is set to zero for the high portions of the register, and the shift only occurs on the lower portions of the register. See `slli.w` and `slli.d` in the R64I/R128I specifications. See `slli.w` and `slli.d` in the R64I/R128I specifications.

### Related Pseudo-Instructions:
 

    // builds a mask in the low-order bits up to a certain point
	maski   rOut,iWidth:
   	    sloi rOut,r0,iWidth
    
    // builds a mask in the low-order bits up to a certain point
    mask    rOut,rIn:
        slo rOut,r0,rIn
    
    // extracts a bitfield of length width from offset and moves it down to the bottom
    bfextracti  rOut,rIn,iWidth,iOffset:
	    slli rTop,rIn,XLEN-iWidth-iOffset
	    srli rOut,rTop,XLEN-iWidth

    // updates a bitfield of length width at offset in rCurrent with the value from rIn
	bfupdatei rOut,rCurrent,rIn,iWidth,iOffset:
   	    sloi rTop,rIn,<XLEN-iWidth>
        sroi rField,rTop,<XLEN-iWidth-iOffset>
        and rOut,rCurrent,rField
    
    // sets a bitfield of length-width at offset to 1
    bfseti rOut,rCurrent,iWidth,iOffset:
        sloi rMask,r0,iWidth
        slli rMask,rMask,iOffset
	    or rOut,rCurrent,rMask
	
	// sets a bitfield of length-width at offset to 0
	bfcleari rOut,rCurrent,iWidth,iOffset:
    	sloi rMask,r0,iWidth
    	slli rMask,rMask,iOffset
    	andc rOut,rCurrent,rMask
   
### Justification

This instruction can be used to create masks, which is an incredibly common operation for modifying the bitfield structures.

### References

## Rotate (Left/Right) (`rol`ifdef::study[, `roli`], `ror`, `rori`)

These instructions are similar to shift-logical operations from the base spec, except they shift in the values from the opposite side of the register, in order. This is also called 'circular shift'.  ifdef::spec[`roli` machine instruction is not supported since the assembler can easily modify the immediate value of the `roli` psuedo instruction, so the `rori` instruction can be used.]

### Functionality definition.

    // Implementation of `rol(i)` in C
    uint_xlen_t roli(uint_xlen_t rs1,int12_t immed)
	{
   	    int12_t amount=(immed & (XLEN-1));
        return (rs1 << amount) | (rsl >> (XLEN-amount));
    }
    uint_xlen_t rol(uint_xlen_t rs1,uint_xlen_t rs2)
    {
        int12_t amount=(rs2 & (XLEN-1));
        return (rs1 << amount) | (rsl >> (XLEN-amount));
    }	
	
    uint_xlen_t roli(uint_xlen_t rs1,int12_t immed)
	{
   	    int12_t amount=(immed & (XLEN-1));
        return (rs1 << amount) | (rsl >> (XLEN-amount));
    }
    uint_xlen_t rol(uint_xlen_t rs1,uint_xlen_t rs2)
    {
        int12_t amount=(rs2 & (XLEN-1));
        return (rs1 << amount) | (rsl >> (XLEN-amount));
    }   
	
    // Implementation of `ror(i)` in C
    int_xlen_t rori(uint_xlen_t rs1,int12_t immed)
	{
   	    int12_t amount=(immed & (XLEN-1));
        return (rs1 >> amount) | (rs1 << (XLEN-amount));
    }
    uint_xlen_t ror(uint_xlen_t rs1,uint_xlen_t rs2)
    {
        int12_t amount=(rs2 & (XLEN-1));
        return (rs1 >> amount) | (rsl << (XLEN-amount));
    }
	   
	
### Encoding:

include::[fig/bextrox.tex]

`ror(i),rol(i)` is implemented very similarly to the other shift instructions. One possible way to encode it is to re-use the way that bit 30 in the instruction encoding selects 'arithmetic shift' when bit 31 is zero (signalling a logical-zero shift). We can re-use this so that when bit 31 is set (signalling a logical-ones shift), if bit 31 is also set, then we are doing a rotate. The following table summarizes the behavior:

| Bit 31 | Bit 30 | Meaning             |
| ------ | ------ | ------------------- |
| 0      | 0      | Logical Shift-Zeros |
| 0      | 1      | Arithmetic Shift    |
| 1      | 0      | Logical Shift-Ones  |
| 1      | 1      | Rotate              |

Table: Rotate Encodings

Implementation Commentary

### Extensions: `ro(r/l)(i).w` (R64I+),`ro(r/l)(i).d` (R128I+)

On RV64B+, the appropriate versions of rotate that operate on sub-portions of the register are defined. On these platforms, the input source is set to zero for the high portions of the register, and the shift only occurs on the lower portions of the register. See `slli.w` and `slli.d` in the R64I/R128I specifications.

### Justification

This instruction is very useful for cryptography, hashing, and other operations.

### References

ifdef::study[]

## Missing Bitwise Subset (`andc[i]`, `nand[i]`, `nandc[i]`, `xnor[i]`,`nor[i]`)

These instructions implement the five remaining bitwise operations that, together with the three from the base spec, and permutation of operands, allow any of the 16 possible two-op binary operations to be implemented as a single instruction.

Additionally, these operations can all be implemented with the same ALU area (e.g. as a single microcode instruction) using a scheme described in the implementation commentary.

### Functionality definition.

These instructions perform similarly to the other bitwise operations in base spec `and,andi,xor,xori,or,ori`. They take in two operands and perform the binary operation described bitwise.

    // Implementation of `andc(i)` in C
    uint_xlen_t andci(uint_xlen_t rs1,int12_t immed)
	{
   	    return rs1 & ~sign_extend_xlen(immed);
    }
    uint_xlen_t andc(uint_xlen_t rs1,uint_xlen_t rs2)
    {
        return rs1 & ~rs2;
    }
    
	// Implementation of `nand(i)` in C
    uint_xlen_t nandi(uint_xlen_t rs1,int12_t immed)
	{
   	    return ~(rs1 & sign_extend_xlen(immed));
    }
    uint_xlen_t nand(uint_xlen_t rs1,uint_xlen_t rs2)
    {
        return ~(rs1 & rs2);
    }
       
	// Implementation of `nandc(i)` in C
    uint_xlen_t nandci(uint_xlen_t rs1,int12_t immed)
	{
   	    return ~(rs1 & ~sign_extend_xlen(immed));
    }
    uint_xlen_t nandc(uint_xlen_t rs1,uint_xlen_t rs2)
    {
        return ~(rs1 & ~rs2);
    }
       
	// Implementation of `xnor(i)` in C
    uint_xlen_t xnori(uint_xlen_t rs1,int12_t immed)
	{
   	    return ~(rs1 ^ sign_extend_xlen(immed));
    }
    uint_xlen_t xnor(uint_xlen_t rs1,uint_xlen_t rs2)
    {
        return ~(rs1 ^ rs2);
    }
       
    // Implementation of `nor(i)` in C
    uint_xlen_t nori(uint_xlen_t rs1,int12_t immed)
	{
   	    return ~(rs1 | sign_extend_xlen(immed));
    }
    uint_xlen_t nor(uint_xlen_t rs1,uint_xlen_t rs2)
    {
        return ~(rs1 | rs2);
    }
       
### Encoding:
	
These instructions should all be encoded similarly to the instructions in the base spec. The exact instruction encoding is to be decided, however, the encoding to be decided should allow for efficient implementation of a LUT to translate from the `func` portion of the opcode to the appropriate values of the selector field described in the table found in 'implementation commentary'.

Implementation Commentary

It is worth observing that if we associate each operation with a 4-bit binary string `c3c2c1c0`, and map each of the 8 operations to a 4 bit binary string according to the following table, then there is a simple bitwise operation that implements all eight binary bitwise instructions in this ISA in a single implementation.

| operation name | c3   | c2   | c1   | c0   |
| -------------- | ---- | ---- | ---- | ---- |
| `and`          | 0    | 0    | 0    | 1    |
| `andc`         | 0    | 0    | 1    | 0    |
| `xor`          | 0    | 1    | 1    | 0    |
| `or`           | 0    | 1    | 1    | 1    |
| `nand`         | 1    | 0    | 0    | 1    |
| `nandc`        | 1    | 0    | 1    | 0    |
| `xnor`         | 1    | 1    | 1    | 0    |
| `nor`          | 1    | 1    | 1    | 1    |

Table: Bitwise Instructions

With this set of coefficients, ALL 2-argument bitwise functions can be implemented by the following function in hardware.  
    
	b(x,y,c[0:3])=(c[0] x y + c[1] x (~y) + c[2] (~x)(~y)) ^ c[3]

#### Table of 2-bit bitwise operations and possible implementations on RV

| Operation     | Truth table  | implementation                                                                                                  |
| :-----------: | :----------- | :-------------------------------------------------------------------------------------------------------------- |
| **and**       |              |                                                                                                                 |
| r1 and r2     |              | `trivial`                                                                                                       |
| r2 and r1     |              | `trivial`                                                                                                       |
| r1 and C      |              | `trivial`                                                                                                       |
| C and r1      |              | `trivial`                                                                                                       |
| **andc**      |              |                                                                                                                 |
| r1 andc r2    |              | `andc ro,r1,r2`(andc) or `not r2,r2;and ro,r1,r2`                                                               |
| r2 andc r1    |              | `andc ro,r2,r1`(andc) or `not r1,r1;and ro,r1,r2`                                                               |
| r1 andc C     |              | `andi ro,r1,~C`                                                                                                 |
| C andc r1     |              | `nori ro,r1,~C`(nori) or `not r1,r1;andi ro,r1,C` or `ori ro,r1,~C;not ro,ro`                                 |
| **xor**       |              |                                                                                                                 |
| r1 xor r2     |              | `trivial`                                                                                                       |
| r2 xor r1     |              | `trivial`                                                                                                       |
| r1 xor C      |              | `trivial`                                                                                                       |
| C xor r1      |              | `trivial`                                                                                                       |
| **or**        |              |                                                                                                                 |
| r1 or r2      |              | `trivial`                                                                                                       |
| r2 or r1      |              | `trivial`                                                                                                       |
| r1 or C       |              | `trivial`                                                                                                       |
| C or r1       |              | `trivial`                                                                                                       |
| **nand**      |              |                                                                                                                 |
| r1 nand r2    |              | `nand ro,r1,r2`(nand) or `and ro,r1,r2;not ro,ro;`                                                              |
| r2 nand r1    |              | `nand ro,r1,r2`(nand) or `and ro,r1,r2;not ro,ro;`                                                              |
| r1 nand C     |              | `nandi ro,r1,C`(nandi) or `andi ro,r1,C;not ro,ro;` or `not r1,r1;ori ro,r1,~C`                                 |
| C nand r1     |              | `nandi ro,r1,C`(nandi) or `andi ro,r1,C;not ro,ro;` or `not r1,r1;ori ro,r1,~C`                                 |
| **nandc**     |              |                                                                                                                 |
| r1 nandc r2   |              | `andc ro,r1,r2;not ro,ro`(andc) or `not r1,r1;or ro,r1,r2`                                                      |
| r2 nandc r1   |              | `andc ro,r1,r2;not ro,ro`(andc) or `not r1,r1;or ro,r1,r2`                                                      |
| r1 nandc C    |              | `nandi ro,r1,~C`(nandi) or `not r1,r1;ori ro,r1,C` or `andi ro,r1,~C;not ro,ro`                                 |
| C nandc r1    |              | `ori ro,r1,~C`                                                                                                  |
| **xnor**      |              |                                                                                                                 |
| r1 xnor r2    |              | `xnor ro,r1,r2`(xnor) or `xor ro,r1,r2; not ro,ro` or `not r2,r2; xor ro,r1,r2` or `not r1,r2; xor ro,r1,r2;`   |
| r2 xnor r1    |              | `xnor ro,r1,r2`(xnor) or `xor ro,r1,r2; not ro,ro` or `not r2,r2; xor ro,r1,r2` or `not r1,r2; xor ro,r1,r2;`   |
| r1 xnor C     |              | `xori ro,r1,~C`                                                                                                 |
| C xnor r1     |              | `xori ro,r1,~C`                                                                                                 |
| **nor**       |              |                                                                                                                 |
|preamble r1 nor r2     |              | `nor ro,r1,r2`(nor) or `or ro,r1,r2;not ro,ro`                                                                  |
| r2 nor r1     |              | `nor ro,r1,r2`(nor) or `or ro,r1,r2;not ro,ro`                                                                  |
| r1 nor C      |              | `nori ro,r1,C`(nori) or `not r1,r1;andi ro,r1,~C` or `ori ro,r1,C;not ro,ro`                                    |
| C nor r1      |              | `nori ro,r1,C`(nori) or `not r1,r1;andi ro,r1,~C` or `ori ro,r1,C;not ro,ro`                                    |

Table: Two-bitwise Ops and Implementations

#### Summary of proposals by proposal benefits: 

*Option A: Remove all of these from the proposal*

* Saves on implementation complexity and instruction encoding space...
* Stricter adherence to the threshold criteria.  None of these technically pass the threshold criteria all bitwise operations are possible in 2 clocks in the base instruction set using *either* a prefix-not OR a postfix-not. 

*Option B: `andc` only:*

* All non-negated R-type bitwise operations are possible in a single instruction.  
* Decreases the implementation of the `mix` and `mux` recipes from 6 instructions to 5
* All remaining 2-instruction bitwise operations have a *postfix-not* version AND a *prefix-not* version.  This makes possible macro-op fusion hardware simpler, especially if we standardize a set of  pseudo-instructions to always emit these the same way.
* The four positive single-clock R-type operations can share an implementation (see the table in the proposal), *possibly* reducing area.

*Option C: `andc`,`nori`,`nandi`:*

* Same benefits as B, except:
* all forward and backwards I-type bitwise operations are now possible in a single instruction.

*Option D: `andc`,`nand`,`xnor`,`nor`,`nandc`:*

* Same as C, except:
* All R-type bitwise operations, are now possible in a single instruction.
* All 8 R-type operations can share an implementation, *possibly* reducing area.

*Option E: `andc`,`nand`,`xnor`,`nor`,`nandc`,`nori`,`nandi`:*

* Same benefits as C and D together

### Related Pseudo-Instructions:
 
    //this selects the corresponding bit from the two arguments A and B, based on whether or not Control is high.
    //out[i]=Control[i] ? A[i] : B[i],
    //A & C | B & ~C
    mix rOut,rControl,rA,rB:
        and rTmp,rA,rControl
        andc rTmp2,rB,rControl
        or rOut,rTmp,rTmp2

    //same as MIX but only use if the first bit of C is true (as in from a comparator)...C can only be zero or 1, so you need a SGT to implement nonzero comparator so its 5 instructions
    mux rOut,rControl,rA,rB:
        neg rC2,rControl
        and rTmp,rA,rC2
        andc rTmp2,rB,rC2
        or rOut,rTmp,rTmp2
   

### Justification

TBD

### References

http://www.hackersdelight.org/basics2.pdf
endif::[]

## And-with-complement (`andc`)

include::[fig/bextandc.tex]

This is an R-type instruction that implements the and-with-complement operation `x=(a & ~b)` with an assembly format of `andc ro,r1,r2`.




Additionally, the four positive bitwise operations can all be implemented with the same ALU area (e.g. as a single microcode instruction) using a scheme described in the implementation commentary, and fused versions can be implemented as well.

### Functionality definition.

	// Implementation of `andc` in C
	uint_xlen_t andc(uint_xlen_t rs1,uint_xlen_t rs2)
	{
   		return rs1 & ~rs2;
	}
   


This instruction should be encoded similarly to the instruction in the base spec. The exact instruction encoding is to be decided, however.

### Related Pseudo-Instructions:
 
	//this selects the corresponding bit from the two arguments A and B, based on whether or not Control is high.
    //out[i]=Control[i] ? A[i] : B[i],
    //A & C | B & ~C
    mix rOut,rControl,rA,rB:
        and rTmp,rA,rControl
        andc rTmp2,rB,rControl
        or rOut,rTmp,rTmp2

    //same as MIX but only use if the first bit of C is true (as in from a comparator)
	// C can only be zero or 1, so you need a SGT to implement nonzero comparator so its 5 instructions
    mux rOut,rControl,rA,rB:
        neg rC2,rControl
        and rTmp,rA,rC2
        andc rTmp2,rB,rC2
        or rOut,rTmp,rTmp2

### Justification

Can be very useful for compresssion/depcompression algorithms.

### References

http://www.hackersdelight.org/basics2.pdf

## Bit Scatter/Gather (`bsc`, `bga`)

This is an R-type instruction that implements the generic bit scatter and bit gather functions.  Similar implementation can be referred to as scatter/gather or unpack/pack. 

	BGA[W] rd,rs1,rs2    	Bit Gather 	 	Collect LSB justified bits to rd from 
											rs1 using extract mask in rs2 
	BSC[W] rd,rs1,rs2    	Bit Scatter 	Write LSB justified bits from rs1 to 
											rd using deposit mask in rs2 

### Functionality definition.

	// Implementation of `bsci` in C
	uint_xlen_t andc(uint_xlen_t rs1,uint_xlen_t rs2)
	{
   		return rs1 & ~rs2;
	}
   
	// Implementation of `bgai` in C
	uint_xlen_t andc(uint_xlen_t rs1,uint_xlen_t rs2)
	{
   		return rs1 & ~rs2;
	}

### Encoding:


include::[fig/bextscagat.tex]


This instruction should be encoded similarly to the instruction in the base spec. The exact instruction encoding is to be decided, however.

### Related Pseudo-Instructions:
 
TBD

### Justification


### References

http://programming.sirrida.de/bit_perm.html#gather_scatter

Hackers Delight, Chapter 7.1, "Compress, Generalized Extract" in

https://books.google.com/books?id=iBNKMspIlqEC&amp;lpg=PP1&amp;pg=RA1-SL20-PA2#v=onepage&amp;q&amp;f=false

http://hackersdelight.org/



# Change History

ifdef::study[]

| Date         | Rev      | Changes                                         |
| :----------- | :------- | :--------------------------------------         |
| 2017-07-17   | 0.3      | Added slo/sro. Added bitfield clear.            |
| -            | -        | Added discussion of extract encoding.           |
| -            | -        | Added alternative implementations               |
| 2017-11-02   | 0.31     | Fixed typos                                     |
| 2017-11-30   | 0.32     | Minor Formatting difference so needed to rev it |

Table: Summary of Changes

endif::[]

ifdef::spec[]

| Date         | Rev      | Changes                                                    |
| :----------- | :------- | :---------------------------------------------             |
| 2017-07-17   | 0.10     | Initial Draft                                              |
| 2017-11-02   | 0.11     | Removed roli, assembler can convert it to use a rori       |
|              |          | Removed bitwise subset and replaced with `andc`            |
|              |          | Doc source text same base for study and spec.              |
|              |          | Fixed typos                                                |
| 2017-11-30   | 0.32     | Jump rev number to be on par with associated Study         |
|              |          | Moved pdep/pext into spec draft and called it scattergaher |

Table: Summary of Changes

endif::[]


