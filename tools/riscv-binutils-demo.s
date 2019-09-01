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

rev.p x1,x2
rev2.n x1,x2
rev.n x1,x2
rev4.b x1,x2
rev2.b x1,x2
rev.b x1,x2
rev8.h x1,x2
rev4.h x1,x2
rev2.h x1,x2
rev.h x1,x2
rev16.w x1,x2
rev8.w x1,x2
rev4.w x1,x2
rev2.w x1,x2
rev.w x1,x2
rev32 x1,x2
rev16 x1,x2
rev8 x1,x2
rev4 x1,x2
rev2 x1,x2
rev x1,x2

orc.p x1,x2
orc2.n x1,x2
orc.n x1,x2
orc4.b x1,x2
orc2.b x1,x2
orc.b x1,x2
orc8.h x1,x2
orc4.h x1,x2
orc2.h x1,x2
orc.h x1,x2
orc16.w x1,x2
orc8.w x1,x2
orc4.w x1,x2
orc2.w x1,x2
orc.w x1,x2
orc32 x1,x2
orc16 x1,x2
orc8 x1,x2
orc4 x1,x2
orc2 x1,x2
orc x1,x2

zip.n x1,x2
zip2.b x1,x2
zip.b x1,x2
zip4.h x1,x2
zip2.h x1,x2
zip.h x1,x2
zip8.w x1,x2
zip4.w x1,x2
zip2.w x1,x2
zip.w x1,x2
zip16 x1,x2
zip8 x1,x2
zip4 x1,x2
zip2 x1,x2
zip x1,x2

unzip.n x1,x2
unzip2.b x1,x2
unzip.b x1,x2
unzip4.h x1,x2
unzip2.h x1,x2
unzip.h x1,x2
unzip8.w x1,x2
unzip4.w x1,x2
unzip2.w x1,x2
unzip.w x1,x2
unzip16 x1,x2
unzip8 x1,x2
unzip4 x1,x2
unzip2 x1,x2
unzip x1,x2

ret
