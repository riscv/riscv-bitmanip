INSTR = 50000
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
	
autotest: asmgen32.exe asmgen64.exe FORCE
	rm ../extB/autoasm/test32.S
	rm ../extB/autoasm/test64.S
	rm ../extB/autoasm/test.S
	asmgen32.exe $(INSTR) RANDOM > ../extB/autoasm/test32.S
	asmgen64.exe $(INSTR) RANDOM > ../extB/autoasm/test64.S
	cp test.S ../extB/autoasm/test.S
	stat ../extB/autoasm/test32.S
	stat ../extB/autoasm/test64.S
	stat ../extB/autoasm/test.S  
	

FORCE: