import sys
import patcherex
from patcherex.backends.detourbackend import DetourBackend
from patcherex.backends.reassembler_backend import ReassemblerBackend
from patcherex.patches import *

HALT_COMMAND = '''
    0xF4 ; HLT opcode
'''

def main():
    binary_path = sys.argv[1]
    output_path = sys.argv[2]
    addr_to_patch = sys.argv[3]

    backend = ReassemblerBackend(binary_path)

    patch = [InlinePatch(HALT_COMMAND, addr_to_patch, HALT_COMMAND)]
    backend.apply_patches(patch)

    backend.save(output_path)



if __name__ == '__main__':
    main()

