;CPU		: Intel® Core™2 Duo CPU T6570 @ 2.10GHz × 2
;ARCHITECTURE	: x86-64
;DESCRIPTION	: Convert stdin characters to uppercase
;MAKE		: uppercasev1: uppercasev1.o [ld -o uppercasev1 uppercasev1.o]; uppercasev1.o: uppercasev1.asm [nasm -f elf64 -g -F dwarf uppercasev1.asm]
SECTION .bss
	BUFF RESB 1

SECTION .data

SECTION .text

global _start			; GLOBAL MAIN FOR GCC PROGRAMS

	_start:

		MOV RBP, RSP			; For correct debugging

				READ:
					MOV RAX,0			; Specify sys_read call
					MOV RDI,0			; Specify stdin fd
					MOV RSI,BUFF			; Addy of buffer to read *to*
					MOV RDX,1			; Tell sys_read to read one char *from* stdin
					SYSCALL				; Invoke sys_read [Uses ring 0] {I wonder if int 80h still works in x64}

					CMP RAX,0			; Did sys_read return EOF?
					JE EXIT				; Jump if Equal to 0 (EOF) to Exit or fall through to test for lower case

					CMP BYTE [BUFF],0X61		; Test input char against 'a'
					JB WRITE			; If below 'a' in ASCII, not lowercase
					CMP BYTE [BUFF],0X7A		; Test input char against 'z'
					JA WRITE			; If above 'z' in ASCII, not lowercase

									; Thus, we have filtered out lowercase characters
					SUB BYTE [BUFF],0X20		; Subtract 0x20 from lowercase to give uppercase.This is very neat!
									; & then write out the char to stdout:

				WRITE:
					MOV RAX,1			; Specify sys_write call
					MOV RDI,1			; Specify fd 4 stdout
					MOV RSI,BUFF			; Remember that vars in asm are locations/addresses/pointers/offsets
					MOV RDX,1			; Pass the number of bytes to write
					SYSCALL				; (INT 80H Was a software interrupt.) Call sys_write
					JMP READ			; Get another char

				EXIT:
					;ret				; For programms that use GCC
					MOV RAX,60			; 60 = Exit the programm
					MOV RDI,0			; Return value is stored in RDI
					SYSCALL				; Bis dann! Servus.
