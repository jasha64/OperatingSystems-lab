
obj/user/softint.debug：     文件格式 elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $14");	// page fault
  800036:	cd 0e                	int    $0xe
}
  800038:	5d                   	pop    %ebp
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800042:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  800045:	e8 c6 00 00 00       	call   800110 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  80004a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800052:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800057:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005c:	85 db                	test   %ebx,%ebx
  80005e:	7e 07                	jle    800067 <libmain+0x2d>
		binaryname = argv[0];
  800060:	8b 06                	mov    (%esi),%eax
  800062:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800067:	83 ec 08             	sub    $0x8,%esp
  80006a:	56                   	push   %esi
  80006b:	53                   	push   %ebx
  80006c:	e8 c2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800071:	e8 0a 00 00 00       	call   800080 <exit>
}
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007c:	5b                   	pop    %ebx
  80007d:	5e                   	pop    %esi
  80007e:	5d                   	pop    %ebp
  80007f:	c3                   	ret    

00800080 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800086:	6a 00                	push   $0x0
  800088:	e8 42 00 00 00       	call   8000cf <sys_env_destroy>
}
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	c9                   	leave  
  800091:	c3                   	ret    

00800092 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	57                   	push   %edi
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000a3:	89 c3                	mov    %eax,%ebx
  8000a5:	89 c7                	mov    %eax,%edi
  8000a7:	89 c6                	mov    %eax,%esi
  8000a9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000ab:	5b                   	pop    %ebx
  8000ac:	5e                   	pop    %esi
  8000ad:	5f                   	pop    %edi
  8000ae:	5d                   	pop    %ebp
  8000af:	c3                   	ret    

008000b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b0:	55                   	push   %ebp
  8000b1:	89 e5                	mov    %esp,%ebp
  8000b3:	57                   	push   %edi
  8000b4:	56                   	push   %esi
  8000b5:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c0:	89 d1                	mov    %edx,%ecx
  8000c2:	89 d3                	mov    %edx,%ebx
  8000c4:	89 d7                	mov    %edx,%edi
  8000c6:	89 d6                	mov    %edx,%esi
  8000c8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ca:	5b                   	pop    %ebx
  8000cb:	5e                   	pop    %esi
  8000cc:	5f                   	pop    %edi
  8000cd:	5d                   	pop    %ebp
  8000ce:	c3                   	ret    

008000cf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000cf:	55                   	push   %ebp
  8000d0:	89 e5                	mov    %esp,%ebp
  8000d2:	57                   	push   %edi
  8000d3:	56                   	push   %esi
  8000d4:	53                   	push   %ebx
  8000d5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e0:	b8 03 00 00 00       	mov    $0x3,%eax
  8000e5:	89 cb                	mov    %ecx,%ebx
  8000e7:	89 cf                	mov    %ecx,%edi
  8000e9:	89 ce                	mov    %ecx,%esi
  8000eb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000ed:	85 c0                	test   %eax,%eax
  8000ef:	7f 08                	jg     8000f9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000f4:	5b                   	pop    %ebx
  8000f5:	5e                   	pop    %esi
  8000f6:	5f                   	pop    %edi
  8000f7:	5d                   	pop    %ebp
  8000f8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8000f9:	83 ec 0c             	sub    $0xc,%esp
  8000fc:	50                   	push   %eax
  8000fd:	6a 03                	push   $0x3
  8000ff:	68 ca 0f 80 00       	push   $0x800fca
  800104:	6a 23                	push   $0x23
  800106:	68 e7 0f 80 00       	push   $0x800fe7
  80010b:	e8 2f 02 00 00       	call   80033f <_panic>

00800110 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	57                   	push   %edi
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800116:	ba 00 00 00 00       	mov    $0x0,%edx
  80011b:	b8 02 00 00 00       	mov    $0x2,%eax
  800120:	89 d1                	mov    %edx,%ecx
  800122:	89 d3                	mov    %edx,%ebx
  800124:	89 d7                	mov    %edx,%edi
  800126:	89 d6                	mov    %edx,%esi
  800128:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80012a:	5b                   	pop    %ebx
  80012b:	5e                   	pop    %esi
  80012c:	5f                   	pop    %edi
  80012d:	5d                   	pop    %ebp
  80012e:	c3                   	ret    

0080012f <sys_yield>:

void
sys_yield(void)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	57                   	push   %edi
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800135:	ba 00 00 00 00       	mov    $0x0,%edx
  80013a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80013f:	89 d1                	mov    %edx,%ecx
  800141:	89 d3                	mov    %edx,%ebx
  800143:	89 d7                	mov    %edx,%edi
  800145:	89 d6                	mov    %edx,%esi
  800147:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800149:	5b                   	pop    %ebx
  80014a:	5e                   	pop    %esi
  80014b:	5f                   	pop    %edi
  80014c:	5d                   	pop    %ebp
  80014d:	c3                   	ret    

0080014e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80014e:	55                   	push   %ebp
  80014f:	89 e5                	mov    %esp,%ebp
  800151:	57                   	push   %edi
  800152:	56                   	push   %esi
  800153:	53                   	push   %ebx
  800154:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800157:	be 00 00 00 00       	mov    $0x0,%esi
  80015c:	8b 55 08             	mov    0x8(%ebp),%edx
  80015f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800162:	b8 04 00 00 00       	mov    $0x4,%eax
  800167:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80016a:	89 f7                	mov    %esi,%edi
  80016c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80016e:	85 c0                	test   %eax,%eax
  800170:	7f 08                	jg     80017a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800172:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800175:	5b                   	pop    %ebx
  800176:	5e                   	pop    %esi
  800177:	5f                   	pop    %edi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80017a:	83 ec 0c             	sub    $0xc,%esp
  80017d:	50                   	push   %eax
  80017e:	6a 04                	push   $0x4
  800180:	68 ca 0f 80 00       	push   $0x800fca
  800185:	6a 23                	push   $0x23
  800187:	68 e7 0f 80 00       	push   $0x800fe7
  80018c:	e8 ae 01 00 00       	call   80033f <_panic>

00800191 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800191:	55                   	push   %ebp
  800192:	89 e5                	mov    %esp,%ebp
  800194:	57                   	push   %edi
  800195:	56                   	push   %esi
  800196:	53                   	push   %ebx
  800197:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80019a:	8b 55 08             	mov    0x8(%ebp),%edx
  80019d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ab:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ae:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b0:	85 c0                	test   %eax,%eax
  8001b2:	7f 08                	jg     8001bc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b7:	5b                   	pop    %ebx
  8001b8:	5e                   	pop    %esi
  8001b9:	5f                   	pop    %edi
  8001ba:	5d                   	pop    %ebp
  8001bb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	50                   	push   %eax
  8001c0:	6a 05                	push   $0x5
  8001c2:	68 ca 0f 80 00       	push   $0x800fca
  8001c7:	6a 23                	push   $0x23
  8001c9:	68 e7 0f 80 00       	push   $0x800fe7
  8001ce:	e8 6c 01 00 00       	call   80033f <_panic>

008001d3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	57                   	push   %edi
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
  8001d9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8001dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e7:	b8 06 00 00 00       	mov    $0x6,%eax
  8001ec:	89 df                	mov    %ebx,%edi
  8001ee:	89 de                	mov    %ebx,%esi
  8001f0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f2:	85 c0                	test   %eax,%eax
  8001f4:	7f 08                	jg     8001fe <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f9:	5b                   	pop    %ebx
  8001fa:	5e                   	pop    %esi
  8001fb:	5f                   	pop    %edi
  8001fc:	5d                   	pop    %ebp
  8001fd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fe:	83 ec 0c             	sub    $0xc,%esp
  800201:	50                   	push   %eax
  800202:	6a 06                	push   $0x6
  800204:	68 ca 0f 80 00       	push   $0x800fca
  800209:	6a 23                	push   $0x23
  80020b:	68 e7 0f 80 00       	push   $0x800fe7
  800210:	e8 2a 01 00 00       	call   80033f <_panic>

00800215 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	57                   	push   %edi
  800219:	56                   	push   %esi
  80021a:	53                   	push   %ebx
  80021b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80021e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800223:	8b 55 08             	mov    0x8(%ebp),%edx
  800226:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800229:	b8 08 00 00 00       	mov    $0x8,%eax
  80022e:	89 df                	mov    %ebx,%edi
  800230:	89 de                	mov    %ebx,%esi
  800232:	cd 30                	int    $0x30
	if(check && ret > 0)
  800234:	85 c0                	test   %eax,%eax
  800236:	7f 08                	jg     800240 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023b:	5b                   	pop    %ebx
  80023c:	5e                   	pop    %esi
  80023d:	5f                   	pop    %edi
  80023e:	5d                   	pop    %ebp
  80023f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	50                   	push   %eax
  800244:	6a 08                	push   $0x8
  800246:	68 ca 0f 80 00       	push   $0x800fca
  80024b:	6a 23                	push   $0x23
  80024d:	68 e7 0f 80 00       	push   $0x800fe7
  800252:	e8 e8 00 00 00       	call   80033f <_panic>

00800257 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	57                   	push   %edi
  80025b:	56                   	push   %esi
  80025c:	53                   	push   %ebx
  80025d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800260:	bb 00 00 00 00       	mov    $0x0,%ebx
  800265:	8b 55 08             	mov    0x8(%ebp),%edx
  800268:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026b:	b8 09 00 00 00       	mov    $0x9,%eax
  800270:	89 df                	mov    %ebx,%edi
  800272:	89 de                	mov    %ebx,%esi
  800274:	cd 30                	int    $0x30
	if(check && ret > 0)
  800276:	85 c0                	test   %eax,%eax
  800278:	7f 08                	jg     800282 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80027a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027d:	5b                   	pop    %ebx
  80027e:	5e                   	pop    %esi
  80027f:	5f                   	pop    %edi
  800280:	5d                   	pop    %ebp
  800281:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	50                   	push   %eax
  800286:	6a 09                	push   $0x9
  800288:	68 ca 0f 80 00       	push   $0x800fca
  80028d:	6a 23                	push   $0x23
  80028f:	68 e7 0f 80 00       	push   $0x800fe7
  800294:	e8 a6 00 00 00       	call   80033f <_panic>

00800299 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	57                   	push   %edi
  80029d:	56                   	push   %esi
  80029e:	53                   	push   %ebx
  80029f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b2:	89 df                	mov    %ebx,%edi
  8002b4:	89 de                	mov    %ebx,%esi
  8002b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002b8:	85 c0                	test   %eax,%eax
  8002ba:	7f 08                	jg     8002c4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bf:	5b                   	pop    %ebx
  8002c0:	5e                   	pop    %esi
  8002c1:	5f                   	pop    %edi
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c4:	83 ec 0c             	sub    $0xc,%esp
  8002c7:	50                   	push   %eax
  8002c8:	6a 0a                	push   $0xa
  8002ca:	68 ca 0f 80 00       	push   $0x800fca
  8002cf:	6a 23                	push   $0x23
  8002d1:	68 e7 0f 80 00       	push   $0x800fe7
  8002d6:	e8 64 00 00 00       	call   80033f <_panic>

008002db <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	57                   	push   %edi
  8002df:	56                   	push   %esi
  8002e0:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002ec:	be 00 00 00 00       	mov    $0x0,%esi
  8002f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002f4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002f7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002f9:	5b                   	pop    %ebx
  8002fa:	5e                   	pop    %esi
  8002fb:	5f                   	pop    %edi
  8002fc:	5d                   	pop    %ebp
  8002fd:	c3                   	ret    

008002fe <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	57                   	push   %edi
  800302:	56                   	push   %esi
  800303:	53                   	push   %ebx
  800304:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800307:	b9 00 00 00 00       	mov    $0x0,%ecx
  80030c:	8b 55 08             	mov    0x8(%ebp),%edx
  80030f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800314:	89 cb                	mov    %ecx,%ebx
  800316:	89 cf                	mov    %ecx,%edi
  800318:	89 ce                	mov    %ecx,%esi
  80031a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80031c:	85 c0                	test   %eax,%eax
  80031e:	7f 08                	jg     800328 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800323:	5b                   	pop    %ebx
  800324:	5e                   	pop    %esi
  800325:	5f                   	pop    %edi
  800326:	5d                   	pop    %ebp
  800327:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	50                   	push   %eax
  80032c:	6a 0d                	push   $0xd
  80032e:	68 ca 0f 80 00       	push   $0x800fca
  800333:	6a 23                	push   $0x23
  800335:	68 e7 0f 80 00       	push   $0x800fe7
  80033a:	e8 00 00 00 00       	call   80033f <_panic>

0080033f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	56                   	push   %esi
  800343:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800344:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800347:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80034d:	e8 be fd ff ff       	call   800110 <sys_getenvid>
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	ff 75 08             	pushl  0x8(%ebp)
  80035b:	56                   	push   %esi
  80035c:	50                   	push   %eax
  80035d:	68 f8 0f 80 00       	push   $0x800ff8
  800362:	e8 b3 00 00 00       	call   80041a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800367:	83 c4 18             	add    $0x18,%esp
  80036a:	53                   	push   %ebx
  80036b:	ff 75 10             	pushl  0x10(%ebp)
  80036e:	e8 56 00 00 00       	call   8003c9 <vcprintf>
	cprintf("\n");
  800373:	c7 04 24 1b 10 80 00 	movl   $0x80101b,(%esp)
  80037a:	e8 9b 00 00 00       	call   80041a <cprintf>
  80037f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800382:	cc                   	int3   
  800383:	eb fd                	jmp    800382 <_panic+0x43>

00800385 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	53                   	push   %ebx
  800389:	83 ec 04             	sub    $0x4,%esp
  80038c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80038f:	8b 13                	mov    (%ebx),%edx
  800391:	8d 42 01             	lea    0x1(%edx),%eax
  800394:	89 03                	mov    %eax,(%ebx)
  800396:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800399:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80039d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a2:	74 09                	je     8003ad <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003a4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	68 ff 00 00 00       	push   $0xff
  8003b5:	8d 43 08             	lea    0x8(%ebx),%eax
  8003b8:	50                   	push   %eax
  8003b9:	e8 d4 fc ff ff       	call   800092 <sys_cputs>
		b->idx = 0;
  8003be:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003c4:	83 c4 10             	add    $0x10,%esp
  8003c7:	eb db                	jmp    8003a4 <putch+0x1f>

008003c9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003c9:	55                   	push   %ebp
  8003ca:	89 e5                	mov    %esp,%ebp
  8003cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003d9:	00 00 00 
	b.cnt = 0;
  8003dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003e3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003e6:	ff 75 0c             	pushl  0xc(%ebp)
  8003e9:	ff 75 08             	pushl  0x8(%ebp)
  8003ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003f2:	50                   	push   %eax
  8003f3:	68 85 03 80 00       	push   $0x800385
  8003f8:	e8 1a 01 00 00       	call   800517 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003fd:	83 c4 08             	add    $0x8,%esp
  800400:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800406:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 80 fc ff ff       	call   800092 <sys_cputs>

	return b.cnt;
}
  800412:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800418:	c9                   	leave  
  800419:	c3                   	ret    

0080041a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800420:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800423:	50                   	push   %eax
  800424:	ff 75 08             	pushl  0x8(%ebp)
  800427:	e8 9d ff ff ff       	call   8003c9 <vcprintf>
	va_end(ap);

	return cnt;
}
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	57                   	push   %edi
  800432:	56                   	push   %esi
  800433:	53                   	push   %ebx
  800434:	83 ec 1c             	sub    $0x1c,%esp
  800437:	89 c7                	mov    %eax,%edi
  800439:	89 d6                	mov    %edx,%esi
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800441:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800444:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800447:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80044a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80044f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800452:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800455:	39 d3                	cmp    %edx,%ebx
  800457:	72 05                	jb     80045e <printnum+0x30>
  800459:	39 45 10             	cmp    %eax,0x10(%ebp)
  80045c:	77 7a                	ja     8004d8 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80045e:	83 ec 0c             	sub    $0xc,%esp
  800461:	ff 75 18             	pushl  0x18(%ebp)
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80046a:	53                   	push   %ebx
  80046b:	ff 75 10             	pushl  0x10(%ebp)
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	ff 75 e4             	pushl  -0x1c(%ebp)
  800474:	ff 75 e0             	pushl  -0x20(%ebp)
  800477:	ff 75 dc             	pushl  -0x24(%ebp)
  80047a:	ff 75 d8             	pushl  -0x28(%ebp)
  80047d:	e8 fe 08 00 00       	call   800d80 <__udivdi3>
  800482:	83 c4 18             	add    $0x18,%esp
  800485:	52                   	push   %edx
  800486:	50                   	push   %eax
  800487:	89 f2                	mov    %esi,%edx
  800489:	89 f8                	mov    %edi,%eax
  80048b:	e8 9e ff ff ff       	call   80042e <printnum>
  800490:	83 c4 20             	add    $0x20,%esp
  800493:	eb 13                	jmp    8004a8 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800495:	83 ec 08             	sub    $0x8,%esp
  800498:	56                   	push   %esi
  800499:	ff 75 18             	pushl  0x18(%ebp)
  80049c:	ff d7                	call   *%edi
  80049e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004a1:	83 eb 01             	sub    $0x1,%ebx
  8004a4:	85 db                	test   %ebx,%ebx
  8004a6:	7f ed                	jg     800495 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	56                   	push   %esi
  8004ac:	83 ec 04             	sub    $0x4,%esp
  8004af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8004b8:	ff 75 d8             	pushl  -0x28(%ebp)
  8004bb:	e8 e0 09 00 00       	call   800ea0 <__umoddi3>
  8004c0:	83 c4 14             	add    $0x14,%esp
  8004c3:	0f be 80 1d 10 80 00 	movsbl 0x80101d(%eax),%eax
  8004ca:	50                   	push   %eax
  8004cb:	ff d7                	call   *%edi
}
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d3:	5b                   	pop    %ebx
  8004d4:	5e                   	pop    %esi
  8004d5:	5f                   	pop    %edi
  8004d6:	5d                   	pop    %ebp
  8004d7:	c3                   	ret    
  8004d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004db:	eb c4                	jmp    8004a1 <printnum+0x73>

008004dd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004e3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004e7:	8b 10                	mov    (%eax),%edx
  8004e9:	3b 50 04             	cmp    0x4(%eax),%edx
  8004ec:	73 0a                	jae    8004f8 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004f1:	89 08                	mov    %ecx,(%eax)
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	88 02                	mov    %al,(%edx)
}
  8004f8:	5d                   	pop    %ebp
  8004f9:	c3                   	ret    

008004fa <printfmt>:
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800500:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800503:	50                   	push   %eax
  800504:	ff 75 10             	pushl  0x10(%ebp)
  800507:	ff 75 0c             	pushl  0xc(%ebp)
  80050a:	ff 75 08             	pushl  0x8(%ebp)
  80050d:	e8 05 00 00 00       	call   800517 <vprintfmt>
}
  800512:	83 c4 10             	add    $0x10,%esp
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <vprintfmt>:
{
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	57                   	push   %edi
  80051b:	56                   	push   %esi
  80051c:	53                   	push   %ebx
  80051d:	83 ec 2c             	sub    $0x2c,%esp
  800520:	8b 75 08             	mov    0x8(%ebp),%esi
  800523:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800526:	8b 7d 10             	mov    0x10(%ebp),%edi
  800529:	e9 c1 03 00 00       	jmp    8008ef <vprintfmt+0x3d8>
		padc = ' ';
  80052e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800532:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800539:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800540:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800547:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80054c:	8d 47 01             	lea    0x1(%edi),%eax
  80054f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800552:	0f b6 17             	movzbl (%edi),%edx
  800555:	8d 42 dd             	lea    -0x23(%edx),%eax
  800558:	3c 55                	cmp    $0x55,%al
  80055a:	0f 87 12 04 00 00    	ja     800972 <vprintfmt+0x45b>
  800560:	0f b6 c0             	movzbl %al,%eax
  800563:	ff 24 85 60 11 80 00 	jmp    *0x801160(,%eax,4)
  80056a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80056d:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800571:	eb d9                	jmp    80054c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800573:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800576:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80057a:	eb d0                	jmp    80054c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80057c:	0f b6 d2             	movzbl %dl,%edx
  80057f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800582:	b8 00 00 00 00       	mov    $0x0,%eax
  800587:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80058a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80058d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800591:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800594:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800597:	83 f9 09             	cmp    $0x9,%ecx
  80059a:	77 55                	ja     8005f1 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80059c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80059f:	eb e9                	jmp    80058a <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8d 40 04             	lea    0x4(%eax),%eax
  8005af:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b9:	79 91                	jns    80054c <vprintfmt+0x35>
				width = precision, precision = -1;
  8005bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c1:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005c8:	eb 82                	jmp    80054c <vprintfmt+0x35>
  8005ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005cd:	85 c0                	test   %eax,%eax
  8005cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d4:	0f 49 d0             	cmovns %eax,%edx
  8005d7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005dd:	e9 6a ff ff ff       	jmp    80054c <vprintfmt+0x35>
  8005e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005e5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005ec:	e9 5b ff ff ff       	jmp    80054c <vprintfmt+0x35>
  8005f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f7:	eb bc                	jmp    8005b5 <vprintfmt+0x9e>
			lflag++;
  8005f9:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005ff:	e9 48 ff ff ff       	jmp    80054c <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8d 78 04             	lea    0x4(%eax),%edi
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	53                   	push   %ebx
  80060e:	ff 30                	pushl  (%eax)
  800610:	ff d6                	call   *%esi
			break;
  800612:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800615:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800618:	e9 cf 02 00 00       	jmp    8008ec <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8d 78 04             	lea    0x4(%eax),%edi
  800623:	8b 00                	mov    (%eax),%eax
  800625:	99                   	cltd   
  800626:	31 d0                	xor    %edx,%eax
  800628:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80062a:	83 f8 0f             	cmp    $0xf,%eax
  80062d:	7f 23                	jg     800652 <vprintfmt+0x13b>
  80062f:	8b 14 85 c0 12 80 00 	mov    0x8012c0(,%eax,4),%edx
  800636:	85 d2                	test   %edx,%edx
  800638:	74 18                	je     800652 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80063a:	52                   	push   %edx
  80063b:	68 3e 10 80 00       	push   $0x80103e
  800640:	53                   	push   %ebx
  800641:	56                   	push   %esi
  800642:	e8 b3 fe ff ff       	call   8004fa <printfmt>
  800647:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80064a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80064d:	e9 9a 02 00 00       	jmp    8008ec <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800652:	50                   	push   %eax
  800653:	68 35 10 80 00       	push   $0x801035
  800658:	53                   	push   %ebx
  800659:	56                   	push   %esi
  80065a:	e8 9b fe ff ff       	call   8004fa <printfmt>
  80065f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800662:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800665:	e9 82 02 00 00       	jmp    8008ec <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	83 c0 04             	add    $0x4,%eax
  800670:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800678:	85 ff                	test   %edi,%edi
  80067a:	b8 2e 10 80 00       	mov    $0x80102e,%eax
  80067f:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800682:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800686:	0f 8e bd 00 00 00    	jle    800749 <vprintfmt+0x232>
  80068c:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800690:	75 0e                	jne    8006a0 <vprintfmt+0x189>
  800692:	89 75 08             	mov    %esi,0x8(%ebp)
  800695:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800698:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80069b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80069e:	eb 6d                	jmp    80070d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	ff 75 d0             	pushl  -0x30(%ebp)
  8006a6:	57                   	push   %edi
  8006a7:	e8 6e 03 00 00       	call   800a1a <strnlen>
  8006ac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006af:	29 c1                	sub    %eax,%ecx
  8006b1:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8006b4:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006b7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006be:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006c1:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c3:	eb 0f                	jmp    8006d4 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006c5:	83 ec 08             	sub    $0x8,%esp
  8006c8:	53                   	push   %ebx
  8006c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8006cc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ce:	83 ef 01             	sub    $0x1,%edi
  8006d1:	83 c4 10             	add    $0x10,%esp
  8006d4:	85 ff                	test   %edi,%edi
  8006d6:	7f ed                	jg     8006c5 <vprintfmt+0x1ae>
  8006d8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006db:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006de:	85 c9                	test   %ecx,%ecx
  8006e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e5:	0f 49 c1             	cmovns %ecx,%eax
  8006e8:	29 c1                	sub    %eax,%ecx
  8006ea:	89 75 08             	mov    %esi,0x8(%ebp)
  8006ed:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006f0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006f3:	89 cb                	mov    %ecx,%ebx
  8006f5:	eb 16                	jmp    80070d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006fb:	75 31                	jne    80072e <vprintfmt+0x217>
					putch(ch, putdat);
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 0c             	pushl  0xc(%ebp)
  800703:	50                   	push   %eax
  800704:	ff 55 08             	call   *0x8(%ebp)
  800707:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070a:	83 eb 01             	sub    $0x1,%ebx
  80070d:	83 c7 01             	add    $0x1,%edi
  800710:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800714:	0f be c2             	movsbl %dl,%eax
  800717:	85 c0                	test   %eax,%eax
  800719:	74 59                	je     800774 <vprintfmt+0x25d>
  80071b:	85 f6                	test   %esi,%esi
  80071d:	78 d8                	js     8006f7 <vprintfmt+0x1e0>
  80071f:	83 ee 01             	sub    $0x1,%esi
  800722:	79 d3                	jns    8006f7 <vprintfmt+0x1e0>
  800724:	89 df                	mov    %ebx,%edi
  800726:	8b 75 08             	mov    0x8(%ebp),%esi
  800729:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80072c:	eb 37                	jmp    800765 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80072e:	0f be d2             	movsbl %dl,%edx
  800731:	83 ea 20             	sub    $0x20,%edx
  800734:	83 fa 5e             	cmp    $0x5e,%edx
  800737:	76 c4                	jbe    8006fd <vprintfmt+0x1e6>
					putch('?', putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	6a 3f                	push   $0x3f
  800741:	ff 55 08             	call   *0x8(%ebp)
  800744:	83 c4 10             	add    $0x10,%esp
  800747:	eb c1                	jmp    80070a <vprintfmt+0x1f3>
  800749:	89 75 08             	mov    %esi,0x8(%ebp)
  80074c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80074f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800752:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800755:	eb b6                	jmp    80070d <vprintfmt+0x1f6>
				putch(' ', putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	53                   	push   %ebx
  80075b:	6a 20                	push   $0x20
  80075d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80075f:	83 ef 01             	sub    $0x1,%edi
  800762:	83 c4 10             	add    $0x10,%esp
  800765:	85 ff                	test   %edi,%edi
  800767:	7f ee                	jg     800757 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800769:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80076c:	89 45 14             	mov    %eax,0x14(%ebp)
  80076f:	e9 78 01 00 00       	jmp    8008ec <vprintfmt+0x3d5>
  800774:	89 df                	mov    %ebx,%edi
  800776:	8b 75 08             	mov    0x8(%ebp),%esi
  800779:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80077c:	eb e7                	jmp    800765 <vprintfmt+0x24e>
	if (lflag >= 2)
  80077e:	83 f9 01             	cmp    $0x1,%ecx
  800781:	7e 3f                	jle    8007c2 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8b 50 04             	mov    0x4(%eax),%edx
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8d 40 08             	lea    0x8(%eax),%eax
  800797:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80079a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80079e:	79 5c                	jns    8007fc <vprintfmt+0x2e5>
				putch('-', putdat);
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	53                   	push   %ebx
  8007a4:	6a 2d                	push   $0x2d
  8007a6:	ff d6                	call   *%esi
				num = -(long long) num;
  8007a8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007ab:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007ae:	f7 da                	neg    %edx
  8007b0:	83 d1 00             	adc    $0x0,%ecx
  8007b3:	f7 d9                	neg    %ecx
  8007b5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007bd:	e9 10 01 00 00       	jmp    8008d2 <vprintfmt+0x3bb>
	else if (lflag)
  8007c2:	85 c9                	test   %ecx,%ecx
  8007c4:	75 1b                	jne    8007e1 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ce:	89 c1                	mov    %eax,%ecx
  8007d0:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8d 40 04             	lea    0x4(%eax),%eax
  8007dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007df:	eb b9                	jmp    80079a <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	8b 00                	mov    (%eax),%eax
  8007e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e9:	89 c1                	mov    %eax,%ecx
  8007eb:	c1 f9 1f             	sar    $0x1f,%ecx
  8007ee:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8d 40 04             	lea    0x4(%eax),%eax
  8007f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fa:	eb 9e                	jmp    80079a <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007ff:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800802:	b8 0a 00 00 00       	mov    $0xa,%eax
  800807:	e9 c6 00 00 00       	jmp    8008d2 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80080c:	83 f9 01             	cmp    $0x1,%ecx
  80080f:	7e 18                	jle    800829 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	8b 10                	mov    (%eax),%edx
  800816:	8b 48 04             	mov    0x4(%eax),%ecx
  800819:	8d 40 08             	lea    0x8(%eax),%eax
  80081c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80081f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800824:	e9 a9 00 00 00       	jmp    8008d2 <vprintfmt+0x3bb>
	else if (lflag)
  800829:	85 c9                	test   %ecx,%ecx
  80082b:	75 1a                	jne    800847 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8b 10                	mov    (%eax),%edx
  800832:	b9 00 00 00 00       	mov    $0x0,%ecx
  800837:	8d 40 04             	lea    0x4(%eax),%eax
  80083a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80083d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800842:	e9 8b 00 00 00       	jmp    8008d2 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	8b 10                	mov    (%eax),%edx
  80084c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800851:	8d 40 04             	lea    0x4(%eax),%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800857:	b8 0a 00 00 00       	mov    $0xa,%eax
  80085c:	eb 74                	jmp    8008d2 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80085e:	83 f9 01             	cmp    $0x1,%ecx
  800861:	7e 15                	jle    800878 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	8b 10                	mov    (%eax),%edx
  800868:	8b 48 04             	mov    0x4(%eax),%ecx
  80086b:	8d 40 08             	lea    0x8(%eax),%eax
  80086e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800871:	b8 08 00 00 00       	mov    $0x8,%eax
  800876:	eb 5a                	jmp    8008d2 <vprintfmt+0x3bb>
	else if (lflag)
  800878:	85 c9                	test   %ecx,%ecx
  80087a:	75 17                	jne    800893 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8b 10                	mov    (%eax),%edx
  800881:	b9 00 00 00 00       	mov    $0x0,%ecx
  800886:	8d 40 04             	lea    0x4(%eax),%eax
  800889:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80088c:	b8 08 00 00 00       	mov    $0x8,%eax
  800891:	eb 3f                	jmp    8008d2 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	8b 10                	mov    (%eax),%edx
  800898:	b9 00 00 00 00       	mov    $0x0,%ecx
  80089d:	8d 40 04             	lea    0x4(%eax),%eax
  8008a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008a3:	b8 08 00 00 00       	mov    $0x8,%eax
  8008a8:	eb 28                	jmp    8008d2 <vprintfmt+0x3bb>
			putch('0', putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	53                   	push   %ebx
  8008ae:	6a 30                	push   $0x30
  8008b0:	ff d6                	call   *%esi
			putch('x', putdat);
  8008b2:	83 c4 08             	add    $0x8,%esp
  8008b5:	53                   	push   %ebx
  8008b6:	6a 78                	push   $0x78
  8008b8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	8b 10                	mov    (%eax),%edx
  8008bf:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008c4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008c7:	8d 40 04             	lea    0x4(%eax),%eax
  8008ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008cd:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008d2:	83 ec 0c             	sub    $0xc,%esp
  8008d5:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008d9:	57                   	push   %edi
  8008da:	ff 75 e0             	pushl  -0x20(%ebp)
  8008dd:	50                   	push   %eax
  8008de:	51                   	push   %ecx
  8008df:	52                   	push   %edx
  8008e0:	89 da                	mov    %ebx,%edx
  8008e2:	89 f0                	mov    %esi,%eax
  8008e4:	e8 45 fb ff ff       	call   80042e <printnum>
			break;
  8008e9:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  8008ef:	83 c7 01             	add    $0x1,%edi
  8008f2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008f6:	83 f8 25             	cmp    $0x25,%eax
  8008f9:	0f 84 2f fc ff ff    	je     80052e <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  8008ff:	85 c0                	test   %eax,%eax
  800901:	0f 84 8b 00 00 00    	je     800992 <vprintfmt+0x47b>
			putch(ch, putdat);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	53                   	push   %ebx
  80090b:	50                   	push   %eax
  80090c:	ff d6                	call   *%esi
  80090e:	83 c4 10             	add    $0x10,%esp
  800911:	eb dc                	jmp    8008ef <vprintfmt+0x3d8>
	if (lflag >= 2)
  800913:	83 f9 01             	cmp    $0x1,%ecx
  800916:	7e 15                	jle    80092d <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800918:	8b 45 14             	mov    0x14(%ebp),%eax
  80091b:	8b 10                	mov    (%eax),%edx
  80091d:	8b 48 04             	mov    0x4(%eax),%ecx
  800920:	8d 40 08             	lea    0x8(%eax),%eax
  800923:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800926:	b8 10 00 00 00       	mov    $0x10,%eax
  80092b:	eb a5                	jmp    8008d2 <vprintfmt+0x3bb>
	else if (lflag)
  80092d:	85 c9                	test   %ecx,%ecx
  80092f:	75 17                	jne    800948 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	8b 10                	mov    (%eax),%edx
  800936:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093b:	8d 40 04             	lea    0x4(%eax),%eax
  80093e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800941:	b8 10 00 00 00       	mov    $0x10,%eax
  800946:	eb 8a                	jmp    8008d2 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	8b 10                	mov    (%eax),%edx
  80094d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800952:	8d 40 04             	lea    0x4(%eax),%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800958:	b8 10 00 00 00       	mov    $0x10,%eax
  80095d:	e9 70 ff ff ff       	jmp    8008d2 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	53                   	push   %ebx
  800966:	6a 25                	push   $0x25
  800968:	ff d6                	call   *%esi
			break;
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	e9 7a ff ff ff       	jmp    8008ec <vprintfmt+0x3d5>
			putch('%', putdat);
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	53                   	push   %ebx
  800976:	6a 25                	push   $0x25
  800978:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80097a:	83 c4 10             	add    $0x10,%esp
  80097d:	89 f8                	mov    %edi,%eax
  80097f:	eb 03                	jmp    800984 <vprintfmt+0x46d>
  800981:	83 e8 01             	sub    $0x1,%eax
  800984:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800988:	75 f7                	jne    800981 <vprintfmt+0x46a>
  80098a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80098d:	e9 5a ff ff ff       	jmp    8008ec <vprintfmt+0x3d5>
}
  800992:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800995:	5b                   	pop    %ebx
  800996:	5e                   	pop    %esi
  800997:	5f                   	pop    %edi
  800998:	5d                   	pop    %ebp
  800999:	c3                   	ret    

0080099a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	83 ec 18             	sub    $0x18,%esp
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009a9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009ad:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009b7:	85 c0                	test   %eax,%eax
  8009b9:	74 26                	je     8009e1 <vsnprintf+0x47>
  8009bb:	85 d2                	test   %edx,%edx
  8009bd:	7e 22                	jle    8009e1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009bf:	ff 75 14             	pushl  0x14(%ebp)
  8009c2:	ff 75 10             	pushl  0x10(%ebp)
  8009c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009c8:	50                   	push   %eax
  8009c9:	68 dd 04 80 00       	push   $0x8004dd
  8009ce:	e8 44 fb ff ff       	call   800517 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009d6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009dc:	83 c4 10             	add    $0x10,%esp
}
  8009df:	c9                   	leave  
  8009e0:	c3                   	ret    
		return -E_INVAL;
  8009e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009e6:	eb f7                	jmp    8009df <vsnprintf+0x45>

008009e8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009ee:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009f1:	50                   	push   %eax
  8009f2:	ff 75 10             	pushl  0x10(%ebp)
  8009f5:	ff 75 0c             	pushl  0xc(%ebp)
  8009f8:	ff 75 08             	pushl  0x8(%ebp)
  8009fb:	e8 9a ff ff ff       	call   80099a <vsnprintf>
	va_end(ap);

	return rc;
}
  800a00:	c9                   	leave  
  800a01:	c3                   	ret    

00800a02 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a08:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0d:	eb 03                	jmp    800a12 <strlen+0x10>
		n++;
  800a0f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a12:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a16:	75 f7                	jne    800a0f <strlen+0xd>
	return n;
}
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a20:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a23:	b8 00 00 00 00       	mov    $0x0,%eax
  800a28:	eb 03                	jmp    800a2d <strnlen+0x13>
		n++;
  800a2a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a2d:	39 d0                	cmp    %edx,%eax
  800a2f:	74 06                	je     800a37 <strnlen+0x1d>
  800a31:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a35:	75 f3                	jne    800a2a <strnlen+0x10>
	return n;
}
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	53                   	push   %ebx
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a43:	89 c2                	mov    %eax,%edx
  800a45:	83 c1 01             	add    $0x1,%ecx
  800a48:	83 c2 01             	add    $0x1,%edx
  800a4b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a4f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a52:	84 db                	test   %bl,%bl
  800a54:	75 ef                	jne    800a45 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a56:	5b                   	pop    %ebx
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	53                   	push   %ebx
  800a5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a60:	53                   	push   %ebx
  800a61:	e8 9c ff ff ff       	call   800a02 <strlen>
  800a66:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	01 d8                	add    %ebx,%eax
  800a6e:	50                   	push   %eax
  800a6f:	e8 c5 ff ff ff       	call   800a39 <strcpy>
	return dst;
}
  800a74:	89 d8                	mov    %ebx,%eax
  800a76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	56                   	push   %esi
  800a7f:	53                   	push   %ebx
  800a80:	8b 75 08             	mov    0x8(%ebp),%esi
  800a83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a86:	89 f3                	mov    %esi,%ebx
  800a88:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a8b:	89 f2                	mov    %esi,%edx
  800a8d:	eb 0f                	jmp    800a9e <strncpy+0x23>
		*dst++ = *src;
  800a8f:	83 c2 01             	add    $0x1,%edx
  800a92:	0f b6 01             	movzbl (%ecx),%eax
  800a95:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a98:	80 39 01             	cmpb   $0x1,(%ecx)
  800a9b:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a9e:	39 da                	cmp    %ebx,%edx
  800aa0:	75 ed                	jne    800a8f <strncpy+0x14>
	}
	return ret;
}
  800aa2:	89 f0                	mov    %esi,%eax
  800aa4:	5b                   	pop    %ebx
  800aa5:	5e                   	pop    %esi
  800aa6:	5d                   	pop    %ebp
  800aa7:	c3                   	ret    

00800aa8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	56                   	push   %esi
  800aac:	53                   	push   %ebx
  800aad:	8b 75 08             	mov    0x8(%ebp),%esi
  800ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ab6:	89 f0                	mov    %esi,%eax
  800ab8:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800abc:	85 c9                	test   %ecx,%ecx
  800abe:	75 0b                	jne    800acb <strlcpy+0x23>
  800ac0:	eb 17                	jmp    800ad9 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ac2:	83 c2 01             	add    $0x1,%edx
  800ac5:	83 c0 01             	add    $0x1,%eax
  800ac8:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800acb:	39 d8                	cmp    %ebx,%eax
  800acd:	74 07                	je     800ad6 <strlcpy+0x2e>
  800acf:	0f b6 0a             	movzbl (%edx),%ecx
  800ad2:	84 c9                	test   %cl,%cl
  800ad4:	75 ec                	jne    800ac2 <strlcpy+0x1a>
		*dst = '\0';
  800ad6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad9:	29 f0                	sub    %esi,%eax
}
  800adb:	5b                   	pop    %ebx
  800adc:	5e                   	pop    %esi
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    

00800adf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ae8:	eb 06                	jmp    800af0 <strcmp+0x11>
		p++, q++;
  800aea:	83 c1 01             	add    $0x1,%ecx
  800aed:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800af0:	0f b6 01             	movzbl (%ecx),%eax
  800af3:	84 c0                	test   %al,%al
  800af5:	74 04                	je     800afb <strcmp+0x1c>
  800af7:	3a 02                	cmp    (%edx),%al
  800af9:	74 ef                	je     800aea <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800afb:	0f b6 c0             	movzbl %al,%eax
  800afe:	0f b6 12             	movzbl (%edx),%edx
  800b01:	29 d0                	sub    %edx,%eax
}
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	53                   	push   %ebx
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0f:	89 c3                	mov    %eax,%ebx
  800b11:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b14:	eb 06                	jmp    800b1c <strncmp+0x17>
		n--, p++, q++;
  800b16:	83 c0 01             	add    $0x1,%eax
  800b19:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b1c:	39 d8                	cmp    %ebx,%eax
  800b1e:	74 16                	je     800b36 <strncmp+0x31>
  800b20:	0f b6 08             	movzbl (%eax),%ecx
  800b23:	84 c9                	test   %cl,%cl
  800b25:	74 04                	je     800b2b <strncmp+0x26>
  800b27:	3a 0a                	cmp    (%edx),%cl
  800b29:	74 eb                	je     800b16 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2b:	0f b6 00             	movzbl (%eax),%eax
  800b2e:	0f b6 12             	movzbl (%edx),%edx
  800b31:	29 d0                	sub    %edx,%eax
}
  800b33:	5b                   	pop    %ebx
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    
		return 0;
  800b36:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3b:	eb f6                	jmp    800b33 <strncmp+0x2e>

00800b3d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b47:	0f b6 10             	movzbl (%eax),%edx
  800b4a:	84 d2                	test   %dl,%dl
  800b4c:	74 09                	je     800b57 <strchr+0x1a>
		if (*s == c)
  800b4e:	38 ca                	cmp    %cl,%dl
  800b50:	74 0a                	je     800b5c <strchr+0x1f>
	for (; *s; s++)
  800b52:	83 c0 01             	add    $0x1,%eax
  800b55:	eb f0                	jmp    800b47 <strchr+0xa>
			return (char *) s;
	return 0;
  800b57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b5c:	5d                   	pop    %ebp
  800b5d:	c3                   	ret    

00800b5e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b5e:	55                   	push   %ebp
  800b5f:	89 e5                	mov    %esp,%ebp
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b68:	eb 03                	jmp    800b6d <strfind+0xf>
  800b6a:	83 c0 01             	add    $0x1,%eax
  800b6d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b70:	38 ca                	cmp    %cl,%dl
  800b72:	74 04                	je     800b78 <strfind+0x1a>
  800b74:	84 d2                	test   %dl,%dl
  800b76:	75 f2                	jne    800b6a <strfind+0xc>
			break;
	return (char *) s;
}
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	57                   	push   %edi
  800b7e:	56                   	push   %esi
  800b7f:	53                   	push   %ebx
  800b80:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b83:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b86:	85 c9                	test   %ecx,%ecx
  800b88:	74 13                	je     800b9d <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b8a:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b90:	75 05                	jne    800b97 <memset+0x1d>
  800b92:	f6 c1 03             	test   $0x3,%cl
  800b95:	74 0d                	je     800ba4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9a:	fc                   	cld    
  800b9b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b9d:	89 f8                	mov    %edi,%eax
  800b9f:	5b                   	pop    %ebx
  800ba0:	5e                   	pop    %esi
  800ba1:	5f                   	pop    %edi
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    
		c &= 0xFF;
  800ba4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ba8:	89 d3                	mov    %edx,%ebx
  800baa:	c1 e3 08             	shl    $0x8,%ebx
  800bad:	89 d0                	mov    %edx,%eax
  800baf:	c1 e0 18             	shl    $0x18,%eax
  800bb2:	89 d6                	mov    %edx,%esi
  800bb4:	c1 e6 10             	shl    $0x10,%esi
  800bb7:	09 f0                	or     %esi,%eax
  800bb9:	09 c2                	or     %eax,%edx
  800bbb:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bbd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bc0:	89 d0                	mov    %edx,%eax
  800bc2:	fc                   	cld    
  800bc3:	f3 ab                	rep stos %eax,%es:(%edi)
  800bc5:	eb d6                	jmp    800b9d <memset+0x23>

00800bc7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	57                   	push   %edi
  800bcb:	56                   	push   %esi
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bd5:	39 c6                	cmp    %eax,%esi
  800bd7:	73 35                	jae    800c0e <memmove+0x47>
  800bd9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bdc:	39 c2                	cmp    %eax,%edx
  800bde:	76 2e                	jbe    800c0e <memmove+0x47>
		s += n;
		d += n;
  800be0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be3:	89 d6                	mov    %edx,%esi
  800be5:	09 fe                	or     %edi,%esi
  800be7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bed:	74 0c                	je     800bfb <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bef:	83 ef 01             	sub    $0x1,%edi
  800bf2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bf5:	fd                   	std    
  800bf6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bf8:	fc                   	cld    
  800bf9:	eb 21                	jmp    800c1c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfb:	f6 c1 03             	test   $0x3,%cl
  800bfe:	75 ef                	jne    800bef <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c00:	83 ef 04             	sub    $0x4,%edi
  800c03:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c06:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c09:	fd                   	std    
  800c0a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c0c:	eb ea                	jmp    800bf8 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0e:	89 f2                	mov    %esi,%edx
  800c10:	09 c2                	or     %eax,%edx
  800c12:	f6 c2 03             	test   $0x3,%dl
  800c15:	74 09                	je     800c20 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c17:	89 c7                	mov    %eax,%edi
  800c19:	fc                   	cld    
  800c1a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c1c:	5e                   	pop    %esi
  800c1d:	5f                   	pop    %edi
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c20:	f6 c1 03             	test   $0x3,%cl
  800c23:	75 f2                	jne    800c17 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c25:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c28:	89 c7                	mov    %eax,%edi
  800c2a:	fc                   	cld    
  800c2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c2d:	eb ed                	jmp    800c1c <memmove+0x55>

00800c2f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c32:	ff 75 10             	pushl  0x10(%ebp)
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	ff 75 08             	pushl  0x8(%ebp)
  800c3b:	e8 87 ff ff ff       	call   800bc7 <memmove>
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	56                   	push   %esi
  800c46:	53                   	push   %ebx
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4d:	89 c6                	mov    %eax,%esi
  800c4f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c52:	39 f0                	cmp    %esi,%eax
  800c54:	74 1c                	je     800c72 <memcmp+0x30>
		if (*s1 != *s2)
  800c56:	0f b6 08             	movzbl (%eax),%ecx
  800c59:	0f b6 1a             	movzbl (%edx),%ebx
  800c5c:	38 d9                	cmp    %bl,%cl
  800c5e:	75 08                	jne    800c68 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c60:	83 c0 01             	add    $0x1,%eax
  800c63:	83 c2 01             	add    $0x1,%edx
  800c66:	eb ea                	jmp    800c52 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c68:	0f b6 c1             	movzbl %cl,%eax
  800c6b:	0f b6 db             	movzbl %bl,%ebx
  800c6e:	29 d8                	sub    %ebx,%eax
  800c70:	eb 05                	jmp    800c77 <memcmp+0x35>
	}

	return 0;
  800c72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c77:	5b                   	pop    %ebx
  800c78:	5e                   	pop    %esi
  800c79:	5d                   	pop    %ebp
  800c7a:	c3                   	ret    

00800c7b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c84:	89 c2                	mov    %eax,%edx
  800c86:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c89:	39 d0                	cmp    %edx,%eax
  800c8b:	73 09                	jae    800c96 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c8d:	38 08                	cmp    %cl,(%eax)
  800c8f:	74 05                	je     800c96 <memfind+0x1b>
	for (; s < ends; s++)
  800c91:	83 c0 01             	add    $0x1,%eax
  800c94:	eb f3                	jmp    800c89 <memfind+0xe>
			break;
	return (void *) s;
}
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	57                   	push   %edi
  800c9c:	56                   	push   %esi
  800c9d:	53                   	push   %ebx
  800c9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ca4:	eb 03                	jmp    800ca9 <strtol+0x11>
		s++;
  800ca6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ca9:	0f b6 01             	movzbl (%ecx),%eax
  800cac:	3c 20                	cmp    $0x20,%al
  800cae:	74 f6                	je     800ca6 <strtol+0xe>
  800cb0:	3c 09                	cmp    $0x9,%al
  800cb2:	74 f2                	je     800ca6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cb4:	3c 2b                	cmp    $0x2b,%al
  800cb6:	74 2e                	je     800ce6 <strtol+0x4e>
	int neg = 0;
  800cb8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cbd:	3c 2d                	cmp    $0x2d,%al
  800cbf:	74 2f                	je     800cf0 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cc7:	75 05                	jne    800cce <strtol+0x36>
  800cc9:	80 39 30             	cmpb   $0x30,(%ecx)
  800ccc:	74 2c                	je     800cfa <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cce:	85 db                	test   %ebx,%ebx
  800cd0:	75 0a                	jne    800cdc <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cd2:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cd7:	80 39 30             	cmpb   $0x30,(%ecx)
  800cda:	74 28                	je     800d04 <strtol+0x6c>
		base = 10;
  800cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ce4:	eb 50                	jmp    800d36 <strtol+0x9e>
		s++;
  800ce6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ce9:	bf 00 00 00 00       	mov    $0x0,%edi
  800cee:	eb d1                	jmp    800cc1 <strtol+0x29>
		s++, neg = 1;
  800cf0:	83 c1 01             	add    $0x1,%ecx
  800cf3:	bf 01 00 00 00       	mov    $0x1,%edi
  800cf8:	eb c7                	jmp    800cc1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cfa:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cfe:	74 0e                	je     800d0e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d00:	85 db                	test   %ebx,%ebx
  800d02:	75 d8                	jne    800cdc <strtol+0x44>
		s++, base = 8;
  800d04:	83 c1 01             	add    $0x1,%ecx
  800d07:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d0c:	eb ce                	jmp    800cdc <strtol+0x44>
		s += 2, base = 16;
  800d0e:	83 c1 02             	add    $0x2,%ecx
  800d11:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d16:	eb c4                	jmp    800cdc <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d18:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d1b:	89 f3                	mov    %esi,%ebx
  800d1d:	80 fb 19             	cmp    $0x19,%bl
  800d20:	77 29                	ja     800d4b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d22:	0f be d2             	movsbl %dl,%edx
  800d25:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d28:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d2b:	7d 30                	jge    800d5d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d2d:	83 c1 01             	add    $0x1,%ecx
  800d30:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d34:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d36:	0f b6 11             	movzbl (%ecx),%edx
  800d39:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d3c:	89 f3                	mov    %esi,%ebx
  800d3e:	80 fb 09             	cmp    $0x9,%bl
  800d41:	77 d5                	ja     800d18 <strtol+0x80>
			dig = *s - '0';
  800d43:	0f be d2             	movsbl %dl,%edx
  800d46:	83 ea 30             	sub    $0x30,%edx
  800d49:	eb dd                	jmp    800d28 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d4b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d4e:	89 f3                	mov    %esi,%ebx
  800d50:	80 fb 19             	cmp    $0x19,%bl
  800d53:	77 08                	ja     800d5d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d55:	0f be d2             	movsbl %dl,%edx
  800d58:	83 ea 37             	sub    $0x37,%edx
  800d5b:	eb cb                	jmp    800d28 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d61:	74 05                	je     800d68 <strtol+0xd0>
		*endptr = (char *) s;
  800d63:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d66:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d68:	89 c2                	mov    %eax,%edx
  800d6a:	f7 da                	neg    %edx
  800d6c:	85 ff                	test   %edi,%edi
  800d6e:	0f 45 c2             	cmovne %edx,%eax
}
  800d71:	5b                   	pop    %ebx
  800d72:	5e                   	pop    %esi
  800d73:	5f                   	pop    %edi
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    
  800d76:	66 90                	xchg   %ax,%ax
  800d78:	66 90                	xchg   %ax,%ax
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
