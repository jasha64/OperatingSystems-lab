
obj/user/faultwrite.debug：     文件格式 elf32-i386


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
  80002c:	e8 11 00 00 00       	call   800042 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	*(unsigned*)0 = 0;
  800036:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003d:	00 00 00 
}
  800040:	5d                   	pop    %ebp
  800041:	c3                   	ret    

00800042 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800042:	55                   	push   %ebp
  800043:	89 e5                	mov    %esp,%ebp
  800045:	56                   	push   %esi
  800046:	53                   	push   %ebx
  800047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  80004d:	e8 c6 00 00 00       	call   800118 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  800052:	25 ff 03 00 00       	and    $0x3ff,%eax
  800057:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005f:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800064:	85 db                	test   %ebx,%ebx
  800066:	7e 07                	jle    80006f <libmain+0x2d>
		binaryname = argv[0];
  800068:	8b 06                	mov    (%esi),%eax
  80006a:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80006f:	83 ec 08             	sub    $0x8,%esp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	e8 ba ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800079:	e8 0a 00 00 00       	call   800088 <exit>
}
  80007e:	83 c4 10             	add    $0x10,%esp
  800081:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800084:	5b                   	pop    %ebx
  800085:	5e                   	pop    %esi
  800086:	5d                   	pop    %ebp
  800087:	c3                   	ret    

00800088 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800088:	55                   	push   %ebp
  800089:	89 e5                	mov    %esp,%ebp
  80008b:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80008e:	6a 00                	push   $0x0
  800090:	e8 42 00 00 00       	call   8000d7 <sys_env_destroy>
}
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	57                   	push   %edi
  80009e:	56                   	push   %esi
  80009f:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ab:	89 c3                	mov    %eax,%ebx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 c6                	mov    %eax,%esi
  8000b1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b3:	5b                   	pop    %ebx
  8000b4:	5e                   	pop    %esi
  8000b5:	5f                   	pop    %edi
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	57                   	push   %edi
  8000bc:	56                   	push   %esi
  8000bd:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000be:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c8:	89 d1                	mov    %edx,%ecx
  8000ca:	89 d3                	mov    %edx,%ebx
  8000cc:	89 d7                	mov    %edx,%edi
  8000ce:	89 d6                	mov    %edx,%esi
  8000d0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d2:	5b                   	pop    %ebx
  8000d3:	5e                   	pop    %esi
  8000d4:	5f                   	pop    %edi
  8000d5:	5d                   	pop    %ebp
  8000d6:	c3                   	ret    

008000d7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d7:	55                   	push   %ebp
  8000d8:	89 e5                	mov    %esp,%ebp
  8000da:	57                   	push   %edi
  8000db:	56                   	push   %esi
  8000dc:	53                   	push   %ebx
  8000dd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e8:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ed:	89 cb                	mov    %ecx,%ebx
  8000ef:	89 cf                	mov    %ecx,%edi
  8000f1:	89 ce                	mov    %ecx,%esi
  8000f3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f5:	85 c0                	test   %eax,%eax
  8000f7:	7f 08                	jg     800101 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000fc:	5b                   	pop    %ebx
  8000fd:	5e                   	pop    %esi
  8000fe:	5f                   	pop    %edi
  8000ff:	5d                   	pop    %ebp
  800100:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	50                   	push   %eax
  800105:	6a 03                	push   $0x3
  800107:	68 ca 0f 80 00       	push   $0x800fca
  80010c:	6a 23                	push   $0x23
  80010e:	68 e7 0f 80 00       	push   $0x800fe7
  800113:	e8 2f 02 00 00       	call   800347 <_panic>

00800118 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80011e:	ba 00 00 00 00       	mov    $0x0,%edx
  800123:	b8 02 00 00 00       	mov    $0x2,%eax
  800128:	89 d1                	mov    %edx,%ecx
  80012a:	89 d3                	mov    %edx,%ebx
  80012c:	89 d7                	mov    %edx,%edi
  80012e:	89 d6                	mov    %edx,%esi
  800130:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800132:	5b                   	pop    %ebx
  800133:	5e                   	pop    %esi
  800134:	5f                   	pop    %edi
  800135:	5d                   	pop    %ebp
  800136:	c3                   	ret    

00800137 <sys_yield>:

void
sys_yield(void)
{
  800137:	55                   	push   %ebp
  800138:	89 e5                	mov    %esp,%ebp
  80013a:	57                   	push   %edi
  80013b:	56                   	push   %esi
  80013c:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80013d:	ba 00 00 00 00       	mov    $0x0,%edx
  800142:	b8 0b 00 00 00       	mov    $0xb,%eax
  800147:	89 d1                	mov    %edx,%ecx
  800149:	89 d3                	mov    %edx,%ebx
  80014b:	89 d7                	mov    %edx,%edi
  80014d:	89 d6                	mov    %edx,%esi
  80014f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800151:	5b                   	pop    %ebx
  800152:	5e                   	pop    %esi
  800153:	5f                   	pop    %edi
  800154:	5d                   	pop    %ebp
  800155:	c3                   	ret    

00800156 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800156:	55                   	push   %ebp
  800157:	89 e5                	mov    %esp,%ebp
  800159:	57                   	push   %edi
  80015a:	56                   	push   %esi
  80015b:	53                   	push   %ebx
  80015c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80015f:	be 00 00 00 00       	mov    $0x0,%esi
  800164:	8b 55 08             	mov    0x8(%ebp),%edx
  800167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016a:	b8 04 00 00 00       	mov    $0x4,%eax
  80016f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800172:	89 f7                	mov    %esi,%edi
  800174:	cd 30                	int    $0x30
	if(check && ret > 0)
  800176:	85 c0                	test   %eax,%eax
  800178:	7f 08                	jg     800182 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017d:	5b                   	pop    %ebx
  80017e:	5e                   	pop    %esi
  80017f:	5f                   	pop    %edi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	6a 04                	push   $0x4
  800188:	68 ca 0f 80 00       	push   $0x800fca
  80018d:	6a 23                	push   $0x23
  80018f:	68 e7 0f 80 00       	push   $0x800fe7
  800194:	e8 ae 01 00 00       	call   800347 <_panic>

00800199 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800199:	55                   	push   %ebp
  80019a:	89 e5                	mov    %esp,%ebp
  80019c:	57                   	push   %edi
  80019d:	56                   	push   %esi
  80019e:	53                   	push   %ebx
  80019f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8001a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a8:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b8:	85 c0                	test   %eax,%eax
  8001ba:	7f 08                	jg     8001c4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bf:	5b                   	pop    %ebx
  8001c0:	5e                   	pop    %esi
  8001c1:	5f                   	pop    %edi
  8001c2:	5d                   	pop    %ebp
  8001c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	50                   	push   %eax
  8001c8:	6a 05                	push   $0x5
  8001ca:	68 ca 0f 80 00       	push   $0x800fca
  8001cf:	6a 23                	push   $0x23
  8001d1:	68 e7 0f 80 00       	push   $0x800fe7
  8001d6:	e8 6c 01 00 00       	call   800347 <_panic>

008001db <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	57                   	push   %edi
  8001df:	56                   	push   %esi
  8001e0:	53                   	push   %ebx
  8001e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8001e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f4:	89 df                	mov    %ebx,%edi
  8001f6:	89 de                	mov    %ebx,%esi
  8001f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001fa:	85 c0                	test   %eax,%eax
  8001fc:	7f 08                	jg     800206 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800201:	5b                   	pop    %ebx
  800202:	5e                   	pop    %esi
  800203:	5f                   	pop    %edi
  800204:	5d                   	pop    %ebp
  800205:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	50                   	push   %eax
  80020a:	6a 06                	push   $0x6
  80020c:	68 ca 0f 80 00       	push   $0x800fca
  800211:	6a 23                	push   $0x23
  800213:	68 e7 0f 80 00       	push   $0x800fe7
  800218:	e8 2a 01 00 00       	call   800347 <_panic>

0080021d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	57                   	push   %edi
  800221:	56                   	push   %esi
  800222:	53                   	push   %ebx
  800223:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800226:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022b:	8b 55 08             	mov    0x8(%ebp),%edx
  80022e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800231:	b8 08 00 00 00       	mov    $0x8,%eax
  800236:	89 df                	mov    %ebx,%edi
  800238:	89 de                	mov    %ebx,%esi
  80023a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80023c:	85 c0                	test   %eax,%eax
  80023e:	7f 08                	jg     800248 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800243:	5b                   	pop    %ebx
  800244:	5e                   	pop    %esi
  800245:	5f                   	pop    %edi
  800246:	5d                   	pop    %ebp
  800247:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	50                   	push   %eax
  80024c:	6a 08                	push   $0x8
  80024e:	68 ca 0f 80 00       	push   $0x800fca
  800253:	6a 23                	push   $0x23
  800255:	68 e7 0f 80 00       	push   $0x800fe7
  80025a:	e8 e8 00 00 00       	call   800347 <_panic>

0080025f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	57                   	push   %edi
  800263:	56                   	push   %esi
  800264:	53                   	push   %ebx
  800265:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800268:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026d:	8b 55 08             	mov    0x8(%ebp),%edx
  800270:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800273:	b8 09 00 00 00       	mov    $0x9,%eax
  800278:	89 df                	mov    %ebx,%edi
  80027a:	89 de                	mov    %ebx,%esi
  80027c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027e:	85 c0                	test   %eax,%eax
  800280:	7f 08                	jg     80028a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800282:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800285:	5b                   	pop    %ebx
  800286:	5e                   	pop    %esi
  800287:	5f                   	pop    %edi
  800288:	5d                   	pop    %ebp
  800289:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	50                   	push   %eax
  80028e:	6a 09                	push   $0x9
  800290:	68 ca 0f 80 00       	push   $0x800fca
  800295:	6a 23                	push   $0x23
  800297:	68 e7 0f 80 00       	push   $0x800fe7
  80029c:	e8 a6 00 00 00       	call   800347 <_panic>

008002a1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	57                   	push   %edi
  8002a5:	56                   	push   %esi
  8002a6:	53                   	push   %ebx
  8002a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002af:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ba:	89 df                	mov    %ebx,%edi
  8002bc:	89 de                	mov    %ebx,%esi
  8002be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c0:	85 c0                	test   %eax,%eax
  8002c2:	7f 08                	jg     8002cc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c7:	5b                   	pop    %ebx
  8002c8:	5e                   	pop    %esi
  8002c9:	5f                   	pop    %edi
  8002ca:	5d                   	pop    %ebp
  8002cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	50                   	push   %eax
  8002d0:	6a 0a                	push   $0xa
  8002d2:	68 ca 0f 80 00       	push   $0x800fca
  8002d7:	6a 23                	push   $0x23
  8002d9:	68 e7 0f 80 00       	push   $0x800fe7
  8002de:	e8 64 00 00 00       	call   800347 <_panic>

008002e3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	57                   	push   %edi
  8002e7:	56                   	push   %esi
  8002e8:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ef:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f4:	be 00 00 00 00       	mov    $0x0,%esi
  8002f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002fc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002ff:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800301:	5b                   	pop    %ebx
  800302:	5e                   	pop    %esi
  800303:	5f                   	pop    %edi
  800304:	5d                   	pop    %ebp
  800305:	c3                   	ret    

00800306 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	57                   	push   %edi
  80030a:	56                   	push   %esi
  80030b:	53                   	push   %ebx
  80030c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80030f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800314:	8b 55 08             	mov    0x8(%ebp),%edx
  800317:	b8 0d 00 00 00       	mov    $0xd,%eax
  80031c:	89 cb                	mov    %ecx,%ebx
  80031e:	89 cf                	mov    %ecx,%edi
  800320:	89 ce                	mov    %ecx,%esi
  800322:	cd 30                	int    $0x30
	if(check && ret > 0)
  800324:	85 c0                	test   %eax,%eax
  800326:	7f 08                	jg     800330 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800328:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032b:	5b                   	pop    %ebx
  80032c:	5e                   	pop    %esi
  80032d:	5f                   	pop    %edi
  80032e:	5d                   	pop    %ebp
  80032f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800330:	83 ec 0c             	sub    $0xc,%esp
  800333:	50                   	push   %eax
  800334:	6a 0d                	push   $0xd
  800336:	68 ca 0f 80 00       	push   $0x800fca
  80033b:	6a 23                	push   $0x23
  80033d:	68 e7 0f 80 00       	push   $0x800fe7
  800342:	e8 00 00 00 00       	call   800347 <_panic>

00800347 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	56                   	push   %esi
  80034b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80034c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80034f:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800355:	e8 be fd ff ff       	call   800118 <sys_getenvid>
  80035a:	83 ec 0c             	sub    $0xc,%esp
  80035d:	ff 75 0c             	pushl  0xc(%ebp)
  800360:	ff 75 08             	pushl  0x8(%ebp)
  800363:	56                   	push   %esi
  800364:	50                   	push   %eax
  800365:	68 f8 0f 80 00       	push   $0x800ff8
  80036a:	e8 b3 00 00 00       	call   800422 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80036f:	83 c4 18             	add    $0x18,%esp
  800372:	53                   	push   %ebx
  800373:	ff 75 10             	pushl  0x10(%ebp)
  800376:	e8 56 00 00 00       	call   8003d1 <vcprintf>
	cprintf("\n");
  80037b:	c7 04 24 1b 10 80 00 	movl   $0x80101b,(%esp)
  800382:	e8 9b 00 00 00       	call   800422 <cprintf>
  800387:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80038a:	cc                   	int3   
  80038b:	eb fd                	jmp    80038a <_panic+0x43>

0080038d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80038d:	55                   	push   %ebp
  80038e:	89 e5                	mov    %esp,%ebp
  800390:	53                   	push   %ebx
  800391:	83 ec 04             	sub    $0x4,%esp
  800394:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800397:	8b 13                	mov    (%ebx),%edx
  800399:	8d 42 01             	lea    0x1(%edx),%eax
  80039c:	89 03                	mov    %eax,(%ebx)
  80039e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003a5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003aa:	74 09                	je     8003b5 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003ac:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b3:	c9                   	leave  
  8003b4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003b5:	83 ec 08             	sub    $0x8,%esp
  8003b8:	68 ff 00 00 00       	push   $0xff
  8003bd:	8d 43 08             	lea    0x8(%ebx),%eax
  8003c0:	50                   	push   %eax
  8003c1:	e8 d4 fc ff ff       	call   80009a <sys_cputs>
		b->idx = 0;
  8003c6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003cc:	83 c4 10             	add    $0x10,%esp
  8003cf:	eb db                	jmp    8003ac <putch+0x1f>

008003d1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
  8003d4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003da:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e1:	00 00 00 
	b.cnt = 0;
  8003e4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003eb:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003ee:	ff 75 0c             	pushl  0xc(%ebp)
  8003f1:	ff 75 08             	pushl  0x8(%ebp)
  8003f4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003fa:	50                   	push   %eax
  8003fb:	68 8d 03 80 00       	push   $0x80038d
  800400:	e8 1a 01 00 00       	call   80051f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800405:	83 c4 08             	add    $0x8,%esp
  800408:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80040e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800414:	50                   	push   %eax
  800415:	e8 80 fc ff ff       	call   80009a <sys_cputs>

	return b.cnt;
}
  80041a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800420:	c9                   	leave  
  800421:	c3                   	ret    

00800422 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800428:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80042b:	50                   	push   %eax
  80042c:	ff 75 08             	pushl  0x8(%ebp)
  80042f:	e8 9d ff ff ff       	call   8003d1 <vcprintf>
	va_end(ap);

	return cnt;
}
  800434:	c9                   	leave  
  800435:	c3                   	ret    

00800436 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	57                   	push   %edi
  80043a:	56                   	push   %esi
  80043b:	53                   	push   %ebx
  80043c:	83 ec 1c             	sub    $0x1c,%esp
  80043f:	89 c7                	mov    %eax,%edi
  800441:	89 d6                	mov    %edx,%esi
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	8b 55 0c             	mov    0xc(%ebp),%edx
  800449:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80044c:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80044f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800452:	bb 00 00 00 00       	mov    $0x0,%ebx
  800457:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80045a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80045d:	39 d3                	cmp    %edx,%ebx
  80045f:	72 05                	jb     800466 <printnum+0x30>
  800461:	39 45 10             	cmp    %eax,0x10(%ebp)
  800464:	77 7a                	ja     8004e0 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	ff 75 18             	pushl  0x18(%ebp)
  80046c:	8b 45 14             	mov    0x14(%ebp),%eax
  80046f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800472:	53                   	push   %ebx
  800473:	ff 75 10             	pushl  0x10(%ebp)
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	ff 75 e4             	pushl  -0x1c(%ebp)
  80047c:	ff 75 e0             	pushl  -0x20(%ebp)
  80047f:	ff 75 dc             	pushl  -0x24(%ebp)
  800482:	ff 75 d8             	pushl  -0x28(%ebp)
  800485:	e8 f6 08 00 00       	call   800d80 <__udivdi3>
  80048a:	83 c4 18             	add    $0x18,%esp
  80048d:	52                   	push   %edx
  80048e:	50                   	push   %eax
  80048f:	89 f2                	mov    %esi,%edx
  800491:	89 f8                	mov    %edi,%eax
  800493:	e8 9e ff ff ff       	call   800436 <printnum>
  800498:	83 c4 20             	add    $0x20,%esp
  80049b:	eb 13                	jmp    8004b0 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	56                   	push   %esi
  8004a1:	ff 75 18             	pushl  0x18(%ebp)
  8004a4:	ff d7                	call   *%edi
  8004a6:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004a9:	83 eb 01             	sub    $0x1,%ebx
  8004ac:	85 db                	test   %ebx,%ebx
  8004ae:	7f ed                	jg     80049d <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	56                   	push   %esi
  8004b4:	83 ec 04             	sub    $0x4,%esp
  8004b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8004bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8004c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c3:	e8 d8 09 00 00       	call   800ea0 <__umoddi3>
  8004c8:	83 c4 14             	add    $0x14,%esp
  8004cb:	0f be 80 1d 10 80 00 	movsbl 0x80101d(%eax),%eax
  8004d2:	50                   	push   %eax
  8004d3:	ff d7                	call   *%edi
}
  8004d5:	83 c4 10             	add    $0x10,%esp
  8004d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004db:	5b                   	pop    %ebx
  8004dc:	5e                   	pop    %esi
  8004dd:	5f                   	pop    %edi
  8004de:	5d                   	pop    %ebp
  8004df:	c3                   	ret    
  8004e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004e3:	eb c4                	jmp    8004a9 <printnum+0x73>

008004e5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004e5:	55                   	push   %ebp
  8004e6:	89 e5                	mov    %esp,%ebp
  8004e8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004eb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ef:	8b 10                	mov    (%eax),%edx
  8004f1:	3b 50 04             	cmp    0x4(%eax),%edx
  8004f4:	73 0a                	jae    800500 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004f9:	89 08                	mov    %ecx,(%eax)
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	88 02                	mov    %al,(%edx)
}
  800500:	5d                   	pop    %ebp
  800501:	c3                   	ret    

00800502 <printfmt>:
{
  800502:	55                   	push   %ebp
  800503:	89 e5                	mov    %esp,%ebp
  800505:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800508:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80050b:	50                   	push   %eax
  80050c:	ff 75 10             	pushl  0x10(%ebp)
  80050f:	ff 75 0c             	pushl  0xc(%ebp)
  800512:	ff 75 08             	pushl  0x8(%ebp)
  800515:	e8 05 00 00 00       	call   80051f <vprintfmt>
}
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	c9                   	leave  
  80051e:	c3                   	ret    

0080051f <vprintfmt>:
{
  80051f:	55                   	push   %ebp
  800520:	89 e5                	mov    %esp,%ebp
  800522:	57                   	push   %edi
  800523:	56                   	push   %esi
  800524:	53                   	push   %ebx
  800525:	83 ec 2c             	sub    $0x2c,%esp
  800528:	8b 75 08             	mov    0x8(%ebp),%esi
  80052b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80052e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800531:	e9 c1 03 00 00       	jmp    8008f7 <vprintfmt+0x3d8>
		padc = ' ';
  800536:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80053a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800541:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800548:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80054f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800554:	8d 47 01             	lea    0x1(%edi),%eax
  800557:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80055a:	0f b6 17             	movzbl (%edi),%edx
  80055d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800560:	3c 55                	cmp    $0x55,%al
  800562:	0f 87 12 04 00 00    	ja     80097a <vprintfmt+0x45b>
  800568:	0f b6 c0             	movzbl %al,%eax
  80056b:	ff 24 85 60 11 80 00 	jmp    *0x801160(,%eax,4)
  800572:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800575:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800579:	eb d9                	jmp    800554 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80057b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80057e:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800582:	eb d0                	jmp    800554 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800584:	0f b6 d2             	movzbl %dl,%edx
  800587:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80058a:	b8 00 00 00 00       	mov    $0x0,%eax
  80058f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800592:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800595:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800599:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80059c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80059f:	83 f9 09             	cmp    $0x9,%ecx
  8005a2:	77 55                	ja     8005f9 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8005a4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005a7:	eb e9                	jmp    800592 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8d 40 04             	lea    0x4(%eax),%eax
  8005b7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c1:	79 91                	jns    800554 <vprintfmt+0x35>
				width = precision, precision = -1;
  8005c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c9:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005d0:	eb 82                	jmp    800554 <vprintfmt+0x35>
  8005d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d5:	85 c0                	test   %eax,%eax
  8005d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005dc:	0f 49 d0             	cmovns %eax,%edx
  8005df:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005e5:	e9 6a ff ff ff       	jmp    800554 <vprintfmt+0x35>
  8005ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005ed:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005f4:	e9 5b ff ff ff       	jmp    800554 <vprintfmt+0x35>
  8005f9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ff:	eb bc                	jmp    8005bd <vprintfmt+0x9e>
			lflag++;
  800601:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800604:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800607:	e9 48 ff ff ff       	jmp    800554 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8d 78 04             	lea    0x4(%eax),%edi
  800612:	83 ec 08             	sub    $0x8,%esp
  800615:	53                   	push   %ebx
  800616:	ff 30                	pushl  (%eax)
  800618:	ff d6                	call   *%esi
			break;
  80061a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80061d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800620:	e9 cf 02 00 00       	jmp    8008f4 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8d 78 04             	lea    0x4(%eax),%edi
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	99                   	cltd   
  80062e:	31 d0                	xor    %edx,%eax
  800630:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800632:	83 f8 0f             	cmp    $0xf,%eax
  800635:	7f 23                	jg     80065a <vprintfmt+0x13b>
  800637:	8b 14 85 c0 12 80 00 	mov    0x8012c0(,%eax,4),%edx
  80063e:	85 d2                	test   %edx,%edx
  800640:	74 18                	je     80065a <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800642:	52                   	push   %edx
  800643:	68 3e 10 80 00       	push   $0x80103e
  800648:	53                   	push   %ebx
  800649:	56                   	push   %esi
  80064a:	e8 b3 fe ff ff       	call   800502 <printfmt>
  80064f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800652:	89 7d 14             	mov    %edi,0x14(%ebp)
  800655:	e9 9a 02 00 00       	jmp    8008f4 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80065a:	50                   	push   %eax
  80065b:	68 35 10 80 00       	push   $0x801035
  800660:	53                   	push   %ebx
  800661:	56                   	push   %esi
  800662:	e8 9b fe ff ff       	call   800502 <printfmt>
  800667:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80066a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80066d:	e9 82 02 00 00       	jmp    8008f4 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	83 c0 04             	add    $0x4,%eax
  800678:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800680:	85 ff                	test   %edi,%edi
  800682:	b8 2e 10 80 00       	mov    $0x80102e,%eax
  800687:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80068a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80068e:	0f 8e bd 00 00 00    	jle    800751 <vprintfmt+0x232>
  800694:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800698:	75 0e                	jne    8006a8 <vprintfmt+0x189>
  80069a:	89 75 08             	mov    %esi,0x8(%ebp)
  80069d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006a0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006a3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006a6:	eb 6d                	jmp    800715 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	ff 75 d0             	pushl  -0x30(%ebp)
  8006ae:	57                   	push   %edi
  8006af:	e8 6e 03 00 00       	call   800a22 <strnlen>
  8006b4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006b7:	29 c1                	sub    %eax,%ecx
  8006b9:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8006bc:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006bf:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c6:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006c9:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cb:	eb 0f                	jmp    8006dc <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	53                   	push   %ebx
  8006d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d6:	83 ef 01             	sub    $0x1,%edi
  8006d9:	83 c4 10             	add    $0x10,%esp
  8006dc:	85 ff                	test   %edi,%edi
  8006de:	7f ed                	jg     8006cd <vprintfmt+0x1ae>
  8006e0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006e3:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006e6:	85 c9                	test   %ecx,%ecx
  8006e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ed:	0f 49 c1             	cmovns %ecx,%eax
  8006f0:	29 c1                	sub    %eax,%ecx
  8006f2:	89 75 08             	mov    %esi,0x8(%ebp)
  8006f5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006f8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006fb:	89 cb                	mov    %ecx,%ebx
  8006fd:	eb 16                	jmp    800715 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006ff:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800703:	75 31                	jne    800736 <vprintfmt+0x217>
					putch(ch, putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	50                   	push   %eax
  80070c:	ff 55 08             	call   *0x8(%ebp)
  80070f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800712:	83 eb 01             	sub    $0x1,%ebx
  800715:	83 c7 01             	add    $0x1,%edi
  800718:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80071c:	0f be c2             	movsbl %dl,%eax
  80071f:	85 c0                	test   %eax,%eax
  800721:	74 59                	je     80077c <vprintfmt+0x25d>
  800723:	85 f6                	test   %esi,%esi
  800725:	78 d8                	js     8006ff <vprintfmt+0x1e0>
  800727:	83 ee 01             	sub    $0x1,%esi
  80072a:	79 d3                	jns    8006ff <vprintfmt+0x1e0>
  80072c:	89 df                	mov    %ebx,%edi
  80072e:	8b 75 08             	mov    0x8(%ebp),%esi
  800731:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800734:	eb 37                	jmp    80076d <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800736:	0f be d2             	movsbl %dl,%edx
  800739:	83 ea 20             	sub    $0x20,%edx
  80073c:	83 fa 5e             	cmp    $0x5e,%edx
  80073f:	76 c4                	jbe    800705 <vprintfmt+0x1e6>
					putch('?', putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	ff 75 0c             	pushl  0xc(%ebp)
  800747:	6a 3f                	push   $0x3f
  800749:	ff 55 08             	call   *0x8(%ebp)
  80074c:	83 c4 10             	add    $0x10,%esp
  80074f:	eb c1                	jmp    800712 <vprintfmt+0x1f3>
  800751:	89 75 08             	mov    %esi,0x8(%ebp)
  800754:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800757:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80075a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80075d:	eb b6                	jmp    800715 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	53                   	push   %ebx
  800763:	6a 20                	push   $0x20
  800765:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800767:	83 ef 01             	sub    $0x1,%edi
  80076a:	83 c4 10             	add    $0x10,%esp
  80076d:	85 ff                	test   %edi,%edi
  80076f:	7f ee                	jg     80075f <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800771:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
  800777:	e9 78 01 00 00       	jmp    8008f4 <vprintfmt+0x3d5>
  80077c:	89 df                	mov    %ebx,%edi
  80077e:	8b 75 08             	mov    0x8(%ebp),%esi
  800781:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800784:	eb e7                	jmp    80076d <vprintfmt+0x24e>
	if (lflag >= 2)
  800786:	83 f9 01             	cmp    $0x1,%ecx
  800789:	7e 3f                	jle    8007ca <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8b 50 04             	mov    0x4(%eax),%edx
  800791:	8b 00                	mov    (%eax),%eax
  800793:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800796:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8d 40 08             	lea    0x8(%eax),%eax
  80079f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007a6:	79 5c                	jns    800804 <vprintfmt+0x2e5>
				putch('-', putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	53                   	push   %ebx
  8007ac:	6a 2d                	push   $0x2d
  8007ae:	ff d6                	call   *%esi
				num = -(long long) num;
  8007b0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007b3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007b6:	f7 da                	neg    %edx
  8007b8:	83 d1 00             	adc    $0x0,%ecx
  8007bb:	f7 d9                	neg    %ecx
  8007bd:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c5:	e9 10 01 00 00       	jmp    8008da <vprintfmt+0x3bb>
	else if (lflag)
  8007ca:	85 c9                	test   %ecx,%ecx
  8007cc:	75 1b                	jne    8007e9 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d6:	89 c1                	mov    %eax,%ecx
  8007d8:	c1 f9 1f             	sar    $0x1f,%ecx
  8007db:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8d 40 04             	lea    0x4(%eax),%eax
  8007e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e7:	eb b9                	jmp    8007a2 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f1:	89 c1                	mov    %eax,%ecx
  8007f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8007f6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8d 40 04             	lea    0x4(%eax),%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	eb 9e                	jmp    8007a2 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800804:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800807:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80080a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080f:	e9 c6 00 00 00       	jmp    8008da <vprintfmt+0x3bb>
	if (lflag >= 2)
  800814:	83 f9 01             	cmp    $0x1,%ecx
  800817:	7e 18                	jle    800831 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	8b 10                	mov    (%eax),%edx
  80081e:	8b 48 04             	mov    0x4(%eax),%ecx
  800821:	8d 40 08             	lea    0x8(%eax),%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800827:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082c:	e9 a9 00 00 00       	jmp    8008da <vprintfmt+0x3bb>
	else if (lflag)
  800831:	85 c9                	test   %ecx,%ecx
  800833:	75 1a                	jne    80084f <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	8b 10                	mov    (%eax),%edx
  80083a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80083f:	8d 40 04             	lea    0x4(%eax),%eax
  800842:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800845:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084a:	e9 8b 00 00 00       	jmp    8008da <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	8b 10                	mov    (%eax),%edx
  800854:	b9 00 00 00 00       	mov    $0x0,%ecx
  800859:	8d 40 04             	lea    0x4(%eax),%eax
  80085c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80085f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800864:	eb 74                	jmp    8008da <vprintfmt+0x3bb>
	if (lflag >= 2)
  800866:	83 f9 01             	cmp    $0x1,%ecx
  800869:	7e 15                	jle    800880 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8b 10                	mov    (%eax),%edx
  800870:	8b 48 04             	mov    0x4(%eax),%ecx
  800873:	8d 40 08             	lea    0x8(%eax),%eax
  800876:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800879:	b8 08 00 00 00       	mov    $0x8,%eax
  80087e:	eb 5a                	jmp    8008da <vprintfmt+0x3bb>
	else if (lflag)
  800880:	85 c9                	test   %ecx,%ecx
  800882:	75 17                	jne    80089b <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	8b 10                	mov    (%eax),%edx
  800889:	b9 00 00 00 00       	mov    $0x0,%ecx
  80088e:	8d 40 04             	lea    0x4(%eax),%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800894:	b8 08 00 00 00       	mov    $0x8,%eax
  800899:	eb 3f                	jmp    8008da <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	8b 10                	mov    (%eax),%edx
  8008a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008a5:	8d 40 04             	lea    0x4(%eax),%eax
  8008a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008ab:	b8 08 00 00 00       	mov    $0x8,%eax
  8008b0:	eb 28                	jmp    8008da <vprintfmt+0x3bb>
			putch('0', putdat);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	53                   	push   %ebx
  8008b6:	6a 30                	push   $0x30
  8008b8:	ff d6                	call   *%esi
			putch('x', putdat);
  8008ba:	83 c4 08             	add    $0x8,%esp
  8008bd:	53                   	push   %ebx
  8008be:	6a 78                	push   $0x78
  8008c0:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	8b 10                	mov    (%eax),%edx
  8008c7:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008cc:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008cf:	8d 40 04             	lea    0x4(%eax),%eax
  8008d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008da:	83 ec 0c             	sub    $0xc,%esp
  8008dd:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008e1:	57                   	push   %edi
  8008e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8008e5:	50                   	push   %eax
  8008e6:	51                   	push   %ecx
  8008e7:	52                   	push   %edx
  8008e8:	89 da                	mov    %ebx,%edx
  8008ea:	89 f0                	mov    %esi,%eax
  8008ec:	e8 45 fb ff ff       	call   800436 <printnum>
			break;
  8008f1:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  8008f7:	83 c7 01             	add    $0x1,%edi
  8008fa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008fe:	83 f8 25             	cmp    $0x25,%eax
  800901:	0f 84 2f fc ff ff    	je     800536 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  800907:	85 c0                	test   %eax,%eax
  800909:	0f 84 8b 00 00 00    	je     80099a <vprintfmt+0x47b>
			putch(ch, putdat);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	53                   	push   %ebx
  800913:	50                   	push   %eax
  800914:	ff d6                	call   *%esi
  800916:	83 c4 10             	add    $0x10,%esp
  800919:	eb dc                	jmp    8008f7 <vprintfmt+0x3d8>
	if (lflag >= 2)
  80091b:	83 f9 01             	cmp    $0x1,%ecx
  80091e:	7e 15                	jle    800935 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	8b 10                	mov    (%eax),%edx
  800925:	8b 48 04             	mov    0x4(%eax),%ecx
  800928:	8d 40 08             	lea    0x8(%eax),%eax
  80092b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80092e:	b8 10 00 00 00       	mov    $0x10,%eax
  800933:	eb a5                	jmp    8008da <vprintfmt+0x3bb>
	else if (lflag)
  800935:	85 c9                	test   %ecx,%ecx
  800937:	75 17                	jne    800950 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	8b 10                	mov    (%eax),%edx
  80093e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800943:	8d 40 04             	lea    0x4(%eax),%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800949:	b8 10 00 00 00       	mov    $0x10,%eax
  80094e:	eb 8a                	jmp    8008da <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	8b 10                	mov    (%eax),%edx
  800955:	b9 00 00 00 00       	mov    $0x0,%ecx
  80095a:	8d 40 04             	lea    0x4(%eax),%eax
  80095d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800960:	b8 10 00 00 00       	mov    $0x10,%eax
  800965:	e9 70 ff ff ff       	jmp    8008da <vprintfmt+0x3bb>
			putch(ch, putdat);
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	53                   	push   %ebx
  80096e:	6a 25                	push   $0x25
  800970:	ff d6                	call   *%esi
			break;
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	e9 7a ff ff ff       	jmp    8008f4 <vprintfmt+0x3d5>
			putch('%', putdat);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	53                   	push   %ebx
  80097e:	6a 25                	push   $0x25
  800980:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	89 f8                	mov    %edi,%eax
  800987:	eb 03                	jmp    80098c <vprintfmt+0x46d>
  800989:	83 e8 01             	sub    $0x1,%eax
  80098c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800990:	75 f7                	jne    800989 <vprintfmt+0x46a>
  800992:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800995:	e9 5a ff ff ff       	jmp    8008f4 <vprintfmt+0x3d5>
}
  80099a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80099d:	5b                   	pop    %ebx
  80099e:	5e                   	pop    %esi
  80099f:	5f                   	pop    %edi
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	83 ec 18             	sub    $0x18,%esp
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009b1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009b5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009bf:	85 c0                	test   %eax,%eax
  8009c1:	74 26                	je     8009e9 <vsnprintf+0x47>
  8009c3:	85 d2                	test   %edx,%edx
  8009c5:	7e 22                	jle    8009e9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009c7:	ff 75 14             	pushl  0x14(%ebp)
  8009ca:	ff 75 10             	pushl  0x10(%ebp)
  8009cd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009d0:	50                   	push   %eax
  8009d1:	68 e5 04 80 00       	push   $0x8004e5
  8009d6:	e8 44 fb ff ff       	call   80051f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009de:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e4:	83 c4 10             	add    $0x10,%esp
}
  8009e7:	c9                   	leave  
  8009e8:	c3                   	ret    
		return -E_INVAL;
  8009e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009ee:	eb f7                	jmp    8009e7 <vsnprintf+0x45>

008009f0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009f6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009f9:	50                   	push   %eax
  8009fa:	ff 75 10             	pushl  0x10(%ebp)
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	ff 75 08             	pushl  0x8(%ebp)
  800a03:	e8 9a ff ff ff       	call   8009a2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a10:	b8 00 00 00 00       	mov    $0x0,%eax
  800a15:	eb 03                	jmp    800a1a <strlen+0x10>
		n++;
  800a17:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a1a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a1e:	75 f7                	jne    800a17 <strlen+0xd>
	return n;
}
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a28:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a30:	eb 03                	jmp    800a35 <strnlen+0x13>
		n++;
  800a32:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a35:	39 d0                	cmp    %edx,%eax
  800a37:	74 06                	je     800a3f <strnlen+0x1d>
  800a39:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a3d:	75 f3                	jne    800a32 <strnlen+0x10>
	return n;
}
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    

00800a41 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	53                   	push   %ebx
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a4b:	89 c2                	mov    %eax,%edx
  800a4d:	83 c1 01             	add    $0x1,%ecx
  800a50:	83 c2 01             	add    $0x1,%edx
  800a53:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a57:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a5a:	84 db                	test   %bl,%bl
  800a5c:	75 ef                	jne    800a4d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a5e:	5b                   	pop    %ebx
  800a5f:	5d                   	pop    %ebp
  800a60:	c3                   	ret    

00800a61 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	53                   	push   %ebx
  800a65:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a68:	53                   	push   %ebx
  800a69:	e8 9c ff ff ff       	call   800a0a <strlen>
  800a6e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	01 d8                	add    %ebx,%eax
  800a76:	50                   	push   %eax
  800a77:	e8 c5 ff ff ff       	call   800a41 <strcpy>
	return dst;
}
  800a7c:	89 d8                	mov    %ebx,%eax
  800a7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a81:	c9                   	leave  
  800a82:	c3                   	ret    

00800a83 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	56                   	push   %esi
  800a87:	53                   	push   %ebx
  800a88:	8b 75 08             	mov    0x8(%ebp),%esi
  800a8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a8e:	89 f3                	mov    %esi,%ebx
  800a90:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a93:	89 f2                	mov    %esi,%edx
  800a95:	eb 0f                	jmp    800aa6 <strncpy+0x23>
		*dst++ = *src;
  800a97:	83 c2 01             	add    $0x1,%edx
  800a9a:	0f b6 01             	movzbl (%ecx),%eax
  800a9d:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa0:	80 39 01             	cmpb   $0x1,(%ecx)
  800aa3:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800aa6:	39 da                	cmp    %ebx,%edx
  800aa8:	75 ed                	jne    800a97 <strncpy+0x14>
	}
	return ret;
}
  800aaa:	89 f0                	mov    %esi,%eax
  800aac:	5b                   	pop    %ebx
  800aad:	5e                   	pop    %esi
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    

00800ab0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	56                   	push   %esi
  800ab4:	53                   	push   %ebx
  800ab5:	8b 75 08             	mov    0x8(%ebp),%esi
  800ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800abe:	89 f0                	mov    %esi,%eax
  800ac0:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac4:	85 c9                	test   %ecx,%ecx
  800ac6:	75 0b                	jne    800ad3 <strlcpy+0x23>
  800ac8:	eb 17                	jmp    800ae1 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800aca:	83 c2 01             	add    $0x1,%edx
  800acd:	83 c0 01             	add    $0x1,%eax
  800ad0:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ad3:	39 d8                	cmp    %ebx,%eax
  800ad5:	74 07                	je     800ade <strlcpy+0x2e>
  800ad7:	0f b6 0a             	movzbl (%edx),%ecx
  800ada:	84 c9                	test   %cl,%cl
  800adc:	75 ec                	jne    800aca <strlcpy+0x1a>
		*dst = '\0';
  800ade:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae1:	29 f0                	sub    %esi,%eax
}
  800ae3:	5b                   	pop    %ebx
  800ae4:	5e                   	pop    %esi
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aed:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800af0:	eb 06                	jmp    800af8 <strcmp+0x11>
		p++, q++;
  800af2:	83 c1 01             	add    $0x1,%ecx
  800af5:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800af8:	0f b6 01             	movzbl (%ecx),%eax
  800afb:	84 c0                	test   %al,%al
  800afd:	74 04                	je     800b03 <strcmp+0x1c>
  800aff:	3a 02                	cmp    (%edx),%al
  800b01:	74 ef                	je     800af2 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b03:	0f b6 c0             	movzbl %al,%eax
  800b06:	0f b6 12             	movzbl (%edx),%edx
  800b09:	29 d0                	sub    %edx,%eax
}
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	53                   	push   %ebx
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b17:	89 c3                	mov    %eax,%ebx
  800b19:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b1c:	eb 06                	jmp    800b24 <strncmp+0x17>
		n--, p++, q++;
  800b1e:	83 c0 01             	add    $0x1,%eax
  800b21:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b24:	39 d8                	cmp    %ebx,%eax
  800b26:	74 16                	je     800b3e <strncmp+0x31>
  800b28:	0f b6 08             	movzbl (%eax),%ecx
  800b2b:	84 c9                	test   %cl,%cl
  800b2d:	74 04                	je     800b33 <strncmp+0x26>
  800b2f:	3a 0a                	cmp    (%edx),%cl
  800b31:	74 eb                	je     800b1e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b33:	0f b6 00             	movzbl (%eax),%eax
  800b36:	0f b6 12             	movzbl (%edx),%edx
  800b39:	29 d0                	sub    %edx,%eax
}
  800b3b:	5b                   	pop    %ebx
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    
		return 0;
  800b3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b43:	eb f6                	jmp    800b3b <strncmp+0x2e>

00800b45 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b4f:	0f b6 10             	movzbl (%eax),%edx
  800b52:	84 d2                	test   %dl,%dl
  800b54:	74 09                	je     800b5f <strchr+0x1a>
		if (*s == c)
  800b56:	38 ca                	cmp    %cl,%dl
  800b58:	74 0a                	je     800b64 <strchr+0x1f>
	for (; *s; s++)
  800b5a:	83 c0 01             	add    $0x1,%eax
  800b5d:	eb f0                	jmp    800b4f <strchr+0xa>
			return (char *) s;
	return 0;
  800b5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b70:	eb 03                	jmp    800b75 <strfind+0xf>
  800b72:	83 c0 01             	add    $0x1,%eax
  800b75:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b78:	38 ca                	cmp    %cl,%dl
  800b7a:	74 04                	je     800b80 <strfind+0x1a>
  800b7c:	84 d2                	test   %dl,%dl
  800b7e:	75 f2                	jne    800b72 <strfind+0xc>
			break;
	return (char *) s;
}
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	57                   	push   %edi
  800b86:	56                   	push   %esi
  800b87:	53                   	push   %ebx
  800b88:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b8e:	85 c9                	test   %ecx,%ecx
  800b90:	74 13                	je     800ba5 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b92:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b98:	75 05                	jne    800b9f <memset+0x1d>
  800b9a:	f6 c1 03             	test   $0x3,%cl
  800b9d:	74 0d                	je     800bac <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	fc                   	cld    
  800ba3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ba5:	89 f8                	mov    %edi,%eax
  800ba7:	5b                   	pop    %ebx
  800ba8:	5e                   	pop    %esi
  800ba9:	5f                   	pop    %edi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    
		c &= 0xFF;
  800bac:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb0:	89 d3                	mov    %edx,%ebx
  800bb2:	c1 e3 08             	shl    $0x8,%ebx
  800bb5:	89 d0                	mov    %edx,%eax
  800bb7:	c1 e0 18             	shl    $0x18,%eax
  800bba:	89 d6                	mov    %edx,%esi
  800bbc:	c1 e6 10             	shl    $0x10,%esi
  800bbf:	09 f0                	or     %esi,%eax
  800bc1:	09 c2                	or     %eax,%edx
  800bc3:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bc5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bc8:	89 d0                	mov    %edx,%eax
  800bca:	fc                   	cld    
  800bcb:	f3 ab                	rep stos %eax,%es:(%edi)
  800bcd:	eb d6                	jmp    800ba5 <memset+0x23>

00800bcf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	57                   	push   %edi
  800bd3:	56                   	push   %esi
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bda:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bdd:	39 c6                	cmp    %eax,%esi
  800bdf:	73 35                	jae    800c16 <memmove+0x47>
  800be1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800be4:	39 c2                	cmp    %eax,%edx
  800be6:	76 2e                	jbe    800c16 <memmove+0x47>
		s += n;
		d += n;
  800be8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800beb:	89 d6                	mov    %edx,%esi
  800bed:	09 fe                	or     %edi,%esi
  800bef:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bf5:	74 0c                	je     800c03 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bf7:	83 ef 01             	sub    $0x1,%edi
  800bfa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bfd:	fd                   	std    
  800bfe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c00:	fc                   	cld    
  800c01:	eb 21                	jmp    800c24 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c03:	f6 c1 03             	test   $0x3,%cl
  800c06:	75 ef                	jne    800bf7 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c08:	83 ef 04             	sub    $0x4,%edi
  800c0b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c0e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c11:	fd                   	std    
  800c12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c14:	eb ea                	jmp    800c00 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c16:	89 f2                	mov    %esi,%edx
  800c18:	09 c2                	or     %eax,%edx
  800c1a:	f6 c2 03             	test   $0x3,%dl
  800c1d:	74 09                	je     800c28 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c1f:	89 c7                	mov    %eax,%edi
  800c21:	fc                   	cld    
  800c22:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c24:	5e                   	pop    %esi
  800c25:	5f                   	pop    %edi
  800c26:	5d                   	pop    %ebp
  800c27:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c28:	f6 c1 03             	test   $0x3,%cl
  800c2b:	75 f2                	jne    800c1f <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c2d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c30:	89 c7                	mov    %eax,%edi
  800c32:	fc                   	cld    
  800c33:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c35:	eb ed                	jmp    800c24 <memmove+0x55>

00800c37 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c3a:	ff 75 10             	pushl  0x10(%ebp)
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	ff 75 08             	pushl  0x8(%ebp)
  800c43:	e8 87 ff ff ff       	call   800bcf <memmove>
}
  800c48:	c9                   	leave  
  800c49:	c3                   	ret    

00800c4a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c55:	89 c6                	mov    %eax,%esi
  800c57:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c5a:	39 f0                	cmp    %esi,%eax
  800c5c:	74 1c                	je     800c7a <memcmp+0x30>
		if (*s1 != *s2)
  800c5e:	0f b6 08             	movzbl (%eax),%ecx
  800c61:	0f b6 1a             	movzbl (%edx),%ebx
  800c64:	38 d9                	cmp    %bl,%cl
  800c66:	75 08                	jne    800c70 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c68:	83 c0 01             	add    $0x1,%eax
  800c6b:	83 c2 01             	add    $0x1,%edx
  800c6e:	eb ea                	jmp    800c5a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c70:	0f b6 c1             	movzbl %cl,%eax
  800c73:	0f b6 db             	movzbl %bl,%ebx
  800c76:	29 d8                	sub    %ebx,%eax
  800c78:	eb 05                	jmp    800c7f <memcmp+0x35>
	}

	return 0;
  800c7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c8c:	89 c2                	mov    %eax,%edx
  800c8e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c91:	39 d0                	cmp    %edx,%eax
  800c93:	73 09                	jae    800c9e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c95:	38 08                	cmp    %cl,(%eax)
  800c97:	74 05                	je     800c9e <memfind+0x1b>
	for (; s < ends; s++)
  800c99:	83 c0 01             	add    $0x1,%eax
  800c9c:	eb f3                	jmp    800c91 <memfind+0xe>
			break;
	return (void *) s;
}
  800c9e:	5d                   	pop    %ebp
  800c9f:	c3                   	ret    

00800ca0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	57                   	push   %edi
  800ca4:	56                   	push   %esi
  800ca5:	53                   	push   %ebx
  800ca6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cac:	eb 03                	jmp    800cb1 <strtol+0x11>
		s++;
  800cae:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cb1:	0f b6 01             	movzbl (%ecx),%eax
  800cb4:	3c 20                	cmp    $0x20,%al
  800cb6:	74 f6                	je     800cae <strtol+0xe>
  800cb8:	3c 09                	cmp    $0x9,%al
  800cba:	74 f2                	je     800cae <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cbc:	3c 2b                	cmp    $0x2b,%al
  800cbe:	74 2e                	je     800cee <strtol+0x4e>
	int neg = 0;
  800cc0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cc5:	3c 2d                	cmp    $0x2d,%al
  800cc7:	74 2f                	je     800cf8 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ccf:	75 05                	jne    800cd6 <strtol+0x36>
  800cd1:	80 39 30             	cmpb   $0x30,(%ecx)
  800cd4:	74 2c                	je     800d02 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cd6:	85 db                	test   %ebx,%ebx
  800cd8:	75 0a                	jne    800ce4 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cda:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cdf:	80 39 30             	cmpb   $0x30,(%ecx)
  800ce2:	74 28                	je     800d0c <strtol+0x6c>
		base = 10;
  800ce4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cec:	eb 50                	jmp    800d3e <strtol+0x9e>
		s++;
  800cee:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cf1:	bf 00 00 00 00       	mov    $0x0,%edi
  800cf6:	eb d1                	jmp    800cc9 <strtol+0x29>
		s++, neg = 1;
  800cf8:	83 c1 01             	add    $0x1,%ecx
  800cfb:	bf 01 00 00 00       	mov    $0x1,%edi
  800d00:	eb c7                	jmp    800cc9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d02:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d06:	74 0e                	je     800d16 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d08:	85 db                	test   %ebx,%ebx
  800d0a:	75 d8                	jne    800ce4 <strtol+0x44>
		s++, base = 8;
  800d0c:	83 c1 01             	add    $0x1,%ecx
  800d0f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d14:	eb ce                	jmp    800ce4 <strtol+0x44>
		s += 2, base = 16;
  800d16:	83 c1 02             	add    $0x2,%ecx
  800d19:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d1e:	eb c4                	jmp    800ce4 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d20:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d23:	89 f3                	mov    %esi,%ebx
  800d25:	80 fb 19             	cmp    $0x19,%bl
  800d28:	77 29                	ja     800d53 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d2a:	0f be d2             	movsbl %dl,%edx
  800d2d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d30:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d33:	7d 30                	jge    800d65 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d35:	83 c1 01             	add    $0x1,%ecx
  800d38:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d3c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d3e:	0f b6 11             	movzbl (%ecx),%edx
  800d41:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d44:	89 f3                	mov    %esi,%ebx
  800d46:	80 fb 09             	cmp    $0x9,%bl
  800d49:	77 d5                	ja     800d20 <strtol+0x80>
			dig = *s - '0';
  800d4b:	0f be d2             	movsbl %dl,%edx
  800d4e:	83 ea 30             	sub    $0x30,%edx
  800d51:	eb dd                	jmp    800d30 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d53:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d56:	89 f3                	mov    %esi,%ebx
  800d58:	80 fb 19             	cmp    $0x19,%bl
  800d5b:	77 08                	ja     800d65 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d5d:	0f be d2             	movsbl %dl,%edx
  800d60:	83 ea 37             	sub    $0x37,%edx
  800d63:	eb cb                	jmp    800d30 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d69:	74 05                	je     800d70 <strtol+0xd0>
		*endptr = (char *) s;
  800d6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d6e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d70:	89 c2                	mov    %eax,%edx
  800d72:	f7 da                	neg    %edx
  800d74:	85 ff                	test   %edi,%edi
  800d76:	0f 45 c2             	cmovne %edx,%eax
}
  800d79:	5b                   	pop    %ebx
  800d7a:	5e                   	pop    %esi
  800d7b:	5f                   	pop    %edi
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    
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
