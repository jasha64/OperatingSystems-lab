
obj/user/badsegment.debug：     文件格式 elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800036:	66 b8 28 00          	mov    $0x28,%ax
  80003a:	8e d8                	mov    %eax,%ds
}
  80003c:	5d                   	pop    %ebp
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800046:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  800049:	e8 c6 00 00 00       	call   800114 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  80004e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800053:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800056:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005b:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800060:	85 db                	test   %ebx,%ebx
  800062:	7e 07                	jle    80006b <libmain+0x2d>
		binaryname = argv[0];
  800064:	8b 06                	mov    (%esi),%eax
  800066:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80006b:	83 ec 08             	sub    $0x8,%esp
  80006e:	56                   	push   %esi
  80006f:	53                   	push   %ebx
  800070:	e8 be ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800075:	e8 0a 00 00 00       	call   800084 <exit>
}
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800080:	5b                   	pop    %ebx
  800081:	5e                   	pop    %esi
  800082:	5d                   	pop    %ebp
  800083:	c3                   	ret    

00800084 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800084:	55                   	push   %ebp
  800085:	89 e5                	mov    %esp,%ebp
  800087:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80008a:	6a 00                	push   $0x0
  80008c:	e8 42 00 00 00       	call   8000d3 <sys_env_destroy>
}
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	c9                   	leave  
  800095:	c3                   	ret    

00800096 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	57                   	push   %edi
  80009a:	56                   	push   %esi
  80009b:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80009c:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a7:	89 c3                	mov    %eax,%ebx
  8000a9:	89 c7                	mov    %eax,%edi
  8000ab:	89 c6                	mov    %eax,%esi
  8000ad:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000af:	5b                   	pop    %ebx
  8000b0:	5e                   	pop    %esi
  8000b1:	5f                   	pop    %edi
  8000b2:	5d                   	pop    %ebp
  8000b3:	c3                   	ret    

008000b4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b4:	55                   	push   %ebp
  8000b5:	89 e5                	mov    %esp,%ebp
  8000b7:	57                   	push   %edi
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8000bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c4:	89 d1                	mov    %edx,%ecx
  8000c6:	89 d3                	mov    %edx,%ebx
  8000c8:	89 d7                	mov    %edx,%edi
  8000ca:	89 d6                	mov    %edx,%esi
  8000cc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ce:	5b                   	pop    %ebx
  8000cf:	5e                   	pop    %esi
  8000d0:	5f                   	pop    %edi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e9:	89 cb                	mov    %ecx,%ebx
  8000eb:	89 cf                	mov    %ecx,%edi
  8000ed:	89 ce                	mov    %ecx,%esi
  8000ef:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f1:	85 c0                	test   %eax,%eax
  8000f3:	7f 08                	jg     8000fd <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f8:	5b                   	pop    %ebx
  8000f9:	5e                   	pop    %esi
  8000fa:	5f                   	pop    %edi
  8000fb:	5d                   	pop    %ebp
  8000fc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000fd:	83 ec 0c             	sub    $0xc,%esp
  800100:	50                   	push   %eax
  800101:	6a 03                	push   $0x3
  800103:	68 ca 0f 80 00       	push   $0x800fca
  800108:	6a 23                	push   $0x23
  80010a:	68 e7 0f 80 00       	push   $0x800fe7
  80010f:	e8 2f 02 00 00       	call   800343 <_panic>

00800114 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800114:	55                   	push   %ebp
  800115:	89 e5                	mov    %esp,%ebp
  800117:	57                   	push   %edi
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80011a:	ba 00 00 00 00       	mov    $0x0,%edx
  80011f:	b8 02 00 00 00       	mov    $0x2,%eax
  800124:	89 d1                	mov    %edx,%ecx
  800126:	89 d3                	mov    %edx,%ebx
  800128:	89 d7                	mov    %edx,%edi
  80012a:	89 d6                	mov    %edx,%esi
  80012c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80012e:	5b                   	pop    %ebx
  80012f:	5e                   	pop    %esi
  800130:	5f                   	pop    %edi
  800131:	5d                   	pop    %ebp
  800132:	c3                   	ret    

00800133 <sys_yield>:

void
sys_yield(void)
{
  800133:	55                   	push   %ebp
  800134:	89 e5                	mov    %esp,%ebp
  800136:	57                   	push   %edi
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800139:	ba 00 00 00 00       	mov    $0x0,%edx
  80013e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800143:	89 d1                	mov    %edx,%ecx
  800145:	89 d3                	mov    %edx,%ebx
  800147:	89 d7                	mov    %edx,%edi
  800149:	89 d6                	mov    %edx,%esi
  80014b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80014d:	5b                   	pop    %ebx
  80014e:	5e                   	pop    %esi
  80014f:	5f                   	pop    %edi
  800150:	5d                   	pop    %ebp
  800151:	c3                   	ret    

00800152 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800152:	55                   	push   %ebp
  800153:	89 e5                	mov    %esp,%ebp
  800155:	57                   	push   %edi
  800156:	56                   	push   %esi
  800157:	53                   	push   %ebx
  800158:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80015b:	be 00 00 00 00       	mov    $0x0,%esi
  800160:	8b 55 08             	mov    0x8(%ebp),%edx
  800163:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800166:	b8 04 00 00 00       	mov    $0x4,%eax
  80016b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80016e:	89 f7                	mov    %esi,%edi
  800170:	cd 30                	int    $0x30
	if(check && ret > 0)
  800172:	85 c0                	test   %eax,%eax
  800174:	7f 08                	jg     80017e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800176:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5f                   	pop    %edi
  80017c:	5d                   	pop    %ebp
  80017d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80017e:	83 ec 0c             	sub    $0xc,%esp
  800181:	50                   	push   %eax
  800182:	6a 04                	push   $0x4
  800184:	68 ca 0f 80 00       	push   $0x800fca
  800189:	6a 23                	push   $0x23
  80018b:	68 e7 0f 80 00       	push   $0x800fe7
  800190:	e8 ae 01 00 00       	call   800343 <_panic>

00800195 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	57                   	push   %edi
  800199:	56                   	push   %esi
  80019a:	53                   	push   %ebx
  80019b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80019e:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a4:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ac:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001af:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b4:	85 c0                	test   %eax,%eax
  8001b6:	7f 08                	jg     8001c0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bb:	5b                   	pop    %ebx
  8001bc:	5e                   	pop    %esi
  8001bd:	5f                   	pop    %edi
  8001be:	5d                   	pop    %ebp
  8001bf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	6a 05                	push   $0x5
  8001c6:	68 ca 0f 80 00       	push   $0x800fca
  8001cb:	6a 23                	push   $0x23
  8001cd:	68 e7 0f 80 00       	push   $0x800fe7
  8001d2:	e8 6c 01 00 00       	call   800343 <_panic>

008001d7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	57                   	push   %edi
  8001db:	56                   	push   %esi
  8001dc:	53                   	push   %ebx
  8001dd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8001e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001eb:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f0:	89 df                	mov    %ebx,%edi
  8001f2:	89 de                	mov    %ebx,%esi
  8001f4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f6:	85 c0                	test   %eax,%eax
  8001f8:	7f 08                	jg     800202 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001fd:	5b                   	pop    %ebx
  8001fe:	5e                   	pop    %esi
  8001ff:	5f                   	pop    %edi
  800200:	5d                   	pop    %ebp
  800201:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	6a 06                	push   $0x6
  800208:	68 ca 0f 80 00       	push   $0x800fca
  80020d:	6a 23                	push   $0x23
  80020f:	68 e7 0f 80 00       	push   $0x800fe7
  800214:	e8 2a 01 00 00       	call   800343 <_panic>

00800219 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	57                   	push   %edi
  80021d:	56                   	push   %esi
  80021e:	53                   	push   %ebx
  80021f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800222:	bb 00 00 00 00       	mov    $0x0,%ebx
  800227:	8b 55 08             	mov    0x8(%ebp),%edx
  80022a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80022d:	b8 08 00 00 00       	mov    $0x8,%eax
  800232:	89 df                	mov    %ebx,%edi
  800234:	89 de                	mov    %ebx,%esi
  800236:	cd 30                	int    $0x30
	if(check && ret > 0)
  800238:	85 c0                	test   %eax,%eax
  80023a:	7f 08                	jg     800244 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80023c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023f:	5b                   	pop    %ebx
  800240:	5e                   	pop    %esi
  800241:	5f                   	pop    %edi
  800242:	5d                   	pop    %ebp
  800243:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	50                   	push   %eax
  800248:	6a 08                	push   $0x8
  80024a:	68 ca 0f 80 00       	push   $0x800fca
  80024f:	6a 23                	push   $0x23
  800251:	68 e7 0f 80 00       	push   $0x800fe7
  800256:	e8 e8 00 00 00       	call   800343 <_panic>

0080025b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	57                   	push   %edi
  80025f:	56                   	push   %esi
  800260:	53                   	push   %ebx
  800261:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800264:	bb 00 00 00 00       	mov    $0x0,%ebx
  800269:	8b 55 08             	mov    0x8(%ebp),%edx
  80026c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026f:	b8 09 00 00 00       	mov    $0x9,%eax
  800274:	89 df                	mov    %ebx,%edi
  800276:	89 de                	mov    %ebx,%esi
  800278:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027a:	85 c0                	test   %eax,%eax
  80027c:	7f 08                	jg     800286 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80027e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800281:	5b                   	pop    %ebx
  800282:	5e                   	pop    %esi
  800283:	5f                   	pop    %edi
  800284:	5d                   	pop    %ebp
  800285:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	6a 09                	push   $0x9
  80028c:	68 ca 0f 80 00       	push   $0x800fca
  800291:	6a 23                	push   $0x23
  800293:	68 e7 0f 80 00       	push   $0x800fe7
  800298:	e8 a6 00 00 00       	call   800343 <_panic>

0080029d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	57                   	push   %edi
  8002a1:	56                   	push   %esi
  8002a2:	53                   	push   %ebx
  8002a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b6:	89 df                	mov    %ebx,%edi
  8002b8:	89 de                	mov    %ebx,%esi
  8002ba:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002bc:	85 c0                	test   %eax,%eax
  8002be:	7f 08                	jg     8002c8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c3:	5b                   	pop    %ebx
  8002c4:	5e                   	pop    %esi
  8002c5:	5f                   	pop    %edi
  8002c6:	5d                   	pop    %ebp
  8002c7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	6a 0a                	push   $0xa
  8002ce:	68 ca 0f 80 00       	push   $0x800fca
  8002d3:	6a 23                	push   $0x23
  8002d5:	68 e7 0f 80 00       	push   $0x800fe7
  8002da:	e8 64 00 00 00       	call   800343 <_panic>

008002df <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	57                   	push   %edi
  8002e3:	56                   	push   %esi
  8002e4:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002eb:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f0:	be 00 00 00 00       	mov    $0x0,%esi
  8002f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002f8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002fb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002fd:	5b                   	pop    %ebx
  8002fe:	5e                   	pop    %esi
  8002ff:	5f                   	pop    %edi
  800300:	5d                   	pop    %ebp
  800301:	c3                   	ret    

00800302 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	57                   	push   %edi
  800306:	56                   	push   %esi
  800307:	53                   	push   %ebx
  800308:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80030b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800310:	8b 55 08             	mov    0x8(%ebp),%edx
  800313:	b8 0d 00 00 00       	mov    $0xd,%eax
  800318:	89 cb                	mov    %ecx,%ebx
  80031a:	89 cf                	mov    %ecx,%edi
  80031c:	89 ce                	mov    %ecx,%esi
  80031e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800320:	85 c0                	test   %eax,%eax
  800322:	7f 08                	jg     80032c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800324:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800327:	5b                   	pop    %ebx
  800328:	5e                   	pop    %esi
  800329:	5f                   	pop    %edi
  80032a:	5d                   	pop    %ebp
  80032b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	50                   	push   %eax
  800330:	6a 0d                	push   $0xd
  800332:	68 ca 0f 80 00       	push   $0x800fca
  800337:	6a 23                	push   $0x23
  800339:	68 e7 0f 80 00       	push   $0x800fe7
  80033e:	e8 00 00 00 00       	call   800343 <_panic>

00800343 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	56                   	push   %esi
  800347:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800348:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80034b:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800351:	e8 be fd ff ff       	call   800114 <sys_getenvid>
  800356:	83 ec 0c             	sub    $0xc,%esp
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	56                   	push   %esi
  800360:	50                   	push   %eax
  800361:	68 f8 0f 80 00       	push   $0x800ff8
  800366:	e8 b3 00 00 00       	call   80041e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80036b:	83 c4 18             	add    $0x18,%esp
  80036e:	53                   	push   %ebx
  80036f:	ff 75 10             	pushl  0x10(%ebp)
  800372:	e8 56 00 00 00       	call   8003cd <vcprintf>
	cprintf("\n");
  800377:	c7 04 24 1b 10 80 00 	movl   $0x80101b,(%esp)
  80037e:	e8 9b 00 00 00       	call   80041e <cprintf>
  800383:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800386:	cc                   	int3   
  800387:	eb fd                	jmp    800386 <_panic+0x43>

00800389 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	53                   	push   %ebx
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800393:	8b 13                	mov    (%ebx),%edx
  800395:	8d 42 01             	lea    0x1(%edx),%eax
  800398:	89 03                	mov    %eax,(%ebx)
  80039a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80039d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a6:	74 09                	je     8003b1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003a8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003af:	c9                   	leave  
  8003b0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003b1:	83 ec 08             	sub    $0x8,%esp
  8003b4:	68 ff 00 00 00       	push   $0xff
  8003b9:	8d 43 08             	lea    0x8(%ebx),%eax
  8003bc:	50                   	push   %eax
  8003bd:	e8 d4 fc ff ff       	call   800096 <sys_cputs>
		b->idx = 0;
  8003c2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	eb db                	jmp    8003a8 <putch+0x1f>

008003cd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003d6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003dd:	00 00 00 
	b.cnt = 0;
  8003e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003e7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003ea:	ff 75 0c             	pushl  0xc(%ebp)
  8003ed:	ff 75 08             	pushl  0x8(%ebp)
  8003f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003f6:	50                   	push   %eax
  8003f7:	68 89 03 80 00       	push   $0x800389
  8003fc:	e8 1a 01 00 00       	call   80051b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800401:	83 c4 08             	add    $0x8,%esp
  800404:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80040a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800410:	50                   	push   %eax
  800411:	e8 80 fc ff ff       	call   800096 <sys_cputs>

	return b.cnt;
}
  800416:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80041c:	c9                   	leave  
  80041d:	c3                   	ret    

0080041e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80041e:	55                   	push   %ebp
  80041f:	89 e5                	mov    %esp,%ebp
  800421:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800424:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800427:	50                   	push   %eax
  800428:	ff 75 08             	pushl  0x8(%ebp)
  80042b:	e8 9d ff ff ff       	call   8003cd <vcprintf>
	va_end(ap);

	return cnt;
}
  800430:	c9                   	leave  
  800431:	c3                   	ret    

00800432 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
  800435:	57                   	push   %edi
  800436:	56                   	push   %esi
  800437:	53                   	push   %ebx
  800438:	83 ec 1c             	sub    $0x1c,%esp
  80043b:	89 c7                	mov    %eax,%edi
  80043d:	89 d6                	mov    %edx,%esi
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	8b 55 0c             	mov    0xc(%ebp),%edx
  800445:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800448:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80044b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80044e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800453:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800456:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800459:	39 d3                	cmp    %edx,%ebx
  80045b:	72 05                	jb     800462 <printnum+0x30>
  80045d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800460:	77 7a                	ja     8004dc <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 18             	pushl  0x18(%ebp)
  800468:	8b 45 14             	mov    0x14(%ebp),%eax
  80046b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80046e:	53                   	push   %ebx
  80046f:	ff 75 10             	pushl  0x10(%ebp)
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 e4             	pushl  -0x1c(%ebp)
  800478:	ff 75 e0             	pushl  -0x20(%ebp)
  80047b:	ff 75 dc             	pushl  -0x24(%ebp)
  80047e:	ff 75 d8             	pushl  -0x28(%ebp)
  800481:	e8 fa 08 00 00       	call   800d80 <__udivdi3>
  800486:	83 c4 18             	add    $0x18,%esp
  800489:	52                   	push   %edx
  80048a:	50                   	push   %eax
  80048b:	89 f2                	mov    %esi,%edx
  80048d:	89 f8                	mov    %edi,%eax
  80048f:	e8 9e ff ff ff       	call   800432 <printnum>
  800494:	83 c4 20             	add    $0x20,%esp
  800497:	eb 13                	jmp    8004ac <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	56                   	push   %esi
  80049d:	ff 75 18             	pushl  0x18(%ebp)
  8004a0:	ff d7                	call   *%edi
  8004a2:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004a5:	83 eb 01             	sub    $0x1,%ebx
  8004a8:	85 db                	test   %ebx,%ebx
  8004aa:	7f ed                	jg     800499 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ac:	83 ec 08             	sub    $0x8,%esp
  8004af:	56                   	push   %esi
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b9:	ff 75 dc             	pushl  -0x24(%ebp)
  8004bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8004bf:	e8 dc 09 00 00       	call   800ea0 <__umoddi3>
  8004c4:	83 c4 14             	add    $0x14,%esp
  8004c7:	0f be 80 1d 10 80 00 	movsbl 0x80101d(%eax),%eax
  8004ce:	50                   	push   %eax
  8004cf:	ff d7                	call   *%edi
}
  8004d1:	83 c4 10             	add    $0x10,%esp
  8004d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d7:	5b                   	pop    %ebx
  8004d8:	5e                   	pop    %esi
  8004d9:	5f                   	pop    %edi
  8004da:	5d                   	pop    %ebp
  8004db:	c3                   	ret    
  8004dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004df:	eb c4                	jmp    8004a5 <printnum+0x73>

008004e1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004e7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004eb:	8b 10                	mov    (%eax),%edx
  8004ed:	3b 50 04             	cmp    0x4(%eax),%edx
  8004f0:	73 0a                	jae    8004fc <sprintputch+0x1b>
		*b->buf++ = ch;
  8004f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004f5:	89 08                	mov    %ecx,(%eax)
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	88 02                	mov    %al,(%edx)
}
  8004fc:	5d                   	pop    %ebp
  8004fd:	c3                   	ret    

008004fe <printfmt>:
{
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
  800501:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800504:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800507:	50                   	push   %eax
  800508:	ff 75 10             	pushl  0x10(%ebp)
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	ff 75 08             	pushl  0x8(%ebp)
  800511:	e8 05 00 00 00       	call   80051b <vprintfmt>
}
  800516:	83 c4 10             	add    $0x10,%esp
  800519:	c9                   	leave  
  80051a:	c3                   	ret    

0080051b <vprintfmt>:
{
  80051b:	55                   	push   %ebp
  80051c:	89 e5                	mov    %esp,%ebp
  80051e:	57                   	push   %edi
  80051f:	56                   	push   %esi
  800520:	53                   	push   %ebx
  800521:	83 ec 2c             	sub    $0x2c,%esp
  800524:	8b 75 08             	mov    0x8(%ebp),%esi
  800527:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80052a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80052d:	e9 c1 03 00 00       	jmp    8008f3 <vprintfmt+0x3d8>
		padc = ' ';
  800532:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800536:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80053d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800544:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80054b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800550:	8d 47 01             	lea    0x1(%edi),%eax
  800553:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800556:	0f b6 17             	movzbl (%edi),%edx
  800559:	8d 42 dd             	lea    -0x23(%edx),%eax
  80055c:	3c 55                	cmp    $0x55,%al
  80055e:	0f 87 12 04 00 00    	ja     800976 <vprintfmt+0x45b>
  800564:	0f b6 c0             	movzbl %al,%eax
  800567:	ff 24 85 60 11 80 00 	jmp    *0x801160(,%eax,4)
  80056e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800571:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800575:	eb d9                	jmp    800550 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800577:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80057a:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80057e:	eb d0                	jmp    800550 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800580:	0f b6 d2             	movzbl %dl,%edx
  800583:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800586:	b8 00 00 00 00       	mov    $0x0,%eax
  80058b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80058e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800591:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800595:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800598:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80059b:	83 f9 09             	cmp    $0x9,%ecx
  80059e:	77 55                	ja     8005f5 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8005a0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005a3:	eb e9                	jmp    80058e <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8d 40 04             	lea    0x4(%eax),%eax
  8005b3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005bd:	79 91                	jns    800550 <vprintfmt+0x35>
				width = precision, precision = -1;
  8005bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005cc:	eb 82                	jmp    800550 <vprintfmt+0x35>
  8005ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d1:	85 c0                	test   %eax,%eax
  8005d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d8:	0f 49 d0             	cmovns %eax,%edx
  8005db:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005e1:	e9 6a ff ff ff       	jmp    800550 <vprintfmt+0x35>
  8005e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005e9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005f0:	e9 5b ff ff ff       	jmp    800550 <vprintfmt+0x35>
  8005f5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005fb:	eb bc                	jmp    8005b9 <vprintfmt+0x9e>
			lflag++;
  8005fd:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800600:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800603:	e9 48 ff ff ff       	jmp    800550 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8d 78 04             	lea    0x4(%eax),%edi
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	53                   	push   %ebx
  800612:	ff 30                	pushl  (%eax)
  800614:	ff d6                	call   *%esi
			break;
  800616:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800619:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80061c:	e9 cf 02 00 00       	jmp    8008f0 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8d 78 04             	lea    0x4(%eax),%edi
  800627:	8b 00                	mov    (%eax),%eax
  800629:	99                   	cltd   
  80062a:	31 d0                	xor    %edx,%eax
  80062c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80062e:	83 f8 0f             	cmp    $0xf,%eax
  800631:	7f 23                	jg     800656 <vprintfmt+0x13b>
  800633:	8b 14 85 c0 12 80 00 	mov    0x8012c0(,%eax,4),%edx
  80063a:	85 d2                	test   %edx,%edx
  80063c:	74 18                	je     800656 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80063e:	52                   	push   %edx
  80063f:	68 3e 10 80 00       	push   $0x80103e
  800644:	53                   	push   %ebx
  800645:	56                   	push   %esi
  800646:	e8 b3 fe ff ff       	call   8004fe <printfmt>
  80064b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80064e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800651:	e9 9a 02 00 00       	jmp    8008f0 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800656:	50                   	push   %eax
  800657:	68 35 10 80 00       	push   $0x801035
  80065c:	53                   	push   %ebx
  80065d:	56                   	push   %esi
  80065e:	e8 9b fe ff ff       	call   8004fe <printfmt>
  800663:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800666:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800669:	e9 82 02 00 00       	jmp    8008f0 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	83 c0 04             	add    $0x4,%eax
  800674:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80067c:	85 ff                	test   %edi,%edi
  80067e:	b8 2e 10 80 00       	mov    $0x80102e,%eax
  800683:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800686:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80068a:	0f 8e bd 00 00 00    	jle    80074d <vprintfmt+0x232>
  800690:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800694:	75 0e                	jne    8006a4 <vprintfmt+0x189>
  800696:	89 75 08             	mov    %esi,0x8(%ebp)
  800699:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80069c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80069f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006a2:	eb 6d                	jmp    800711 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	ff 75 d0             	pushl  -0x30(%ebp)
  8006aa:	57                   	push   %edi
  8006ab:	e8 6e 03 00 00       	call   800a1e <strnlen>
  8006b0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006b3:	29 c1                	sub    %eax,%ecx
  8006b5:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8006b8:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006bb:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006c5:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c7:	eb 0f                	jmp    8006d8 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d2:	83 ef 01             	sub    $0x1,%edi
  8006d5:	83 c4 10             	add    $0x10,%esp
  8006d8:	85 ff                	test   %edi,%edi
  8006da:	7f ed                	jg     8006c9 <vprintfmt+0x1ae>
  8006dc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006df:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006e2:	85 c9                	test   %ecx,%ecx
  8006e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e9:	0f 49 c1             	cmovns %ecx,%eax
  8006ec:	29 c1                	sub    %eax,%ecx
  8006ee:	89 75 08             	mov    %esi,0x8(%ebp)
  8006f1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006f4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006f7:	89 cb                	mov    %ecx,%ebx
  8006f9:	eb 16                	jmp    800711 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006fb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006ff:	75 31                	jne    800732 <vprintfmt+0x217>
					putch(ch, putdat);
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	ff 75 0c             	pushl  0xc(%ebp)
  800707:	50                   	push   %eax
  800708:	ff 55 08             	call   *0x8(%ebp)
  80070b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070e:	83 eb 01             	sub    $0x1,%ebx
  800711:	83 c7 01             	add    $0x1,%edi
  800714:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800718:	0f be c2             	movsbl %dl,%eax
  80071b:	85 c0                	test   %eax,%eax
  80071d:	74 59                	je     800778 <vprintfmt+0x25d>
  80071f:	85 f6                	test   %esi,%esi
  800721:	78 d8                	js     8006fb <vprintfmt+0x1e0>
  800723:	83 ee 01             	sub    $0x1,%esi
  800726:	79 d3                	jns    8006fb <vprintfmt+0x1e0>
  800728:	89 df                	mov    %ebx,%edi
  80072a:	8b 75 08             	mov    0x8(%ebp),%esi
  80072d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800730:	eb 37                	jmp    800769 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800732:	0f be d2             	movsbl %dl,%edx
  800735:	83 ea 20             	sub    $0x20,%edx
  800738:	83 fa 5e             	cmp    $0x5e,%edx
  80073b:	76 c4                	jbe    800701 <vprintfmt+0x1e6>
					putch('?', putdat);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 0c             	pushl  0xc(%ebp)
  800743:	6a 3f                	push   $0x3f
  800745:	ff 55 08             	call   *0x8(%ebp)
  800748:	83 c4 10             	add    $0x10,%esp
  80074b:	eb c1                	jmp    80070e <vprintfmt+0x1f3>
  80074d:	89 75 08             	mov    %esi,0x8(%ebp)
  800750:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800753:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800756:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800759:	eb b6                	jmp    800711 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	53                   	push   %ebx
  80075f:	6a 20                	push   $0x20
  800761:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800763:	83 ef 01             	sub    $0x1,%edi
  800766:	83 c4 10             	add    $0x10,%esp
  800769:	85 ff                	test   %edi,%edi
  80076b:	7f ee                	jg     80075b <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80076d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800770:	89 45 14             	mov    %eax,0x14(%ebp)
  800773:	e9 78 01 00 00       	jmp    8008f0 <vprintfmt+0x3d5>
  800778:	89 df                	mov    %ebx,%edi
  80077a:	8b 75 08             	mov    0x8(%ebp),%esi
  80077d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800780:	eb e7                	jmp    800769 <vprintfmt+0x24e>
	if (lflag >= 2)
  800782:	83 f9 01             	cmp    $0x1,%ecx
  800785:	7e 3f                	jle    8007c6 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8b 50 04             	mov    0x4(%eax),%edx
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800792:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8d 40 08             	lea    0x8(%eax),%eax
  80079b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80079e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007a2:	79 5c                	jns    800800 <vprintfmt+0x2e5>
				putch('-', putdat);
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	53                   	push   %ebx
  8007a8:	6a 2d                	push   $0x2d
  8007aa:	ff d6                	call   *%esi
				num = -(long long) num;
  8007ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007af:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007b2:	f7 da                	neg    %edx
  8007b4:	83 d1 00             	adc    $0x0,%ecx
  8007b7:	f7 d9                	neg    %ecx
  8007b9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007bc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c1:	e9 10 01 00 00       	jmp    8008d6 <vprintfmt+0x3bb>
	else if (lflag)
  8007c6:	85 c9                	test   %ecx,%ecx
  8007c8:	75 1b                	jne    8007e5 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d2:	89 c1                	mov    %eax,%ecx
  8007d4:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8d 40 04             	lea    0x4(%eax),%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e3:	eb b9                	jmp    80079e <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ed:	89 c1                	mov    %eax,%ecx
  8007ef:	c1 f9 1f             	sar    $0x1f,%ecx
  8007f2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	8d 40 04             	lea    0x4(%eax),%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fe:	eb 9e                	jmp    80079e <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800800:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800803:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800806:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080b:	e9 c6 00 00 00       	jmp    8008d6 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800810:	83 f9 01             	cmp    $0x1,%ecx
  800813:	7e 18                	jle    80082d <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8b 10                	mov    (%eax),%edx
  80081a:	8b 48 04             	mov    0x4(%eax),%ecx
  80081d:	8d 40 08             	lea    0x8(%eax),%eax
  800820:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800823:	b8 0a 00 00 00       	mov    $0xa,%eax
  800828:	e9 a9 00 00 00       	jmp    8008d6 <vprintfmt+0x3bb>
	else if (lflag)
  80082d:	85 c9                	test   %ecx,%ecx
  80082f:	75 1a                	jne    80084b <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8b 10                	mov    (%eax),%edx
  800836:	b9 00 00 00 00       	mov    $0x0,%ecx
  80083b:	8d 40 04             	lea    0x4(%eax),%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800841:	b8 0a 00 00 00       	mov    $0xa,%eax
  800846:	e9 8b 00 00 00       	jmp    8008d6 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	8b 10                	mov    (%eax),%edx
  800850:	b9 00 00 00 00       	mov    $0x0,%ecx
  800855:	8d 40 04             	lea    0x4(%eax),%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80085b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800860:	eb 74                	jmp    8008d6 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800862:	83 f9 01             	cmp    $0x1,%ecx
  800865:	7e 15                	jle    80087c <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800867:	8b 45 14             	mov    0x14(%ebp),%eax
  80086a:	8b 10                	mov    (%eax),%edx
  80086c:	8b 48 04             	mov    0x4(%eax),%ecx
  80086f:	8d 40 08             	lea    0x8(%eax),%eax
  800872:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800875:	b8 08 00 00 00       	mov    $0x8,%eax
  80087a:	eb 5a                	jmp    8008d6 <vprintfmt+0x3bb>
	else if (lflag)
  80087c:	85 c9                	test   %ecx,%ecx
  80087e:	75 17                	jne    800897 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	8b 10                	mov    (%eax),%edx
  800885:	b9 00 00 00 00       	mov    $0x0,%ecx
  80088a:	8d 40 04             	lea    0x4(%eax),%eax
  80088d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800890:	b8 08 00 00 00       	mov    $0x8,%eax
  800895:	eb 3f                	jmp    8008d6 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8b 10                	mov    (%eax),%edx
  80089c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008a1:	8d 40 04             	lea    0x4(%eax),%eax
  8008a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008a7:	b8 08 00 00 00       	mov    $0x8,%eax
  8008ac:	eb 28                	jmp    8008d6 <vprintfmt+0x3bb>
			putch('0', putdat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	53                   	push   %ebx
  8008b2:	6a 30                	push   $0x30
  8008b4:	ff d6                	call   *%esi
			putch('x', putdat);
  8008b6:	83 c4 08             	add    $0x8,%esp
  8008b9:	53                   	push   %ebx
  8008ba:	6a 78                	push   $0x78
  8008bc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008be:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c1:	8b 10                	mov    (%eax),%edx
  8008c3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008c8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008cb:	8d 40 04             	lea    0x4(%eax),%eax
  8008ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008d6:	83 ec 0c             	sub    $0xc,%esp
  8008d9:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008dd:	57                   	push   %edi
  8008de:	ff 75 e0             	pushl  -0x20(%ebp)
  8008e1:	50                   	push   %eax
  8008e2:	51                   	push   %ecx
  8008e3:	52                   	push   %edx
  8008e4:	89 da                	mov    %ebx,%edx
  8008e6:	89 f0                	mov    %esi,%eax
  8008e8:	e8 45 fb ff ff       	call   800432 <printnum>
			break;
  8008ed:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  8008f3:	83 c7 01             	add    $0x1,%edi
  8008f6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008fa:	83 f8 25             	cmp    $0x25,%eax
  8008fd:	0f 84 2f fc ff ff    	je     800532 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  800903:	85 c0                	test   %eax,%eax
  800905:	0f 84 8b 00 00 00    	je     800996 <vprintfmt+0x47b>
			putch(ch, putdat);
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	53                   	push   %ebx
  80090f:	50                   	push   %eax
  800910:	ff d6                	call   *%esi
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	eb dc                	jmp    8008f3 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800917:	83 f9 01             	cmp    $0x1,%ecx
  80091a:	7e 15                	jle    800931 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  80091c:	8b 45 14             	mov    0x14(%ebp),%eax
  80091f:	8b 10                	mov    (%eax),%edx
  800921:	8b 48 04             	mov    0x4(%eax),%ecx
  800924:	8d 40 08             	lea    0x8(%eax),%eax
  800927:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80092a:	b8 10 00 00 00       	mov    $0x10,%eax
  80092f:	eb a5                	jmp    8008d6 <vprintfmt+0x3bb>
	else if (lflag)
  800931:	85 c9                	test   %ecx,%ecx
  800933:	75 17                	jne    80094c <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	8b 10                	mov    (%eax),%edx
  80093a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093f:	8d 40 04             	lea    0x4(%eax),%eax
  800942:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800945:	b8 10 00 00 00       	mov    $0x10,%eax
  80094a:	eb 8a                	jmp    8008d6 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	8b 10                	mov    (%eax),%edx
  800951:	b9 00 00 00 00       	mov    $0x0,%ecx
  800956:	8d 40 04             	lea    0x4(%eax),%eax
  800959:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80095c:	b8 10 00 00 00       	mov    $0x10,%eax
  800961:	e9 70 ff ff ff       	jmp    8008d6 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	53                   	push   %ebx
  80096a:	6a 25                	push   $0x25
  80096c:	ff d6                	call   *%esi
			break;
  80096e:	83 c4 10             	add    $0x10,%esp
  800971:	e9 7a ff ff ff       	jmp    8008f0 <vprintfmt+0x3d5>
			putch('%', putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	53                   	push   %ebx
  80097a:	6a 25                	push   $0x25
  80097c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80097e:	83 c4 10             	add    $0x10,%esp
  800981:	89 f8                	mov    %edi,%eax
  800983:	eb 03                	jmp    800988 <vprintfmt+0x46d>
  800985:	83 e8 01             	sub    $0x1,%eax
  800988:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80098c:	75 f7                	jne    800985 <vprintfmt+0x46a>
  80098e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800991:	e9 5a ff ff ff       	jmp    8008f0 <vprintfmt+0x3d5>
}
  800996:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800999:	5b                   	pop    %ebx
  80099a:	5e                   	pop    %esi
  80099b:	5f                   	pop    %edi
  80099c:	5d                   	pop    %ebp
  80099d:	c3                   	ret    

0080099e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	83 ec 18             	sub    $0x18,%esp
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ad:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009b1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009bb:	85 c0                	test   %eax,%eax
  8009bd:	74 26                	je     8009e5 <vsnprintf+0x47>
  8009bf:	85 d2                	test   %edx,%edx
  8009c1:	7e 22                	jle    8009e5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009c3:	ff 75 14             	pushl  0x14(%ebp)
  8009c6:	ff 75 10             	pushl  0x10(%ebp)
  8009c9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009cc:	50                   	push   %eax
  8009cd:	68 e1 04 80 00       	push   $0x8004e1
  8009d2:	e8 44 fb ff ff       	call   80051b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009da:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e0:	83 c4 10             	add    $0x10,%esp
}
  8009e3:	c9                   	leave  
  8009e4:	c3                   	ret    
		return -E_INVAL;
  8009e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009ea:	eb f7                	jmp    8009e3 <vsnprintf+0x45>

008009ec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009f2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009f5:	50                   	push   %eax
  8009f6:	ff 75 10             	pushl  0x10(%ebp)
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	ff 75 08             	pushl  0x8(%ebp)
  8009ff:	e8 9a ff ff ff       	call   80099e <vsnprintf>
	va_end(ap);

	return rc;
}
  800a04:	c9                   	leave  
  800a05:	c3                   	ret    

00800a06 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a11:	eb 03                	jmp    800a16 <strlen+0x10>
		n++;
  800a13:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a16:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a1a:	75 f7                	jne    800a13 <strlen+0xd>
	return n;
}
  800a1c:	5d                   	pop    %ebp
  800a1d:	c3                   	ret    

00800a1e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a24:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a27:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2c:	eb 03                	jmp    800a31 <strnlen+0x13>
		n++;
  800a2e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a31:	39 d0                	cmp    %edx,%eax
  800a33:	74 06                	je     800a3b <strnlen+0x1d>
  800a35:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a39:	75 f3                	jne    800a2e <strnlen+0x10>
	return n;
}
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	53                   	push   %ebx
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a47:	89 c2                	mov    %eax,%edx
  800a49:	83 c1 01             	add    $0x1,%ecx
  800a4c:	83 c2 01             	add    $0x1,%edx
  800a4f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a53:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a56:	84 db                	test   %bl,%bl
  800a58:	75 ef                	jne    800a49 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a5a:	5b                   	pop    %ebx
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    

00800a5d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	53                   	push   %ebx
  800a61:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a64:	53                   	push   %ebx
  800a65:	e8 9c ff ff ff       	call   800a06 <strlen>
  800a6a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a6d:	ff 75 0c             	pushl  0xc(%ebp)
  800a70:	01 d8                	add    %ebx,%eax
  800a72:	50                   	push   %eax
  800a73:	e8 c5 ff ff ff       	call   800a3d <strcpy>
	return dst;
}
  800a78:	89 d8                	mov    %ebx,%eax
  800a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7d:	c9                   	leave  
  800a7e:	c3                   	ret    

00800a7f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	56                   	push   %esi
  800a83:	53                   	push   %ebx
  800a84:	8b 75 08             	mov    0x8(%ebp),%esi
  800a87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a8a:	89 f3                	mov    %esi,%ebx
  800a8c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a8f:	89 f2                	mov    %esi,%edx
  800a91:	eb 0f                	jmp    800aa2 <strncpy+0x23>
		*dst++ = *src;
  800a93:	83 c2 01             	add    $0x1,%edx
  800a96:	0f b6 01             	movzbl (%ecx),%eax
  800a99:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a9c:	80 39 01             	cmpb   $0x1,(%ecx)
  800a9f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800aa2:	39 da                	cmp    %ebx,%edx
  800aa4:	75 ed                	jne    800a93 <strncpy+0x14>
	}
	return ret;
}
  800aa6:	89 f0                	mov    %esi,%eax
  800aa8:	5b                   	pop    %ebx
  800aa9:	5e                   	pop    %esi
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	56                   	push   %esi
  800ab0:	53                   	push   %ebx
  800ab1:	8b 75 08             	mov    0x8(%ebp),%esi
  800ab4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800aba:	89 f0                	mov    %esi,%eax
  800abc:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac0:	85 c9                	test   %ecx,%ecx
  800ac2:	75 0b                	jne    800acf <strlcpy+0x23>
  800ac4:	eb 17                	jmp    800add <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ac6:	83 c2 01             	add    $0x1,%edx
  800ac9:	83 c0 01             	add    $0x1,%eax
  800acc:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800acf:	39 d8                	cmp    %ebx,%eax
  800ad1:	74 07                	je     800ada <strlcpy+0x2e>
  800ad3:	0f b6 0a             	movzbl (%edx),%ecx
  800ad6:	84 c9                	test   %cl,%cl
  800ad8:	75 ec                	jne    800ac6 <strlcpy+0x1a>
		*dst = '\0';
  800ada:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800add:	29 f0                	sub    %esi,%eax
}
  800adf:	5b                   	pop    %ebx
  800ae0:	5e                   	pop    %esi
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aec:	eb 06                	jmp    800af4 <strcmp+0x11>
		p++, q++;
  800aee:	83 c1 01             	add    $0x1,%ecx
  800af1:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800af4:	0f b6 01             	movzbl (%ecx),%eax
  800af7:	84 c0                	test   %al,%al
  800af9:	74 04                	je     800aff <strcmp+0x1c>
  800afb:	3a 02                	cmp    (%edx),%al
  800afd:	74 ef                	je     800aee <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aff:	0f b6 c0             	movzbl %al,%eax
  800b02:	0f b6 12             	movzbl (%edx),%edx
  800b05:	29 d0                	sub    %edx,%eax
}
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	53                   	push   %ebx
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b13:	89 c3                	mov    %eax,%ebx
  800b15:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b18:	eb 06                	jmp    800b20 <strncmp+0x17>
		n--, p++, q++;
  800b1a:	83 c0 01             	add    $0x1,%eax
  800b1d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b20:	39 d8                	cmp    %ebx,%eax
  800b22:	74 16                	je     800b3a <strncmp+0x31>
  800b24:	0f b6 08             	movzbl (%eax),%ecx
  800b27:	84 c9                	test   %cl,%cl
  800b29:	74 04                	je     800b2f <strncmp+0x26>
  800b2b:	3a 0a                	cmp    (%edx),%cl
  800b2d:	74 eb                	je     800b1a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2f:	0f b6 00             	movzbl (%eax),%eax
  800b32:	0f b6 12             	movzbl (%edx),%edx
  800b35:	29 d0                	sub    %edx,%eax
}
  800b37:	5b                   	pop    %ebx
  800b38:	5d                   	pop    %ebp
  800b39:	c3                   	ret    
		return 0;
  800b3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3f:	eb f6                	jmp    800b37 <strncmp+0x2e>

00800b41 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b4b:	0f b6 10             	movzbl (%eax),%edx
  800b4e:	84 d2                	test   %dl,%dl
  800b50:	74 09                	je     800b5b <strchr+0x1a>
		if (*s == c)
  800b52:	38 ca                	cmp    %cl,%dl
  800b54:	74 0a                	je     800b60 <strchr+0x1f>
	for (; *s; s++)
  800b56:	83 c0 01             	add    $0x1,%eax
  800b59:	eb f0                	jmp    800b4b <strchr+0xa>
			return (char *) s;
	return 0;
  800b5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b60:	5d                   	pop    %ebp
  800b61:	c3                   	ret    

00800b62 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b6c:	eb 03                	jmp    800b71 <strfind+0xf>
  800b6e:	83 c0 01             	add    $0x1,%eax
  800b71:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b74:	38 ca                	cmp    %cl,%dl
  800b76:	74 04                	je     800b7c <strfind+0x1a>
  800b78:	84 d2                	test   %dl,%dl
  800b7a:	75 f2                	jne    800b6e <strfind+0xc>
			break;
	return (char *) s;
}
  800b7c:	5d                   	pop    %ebp
  800b7d:	c3                   	ret    

00800b7e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	57                   	push   %edi
  800b82:	56                   	push   %esi
  800b83:	53                   	push   %ebx
  800b84:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b87:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b8a:	85 c9                	test   %ecx,%ecx
  800b8c:	74 13                	je     800ba1 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b8e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b94:	75 05                	jne    800b9b <memset+0x1d>
  800b96:	f6 c1 03             	test   $0x3,%cl
  800b99:	74 0d                	je     800ba8 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9e:	fc                   	cld    
  800b9f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ba1:	89 f8                	mov    %edi,%eax
  800ba3:	5b                   	pop    %ebx
  800ba4:	5e                   	pop    %esi
  800ba5:	5f                   	pop    %edi
  800ba6:	5d                   	pop    %ebp
  800ba7:	c3                   	ret    
		c &= 0xFF;
  800ba8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bac:	89 d3                	mov    %edx,%ebx
  800bae:	c1 e3 08             	shl    $0x8,%ebx
  800bb1:	89 d0                	mov    %edx,%eax
  800bb3:	c1 e0 18             	shl    $0x18,%eax
  800bb6:	89 d6                	mov    %edx,%esi
  800bb8:	c1 e6 10             	shl    $0x10,%esi
  800bbb:	09 f0                	or     %esi,%eax
  800bbd:	09 c2                	or     %eax,%edx
  800bbf:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bc1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bc4:	89 d0                	mov    %edx,%eax
  800bc6:	fc                   	cld    
  800bc7:	f3 ab                	rep stos %eax,%es:(%edi)
  800bc9:	eb d6                	jmp    800ba1 <memset+0x23>

00800bcb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	57                   	push   %edi
  800bcf:	56                   	push   %esi
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bd9:	39 c6                	cmp    %eax,%esi
  800bdb:	73 35                	jae    800c12 <memmove+0x47>
  800bdd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800be0:	39 c2                	cmp    %eax,%edx
  800be2:	76 2e                	jbe    800c12 <memmove+0x47>
		s += n;
		d += n;
  800be4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be7:	89 d6                	mov    %edx,%esi
  800be9:	09 fe                	or     %edi,%esi
  800beb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bf1:	74 0c                	je     800bff <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bf3:	83 ef 01             	sub    $0x1,%edi
  800bf6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bf9:	fd                   	std    
  800bfa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bfc:	fc                   	cld    
  800bfd:	eb 21                	jmp    800c20 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bff:	f6 c1 03             	test   $0x3,%cl
  800c02:	75 ef                	jne    800bf3 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c04:	83 ef 04             	sub    $0x4,%edi
  800c07:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c0a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c0d:	fd                   	std    
  800c0e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c10:	eb ea                	jmp    800bfc <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c12:	89 f2                	mov    %esi,%edx
  800c14:	09 c2                	or     %eax,%edx
  800c16:	f6 c2 03             	test   $0x3,%dl
  800c19:	74 09                	je     800c24 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c1b:	89 c7                	mov    %eax,%edi
  800c1d:	fc                   	cld    
  800c1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c20:	5e                   	pop    %esi
  800c21:	5f                   	pop    %edi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c24:	f6 c1 03             	test   $0x3,%cl
  800c27:	75 f2                	jne    800c1b <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c29:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c2c:	89 c7                	mov    %eax,%edi
  800c2e:	fc                   	cld    
  800c2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c31:	eb ed                	jmp    800c20 <memmove+0x55>

00800c33 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c36:	ff 75 10             	pushl  0x10(%ebp)
  800c39:	ff 75 0c             	pushl  0xc(%ebp)
  800c3c:	ff 75 08             	pushl  0x8(%ebp)
  800c3f:	e8 87 ff ff ff       	call   800bcb <memmove>
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	56                   	push   %esi
  800c4a:	53                   	push   %ebx
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c51:	89 c6                	mov    %eax,%esi
  800c53:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c56:	39 f0                	cmp    %esi,%eax
  800c58:	74 1c                	je     800c76 <memcmp+0x30>
		if (*s1 != *s2)
  800c5a:	0f b6 08             	movzbl (%eax),%ecx
  800c5d:	0f b6 1a             	movzbl (%edx),%ebx
  800c60:	38 d9                	cmp    %bl,%cl
  800c62:	75 08                	jne    800c6c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c64:	83 c0 01             	add    $0x1,%eax
  800c67:	83 c2 01             	add    $0x1,%edx
  800c6a:	eb ea                	jmp    800c56 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c6c:	0f b6 c1             	movzbl %cl,%eax
  800c6f:	0f b6 db             	movzbl %bl,%ebx
  800c72:	29 d8                	sub    %ebx,%eax
  800c74:	eb 05                	jmp    800c7b <memcmp+0x35>
	}

	return 0;
  800c76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7b:	5b                   	pop    %ebx
  800c7c:	5e                   	pop    %esi
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c88:	89 c2                	mov    %eax,%edx
  800c8a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c8d:	39 d0                	cmp    %edx,%eax
  800c8f:	73 09                	jae    800c9a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c91:	38 08                	cmp    %cl,(%eax)
  800c93:	74 05                	je     800c9a <memfind+0x1b>
	for (; s < ends; s++)
  800c95:	83 c0 01             	add    $0x1,%eax
  800c98:	eb f3                	jmp    800c8d <memfind+0xe>
			break;
	return (void *) s;
}
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	57                   	push   %edi
  800ca0:	56                   	push   %esi
  800ca1:	53                   	push   %ebx
  800ca2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ca8:	eb 03                	jmp    800cad <strtol+0x11>
		s++;
  800caa:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cad:	0f b6 01             	movzbl (%ecx),%eax
  800cb0:	3c 20                	cmp    $0x20,%al
  800cb2:	74 f6                	je     800caa <strtol+0xe>
  800cb4:	3c 09                	cmp    $0x9,%al
  800cb6:	74 f2                	je     800caa <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cb8:	3c 2b                	cmp    $0x2b,%al
  800cba:	74 2e                	je     800cea <strtol+0x4e>
	int neg = 0;
  800cbc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cc1:	3c 2d                	cmp    $0x2d,%al
  800cc3:	74 2f                	je     800cf4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ccb:	75 05                	jne    800cd2 <strtol+0x36>
  800ccd:	80 39 30             	cmpb   $0x30,(%ecx)
  800cd0:	74 2c                	je     800cfe <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cd2:	85 db                	test   %ebx,%ebx
  800cd4:	75 0a                	jne    800ce0 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cd6:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cdb:	80 39 30             	cmpb   $0x30,(%ecx)
  800cde:	74 28                	je     800d08 <strtol+0x6c>
		base = 10;
  800ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ce8:	eb 50                	jmp    800d3a <strtol+0x9e>
		s++;
  800cea:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ced:	bf 00 00 00 00       	mov    $0x0,%edi
  800cf2:	eb d1                	jmp    800cc5 <strtol+0x29>
		s++, neg = 1;
  800cf4:	83 c1 01             	add    $0x1,%ecx
  800cf7:	bf 01 00 00 00       	mov    $0x1,%edi
  800cfc:	eb c7                	jmp    800cc5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cfe:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d02:	74 0e                	je     800d12 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d04:	85 db                	test   %ebx,%ebx
  800d06:	75 d8                	jne    800ce0 <strtol+0x44>
		s++, base = 8;
  800d08:	83 c1 01             	add    $0x1,%ecx
  800d0b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d10:	eb ce                	jmp    800ce0 <strtol+0x44>
		s += 2, base = 16;
  800d12:	83 c1 02             	add    $0x2,%ecx
  800d15:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d1a:	eb c4                	jmp    800ce0 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d1c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d1f:	89 f3                	mov    %esi,%ebx
  800d21:	80 fb 19             	cmp    $0x19,%bl
  800d24:	77 29                	ja     800d4f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d26:	0f be d2             	movsbl %dl,%edx
  800d29:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d2c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d2f:	7d 30                	jge    800d61 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d31:	83 c1 01             	add    $0x1,%ecx
  800d34:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d38:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d3a:	0f b6 11             	movzbl (%ecx),%edx
  800d3d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d40:	89 f3                	mov    %esi,%ebx
  800d42:	80 fb 09             	cmp    $0x9,%bl
  800d45:	77 d5                	ja     800d1c <strtol+0x80>
			dig = *s - '0';
  800d47:	0f be d2             	movsbl %dl,%edx
  800d4a:	83 ea 30             	sub    $0x30,%edx
  800d4d:	eb dd                	jmp    800d2c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d4f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d52:	89 f3                	mov    %esi,%ebx
  800d54:	80 fb 19             	cmp    $0x19,%bl
  800d57:	77 08                	ja     800d61 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d59:	0f be d2             	movsbl %dl,%edx
  800d5c:	83 ea 37             	sub    $0x37,%edx
  800d5f:	eb cb                	jmp    800d2c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d65:	74 05                	je     800d6c <strtol+0xd0>
		*endptr = (char *) s;
  800d67:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d6a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d6c:	89 c2                	mov    %eax,%edx
  800d6e:	f7 da                	neg    %edx
  800d70:	85 ff                	test   %edi,%edi
  800d72:	0f 45 c2             	cmovne %edx,%eax
}
  800d75:	5b                   	pop    %ebx
  800d76:	5e                   	pop    %esi
  800d77:	5f                   	pop    %edi
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    
  800d7a:	66 90                	xchg   %ax,%ax
  800d7c:	66 90                	xchg   %ax,%ax
  800d7e:	66 90                	xchg   %ax,%ax

00800d80 <__udivdi3>:
  800d80:	55                   	push   %ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	83 ec 1c             	sub    $0x1c,%esp
  800d87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800d8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800d8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800d93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800d97:	85 d2                	test   %edx,%edx
  800d99:	75 35                	jne    800dd0 <__udivdi3+0x50>
  800d9b:	39 f3                	cmp    %esi,%ebx
  800d9d:	0f 87 bd 00 00 00    	ja     800e60 <__udivdi3+0xe0>
  800da3:	85 db                	test   %ebx,%ebx
  800da5:	89 d9                	mov    %ebx,%ecx
  800da7:	75 0b                	jne    800db4 <__udivdi3+0x34>
  800da9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dae:	31 d2                	xor    %edx,%edx
  800db0:	f7 f3                	div    %ebx
  800db2:	89 c1                	mov    %eax,%ecx
  800db4:	31 d2                	xor    %edx,%edx
  800db6:	89 f0                	mov    %esi,%eax
  800db8:	f7 f1                	div    %ecx
  800dba:	89 c6                	mov    %eax,%esi
  800dbc:	89 e8                	mov    %ebp,%eax
  800dbe:	89 f7                	mov    %esi,%edi
  800dc0:	f7 f1                	div    %ecx
  800dc2:	89 fa                	mov    %edi,%edx
  800dc4:	83 c4 1c             	add    $0x1c,%esp
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5f                   	pop    %edi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    
  800dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800dd0:	39 f2                	cmp    %esi,%edx
  800dd2:	77 7c                	ja     800e50 <__udivdi3+0xd0>
  800dd4:	0f bd fa             	bsr    %edx,%edi
  800dd7:	83 f7 1f             	xor    $0x1f,%edi
  800dda:	0f 84 98 00 00 00    	je     800e78 <__udivdi3+0xf8>
  800de0:	89 f9                	mov    %edi,%ecx
  800de2:	b8 20 00 00 00       	mov    $0x20,%eax
  800de7:	29 f8                	sub    %edi,%eax
  800de9:	d3 e2                	shl    %cl,%edx
  800deb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800def:	89 c1                	mov    %eax,%ecx
  800df1:	89 da                	mov    %ebx,%edx
  800df3:	d3 ea                	shr    %cl,%edx
  800df5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800df9:	09 d1                	or     %edx,%ecx
  800dfb:	89 f2                	mov    %esi,%edx
  800dfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e01:	89 f9                	mov    %edi,%ecx
  800e03:	d3 e3                	shl    %cl,%ebx
  800e05:	89 c1                	mov    %eax,%ecx
  800e07:	d3 ea                	shr    %cl,%edx
  800e09:	89 f9                	mov    %edi,%ecx
  800e0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e0f:	d3 e6                	shl    %cl,%esi
  800e11:	89 eb                	mov    %ebp,%ebx
  800e13:	89 c1                	mov    %eax,%ecx
  800e15:	d3 eb                	shr    %cl,%ebx
  800e17:	09 de                	or     %ebx,%esi
  800e19:	89 f0                	mov    %esi,%eax
  800e1b:	f7 74 24 08          	divl   0x8(%esp)
  800e1f:	89 d6                	mov    %edx,%esi
  800e21:	89 c3                	mov    %eax,%ebx
  800e23:	f7 64 24 0c          	mull   0xc(%esp)
  800e27:	39 d6                	cmp    %edx,%esi
  800e29:	72 0c                	jb     800e37 <__udivdi3+0xb7>
  800e2b:	89 f9                	mov    %edi,%ecx
  800e2d:	d3 e5                	shl    %cl,%ebp
  800e2f:	39 c5                	cmp    %eax,%ebp
  800e31:	73 5d                	jae    800e90 <__udivdi3+0x110>
  800e33:	39 d6                	cmp    %edx,%esi
  800e35:	75 59                	jne    800e90 <__udivdi3+0x110>
  800e37:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e3a:	31 ff                	xor    %edi,%edi
  800e3c:	89 fa                	mov    %edi,%edx
  800e3e:	83 c4 1c             	add    $0x1c,%esp
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    
  800e46:	8d 76 00             	lea    0x0(%esi),%esi
  800e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800e50:	31 ff                	xor    %edi,%edi
  800e52:	31 c0                	xor    %eax,%eax
  800e54:	89 fa                	mov    %edi,%edx
  800e56:	83 c4 1c             	add    $0x1c,%esp
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    
  800e5e:	66 90                	xchg   %ax,%ax
  800e60:	31 ff                	xor    %edi,%edi
  800e62:	89 e8                	mov    %ebp,%eax
  800e64:	89 f2                	mov    %esi,%edx
  800e66:	f7 f3                	div    %ebx
  800e68:	89 fa                	mov    %edi,%edx
  800e6a:	83 c4 1c             	add    $0x1c,%esp
  800e6d:	5b                   	pop    %ebx
  800e6e:	5e                   	pop    %esi
  800e6f:	5f                   	pop    %edi
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    
  800e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e78:	39 f2                	cmp    %esi,%edx
  800e7a:	72 06                	jb     800e82 <__udivdi3+0x102>
  800e7c:	31 c0                	xor    %eax,%eax
  800e7e:	39 eb                	cmp    %ebp,%ebx
  800e80:	77 d2                	ja     800e54 <__udivdi3+0xd4>
  800e82:	b8 01 00 00 00       	mov    $0x1,%eax
  800e87:	eb cb                	jmp    800e54 <__udivdi3+0xd4>
  800e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800e90:	89 d8                	mov    %ebx,%eax
  800e92:	31 ff                	xor    %edi,%edi
  800e94:	eb be                	jmp    800e54 <__udivdi3+0xd4>
  800e96:	66 90                	xchg   %ax,%ax
  800e98:	66 90                	xchg   %ax,%ax
  800e9a:	66 90                	xchg   %ax,%ax
  800e9c:	66 90                	xchg   %ax,%ax
  800e9e:	66 90                	xchg   %ax,%ax

00800ea0 <__umoddi3>:
  800ea0:	55                   	push   %ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
  800ea4:	83 ec 1c             	sub    $0x1c,%esp
  800ea7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800eab:	8b 74 24 30          	mov    0x30(%esp),%esi
  800eaf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800eb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800eb7:	85 ed                	test   %ebp,%ebp
  800eb9:	89 f0                	mov    %esi,%eax
  800ebb:	89 da                	mov    %ebx,%edx
  800ebd:	75 19                	jne    800ed8 <__umoddi3+0x38>
  800ebf:	39 df                	cmp    %ebx,%edi
  800ec1:	0f 86 b1 00 00 00    	jbe    800f78 <__umoddi3+0xd8>
  800ec7:	f7 f7                	div    %edi
  800ec9:	89 d0                	mov    %edx,%eax
  800ecb:	31 d2                	xor    %edx,%edx
  800ecd:	83 c4 1c             	add    $0x1c,%esp
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    
  800ed5:	8d 76 00             	lea    0x0(%esi),%esi
  800ed8:	39 dd                	cmp    %ebx,%ebp
  800eda:	77 f1                	ja     800ecd <__umoddi3+0x2d>
  800edc:	0f bd cd             	bsr    %ebp,%ecx
  800edf:	83 f1 1f             	xor    $0x1f,%ecx
  800ee2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ee6:	0f 84 b4 00 00 00    	je     800fa0 <__umoddi3+0x100>
  800eec:	b8 20 00 00 00       	mov    $0x20,%eax
  800ef1:	89 c2                	mov    %eax,%edx
  800ef3:	8b 44 24 04          	mov    0x4(%esp),%eax
  800ef7:	29 c2                	sub    %eax,%edx
  800ef9:	89 c1                	mov    %eax,%ecx
  800efb:	89 f8                	mov    %edi,%eax
  800efd:	d3 e5                	shl    %cl,%ebp
  800eff:	89 d1                	mov    %edx,%ecx
  800f01:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f05:	d3 e8                	shr    %cl,%eax
  800f07:	09 c5                	or     %eax,%ebp
  800f09:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f0d:	89 c1                	mov    %eax,%ecx
  800f0f:	d3 e7                	shl    %cl,%edi
  800f11:	89 d1                	mov    %edx,%ecx
  800f13:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f17:	89 df                	mov    %ebx,%edi
  800f19:	d3 ef                	shr    %cl,%edi
  800f1b:	89 c1                	mov    %eax,%ecx
  800f1d:	89 f0                	mov    %esi,%eax
  800f1f:	d3 e3                	shl    %cl,%ebx
  800f21:	89 d1                	mov    %edx,%ecx
  800f23:	89 fa                	mov    %edi,%edx
  800f25:	d3 e8                	shr    %cl,%eax
  800f27:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f2c:	09 d8                	or     %ebx,%eax
  800f2e:	f7 f5                	div    %ebp
  800f30:	d3 e6                	shl    %cl,%esi
  800f32:	89 d1                	mov    %edx,%ecx
  800f34:	f7 64 24 08          	mull   0x8(%esp)
  800f38:	39 d1                	cmp    %edx,%ecx
  800f3a:	89 c3                	mov    %eax,%ebx
  800f3c:	89 d7                	mov    %edx,%edi
  800f3e:	72 06                	jb     800f46 <__umoddi3+0xa6>
  800f40:	75 0e                	jne    800f50 <__umoddi3+0xb0>
  800f42:	39 c6                	cmp    %eax,%esi
  800f44:	73 0a                	jae    800f50 <__umoddi3+0xb0>
  800f46:	2b 44 24 08          	sub    0x8(%esp),%eax
  800f4a:	19 ea                	sbb    %ebp,%edx
  800f4c:	89 d7                	mov    %edx,%edi
  800f4e:	89 c3                	mov    %eax,%ebx
  800f50:	89 ca                	mov    %ecx,%edx
  800f52:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800f57:	29 de                	sub    %ebx,%esi
  800f59:	19 fa                	sbb    %edi,%edx
  800f5b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800f5f:	89 d0                	mov    %edx,%eax
  800f61:	d3 e0                	shl    %cl,%eax
  800f63:	89 d9                	mov    %ebx,%ecx
  800f65:	d3 ee                	shr    %cl,%esi
  800f67:	d3 ea                	shr    %cl,%edx
  800f69:	09 f0                	or     %esi,%eax
  800f6b:	83 c4 1c             	add    $0x1c,%esp
  800f6e:	5b                   	pop    %ebx
  800f6f:	5e                   	pop    %esi
  800f70:	5f                   	pop    %edi
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    
  800f73:	90                   	nop
  800f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f78:	85 ff                	test   %edi,%edi
  800f7a:	89 f9                	mov    %edi,%ecx
  800f7c:	75 0b                	jne    800f89 <__umoddi3+0xe9>
  800f7e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f83:	31 d2                	xor    %edx,%edx
  800f85:	f7 f7                	div    %edi
  800f87:	89 c1                	mov    %eax,%ecx
  800f89:	89 d8                	mov    %ebx,%eax
  800f8b:	31 d2                	xor    %edx,%edx
  800f8d:	f7 f1                	div    %ecx
  800f8f:	89 f0                	mov    %esi,%eax
  800f91:	f7 f1                	div    %ecx
  800f93:	e9 31 ff ff ff       	jmp    800ec9 <__umoddi3+0x29>
  800f98:	90                   	nop
  800f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fa0:	39 dd                	cmp    %ebx,%ebp
  800fa2:	72 08                	jb     800fac <__umoddi3+0x10c>
  800fa4:	39 f7                	cmp    %esi,%edi
  800fa6:	0f 87 21 ff ff ff    	ja     800ecd <__umoddi3+0x2d>
  800fac:	89 da                	mov    %ebx,%edx
  800fae:	89 f0                	mov    %esi,%eax
  800fb0:	29 f8                	sub    %edi,%eax
  800fb2:	19 ea                	sbb    %ebp,%edx
  800fb4:	e9 14 ff ff ff       	jmp    800ecd <__umoddi3+0x2d>
