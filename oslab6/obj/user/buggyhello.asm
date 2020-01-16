
obj/user/buggyhello.debug：     文件格式 elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 5d 00 00 00       	call   80009f <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  800052:	e8 c6 00 00 00       	call   80011d <sys_getenvid>
	thisenv = envs + ENVX(envid);
  800057:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800064:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800069:	85 db                	test   %ebx,%ebx
  80006b:	7e 07                	jle    800074 <libmain+0x2d>
		binaryname = argv[0];
  80006d:	8b 06                	mov    (%esi),%eax
  80006f:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800074:	83 ec 08             	sub    $0x8,%esp
  800077:	56                   	push   %esi
  800078:	53                   	push   %ebx
  800079:	e8 b5 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007e:	e8 0a 00 00 00       	call   80008d <exit>
}
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800089:	5b                   	pop    %ebx
  80008a:	5e                   	pop    %esi
  80008b:	5d                   	pop    %ebp
  80008c:	c3                   	ret    

0080008d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008d:	55                   	push   %ebp
  80008e:	89 e5                	mov    %esp,%ebp
  800090:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800093:	6a 00                	push   $0x0
  800095:	e8 42 00 00 00       	call   8000dc <sys_env_destroy>
}
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	c9                   	leave  
  80009e:	c3                   	ret    

0080009f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009f:	55                   	push   %ebp
  8000a0:	89 e5                	mov    %esp,%ebp
  8000a2:	57                   	push   %edi
  8000a3:	56                   	push   %esi
  8000a4:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b0:	89 c3                	mov    %eax,%ebx
  8000b2:	89 c7                	mov    %eax,%edi
  8000b4:	89 c6                	mov    %eax,%esi
  8000b6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b8:	5b                   	pop    %ebx
  8000b9:	5e                   	pop    %esi
  8000ba:	5f                   	pop    %edi
  8000bb:	5d                   	pop    %ebp
  8000bc:	c3                   	ret    

008000bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	57                   	push   %edi
  8000c1:	56                   	push   %esi
  8000c2:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8000cd:	89 d1                	mov    %edx,%ecx
  8000cf:	89 d3                	mov    %edx,%ebx
  8000d1:	89 d7                	mov    %edx,%edi
  8000d3:	89 d6                	mov    %edx,%esi
  8000d5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d7:	5b                   	pop    %ebx
  8000d8:	5e                   	pop    %esi
  8000d9:	5f                   	pop    %edi
  8000da:	5d                   	pop    %ebp
  8000db:	c3                   	ret    

008000dc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	57                   	push   %edi
  8000e0:	56                   	push   %esi
  8000e1:	53                   	push   %ebx
  8000e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f2:	89 cb                	mov    %ecx,%ebx
  8000f4:	89 cf                	mov    %ecx,%edi
  8000f6:	89 ce                	mov    %ecx,%esi
  8000f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	7f 08                	jg     800106 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800101:	5b                   	pop    %ebx
  800102:	5e                   	pop    %esi
  800103:	5f                   	pop    %edi
  800104:	5d                   	pop    %ebp
  800105:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	50                   	push   %eax
  80010a:	6a 03                	push   $0x3
  80010c:	68 ea 0f 80 00       	push   $0x800fea
  800111:	6a 23                	push   $0x23
  800113:	68 07 10 80 00       	push   $0x801007
  800118:	e8 2f 02 00 00       	call   80034c <_panic>

0080011d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80011d:	55                   	push   %ebp
  80011e:	89 e5                	mov    %esp,%ebp
  800120:	57                   	push   %edi
  800121:	56                   	push   %esi
  800122:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800123:	ba 00 00 00 00       	mov    $0x0,%edx
  800128:	b8 02 00 00 00       	mov    $0x2,%eax
  80012d:	89 d1                	mov    %edx,%ecx
  80012f:	89 d3                	mov    %edx,%ebx
  800131:	89 d7                	mov    %edx,%edi
  800133:	89 d6                	mov    %edx,%esi
  800135:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800137:	5b                   	pop    %ebx
  800138:	5e                   	pop    %esi
  800139:	5f                   	pop    %edi
  80013a:	5d                   	pop    %ebp
  80013b:	c3                   	ret    

0080013c <sys_yield>:

void
sys_yield(void)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	57                   	push   %edi
  800140:	56                   	push   %esi
  800141:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800142:	ba 00 00 00 00       	mov    $0x0,%edx
  800147:	b8 0b 00 00 00       	mov    $0xb,%eax
  80014c:	89 d1                	mov    %edx,%ecx
  80014e:	89 d3                	mov    %edx,%ebx
  800150:	89 d7                	mov    %edx,%edi
  800152:	89 d6                	mov    %edx,%esi
  800154:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800156:	5b                   	pop    %ebx
  800157:	5e                   	pop    %esi
  800158:	5f                   	pop    %edi
  800159:	5d                   	pop    %ebp
  80015a:	c3                   	ret    

0080015b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	57                   	push   %edi
  80015f:	56                   	push   %esi
  800160:	53                   	push   %ebx
  800161:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800164:	be 00 00 00 00       	mov    $0x0,%esi
  800169:	8b 55 08             	mov    0x8(%ebp),%edx
  80016c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016f:	b8 04 00 00 00       	mov    $0x4,%eax
  800174:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800177:	89 f7                	mov    %esi,%edi
  800179:	cd 30                	int    $0x30
	if(check && ret > 0)
  80017b:	85 c0                	test   %eax,%eax
  80017d:	7f 08                	jg     800187 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80017f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800182:	5b                   	pop    %ebx
  800183:	5e                   	pop    %esi
  800184:	5f                   	pop    %edi
  800185:	5d                   	pop    %ebp
  800186:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	50                   	push   %eax
  80018b:	6a 04                	push   $0x4
  80018d:	68 ea 0f 80 00       	push   $0x800fea
  800192:	6a 23                	push   $0x23
  800194:	68 07 10 80 00       	push   $0x801007
  800199:	e8 ae 01 00 00       	call   80034c <_panic>

0080019e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	57                   	push   %edi
  8001a2:	56                   	push   %esi
  8001a3:	53                   	push   %ebx
  8001a4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8001a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ad:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b8:	8b 75 18             	mov    0x18(%ebp),%esi
  8001bb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001bd:	85 c0                	test   %eax,%eax
  8001bf:	7f 08                	jg     8001c9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c4:	5b                   	pop    %ebx
  8001c5:	5e                   	pop    %esi
  8001c6:	5f                   	pop    %edi
  8001c7:	5d                   	pop    %ebp
  8001c8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	50                   	push   %eax
  8001cd:	6a 05                	push   $0x5
  8001cf:	68 ea 0f 80 00       	push   $0x800fea
  8001d4:	6a 23                	push   $0x23
  8001d6:	68 07 10 80 00       	push   $0x801007
  8001db:	e8 6c 01 00 00       	call   80034c <_panic>

008001e0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	57                   	push   %edi
  8001e4:	56                   	push   %esi
  8001e5:	53                   	push   %ebx
  8001e6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8001e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f4:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f9:	89 df                	mov    %ebx,%edi
  8001fb:	89 de                	mov    %ebx,%esi
  8001fd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ff:	85 c0                	test   %eax,%eax
  800201:	7f 08                	jg     80020b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800203:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800206:	5b                   	pop    %ebx
  800207:	5e                   	pop    %esi
  800208:	5f                   	pop    %edi
  800209:	5d                   	pop    %ebp
  80020a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	50                   	push   %eax
  80020f:	6a 06                	push   $0x6
  800211:	68 ea 0f 80 00       	push   $0x800fea
  800216:	6a 23                	push   $0x23
  800218:	68 07 10 80 00       	push   $0x801007
  80021d:	e8 2a 01 00 00       	call   80034c <_panic>

00800222 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	57                   	push   %edi
  800226:	56                   	push   %esi
  800227:	53                   	push   %ebx
  800228:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80022b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800230:	8b 55 08             	mov    0x8(%ebp),%edx
  800233:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800236:	b8 08 00 00 00       	mov    $0x8,%eax
  80023b:	89 df                	mov    %ebx,%edi
  80023d:	89 de                	mov    %ebx,%esi
  80023f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800241:	85 c0                	test   %eax,%eax
  800243:	7f 08                	jg     80024d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800245:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800248:	5b                   	pop    %ebx
  800249:	5e                   	pop    %esi
  80024a:	5f                   	pop    %edi
  80024b:	5d                   	pop    %ebp
  80024c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	50                   	push   %eax
  800251:	6a 08                	push   $0x8
  800253:	68 ea 0f 80 00       	push   $0x800fea
  800258:	6a 23                	push   $0x23
  80025a:	68 07 10 80 00       	push   $0x801007
  80025f:	e8 e8 00 00 00       	call   80034c <_panic>

00800264 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	57                   	push   %edi
  800268:	56                   	push   %esi
  800269:	53                   	push   %ebx
  80026a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80026d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800272:	8b 55 08             	mov    0x8(%ebp),%edx
  800275:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800278:	b8 09 00 00 00       	mov    $0x9,%eax
  80027d:	89 df                	mov    %ebx,%edi
  80027f:	89 de                	mov    %ebx,%esi
  800281:	cd 30                	int    $0x30
	if(check && ret > 0)
  800283:	85 c0                	test   %eax,%eax
  800285:	7f 08                	jg     80028f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800287:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028a:	5b                   	pop    %ebx
  80028b:	5e                   	pop    %esi
  80028c:	5f                   	pop    %edi
  80028d:	5d                   	pop    %ebp
  80028e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	6a 09                	push   $0x9
  800295:	68 ea 0f 80 00       	push   $0x800fea
  80029a:	6a 23                	push   $0x23
  80029c:	68 07 10 80 00       	push   $0x801007
  8002a1:	e8 a6 00 00 00       	call   80034c <_panic>

008002a6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	57                   	push   %edi
  8002aa:	56                   	push   %esi
  8002ab:	53                   	push   %ebx
  8002ac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002bf:	89 df                	mov    %ebx,%edi
  8002c1:	89 de                	mov    %ebx,%esi
  8002c3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c5:	85 c0                	test   %eax,%eax
  8002c7:	7f 08                	jg     8002d1 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cc:	5b                   	pop    %ebx
  8002cd:	5e                   	pop    %esi
  8002ce:	5f                   	pop    %edi
  8002cf:	5d                   	pop    %ebp
  8002d0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d1:	83 ec 0c             	sub    $0xc,%esp
  8002d4:	50                   	push   %eax
  8002d5:	6a 0a                	push   $0xa
  8002d7:	68 ea 0f 80 00       	push   $0x800fea
  8002dc:	6a 23                	push   $0x23
  8002de:	68 07 10 80 00       	push   $0x801007
  8002e3:	e8 64 00 00 00       	call   80034c <_panic>

008002e8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	57                   	push   %edi
  8002ec:	56                   	push   %esi
  8002ed:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f4:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f9:	be 00 00 00 00       	mov    $0x0,%esi
  8002fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800301:	8b 7d 14             	mov    0x14(%ebp),%edi
  800304:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800306:	5b                   	pop    %ebx
  800307:	5e                   	pop    %esi
  800308:	5f                   	pop    %edi
  800309:	5d                   	pop    %ebp
  80030a:	c3                   	ret    

0080030b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	57                   	push   %edi
  80030f:	56                   	push   %esi
  800310:	53                   	push   %ebx
  800311:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800314:	b9 00 00 00 00       	mov    $0x0,%ecx
  800319:	8b 55 08             	mov    0x8(%ebp),%edx
  80031c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800321:	89 cb                	mov    %ecx,%ebx
  800323:	89 cf                	mov    %ecx,%edi
  800325:	89 ce                	mov    %ecx,%esi
  800327:	cd 30                	int    $0x30
	if(check && ret > 0)
  800329:	85 c0                	test   %eax,%eax
  80032b:	7f 08                	jg     800335 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80032d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800330:	5b                   	pop    %ebx
  800331:	5e                   	pop    %esi
  800332:	5f                   	pop    %edi
  800333:	5d                   	pop    %ebp
  800334:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	50                   	push   %eax
  800339:	6a 0d                	push   $0xd
  80033b:	68 ea 0f 80 00       	push   $0x800fea
  800340:	6a 23                	push   $0x23
  800342:	68 07 10 80 00       	push   $0x801007
  800347:	e8 00 00 00 00       	call   80034c <_panic>

0080034c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80034c:	55                   	push   %ebp
  80034d:	89 e5                	mov    %esp,%ebp
  80034f:	56                   	push   %esi
  800350:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800351:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800354:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80035a:	e8 be fd ff ff       	call   80011d <sys_getenvid>
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 0c             	pushl  0xc(%ebp)
  800365:	ff 75 08             	pushl  0x8(%ebp)
  800368:	56                   	push   %esi
  800369:	50                   	push   %eax
  80036a:	68 18 10 80 00       	push   $0x801018
  80036f:	e8 b3 00 00 00       	call   800427 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800374:	83 c4 18             	add    $0x18,%esp
  800377:	53                   	push   %ebx
  800378:	ff 75 10             	pushl  0x10(%ebp)
  80037b:	e8 56 00 00 00       	call   8003d6 <vcprintf>
	cprintf("\n");
  800380:	c7 04 24 3b 10 80 00 	movl   $0x80103b,(%esp)
  800387:	e8 9b 00 00 00       	call   800427 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80038f:	cc                   	int3   
  800390:	eb fd                	jmp    80038f <_panic+0x43>

00800392 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800392:	55                   	push   %ebp
  800393:	89 e5                	mov    %esp,%ebp
  800395:	53                   	push   %ebx
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80039c:	8b 13                	mov    (%ebx),%edx
  80039e:	8d 42 01             	lea    0x1(%edx),%eax
  8003a1:	89 03                	mov    %eax,(%ebx)
  8003a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003af:	74 09                	je     8003ba <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003b1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b8:	c9                   	leave  
  8003b9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003ba:	83 ec 08             	sub    $0x8,%esp
  8003bd:	68 ff 00 00 00       	push   $0xff
  8003c2:	8d 43 08             	lea    0x8(%ebx),%eax
  8003c5:	50                   	push   %eax
  8003c6:	e8 d4 fc ff ff       	call   80009f <sys_cputs>
		b->idx = 0;
  8003cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003d1:	83 c4 10             	add    $0x10,%esp
  8003d4:	eb db                	jmp    8003b1 <putch+0x1f>

008003d6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e6:	00 00 00 
	b.cnt = 0;
  8003e9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003f3:	ff 75 0c             	pushl  0xc(%ebp)
  8003f6:	ff 75 08             	pushl  0x8(%ebp)
  8003f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ff:	50                   	push   %eax
  800400:	68 92 03 80 00       	push   $0x800392
  800405:	e8 1a 01 00 00       	call   800524 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80040a:	83 c4 08             	add    $0x8,%esp
  80040d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800413:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800419:	50                   	push   %eax
  80041a:	e8 80 fc ff ff       	call   80009f <sys_cputs>

	return b.cnt;
}
  80041f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800425:	c9                   	leave  
  800426:	c3                   	ret    

00800427 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800427:	55                   	push   %ebp
  800428:	89 e5                	mov    %esp,%ebp
  80042a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80042d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800430:	50                   	push   %eax
  800431:	ff 75 08             	pushl  0x8(%ebp)
  800434:	e8 9d ff ff ff       	call   8003d6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	57                   	push   %edi
  80043f:	56                   	push   %esi
  800440:	53                   	push   %ebx
  800441:	83 ec 1c             	sub    $0x1c,%esp
  800444:	89 c7                	mov    %eax,%edi
  800446:	89 d6                	mov    %edx,%esi
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800451:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800454:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800457:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80045f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800462:	39 d3                	cmp    %edx,%ebx
  800464:	72 05                	jb     80046b <printnum+0x30>
  800466:	39 45 10             	cmp    %eax,0x10(%ebp)
  800469:	77 7a                	ja     8004e5 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80046b:	83 ec 0c             	sub    $0xc,%esp
  80046e:	ff 75 18             	pushl  0x18(%ebp)
  800471:	8b 45 14             	mov    0x14(%ebp),%eax
  800474:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800477:	53                   	push   %ebx
  800478:	ff 75 10             	pushl  0x10(%ebp)
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800481:	ff 75 e0             	pushl  -0x20(%ebp)
  800484:	ff 75 dc             	pushl  -0x24(%ebp)
  800487:	ff 75 d8             	pushl  -0x28(%ebp)
  80048a:	e8 01 09 00 00       	call   800d90 <__udivdi3>
  80048f:	83 c4 18             	add    $0x18,%esp
  800492:	52                   	push   %edx
  800493:	50                   	push   %eax
  800494:	89 f2                	mov    %esi,%edx
  800496:	89 f8                	mov    %edi,%eax
  800498:	e8 9e ff ff ff       	call   80043b <printnum>
  80049d:	83 c4 20             	add    $0x20,%esp
  8004a0:	eb 13                	jmp    8004b5 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a2:	83 ec 08             	sub    $0x8,%esp
  8004a5:	56                   	push   %esi
  8004a6:	ff 75 18             	pushl  0x18(%ebp)
  8004a9:	ff d7                	call   *%edi
  8004ab:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004ae:	83 eb 01             	sub    $0x1,%ebx
  8004b1:	85 db                	test   %ebx,%ebx
  8004b3:	7f ed                	jg     8004a2 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	56                   	push   %esi
  8004b9:	83 ec 04             	sub    $0x4,%esp
  8004bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c2:	ff 75 dc             	pushl  -0x24(%ebp)
  8004c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c8:	e8 e3 09 00 00       	call   800eb0 <__umoddi3>
  8004cd:	83 c4 14             	add    $0x14,%esp
  8004d0:	0f be 80 3d 10 80 00 	movsbl 0x80103d(%eax),%eax
  8004d7:	50                   	push   %eax
  8004d8:	ff d7                	call   *%edi
}
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e0:	5b                   	pop    %ebx
  8004e1:	5e                   	pop    %esi
  8004e2:	5f                   	pop    %edi
  8004e3:	5d                   	pop    %ebp
  8004e4:	c3                   	ret    
  8004e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004e8:	eb c4                	jmp    8004ae <printnum+0x73>

008004ea <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f4:	8b 10                	mov    (%eax),%edx
  8004f6:	3b 50 04             	cmp    0x4(%eax),%edx
  8004f9:	73 0a                	jae    800505 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004fe:	89 08                	mov    %ecx,(%eax)
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	88 02                	mov    %al,(%edx)
}
  800505:	5d                   	pop    %ebp
  800506:	c3                   	ret    

00800507 <printfmt>:
{
  800507:	55                   	push   %ebp
  800508:	89 e5                	mov    %esp,%ebp
  80050a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80050d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800510:	50                   	push   %eax
  800511:	ff 75 10             	pushl  0x10(%ebp)
  800514:	ff 75 0c             	pushl  0xc(%ebp)
  800517:	ff 75 08             	pushl  0x8(%ebp)
  80051a:	e8 05 00 00 00       	call   800524 <vprintfmt>
}
  80051f:	83 c4 10             	add    $0x10,%esp
  800522:	c9                   	leave  
  800523:	c3                   	ret    

00800524 <vprintfmt>:
{
  800524:	55                   	push   %ebp
  800525:	89 e5                	mov    %esp,%ebp
  800527:	57                   	push   %edi
  800528:	56                   	push   %esi
  800529:	53                   	push   %ebx
  80052a:	83 ec 2c             	sub    $0x2c,%esp
  80052d:	8b 75 08             	mov    0x8(%ebp),%esi
  800530:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800533:	8b 7d 10             	mov    0x10(%ebp),%edi
  800536:	e9 c1 03 00 00       	jmp    8008fc <vprintfmt+0x3d8>
		padc = ' ';
  80053b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80053f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800546:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80054d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800554:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800559:	8d 47 01             	lea    0x1(%edi),%eax
  80055c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80055f:	0f b6 17             	movzbl (%edi),%edx
  800562:	8d 42 dd             	lea    -0x23(%edx),%eax
  800565:	3c 55                	cmp    $0x55,%al
  800567:	0f 87 12 04 00 00    	ja     80097f <vprintfmt+0x45b>
  80056d:	0f b6 c0             	movzbl %al,%eax
  800570:	ff 24 85 80 11 80 00 	jmp    *0x801180(,%eax,4)
  800577:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80057a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80057e:	eb d9                	jmp    800559 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800580:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800583:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800587:	eb d0                	jmp    800559 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800589:	0f b6 d2             	movzbl %dl,%edx
  80058c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80058f:	b8 00 00 00 00       	mov    $0x0,%eax
  800594:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800597:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80059a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80059e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005a1:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005a4:	83 f9 09             	cmp    $0x9,%ecx
  8005a7:	77 55                	ja     8005fe <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8005a9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005ac:	eb e9                	jmp    800597 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8d 40 04             	lea    0x4(%eax),%eax
  8005bc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c6:	79 91                	jns    800559 <vprintfmt+0x35>
				width = precision, precision = -1;
  8005c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ce:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005d5:	eb 82                	jmp    800559 <vprintfmt+0x35>
  8005d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005da:	85 c0                	test   %eax,%eax
  8005dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e1:	0f 49 d0             	cmovns %eax,%edx
  8005e4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005ea:	e9 6a ff ff ff       	jmp    800559 <vprintfmt+0x35>
  8005ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005f2:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005f9:	e9 5b ff ff ff       	jmp    800559 <vprintfmt+0x35>
  8005fe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800601:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800604:	eb bc                	jmp    8005c2 <vprintfmt+0x9e>
			lflag++;
  800606:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800609:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80060c:	e9 48 ff ff ff       	jmp    800559 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8d 78 04             	lea    0x4(%eax),%edi
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	53                   	push   %ebx
  80061b:	ff 30                	pushl  (%eax)
  80061d:	ff d6                	call   *%esi
			break;
  80061f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800622:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800625:	e9 cf 02 00 00       	jmp    8008f9 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8d 78 04             	lea    0x4(%eax),%edi
  800630:	8b 00                	mov    (%eax),%eax
  800632:	99                   	cltd   
  800633:	31 d0                	xor    %edx,%eax
  800635:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800637:	83 f8 0f             	cmp    $0xf,%eax
  80063a:	7f 23                	jg     80065f <vprintfmt+0x13b>
  80063c:	8b 14 85 e0 12 80 00 	mov    0x8012e0(,%eax,4),%edx
  800643:	85 d2                	test   %edx,%edx
  800645:	74 18                	je     80065f <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800647:	52                   	push   %edx
  800648:	68 5e 10 80 00       	push   $0x80105e
  80064d:	53                   	push   %ebx
  80064e:	56                   	push   %esi
  80064f:	e8 b3 fe ff ff       	call   800507 <printfmt>
  800654:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800657:	89 7d 14             	mov    %edi,0x14(%ebp)
  80065a:	e9 9a 02 00 00       	jmp    8008f9 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80065f:	50                   	push   %eax
  800660:	68 55 10 80 00       	push   $0x801055
  800665:	53                   	push   %ebx
  800666:	56                   	push   %esi
  800667:	e8 9b fe ff ff       	call   800507 <printfmt>
  80066c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80066f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800672:	e9 82 02 00 00       	jmp    8008f9 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	83 c0 04             	add    $0x4,%eax
  80067d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800685:	85 ff                	test   %edi,%edi
  800687:	b8 4e 10 80 00       	mov    $0x80104e,%eax
  80068c:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80068f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800693:	0f 8e bd 00 00 00    	jle    800756 <vprintfmt+0x232>
  800699:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80069d:	75 0e                	jne    8006ad <vprintfmt+0x189>
  80069f:	89 75 08             	mov    %esi,0x8(%ebp)
  8006a2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006a5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006a8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006ab:	eb 6d                	jmp    80071a <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8006b3:	57                   	push   %edi
  8006b4:	e8 6e 03 00 00       	call   800a27 <strnlen>
  8006b9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006bc:	29 c1                	sub    %eax,%ecx
  8006be:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8006c1:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006c4:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006cb:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006ce:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d0:	eb 0f                	jmp    8006e1 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	53                   	push   %ebx
  8006d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006db:	83 ef 01             	sub    $0x1,%edi
  8006de:	83 c4 10             	add    $0x10,%esp
  8006e1:	85 ff                	test   %edi,%edi
  8006e3:	7f ed                	jg     8006d2 <vprintfmt+0x1ae>
  8006e5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006e8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006eb:	85 c9                	test   %ecx,%ecx
  8006ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f2:	0f 49 c1             	cmovns %ecx,%eax
  8006f5:	29 c1                	sub    %eax,%ecx
  8006f7:	89 75 08             	mov    %esi,0x8(%ebp)
  8006fa:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006fd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800700:	89 cb                	mov    %ecx,%ebx
  800702:	eb 16                	jmp    80071a <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800704:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800708:	75 31                	jne    80073b <vprintfmt+0x217>
					putch(ch, putdat);
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	50                   	push   %eax
  800711:	ff 55 08             	call   *0x8(%ebp)
  800714:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800717:	83 eb 01             	sub    $0x1,%ebx
  80071a:	83 c7 01             	add    $0x1,%edi
  80071d:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800721:	0f be c2             	movsbl %dl,%eax
  800724:	85 c0                	test   %eax,%eax
  800726:	74 59                	je     800781 <vprintfmt+0x25d>
  800728:	85 f6                	test   %esi,%esi
  80072a:	78 d8                	js     800704 <vprintfmt+0x1e0>
  80072c:	83 ee 01             	sub    $0x1,%esi
  80072f:	79 d3                	jns    800704 <vprintfmt+0x1e0>
  800731:	89 df                	mov    %ebx,%edi
  800733:	8b 75 08             	mov    0x8(%ebp),%esi
  800736:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800739:	eb 37                	jmp    800772 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80073b:	0f be d2             	movsbl %dl,%edx
  80073e:	83 ea 20             	sub    $0x20,%edx
  800741:	83 fa 5e             	cmp    $0x5e,%edx
  800744:	76 c4                	jbe    80070a <vprintfmt+0x1e6>
					putch('?', putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	ff 75 0c             	pushl  0xc(%ebp)
  80074c:	6a 3f                	push   $0x3f
  80074e:	ff 55 08             	call   *0x8(%ebp)
  800751:	83 c4 10             	add    $0x10,%esp
  800754:	eb c1                	jmp    800717 <vprintfmt+0x1f3>
  800756:	89 75 08             	mov    %esi,0x8(%ebp)
  800759:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80075c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80075f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800762:	eb b6                	jmp    80071a <vprintfmt+0x1f6>
				putch(' ', putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	53                   	push   %ebx
  800768:	6a 20                	push   $0x20
  80076a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80076c:	83 ef 01             	sub    $0x1,%edi
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	85 ff                	test   %edi,%edi
  800774:	7f ee                	jg     800764 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800776:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800779:	89 45 14             	mov    %eax,0x14(%ebp)
  80077c:	e9 78 01 00 00       	jmp    8008f9 <vprintfmt+0x3d5>
  800781:	89 df                	mov    %ebx,%edi
  800783:	8b 75 08             	mov    0x8(%ebp),%esi
  800786:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800789:	eb e7                	jmp    800772 <vprintfmt+0x24e>
	if (lflag >= 2)
  80078b:	83 f9 01             	cmp    $0x1,%ecx
  80078e:	7e 3f                	jle    8007cf <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8b 50 04             	mov    0x4(%eax),%edx
  800796:	8b 00                	mov    (%eax),%eax
  800798:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8d 40 08             	lea    0x8(%eax),%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007ab:	79 5c                	jns    800809 <vprintfmt+0x2e5>
				putch('-', putdat);
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	53                   	push   %ebx
  8007b1:	6a 2d                	push   $0x2d
  8007b3:	ff d6                	call   *%esi
				num = -(long long) num;
  8007b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007b8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007bb:	f7 da                	neg    %edx
  8007bd:	83 d1 00             	adc    $0x0,%ecx
  8007c0:	f7 d9                	neg    %ecx
  8007c2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ca:	e9 10 01 00 00       	jmp    8008df <vprintfmt+0x3bb>
	else if (lflag)
  8007cf:	85 c9                	test   %ecx,%ecx
  8007d1:	75 1b                	jne    8007ee <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007db:	89 c1                	mov    %eax,%ecx
  8007dd:	c1 f9 1f             	sar    $0x1f,%ecx
  8007e0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ec:	eb b9                	jmp    8007a7 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f6:	89 c1                	mov    %eax,%ecx
  8007f8:	c1 f9 1f             	sar    $0x1f,%ecx
  8007fb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	8d 40 04             	lea    0x4(%eax),%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
  800807:	eb 9e                	jmp    8007a7 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800809:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80080c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80080f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800814:	e9 c6 00 00 00       	jmp    8008df <vprintfmt+0x3bb>
	if (lflag >= 2)
  800819:	83 f9 01             	cmp    $0x1,%ecx
  80081c:	7e 18                	jle    800836 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	8b 10                	mov    (%eax),%edx
  800823:	8b 48 04             	mov    0x4(%eax),%ecx
  800826:	8d 40 08             	lea    0x8(%eax),%eax
  800829:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80082c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800831:	e9 a9 00 00 00       	jmp    8008df <vprintfmt+0x3bb>
	else if (lflag)
  800836:	85 c9                	test   %ecx,%ecx
  800838:	75 1a                	jne    800854 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	8b 10                	mov    (%eax),%edx
  80083f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800844:	8d 40 04             	lea    0x4(%eax),%eax
  800847:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80084a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084f:	e9 8b 00 00 00       	jmp    8008df <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8b 10                	mov    (%eax),%edx
  800859:	b9 00 00 00 00       	mov    $0x0,%ecx
  80085e:	8d 40 04             	lea    0x4(%eax),%eax
  800861:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800864:	b8 0a 00 00 00       	mov    $0xa,%eax
  800869:	eb 74                	jmp    8008df <vprintfmt+0x3bb>
	if (lflag >= 2)
  80086b:	83 f9 01             	cmp    $0x1,%ecx
  80086e:	7e 15                	jle    800885 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	8b 10                	mov    (%eax),%edx
  800875:	8b 48 04             	mov    0x4(%eax),%ecx
  800878:	8d 40 08             	lea    0x8(%eax),%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80087e:	b8 08 00 00 00       	mov    $0x8,%eax
  800883:	eb 5a                	jmp    8008df <vprintfmt+0x3bb>
	else if (lflag)
  800885:	85 c9                	test   %ecx,%ecx
  800887:	75 17                	jne    8008a0 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	8b 10                	mov    (%eax),%edx
  80088e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800893:	8d 40 04             	lea    0x4(%eax),%eax
  800896:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800899:	b8 08 00 00 00       	mov    $0x8,%eax
  80089e:	eb 3f                	jmp    8008df <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	8b 10                	mov    (%eax),%edx
  8008a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008aa:	8d 40 04             	lea    0x4(%eax),%eax
  8008ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8008b5:	eb 28                	jmp    8008df <vprintfmt+0x3bb>
			putch('0', putdat);
  8008b7:	83 ec 08             	sub    $0x8,%esp
  8008ba:	53                   	push   %ebx
  8008bb:	6a 30                	push   $0x30
  8008bd:	ff d6                	call   *%esi
			putch('x', putdat);
  8008bf:	83 c4 08             	add    $0x8,%esp
  8008c2:	53                   	push   %ebx
  8008c3:	6a 78                	push   $0x78
  8008c5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	8b 10                	mov    (%eax),%edx
  8008cc:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008d1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008d4:	8d 40 04             	lea    0x4(%eax),%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008da:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008df:	83 ec 0c             	sub    $0xc,%esp
  8008e2:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008e6:	57                   	push   %edi
  8008e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8008ea:	50                   	push   %eax
  8008eb:	51                   	push   %ecx
  8008ec:	52                   	push   %edx
  8008ed:	89 da                	mov    %ebx,%edx
  8008ef:	89 f0                	mov    %esi,%eax
  8008f1:	e8 45 fb ff ff       	call   80043b <printnum>
			break;
  8008f6:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  8008fc:	83 c7 01             	add    $0x1,%edi
  8008ff:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800903:	83 f8 25             	cmp    $0x25,%eax
  800906:	0f 84 2f fc ff ff    	je     80053b <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  80090c:	85 c0                	test   %eax,%eax
  80090e:	0f 84 8b 00 00 00    	je     80099f <vprintfmt+0x47b>
			putch(ch, putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	53                   	push   %ebx
  800918:	50                   	push   %eax
  800919:	ff d6                	call   *%esi
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	eb dc                	jmp    8008fc <vprintfmt+0x3d8>
	if (lflag >= 2)
  800920:	83 f9 01             	cmp    $0x1,%ecx
  800923:	7e 15                	jle    80093a <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800925:	8b 45 14             	mov    0x14(%ebp),%eax
  800928:	8b 10                	mov    (%eax),%edx
  80092a:	8b 48 04             	mov    0x4(%eax),%ecx
  80092d:	8d 40 08             	lea    0x8(%eax),%eax
  800930:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800933:	b8 10 00 00 00       	mov    $0x10,%eax
  800938:	eb a5                	jmp    8008df <vprintfmt+0x3bb>
	else if (lflag)
  80093a:	85 c9                	test   %ecx,%ecx
  80093c:	75 17                	jne    800955 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80093e:	8b 45 14             	mov    0x14(%ebp),%eax
  800941:	8b 10                	mov    (%eax),%edx
  800943:	b9 00 00 00 00       	mov    $0x0,%ecx
  800948:	8d 40 04             	lea    0x4(%eax),%eax
  80094b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80094e:	b8 10 00 00 00       	mov    $0x10,%eax
  800953:	eb 8a                	jmp    8008df <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	8b 10                	mov    (%eax),%edx
  80095a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80095f:	8d 40 04             	lea    0x4(%eax),%eax
  800962:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800965:	b8 10 00 00 00       	mov    $0x10,%eax
  80096a:	e9 70 ff ff ff       	jmp    8008df <vprintfmt+0x3bb>
			putch(ch, putdat);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	53                   	push   %ebx
  800973:	6a 25                	push   $0x25
  800975:	ff d6                	call   *%esi
			break;
  800977:	83 c4 10             	add    $0x10,%esp
  80097a:	e9 7a ff ff ff       	jmp    8008f9 <vprintfmt+0x3d5>
			putch('%', putdat);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	53                   	push   %ebx
  800983:	6a 25                	push   $0x25
  800985:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800987:	83 c4 10             	add    $0x10,%esp
  80098a:	89 f8                	mov    %edi,%eax
  80098c:	eb 03                	jmp    800991 <vprintfmt+0x46d>
  80098e:	83 e8 01             	sub    $0x1,%eax
  800991:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800995:	75 f7                	jne    80098e <vprintfmt+0x46a>
  800997:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80099a:	e9 5a ff ff ff       	jmp    8008f9 <vprintfmt+0x3d5>
}
  80099f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a2:	5b                   	pop    %ebx
  8009a3:	5e                   	pop    %esi
  8009a4:	5f                   	pop    %edi
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	83 ec 18             	sub    $0x18,%esp
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009b6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009ba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009c4:	85 c0                	test   %eax,%eax
  8009c6:	74 26                	je     8009ee <vsnprintf+0x47>
  8009c8:	85 d2                	test   %edx,%edx
  8009ca:	7e 22                	jle    8009ee <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009cc:	ff 75 14             	pushl  0x14(%ebp)
  8009cf:	ff 75 10             	pushl  0x10(%ebp)
  8009d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009d5:	50                   	push   %eax
  8009d6:	68 ea 04 80 00       	push   $0x8004ea
  8009db:	e8 44 fb ff ff       	call   800524 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e9:	83 c4 10             	add    $0x10,%esp
}
  8009ec:	c9                   	leave  
  8009ed:	c3                   	ret    
		return -E_INVAL;
  8009ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f3:	eb f7                	jmp    8009ec <vsnprintf+0x45>

008009f5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009fb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009fe:	50                   	push   %eax
  8009ff:	ff 75 10             	pushl  0x10(%ebp)
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	ff 75 08             	pushl  0x8(%ebp)
  800a08:	e8 9a ff ff ff       	call   8009a7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a0d:	c9                   	leave  
  800a0e:	c3                   	ret    

00800a0f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a15:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1a:	eb 03                	jmp    800a1f <strlen+0x10>
		n++;
  800a1c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a1f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a23:	75 f7                	jne    800a1c <strlen+0xd>
	return n;
}
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a30:	b8 00 00 00 00       	mov    $0x0,%eax
  800a35:	eb 03                	jmp    800a3a <strnlen+0x13>
		n++;
  800a37:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3a:	39 d0                	cmp    %edx,%eax
  800a3c:	74 06                	je     800a44 <strnlen+0x1d>
  800a3e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a42:	75 f3                	jne    800a37 <strnlen+0x10>
	return n;
}
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	53                   	push   %ebx
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a50:	89 c2                	mov    %eax,%edx
  800a52:	83 c1 01             	add    $0x1,%ecx
  800a55:	83 c2 01             	add    $0x1,%edx
  800a58:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a5c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a5f:	84 db                	test   %bl,%bl
  800a61:	75 ef                	jne    800a52 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a63:	5b                   	pop    %ebx
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	53                   	push   %ebx
  800a6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a6d:	53                   	push   %ebx
  800a6e:	e8 9c ff ff ff       	call   800a0f <strlen>
  800a73:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a76:	ff 75 0c             	pushl  0xc(%ebp)
  800a79:	01 d8                	add    %ebx,%eax
  800a7b:	50                   	push   %eax
  800a7c:	e8 c5 ff ff ff       	call   800a46 <strcpy>
	return dst;
}
  800a81:	89 d8                	mov    %ebx,%eax
  800a83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a86:	c9                   	leave  
  800a87:	c3                   	ret    

00800a88 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	56                   	push   %esi
  800a8c:	53                   	push   %ebx
  800a8d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a93:	89 f3                	mov    %esi,%ebx
  800a95:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a98:	89 f2                	mov    %esi,%edx
  800a9a:	eb 0f                	jmp    800aab <strncpy+0x23>
		*dst++ = *src;
  800a9c:	83 c2 01             	add    $0x1,%edx
  800a9f:	0f b6 01             	movzbl (%ecx),%eax
  800aa2:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa5:	80 39 01             	cmpb   $0x1,(%ecx)
  800aa8:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800aab:	39 da                	cmp    %ebx,%edx
  800aad:	75 ed                	jne    800a9c <strncpy+0x14>
	}
	return ret;
}
  800aaf:	89 f0                	mov    %esi,%eax
  800ab1:	5b                   	pop    %ebx
  800ab2:	5e                   	pop    %esi
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	56                   	push   %esi
  800ab9:	53                   	push   %ebx
  800aba:	8b 75 08             	mov    0x8(%ebp),%esi
  800abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ac3:	89 f0                	mov    %esi,%eax
  800ac5:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac9:	85 c9                	test   %ecx,%ecx
  800acb:	75 0b                	jne    800ad8 <strlcpy+0x23>
  800acd:	eb 17                	jmp    800ae6 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800acf:	83 c2 01             	add    $0x1,%edx
  800ad2:	83 c0 01             	add    $0x1,%eax
  800ad5:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ad8:	39 d8                	cmp    %ebx,%eax
  800ada:	74 07                	je     800ae3 <strlcpy+0x2e>
  800adc:	0f b6 0a             	movzbl (%edx),%ecx
  800adf:	84 c9                	test   %cl,%cl
  800ae1:	75 ec                	jne    800acf <strlcpy+0x1a>
		*dst = '\0';
  800ae3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae6:	29 f0                	sub    %esi,%eax
}
  800ae8:	5b                   	pop    %ebx
  800ae9:	5e                   	pop    %esi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800af5:	eb 06                	jmp    800afd <strcmp+0x11>
		p++, q++;
  800af7:	83 c1 01             	add    $0x1,%ecx
  800afa:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800afd:	0f b6 01             	movzbl (%ecx),%eax
  800b00:	84 c0                	test   %al,%al
  800b02:	74 04                	je     800b08 <strcmp+0x1c>
  800b04:	3a 02                	cmp    (%edx),%al
  800b06:	74 ef                	je     800af7 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b08:	0f b6 c0             	movzbl %al,%eax
  800b0b:	0f b6 12             	movzbl (%edx),%edx
  800b0e:	29 d0                	sub    %edx,%eax
}
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	53                   	push   %ebx
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1c:	89 c3                	mov    %eax,%ebx
  800b1e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b21:	eb 06                	jmp    800b29 <strncmp+0x17>
		n--, p++, q++;
  800b23:	83 c0 01             	add    $0x1,%eax
  800b26:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b29:	39 d8                	cmp    %ebx,%eax
  800b2b:	74 16                	je     800b43 <strncmp+0x31>
  800b2d:	0f b6 08             	movzbl (%eax),%ecx
  800b30:	84 c9                	test   %cl,%cl
  800b32:	74 04                	je     800b38 <strncmp+0x26>
  800b34:	3a 0a                	cmp    (%edx),%cl
  800b36:	74 eb                	je     800b23 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b38:	0f b6 00             	movzbl (%eax),%eax
  800b3b:	0f b6 12             	movzbl (%edx),%edx
  800b3e:	29 d0                	sub    %edx,%eax
}
  800b40:	5b                   	pop    %ebx
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    
		return 0;
  800b43:	b8 00 00 00 00       	mov    $0x0,%eax
  800b48:	eb f6                	jmp    800b40 <strncmp+0x2e>

00800b4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b54:	0f b6 10             	movzbl (%eax),%edx
  800b57:	84 d2                	test   %dl,%dl
  800b59:	74 09                	je     800b64 <strchr+0x1a>
		if (*s == c)
  800b5b:	38 ca                	cmp    %cl,%dl
  800b5d:	74 0a                	je     800b69 <strchr+0x1f>
	for (; *s; s++)
  800b5f:	83 c0 01             	add    $0x1,%eax
  800b62:	eb f0                	jmp    800b54 <strchr+0xa>
			return (char *) s;
	return 0;
  800b64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b75:	eb 03                	jmp    800b7a <strfind+0xf>
  800b77:	83 c0 01             	add    $0x1,%eax
  800b7a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b7d:	38 ca                	cmp    %cl,%dl
  800b7f:	74 04                	je     800b85 <strfind+0x1a>
  800b81:	84 d2                	test   %dl,%dl
  800b83:	75 f2                	jne    800b77 <strfind+0xc>
			break;
	return (char *) s;
}
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	57                   	push   %edi
  800b8b:	56                   	push   %esi
  800b8c:	53                   	push   %ebx
  800b8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b93:	85 c9                	test   %ecx,%ecx
  800b95:	74 13                	je     800baa <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b97:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b9d:	75 05                	jne    800ba4 <memset+0x1d>
  800b9f:	f6 c1 03             	test   $0x3,%cl
  800ba2:	74 0d                	je     800bb1 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba7:	fc                   	cld    
  800ba8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800baa:	89 f8                	mov    %edi,%eax
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5f                   	pop    %edi
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    
		c &= 0xFF;
  800bb1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb5:	89 d3                	mov    %edx,%ebx
  800bb7:	c1 e3 08             	shl    $0x8,%ebx
  800bba:	89 d0                	mov    %edx,%eax
  800bbc:	c1 e0 18             	shl    $0x18,%eax
  800bbf:	89 d6                	mov    %edx,%esi
  800bc1:	c1 e6 10             	shl    $0x10,%esi
  800bc4:	09 f0                	or     %esi,%eax
  800bc6:	09 c2                	or     %eax,%edx
  800bc8:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bca:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bcd:	89 d0                	mov    %edx,%eax
  800bcf:	fc                   	cld    
  800bd0:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd2:	eb d6                	jmp    800baa <memset+0x23>

00800bd4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bdf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be2:	39 c6                	cmp    %eax,%esi
  800be4:	73 35                	jae    800c1b <memmove+0x47>
  800be6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800be9:	39 c2                	cmp    %eax,%edx
  800beb:	76 2e                	jbe    800c1b <memmove+0x47>
		s += n;
		d += n;
  800bed:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf0:	89 d6                	mov    %edx,%esi
  800bf2:	09 fe                	or     %edi,%esi
  800bf4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bfa:	74 0c                	je     800c08 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bfc:	83 ef 01             	sub    $0x1,%edi
  800bff:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c02:	fd                   	std    
  800c03:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c05:	fc                   	cld    
  800c06:	eb 21                	jmp    800c29 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c08:	f6 c1 03             	test   $0x3,%cl
  800c0b:	75 ef                	jne    800bfc <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c0d:	83 ef 04             	sub    $0x4,%edi
  800c10:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c13:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c16:	fd                   	std    
  800c17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c19:	eb ea                	jmp    800c05 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c1b:	89 f2                	mov    %esi,%edx
  800c1d:	09 c2                	or     %eax,%edx
  800c1f:	f6 c2 03             	test   $0x3,%dl
  800c22:	74 09                	je     800c2d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c24:	89 c7                	mov    %eax,%edi
  800c26:	fc                   	cld    
  800c27:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c29:	5e                   	pop    %esi
  800c2a:	5f                   	pop    %edi
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c2d:	f6 c1 03             	test   $0x3,%cl
  800c30:	75 f2                	jne    800c24 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c32:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c35:	89 c7                	mov    %eax,%edi
  800c37:	fc                   	cld    
  800c38:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c3a:	eb ed                	jmp    800c29 <memmove+0x55>

00800c3c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c3f:	ff 75 10             	pushl  0x10(%ebp)
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	ff 75 08             	pushl  0x8(%ebp)
  800c48:	e8 87 ff ff ff       	call   800bd4 <memmove>
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5a:	89 c6                	mov    %eax,%esi
  800c5c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c5f:	39 f0                	cmp    %esi,%eax
  800c61:	74 1c                	je     800c7f <memcmp+0x30>
		if (*s1 != *s2)
  800c63:	0f b6 08             	movzbl (%eax),%ecx
  800c66:	0f b6 1a             	movzbl (%edx),%ebx
  800c69:	38 d9                	cmp    %bl,%cl
  800c6b:	75 08                	jne    800c75 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c6d:	83 c0 01             	add    $0x1,%eax
  800c70:	83 c2 01             	add    $0x1,%edx
  800c73:	eb ea                	jmp    800c5f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c75:	0f b6 c1             	movzbl %cl,%eax
  800c78:	0f b6 db             	movzbl %bl,%ebx
  800c7b:	29 d8                	sub    %ebx,%eax
  800c7d:	eb 05                	jmp    800c84 <memcmp+0x35>
	}

	return 0;
  800c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c91:	89 c2                	mov    %eax,%edx
  800c93:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c96:	39 d0                	cmp    %edx,%eax
  800c98:	73 09                	jae    800ca3 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c9a:	38 08                	cmp    %cl,(%eax)
  800c9c:	74 05                	je     800ca3 <memfind+0x1b>
	for (; s < ends; s++)
  800c9e:	83 c0 01             	add    $0x1,%eax
  800ca1:	eb f3                	jmp    800c96 <memfind+0xe>
			break;
	return (void *) s;
}
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	57                   	push   %edi
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
  800cab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb1:	eb 03                	jmp    800cb6 <strtol+0x11>
		s++;
  800cb3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cb6:	0f b6 01             	movzbl (%ecx),%eax
  800cb9:	3c 20                	cmp    $0x20,%al
  800cbb:	74 f6                	je     800cb3 <strtol+0xe>
  800cbd:	3c 09                	cmp    $0x9,%al
  800cbf:	74 f2                	je     800cb3 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cc1:	3c 2b                	cmp    $0x2b,%al
  800cc3:	74 2e                	je     800cf3 <strtol+0x4e>
	int neg = 0;
  800cc5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cca:	3c 2d                	cmp    $0x2d,%al
  800ccc:	74 2f                	je     800cfd <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cce:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cd4:	75 05                	jne    800cdb <strtol+0x36>
  800cd6:	80 39 30             	cmpb   $0x30,(%ecx)
  800cd9:	74 2c                	je     800d07 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cdb:	85 db                	test   %ebx,%ebx
  800cdd:	75 0a                	jne    800ce9 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cdf:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ce4:	80 39 30             	cmpb   $0x30,(%ecx)
  800ce7:	74 28                	je     800d11 <strtol+0x6c>
		base = 10;
  800ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cf1:	eb 50                	jmp    800d43 <strtol+0x9e>
		s++;
  800cf3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cf6:	bf 00 00 00 00       	mov    $0x0,%edi
  800cfb:	eb d1                	jmp    800cce <strtol+0x29>
		s++, neg = 1;
  800cfd:	83 c1 01             	add    $0x1,%ecx
  800d00:	bf 01 00 00 00       	mov    $0x1,%edi
  800d05:	eb c7                	jmp    800cce <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d07:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d0b:	74 0e                	je     800d1b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d0d:	85 db                	test   %ebx,%ebx
  800d0f:	75 d8                	jne    800ce9 <strtol+0x44>
		s++, base = 8;
  800d11:	83 c1 01             	add    $0x1,%ecx
  800d14:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d19:	eb ce                	jmp    800ce9 <strtol+0x44>
		s += 2, base = 16;
  800d1b:	83 c1 02             	add    $0x2,%ecx
  800d1e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d23:	eb c4                	jmp    800ce9 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d25:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d28:	89 f3                	mov    %esi,%ebx
  800d2a:	80 fb 19             	cmp    $0x19,%bl
  800d2d:	77 29                	ja     800d58 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d2f:	0f be d2             	movsbl %dl,%edx
  800d32:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d35:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d38:	7d 30                	jge    800d6a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d3a:	83 c1 01             	add    $0x1,%ecx
  800d3d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d41:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d43:	0f b6 11             	movzbl (%ecx),%edx
  800d46:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d49:	89 f3                	mov    %esi,%ebx
  800d4b:	80 fb 09             	cmp    $0x9,%bl
  800d4e:	77 d5                	ja     800d25 <strtol+0x80>
			dig = *s - '0';
  800d50:	0f be d2             	movsbl %dl,%edx
  800d53:	83 ea 30             	sub    $0x30,%edx
  800d56:	eb dd                	jmp    800d35 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d58:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d5b:	89 f3                	mov    %esi,%ebx
  800d5d:	80 fb 19             	cmp    $0x19,%bl
  800d60:	77 08                	ja     800d6a <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d62:	0f be d2             	movsbl %dl,%edx
  800d65:	83 ea 37             	sub    $0x37,%edx
  800d68:	eb cb                	jmp    800d35 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6e:	74 05                	je     800d75 <strtol+0xd0>
		*endptr = (char *) s;
  800d70:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d73:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d75:	89 c2                	mov    %eax,%edx
  800d77:	f7 da                	neg    %edx
  800d79:	85 ff                	test   %edi,%edi
  800d7b:	0f 45 c2             	cmovne %edx,%eax
}
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    
  800d83:	66 90                	xchg   %ax,%ax
  800d85:	66 90                	xchg   %ax,%ax
  800d87:	66 90                	xchg   %ax,%ax
  800d89:	66 90                	xchg   %ax,%ax
  800d8b:	66 90                	xchg   %ax,%ax
  800d8d:	66 90                	xchg   %ax,%ax
  800d8f:	90                   	nop

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
