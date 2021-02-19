#!/bin/bash
nasm -f elf64 $1 -o a.o
ld a.o -o a.out
./bin2shell.sh a.out
rm a.*
