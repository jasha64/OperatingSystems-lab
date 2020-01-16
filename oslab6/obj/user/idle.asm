
obj/user/idle.debug：     文件格式 elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  800039:	c7 05 00 20 80 00 e0 	movl   $0x800fe0,0x802000
  800040:	0f 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800043:	e8 f7 00 00 00       	call   80013f <sys_yield>
  800048:	eb f9                	jmp    800043 <umain+0x10>

0080004a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	56                   	push   %esi
  80004e:	53                   	push   %ebx
  80004f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800052:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  800055:	e8 c6 00 00 00       	call   800120 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  80005a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800062:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800067:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006c:	85 db                	test   %ebx,%ebx
  80006e:	7e 07                	jle    800077 <libmain+0x2d>
		binaryname = argv[0];
  800070:	8b 06                	mov    (%esi),%eax
  800072:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800077:	83 ec 08             	sub    $0x8,%esp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	e8 b2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800081:	e8 0a 00 00 00       	call   800090 <exit>
}
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008c:	5b                   	pop    %ebx
  80008d:	5e                   	pop    %esi
  80008e:	5d                   	pop    %ebp
  80008f:	c3                   	ret    

00800090 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800096:	6a 00                	push   $0x0
  800098:	e8 42 00 00 00       	call   8000df <sys_env_destroy>
}
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	57                   	push   %edi
  8000a6:	56                   	push   %esi
  8000a7:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b3:	89 c3                	mov    %eax,%ebx
  8000b5:	89 c7                	mov    %eax,%edi
  8000b7:	89 c6                	mov    %eax,%esi
  8000b9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000bb:	5b                   	pop    %ebx
  8000bc:	5e                   	pop    %esi
  8000bd:	5f                   	pop    %edi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    

008000c0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d0:	89 d1                	mov    %edx,%ecx
  8000d2:	89 d3                	mov    %edx,%ebx
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	89 d6                	mov    %edx,%esi
  8000d8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000da:	5b                   	pop    %ebx
  8000db:	5e                   	pop    %esi
  8000dc:	5f                   	pop    %edi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	57                   	push   %edi
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f5:	89 cb                	mov    %ecx,%ebx
  8000f7:	89 cf                	mov    %ecx,%edi
  8000f9:	89 ce                	mov    %ecx,%esi
  8000fb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000fd:	85 c0                	test   %eax,%eax
  8000ff:	7f 08                	jg     800109 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800101:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800104:	5b                   	pop    %ebx
  800105:	5e                   	pop    %esi
  800106:	5f                   	pop    %edi
  800107:	5d                   	pop    %ebp
  800108:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	50                   	push   %eax
  80010d:	6a 03                	push   $0x3
  80010f:	68 ef 0f 80 00       	push   $0x800fef
  800114:	6a 23                	push   $0x23
  800116:	68 0c 10 80 00       	push   $0x80100c
  80011b:	e8 2f 02 00 00       	call   80034f <_panic>

00800120 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	57                   	push   %edi
  800124:	56                   	push   %esi
  800125:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	b8 02 00 00 00       	mov    $0x2,%eax
  800130:	89 d1                	mov    %edx,%ecx
  800132:	89 d3                	mov    %edx,%ebx
  800134:	89 d7                	mov    %edx,%edi
  800136:	89 d6                	mov    %edx,%esi
  800138:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5f                   	pop    %edi
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    

0080013f <sys_yield>:

void
sys_yield(void)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	57                   	push   %edi
  800143:	56                   	push   %esi
  800144:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800145:	ba 00 00 00 00       	mov    $0x0,%edx
  80014a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80014f:	89 d1                	mov    %edx,%ecx
  800151:	89 d3                	mov    %edx,%ebx
  800153:	89 d7                	mov    %edx,%edi
  800155:	89 d6                	mov    %edx,%esi
  800157:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800159:	5b                   	pop    %ebx
  80015a:	5e                   	pop    %esi
  80015b:	5f                   	pop    %edi
  80015c:	5d                   	pop    %ebp
  80015d:	c3                   	ret    

0080015e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	57                   	push   %edi
  800162:	56                   	push   %esi
  800163:	53                   	push   %ebx
  800164:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	8b 55 08             	mov    0x8(%ebp),%edx
  80016f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800172:	b8 04 00 00 00       	mov    $0x4,%eax
  800177:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017a:	89 f7                	mov    %esi,%edi
  80017c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80017e:	85 c0                	test   %eax,%eax
  800180:	7f 08                	jg     80018a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800182:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800185:	5b                   	pop    %ebx
  800186:	5e                   	pop    %esi
  800187:	5f                   	pop    %edi
  800188:	5d                   	pop    %ebp
  800189:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	50                   	push   %eax
  80018e:	6a 04                	push   $0x4
  800190:	68 ef 0f 80 00       	push   $0x800fef
  800195:	6a 23                	push   $0x23
  800197:	68 0c 10 80 00       	push   $0x80100c
  80019c:	e8 ae 01 00 00       	call   80034f <_panic>

008001a1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	57                   	push   %edi
  8001a5:	56                   	push   %esi
  8001a6:	53                   	push   %ebx
  8001a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8001aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001bb:	8b 75 18             	mov    0x18(%ebp),%esi
  8001be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c0:	85 c0                	test   %eax,%eax
  8001c2:	7f 08                	jg     8001cc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c7:	5b                   	pop    %ebx
  8001c8:	5e                   	pop    %esi
  8001c9:	5f                   	pop    %edi
  8001ca:	5d                   	pop    %ebp
  8001cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	6a 05                	push   $0x5
  8001d2:	68 ef 0f 80 00       	push   $0x800fef
  8001d7:	6a 23                	push   $0x23
  8001d9:	68 0c 10 80 00       	push   $0x80100c
  8001de:	e8 6c 01 00 00       	call   80034f <_panic>

008001e3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	57                   	push   %edi
  8001e7:	56                   	push   %esi
  8001e8:	53                   	push   %ebx
  8001e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8001ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f7:	b8 06 00 00 00       	mov    $0x6,%eax
  8001fc:	89 df                	mov    %ebx,%edi
  8001fe:	89 de                	mov    %ebx,%esi
  800200:	cd 30                	int    $0x30
	if(check && ret > 0)
  800202:	85 c0                	test   %eax,%eax
  800204:	7f 08                	jg     80020e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800206:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800209:	5b                   	pop    %ebx
  80020a:	5e                   	pop    %esi
  80020b:	5f                   	pop    %edi
  80020c:	5d                   	pop    %ebp
  80020d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020e:	83 ec 0c             	sub    $0xc,%esp
  800211:	50                   	push   %eax
  800212:	6a 06                	push   $0x6
  800214:	68 ef 0f 80 00       	push   $0x800fef
  800219:	6a 23                	push   $0x23
  80021b:	68 0c 10 80 00       	push   $0x80100c
  800220:	e8 2a 01 00 00       	call   80034f <_panic>

00800225 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	57                   	push   %edi
  800229:	56                   	push   %esi
  80022a:	53                   	push   %ebx
  80022b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80022e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800233:	8b 55 08             	mov    0x8(%ebp),%edx
  800236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800239:	b8 08 00 00 00       	mov    $0x8,%eax
  80023e:	89 df                	mov    %ebx,%edi
  800240:	89 de                	mov    %ebx,%esi
  800242:	cd 30                	int    $0x30
	if(check && ret > 0)
  800244:	85 c0                	test   %eax,%eax
  800246:	7f 08                	jg     800250 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024b:	5b                   	pop    %ebx
  80024c:	5e                   	pop    %esi
  80024d:	5f                   	pop    %edi
  80024e:	5d                   	pop    %ebp
  80024f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800250:	83 ec 0c             	sub    $0xc,%esp
  800253:	50                   	push   %eax
  800254:	6a 08                	push   $0x8
  800256:	68 ef 0f 80 00       	push   $0x800fef
  80025b:	6a 23                	push   $0x23
  80025d:	68 0c 10 80 00       	push   $0x80100c
  800262:	e8 e8 00 00 00       	call   80034f <_panic>

00800267 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	57                   	push   %edi
  80026b:	56                   	push   %esi
  80026c:	53                   	push   %ebx
  80026d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800270:	bb 00 00 00 00       	mov    $0x0,%ebx
  800275:	8b 55 08             	mov    0x8(%ebp),%edx
  800278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027b:	b8 09 00 00 00       	mov    $0x9,%eax
  800280:	89 df                	mov    %ebx,%edi
  800282:	89 de                	mov    %ebx,%esi
  800284:	cd 30                	int    $0x30
	if(check && ret > 0)
  800286:	85 c0                	test   %eax,%eax
  800288:	7f 08                	jg     800292 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80028a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028d:	5b                   	pop    %ebx
  80028e:	5e                   	pop    %esi
  80028f:	5f                   	pop    %edi
  800290:	5d                   	pop    %ebp
  800291:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	50                   	push   %eax
  800296:	6a 09                	push   $0x9
  800298:	68 ef 0f 80 00       	push   $0x800fef
  80029d:	6a 23                	push   $0x23
  80029f:	68 0c 10 80 00       	push   $0x80100c
  8002a4:	e8 a6 00 00 00       	call   80034f <_panic>

008002a9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c2:	89 df                	mov    %ebx,%edi
  8002c4:	89 de                	mov    %ebx,%esi
  8002c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	7f 08                	jg     8002d4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cf:	5b                   	pop    %ebx
  8002d0:	5e                   	pop    %esi
  8002d1:	5f                   	pop    %edi
  8002d2:	5d                   	pop    %ebp
  8002d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	50                   	push   %eax
  8002d8:	6a 0a                	push   $0xa
  8002da:	68 ef 0f 80 00       	push   $0x800fef
  8002df:	6a 23                	push   $0x23
  8002e1:	68 0c 10 80 00       	push   $0x80100c
  8002e6:	e8 64 00 00 00       	call   80034f <_panic>

008002eb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	57                   	push   %edi
  8002ef:	56                   	push   %esi
  8002f0:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002fc:	be 00 00 00 00       	mov    $0x0,%esi
  800301:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800304:	8b 7d 14             	mov    0x14(%ebp),%edi
  800307:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800309:	5b                   	pop    %ebx
  80030a:	5e                   	pop    %esi
  80030b:	5f                   	pop    %edi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	57                   	push   %edi
  800312:	56                   	push   %esi
  800313:	53                   	push   %ebx
  800314:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800317:	b9 00 00 00 00       	mov    $0x0,%ecx
  80031c:	8b 55 08             	mov    0x8(%ebp),%edx
  80031f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800324:	89 cb                	mov    %ecx,%ebx
  800326:	89 cf                	mov    %ecx,%edi
  800328:	89 ce                	mov    %ecx,%esi
  80032a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80032c:	85 c0                	test   %eax,%eax
  80032e:	7f 08                	jg     800338 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800333:	5b                   	pop    %ebx
  800334:	5e                   	pop    %esi
  800335:	5f                   	pop    %edi
  800336:	5d                   	pop    %ebp
  800337:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800338:	83 ec 0c             	sub    $0xc,%esp
  80033b:	50                   	push   %eax
  80033c:	6a 0d                	push   $0xd
  80033e:	68 ef 0f 80 00       	push   $0x800fef
  800343:	6a 23                	push   $0x23
  800345:	68 0c 10 80 00       	push   $0x80100c
  80034a:	e8 00 00 00 00       	call   80034f <_panic>

0080034f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	56                   	push   %esi
  800353:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800354:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800357:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80035d:	e8 be fd ff ff       	call   800120 <sys_getenvid>
  800362:	83 ec 0c             	sub    $0xc,%esp
  800365:	ff 75 0c             	pushl  0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	56                   	push   %esi
  80036c:	50                   	push   %eax
  80036d:	68 1c 10 80 00       	push   $0x80101c
  800372:	e8 b3 00 00 00       	call   80042a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800377:	83 c4 18             	add    $0x18,%esp
  80037a:	53                   	push   %ebx
  80037b:	ff 75 10             	pushl  0x10(%ebp)
  80037e:	e8 56 00 00 00       	call   8003d9 <vcprintf>
	cprintf("\n");
  800383:	c7 04 24 3f 10 80 00 	movl   $0x80103f,(%esp)
  80038a:	e8 9b 00 00 00       	call   80042a <cprintf>
  80038f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800392:	cc                   	int3   
  800393:	eb fd                	jmp    800392 <_panic+0x43>

00800395 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800395:	55                   	push   %ebp
  800396:	89 e5                	mov    %esp,%ebp
  800398:	53                   	push   %ebx
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80039f:	8b 13                	mov    (%ebx),%edx
  8003a1:	8d 42 01             	lea    0x1(%edx),%eax
  8003a4:	89 03                	mov    %eax,(%ebx)
  8003a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003ad:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b2:	74 09                	je     8003bd <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003b4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003bb:	c9                   	leave  
  8003bc:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	68 ff 00 00 00       	push   $0xff
  8003c5:	8d 43 08             	lea    0x8(%ebx),%eax
  8003c8:	50                   	push   %eax
  8003c9:	e8 d4 fc ff ff       	call   8000a2 <sys_cputs>
		b->idx = 0;
  8003ce:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003d4:	83 c4 10             	add    $0x10,%esp
  8003d7:	eb db                	jmp    8003b4 <putch+0x1f>

008003d9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e9:	00 00 00 
	b.cnt = 0;
  8003ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003f6:	ff 75 0c             	pushl  0xc(%ebp)
  8003f9:	ff 75 08             	pushl  0x8(%ebp)
  8003fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800402:	50                   	push   %eax
  800403:	68 95 03 80 00       	push   $0x800395
  800408:	e8 1a 01 00 00       	call   800527 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80040d:	83 c4 08             	add    $0x8,%esp
  800410:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800416:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80041c:	50                   	push   %eax
  80041d:	e8 80 fc ff ff       	call   8000a2 <sys_cputs>

	return b.cnt;
}
  800422:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800430:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800433:	50                   	push   %eax
  800434:	ff 75 08             	pushl  0x8(%ebp)
  800437:	e8 9d ff ff ff       	call   8003d9 <vcprintf>
	va_end(ap);

	return cnt;
}
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	57                   	push   %edi
  800442:	56                   	push   %esi
  800443:	53                   	push   %ebx
  800444:	83 ec 1c             	sub    $0x1c,%esp
  800447:	89 c7                	mov    %eax,%edi
  800449:	89 d6                	mov    %edx,%esi
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800451:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800454:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800457:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80045a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800462:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800465:	39 d3                	cmp    %edx,%ebx
  800467:	72 05                	jb     80046e <printnum+0x30>
  800469:	39 45 10             	cmp    %eax,0x10(%ebp)
  80046c:	77 7a                	ja     8004e8 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80046e:	83 ec 0c             	sub    $0xc,%esp
  800471:	ff 75 18             	pushl  0x18(%ebp)
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80047a:	53                   	push   %ebx
  80047b:	ff 75 10             	pushl  0x10(%ebp)
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	ff 75 e4             	pushl  -0x1c(%ebp)
  800484:	ff 75 e0             	pushl  -0x20(%ebp)
  800487:	ff 75 dc             	pushl  -0x24(%ebp)
  80048a:	ff 75 d8             	pushl  -0x28(%ebp)
  80048d:	e8 fe 08 00 00       	call   800d90 <__udivdi3>
  800492:	83 c4 18             	add    $0x18,%esp
  800495:	52                   	push   %edx
  800496:	50                   	push   %eax
  800497:	89 f2                	mov    %esi,%edx
  800499:	89 f8                	mov    %edi,%eax
  80049b:	e8 9e ff ff ff       	call   80043e <printnum>
  8004a0:	83 c4 20             	add    $0x20,%esp
  8004a3:	eb 13                	jmp    8004b8 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a5:	83 ec 08             	sub    $0x8,%esp
  8004a8:	56                   	push   %esi
  8004a9:	ff 75 18             	pushl  0x18(%ebp)
  8004ac:	ff d7                	call   *%edi
  8004ae:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004b1:	83 eb 01             	sub    $0x1,%ebx
  8004b4:	85 db                	test   %ebx,%ebx
  8004b6:	7f ed                	jg     8004a5 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004b8:	83 ec 08             	sub    $0x8,%esp
  8004bb:	56                   	push   %esi
  8004bc:	83 ec 04             	sub    $0x4,%esp
  8004bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004c2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c5:	ff 75 dc             	pushl  -0x24(%ebp)
  8004c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8004cb:	e8 e0 09 00 00       	call   800eb0 <__umoddi3>
  8004d0:	83 c4 14             	add    $0x14,%esp
  8004d3:	0f be 80 41 10 80 00 	movsbl 0x801041(%eax),%eax
  8004da:	50                   	push   %eax
  8004db:	ff d7                	call   *%edi
}
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e3:	5b                   	pop    %ebx
  8004e4:	5e                   	pop    %esi
  8004e5:	5f                   	pop    %edi
  8004e6:	5d                   	pop    %ebp
  8004e7:	c3                   	ret    
  8004e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004eb:	eb c4                	jmp    8004b1 <printnum+0x73>

008004ed <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f7:	8b 10                	mov    (%eax),%edx
  8004f9:	3b 50 04             	cmp    0x4(%eax),%edx
  8004fc:	73 0a                	jae    800508 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800501:	89 08                	mov    %ecx,(%eax)
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	88 02                	mov    %al,(%edx)
}
  800508:	5d                   	pop    %ebp
  800509:	c3                   	ret    

0080050a <printfmt>:
{
  80050a:	55                   	push   %ebp
  80050b:	89 e5                	mov    %esp,%ebp
  80050d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800510:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800513:	50                   	push   %eax
  800514:	ff 75 10             	pushl  0x10(%ebp)
  800517:	ff 75 0c             	pushl  0xc(%ebp)
  80051a:	ff 75 08             	pushl  0x8(%ebp)
  80051d:	e8 05 00 00 00       	call   800527 <vprintfmt>
}
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	c9                   	leave  
  800526:	c3                   	ret    

00800527 <vprintfmt>:
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	57                   	push   %edi
  80052b:	56                   	push   %esi
  80052c:	53                   	push   %ebx
  80052d:	83 ec 2c             	sub    $0x2c,%esp
  800530:	8b 75 08             	mov    0x8(%ebp),%esi
  800533:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800536:	8b 7d 10             	mov    0x10(%ebp),%edi
  800539:	e9 c1 03 00 00       	jmp    8008ff <vprintfmt+0x3d8>
		padc = ' ';
  80053e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800542:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800549:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800550:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800557:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80055c:	8d 47 01             	lea    0x1(%edi),%eax
  80055f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800562:	0f b6 17             	movzbl (%edi),%edx
  800565:	8d 42 dd             	lea    -0x23(%edx),%eax
  800568:	3c 55                	cmp    $0x55,%al
  80056a:	0f 87 12 04 00 00    	ja     800982 <vprintfmt+0x45b>
  800570:	0f b6 c0             	movzbl %al,%eax
  800573:	ff 24 85 80 11 80 00 	jmp    *0x801180(,%eax,4)
  80057a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80057d:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800581:	eb d9                	jmp    80055c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800583:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800586:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80058a:	eb d0                	jmp    80055c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80058c:	0f b6 d2             	movzbl %dl,%edx
  80058f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800592:	b8 00 00 00 00       	mov    $0x0,%eax
  800597:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80059a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80059d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005a1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005a4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005a7:	83 f9 09             	cmp    $0x9,%ecx
  8005aa:	77 55                	ja     800601 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8005ac:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005af:	eb e9                	jmp    80059a <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	8d 40 04             	lea    0x4(%eax),%eax
  8005bf:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c9:	79 91                	jns    80055c <vprintfmt+0x35>
				width = precision, precision = -1;
  8005cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d1:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005d8:	eb 82                	jmp    80055c <vprintfmt+0x35>
  8005da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005dd:	85 c0                	test   %eax,%eax
  8005df:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e4:	0f 49 d0             	cmovns %eax,%edx
  8005e7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005ed:	e9 6a ff ff ff       	jmp    80055c <vprintfmt+0x35>
  8005f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005f5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005fc:	e9 5b ff ff ff       	jmp    80055c <vprintfmt+0x35>
  800601:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800604:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800607:	eb bc                	jmp    8005c5 <vprintfmt+0x9e>
			lflag++;
  800609:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80060c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80060f:	e9 48 ff ff ff       	jmp    80055c <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8d 78 04             	lea    0x4(%eax),%edi
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	53                   	push   %ebx
  80061e:	ff 30                	pushl  (%eax)
  800620:	ff d6                	call   *%esi
			break;
  800622:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800625:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800628:	e9 cf 02 00 00       	jmp    8008fc <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8d 78 04             	lea    0x4(%eax),%edi
  800633:	8b 00                	mov    (%eax),%eax
  800635:	99                   	cltd   
  800636:	31 d0                	xor    %edx,%eax
  800638:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80063a:	83 f8 0f             	cmp    $0xf,%eax
  80063d:	7f 23                	jg     800662 <vprintfmt+0x13b>
  80063f:	8b 14 85 e0 12 80 00 	mov    0x8012e0(,%eax,4),%edx
  800646:	85 d2                	test   %edx,%edx
  800648:	74 18                	je     800662 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80064a:	52                   	push   %edx
  80064b:	68 62 10 80 00       	push   $0x801062
  800650:	53                   	push   %ebx
  800651:	56                   	push   %esi
  800652:	e8 b3 fe ff ff       	call   80050a <printfmt>
  800657:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80065a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80065d:	e9 9a 02 00 00       	jmp    8008fc <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800662:	50                   	push   %eax
  800663:	68 59 10 80 00       	push   $0x801059
  800668:	53                   	push   %ebx
  800669:	56                   	push   %esi
  80066a:	e8 9b fe ff ff       	call   80050a <printfmt>
  80066f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800672:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800675:	e9 82 02 00 00       	jmp    8008fc <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	83 c0 04             	add    $0x4,%eax
  800680:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800688:	85 ff                	test   %edi,%edi
  80068a:	b8 52 10 80 00       	mov    $0x801052,%eax
  80068f:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800692:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800696:	0f 8e bd 00 00 00    	jle    800759 <vprintfmt+0x232>
  80069c:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8006a0:	75 0e                	jne    8006b0 <vprintfmt+0x189>
  8006a2:	89 75 08             	mov    %esi,0x8(%ebp)
  8006a5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006a8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006ab:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006ae:	eb 6d                	jmp    80071d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	ff 75 d0             	pushl  -0x30(%ebp)
  8006b6:	57                   	push   %edi
  8006b7:	e8 6e 03 00 00       	call   800a2a <strnlen>
  8006bc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006bf:	29 c1                	sub    %eax,%ecx
  8006c1:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8006c4:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006c7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006ce:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006d1:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d3:	eb 0f                	jmp    8006e4 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	53                   	push   %ebx
  8006d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8006dc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006de:	83 ef 01             	sub    $0x1,%edi
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	85 ff                	test   %edi,%edi
  8006e6:	7f ed                	jg     8006d5 <vprintfmt+0x1ae>
  8006e8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006eb:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006ee:	85 c9                	test   %ecx,%ecx
  8006f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f5:	0f 49 c1             	cmovns %ecx,%eax
  8006f8:	29 c1                	sub    %eax,%ecx
  8006fa:	89 75 08             	mov    %esi,0x8(%ebp)
  8006fd:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800700:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800703:	89 cb                	mov    %ecx,%ebx
  800705:	eb 16                	jmp    80071d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800707:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80070b:	75 31                	jne    80073e <vprintfmt+0x217>
					putch(ch, putdat);
  80070d:	83 ec 08             	sub    $0x8,%esp
  800710:	ff 75 0c             	pushl  0xc(%ebp)
  800713:	50                   	push   %eax
  800714:	ff 55 08             	call   *0x8(%ebp)
  800717:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80071a:	83 eb 01             	sub    $0x1,%ebx
  80071d:	83 c7 01             	add    $0x1,%edi
  800720:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800724:	0f be c2             	movsbl %dl,%eax
  800727:	85 c0                	test   %eax,%eax
  800729:	74 59                	je     800784 <vprintfmt+0x25d>
  80072b:	85 f6                	test   %esi,%esi
  80072d:	78 d8                	js     800707 <vprintfmt+0x1e0>
  80072f:	83 ee 01             	sub    $0x1,%esi
  800732:	79 d3                	jns    800707 <vprintfmt+0x1e0>
  800734:	89 df                	mov    %ebx,%edi
  800736:	8b 75 08             	mov    0x8(%ebp),%esi
  800739:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80073c:	eb 37                	jmp    800775 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80073e:	0f be d2             	movsbl %dl,%edx
  800741:	83 ea 20             	sub    $0x20,%edx
  800744:	83 fa 5e             	cmp    $0x5e,%edx
  800747:	76 c4                	jbe    80070d <vprintfmt+0x1e6>
					putch('?', putdat);
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	ff 75 0c             	pushl  0xc(%ebp)
  80074f:	6a 3f                	push   $0x3f
  800751:	ff 55 08             	call   *0x8(%ebp)
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	eb c1                	jmp    80071a <vprintfmt+0x1f3>
  800759:	89 75 08             	mov    %esi,0x8(%ebp)
  80075c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80075f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800762:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800765:	eb b6                	jmp    80071d <vprintfmt+0x1f6>
				putch(' ', putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	53                   	push   %ebx
  80076b:	6a 20                	push   $0x20
  80076d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80076f:	83 ef 01             	sub    $0x1,%edi
  800772:	83 c4 10             	add    $0x10,%esp
  800775:	85 ff                	test   %edi,%edi
  800777:	7f ee                	jg     800767 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800779:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
  80077f:	e9 78 01 00 00       	jmp    8008fc <vprintfmt+0x3d5>
  800784:	89 df                	mov    %ebx,%edi
  800786:	8b 75 08             	mov    0x8(%ebp),%esi
  800789:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80078c:	eb e7                	jmp    800775 <vprintfmt+0x24e>
	if (lflag >= 2)
  80078e:	83 f9 01             	cmp    $0x1,%ecx
  800791:	7e 3f                	jle    8007d2 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8b 50 04             	mov    0x4(%eax),%edx
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a4:	8d 40 08             	lea    0x8(%eax),%eax
  8007a7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007ae:	79 5c                	jns    80080c <vprintfmt+0x2e5>
				putch('-', putdat);
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	53                   	push   %ebx
  8007b4:	6a 2d                	push   $0x2d
  8007b6:	ff d6                	call   *%esi
				num = -(long long) num;
  8007b8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007bb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007be:	f7 da                	neg    %edx
  8007c0:	83 d1 00             	adc    $0x0,%ecx
  8007c3:	f7 d9                	neg    %ecx
  8007c5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007cd:	e9 10 01 00 00       	jmp    8008e2 <vprintfmt+0x3bb>
	else if (lflag)
  8007d2:	85 c9                	test   %ecx,%ecx
  8007d4:	75 1b                	jne    8007f1 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007de:	89 c1                	mov    %eax,%ecx
  8007e0:	c1 f9 1f             	sar    $0x1f,%ecx
  8007e3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e9:	8d 40 04             	lea    0x4(%eax),%eax
  8007ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ef:	eb b9                	jmp    8007aa <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f9:	89 c1                	mov    %eax,%ecx
  8007fb:	c1 f9 1f             	sar    $0x1f,%ecx
  8007fe:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	8d 40 04             	lea    0x4(%eax),%eax
  800807:	89 45 14             	mov    %eax,0x14(%ebp)
  80080a:	eb 9e                	jmp    8007aa <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80080c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80080f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800812:	b8 0a 00 00 00       	mov    $0xa,%eax
  800817:	e9 c6 00 00 00       	jmp    8008e2 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80081c:	83 f9 01             	cmp    $0x1,%ecx
  80081f:	7e 18                	jle    800839 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800821:	8b 45 14             	mov    0x14(%ebp),%eax
  800824:	8b 10                	mov    (%eax),%edx
  800826:	8b 48 04             	mov    0x4(%eax),%ecx
  800829:	8d 40 08             	lea    0x8(%eax),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80082f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800834:	e9 a9 00 00 00       	jmp    8008e2 <vprintfmt+0x3bb>
	else if (lflag)
  800839:	85 c9                	test   %ecx,%ecx
  80083b:	75 1a                	jne    800857 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	8b 10                	mov    (%eax),%edx
  800842:	b9 00 00 00 00       	mov    $0x0,%ecx
  800847:	8d 40 04             	lea    0x4(%eax),%eax
  80084a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80084d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800852:	e9 8b 00 00 00       	jmp    8008e2 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	8b 10                	mov    (%eax),%edx
  80085c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800861:	8d 40 04             	lea    0x4(%eax),%eax
  800864:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800867:	b8 0a 00 00 00       	mov    $0xa,%eax
  80086c:	eb 74                	jmp    8008e2 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80086e:	83 f9 01             	cmp    $0x1,%ecx
  800871:	7e 15                	jle    800888 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	8b 10                	mov    (%eax),%edx
  800878:	8b 48 04             	mov    0x4(%eax),%ecx
  80087b:	8d 40 08             	lea    0x8(%eax),%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800881:	b8 08 00 00 00       	mov    $0x8,%eax
  800886:	eb 5a                	jmp    8008e2 <vprintfmt+0x3bb>
	else if (lflag)
  800888:	85 c9                	test   %ecx,%ecx
  80088a:	75 17                	jne    8008a3 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	8b 10                	mov    (%eax),%edx
  800891:	b9 00 00 00 00       	mov    $0x0,%ecx
  800896:	8d 40 04             	lea    0x4(%eax),%eax
  800899:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80089c:	b8 08 00 00 00       	mov    $0x8,%eax
  8008a1:	eb 3f                	jmp    8008e2 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8008a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a6:	8b 10                	mov    (%eax),%edx
  8008a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008ad:	8d 40 04             	lea    0x4(%eax),%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008b3:	b8 08 00 00 00       	mov    $0x8,%eax
  8008b8:	eb 28                	jmp    8008e2 <vprintfmt+0x3bb>
			putch('0', putdat);
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	53                   	push   %ebx
  8008be:	6a 30                	push   $0x30
  8008c0:	ff d6                	call   *%esi
			putch('x', putdat);
  8008c2:	83 c4 08             	add    $0x8,%esp
  8008c5:	53                   	push   %ebx
  8008c6:	6a 78                	push   $0x78
  8008c8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	8b 10                	mov    (%eax),%edx
  8008cf:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008d4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008d7:	8d 40 04             	lea    0x4(%eax),%eax
  8008da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008dd:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008e2:	83 ec 0c             	sub    $0xc,%esp
  8008e5:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008e9:	57                   	push   %edi
  8008ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8008ed:	50                   	push   %eax
  8008ee:	51                   	push   %ecx
  8008ef:	52                   	push   %edx
  8008f0:	89 da                	mov    %ebx,%edx
  8008f2:	89 f0                	mov    %esi,%eax
  8008f4:	e8 45 fb ff ff       	call   80043e <printnum>
			break;
  8008f9:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  8008ff:	83 c7 01             	add    $0x1,%edi
  800902:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800906:	83 f8 25             	cmp    $0x25,%eax
  800909:	0f 84 2f fc ff ff    	je     80053e <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  80090f:	85 c0                	test   %eax,%eax
  800911:	0f 84 8b 00 00 00    	je     8009a2 <vprintfmt+0x47b>
			putch(ch, putdat);
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	53                   	push   %ebx
  80091b:	50                   	push   %eax
  80091c:	ff d6                	call   *%esi
  80091e:	83 c4 10             	add    $0x10,%esp
  800921:	eb dc                	jmp    8008ff <vprintfmt+0x3d8>
	if (lflag >= 2)
  800923:	83 f9 01             	cmp    $0x1,%ecx
  800926:	7e 15                	jle    80093d <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	8b 10                	mov    (%eax),%edx
  80092d:	8b 48 04             	mov    0x4(%eax),%ecx
  800930:	8d 40 08             	lea    0x8(%eax),%eax
  800933:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800936:	b8 10 00 00 00       	mov    $0x10,%eax
  80093b:	eb a5                	jmp    8008e2 <vprintfmt+0x3bb>
	else if (lflag)
  80093d:	85 c9                	test   %ecx,%ecx
  80093f:	75 17                	jne    800958 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800941:	8b 45 14             	mov    0x14(%ebp),%eax
  800944:	8b 10                	mov    (%eax),%edx
  800946:	b9 00 00 00 00       	mov    $0x0,%ecx
  80094b:	8d 40 04             	lea    0x4(%eax),%eax
  80094e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800951:	b8 10 00 00 00       	mov    $0x10,%eax
  800956:	eb 8a                	jmp    8008e2 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	8b 10                	mov    (%eax),%edx
  80095d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800962:	8d 40 04             	lea    0x4(%eax),%eax
  800965:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800968:	b8 10 00 00 00       	mov    $0x10,%eax
  80096d:	e9 70 ff ff ff       	jmp    8008e2 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	53                   	push   %ebx
  800976:	6a 25                	push   $0x25
  800978:	ff d6                	call   *%esi
			break;
  80097a:	83 c4 10             	add    $0x10,%esp
  80097d:	e9 7a ff ff ff       	jmp    8008fc <vprintfmt+0x3d5>
			putch('%', putdat);
  800982:	83 ec 08             	sub    $0x8,%esp
  800985:	53                   	push   %ebx
  800986:	6a 25                	push   $0x25
  800988:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80098a:	83 c4 10             	add    $0x10,%esp
  80098d:	89 f8                	mov    %edi,%eax
  80098f:	eb 03                	jmp    800994 <vprintfmt+0x46d>
  800991:	83 e8 01             	sub    $0x1,%eax
  800994:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800998:	75 f7                	jne    800991 <vprintfmt+0x46a>
  80099a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80099d:	e9 5a ff ff ff       	jmp    8008fc <vprintfmt+0x3d5>
}
  8009a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a5:	5b                   	pop    %ebx
  8009a6:	5e                   	pop    %esi
  8009a7:	5f                   	pop    %edi
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	83 ec 18             	sub    $0x18,%esp
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009b9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009bd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009c7:	85 c0                	test   %eax,%eax
  8009c9:	74 26                	je     8009f1 <vsnprintf+0x47>
  8009cb:	85 d2                	test   %edx,%edx
  8009cd:	7e 22                	jle    8009f1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009cf:	ff 75 14             	pushl  0x14(%ebp)
  8009d2:	ff 75 10             	pushl  0x10(%ebp)
  8009d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009d8:	50                   	push   %eax
  8009d9:	68 ed 04 80 00       	push   $0x8004ed
  8009de:	e8 44 fb ff ff       	call   800527 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
}
  8009ef:	c9                   	leave  
  8009f0:	c3                   	ret    
		return -E_INVAL;
  8009f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f6:	eb f7                	jmp    8009ef <vsnprintf+0x45>

008009f8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009fe:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a01:	50                   	push   %eax
  800a02:	ff 75 10             	pushl  0x10(%ebp)
  800a05:	ff 75 0c             	pushl  0xc(%ebp)
  800a08:	ff 75 08             	pushl  0x8(%ebp)
  800a0b:	e8 9a ff ff ff       	call   8009aa <vsnprintf>
	va_end(ap);

	return rc;
}
  800a10:	c9                   	leave  
  800a11:	c3                   	ret    

00800a12 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a18:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1d:	eb 03                	jmp    800a22 <strlen+0x10>
		n++;
  800a1f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a22:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a26:	75 f7                	jne    800a1f <strlen+0xd>
	return n;
}
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a30:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a33:	b8 00 00 00 00       	mov    $0x0,%eax
  800a38:	eb 03                	jmp    800a3d <strnlen+0x13>
		n++;
  800a3a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3d:	39 d0                	cmp    %edx,%eax
  800a3f:	74 06                	je     800a47 <strnlen+0x1d>
  800a41:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a45:	75 f3                	jne    800a3a <strnlen+0x10>
	return n;
}
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	53                   	push   %ebx
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a53:	89 c2                	mov    %eax,%edx
  800a55:	83 c1 01             	add    $0x1,%ecx
  800a58:	83 c2 01             	add    $0x1,%edx
  800a5b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a5f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a62:	84 db                	test   %bl,%bl
  800a64:	75 ef                	jne    800a55 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a66:	5b                   	pop    %ebx
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	53                   	push   %ebx
  800a6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a70:	53                   	push   %ebx
  800a71:	e8 9c ff ff ff       	call   800a12 <strlen>
  800a76:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	01 d8                	add    %ebx,%eax
  800a7e:	50                   	push   %eax
  800a7f:	e8 c5 ff ff ff       	call   800a49 <strcpy>
	return dst;
}
  800a84:	89 d8                	mov    %ebx,%eax
  800a86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a89:	c9                   	leave  
  800a8a:	c3                   	ret    

00800a8b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	56                   	push   %esi
  800a8f:	53                   	push   %ebx
  800a90:	8b 75 08             	mov    0x8(%ebp),%esi
  800a93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a96:	89 f3                	mov    %esi,%ebx
  800a98:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a9b:	89 f2                	mov    %esi,%edx
  800a9d:	eb 0f                	jmp    800aae <strncpy+0x23>
		*dst++ = *src;
  800a9f:	83 c2 01             	add    $0x1,%edx
  800aa2:	0f b6 01             	movzbl (%ecx),%eax
  800aa5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa8:	80 39 01             	cmpb   $0x1,(%ecx)
  800aab:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800aae:	39 da                	cmp    %ebx,%edx
  800ab0:	75 ed                	jne    800a9f <strncpy+0x14>
	}
	return ret;
}
  800ab2:	89 f0                	mov    %esi,%eax
  800ab4:	5b                   	pop    %ebx
  800ab5:	5e                   	pop    %esi
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    

00800ab8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	56                   	push   %esi
  800abc:	53                   	push   %ebx
  800abd:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ac6:	89 f0                	mov    %esi,%eax
  800ac8:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800acc:	85 c9                	test   %ecx,%ecx
  800ace:	75 0b                	jne    800adb <strlcpy+0x23>
  800ad0:	eb 17                	jmp    800ae9 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ad2:	83 c2 01             	add    $0x1,%edx
  800ad5:	83 c0 01             	add    $0x1,%eax
  800ad8:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800adb:	39 d8                	cmp    %ebx,%eax
  800add:	74 07                	je     800ae6 <strlcpy+0x2e>
  800adf:	0f b6 0a             	movzbl (%edx),%ecx
  800ae2:	84 c9                	test   %cl,%cl
  800ae4:	75 ec                	jne    800ad2 <strlcpy+0x1a>
		*dst = '\0';
  800ae6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae9:	29 f0                	sub    %esi,%eax
}
  800aeb:	5b                   	pop    %ebx
  800aec:	5e                   	pop    %esi
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800af8:	eb 06                	jmp    800b00 <strcmp+0x11>
		p++, q++;
  800afa:	83 c1 01             	add    $0x1,%ecx
  800afd:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b00:	0f b6 01             	movzbl (%ecx),%eax
  800b03:	84 c0                	test   %al,%al
  800b05:	74 04                	je     800b0b <strcmp+0x1c>
  800b07:	3a 02                	cmp    (%edx),%al
  800b09:	74 ef                	je     800afa <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0b:	0f b6 c0             	movzbl %al,%eax
  800b0e:	0f b6 12             	movzbl (%edx),%edx
  800b11:	29 d0                	sub    %edx,%eax
}
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	53                   	push   %ebx
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1f:	89 c3                	mov    %eax,%ebx
  800b21:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b24:	eb 06                	jmp    800b2c <strncmp+0x17>
		n--, p++, q++;
  800b26:	83 c0 01             	add    $0x1,%eax
  800b29:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b2c:	39 d8                	cmp    %ebx,%eax
  800b2e:	74 16                	je     800b46 <strncmp+0x31>
  800b30:	0f b6 08             	movzbl (%eax),%ecx
  800b33:	84 c9                	test   %cl,%cl
  800b35:	74 04                	je     800b3b <strncmp+0x26>
  800b37:	3a 0a                	cmp    (%edx),%cl
  800b39:	74 eb                	je     800b26 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b3b:	0f b6 00             	movzbl (%eax),%eax
  800b3e:	0f b6 12             	movzbl (%edx),%edx
  800b41:	29 d0                	sub    %edx,%eax
}
  800b43:	5b                   	pop    %ebx
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    
		return 0;
  800b46:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4b:	eb f6                	jmp    800b43 <strncmp+0x2e>

00800b4d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b57:	0f b6 10             	movzbl (%eax),%edx
  800b5a:	84 d2                	test   %dl,%dl
  800b5c:	74 09                	je     800b67 <strchr+0x1a>
		if (*s == c)
  800b5e:	38 ca                	cmp    %cl,%dl
  800b60:	74 0a                	je     800b6c <strchr+0x1f>
	for (; *s; s++)
  800b62:	83 c0 01             	add    $0x1,%eax
  800b65:	eb f0                	jmp    800b57 <strchr+0xa>
			return (char *) s;
	return 0;
  800b67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    

00800b6e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b78:	eb 03                	jmp    800b7d <strfind+0xf>
  800b7a:	83 c0 01             	add    $0x1,%eax
  800b7d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b80:	38 ca                	cmp    %cl,%dl
  800b82:	74 04                	je     800b88 <strfind+0x1a>
  800b84:	84 d2                	test   %dl,%dl
  800b86:	75 f2                	jne    800b7a <strfind+0xc>
			break;
	return (char *) s;
}
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	57                   	push   %edi
  800b8e:	56                   	push   %esi
  800b8f:	53                   	push   %ebx
  800b90:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b93:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b96:	85 c9                	test   %ecx,%ecx
  800b98:	74 13                	je     800bad <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b9a:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ba0:	75 05                	jne    800ba7 <memset+0x1d>
  800ba2:	f6 c1 03             	test   $0x3,%cl
  800ba5:	74 0d                	je     800bb4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	fc                   	cld    
  800bab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bad:	89 f8                	mov    %edi,%eax
  800baf:	5b                   	pop    %ebx
  800bb0:	5e                   	pop    %esi
  800bb1:	5f                   	pop    %edi
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    
		c &= 0xFF;
  800bb4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb8:	89 d3                	mov    %edx,%ebx
  800bba:	c1 e3 08             	shl    $0x8,%ebx
  800bbd:	89 d0                	mov    %edx,%eax
  800bbf:	c1 e0 18             	shl    $0x18,%eax
  800bc2:	89 d6                	mov    %edx,%esi
  800bc4:	c1 e6 10             	shl    $0x10,%esi
  800bc7:	09 f0                	or     %esi,%eax
  800bc9:	09 c2                	or     %eax,%edx
  800bcb:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bcd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bd0:	89 d0                	mov    %edx,%eax
  800bd2:	fc                   	cld    
  800bd3:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd5:	eb d6                	jmp    800bad <memset+0x23>

00800bd7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	57                   	push   %edi
  800bdb:	56                   	push   %esi
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be5:	39 c6                	cmp    %eax,%esi
  800be7:	73 35                	jae    800c1e <memmove+0x47>
  800be9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bec:	39 c2                	cmp    %eax,%edx
  800bee:	76 2e                	jbe    800c1e <memmove+0x47>
		s += n;
		d += n;
  800bf0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf3:	89 d6                	mov    %edx,%esi
  800bf5:	09 fe                	or     %edi,%esi
  800bf7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bfd:	74 0c                	je     800c0b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bff:	83 ef 01             	sub    $0x1,%edi
  800c02:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c05:	fd                   	std    
  800c06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c08:	fc                   	cld    
  800c09:	eb 21                	jmp    800c2c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0b:	f6 c1 03             	test   $0x3,%cl
  800c0e:	75 ef                	jne    800bff <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c10:	83 ef 04             	sub    $0x4,%edi
  800c13:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c16:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c19:	fd                   	std    
  800c1a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1c:	eb ea                	jmp    800c08 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c1e:	89 f2                	mov    %esi,%edx
  800c20:	09 c2                	or     %eax,%edx
  800c22:	f6 c2 03             	test   $0x3,%dl
  800c25:	74 09                	je     800c30 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c27:	89 c7                	mov    %eax,%edi
  800c29:	fc                   	cld    
  800c2a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c2c:	5e                   	pop    %esi
  800c2d:	5f                   	pop    %edi
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c30:	f6 c1 03             	test   $0x3,%cl
  800c33:	75 f2                	jne    800c27 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c35:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c38:	89 c7                	mov    %eax,%edi
  800c3a:	fc                   	cld    
  800c3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c3d:	eb ed                	jmp    800c2c <memmove+0x55>

00800c3f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c42:	ff 75 10             	pushl  0x10(%ebp)
  800c45:	ff 75 0c             	pushl  0xc(%ebp)
  800c48:	ff 75 08             	pushl  0x8(%ebp)
  800c4b:	e8 87 ff ff ff       	call   800bd7 <memmove>
}
  800c50:	c9                   	leave  
  800c51:	c3                   	ret    

00800c52 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	56                   	push   %esi
  800c56:	53                   	push   %ebx
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5d:	89 c6                	mov    %eax,%esi
  800c5f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c62:	39 f0                	cmp    %esi,%eax
  800c64:	74 1c                	je     800c82 <memcmp+0x30>
		if (*s1 != *s2)
  800c66:	0f b6 08             	movzbl (%eax),%ecx
  800c69:	0f b6 1a             	movzbl (%edx),%ebx
  800c6c:	38 d9                	cmp    %bl,%cl
  800c6e:	75 08                	jne    800c78 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c70:	83 c0 01             	add    $0x1,%eax
  800c73:	83 c2 01             	add    $0x1,%edx
  800c76:	eb ea                	jmp    800c62 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c78:	0f b6 c1             	movzbl %cl,%eax
  800c7b:	0f b6 db             	movzbl %bl,%ebx
  800c7e:	29 d8                	sub    %ebx,%eax
  800c80:	eb 05                	jmp    800c87 <memcmp+0x35>
	}

	return 0;
  800c82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c94:	89 c2                	mov    %eax,%edx
  800c96:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c99:	39 d0                	cmp    %edx,%eax
  800c9b:	73 09                	jae    800ca6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c9d:	38 08                	cmp    %cl,(%eax)
  800c9f:	74 05                	je     800ca6 <memfind+0x1b>
	for (; s < ends; s++)
  800ca1:	83 c0 01             	add    $0x1,%eax
  800ca4:	eb f3                	jmp    800c99 <memfind+0xe>
			break;
	return (void *) s;
}
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	57                   	push   %edi
  800cac:	56                   	push   %esi
  800cad:	53                   	push   %ebx
  800cae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb4:	eb 03                	jmp    800cb9 <strtol+0x11>
		s++;
  800cb6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cb9:	0f b6 01             	movzbl (%ecx),%eax
  800cbc:	3c 20                	cmp    $0x20,%al
  800cbe:	74 f6                	je     800cb6 <strtol+0xe>
  800cc0:	3c 09                	cmp    $0x9,%al
  800cc2:	74 f2                	je     800cb6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cc4:	3c 2b                	cmp    $0x2b,%al
  800cc6:	74 2e                	je     800cf6 <strtol+0x4e>
	int neg = 0;
  800cc8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ccd:	3c 2d                	cmp    $0x2d,%al
  800ccf:	74 2f                	je     800d00 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cd1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cd7:	75 05                	jne    800cde <strtol+0x36>
  800cd9:	80 39 30             	cmpb   $0x30,(%ecx)
  800cdc:	74 2c                	je     800d0a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cde:	85 db                	test   %ebx,%ebx
  800ce0:	75 0a                	jne    800cec <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ce2:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ce7:	80 39 30             	cmpb   $0x30,(%ecx)
  800cea:	74 28                	je     800d14 <strtol+0x6c>
		base = 10;
  800cec:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cf4:	eb 50                	jmp    800d46 <strtol+0x9e>
		s++;
  800cf6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cf9:	bf 00 00 00 00       	mov    $0x0,%edi
  800cfe:	eb d1                	jmp    800cd1 <strtol+0x29>
		s++, neg = 1;
  800d00:	83 c1 01             	add    $0x1,%ecx
  800d03:	bf 01 00 00 00       	mov    $0x1,%edi
  800d08:	eb c7                	jmp    800cd1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d0a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d0e:	74 0e                	je     800d1e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d10:	85 db                	test   %ebx,%ebx
  800d12:	75 d8                	jne    800cec <strtol+0x44>
		s++, base = 8;
  800d14:	83 c1 01             	add    $0x1,%ecx
  800d17:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d1c:	eb ce                	jmp    800cec <strtol+0x44>
		s += 2, base = 16;
  800d1e:	83 c1 02             	add    $0x2,%ecx
  800d21:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d26:	eb c4                	jmp    800cec <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d28:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d2b:	89 f3                	mov    %esi,%ebx
  800d2d:	80 fb 19             	cmp    $0x19,%bl
  800d30:	77 29                	ja     800d5b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d32:	0f be d2             	movsbl %dl,%edx
  800d35:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d38:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d3b:	7d 30                	jge    800d6d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d3d:	83 c1 01             	add    $0x1,%ecx
  800d40:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d44:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d46:	0f b6 11             	movzbl (%ecx),%edx
  800d49:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d4c:	89 f3                	mov    %esi,%ebx
  800d4e:	80 fb 09             	cmp    $0x9,%bl
  800d51:	77 d5                	ja     800d28 <strtol+0x80>
			dig = *s - '0';
  800d53:	0f be d2             	movsbl %dl,%edx
  800d56:	83 ea 30             	sub    $0x30,%edx
  800d59:	eb dd                	jmp    800d38 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d5b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d5e:	89 f3                	mov    %esi,%ebx
  800d60:	80 fb 19             	cmp    $0x19,%bl
  800d63:	77 08                	ja     800d6d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d65:	0f be d2             	movsbl %dl,%edx
  800d68:	83 ea 37             	sub    $0x37,%edx
  800d6b:	eb cb                	jmp    800d38 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d71:	74 05                	je     800d78 <strtol+0xd0>
		*endptr = (char *) s;
  800d73:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d76:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d78:	89 c2                	mov    %eax,%edx
  800d7a:	f7 da                	neg    %edx
  800d7c:	85 ff                	test   %edi,%edi
  800d7e:	0f 45 c2             	cmovne %edx,%eax
}
  800d81:	5b                   	pop    %ebx
  800d82:	5e                   	pop    %esi
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    
  800d86:	66 90                	xchg   %ax,%ax
  800d88:	66 90                	xchg   %ax,%ax
  800d8a:	66 90                	xchg   %ax,%ax
  800d8c:	66 90                	xchg   %ax,%ax
  800d8e:	66 90                	xchg   %ax,%ax

00800d90 <__udivdi3>:
  800d90:	55                   	push   %ebp
  800d91:	57                   	push   %edi
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	83 ec 1c             	sub    $0x1c,%esp
  800d97:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800d9b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800d9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800da3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800da7:	85 d2                	test   %edx,%edx
  800da9:	75 35                	jne    800de0 <__udivdi3+0x50>
  800dab:	39 f3                	cmp    %esi,%ebx
  800dad:	0f 87 bd 00 00 00    	ja     800e70 <__udivdi3+0xe0>
  800db3:	85 db                	test   %ebx,%ebx
  800db5:	89 d9                	mov    %ebx,%ecx
  800db7:	75 0b                	jne    800dc4 <__udivdi3+0x34>
  800db9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dbe:	31 d2                	xor    %edx,%edx
  800dc0:	f7 f3                	div    %ebx
  800dc2:	89 c1                	mov    %eax,%ecx
  800dc4:	31 d2                	xor    %edx,%edx
  800dc6:	89 f0                	mov    %esi,%eax
  800dc8:	f7 f1                	div    %ecx
  800dca:	89 c6                	mov    %eax,%esi
  800dcc:	89 e8                	mov    %ebp,%eax
  800dce:	89 f7                	mov    %esi,%edi
  800dd0:	f7 f1                	div    %ecx
  800dd2:	89 fa                	mov    %edi,%edx
  800dd4:	83 c4 1c             	add    $0x1c,%esp
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    
  800ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800de0:	39 f2                	cmp    %esi,%edx
  800de2:	77 7c                	ja     800e60 <__udivdi3+0xd0>
  800de4:	0f bd fa             	bsr    %edx,%edi
  800de7:	83 f7 1f             	xor    $0x1f,%edi
  800dea:	0f 84 98 00 00 00    	je     800e88 <__udivdi3+0xf8>
  800df0:	89 f9                	mov    %edi,%ecx
  800df2:	b8 20 00 00 00       	mov    $0x20,%eax
  800df7:	29 f8                	sub    %edi,%eax
  800df9:	d3 e2                	shl    %cl,%edx
  800dfb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800dff:	89 c1                	mov    %eax,%ecx
  800e01:	89 da                	mov    %ebx,%edx
  800e03:	d3 ea                	shr    %cl,%edx
  800e05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e09:	09 d1                	or     %edx,%ecx
  800e0b:	89 f2                	mov    %esi,%edx
  800e0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e11:	89 f9                	mov    %edi,%ecx
  800e13:	d3 e3                	shl    %cl,%ebx
  800e15:	89 c1                	mov    %eax,%ecx
  800e17:	d3 ea                	shr    %cl,%edx
  800e19:	89 f9                	mov    %edi,%ecx
  800e1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e1f:	d3 e6                	shl    %cl,%esi
  800e21:	89 eb                	mov    %ebp,%ebx
  800e23:	89 c1                	mov    %eax,%ecx
  800e25:	d3 eb                	shr    %cl,%ebx
  800e27:	09 de                	or     %ebx,%esi
  800e29:	89 f0                	mov    %esi,%eax
  800e2b:	f7 74 24 08          	divl   0x8(%esp)
  800e2f:	89 d6                	mov    %edx,%esi
  800e31:	89 c3                	mov    %eax,%ebx
  800e33:	f7 64 24 0c          	mull   0xc(%esp)
  800e37:	39 d6                	cmp    %edx,%esi
  800e39:	72 0c                	jb     800e47 <__udivdi3+0xb7>
  800e3b:	89 f9                	mov    %edi,%ecx
  800e3d:	d3 e5                	shl    %cl,%ebp
  800e3f:	39 c5                	cmp    %eax,%ebp
  800e41:	73 5d                	jae    800ea0 <__udivdi3+0x110>
  800e43:	39 d6                	cmp    %edx,%esi
  800e45:	75 59                	jne    800ea0 <__udivdi3+0x110>
  800e47:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e4a:	31 ff                	xor    %edi,%edi
  800e4c:	89 fa                	mov    %edi,%edx
  800e4e:	83 c4 1c             	add    $0x1c,%esp
  800e51:	5b                   	pop    %ebx
  800e52:	5e                   	pop    %esi
  800e53:	5f                   	pop    %edi
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    
  800e56:	8d 76 00             	lea    0x0(%esi),%esi
  800e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800e60:	31 ff                	xor    %edi,%edi
  800e62:	31 c0                	xor    %eax,%eax
  800e64:	89 fa                	mov    %edi,%edx
  800e66:	83 c4 1c             	add    $0x1c,%esp
  800e69:	5b                   	pop    %ebx
  800e6a:	5e                   	pop    %esi
  800e6b:	5f                   	pop    %edi
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    
  800e6e:	66 90                	xchg   %ax,%ax
  800e70:	31 ff                	xor    %edi,%edi
  800e72:	89 e8                	mov    %ebp,%eax
  800e74:	89 f2                	mov    %esi,%edx
  800e76:	f7 f3                	div    %ebx
  800e78:	89 fa                	mov    %edi,%edx
  800e7a:	83 c4 1c             	add    $0x1c,%esp
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    
  800e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800e88:	39 f2                	cmp    %esi,%edx
  800e8a:	72 06                	jb     800e92 <__udivdi3+0x102>
  800e8c:	31 c0                	xor    %eax,%eax
  800e8e:	39 eb                	cmp    %ebp,%ebx
  800e90:	77 d2                	ja     800e64 <__udivdi3+0xd4>
  800e92:	b8 01 00 00 00       	mov    $0x1,%eax
  800e97:	eb cb                	jmp    800e64 <__udivdi3+0xd4>
  800e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ea0:	89 d8                	mov    %ebx,%eax
  800ea2:	31 ff                	xor    %edi,%edi
  800ea4:	eb be                	jmp    800e64 <__udivdi3+0xd4>
  800ea6:	66 90                	xchg   %ax,%ax
  800ea8:	66 90                	xchg   %ax,%ax
  800eaa:	66 90                	xchg   %ax,%ax
  800eac:	66 90                	xchg   %ax,%ax
  800eae:	66 90                	xchg   %ax,%ax

00800eb0 <__umoddi3>:
  800eb0:	55                   	push   %ebp
  800eb1:	57                   	push   %edi
  800eb2:	56                   	push   %esi
  800eb3:	53                   	push   %ebx
  800eb4:	83 ec 1c             	sub    $0x1c,%esp
  800eb7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800ebb:	8b 74 24 30          	mov    0x30(%esp),%esi
  800ebf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ec3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ec7:	85 ed                	test   %ebp,%ebp
  800ec9:	89 f0                	mov    %esi,%eax
  800ecb:	89 da                	mov    %ebx,%edx
  800ecd:	75 19                	jne    800ee8 <__umoddi3+0x38>
  800ecf:	39 df                	cmp    %ebx,%edi
  800ed1:	0f 86 b1 00 00 00    	jbe    800f88 <__umoddi3+0xd8>
  800ed7:	f7 f7                	div    %edi
  800ed9:	89 d0                	mov    %edx,%eax
  800edb:	31 d2                	xor    %edx,%edx
  800edd:	83 c4 1c             	add    $0x1c,%esp
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    
  800ee5:	8d 76 00             	lea    0x0(%esi),%esi
  800ee8:	39 dd                	cmp    %ebx,%ebp
  800eea:	77 f1                	ja     800edd <__umoddi3+0x2d>
  800eec:	0f bd cd             	bsr    %ebp,%ecx
  800eef:	83 f1 1f             	xor    $0x1f,%ecx
  800ef2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ef6:	0f 84 b4 00 00 00    	je     800fb0 <__umoddi3+0x100>
  800efc:	b8 20 00 00 00       	mov    $0x20,%eax
  800f01:	89 c2                	mov    %eax,%edx
  800f03:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f07:	29 c2                	sub    %eax,%edx
  800f09:	89 c1                	mov    %eax,%ecx
  800f0b:	89 f8                	mov    %edi,%eax
  800f0d:	d3 e5                	shl    %cl,%ebp
  800f0f:	89 d1                	mov    %edx,%ecx
  800f11:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f15:	d3 e8                	shr    %cl,%eax
  800f17:	09 c5                	or     %eax,%ebp
  800f19:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f1d:	89 c1                	mov    %eax,%ecx
  800f1f:	d3 e7                	shl    %cl,%edi
  800f21:	89 d1                	mov    %edx,%ecx
  800f23:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f27:	89 df                	mov    %ebx,%edi
  800f29:	d3 ef                	shr    %cl,%edi
  800f2b:	89 c1                	mov    %eax,%ecx
  800f2d:	89 f0                	mov    %esi,%eax
  800f2f:	d3 e3                	shl    %cl,%ebx
  800f31:	89 d1                	mov    %edx,%ecx
  800f33:	89 fa                	mov    %edi,%edx
  800f35:	d3 e8                	shr    %cl,%eax
  800f37:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f3c:	09 d8                	or     %ebx,%eax
  800f3e:	f7 f5                	div    %ebp
  800f40:	d3 e6                	shl    %cl,%esi
  800f42:	89 d1                	mov    %edx,%ecx
  800f44:	f7 64 24 08          	mull   0x8(%esp)
  800f48:	39 d1                	cmp    %edx,%ecx
  800f4a:	89 c3                	mov    %eax,%ebx
  800f4c:	89 d7                	mov    %edx,%edi
  800f4e:	72 06                	jb     800f56 <__umoddi3+0xa6>
  800f50:	75 0e                	jne    800f60 <__umoddi3+0xb0>
  800f52:	39 c6                	cmp    %eax,%esi
  800f54:	73 0a                	jae    800f60 <__umoddi3+0xb0>
  800f56:	2b 44 24 08          	sub    0x8(%esp),%eax
  800f5a:	19 ea                	sbb    %ebp,%edx
  800f5c:	89 d7                	mov    %edx,%edi
  800f5e:	89 c3                	mov    %eax,%ebx
  800f60:	89 ca                	mov    %ecx,%edx
  800f62:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800f67:	29 de                	sub    %ebx,%esi
  800f69:	19 fa                	sbb    %edi,%edx
  800f6b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800f6f:	89 d0                	mov    %edx,%eax
  800f71:	d3 e0                	shl    %cl,%eax
  800f73:	89 d9                	mov    %ebx,%ecx
  800f75:	d3 ee                	shr    %cl,%esi
  800f77:	d3 ea                	shr    %cl,%edx
  800f79:	09 f0                	or     %esi,%eax
  800f7b:	83 c4 1c             	add    $0x1c,%esp
  800f7e:	5b                   	pop    %ebx
  800f7f:	5e                   	pop    %esi
  800f80:	5f                   	pop    %edi
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    
  800f83:	90                   	nop
  800f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f88:	85 ff                	test   %edi,%edi
  800f8a:	89 f9                	mov    %edi,%ecx
  800f8c:	75 0b                	jne    800f99 <__umoddi3+0xe9>
  800f8e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f93:	31 d2                	xor    %edx,%edx
  800f95:	f7 f7                	div    %edi
  800f97:	89 c1                	mov    %eax,%ecx
  800f99:	89 d8                	mov    %ebx,%eax
  800f9b:	31 d2                	xor    %edx,%edx
  800f9d:	f7 f1                	div    %ecx
  800f9f:	89 f0                	mov    %esi,%eax
  800fa1:	f7 f1                	div    %ecx
  800fa3:	e9 31 ff ff ff       	jmp    800ed9 <__umoddi3+0x29>
  800fa8:	90                   	nop
  800fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fb0:	39 dd                	cmp    %ebx,%ebp
  800fb2:	72 08                	jb     800fbc <__umoddi3+0x10c>
  800fb4:	39 f7                	cmp    %esi,%edi
  800fb6:	0f 87 21 ff ff ff    	ja     800edd <__umoddi3+0x2d>
  800fbc:	89 da                	mov    %ebx,%edx
  800fbe:	89 f0                	mov    %esi,%eax
  800fc0:	29 f8                	sub    %edi,%eax
  800fc2:	19 ea                	sbb    %ebp,%edx
  800fc4:	e9 14 ff ff ff       	jmp    800edd <__umoddi3+0x2d>
