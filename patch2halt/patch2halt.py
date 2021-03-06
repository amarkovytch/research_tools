import sys
from patcherex.backends.detourbackend import DetourBackend
from patcherex.patches import *

HALT_COMMAND = '''
    hlt
'''

def main():
    binary_path = sys.argv[1]
    output_path = sys.argv[2]

    backend = DetourBackend(binary_path)

    patch = [AddEntryPointPatch(HALT_COMMAND)]
    backend.apply_patches(patch)

    backend.save(output_path)



if __name__ == '__main__':
    main()

