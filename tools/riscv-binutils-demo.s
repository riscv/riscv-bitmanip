demo:
slli x1,x2,5
srli x1,x2,5
srai x1,x2,5

andn x1,x2,x3
orn  x1,x2,x3
xnor x1,x2,x3

slo x1,x2,x3
slo x1,x2,5
sro x1,x2,x3
sro x1,x2,5
rol x1,x2,x3
ror x1,x2,x3
ror x1,x2,5

sbset x1,x2,x3
sbset x1,x2,5
sbclr x1,x2,x3
sbclr x1,x2,5
sbinv x1,x2,x3
sbinv x1,x2,5
sbext x1,x2,x3
sbext x1,x2,5

sloi x1,x2,5
sroi x1,x2,5
rori x1,x2,5

sbseti x1,x2,5
sbclri x1,x2,5
sbinvi x1,x2,5
sbexti x1,x2,5

cmix x1,x2,x3,x4
cmov x1,x2,x3,x4

cmix x0,x0,x0,x0
cmix x31,x0,x0,x0
cmix x0,x31,x0,x0
cmix x0,x0,x31,x0
cmix x0,x0,x0,x31

fsl x1,x2,x3,x4
fsr x1,x2,x3,x4
fsr x1,x2,x3,5
fsri x1,x2,x3,5

clz x1,x2
ctz x1,x2
pcnt x1,x2

crc32.b x1,x2
crc32.h x1,x2
crc32.w x1,x2
crc32.d x1,x2

crc32c.b x1,x2
crc32c.h x1,x2
crc32c.w x1,x2
crc32c.d x1,x2

clmul x1,x2,x3
clmulh x1,x2,x3
clmulr x1,x2,x3
min x1,x2,x3
max x1,x2,x3
minu x1,x2,x3
maxu x1,x2,x3

shfl x1,x2,x3
shfl x1,x2,5
unshfl x1,x2,x3
unshfl x1,x2,5

shfli x1,x2,5
unshfli x1,x2,5

bdep x1,x2,x3
bext x1,x2,x3
pack x1,x2,x3

bmatflip x1,x2
bmator x1,x2,x3
bmatxor x1,x2,x3

addiwu x1,x2,1234
slliu.w x1,x2,12
addwu x1,x2,x3
subwu x1,x2,x3
addu.w x1,x2,x3
subu.w x1,x2,x3

slow x1,x2,x3
slow x1,x2,5
srow x1,x2,x3
srow x1,x2,5
rolw x1,x2,x3
rorw x1,x2,x3
rorw x1,x2,5

sbsetw x1,x2,x3
sbsetw x1,x2,5
sbclrw x1,x2,x3
sbclrw x1,x2,5
sbinvw x1,x2,x3
sbinvw x1,x2,5
sbextw x1,x2,x3

sloiw x1,x2,5
sroiw x1,x2,5
roriw x1,x2,5

sbsetiw x1,x2,5
sbclriw x1,x2,5
sbinviw x1,x2,5

fslw x1,x2,x3,x4
fsrw x1,x2,x3,x4
fsrw x1,x2,x3,5
fsriw x1,x2,x3,5

clzw x1,x2
ctzw x1,x2
pcntw x1,x2

clmulw x1,x2,x3
clmulhw x1,x2,x3
clmulrw x1,x2,x3

shflw x1,x2,x3
unshflw x1,x2,x3

bdepw x1,x2,x3
bextw x1,x2,x3
packw x1,x2,x3

ret
