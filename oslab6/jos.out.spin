+ ld obj/kern/kernel
+ mk obj/kern/kernel.img
6828 decimal is 15254 octal!
Physical memory: 131072K available, base = 640K, extended = 130432K
check_page_free_list() succeeded!
check_page_alloc() succeeded!
check_page() succeeded!
check_kern_pgdir() succeeded!
check_page_free_list() succeeded!
check_page_installed_pgdir() succeeded!
SMP: CPU 0 found 1 CPU(s)
enabled interrupts: 1 2 4
[00000000] new env 00001000
[00000000] new env 00001001
FS is running
TRAP frame at 0xf026b000 from CPU 0
  edi  0x00000000
  esi  0x00000000
  ebp  0xeebfdfd0
  oesp 0xefffffdc
  ebx  0x00000000
  edx  0x00008a00
  ecx  0x0000000e
  eax  0xffff8a00
  es   0x----0023
  ds   0x----0023
  trap 0x0000000d General Protection
  err  0x00000000
  eip  0x00800ef6
  cs   0x----001b
  flag 0x00000292
  esp  0xeebfdfb8
  ss   0x----0023
[00001000] free env 00001000
I am the parent.  Forking the child...
[00001001] new env 00002000
I am the parent.  Running the child...
I am the child.  Spinning...
I am the parent.  Killing the child...
[00001001] destroying 00002000
[00001001] free env 00002000
[00001001] exiting gracefully
[00001001] free env 00001001
No runnable environments in the system!
Welcome to the JOS kernel monitor!
Type 'help' for a list of commands.
qemu-system-i386: terminating on signal 15 from pid 7179 (make)
