all: asmgen.exe

asmgen.exe: asmgen.c
	g++ -o $@ $< -I../../cproofs
	./$@ 10000 > ../extB/autoasm/test.S
	
clean:
	- rm asmgen.exe
