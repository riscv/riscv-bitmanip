INSTR = 10000
all: asmgen32.exe asmgen64.exe ../extB/autoasm/test.S

asmgen32.exe: asmgen.c
	g++ -o $@ $< -I../../cproofs -DXLEN=32 -g
	./$@ $(INSTR) > ../extB/autoasm/test32.S

asmgen64.exe: asmgen.c
	g++ -o $@ $< -I../../cproofs -DXLEN=64 -g
	./$@ $(INSTR) > ../extB/autoasm/test64.S

../extB/autoasm/test.S: test.S ../extB/autoasm/test32.S ../extB/autoasm/test64.S
	cp $< $@
	
clean:
	- rm asmgen32.exe asmgen64.exe
