
obj/user/buggyhello2.debug：     文件格式 elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  800039:	68 00 00 10 00       	push   $0x100000
  80003e:	ff 35 00 20 80 00    	pushl  0x802000
  800044:	e8 5d 00 00 00       	call   8000a6 <sys_cputs>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  800059:	e8 c6 00 00 00       	call   800124 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006b:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800070:	85 db                	test   %ebx,%ebx
  800072:	7e 07                	jle    80007b <libmain+0x2d>
		binaryname = argv[0];
  800074:	8b 06                	mov    (%esi),%eax
  800076:	a3 04 20 80 00       	mov    %eax,0x802004

	// call user main routine
	umain(argc, argv);
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	e8 ae ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800085:	e8 0a 00 00 00       	call   800094 <exit>
}
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800090:	5b                   	pop    %ebx
  800091:	5e                   	pop    %esi
  800092:	5d                   	pop    %ebp
  800093:	c3                   	ret    

00800094 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80009a:	6a 00                	push   $0x0
  80009c:	e8 42 00 00 00       	call   8000e3 <sys_env_destroy>
}
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	c9                   	leave  
  8000a5:	c3                   	ret    

008000a6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	57                   	push   %edi
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b7:	89 c3                	mov    %eax,%ebx
  8000b9:	89 c7                	mov    %eax,%edi
  8000bb:	89 c6                	mov    %eax,%esi
  8000bd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000bf:	5b                   	pop    %ebx
  8000c0:	5e                   	pop    %esi
  8000c1:	5f                   	pop    %edi
  8000c2:	5d                   	pop    %ebp
  8000c3:	c3                   	ret    

008000c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	57                   	push   %edi
  8000c8:	56                   	push   %esi
  8000c9:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8000cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d4:	89 d1                	mov    %edx,%ecx
  8000d6:	89 d3                	mov    %edx,%ebx
  8000d8:	89 d7                	mov    %edx,%edi
  8000da:	89 d6                	mov    %edx,%esi
  8000dc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000de:	5b                   	pop    %ebx
  8000df:	5e                   	pop    %esi
  8000e0:	5f                   	pop    %edi
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    

008000e3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	57                   	push   %edi
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f9:	89 cb                	mov    %ecx,%ebx
  8000fb:	89 cf                	mov    %ecx,%edi
  8000fd:	89 ce                	mov    %ecx,%esi
  8000ff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800101:	85 c0                	test   %eax,%eax
  800103:	7f 08                	jg     80010d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800105:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800108:	5b                   	pop    %ebx
  800109:	5e                   	pop    %esi
  80010a:	5f                   	pop    %edi
  80010b:	5d                   	pop    %ebp
  80010c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	50                   	push   %eax
  800111:	6a 03                	push   $0x3
  800113:	68 f8 0f 80 00       	push   $0x800ff8
  800118:	6a 23                	push   $0x23
  80011a:	68 15 10 80 00       	push   $0x801015
  80011f:	e8 2f 02 00 00       	call   800353 <_panic>

00800124 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	57                   	push   %edi
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80012a:	ba 00 00 00 00       	mov    $0x0,%edx
  80012f:	b8 02 00 00 00       	mov    $0x2,%eax
  800134:	89 d1                	mov    %edx,%ecx
  800136:	89 d3                	mov    %edx,%ebx
  800138:	89 d7                	mov    %edx,%edi
  80013a:	89 d6                	mov    %edx,%esi
  80013c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013e:	5b                   	pop    %ebx
  80013f:	5e                   	pop    %esi
  800140:	5f                   	pop    %edi
  800141:	5d                   	pop    %ebp
  800142:	c3                   	ret    

00800143 <sys_yield>:

void
sys_yield(void)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	57                   	push   %edi
  800147:	56                   	push   %esi
  800148:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800149:	ba 00 00 00 00       	mov    $0x0,%edx
  80014e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800153:	89 d1                	mov    %edx,%ecx
  800155:	89 d3                	mov    %edx,%ebx
  800157:	89 d7                	mov    %edx,%edi
  800159:	89 d6                	mov    %edx,%esi
  80015b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80015d:	5b                   	pop    %ebx
  80015e:	5e                   	pop    %esi
  80015f:	5f                   	pop    %edi
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    

00800162 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	57                   	push   %edi
  800166:	56                   	push   %esi
  800167:	53                   	push   %ebx
  800168:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80016b:	be 00 00 00 00       	mov    $0x0,%esi
  800170:	8b 55 08             	mov    0x8(%ebp),%edx
  800173:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800176:	b8 04 00 00 00       	mov    $0x4,%eax
  80017b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017e:	89 f7                	mov    %esi,%edi
  800180:	cd 30                	int    $0x30
	if(check && ret > 0)
  800182:	85 c0                	test   %eax,%eax
  800184:	7f 08                	jg     80018e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800186:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800189:	5b                   	pop    %ebx
  80018a:	5e                   	pop    %esi
  80018b:	5f                   	pop    %edi
  80018c:	5d                   	pop    %ebp
  80018d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	50                   	push   %eax
  800192:	6a 04                	push   $0x4
  800194:	68 f8 0f 80 00       	push   $0x800ff8
  800199:	6a 23                	push   $0x23
  80019b:	68 15 10 80 00       	push   $0x801015
  8001a0:	e8 ae 01 00 00       	call   800353 <_panic>

008001a5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	57                   	push   %edi
  8001a9:	56                   	push   %esi
  8001aa:	53                   	push   %ebx
  8001ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8001ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b4:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001bc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001bf:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c4:	85 c0                	test   %eax,%eax
  8001c6:	7f 08                	jg     8001d0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cb:	5b                   	pop    %ebx
  8001cc:	5e                   	pop    %esi
  8001cd:	5f                   	pop    %edi
  8001ce:	5d                   	pop    %ebp
  8001cf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	50                   	push   %eax
  8001d4:	6a 05                	push   $0x5
  8001d6:	68 f8 0f 80 00       	push   $0x800ff8
  8001db:	6a 23                	push   $0x23
  8001dd:	68 15 10 80 00       	push   $0x801015
  8001e2:	e8 6c 01 00 00       	call   800353 <_panic>

008001e7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e7:	55                   	push   %ebp
  8001e8:	89 e5                	mov    %esp,%ebp
  8001ea:	57                   	push   %edi
  8001eb:	56                   	push   %esi
  8001ec:	53                   	push   %ebx
  8001ed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8001f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fb:	b8 06 00 00 00       	mov    $0x6,%eax
  800200:	89 df                	mov    %ebx,%edi
  800202:	89 de                	mov    %ebx,%esi
  800204:	cd 30                	int    $0x30
	if(check && ret > 0)
  800206:	85 c0                	test   %eax,%eax
  800208:	7f 08                	jg     800212 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80020a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020d:	5b                   	pop    %ebx
  80020e:	5e                   	pop    %esi
  80020f:	5f                   	pop    %edi
  800210:	5d                   	pop    %ebp
  800211:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	50                   	push   %eax
  800216:	6a 06                	push   $0x6
  800218:	68 f8 0f 80 00       	push   $0x800ff8
  80021d:	6a 23                	push   $0x23
  80021f:	68 15 10 80 00       	push   $0x801015
  800224:	e8 2a 01 00 00       	call   800353 <_panic>

00800229 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800229:	55                   	push   %ebp
  80022a:	89 e5                	mov    %esp,%ebp
  80022c:	57                   	push   %edi
  80022d:	56                   	push   %esi
  80022e:	53                   	push   %ebx
  80022f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800232:	bb 00 00 00 00       	mov    $0x0,%ebx
  800237:	8b 55 08             	mov    0x8(%ebp),%edx
  80023a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80023d:	b8 08 00 00 00       	mov    $0x8,%eax
  800242:	89 df                	mov    %ebx,%edi
  800244:	89 de                	mov    %ebx,%esi
  800246:	cd 30                	int    $0x30
	if(check && ret > 0)
  800248:	85 c0                	test   %eax,%eax
  80024a:	7f 08                	jg     800254 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80024c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024f:	5b                   	pop    %ebx
  800250:	5e                   	pop    %esi
  800251:	5f                   	pop    %edi
  800252:	5d                   	pop    %ebp
  800253:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	50                   	push   %eax
  800258:	6a 08                	push   $0x8
  80025a:	68 f8 0f 80 00       	push   $0x800ff8
  80025f:	6a 23                	push   $0x23
  800261:	68 15 10 80 00       	push   $0x801015
  800266:	e8 e8 00 00 00       	call   800353 <_panic>

0080026b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	57                   	push   %edi
  80026f:	56                   	push   %esi
  800270:	53                   	push   %ebx
  800271:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800274:	bb 00 00 00 00       	mov    $0x0,%ebx
  800279:	8b 55 08             	mov    0x8(%ebp),%edx
  80027c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027f:	b8 09 00 00 00       	mov    $0x9,%eax
  800284:	89 df                	mov    %ebx,%edi
  800286:	89 de                	mov    %ebx,%esi
  800288:	cd 30                	int    $0x30
	if(check && ret > 0)
  80028a:	85 c0                	test   %eax,%eax
  80028c:	7f 08                	jg     800296 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80028e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800291:	5b                   	pop    %ebx
  800292:	5e                   	pop    %esi
  800293:	5f                   	pop    %edi
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	50                   	push   %eax
  80029a:	6a 09                	push   $0x9
  80029c:	68 f8 0f 80 00       	push   $0x800ff8
  8002a1:	6a 23                	push   $0x23
  8002a3:	68 15 10 80 00       	push   $0x801015
  8002a8:	e8 a6 00 00 00       	call   800353 <_panic>

008002ad <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	57                   	push   %edi
  8002b1:	56                   	push   %esi
  8002b2:	53                   	push   %ebx
  8002b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c6:	89 df                	mov    %ebx,%edi
  8002c8:	89 de                	mov    %ebx,%esi
  8002ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	7f 08                	jg     8002d8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d3:	5b                   	pop    %ebx
  8002d4:	5e                   	pop    %esi
  8002d5:	5f                   	pop    %edi
  8002d6:	5d                   	pop    %ebp
  8002d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	50                   	push   %eax
  8002dc:	6a 0a                	push   $0xa
  8002de:	68 f8 0f 80 00       	push   $0x800ff8
  8002e3:	6a 23                	push   $0x23
  8002e5:	68 15 10 80 00       	push   $0x801015
  8002ea:	e8 64 00 00 00       	call   800353 <_panic>

008002ef <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	57                   	push   %edi
  8002f3:	56                   	push   %esi
  8002f4:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fb:	b8 0c 00 00 00       	mov    $0xc,%eax
  800300:	be 00 00 00 00       	mov    $0x0,%esi
  800305:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800308:	8b 7d 14             	mov    0x14(%ebp),%edi
  80030b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80030d:	5b                   	pop    %ebx
  80030e:	5e                   	pop    %esi
  80030f:	5f                   	pop    %edi
  800310:	5d                   	pop    %ebp
  800311:	c3                   	ret    

00800312 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	57                   	push   %edi
  800316:	56                   	push   %esi
  800317:	53                   	push   %ebx
  800318:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80031b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800320:	8b 55 08             	mov    0x8(%ebp),%edx
  800323:	b8 0d 00 00 00       	mov    $0xd,%eax
  800328:	89 cb                	mov    %ecx,%ebx
  80032a:	89 cf                	mov    %ecx,%edi
  80032c:	89 ce                	mov    %ecx,%esi
  80032e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800330:	85 c0                	test   %eax,%eax
  800332:	7f 08                	jg     80033c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800334:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800337:	5b                   	pop    %ebx
  800338:	5e                   	pop    %esi
  800339:	5f                   	pop    %edi
  80033a:	5d                   	pop    %ebp
  80033b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	6a 0d                	push   $0xd
  800342:	68 f8 0f 80 00       	push   $0x800ff8
  800347:	6a 23                	push   $0x23
  800349:	68 15 10 80 00       	push   $0x801015
  80034e:	e8 00 00 00 00       	call   800353 <_panic>

00800353 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  800356:	56                   	push   %esi
  800357:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800358:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80035b:	8b 35 04 20 80 00    	mov    0x802004,%esi
  800361:	e8 be fd ff ff       	call   800124 <sys_getenvid>
  800366:	83 ec 0c             	sub    $0xc,%esp
  800369:	ff 75 0c             	pushl  0xc(%ebp)
  80036c:	ff 75 08             	pushl  0x8(%ebp)
  80036f:	56                   	push   %esi
  800370:	50                   	push   %eax
  800371:	68 24 10 80 00       	push   $0x801024
  800376:	e8 b3 00 00 00       	call   80042e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80037b:	83 c4 18             	add    $0x18,%esp
  80037e:	53                   	push   %ebx
  80037f:	ff 75 10             	pushl  0x10(%ebp)
  800382:	e8 56 00 00 00       	call   8003dd <vcprintf>
	cprintf("\n");
  800387:	c7 04 24 ec 0f 80 00 	movl   $0x800fec,(%esp)
  80038e:	e8 9b 00 00 00       	call   80042e <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800396:	cc                   	int3   
  800397:	eb fd                	jmp    800396 <_panic+0x43>

00800399 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	53                   	push   %ebx
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003a3:	8b 13                	mov    (%ebx),%edx
  8003a5:	8d 42 01             	lea    0x1(%edx),%eax
  8003a8:	89 03                	mov    %eax,(%ebx)
  8003aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003ad:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003b1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b6:	74 09                	je     8003c1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003b8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003bf:	c9                   	leave  
  8003c0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	68 ff 00 00 00       	push   $0xff
  8003c9:	8d 43 08             	lea    0x8(%ebx),%eax
  8003cc:	50                   	push   %eax
  8003cd:	e8 d4 fc ff ff       	call   8000a6 <sys_cputs>
		b->idx = 0;
  8003d2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003d8:	83 c4 10             	add    $0x10,%esp
  8003db:	eb db                	jmp    8003b8 <putch+0x1f>

008003dd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003dd:	55                   	push   %ebp
  8003de:	89 e5                	mov    %esp,%ebp
  8003e0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ed:	00 00 00 
	b.cnt = 0;
  8003f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003fa:	ff 75 0c             	pushl  0xc(%ebp)
  8003fd:	ff 75 08             	pushl  0x8(%ebp)
  800400:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800406:	50                   	push   %eax
  800407:	68 99 03 80 00       	push   $0x800399
  80040c:	e8 1a 01 00 00       	call   80052b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800411:	83 c4 08             	add    $0x8,%esp
  800414:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80041a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800420:	50                   	push   %eax
  800421:	e8 80 fc ff ff       	call   8000a6 <sys_cputs>

	return b.cnt;
}
  800426:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800434:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800437:	50                   	push   %eax
  800438:	ff 75 08             	pushl  0x8(%ebp)
  80043b:	e8 9d ff ff ff       	call   8003dd <vcprintf>
	va_end(ap);

	return cnt;
}
  800440:	c9                   	leave  
  800441:	c3                   	ret    

00800442 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800442:	55                   	push   %ebp
  800443:	89 e5                	mov    %esp,%ebp
  800445:	57                   	push   %edi
  800446:	56                   	push   %esi
  800447:	53                   	push   %ebx
  800448:	83 ec 1c             	sub    $0x1c,%esp
  80044b:	89 c7                	mov    %eax,%edi
  80044d:	89 d6                	mov    %edx,%esi
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	8b 55 0c             	mov    0xc(%ebp),%edx
  800455:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800458:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80045b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80045e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800463:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800466:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800469:	39 d3                	cmp    %edx,%ebx
  80046b:	72 05                	jb     800472 <printnum+0x30>
  80046d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800470:	77 7a                	ja     8004ec <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	ff 75 18             	pushl  0x18(%ebp)
  800478:	8b 45 14             	mov    0x14(%ebp),%eax
  80047b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80047e:	53                   	push   %ebx
  80047f:	ff 75 10             	pushl  0x10(%ebp)
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	ff 75 e4             	pushl  -0x1c(%ebp)
  800488:	ff 75 e0             	pushl  -0x20(%ebp)
  80048b:	ff 75 dc             	pushl  -0x24(%ebp)
  80048e:	ff 75 d8             	pushl  -0x28(%ebp)
  800491:	e8 fa 08 00 00       	call   800d90 <__udivdi3>
  800496:	83 c4 18             	add    $0x18,%esp
  800499:	52                   	push   %edx
  80049a:	50                   	push   %eax
  80049b:	89 f2                	mov    %esi,%edx
  80049d:	89 f8                	mov    %edi,%eax
  80049f:	e8 9e ff ff ff       	call   800442 <printnum>
  8004a4:	83 c4 20             	add    $0x20,%esp
  8004a7:	eb 13                	jmp    8004bc <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	56                   	push   %esi
  8004ad:	ff 75 18             	pushl  0x18(%ebp)
  8004b0:	ff d7                	call   *%edi
  8004b2:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004b5:	83 eb 01             	sub    $0x1,%ebx
  8004b8:	85 db                	test   %ebx,%ebx
  8004ba:	7f ed                	jg     8004a9 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004bc:	83 ec 08             	sub    $0x8,%esp
  8004bf:	56                   	push   %esi
  8004c0:	83 ec 04             	sub    $0x4,%esp
  8004c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c9:	ff 75 dc             	pushl  -0x24(%ebp)
  8004cc:	ff 75 d8             	pushl  -0x28(%ebp)
  8004cf:	e8 dc 09 00 00       	call   800eb0 <__umoddi3>
  8004d4:	83 c4 14             	add    $0x14,%esp
  8004d7:	0f be 80 47 10 80 00 	movsbl 0x801047(%eax),%eax
  8004de:	50                   	push   %eax
  8004df:	ff d7                	call   *%edi
}
  8004e1:	83 c4 10             	add    $0x10,%esp
  8004e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e7:	5b                   	pop    %ebx
  8004e8:	5e                   	pop    %esi
  8004e9:	5f                   	pop    %edi
  8004ea:	5d                   	pop    %ebp
  8004eb:	c3                   	ret    
  8004ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004ef:	eb c4                	jmp    8004b5 <printnum+0x73>

008004f1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004fb:	8b 10                	mov    (%eax),%edx
  8004fd:	3b 50 04             	cmp    0x4(%eax),%edx
  800500:	73 0a                	jae    80050c <sprintputch+0x1b>
		*b->buf++ = ch;
  800502:	8d 4a 01             	lea    0x1(%edx),%ecx
  800505:	89 08                	mov    %ecx,(%eax)
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	88 02                	mov    %al,(%edx)
}
  80050c:	5d                   	pop    %ebp
  80050d:	c3                   	ret    

0080050e <printfmt>:
{
  80050e:	55                   	push   %ebp
  80050f:	89 e5                	mov    %esp,%ebp
  800511:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800514:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800517:	50                   	push   %eax
  800518:	ff 75 10             	pushl  0x10(%ebp)
  80051b:	ff 75 0c             	pushl  0xc(%ebp)
  80051e:	ff 75 08             	pushl  0x8(%ebp)
  800521:	e8 05 00 00 00       	call   80052b <vprintfmt>
}
  800526:	83 c4 10             	add    $0x10,%esp
  800529:	c9                   	leave  
  80052a:	c3                   	ret    

0080052b <vprintfmt>:
{
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	57                   	push   %edi
  80052f:	56                   	push   %esi
  800530:	53                   	push   %ebx
  800531:	83 ec 2c             	sub    $0x2c,%esp
  800534:	8b 75 08             	mov    0x8(%ebp),%esi
  800537:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80053a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80053d:	e9 c1 03 00 00       	jmp    800903 <vprintfmt+0x3d8>
		padc = ' ';
  800542:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800546:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80054d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800554:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80055b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800560:	8d 47 01             	lea    0x1(%edi),%eax
  800563:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800566:	0f b6 17             	movzbl (%edi),%edx
  800569:	8d 42 dd             	lea    -0x23(%edx),%eax
  80056c:	3c 55                	cmp    $0x55,%al
  80056e:	0f 87 12 04 00 00    	ja     800986 <vprintfmt+0x45b>
  800574:	0f b6 c0             	movzbl %al,%eax
  800577:	ff 24 85 80 11 80 00 	jmp    *0x801180(,%eax,4)
  80057e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800581:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800585:	eb d9                	jmp    800560 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800587:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80058a:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80058e:	eb d0                	jmp    800560 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800590:	0f b6 d2             	movzbl %dl,%edx
  800593:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800596:	b8 00 00 00 00       	mov    $0x0,%eax
  80059b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80059e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005a1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005a5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005a8:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005ab:	83 f9 09             	cmp    $0x9,%ecx
  8005ae:	77 55                	ja     800605 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8005b0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005b3:	eb e9                	jmp    80059e <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8d 40 04             	lea    0x4(%eax),%eax
  8005c3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005cd:	79 91                	jns    800560 <vprintfmt+0x35>
				width = precision, precision = -1;
  8005cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005dc:	eb 82                	jmp    800560 <vprintfmt+0x35>
  8005de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e1:	85 c0                	test   %eax,%eax
  8005e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e8:	0f 49 d0             	cmovns %eax,%edx
  8005eb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005f1:	e9 6a ff ff ff       	jmp    800560 <vprintfmt+0x35>
  8005f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005f9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800600:	e9 5b ff ff ff       	jmp    800560 <vprintfmt+0x35>
  800605:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800608:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80060b:	eb bc                	jmp    8005c9 <vprintfmt+0x9e>
			lflag++;
  80060d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800610:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800613:	e9 48 ff ff ff       	jmp    800560 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8d 78 04             	lea    0x4(%eax),%edi
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	53                   	push   %ebx
  800622:	ff 30                	pushl  (%eax)
  800624:	ff d6                	call   *%esi
			break;
  800626:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800629:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80062c:	e9 cf 02 00 00       	jmp    800900 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8d 78 04             	lea    0x4(%eax),%edi
  800637:	8b 00                	mov    (%eax),%eax
  800639:	99                   	cltd   
  80063a:	31 d0                	xor    %edx,%eax
  80063c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80063e:	83 f8 0f             	cmp    $0xf,%eax
  800641:	7f 23                	jg     800666 <vprintfmt+0x13b>
  800643:	8b 14 85 e0 12 80 00 	mov    0x8012e0(,%eax,4),%edx
  80064a:	85 d2                	test   %edx,%edx
  80064c:	74 18                	je     800666 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80064e:	52                   	push   %edx
  80064f:	68 68 10 80 00       	push   $0x801068
  800654:	53                   	push   %ebx
  800655:	56                   	push   %esi
  800656:	e8 b3 fe ff ff       	call   80050e <printfmt>
  80065b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80065e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800661:	e9 9a 02 00 00       	jmp    800900 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800666:	50                   	push   %eax
  800667:	68 5f 10 80 00       	push   $0x80105f
  80066c:	53                   	push   %ebx
  80066d:	56                   	push   %esi
  80066e:	e8 9b fe ff ff       	call   80050e <printfmt>
  800673:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800676:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800679:	e9 82 02 00 00       	jmp    800900 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	83 c0 04             	add    $0x4,%eax
  800684:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80068c:	85 ff                	test   %edi,%edi
  80068e:	b8 58 10 80 00       	mov    $0x801058,%eax
  800693:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800696:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80069a:	0f 8e bd 00 00 00    	jle    80075d <vprintfmt+0x232>
  8006a0:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8006a4:	75 0e                	jne    8006b4 <vprintfmt+0x189>
  8006a6:	89 75 08             	mov    %esi,0x8(%ebp)
  8006a9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006ac:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006af:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006b2:	eb 6d                	jmp    800721 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	ff 75 d0             	pushl  -0x30(%ebp)
  8006ba:	57                   	push   %edi
  8006bb:	e8 6e 03 00 00       	call   800a2e <strnlen>
  8006c0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006c3:	29 c1                	sub    %eax,%ecx
  8006c5:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8006c8:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006cb:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006d2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006d5:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d7:	eb 0f                	jmp    8006e8 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e2:	83 ef 01             	sub    $0x1,%edi
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	85 ff                	test   %edi,%edi
  8006ea:	7f ed                	jg     8006d9 <vprintfmt+0x1ae>
  8006ec:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006ef:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006f2:	85 c9                	test   %ecx,%ecx
  8006f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f9:	0f 49 c1             	cmovns %ecx,%eax
  8006fc:	29 c1                	sub    %eax,%ecx
  8006fe:	89 75 08             	mov    %esi,0x8(%ebp)
  800701:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800704:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800707:	89 cb                	mov    %ecx,%ebx
  800709:	eb 16                	jmp    800721 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80070b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80070f:	75 31                	jne    800742 <vprintfmt+0x217>
					putch(ch, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	50                   	push   %eax
  800718:	ff 55 08             	call   *0x8(%ebp)
  80071b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80071e:	83 eb 01             	sub    $0x1,%ebx
  800721:	83 c7 01             	add    $0x1,%edi
  800724:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800728:	0f be c2             	movsbl %dl,%eax
  80072b:	85 c0                	test   %eax,%eax
  80072d:	74 59                	je     800788 <vprintfmt+0x25d>
  80072f:	85 f6                	test   %esi,%esi
  800731:	78 d8                	js     80070b <vprintfmt+0x1e0>
  800733:	83 ee 01             	sub    $0x1,%esi
  800736:	79 d3                	jns    80070b <vprintfmt+0x1e0>
  800738:	89 df                	mov    %ebx,%edi
  80073a:	8b 75 08             	mov    0x8(%ebp),%esi
  80073d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800740:	eb 37                	jmp    800779 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800742:	0f be d2             	movsbl %dl,%edx
  800745:	83 ea 20             	sub    $0x20,%edx
  800748:	83 fa 5e             	cmp    $0x5e,%edx
  80074b:	76 c4                	jbe    800711 <vprintfmt+0x1e6>
					putch('?', putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	ff 75 0c             	pushl  0xc(%ebp)
  800753:	6a 3f                	push   $0x3f
  800755:	ff 55 08             	call   *0x8(%ebp)
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	eb c1                	jmp    80071e <vprintfmt+0x1f3>
  80075d:	89 75 08             	mov    %esi,0x8(%ebp)
  800760:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800763:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800766:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800769:	eb b6                	jmp    800721 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	53                   	push   %ebx
  80076f:	6a 20                	push   $0x20
  800771:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800773:	83 ef 01             	sub    $0x1,%edi
  800776:	83 c4 10             	add    $0x10,%esp
  800779:	85 ff                	test   %edi,%edi
  80077b:	7f ee                	jg     80076b <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80077d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800780:	89 45 14             	mov    %eax,0x14(%ebp)
  800783:	e9 78 01 00 00       	jmp    800900 <vprintfmt+0x3d5>
  800788:	89 df                	mov    %ebx,%edi
  80078a:	8b 75 08             	mov    0x8(%ebp),%esi
  80078d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800790:	eb e7                	jmp    800779 <vprintfmt+0x24e>
	if (lflag >= 2)
  800792:	83 f9 01             	cmp    $0x1,%ecx
  800795:	7e 3f                	jle    8007d6 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8b 50 04             	mov    0x4(%eax),%edx
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a8:	8d 40 08             	lea    0x8(%eax),%eax
  8007ab:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007b2:	79 5c                	jns    800810 <vprintfmt+0x2e5>
				putch('-', putdat);
  8007b4:	83 ec 08             	sub    $0x8,%esp
  8007b7:	53                   	push   %ebx
  8007b8:	6a 2d                	push   $0x2d
  8007ba:	ff d6                	call   *%esi
				num = -(long long) num;
  8007bc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007bf:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007c2:	f7 da                	neg    %edx
  8007c4:	83 d1 00             	adc    $0x0,%ecx
  8007c7:	f7 d9                	neg    %ecx
  8007c9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d1:	e9 10 01 00 00       	jmp    8008e6 <vprintfmt+0x3bb>
	else if (lflag)
  8007d6:	85 c9                	test   %ecx,%ecx
  8007d8:	75 1b                	jne    8007f5 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e2:	89 c1                	mov    %eax,%ecx
  8007e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8007e7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ed:	8d 40 04             	lea    0x4(%eax),%eax
  8007f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f3:	eb b9                	jmp    8007ae <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	8b 00                	mov    (%eax),%eax
  8007fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fd:	89 c1                	mov    %eax,%ecx
  8007ff:	c1 f9 1f             	sar    $0x1f,%ecx
  800802:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8d 40 04             	lea    0x4(%eax),%eax
  80080b:	89 45 14             	mov    %eax,0x14(%ebp)
  80080e:	eb 9e                	jmp    8007ae <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800810:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800813:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800816:	b8 0a 00 00 00       	mov    $0xa,%eax
  80081b:	e9 c6 00 00 00       	jmp    8008e6 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800820:	83 f9 01             	cmp    $0x1,%ecx
  800823:	7e 18                	jle    80083d <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	8b 10                	mov    (%eax),%edx
  80082a:	8b 48 04             	mov    0x4(%eax),%ecx
  80082d:	8d 40 08             	lea    0x8(%eax),%eax
  800830:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800833:	b8 0a 00 00 00       	mov    $0xa,%eax
  800838:	e9 a9 00 00 00       	jmp    8008e6 <vprintfmt+0x3bb>
	else if (lflag)
  80083d:	85 c9                	test   %ecx,%ecx
  80083f:	75 1a                	jne    80085b <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	8b 10                	mov    (%eax),%edx
  800846:	b9 00 00 00 00       	mov    $0x0,%ecx
  80084b:	8d 40 04             	lea    0x4(%eax),%eax
  80084e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800851:	b8 0a 00 00 00       	mov    $0xa,%eax
  800856:	e9 8b 00 00 00       	jmp    8008e6 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	8b 10                	mov    (%eax),%edx
  800860:	b9 00 00 00 00       	mov    $0x0,%ecx
  800865:	8d 40 04             	lea    0x4(%eax),%eax
  800868:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80086b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800870:	eb 74                	jmp    8008e6 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800872:	83 f9 01             	cmp    $0x1,%ecx
  800875:	7e 15                	jle    80088c <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	8b 10                	mov    (%eax),%edx
  80087c:	8b 48 04             	mov    0x4(%eax),%ecx
  80087f:	8d 40 08             	lea    0x8(%eax),%eax
  800882:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800885:	b8 08 00 00 00       	mov    $0x8,%eax
  80088a:	eb 5a                	jmp    8008e6 <vprintfmt+0x3bb>
	else if (lflag)
  80088c:	85 c9                	test   %ecx,%ecx
  80088e:	75 17                	jne    8008a7 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800890:	8b 45 14             	mov    0x14(%ebp),%eax
  800893:	8b 10                	mov    (%eax),%edx
  800895:	b9 00 00 00 00       	mov    $0x0,%ecx
  80089a:	8d 40 04             	lea    0x4(%eax),%eax
  80089d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008a0:	b8 08 00 00 00       	mov    $0x8,%eax
  8008a5:	eb 3f                	jmp    8008e6 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8008a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008aa:	8b 10                	mov    (%eax),%edx
  8008ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008b1:	8d 40 04             	lea    0x4(%eax),%eax
  8008b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008b7:	b8 08 00 00 00       	mov    $0x8,%eax
  8008bc:	eb 28                	jmp    8008e6 <vprintfmt+0x3bb>
			putch('0', putdat);
  8008be:	83 ec 08             	sub    $0x8,%esp
  8008c1:	53                   	push   %ebx
  8008c2:	6a 30                	push   $0x30
  8008c4:	ff d6                	call   *%esi
			putch('x', putdat);
  8008c6:	83 c4 08             	add    $0x8,%esp
  8008c9:	53                   	push   %ebx
  8008ca:	6a 78                	push   $0x78
  8008cc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	8b 10                	mov    (%eax),%edx
  8008d3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008d8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008db:	8d 40 04             	lea    0x4(%eax),%eax
  8008de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008e6:	83 ec 0c             	sub    $0xc,%esp
  8008e9:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008ed:	57                   	push   %edi
  8008ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8008f1:	50                   	push   %eax
  8008f2:	51                   	push   %ecx
  8008f3:	52                   	push   %edx
  8008f4:	89 da                	mov    %ebx,%edx
  8008f6:	89 f0                	mov    %esi,%eax
  8008f8:	e8 45 fb ff ff       	call   800442 <printnum>
			break;
  8008fd:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800900:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  800903:	83 c7 01             	add    $0x1,%edi
  800906:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80090a:	83 f8 25             	cmp    $0x25,%eax
  80090d:	0f 84 2f fc ff ff    	je     800542 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  800913:	85 c0                	test   %eax,%eax
  800915:	0f 84 8b 00 00 00    	je     8009a6 <vprintfmt+0x47b>
			putch(ch, putdat);
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	53                   	push   %ebx
  80091f:	50                   	push   %eax
  800920:	ff d6                	call   *%esi
  800922:	83 c4 10             	add    $0x10,%esp
  800925:	eb dc                	jmp    800903 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800927:	83 f9 01             	cmp    $0x1,%ecx
  80092a:	7e 15                	jle    800941 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	8b 10                	mov    (%eax),%edx
  800931:	8b 48 04             	mov    0x4(%eax),%ecx
  800934:	8d 40 08             	lea    0x8(%eax),%eax
  800937:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093a:	b8 10 00 00 00       	mov    $0x10,%eax
  80093f:	eb a5                	jmp    8008e6 <vprintfmt+0x3bb>
	else if (lflag)
  800941:	85 c9                	test   %ecx,%ecx
  800943:	75 17                	jne    80095c <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800945:	8b 45 14             	mov    0x14(%ebp),%eax
  800948:	8b 10                	mov    (%eax),%edx
  80094a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80094f:	8d 40 04             	lea    0x4(%eax),%eax
  800952:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800955:	b8 10 00 00 00       	mov    $0x10,%eax
  80095a:	eb 8a                	jmp    8008e6 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80095c:	8b 45 14             	mov    0x14(%ebp),%eax
  80095f:	8b 10                	mov    (%eax),%edx
  800961:	b9 00 00 00 00       	mov    $0x0,%ecx
  800966:	8d 40 04             	lea    0x4(%eax),%eax
  800969:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80096c:	b8 10 00 00 00       	mov    $0x10,%eax
  800971:	e9 70 ff ff ff       	jmp    8008e6 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	53                   	push   %ebx
  80097a:	6a 25                	push   $0x25
  80097c:	ff d6                	call   *%esi
			break;
  80097e:	83 c4 10             	add    $0x10,%esp
  800981:	e9 7a ff ff ff       	jmp    800900 <vprintfmt+0x3d5>
			putch('%', putdat);
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	53                   	push   %ebx
  80098a:	6a 25                	push   $0x25
  80098c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80098e:	83 c4 10             	add    $0x10,%esp
  800991:	89 f8                	mov    %edi,%eax
  800993:	eb 03                	jmp    800998 <vprintfmt+0x46d>
  800995:	83 e8 01             	sub    $0x1,%eax
  800998:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80099c:	75 f7                	jne    800995 <vprintfmt+0x46a>
  80099e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009a1:	e9 5a ff ff ff       	jmp    800900 <vprintfmt+0x3d5>
}
  8009a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a9:	5b                   	pop    %ebx
  8009aa:	5e                   	pop    %esi
  8009ab:	5f                   	pop    %edi
  8009ac:	5d                   	pop    %ebp
  8009ad:	c3                   	ret    

008009ae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	83 ec 18             	sub    $0x18,%esp
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009bd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009c1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	74 26                	je     8009f5 <vsnprintf+0x47>
  8009cf:	85 d2                	test   %edx,%edx
  8009d1:	7e 22                	jle    8009f5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009d3:	ff 75 14             	pushl  0x14(%ebp)
  8009d6:	ff 75 10             	pushl  0x10(%ebp)
  8009d9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	68 f1 04 80 00       	push   $0x8004f1
  8009e2:	e8 44 fb ff ff       	call   80052b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f0:	83 c4 10             	add    $0x10,%esp
}
  8009f3:	c9                   	leave  
  8009f4:	c3                   	ret    
		return -E_INVAL;
  8009f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009fa:	eb f7                	jmp    8009f3 <vsnprintf+0x45>

008009fc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a02:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a05:	50                   	push   %eax
  800a06:	ff 75 10             	pushl  0x10(%ebp)
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	ff 75 08             	pushl  0x8(%ebp)
  800a0f:	e8 9a ff ff ff       	call   8009ae <vsnprintf>
	va_end(ap);

	return rc;
}
  800a14:	c9                   	leave  
  800a15:	c3                   	ret    

00800a16 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a21:	eb 03                	jmp    800a26 <strlen+0x10>
		n++;
  800a23:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a26:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a2a:	75 f7                	jne    800a23 <strlen+0xd>
	return n;
}
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    

00800a2e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a34:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	eb 03                	jmp    800a41 <strnlen+0x13>
		n++;
  800a3e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a41:	39 d0                	cmp    %edx,%eax
  800a43:	74 06                	je     800a4b <strnlen+0x1d>
  800a45:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a49:	75 f3                	jne    800a3e <strnlen+0x10>
	return n;
}
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	53                   	push   %ebx
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a57:	89 c2                	mov    %eax,%edx
  800a59:	83 c1 01             	add    $0x1,%ecx
  800a5c:	83 c2 01             	add    $0x1,%edx
  800a5f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a63:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a66:	84 db                	test   %bl,%bl
  800a68:	75 ef                	jne    800a59 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a6a:	5b                   	pop    %ebx
  800a6b:	5d                   	pop    %ebp
  800a6c:	c3                   	ret    

00800a6d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	53                   	push   %ebx
  800a71:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a74:	53                   	push   %ebx
  800a75:	e8 9c ff ff ff       	call   800a16 <strlen>
  800a7a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	01 d8                	add    %ebx,%eax
  800a82:	50                   	push   %eax
  800a83:	e8 c5 ff ff ff       	call   800a4d <strcpy>
	return dst;
}
  800a88:	89 d8                	mov    %ebx,%eax
  800a8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    

00800a8f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	56                   	push   %esi
  800a93:	53                   	push   %ebx
  800a94:	8b 75 08             	mov    0x8(%ebp),%esi
  800a97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a9a:	89 f3                	mov    %esi,%ebx
  800a9c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a9f:	89 f2                	mov    %esi,%edx
  800aa1:	eb 0f                	jmp    800ab2 <strncpy+0x23>
		*dst++ = *src;
  800aa3:	83 c2 01             	add    $0x1,%edx
  800aa6:	0f b6 01             	movzbl (%ecx),%eax
  800aa9:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aac:	80 39 01             	cmpb   $0x1,(%ecx)
  800aaf:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800ab2:	39 da                	cmp    %ebx,%edx
  800ab4:	75 ed                	jne    800aa3 <strncpy+0x14>
	}
	return ret;
}
  800ab6:	89 f0                	mov    %esi,%eax
  800ab8:	5b                   	pop    %ebx
  800ab9:	5e                   	pop    %esi
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    

00800abc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	56                   	push   %esi
  800ac0:	53                   	push   %ebx
  800ac1:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800aca:	89 f0                	mov    %esi,%eax
  800acc:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ad0:	85 c9                	test   %ecx,%ecx
  800ad2:	75 0b                	jne    800adf <strlcpy+0x23>
  800ad4:	eb 17                	jmp    800aed <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ad6:	83 c2 01             	add    $0x1,%edx
  800ad9:	83 c0 01             	add    $0x1,%eax
  800adc:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800adf:	39 d8                	cmp    %ebx,%eax
  800ae1:	74 07                	je     800aea <strlcpy+0x2e>
  800ae3:	0f b6 0a             	movzbl (%edx),%ecx
  800ae6:	84 c9                	test   %cl,%cl
  800ae8:	75 ec                	jne    800ad6 <strlcpy+0x1a>
		*dst = '\0';
  800aea:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aed:	29 f0                	sub    %esi,%eax
}
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    

00800af3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800afc:	eb 06                	jmp    800b04 <strcmp+0x11>
		p++, q++;
  800afe:	83 c1 01             	add    $0x1,%ecx
  800b01:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b04:	0f b6 01             	movzbl (%ecx),%eax
  800b07:	84 c0                	test   %al,%al
  800b09:	74 04                	je     800b0f <strcmp+0x1c>
  800b0b:	3a 02                	cmp    (%edx),%al
  800b0d:	74 ef                	je     800afe <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0f:	0f b6 c0             	movzbl %al,%eax
  800b12:	0f b6 12             	movzbl (%edx),%edx
  800b15:	29 d0                	sub    %edx,%eax
}
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    

00800b19 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	53                   	push   %ebx
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b23:	89 c3                	mov    %eax,%ebx
  800b25:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b28:	eb 06                	jmp    800b30 <strncmp+0x17>
		n--, p++, q++;
  800b2a:	83 c0 01             	add    $0x1,%eax
  800b2d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b30:	39 d8                	cmp    %ebx,%eax
  800b32:	74 16                	je     800b4a <strncmp+0x31>
  800b34:	0f b6 08             	movzbl (%eax),%ecx
  800b37:	84 c9                	test   %cl,%cl
  800b39:	74 04                	je     800b3f <strncmp+0x26>
  800b3b:	3a 0a                	cmp    (%edx),%cl
  800b3d:	74 eb                	je     800b2a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b3f:	0f b6 00             	movzbl (%eax),%eax
  800b42:	0f b6 12             	movzbl (%edx),%edx
  800b45:	29 d0                	sub    %edx,%eax
}
  800b47:	5b                   	pop    %ebx
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    
		return 0;
  800b4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4f:	eb f6                	jmp    800b47 <strncmp+0x2e>

00800b51 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b5b:	0f b6 10             	movzbl (%eax),%edx
  800b5e:	84 d2                	test   %dl,%dl
  800b60:	74 09                	je     800b6b <strchr+0x1a>
		if (*s == c)
  800b62:	38 ca                	cmp    %cl,%dl
  800b64:	74 0a                	je     800b70 <strchr+0x1f>
	for (; *s; s++)
  800b66:	83 c0 01             	add    $0x1,%eax
  800b69:	eb f0                	jmp    800b5b <strchr+0xa>
			return (char *) s;
	return 0;
  800b6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b7c:	eb 03                	jmp    800b81 <strfind+0xf>
  800b7e:	83 c0 01             	add    $0x1,%eax
  800b81:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b84:	38 ca                	cmp    %cl,%dl
  800b86:	74 04                	je     800b8c <strfind+0x1a>
  800b88:	84 d2                	test   %dl,%dl
  800b8a:	75 f2                	jne    800b7e <strfind+0xc>
			break;
	return (char *) s;
}
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	57                   	push   %edi
  800b92:	56                   	push   %esi
  800b93:	53                   	push   %ebx
  800b94:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b97:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b9a:	85 c9                	test   %ecx,%ecx
  800b9c:	74 13                	je     800bb1 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b9e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ba4:	75 05                	jne    800bab <memset+0x1d>
  800ba6:	f6 c1 03             	test   $0x3,%cl
  800ba9:	74 0d                	je     800bb8 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bae:	fc                   	cld    
  800baf:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bb1:	89 f8                	mov    %edi,%eax
  800bb3:	5b                   	pop    %ebx
  800bb4:	5e                   	pop    %esi
  800bb5:	5f                   	pop    %edi
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    
		c &= 0xFF;
  800bb8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bbc:	89 d3                	mov    %edx,%ebx
  800bbe:	c1 e3 08             	shl    $0x8,%ebx
  800bc1:	89 d0                	mov    %edx,%eax
  800bc3:	c1 e0 18             	shl    $0x18,%eax
  800bc6:	89 d6                	mov    %edx,%esi
  800bc8:	c1 e6 10             	shl    $0x10,%esi
  800bcb:	09 f0                	or     %esi,%eax
  800bcd:	09 c2                	or     %eax,%edx
  800bcf:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bd1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bd4:	89 d0                	mov    %edx,%eax
  800bd6:	fc                   	cld    
  800bd7:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd9:	eb d6                	jmp    800bb1 <memset+0x23>

00800bdb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	57                   	push   %edi
  800bdf:	56                   	push   %esi
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be9:	39 c6                	cmp    %eax,%esi
  800beb:	73 35                	jae    800c22 <memmove+0x47>
  800bed:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bf0:	39 c2                	cmp    %eax,%edx
  800bf2:	76 2e                	jbe    800c22 <memmove+0x47>
		s += n;
		d += n;
  800bf4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf7:	89 d6                	mov    %edx,%esi
  800bf9:	09 fe                	or     %edi,%esi
  800bfb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c01:	74 0c                	je     800c0f <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c03:	83 ef 01             	sub    $0x1,%edi
  800c06:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c09:	fd                   	std    
  800c0a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c0c:	fc                   	cld    
  800c0d:	eb 21                	jmp    800c30 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0f:	f6 c1 03             	test   $0x3,%cl
  800c12:	75 ef                	jne    800c03 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c14:	83 ef 04             	sub    $0x4,%edi
  800c17:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c1a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c1d:	fd                   	std    
  800c1e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c20:	eb ea                	jmp    800c0c <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c22:	89 f2                	mov    %esi,%edx
  800c24:	09 c2                	or     %eax,%edx
  800c26:	f6 c2 03             	test   $0x3,%dl
  800c29:	74 09                	je     800c34 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c2b:	89 c7                	mov    %eax,%edi
  800c2d:	fc                   	cld    
  800c2e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c34:	f6 c1 03             	test   $0x3,%cl
  800c37:	75 f2                	jne    800c2b <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c39:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c3c:	89 c7                	mov    %eax,%edi
  800c3e:	fc                   	cld    
  800c3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c41:	eb ed                	jmp    800c30 <memmove+0x55>

00800c43 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c46:	ff 75 10             	pushl  0x10(%ebp)
  800c49:	ff 75 0c             	pushl  0xc(%ebp)
  800c4c:	ff 75 08             	pushl  0x8(%ebp)
  800c4f:	e8 87 ff ff ff       	call   800bdb <memmove>
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c61:	89 c6                	mov    %eax,%esi
  800c63:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c66:	39 f0                	cmp    %esi,%eax
  800c68:	74 1c                	je     800c86 <memcmp+0x30>
		if (*s1 != *s2)
  800c6a:	0f b6 08             	movzbl (%eax),%ecx
  800c6d:	0f b6 1a             	movzbl (%edx),%ebx
  800c70:	38 d9                	cmp    %bl,%cl
  800c72:	75 08                	jne    800c7c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c74:	83 c0 01             	add    $0x1,%eax
  800c77:	83 c2 01             	add    $0x1,%edx
  800c7a:	eb ea                	jmp    800c66 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c7c:	0f b6 c1             	movzbl %cl,%eax
  800c7f:	0f b6 db             	movzbl %bl,%ebx
  800c82:	29 d8                	sub    %ebx,%eax
  800c84:	eb 05                	jmp    800c8b <memcmp+0x35>
	}

	return 0;
  800c86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c8b:	5b                   	pop    %ebx
  800c8c:	5e                   	pop    %esi
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    

00800c8f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c98:	89 c2                	mov    %eax,%edx
  800c9a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c9d:	39 d0                	cmp    %edx,%eax
  800c9f:	73 09                	jae    800caa <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ca1:	38 08                	cmp    %cl,(%eax)
  800ca3:	74 05                	je     800caa <memfind+0x1b>
	for (; s < ends; s++)
  800ca5:	83 c0 01             	add    $0x1,%eax
  800ca8:	eb f3                	jmp    800c9d <memfind+0xe>
			break;
	return (void *) s;
}
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	57                   	push   %edi
  800cb0:	56                   	push   %esi
  800cb1:	53                   	push   %ebx
  800cb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb8:	eb 03                	jmp    800cbd <strtol+0x11>
		s++;
  800cba:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cbd:	0f b6 01             	movzbl (%ecx),%eax
  800cc0:	3c 20                	cmp    $0x20,%al
  800cc2:	74 f6                	je     800cba <strtol+0xe>
  800cc4:	3c 09                	cmp    $0x9,%al
  800cc6:	74 f2                	je     800cba <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cc8:	3c 2b                	cmp    $0x2b,%al
  800cca:	74 2e                	je     800cfa <strtol+0x4e>
	int neg = 0;
  800ccc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cd1:	3c 2d                	cmp    $0x2d,%al
  800cd3:	74 2f                	je     800d04 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cd5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cdb:	75 05                	jne    800ce2 <strtol+0x36>
  800cdd:	80 39 30             	cmpb   $0x30,(%ecx)
  800ce0:	74 2c                	je     800d0e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ce2:	85 db                	test   %ebx,%ebx
  800ce4:	75 0a                	jne    800cf0 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ce6:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ceb:	80 39 30             	cmpb   $0x30,(%ecx)
  800cee:	74 28                	je     800d18 <strtol+0x6c>
		base = 10;
  800cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cf8:	eb 50                	jmp    800d4a <strtol+0x9e>
		s++;
  800cfa:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cfd:	bf 00 00 00 00       	mov    $0x0,%edi
  800d02:	eb d1                	jmp    800cd5 <strtol+0x29>
		s++, neg = 1;
  800d04:	83 c1 01             	add    $0x1,%ecx
  800d07:	bf 01 00 00 00       	mov    $0x1,%edi
  800d0c:	eb c7                	jmp    800cd5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d0e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d12:	74 0e                	je     800d22 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d14:	85 db                	test   %ebx,%ebx
  800d16:	75 d8                	jne    800cf0 <strtol+0x44>
		s++, base = 8;
  800d18:	83 c1 01             	add    $0x1,%ecx
  800d1b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d20:	eb ce                	jmp    800cf0 <strtol+0x44>
		s += 2, base = 16;
  800d22:	83 c1 02             	add    $0x2,%ecx
  800d25:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d2a:	eb c4                	jmp    800cf0 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d2c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d2f:	89 f3                	mov    %esi,%ebx
  800d31:	80 fb 19             	cmp    $0x19,%bl
  800d34:	77 29                	ja     800d5f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d36:	0f be d2             	movsbl %dl,%edx
  800d39:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d3c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d3f:	7d 30                	jge    800d71 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d41:	83 c1 01             	add    $0x1,%ecx
  800d44:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d48:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d4a:	0f b6 11             	movzbl (%ecx),%edx
  800d4d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d50:	89 f3                	mov    %esi,%ebx
  800d52:	80 fb 09             	cmp    $0x9,%bl
  800d55:	77 d5                	ja     800d2c <strtol+0x80>
			dig = *s - '0';
  800d57:	0f be d2             	movsbl %dl,%edx
  800d5a:	83 ea 30             	sub    $0x30,%edx
  800d5d:	eb dd                	jmp    800d3c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d5f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d62:	89 f3                	mov    %esi,%ebx
  800d64:	80 fb 19             	cmp    $0x19,%bl
  800d67:	77 08                	ja     800d71 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d69:	0f be d2             	movsbl %dl,%edx
  800d6c:	83 ea 37             	sub    $0x37,%edx
  800d6f:	eb cb                	jmp    800d3c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d75:	74 05                	je     800d7c <strtol+0xd0>
		*endptr = (char *) s;
  800d77:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d7a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d7c:	89 c2                	mov    %eax,%edx
  800d7e:	f7 da                	neg    %edx
  800d80:	85 ff                	test   %edi,%edi
  800d82:	0f 45 c2             	cmovne %edx,%eax
}
  800d85:	5b                   	pop    %ebx
  800d86:	5e                   	pop    %esi
  800d87:	5f                   	pop    %edi
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    
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
