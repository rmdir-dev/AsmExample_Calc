all:
	mkdir -p temp/
	nasm -f elf64 -g -o temp/start.o src/start.asm
	mkdir -p temp/String
	nasm -f elf64 -g -o temp/String/string.o src/String/string.asm
	mkdir -p temp/IO
	nasm -f elf64 -g -o temp/IO/io.o src/IO/io.asm
	mkdir -p temp/Args
	nasm -f elf64 -g -o temp/Args/args.o src/Args/args.asm
	mkdir -p temp/Calc
	nasm -f elf64 -g -o temp/Calc/calc.o src/Calc/calc.asm
	ld temp/start.o temp/String/string.o temp/IO/io.o temp/Args/args.o temp/Calc/calc.o -o Calc
	
clean:
	rm -Rf temp/