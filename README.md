# A collection of various research tools

## bin2shell
Create raw bytes from assembly file to be used in shellcode
* shellcode32.sh asm32.S 
* shellcode64.sh asm64.S

## Patch2Halt
A small utility to patch binary so that it halts at main function. This is useful in some cases when we want to attach to running process, but it finishes it's execution before we have a chance to do so
* patch2halt.py binary patched_binary


## tribute

bin2shell - https://github.com/touhidshaikh/bin2shell