
obj/user/faultbadhandler.debug：     文件格式 elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	6a 07                	push   $0x7
  80003b:	68 00 f0 bf ee       	push   $0xeebff000
  800040:	6a 00                	push   $0x0
  800042:	e8 32 01 00 00       	call   800179 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 ef be ad de       	push   $0xdeadbeef
  80004f:	6a 00                	push   $0x0
  800051:	e8 6e 02 00 00       	call   8002c4 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800056:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80005d:	00 00 00 
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  800070:	e8 c6 00 00 00       	call   80013b <sys_getenvid>
	thisenv = envs + ENVX(envid);
  800075:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800082:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800087:	85 db                	test   %ebx,%ebx
  800089:	7e 07                	jle    800092 <libmain+0x2d>
		binaryname = argv[0];
  80008b:	8b 06                	mov    (%esi),%eax
  80008d:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	56                   	push   %esi
  800096:	53                   	push   %ebx
  800097:	e8 97 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009c:	e8 0a 00 00 00       	call   8000ab <exit>
}
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a7:	5b                   	pop    %ebx
  8000a8:	5e                   	pop    %esi
  8000a9:	5d                   	pop    %ebp
  8000aa:	c3                   	ret    

008000ab <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ab:	55                   	push   %ebp
  8000ac:	89 e5                	mov    %esp,%ebp
  8000ae:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000b1:	6a 00                	push   $0x0
  8000b3:	e8 42 00 00 00       	call   8000fa <sys_env_destroy>
}
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	c9                   	leave  
  8000bc:	c3                   	ret    

008000bd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	57                   	push   %edi
  8000c1:	56                   	push   %esi
  8000c2:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ce:	89 c3                	mov    %eax,%ebx
  8000d0:	89 c7                	mov    %eax,%edi
  8000d2:	89 c6                	mov    %eax,%esi
  8000d4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d6:	5b                   	pop    %ebx
  8000d7:	5e                   	pop    %esi
  8000d8:	5f                   	pop    %edi
  8000d9:	5d                   	pop    %ebp
  8000da:	c3                   	ret    

008000db <sys_cgetc>:

int
sys_cgetc(void)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	57                   	push   %edi
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8000eb:	89 d1                	mov    %edx,%ecx
  8000ed:	89 d3                	mov    %edx,%ebx
  8000ef:	89 d7                	mov    %edx,%edi
  8000f1:	89 d6                	mov    %edx,%esi
  8000f3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f5:	5b                   	pop    %ebx
  8000f6:	5e                   	pop    %esi
  8000f7:	5f                   	pop    %edi
  8000f8:	5d                   	pop    %ebp
  8000f9:	c3                   	ret    

008000fa <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	57                   	push   %edi
  8000fe:	56                   	push   %esi
  8000ff:	53                   	push   %ebx
  800100:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800103:	b9 00 00 00 00       	mov    $0x0,%ecx
  800108:	8b 55 08             	mov    0x8(%ebp),%edx
  80010b:	b8 03 00 00 00       	mov    $0x3,%eax
  800110:	89 cb                	mov    %ecx,%ebx
  800112:	89 cf                	mov    %ecx,%edi
  800114:	89 ce                	mov    %ecx,%esi
  800116:	cd 30                	int    $0x30
	if(check && ret > 0)
  800118:	85 c0                	test   %eax,%eax
  80011a:	7f 08                	jg     800124 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80011c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80011f:	5b                   	pop    %ebx
  800120:	5e                   	pop    %esi
  800121:	5f                   	pop    %edi
  800122:	5d                   	pop    %ebp
  800123:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	50                   	push   %eax
  800128:	6a 03                	push   $0x3
  80012a:	68 0a 10 80 00       	push   $0x80100a
  80012f:	6a 23                	push   $0x23
  800131:	68 27 10 80 00       	push   $0x801027
  800136:	e8 2f 02 00 00       	call   80036a <_panic>

0080013b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	57                   	push   %edi
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800141:	ba 00 00 00 00       	mov    $0x0,%edx
  800146:	b8 02 00 00 00       	mov    $0x2,%eax
  80014b:	89 d1                	mov    %edx,%ecx
  80014d:	89 d3                	mov    %edx,%ebx
  80014f:	89 d7                	mov    %edx,%edi
  800151:	89 d6                	mov    %edx,%esi
  800153:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5f                   	pop    %edi
  800158:	5d                   	pop    %ebp
  800159:	c3                   	ret    

0080015a <sys_yield>:

void
sys_yield(void)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	57                   	push   %edi
  80015e:	56                   	push   %esi
  80015f:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800160:	ba 00 00 00 00       	mov    $0x0,%edx
  800165:	b8 0b 00 00 00       	mov    $0xb,%eax
  80016a:	89 d1                	mov    %edx,%ecx
  80016c:	89 d3                	mov    %edx,%ebx
  80016e:	89 d7                	mov    %edx,%edi
  800170:	89 d6                	mov    %edx,%esi
  800172:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800174:	5b                   	pop    %ebx
  800175:	5e                   	pop    %esi
  800176:	5f                   	pop    %edi
  800177:	5d                   	pop    %ebp
  800178:	c3                   	ret    

00800179 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	57                   	push   %edi
  80017d:	56                   	push   %esi
  80017e:	53                   	push   %ebx
  80017f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800182:	be 00 00 00 00       	mov    $0x0,%esi
  800187:	8b 55 08             	mov    0x8(%ebp),%edx
  80018a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80018d:	b8 04 00 00 00       	mov    $0x4,%eax
  800192:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800195:	89 f7                	mov    %esi,%edi
  800197:	cd 30                	int    $0x30
	if(check && ret > 0)
  800199:	85 c0                	test   %eax,%eax
  80019b:	7f 08                	jg     8001a5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80019d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a0:	5b                   	pop    %ebx
  8001a1:	5e                   	pop    %esi
  8001a2:	5f                   	pop    %edi
  8001a3:	5d                   	pop    %ebp
  8001a4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a5:	83 ec 0c             	sub    $0xc,%esp
  8001a8:	50                   	push   %eax
  8001a9:	6a 04                	push   $0x4
  8001ab:	68 0a 10 80 00       	push   $0x80100a
  8001b0:	6a 23                	push   $0x23
  8001b2:	68 27 10 80 00       	push   $0x801027
  8001b7:	e8 ae 01 00 00       	call   80036a <_panic>

008001bc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001bc:	55                   	push   %ebp
  8001bd:	89 e5                	mov    %esp,%ebp
  8001bf:	57                   	push   %edi
  8001c0:	56                   	push   %esi
  8001c1:	53                   	push   %ebx
  8001c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8001c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001cb:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001d6:	8b 75 18             	mov    0x18(%ebp),%esi
  8001d9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001db:	85 c0                	test   %eax,%eax
  8001dd:	7f 08                	jg     8001e7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e2:	5b                   	pop    %ebx
  8001e3:	5e                   	pop    %esi
  8001e4:	5f                   	pop    %edi
  8001e5:	5d                   	pop    %ebp
  8001e6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	50                   	push   %eax
  8001eb:	6a 05                	push   $0x5
  8001ed:	68 0a 10 80 00       	push   $0x80100a
  8001f2:	6a 23                	push   $0x23
  8001f4:	68 27 10 80 00       	push   $0x801027
  8001f9:	e8 6c 01 00 00       	call   80036a <_panic>

008001fe <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	57                   	push   %edi
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800207:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020c:	8b 55 08             	mov    0x8(%ebp),%edx
  80020f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800212:	b8 06 00 00 00       	mov    $0x6,%eax
  800217:	89 df                	mov    %ebx,%edi
  800219:	89 de                	mov    %ebx,%esi
  80021b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80021d:	85 c0                	test   %eax,%eax
  80021f:	7f 08                	jg     800229 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800221:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800224:	5b                   	pop    %ebx
  800225:	5e                   	pop    %esi
  800226:	5f                   	pop    %edi
  800227:	5d                   	pop    %ebp
  800228:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	50                   	push   %eax
  80022d:	6a 06                	push   $0x6
  80022f:	68 0a 10 80 00       	push   $0x80100a
  800234:	6a 23                	push   $0x23
  800236:	68 27 10 80 00       	push   $0x801027
  80023b:	e8 2a 01 00 00       	call   80036a <_panic>

00800240 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	57                   	push   %edi
  800244:	56                   	push   %esi
  800245:	53                   	push   %ebx
  800246:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800249:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024e:	8b 55 08             	mov    0x8(%ebp),%edx
  800251:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800254:	b8 08 00 00 00       	mov    $0x8,%eax
  800259:	89 df                	mov    %ebx,%edi
  80025b:	89 de                	mov    %ebx,%esi
  80025d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80025f:	85 c0                	test   %eax,%eax
  800261:	7f 08                	jg     80026b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	50                   	push   %eax
  80026f:	6a 08                	push   $0x8
  800271:	68 0a 10 80 00       	push   $0x80100a
  800276:	6a 23                	push   $0x23
  800278:	68 27 10 80 00       	push   $0x801027
  80027d:	e8 e8 00 00 00       	call   80036a <_panic>

00800282 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	57                   	push   %edi
  800286:	56                   	push   %esi
  800287:	53                   	push   %ebx
  800288:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80028b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800290:	8b 55 08             	mov    0x8(%ebp),%edx
  800293:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800296:	b8 09 00 00 00       	mov    $0x9,%eax
  80029b:	89 df                	mov    %ebx,%edi
  80029d:	89 de                	mov    %ebx,%esi
  80029f:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002a1:	85 c0                	test   %eax,%eax
  8002a3:	7f 08                	jg     8002ad <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a8:	5b                   	pop    %ebx
  8002a9:	5e                   	pop    %esi
  8002aa:	5f                   	pop    %edi
  8002ab:	5d                   	pop    %ebp
  8002ac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	50                   	push   %eax
  8002b1:	6a 09                	push   $0x9
  8002b3:	68 0a 10 80 00       	push   $0x80100a
  8002b8:	6a 23                	push   $0x23
  8002ba:	68 27 10 80 00       	push   $0x801027
  8002bf:	e8 a6 00 00 00       	call   80036a <_panic>

008002c4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	57                   	push   %edi
  8002c8:	56                   	push   %esi
  8002c9:	53                   	push   %ebx
  8002ca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002dd:	89 df                	mov    %ebx,%edi
  8002df:	89 de                	mov    %ebx,%esi
  8002e1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002e3:	85 c0                	test   %eax,%eax
  8002e5:	7f 08                	jg     8002ef <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ea:	5b                   	pop    %ebx
  8002eb:	5e                   	pop    %esi
  8002ec:	5f                   	pop    %edi
  8002ed:	5d                   	pop    %ebp
  8002ee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ef:	83 ec 0c             	sub    $0xc,%esp
  8002f2:	50                   	push   %eax
  8002f3:	6a 0a                	push   $0xa
  8002f5:	68 0a 10 80 00       	push   $0x80100a
  8002fa:	6a 23                	push   $0x23
  8002fc:	68 27 10 80 00       	push   $0x801027
  800301:	e8 64 00 00 00       	call   80036a <_panic>

00800306 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	57                   	push   %edi
  80030a:	56                   	push   %esi
  80030b:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80030c:	8b 55 08             	mov    0x8(%ebp),%edx
  80030f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800312:	b8 0c 00 00 00       	mov    $0xc,%eax
  800317:	be 00 00 00 00       	mov    $0x0,%esi
  80031c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80031f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800322:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800324:	5b                   	pop    %ebx
  800325:	5e                   	pop    %esi
  800326:	5f                   	pop    %edi
  800327:	5d                   	pop    %ebp
  800328:	c3                   	ret    

00800329 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	57                   	push   %edi
  80032d:	56                   	push   %esi
  80032e:	53                   	push   %ebx
  80032f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800332:	b9 00 00 00 00       	mov    $0x0,%ecx
  800337:	8b 55 08             	mov    0x8(%ebp),%edx
  80033a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80033f:	89 cb                	mov    %ecx,%ebx
  800341:	89 cf                	mov    %ecx,%edi
  800343:	89 ce                	mov    %ecx,%esi
  800345:	cd 30                	int    $0x30
	if(check && ret > 0)
  800347:	85 c0                	test   %eax,%eax
  800349:	7f 08                	jg     800353 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80034b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80034e:	5b                   	pop    %ebx
  80034f:	5e                   	pop    %esi
  800350:	5f                   	pop    %edi
  800351:	5d                   	pop    %ebp
  800352:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	50                   	push   %eax
  800357:	6a 0d                	push   $0xd
  800359:	68 0a 10 80 00       	push   $0x80100a
  80035e:	6a 23                	push   $0x23
  800360:	68 27 10 80 00       	push   $0x801027
  800365:	e8 00 00 00 00       	call   80036a <_panic>

0080036a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	56                   	push   %esi
  80036e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80036f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800372:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800378:	e8 be fd ff ff       	call   80013b <sys_getenvid>
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	ff 75 0c             	pushl  0xc(%ebp)
  800383:	ff 75 08             	pushl  0x8(%ebp)
  800386:	56                   	push   %esi
  800387:	50                   	push   %eax
  800388:	68 38 10 80 00       	push   $0x801038
  80038d:	e8 b3 00 00 00       	call   800445 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800392:	83 c4 18             	add    $0x18,%esp
  800395:	53                   	push   %ebx
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	e8 56 00 00 00       	call   8003f4 <vcprintf>
	cprintf("\n");
  80039e:	c7 04 24 5b 10 80 00 	movl   $0x80105b,(%esp)
  8003a5:	e8 9b 00 00 00       	call   800445 <cprintf>
  8003aa:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003ad:	cc                   	int3   
  8003ae:	eb fd                	jmp    8003ad <_panic+0x43>

008003b0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	53                   	push   %ebx
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003ba:	8b 13                	mov    (%ebx),%edx
  8003bc:	8d 42 01             	lea    0x1(%edx),%eax
  8003bf:	89 03                	mov    %eax,(%ebx)
  8003c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003c4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003c8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003cd:	74 09                	je     8003d8 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003cf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003d8:	83 ec 08             	sub    $0x8,%esp
  8003db:	68 ff 00 00 00       	push   $0xff
  8003e0:	8d 43 08             	lea    0x8(%ebx),%eax
  8003e3:	50                   	push   %eax
  8003e4:	e8 d4 fc ff ff       	call   8000bd <sys_cputs>
		b->idx = 0;
  8003e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003ef:	83 c4 10             	add    $0x10,%esp
  8003f2:	eb db                	jmp    8003cf <putch+0x1f>

008003f4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800404:	00 00 00 
	b.cnt = 0;
  800407:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80040e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800411:	ff 75 0c             	pushl  0xc(%ebp)
  800414:	ff 75 08             	pushl  0x8(%ebp)
  800417:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80041d:	50                   	push   %eax
  80041e:	68 b0 03 80 00       	push   $0x8003b0
  800423:	e8 1a 01 00 00       	call   800542 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800428:	83 c4 08             	add    $0x8,%esp
  80042b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800431:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800437:	50                   	push   %eax
  800438:	e8 80 fc ff ff       	call   8000bd <sys_cputs>

	return b.cnt;
}
  80043d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800443:	c9                   	leave  
  800444:	c3                   	ret    

00800445 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800445:	55                   	push   %ebp
  800446:	89 e5                	mov    %esp,%ebp
  800448:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80044b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80044e:	50                   	push   %eax
  80044f:	ff 75 08             	pushl  0x8(%ebp)
  800452:	e8 9d ff ff ff       	call   8003f4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800457:	c9                   	leave  
  800458:	c3                   	ret    

00800459 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	57                   	push   %edi
  80045d:	56                   	push   %esi
  80045e:	53                   	push   %ebx
  80045f:	83 ec 1c             	sub    $0x1c,%esp
  800462:	89 c7                	mov    %eax,%edi
  800464:	89 d6                	mov    %edx,%esi
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800472:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800475:	bb 00 00 00 00       	mov    $0x0,%ebx
  80047a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80047d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800480:	39 d3                	cmp    %edx,%ebx
  800482:	72 05                	jb     800489 <printnum+0x30>
  800484:	39 45 10             	cmp    %eax,0x10(%ebp)
  800487:	77 7a                	ja     800503 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800489:	83 ec 0c             	sub    $0xc,%esp
  80048c:	ff 75 18             	pushl  0x18(%ebp)
  80048f:	8b 45 14             	mov    0x14(%ebp),%eax
  800492:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800495:	53                   	push   %ebx
  800496:	ff 75 10             	pushl  0x10(%ebp)
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049f:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a2:	ff 75 dc             	pushl  -0x24(%ebp)
  8004a5:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a8:	e8 03 09 00 00       	call   800db0 <__udivdi3>
  8004ad:	83 c4 18             	add    $0x18,%esp
  8004b0:	52                   	push   %edx
  8004b1:	50                   	push   %eax
  8004b2:	89 f2                	mov    %esi,%edx
  8004b4:	89 f8                	mov    %edi,%eax
  8004b6:	e8 9e ff ff ff       	call   800459 <printnum>
  8004bb:	83 c4 20             	add    $0x20,%esp
  8004be:	eb 13                	jmp    8004d3 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	56                   	push   %esi
  8004c4:	ff 75 18             	pushl  0x18(%ebp)
  8004c7:	ff d7                	call   *%edi
  8004c9:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004cc:	83 eb 01             	sub    $0x1,%ebx
  8004cf:	85 db                	test   %ebx,%ebx
  8004d1:	7f ed                	jg     8004c0 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	56                   	push   %esi
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004dd:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e0:	ff 75 dc             	pushl  -0x24(%ebp)
  8004e3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004e6:	e8 e5 09 00 00       	call   800ed0 <__umoddi3>
  8004eb:	83 c4 14             	add    $0x14,%esp
  8004ee:	0f be 80 5d 10 80 00 	movsbl 0x80105d(%eax),%eax
  8004f5:	50                   	push   %eax
  8004f6:	ff d7                	call   *%edi
}
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004fe:	5b                   	pop    %ebx
  8004ff:	5e                   	pop    %esi
  800500:	5f                   	pop    %edi
  800501:	5d                   	pop    %ebp
  800502:	c3                   	ret    
  800503:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800506:	eb c4                	jmp    8004cc <printnum+0x73>

00800508 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800508:	55                   	push   %ebp
  800509:	89 e5                	mov    %esp,%ebp
  80050b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80050e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800512:	8b 10                	mov    (%eax),%edx
  800514:	3b 50 04             	cmp    0x4(%eax),%edx
  800517:	73 0a                	jae    800523 <sprintputch+0x1b>
		*b->buf++ = ch;
  800519:	8d 4a 01             	lea    0x1(%edx),%ecx
  80051c:	89 08                	mov    %ecx,(%eax)
  80051e:	8b 45 08             	mov    0x8(%ebp),%eax
  800521:	88 02                	mov    %al,(%edx)
}
  800523:	5d                   	pop    %ebp
  800524:	c3                   	ret    

00800525 <printfmt>:
{
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80052b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80052e:	50                   	push   %eax
  80052f:	ff 75 10             	pushl  0x10(%ebp)
  800532:	ff 75 0c             	pushl  0xc(%ebp)
  800535:	ff 75 08             	pushl  0x8(%ebp)
  800538:	e8 05 00 00 00       	call   800542 <vprintfmt>
}
  80053d:	83 c4 10             	add    $0x10,%esp
  800540:	c9                   	leave  
  800541:	c3                   	ret    

00800542 <vprintfmt>:
{
  800542:	55                   	push   %ebp
  800543:	89 e5                	mov    %esp,%ebp
  800545:	57                   	push   %edi
  800546:	56                   	push   %esi
  800547:	53                   	push   %ebx
  800548:	83 ec 2c             	sub    $0x2c,%esp
  80054b:	8b 75 08             	mov    0x8(%ebp),%esi
  80054e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800551:	8b 7d 10             	mov    0x10(%ebp),%edi
  800554:	e9 c1 03 00 00       	jmp    80091a <vprintfmt+0x3d8>
		padc = ' ';
  800559:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80055d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800564:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80056b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800572:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800577:	8d 47 01             	lea    0x1(%edi),%eax
  80057a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80057d:	0f b6 17             	movzbl (%edi),%edx
  800580:	8d 42 dd             	lea    -0x23(%edx),%eax
  800583:	3c 55                	cmp    $0x55,%al
  800585:	0f 87 12 04 00 00    	ja     80099d <vprintfmt+0x45b>
  80058b:	0f b6 c0             	movzbl %al,%eax
  80058e:	ff 24 85 a0 11 80 00 	jmp    *0x8011a0(,%eax,4)
  800595:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800598:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80059c:	eb d9                	jmp    800577 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80059e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005a1:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8005a5:	eb d0                	jmp    800577 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8005a7:	0f b6 d2             	movzbl %dl,%edx
  8005aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8005b5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005b8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005bc:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005bf:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005c2:	83 f9 09             	cmp    $0x9,%ecx
  8005c5:	77 55                	ja     80061c <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8005c7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005ca:	eb e9                	jmp    8005b5 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8d 40 04             	lea    0x4(%eax),%eax
  8005da:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005e0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005e4:	79 91                	jns    800577 <vprintfmt+0x35>
				width = precision, precision = -1;
  8005e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ec:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005f3:	eb 82                	jmp    800577 <vprintfmt+0x35>
  8005f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f8:	85 c0                	test   %eax,%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ff:	0f 49 d0             	cmovns %eax,%edx
  800602:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800605:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800608:	e9 6a ff ff ff       	jmp    800577 <vprintfmt+0x35>
  80060d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800610:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800617:	e9 5b ff ff ff       	jmp    800577 <vprintfmt+0x35>
  80061c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80061f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800622:	eb bc                	jmp    8005e0 <vprintfmt+0x9e>
			lflag++;
  800624:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800627:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80062a:	e9 48 ff ff ff       	jmp    800577 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8d 78 04             	lea    0x4(%eax),%edi
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	53                   	push   %ebx
  800639:	ff 30                	pushl  (%eax)
  80063b:	ff d6                	call   *%esi
			break;
  80063d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800640:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800643:	e9 cf 02 00 00       	jmp    800917 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 78 04             	lea    0x4(%eax),%edi
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	99                   	cltd   
  800651:	31 d0                	xor    %edx,%eax
  800653:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800655:	83 f8 0f             	cmp    $0xf,%eax
  800658:	7f 23                	jg     80067d <vprintfmt+0x13b>
  80065a:	8b 14 85 00 13 80 00 	mov    0x801300(,%eax,4),%edx
  800661:	85 d2                	test   %edx,%edx
  800663:	74 18                	je     80067d <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800665:	52                   	push   %edx
  800666:	68 7e 10 80 00       	push   $0x80107e
  80066b:	53                   	push   %ebx
  80066c:	56                   	push   %esi
  80066d:	e8 b3 fe ff ff       	call   800525 <printfmt>
  800672:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800675:	89 7d 14             	mov    %edi,0x14(%ebp)
  800678:	e9 9a 02 00 00       	jmp    800917 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80067d:	50                   	push   %eax
  80067e:	68 75 10 80 00       	push   $0x801075
  800683:	53                   	push   %ebx
  800684:	56                   	push   %esi
  800685:	e8 9b fe ff ff       	call   800525 <printfmt>
  80068a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80068d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800690:	e9 82 02 00 00       	jmp    800917 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	83 c0 04             	add    $0x4,%eax
  80069b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8006a3:	85 ff                	test   %edi,%edi
  8006a5:	b8 6e 10 80 00       	mov    $0x80106e,%eax
  8006aa:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8006ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b1:	0f 8e bd 00 00 00    	jle    800774 <vprintfmt+0x232>
  8006b7:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8006bb:	75 0e                	jne    8006cb <vprintfmt+0x189>
  8006bd:	89 75 08             	mov    %esi,0x8(%ebp)
  8006c0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006c3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006c6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006c9:	eb 6d                	jmp    800738 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	ff 75 d0             	pushl  -0x30(%ebp)
  8006d1:	57                   	push   %edi
  8006d2:	e8 6e 03 00 00       	call   800a45 <strnlen>
  8006d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006da:	29 c1                	sub    %eax,%ecx
  8006dc:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8006df:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006e2:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006e9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006ec:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ee:	eb 0f                	jmp    8006ff <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006f0:	83 ec 08             	sub    $0x8,%esp
  8006f3:	53                   	push   %ebx
  8006f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f9:	83 ef 01             	sub    $0x1,%edi
  8006fc:	83 c4 10             	add    $0x10,%esp
  8006ff:	85 ff                	test   %edi,%edi
  800701:	7f ed                	jg     8006f0 <vprintfmt+0x1ae>
  800703:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800706:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800709:	85 c9                	test   %ecx,%ecx
  80070b:	b8 00 00 00 00       	mov    $0x0,%eax
  800710:	0f 49 c1             	cmovns %ecx,%eax
  800713:	29 c1                	sub    %eax,%ecx
  800715:	89 75 08             	mov    %esi,0x8(%ebp)
  800718:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80071b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80071e:	89 cb                	mov    %ecx,%ebx
  800720:	eb 16                	jmp    800738 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800722:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800726:	75 31                	jne    800759 <vprintfmt+0x217>
					putch(ch, putdat);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	ff 75 0c             	pushl  0xc(%ebp)
  80072e:	50                   	push   %eax
  80072f:	ff 55 08             	call   *0x8(%ebp)
  800732:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800735:	83 eb 01             	sub    $0x1,%ebx
  800738:	83 c7 01             	add    $0x1,%edi
  80073b:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80073f:	0f be c2             	movsbl %dl,%eax
  800742:	85 c0                	test   %eax,%eax
  800744:	74 59                	je     80079f <vprintfmt+0x25d>
  800746:	85 f6                	test   %esi,%esi
  800748:	78 d8                	js     800722 <vprintfmt+0x1e0>
  80074a:	83 ee 01             	sub    $0x1,%esi
  80074d:	79 d3                	jns    800722 <vprintfmt+0x1e0>
  80074f:	89 df                	mov    %ebx,%edi
  800751:	8b 75 08             	mov    0x8(%ebp),%esi
  800754:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800757:	eb 37                	jmp    800790 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800759:	0f be d2             	movsbl %dl,%edx
  80075c:	83 ea 20             	sub    $0x20,%edx
  80075f:	83 fa 5e             	cmp    $0x5e,%edx
  800762:	76 c4                	jbe    800728 <vprintfmt+0x1e6>
					putch('?', putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	6a 3f                	push   $0x3f
  80076c:	ff 55 08             	call   *0x8(%ebp)
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	eb c1                	jmp    800735 <vprintfmt+0x1f3>
  800774:	89 75 08             	mov    %esi,0x8(%ebp)
  800777:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80077a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80077d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800780:	eb b6                	jmp    800738 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	53                   	push   %ebx
  800786:	6a 20                	push   $0x20
  800788:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80078a:	83 ef 01             	sub    $0x1,%edi
  80078d:	83 c4 10             	add    $0x10,%esp
  800790:	85 ff                	test   %edi,%edi
  800792:	7f ee                	jg     800782 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800794:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800797:	89 45 14             	mov    %eax,0x14(%ebp)
  80079a:	e9 78 01 00 00       	jmp    800917 <vprintfmt+0x3d5>
  80079f:	89 df                	mov    %ebx,%edi
  8007a1:	8b 75 08             	mov    0x8(%ebp),%esi
  8007a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007a7:	eb e7                	jmp    800790 <vprintfmt+0x24e>
	if (lflag >= 2)
  8007a9:	83 f9 01             	cmp    $0x1,%ecx
  8007ac:	7e 3f                	jle    8007ed <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8b 50 04             	mov    0x4(%eax),%edx
  8007b4:	8b 00                	mov    (%eax),%eax
  8007b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8d 40 08             	lea    0x8(%eax),%eax
  8007c2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007c5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007c9:	79 5c                	jns    800827 <vprintfmt+0x2e5>
				putch('-', putdat);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	53                   	push   %ebx
  8007cf:	6a 2d                	push   $0x2d
  8007d1:	ff d6                	call   *%esi
				num = -(long long) num;
  8007d3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007d6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007d9:	f7 da                	neg    %edx
  8007db:	83 d1 00             	adc    $0x0,%ecx
  8007de:	f7 d9                	neg    %ecx
  8007e0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e8:	e9 10 01 00 00       	jmp    8008fd <vprintfmt+0x3bb>
	else if (lflag)
  8007ed:	85 c9                	test   %ecx,%ecx
  8007ef:	75 1b                	jne    80080c <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f9:	89 c1                	mov    %eax,%ecx
  8007fb:	c1 f9 1f             	sar    $0x1f,%ecx
  8007fe:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	8d 40 04             	lea    0x4(%eax),%eax
  800807:	89 45 14             	mov    %eax,0x14(%ebp)
  80080a:	eb b9                	jmp    8007c5 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800814:	89 c1                	mov    %eax,%ecx
  800816:	c1 f9 1f             	sar    $0x1f,%ecx
  800819:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8d 40 04             	lea    0x4(%eax),%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
  800825:	eb 9e                	jmp    8007c5 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800827:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80082a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80082d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800832:	e9 c6 00 00 00       	jmp    8008fd <vprintfmt+0x3bb>
	if (lflag >= 2)
  800837:	83 f9 01             	cmp    $0x1,%ecx
  80083a:	7e 18                	jle    800854 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80083c:	8b 45 14             	mov    0x14(%ebp),%eax
  80083f:	8b 10                	mov    (%eax),%edx
  800841:	8b 48 04             	mov    0x4(%eax),%ecx
  800844:	8d 40 08             	lea    0x8(%eax),%eax
  800847:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80084a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084f:	e9 a9 00 00 00       	jmp    8008fd <vprintfmt+0x3bb>
	else if (lflag)
  800854:	85 c9                	test   %ecx,%ecx
  800856:	75 1a                	jne    800872 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	8b 10                	mov    (%eax),%edx
  80085d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800862:	8d 40 04             	lea    0x4(%eax),%eax
  800865:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800868:	b8 0a 00 00 00       	mov    $0xa,%eax
  80086d:	e9 8b 00 00 00       	jmp    8008fd <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	8b 10                	mov    (%eax),%edx
  800877:	b9 00 00 00 00       	mov    $0x0,%ecx
  80087c:	8d 40 04             	lea    0x4(%eax),%eax
  80087f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800882:	b8 0a 00 00 00       	mov    $0xa,%eax
  800887:	eb 74                	jmp    8008fd <vprintfmt+0x3bb>
	if (lflag >= 2)
  800889:	83 f9 01             	cmp    $0x1,%ecx
  80088c:	7e 15                	jle    8008a3 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	8b 10                	mov    (%eax),%edx
  800893:	8b 48 04             	mov    0x4(%eax),%ecx
  800896:	8d 40 08             	lea    0x8(%eax),%eax
  800899:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80089c:	b8 08 00 00 00       	mov    $0x8,%eax
  8008a1:	eb 5a                	jmp    8008fd <vprintfmt+0x3bb>
	else if (lflag)
  8008a3:	85 c9                	test   %ecx,%ecx
  8008a5:	75 17                	jne    8008be <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8008a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008aa:	8b 10                	mov    (%eax),%edx
  8008ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008b1:	8d 40 04             	lea    0x4(%eax),%eax
  8008b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008b7:	b8 08 00 00 00       	mov    $0x8,%eax
  8008bc:	eb 3f                	jmp    8008fd <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8008be:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c1:	8b 10                	mov    (%eax),%edx
  8008c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008c8:	8d 40 04             	lea    0x4(%eax),%eax
  8008cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8008d3:	eb 28                	jmp    8008fd <vprintfmt+0x3bb>
			putch('0', putdat);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	53                   	push   %ebx
  8008d9:	6a 30                	push   $0x30
  8008db:	ff d6                	call   *%esi
			putch('x', putdat);
  8008dd:	83 c4 08             	add    $0x8,%esp
  8008e0:	53                   	push   %ebx
  8008e1:	6a 78                	push   $0x78
  8008e3:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e8:	8b 10                	mov    (%eax),%edx
  8008ea:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008ef:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008f2:	8d 40 04             	lea    0x4(%eax),%eax
  8008f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f8:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008fd:	83 ec 0c             	sub    $0xc,%esp
  800900:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800904:	57                   	push   %edi
  800905:	ff 75 e0             	pushl  -0x20(%ebp)
  800908:	50                   	push   %eax
  800909:	51                   	push   %ecx
  80090a:	52                   	push   %edx
  80090b:	89 da                	mov    %ebx,%edx
  80090d:	89 f0                	mov    %esi,%eax
  80090f:	e8 45 fb ff ff       	call   800459 <printnum>
			break;
  800914:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800917:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  80091a:	83 c7 01             	add    $0x1,%edi
  80091d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800921:	83 f8 25             	cmp    $0x25,%eax
  800924:	0f 84 2f fc ff ff    	je     800559 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  80092a:	85 c0                	test   %eax,%eax
  80092c:	0f 84 8b 00 00 00    	je     8009bd <vprintfmt+0x47b>
			putch(ch, putdat);
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	53                   	push   %ebx
  800936:	50                   	push   %eax
  800937:	ff d6                	call   *%esi
  800939:	83 c4 10             	add    $0x10,%esp
  80093c:	eb dc                	jmp    80091a <vprintfmt+0x3d8>
	if (lflag >= 2)
  80093e:	83 f9 01             	cmp    $0x1,%ecx
  800941:	7e 15                	jle    800958 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	8b 10                	mov    (%eax),%edx
  800948:	8b 48 04             	mov    0x4(%eax),%ecx
  80094b:	8d 40 08             	lea    0x8(%eax),%eax
  80094e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800951:	b8 10 00 00 00       	mov    $0x10,%eax
  800956:	eb a5                	jmp    8008fd <vprintfmt+0x3bb>
	else if (lflag)
  800958:	85 c9                	test   %ecx,%ecx
  80095a:	75 17                	jne    800973 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80095c:	8b 45 14             	mov    0x14(%ebp),%eax
  80095f:	8b 10                	mov    (%eax),%edx
  800961:	b9 00 00 00 00       	mov    $0x0,%ecx
  800966:	8d 40 04             	lea    0x4(%eax),%eax
  800969:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80096c:	b8 10 00 00 00       	mov    $0x10,%eax
  800971:	eb 8a                	jmp    8008fd <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	8b 10                	mov    (%eax),%edx
  800978:	b9 00 00 00 00       	mov    $0x0,%ecx
  80097d:	8d 40 04             	lea    0x4(%eax),%eax
  800980:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800983:	b8 10 00 00 00       	mov    $0x10,%eax
  800988:	e9 70 ff ff ff       	jmp    8008fd <vprintfmt+0x3bb>
			putch(ch, putdat);
  80098d:	83 ec 08             	sub    $0x8,%esp
  800990:	53                   	push   %ebx
  800991:	6a 25                	push   $0x25
  800993:	ff d6                	call   *%esi
			break;
  800995:	83 c4 10             	add    $0x10,%esp
  800998:	e9 7a ff ff ff       	jmp    800917 <vprintfmt+0x3d5>
			putch('%', putdat);
  80099d:	83 ec 08             	sub    $0x8,%esp
  8009a0:	53                   	push   %ebx
  8009a1:	6a 25                	push   $0x25
  8009a3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 f8                	mov    %edi,%eax
  8009aa:	eb 03                	jmp    8009af <vprintfmt+0x46d>
  8009ac:	83 e8 01             	sub    $0x1,%eax
  8009af:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009b3:	75 f7                	jne    8009ac <vprintfmt+0x46a>
  8009b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009b8:	e9 5a ff ff ff       	jmp    800917 <vprintfmt+0x3d5>
}
  8009bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009c0:	5b                   	pop    %ebx
  8009c1:	5e                   	pop    %esi
  8009c2:	5f                   	pop    %edi
  8009c3:	5d                   	pop    %ebp
  8009c4:	c3                   	ret    

008009c5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	83 ec 18             	sub    $0x18,%esp
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009d4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009d8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009e2:	85 c0                	test   %eax,%eax
  8009e4:	74 26                	je     800a0c <vsnprintf+0x47>
  8009e6:	85 d2                	test   %edx,%edx
  8009e8:	7e 22                	jle    800a0c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ea:	ff 75 14             	pushl  0x14(%ebp)
  8009ed:	ff 75 10             	pushl  0x10(%ebp)
  8009f0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009f3:	50                   	push   %eax
  8009f4:	68 08 05 80 00       	push   $0x800508
  8009f9:	e8 44 fb ff ff       	call   800542 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a01:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a07:	83 c4 10             	add    $0x10,%esp
}
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    
		return -E_INVAL;
  800a0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a11:	eb f7                	jmp    800a0a <vsnprintf+0x45>

00800a13 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a19:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a1c:	50                   	push   %eax
  800a1d:	ff 75 10             	pushl  0x10(%ebp)
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	ff 75 08             	pushl  0x8(%ebp)
  800a26:	e8 9a ff ff ff       	call   8009c5 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a2b:	c9                   	leave  
  800a2c:	c3                   	ret    

00800a2d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a33:	b8 00 00 00 00       	mov    $0x0,%eax
  800a38:	eb 03                	jmp    800a3d <strlen+0x10>
		n++;
  800a3a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a3d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a41:	75 f7                	jne    800a3a <strlen+0xd>
	return n;
}
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    

00800a45 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a53:	eb 03                	jmp    800a58 <strnlen+0x13>
		n++;
  800a55:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a58:	39 d0                	cmp    %edx,%eax
  800a5a:	74 06                	je     800a62 <strnlen+0x1d>
  800a5c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a60:	75 f3                	jne    800a55 <strnlen+0x10>
	return n;
}
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	53                   	push   %ebx
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a6e:	89 c2                	mov    %eax,%edx
  800a70:	83 c1 01             	add    $0x1,%ecx
  800a73:	83 c2 01             	add    $0x1,%edx
  800a76:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a7a:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a7d:	84 db                	test   %bl,%bl
  800a7f:	75 ef                	jne    800a70 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a81:	5b                   	pop    %ebx
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	53                   	push   %ebx
  800a88:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a8b:	53                   	push   %ebx
  800a8c:	e8 9c ff ff ff       	call   800a2d <strlen>
  800a91:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	01 d8                	add    %ebx,%eax
  800a99:	50                   	push   %eax
  800a9a:	e8 c5 ff ff ff       	call   800a64 <strcpy>
	return dst;
}
  800a9f:	89 d8                	mov    %ebx,%eax
  800aa1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa4:	c9                   	leave  
  800aa5:	c3                   	ret    

00800aa6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	56                   	push   %esi
  800aaa:	53                   	push   %ebx
  800aab:	8b 75 08             	mov    0x8(%ebp),%esi
  800aae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab1:	89 f3                	mov    %esi,%ebx
  800ab3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ab6:	89 f2                	mov    %esi,%edx
  800ab8:	eb 0f                	jmp    800ac9 <strncpy+0x23>
		*dst++ = *src;
  800aba:	83 c2 01             	add    $0x1,%edx
  800abd:	0f b6 01             	movzbl (%ecx),%eax
  800ac0:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ac3:	80 39 01             	cmpb   $0x1,(%ecx)
  800ac6:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800ac9:	39 da                	cmp    %ebx,%edx
  800acb:	75 ed                	jne    800aba <strncpy+0x14>
	}
	return ret;
}
  800acd:	89 f0                	mov    %esi,%eax
  800acf:	5b                   	pop    %ebx
  800ad0:	5e                   	pop    %esi
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	56                   	push   %esi
  800ad7:	53                   	push   %ebx
  800ad8:	8b 75 08             	mov    0x8(%ebp),%esi
  800adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ade:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ae1:	89 f0                	mov    %esi,%eax
  800ae3:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ae7:	85 c9                	test   %ecx,%ecx
  800ae9:	75 0b                	jne    800af6 <strlcpy+0x23>
  800aeb:	eb 17                	jmp    800b04 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800aed:	83 c2 01             	add    $0x1,%edx
  800af0:	83 c0 01             	add    $0x1,%eax
  800af3:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800af6:	39 d8                	cmp    %ebx,%eax
  800af8:	74 07                	je     800b01 <strlcpy+0x2e>
  800afa:	0f b6 0a             	movzbl (%edx),%ecx
  800afd:	84 c9                	test   %cl,%cl
  800aff:	75 ec                	jne    800aed <strlcpy+0x1a>
		*dst = '\0';
  800b01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b04:	29 f0                	sub    %esi,%eax
}
  800b06:	5b                   	pop    %ebx
  800b07:	5e                   	pop    %esi
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b10:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b13:	eb 06                	jmp    800b1b <strcmp+0x11>
		p++, q++;
  800b15:	83 c1 01             	add    $0x1,%ecx
  800b18:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b1b:	0f b6 01             	movzbl (%ecx),%eax
  800b1e:	84 c0                	test   %al,%al
  800b20:	74 04                	je     800b26 <strcmp+0x1c>
  800b22:	3a 02                	cmp    (%edx),%al
  800b24:	74 ef                	je     800b15 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b26:	0f b6 c0             	movzbl %al,%eax
  800b29:	0f b6 12             	movzbl (%edx),%edx
  800b2c:	29 d0                	sub    %edx,%eax
}
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    

00800b30 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	53                   	push   %ebx
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	89 c3                	mov    %eax,%ebx
  800b3c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b3f:	eb 06                	jmp    800b47 <strncmp+0x17>
		n--, p++, q++;
  800b41:	83 c0 01             	add    $0x1,%eax
  800b44:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b47:	39 d8                	cmp    %ebx,%eax
  800b49:	74 16                	je     800b61 <strncmp+0x31>
  800b4b:	0f b6 08             	movzbl (%eax),%ecx
  800b4e:	84 c9                	test   %cl,%cl
  800b50:	74 04                	je     800b56 <strncmp+0x26>
  800b52:	3a 0a                	cmp    (%edx),%cl
  800b54:	74 eb                	je     800b41 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b56:	0f b6 00             	movzbl (%eax),%eax
  800b59:	0f b6 12             	movzbl (%edx),%edx
  800b5c:	29 d0                	sub    %edx,%eax
}
  800b5e:	5b                   	pop    %ebx
  800b5f:	5d                   	pop    %ebp
  800b60:	c3                   	ret    
		return 0;
  800b61:	b8 00 00 00 00       	mov    $0x0,%eax
  800b66:	eb f6                	jmp    800b5e <strncmp+0x2e>

00800b68 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b72:	0f b6 10             	movzbl (%eax),%edx
  800b75:	84 d2                	test   %dl,%dl
  800b77:	74 09                	je     800b82 <strchr+0x1a>
		if (*s == c)
  800b79:	38 ca                	cmp    %cl,%dl
  800b7b:	74 0a                	je     800b87 <strchr+0x1f>
	for (; *s; s++)
  800b7d:	83 c0 01             	add    $0x1,%eax
  800b80:	eb f0                	jmp    800b72 <strchr+0xa>
			return (char *) s;
	return 0;
  800b82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b93:	eb 03                	jmp    800b98 <strfind+0xf>
  800b95:	83 c0 01             	add    $0x1,%eax
  800b98:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b9b:	38 ca                	cmp    %cl,%dl
  800b9d:	74 04                	je     800ba3 <strfind+0x1a>
  800b9f:	84 d2                	test   %dl,%dl
  800ba1:	75 f2                	jne    800b95 <strfind+0xc>
			break;
	return (char *) s;
}
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	57                   	push   %edi
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
  800bab:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bb1:	85 c9                	test   %ecx,%ecx
  800bb3:	74 13                	je     800bc8 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bb5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bbb:	75 05                	jne    800bc2 <memset+0x1d>
  800bbd:	f6 c1 03             	test   $0x3,%cl
  800bc0:	74 0d                	je     800bcf <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc5:	fc                   	cld    
  800bc6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bc8:	89 f8                	mov    %edi,%eax
  800bca:	5b                   	pop    %ebx
  800bcb:	5e                   	pop    %esi
  800bcc:	5f                   	pop    %edi
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    
		c &= 0xFF;
  800bcf:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bd3:	89 d3                	mov    %edx,%ebx
  800bd5:	c1 e3 08             	shl    $0x8,%ebx
  800bd8:	89 d0                	mov    %edx,%eax
  800bda:	c1 e0 18             	shl    $0x18,%eax
  800bdd:	89 d6                	mov    %edx,%esi
  800bdf:	c1 e6 10             	shl    $0x10,%esi
  800be2:	09 f0                	or     %esi,%eax
  800be4:	09 c2                	or     %eax,%edx
  800be6:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800be8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800beb:	89 d0                	mov    %edx,%eax
  800bed:	fc                   	cld    
  800bee:	f3 ab                	rep stos %eax,%es:(%edi)
  800bf0:	eb d6                	jmp    800bc8 <memset+0x23>

00800bf2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	57                   	push   %edi
  800bf6:	56                   	push   %esi
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bfd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c00:	39 c6                	cmp    %eax,%esi
  800c02:	73 35                	jae    800c39 <memmove+0x47>
  800c04:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c07:	39 c2                	cmp    %eax,%edx
  800c09:	76 2e                	jbe    800c39 <memmove+0x47>
		s += n;
		d += n;
  800c0b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0e:	89 d6                	mov    %edx,%esi
  800c10:	09 fe                	or     %edi,%esi
  800c12:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c18:	74 0c                	je     800c26 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c1a:	83 ef 01             	sub    $0x1,%edi
  800c1d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c20:	fd                   	std    
  800c21:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c23:	fc                   	cld    
  800c24:	eb 21                	jmp    800c47 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c26:	f6 c1 03             	test   $0x3,%cl
  800c29:	75 ef                	jne    800c1a <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c2b:	83 ef 04             	sub    $0x4,%edi
  800c2e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c31:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c34:	fd                   	std    
  800c35:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c37:	eb ea                	jmp    800c23 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c39:	89 f2                	mov    %esi,%edx
  800c3b:	09 c2                	or     %eax,%edx
  800c3d:	f6 c2 03             	test   $0x3,%dl
  800c40:	74 09                	je     800c4b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c42:	89 c7                	mov    %eax,%edi
  800c44:	fc                   	cld    
  800c45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c47:	5e                   	pop    %esi
  800c48:	5f                   	pop    %edi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c4b:	f6 c1 03             	test   $0x3,%cl
  800c4e:	75 f2                	jne    800c42 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c50:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c53:	89 c7                	mov    %eax,%edi
  800c55:	fc                   	cld    
  800c56:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c58:	eb ed                	jmp    800c47 <memmove+0x55>

00800c5a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c5d:	ff 75 10             	pushl  0x10(%ebp)
  800c60:	ff 75 0c             	pushl  0xc(%ebp)
  800c63:	ff 75 08             	pushl  0x8(%ebp)
  800c66:	e8 87 ff ff ff       	call   800bf2 <memmove>
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c78:	89 c6                	mov    %eax,%esi
  800c7a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c7d:	39 f0                	cmp    %esi,%eax
  800c7f:	74 1c                	je     800c9d <memcmp+0x30>
		if (*s1 != *s2)
  800c81:	0f b6 08             	movzbl (%eax),%ecx
  800c84:	0f b6 1a             	movzbl (%edx),%ebx
  800c87:	38 d9                	cmp    %bl,%cl
  800c89:	75 08                	jne    800c93 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c8b:	83 c0 01             	add    $0x1,%eax
  800c8e:	83 c2 01             	add    $0x1,%edx
  800c91:	eb ea                	jmp    800c7d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c93:	0f b6 c1             	movzbl %cl,%eax
  800c96:	0f b6 db             	movzbl %bl,%ebx
  800c99:	29 d8                	sub    %ebx,%eax
  800c9b:	eb 05                	jmp    800ca2 <memcmp+0x35>
	}

	return 0;
  800c9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800caf:	89 c2                	mov    %eax,%edx
  800cb1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb4:	39 d0                	cmp    %edx,%eax
  800cb6:	73 09                	jae    800cc1 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb8:	38 08                	cmp    %cl,(%eax)
  800cba:	74 05                	je     800cc1 <memfind+0x1b>
	for (; s < ends; s++)
  800cbc:	83 c0 01             	add    $0x1,%eax
  800cbf:	eb f3                	jmp    800cb4 <memfind+0xe>
			break;
	return (void *) s;
}
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ccc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ccf:	eb 03                	jmp    800cd4 <strtol+0x11>
		s++;
  800cd1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cd4:	0f b6 01             	movzbl (%ecx),%eax
  800cd7:	3c 20                	cmp    $0x20,%al
  800cd9:	74 f6                	je     800cd1 <strtol+0xe>
  800cdb:	3c 09                	cmp    $0x9,%al
  800cdd:	74 f2                	je     800cd1 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cdf:	3c 2b                	cmp    $0x2b,%al
  800ce1:	74 2e                	je     800d11 <strtol+0x4e>
	int neg = 0;
  800ce3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ce8:	3c 2d                	cmp    $0x2d,%al
  800cea:	74 2f                	je     800d1b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cec:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cf2:	75 05                	jne    800cf9 <strtol+0x36>
  800cf4:	80 39 30             	cmpb   $0x30,(%ecx)
  800cf7:	74 2c                	je     800d25 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cf9:	85 db                	test   %ebx,%ebx
  800cfb:	75 0a                	jne    800d07 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cfd:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800d02:	80 39 30             	cmpb   $0x30,(%ecx)
  800d05:	74 28                	je     800d2f <strtol+0x6c>
		base = 10;
  800d07:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d0f:	eb 50                	jmp    800d61 <strtol+0x9e>
		s++;
  800d11:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d14:	bf 00 00 00 00       	mov    $0x0,%edi
  800d19:	eb d1                	jmp    800cec <strtol+0x29>
		s++, neg = 1;
  800d1b:	83 c1 01             	add    $0x1,%ecx
  800d1e:	bf 01 00 00 00       	mov    $0x1,%edi
  800d23:	eb c7                	jmp    800cec <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d25:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d29:	74 0e                	je     800d39 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d2b:	85 db                	test   %ebx,%ebx
  800d2d:	75 d8                	jne    800d07 <strtol+0x44>
		s++, base = 8;
  800d2f:	83 c1 01             	add    $0x1,%ecx
  800d32:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d37:	eb ce                	jmp    800d07 <strtol+0x44>
		s += 2, base = 16;
  800d39:	83 c1 02             	add    $0x2,%ecx
  800d3c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d41:	eb c4                	jmp    800d07 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d43:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d46:	89 f3                	mov    %esi,%ebx
  800d48:	80 fb 19             	cmp    $0x19,%bl
  800d4b:	77 29                	ja     800d76 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d4d:	0f be d2             	movsbl %dl,%edx
  800d50:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d53:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d56:	7d 30                	jge    800d88 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d58:	83 c1 01             	add    $0x1,%ecx
  800d5b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d5f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d61:	0f b6 11             	movzbl (%ecx),%edx
  800d64:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d67:	89 f3                	mov    %esi,%ebx
  800d69:	80 fb 09             	cmp    $0x9,%bl
  800d6c:	77 d5                	ja     800d43 <strtol+0x80>
			dig = *s - '0';
  800d6e:	0f be d2             	movsbl %dl,%edx
  800d71:	83 ea 30             	sub    $0x30,%edx
  800d74:	eb dd                	jmp    800d53 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d76:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d79:	89 f3                	mov    %esi,%ebx
  800d7b:	80 fb 19             	cmp    $0x19,%bl
  800d7e:	77 08                	ja     800d88 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d80:	0f be d2             	movsbl %dl,%edx
  800d83:	83 ea 37             	sub    $0x37,%edx
  800d86:	eb cb                	jmp    800d53 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8c:	74 05                	je     800d93 <strtol+0xd0>
		*endptr = (char *) s;
  800d8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d91:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d93:	89 c2                	mov    %eax,%edx
  800d95:	f7 da                	neg    %edx
  800d97:	85 ff                	test   %edi,%edi
  800d99:	0f 45 c2             	cmovne %edx,%eax
}
  800d9c:	5b                   	pop    %ebx
  800d9d:	5e                   	pop    %esi
  800d9e:	5f                   	pop    %edi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    
  800da1:	66 90                	xchg   %ax,%ax
  800da3:	66 90                	xchg   %ax,%ax
  800da5:	66 90                	xchg   %ax,%ax
  800da7:	66 90                	xchg   %ax,%ax
  800da9:	66 90                	xchg   %ax,%ax
  800dab:	66 90                	xchg   %ax,%ax
  800dad:	66 90                	xchg   %ax,%ax
  800daf:	90                   	nop

00800db0 <__udivdi3>:
  800db0:	55                   	push   %ebp
  800db1:	57                   	push   %edi
  800db2:	56                   	push   %esi
  800db3:	53                   	push   %ebx
  800db4:	83 ec 1c             	sub    $0x1c,%esp
  800db7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800dbb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800dbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800dc3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800dc7:	85 d2                	test   %edx,%edx
  800dc9:	75 35                	jne    800e00 <__udivdi3+0x50>
  800dcb:	39 f3                	cmp    %esi,%ebx
  800dcd:	0f 87 bd 00 00 00    	ja     800e90 <__udivdi3+0xe0>
  800dd3:	85 db                	test   %ebx,%ebx
  800dd5:	89 d9                	mov    %ebx,%ecx
  800dd7:	75 0b                	jne    800de4 <__udivdi3+0x34>
  800dd9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dde:	31 d2                	xor    %edx,%edx
  800de0:	f7 f3                	div    %ebx
  800de2:	89 c1                	mov    %eax,%ecx
  800de4:	31 d2                	xor    %edx,%edx
  800de6:	89 f0                	mov    %esi,%eax
  800de8:	f7 f1                	div    %ecx
  800dea:	89 c6                	mov    %eax,%esi
  800dec:	89 e8                	mov    %ebp,%eax
  800dee:	89 f7                	mov    %esi,%edi
  800df0:	f7 f1                	div    %ecx
  800df2:	89 fa                	mov    %edi,%edx
  800df4:	83 c4 1c             	add    $0x1c,%esp
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    
  800dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e00:	39 f2                	cmp    %esi,%edx
  800e02:	77 7c                	ja     800e80 <__udivdi3+0xd0>
  800e04:	0f bd fa             	bsr    %edx,%edi
  800e07:	83 f7 1f             	xor    $0x1f,%edi
  800e0a:	0f 84 98 00 00 00    	je     800ea8 <__udivdi3+0xf8>
  800e10:	89 f9                	mov    %edi,%ecx
  800e12:	b8 20 00 00 00       	mov    $0x20,%eax
  800e17:	29 f8                	sub    %edi,%eax
  800e19:	d3 e2                	shl    %cl,%edx
  800e1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e1f:	89 c1                	mov    %eax,%ecx
  800e21:	89 da                	mov    %ebx,%edx
  800e23:	d3 ea                	shr    %cl,%edx
  800e25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e29:	09 d1                	or     %edx,%ecx
  800e2b:	89 f2                	mov    %esi,%edx
  800e2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e31:	89 f9                	mov    %edi,%ecx
  800e33:	d3 e3                	shl    %cl,%ebx
  800e35:	89 c1                	mov    %eax,%ecx
  800e37:	d3 ea                	shr    %cl,%edx
  800e39:	89 f9                	mov    %edi,%ecx
  800e3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e3f:	d3 e6                	shl    %cl,%esi
  800e41:	89 eb                	mov    %ebp,%ebx
  800e43:	89 c1                	mov    %eax,%ecx
  800e45:	d3 eb                	shr    %cl,%ebx
  800e47:	09 de                	or     %ebx,%esi
  800e49:	89 f0                	mov    %esi,%eax
  800e4b:	f7 74 24 08          	divl   0x8(%esp)
  800e4f:	89 d6                	mov    %edx,%esi
  800e51:	89 c3                	mov    %eax,%ebx
  800e53:	f7 64 24 0c          	mull   0xc(%esp)
  800e57:	39 d6                	cmp    %edx,%esi
  800e59:	72 0c                	jb     800e67 <__udivdi3+0xb7>
  800e5b:	89 f9                	mov    %edi,%ecx
  800e5d:	d3 e5                	shl    %cl,%ebp
  800e5f:	39 c5                	cmp    %eax,%ebp
  800e61:	73 5d                	jae    800ec0 <__udivdi3+0x110>
  800e63:	39 d6                	cmp    %edx,%esi
  800e65:	75 59                	jne    800ec0 <__udivdi3+0x110>
  800e67:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e6a:	31 ff                	xor    %edi,%edi
  800e6c:	89 fa                	mov    %edi,%edx
  800e6e:	83 c4 1c             	add    $0x1c,%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    
  800e76:	8d 76 00             	lea    0x0(%esi),%esi
  800e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800e80:	31 ff                	xor    %edi,%edi
  800e82:	31 c0                	xor    %eax,%eax
  800e84:	89 fa                	mov    %edi,%edx
  800e86:	83 c4 1c             	add    $0x1c,%esp
  800e89:	5b                   	pop    %ebx
  800e8a:	5e                   	pop    %esi
  800e8b:	5f                   	pop    %edi
  800e8c:	5d                   	pop    %ebp
  800e8d:	c3                   	ret    
  800e8e:	66 90                	xchg   %ax,%ax
  800e90:	31 ff                	xor    %edi,%edi
  800e92:	89 e8                	mov    %ebp,%eax
  800e94:	89 f2                	mov    %esi,%edx
  800e96:	f7 f3                	div    %ebx
  800e98:	89 fa                	mov    %edi,%edx
  800e9a:	83 c4 1c             	add    $0x1c,%esp
  800e9d:	5b                   	pop    %ebx
  800e9e:	5e                   	pop    %esi
  800e9f:	5f                   	pop    %edi
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    
  800ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800ea8:	39 f2                	cmp    %esi,%edx
  800eaa:	72 06                	jb     800eb2 <__udivdi3+0x102>
  800eac:	31 c0                	xor    %eax,%eax
  800eae:	39 eb                	cmp    %ebp,%ebx
  800eb0:	77 d2                	ja     800e84 <__udivdi3+0xd4>
  800eb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800eb7:	eb cb                	jmp    800e84 <__udivdi3+0xd4>
  800eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ec0:	89 d8                	mov    %ebx,%eax
  800ec2:	31 ff                	xor    %edi,%edi
  800ec4:	eb be                	jmp    800e84 <__udivdi3+0xd4>
  800ec6:	66 90                	xchg   %ax,%ax
  800ec8:	66 90                	xchg   %ax,%ax
  800eca:	66 90                	xchg   %ax,%ax
  800ecc:	66 90                	xchg   %ax,%ax
  800ece:	66 90                	xchg   %ax,%ax

00800ed0 <__umoddi3>:
  800ed0:	55                   	push   %ebp
  800ed1:	57                   	push   %edi
  800ed2:	56                   	push   %esi
  800ed3:	53                   	push   %ebx
  800ed4:	83 ec 1c             	sub    $0x1c,%esp
  800ed7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800edb:	8b 74 24 30          	mov    0x30(%esp),%esi
  800edf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ee3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ee7:	85 ed                	test   %ebp,%ebp
  800ee9:	89 f0                	mov    %esi,%eax
  800eeb:	89 da                	mov    %ebx,%edx
  800eed:	75 19                	jne    800f08 <__umoddi3+0x38>
  800eef:	39 df                	cmp    %ebx,%edi
  800ef1:	0f 86 b1 00 00 00    	jbe    800fa8 <__umoddi3+0xd8>
  800ef7:	f7 f7                	div    %edi
  800ef9:	89 d0                	mov    %edx,%eax
  800efb:	31 d2                	xor    %edx,%edx
  800efd:	83 c4 1c             	add    $0x1c,%esp
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    
  800f05:	8d 76 00             	lea    0x0(%esi),%esi
  800f08:	39 dd                	cmp    %ebx,%ebp
  800f0a:	77 f1                	ja     800efd <__umoddi3+0x2d>
  800f0c:	0f bd cd             	bsr    %ebp,%ecx
  800f0f:	83 f1 1f             	xor    $0x1f,%ecx
  800f12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f16:	0f 84 b4 00 00 00    	je     800fd0 <__umoddi3+0x100>
  800f1c:	b8 20 00 00 00       	mov    $0x20,%eax
  800f21:	89 c2                	mov    %eax,%edx
  800f23:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f27:	29 c2                	sub    %eax,%edx
  800f29:	89 c1                	mov    %eax,%ecx
  800f2b:	89 f8                	mov    %edi,%eax
  800f2d:	d3 e5                	shl    %cl,%ebp
  800f2f:	89 d1                	mov    %edx,%ecx
  800f31:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f35:	d3 e8                	shr    %cl,%eax
  800f37:	09 c5                	or     %eax,%ebp
  800f39:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f3d:	89 c1                	mov    %eax,%ecx
  800f3f:	d3 e7                	shl    %cl,%edi
  800f41:	89 d1                	mov    %edx,%ecx
  800f43:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f47:	89 df                	mov    %ebx,%edi
  800f49:	d3 ef                	shr    %cl,%edi
  800f4b:	89 c1                	mov    %eax,%ecx
  800f4d:	89 f0                	mov    %esi,%eax
  800f4f:	d3 e3                	shl    %cl,%ebx
  800f51:	89 d1                	mov    %edx,%ecx
  800f53:	89 fa                	mov    %edi,%edx
  800f55:	d3 e8                	shr    %cl,%eax
  800f57:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f5c:	09 d8                	or     %ebx,%eax
  800f5e:	f7 f5                	div    %ebp
  800f60:	d3 e6                	shl    %cl,%esi
  800f62:	89 d1                	mov    %edx,%ecx
  800f64:	f7 64 24 08          	mull   0x8(%esp)
  800f68:	39 d1                	cmp    %edx,%ecx
  800f6a:	89 c3                	mov    %eax,%ebx
  800f6c:	89 d7                	mov    %edx,%edi
  800f6e:	72 06                	jb     800f76 <__umoddi3+0xa6>
  800f70:	75 0e                	jne    800f80 <__umoddi3+0xb0>
  800f72:	39 c6                	cmp    %eax,%esi
  800f74:	73 0a                	jae    800f80 <__umoddi3+0xb0>
  800f76:	2b 44 24 08          	sub    0x8(%esp),%eax
  800f7a:	19 ea                	sbb    %ebp,%edx
  800f7c:	89 d7                	mov    %edx,%edi
  800f7e:	89 c3                	mov    %eax,%ebx
  800f80:	89 ca                	mov    %ecx,%edx
  800f82:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800f87:	29 de                	sub    %ebx,%esi
  800f89:	19 fa                	sbb    %edi,%edx
  800f8b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800f8f:	89 d0                	mov    %edx,%eax
  800f91:	d3 e0                	shl    %cl,%eax
  800f93:	89 d9                	mov    %ebx,%ecx
  800f95:	d3 ee                	shr    %cl,%esi
  800f97:	d3 ea                	shr    %cl,%edx
  800f99:	09 f0                	or     %esi,%eax
  800f9b:	83 c4 1c             	add    $0x1c,%esp
  800f9e:	5b                   	pop    %ebx
  800f9f:	5e                   	pop    %esi
  800fa0:	5f                   	pop    %edi
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    
  800fa3:	90                   	nop
  800fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800fa8:	85 ff                	test   %edi,%edi
  800faa:	89 f9                	mov    %edi,%ecx
  800fac:	75 0b                	jne    800fb9 <__umoddi3+0xe9>
  800fae:	b8 01 00 00 00       	mov    $0x1,%eax
  800fb3:	31 d2                	xor    %edx,%edx
  800fb5:	f7 f7                	div    %edi
  800fb7:	89 c1                	mov    %eax,%ecx
  800fb9:	89 d8                	mov    %ebx,%eax
  800fbb:	31 d2                	xor    %edx,%edx
  800fbd:	f7 f1                	div    %ecx
  800fbf:	89 f0                	mov    %esi,%eax
  800fc1:	f7 f1                	div    %ecx
  800fc3:	e9 31 ff ff ff       	jmp    800ef9 <__umoddi3+0x29>
  800fc8:	90                   	nop
  800fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fd0:	39 dd                	cmp    %ebx,%ebp
  800fd2:	72 08                	jb     800fdc <__umoddi3+0x10c>
  800fd4:	39 f7                	cmp    %esi,%edi
  800fd6:	0f 87 21 ff ff ff    	ja     800efd <__umoddi3+0x2d>
  800fdc:	89 da                	mov    %ebx,%edx
  800fde:	89 f0                	mov    %esi,%eax
  800fe0:	29 f8                	sub    %edi,%eax
  800fe2:	19 ea                	sbb    %ebp,%edx
  800fe4:	e9 14 ff ff ff       	jmp    800efd <__umoddi3+0x2d>
