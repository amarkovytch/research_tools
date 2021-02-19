#!/bin/bash
nasm -f elf32 $1 -o a.o
ld -m elf_i386 a.o -o a.out
./bin2shell.sh a.out
#rm a.*
