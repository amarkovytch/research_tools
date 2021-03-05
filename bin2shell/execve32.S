;int execve(const char *filename, char *const argv[],char *const envp[])
section .text
  global _start
    _start:
      xor eax, eax
      push eax ; push last '\0'
      push 0x68732f2f ; push /bin/sh
      push 0x6e69622f
      mov ebx, esp ; first param
      xor ecx, ecx ; 0 to second param
      xor edx, edx ; 0 to third param
      mov al, 0x0b ; execve syscall
      int 80h
