uppercaserv1: uppercaserv1.o
	ld -o uppercaserv1 uppercaserv1.o
uppercaserv1.o: uppercaserv1.asm
	nasm -f elf64 -g -F dwarf uppercaserv1.asm
