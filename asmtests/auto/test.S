#if defined(XLEN32)
.include "autoasm/test32.S"
#else
.include "autoasm/test64.S"
#endif
