
obj/user/testpiperace.debug：     文件格式 elf32-i386


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
  80002c:	e8 bf 01 00 00       	call   8001f0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003b:	68 e0 22 80 00       	push   $0x8022e0
  800040:	e8 de 02 00 00       	call   800323 <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 d4 1c 00 00       	call   801d24 <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	78 5b                	js     8000b2 <umain+0x7f>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  800057:	e8 a0 0f 00 00       	call   800ffc <fork>
  80005c:	89 c6                	mov    %eax,%esi
  80005e:	85 c0                	test   %eax,%eax
  800060:	78 62                	js     8000c4 <umain+0x91>
		panic("fork: %e", r);
	if (r == 0) {
  800062:	85 c0                	test   %eax,%eax
  800064:	74 70                	je     8000d6 <umain+0xa3>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	56                   	push   %esi
  80006a:	68 31 23 80 00       	push   $0x802331
  80006f:	e8 af 02 00 00       	call   800323 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800074:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  80007a:	83 c4 08             	add    $0x8,%esp
  80007d:	6b c6 7c             	imul   $0x7c,%esi,%eax
  800080:	c1 f8 02             	sar    $0x2,%eax
  800083:	69 c0 df 7b ef bd    	imul   $0xbdef7bdf,%eax,%eax
  800089:	50                   	push   %eax
  80008a:	68 3c 23 80 00       	push   $0x80233c
  80008f:	e8 8f 02 00 00       	call   800323 <cprintf>
	dup(p[0], 10);
  800094:	83 c4 08             	add    $0x8,%esp
  800097:	6a 0a                	push   $0xa
  800099:	ff 75 f0             	pushl  -0x10(%ebp)
  80009c:	e8 38 14 00 00       	call   8014d9 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	6b de 7c             	imul   $0x7c,%esi,%ebx
  8000a7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000ad:	e9 92 00 00 00       	jmp    800144 <umain+0x111>
		panic("pipe: %e", r);
  8000b2:	50                   	push   %eax
  8000b3:	68 f9 22 80 00       	push   $0x8022f9
  8000b8:	6a 0d                	push   $0xd
  8000ba:	68 02 23 80 00       	push   $0x802302
  8000bf:	e8 84 01 00 00       	call   800248 <_panic>
		panic("fork: %e", r);
  8000c4:	50                   	push   %eax
  8000c5:	68 85 27 80 00       	push   $0x802785
  8000ca:	6a 10                	push   $0x10
  8000cc:	68 02 23 80 00       	push   $0x802302
  8000d1:	e8 72 01 00 00       	call   800248 <_panic>
		close(p[1]);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8000dc:	e8 a8 13 00 00       	call   801489 <close>
  8000e1:	83 c4 10             	add    $0x10,%esp
  8000e4:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000e9:	eb 0a                	jmp    8000f5 <umain+0xc2>
			sys_yield();
  8000eb:	e8 2c 0c 00 00       	call   800d1c <sys_yield>
		for (i=0; i<max; i++) {
  8000f0:	83 eb 01             	sub    $0x1,%ebx
  8000f3:	74 29                	je     80011e <umain+0xeb>
			if(pipeisclosed(p[0])){
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000fb:	e8 6d 1d 00 00       	call   801e6d <pipeisclosed>
  800100:	83 c4 10             	add    $0x10,%esp
  800103:	85 c0                	test   %eax,%eax
  800105:	74 e4                	je     8000eb <umain+0xb8>
				cprintf("RACE: pipe appears closed\n");
  800107:	83 ec 0c             	sub    $0xc,%esp
  80010a:	68 16 23 80 00       	push   $0x802316
  80010f:	e8 0f 02 00 00       	call   800323 <cprintf>
				exit();
  800114:	e8 1d 01 00 00       	call   800236 <exit>
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	eb cd                	jmp    8000eb <umain+0xb8>
		ipc_recv(0,0,0);
  80011e:	83 ec 04             	sub    $0x4,%esp
  800121:	6a 00                	push   $0x0
  800123:	6a 00                	push   $0x0
  800125:	6a 00                	push   $0x0
  800127:	e8 bc 10 00 00       	call   8011e8 <ipc_recv>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	e9 32 ff ff ff       	jmp    800066 <umain+0x33>
		dup(p[0], 10);
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	6a 0a                	push   $0xa
  800139:	ff 75 f0             	pushl  -0x10(%ebp)
  80013c:	e8 98 13 00 00       	call   8014d9 <dup>
  800141:	83 c4 10             	add    $0x10,%esp
	while (kid->env_status == ENV_RUNNABLE)
  800144:	8b 53 54             	mov    0x54(%ebx),%edx
  800147:	83 fa 02             	cmp    $0x2,%edx
  80014a:	74 e8                	je     800134 <umain+0x101>

	cprintf("child done with loop\n");
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	68 47 23 80 00       	push   $0x802347
  800154:	e8 ca 01 00 00       	call   800323 <cprintf>
	if (pipeisclosed(p[0]))
  800159:	83 c4 04             	add    $0x4,%esp
  80015c:	ff 75 f0             	pushl  -0x10(%ebp)
  80015f:	e8 09 1d 00 00       	call   801e6d <pipeisclosed>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	85 c0                	test   %eax,%eax
  800169:	75 48                	jne    8001b3 <umain+0x180>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80016b:	83 ec 08             	sub    $0x8,%esp
  80016e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800171:	50                   	push   %eax
  800172:	ff 75 f0             	pushl  -0x10(%ebp)
  800175:	e8 da 11 00 00       	call   801354 <fd_lookup>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	85 c0                	test   %eax,%eax
  80017f:	78 46                	js     8001c7 <umain+0x194>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	ff 75 ec             	pushl  -0x14(%ebp)
  800187:	e8 62 11 00 00       	call   8012ee <fd2data>
	if (pageref(va) != 3+1)
  80018c:	89 04 24             	mov    %eax,(%esp)
  80018f:	e8 84 19 00 00       	call   801b18 <pageref>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	83 f8 04             	cmp    $0x4,%eax
  80019a:	74 3d                	je     8001d9 <umain+0x1a6>
		cprintf("\nchild detected race\n");
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	68 75 23 80 00       	push   $0x802375
  8001a4:	e8 7a 01 00 00       	call   800323 <cprintf>
  8001a9:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001af:	5b                   	pop    %ebx
  8001b0:	5e                   	pop    %esi
  8001b1:	5d                   	pop    %ebp
  8001b2:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001b3:	83 ec 04             	sub    $0x4,%esp
  8001b6:	68 a0 23 80 00       	push   $0x8023a0
  8001bb:	6a 3a                	push   $0x3a
  8001bd:	68 02 23 80 00       	push   $0x802302
  8001c2:	e8 81 00 00 00       	call   800248 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c7:	50                   	push   %eax
  8001c8:	68 5d 23 80 00       	push   $0x80235d
  8001cd:	6a 3c                	push   $0x3c
  8001cf:	68 02 23 80 00       	push   $0x802302
  8001d4:	e8 6f 00 00 00       	call   800248 <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	68 c8 00 00 00       	push   $0xc8
  8001e1:	68 8b 23 80 00       	push   $0x80238b
  8001e6:	e8 38 01 00 00       	call   800323 <cprintf>
  8001eb:	83 c4 10             	add    $0x10,%esp
}
  8001ee:	eb bc                	jmp    8001ac <umain+0x179>

008001f0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	56                   	push   %esi
  8001f4:	53                   	push   %ebx
  8001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001f8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  8001fb:	e8 fd 0a 00 00       	call   800cfd <sys_getenvid>
	thisenv = envs + ENVX(envid);
  800200:	25 ff 03 00 00       	and    $0x3ff,%eax
  800205:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800208:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80020d:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800212:	85 db                	test   %ebx,%ebx
  800214:	7e 07                	jle    80021d <libmain+0x2d>
		binaryname = argv[0];
  800216:	8b 06                	mov    (%esi),%eax
  800218:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	56                   	push   %esi
  800221:	53                   	push   %ebx
  800222:	e8 0c fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800227:	e8 0a 00 00 00       	call   800236 <exit>
}
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800232:	5b                   	pop    %ebx
  800233:	5e                   	pop    %esi
  800234:	5d                   	pop    %ebp
  800235:	c3                   	ret    

00800236 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80023c:	6a 00                	push   $0x0
  80023e:	e8 79 0a 00 00       	call   800cbc <sys_env_destroy>
}
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	c9                   	leave  
  800247:	c3                   	ret    

00800248 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80024d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800250:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800256:	e8 a2 0a 00 00       	call   800cfd <sys_getenvid>
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	ff 75 0c             	pushl  0xc(%ebp)
  800261:	ff 75 08             	pushl  0x8(%ebp)
  800264:	56                   	push   %esi
  800265:	50                   	push   %eax
  800266:	68 d4 23 80 00       	push   $0x8023d4
  80026b:	e8 b3 00 00 00       	call   800323 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800270:	83 c4 18             	add    $0x18,%esp
  800273:	53                   	push   %ebx
  800274:	ff 75 10             	pushl  0x10(%ebp)
  800277:	e8 56 00 00 00       	call   8002d2 <vcprintf>
	cprintf("\n");
  80027c:	c7 04 24 f7 22 80 00 	movl   $0x8022f7,(%esp)
  800283:	e8 9b 00 00 00       	call   800323 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80028b:	cc                   	int3   
  80028c:	eb fd                	jmp    80028b <_panic+0x43>

0080028e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	53                   	push   %ebx
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800298:	8b 13                	mov    (%ebx),%edx
  80029a:	8d 42 01             	lea    0x1(%edx),%eax
  80029d:	89 03                	mov    %eax,(%ebx)
  80029f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ab:	74 09                	je     8002b6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002ad:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002b6:	83 ec 08             	sub    $0x8,%esp
  8002b9:	68 ff 00 00 00       	push   $0xff
  8002be:	8d 43 08             	lea    0x8(%ebx),%eax
  8002c1:	50                   	push   %eax
  8002c2:	e8 b8 09 00 00       	call   800c7f <sys_cputs>
		b->idx = 0;
  8002c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002cd:	83 c4 10             	add    $0x10,%esp
  8002d0:	eb db                	jmp    8002ad <putch+0x1f>

008002d2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e2:	00 00 00 
	b.cnt = 0;
  8002e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ec:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002ef:	ff 75 0c             	pushl  0xc(%ebp)
  8002f2:	ff 75 08             	pushl  0x8(%ebp)
  8002f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002fb:	50                   	push   %eax
  8002fc:	68 8e 02 80 00       	push   $0x80028e
  800301:	e8 1a 01 00 00       	call   800420 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800306:	83 c4 08             	add    $0x8,%esp
  800309:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80030f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800315:	50                   	push   %eax
  800316:	e8 64 09 00 00       	call   800c7f <sys_cputs>

	return b.cnt;
}
  80031b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800321:	c9                   	leave  
  800322:	c3                   	ret    

00800323 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800329:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80032c:	50                   	push   %eax
  80032d:	ff 75 08             	pushl  0x8(%ebp)
  800330:	e8 9d ff ff ff       	call   8002d2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800335:	c9                   	leave  
  800336:	c3                   	ret    

00800337 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	57                   	push   %edi
  80033b:	56                   	push   %esi
  80033c:	53                   	push   %ebx
  80033d:	83 ec 1c             	sub    $0x1c,%esp
  800340:	89 c7                	mov    %eax,%edi
  800342:	89 d6                	mov    %edx,%esi
  800344:	8b 45 08             	mov    0x8(%ebp),%eax
  800347:	8b 55 0c             	mov    0xc(%ebp),%edx
  80034a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800350:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800353:	bb 00 00 00 00       	mov    $0x0,%ebx
  800358:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80035b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80035e:	39 d3                	cmp    %edx,%ebx
  800360:	72 05                	jb     800367 <printnum+0x30>
  800362:	39 45 10             	cmp    %eax,0x10(%ebp)
  800365:	77 7a                	ja     8003e1 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800367:	83 ec 0c             	sub    $0xc,%esp
  80036a:	ff 75 18             	pushl  0x18(%ebp)
  80036d:	8b 45 14             	mov    0x14(%ebp),%eax
  800370:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800373:	53                   	push   %ebx
  800374:	ff 75 10             	pushl  0x10(%ebp)
  800377:	83 ec 08             	sub    $0x8,%esp
  80037a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80037d:	ff 75 e0             	pushl  -0x20(%ebp)
  800380:	ff 75 dc             	pushl  -0x24(%ebp)
  800383:	ff 75 d8             	pushl  -0x28(%ebp)
  800386:	e8 15 1d 00 00       	call   8020a0 <__udivdi3>
  80038b:	83 c4 18             	add    $0x18,%esp
  80038e:	52                   	push   %edx
  80038f:	50                   	push   %eax
  800390:	89 f2                	mov    %esi,%edx
  800392:	89 f8                	mov    %edi,%eax
  800394:	e8 9e ff ff ff       	call   800337 <printnum>
  800399:	83 c4 20             	add    $0x20,%esp
  80039c:	eb 13                	jmp    8003b1 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	56                   	push   %esi
  8003a2:	ff 75 18             	pushl  0x18(%ebp)
  8003a5:	ff d7                	call   *%edi
  8003a7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003aa:	83 eb 01             	sub    $0x1,%ebx
  8003ad:	85 db                	test   %ebx,%ebx
  8003af:	7f ed                	jg     80039e <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b1:	83 ec 08             	sub    $0x8,%esp
  8003b4:	56                   	push   %esi
  8003b5:	83 ec 04             	sub    $0x4,%esp
  8003b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8003be:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8003c4:	e8 f7 1d 00 00       	call   8021c0 <__umoddi3>
  8003c9:	83 c4 14             	add    $0x14,%esp
  8003cc:	0f be 80 f7 23 80 00 	movsbl 0x8023f7(%eax),%eax
  8003d3:	50                   	push   %eax
  8003d4:	ff d7                	call   *%edi
}
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003dc:	5b                   	pop    %ebx
  8003dd:	5e                   	pop    %esi
  8003de:	5f                   	pop    %edi
  8003df:	5d                   	pop    %ebp
  8003e0:	c3                   	ret    
  8003e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003e4:	eb c4                	jmp    8003aa <printnum+0x73>

008003e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ec:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f0:	8b 10                	mov    (%eax),%edx
  8003f2:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f5:	73 0a                	jae    800401 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003fa:	89 08                	mov    %ecx,(%eax)
  8003fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ff:	88 02                	mov    %al,(%edx)
}
  800401:	5d                   	pop    %ebp
  800402:	c3                   	ret    

00800403 <printfmt>:
{
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800409:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80040c:	50                   	push   %eax
  80040d:	ff 75 10             	pushl  0x10(%ebp)
  800410:	ff 75 0c             	pushl  0xc(%ebp)
  800413:	ff 75 08             	pushl  0x8(%ebp)
  800416:	e8 05 00 00 00       	call   800420 <vprintfmt>
}
  80041b:	83 c4 10             	add    $0x10,%esp
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <vprintfmt>:
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	57                   	push   %edi
  800424:	56                   	push   %esi
  800425:	53                   	push   %ebx
  800426:	83 ec 2c             	sub    $0x2c,%esp
  800429:	8b 75 08             	mov    0x8(%ebp),%esi
  80042c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80042f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800432:	e9 c1 03 00 00       	jmp    8007f8 <vprintfmt+0x3d8>
		padc = ' ';
  800437:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80043b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800442:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800449:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800450:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800455:	8d 47 01             	lea    0x1(%edi),%eax
  800458:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80045b:	0f b6 17             	movzbl (%edi),%edx
  80045e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800461:	3c 55                	cmp    $0x55,%al
  800463:	0f 87 12 04 00 00    	ja     80087b <vprintfmt+0x45b>
  800469:	0f b6 c0             	movzbl %al,%eax
  80046c:	ff 24 85 40 25 80 00 	jmp    *0x802540(,%eax,4)
  800473:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800476:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80047a:	eb d9                	jmp    800455 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80047c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80047f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800483:	eb d0                	jmp    800455 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800485:	0f b6 d2             	movzbl %dl,%edx
  800488:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800493:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800496:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80049a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80049d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004a0:	83 f9 09             	cmp    $0x9,%ecx
  8004a3:	77 55                	ja     8004fa <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8004a5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004a8:	eb e9                	jmp    800493 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8004aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b5:	8d 40 04             	lea    0x4(%eax),%eax
  8004b8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c2:	79 91                	jns    800455 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ca:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004d1:	eb 82                	jmp    800455 <vprintfmt+0x35>
  8004d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d6:	85 c0                	test   %eax,%eax
  8004d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004dd:	0f 49 d0             	cmovns %eax,%edx
  8004e0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004e6:	e9 6a ff ff ff       	jmp    800455 <vprintfmt+0x35>
  8004eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004ee:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004f5:	e9 5b ff ff ff       	jmp    800455 <vprintfmt+0x35>
  8004fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800500:	eb bc                	jmp    8004be <vprintfmt+0x9e>
			lflag++;
  800502:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800505:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800508:	e9 48 ff ff ff       	jmp    800455 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8d 78 04             	lea    0x4(%eax),%edi
  800513:	83 ec 08             	sub    $0x8,%esp
  800516:	53                   	push   %ebx
  800517:	ff 30                	pushl  (%eax)
  800519:	ff d6                	call   *%esi
			break;
  80051b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80051e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800521:	e9 cf 02 00 00       	jmp    8007f5 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800526:	8b 45 14             	mov    0x14(%ebp),%eax
  800529:	8d 78 04             	lea    0x4(%eax),%edi
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	99                   	cltd   
  80052f:	31 d0                	xor    %edx,%eax
  800531:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800533:	83 f8 0f             	cmp    $0xf,%eax
  800536:	7f 23                	jg     80055b <vprintfmt+0x13b>
  800538:	8b 14 85 a0 26 80 00 	mov    0x8026a0(,%eax,4),%edx
  80053f:	85 d2                	test   %edx,%edx
  800541:	74 18                	je     80055b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800543:	52                   	push   %edx
  800544:	68 8d 28 80 00       	push   $0x80288d
  800549:	53                   	push   %ebx
  80054a:	56                   	push   %esi
  80054b:	e8 b3 fe ff ff       	call   800403 <printfmt>
  800550:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800553:	89 7d 14             	mov    %edi,0x14(%ebp)
  800556:	e9 9a 02 00 00       	jmp    8007f5 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80055b:	50                   	push   %eax
  80055c:	68 0f 24 80 00       	push   $0x80240f
  800561:	53                   	push   %ebx
  800562:	56                   	push   %esi
  800563:	e8 9b fe ff ff       	call   800403 <printfmt>
  800568:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80056b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80056e:	e9 82 02 00 00       	jmp    8007f5 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	83 c0 04             	add    $0x4,%eax
  800579:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800581:	85 ff                	test   %edi,%edi
  800583:	b8 08 24 80 00       	mov    $0x802408,%eax
  800588:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80058b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80058f:	0f 8e bd 00 00 00    	jle    800652 <vprintfmt+0x232>
  800595:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800599:	75 0e                	jne    8005a9 <vprintfmt+0x189>
  80059b:	89 75 08             	mov    %esi,0x8(%ebp)
  80059e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005a1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005a4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005a7:	eb 6d                	jmp    800616 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	ff 75 d0             	pushl  -0x30(%ebp)
  8005af:	57                   	push   %edi
  8005b0:	e8 6e 03 00 00       	call   800923 <strnlen>
  8005b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005b8:	29 c1                	sub    %eax,%ecx
  8005ba:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005bd:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005c0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005ca:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cc:	eb 0f                	jmp    8005dd <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	53                   	push   %ebx
  8005d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8005d5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d7:	83 ef 01             	sub    $0x1,%edi
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	85 ff                	test   %edi,%edi
  8005df:	7f ed                	jg     8005ce <vprintfmt+0x1ae>
  8005e1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005e4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005e7:	85 c9                	test   %ecx,%ecx
  8005e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ee:	0f 49 c1             	cmovns %ecx,%eax
  8005f1:	29 c1                	sub    %eax,%ecx
  8005f3:	89 75 08             	mov    %esi,0x8(%ebp)
  8005f6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005f9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005fc:	89 cb                	mov    %ecx,%ebx
  8005fe:	eb 16                	jmp    800616 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800600:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800604:	75 31                	jne    800637 <vprintfmt+0x217>
					putch(ch, putdat);
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	ff 75 0c             	pushl  0xc(%ebp)
  80060c:	50                   	push   %eax
  80060d:	ff 55 08             	call   *0x8(%ebp)
  800610:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800613:	83 eb 01             	sub    $0x1,%ebx
  800616:	83 c7 01             	add    $0x1,%edi
  800619:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80061d:	0f be c2             	movsbl %dl,%eax
  800620:	85 c0                	test   %eax,%eax
  800622:	74 59                	je     80067d <vprintfmt+0x25d>
  800624:	85 f6                	test   %esi,%esi
  800626:	78 d8                	js     800600 <vprintfmt+0x1e0>
  800628:	83 ee 01             	sub    $0x1,%esi
  80062b:	79 d3                	jns    800600 <vprintfmt+0x1e0>
  80062d:	89 df                	mov    %ebx,%edi
  80062f:	8b 75 08             	mov    0x8(%ebp),%esi
  800632:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800635:	eb 37                	jmp    80066e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800637:	0f be d2             	movsbl %dl,%edx
  80063a:	83 ea 20             	sub    $0x20,%edx
  80063d:	83 fa 5e             	cmp    $0x5e,%edx
  800640:	76 c4                	jbe    800606 <vprintfmt+0x1e6>
					putch('?', putdat);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 0c             	pushl  0xc(%ebp)
  800648:	6a 3f                	push   $0x3f
  80064a:	ff 55 08             	call   *0x8(%ebp)
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	eb c1                	jmp    800613 <vprintfmt+0x1f3>
  800652:	89 75 08             	mov    %esi,0x8(%ebp)
  800655:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800658:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80065b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80065e:	eb b6                	jmp    800616 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800660:	83 ec 08             	sub    $0x8,%esp
  800663:	53                   	push   %ebx
  800664:	6a 20                	push   $0x20
  800666:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800668:	83 ef 01             	sub    $0x1,%edi
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	85 ff                	test   %edi,%edi
  800670:	7f ee                	jg     800660 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800672:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800675:	89 45 14             	mov    %eax,0x14(%ebp)
  800678:	e9 78 01 00 00       	jmp    8007f5 <vprintfmt+0x3d5>
  80067d:	89 df                	mov    %ebx,%edi
  80067f:	8b 75 08             	mov    0x8(%ebp),%esi
  800682:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800685:	eb e7                	jmp    80066e <vprintfmt+0x24e>
	if (lflag >= 2)
  800687:	83 f9 01             	cmp    $0x1,%ecx
  80068a:	7e 3f                	jle    8006cb <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8b 50 04             	mov    0x4(%eax),%edx
  800692:	8b 00                	mov    (%eax),%eax
  800694:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800697:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8d 40 08             	lea    0x8(%eax),%eax
  8006a0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006a3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006a7:	79 5c                	jns    800705 <vprintfmt+0x2e5>
				putch('-', putdat);
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	53                   	push   %ebx
  8006ad:	6a 2d                	push   $0x2d
  8006af:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006b7:	f7 da                	neg    %edx
  8006b9:	83 d1 00             	adc    $0x0,%ecx
  8006bc:	f7 d9                	neg    %ecx
  8006be:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c6:	e9 10 01 00 00       	jmp    8007db <vprintfmt+0x3bb>
	else if (lflag)
  8006cb:	85 c9                	test   %ecx,%ecx
  8006cd:	75 1b                	jne    8006ea <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d7:	89 c1                	mov    %eax,%ecx
  8006d9:	c1 f9 1f             	sar    $0x1f,%ecx
  8006dc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8d 40 04             	lea    0x4(%eax),%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e8:	eb b9                	jmp    8006a3 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f2:	89 c1                	mov    %eax,%ecx
  8006f4:	c1 f9 1f             	sar    $0x1f,%ecx
  8006f7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8d 40 04             	lea    0x4(%eax),%eax
  800700:	89 45 14             	mov    %eax,0x14(%ebp)
  800703:	eb 9e                	jmp    8006a3 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800705:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800708:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80070b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800710:	e9 c6 00 00 00       	jmp    8007db <vprintfmt+0x3bb>
	if (lflag >= 2)
  800715:	83 f9 01             	cmp    $0x1,%ecx
  800718:	7e 18                	jle    800732 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	8b 10                	mov    (%eax),%edx
  80071f:	8b 48 04             	mov    0x4(%eax),%ecx
  800722:	8d 40 08             	lea    0x8(%eax),%eax
  800725:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800728:	b8 0a 00 00 00       	mov    $0xa,%eax
  80072d:	e9 a9 00 00 00       	jmp    8007db <vprintfmt+0x3bb>
	else if (lflag)
  800732:	85 c9                	test   %ecx,%ecx
  800734:	75 1a                	jne    800750 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8b 10                	mov    (%eax),%edx
  80073b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800740:	8d 40 04             	lea    0x4(%eax),%eax
  800743:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800746:	b8 0a 00 00 00       	mov    $0xa,%eax
  80074b:	e9 8b 00 00 00       	jmp    8007db <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8b 10                	mov    (%eax),%edx
  800755:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075a:	8d 40 04             	lea    0x4(%eax),%eax
  80075d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800760:	b8 0a 00 00 00       	mov    $0xa,%eax
  800765:	eb 74                	jmp    8007db <vprintfmt+0x3bb>
	if (lflag >= 2)
  800767:	83 f9 01             	cmp    $0x1,%ecx
  80076a:	7e 15                	jle    800781 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8b 10                	mov    (%eax),%edx
  800771:	8b 48 04             	mov    0x4(%eax),%ecx
  800774:	8d 40 08             	lea    0x8(%eax),%eax
  800777:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077a:	b8 08 00 00 00       	mov    $0x8,%eax
  80077f:	eb 5a                	jmp    8007db <vprintfmt+0x3bb>
	else if (lflag)
  800781:	85 c9                	test   %ecx,%ecx
  800783:	75 17                	jne    80079c <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8b 10                	mov    (%eax),%edx
  80078a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078f:	8d 40 04             	lea    0x4(%eax),%eax
  800792:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800795:	b8 08 00 00 00       	mov    $0x8,%eax
  80079a:	eb 3f                	jmp    8007db <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8b 10                	mov    (%eax),%edx
  8007a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a6:	8d 40 04             	lea    0x4(%eax),%eax
  8007a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b1:	eb 28                	jmp    8007db <vprintfmt+0x3bb>
			putch('0', putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	53                   	push   %ebx
  8007b7:	6a 30                	push   $0x30
  8007b9:	ff d6                	call   *%esi
			putch('x', putdat);
  8007bb:	83 c4 08             	add    $0x8,%esp
  8007be:	53                   	push   %ebx
  8007bf:	6a 78                	push   $0x78
  8007c1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8b 10                	mov    (%eax),%edx
  8007c8:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007cd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007d0:	8d 40 04             	lea    0x4(%eax),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007db:	83 ec 0c             	sub    $0xc,%esp
  8007de:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007e2:	57                   	push   %edi
  8007e3:	ff 75 e0             	pushl  -0x20(%ebp)
  8007e6:	50                   	push   %eax
  8007e7:	51                   	push   %ecx
  8007e8:	52                   	push   %edx
  8007e9:	89 da                	mov    %ebx,%edx
  8007eb:	89 f0                	mov    %esi,%eax
  8007ed:	e8 45 fb ff ff       	call   800337 <printnum>
			break;
  8007f2:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  8007f8:	83 c7 01             	add    $0x1,%edi
  8007fb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ff:	83 f8 25             	cmp    $0x25,%eax
  800802:	0f 84 2f fc ff ff    	je     800437 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  800808:	85 c0                	test   %eax,%eax
  80080a:	0f 84 8b 00 00 00    	je     80089b <vprintfmt+0x47b>
			putch(ch, putdat);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	53                   	push   %ebx
  800814:	50                   	push   %eax
  800815:	ff d6                	call   *%esi
  800817:	83 c4 10             	add    $0x10,%esp
  80081a:	eb dc                	jmp    8007f8 <vprintfmt+0x3d8>
	if (lflag >= 2)
  80081c:	83 f9 01             	cmp    $0x1,%ecx
  80081f:	7e 15                	jle    800836 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800821:	8b 45 14             	mov    0x14(%ebp),%eax
  800824:	8b 10                	mov    (%eax),%edx
  800826:	8b 48 04             	mov    0x4(%eax),%ecx
  800829:	8d 40 08             	lea    0x8(%eax),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082f:	b8 10 00 00 00       	mov    $0x10,%eax
  800834:	eb a5                	jmp    8007db <vprintfmt+0x3bb>
	else if (lflag)
  800836:	85 c9                	test   %ecx,%ecx
  800838:	75 17                	jne    800851 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	8b 10                	mov    (%eax),%edx
  80083f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800844:	8d 40 04             	lea    0x4(%eax),%eax
  800847:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084a:	b8 10 00 00 00       	mov    $0x10,%eax
  80084f:	eb 8a                	jmp    8007db <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	8b 10                	mov    (%eax),%edx
  800856:	b9 00 00 00 00       	mov    $0x0,%ecx
  80085b:	8d 40 04             	lea    0x4(%eax),%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800861:	b8 10 00 00 00       	mov    $0x10,%eax
  800866:	e9 70 ff ff ff       	jmp    8007db <vprintfmt+0x3bb>
			putch(ch, putdat);
  80086b:	83 ec 08             	sub    $0x8,%esp
  80086e:	53                   	push   %ebx
  80086f:	6a 25                	push   $0x25
  800871:	ff d6                	call   *%esi
			break;
  800873:	83 c4 10             	add    $0x10,%esp
  800876:	e9 7a ff ff ff       	jmp    8007f5 <vprintfmt+0x3d5>
			putch('%', putdat);
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	53                   	push   %ebx
  80087f:	6a 25                	push   $0x25
  800881:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800883:	83 c4 10             	add    $0x10,%esp
  800886:	89 f8                	mov    %edi,%eax
  800888:	eb 03                	jmp    80088d <vprintfmt+0x46d>
  80088a:	83 e8 01             	sub    $0x1,%eax
  80088d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800891:	75 f7                	jne    80088a <vprintfmt+0x46a>
  800893:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800896:	e9 5a ff ff ff       	jmp    8007f5 <vprintfmt+0x3d5>
}
  80089b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80089e:	5b                   	pop    %ebx
  80089f:	5e                   	pop    %esi
  8008a0:	5f                   	pop    %edi
  8008a1:	5d                   	pop    %ebp
  8008a2:	c3                   	ret    

008008a3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	83 ec 18             	sub    $0x18,%esp
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008b6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c0:	85 c0                	test   %eax,%eax
  8008c2:	74 26                	je     8008ea <vsnprintf+0x47>
  8008c4:	85 d2                	test   %edx,%edx
  8008c6:	7e 22                	jle    8008ea <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c8:	ff 75 14             	pushl  0x14(%ebp)
  8008cb:	ff 75 10             	pushl  0x10(%ebp)
  8008ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d1:	50                   	push   %eax
  8008d2:	68 e6 03 80 00       	push   $0x8003e6
  8008d7:	e8 44 fb ff ff       	call   800420 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008df:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e5:	83 c4 10             	add    $0x10,%esp
}
  8008e8:	c9                   	leave  
  8008e9:	c3                   	ret    
		return -E_INVAL;
  8008ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ef:	eb f7                	jmp    8008e8 <vsnprintf+0x45>

008008f1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008f7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008fa:	50                   	push   %eax
  8008fb:	ff 75 10             	pushl  0x10(%ebp)
  8008fe:	ff 75 0c             	pushl  0xc(%ebp)
  800901:	ff 75 08             	pushl  0x8(%ebp)
  800904:	e8 9a ff ff ff       	call   8008a3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800909:	c9                   	leave  
  80090a:	c3                   	ret    

0080090b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800911:	b8 00 00 00 00       	mov    $0x0,%eax
  800916:	eb 03                	jmp    80091b <strlen+0x10>
		n++;
  800918:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80091b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80091f:	75 f7                	jne    800918 <strlen+0xd>
	return n;
}
  800921:	5d                   	pop    %ebp
  800922:	c3                   	ret    

00800923 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800929:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092c:	b8 00 00 00 00       	mov    $0x0,%eax
  800931:	eb 03                	jmp    800936 <strnlen+0x13>
		n++;
  800933:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800936:	39 d0                	cmp    %edx,%eax
  800938:	74 06                	je     800940 <strnlen+0x1d>
  80093a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80093e:	75 f3                	jne    800933 <strnlen+0x10>
	return n;
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	53                   	push   %ebx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80094c:	89 c2                	mov    %eax,%edx
  80094e:	83 c1 01             	add    $0x1,%ecx
  800951:	83 c2 01             	add    $0x1,%edx
  800954:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800958:	88 5a ff             	mov    %bl,-0x1(%edx)
  80095b:	84 db                	test   %bl,%bl
  80095d:	75 ef                	jne    80094e <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80095f:	5b                   	pop    %ebx
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	53                   	push   %ebx
  800966:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800969:	53                   	push   %ebx
  80096a:	e8 9c ff ff ff       	call   80090b <strlen>
  80096f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	01 d8                	add    %ebx,%eax
  800977:	50                   	push   %eax
  800978:	e8 c5 ff ff ff       	call   800942 <strcpy>
	return dst;
}
  80097d:	89 d8                	mov    %ebx,%eax
  80097f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800982:	c9                   	leave  
  800983:	c3                   	ret    

00800984 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	56                   	push   %esi
  800988:	53                   	push   %ebx
  800989:	8b 75 08             	mov    0x8(%ebp),%esi
  80098c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098f:	89 f3                	mov    %esi,%ebx
  800991:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800994:	89 f2                	mov    %esi,%edx
  800996:	eb 0f                	jmp    8009a7 <strncpy+0x23>
		*dst++ = *src;
  800998:	83 c2 01             	add    $0x1,%edx
  80099b:	0f b6 01             	movzbl (%ecx),%eax
  80099e:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a1:	80 39 01             	cmpb   $0x1,(%ecx)
  8009a4:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8009a7:	39 da                	cmp    %ebx,%edx
  8009a9:	75 ed                	jne    800998 <strncpy+0x14>
	}
	return ret;
}
  8009ab:	89 f0                	mov    %esi,%eax
  8009ad:	5b                   	pop    %ebx
  8009ae:	5e                   	pop    %esi
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    

008009b1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	56                   	push   %esi
  8009b5:	53                   	push   %ebx
  8009b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009bf:	89 f0                	mov    %esi,%eax
  8009c1:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c5:	85 c9                	test   %ecx,%ecx
  8009c7:	75 0b                	jne    8009d4 <strlcpy+0x23>
  8009c9:	eb 17                	jmp    8009e2 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009cb:	83 c2 01             	add    $0x1,%edx
  8009ce:	83 c0 01             	add    $0x1,%eax
  8009d1:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009d4:	39 d8                	cmp    %ebx,%eax
  8009d6:	74 07                	je     8009df <strlcpy+0x2e>
  8009d8:	0f b6 0a             	movzbl (%edx),%ecx
  8009db:	84 c9                	test   %cl,%cl
  8009dd:	75 ec                	jne    8009cb <strlcpy+0x1a>
		*dst = '\0';
  8009df:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e2:	29 f0                	sub    %esi,%eax
}
  8009e4:	5b                   	pop    %ebx
  8009e5:	5e                   	pop    %esi
  8009e6:	5d                   	pop    %ebp
  8009e7:	c3                   	ret    

008009e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ee:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f1:	eb 06                	jmp    8009f9 <strcmp+0x11>
		p++, q++;
  8009f3:	83 c1 01             	add    $0x1,%ecx
  8009f6:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009f9:	0f b6 01             	movzbl (%ecx),%eax
  8009fc:	84 c0                	test   %al,%al
  8009fe:	74 04                	je     800a04 <strcmp+0x1c>
  800a00:	3a 02                	cmp    (%edx),%al
  800a02:	74 ef                	je     8009f3 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a04:	0f b6 c0             	movzbl %al,%eax
  800a07:	0f b6 12             	movzbl (%edx),%edx
  800a0a:	29 d0                	sub    %edx,%eax
}
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    

00800a0e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	53                   	push   %ebx
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a18:	89 c3                	mov    %eax,%ebx
  800a1a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a1d:	eb 06                	jmp    800a25 <strncmp+0x17>
		n--, p++, q++;
  800a1f:	83 c0 01             	add    $0x1,%eax
  800a22:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a25:	39 d8                	cmp    %ebx,%eax
  800a27:	74 16                	je     800a3f <strncmp+0x31>
  800a29:	0f b6 08             	movzbl (%eax),%ecx
  800a2c:	84 c9                	test   %cl,%cl
  800a2e:	74 04                	je     800a34 <strncmp+0x26>
  800a30:	3a 0a                	cmp    (%edx),%cl
  800a32:	74 eb                	je     800a1f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a34:	0f b6 00             	movzbl (%eax),%eax
  800a37:	0f b6 12             	movzbl (%edx),%edx
  800a3a:	29 d0                	sub    %edx,%eax
}
  800a3c:	5b                   	pop    %ebx
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    
		return 0;
  800a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a44:	eb f6                	jmp    800a3c <strncmp+0x2e>

00800a46 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a50:	0f b6 10             	movzbl (%eax),%edx
  800a53:	84 d2                	test   %dl,%dl
  800a55:	74 09                	je     800a60 <strchr+0x1a>
		if (*s == c)
  800a57:	38 ca                	cmp    %cl,%dl
  800a59:	74 0a                	je     800a65 <strchr+0x1f>
	for (; *s; s++)
  800a5b:	83 c0 01             	add    $0x1,%eax
  800a5e:	eb f0                	jmp    800a50 <strchr+0xa>
			return (char *) s;
	return 0;
  800a60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a71:	eb 03                	jmp    800a76 <strfind+0xf>
  800a73:	83 c0 01             	add    $0x1,%eax
  800a76:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a79:	38 ca                	cmp    %cl,%dl
  800a7b:	74 04                	je     800a81 <strfind+0x1a>
  800a7d:	84 d2                	test   %dl,%dl
  800a7f:	75 f2                	jne    800a73 <strfind+0xc>
			break;
	return (char *) s;
}
  800a81:	5d                   	pop    %ebp
  800a82:	c3                   	ret    

00800a83 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	57                   	push   %edi
  800a87:	56                   	push   %esi
  800a88:	53                   	push   %ebx
  800a89:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a8f:	85 c9                	test   %ecx,%ecx
  800a91:	74 13                	je     800aa6 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a93:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a99:	75 05                	jne    800aa0 <memset+0x1d>
  800a9b:	f6 c1 03             	test   $0x3,%cl
  800a9e:	74 0d                	je     800aad <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa3:	fc                   	cld    
  800aa4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aa6:	89 f8                	mov    %edi,%eax
  800aa8:	5b                   	pop    %ebx
  800aa9:	5e                   	pop    %esi
  800aaa:	5f                   	pop    %edi
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    
		c &= 0xFF;
  800aad:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab1:	89 d3                	mov    %edx,%ebx
  800ab3:	c1 e3 08             	shl    $0x8,%ebx
  800ab6:	89 d0                	mov    %edx,%eax
  800ab8:	c1 e0 18             	shl    $0x18,%eax
  800abb:	89 d6                	mov    %edx,%esi
  800abd:	c1 e6 10             	shl    $0x10,%esi
  800ac0:	09 f0                	or     %esi,%eax
  800ac2:	09 c2                	or     %eax,%edx
  800ac4:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ac6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	fc                   	cld    
  800acc:	f3 ab                	rep stos %eax,%es:(%edi)
  800ace:	eb d6                	jmp    800aa6 <memset+0x23>

00800ad0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	57                   	push   %edi
  800ad4:	56                   	push   %esi
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800adb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ade:	39 c6                	cmp    %eax,%esi
  800ae0:	73 35                	jae    800b17 <memmove+0x47>
  800ae2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ae5:	39 c2                	cmp    %eax,%edx
  800ae7:	76 2e                	jbe    800b17 <memmove+0x47>
		s += n;
		d += n;
  800ae9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aec:	89 d6                	mov    %edx,%esi
  800aee:	09 fe                	or     %edi,%esi
  800af0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800af6:	74 0c                	je     800b04 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800af8:	83 ef 01             	sub    $0x1,%edi
  800afb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800afe:	fd                   	std    
  800aff:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b01:	fc                   	cld    
  800b02:	eb 21                	jmp    800b25 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b04:	f6 c1 03             	test   $0x3,%cl
  800b07:	75 ef                	jne    800af8 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b09:	83 ef 04             	sub    $0x4,%edi
  800b0c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b0f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b12:	fd                   	std    
  800b13:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b15:	eb ea                	jmp    800b01 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b17:	89 f2                	mov    %esi,%edx
  800b19:	09 c2                	or     %eax,%edx
  800b1b:	f6 c2 03             	test   $0x3,%dl
  800b1e:	74 09                	je     800b29 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b20:	89 c7                	mov    %eax,%edi
  800b22:	fc                   	cld    
  800b23:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b25:	5e                   	pop    %esi
  800b26:	5f                   	pop    %edi
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b29:	f6 c1 03             	test   $0x3,%cl
  800b2c:	75 f2                	jne    800b20 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b2e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b31:	89 c7                	mov    %eax,%edi
  800b33:	fc                   	cld    
  800b34:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b36:	eb ed                	jmp    800b25 <memmove+0x55>

00800b38 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b3b:	ff 75 10             	pushl  0x10(%ebp)
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	ff 75 08             	pushl  0x8(%ebp)
  800b44:	e8 87 ff ff ff       	call   800ad0 <memmove>
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	56                   	push   %esi
  800b4f:	53                   	push   %ebx
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b56:	89 c6                	mov    %eax,%esi
  800b58:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b5b:	39 f0                	cmp    %esi,%eax
  800b5d:	74 1c                	je     800b7b <memcmp+0x30>
		if (*s1 != *s2)
  800b5f:	0f b6 08             	movzbl (%eax),%ecx
  800b62:	0f b6 1a             	movzbl (%edx),%ebx
  800b65:	38 d9                	cmp    %bl,%cl
  800b67:	75 08                	jne    800b71 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b69:	83 c0 01             	add    $0x1,%eax
  800b6c:	83 c2 01             	add    $0x1,%edx
  800b6f:	eb ea                	jmp    800b5b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b71:	0f b6 c1             	movzbl %cl,%eax
  800b74:	0f b6 db             	movzbl %bl,%ebx
  800b77:	29 d8                	sub    %ebx,%eax
  800b79:	eb 05                	jmp    800b80 <memcmp+0x35>
	}

	return 0;
  800b7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b80:	5b                   	pop    %ebx
  800b81:	5e                   	pop    %esi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b8d:	89 c2                	mov    %eax,%edx
  800b8f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b92:	39 d0                	cmp    %edx,%eax
  800b94:	73 09                	jae    800b9f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b96:	38 08                	cmp    %cl,(%eax)
  800b98:	74 05                	je     800b9f <memfind+0x1b>
	for (; s < ends; s++)
  800b9a:	83 c0 01             	add    $0x1,%eax
  800b9d:	eb f3                	jmp    800b92 <memfind+0xe>
			break;
	return (void *) s;
}
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    

00800ba1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	57                   	push   %edi
  800ba5:	56                   	push   %esi
  800ba6:	53                   	push   %ebx
  800ba7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800baa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bad:	eb 03                	jmp    800bb2 <strtol+0x11>
		s++;
  800baf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bb2:	0f b6 01             	movzbl (%ecx),%eax
  800bb5:	3c 20                	cmp    $0x20,%al
  800bb7:	74 f6                	je     800baf <strtol+0xe>
  800bb9:	3c 09                	cmp    $0x9,%al
  800bbb:	74 f2                	je     800baf <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bbd:	3c 2b                	cmp    $0x2b,%al
  800bbf:	74 2e                	je     800bef <strtol+0x4e>
	int neg = 0;
  800bc1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bc6:	3c 2d                	cmp    $0x2d,%al
  800bc8:	74 2f                	je     800bf9 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bca:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bd0:	75 05                	jne    800bd7 <strtol+0x36>
  800bd2:	80 39 30             	cmpb   $0x30,(%ecx)
  800bd5:	74 2c                	je     800c03 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bd7:	85 db                	test   %ebx,%ebx
  800bd9:	75 0a                	jne    800be5 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bdb:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800be0:	80 39 30             	cmpb   $0x30,(%ecx)
  800be3:	74 28                	je     800c0d <strtol+0x6c>
		base = 10;
  800be5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bea:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bed:	eb 50                	jmp    800c3f <strtol+0x9e>
		s++;
  800bef:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bf2:	bf 00 00 00 00       	mov    $0x0,%edi
  800bf7:	eb d1                	jmp    800bca <strtol+0x29>
		s++, neg = 1;
  800bf9:	83 c1 01             	add    $0x1,%ecx
  800bfc:	bf 01 00 00 00       	mov    $0x1,%edi
  800c01:	eb c7                	jmp    800bca <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c03:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c07:	74 0e                	je     800c17 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c09:	85 db                	test   %ebx,%ebx
  800c0b:	75 d8                	jne    800be5 <strtol+0x44>
		s++, base = 8;
  800c0d:	83 c1 01             	add    $0x1,%ecx
  800c10:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c15:	eb ce                	jmp    800be5 <strtol+0x44>
		s += 2, base = 16;
  800c17:	83 c1 02             	add    $0x2,%ecx
  800c1a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c1f:	eb c4                	jmp    800be5 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c21:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c24:	89 f3                	mov    %esi,%ebx
  800c26:	80 fb 19             	cmp    $0x19,%bl
  800c29:	77 29                	ja     800c54 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c2b:	0f be d2             	movsbl %dl,%edx
  800c2e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c31:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c34:	7d 30                	jge    800c66 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c36:	83 c1 01             	add    $0x1,%ecx
  800c39:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c3d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c3f:	0f b6 11             	movzbl (%ecx),%edx
  800c42:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c45:	89 f3                	mov    %esi,%ebx
  800c47:	80 fb 09             	cmp    $0x9,%bl
  800c4a:	77 d5                	ja     800c21 <strtol+0x80>
			dig = *s - '0';
  800c4c:	0f be d2             	movsbl %dl,%edx
  800c4f:	83 ea 30             	sub    $0x30,%edx
  800c52:	eb dd                	jmp    800c31 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c54:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c57:	89 f3                	mov    %esi,%ebx
  800c59:	80 fb 19             	cmp    $0x19,%bl
  800c5c:	77 08                	ja     800c66 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c5e:	0f be d2             	movsbl %dl,%edx
  800c61:	83 ea 37             	sub    $0x37,%edx
  800c64:	eb cb                	jmp    800c31 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6a:	74 05                	je     800c71 <strtol+0xd0>
		*endptr = (char *) s;
  800c6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c6f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c71:	89 c2                	mov    %eax,%edx
  800c73:	f7 da                	neg    %edx
  800c75:	85 ff                	test   %edi,%edi
  800c77:	0f 45 c2             	cmovne %edx,%eax
}
  800c7a:	5b                   	pop    %ebx
  800c7b:	5e                   	pop    %esi
  800c7c:	5f                   	pop    %edi
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c85:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c90:	89 c3                	mov    %eax,%ebx
  800c92:	89 c7                	mov    %eax,%edi
  800c94:	89 c6                	mov    %eax,%esi
  800c96:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c98:	5b                   	pop    %ebx
  800c99:	5e                   	pop    %esi
  800c9a:	5f                   	pop    %edi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <sys_cgetc>:

int
sys_cgetc(void)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ca3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca8:	b8 01 00 00 00       	mov    $0x1,%eax
  800cad:	89 d1                	mov    %edx,%ecx
  800caf:	89 d3                	mov    %edx,%ebx
  800cb1:	89 d7                	mov    %edx,%edi
  800cb3:	89 d6                	mov    %edx,%esi
  800cb5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cb7:	5b                   	pop    %ebx
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	57                   	push   %edi
  800cc0:	56                   	push   %esi
  800cc1:	53                   	push   %ebx
  800cc2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800cc5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccd:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd2:	89 cb                	mov    %ecx,%ebx
  800cd4:	89 cf                	mov    %ecx,%edi
  800cd6:	89 ce                	mov    %ecx,%esi
  800cd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cda:	85 c0                	test   %eax,%eax
  800cdc:	7f 08                	jg     800ce6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce1:	5b                   	pop    %ebx
  800ce2:	5e                   	pop    %esi
  800ce3:	5f                   	pop    %edi
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce6:	83 ec 0c             	sub    $0xc,%esp
  800ce9:	50                   	push   %eax
  800cea:	6a 03                	push   $0x3
  800cec:	68 ff 26 80 00       	push   $0x8026ff
  800cf1:	6a 23                	push   $0x23
  800cf3:	68 1c 27 80 00       	push   $0x80271c
  800cf8:	e8 4b f5 ff ff       	call   800248 <_panic>

00800cfd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	57                   	push   %edi
  800d01:	56                   	push   %esi
  800d02:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d03:	ba 00 00 00 00       	mov    $0x0,%edx
  800d08:	b8 02 00 00 00       	mov    $0x2,%eax
  800d0d:	89 d1                	mov    %edx,%ecx
  800d0f:	89 d3                	mov    %edx,%ebx
  800d11:	89 d7                	mov    %edx,%edi
  800d13:	89 d6                	mov    %edx,%esi
  800d15:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <sys_yield>:

void
sys_yield(void)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	57                   	push   %edi
  800d20:	56                   	push   %esi
  800d21:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d22:	ba 00 00 00 00       	mov    $0x0,%edx
  800d27:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d2c:	89 d1                	mov    %edx,%ecx
  800d2e:	89 d3                	mov    %edx,%ebx
  800d30:	89 d7                	mov    %edx,%edi
  800d32:	89 d6                	mov    %edx,%esi
  800d34:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d36:	5b                   	pop    %ebx
  800d37:	5e                   	pop    %esi
  800d38:	5f                   	pop    %edi
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	57                   	push   %edi
  800d3f:	56                   	push   %esi
  800d40:	53                   	push   %ebx
  800d41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d44:	be 00 00 00 00       	mov    $0x0,%esi
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4f:	b8 04 00 00 00       	mov    $0x4,%eax
  800d54:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d57:	89 f7                	mov    %esi,%edi
  800d59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	7f 08                	jg     800d67 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d67:	83 ec 0c             	sub    $0xc,%esp
  800d6a:	50                   	push   %eax
  800d6b:	6a 04                	push   $0x4
  800d6d:	68 ff 26 80 00       	push   $0x8026ff
  800d72:	6a 23                	push   $0x23
  800d74:	68 1c 27 80 00       	push   $0x80271c
  800d79:	e8 ca f4 ff ff       	call   800248 <_panic>

00800d7e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d87:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d95:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d98:	8b 75 18             	mov    0x18(%ebp),%esi
  800d9b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9d:	85 c0                	test   %eax,%eax
  800d9f:	7f 08                	jg     800da9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da4:	5b                   	pop    %ebx
  800da5:	5e                   	pop    %esi
  800da6:	5f                   	pop    %edi
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da9:	83 ec 0c             	sub    $0xc,%esp
  800dac:	50                   	push   %eax
  800dad:	6a 05                	push   $0x5
  800daf:	68 ff 26 80 00       	push   $0x8026ff
  800db4:	6a 23                	push   $0x23
  800db6:	68 1c 27 80 00       	push   $0x80271c
  800dbb:	e8 88 f4 ff ff       	call   800248 <_panic>

00800dc0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	57                   	push   %edi
  800dc4:	56                   	push   %esi
  800dc5:	53                   	push   %ebx
  800dc6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800dc9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dce:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd4:	b8 06 00 00 00       	mov    $0x6,%eax
  800dd9:	89 df                	mov    %ebx,%edi
  800ddb:	89 de                	mov    %ebx,%esi
  800ddd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ddf:	85 c0                	test   %eax,%eax
  800de1:	7f 08                	jg     800deb <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de6:	5b                   	pop    %ebx
  800de7:	5e                   	pop    %esi
  800de8:	5f                   	pop    %edi
  800de9:	5d                   	pop    %ebp
  800dea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800deb:	83 ec 0c             	sub    $0xc,%esp
  800dee:	50                   	push   %eax
  800def:	6a 06                	push   $0x6
  800df1:	68 ff 26 80 00       	push   $0x8026ff
  800df6:	6a 23                	push   $0x23
  800df8:	68 1c 27 80 00       	push   $0x80271c
  800dfd:	e8 46 f4 ff ff       	call   800248 <_panic>

00800e02 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
  800e08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e10:	8b 55 08             	mov    0x8(%ebp),%edx
  800e13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e16:	b8 08 00 00 00       	mov    $0x8,%eax
  800e1b:	89 df                	mov    %ebx,%edi
  800e1d:	89 de                	mov    %ebx,%esi
  800e1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e21:	85 c0                	test   %eax,%eax
  800e23:	7f 08                	jg     800e2d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e28:	5b                   	pop    %ebx
  800e29:	5e                   	pop    %esi
  800e2a:	5f                   	pop    %edi
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2d:	83 ec 0c             	sub    $0xc,%esp
  800e30:	50                   	push   %eax
  800e31:	6a 08                	push   $0x8
  800e33:	68 ff 26 80 00       	push   $0x8026ff
  800e38:	6a 23                	push   $0x23
  800e3a:	68 1c 27 80 00       	push   $0x80271c
  800e3f:	e8 04 f4 ff ff       	call   800248 <_panic>

00800e44 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	57                   	push   %edi
  800e48:	56                   	push   %esi
  800e49:	53                   	push   %ebx
  800e4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e52:	8b 55 08             	mov    0x8(%ebp),%edx
  800e55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e58:	b8 09 00 00 00       	mov    $0x9,%eax
  800e5d:	89 df                	mov    %ebx,%edi
  800e5f:	89 de                	mov    %ebx,%esi
  800e61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e63:	85 c0                	test   %eax,%eax
  800e65:	7f 08                	jg     800e6f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6a:	5b                   	pop    %ebx
  800e6b:	5e                   	pop    %esi
  800e6c:	5f                   	pop    %edi
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6f:	83 ec 0c             	sub    $0xc,%esp
  800e72:	50                   	push   %eax
  800e73:	6a 09                	push   $0x9
  800e75:	68 ff 26 80 00       	push   $0x8026ff
  800e7a:	6a 23                	push   $0x23
  800e7c:	68 1c 27 80 00       	push   $0x80271c
  800e81:	e8 c2 f3 ff ff       	call   800248 <_panic>

00800e86 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
  800e8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e9f:	89 df                	mov    %ebx,%edi
  800ea1:	89 de                	mov    %ebx,%esi
  800ea3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	7f 08                	jg     800eb1 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eac:	5b                   	pop    %ebx
  800ead:	5e                   	pop    %esi
  800eae:	5f                   	pop    %edi
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb1:	83 ec 0c             	sub    $0xc,%esp
  800eb4:	50                   	push   %eax
  800eb5:	6a 0a                	push   $0xa
  800eb7:	68 ff 26 80 00       	push   $0x8026ff
  800ebc:	6a 23                	push   $0x23
  800ebe:	68 1c 27 80 00       	push   $0x80271c
  800ec3:	e8 80 f3 ff ff       	call   800248 <_panic>

00800ec8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	57                   	push   %edi
  800ecc:	56                   	push   %esi
  800ecd:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ece:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ed9:	be 00 00 00 00       	mov    $0x0,%esi
  800ede:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5f                   	pop    %edi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    

00800eeb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	57                   	push   %edi
  800eef:	56                   	push   %esi
  800ef0:	53                   	push   %ebx
  800ef1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ef4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f01:	89 cb                	mov    %ecx,%ebx
  800f03:	89 cf                	mov    %ecx,%edi
  800f05:	89 ce                	mov    %ecx,%esi
  800f07:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	7f 08                	jg     800f15 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f10:	5b                   	pop    %ebx
  800f11:	5e                   	pop    %esi
  800f12:	5f                   	pop    %edi
  800f13:	5d                   	pop    %ebp
  800f14:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f15:	83 ec 0c             	sub    $0xc,%esp
  800f18:	50                   	push   %eax
  800f19:	6a 0d                	push   $0xd
  800f1b:	68 ff 26 80 00       	push   $0x8026ff
  800f20:	6a 23                	push   $0x23
  800f22:	68 1c 27 80 00       	push   $0x80271c
  800f27:	e8 1c f3 ff ff       	call   800248 <_panic>

00800f2c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	53                   	push   %ebx
  800f30:	83 ec 04             	sub    $0x4,%esp
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f36:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) { //只有因为写操作写时拷贝的地址这中情况，才可以抢救。否则一律panic
  800f38:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f3c:	74 74                	je     800fb2 <pgfault+0x86>
  800f3e:	89 d8                	mov    %ebx,%eax
  800f40:	c1 e8 0c             	shr    $0xc,%eax
  800f43:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f4a:	f6 c4 08             	test   $0x8,%ah
  800f4d:	74 63                	je     800fb2 <pgfault+0x86>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800f4f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, PFTEMP, PTE_U|PTE_P)) < 0)		//将当前进程PFTEMP也映射到当前进程addr指向的物理页
  800f55:	83 ec 0c             	sub    $0xc,%esp
  800f58:	6a 05                	push   $0x5
  800f5a:	68 00 f0 7f 00       	push   $0x7ff000
  800f5f:	6a 00                	push   $0x0
  800f61:	53                   	push   %ebx
  800f62:	6a 00                	push   $0x0
  800f64:	e8 15 fe ff ff       	call   800d7e <sys_page_map>
  800f69:	83 c4 20             	add    $0x20,%esp
  800f6c:	85 c0                	test   %eax,%eax
  800f6e:	78 56                	js     800fc6 <pgfault+0x9a>
		panic("sys_page_map: %e", r);
	if ((r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W)) < 0)	//令当前进程addr指向新分配的物理页
  800f70:	83 ec 04             	sub    $0x4,%esp
  800f73:	6a 07                	push   $0x7
  800f75:	53                   	push   %ebx
  800f76:	6a 00                	push   $0x0
  800f78:	e8 be fd ff ff       	call   800d3b <sys_page_alloc>
  800f7d:	83 c4 10             	add    $0x10,%esp
  800f80:	85 c0                	test   %eax,%eax
  800f82:	78 54                	js     800fd8 <pgfault+0xac>
		panic("sys_page_alloc: %e", r);
	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800f84:	83 ec 04             	sub    $0x4,%esp
  800f87:	68 00 10 00 00       	push   $0x1000
  800f8c:	68 00 f0 7f 00       	push   $0x7ff000
  800f91:	53                   	push   %ebx
  800f92:	e8 39 fb ff ff       	call   800ad0 <memmove>
	if ((r = sys_page_unmap(0, PFTEMP)) < 0)					//解除当前进程PFTEMP映射
  800f97:	83 c4 08             	add    $0x8,%esp
  800f9a:	68 00 f0 7f 00       	push   $0x7ff000
  800f9f:	6a 00                	push   $0x0
  800fa1:	e8 1a fe ff ff       	call   800dc0 <sys_page_unmap>
  800fa6:	83 c4 10             	add    $0x10,%esp
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	78 3d                	js     800fea <pgfault+0xbe>
		panic("sys_page_unmap: %e", r);
}
  800fad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fb0:	c9                   	leave  
  800fb1:	c3                   	ret    
		panic("pgfault():not cow");
  800fb2:	83 ec 04             	sub    $0x4,%esp
  800fb5:	68 2a 27 80 00       	push   $0x80272a
  800fba:	6a 1d                	push   $0x1d
  800fbc:	68 3c 27 80 00       	push   $0x80273c
  800fc1:	e8 82 f2 ff ff       	call   800248 <_panic>
		panic("sys_page_map: %e", r);
  800fc6:	50                   	push   %eax
  800fc7:	68 47 27 80 00       	push   $0x802747
  800fcc:	6a 2a                	push   $0x2a
  800fce:	68 3c 27 80 00       	push   $0x80273c
  800fd3:	e8 70 f2 ff ff       	call   800248 <_panic>
		panic("sys_page_alloc: %e", r);
  800fd8:	50                   	push   %eax
  800fd9:	68 58 27 80 00       	push   $0x802758
  800fde:	6a 2c                	push   $0x2c
  800fe0:	68 3c 27 80 00       	push   $0x80273c
  800fe5:	e8 5e f2 ff ff       	call   800248 <_panic>
		panic("sys_page_unmap: %e", r);
  800fea:	50                   	push   %eax
  800feb:	68 6b 27 80 00       	push   $0x80276b
  800ff0:	6a 2f                	push   $0x2f
  800ff2:	68 3c 27 80 00       	push   $0x80273c
  800ff7:	e8 4c f2 ff ff       	call   800248 <_panic>

00800ffc <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	57                   	push   %edi
  801000:	56                   	push   %esi
  801001:	53                   	push   %ebx
  801002:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);	//设置缺页处理函数
  801005:	68 2c 0f 80 00       	push   $0x800f2c
  80100a:	e8 0e 10 00 00       	call   80201d <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80100f:	b8 07 00 00 00       	mov    $0x7,%eax
  801014:	cd 30                	int    $0x30
  801016:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();	//系统调用，只是简单创建一个Env结构，复制当前用户环境寄存器状态，UTOP以下的页目录还没有建立
	if (envid == 0) {				//子进程将走这个逻辑
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	85 c0                	test   %eax,%eax
  80101e:	74 12                	je     801032 <fork+0x36>
  801020:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	if (envid < 0) {
  801022:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801026:	78 26                	js     80104e <fork+0x52>
		panic("sys_exofork: %e", envid);
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801028:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102d:	e9 94 00 00 00       	jmp    8010c6 <fork+0xca>
		thisenv = &envs[ENVX(sys_getenvid())];
  801032:	e8 c6 fc ff ff       	call   800cfd <sys_getenvid>
  801037:	25 ff 03 00 00       	and    $0x3ff,%eax
  80103c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80103f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801044:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801049:	e9 51 01 00 00       	jmp    80119f <fork+0x1a3>
		panic("sys_exofork: %e", envid);
  80104e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801051:	68 7e 27 80 00       	push   $0x80277e
  801056:	6a 6d                	push   $0x6d
  801058:	68 3c 27 80 00       	push   $0x80273c
  80105d:	e8 e6 f1 ff ff       	call   800248 <_panic>
		sys_page_map(0, addr, envid, addr, PTE_SYSCALL);		//对于表示为PTE_SHARE的页，拷贝映射关系，并且两个进程都有读写权限
  801062:	83 ec 0c             	sub    $0xc,%esp
  801065:	68 07 0e 00 00       	push   $0xe07
  80106a:	56                   	push   %esi
  80106b:	57                   	push   %edi
  80106c:	56                   	push   %esi
  80106d:	6a 00                	push   $0x0
  80106f:	e8 0a fd ff ff       	call   800d7e <sys_page_map>
  801074:	83 c4 20             	add    $0x20,%esp
  801077:	eb 3b                	jmp    8010b4 <fork+0xb8>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	68 05 08 00 00       	push   $0x805
  801081:	56                   	push   %esi
  801082:	57                   	push   %edi
  801083:	56                   	push   %esi
  801084:	6a 00                	push   $0x0
  801086:	e8 f3 fc ff ff       	call   800d7e <sys_page_map>
  80108b:	83 c4 20             	add    $0x20,%esp
  80108e:	85 c0                	test   %eax,%eax
  801090:	0f 88 a9 00 00 00    	js     80113f <fork+0x143>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  801096:	83 ec 0c             	sub    $0xc,%esp
  801099:	68 05 08 00 00       	push   $0x805
  80109e:	56                   	push   %esi
  80109f:	6a 00                	push   $0x0
  8010a1:	56                   	push   %esi
  8010a2:	6a 00                	push   $0x0
  8010a4:	e8 d5 fc ff ff       	call   800d7e <sys_page_map>
  8010a9:	83 c4 20             	add    $0x20,%esp
  8010ac:	85 c0                	test   %eax,%eax
  8010ae:	0f 88 9d 00 00 00    	js     801151 <fork+0x155>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010b4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010ba:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010c0:	0f 84 9d 00 00 00    	je     801163 <fork+0x167>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) //为什么uvpt[pagenumber]能访问到第pagenumber项页表条目：https://pdos.csail.mit.edu/6.828/2018/labs/lab4/uvpt.html
  8010c6:	89 d8                	mov    %ebx,%eax
  8010c8:	c1 e8 16             	shr    $0x16,%eax
  8010cb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010d2:	a8 01                	test   $0x1,%al
  8010d4:	74 de                	je     8010b4 <fork+0xb8>
  8010d6:	89 d8                	mov    %ebx,%eax
  8010d8:	c1 e8 0c             	shr    $0xc,%eax
  8010db:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010e2:	f6 c2 01             	test   $0x1,%dl
  8010e5:	74 cd                	je     8010b4 <fork+0xb8>
			&& (uvpt[PGNUM(addr)] & PTE_U)) {
  8010e7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010ee:	f6 c2 04             	test   $0x4,%dl
  8010f1:	74 c1                	je     8010b4 <fork+0xb8>
	void *addr = (void*) (pn * PGSIZE);
  8010f3:	89 c6                	mov    %eax,%esi
  8010f5:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE) {
  8010f8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010ff:	f6 c6 04             	test   $0x4,%dh
  801102:	0f 85 5a ff ff ff    	jne    801062 <fork+0x66>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) { //对于UTOP以下的可写的或者写时拷贝的页，拷贝映射关系的同时，需要同时标记当前进程和子进程的页表项为PTE_COW
  801108:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80110f:	f6 c2 02             	test   $0x2,%dl
  801112:	0f 85 61 ff ff ff    	jne    801079 <fork+0x7d>
  801118:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80111f:	f6 c4 08             	test   $0x8,%ah
  801122:	0f 85 51 ff ff ff    	jne    801079 <fork+0x7d>
		sys_page_map(0, addr, envid, addr, PTE_U|PTE_P);	//对于只读的页，只需要拷贝映射关系即可
  801128:	83 ec 0c             	sub    $0xc,%esp
  80112b:	6a 05                	push   $0x5
  80112d:	56                   	push   %esi
  80112e:	57                   	push   %edi
  80112f:	56                   	push   %esi
  801130:	6a 00                	push   $0x0
  801132:	e8 47 fc ff ff       	call   800d7e <sys_page_map>
  801137:	83 c4 20             	add    $0x20,%esp
  80113a:	e9 75 ff ff ff       	jmp    8010b4 <fork+0xb8>
			panic("sys_page_map：%e", r);
  80113f:	50                   	push   %eax
  801140:	68 8e 27 80 00       	push   $0x80278e
  801145:	6a 48                	push   $0x48
  801147:	68 3c 27 80 00       	push   $0x80273c
  80114c:	e8 f7 f0 ff ff       	call   800248 <_panic>
			panic("sys_page_map：%e", r);
  801151:	50                   	push   %eax
  801152:	68 8e 27 80 00       	push   $0x80278e
  801157:	6a 4a                	push   $0x4a
  801159:	68 3c 27 80 00       	push   $0x80273c
  80115e:	e8 e5 f0 ff ff       	call   800248 <_panic>
			duppage(envid, PGNUM(addr));	//拷贝当前进程映射关系到子进程
		}
	}
	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_W | PTE_U)) < 0)	//为子进程分配异常栈
  801163:	83 ec 04             	sub    $0x4,%esp
  801166:	6a 07                	push   $0x7
  801168:	68 00 f0 bf ee       	push   $0xeebff000
  80116d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801170:	e8 c6 fb ff ff       	call   800d3b <sys_page_alloc>
  801175:	83 c4 10             	add    $0x10,%esp
  801178:	85 c0                	test   %eax,%eax
  80117a:	78 2e                	js     8011aa <fork+0x1ae>
		panic("sys_page_alloc: %e", r);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);		//为子进程设置_pgfault_upcall
  80117c:	83 ec 08             	sub    $0x8,%esp
  80117f:	68 76 20 80 00       	push   $0x802076
  801184:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801187:	57                   	push   %edi
  801188:	e8 f9 fc ff ff       	call   800e86 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)	//设置子进程为ENV_RUNNABLE状态
  80118d:	83 c4 08             	add    $0x8,%esp
  801190:	6a 02                	push   $0x2
  801192:	57                   	push   %edi
  801193:	e8 6a fc ff ff       	call   800e02 <sys_env_set_status>
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	85 c0                	test   %eax,%eax
  80119d:	78 1d                	js     8011bc <fork+0x1c0>
		panic("sys_env_set_status: %e", r);
	return envid;
}
  80119f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a5:	5b                   	pop    %ebx
  8011a6:	5e                   	pop    %esi
  8011a7:	5f                   	pop    %edi
  8011a8:	5d                   	pop    %ebp
  8011a9:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8011aa:	50                   	push   %eax
  8011ab:	68 58 27 80 00       	push   $0x802758
  8011b0:	6a 79                	push   $0x79
  8011b2:	68 3c 27 80 00       	push   $0x80273c
  8011b7:	e8 8c f0 ff ff       	call   800248 <_panic>
		panic("sys_env_set_status: %e", r);
  8011bc:	50                   	push   %eax
  8011bd:	68 a0 27 80 00       	push   $0x8027a0
  8011c2:	6a 7d                	push   $0x7d
  8011c4:	68 3c 27 80 00       	push   $0x80273c
  8011c9:	e8 7a f0 ff ff       	call   800248 <_panic>

008011ce <sfork>:

// Challenge!
int
sfork(void)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011d4:	68 b7 27 80 00       	push   $0x8027b7
  8011d9:	68 85 00 00 00       	push   $0x85
  8011de:	68 3c 27 80 00       	push   $0x80273c
  8011e3:	e8 60 f0 ff ff       	call   800248 <_panic>

008011e8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	56                   	push   %esi
  8011ec:	53                   	push   %ebx
  8011ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  8011f6:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  8011f8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8011fd:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  801200:	83 ec 0c             	sub    $0xc,%esp
  801203:	50                   	push   %eax
  801204:	e8 e2 fc ff ff       	call   800eeb <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	85 c0                	test   %eax,%eax
  80120e:	78 2b                	js     80123b <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  801210:	85 f6                	test   %esi,%esi
  801212:	74 0a                	je     80121e <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801214:	a1 04 40 80 00       	mov    0x804004,%eax
  801219:	8b 40 74             	mov    0x74(%eax),%eax
  80121c:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  80121e:	85 db                	test   %ebx,%ebx
  801220:	74 0a                	je     80122c <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801222:	a1 04 40 80 00       	mov    0x804004,%eax
  801227:	8b 40 78             	mov    0x78(%eax),%eax
  80122a:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  80122c:	a1 04 40 80 00       	mov    0x804004,%eax
  801231:	8b 40 70             	mov    0x70(%eax),%eax
}
  801234:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801237:	5b                   	pop    %ebx
  801238:	5e                   	pop    %esi
  801239:	5d                   	pop    %ebp
  80123a:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80123b:	85 f6                	test   %esi,%esi
  80123d:	74 06                	je     801245 <ipc_recv+0x5d>
  80123f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801245:	85 db                	test   %ebx,%ebx
  801247:	74 eb                	je     801234 <ipc_recv+0x4c>
  801249:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80124f:	eb e3                	jmp    801234 <ipc_recv+0x4c>

00801251 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	57                   	push   %edi
  801255:	56                   	push   %esi
  801256:	53                   	push   %ebx
  801257:	83 ec 0c             	sub    $0xc,%esp
  80125a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80125d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801260:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801263:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  801265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80126a:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  80126d:	ff 75 14             	pushl  0x14(%ebp)
  801270:	53                   	push   %ebx
  801271:	56                   	push   %esi
  801272:	57                   	push   %edi
  801273:	e8 50 fc ff ff       	call   800ec8 <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  801278:	83 c4 10             	add    $0x10,%esp
  80127b:	85 c0                	test   %eax,%eax
  80127d:	74 1e                	je     80129d <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  80127f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801282:	75 07                	jne    80128b <ipc_send+0x3a>
			sys_yield();
  801284:	e8 93 fa ff ff       	call   800d1c <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801289:	eb e2                	jmp    80126d <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  80128b:	50                   	push   %eax
  80128c:	68 cd 27 80 00       	push   $0x8027cd
  801291:	6a 41                	push   $0x41
  801293:	68 db 27 80 00       	push   $0x8027db
  801298:	e8 ab ef ff ff       	call   800248 <_panic>
		}
	}
}
  80129d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a0:	5b                   	pop    %ebx
  8012a1:	5e                   	pop    %esi
  8012a2:	5f                   	pop    %edi
  8012a3:	5d                   	pop    %ebp
  8012a4:	c3                   	ret    

008012a5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8012ab:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8012b0:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8012b3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8012b9:	8b 52 50             	mov    0x50(%edx),%edx
  8012bc:	39 ca                	cmp    %ecx,%edx
  8012be:	74 11                	je     8012d1 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8012c0:	83 c0 01             	add    $0x1,%eax
  8012c3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012c8:	75 e6                	jne    8012b0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8012ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cf:	eb 0b                	jmp    8012dc <ipc_find_env+0x37>
			return envs[i].env_id;
  8012d1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012d4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012d9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8012dc:	5d                   	pop    %ebp
  8012dd:	c3                   	ret    

008012de <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	05 00 00 00 30       	add    $0x30000000,%eax
  8012e9:	c1 e8 0c             	shr    $0xc,%eax
}
  8012ec:	5d                   	pop    %ebp
  8012ed:	c3                   	ret    

008012ee <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012fe:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    

00801305 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80130b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801310:	89 c2                	mov    %eax,%edx
  801312:	c1 ea 16             	shr    $0x16,%edx
  801315:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80131c:	f6 c2 01             	test   $0x1,%dl
  80131f:	74 2a                	je     80134b <fd_alloc+0x46>
  801321:	89 c2                	mov    %eax,%edx
  801323:	c1 ea 0c             	shr    $0xc,%edx
  801326:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80132d:	f6 c2 01             	test   $0x1,%dl
  801330:	74 19                	je     80134b <fd_alloc+0x46>
  801332:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801337:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80133c:	75 d2                	jne    801310 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80133e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801344:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801349:	eb 07                	jmp    801352 <fd_alloc+0x4d>
			*fd_store = fd;
  80134b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80134d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801352:	5d                   	pop    %ebp
  801353:	c3                   	ret    

00801354 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80135a:	83 f8 1f             	cmp    $0x1f,%eax
  80135d:	77 36                	ja     801395 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80135f:	c1 e0 0c             	shl    $0xc,%eax
  801362:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801367:	89 c2                	mov    %eax,%edx
  801369:	c1 ea 16             	shr    $0x16,%edx
  80136c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801373:	f6 c2 01             	test   $0x1,%dl
  801376:	74 24                	je     80139c <fd_lookup+0x48>
  801378:	89 c2                	mov    %eax,%edx
  80137a:	c1 ea 0c             	shr    $0xc,%edx
  80137d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801384:	f6 c2 01             	test   $0x1,%dl
  801387:	74 1a                	je     8013a3 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138c:	89 02                	mov    %eax,(%edx)
	return 0;
  80138e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801393:	5d                   	pop    %ebp
  801394:	c3                   	ret    
		return -E_INVAL;
  801395:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80139a:	eb f7                	jmp    801393 <fd_lookup+0x3f>
		return -E_INVAL;
  80139c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a1:	eb f0                	jmp    801393 <fd_lookup+0x3f>
  8013a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a8:	eb e9                	jmp    801393 <fd_lookup+0x3f>

008013aa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b3:	ba 64 28 80 00       	mov    $0x802864,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013b8:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013bd:	39 08                	cmp    %ecx,(%eax)
  8013bf:	74 33                	je     8013f4 <dev_lookup+0x4a>
  8013c1:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013c4:	8b 02                	mov    (%edx),%eax
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	75 f3                	jne    8013bd <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013ca:	a1 04 40 80 00       	mov    0x804004,%eax
  8013cf:	8b 40 48             	mov    0x48(%eax),%eax
  8013d2:	83 ec 04             	sub    $0x4,%esp
  8013d5:	51                   	push   %ecx
  8013d6:	50                   	push   %eax
  8013d7:	68 e8 27 80 00       	push   $0x8027e8
  8013dc:	e8 42 ef ff ff       	call   800323 <cprintf>
	*dev = 0;
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013ea:	83 c4 10             	add    $0x10,%esp
  8013ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    
			*dev = devtab[i];
  8013f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fe:	eb f2                	jmp    8013f2 <dev_lookup+0x48>

00801400 <fd_close>:
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	57                   	push   %edi
  801404:	56                   	push   %esi
  801405:	53                   	push   %ebx
  801406:	83 ec 1c             	sub    $0x1c,%esp
  801409:	8b 75 08             	mov    0x8(%ebp),%esi
  80140c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80140f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801412:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801413:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801419:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80141c:	50                   	push   %eax
  80141d:	e8 32 ff ff ff       	call   801354 <fd_lookup>
  801422:	89 c3                	mov    %eax,%ebx
  801424:	83 c4 08             	add    $0x8,%esp
  801427:	85 c0                	test   %eax,%eax
  801429:	78 05                	js     801430 <fd_close+0x30>
	    || fd != fd2)
  80142b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80142e:	74 16                	je     801446 <fd_close+0x46>
		return (must_exist ? r : 0);
  801430:	89 f8                	mov    %edi,%eax
  801432:	84 c0                	test   %al,%al
  801434:	b8 00 00 00 00       	mov    $0x0,%eax
  801439:	0f 44 d8             	cmove  %eax,%ebx
}
  80143c:	89 d8                	mov    %ebx,%eax
  80143e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801441:	5b                   	pop    %ebx
  801442:	5e                   	pop    %esi
  801443:	5f                   	pop    %edi
  801444:	5d                   	pop    %ebp
  801445:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80144c:	50                   	push   %eax
  80144d:	ff 36                	pushl  (%esi)
  80144f:	e8 56 ff ff ff       	call   8013aa <dev_lookup>
  801454:	89 c3                	mov    %eax,%ebx
  801456:	83 c4 10             	add    $0x10,%esp
  801459:	85 c0                	test   %eax,%eax
  80145b:	78 15                	js     801472 <fd_close+0x72>
		if (dev->dev_close)
  80145d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801460:	8b 40 10             	mov    0x10(%eax),%eax
  801463:	85 c0                	test   %eax,%eax
  801465:	74 1b                	je     801482 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801467:	83 ec 0c             	sub    $0xc,%esp
  80146a:	56                   	push   %esi
  80146b:	ff d0                	call   *%eax
  80146d:	89 c3                	mov    %eax,%ebx
  80146f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801472:	83 ec 08             	sub    $0x8,%esp
  801475:	56                   	push   %esi
  801476:	6a 00                	push   $0x0
  801478:	e8 43 f9 ff ff       	call   800dc0 <sys_page_unmap>
	return r;
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	eb ba                	jmp    80143c <fd_close+0x3c>
			r = 0;
  801482:	bb 00 00 00 00       	mov    $0x0,%ebx
  801487:	eb e9                	jmp    801472 <fd_close+0x72>

00801489 <close>:

int
close(int fdnum)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80148f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801492:	50                   	push   %eax
  801493:	ff 75 08             	pushl  0x8(%ebp)
  801496:	e8 b9 fe ff ff       	call   801354 <fd_lookup>
  80149b:	83 c4 08             	add    $0x8,%esp
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	78 10                	js     8014b2 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8014a2:	83 ec 08             	sub    $0x8,%esp
  8014a5:	6a 01                	push   $0x1
  8014a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8014aa:	e8 51 ff ff ff       	call   801400 <fd_close>
  8014af:	83 c4 10             	add    $0x10,%esp
}
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <close_all>:

void
close_all(void)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	53                   	push   %ebx
  8014b8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014bb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014c0:	83 ec 0c             	sub    $0xc,%esp
  8014c3:	53                   	push   %ebx
  8014c4:	e8 c0 ff ff ff       	call   801489 <close>
	for (i = 0; i < MAXFD; i++)
  8014c9:	83 c3 01             	add    $0x1,%ebx
  8014cc:	83 c4 10             	add    $0x10,%esp
  8014cf:	83 fb 20             	cmp    $0x20,%ebx
  8014d2:	75 ec                	jne    8014c0 <close_all+0xc>
}
  8014d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	57                   	push   %edi
  8014dd:	56                   	push   %esi
  8014de:	53                   	push   %ebx
  8014df:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014e5:	50                   	push   %eax
  8014e6:	ff 75 08             	pushl  0x8(%ebp)
  8014e9:	e8 66 fe ff ff       	call   801354 <fd_lookup>
  8014ee:	89 c3                	mov    %eax,%ebx
  8014f0:	83 c4 08             	add    $0x8,%esp
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	0f 88 81 00 00 00    	js     80157c <dup+0xa3>
		return r;
	close(newfdnum);
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	ff 75 0c             	pushl  0xc(%ebp)
  801501:	e8 83 ff ff ff       	call   801489 <close>

	newfd = INDEX2FD(newfdnum);
  801506:	8b 75 0c             	mov    0xc(%ebp),%esi
  801509:	c1 e6 0c             	shl    $0xc,%esi
  80150c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801512:	83 c4 04             	add    $0x4,%esp
  801515:	ff 75 e4             	pushl  -0x1c(%ebp)
  801518:	e8 d1 fd ff ff       	call   8012ee <fd2data>
  80151d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80151f:	89 34 24             	mov    %esi,(%esp)
  801522:	e8 c7 fd ff ff       	call   8012ee <fd2data>
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80152c:	89 d8                	mov    %ebx,%eax
  80152e:	c1 e8 16             	shr    $0x16,%eax
  801531:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801538:	a8 01                	test   $0x1,%al
  80153a:	74 11                	je     80154d <dup+0x74>
  80153c:	89 d8                	mov    %ebx,%eax
  80153e:	c1 e8 0c             	shr    $0xc,%eax
  801541:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801548:	f6 c2 01             	test   $0x1,%dl
  80154b:	75 39                	jne    801586 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80154d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801550:	89 d0                	mov    %edx,%eax
  801552:	c1 e8 0c             	shr    $0xc,%eax
  801555:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80155c:	83 ec 0c             	sub    $0xc,%esp
  80155f:	25 07 0e 00 00       	and    $0xe07,%eax
  801564:	50                   	push   %eax
  801565:	56                   	push   %esi
  801566:	6a 00                	push   $0x0
  801568:	52                   	push   %edx
  801569:	6a 00                	push   $0x0
  80156b:	e8 0e f8 ff ff       	call   800d7e <sys_page_map>
  801570:	89 c3                	mov    %eax,%ebx
  801572:	83 c4 20             	add    $0x20,%esp
  801575:	85 c0                	test   %eax,%eax
  801577:	78 31                	js     8015aa <dup+0xd1>
		goto err;

	return newfdnum;
  801579:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80157c:	89 d8                	mov    %ebx,%eax
  80157e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801581:	5b                   	pop    %ebx
  801582:	5e                   	pop    %esi
  801583:	5f                   	pop    %edi
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801586:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	25 07 0e 00 00       	and    $0xe07,%eax
  801595:	50                   	push   %eax
  801596:	57                   	push   %edi
  801597:	6a 00                	push   $0x0
  801599:	53                   	push   %ebx
  80159a:	6a 00                	push   $0x0
  80159c:	e8 dd f7 ff ff       	call   800d7e <sys_page_map>
  8015a1:	89 c3                	mov    %eax,%ebx
  8015a3:	83 c4 20             	add    $0x20,%esp
  8015a6:	85 c0                	test   %eax,%eax
  8015a8:	79 a3                	jns    80154d <dup+0x74>
	sys_page_unmap(0, newfd);
  8015aa:	83 ec 08             	sub    $0x8,%esp
  8015ad:	56                   	push   %esi
  8015ae:	6a 00                	push   $0x0
  8015b0:	e8 0b f8 ff ff       	call   800dc0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015b5:	83 c4 08             	add    $0x8,%esp
  8015b8:	57                   	push   %edi
  8015b9:	6a 00                	push   $0x0
  8015bb:	e8 00 f8 ff ff       	call   800dc0 <sys_page_unmap>
	return r;
  8015c0:	83 c4 10             	add    $0x10,%esp
  8015c3:	eb b7                	jmp    80157c <dup+0xa3>

008015c5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	53                   	push   %ebx
  8015c9:	83 ec 14             	sub    $0x14,%esp
  8015cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d2:	50                   	push   %eax
  8015d3:	53                   	push   %ebx
  8015d4:	e8 7b fd ff ff       	call   801354 <fd_lookup>
  8015d9:	83 c4 08             	add    $0x8,%esp
  8015dc:	85 c0                	test   %eax,%eax
  8015de:	78 3f                	js     80161f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e0:	83 ec 08             	sub    $0x8,%esp
  8015e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e6:	50                   	push   %eax
  8015e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ea:	ff 30                	pushl  (%eax)
  8015ec:	e8 b9 fd ff ff       	call   8013aa <dev_lookup>
  8015f1:	83 c4 10             	add    $0x10,%esp
  8015f4:	85 c0                	test   %eax,%eax
  8015f6:	78 27                	js     80161f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015fb:	8b 42 08             	mov    0x8(%edx),%eax
  8015fe:	83 e0 03             	and    $0x3,%eax
  801601:	83 f8 01             	cmp    $0x1,%eax
  801604:	74 1e                	je     801624 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801609:	8b 40 08             	mov    0x8(%eax),%eax
  80160c:	85 c0                	test   %eax,%eax
  80160e:	74 35                	je     801645 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801610:	83 ec 04             	sub    $0x4,%esp
  801613:	ff 75 10             	pushl  0x10(%ebp)
  801616:	ff 75 0c             	pushl  0xc(%ebp)
  801619:	52                   	push   %edx
  80161a:	ff d0                	call   *%eax
  80161c:	83 c4 10             	add    $0x10,%esp
}
  80161f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801622:	c9                   	leave  
  801623:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801624:	a1 04 40 80 00       	mov    0x804004,%eax
  801629:	8b 40 48             	mov    0x48(%eax),%eax
  80162c:	83 ec 04             	sub    $0x4,%esp
  80162f:	53                   	push   %ebx
  801630:	50                   	push   %eax
  801631:	68 29 28 80 00       	push   $0x802829
  801636:	e8 e8 ec ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  80163b:	83 c4 10             	add    $0x10,%esp
  80163e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801643:	eb da                	jmp    80161f <read+0x5a>
		return -E_NOT_SUPP;
  801645:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80164a:	eb d3                	jmp    80161f <read+0x5a>

0080164c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	57                   	push   %edi
  801650:	56                   	push   %esi
  801651:	53                   	push   %ebx
  801652:	83 ec 0c             	sub    $0xc,%esp
  801655:	8b 7d 08             	mov    0x8(%ebp),%edi
  801658:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80165b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801660:	39 f3                	cmp    %esi,%ebx
  801662:	73 25                	jae    801689 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801664:	83 ec 04             	sub    $0x4,%esp
  801667:	89 f0                	mov    %esi,%eax
  801669:	29 d8                	sub    %ebx,%eax
  80166b:	50                   	push   %eax
  80166c:	89 d8                	mov    %ebx,%eax
  80166e:	03 45 0c             	add    0xc(%ebp),%eax
  801671:	50                   	push   %eax
  801672:	57                   	push   %edi
  801673:	e8 4d ff ff ff       	call   8015c5 <read>
		if (m < 0)
  801678:	83 c4 10             	add    $0x10,%esp
  80167b:	85 c0                	test   %eax,%eax
  80167d:	78 08                	js     801687 <readn+0x3b>
			return m;
		if (m == 0)
  80167f:	85 c0                	test   %eax,%eax
  801681:	74 06                	je     801689 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801683:	01 c3                	add    %eax,%ebx
  801685:	eb d9                	jmp    801660 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801687:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801689:	89 d8                	mov    %ebx,%eax
  80168b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80168e:	5b                   	pop    %ebx
  80168f:	5e                   	pop    %esi
  801690:	5f                   	pop    %edi
  801691:	5d                   	pop    %ebp
  801692:	c3                   	ret    

00801693 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	53                   	push   %ebx
  801697:	83 ec 14             	sub    $0x14,%esp
  80169a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80169d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a0:	50                   	push   %eax
  8016a1:	53                   	push   %ebx
  8016a2:	e8 ad fc ff ff       	call   801354 <fd_lookup>
  8016a7:	83 c4 08             	add    $0x8,%esp
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	78 3a                	js     8016e8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b4:	50                   	push   %eax
  8016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b8:	ff 30                	pushl  (%eax)
  8016ba:	e8 eb fc ff ff       	call   8013aa <dev_lookup>
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	78 22                	js     8016e8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016cd:	74 1e                	je     8016ed <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d2:	8b 52 0c             	mov    0xc(%edx),%edx
  8016d5:	85 d2                	test   %edx,%edx
  8016d7:	74 35                	je     80170e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016d9:	83 ec 04             	sub    $0x4,%esp
  8016dc:	ff 75 10             	pushl  0x10(%ebp)
  8016df:	ff 75 0c             	pushl  0xc(%ebp)
  8016e2:	50                   	push   %eax
  8016e3:	ff d2                	call   *%edx
  8016e5:	83 c4 10             	add    $0x10,%esp
}
  8016e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016ed:	a1 04 40 80 00       	mov    0x804004,%eax
  8016f2:	8b 40 48             	mov    0x48(%eax),%eax
  8016f5:	83 ec 04             	sub    $0x4,%esp
  8016f8:	53                   	push   %ebx
  8016f9:	50                   	push   %eax
  8016fa:	68 45 28 80 00       	push   $0x802845
  8016ff:	e8 1f ec ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  801704:	83 c4 10             	add    $0x10,%esp
  801707:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80170c:	eb da                	jmp    8016e8 <write+0x55>
		return -E_NOT_SUPP;
  80170e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801713:	eb d3                	jmp    8016e8 <write+0x55>

00801715 <seek>:

int
seek(int fdnum, off_t offset)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80171b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80171e:	50                   	push   %eax
  80171f:	ff 75 08             	pushl  0x8(%ebp)
  801722:	e8 2d fc ff ff       	call   801354 <fd_lookup>
  801727:	83 c4 08             	add    $0x8,%esp
  80172a:	85 c0                	test   %eax,%eax
  80172c:	78 0e                	js     80173c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80172e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801731:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801734:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	53                   	push   %ebx
  801742:	83 ec 14             	sub    $0x14,%esp
  801745:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801748:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80174b:	50                   	push   %eax
  80174c:	53                   	push   %ebx
  80174d:	e8 02 fc ff ff       	call   801354 <fd_lookup>
  801752:	83 c4 08             	add    $0x8,%esp
  801755:	85 c0                	test   %eax,%eax
  801757:	78 37                	js     801790 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801759:	83 ec 08             	sub    $0x8,%esp
  80175c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175f:	50                   	push   %eax
  801760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801763:	ff 30                	pushl  (%eax)
  801765:	e8 40 fc ff ff       	call   8013aa <dev_lookup>
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	85 c0                	test   %eax,%eax
  80176f:	78 1f                	js     801790 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801774:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801778:	74 1b                	je     801795 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80177a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80177d:	8b 52 18             	mov    0x18(%edx),%edx
  801780:	85 d2                	test   %edx,%edx
  801782:	74 32                	je     8017b6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801784:	83 ec 08             	sub    $0x8,%esp
  801787:	ff 75 0c             	pushl  0xc(%ebp)
  80178a:	50                   	push   %eax
  80178b:	ff d2                	call   *%edx
  80178d:	83 c4 10             	add    $0x10,%esp
}
  801790:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801793:	c9                   	leave  
  801794:	c3                   	ret    
			thisenv->env_id, fdnum);
  801795:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80179a:	8b 40 48             	mov    0x48(%eax),%eax
  80179d:	83 ec 04             	sub    $0x4,%esp
  8017a0:	53                   	push   %ebx
  8017a1:	50                   	push   %eax
  8017a2:	68 08 28 80 00       	push   $0x802808
  8017a7:	e8 77 eb ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b4:	eb da                	jmp    801790 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8017b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017bb:	eb d3                	jmp    801790 <ftruncate+0x52>

008017bd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	53                   	push   %ebx
  8017c1:	83 ec 14             	sub    $0x14,%esp
  8017c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ca:	50                   	push   %eax
  8017cb:	ff 75 08             	pushl  0x8(%ebp)
  8017ce:	e8 81 fb ff ff       	call   801354 <fd_lookup>
  8017d3:	83 c4 08             	add    $0x8,%esp
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	78 4b                	js     801825 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017da:	83 ec 08             	sub    $0x8,%esp
  8017dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e0:	50                   	push   %eax
  8017e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e4:	ff 30                	pushl  (%eax)
  8017e6:	e8 bf fb ff ff       	call   8013aa <dev_lookup>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	78 33                	js     801825 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017f9:	74 2f                	je     80182a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017fb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017fe:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801805:	00 00 00 
	stat->st_isdir = 0;
  801808:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80180f:	00 00 00 
	stat->st_dev = dev;
  801812:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801818:	83 ec 08             	sub    $0x8,%esp
  80181b:	53                   	push   %ebx
  80181c:	ff 75 f0             	pushl  -0x10(%ebp)
  80181f:	ff 50 14             	call   *0x14(%eax)
  801822:	83 c4 10             	add    $0x10,%esp
}
  801825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801828:	c9                   	leave  
  801829:	c3                   	ret    
		return -E_NOT_SUPP;
  80182a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80182f:	eb f4                	jmp    801825 <fstat+0x68>

00801831 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	56                   	push   %esi
  801835:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801836:	83 ec 08             	sub    $0x8,%esp
  801839:	6a 00                	push   $0x0
  80183b:	ff 75 08             	pushl  0x8(%ebp)
  80183e:	e8 30 02 00 00       	call   801a73 <open>
  801843:	89 c3                	mov    %eax,%ebx
  801845:	83 c4 10             	add    $0x10,%esp
  801848:	85 c0                	test   %eax,%eax
  80184a:	78 1b                	js     801867 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80184c:	83 ec 08             	sub    $0x8,%esp
  80184f:	ff 75 0c             	pushl  0xc(%ebp)
  801852:	50                   	push   %eax
  801853:	e8 65 ff ff ff       	call   8017bd <fstat>
  801858:	89 c6                	mov    %eax,%esi
	close(fd);
  80185a:	89 1c 24             	mov    %ebx,(%esp)
  80185d:	e8 27 fc ff ff       	call   801489 <close>
	return r;
  801862:	83 c4 10             	add    $0x10,%esp
  801865:	89 f3                	mov    %esi,%ebx
}
  801867:	89 d8                	mov    %ebx,%eax
  801869:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186c:	5b                   	pop    %ebx
  80186d:	5e                   	pop    %esi
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    

00801870 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	56                   	push   %esi
  801874:	53                   	push   %ebx
  801875:	89 c6                	mov    %eax,%esi
  801877:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801879:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801880:	74 27                	je     8018a9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801882:	6a 07                	push   $0x7
  801884:	68 00 50 80 00       	push   $0x805000
  801889:	56                   	push   %esi
  80188a:	ff 35 00 40 80 00    	pushl  0x804000
  801890:	e8 bc f9 ff ff       	call   801251 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801895:	83 c4 0c             	add    $0xc,%esp
  801898:	6a 00                	push   $0x0
  80189a:	53                   	push   %ebx
  80189b:	6a 00                	push   $0x0
  80189d:	e8 46 f9 ff ff       	call   8011e8 <ipc_recv>
}
  8018a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a5:	5b                   	pop    %ebx
  8018a6:	5e                   	pop    %esi
  8018a7:	5d                   	pop    %ebp
  8018a8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018a9:	83 ec 0c             	sub    $0xc,%esp
  8018ac:	6a 01                	push   $0x1
  8018ae:	e8 f2 f9 ff ff       	call   8012a5 <ipc_find_env>
  8018b3:	a3 00 40 80 00       	mov    %eax,0x804000
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	eb c5                	jmp    801882 <fsipc+0x12>

008018bd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018db:	b8 02 00 00 00       	mov    $0x2,%eax
  8018e0:	e8 8b ff ff ff       	call   801870 <fsipc>
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <devfile_flush>:
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fd:	b8 06 00 00 00       	mov    $0x6,%eax
  801902:	e8 69 ff ff ff       	call   801870 <fsipc>
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <devfile_stat>:
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	53                   	push   %ebx
  80190d:	83 ec 04             	sub    $0x4,%esp
  801910:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8b 40 0c             	mov    0xc(%eax),%eax
  801919:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80191e:	ba 00 00 00 00       	mov    $0x0,%edx
  801923:	b8 05 00 00 00       	mov    $0x5,%eax
  801928:	e8 43 ff ff ff       	call   801870 <fsipc>
  80192d:	85 c0                	test   %eax,%eax
  80192f:	78 2c                	js     80195d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801931:	83 ec 08             	sub    $0x8,%esp
  801934:	68 00 50 80 00       	push   $0x805000
  801939:	53                   	push   %ebx
  80193a:	e8 03 f0 ff ff       	call   800942 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80193f:	a1 80 50 80 00       	mov    0x805080,%eax
  801944:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80194a:	a1 84 50 80 00       	mov    0x805084,%eax
  80194f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80195d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <devfile_write>:
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	53                   	push   %ebx
  801966:	83 ec 08             	sub    $0x8,%esp
  801969:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  80196c:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801972:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801977:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	8b 40 0c             	mov    0xc(%eax),%eax
  801980:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801985:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80198b:	53                   	push   %ebx
  80198c:	ff 75 0c             	pushl  0xc(%ebp)
  80198f:	68 08 50 80 00       	push   $0x805008
  801994:	e8 37 f1 ff ff       	call   800ad0 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801999:	ba 00 00 00 00       	mov    $0x0,%edx
  80199e:	b8 04 00 00 00       	mov    $0x4,%eax
  8019a3:	e8 c8 fe ff ff       	call   801870 <fsipc>
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	78 0b                	js     8019ba <devfile_write+0x58>
	assert(r <= n);
  8019af:	39 d8                	cmp    %ebx,%eax
  8019b1:	77 0c                	ja     8019bf <devfile_write+0x5d>
	assert(r <= PGSIZE);
  8019b3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019b8:	7f 1e                	jg     8019d8 <devfile_write+0x76>
}
  8019ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    
	assert(r <= n);
  8019bf:	68 74 28 80 00       	push   $0x802874
  8019c4:	68 7b 28 80 00       	push   $0x80287b
  8019c9:	68 98 00 00 00       	push   $0x98
  8019ce:	68 90 28 80 00       	push   $0x802890
  8019d3:	e8 70 e8 ff ff       	call   800248 <_panic>
	assert(r <= PGSIZE);
  8019d8:	68 9b 28 80 00       	push   $0x80289b
  8019dd:	68 7b 28 80 00       	push   $0x80287b
  8019e2:	68 99 00 00 00       	push   $0x99
  8019e7:	68 90 28 80 00       	push   $0x802890
  8019ec:	e8 57 e8 ff ff       	call   800248 <_panic>

008019f1 <devfile_read>:
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	56                   	push   %esi
  8019f5:	53                   	push   %ebx
  8019f6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ff:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a04:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0f:	b8 03 00 00 00       	mov    $0x3,%eax
  801a14:	e8 57 fe ff ff       	call   801870 <fsipc>
  801a19:	89 c3                	mov    %eax,%ebx
  801a1b:	85 c0                	test   %eax,%eax
  801a1d:	78 1f                	js     801a3e <devfile_read+0x4d>
	assert(r <= n);
  801a1f:	39 f0                	cmp    %esi,%eax
  801a21:	77 24                	ja     801a47 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a23:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a28:	7f 33                	jg     801a5d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a2a:	83 ec 04             	sub    $0x4,%esp
  801a2d:	50                   	push   %eax
  801a2e:	68 00 50 80 00       	push   $0x805000
  801a33:	ff 75 0c             	pushl  0xc(%ebp)
  801a36:	e8 95 f0 ff ff       	call   800ad0 <memmove>
	return r;
  801a3b:	83 c4 10             	add    $0x10,%esp
}
  801a3e:	89 d8                	mov    %ebx,%eax
  801a40:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a43:	5b                   	pop    %ebx
  801a44:	5e                   	pop    %esi
  801a45:	5d                   	pop    %ebp
  801a46:	c3                   	ret    
	assert(r <= n);
  801a47:	68 74 28 80 00       	push   $0x802874
  801a4c:	68 7b 28 80 00       	push   $0x80287b
  801a51:	6a 7c                	push   $0x7c
  801a53:	68 90 28 80 00       	push   $0x802890
  801a58:	e8 eb e7 ff ff       	call   800248 <_panic>
	assert(r <= PGSIZE);
  801a5d:	68 9b 28 80 00       	push   $0x80289b
  801a62:	68 7b 28 80 00       	push   $0x80287b
  801a67:	6a 7d                	push   $0x7d
  801a69:	68 90 28 80 00       	push   $0x802890
  801a6e:	e8 d5 e7 ff ff       	call   800248 <_panic>

00801a73 <open>:
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	56                   	push   %esi
  801a77:	53                   	push   %ebx
  801a78:	83 ec 1c             	sub    $0x1c,%esp
  801a7b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a7e:	56                   	push   %esi
  801a7f:	e8 87 ee ff ff       	call   80090b <strlen>
  801a84:	83 c4 10             	add    $0x10,%esp
  801a87:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a8c:	7f 6c                	jg     801afa <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a8e:	83 ec 0c             	sub    $0xc,%esp
  801a91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a94:	50                   	push   %eax
  801a95:	e8 6b f8 ff ff       	call   801305 <fd_alloc>
  801a9a:	89 c3                	mov    %eax,%ebx
  801a9c:	83 c4 10             	add    $0x10,%esp
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	78 3c                	js     801adf <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801aa3:	83 ec 08             	sub    $0x8,%esp
  801aa6:	56                   	push   %esi
  801aa7:	68 00 50 80 00       	push   $0x805000
  801aac:	e8 91 ee ff ff       	call   800942 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab4:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ab9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801abc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac1:	e8 aa fd ff ff       	call   801870 <fsipc>
  801ac6:	89 c3                	mov    %eax,%ebx
  801ac8:	83 c4 10             	add    $0x10,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	78 19                	js     801ae8 <open+0x75>
	return fd2num(fd);
  801acf:	83 ec 0c             	sub    $0xc,%esp
  801ad2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad5:	e8 04 f8 ff ff       	call   8012de <fd2num>
  801ada:	89 c3                	mov    %eax,%ebx
  801adc:	83 c4 10             	add    $0x10,%esp
}
  801adf:	89 d8                	mov    %ebx,%eax
  801ae1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae4:	5b                   	pop    %ebx
  801ae5:	5e                   	pop    %esi
  801ae6:	5d                   	pop    %ebp
  801ae7:	c3                   	ret    
		fd_close(fd, 0);
  801ae8:	83 ec 08             	sub    $0x8,%esp
  801aeb:	6a 00                	push   $0x0
  801aed:	ff 75 f4             	pushl  -0xc(%ebp)
  801af0:	e8 0b f9 ff ff       	call   801400 <fd_close>
		return r;
  801af5:	83 c4 10             	add    $0x10,%esp
  801af8:	eb e5                	jmp    801adf <open+0x6c>
		return -E_BAD_PATH;
  801afa:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aff:	eb de                	jmp    801adf <open+0x6c>

00801b01 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b07:	ba 00 00 00 00       	mov    $0x0,%edx
  801b0c:	b8 08 00 00 00       	mov    $0x8,%eax
  801b11:	e8 5a fd ff ff       	call   801870 <fsipc>
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b1e:	89 d0                	mov    %edx,%eax
  801b20:	c1 e8 16             	shr    $0x16,%eax
  801b23:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801b2a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801b2f:	f6 c1 01             	test   $0x1,%cl
  801b32:	74 1d                	je     801b51 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801b34:	c1 ea 0c             	shr    $0xc,%edx
  801b37:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801b3e:	f6 c2 01             	test   $0x1,%dl
  801b41:	74 0e                	je     801b51 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b43:	c1 ea 0c             	shr    $0xc,%edx
  801b46:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801b4d:	ef 
  801b4e:	0f b7 c0             	movzwl %ax,%eax
}
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    

00801b53 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	56                   	push   %esi
  801b57:	53                   	push   %ebx
  801b58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b5b:	83 ec 0c             	sub    $0xc,%esp
  801b5e:	ff 75 08             	pushl  0x8(%ebp)
  801b61:	e8 88 f7 ff ff       	call   8012ee <fd2data>
  801b66:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b68:	83 c4 08             	add    $0x8,%esp
  801b6b:	68 a7 28 80 00       	push   $0x8028a7
  801b70:	53                   	push   %ebx
  801b71:	e8 cc ed ff ff       	call   800942 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b76:	8b 46 04             	mov    0x4(%esi),%eax
  801b79:	2b 06                	sub    (%esi),%eax
  801b7b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b81:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b88:	00 00 00 
	stat->st_dev = &devpipe;
  801b8b:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b92:	30 80 00 
	return 0;
}
  801b95:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b9d:	5b                   	pop    %ebx
  801b9e:	5e                   	pop    %esi
  801b9f:	5d                   	pop    %ebp
  801ba0:	c3                   	ret    

00801ba1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	53                   	push   %ebx
  801ba5:	83 ec 0c             	sub    $0xc,%esp
  801ba8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bab:	53                   	push   %ebx
  801bac:	6a 00                	push   $0x0
  801bae:	e8 0d f2 ff ff       	call   800dc0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bb3:	89 1c 24             	mov    %ebx,(%esp)
  801bb6:	e8 33 f7 ff ff       	call   8012ee <fd2data>
  801bbb:	83 c4 08             	add    $0x8,%esp
  801bbe:	50                   	push   %eax
  801bbf:	6a 00                	push   $0x0
  801bc1:	e8 fa f1 ff ff       	call   800dc0 <sys_page_unmap>
}
  801bc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <_pipeisclosed>:
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	57                   	push   %edi
  801bcf:	56                   	push   %esi
  801bd0:	53                   	push   %ebx
  801bd1:	83 ec 1c             	sub    $0x1c,%esp
  801bd4:	89 c7                	mov    %eax,%edi
  801bd6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bd8:	a1 04 40 80 00       	mov    0x804004,%eax
  801bdd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801be0:	83 ec 0c             	sub    $0xc,%esp
  801be3:	57                   	push   %edi
  801be4:	e8 2f ff ff ff       	call   801b18 <pageref>
  801be9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bec:	89 34 24             	mov    %esi,(%esp)
  801bef:	e8 24 ff ff ff       	call   801b18 <pageref>
		nn = thisenv->env_runs;
  801bf4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bfa:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bfd:	83 c4 10             	add    $0x10,%esp
  801c00:	39 cb                	cmp    %ecx,%ebx
  801c02:	74 1b                	je     801c1f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c04:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c07:	75 cf                	jne    801bd8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c09:	8b 42 58             	mov    0x58(%edx),%eax
  801c0c:	6a 01                	push   $0x1
  801c0e:	50                   	push   %eax
  801c0f:	53                   	push   %ebx
  801c10:	68 ae 28 80 00       	push   $0x8028ae
  801c15:	e8 09 e7 ff ff       	call   800323 <cprintf>
  801c1a:	83 c4 10             	add    $0x10,%esp
  801c1d:	eb b9                	jmp    801bd8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c1f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c22:	0f 94 c0             	sete   %al
  801c25:	0f b6 c0             	movzbl %al,%eax
}
  801c28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5f                   	pop    %edi
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    

00801c30 <devpipe_write>:
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	57                   	push   %edi
  801c34:	56                   	push   %esi
  801c35:	53                   	push   %ebx
  801c36:	83 ec 28             	sub    $0x28,%esp
  801c39:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c3c:	56                   	push   %esi
  801c3d:	e8 ac f6 ff ff       	call   8012ee <fd2data>
  801c42:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c44:	83 c4 10             	add    $0x10,%esp
  801c47:	bf 00 00 00 00       	mov    $0x0,%edi
  801c4c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c4f:	74 4f                	je     801ca0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c51:	8b 43 04             	mov    0x4(%ebx),%eax
  801c54:	8b 0b                	mov    (%ebx),%ecx
  801c56:	8d 51 20             	lea    0x20(%ecx),%edx
  801c59:	39 d0                	cmp    %edx,%eax
  801c5b:	72 14                	jb     801c71 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c5d:	89 da                	mov    %ebx,%edx
  801c5f:	89 f0                	mov    %esi,%eax
  801c61:	e8 65 ff ff ff       	call   801bcb <_pipeisclosed>
  801c66:	85 c0                	test   %eax,%eax
  801c68:	75 3a                	jne    801ca4 <devpipe_write+0x74>
			sys_yield();
  801c6a:	e8 ad f0 ff ff       	call   800d1c <sys_yield>
  801c6f:	eb e0                	jmp    801c51 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c74:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c78:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c7b:	89 c2                	mov    %eax,%edx
  801c7d:	c1 fa 1f             	sar    $0x1f,%edx
  801c80:	89 d1                	mov    %edx,%ecx
  801c82:	c1 e9 1b             	shr    $0x1b,%ecx
  801c85:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c88:	83 e2 1f             	and    $0x1f,%edx
  801c8b:	29 ca                	sub    %ecx,%edx
  801c8d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c91:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c95:	83 c0 01             	add    $0x1,%eax
  801c98:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c9b:	83 c7 01             	add    $0x1,%edi
  801c9e:	eb ac                	jmp    801c4c <devpipe_write+0x1c>
	return i;
  801ca0:	89 f8                	mov    %edi,%eax
  801ca2:	eb 05                	jmp    801ca9 <devpipe_write+0x79>
				return 0;
  801ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cac:	5b                   	pop    %ebx
  801cad:	5e                   	pop    %esi
  801cae:	5f                   	pop    %edi
  801caf:	5d                   	pop    %ebp
  801cb0:	c3                   	ret    

00801cb1 <devpipe_read>:
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	57                   	push   %edi
  801cb5:	56                   	push   %esi
  801cb6:	53                   	push   %ebx
  801cb7:	83 ec 18             	sub    $0x18,%esp
  801cba:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cbd:	57                   	push   %edi
  801cbe:	e8 2b f6 ff ff       	call   8012ee <fd2data>
  801cc3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cc5:	83 c4 10             	add    $0x10,%esp
  801cc8:	be 00 00 00 00       	mov    $0x0,%esi
  801ccd:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cd0:	74 47                	je     801d19 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801cd2:	8b 03                	mov    (%ebx),%eax
  801cd4:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cd7:	75 22                	jne    801cfb <devpipe_read+0x4a>
			if (i > 0)
  801cd9:	85 f6                	test   %esi,%esi
  801cdb:	75 14                	jne    801cf1 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801cdd:	89 da                	mov    %ebx,%edx
  801cdf:	89 f8                	mov    %edi,%eax
  801ce1:	e8 e5 fe ff ff       	call   801bcb <_pipeisclosed>
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	75 33                	jne    801d1d <devpipe_read+0x6c>
			sys_yield();
  801cea:	e8 2d f0 ff ff       	call   800d1c <sys_yield>
  801cef:	eb e1                	jmp    801cd2 <devpipe_read+0x21>
				return i;
  801cf1:	89 f0                	mov    %esi,%eax
}
  801cf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf6:	5b                   	pop    %ebx
  801cf7:	5e                   	pop    %esi
  801cf8:	5f                   	pop    %edi
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cfb:	99                   	cltd   
  801cfc:	c1 ea 1b             	shr    $0x1b,%edx
  801cff:	01 d0                	add    %edx,%eax
  801d01:	83 e0 1f             	and    $0x1f,%eax
  801d04:	29 d0                	sub    %edx,%eax
  801d06:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d0e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d11:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d14:	83 c6 01             	add    $0x1,%esi
  801d17:	eb b4                	jmp    801ccd <devpipe_read+0x1c>
	return i;
  801d19:	89 f0                	mov    %esi,%eax
  801d1b:	eb d6                	jmp    801cf3 <devpipe_read+0x42>
				return 0;
  801d1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d22:	eb cf                	jmp    801cf3 <devpipe_read+0x42>

00801d24 <pipe>:
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	56                   	push   %esi
  801d28:	53                   	push   %ebx
  801d29:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d2f:	50                   	push   %eax
  801d30:	e8 d0 f5 ff ff       	call   801305 <fd_alloc>
  801d35:	89 c3                	mov    %eax,%ebx
  801d37:	83 c4 10             	add    $0x10,%esp
  801d3a:	85 c0                	test   %eax,%eax
  801d3c:	78 5b                	js     801d99 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d3e:	83 ec 04             	sub    $0x4,%esp
  801d41:	68 07 04 00 00       	push   $0x407
  801d46:	ff 75 f4             	pushl  -0xc(%ebp)
  801d49:	6a 00                	push   $0x0
  801d4b:	e8 eb ef ff ff       	call   800d3b <sys_page_alloc>
  801d50:	89 c3                	mov    %eax,%ebx
  801d52:	83 c4 10             	add    $0x10,%esp
  801d55:	85 c0                	test   %eax,%eax
  801d57:	78 40                	js     801d99 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801d59:	83 ec 0c             	sub    $0xc,%esp
  801d5c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d5f:	50                   	push   %eax
  801d60:	e8 a0 f5 ff ff       	call   801305 <fd_alloc>
  801d65:	89 c3                	mov    %eax,%ebx
  801d67:	83 c4 10             	add    $0x10,%esp
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	78 1b                	js     801d89 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d6e:	83 ec 04             	sub    $0x4,%esp
  801d71:	68 07 04 00 00       	push   $0x407
  801d76:	ff 75 f0             	pushl  -0x10(%ebp)
  801d79:	6a 00                	push   $0x0
  801d7b:	e8 bb ef ff ff       	call   800d3b <sys_page_alloc>
  801d80:	89 c3                	mov    %eax,%ebx
  801d82:	83 c4 10             	add    $0x10,%esp
  801d85:	85 c0                	test   %eax,%eax
  801d87:	79 19                	jns    801da2 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801d89:	83 ec 08             	sub    $0x8,%esp
  801d8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d8f:	6a 00                	push   $0x0
  801d91:	e8 2a f0 ff ff       	call   800dc0 <sys_page_unmap>
  801d96:	83 c4 10             	add    $0x10,%esp
}
  801d99:	89 d8                	mov    %ebx,%eax
  801d9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d9e:	5b                   	pop    %ebx
  801d9f:	5e                   	pop    %esi
  801da0:	5d                   	pop    %ebp
  801da1:	c3                   	ret    
	va = fd2data(fd0);
  801da2:	83 ec 0c             	sub    $0xc,%esp
  801da5:	ff 75 f4             	pushl  -0xc(%ebp)
  801da8:	e8 41 f5 ff ff       	call   8012ee <fd2data>
  801dad:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801daf:	83 c4 0c             	add    $0xc,%esp
  801db2:	68 07 04 00 00       	push   $0x407
  801db7:	50                   	push   %eax
  801db8:	6a 00                	push   $0x0
  801dba:	e8 7c ef ff ff       	call   800d3b <sys_page_alloc>
  801dbf:	89 c3                	mov    %eax,%ebx
  801dc1:	83 c4 10             	add    $0x10,%esp
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	0f 88 8c 00 00 00    	js     801e58 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dcc:	83 ec 0c             	sub    $0xc,%esp
  801dcf:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd2:	e8 17 f5 ff ff       	call   8012ee <fd2data>
  801dd7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801dde:	50                   	push   %eax
  801ddf:	6a 00                	push   $0x0
  801de1:	56                   	push   %esi
  801de2:	6a 00                	push   $0x0
  801de4:	e8 95 ef ff ff       	call   800d7e <sys_page_map>
  801de9:	89 c3                	mov    %eax,%ebx
  801deb:	83 c4 20             	add    $0x20,%esp
  801dee:	85 c0                	test   %eax,%eax
  801df0:	78 58                	js     801e4a <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df5:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801dfb:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0a:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e10:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e15:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e1c:	83 ec 0c             	sub    $0xc,%esp
  801e1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e22:	e8 b7 f4 ff ff       	call   8012de <fd2num>
  801e27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e2a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e2c:	83 c4 04             	add    $0x4,%esp
  801e2f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e32:	e8 a7 f4 ff ff       	call   8012de <fd2num>
  801e37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e3a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e3d:	83 c4 10             	add    $0x10,%esp
  801e40:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e45:	e9 4f ff ff ff       	jmp    801d99 <pipe+0x75>
	sys_page_unmap(0, va);
  801e4a:	83 ec 08             	sub    $0x8,%esp
  801e4d:	56                   	push   %esi
  801e4e:	6a 00                	push   $0x0
  801e50:	e8 6b ef ff ff       	call   800dc0 <sys_page_unmap>
  801e55:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e58:	83 ec 08             	sub    $0x8,%esp
  801e5b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5e:	6a 00                	push   $0x0
  801e60:	e8 5b ef ff ff       	call   800dc0 <sys_page_unmap>
  801e65:	83 c4 10             	add    $0x10,%esp
  801e68:	e9 1c ff ff ff       	jmp    801d89 <pipe+0x65>

00801e6d <pipeisclosed>:
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e76:	50                   	push   %eax
  801e77:	ff 75 08             	pushl  0x8(%ebp)
  801e7a:	e8 d5 f4 ff ff       	call   801354 <fd_lookup>
  801e7f:	83 c4 10             	add    $0x10,%esp
  801e82:	85 c0                	test   %eax,%eax
  801e84:	78 18                	js     801e9e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e86:	83 ec 0c             	sub    $0xc,%esp
  801e89:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8c:	e8 5d f4 ff ff       	call   8012ee <fd2data>
	return _pipeisclosed(fd, p);
  801e91:	89 c2                	mov    %eax,%edx
  801e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e96:	e8 30 fd ff ff       	call   801bcb <_pipeisclosed>
  801e9b:	83 c4 10             	add    $0x10,%esp
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801ea3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea8:	5d                   	pop    %ebp
  801ea9:	c3                   	ret    

00801eaa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801eb0:	68 c6 28 80 00       	push   $0x8028c6
  801eb5:	ff 75 0c             	pushl  0xc(%ebp)
  801eb8:	e8 85 ea ff ff       	call   800942 <strcpy>
	return 0;
}
  801ebd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <devcons_write>:
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	57                   	push   %edi
  801ec8:	56                   	push   %esi
  801ec9:	53                   	push   %ebx
  801eca:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ed0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ed5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801edb:	eb 2f                	jmp    801f0c <devcons_write+0x48>
		m = n - tot;
  801edd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ee0:	29 f3                	sub    %esi,%ebx
  801ee2:	83 fb 7f             	cmp    $0x7f,%ebx
  801ee5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801eea:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801eed:	83 ec 04             	sub    $0x4,%esp
  801ef0:	53                   	push   %ebx
  801ef1:	89 f0                	mov    %esi,%eax
  801ef3:	03 45 0c             	add    0xc(%ebp),%eax
  801ef6:	50                   	push   %eax
  801ef7:	57                   	push   %edi
  801ef8:	e8 d3 eb ff ff       	call   800ad0 <memmove>
		sys_cputs(buf, m);
  801efd:	83 c4 08             	add    $0x8,%esp
  801f00:	53                   	push   %ebx
  801f01:	57                   	push   %edi
  801f02:	e8 78 ed ff ff       	call   800c7f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f07:	01 de                	add    %ebx,%esi
  801f09:	83 c4 10             	add    $0x10,%esp
  801f0c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f0f:	72 cc                	jb     801edd <devcons_write+0x19>
}
  801f11:	89 f0                	mov    %esi,%eax
  801f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f16:	5b                   	pop    %ebx
  801f17:	5e                   	pop    %esi
  801f18:	5f                   	pop    %edi
  801f19:	5d                   	pop    %ebp
  801f1a:	c3                   	ret    

00801f1b <devcons_read>:
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	83 ec 08             	sub    $0x8,%esp
  801f21:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f2a:	75 07                	jne    801f33 <devcons_read+0x18>
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    
		sys_yield();
  801f2e:	e8 e9 ed ff ff       	call   800d1c <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801f33:	e8 65 ed ff ff       	call   800c9d <sys_cgetc>
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	74 f2                	je     801f2e <devcons_read+0x13>
	if (c < 0)
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	78 ec                	js     801f2c <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801f40:	83 f8 04             	cmp    $0x4,%eax
  801f43:	74 0c                	je     801f51 <devcons_read+0x36>
	*(char*)vbuf = c;
  801f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f48:	88 02                	mov    %al,(%edx)
	return 1;
  801f4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4f:	eb db                	jmp    801f2c <devcons_read+0x11>
		return 0;
  801f51:	b8 00 00 00 00       	mov    $0x0,%eax
  801f56:	eb d4                	jmp    801f2c <devcons_read+0x11>

00801f58 <cputchar>:
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f61:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f64:	6a 01                	push   $0x1
  801f66:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f69:	50                   	push   %eax
  801f6a:	e8 10 ed ff ff       	call   800c7f <sys_cputs>
}
  801f6f:	83 c4 10             	add    $0x10,%esp
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <getchar>:
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f7a:	6a 01                	push   $0x1
  801f7c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f7f:	50                   	push   %eax
  801f80:	6a 00                	push   $0x0
  801f82:	e8 3e f6 ff ff       	call   8015c5 <read>
	if (r < 0)
  801f87:	83 c4 10             	add    $0x10,%esp
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	78 08                	js     801f96 <getchar+0x22>
	if (r < 1)
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	7e 06                	jle    801f98 <getchar+0x24>
	return c;
  801f92:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    
		return -E_EOF;
  801f98:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f9d:	eb f7                	jmp    801f96 <getchar+0x22>

00801f9f <iscons>:
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fa5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa8:	50                   	push   %eax
  801fa9:	ff 75 08             	pushl  0x8(%ebp)
  801fac:	e8 a3 f3 ff ff       	call   801354 <fd_lookup>
  801fb1:	83 c4 10             	add    $0x10,%esp
  801fb4:	85 c0                	test   %eax,%eax
  801fb6:	78 11                	js     801fc9 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fc1:	39 10                	cmp    %edx,(%eax)
  801fc3:	0f 94 c0             	sete   %al
  801fc6:	0f b6 c0             	movzbl %al,%eax
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <opencons>:
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fd1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd4:	50                   	push   %eax
  801fd5:	e8 2b f3 ff ff       	call   801305 <fd_alloc>
  801fda:	83 c4 10             	add    $0x10,%esp
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	78 3a                	js     80201b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fe1:	83 ec 04             	sub    $0x4,%esp
  801fe4:	68 07 04 00 00       	push   $0x407
  801fe9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fec:	6a 00                	push   $0x0
  801fee:	e8 48 ed ff ff       	call   800d3b <sys_page_alloc>
  801ff3:	83 c4 10             	add    $0x10,%esp
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	78 21                	js     80201b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802003:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802008:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80200f:	83 ec 0c             	sub    $0xc,%esp
  802012:	50                   	push   %eax
  802013:	e8 c6 f2 ff ff       	call   8012de <fd2num>
  802018:	83 c4 10             	add    $0x10,%esp
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802023:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80202a:	74 0a                	je     802036 <set_pgfault_handler+0x19>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    
		int r = sys_page_alloc(0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P);	//为当前进程分配异常栈
  802036:	83 ec 04             	sub    $0x4,%esp
  802039:	6a 07                	push   $0x7
  80203b:	68 00 f0 bf ee       	push   $0xeebff000
  802040:	6a 00                	push   $0x0
  802042:	e8 f4 ec ff ff       	call   800d3b <sys_page_alloc>
		if (r < 0) {
  802047:	83 c4 10             	add    $0x10,%esp
  80204a:	85 c0                	test   %eax,%eax
  80204c:	78 14                	js     802062 <set_pgfault_handler+0x45>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
  80204e:	83 ec 08             	sub    $0x8,%esp
  802051:	68 76 20 80 00       	push   $0x802076
  802056:	6a 00                	push   $0x0
  802058:	e8 29 ee ff ff       	call   800e86 <sys_env_set_pgfault_upcall>
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	eb ca                	jmp    80202c <set_pgfault_handler+0xf>
			panic("set_pgfault_handler:sys_page_alloc failed");;
  802062:	83 ec 04             	sub    $0x4,%esp
  802065:	68 d4 28 80 00       	push   $0x8028d4
  80206a:	6a 22                	push   $0x22
  80206c:	68 00 29 80 00       	push   $0x802900
  802071:	e8 d2 e1 ff ff       	call   800248 <_panic>

00802076 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802076:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802077:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax				//调用页处理函数
  80207c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80207e:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp			//跳过utf_fault_va和utf_err
  802081:	83 c4 08             	add    $0x8,%esp
	movl 40(%esp), %eax 	//保存中断发生时的esp到eax
  802084:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl 32(%esp), %ecx 	//保存终端发生时的eip到ecx
  802088:	8b 4c 24 20          	mov    0x20(%esp),%ecx
	movl %ecx, -4(%eax) 	//将中断发生时的esp值亚入到到原来的栈中
  80208c:	89 48 fc             	mov    %ecx,-0x4(%eax)
	popal
  80208f:	61                   	popa   
	addl $4, %esp			//跳过eip
  802090:	83 c4 04             	add    $0x4,%esp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  802093:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802094:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	lea -4(%esp), %esp		//因为之前压入了eip的值但是没有减esp的值，所以现在需要将esp寄存器中的值减4
  802095:	8d 64 24 fc          	lea    -0x4(%esp),%esp
  802099:	c3                   	ret    
  80209a:	66 90                	xchg   %ax,%ax
  80209c:	66 90                	xchg   %ax,%ax
  80209e:	66 90                	xchg   %ax,%ax

008020a0 <__udivdi3>:
  8020a0:	55                   	push   %ebp
  8020a1:	57                   	push   %edi
  8020a2:	56                   	push   %esi
  8020a3:	53                   	push   %ebx
  8020a4:	83 ec 1c             	sub    $0x1c,%esp
  8020a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020b7:	85 d2                	test   %edx,%edx
  8020b9:	75 35                	jne    8020f0 <__udivdi3+0x50>
  8020bb:	39 f3                	cmp    %esi,%ebx
  8020bd:	0f 87 bd 00 00 00    	ja     802180 <__udivdi3+0xe0>
  8020c3:	85 db                	test   %ebx,%ebx
  8020c5:	89 d9                	mov    %ebx,%ecx
  8020c7:	75 0b                	jne    8020d4 <__udivdi3+0x34>
  8020c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ce:	31 d2                	xor    %edx,%edx
  8020d0:	f7 f3                	div    %ebx
  8020d2:	89 c1                	mov    %eax,%ecx
  8020d4:	31 d2                	xor    %edx,%edx
  8020d6:	89 f0                	mov    %esi,%eax
  8020d8:	f7 f1                	div    %ecx
  8020da:	89 c6                	mov    %eax,%esi
  8020dc:	89 e8                	mov    %ebp,%eax
  8020de:	89 f7                	mov    %esi,%edi
  8020e0:	f7 f1                	div    %ecx
  8020e2:	89 fa                	mov    %edi,%edx
  8020e4:	83 c4 1c             	add    $0x1c,%esp
  8020e7:	5b                   	pop    %ebx
  8020e8:	5e                   	pop    %esi
  8020e9:	5f                   	pop    %edi
  8020ea:	5d                   	pop    %ebp
  8020eb:	c3                   	ret    
  8020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020f0:	39 f2                	cmp    %esi,%edx
  8020f2:	77 7c                	ja     802170 <__udivdi3+0xd0>
  8020f4:	0f bd fa             	bsr    %edx,%edi
  8020f7:	83 f7 1f             	xor    $0x1f,%edi
  8020fa:	0f 84 98 00 00 00    	je     802198 <__udivdi3+0xf8>
  802100:	89 f9                	mov    %edi,%ecx
  802102:	b8 20 00 00 00       	mov    $0x20,%eax
  802107:	29 f8                	sub    %edi,%eax
  802109:	d3 e2                	shl    %cl,%edx
  80210b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80210f:	89 c1                	mov    %eax,%ecx
  802111:	89 da                	mov    %ebx,%edx
  802113:	d3 ea                	shr    %cl,%edx
  802115:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802119:	09 d1                	or     %edx,%ecx
  80211b:	89 f2                	mov    %esi,%edx
  80211d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802121:	89 f9                	mov    %edi,%ecx
  802123:	d3 e3                	shl    %cl,%ebx
  802125:	89 c1                	mov    %eax,%ecx
  802127:	d3 ea                	shr    %cl,%edx
  802129:	89 f9                	mov    %edi,%ecx
  80212b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80212f:	d3 e6                	shl    %cl,%esi
  802131:	89 eb                	mov    %ebp,%ebx
  802133:	89 c1                	mov    %eax,%ecx
  802135:	d3 eb                	shr    %cl,%ebx
  802137:	09 de                	or     %ebx,%esi
  802139:	89 f0                	mov    %esi,%eax
  80213b:	f7 74 24 08          	divl   0x8(%esp)
  80213f:	89 d6                	mov    %edx,%esi
  802141:	89 c3                	mov    %eax,%ebx
  802143:	f7 64 24 0c          	mull   0xc(%esp)
  802147:	39 d6                	cmp    %edx,%esi
  802149:	72 0c                	jb     802157 <__udivdi3+0xb7>
  80214b:	89 f9                	mov    %edi,%ecx
  80214d:	d3 e5                	shl    %cl,%ebp
  80214f:	39 c5                	cmp    %eax,%ebp
  802151:	73 5d                	jae    8021b0 <__udivdi3+0x110>
  802153:	39 d6                	cmp    %edx,%esi
  802155:	75 59                	jne    8021b0 <__udivdi3+0x110>
  802157:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80215a:	31 ff                	xor    %edi,%edi
  80215c:	89 fa                	mov    %edi,%edx
  80215e:	83 c4 1c             	add    $0x1c,%esp
  802161:	5b                   	pop    %ebx
  802162:	5e                   	pop    %esi
  802163:	5f                   	pop    %edi
  802164:	5d                   	pop    %ebp
  802165:	c3                   	ret    
  802166:	8d 76 00             	lea    0x0(%esi),%esi
  802169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802170:	31 ff                	xor    %edi,%edi
  802172:	31 c0                	xor    %eax,%eax
  802174:	89 fa                	mov    %edi,%edx
  802176:	83 c4 1c             	add    $0x1c,%esp
  802179:	5b                   	pop    %ebx
  80217a:	5e                   	pop    %esi
  80217b:	5f                   	pop    %edi
  80217c:	5d                   	pop    %ebp
  80217d:	c3                   	ret    
  80217e:	66 90                	xchg   %ax,%ax
  802180:	31 ff                	xor    %edi,%edi
  802182:	89 e8                	mov    %ebp,%eax
  802184:	89 f2                	mov    %esi,%edx
  802186:	f7 f3                	div    %ebx
  802188:	89 fa                	mov    %edi,%edx
  80218a:	83 c4 1c             	add    $0x1c,%esp
  80218d:	5b                   	pop    %ebx
  80218e:	5e                   	pop    %esi
  80218f:	5f                   	pop    %edi
  802190:	5d                   	pop    %ebp
  802191:	c3                   	ret    
  802192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802198:	39 f2                	cmp    %esi,%edx
  80219a:	72 06                	jb     8021a2 <__udivdi3+0x102>
  80219c:	31 c0                	xor    %eax,%eax
  80219e:	39 eb                	cmp    %ebp,%ebx
  8021a0:	77 d2                	ja     802174 <__udivdi3+0xd4>
  8021a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a7:	eb cb                	jmp    802174 <__udivdi3+0xd4>
  8021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021b0:	89 d8                	mov    %ebx,%eax
  8021b2:	31 ff                	xor    %edi,%edi
  8021b4:	eb be                	jmp    802174 <__udivdi3+0xd4>
  8021b6:	66 90                	xchg   %ax,%ax
  8021b8:	66 90                	xchg   %ax,%ax
  8021ba:	66 90                	xchg   %ax,%ax
  8021bc:	66 90                	xchg   %ax,%ax
  8021be:	66 90                	xchg   %ax,%ax

008021c0 <__umoddi3>:
  8021c0:	55                   	push   %ebp
  8021c1:	57                   	push   %edi
  8021c2:	56                   	push   %esi
  8021c3:	53                   	push   %ebx
  8021c4:	83 ec 1c             	sub    $0x1c,%esp
  8021c7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8021cb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021cf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021d7:	85 ed                	test   %ebp,%ebp
  8021d9:	89 f0                	mov    %esi,%eax
  8021db:	89 da                	mov    %ebx,%edx
  8021dd:	75 19                	jne    8021f8 <__umoddi3+0x38>
  8021df:	39 df                	cmp    %ebx,%edi
  8021e1:	0f 86 b1 00 00 00    	jbe    802298 <__umoddi3+0xd8>
  8021e7:	f7 f7                	div    %edi
  8021e9:	89 d0                	mov    %edx,%eax
  8021eb:	31 d2                	xor    %edx,%edx
  8021ed:	83 c4 1c             	add    $0x1c,%esp
  8021f0:	5b                   	pop    %ebx
  8021f1:	5e                   	pop    %esi
  8021f2:	5f                   	pop    %edi
  8021f3:	5d                   	pop    %ebp
  8021f4:	c3                   	ret    
  8021f5:	8d 76 00             	lea    0x0(%esi),%esi
  8021f8:	39 dd                	cmp    %ebx,%ebp
  8021fa:	77 f1                	ja     8021ed <__umoddi3+0x2d>
  8021fc:	0f bd cd             	bsr    %ebp,%ecx
  8021ff:	83 f1 1f             	xor    $0x1f,%ecx
  802202:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802206:	0f 84 b4 00 00 00    	je     8022c0 <__umoddi3+0x100>
  80220c:	b8 20 00 00 00       	mov    $0x20,%eax
  802211:	89 c2                	mov    %eax,%edx
  802213:	8b 44 24 04          	mov    0x4(%esp),%eax
  802217:	29 c2                	sub    %eax,%edx
  802219:	89 c1                	mov    %eax,%ecx
  80221b:	89 f8                	mov    %edi,%eax
  80221d:	d3 e5                	shl    %cl,%ebp
  80221f:	89 d1                	mov    %edx,%ecx
  802221:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802225:	d3 e8                	shr    %cl,%eax
  802227:	09 c5                	or     %eax,%ebp
  802229:	8b 44 24 04          	mov    0x4(%esp),%eax
  80222d:	89 c1                	mov    %eax,%ecx
  80222f:	d3 e7                	shl    %cl,%edi
  802231:	89 d1                	mov    %edx,%ecx
  802233:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802237:	89 df                	mov    %ebx,%edi
  802239:	d3 ef                	shr    %cl,%edi
  80223b:	89 c1                	mov    %eax,%ecx
  80223d:	89 f0                	mov    %esi,%eax
  80223f:	d3 e3                	shl    %cl,%ebx
  802241:	89 d1                	mov    %edx,%ecx
  802243:	89 fa                	mov    %edi,%edx
  802245:	d3 e8                	shr    %cl,%eax
  802247:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80224c:	09 d8                	or     %ebx,%eax
  80224e:	f7 f5                	div    %ebp
  802250:	d3 e6                	shl    %cl,%esi
  802252:	89 d1                	mov    %edx,%ecx
  802254:	f7 64 24 08          	mull   0x8(%esp)
  802258:	39 d1                	cmp    %edx,%ecx
  80225a:	89 c3                	mov    %eax,%ebx
  80225c:	89 d7                	mov    %edx,%edi
  80225e:	72 06                	jb     802266 <__umoddi3+0xa6>
  802260:	75 0e                	jne    802270 <__umoddi3+0xb0>
  802262:	39 c6                	cmp    %eax,%esi
  802264:	73 0a                	jae    802270 <__umoddi3+0xb0>
  802266:	2b 44 24 08          	sub    0x8(%esp),%eax
  80226a:	19 ea                	sbb    %ebp,%edx
  80226c:	89 d7                	mov    %edx,%edi
  80226e:	89 c3                	mov    %eax,%ebx
  802270:	89 ca                	mov    %ecx,%edx
  802272:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802277:	29 de                	sub    %ebx,%esi
  802279:	19 fa                	sbb    %edi,%edx
  80227b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80227f:	89 d0                	mov    %edx,%eax
  802281:	d3 e0                	shl    %cl,%eax
  802283:	89 d9                	mov    %ebx,%ecx
  802285:	d3 ee                	shr    %cl,%esi
  802287:	d3 ea                	shr    %cl,%edx
  802289:	09 f0                	or     %esi,%eax
  80228b:	83 c4 1c             	add    $0x1c,%esp
  80228e:	5b                   	pop    %ebx
  80228f:	5e                   	pop    %esi
  802290:	5f                   	pop    %edi
  802291:	5d                   	pop    %ebp
  802292:	c3                   	ret    
  802293:	90                   	nop
  802294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802298:	85 ff                	test   %edi,%edi
  80229a:	89 f9                	mov    %edi,%ecx
  80229c:	75 0b                	jne    8022a9 <__umoddi3+0xe9>
  80229e:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a3:	31 d2                	xor    %edx,%edx
  8022a5:	f7 f7                	div    %edi
  8022a7:	89 c1                	mov    %eax,%ecx
  8022a9:	89 d8                	mov    %ebx,%eax
  8022ab:	31 d2                	xor    %edx,%edx
  8022ad:	f7 f1                	div    %ecx
  8022af:	89 f0                	mov    %esi,%eax
  8022b1:	f7 f1                	div    %ecx
  8022b3:	e9 31 ff ff ff       	jmp    8021e9 <__umoddi3+0x29>
  8022b8:	90                   	nop
  8022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022c0:	39 dd                	cmp    %ebx,%ebp
  8022c2:	72 08                	jb     8022cc <__umoddi3+0x10c>
  8022c4:	39 f7                	cmp    %esi,%edi
  8022c6:	0f 87 21 ff ff ff    	ja     8021ed <__umoddi3+0x2d>
  8022cc:	89 da                	mov    %ebx,%edx
  8022ce:	89 f0                	mov    %esi,%eax
  8022d0:	29 f8                	sub    %edi,%eax
  8022d2:	19 ea                	sbb    %ebp,%edx
  8022d4:	e9 14 ff ff ff       	jmp    8021ed <__umoddi3+0x2d>
