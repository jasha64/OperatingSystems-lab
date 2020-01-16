
obj/user/faultnostack.debug：     文件格式 elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 59 03 80 00       	push   $0x800359
  80003e:	6a 00                	push   $0x0
  800040:	e8 6e 02 00 00       	call   8002b3 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	56                   	push   %esi
  800058:	53                   	push   %ebx
  800059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  80005f:	e8 c6 00 00 00       	call   80012a <sys_getenvid>
	thisenv = envs + ENVX(envid);
  800064:	25 ff 03 00 00       	and    $0x3ff,%eax
  800069:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800071:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800076:	85 db                	test   %ebx,%ebx
  800078:	7e 07                	jle    800081 <libmain+0x2d>
		binaryname = argv[0];
  80007a:	8b 06                	mov    (%esi),%eax
  80007c:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800081:	83 ec 08             	sub    $0x8,%esp
  800084:	56                   	push   %esi
  800085:	53                   	push   %ebx
  800086:	e8 a8 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008b:	e8 0a 00 00 00       	call   80009a <exit>
}
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5d                   	pop    %ebp
  800099:	c3                   	ret    

0080009a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 42 00 00 00       	call   8000e9 <sys_env_destroy>
}
  8000a7:	83 c4 10             	add    $0x10,%esp
  8000aa:	c9                   	leave  
  8000ab:	c3                   	ret    

008000ac <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ac:	55                   	push   %ebp
  8000ad:	89 e5                	mov    %esp,%ebp
  8000af:	57                   	push   %edi
  8000b0:	56                   	push   %esi
  8000b1:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bd:	89 c3                	mov    %eax,%ebx
  8000bf:	89 c7                	mov    %eax,%edi
  8000c1:	89 c6                	mov    %eax,%esi
  8000c3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c5:	5b                   	pop    %ebx
  8000c6:	5e                   	pop    %esi
  8000c7:	5f                   	pop    %edi
  8000c8:	5d                   	pop    %ebp
  8000c9:	c3                   	ret    

008000ca <sys_cgetc>:

int
sys_cgetc(void)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	57                   	push   %edi
  8000ce:	56                   	push   %esi
  8000cf:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8000da:	89 d1                	mov    %edx,%ecx
  8000dc:	89 d3                	mov    %edx,%ebx
  8000de:	89 d7                	mov    %edx,%edi
  8000e0:	89 d6                	mov    %edx,%esi
  8000e2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e4:	5b                   	pop    %ebx
  8000e5:	5e                   	pop    %esi
  8000e6:	5f                   	pop    %edi
  8000e7:	5d                   	pop    %ebp
  8000e8:	c3                   	ret    

008000e9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8000f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fa:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ff:	89 cb                	mov    %ecx,%ebx
  800101:	89 cf                	mov    %ecx,%edi
  800103:	89 ce                	mov    %ecx,%esi
  800105:	cd 30                	int    $0x30
	if(check && ret > 0)
  800107:	85 c0                	test   %eax,%eax
  800109:	7f 08                	jg     800113 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010e:	5b                   	pop    %ebx
  80010f:	5e                   	pop    %esi
  800110:	5f                   	pop    %edi
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	50                   	push   %eax
  800117:	6a 03                	push   $0x3
  800119:	68 6a 10 80 00       	push   $0x80106a
  80011e:	6a 23                	push   $0x23
  800120:	68 87 10 80 00       	push   $0x801087
  800125:	e8 53 02 00 00       	call   80037d <_panic>

0080012a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	57                   	push   %edi
  80012e:	56                   	push   %esi
  80012f:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800130:	ba 00 00 00 00       	mov    $0x0,%edx
  800135:	b8 02 00 00 00       	mov    $0x2,%eax
  80013a:	89 d1                	mov    %edx,%ecx
  80013c:	89 d3                	mov    %edx,%ebx
  80013e:	89 d7                	mov    %edx,%edi
  800140:	89 d6                	mov    %edx,%esi
  800142:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800144:	5b                   	pop    %ebx
  800145:	5e                   	pop    %esi
  800146:	5f                   	pop    %edi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    

00800149 <sys_yield>:

void
sys_yield(void)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	57                   	push   %edi
  80014d:	56                   	push   %esi
  80014e:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80014f:	ba 00 00 00 00       	mov    $0x0,%edx
  800154:	b8 0b 00 00 00       	mov    $0xb,%eax
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	89 d3                	mov    %edx,%ebx
  80015d:	89 d7                	mov    %edx,%edi
  80015f:	89 d6                	mov    %edx,%esi
  800161:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800163:	5b                   	pop    %ebx
  800164:	5e                   	pop    %esi
  800165:	5f                   	pop    %edi
  800166:	5d                   	pop    %ebp
  800167:	c3                   	ret    

00800168 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	57                   	push   %edi
  80016c:	56                   	push   %esi
  80016d:	53                   	push   %ebx
  80016e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800171:	be 00 00 00 00       	mov    $0x0,%esi
  800176:	8b 55 08             	mov    0x8(%ebp),%edx
  800179:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80017c:	b8 04 00 00 00       	mov    $0x4,%eax
  800181:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800184:	89 f7                	mov    %esi,%edi
  800186:	cd 30                	int    $0x30
	if(check && ret > 0)
  800188:	85 c0                	test   %eax,%eax
  80018a:	7f 08                	jg     800194 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80018c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80018f:	5b                   	pop    %ebx
  800190:	5e                   	pop    %esi
  800191:	5f                   	pop    %edi
  800192:	5d                   	pop    %ebp
  800193:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800194:	83 ec 0c             	sub    $0xc,%esp
  800197:	50                   	push   %eax
  800198:	6a 04                	push   $0x4
  80019a:	68 6a 10 80 00       	push   $0x80106a
  80019f:	6a 23                	push   $0x23
  8001a1:	68 87 10 80 00       	push   $0x801087
  8001a6:	e8 d2 01 00 00       	call   80037d <_panic>

008001ab <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	57                   	push   %edi
  8001af:	56                   	push   %esi
  8001b0:	53                   	push   %ebx
  8001b1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8001b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ba:	b8 05 00 00 00       	mov    $0x5,%eax
  8001bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c5:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ca:	85 c0                	test   %eax,%eax
  8001cc:	7f 08                	jg     8001d6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d1:	5b                   	pop    %ebx
  8001d2:	5e                   	pop    %esi
  8001d3:	5f                   	pop    %edi
  8001d4:	5d                   	pop    %ebp
  8001d5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	50                   	push   %eax
  8001da:	6a 05                	push   $0x5
  8001dc:	68 6a 10 80 00       	push   $0x80106a
  8001e1:	6a 23                	push   $0x23
  8001e3:	68 87 10 80 00       	push   $0x801087
  8001e8:	e8 90 01 00 00       	call   80037d <_panic>

008001ed <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	57                   	push   %edi
  8001f1:	56                   	push   %esi
  8001f2:	53                   	push   %ebx
  8001f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8001f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800201:	b8 06 00 00 00       	mov    $0x6,%eax
  800206:	89 df                	mov    %ebx,%edi
  800208:	89 de                	mov    %ebx,%esi
  80020a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80020c:	85 c0                	test   %eax,%eax
  80020e:	7f 08                	jg     800218 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800213:	5b                   	pop    %ebx
  800214:	5e                   	pop    %esi
  800215:	5f                   	pop    %edi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	50                   	push   %eax
  80021c:	6a 06                	push   $0x6
  80021e:	68 6a 10 80 00       	push   $0x80106a
  800223:	6a 23                	push   $0x23
  800225:	68 87 10 80 00       	push   $0x801087
  80022a:	e8 4e 01 00 00       	call   80037d <_panic>

0080022f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	57                   	push   %edi
  800233:	56                   	push   %esi
  800234:	53                   	push   %ebx
  800235:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800238:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023d:	8b 55 08             	mov    0x8(%ebp),%edx
  800240:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800243:	b8 08 00 00 00       	mov    $0x8,%eax
  800248:	89 df                	mov    %ebx,%edi
  80024a:	89 de                	mov    %ebx,%esi
  80024c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80024e:	85 c0                	test   %eax,%eax
  800250:	7f 08                	jg     80025a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800252:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800255:	5b                   	pop    %ebx
  800256:	5e                   	pop    %esi
  800257:	5f                   	pop    %edi
  800258:	5d                   	pop    %ebp
  800259:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80025a:	83 ec 0c             	sub    $0xc,%esp
  80025d:	50                   	push   %eax
  80025e:	6a 08                	push   $0x8
  800260:	68 6a 10 80 00       	push   $0x80106a
  800265:	6a 23                	push   $0x23
  800267:	68 87 10 80 00       	push   $0x801087
  80026c:	e8 0c 01 00 00       	call   80037d <_panic>

00800271 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	57                   	push   %edi
  800275:	56                   	push   %esi
  800276:	53                   	push   %ebx
  800277:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80027a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80027f:	8b 55 08             	mov    0x8(%ebp),%edx
  800282:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800285:	b8 09 00 00 00       	mov    $0x9,%eax
  80028a:	89 df                	mov    %ebx,%edi
  80028c:	89 de                	mov    %ebx,%esi
  80028e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800290:	85 c0                	test   %eax,%eax
  800292:	7f 08                	jg     80029c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800294:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800297:	5b                   	pop    %ebx
  800298:	5e                   	pop    %esi
  800299:	5f                   	pop    %edi
  80029a:	5d                   	pop    %ebp
  80029b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	50                   	push   %eax
  8002a0:	6a 09                	push   $0x9
  8002a2:	68 6a 10 80 00       	push   $0x80106a
  8002a7:	6a 23                	push   $0x23
  8002a9:	68 87 10 80 00       	push   $0x801087
  8002ae:	e8 ca 00 00 00       	call   80037d <_panic>

008002b3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	57                   	push   %edi
  8002b7:	56                   	push   %esi
  8002b8:	53                   	push   %ebx
  8002b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002cc:	89 df                	mov    %ebx,%edi
  8002ce:	89 de                	mov    %ebx,%esi
  8002d0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d2:	85 c0                	test   %eax,%eax
  8002d4:	7f 08                	jg     8002de <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d9:	5b                   	pop    %ebx
  8002da:	5e                   	pop    %esi
  8002db:	5f                   	pop    %edi
  8002dc:	5d                   	pop    %ebp
  8002dd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	50                   	push   %eax
  8002e2:	6a 0a                	push   $0xa
  8002e4:	68 6a 10 80 00       	push   $0x80106a
  8002e9:	6a 23                	push   $0x23
  8002eb:	68 87 10 80 00       	push   $0x801087
  8002f0:	e8 88 00 00 00       	call   80037d <_panic>

008002f5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	57                   	push   %edi
  8002f9:	56                   	push   %esi
  8002fa:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8002fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800301:	b8 0c 00 00 00       	mov    $0xc,%eax
  800306:	be 00 00 00 00       	mov    $0x0,%esi
  80030b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80030e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800311:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800313:	5b                   	pop    %ebx
  800314:	5e                   	pop    %esi
  800315:	5f                   	pop    %edi
  800316:	5d                   	pop    %ebp
  800317:	c3                   	ret    

00800318 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	57                   	push   %edi
  80031c:	56                   	push   %esi
  80031d:	53                   	push   %ebx
  80031e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800321:	b9 00 00 00 00       	mov    $0x0,%ecx
  800326:	8b 55 08             	mov    0x8(%ebp),%edx
  800329:	b8 0d 00 00 00       	mov    $0xd,%eax
  80032e:	89 cb                	mov    %ecx,%ebx
  800330:	89 cf                	mov    %ecx,%edi
  800332:	89 ce                	mov    %ecx,%esi
  800334:	cd 30                	int    $0x30
	if(check && ret > 0)
  800336:	85 c0                	test   %eax,%eax
  800338:	7f 08                	jg     800342 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80033a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033d:	5b                   	pop    %ebx
  80033e:	5e                   	pop    %esi
  80033f:	5f                   	pop    %edi
  800340:	5d                   	pop    %ebp
  800341:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800342:	83 ec 0c             	sub    $0xc,%esp
  800345:	50                   	push   %eax
  800346:	6a 0d                	push   $0xd
  800348:	68 6a 10 80 00       	push   $0x80106a
  80034d:	6a 23                	push   $0x23
  80034f:	68 87 10 80 00       	push   $0x801087
  800354:	e8 24 00 00 00       	call   80037d <_panic>

00800359 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800359:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80035a:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax				//调用页处理函数
  80035f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800361:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp			//跳过utf_fault_va和utf_err
  800364:	83 c4 08             	add    $0x8,%esp
	movl 40(%esp), %eax 	//保存中断发生时的esp到eax
  800367:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl 32(%esp), %ecx 	//保存终端发生时的eip到ecx
  80036b:	8b 4c 24 20          	mov    0x20(%esp),%ecx
	movl %ecx, -4(%eax) 	//将中断发生时的esp值亚入到到原来的栈中
  80036f:	89 48 fc             	mov    %ecx,-0x4(%eax)
	popal
  800372:	61                   	popa   
	addl $4, %esp			//跳过eip
  800373:	83 c4 04             	add    $0x4,%esp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  800376:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800377:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	lea -4(%esp), %esp		//因为之前压入了eip的值但是没有减esp的值，所以现在需要将esp寄存器中的值减4
  800378:	8d 64 24 fc          	lea    -0x4(%esp),%esp
  80037c:	c3                   	ret    

0080037d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	56                   	push   %esi
  800381:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800382:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800385:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80038b:	e8 9a fd ff ff       	call   80012a <sys_getenvid>
  800390:	83 ec 0c             	sub    $0xc,%esp
  800393:	ff 75 0c             	pushl  0xc(%ebp)
  800396:	ff 75 08             	pushl  0x8(%ebp)
  800399:	56                   	push   %esi
  80039a:	50                   	push   %eax
  80039b:	68 98 10 80 00       	push   $0x801098
  8003a0:	e8 b3 00 00 00       	call   800458 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003a5:	83 c4 18             	add    $0x18,%esp
  8003a8:	53                   	push   %ebx
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	e8 56 00 00 00       	call   800407 <vcprintf>
	cprintf("\n");
  8003b1:	c7 04 24 bb 10 80 00 	movl   $0x8010bb,(%esp)
  8003b8:	e8 9b 00 00 00       	call   800458 <cprintf>
  8003bd:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003c0:	cc                   	int3   
  8003c1:	eb fd                	jmp    8003c0 <_panic+0x43>

008003c3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	53                   	push   %ebx
  8003c7:	83 ec 04             	sub    $0x4,%esp
  8003ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003cd:	8b 13                	mov    (%ebx),%edx
  8003cf:	8d 42 01             	lea    0x1(%edx),%eax
  8003d2:	89 03                	mov    %eax,(%ebx)
  8003d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003db:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e0:	74 09                	je     8003eb <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003e2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003e9:	c9                   	leave  
  8003ea:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	68 ff 00 00 00       	push   $0xff
  8003f3:	8d 43 08             	lea    0x8(%ebx),%eax
  8003f6:	50                   	push   %eax
  8003f7:	e8 b0 fc ff ff       	call   8000ac <sys_cputs>
		b->idx = 0;
  8003fc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800402:	83 c4 10             	add    $0x10,%esp
  800405:	eb db                	jmp    8003e2 <putch+0x1f>

00800407 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800410:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800417:	00 00 00 
	b.cnt = 0;
  80041a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800421:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800424:	ff 75 0c             	pushl  0xc(%ebp)
  800427:	ff 75 08             	pushl  0x8(%ebp)
  80042a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800430:	50                   	push   %eax
  800431:	68 c3 03 80 00       	push   $0x8003c3
  800436:	e8 1a 01 00 00       	call   800555 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80043b:	83 c4 08             	add    $0x8,%esp
  80043e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800444:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80044a:	50                   	push   %eax
  80044b:	e8 5c fc ff ff       	call   8000ac <sys_cputs>

	return b.cnt;
}
  800450:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800456:	c9                   	leave  
  800457:	c3                   	ret    

00800458 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
  80045b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80045e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800461:	50                   	push   %eax
  800462:	ff 75 08             	pushl  0x8(%ebp)
  800465:	e8 9d ff ff ff       	call   800407 <vcprintf>
	va_end(ap);

	return cnt;
}
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	57                   	push   %edi
  800470:	56                   	push   %esi
  800471:	53                   	push   %ebx
  800472:	83 ec 1c             	sub    $0x1c,%esp
  800475:	89 c7                	mov    %eax,%edi
  800477:	89 d6                	mov    %edx,%esi
  800479:	8b 45 08             	mov    0x8(%ebp),%eax
  80047c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800482:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800485:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800488:	bb 00 00 00 00       	mov    $0x0,%ebx
  80048d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800490:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800493:	39 d3                	cmp    %edx,%ebx
  800495:	72 05                	jb     80049c <printnum+0x30>
  800497:	39 45 10             	cmp    %eax,0x10(%ebp)
  80049a:	77 7a                	ja     800516 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80049c:	83 ec 0c             	sub    $0xc,%esp
  80049f:	ff 75 18             	pushl  0x18(%ebp)
  8004a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004a8:	53                   	push   %ebx
  8004a9:	ff 75 10             	pushl  0x10(%ebp)
  8004ac:	83 ec 08             	sub    $0x8,%esp
  8004af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8004b8:	ff 75 d8             	pushl  -0x28(%ebp)
  8004bb:	e8 50 09 00 00       	call   800e10 <__udivdi3>
  8004c0:	83 c4 18             	add    $0x18,%esp
  8004c3:	52                   	push   %edx
  8004c4:	50                   	push   %eax
  8004c5:	89 f2                	mov    %esi,%edx
  8004c7:	89 f8                	mov    %edi,%eax
  8004c9:	e8 9e ff ff ff       	call   80046c <printnum>
  8004ce:	83 c4 20             	add    $0x20,%esp
  8004d1:	eb 13                	jmp    8004e6 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	56                   	push   %esi
  8004d7:	ff 75 18             	pushl  0x18(%ebp)
  8004da:	ff d7                	call   *%edi
  8004dc:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004df:	83 eb 01             	sub    $0x1,%ebx
  8004e2:	85 db                	test   %ebx,%ebx
  8004e4:	7f ed                	jg     8004d3 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	56                   	push   %esi
  8004ea:	83 ec 04             	sub    $0x4,%esp
  8004ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f3:	ff 75 dc             	pushl  -0x24(%ebp)
  8004f6:	ff 75 d8             	pushl  -0x28(%ebp)
  8004f9:	e8 32 0a 00 00       	call   800f30 <__umoddi3>
  8004fe:	83 c4 14             	add    $0x14,%esp
  800501:	0f be 80 bd 10 80 00 	movsbl 0x8010bd(%eax),%eax
  800508:	50                   	push   %eax
  800509:	ff d7                	call   *%edi
}
  80050b:	83 c4 10             	add    $0x10,%esp
  80050e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800511:	5b                   	pop    %ebx
  800512:	5e                   	pop    %esi
  800513:	5f                   	pop    %edi
  800514:	5d                   	pop    %ebp
  800515:	c3                   	ret    
  800516:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800519:	eb c4                	jmp    8004df <printnum+0x73>

0080051b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80051b:	55                   	push   %ebp
  80051c:	89 e5                	mov    %esp,%ebp
  80051e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800521:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800525:	8b 10                	mov    (%eax),%edx
  800527:	3b 50 04             	cmp    0x4(%eax),%edx
  80052a:	73 0a                	jae    800536 <sprintputch+0x1b>
		*b->buf++ = ch;
  80052c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80052f:	89 08                	mov    %ecx,(%eax)
  800531:	8b 45 08             	mov    0x8(%ebp),%eax
  800534:	88 02                	mov    %al,(%edx)
}
  800536:	5d                   	pop    %ebp
  800537:	c3                   	ret    

00800538 <printfmt>:
{
  800538:	55                   	push   %ebp
  800539:	89 e5                	mov    %esp,%ebp
  80053b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80053e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800541:	50                   	push   %eax
  800542:	ff 75 10             	pushl  0x10(%ebp)
  800545:	ff 75 0c             	pushl  0xc(%ebp)
  800548:	ff 75 08             	pushl  0x8(%ebp)
  80054b:	e8 05 00 00 00       	call   800555 <vprintfmt>
}
  800550:	83 c4 10             	add    $0x10,%esp
  800553:	c9                   	leave  
  800554:	c3                   	ret    

00800555 <vprintfmt>:
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	57                   	push   %edi
  800559:	56                   	push   %esi
  80055a:	53                   	push   %ebx
  80055b:	83 ec 2c             	sub    $0x2c,%esp
  80055e:	8b 75 08             	mov    0x8(%ebp),%esi
  800561:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800564:	8b 7d 10             	mov    0x10(%ebp),%edi
  800567:	e9 c1 03 00 00       	jmp    80092d <vprintfmt+0x3d8>
		padc = ' ';
  80056c:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800570:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800577:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80057e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800585:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80058a:	8d 47 01             	lea    0x1(%edi),%eax
  80058d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800590:	0f b6 17             	movzbl (%edi),%edx
  800593:	8d 42 dd             	lea    -0x23(%edx),%eax
  800596:	3c 55                	cmp    $0x55,%al
  800598:	0f 87 12 04 00 00    	ja     8009b0 <vprintfmt+0x45b>
  80059e:	0f b6 c0             	movzbl %al,%eax
  8005a1:	ff 24 85 00 12 80 00 	jmp    *0x801200(,%eax,4)
  8005a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8005ab:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8005af:	eb d9                	jmp    80058a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8005b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8005b4:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8005b8:	eb d0                	jmp    80058a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8005ba:	0f b6 d2             	movzbl %dl,%edx
  8005bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8005c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8005c8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005cb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005cf:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005d2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005d5:	83 f9 09             	cmp    $0x9,%ecx
  8005d8:	77 55                	ja     80062f <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8005da:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005dd:	eb e9                	jmp    8005c8 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8d 40 04             	lea    0x4(%eax),%eax
  8005ed:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f7:	79 91                	jns    80058a <vprintfmt+0x35>
				width = precision, precision = -1;
  8005f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ff:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800606:	eb 82                	jmp    80058a <vprintfmt+0x35>
  800608:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80060b:	85 c0                	test   %eax,%eax
  80060d:	ba 00 00 00 00       	mov    $0x0,%edx
  800612:	0f 49 d0             	cmovns %eax,%edx
  800615:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800618:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80061b:	e9 6a ff ff ff       	jmp    80058a <vprintfmt+0x35>
  800620:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800623:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80062a:	e9 5b ff ff ff       	jmp    80058a <vprintfmt+0x35>
  80062f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800632:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800635:	eb bc                	jmp    8005f3 <vprintfmt+0x9e>
			lflag++;
  800637:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80063a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80063d:	e9 48 ff ff ff       	jmp    80058a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8d 78 04             	lea    0x4(%eax),%edi
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	53                   	push   %ebx
  80064c:	ff 30                	pushl  (%eax)
  80064e:	ff d6                	call   *%esi
			break;
  800650:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800653:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800656:	e9 cf 02 00 00       	jmp    80092a <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8d 78 04             	lea    0x4(%eax),%edi
  800661:	8b 00                	mov    (%eax),%eax
  800663:	99                   	cltd   
  800664:	31 d0                	xor    %edx,%eax
  800666:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800668:	83 f8 0f             	cmp    $0xf,%eax
  80066b:	7f 23                	jg     800690 <vprintfmt+0x13b>
  80066d:	8b 14 85 60 13 80 00 	mov    0x801360(,%eax,4),%edx
  800674:	85 d2                	test   %edx,%edx
  800676:	74 18                	je     800690 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800678:	52                   	push   %edx
  800679:	68 de 10 80 00       	push   $0x8010de
  80067e:	53                   	push   %ebx
  80067f:	56                   	push   %esi
  800680:	e8 b3 fe ff ff       	call   800538 <printfmt>
  800685:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800688:	89 7d 14             	mov    %edi,0x14(%ebp)
  80068b:	e9 9a 02 00 00       	jmp    80092a <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800690:	50                   	push   %eax
  800691:	68 d5 10 80 00       	push   $0x8010d5
  800696:	53                   	push   %ebx
  800697:	56                   	push   %esi
  800698:	e8 9b fe ff ff       	call   800538 <printfmt>
  80069d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8006a0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8006a3:	e9 82 02 00 00       	jmp    80092a <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	83 c0 04             	add    $0x4,%eax
  8006ae:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8006b6:	85 ff                	test   %edi,%edi
  8006b8:	b8 ce 10 80 00       	mov    $0x8010ce,%eax
  8006bd:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8006c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c4:	0f 8e bd 00 00 00    	jle    800787 <vprintfmt+0x232>
  8006ca:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8006ce:	75 0e                	jne    8006de <vprintfmt+0x189>
  8006d0:	89 75 08             	mov    %esi,0x8(%ebp)
  8006d3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006d6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006d9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006dc:	eb 6d                	jmp    80074b <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	ff 75 d0             	pushl  -0x30(%ebp)
  8006e4:	57                   	push   %edi
  8006e5:	e8 6e 03 00 00       	call   800a58 <strnlen>
  8006ea:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006ed:	29 c1                	sub    %eax,%ecx
  8006ef:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8006f2:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006f5:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006fc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006ff:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800701:	eb 0f                	jmp    800712 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800703:	83 ec 08             	sub    $0x8,%esp
  800706:	53                   	push   %ebx
  800707:	ff 75 e0             	pushl  -0x20(%ebp)
  80070a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80070c:	83 ef 01             	sub    $0x1,%edi
  80070f:	83 c4 10             	add    $0x10,%esp
  800712:	85 ff                	test   %edi,%edi
  800714:	7f ed                	jg     800703 <vprintfmt+0x1ae>
  800716:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800719:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80071c:	85 c9                	test   %ecx,%ecx
  80071e:	b8 00 00 00 00       	mov    $0x0,%eax
  800723:	0f 49 c1             	cmovns %ecx,%eax
  800726:	29 c1                	sub    %eax,%ecx
  800728:	89 75 08             	mov    %esi,0x8(%ebp)
  80072b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80072e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800731:	89 cb                	mov    %ecx,%ebx
  800733:	eb 16                	jmp    80074b <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800735:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800739:	75 31                	jne    80076c <vprintfmt+0x217>
					putch(ch, putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	ff 75 0c             	pushl  0xc(%ebp)
  800741:	50                   	push   %eax
  800742:	ff 55 08             	call   *0x8(%ebp)
  800745:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800748:	83 eb 01             	sub    $0x1,%ebx
  80074b:	83 c7 01             	add    $0x1,%edi
  80074e:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800752:	0f be c2             	movsbl %dl,%eax
  800755:	85 c0                	test   %eax,%eax
  800757:	74 59                	je     8007b2 <vprintfmt+0x25d>
  800759:	85 f6                	test   %esi,%esi
  80075b:	78 d8                	js     800735 <vprintfmt+0x1e0>
  80075d:	83 ee 01             	sub    $0x1,%esi
  800760:	79 d3                	jns    800735 <vprintfmt+0x1e0>
  800762:	89 df                	mov    %ebx,%edi
  800764:	8b 75 08             	mov    0x8(%ebp),%esi
  800767:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80076a:	eb 37                	jmp    8007a3 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80076c:	0f be d2             	movsbl %dl,%edx
  80076f:	83 ea 20             	sub    $0x20,%edx
  800772:	83 fa 5e             	cmp    $0x5e,%edx
  800775:	76 c4                	jbe    80073b <vprintfmt+0x1e6>
					putch('?', putdat);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	ff 75 0c             	pushl  0xc(%ebp)
  80077d:	6a 3f                	push   $0x3f
  80077f:	ff 55 08             	call   *0x8(%ebp)
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	eb c1                	jmp    800748 <vprintfmt+0x1f3>
  800787:	89 75 08             	mov    %esi,0x8(%ebp)
  80078a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80078d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800790:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800793:	eb b6                	jmp    80074b <vprintfmt+0x1f6>
				putch(' ', putdat);
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	53                   	push   %ebx
  800799:	6a 20                	push   $0x20
  80079b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80079d:	83 ef 01             	sub    $0x1,%edi
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	85 ff                	test   %edi,%edi
  8007a5:	7f ee                	jg     800795 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8007a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ad:	e9 78 01 00 00       	jmp    80092a <vprintfmt+0x3d5>
  8007b2:	89 df                	mov    %ebx,%edi
  8007b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8007b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007ba:	eb e7                	jmp    8007a3 <vprintfmt+0x24e>
	if (lflag >= 2)
  8007bc:	83 f9 01             	cmp    $0x1,%ecx
  8007bf:	7e 3f                	jle    800800 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	8b 50 04             	mov    0x4(%eax),%edx
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8d 40 08             	lea    0x8(%eax),%eax
  8007d5:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007dc:	79 5c                	jns    80083a <vprintfmt+0x2e5>
				putch('-', putdat);
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	53                   	push   %ebx
  8007e2:	6a 2d                	push   $0x2d
  8007e4:	ff d6                	call   *%esi
				num = -(long long) num;
  8007e6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007ec:	f7 da                	neg    %edx
  8007ee:	83 d1 00             	adc    $0x0,%ecx
  8007f1:	f7 d9                	neg    %ecx
  8007f3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fb:	e9 10 01 00 00       	jmp    800910 <vprintfmt+0x3bb>
	else if (lflag)
  800800:	85 c9                	test   %ecx,%ecx
  800802:	75 1b                	jne    80081f <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080c:	89 c1                	mov    %eax,%ecx
  80080e:	c1 f9 1f             	sar    $0x1f,%ecx
  800811:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8d 40 04             	lea    0x4(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	eb b9                	jmp    8007d8 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800827:	89 c1                	mov    %eax,%ecx
  800829:	c1 f9 1f             	sar    $0x1f,%ecx
  80082c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8d 40 04             	lea    0x4(%eax),%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
  800838:	eb 9e                	jmp    8007d8 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80083a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80083d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800840:	b8 0a 00 00 00       	mov    $0xa,%eax
  800845:	e9 c6 00 00 00       	jmp    800910 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80084a:	83 f9 01             	cmp    $0x1,%ecx
  80084d:	7e 18                	jle    800867 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	8b 10                	mov    (%eax),%edx
  800854:	8b 48 04             	mov    0x4(%eax),%ecx
  800857:	8d 40 08             	lea    0x8(%eax),%eax
  80085a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80085d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800862:	e9 a9 00 00 00       	jmp    800910 <vprintfmt+0x3bb>
	else if (lflag)
  800867:	85 c9                	test   %ecx,%ecx
  800869:	75 1a                	jne    800885 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8b 10                	mov    (%eax),%edx
  800870:	b9 00 00 00 00       	mov    $0x0,%ecx
  800875:	8d 40 04             	lea    0x4(%eax),%eax
  800878:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80087b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800880:	e9 8b 00 00 00       	jmp    800910 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	8b 10                	mov    (%eax),%edx
  80088a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80088f:	8d 40 04             	lea    0x4(%eax),%eax
  800892:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800895:	b8 0a 00 00 00       	mov    $0xa,%eax
  80089a:	eb 74                	jmp    800910 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80089c:	83 f9 01             	cmp    $0x1,%ecx
  80089f:	7e 15                	jle    8008b6 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8b 10                	mov    (%eax),%edx
  8008a6:	8b 48 04             	mov    0x4(%eax),%ecx
  8008a9:	8d 40 08             	lea    0x8(%eax),%eax
  8008ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008af:	b8 08 00 00 00       	mov    $0x8,%eax
  8008b4:	eb 5a                	jmp    800910 <vprintfmt+0x3bb>
	else if (lflag)
  8008b6:	85 c9                	test   %ecx,%ecx
  8008b8:	75 17                	jne    8008d1 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	8b 10                	mov    (%eax),%edx
  8008bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008c4:	8d 40 04             	lea    0x4(%eax),%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8008cf:	eb 3f                	jmp    800910 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	8b 10                	mov    (%eax),%edx
  8008d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008db:	8d 40 04             	lea    0x4(%eax),%eax
  8008de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8008e6:	eb 28                	jmp    800910 <vprintfmt+0x3bb>
			putch('0', putdat);
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	53                   	push   %ebx
  8008ec:	6a 30                	push   $0x30
  8008ee:	ff d6                	call   *%esi
			putch('x', putdat);
  8008f0:	83 c4 08             	add    $0x8,%esp
  8008f3:	53                   	push   %ebx
  8008f4:	6a 78                	push   $0x78
  8008f6:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fb:	8b 10                	mov    (%eax),%edx
  8008fd:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800902:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800905:	8d 40 04             	lea    0x4(%eax),%eax
  800908:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80090b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800910:	83 ec 0c             	sub    $0xc,%esp
  800913:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800917:	57                   	push   %edi
  800918:	ff 75 e0             	pushl  -0x20(%ebp)
  80091b:	50                   	push   %eax
  80091c:	51                   	push   %ecx
  80091d:	52                   	push   %edx
  80091e:	89 da                	mov    %ebx,%edx
  800920:	89 f0                	mov    %esi,%eax
  800922:	e8 45 fb ff ff       	call   80046c <printnum>
			break;
  800927:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80092a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  80092d:	83 c7 01             	add    $0x1,%edi
  800930:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800934:	83 f8 25             	cmp    $0x25,%eax
  800937:	0f 84 2f fc ff ff    	je     80056c <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  80093d:	85 c0                	test   %eax,%eax
  80093f:	0f 84 8b 00 00 00    	je     8009d0 <vprintfmt+0x47b>
			putch(ch, putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	53                   	push   %ebx
  800949:	50                   	push   %eax
  80094a:	ff d6                	call   *%esi
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	eb dc                	jmp    80092d <vprintfmt+0x3d8>
	if (lflag >= 2)
  800951:	83 f9 01             	cmp    $0x1,%ecx
  800954:	7e 15                	jle    80096b <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800956:	8b 45 14             	mov    0x14(%ebp),%eax
  800959:	8b 10                	mov    (%eax),%edx
  80095b:	8b 48 04             	mov    0x4(%eax),%ecx
  80095e:	8d 40 08             	lea    0x8(%eax),%eax
  800961:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800964:	b8 10 00 00 00       	mov    $0x10,%eax
  800969:	eb a5                	jmp    800910 <vprintfmt+0x3bb>
	else if (lflag)
  80096b:	85 c9                	test   %ecx,%ecx
  80096d:	75 17                	jne    800986 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80096f:	8b 45 14             	mov    0x14(%ebp),%eax
  800972:	8b 10                	mov    (%eax),%edx
  800974:	b9 00 00 00 00       	mov    $0x0,%ecx
  800979:	8d 40 04             	lea    0x4(%eax),%eax
  80097c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80097f:	b8 10 00 00 00       	mov    $0x10,%eax
  800984:	eb 8a                	jmp    800910 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800986:	8b 45 14             	mov    0x14(%ebp),%eax
  800989:	8b 10                	mov    (%eax),%edx
  80098b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800990:	8d 40 04             	lea    0x4(%eax),%eax
  800993:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800996:	b8 10 00 00 00       	mov    $0x10,%eax
  80099b:	e9 70 ff ff ff       	jmp    800910 <vprintfmt+0x3bb>
			putch(ch, putdat);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	53                   	push   %ebx
  8009a4:	6a 25                	push   $0x25
  8009a6:	ff d6                	call   *%esi
			break;
  8009a8:	83 c4 10             	add    $0x10,%esp
  8009ab:	e9 7a ff ff ff       	jmp    80092a <vprintfmt+0x3d5>
			putch('%', putdat);
  8009b0:	83 ec 08             	sub    $0x8,%esp
  8009b3:	53                   	push   %ebx
  8009b4:	6a 25                	push   $0x25
  8009b6:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009b8:	83 c4 10             	add    $0x10,%esp
  8009bb:	89 f8                	mov    %edi,%eax
  8009bd:	eb 03                	jmp    8009c2 <vprintfmt+0x46d>
  8009bf:	83 e8 01             	sub    $0x1,%eax
  8009c2:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009c6:	75 f7                	jne    8009bf <vprintfmt+0x46a>
  8009c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009cb:	e9 5a ff ff ff       	jmp    80092a <vprintfmt+0x3d5>
}
  8009d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009d3:	5b                   	pop    %ebx
  8009d4:	5e                   	pop    %esi
  8009d5:	5f                   	pop    %edi
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	83 ec 18             	sub    $0x18,%esp
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009e7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009eb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009f5:	85 c0                	test   %eax,%eax
  8009f7:	74 26                	je     800a1f <vsnprintf+0x47>
  8009f9:	85 d2                	test   %edx,%edx
  8009fb:	7e 22                	jle    800a1f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009fd:	ff 75 14             	pushl  0x14(%ebp)
  800a00:	ff 75 10             	pushl  0x10(%ebp)
  800a03:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a06:	50                   	push   %eax
  800a07:	68 1b 05 80 00       	push   $0x80051b
  800a0c:	e8 44 fb ff ff       	call   800555 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a14:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
}
  800a1d:	c9                   	leave  
  800a1e:	c3                   	ret    
		return -E_INVAL;
  800a1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a24:	eb f7                	jmp    800a1d <vsnprintf+0x45>

00800a26 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a2c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a2f:	50                   	push   %eax
  800a30:	ff 75 10             	pushl  0x10(%ebp)
  800a33:	ff 75 0c             	pushl  0xc(%ebp)
  800a36:	ff 75 08             	pushl  0x8(%ebp)
  800a39:	e8 9a ff ff ff       	call   8009d8 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a3e:	c9                   	leave  
  800a3f:	c3                   	ret    

00800a40 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a46:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4b:	eb 03                	jmp    800a50 <strlen+0x10>
		n++;
  800a4d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a50:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a54:	75 f7                	jne    800a4d <strlen+0xd>
	return n;
}
  800a56:	5d                   	pop    %ebp
  800a57:	c3                   	ret    

00800a58 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a61:	b8 00 00 00 00       	mov    $0x0,%eax
  800a66:	eb 03                	jmp    800a6b <strnlen+0x13>
		n++;
  800a68:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a6b:	39 d0                	cmp    %edx,%eax
  800a6d:	74 06                	je     800a75 <strnlen+0x1d>
  800a6f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a73:	75 f3                	jne    800a68 <strnlen+0x10>
	return n;
}
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	53                   	push   %ebx
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a81:	89 c2                	mov    %eax,%edx
  800a83:	83 c1 01             	add    $0x1,%ecx
  800a86:	83 c2 01             	add    $0x1,%edx
  800a89:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a8d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a90:	84 db                	test   %bl,%bl
  800a92:	75 ef                	jne    800a83 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a94:	5b                   	pop    %ebx
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	53                   	push   %ebx
  800a9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a9e:	53                   	push   %ebx
  800a9f:	e8 9c ff ff ff       	call   800a40 <strlen>
  800aa4:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800aa7:	ff 75 0c             	pushl  0xc(%ebp)
  800aaa:	01 d8                	add    %ebx,%eax
  800aac:	50                   	push   %eax
  800aad:	e8 c5 ff ff ff       	call   800a77 <strcpy>
	return dst;
}
  800ab2:	89 d8                	mov    %ebx,%eax
  800ab4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ab7:	c9                   	leave  
  800ab8:	c3                   	ret    

00800ab9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	56                   	push   %esi
  800abd:	53                   	push   %ebx
  800abe:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac4:	89 f3                	mov    %esi,%ebx
  800ac6:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ac9:	89 f2                	mov    %esi,%edx
  800acb:	eb 0f                	jmp    800adc <strncpy+0x23>
		*dst++ = *src;
  800acd:	83 c2 01             	add    $0x1,%edx
  800ad0:	0f b6 01             	movzbl (%ecx),%eax
  800ad3:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ad6:	80 39 01             	cmpb   $0x1,(%ecx)
  800ad9:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800adc:	39 da                	cmp    %ebx,%edx
  800ade:	75 ed                	jne    800acd <strncpy+0x14>
	}
	return ret;
}
  800ae0:	89 f0                	mov    %esi,%eax
  800ae2:	5b                   	pop    %ebx
  800ae3:	5e                   	pop    %esi
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	56                   	push   %esi
  800aea:	53                   	push   %ebx
  800aeb:	8b 75 08             	mov    0x8(%ebp),%esi
  800aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800af4:	89 f0                	mov    %esi,%eax
  800af6:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800afa:	85 c9                	test   %ecx,%ecx
  800afc:	75 0b                	jne    800b09 <strlcpy+0x23>
  800afe:	eb 17                	jmp    800b17 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b00:	83 c2 01             	add    $0x1,%edx
  800b03:	83 c0 01             	add    $0x1,%eax
  800b06:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800b09:	39 d8                	cmp    %ebx,%eax
  800b0b:	74 07                	je     800b14 <strlcpy+0x2e>
  800b0d:	0f b6 0a             	movzbl (%edx),%ecx
  800b10:	84 c9                	test   %cl,%cl
  800b12:	75 ec                	jne    800b00 <strlcpy+0x1a>
		*dst = '\0';
  800b14:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b17:	29 f0                	sub    %esi,%eax
}
  800b19:	5b                   	pop    %ebx
  800b1a:	5e                   	pop    %esi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b23:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b26:	eb 06                	jmp    800b2e <strcmp+0x11>
		p++, q++;
  800b28:	83 c1 01             	add    $0x1,%ecx
  800b2b:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b2e:	0f b6 01             	movzbl (%ecx),%eax
  800b31:	84 c0                	test   %al,%al
  800b33:	74 04                	je     800b39 <strcmp+0x1c>
  800b35:	3a 02                	cmp    (%edx),%al
  800b37:	74 ef                	je     800b28 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b39:	0f b6 c0             	movzbl %al,%eax
  800b3c:	0f b6 12             	movzbl (%edx),%edx
  800b3f:	29 d0                	sub    %edx,%eax
}
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	53                   	push   %ebx
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4d:	89 c3                	mov    %eax,%ebx
  800b4f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b52:	eb 06                	jmp    800b5a <strncmp+0x17>
		n--, p++, q++;
  800b54:	83 c0 01             	add    $0x1,%eax
  800b57:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b5a:	39 d8                	cmp    %ebx,%eax
  800b5c:	74 16                	je     800b74 <strncmp+0x31>
  800b5e:	0f b6 08             	movzbl (%eax),%ecx
  800b61:	84 c9                	test   %cl,%cl
  800b63:	74 04                	je     800b69 <strncmp+0x26>
  800b65:	3a 0a                	cmp    (%edx),%cl
  800b67:	74 eb                	je     800b54 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b69:	0f b6 00             	movzbl (%eax),%eax
  800b6c:	0f b6 12             	movzbl (%edx),%edx
  800b6f:	29 d0                	sub    %edx,%eax
}
  800b71:	5b                   	pop    %ebx
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    
		return 0;
  800b74:	b8 00 00 00 00       	mov    $0x0,%eax
  800b79:	eb f6                	jmp    800b71 <strncmp+0x2e>

00800b7b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b85:	0f b6 10             	movzbl (%eax),%edx
  800b88:	84 d2                	test   %dl,%dl
  800b8a:	74 09                	je     800b95 <strchr+0x1a>
		if (*s == c)
  800b8c:	38 ca                	cmp    %cl,%dl
  800b8e:	74 0a                	je     800b9a <strchr+0x1f>
	for (; *s; s++)
  800b90:	83 c0 01             	add    $0x1,%eax
  800b93:	eb f0                	jmp    800b85 <strchr+0xa>
			return (char *) s;
	return 0;
  800b95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ba6:	eb 03                	jmp    800bab <strfind+0xf>
  800ba8:	83 c0 01             	add    $0x1,%eax
  800bab:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bae:	38 ca                	cmp    %cl,%dl
  800bb0:	74 04                	je     800bb6 <strfind+0x1a>
  800bb2:	84 d2                	test   %dl,%dl
  800bb4:	75 f2                	jne    800ba8 <strfind+0xc>
			break;
	return (char *) s;
}
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    

00800bb8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	57                   	push   %edi
  800bbc:	56                   	push   %esi
  800bbd:	53                   	push   %ebx
  800bbe:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bc1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bc4:	85 c9                	test   %ecx,%ecx
  800bc6:	74 13                	je     800bdb <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bc8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bce:	75 05                	jne    800bd5 <memset+0x1d>
  800bd0:	f6 c1 03             	test   $0x3,%cl
  800bd3:	74 0d                	je     800be2 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	fc                   	cld    
  800bd9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bdb:	89 f8                	mov    %edi,%eax
  800bdd:	5b                   	pop    %ebx
  800bde:	5e                   	pop    %esi
  800bdf:	5f                   	pop    %edi
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    
		c &= 0xFF;
  800be2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800be6:	89 d3                	mov    %edx,%ebx
  800be8:	c1 e3 08             	shl    $0x8,%ebx
  800beb:	89 d0                	mov    %edx,%eax
  800bed:	c1 e0 18             	shl    $0x18,%eax
  800bf0:	89 d6                	mov    %edx,%esi
  800bf2:	c1 e6 10             	shl    $0x10,%esi
  800bf5:	09 f0                	or     %esi,%eax
  800bf7:	09 c2                	or     %eax,%edx
  800bf9:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bfb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bfe:	89 d0                	mov    %edx,%eax
  800c00:	fc                   	cld    
  800c01:	f3 ab                	rep stos %eax,%es:(%edi)
  800c03:	eb d6                	jmp    800bdb <memset+0x23>

00800c05 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	57                   	push   %edi
  800c09:	56                   	push   %esi
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c13:	39 c6                	cmp    %eax,%esi
  800c15:	73 35                	jae    800c4c <memmove+0x47>
  800c17:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c1a:	39 c2                	cmp    %eax,%edx
  800c1c:	76 2e                	jbe    800c4c <memmove+0x47>
		s += n;
		d += n;
  800c1e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c21:	89 d6                	mov    %edx,%esi
  800c23:	09 fe                	or     %edi,%esi
  800c25:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c2b:	74 0c                	je     800c39 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c2d:	83 ef 01             	sub    $0x1,%edi
  800c30:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c33:	fd                   	std    
  800c34:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c36:	fc                   	cld    
  800c37:	eb 21                	jmp    800c5a <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c39:	f6 c1 03             	test   $0x3,%cl
  800c3c:	75 ef                	jne    800c2d <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c3e:	83 ef 04             	sub    $0x4,%edi
  800c41:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c44:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c47:	fd                   	std    
  800c48:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c4a:	eb ea                	jmp    800c36 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c4c:	89 f2                	mov    %esi,%edx
  800c4e:	09 c2                	or     %eax,%edx
  800c50:	f6 c2 03             	test   $0x3,%dl
  800c53:	74 09                	je     800c5e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c55:	89 c7                	mov    %eax,%edi
  800c57:	fc                   	cld    
  800c58:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c5a:	5e                   	pop    %esi
  800c5b:	5f                   	pop    %edi
  800c5c:	5d                   	pop    %ebp
  800c5d:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c5e:	f6 c1 03             	test   $0x3,%cl
  800c61:	75 f2                	jne    800c55 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c63:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c66:	89 c7                	mov    %eax,%edi
  800c68:	fc                   	cld    
  800c69:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c6b:	eb ed                	jmp    800c5a <memmove+0x55>

00800c6d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c70:	ff 75 10             	pushl  0x10(%ebp)
  800c73:	ff 75 0c             	pushl  0xc(%ebp)
  800c76:	ff 75 08             	pushl  0x8(%ebp)
  800c79:	e8 87 ff ff ff       	call   800c05 <memmove>
}
  800c7e:	c9                   	leave  
  800c7f:	c3                   	ret    

00800c80 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8b:	89 c6                	mov    %eax,%esi
  800c8d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c90:	39 f0                	cmp    %esi,%eax
  800c92:	74 1c                	je     800cb0 <memcmp+0x30>
		if (*s1 != *s2)
  800c94:	0f b6 08             	movzbl (%eax),%ecx
  800c97:	0f b6 1a             	movzbl (%edx),%ebx
  800c9a:	38 d9                	cmp    %bl,%cl
  800c9c:	75 08                	jne    800ca6 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c9e:	83 c0 01             	add    $0x1,%eax
  800ca1:	83 c2 01             	add    $0x1,%edx
  800ca4:	eb ea                	jmp    800c90 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ca6:	0f b6 c1             	movzbl %cl,%eax
  800ca9:	0f b6 db             	movzbl %bl,%ebx
  800cac:	29 d8                	sub    %ebx,%eax
  800cae:	eb 05                	jmp    800cb5 <memcmp+0x35>
	}

	return 0;
  800cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    

00800cb9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cc2:	89 c2                	mov    %eax,%edx
  800cc4:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cc7:	39 d0                	cmp    %edx,%eax
  800cc9:	73 09                	jae    800cd4 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ccb:	38 08                	cmp    %cl,(%eax)
  800ccd:	74 05                	je     800cd4 <memfind+0x1b>
	for (; s < ends; s++)
  800ccf:	83 c0 01             	add    $0x1,%eax
  800cd2:	eb f3                	jmp    800cc7 <memfind+0xe>
			break;
	return (void *) s;
}
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    

00800cd6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	57                   	push   %edi
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
  800cdc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cdf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ce2:	eb 03                	jmp    800ce7 <strtol+0x11>
		s++;
  800ce4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ce7:	0f b6 01             	movzbl (%ecx),%eax
  800cea:	3c 20                	cmp    $0x20,%al
  800cec:	74 f6                	je     800ce4 <strtol+0xe>
  800cee:	3c 09                	cmp    $0x9,%al
  800cf0:	74 f2                	je     800ce4 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cf2:	3c 2b                	cmp    $0x2b,%al
  800cf4:	74 2e                	je     800d24 <strtol+0x4e>
	int neg = 0;
  800cf6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cfb:	3c 2d                	cmp    $0x2d,%al
  800cfd:	74 2f                	je     800d2e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cff:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d05:	75 05                	jne    800d0c <strtol+0x36>
  800d07:	80 39 30             	cmpb   $0x30,(%ecx)
  800d0a:	74 2c                	je     800d38 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d0c:	85 db                	test   %ebx,%ebx
  800d0e:	75 0a                	jne    800d1a <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d10:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800d15:	80 39 30             	cmpb   $0x30,(%ecx)
  800d18:	74 28                	je     800d42 <strtol+0x6c>
		base = 10;
  800d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d22:	eb 50                	jmp    800d74 <strtol+0x9e>
		s++;
  800d24:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d27:	bf 00 00 00 00       	mov    $0x0,%edi
  800d2c:	eb d1                	jmp    800cff <strtol+0x29>
		s++, neg = 1;
  800d2e:	83 c1 01             	add    $0x1,%ecx
  800d31:	bf 01 00 00 00       	mov    $0x1,%edi
  800d36:	eb c7                	jmp    800cff <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d38:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d3c:	74 0e                	je     800d4c <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d3e:	85 db                	test   %ebx,%ebx
  800d40:	75 d8                	jne    800d1a <strtol+0x44>
		s++, base = 8;
  800d42:	83 c1 01             	add    $0x1,%ecx
  800d45:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d4a:	eb ce                	jmp    800d1a <strtol+0x44>
		s += 2, base = 16;
  800d4c:	83 c1 02             	add    $0x2,%ecx
  800d4f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d54:	eb c4                	jmp    800d1a <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d56:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d59:	89 f3                	mov    %esi,%ebx
  800d5b:	80 fb 19             	cmp    $0x19,%bl
  800d5e:	77 29                	ja     800d89 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d60:	0f be d2             	movsbl %dl,%edx
  800d63:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d66:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d69:	7d 30                	jge    800d9b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d6b:	83 c1 01             	add    $0x1,%ecx
  800d6e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d72:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d74:	0f b6 11             	movzbl (%ecx),%edx
  800d77:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d7a:	89 f3                	mov    %esi,%ebx
  800d7c:	80 fb 09             	cmp    $0x9,%bl
  800d7f:	77 d5                	ja     800d56 <strtol+0x80>
			dig = *s - '0';
  800d81:	0f be d2             	movsbl %dl,%edx
  800d84:	83 ea 30             	sub    $0x30,%edx
  800d87:	eb dd                	jmp    800d66 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d89:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d8c:	89 f3                	mov    %esi,%ebx
  800d8e:	80 fb 19             	cmp    $0x19,%bl
  800d91:	77 08                	ja     800d9b <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d93:	0f be d2             	movsbl %dl,%edx
  800d96:	83 ea 37             	sub    $0x37,%edx
  800d99:	eb cb                	jmp    800d66 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9f:	74 05                	je     800da6 <strtol+0xd0>
		*endptr = (char *) s;
  800da1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800da4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800da6:	89 c2                	mov    %eax,%edx
  800da8:	f7 da                	neg    %edx
  800daa:	85 ff                	test   %edi,%edi
  800dac:	0f 45 c2             	cmovne %edx,%eax
}
  800daf:	5b                   	pop    %ebx
  800db0:	5e                   	pop    %esi
  800db1:	5f                   	pop    %edi
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    

00800db4 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800dba:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800dc1:	74 0a                	je     800dcd <set_pgfault_handler+0x19>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800dcb:	c9                   	leave  
  800dcc:	c3                   	ret    
		int r = sys_page_alloc(0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P);	//为当前进程分配异常栈
  800dcd:	83 ec 04             	sub    $0x4,%esp
  800dd0:	6a 07                	push   $0x7
  800dd2:	68 00 f0 bf ee       	push   $0xeebff000
  800dd7:	6a 00                	push   $0x0
  800dd9:	e8 8a f3 ff ff       	call   800168 <sys_page_alloc>
		if (r < 0) {
  800dde:	83 c4 10             	add    $0x10,%esp
  800de1:	85 c0                	test   %eax,%eax
  800de3:	78 14                	js     800df9 <set_pgfault_handler+0x45>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
  800de5:	83 ec 08             	sub    $0x8,%esp
  800de8:	68 59 03 80 00       	push   $0x800359
  800ded:	6a 00                	push   $0x0
  800def:	e8 bf f4 ff ff       	call   8002b3 <sys_env_set_pgfault_upcall>
  800df4:	83 c4 10             	add    $0x10,%esp
  800df7:	eb ca                	jmp    800dc3 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler:sys_page_alloc failed");;
  800df9:	83 ec 04             	sub    $0x4,%esp
  800dfc:	68 c0 13 80 00       	push   $0x8013c0
  800e01:	6a 22                	push   $0x22
  800e03:	68 ec 13 80 00       	push   $0x8013ec
  800e08:	e8 70 f5 ff ff       	call   80037d <_panic>
  800e0d:	66 90                	xchg   %ax,%ax
  800e0f:	90                   	nop

00800e10 <__udivdi3>:
  800e10:	55                   	push   %ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	53                   	push   %ebx
  800e14:	83 ec 1c             	sub    $0x1c,%esp
  800e17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800e1b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800e1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800e23:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800e27:	85 d2                	test   %edx,%edx
  800e29:	75 35                	jne    800e60 <__udivdi3+0x50>
  800e2b:	39 f3                	cmp    %esi,%ebx
  800e2d:	0f 87 bd 00 00 00    	ja     800ef0 <__udivdi3+0xe0>
  800e33:	85 db                	test   %ebx,%ebx
  800e35:	89 d9                	mov    %ebx,%ecx
  800e37:	75 0b                	jne    800e44 <__udivdi3+0x34>
  800e39:	b8 01 00 00 00       	mov    $0x1,%eax
  800e3e:	31 d2                	xor    %edx,%edx
  800e40:	f7 f3                	div    %ebx
  800e42:	89 c1                	mov    %eax,%ecx
  800e44:	31 d2                	xor    %edx,%edx
  800e46:	89 f0                	mov    %esi,%eax
  800e48:	f7 f1                	div    %ecx
  800e4a:	89 c6                	mov    %eax,%esi
  800e4c:	89 e8                	mov    %ebp,%eax
  800e4e:	89 f7                	mov    %esi,%edi
  800e50:	f7 f1                	div    %ecx
  800e52:	89 fa                	mov    %edi,%edx
  800e54:	83 c4 1c             	add    $0x1c,%esp
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    
  800e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e60:	39 f2                	cmp    %esi,%edx
  800e62:	77 7c                	ja     800ee0 <__udivdi3+0xd0>
  800e64:	0f bd fa             	bsr    %edx,%edi
  800e67:	83 f7 1f             	xor    $0x1f,%edi
  800e6a:	0f 84 98 00 00 00    	je     800f08 <__udivdi3+0xf8>
  800e70:	89 f9                	mov    %edi,%ecx
  800e72:	b8 20 00 00 00       	mov    $0x20,%eax
  800e77:	29 f8                	sub    %edi,%eax
  800e79:	d3 e2                	shl    %cl,%edx
  800e7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e7f:	89 c1                	mov    %eax,%ecx
  800e81:	89 da                	mov    %ebx,%edx
  800e83:	d3 ea                	shr    %cl,%edx
  800e85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e89:	09 d1                	or     %edx,%ecx
  800e8b:	89 f2                	mov    %esi,%edx
  800e8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e91:	89 f9                	mov    %edi,%ecx
  800e93:	d3 e3                	shl    %cl,%ebx
  800e95:	89 c1                	mov    %eax,%ecx
  800e97:	d3 ea                	shr    %cl,%edx
  800e99:	89 f9                	mov    %edi,%ecx
  800e9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e9f:	d3 e6                	shl    %cl,%esi
  800ea1:	89 eb                	mov    %ebp,%ebx
  800ea3:	89 c1                	mov    %eax,%ecx
  800ea5:	d3 eb                	shr    %cl,%ebx
  800ea7:	09 de                	or     %ebx,%esi
  800ea9:	89 f0                	mov    %esi,%eax
  800eab:	f7 74 24 08          	divl   0x8(%esp)
  800eaf:	89 d6                	mov    %edx,%esi
  800eb1:	89 c3                	mov    %eax,%ebx
  800eb3:	f7 64 24 0c          	mull   0xc(%esp)
  800eb7:	39 d6                	cmp    %edx,%esi
  800eb9:	72 0c                	jb     800ec7 <__udivdi3+0xb7>
  800ebb:	89 f9                	mov    %edi,%ecx
  800ebd:	d3 e5                	shl    %cl,%ebp
  800ebf:	39 c5                	cmp    %eax,%ebp
  800ec1:	73 5d                	jae    800f20 <__udivdi3+0x110>
  800ec3:	39 d6                	cmp    %edx,%esi
  800ec5:	75 59                	jne    800f20 <__udivdi3+0x110>
  800ec7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800eca:	31 ff                	xor    %edi,%edi
  800ecc:	89 fa                	mov    %edi,%edx
  800ece:	83 c4 1c             	add    $0x1c,%esp
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    
  800ed6:	8d 76 00             	lea    0x0(%esi),%esi
  800ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800ee0:	31 ff                	xor    %edi,%edi
  800ee2:	31 c0                	xor    %eax,%eax
  800ee4:	89 fa                	mov    %edi,%edx
  800ee6:	83 c4 1c             	add    $0x1c,%esp
  800ee9:	5b                   	pop    %ebx
  800eea:	5e                   	pop    %esi
  800eeb:	5f                   	pop    %edi
  800eec:	5d                   	pop    %ebp
  800eed:	c3                   	ret    
  800eee:	66 90                	xchg   %ax,%ax
  800ef0:	31 ff                	xor    %edi,%edi
  800ef2:	89 e8                	mov    %ebp,%eax
  800ef4:	89 f2                	mov    %esi,%edx
  800ef6:	f7 f3                	div    %ebx
  800ef8:	89 fa                	mov    %edi,%edx
  800efa:	83 c4 1c             	add    $0x1c,%esp
  800efd:	5b                   	pop    %ebx
  800efe:	5e                   	pop    %esi
  800eff:	5f                   	pop    %edi
  800f00:	5d                   	pop    %ebp
  800f01:	c3                   	ret    
  800f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800f08:	39 f2                	cmp    %esi,%edx
  800f0a:	72 06                	jb     800f12 <__udivdi3+0x102>
  800f0c:	31 c0                	xor    %eax,%eax
  800f0e:	39 eb                	cmp    %ebp,%ebx
  800f10:	77 d2                	ja     800ee4 <__udivdi3+0xd4>
  800f12:	b8 01 00 00 00       	mov    $0x1,%eax
  800f17:	eb cb                	jmp    800ee4 <__udivdi3+0xd4>
  800f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800f20:	89 d8                	mov    %ebx,%eax
  800f22:	31 ff                	xor    %edi,%edi
  800f24:	eb be                	jmp    800ee4 <__udivdi3+0xd4>
  800f26:	66 90                	xchg   %ax,%ax
  800f28:	66 90                	xchg   %ax,%ax
  800f2a:	66 90                	xchg   %ax,%ax
  800f2c:	66 90                	xchg   %ax,%ax
  800f2e:	66 90                	xchg   %ax,%ax

00800f30 <__umoddi3>:
  800f30:	55                   	push   %ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
  800f34:	83 ec 1c             	sub    $0x1c,%esp
  800f37:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800f3b:	8b 74 24 30          	mov    0x30(%esp),%esi
  800f3f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800f43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800f47:	85 ed                	test   %ebp,%ebp
  800f49:	89 f0                	mov    %esi,%eax
  800f4b:	89 da                	mov    %ebx,%edx
  800f4d:	75 19                	jne    800f68 <__umoddi3+0x38>
  800f4f:	39 df                	cmp    %ebx,%edi
  800f51:	0f 86 b1 00 00 00    	jbe    801008 <__umoddi3+0xd8>
  800f57:	f7 f7                	div    %edi
  800f59:	89 d0                	mov    %edx,%eax
  800f5b:	31 d2                	xor    %edx,%edx
  800f5d:	83 c4 1c             	add    $0x1c,%esp
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    
  800f65:	8d 76 00             	lea    0x0(%esi),%esi
  800f68:	39 dd                	cmp    %ebx,%ebp
  800f6a:	77 f1                	ja     800f5d <__umoddi3+0x2d>
  800f6c:	0f bd cd             	bsr    %ebp,%ecx
  800f6f:	83 f1 1f             	xor    $0x1f,%ecx
  800f72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f76:	0f 84 b4 00 00 00    	je     801030 <__umoddi3+0x100>
  800f7c:	b8 20 00 00 00       	mov    $0x20,%eax
  800f81:	89 c2                	mov    %eax,%edx
  800f83:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f87:	29 c2                	sub    %eax,%edx
  800f89:	89 c1                	mov    %eax,%ecx
  800f8b:	89 f8                	mov    %edi,%eax
  800f8d:	d3 e5                	shl    %cl,%ebp
  800f8f:	89 d1                	mov    %edx,%ecx
  800f91:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f95:	d3 e8                	shr    %cl,%eax
  800f97:	09 c5                	or     %eax,%ebp
  800f99:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f9d:	89 c1                	mov    %eax,%ecx
  800f9f:	d3 e7                	shl    %cl,%edi
  800fa1:	89 d1                	mov    %edx,%ecx
  800fa3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800fa7:	89 df                	mov    %ebx,%edi
  800fa9:	d3 ef                	shr    %cl,%edi
  800fab:	89 c1                	mov    %eax,%ecx
  800fad:	89 f0                	mov    %esi,%eax
  800faf:	d3 e3                	shl    %cl,%ebx
  800fb1:	89 d1                	mov    %edx,%ecx
  800fb3:	89 fa                	mov    %edi,%edx
  800fb5:	d3 e8                	shr    %cl,%eax
  800fb7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800fbc:	09 d8                	or     %ebx,%eax
  800fbe:	f7 f5                	div    %ebp
  800fc0:	d3 e6                	shl    %cl,%esi
  800fc2:	89 d1                	mov    %edx,%ecx
  800fc4:	f7 64 24 08          	mull   0x8(%esp)
  800fc8:	39 d1                	cmp    %edx,%ecx
  800fca:	89 c3                	mov    %eax,%ebx
  800fcc:	89 d7                	mov    %edx,%edi
  800fce:	72 06                	jb     800fd6 <__umoddi3+0xa6>
  800fd0:	75 0e                	jne    800fe0 <__umoddi3+0xb0>
  800fd2:	39 c6                	cmp    %eax,%esi
  800fd4:	73 0a                	jae    800fe0 <__umoddi3+0xb0>
  800fd6:	2b 44 24 08          	sub    0x8(%esp),%eax
  800fda:	19 ea                	sbb    %ebp,%edx
  800fdc:	89 d7                	mov    %edx,%edi
  800fde:	89 c3                	mov    %eax,%ebx
  800fe0:	89 ca                	mov    %ecx,%edx
  800fe2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800fe7:	29 de                	sub    %ebx,%esi
  800fe9:	19 fa                	sbb    %edi,%edx
  800feb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800fef:	89 d0                	mov    %edx,%eax
  800ff1:	d3 e0                	shl    %cl,%eax
  800ff3:	89 d9                	mov    %ebx,%ecx
  800ff5:	d3 ee                	shr    %cl,%esi
  800ff7:	d3 ea                	shr    %cl,%edx
  800ff9:	09 f0                	or     %esi,%eax
  800ffb:	83 c4 1c             	add    $0x1c,%esp
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    
  801003:	90                   	nop
  801004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801008:	85 ff                	test   %edi,%edi
  80100a:	89 f9                	mov    %edi,%ecx
  80100c:	75 0b                	jne    801019 <__umoddi3+0xe9>
  80100e:	b8 01 00 00 00       	mov    $0x1,%eax
  801013:	31 d2                	xor    %edx,%edx
  801015:	f7 f7                	div    %edi
  801017:	89 c1                	mov    %eax,%ecx
  801019:	89 d8                	mov    %ebx,%eax
  80101b:	31 d2                	xor    %edx,%edx
  80101d:	f7 f1                	div    %ecx
  80101f:	89 f0                	mov    %esi,%eax
  801021:	f7 f1                	div    %ecx
  801023:	e9 31 ff ff ff       	jmp    800f59 <__umoddi3+0x29>
  801028:	90                   	nop
  801029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801030:	39 dd                	cmp    %ebx,%ebp
  801032:	72 08                	jb     80103c <__umoddi3+0x10c>
  801034:	39 f7                	cmp    %esi,%edi
  801036:	0f 87 21 ff ff ff    	ja     800f5d <__umoddi3+0x2d>
  80103c:	89 da                	mov    %ebx,%edx
  80103e:	89 f0                	mov    %esi,%eax
  801040:	29 f8                	sub    %edi,%eax
  801042:	19 ea                	sbb    %ebp,%edx
  801044:	e9 14 ff ff ff       	jmp    800f5d <__umoddi3+0x2d>
