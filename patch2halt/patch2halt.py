#!/bin/python

import sys
from pwn import *


def main():
    input = sys.argv[1]
    output = sys.argv[2]

    e = ELF(input)

    code = 'endless: jmp endless'
    code_len = len(asm(code))

    main_addr = e.symbols['main']
    main_orig_code = e.read(main_addr, code_len)

    print('Patching these {} bytes of code {} at the beginning of main with infinite loop ({})'
          .format(code_len, enhex(main_orig_code), enhex(asm(code))))
    print('Now you can attach with gdb to the running (stuck) process: gdb <PATH> <PID>')
    print('Once attached patch main code to original after each run + ctrl c:')
    print('patch word {} {}'.format(hex(main_addr), hex(u16(main_orig_code))))
    e.asm(main_addr, code)
    e.save(output)


if __name__ == '__main__':
    main()
