
obj/user/testpiperace2.debug：     文件格式 elf32-i386


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
  80002c:	e8 a1 01 00 00       	call   8001d2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	68 c0 22 80 00       	push   $0x8022c0
  800041:	e8 bf 02 00 00       	call   800305 <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 84 1b 00 00       	call   801bd5 <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 5d                	js     8000b5 <umain+0x82>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 81 0f 00 00       	call   800fde <fork>
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 64                	js     8000c7 <umain+0x94>
		panic("fork: %e", r);
	if (r == 0) {
  800063:	85 c0                	test   %eax,%eax
  800065:	74 72                	je     8000d9 <umain+0xa6>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800067:	89 fb                	mov    %edi,%ebx
  800069:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80006f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800072:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800078:	8b 43 54             	mov    0x54(%ebx),%eax
  80007b:	83 f8 02             	cmp    $0x2,%eax
  80007e:	0f 85 d1 00 00 00    	jne    800155 <umain+0x122>
		if (pipeisclosed(p[0]) != 0) {
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	ff 75 e0             	pushl  -0x20(%ebp)
  80008a:	e8 8f 1c 00 00       	call   801d1e <pipeisclosed>
  80008f:	83 c4 10             	add    $0x10,%esp
  800092:	85 c0                	test   %eax,%eax
  800094:	74 e2                	je     800078 <umain+0x45>
			cprintf("\nRACE: pipe appears closed\n");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 30 23 80 00       	push   $0x802330
  80009e:	e8 62 02 00 00       	call   800305 <cprintf>
			sys_env_destroy(r);
  8000a3:	89 3c 24             	mov    %edi,(%esp)
  8000a6:	e8 f3 0b 00 00       	call   800c9e <sys_env_destroy>
			exit();
  8000ab:	e8 68 01 00 00       	call   800218 <exit>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	eb c3                	jmp    800078 <umain+0x45>
		panic("pipe: %e", r);
  8000b5:	50                   	push   %eax
  8000b6:	68 0e 23 80 00       	push   $0x80230e
  8000bb:	6a 0d                	push   $0xd
  8000bd:	68 17 23 80 00       	push   $0x802317
  8000c2:	e8 63 01 00 00       	call   80022a <_panic>
		panic("fork: %e", r);
  8000c7:	50                   	push   %eax
  8000c8:	68 45 27 80 00       	push   $0x802745
  8000cd:	6a 0f                	push   $0xf
  8000cf:	68 17 23 80 00       	push   $0x802317
  8000d4:	e8 51 01 00 00       	call   80022a <_panic>
		close(p[1]);
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000df:	e8 91 12 00 00       	call   801375 <close>
  8000e4:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000e7:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000e9:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000ee:	eb 31                	jmp    800121 <umain+0xee>
			dup(p[0], 10);
  8000f0:	83 ec 08             	sub    $0x8,%esp
  8000f3:	6a 0a                	push   $0xa
  8000f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f8:	e8 c8 12 00 00       	call   8013c5 <dup>
			sys_yield();
  8000fd:	e8 fc 0b 00 00       	call   800cfe <sys_yield>
			close(10);
  800102:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800109:	e8 67 12 00 00       	call   801375 <close>
			sys_yield();
  80010e:	e8 eb 0b 00 00       	call   800cfe <sys_yield>
		for (i = 0; i < 200; i++) {
  800113:	83 c3 01             	add    $0x1,%ebx
  800116:	83 c4 10             	add    $0x10,%esp
  800119:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  80011f:	74 2a                	je     80014b <umain+0x118>
			if (i % 10 == 0)
  800121:	89 d8                	mov    %ebx,%eax
  800123:	f7 ee                	imul   %esi
  800125:	c1 fa 02             	sar    $0x2,%edx
  800128:	89 d8                	mov    %ebx,%eax
  80012a:	c1 f8 1f             	sar    $0x1f,%eax
  80012d:	29 c2                	sub    %eax,%edx
  80012f:	8d 04 92             	lea    (%edx,%edx,4),%eax
  800132:	01 c0                	add    %eax,%eax
  800134:	39 c3                	cmp    %eax,%ebx
  800136:	75 b8                	jne    8000f0 <umain+0xbd>
				cprintf("%d.", i);
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	53                   	push   %ebx
  80013c:	68 2c 23 80 00       	push   $0x80232c
  800141:	e8 bf 01 00 00       	call   800305 <cprintf>
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	eb a5                	jmp    8000f0 <umain+0xbd>
		exit();
  80014b:	e8 c8 00 00 00       	call   800218 <exit>
  800150:	e9 12 ff ff ff       	jmp    800067 <umain+0x34>
		}
	cprintf("child done with loop\n");
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	68 4c 23 80 00       	push   $0x80234c
  80015d:	e8 a3 01 00 00       	call   800305 <cprintf>
	if (pipeisclosed(p[0]))
  800162:	83 c4 04             	add    $0x4,%esp
  800165:	ff 75 e0             	pushl  -0x20(%ebp)
  800168:	e8 b1 1b 00 00       	call   801d1e <pipeisclosed>
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	85 c0                	test   %eax,%eax
  800172:	75 38                	jne    8001ac <umain+0x179>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800174:	83 ec 08             	sub    $0x8,%esp
  800177:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80017a:	50                   	push   %eax
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 bd 10 00 00       	call   801240 <fd_lookup>
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	85 c0                	test   %eax,%eax
  800188:	78 36                	js     8001c0 <umain+0x18d>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	ff 75 dc             	pushl  -0x24(%ebp)
  800190:	e8 45 10 00 00       	call   8011da <fd2data>
	cprintf("race didn't happen\n");
  800195:	c7 04 24 7a 23 80 00 	movl   $0x80237a,(%esp)
  80019c:	e8 64 01 00 00       	call   800305 <cprintf>
}
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a7:	5b                   	pop    %ebx
  8001a8:	5e                   	pop    %esi
  8001a9:	5f                   	pop    %edi
  8001aa:	5d                   	pop    %ebp
  8001ab:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 e4 22 80 00       	push   $0x8022e4
  8001b4:	6a 40                	push   $0x40
  8001b6:	68 17 23 80 00       	push   $0x802317
  8001bb:	e8 6a 00 00 00       	call   80022a <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c0:	50                   	push   %eax
  8001c1:	68 62 23 80 00       	push   $0x802362
  8001c6:	6a 42                	push   $0x42
  8001c8:	68 17 23 80 00       	push   $0x802317
  8001cd:	e8 58 00 00 00       	call   80022a <_panic>

008001d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	56                   	push   %esi
  8001d6:	53                   	push   %ebx
  8001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001da:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  8001dd:	e8 fd 0a 00 00       	call   800cdf <sys_getenvid>
	thisenv = envs + ENVX(envid);
  8001e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ef:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f4:	85 db                	test   %ebx,%ebx
  8001f6:	7e 07                	jle    8001ff <libmain+0x2d>
		binaryname = argv[0];
  8001f8:	8b 06                	mov    (%esi),%eax
  8001fa:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001ff:	83 ec 08             	sub    $0x8,%esp
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	e8 2a fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800209:	e8 0a 00 00 00       	call   800218 <exit>
}
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80021e:	6a 00                	push   $0x0
  800220:	e8 79 0a 00 00       	call   800c9e <sys_env_destroy>
}
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	c9                   	leave  
  800229:	c3                   	ret    

0080022a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	56                   	push   %esi
  80022e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80022f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800232:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800238:	e8 a2 0a 00 00       	call   800cdf <sys_getenvid>
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	ff 75 0c             	pushl  0xc(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	56                   	push   %esi
  800247:	50                   	push   %eax
  800248:	68 98 23 80 00       	push   $0x802398
  80024d:	e8 b3 00 00 00       	call   800305 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800252:	83 c4 18             	add    $0x18,%esp
  800255:	53                   	push   %ebx
  800256:	ff 75 10             	pushl  0x10(%ebp)
  800259:	e8 56 00 00 00       	call   8002b4 <vcprintf>
	cprintf("\n");
  80025e:	c7 04 24 67 28 80 00 	movl   $0x802867,(%esp)
  800265:	e8 9b 00 00 00       	call   800305 <cprintf>
  80026a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80026d:	cc                   	int3   
  80026e:	eb fd                	jmp    80026d <_panic+0x43>

00800270 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	53                   	push   %ebx
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80027a:	8b 13                	mov    (%ebx),%edx
  80027c:	8d 42 01             	lea    0x1(%edx),%eax
  80027f:	89 03                	mov    %eax,(%ebx)
  800281:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800284:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800288:	3d ff 00 00 00       	cmp    $0xff,%eax
  80028d:	74 09                	je     800298 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80028f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800293:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800296:	c9                   	leave  
  800297:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800298:	83 ec 08             	sub    $0x8,%esp
  80029b:	68 ff 00 00 00       	push   $0xff
  8002a0:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a3:	50                   	push   %eax
  8002a4:	e8 b8 09 00 00       	call   800c61 <sys_cputs>
		b->idx = 0;
  8002a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002af:	83 c4 10             	add    $0x10,%esp
  8002b2:	eb db                	jmp    80028f <putch+0x1f>

008002b4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c4:	00 00 00 
	b.cnt = 0;
  8002c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ce:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d1:	ff 75 0c             	pushl  0xc(%ebp)
  8002d4:	ff 75 08             	pushl  0x8(%ebp)
  8002d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002dd:	50                   	push   %eax
  8002de:	68 70 02 80 00       	push   $0x800270
  8002e3:	e8 1a 01 00 00       	call   800402 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e8:	83 c4 08             	add    $0x8,%esp
  8002eb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f7:	50                   	push   %eax
  8002f8:	e8 64 09 00 00       	call   800c61 <sys_cputs>

	return b.cnt;
}
  8002fd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800303:	c9                   	leave  
  800304:	c3                   	ret    

00800305 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80030e:	50                   	push   %eax
  80030f:	ff 75 08             	pushl  0x8(%ebp)
  800312:	e8 9d ff ff ff       	call   8002b4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	57                   	push   %edi
  80031d:	56                   	push   %esi
  80031e:	53                   	push   %ebx
  80031f:	83 ec 1c             	sub    $0x1c,%esp
  800322:	89 c7                	mov    %eax,%edi
  800324:	89 d6                	mov    %edx,%esi
  800326:	8b 45 08             	mov    0x8(%ebp),%eax
  800329:	8b 55 0c             	mov    0xc(%ebp),%edx
  80032c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80032f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800332:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800335:	bb 00 00 00 00       	mov    $0x0,%ebx
  80033a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80033d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800340:	39 d3                	cmp    %edx,%ebx
  800342:	72 05                	jb     800349 <printnum+0x30>
  800344:	39 45 10             	cmp    %eax,0x10(%ebp)
  800347:	77 7a                	ja     8003c3 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800349:	83 ec 0c             	sub    $0xc,%esp
  80034c:	ff 75 18             	pushl  0x18(%ebp)
  80034f:	8b 45 14             	mov    0x14(%ebp),%eax
  800352:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800355:	53                   	push   %ebx
  800356:	ff 75 10             	pushl  0x10(%ebp)
  800359:	83 ec 08             	sub    $0x8,%esp
  80035c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80035f:	ff 75 e0             	pushl  -0x20(%ebp)
  800362:	ff 75 dc             	pushl  -0x24(%ebp)
  800365:	ff 75 d8             	pushl  -0x28(%ebp)
  800368:	e8 13 1d 00 00       	call   802080 <__udivdi3>
  80036d:	83 c4 18             	add    $0x18,%esp
  800370:	52                   	push   %edx
  800371:	50                   	push   %eax
  800372:	89 f2                	mov    %esi,%edx
  800374:	89 f8                	mov    %edi,%eax
  800376:	e8 9e ff ff ff       	call   800319 <printnum>
  80037b:	83 c4 20             	add    $0x20,%esp
  80037e:	eb 13                	jmp    800393 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800380:	83 ec 08             	sub    $0x8,%esp
  800383:	56                   	push   %esi
  800384:	ff 75 18             	pushl  0x18(%ebp)
  800387:	ff d7                	call   *%edi
  800389:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80038c:	83 eb 01             	sub    $0x1,%ebx
  80038f:	85 db                	test   %ebx,%ebx
  800391:	7f ed                	jg     800380 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800393:	83 ec 08             	sub    $0x8,%esp
  800396:	56                   	push   %esi
  800397:	83 ec 04             	sub    $0x4,%esp
  80039a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039d:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a0:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a6:	e8 f5 1d 00 00       	call   8021a0 <__umoddi3>
  8003ab:	83 c4 14             	add    $0x14,%esp
  8003ae:	0f be 80 bb 23 80 00 	movsbl 0x8023bb(%eax),%eax
  8003b5:	50                   	push   %eax
  8003b6:	ff d7                	call   *%edi
}
  8003b8:	83 c4 10             	add    $0x10,%esp
  8003bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003be:	5b                   	pop    %ebx
  8003bf:	5e                   	pop    %esi
  8003c0:	5f                   	pop    %edi
  8003c1:	5d                   	pop    %ebp
  8003c2:	c3                   	ret    
  8003c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003c6:	eb c4                	jmp    80038c <printnum+0x73>

008003c8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ce:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003d2:	8b 10                	mov    (%eax),%edx
  8003d4:	3b 50 04             	cmp    0x4(%eax),%edx
  8003d7:	73 0a                	jae    8003e3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003dc:	89 08                	mov    %ecx,(%eax)
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	88 02                	mov    %al,(%edx)
}
  8003e3:	5d                   	pop    %ebp
  8003e4:	c3                   	ret    

008003e5 <printfmt>:
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003eb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ee:	50                   	push   %eax
  8003ef:	ff 75 10             	pushl  0x10(%ebp)
  8003f2:	ff 75 0c             	pushl  0xc(%ebp)
  8003f5:	ff 75 08             	pushl  0x8(%ebp)
  8003f8:	e8 05 00 00 00       	call   800402 <vprintfmt>
}
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	c9                   	leave  
  800401:	c3                   	ret    

00800402 <vprintfmt>:
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	57                   	push   %edi
  800406:	56                   	push   %esi
  800407:	53                   	push   %ebx
  800408:	83 ec 2c             	sub    $0x2c,%esp
  80040b:	8b 75 08             	mov    0x8(%ebp),%esi
  80040e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800411:	8b 7d 10             	mov    0x10(%ebp),%edi
  800414:	e9 c1 03 00 00       	jmp    8007da <vprintfmt+0x3d8>
		padc = ' ';
  800419:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80041d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800424:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80042b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800432:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800437:	8d 47 01             	lea    0x1(%edi),%eax
  80043a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80043d:	0f b6 17             	movzbl (%edi),%edx
  800440:	8d 42 dd             	lea    -0x23(%edx),%eax
  800443:	3c 55                	cmp    $0x55,%al
  800445:	0f 87 12 04 00 00    	ja     80085d <vprintfmt+0x45b>
  80044b:	0f b6 c0             	movzbl %al,%eax
  80044e:	ff 24 85 00 25 80 00 	jmp    *0x802500(,%eax,4)
  800455:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800458:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80045c:	eb d9                	jmp    800437 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80045e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800461:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800465:	eb d0                	jmp    800437 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800467:	0f b6 d2             	movzbl %dl,%edx
  80046a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80046d:	b8 00 00 00 00       	mov    $0x0,%eax
  800472:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800475:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800478:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80047c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80047f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800482:	83 f9 09             	cmp    $0x9,%ecx
  800485:	77 55                	ja     8004dc <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800487:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80048a:	eb e9                	jmp    800475 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80048c:	8b 45 14             	mov    0x14(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800494:	8b 45 14             	mov    0x14(%ebp),%eax
  800497:	8d 40 04             	lea    0x4(%eax),%eax
  80049a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80049d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a4:	79 91                	jns    800437 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ac:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004b3:	eb 82                	jmp    800437 <vprintfmt+0x35>
  8004b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b8:	85 c0                	test   %eax,%eax
  8004ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8004bf:	0f 49 d0             	cmovns %eax,%edx
  8004c2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004c8:	e9 6a ff ff ff       	jmp    800437 <vprintfmt+0x35>
  8004cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004d0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004d7:	e9 5b ff ff ff       	jmp    800437 <vprintfmt+0x35>
  8004dc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004e2:	eb bc                	jmp    8004a0 <vprintfmt+0x9e>
			lflag++;
  8004e4:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004ea:	e9 48 ff ff ff       	jmp    800437 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f2:	8d 78 04             	lea    0x4(%eax),%edi
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	53                   	push   %ebx
  8004f9:	ff 30                	pushl  (%eax)
  8004fb:	ff d6                	call   *%esi
			break;
  8004fd:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800500:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800503:	e9 cf 02 00 00       	jmp    8007d7 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	8d 78 04             	lea    0x4(%eax),%edi
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	99                   	cltd   
  800511:	31 d0                	xor    %edx,%eax
  800513:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800515:	83 f8 0f             	cmp    $0xf,%eax
  800518:	7f 23                	jg     80053d <vprintfmt+0x13b>
  80051a:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  800521:	85 d2                	test   %edx,%edx
  800523:	74 18                	je     80053d <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800525:	52                   	push   %edx
  800526:	68 35 28 80 00       	push   $0x802835
  80052b:	53                   	push   %ebx
  80052c:	56                   	push   %esi
  80052d:	e8 b3 fe ff ff       	call   8003e5 <printfmt>
  800532:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800535:	89 7d 14             	mov    %edi,0x14(%ebp)
  800538:	e9 9a 02 00 00       	jmp    8007d7 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80053d:	50                   	push   %eax
  80053e:	68 d3 23 80 00       	push   $0x8023d3
  800543:	53                   	push   %ebx
  800544:	56                   	push   %esi
  800545:	e8 9b fe ff ff       	call   8003e5 <printfmt>
  80054a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80054d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800550:	e9 82 02 00 00       	jmp    8007d7 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	83 c0 04             	add    $0x4,%eax
  80055b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800563:	85 ff                	test   %edi,%edi
  800565:	b8 cc 23 80 00       	mov    $0x8023cc,%eax
  80056a:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80056d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800571:	0f 8e bd 00 00 00    	jle    800634 <vprintfmt+0x232>
  800577:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80057b:	75 0e                	jne    80058b <vprintfmt+0x189>
  80057d:	89 75 08             	mov    %esi,0x8(%ebp)
  800580:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800583:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800586:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800589:	eb 6d                	jmp    8005f8 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	ff 75 d0             	pushl  -0x30(%ebp)
  800591:	57                   	push   %edi
  800592:	e8 6e 03 00 00       	call   800905 <strnlen>
  800597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80059a:	29 c1                	sub    %eax,%ecx
  80059c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80059f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005a2:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005ac:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ae:	eb 0f                	jmp    8005bf <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005b0:	83 ec 08             	sub    $0x8,%esp
  8005b3:	53                   	push   %ebx
  8005b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8005b7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b9:	83 ef 01             	sub    $0x1,%edi
  8005bc:	83 c4 10             	add    $0x10,%esp
  8005bf:	85 ff                	test   %edi,%edi
  8005c1:	7f ed                	jg     8005b0 <vprintfmt+0x1ae>
  8005c3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005c6:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005c9:	85 c9                	test   %ecx,%ecx
  8005cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d0:	0f 49 c1             	cmovns %ecx,%eax
  8005d3:	29 c1                	sub    %eax,%ecx
  8005d5:	89 75 08             	mov    %esi,0x8(%ebp)
  8005d8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005db:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005de:	89 cb                	mov    %ecx,%ebx
  8005e0:	eb 16                	jmp    8005f8 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005e6:	75 31                	jne    800619 <vprintfmt+0x217>
					putch(ch, putdat);
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	ff 75 0c             	pushl  0xc(%ebp)
  8005ee:	50                   	push   %eax
  8005ef:	ff 55 08             	call   *0x8(%ebp)
  8005f2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f5:	83 eb 01             	sub    $0x1,%ebx
  8005f8:	83 c7 01             	add    $0x1,%edi
  8005fb:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005ff:	0f be c2             	movsbl %dl,%eax
  800602:	85 c0                	test   %eax,%eax
  800604:	74 59                	je     80065f <vprintfmt+0x25d>
  800606:	85 f6                	test   %esi,%esi
  800608:	78 d8                	js     8005e2 <vprintfmt+0x1e0>
  80060a:	83 ee 01             	sub    $0x1,%esi
  80060d:	79 d3                	jns    8005e2 <vprintfmt+0x1e0>
  80060f:	89 df                	mov    %ebx,%edi
  800611:	8b 75 08             	mov    0x8(%ebp),%esi
  800614:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800617:	eb 37                	jmp    800650 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800619:	0f be d2             	movsbl %dl,%edx
  80061c:	83 ea 20             	sub    $0x20,%edx
  80061f:	83 fa 5e             	cmp    $0x5e,%edx
  800622:	76 c4                	jbe    8005e8 <vprintfmt+0x1e6>
					putch('?', putdat);
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	ff 75 0c             	pushl  0xc(%ebp)
  80062a:	6a 3f                	push   $0x3f
  80062c:	ff 55 08             	call   *0x8(%ebp)
  80062f:	83 c4 10             	add    $0x10,%esp
  800632:	eb c1                	jmp    8005f5 <vprintfmt+0x1f3>
  800634:	89 75 08             	mov    %esi,0x8(%ebp)
  800637:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80063a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80063d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800640:	eb b6                	jmp    8005f8 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	53                   	push   %ebx
  800646:	6a 20                	push   $0x20
  800648:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80064a:	83 ef 01             	sub    $0x1,%edi
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	85 ff                	test   %edi,%edi
  800652:	7f ee                	jg     800642 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800654:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
  80065a:	e9 78 01 00 00       	jmp    8007d7 <vprintfmt+0x3d5>
  80065f:	89 df                	mov    %ebx,%edi
  800661:	8b 75 08             	mov    0x8(%ebp),%esi
  800664:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800667:	eb e7                	jmp    800650 <vprintfmt+0x24e>
	if (lflag >= 2)
  800669:	83 f9 01             	cmp    $0x1,%ecx
  80066c:	7e 3f                	jle    8006ad <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 50 04             	mov    0x4(%eax),%edx
  800674:	8b 00                	mov    (%eax),%eax
  800676:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800679:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8d 40 08             	lea    0x8(%eax),%eax
  800682:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800685:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800689:	79 5c                	jns    8006e7 <vprintfmt+0x2e5>
				putch('-', putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	53                   	push   %ebx
  80068f:	6a 2d                	push   $0x2d
  800691:	ff d6                	call   *%esi
				num = -(long long) num;
  800693:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800696:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800699:	f7 da                	neg    %edx
  80069b:	83 d1 00             	adc    $0x0,%ecx
  80069e:	f7 d9                	neg    %ecx
  8006a0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a8:	e9 10 01 00 00       	jmp    8007bd <vprintfmt+0x3bb>
	else if (lflag)
  8006ad:	85 c9                	test   %ecx,%ecx
  8006af:	75 1b                	jne    8006cc <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b9:	89 c1                	mov    %eax,%ecx
  8006bb:	c1 f9 1f             	sar    $0x1f,%ecx
  8006be:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8d 40 04             	lea    0x4(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ca:	eb b9                	jmp    800685 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d4:	89 c1                	mov    %eax,%ecx
  8006d6:	c1 f9 1f             	sar    $0x1f,%ecx
  8006d9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8d 40 04             	lea    0x4(%eax),%eax
  8006e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e5:	eb 9e                	jmp    800685 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f2:	e9 c6 00 00 00       	jmp    8007bd <vprintfmt+0x3bb>
	if (lflag >= 2)
  8006f7:	83 f9 01             	cmp    $0x1,%ecx
  8006fa:	7e 18                	jle    800714 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 10                	mov    (%eax),%edx
  800701:	8b 48 04             	mov    0x4(%eax),%ecx
  800704:	8d 40 08             	lea    0x8(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070f:	e9 a9 00 00 00       	jmp    8007bd <vprintfmt+0x3bb>
	else if (lflag)
  800714:	85 c9                	test   %ecx,%ecx
  800716:	75 1a                	jne    800732 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8b 10                	mov    (%eax),%edx
  80071d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800722:	8d 40 04             	lea    0x4(%eax),%eax
  800725:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800728:	b8 0a 00 00 00       	mov    $0xa,%eax
  80072d:	e9 8b 00 00 00       	jmp    8007bd <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8b 10                	mov    (%eax),%edx
  800737:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073c:	8d 40 04             	lea    0x4(%eax),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800742:	b8 0a 00 00 00       	mov    $0xa,%eax
  800747:	eb 74                	jmp    8007bd <vprintfmt+0x3bb>
	if (lflag >= 2)
  800749:	83 f9 01             	cmp    $0x1,%ecx
  80074c:	7e 15                	jle    800763 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8b 10                	mov    (%eax),%edx
  800753:	8b 48 04             	mov    0x4(%eax),%ecx
  800756:	8d 40 08             	lea    0x8(%eax),%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075c:	b8 08 00 00 00       	mov    $0x8,%eax
  800761:	eb 5a                	jmp    8007bd <vprintfmt+0x3bb>
	else if (lflag)
  800763:	85 c9                	test   %ecx,%ecx
  800765:	75 17                	jne    80077e <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8b 10                	mov    (%eax),%edx
  80076c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800771:	8d 40 04             	lea    0x4(%eax),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800777:	b8 08 00 00 00       	mov    $0x8,%eax
  80077c:	eb 3f                	jmp    8007bd <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	8b 10                	mov    (%eax),%edx
  800783:	b9 00 00 00 00       	mov    $0x0,%ecx
  800788:	8d 40 04             	lea    0x4(%eax),%eax
  80078b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078e:	b8 08 00 00 00       	mov    $0x8,%eax
  800793:	eb 28                	jmp    8007bd <vprintfmt+0x3bb>
			putch('0', putdat);
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	53                   	push   %ebx
  800799:	6a 30                	push   $0x30
  80079b:	ff d6                	call   *%esi
			putch('x', putdat);
  80079d:	83 c4 08             	add    $0x8,%esp
  8007a0:	53                   	push   %ebx
  8007a1:	6a 78                	push   $0x78
  8007a3:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a8:	8b 10                	mov    (%eax),%edx
  8007aa:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007af:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007b2:	8d 40 04             	lea    0x4(%eax),%eax
  8007b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b8:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007bd:	83 ec 0c             	sub    $0xc,%esp
  8007c0:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007c4:	57                   	push   %edi
  8007c5:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c8:	50                   	push   %eax
  8007c9:	51                   	push   %ecx
  8007ca:	52                   	push   %edx
  8007cb:	89 da                	mov    %ebx,%edx
  8007cd:	89 f0                	mov    %esi,%eax
  8007cf:	e8 45 fb ff ff       	call   800319 <printnum>
			break;
  8007d4:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  8007da:	83 c7 01             	add    $0x1,%edi
  8007dd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e1:	83 f8 25             	cmp    $0x25,%eax
  8007e4:	0f 84 2f fc ff ff    	je     800419 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  8007ea:	85 c0                	test   %eax,%eax
  8007ec:	0f 84 8b 00 00 00    	je     80087d <vprintfmt+0x47b>
			putch(ch, putdat);
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	53                   	push   %ebx
  8007f6:	50                   	push   %eax
  8007f7:	ff d6                	call   *%esi
  8007f9:	83 c4 10             	add    $0x10,%esp
  8007fc:	eb dc                	jmp    8007da <vprintfmt+0x3d8>
	if (lflag >= 2)
  8007fe:	83 f9 01             	cmp    $0x1,%ecx
  800801:	7e 15                	jle    800818 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8b 10                	mov    (%eax),%edx
  800808:	8b 48 04             	mov    0x4(%eax),%ecx
  80080b:	8d 40 08             	lea    0x8(%eax),%eax
  80080e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800811:	b8 10 00 00 00       	mov    $0x10,%eax
  800816:	eb a5                	jmp    8007bd <vprintfmt+0x3bb>
	else if (lflag)
  800818:	85 c9                	test   %ecx,%ecx
  80081a:	75 17                	jne    800833 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8b 10                	mov    (%eax),%edx
  800821:	b9 00 00 00 00       	mov    $0x0,%ecx
  800826:	8d 40 04             	lea    0x4(%eax),%eax
  800829:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082c:	b8 10 00 00 00       	mov    $0x10,%eax
  800831:	eb 8a                	jmp    8007bd <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800833:	8b 45 14             	mov    0x14(%ebp),%eax
  800836:	8b 10                	mov    (%eax),%edx
  800838:	b9 00 00 00 00       	mov    $0x0,%ecx
  80083d:	8d 40 04             	lea    0x4(%eax),%eax
  800840:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800843:	b8 10 00 00 00       	mov    $0x10,%eax
  800848:	e9 70 ff ff ff       	jmp    8007bd <vprintfmt+0x3bb>
			putch(ch, putdat);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	53                   	push   %ebx
  800851:	6a 25                	push   $0x25
  800853:	ff d6                	call   *%esi
			break;
  800855:	83 c4 10             	add    $0x10,%esp
  800858:	e9 7a ff ff ff       	jmp    8007d7 <vprintfmt+0x3d5>
			putch('%', putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	53                   	push   %ebx
  800861:	6a 25                	push   $0x25
  800863:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800865:	83 c4 10             	add    $0x10,%esp
  800868:	89 f8                	mov    %edi,%eax
  80086a:	eb 03                	jmp    80086f <vprintfmt+0x46d>
  80086c:	83 e8 01             	sub    $0x1,%eax
  80086f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800873:	75 f7                	jne    80086c <vprintfmt+0x46a>
  800875:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800878:	e9 5a ff ff ff       	jmp    8007d7 <vprintfmt+0x3d5>
}
  80087d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800880:	5b                   	pop    %ebx
  800881:	5e                   	pop    %esi
  800882:	5f                   	pop    %edi
  800883:	5d                   	pop    %ebp
  800884:	c3                   	ret    

00800885 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	83 ec 18             	sub    $0x18,%esp
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800891:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800894:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800898:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80089b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a2:	85 c0                	test   %eax,%eax
  8008a4:	74 26                	je     8008cc <vsnprintf+0x47>
  8008a6:	85 d2                	test   %edx,%edx
  8008a8:	7e 22                	jle    8008cc <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008aa:	ff 75 14             	pushl  0x14(%ebp)
  8008ad:	ff 75 10             	pushl  0x10(%ebp)
  8008b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b3:	50                   	push   %eax
  8008b4:	68 c8 03 80 00       	push   $0x8003c8
  8008b9:	e8 44 fb ff ff       	call   800402 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c7:	83 c4 10             	add    $0x10,%esp
}
  8008ca:	c9                   	leave  
  8008cb:	c3                   	ret    
		return -E_INVAL;
  8008cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d1:	eb f7                	jmp    8008ca <vsnprintf+0x45>

008008d3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008dc:	50                   	push   %eax
  8008dd:	ff 75 10             	pushl  0x10(%ebp)
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	ff 75 08             	pushl  0x8(%ebp)
  8008e6:	e8 9a ff ff ff       	call   800885 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008eb:	c9                   	leave  
  8008ec:	c3                   	ret    

008008ed <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f8:	eb 03                	jmp    8008fd <strlen+0x10>
		n++;
  8008fa:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008fd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800901:	75 f7                	jne    8008fa <strlen+0xd>
	return n;
}
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090e:	b8 00 00 00 00       	mov    $0x0,%eax
  800913:	eb 03                	jmp    800918 <strnlen+0x13>
		n++;
  800915:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800918:	39 d0                	cmp    %edx,%eax
  80091a:	74 06                	je     800922 <strnlen+0x1d>
  80091c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800920:	75 f3                	jne    800915 <strnlen+0x10>
	return n;
}
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	53                   	push   %ebx
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80092e:	89 c2                	mov    %eax,%edx
  800930:	83 c1 01             	add    $0x1,%ecx
  800933:	83 c2 01             	add    $0x1,%edx
  800936:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80093a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80093d:	84 db                	test   %bl,%bl
  80093f:	75 ef                	jne    800930 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800941:	5b                   	pop    %ebx
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	53                   	push   %ebx
  800948:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80094b:	53                   	push   %ebx
  80094c:	e8 9c ff ff ff       	call   8008ed <strlen>
  800951:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	01 d8                	add    %ebx,%eax
  800959:	50                   	push   %eax
  80095a:	e8 c5 ff ff ff       	call   800924 <strcpy>
	return dst;
}
  80095f:	89 d8                	mov    %ebx,%eax
  800961:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800964:	c9                   	leave  
  800965:	c3                   	ret    

00800966 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	56                   	push   %esi
  80096a:	53                   	push   %ebx
  80096b:	8b 75 08             	mov    0x8(%ebp),%esi
  80096e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800971:	89 f3                	mov    %esi,%ebx
  800973:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800976:	89 f2                	mov    %esi,%edx
  800978:	eb 0f                	jmp    800989 <strncpy+0x23>
		*dst++ = *src;
  80097a:	83 c2 01             	add    $0x1,%edx
  80097d:	0f b6 01             	movzbl (%ecx),%eax
  800980:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800983:	80 39 01             	cmpb   $0x1,(%ecx)
  800986:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800989:	39 da                	cmp    %ebx,%edx
  80098b:	75 ed                	jne    80097a <strncpy+0x14>
	}
	return ret;
}
  80098d:	89 f0                	mov    %esi,%eax
  80098f:	5b                   	pop    %ebx
  800990:	5e                   	pop    %esi
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    

00800993 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	56                   	push   %esi
  800997:	53                   	push   %ebx
  800998:	8b 75 08             	mov    0x8(%ebp),%esi
  80099b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009a1:	89 f0                	mov    %esi,%eax
  8009a3:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009a7:	85 c9                	test   %ecx,%ecx
  8009a9:	75 0b                	jne    8009b6 <strlcpy+0x23>
  8009ab:	eb 17                	jmp    8009c4 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009ad:	83 c2 01             	add    $0x1,%edx
  8009b0:	83 c0 01             	add    $0x1,%eax
  8009b3:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009b6:	39 d8                	cmp    %ebx,%eax
  8009b8:	74 07                	je     8009c1 <strlcpy+0x2e>
  8009ba:	0f b6 0a             	movzbl (%edx),%ecx
  8009bd:	84 c9                	test   %cl,%cl
  8009bf:	75 ec                	jne    8009ad <strlcpy+0x1a>
		*dst = '\0';
  8009c1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009c4:	29 f0                	sub    %esi,%eax
}
  8009c6:	5b                   	pop    %ebx
  8009c7:	5e                   	pop    %esi
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009d3:	eb 06                	jmp    8009db <strcmp+0x11>
		p++, q++;
  8009d5:	83 c1 01             	add    $0x1,%ecx
  8009d8:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009db:	0f b6 01             	movzbl (%ecx),%eax
  8009de:	84 c0                	test   %al,%al
  8009e0:	74 04                	je     8009e6 <strcmp+0x1c>
  8009e2:	3a 02                	cmp    (%edx),%al
  8009e4:	74 ef                	je     8009d5 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e6:	0f b6 c0             	movzbl %al,%eax
  8009e9:	0f b6 12             	movzbl (%edx),%edx
  8009ec:	29 d0                	sub    %edx,%eax
}
  8009ee:	5d                   	pop    %ebp
  8009ef:	c3                   	ret    

008009f0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	53                   	push   %ebx
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fa:	89 c3                	mov    %eax,%ebx
  8009fc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ff:	eb 06                	jmp    800a07 <strncmp+0x17>
		n--, p++, q++;
  800a01:	83 c0 01             	add    $0x1,%eax
  800a04:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a07:	39 d8                	cmp    %ebx,%eax
  800a09:	74 16                	je     800a21 <strncmp+0x31>
  800a0b:	0f b6 08             	movzbl (%eax),%ecx
  800a0e:	84 c9                	test   %cl,%cl
  800a10:	74 04                	je     800a16 <strncmp+0x26>
  800a12:	3a 0a                	cmp    (%edx),%cl
  800a14:	74 eb                	je     800a01 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a16:	0f b6 00             	movzbl (%eax),%eax
  800a19:	0f b6 12             	movzbl (%edx),%edx
  800a1c:	29 d0                	sub    %edx,%eax
}
  800a1e:	5b                   	pop    %ebx
  800a1f:	5d                   	pop    %ebp
  800a20:	c3                   	ret    
		return 0;
  800a21:	b8 00 00 00 00       	mov    $0x0,%eax
  800a26:	eb f6                	jmp    800a1e <strncmp+0x2e>

00800a28 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a32:	0f b6 10             	movzbl (%eax),%edx
  800a35:	84 d2                	test   %dl,%dl
  800a37:	74 09                	je     800a42 <strchr+0x1a>
		if (*s == c)
  800a39:	38 ca                	cmp    %cl,%dl
  800a3b:	74 0a                	je     800a47 <strchr+0x1f>
	for (; *s; s++)
  800a3d:	83 c0 01             	add    $0x1,%eax
  800a40:	eb f0                	jmp    800a32 <strchr+0xa>
			return (char *) s;
	return 0;
  800a42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a53:	eb 03                	jmp    800a58 <strfind+0xf>
  800a55:	83 c0 01             	add    $0x1,%eax
  800a58:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a5b:	38 ca                	cmp    %cl,%dl
  800a5d:	74 04                	je     800a63 <strfind+0x1a>
  800a5f:	84 d2                	test   %dl,%dl
  800a61:	75 f2                	jne    800a55 <strfind+0xc>
			break;
	return (char *) s;
}
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	57                   	push   %edi
  800a69:	56                   	push   %esi
  800a6a:	53                   	push   %ebx
  800a6b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a71:	85 c9                	test   %ecx,%ecx
  800a73:	74 13                	je     800a88 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a75:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a7b:	75 05                	jne    800a82 <memset+0x1d>
  800a7d:	f6 c1 03             	test   $0x3,%cl
  800a80:	74 0d                	je     800a8f <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a85:	fc                   	cld    
  800a86:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a88:	89 f8                	mov    %edi,%eax
  800a8a:	5b                   	pop    %ebx
  800a8b:	5e                   	pop    %esi
  800a8c:	5f                   	pop    %edi
  800a8d:	5d                   	pop    %ebp
  800a8e:	c3                   	ret    
		c &= 0xFF;
  800a8f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a93:	89 d3                	mov    %edx,%ebx
  800a95:	c1 e3 08             	shl    $0x8,%ebx
  800a98:	89 d0                	mov    %edx,%eax
  800a9a:	c1 e0 18             	shl    $0x18,%eax
  800a9d:	89 d6                	mov    %edx,%esi
  800a9f:	c1 e6 10             	shl    $0x10,%esi
  800aa2:	09 f0                	or     %esi,%eax
  800aa4:	09 c2                	or     %eax,%edx
  800aa6:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800aa8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aab:	89 d0                	mov    %edx,%eax
  800aad:	fc                   	cld    
  800aae:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab0:	eb d6                	jmp    800a88 <memset+0x23>

00800ab2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	57                   	push   %edi
  800ab6:	56                   	push   %esi
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	8b 75 0c             	mov    0xc(%ebp),%esi
  800abd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ac0:	39 c6                	cmp    %eax,%esi
  800ac2:	73 35                	jae    800af9 <memmove+0x47>
  800ac4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac7:	39 c2                	cmp    %eax,%edx
  800ac9:	76 2e                	jbe    800af9 <memmove+0x47>
		s += n;
		d += n;
  800acb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ace:	89 d6                	mov    %edx,%esi
  800ad0:	09 fe                	or     %edi,%esi
  800ad2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ad8:	74 0c                	je     800ae6 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ada:	83 ef 01             	sub    $0x1,%edi
  800add:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ae0:	fd                   	std    
  800ae1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ae3:	fc                   	cld    
  800ae4:	eb 21                	jmp    800b07 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae6:	f6 c1 03             	test   $0x3,%cl
  800ae9:	75 ef                	jne    800ada <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aeb:	83 ef 04             	sub    $0x4,%edi
  800aee:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800af4:	fd                   	std    
  800af5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af7:	eb ea                	jmp    800ae3 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af9:	89 f2                	mov    %esi,%edx
  800afb:	09 c2                	or     %eax,%edx
  800afd:	f6 c2 03             	test   $0x3,%dl
  800b00:	74 09                	je     800b0b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b02:	89 c7                	mov    %eax,%edi
  800b04:	fc                   	cld    
  800b05:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b07:	5e                   	pop    %esi
  800b08:	5f                   	pop    %edi
  800b09:	5d                   	pop    %ebp
  800b0a:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0b:	f6 c1 03             	test   $0x3,%cl
  800b0e:	75 f2                	jne    800b02 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b10:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b13:	89 c7                	mov    %eax,%edi
  800b15:	fc                   	cld    
  800b16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b18:	eb ed                	jmp    800b07 <memmove+0x55>

00800b1a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b1d:	ff 75 10             	pushl  0x10(%ebp)
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	ff 75 08             	pushl  0x8(%ebp)
  800b26:	e8 87 ff ff ff       	call   800ab2 <memmove>
}
  800b2b:	c9                   	leave  
  800b2c:	c3                   	ret    

00800b2d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	56                   	push   %esi
  800b31:	53                   	push   %ebx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b38:	89 c6                	mov    %eax,%esi
  800b3a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b3d:	39 f0                	cmp    %esi,%eax
  800b3f:	74 1c                	je     800b5d <memcmp+0x30>
		if (*s1 != *s2)
  800b41:	0f b6 08             	movzbl (%eax),%ecx
  800b44:	0f b6 1a             	movzbl (%edx),%ebx
  800b47:	38 d9                	cmp    %bl,%cl
  800b49:	75 08                	jne    800b53 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b4b:	83 c0 01             	add    $0x1,%eax
  800b4e:	83 c2 01             	add    $0x1,%edx
  800b51:	eb ea                	jmp    800b3d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b53:	0f b6 c1             	movzbl %cl,%eax
  800b56:	0f b6 db             	movzbl %bl,%ebx
  800b59:	29 d8                	sub    %ebx,%eax
  800b5b:	eb 05                	jmp    800b62 <memcmp+0x35>
	}

	return 0;
  800b5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b62:	5b                   	pop    %ebx
  800b63:	5e                   	pop    %esi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b6f:	89 c2                	mov    %eax,%edx
  800b71:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b74:	39 d0                	cmp    %edx,%eax
  800b76:	73 09                	jae    800b81 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b78:	38 08                	cmp    %cl,(%eax)
  800b7a:	74 05                	je     800b81 <memfind+0x1b>
	for (; s < ends; s++)
  800b7c:	83 c0 01             	add    $0x1,%eax
  800b7f:	eb f3                	jmp    800b74 <memfind+0xe>
			break;
	return (void *) s;
}
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	57                   	push   %edi
  800b87:	56                   	push   %esi
  800b88:	53                   	push   %ebx
  800b89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b8f:	eb 03                	jmp    800b94 <strtol+0x11>
		s++;
  800b91:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b94:	0f b6 01             	movzbl (%ecx),%eax
  800b97:	3c 20                	cmp    $0x20,%al
  800b99:	74 f6                	je     800b91 <strtol+0xe>
  800b9b:	3c 09                	cmp    $0x9,%al
  800b9d:	74 f2                	je     800b91 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b9f:	3c 2b                	cmp    $0x2b,%al
  800ba1:	74 2e                	je     800bd1 <strtol+0x4e>
	int neg = 0;
  800ba3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ba8:	3c 2d                	cmp    $0x2d,%al
  800baa:	74 2f                	je     800bdb <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bac:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bb2:	75 05                	jne    800bb9 <strtol+0x36>
  800bb4:	80 39 30             	cmpb   $0x30,(%ecx)
  800bb7:	74 2c                	je     800be5 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb9:	85 db                	test   %ebx,%ebx
  800bbb:	75 0a                	jne    800bc7 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bbd:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800bc2:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc5:	74 28                	je     800bef <strtol+0x6c>
		base = 10;
  800bc7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bcf:	eb 50                	jmp    800c21 <strtol+0x9e>
		s++;
  800bd1:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bd4:	bf 00 00 00 00       	mov    $0x0,%edi
  800bd9:	eb d1                	jmp    800bac <strtol+0x29>
		s++, neg = 1;
  800bdb:	83 c1 01             	add    $0x1,%ecx
  800bde:	bf 01 00 00 00       	mov    $0x1,%edi
  800be3:	eb c7                	jmp    800bac <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be5:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800be9:	74 0e                	je     800bf9 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800beb:	85 db                	test   %ebx,%ebx
  800bed:	75 d8                	jne    800bc7 <strtol+0x44>
		s++, base = 8;
  800bef:	83 c1 01             	add    $0x1,%ecx
  800bf2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bf7:	eb ce                	jmp    800bc7 <strtol+0x44>
		s += 2, base = 16;
  800bf9:	83 c1 02             	add    $0x2,%ecx
  800bfc:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c01:	eb c4                	jmp    800bc7 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c03:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c06:	89 f3                	mov    %esi,%ebx
  800c08:	80 fb 19             	cmp    $0x19,%bl
  800c0b:	77 29                	ja     800c36 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c0d:	0f be d2             	movsbl %dl,%edx
  800c10:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c13:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c16:	7d 30                	jge    800c48 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c18:	83 c1 01             	add    $0x1,%ecx
  800c1b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c1f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c21:	0f b6 11             	movzbl (%ecx),%edx
  800c24:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c27:	89 f3                	mov    %esi,%ebx
  800c29:	80 fb 09             	cmp    $0x9,%bl
  800c2c:	77 d5                	ja     800c03 <strtol+0x80>
			dig = *s - '0';
  800c2e:	0f be d2             	movsbl %dl,%edx
  800c31:	83 ea 30             	sub    $0x30,%edx
  800c34:	eb dd                	jmp    800c13 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c36:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c39:	89 f3                	mov    %esi,%ebx
  800c3b:	80 fb 19             	cmp    $0x19,%bl
  800c3e:	77 08                	ja     800c48 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c40:	0f be d2             	movsbl %dl,%edx
  800c43:	83 ea 37             	sub    $0x37,%edx
  800c46:	eb cb                	jmp    800c13 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4c:	74 05                	je     800c53 <strtol+0xd0>
		*endptr = (char *) s;
  800c4e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c51:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c53:	89 c2                	mov    %eax,%edx
  800c55:	f7 da                	neg    %edx
  800c57:	85 ff                	test   %edi,%edi
  800c59:	0f 45 c2             	cmovne %edx,%eax
}
  800c5c:	5b                   	pop    %ebx
  800c5d:	5e                   	pop    %esi
  800c5e:	5f                   	pop    %edi
  800c5f:	5d                   	pop    %ebp
  800c60:	c3                   	ret    

00800c61 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	57                   	push   %edi
  800c65:	56                   	push   %esi
  800c66:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c67:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c72:	89 c3                	mov    %eax,%ebx
  800c74:	89 c7                	mov    %eax,%edi
  800c76:	89 c6                	mov    %eax,%esi
  800c78:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c7a:	5b                   	pop    %ebx
  800c7b:	5e                   	pop    %esi
  800c7c:	5f                   	pop    %edi
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c85:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c8f:	89 d1                	mov    %edx,%ecx
  800c91:	89 d3                	mov    %edx,%ebx
  800c93:	89 d7                	mov    %edx,%edi
  800c95:	89 d6                	mov    %edx,%esi
  800c97:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5f                   	pop    %edi
  800c9c:	5d                   	pop    %ebp
  800c9d:	c3                   	ret    

00800c9e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	57                   	push   %edi
  800ca2:	56                   	push   %esi
  800ca3:	53                   	push   %ebx
  800ca4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ca7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb4:	89 cb                	mov    %ecx,%ebx
  800cb6:	89 cf                	mov    %ecx,%edi
  800cb8:	89 ce                	mov    %ecx,%esi
  800cba:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbc:	85 c0                	test   %eax,%eax
  800cbe:	7f 08                	jg     800cc8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc3:	5b                   	pop    %ebx
  800cc4:	5e                   	pop    %esi
  800cc5:	5f                   	pop    %edi
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc8:	83 ec 0c             	sub    $0xc,%esp
  800ccb:	50                   	push   %eax
  800ccc:	6a 03                	push   $0x3
  800cce:	68 bf 26 80 00       	push   $0x8026bf
  800cd3:	6a 23                	push   $0x23
  800cd5:	68 dc 26 80 00       	push   $0x8026dc
  800cda:	e8 4b f5 ff ff       	call   80022a <_panic>

00800cdf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	57                   	push   %edi
  800ce3:	56                   	push   %esi
  800ce4:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ce5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cea:	b8 02 00 00 00       	mov    $0x2,%eax
  800cef:	89 d1                	mov    %edx,%ecx
  800cf1:	89 d3                	mov    %edx,%ebx
  800cf3:	89 d7                	mov    %edx,%edi
  800cf5:	89 d6                	mov    %edx,%esi
  800cf7:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cf9:	5b                   	pop    %ebx
  800cfa:	5e                   	pop    %esi
  800cfb:	5f                   	pop    %edi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <sys_yield>:

void
sys_yield(void)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	57                   	push   %edi
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d04:	ba 00 00 00 00       	mov    $0x0,%edx
  800d09:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d0e:	89 d1                	mov    %edx,%ecx
  800d10:	89 d3                	mov    %edx,%ebx
  800d12:	89 d7                	mov    %edx,%edi
  800d14:	89 d6                	mov    %edx,%esi
  800d16:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d18:	5b                   	pop    %ebx
  800d19:	5e                   	pop    %esi
  800d1a:	5f                   	pop    %edi
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    

00800d1d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	57                   	push   %edi
  800d21:	56                   	push   %esi
  800d22:	53                   	push   %ebx
  800d23:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d26:	be 00 00 00 00       	mov    $0x0,%esi
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d31:	b8 04 00 00 00       	mov    $0x4,%eax
  800d36:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d39:	89 f7                	mov    %esi,%edi
  800d3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	7f 08                	jg     800d49 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	50                   	push   %eax
  800d4d:	6a 04                	push   $0x4
  800d4f:	68 bf 26 80 00       	push   $0x8026bf
  800d54:	6a 23                	push   $0x23
  800d56:	68 dc 26 80 00       	push   $0x8026dc
  800d5b:	e8 ca f4 ff ff       	call   80022a <_panic>

00800d60 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	57                   	push   %edi
  800d64:	56                   	push   %esi
  800d65:	53                   	push   %ebx
  800d66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6f:	b8 05 00 00 00       	mov    $0x5,%eax
  800d74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d77:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d7a:	8b 75 18             	mov    0x18(%ebp),%esi
  800d7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7f:	85 c0                	test   %eax,%eax
  800d81:	7f 08                	jg     800d8b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d86:	5b                   	pop    %ebx
  800d87:	5e                   	pop    %esi
  800d88:	5f                   	pop    %edi
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8b:	83 ec 0c             	sub    $0xc,%esp
  800d8e:	50                   	push   %eax
  800d8f:	6a 05                	push   $0x5
  800d91:	68 bf 26 80 00       	push   $0x8026bf
  800d96:	6a 23                	push   $0x23
  800d98:	68 dc 26 80 00       	push   $0x8026dc
  800d9d:	e8 88 f4 ff ff       	call   80022a <_panic>

00800da2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	57                   	push   %edi
  800da6:	56                   	push   %esi
  800da7:	53                   	push   %ebx
  800da8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800dab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db6:	b8 06 00 00 00       	mov    $0x6,%eax
  800dbb:	89 df                	mov    %ebx,%edi
  800dbd:	89 de                	mov    %ebx,%esi
  800dbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc1:	85 c0                	test   %eax,%eax
  800dc3:	7f 08                	jg     800dcd <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc8:	5b                   	pop    %ebx
  800dc9:	5e                   	pop    %esi
  800dca:	5f                   	pop    %edi
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcd:	83 ec 0c             	sub    $0xc,%esp
  800dd0:	50                   	push   %eax
  800dd1:	6a 06                	push   $0x6
  800dd3:	68 bf 26 80 00       	push   $0x8026bf
  800dd8:	6a 23                	push   $0x23
  800dda:	68 dc 26 80 00       	push   $0x8026dc
  800ddf:	e8 46 f4 ff ff       	call   80022a <_panic>

00800de4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	57                   	push   %edi
  800de8:	56                   	push   %esi
  800de9:	53                   	push   %ebx
  800dea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ded:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df2:	8b 55 08             	mov    0x8(%ebp),%edx
  800df5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df8:	b8 08 00 00 00       	mov    $0x8,%eax
  800dfd:	89 df                	mov    %ebx,%edi
  800dff:	89 de                	mov    %ebx,%esi
  800e01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e03:	85 c0                	test   %eax,%eax
  800e05:	7f 08                	jg     800e0f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0a:	5b                   	pop    %ebx
  800e0b:	5e                   	pop    %esi
  800e0c:	5f                   	pop    %edi
  800e0d:	5d                   	pop    %ebp
  800e0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0f:	83 ec 0c             	sub    $0xc,%esp
  800e12:	50                   	push   %eax
  800e13:	6a 08                	push   $0x8
  800e15:	68 bf 26 80 00       	push   $0x8026bf
  800e1a:	6a 23                	push   $0x23
  800e1c:	68 dc 26 80 00       	push   $0x8026dc
  800e21:	e8 04 f4 ff ff       	call   80022a <_panic>

00800e26 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	57                   	push   %edi
  800e2a:	56                   	push   %esi
  800e2b:	53                   	push   %ebx
  800e2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e34:	8b 55 08             	mov    0x8(%ebp),%edx
  800e37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e3f:	89 df                	mov    %ebx,%edi
  800e41:	89 de                	mov    %ebx,%esi
  800e43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e45:	85 c0                	test   %eax,%eax
  800e47:	7f 08                	jg     800e51 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4c:	5b                   	pop    %ebx
  800e4d:	5e                   	pop    %esi
  800e4e:	5f                   	pop    %edi
  800e4f:	5d                   	pop    %ebp
  800e50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e51:	83 ec 0c             	sub    $0xc,%esp
  800e54:	50                   	push   %eax
  800e55:	6a 09                	push   $0x9
  800e57:	68 bf 26 80 00       	push   $0x8026bf
  800e5c:	6a 23                	push   $0x23
  800e5e:	68 dc 26 80 00       	push   $0x8026dc
  800e63:	e8 c2 f3 ff ff       	call   80022a <_panic>

00800e68 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	57                   	push   %edi
  800e6c:	56                   	push   %esi
  800e6d:	53                   	push   %ebx
  800e6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e71:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e76:	8b 55 08             	mov    0x8(%ebp),%edx
  800e79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e81:	89 df                	mov    %ebx,%edi
  800e83:	89 de                	mov    %ebx,%esi
  800e85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e87:	85 c0                	test   %eax,%eax
  800e89:	7f 08                	jg     800e93 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8e:	5b                   	pop    %ebx
  800e8f:	5e                   	pop    %esi
  800e90:	5f                   	pop    %edi
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e93:	83 ec 0c             	sub    $0xc,%esp
  800e96:	50                   	push   %eax
  800e97:	6a 0a                	push   $0xa
  800e99:	68 bf 26 80 00       	push   $0x8026bf
  800e9e:	6a 23                	push   $0x23
  800ea0:	68 dc 26 80 00       	push   $0x8026dc
  800ea5:	e8 80 f3 ff ff       	call   80022a <_panic>

00800eaa <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	57                   	push   %edi
  800eae:	56                   	push   %esi
  800eaf:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ebb:	be 00 00 00 00       	mov    $0x0,%esi
  800ec0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    

00800ecd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
  800ed3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ed6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ee3:	89 cb                	mov    %ecx,%ebx
  800ee5:	89 cf                	mov    %ecx,%edi
  800ee7:	89 ce                	mov    %ecx,%esi
  800ee9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	7f 08                	jg     800ef7 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef2:	5b                   	pop    %ebx
  800ef3:	5e                   	pop    %esi
  800ef4:	5f                   	pop    %edi
  800ef5:	5d                   	pop    %ebp
  800ef6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef7:	83 ec 0c             	sub    $0xc,%esp
  800efa:	50                   	push   %eax
  800efb:	6a 0d                	push   $0xd
  800efd:	68 bf 26 80 00       	push   $0x8026bf
  800f02:	6a 23                	push   $0x23
  800f04:	68 dc 26 80 00       	push   $0x8026dc
  800f09:	e8 1c f3 ff ff       	call   80022a <_panic>

00800f0e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	53                   	push   %ebx
  800f12:	83 ec 04             	sub    $0x4,%esp
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f18:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) { //只有因为写操作写时拷贝的地址这中情况，才可以抢救。否则一律panic
  800f1a:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f1e:	74 74                	je     800f94 <pgfault+0x86>
  800f20:	89 d8                	mov    %ebx,%eax
  800f22:	c1 e8 0c             	shr    $0xc,%eax
  800f25:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f2c:	f6 c4 08             	test   $0x8,%ah
  800f2f:	74 63                	je     800f94 <pgfault+0x86>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800f31:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, PFTEMP, PTE_U|PTE_P)) < 0)		//将当前进程PFTEMP也映射到当前进程addr指向的物理页
  800f37:	83 ec 0c             	sub    $0xc,%esp
  800f3a:	6a 05                	push   $0x5
  800f3c:	68 00 f0 7f 00       	push   $0x7ff000
  800f41:	6a 00                	push   $0x0
  800f43:	53                   	push   %ebx
  800f44:	6a 00                	push   $0x0
  800f46:	e8 15 fe ff ff       	call   800d60 <sys_page_map>
  800f4b:	83 c4 20             	add    $0x20,%esp
  800f4e:	85 c0                	test   %eax,%eax
  800f50:	78 56                	js     800fa8 <pgfault+0x9a>
		panic("sys_page_map: %e", r);
	if ((r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W)) < 0)	//令当前进程addr指向新分配的物理页
  800f52:	83 ec 04             	sub    $0x4,%esp
  800f55:	6a 07                	push   $0x7
  800f57:	53                   	push   %ebx
  800f58:	6a 00                	push   $0x0
  800f5a:	e8 be fd ff ff       	call   800d1d <sys_page_alloc>
  800f5f:	83 c4 10             	add    $0x10,%esp
  800f62:	85 c0                	test   %eax,%eax
  800f64:	78 54                	js     800fba <pgfault+0xac>
		panic("sys_page_alloc: %e", r);
	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800f66:	83 ec 04             	sub    $0x4,%esp
  800f69:	68 00 10 00 00       	push   $0x1000
  800f6e:	68 00 f0 7f 00       	push   $0x7ff000
  800f73:	53                   	push   %ebx
  800f74:	e8 39 fb ff ff       	call   800ab2 <memmove>
	if ((r = sys_page_unmap(0, PFTEMP)) < 0)					//解除当前进程PFTEMP映射
  800f79:	83 c4 08             	add    $0x8,%esp
  800f7c:	68 00 f0 7f 00       	push   $0x7ff000
  800f81:	6a 00                	push   $0x0
  800f83:	e8 1a fe ff ff       	call   800da2 <sys_page_unmap>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	78 3d                	js     800fcc <pgfault+0xbe>
		panic("sys_page_unmap: %e", r);
}
  800f8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f92:	c9                   	leave  
  800f93:	c3                   	ret    
		panic("pgfault():not cow");
  800f94:	83 ec 04             	sub    $0x4,%esp
  800f97:	68 ea 26 80 00       	push   $0x8026ea
  800f9c:	6a 1d                	push   $0x1d
  800f9e:	68 fc 26 80 00       	push   $0x8026fc
  800fa3:	e8 82 f2 ff ff       	call   80022a <_panic>
		panic("sys_page_map: %e", r);
  800fa8:	50                   	push   %eax
  800fa9:	68 07 27 80 00       	push   $0x802707
  800fae:	6a 2a                	push   $0x2a
  800fb0:	68 fc 26 80 00       	push   $0x8026fc
  800fb5:	e8 70 f2 ff ff       	call   80022a <_panic>
		panic("sys_page_alloc: %e", r);
  800fba:	50                   	push   %eax
  800fbb:	68 18 27 80 00       	push   $0x802718
  800fc0:	6a 2c                	push   $0x2c
  800fc2:	68 fc 26 80 00       	push   $0x8026fc
  800fc7:	e8 5e f2 ff ff       	call   80022a <_panic>
		panic("sys_page_unmap: %e", r);
  800fcc:	50                   	push   %eax
  800fcd:	68 2b 27 80 00       	push   $0x80272b
  800fd2:	6a 2f                	push   $0x2f
  800fd4:	68 fc 26 80 00       	push   $0x8026fc
  800fd9:	e8 4c f2 ff ff       	call   80022a <_panic>

00800fde <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	57                   	push   %edi
  800fe2:	56                   	push   %esi
  800fe3:	53                   	push   %ebx
  800fe4:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);	//设置缺页处理函数
  800fe7:	68 0e 0f 80 00       	push   $0x800f0e
  800fec:	e8 dd 0e 00 00       	call   801ece <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800ff1:	b8 07 00 00 00       	mov    $0x7,%eax
  800ff6:	cd 30                	int    $0x30
  800ff8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();	//系统调用，只是简单创建一个Env结构，复制当前用户环境寄存器状态，UTOP以下的页目录还没有建立
	if (envid == 0) {				//子进程将走这个逻辑
  800ffb:	83 c4 10             	add    $0x10,%esp
  800ffe:	85 c0                	test   %eax,%eax
  801000:	74 12                	je     801014 <fork+0x36>
  801002:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	if (envid < 0) {
  801004:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801008:	78 26                	js     801030 <fork+0x52>
		panic("sys_exofork: %e", envid);
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80100a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100f:	e9 94 00 00 00       	jmp    8010a8 <fork+0xca>
		thisenv = &envs[ENVX(sys_getenvid())];
  801014:	e8 c6 fc ff ff       	call   800cdf <sys_getenvid>
  801019:	25 ff 03 00 00       	and    $0x3ff,%eax
  80101e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801021:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801026:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80102b:	e9 51 01 00 00       	jmp    801181 <fork+0x1a3>
		panic("sys_exofork: %e", envid);
  801030:	ff 75 e4             	pushl  -0x1c(%ebp)
  801033:	68 3e 27 80 00       	push   $0x80273e
  801038:	6a 6d                	push   $0x6d
  80103a:	68 fc 26 80 00       	push   $0x8026fc
  80103f:	e8 e6 f1 ff ff       	call   80022a <_panic>
		sys_page_map(0, addr, envid, addr, PTE_SYSCALL);		//对于表示为PTE_SHARE的页，拷贝映射关系，并且两个进程都有读写权限
  801044:	83 ec 0c             	sub    $0xc,%esp
  801047:	68 07 0e 00 00       	push   $0xe07
  80104c:	56                   	push   %esi
  80104d:	57                   	push   %edi
  80104e:	56                   	push   %esi
  80104f:	6a 00                	push   $0x0
  801051:	e8 0a fd ff ff       	call   800d60 <sys_page_map>
  801056:	83 c4 20             	add    $0x20,%esp
  801059:	eb 3b                	jmp    801096 <fork+0xb8>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  80105b:	83 ec 0c             	sub    $0xc,%esp
  80105e:	68 05 08 00 00       	push   $0x805
  801063:	56                   	push   %esi
  801064:	57                   	push   %edi
  801065:	56                   	push   %esi
  801066:	6a 00                	push   $0x0
  801068:	e8 f3 fc ff ff       	call   800d60 <sys_page_map>
  80106d:	83 c4 20             	add    $0x20,%esp
  801070:	85 c0                	test   %eax,%eax
  801072:	0f 88 a9 00 00 00    	js     801121 <fork+0x143>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  801078:	83 ec 0c             	sub    $0xc,%esp
  80107b:	68 05 08 00 00       	push   $0x805
  801080:	56                   	push   %esi
  801081:	6a 00                	push   $0x0
  801083:	56                   	push   %esi
  801084:	6a 00                	push   $0x0
  801086:	e8 d5 fc ff ff       	call   800d60 <sys_page_map>
  80108b:	83 c4 20             	add    $0x20,%esp
  80108e:	85 c0                	test   %eax,%eax
  801090:	0f 88 9d 00 00 00    	js     801133 <fork+0x155>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801096:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80109c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8010a2:	0f 84 9d 00 00 00    	je     801145 <fork+0x167>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) //为什么uvpt[pagenumber]能访问到第pagenumber项页表条目：https://pdos.csail.mit.edu/6.828/2018/labs/lab4/uvpt.html
  8010a8:	89 d8                	mov    %ebx,%eax
  8010aa:	c1 e8 16             	shr    $0x16,%eax
  8010ad:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010b4:	a8 01                	test   $0x1,%al
  8010b6:	74 de                	je     801096 <fork+0xb8>
  8010b8:	89 d8                	mov    %ebx,%eax
  8010ba:	c1 e8 0c             	shr    $0xc,%eax
  8010bd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010c4:	f6 c2 01             	test   $0x1,%dl
  8010c7:	74 cd                	je     801096 <fork+0xb8>
			&& (uvpt[PGNUM(addr)] & PTE_U)) {
  8010c9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010d0:	f6 c2 04             	test   $0x4,%dl
  8010d3:	74 c1                	je     801096 <fork+0xb8>
	void *addr = (void*) (pn * PGSIZE);
  8010d5:	89 c6                	mov    %eax,%esi
  8010d7:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE) {
  8010da:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010e1:	f6 c6 04             	test   $0x4,%dh
  8010e4:	0f 85 5a ff ff ff    	jne    801044 <fork+0x66>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) { //对于UTOP以下的可写的或者写时拷贝的页，拷贝映射关系的同时，需要同时标记当前进程和子进程的页表项为PTE_COW
  8010ea:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010f1:	f6 c2 02             	test   $0x2,%dl
  8010f4:	0f 85 61 ff ff ff    	jne    80105b <fork+0x7d>
  8010fa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801101:	f6 c4 08             	test   $0x8,%ah
  801104:	0f 85 51 ff ff ff    	jne    80105b <fork+0x7d>
		sys_page_map(0, addr, envid, addr, PTE_U|PTE_P);	//对于只读的页，只需要拷贝映射关系即可
  80110a:	83 ec 0c             	sub    $0xc,%esp
  80110d:	6a 05                	push   $0x5
  80110f:	56                   	push   %esi
  801110:	57                   	push   %edi
  801111:	56                   	push   %esi
  801112:	6a 00                	push   $0x0
  801114:	e8 47 fc ff ff       	call   800d60 <sys_page_map>
  801119:	83 c4 20             	add    $0x20,%esp
  80111c:	e9 75 ff ff ff       	jmp    801096 <fork+0xb8>
			panic("sys_page_map：%e", r);
  801121:	50                   	push   %eax
  801122:	68 4e 27 80 00       	push   $0x80274e
  801127:	6a 48                	push   $0x48
  801129:	68 fc 26 80 00       	push   $0x8026fc
  80112e:	e8 f7 f0 ff ff       	call   80022a <_panic>
			panic("sys_page_map：%e", r);
  801133:	50                   	push   %eax
  801134:	68 4e 27 80 00       	push   $0x80274e
  801139:	6a 4a                	push   $0x4a
  80113b:	68 fc 26 80 00       	push   $0x8026fc
  801140:	e8 e5 f0 ff ff       	call   80022a <_panic>
			duppage(envid, PGNUM(addr));	//拷贝当前进程映射关系到子进程
		}
	}
	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_W | PTE_U)) < 0)	//为子进程分配异常栈
  801145:	83 ec 04             	sub    $0x4,%esp
  801148:	6a 07                	push   $0x7
  80114a:	68 00 f0 bf ee       	push   $0xeebff000
  80114f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801152:	e8 c6 fb ff ff       	call   800d1d <sys_page_alloc>
  801157:	83 c4 10             	add    $0x10,%esp
  80115a:	85 c0                	test   %eax,%eax
  80115c:	78 2e                	js     80118c <fork+0x1ae>
		panic("sys_page_alloc: %e", r);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);		//为子进程设置_pgfault_upcall
  80115e:	83 ec 08             	sub    $0x8,%esp
  801161:	68 27 1f 80 00       	push   $0x801f27
  801166:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801169:	57                   	push   %edi
  80116a:	e8 f9 fc ff ff       	call   800e68 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)	//设置子进程为ENV_RUNNABLE状态
  80116f:	83 c4 08             	add    $0x8,%esp
  801172:	6a 02                	push   $0x2
  801174:	57                   	push   %edi
  801175:	e8 6a fc ff ff       	call   800de4 <sys_env_set_status>
  80117a:	83 c4 10             	add    $0x10,%esp
  80117d:	85 c0                	test   %eax,%eax
  80117f:	78 1d                	js     80119e <fork+0x1c0>
		panic("sys_env_set_status: %e", r);
	return envid;
}
  801181:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801184:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801187:	5b                   	pop    %ebx
  801188:	5e                   	pop    %esi
  801189:	5f                   	pop    %edi
  80118a:	5d                   	pop    %ebp
  80118b:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80118c:	50                   	push   %eax
  80118d:	68 18 27 80 00       	push   $0x802718
  801192:	6a 79                	push   $0x79
  801194:	68 fc 26 80 00       	push   $0x8026fc
  801199:	e8 8c f0 ff ff       	call   80022a <_panic>
		panic("sys_env_set_status: %e", r);
  80119e:	50                   	push   %eax
  80119f:	68 60 27 80 00       	push   $0x802760
  8011a4:	6a 7d                	push   $0x7d
  8011a6:	68 fc 26 80 00       	push   $0x8026fc
  8011ab:	e8 7a f0 ff ff       	call   80022a <_panic>

008011b0 <sfork>:

// Challenge!
int
sfork(void)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011b6:	68 77 27 80 00       	push   $0x802777
  8011bb:	68 85 00 00 00       	push   $0x85
  8011c0:	68 fc 26 80 00       	push   $0x8026fc
  8011c5:	e8 60 f0 ff ff       	call   80022a <_panic>

008011ca <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	05 00 00 00 30       	add    $0x30000000,%eax
  8011d5:	c1 e8 0c             	shr    $0xc,%eax
}
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    

008011da <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ea:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011ef:	5d                   	pop    %ebp
  8011f0:	c3                   	ret    

008011f1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011fc:	89 c2                	mov    %eax,%edx
  8011fe:	c1 ea 16             	shr    $0x16,%edx
  801201:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801208:	f6 c2 01             	test   $0x1,%dl
  80120b:	74 2a                	je     801237 <fd_alloc+0x46>
  80120d:	89 c2                	mov    %eax,%edx
  80120f:	c1 ea 0c             	shr    $0xc,%edx
  801212:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801219:	f6 c2 01             	test   $0x1,%dl
  80121c:	74 19                	je     801237 <fd_alloc+0x46>
  80121e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801223:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801228:	75 d2                	jne    8011fc <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80122a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801230:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801235:	eb 07                	jmp    80123e <fd_alloc+0x4d>
			*fd_store = fd;
  801237:	89 01                	mov    %eax,(%ecx)
			return 0;
  801239:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80123e:	5d                   	pop    %ebp
  80123f:	c3                   	ret    

00801240 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801246:	83 f8 1f             	cmp    $0x1f,%eax
  801249:	77 36                	ja     801281 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80124b:	c1 e0 0c             	shl    $0xc,%eax
  80124e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801253:	89 c2                	mov    %eax,%edx
  801255:	c1 ea 16             	shr    $0x16,%edx
  801258:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80125f:	f6 c2 01             	test   $0x1,%dl
  801262:	74 24                	je     801288 <fd_lookup+0x48>
  801264:	89 c2                	mov    %eax,%edx
  801266:	c1 ea 0c             	shr    $0xc,%edx
  801269:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801270:	f6 c2 01             	test   $0x1,%dl
  801273:	74 1a                	je     80128f <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801275:	8b 55 0c             	mov    0xc(%ebp),%edx
  801278:	89 02                	mov    %eax,(%edx)
	return 0;
  80127a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    
		return -E_INVAL;
  801281:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801286:	eb f7                	jmp    80127f <fd_lookup+0x3f>
		return -E_INVAL;
  801288:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128d:	eb f0                	jmp    80127f <fd_lookup+0x3f>
  80128f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801294:	eb e9                	jmp    80127f <fd_lookup+0x3f>

00801296 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	83 ec 08             	sub    $0x8,%esp
  80129c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80129f:	ba 0c 28 80 00       	mov    $0x80280c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012a4:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012a9:	39 08                	cmp    %ecx,(%eax)
  8012ab:	74 33                	je     8012e0 <dev_lookup+0x4a>
  8012ad:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012b0:	8b 02                	mov    (%edx),%eax
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	75 f3                	jne    8012a9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012b6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012bb:	8b 40 48             	mov    0x48(%eax),%eax
  8012be:	83 ec 04             	sub    $0x4,%esp
  8012c1:	51                   	push   %ecx
  8012c2:	50                   	push   %eax
  8012c3:	68 90 27 80 00       	push   $0x802790
  8012c8:	e8 38 f0 ff ff       	call   800305 <cprintf>
	*dev = 0;
  8012cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012d6:	83 c4 10             	add    $0x10,%esp
  8012d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    
			*dev = devtab[i];
  8012e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ea:	eb f2                	jmp    8012de <dev_lookup+0x48>

008012ec <fd_close>:
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	57                   	push   %edi
  8012f0:	56                   	push   %esi
  8012f1:	53                   	push   %ebx
  8012f2:	83 ec 1c             	sub    $0x1c,%esp
  8012f5:	8b 75 08             	mov    0x8(%ebp),%esi
  8012f8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012fe:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012ff:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801305:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801308:	50                   	push   %eax
  801309:	e8 32 ff ff ff       	call   801240 <fd_lookup>
  80130e:	89 c3                	mov    %eax,%ebx
  801310:	83 c4 08             	add    $0x8,%esp
  801313:	85 c0                	test   %eax,%eax
  801315:	78 05                	js     80131c <fd_close+0x30>
	    || fd != fd2)
  801317:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80131a:	74 16                	je     801332 <fd_close+0x46>
		return (must_exist ? r : 0);
  80131c:	89 f8                	mov    %edi,%eax
  80131e:	84 c0                	test   %al,%al
  801320:	b8 00 00 00 00       	mov    $0x0,%eax
  801325:	0f 44 d8             	cmove  %eax,%ebx
}
  801328:	89 d8                	mov    %ebx,%eax
  80132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80132d:	5b                   	pop    %ebx
  80132e:	5e                   	pop    %esi
  80132f:	5f                   	pop    %edi
  801330:	5d                   	pop    %ebp
  801331:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801332:	83 ec 08             	sub    $0x8,%esp
  801335:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801338:	50                   	push   %eax
  801339:	ff 36                	pushl  (%esi)
  80133b:	e8 56 ff ff ff       	call   801296 <dev_lookup>
  801340:	89 c3                	mov    %eax,%ebx
  801342:	83 c4 10             	add    $0x10,%esp
  801345:	85 c0                	test   %eax,%eax
  801347:	78 15                	js     80135e <fd_close+0x72>
		if (dev->dev_close)
  801349:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80134c:	8b 40 10             	mov    0x10(%eax),%eax
  80134f:	85 c0                	test   %eax,%eax
  801351:	74 1b                	je     80136e <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801353:	83 ec 0c             	sub    $0xc,%esp
  801356:	56                   	push   %esi
  801357:	ff d0                	call   *%eax
  801359:	89 c3                	mov    %eax,%ebx
  80135b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80135e:	83 ec 08             	sub    $0x8,%esp
  801361:	56                   	push   %esi
  801362:	6a 00                	push   $0x0
  801364:	e8 39 fa ff ff       	call   800da2 <sys_page_unmap>
	return r;
  801369:	83 c4 10             	add    $0x10,%esp
  80136c:	eb ba                	jmp    801328 <fd_close+0x3c>
			r = 0;
  80136e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801373:	eb e9                	jmp    80135e <fd_close+0x72>

00801375 <close>:

int
close(int fdnum)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80137b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80137e:	50                   	push   %eax
  80137f:	ff 75 08             	pushl  0x8(%ebp)
  801382:	e8 b9 fe ff ff       	call   801240 <fd_lookup>
  801387:	83 c4 08             	add    $0x8,%esp
  80138a:	85 c0                	test   %eax,%eax
  80138c:	78 10                	js     80139e <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	6a 01                	push   $0x1
  801393:	ff 75 f4             	pushl  -0xc(%ebp)
  801396:	e8 51 ff ff ff       	call   8012ec <fd_close>
  80139b:	83 c4 10             	add    $0x10,%esp
}
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    

008013a0 <close_all>:

void
close_all(void)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	53                   	push   %ebx
  8013a4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013a7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013ac:	83 ec 0c             	sub    $0xc,%esp
  8013af:	53                   	push   %ebx
  8013b0:	e8 c0 ff ff ff       	call   801375 <close>
	for (i = 0; i < MAXFD; i++)
  8013b5:	83 c3 01             	add    $0x1,%ebx
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	83 fb 20             	cmp    $0x20,%ebx
  8013be:	75 ec                	jne    8013ac <close_all+0xc>
}
  8013c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c3:	c9                   	leave  
  8013c4:	c3                   	ret    

008013c5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	57                   	push   %edi
  8013c9:	56                   	push   %esi
  8013ca:	53                   	push   %ebx
  8013cb:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013ce:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013d1:	50                   	push   %eax
  8013d2:	ff 75 08             	pushl  0x8(%ebp)
  8013d5:	e8 66 fe ff ff       	call   801240 <fd_lookup>
  8013da:	89 c3                	mov    %eax,%ebx
  8013dc:	83 c4 08             	add    $0x8,%esp
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	0f 88 81 00 00 00    	js     801468 <dup+0xa3>
		return r;
	close(newfdnum);
  8013e7:	83 ec 0c             	sub    $0xc,%esp
  8013ea:	ff 75 0c             	pushl  0xc(%ebp)
  8013ed:	e8 83 ff ff ff       	call   801375 <close>

	newfd = INDEX2FD(newfdnum);
  8013f2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013f5:	c1 e6 0c             	shl    $0xc,%esi
  8013f8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013fe:	83 c4 04             	add    $0x4,%esp
  801401:	ff 75 e4             	pushl  -0x1c(%ebp)
  801404:	e8 d1 fd ff ff       	call   8011da <fd2data>
  801409:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80140b:	89 34 24             	mov    %esi,(%esp)
  80140e:	e8 c7 fd ff ff       	call   8011da <fd2data>
  801413:	83 c4 10             	add    $0x10,%esp
  801416:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801418:	89 d8                	mov    %ebx,%eax
  80141a:	c1 e8 16             	shr    $0x16,%eax
  80141d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801424:	a8 01                	test   $0x1,%al
  801426:	74 11                	je     801439 <dup+0x74>
  801428:	89 d8                	mov    %ebx,%eax
  80142a:	c1 e8 0c             	shr    $0xc,%eax
  80142d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801434:	f6 c2 01             	test   $0x1,%dl
  801437:	75 39                	jne    801472 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801439:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80143c:	89 d0                	mov    %edx,%eax
  80143e:	c1 e8 0c             	shr    $0xc,%eax
  801441:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801448:	83 ec 0c             	sub    $0xc,%esp
  80144b:	25 07 0e 00 00       	and    $0xe07,%eax
  801450:	50                   	push   %eax
  801451:	56                   	push   %esi
  801452:	6a 00                	push   $0x0
  801454:	52                   	push   %edx
  801455:	6a 00                	push   $0x0
  801457:	e8 04 f9 ff ff       	call   800d60 <sys_page_map>
  80145c:	89 c3                	mov    %eax,%ebx
  80145e:	83 c4 20             	add    $0x20,%esp
  801461:	85 c0                	test   %eax,%eax
  801463:	78 31                	js     801496 <dup+0xd1>
		goto err;

	return newfdnum;
  801465:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801468:	89 d8                	mov    %ebx,%eax
  80146a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80146d:	5b                   	pop    %ebx
  80146e:	5e                   	pop    %esi
  80146f:	5f                   	pop    %edi
  801470:	5d                   	pop    %ebp
  801471:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801472:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801479:	83 ec 0c             	sub    $0xc,%esp
  80147c:	25 07 0e 00 00       	and    $0xe07,%eax
  801481:	50                   	push   %eax
  801482:	57                   	push   %edi
  801483:	6a 00                	push   $0x0
  801485:	53                   	push   %ebx
  801486:	6a 00                	push   $0x0
  801488:	e8 d3 f8 ff ff       	call   800d60 <sys_page_map>
  80148d:	89 c3                	mov    %eax,%ebx
  80148f:	83 c4 20             	add    $0x20,%esp
  801492:	85 c0                	test   %eax,%eax
  801494:	79 a3                	jns    801439 <dup+0x74>
	sys_page_unmap(0, newfd);
  801496:	83 ec 08             	sub    $0x8,%esp
  801499:	56                   	push   %esi
  80149a:	6a 00                	push   $0x0
  80149c:	e8 01 f9 ff ff       	call   800da2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014a1:	83 c4 08             	add    $0x8,%esp
  8014a4:	57                   	push   %edi
  8014a5:	6a 00                	push   $0x0
  8014a7:	e8 f6 f8 ff ff       	call   800da2 <sys_page_unmap>
	return r;
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	eb b7                	jmp    801468 <dup+0xa3>

008014b1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	53                   	push   %ebx
  8014b5:	83 ec 14             	sub    $0x14,%esp
  8014b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014be:	50                   	push   %eax
  8014bf:	53                   	push   %ebx
  8014c0:	e8 7b fd ff ff       	call   801240 <fd_lookup>
  8014c5:	83 c4 08             	add    $0x8,%esp
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	78 3f                	js     80150b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014cc:	83 ec 08             	sub    $0x8,%esp
  8014cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d2:	50                   	push   %eax
  8014d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d6:	ff 30                	pushl  (%eax)
  8014d8:	e8 b9 fd ff ff       	call   801296 <dev_lookup>
  8014dd:	83 c4 10             	add    $0x10,%esp
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	78 27                	js     80150b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014e7:	8b 42 08             	mov    0x8(%edx),%eax
  8014ea:	83 e0 03             	and    $0x3,%eax
  8014ed:	83 f8 01             	cmp    $0x1,%eax
  8014f0:	74 1e                	je     801510 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f5:	8b 40 08             	mov    0x8(%eax),%eax
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	74 35                	je     801531 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014fc:	83 ec 04             	sub    $0x4,%esp
  8014ff:	ff 75 10             	pushl  0x10(%ebp)
  801502:	ff 75 0c             	pushl  0xc(%ebp)
  801505:	52                   	push   %edx
  801506:	ff d0                	call   *%eax
  801508:	83 c4 10             	add    $0x10,%esp
}
  80150b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801510:	a1 04 40 80 00       	mov    0x804004,%eax
  801515:	8b 40 48             	mov    0x48(%eax),%eax
  801518:	83 ec 04             	sub    $0x4,%esp
  80151b:	53                   	push   %ebx
  80151c:	50                   	push   %eax
  80151d:	68 d1 27 80 00       	push   $0x8027d1
  801522:	e8 de ed ff ff       	call   800305 <cprintf>
		return -E_INVAL;
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80152f:	eb da                	jmp    80150b <read+0x5a>
		return -E_NOT_SUPP;
  801531:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801536:	eb d3                	jmp    80150b <read+0x5a>

00801538 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	57                   	push   %edi
  80153c:	56                   	push   %esi
  80153d:	53                   	push   %ebx
  80153e:	83 ec 0c             	sub    $0xc,%esp
  801541:	8b 7d 08             	mov    0x8(%ebp),%edi
  801544:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801547:	bb 00 00 00 00       	mov    $0x0,%ebx
  80154c:	39 f3                	cmp    %esi,%ebx
  80154e:	73 25                	jae    801575 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801550:	83 ec 04             	sub    $0x4,%esp
  801553:	89 f0                	mov    %esi,%eax
  801555:	29 d8                	sub    %ebx,%eax
  801557:	50                   	push   %eax
  801558:	89 d8                	mov    %ebx,%eax
  80155a:	03 45 0c             	add    0xc(%ebp),%eax
  80155d:	50                   	push   %eax
  80155e:	57                   	push   %edi
  80155f:	e8 4d ff ff ff       	call   8014b1 <read>
		if (m < 0)
  801564:	83 c4 10             	add    $0x10,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	78 08                	js     801573 <readn+0x3b>
			return m;
		if (m == 0)
  80156b:	85 c0                	test   %eax,%eax
  80156d:	74 06                	je     801575 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80156f:	01 c3                	add    %eax,%ebx
  801571:	eb d9                	jmp    80154c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801573:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801575:	89 d8                	mov    %ebx,%eax
  801577:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80157a:	5b                   	pop    %ebx
  80157b:	5e                   	pop    %esi
  80157c:	5f                   	pop    %edi
  80157d:	5d                   	pop    %ebp
  80157e:	c3                   	ret    

0080157f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	53                   	push   %ebx
  801583:	83 ec 14             	sub    $0x14,%esp
  801586:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801589:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80158c:	50                   	push   %eax
  80158d:	53                   	push   %ebx
  80158e:	e8 ad fc ff ff       	call   801240 <fd_lookup>
  801593:	83 c4 08             	add    $0x8,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	78 3a                	js     8015d4 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a0:	50                   	push   %eax
  8015a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a4:	ff 30                	pushl  (%eax)
  8015a6:	e8 eb fc ff ff       	call   801296 <dev_lookup>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	78 22                	js     8015d4 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015b9:	74 1e                	je     8015d9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015be:	8b 52 0c             	mov    0xc(%edx),%edx
  8015c1:	85 d2                	test   %edx,%edx
  8015c3:	74 35                	je     8015fa <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015c5:	83 ec 04             	sub    $0x4,%esp
  8015c8:	ff 75 10             	pushl  0x10(%ebp)
  8015cb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ce:	50                   	push   %eax
  8015cf:	ff d2                	call   *%edx
  8015d1:	83 c4 10             	add    $0x10,%esp
}
  8015d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015d9:	a1 04 40 80 00       	mov    0x804004,%eax
  8015de:	8b 40 48             	mov    0x48(%eax),%eax
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	53                   	push   %ebx
  8015e5:	50                   	push   %eax
  8015e6:	68 ed 27 80 00       	push   $0x8027ed
  8015eb:	e8 15 ed ff ff       	call   800305 <cprintf>
		return -E_INVAL;
  8015f0:	83 c4 10             	add    $0x10,%esp
  8015f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f8:	eb da                	jmp    8015d4 <write+0x55>
		return -E_NOT_SUPP;
  8015fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ff:	eb d3                	jmp    8015d4 <write+0x55>

00801601 <seek>:

int
seek(int fdnum, off_t offset)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801607:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80160a:	50                   	push   %eax
  80160b:	ff 75 08             	pushl  0x8(%ebp)
  80160e:	e8 2d fc ff ff       	call   801240 <fd_lookup>
  801613:	83 c4 08             	add    $0x8,%esp
  801616:	85 c0                	test   %eax,%eax
  801618:	78 0e                	js     801628 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80161a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801620:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801623:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	53                   	push   %ebx
  80162e:	83 ec 14             	sub    $0x14,%esp
  801631:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801634:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801637:	50                   	push   %eax
  801638:	53                   	push   %ebx
  801639:	e8 02 fc ff ff       	call   801240 <fd_lookup>
  80163e:	83 c4 08             	add    $0x8,%esp
  801641:	85 c0                	test   %eax,%eax
  801643:	78 37                	js     80167c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801645:	83 ec 08             	sub    $0x8,%esp
  801648:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164b:	50                   	push   %eax
  80164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164f:	ff 30                	pushl  (%eax)
  801651:	e8 40 fc ff ff       	call   801296 <dev_lookup>
  801656:	83 c4 10             	add    $0x10,%esp
  801659:	85 c0                	test   %eax,%eax
  80165b:	78 1f                	js     80167c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80165d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801660:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801664:	74 1b                	je     801681 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801666:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801669:	8b 52 18             	mov    0x18(%edx),%edx
  80166c:	85 d2                	test   %edx,%edx
  80166e:	74 32                	je     8016a2 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	ff 75 0c             	pushl  0xc(%ebp)
  801676:	50                   	push   %eax
  801677:	ff d2                	call   *%edx
  801679:	83 c4 10             	add    $0x10,%esp
}
  80167c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167f:	c9                   	leave  
  801680:	c3                   	ret    
			thisenv->env_id, fdnum);
  801681:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801686:	8b 40 48             	mov    0x48(%eax),%eax
  801689:	83 ec 04             	sub    $0x4,%esp
  80168c:	53                   	push   %ebx
  80168d:	50                   	push   %eax
  80168e:	68 b0 27 80 00       	push   $0x8027b0
  801693:	e8 6d ec ff ff       	call   800305 <cprintf>
		return -E_INVAL;
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a0:	eb da                	jmp    80167c <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a7:	eb d3                	jmp    80167c <ftruncate+0x52>

008016a9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	53                   	push   %ebx
  8016ad:	83 ec 14             	sub    $0x14,%esp
  8016b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b6:	50                   	push   %eax
  8016b7:	ff 75 08             	pushl  0x8(%ebp)
  8016ba:	e8 81 fb ff ff       	call   801240 <fd_lookup>
  8016bf:	83 c4 08             	add    $0x8,%esp
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	78 4b                	js     801711 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c6:	83 ec 08             	sub    $0x8,%esp
  8016c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016cc:	50                   	push   %eax
  8016cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d0:	ff 30                	pushl  (%eax)
  8016d2:	e8 bf fb ff ff       	call   801296 <dev_lookup>
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	85 c0                	test   %eax,%eax
  8016dc:	78 33                	js     801711 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016e5:	74 2f                	je     801716 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016e7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ea:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016f1:	00 00 00 
	stat->st_isdir = 0;
  8016f4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016fb:	00 00 00 
	stat->st_dev = dev;
  8016fe:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801704:	83 ec 08             	sub    $0x8,%esp
  801707:	53                   	push   %ebx
  801708:	ff 75 f0             	pushl  -0x10(%ebp)
  80170b:	ff 50 14             	call   *0x14(%eax)
  80170e:	83 c4 10             	add    $0x10,%esp
}
  801711:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801714:	c9                   	leave  
  801715:	c3                   	ret    
		return -E_NOT_SUPP;
  801716:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80171b:	eb f4                	jmp    801711 <fstat+0x68>

0080171d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	56                   	push   %esi
  801721:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801722:	83 ec 08             	sub    $0x8,%esp
  801725:	6a 00                	push   $0x0
  801727:	ff 75 08             	pushl  0x8(%ebp)
  80172a:	e8 30 02 00 00       	call   80195f <open>
  80172f:	89 c3                	mov    %eax,%ebx
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	78 1b                	js     801753 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801738:	83 ec 08             	sub    $0x8,%esp
  80173b:	ff 75 0c             	pushl  0xc(%ebp)
  80173e:	50                   	push   %eax
  80173f:	e8 65 ff ff ff       	call   8016a9 <fstat>
  801744:	89 c6                	mov    %eax,%esi
	close(fd);
  801746:	89 1c 24             	mov    %ebx,(%esp)
  801749:	e8 27 fc ff ff       	call   801375 <close>
	return r;
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	89 f3                	mov    %esi,%ebx
}
  801753:	89 d8                	mov    %ebx,%eax
  801755:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801758:	5b                   	pop    %ebx
  801759:	5e                   	pop    %esi
  80175a:	5d                   	pop    %ebp
  80175b:	c3                   	ret    

0080175c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	56                   	push   %esi
  801760:	53                   	push   %ebx
  801761:	89 c6                	mov    %eax,%esi
  801763:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801765:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80176c:	74 27                	je     801795 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80176e:	6a 07                	push   $0x7
  801770:	68 00 50 80 00       	push   $0x805000
  801775:	56                   	push   %esi
  801776:	ff 35 00 40 80 00    	pushl  0x804000
  80177c:	e8 33 08 00 00       	call   801fb4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801781:	83 c4 0c             	add    $0xc,%esp
  801784:	6a 00                	push   $0x0
  801786:	53                   	push   %ebx
  801787:	6a 00                	push   $0x0
  801789:	e8 bd 07 00 00       	call   801f4b <ipc_recv>
}
  80178e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801791:	5b                   	pop    %ebx
  801792:	5e                   	pop    %esi
  801793:	5d                   	pop    %ebp
  801794:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801795:	83 ec 0c             	sub    $0xc,%esp
  801798:	6a 01                	push   $0x1
  80179a:	e8 69 08 00 00       	call   802008 <ipc_find_env>
  80179f:	a3 00 40 80 00       	mov    %eax,0x804000
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	eb c5                	jmp    80176e <fsipc+0x12>

008017a9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c7:	b8 02 00 00 00       	mov    $0x2,%eax
  8017cc:	e8 8b ff ff ff       	call   80175c <fsipc>
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <devfile_flush>:
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017df:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e9:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ee:	e8 69 ff ff ff       	call   80175c <fsipc>
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <devfile_stat>:
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	8b 40 0c             	mov    0xc(%eax),%eax
  801805:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80180a:	ba 00 00 00 00       	mov    $0x0,%edx
  80180f:	b8 05 00 00 00       	mov    $0x5,%eax
  801814:	e8 43 ff ff ff       	call   80175c <fsipc>
  801819:	85 c0                	test   %eax,%eax
  80181b:	78 2c                	js     801849 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80181d:	83 ec 08             	sub    $0x8,%esp
  801820:	68 00 50 80 00       	push   $0x805000
  801825:	53                   	push   %ebx
  801826:	e8 f9 f0 ff ff       	call   800924 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80182b:	a1 80 50 80 00       	mov    0x805080,%eax
  801830:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801836:	a1 84 50 80 00       	mov    0x805084,%eax
  80183b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801841:	83 c4 10             	add    $0x10,%esp
  801844:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801849:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <devfile_write>:
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	53                   	push   %ebx
  801852:	83 ec 08             	sub    $0x8,%esp
  801855:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  801858:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80185e:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801863:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	8b 40 0c             	mov    0xc(%eax),%eax
  80186c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801871:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801877:	53                   	push   %ebx
  801878:	ff 75 0c             	pushl  0xc(%ebp)
  80187b:	68 08 50 80 00       	push   $0x805008
  801880:	e8 2d f2 ff ff       	call   800ab2 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801885:	ba 00 00 00 00       	mov    $0x0,%edx
  80188a:	b8 04 00 00 00       	mov    $0x4,%eax
  80188f:	e8 c8 fe ff ff       	call   80175c <fsipc>
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	85 c0                	test   %eax,%eax
  801899:	78 0b                	js     8018a6 <devfile_write+0x58>
	assert(r <= n);
  80189b:	39 d8                	cmp    %ebx,%eax
  80189d:	77 0c                	ja     8018ab <devfile_write+0x5d>
	assert(r <= PGSIZE);
  80189f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018a4:	7f 1e                	jg     8018c4 <devfile_write+0x76>
}
  8018a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    
	assert(r <= n);
  8018ab:	68 1c 28 80 00       	push   $0x80281c
  8018b0:	68 23 28 80 00       	push   $0x802823
  8018b5:	68 98 00 00 00       	push   $0x98
  8018ba:	68 38 28 80 00       	push   $0x802838
  8018bf:	e8 66 e9 ff ff       	call   80022a <_panic>
	assert(r <= PGSIZE);
  8018c4:	68 43 28 80 00       	push   $0x802843
  8018c9:	68 23 28 80 00       	push   $0x802823
  8018ce:	68 99 00 00 00       	push   $0x99
  8018d3:	68 38 28 80 00       	push   $0x802838
  8018d8:	e8 4d e9 ff ff       	call   80022a <_panic>

008018dd <devfile_read>:
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	56                   	push   %esi
  8018e1:	53                   	push   %ebx
  8018e2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8018eb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018f0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fb:	b8 03 00 00 00       	mov    $0x3,%eax
  801900:	e8 57 fe ff ff       	call   80175c <fsipc>
  801905:	89 c3                	mov    %eax,%ebx
  801907:	85 c0                	test   %eax,%eax
  801909:	78 1f                	js     80192a <devfile_read+0x4d>
	assert(r <= n);
  80190b:	39 f0                	cmp    %esi,%eax
  80190d:	77 24                	ja     801933 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80190f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801914:	7f 33                	jg     801949 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801916:	83 ec 04             	sub    $0x4,%esp
  801919:	50                   	push   %eax
  80191a:	68 00 50 80 00       	push   $0x805000
  80191f:	ff 75 0c             	pushl  0xc(%ebp)
  801922:	e8 8b f1 ff ff       	call   800ab2 <memmove>
	return r;
  801927:	83 c4 10             	add    $0x10,%esp
}
  80192a:	89 d8                	mov    %ebx,%eax
  80192c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    
	assert(r <= n);
  801933:	68 1c 28 80 00       	push   $0x80281c
  801938:	68 23 28 80 00       	push   $0x802823
  80193d:	6a 7c                	push   $0x7c
  80193f:	68 38 28 80 00       	push   $0x802838
  801944:	e8 e1 e8 ff ff       	call   80022a <_panic>
	assert(r <= PGSIZE);
  801949:	68 43 28 80 00       	push   $0x802843
  80194e:	68 23 28 80 00       	push   $0x802823
  801953:	6a 7d                	push   $0x7d
  801955:	68 38 28 80 00       	push   $0x802838
  80195a:	e8 cb e8 ff ff       	call   80022a <_panic>

0080195f <open>:
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	56                   	push   %esi
  801963:	53                   	push   %ebx
  801964:	83 ec 1c             	sub    $0x1c,%esp
  801967:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80196a:	56                   	push   %esi
  80196b:	e8 7d ef ff ff       	call   8008ed <strlen>
  801970:	83 c4 10             	add    $0x10,%esp
  801973:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801978:	7f 6c                	jg     8019e6 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80197a:	83 ec 0c             	sub    $0xc,%esp
  80197d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801980:	50                   	push   %eax
  801981:	e8 6b f8 ff ff       	call   8011f1 <fd_alloc>
  801986:	89 c3                	mov    %eax,%ebx
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	85 c0                	test   %eax,%eax
  80198d:	78 3c                	js     8019cb <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80198f:	83 ec 08             	sub    $0x8,%esp
  801992:	56                   	push   %esi
  801993:	68 00 50 80 00       	push   $0x805000
  801998:	e8 87 ef ff ff       	call   800924 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80199d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a8:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ad:	e8 aa fd ff ff       	call   80175c <fsipc>
  8019b2:	89 c3                	mov    %eax,%ebx
  8019b4:	83 c4 10             	add    $0x10,%esp
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	78 19                	js     8019d4 <open+0x75>
	return fd2num(fd);
  8019bb:	83 ec 0c             	sub    $0xc,%esp
  8019be:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c1:	e8 04 f8 ff ff       	call   8011ca <fd2num>
  8019c6:	89 c3                	mov    %eax,%ebx
  8019c8:	83 c4 10             	add    $0x10,%esp
}
  8019cb:	89 d8                	mov    %ebx,%eax
  8019cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d0:	5b                   	pop    %ebx
  8019d1:	5e                   	pop    %esi
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    
		fd_close(fd, 0);
  8019d4:	83 ec 08             	sub    $0x8,%esp
  8019d7:	6a 00                	push   $0x0
  8019d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019dc:	e8 0b f9 ff ff       	call   8012ec <fd_close>
		return r;
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	eb e5                	jmp    8019cb <open+0x6c>
		return -E_BAD_PATH;
  8019e6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019eb:	eb de                	jmp    8019cb <open+0x6c>

008019ed <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f8:	b8 08 00 00 00       	mov    $0x8,%eax
  8019fd:	e8 5a fd ff ff       	call   80175c <fsipc>
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	56                   	push   %esi
  801a08:	53                   	push   %ebx
  801a09:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a0c:	83 ec 0c             	sub    $0xc,%esp
  801a0f:	ff 75 08             	pushl  0x8(%ebp)
  801a12:	e8 c3 f7 ff ff       	call   8011da <fd2data>
  801a17:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a19:	83 c4 08             	add    $0x8,%esp
  801a1c:	68 4f 28 80 00       	push   $0x80284f
  801a21:	53                   	push   %ebx
  801a22:	e8 fd ee ff ff       	call   800924 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a27:	8b 46 04             	mov    0x4(%esi),%eax
  801a2a:	2b 06                	sub    (%esi),%eax
  801a2c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a32:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a39:	00 00 00 
	stat->st_dev = &devpipe;
  801a3c:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a43:	30 80 00 
	return 0;
}
  801a46:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4e:	5b                   	pop    %ebx
  801a4f:	5e                   	pop    %esi
  801a50:	5d                   	pop    %ebp
  801a51:	c3                   	ret    

00801a52 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	53                   	push   %ebx
  801a56:	83 ec 0c             	sub    $0xc,%esp
  801a59:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a5c:	53                   	push   %ebx
  801a5d:	6a 00                	push   $0x0
  801a5f:	e8 3e f3 ff ff       	call   800da2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a64:	89 1c 24             	mov    %ebx,(%esp)
  801a67:	e8 6e f7 ff ff       	call   8011da <fd2data>
  801a6c:	83 c4 08             	add    $0x8,%esp
  801a6f:	50                   	push   %eax
  801a70:	6a 00                	push   $0x0
  801a72:	e8 2b f3 ff ff       	call   800da2 <sys_page_unmap>
}
  801a77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <_pipeisclosed>:
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	57                   	push   %edi
  801a80:	56                   	push   %esi
  801a81:	53                   	push   %ebx
  801a82:	83 ec 1c             	sub    $0x1c,%esp
  801a85:	89 c7                	mov    %eax,%edi
  801a87:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a89:	a1 04 40 80 00       	mov    0x804004,%eax
  801a8e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a91:	83 ec 0c             	sub    $0xc,%esp
  801a94:	57                   	push   %edi
  801a95:	e8 a7 05 00 00       	call   802041 <pageref>
  801a9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a9d:	89 34 24             	mov    %esi,(%esp)
  801aa0:	e8 9c 05 00 00       	call   802041 <pageref>
		nn = thisenv->env_runs;
  801aa5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801aab:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	39 cb                	cmp    %ecx,%ebx
  801ab3:	74 1b                	je     801ad0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ab5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ab8:	75 cf                	jne    801a89 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801aba:	8b 42 58             	mov    0x58(%edx),%eax
  801abd:	6a 01                	push   $0x1
  801abf:	50                   	push   %eax
  801ac0:	53                   	push   %ebx
  801ac1:	68 56 28 80 00       	push   $0x802856
  801ac6:	e8 3a e8 ff ff       	call   800305 <cprintf>
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	eb b9                	jmp    801a89 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ad0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ad3:	0f 94 c0             	sete   %al
  801ad6:	0f b6 c0             	movzbl %al,%eax
}
  801ad9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801adc:	5b                   	pop    %ebx
  801add:	5e                   	pop    %esi
  801ade:	5f                   	pop    %edi
  801adf:	5d                   	pop    %ebp
  801ae0:	c3                   	ret    

00801ae1 <devpipe_write>:
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	57                   	push   %edi
  801ae5:	56                   	push   %esi
  801ae6:	53                   	push   %ebx
  801ae7:	83 ec 28             	sub    $0x28,%esp
  801aea:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801aed:	56                   	push   %esi
  801aee:	e8 e7 f6 ff ff       	call   8011da <fd2data>
  801af3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801af5:	83 c4 10             	add    $0x10,%esp
  801af8:	bf 00 00 00 00       	mov    $0x0,%edi
  801afd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b00:	74 4f                	je     801b51 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b02:	8b 43 04             	mov    0x4(%ebx),%eax
  801b05:	8b 0b                	mov    (%ebx),%ecx
  801b07:	8d 51 20             	lea    0x20(%ecx),%edx
  801b0a:	39 d0                	cmp    %edx,%eax
  801b0c:	72 14                	jb     801b22 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b0e:	89 da                	mov    %ebx,%edx
  801b10:	89 f0                	mov    %esi,%eax
  801b12:	e8 65 ff ff ff       	call   801a7c <_pipeisclosed>
  801b17:	85 c0                	test   %eax,%eax
  801b19:	75 3a                	jne    801b55 <devpipe_write+0x74>
			sys_yield();
  801b1b:	e8 de f1 ff ff       	call   800cfe <sys_yield>
  801b20:	eb e0                	jmp    801b02 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b25:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b29:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b2c:	89 c2                	mov    %eax,%edx
  801b2e:	c1 fa 1f             	sar    $0x1f,%edx
  801b31:	89 d1                	mov    %edx,%ecx
  801b33:	c1 e9 1b             	shr    $0x1b,%ecx
  801b36:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b39:	83 e2 1f             	and    $0x1f,%edx
  801b3c:	29 ca                	sub    %ecx,%edx
  801b3e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b42:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b46:	83 c0 01             	add    $0x1,%eax
  801b49:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b4c:	83 c7 01             	add    $0x1,%edi
  801b4f:	eb ac                	jmp    801afd <devpipe_write+0x1c>
	return i;
  801b51:	89 f8                	mov    %edi,%eax
  801b53:	eb 05                	jmp    801b5a <devpipe_write+0x79>
				return 0;
  801b55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b5d:	5b                   	pop    %ebx
  801b5e:	5e                   	pop    %esi
  801b5f:	5f                   	pop    %edi
  801b60:	5d                   	pop    %ebp
  801b61:	c3                   	ret    

00801b62 <devpipe_read>:
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	57                   	push   %edi
  801b66:	56                   	push   %esi
  801b67:	53                   	push   %ebx
  801b68:	83 ec 18             	sub    $0x18,%esp
  801b6b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b6e:	57                   	push   %edi
  801b6f:	e8 66 f6 ff ff       	call   8011da <fd2data>
  801b74:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b76:	83 c4 10             	add    $0x10,%esp
  801b79:	be 00 00 00 00       	mov    $0x0,%esi
  801b7e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b81:	74 47                	je     801bca <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801b83:	8b 03                	mov    (%ebx),%eax
  801b85:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b88:	75 22                	jne    801bac <devpipe_read+0x4a>
			if (i > 0)
  801b8a:	85 f6                	test   %esi,%esi
  801b8c:	75 14                	jne    801ba2 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801b8e:	89 da                	mov    %ebx,%edx
  801b90:	89 f8                	mov    %edi,%eax
  801b92:	e8 e5 fe ff ff       	call   801a7c <_pipeisclosed>
  801b97:	85 c0                	test   %eax,%eax
  801b99:	75 33                	jne    801bce <devpipe_read+0x6c>
			sys_yield();
  801b9b:	e8 5e f1 ff ff       	call   800cfe <sys_yield>
  801ba0:	eb e1                	jmp    801b83 <devpipe_read+0x21>
				return i;
  801ba2:	89 f0                	mov    %esi,%eax
}
  801ba4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba7:	5b                   	pop    %ebx
  801ba8:	5e                   	pop    %esi
  801ba9:	5f                   	pop    %edi
  801baa:	5d                   	pop    %ebp
  801bab:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801bac:	99                   	cltd   
  801bad:	c1 ea 1b             	shr    $0x1b,%edx
  801bb0:	01 d0                	add    %edx,%eax
  801bb2:	83 e0 1f             	and    $0x1f,%eax
  801bb5:	29 d0                	sub    %edx,%eax
  801bb7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801bbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bbf:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801bc2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801bc5:	83 c6 01             	add    $0x1,%esi
  801bc8:	eb b4                	jmp    801b7e <devpipe_read+0x1c>
	return i;
  801bca:	89 f0                	mov    %esi,%eax
  801bcc:	eb d6                	jmp    801ba4 <devpipe_read+0x42>
				return 0;
  801bce:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd3:	eb cf                	jmp    801ba4 <devpipe_read+0x42>

00801bd5 <pipe>:
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	56                   	push   %esi
  801bd9:	53                   	push   %ebx
  801bda:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801bdd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be0:	50                   	push   %eax
  801be1:	e8 0b f6 ff ff       	call   8011f1 <fd_alloc>
  801be6:	89 c3                	mov    %eax,%ebx
  801be8:	83 c4 10             	add    $0x10,%esp
  801beb:	85 c0                	test   %eax,%eax
  801bed:	78 5b                	js     801c4a <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bef:	83 ec 04             	sub    $0x4,%esp
  801bf2:	68 07 04 00 00       	push   $0x407
  801bf7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfa:	6a 00                	push   $0x0
  801bfc:	e8 1c f1 ff ff       	call   800d1d <sys_page_alloc>
  801c01:	89 c3                	mov    %eax,%ebx
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 40                	js     801c4a <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801c0a:	83 ec 0c             	sub    $0xc,%esp
  801c0d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c10:	50                   	push   %eax
  801c11:	e8 db f5 ff ff       	call   8011f1 <fd_alloc>
  801c16:	89 c3                	mov    %eax,%ebx
  801c18:	83 c4 10             	add    $0x10,%esp
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	78 1b                	js     801c3a <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c1f:	83 ec 04             	sub    $0x4,%esp
  801c22:	68 07 04 00 00       	push   $0x407
  801c27:	ff 75 f0             	pushl  -0x10(%ebp)
  801c2a:	6a 00                	push   $0x0
  801c2c:	e8 ec f0 ff ff       	call   800d1d <sys_page_alloc>
  801c31:	89 c3                	mov    %eax,%ebx
  801c33:	83 c4 10             	add    $0x10,%esp
  801c36:	85 c0                	test   %eax,%eax
  801c38:	79 19                	jns    801c53 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801c3a:	83 ec 08             	sub    $0x8,%esp
  801c3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c40:	6a 00                	push   $0x0
  801c42:	e8 5b f1 ff ff       	call   800da2 <sys_page_unmap>
  801c47:	83 c4 10             	add    $0x10,%esp
}
  801c4a:	89 d8                	mov    %ebx,%eax
  801c4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c4f:	5b                   	pop    %ebx
  801c50:	5e                   	pop    %esi
  801c51:	5d                   	pop    %ebp
  801c52:	c3                   	ret    
	va = fd2data(fd0);
  801c53:	83 ec 0c             	sub    $0xc,%esp
  801c56:	ff 75 f4             	pushl  -0xc(%ebp)
  801c59:	e8 7c f5 ff ff       	call   8011da <fd2data>
  801c5e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c60:	83 c4 0c             	add    $0xc,%esp
  801c63:	68 07 04 00 00       	push   $0x407
  801c68:	50                   	push   %eax
  801c69:	6a 00                	push   $0x0
  801c6b:	e8 ad f0 ff ff       	call   800d1d <sys_page_alloc>
  801c70:	89 c3                	mov    %eax,%ebx
  801c72:	83 c4 10             	add    $0x10,%esp
  801c75:	85 c0                	test   %eax,%eax
  801c77:	0f 88 8c 00 00 00    	js     801d09 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c7d:	83 ec 0c             	sub    $0xc,%esp
  801c80:	ff 75 f0             	pushl  -0x10(%ebp)
  801c83:	e8 52 f5 ff ff       	call   8011da <fd2data>
  801c88:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c8f:	50                   	push   %eax
  801c90:	6a 00                	push   $0x0
  801c92:	56                   	push   %esi
  801c93:	6a 00                	push   $0x0
  801c95:	e8 c6 f0 ff ff       	call   800d60 <sys_page_map>
  801c9a:	89 c3                	mov    %eax,%ebx
  801c9c:	83 c4 20             	add    $0x20,%esp
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	78 58                	js     801cfb <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca6:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cac:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbb:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cc1:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ccd:	83 ec 0c             	sub    $0xc,%esp
  801cd0:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd3:	e8 f2 f4 ff ff       	call   8011ca <fd2num>
  801cd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cdb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801cdd:	83 c4 04             	add    $0x4,%esp
  801ce0:	ff 75 f0             	pushl  -0x10(%ebp)
  801ce3:	e8 e2 f4 ff ff       	call   8011ca <fd2num>
  801ce8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ceb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801cee:	83 c4 10             	add    $0x10,%esp
  801cf1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cf6:	e9 4f ff ff ff       	jmp    801c4a <pipe+0x75>
	sys_page_unmap(0, va);
  801cfb:	83 ec 08             	sub    $0x8,%esp
  801cfe:	56                   	push   %esi
  801cff:	6a 00                	push   $0x0
  801d01:	e8 9c f0 ff ff       	call   800da2 <sys_page_unmap>
  801d06:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d09:	83 ec 08             	sub    $0x8,%esp
  801d0c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d0f:	6a 00                	push   $0x0
  801d11:	e8 8c f0 ff ff       	call   800da2 <sys_page_unmap>
  801d16:	83 c4 10             	add    $0x10,%esp
  801d19:	e9 1c ff ff ff       	jmp    801c3a <pipe+0x65>

00801d1e <pipeisclosed>:
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
  801d21:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d27:	50                   	push   %eax
  801d28:	ff 75 08             	pushl  0x8(%ebp)
  801d2b:	e8 10 f5 ff ff       	call   801240 <fd_lookup>
  801d30:	83 c4 10             	add    $0x10,%esp
  801d33:	85 c0                	test   %eax,%eax
  801d35:	78 18                	js     801d4f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d37:	83 ec 0c             	sub    $0xc,%esp
  801d3a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d3d:	e8 98 f4 ff ff       	call   8011da <fd2data>
	return _pipeisclosed(fd, p);
  801d42:	89 c2                	mov    %eax,%edx
  801d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d47:	e8 30 fd ff ff       	call   801a7c <_pipeisclosed>
  801d4c:	83 c4 10             	add    $0x10,%esp
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
  801d59:	5d                   	pop    %ebp
  801d5a:	c3                   	ret    

00801d5b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d61:	68 6e 28 80 00       	push   $0x80286e
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	e8 b6 eb ff ff       	call   800924 <strcpy>
	return 0;
}
  801d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <devcons_write>:
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	57                   	push   %edi
  801d79:	56                   	push   %esi
  801d7a:	53                   	push   %ebx
  801d7b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d81:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d86:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d8c:	eb 2f                	jmp    801dbd <devcons_write+0x48>
		m = n - tot;
  801d8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d91:	29 f3                	sub    %esi,%ebx
  801d93:	83 fb 7f             	cmp    $0x7f,%ebx
  801d96:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d9b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d9e:	83 ec 04             	sub    $0x4,%esp
  801da1:	53                   	push   %ebx
  801da2:	89 f0                	mov    %esi,%eax
  801da4:	03 45 0c             	add    0xc(%ebp),%eax
  801da7:	50                   	push   %eax
  801da8:	57                   	push   %edi
  801da9:	e8 04 ed ff ff       	call   800ab2 <memmove>
		sys_cputs(buf, m);
  801dae:	83 c4 08             	add    $0x8,%esp
  801db1:	53                   	push   %ebx
  801db2:	57                   	push   %edi
  801db3:	e8 a9 ee ff ff       	call   800c61 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801db8:	01 de                	add    %ebx,%esi
  801dba:	83 c4 10             	add    $0x10,%esp
  801dbd:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dc0:	72 cc                	jb     801d8e <devcons_write+0x19>
}
  801dc2:	89 f0                	mov    %esi,%eax
  801dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5f                   	pop    %edi
  801dca:	5d                   	pop    %ebp
  801dcb:	c3                   	ret    

00801dcc <devcons_read>:
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 08             	sub    $0x8,%esp
  801dd2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801dd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ddb:	75 07                	jne    801de4 <devcons_read+0x18>
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    
		sys_yield();
  801ddf:	e8 1a ef ff ff       	call   800cfe <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801de4:	e8 96 ee ff ff       	call   800c7f <sys_cgetc>
  801de9:	85 c0                	test   %eax,%eax
  801deb:	74 f2                	je     801ddf <devcons_read+0x13>
	if (c < 0)
  801ded:	85 c0                	test   %eax,%eax
  801def:	78 ec                	js     801ddd <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801df1:	83 f8 04             	cmp    $0x4,%eax
  801df4:	74 0c                	je     801e02 <devcons_read+0x36>
	*(char*)vbuf = c;
  801df6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df9:	88 02                	mov    %al,(%edx)
	return 1;
  801dfb:	b8 01 00 00 00       	mov    $0x1,%eax
  801e00:	eb db                	jmp    801ddd <devcons_read+0x11>
		return 0;
  801e02:	b8 00 00 00 00       	mov    $0x0,%eax
  801e07:	eb d4                	jmp    801ddd <devcons_read+0x11>

00801e09 <cputchar>:
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e15:	6a 01                	push   $0x1
  801e17:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e1a:	50                   	push   %eax
  801e1b:	e8 41 ee ff ff       	call   800c61 <sys_cputs>
}
  801e20:	83 c4 10             	add    $0x10,%esp
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <getchar>:
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e2b:	6a 01                	push   $0x1
  801e2d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e30:	50                   	push   %eax
  801e31:	6a 00                	push   $0x0
  801e33:	e8 79 f6 ff ff       	call   8014b1 <read>
	if (r < 0)
  801e38:	83 c4 10             	add    $0x10,%esp
  801e3b:	85 c0                	test   %eax,%eax
  801e3d:	78 08                	js     801e47 <getchar+0x22>
	if (r < 1)
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	7e 06                	jle    801e49 <getchar+0x24>
	return c;
  801e43:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    
		return -E_EOF;
  801e49:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e4e:	eb f7                	jmp    801e47 <getchar+0x22>

00801e50 <iscons>:
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e59:	50                   	push   %eax
  801e5a:	ff 75 08             	pushl  0x8(%ebp)
  801e5d:	e8 de f3 ff ff       	call   801240 <fd_lookup>
  801e62:	83 c4 10             	add    $0x10,%esp
  801e65:	85 c0                	test   %eax,%eax
  801e67:	78 11                	js     801e7a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e72:	39 10                	cmp    %edx,(%eax)
  801e74:	0f 94 c0             	sete   %al
  801e77:	0f b6 c0             	movzbl %al,%eax
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <opencons>:
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e85:	50                   	push   %eax
  801e86:	e8 66 f3 ff ff       	call   8011f1 <fd_alloc>
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	78 3a                	js     801ecc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e92:	83 ec 04             	sub    $0x4,%esp
  801e95:	68 07 04 00 00       	push   $0x407
  801e9a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9d:	6a 00                	push   $0x0
  801e9f:	e8 79 ee ff ff       	call   800d1d <sys_page_alloc>
  801ea4:	83 c4 10             	add    $0x10,%esp
  801ea7:	85 c0                	test   %eax,%eax
  801ea9:	78 21                	js     801ecc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eae:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801eb4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ec0:	83 ec 0c             	sub    $0xc,%esp
  801ec3:	50                   	push   %eax
  801ec4:	e8 01 f3 ff ff       	call   8011ca <fd2num>
  801ec9:	83 c4 10             	add    $0x10,%esp
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801ed4:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801edb:	74 0a                	je     801ee7 <set_pgfault_handler+0x19>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801edd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee0:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    
		int r = sys_page_alloc(0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P);	//为当前进程分配异常栈
  801ee7:	83 ec 04             	sub    $0x4,%esp
  801eea:	6a 07                	push   $0x7
  801eec:	68 00 f0 bf ee       	push   $0xeebff000
  801ef1:	6a 00                	push   $0x0
  801ef3:	e8 25 ee ff ff       	call   800d1d <sys_page_alloc>
		if (r < 0) {
  801ef8:	83 c4 10             	add    $0x10,%esp
  801efb:	85 c0                	test   %eax,%eax
  801efd:	78 14                	js     801f13 <set_pgfault_handler+0x45>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
  801eff:	83 ec 08             	sub    $0x8,%esp
  801f02:	68 27 1f 80 00       	push   $0x801f27
  801f07:	6a 00                	push   $0x0
  801f09:	e8 5a ef ff ff       	call   800e68 <sys_env_set_pgfault_upcall>
  801f0e:	83 c4 10             	add    $0x10,%esp
  801f11:	eb ca                	jmp    801edd <set_pgfault_handler+0xf>
			panic("set_pgfault_handler:sys_page_alloc failed");;
  801f13:	83 ec 04             	sub    $0x4,%esp
  801f16:	68 7c 28 80 00       	push   $0x80287c
  801f1b:	6a 22                	push   $0x22
  801f1d:	68 a8 28 80 00       	push   $0x8028a8
  801f22:	e8 03 e3 ff ff       	call   80022a <_panic>

00801f27 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f27:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f28:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax				//调用页处理函数
  801f2d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801f2f:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp			//跳过utf_fault_va和utf_err
  801f32:	83 c4 08             	add    $0x8,%esp
	movl 40(%esp), %eax 	//保存中断发生时的esp到eax
  801f35:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl 32(%esp), %ecx 	//保存终端发生时的eip到ecx
  801f39:	8b 4c 24 20          	mov    0x20(%esp),%ecx
	movl %ecx, -4(%eax) 	//将中断发生时的esp值亚入到到原来的栈中
  801f3d:	89 48 fc             	mov    %ecx,-0x4(%eax)
	popal
  801f40:	61                   	popa   
	addl $4, %esp			//跳过eip
  801f41:	83 c4 04             	add    $0x4,%esp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801f44:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801f45:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	lea -4(%esp), %esp		//因为之前压入了eip的值但是没有减esp的值，所以现在需要将esp寄存器中的值减4
  801f46:	8d 64 24 fc          	lea    -0x4(%esp),%esp
  801f4a:	c3                   	ret    

00801f4b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	56                   	push   %esi
  801f4f:	53                   	push   %ebx
  801f50:	8b 75 08             	mov    0x8(%ebp),%esi
  801f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f56:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801f59:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  801f5b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801f60:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  801f63:	83 ec 0c             	sub    $0xc,%esp
  801f66:	50                   	push   %eax
  801f67:	e8 61 ef ff ff       	call   800ecd <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	85 c0                	test   %eax,%eax
  801f71:	78 2b                	js     801f9e <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  801f73:	85 f6                	test   %esi,%esi
  801f75:	74 0a                	je     801f81 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801f77:	a1 04 40 80 00       	mov    0x804004,%eax
  801f7c:	8b 40 74             	mov    0x74(%eax),%eax
  801f7f:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  801f81:	85 db                	test   %ebx,%ebx
  801f83:	74 0a                	je     801f8f <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801f85:	a1 04 40 80 00       	mov    0x804004,%eax
  801f8a:	8b 40 78             	mov    0x78(%eax),%eax
  801f8d:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801f8f:	a1 04 40 80 00       	mov    0x804004,%eax
  801f94:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f9a:	5b                   	pop    %ebx
  801f9b:	5e                   	pop    %esi
  801f9c:	5d                   	pop    %ebp
  801f9d:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  801f9e:	85 f6                	test   %esi,%esi
  801fa0:	74 06                	je     801fa8 <ipc_recv+0x5d>
  801fa2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801fa8:	85 db                	test   %ebx,%ebx
  801faa:	74 eb                	je     801f97 <ipc_recv+0x4c>
  801fac:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801fb2:	eb e3                	jmp    801f97 <ipc_recv+0x4c>

00801fb4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	57                   	push   %edi
  801fb8:	56                   	push   %esi
  801fb9:	53                   	push   %ebx
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fc0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801fc6:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  801fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801fcd:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801fd0:	ff 75 14             	pushl  0x14(%ebp)
  801fd3:	53                   	push   %ebx
  801fd4:	56                   	push   %esi
  801fd5:	57                   	push   %edi
  801fd6:	e8 cf ee ff ff       	call   800eaa <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  801fdb:	83 c4 10             	add    $0x10,%esp
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	74 1e                	je     802000 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  801fe2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801fe5:	75 07                	jne    801fee <ipc_send+0x3a>
			sys_yield();
  801fe7:	e8 12 ed ff ff       	call   800cfe <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801fec:	eb e2                	jmp    801fd0 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  801fee:	50                   	push   %eax
  801fef:	68 b6 28 80 00       	push   $0x8028b6
  801ff4:	6a 41                	push   $0x41
  801ff6:	68 c4 28 80 00       	push   $0x8028c4
  801ffb:	e8 2a e2 ff ff       	call   80022a <_panic>
		}
	}
}
  802000:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802003:	5b                   	pop    %ebx
  802004:	5e                   	pop    %esi
  802005:	5f                   	pop    %edi
  802006:	5d                   	pop    %ebp
  802007:	c3                   	ret    

00802008 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80200e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802013:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802016:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80201c:	8b 52 50             	mov    0x50(%edx),%edx
  80201f:	39 ca                	cmp    %ecx,%edx
  802021:	74 11                	je     802034 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802023:	83 c0 01             	add    $0x1,%eax
  802026:	3d 00 04 00 00       	cmp    $0x400,%eax
  80202b:	75 e6                	jne    802013 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80202d:	b8 00 00 00 00       	mov    $0x0,%eax
  802032:	eb 0b                	jmp    80203f <ipc_find_env+0x37>
			return envs[i].env_id;
  802034:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802037:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80203c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80203f:	5d                   	pop    %ebp
  802040:	c3                   	ret    

00802041 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802047:	89 d0                	mov    %edx,%eax
  802049:	c1 e8 16             	shr    $0x16,%eax
  80204c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802053:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802058:	f6 c1 01             	test   $0x1,%cl
  80205b:	74 1d                	je     80207a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80205d:	c1 ea 0c             	shr    $0xc,%edx
  802060:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802067:	f6 c2 01             	test   $0x1,%dl
  80206a:	74 0e                	je     80207a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80206c:	c1 ea 0c             	shr    $0xc,%edx
  80206f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802076:	ef 
  802077:	0f b7 c0             	movzwl %ax,%eax
}
  80207a:	5d                   	pop    %ebp
  80207b:	c3                   	ret    
  80207c:	66 90                	xchg   %ax,%ax
  80207e:	66 90                	xchg   %ax,%ax

00802080 <__udivdi3>:
  802080:	55                   	push   %ebp
  802081:	57                   	push   %edi
  802082:	56                   	push   %esi
  802083:	53                   	push   %ebx
  802084:	83 ec 1c             	sub    $0x1c,%esp
  802087:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80208b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80208f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802093:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802097:	85 d2                	test   %edx,%edx
  802099:	75 35                	jne    8020d0 <__udivdi3+0x50>
  80209b:	39 f3                	cmp    %esi,%ebx
  80209d:	0f 87 bd 00 00 00    	ja     802160 <__udivdi3+0xe0>
  8020a3:	85 db                	test   %ebx,%ebx
  8020a5:	89 d9                	mov    %ebx,%ecx
  8020a7:	75 0b                	jne    8020b4 <__udivdi3+0x34>
  8020a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ae:	31 d2                	xor    %edx,%edx
  8020b0:	f7 f3                	div    %ebx
  8020b2:	89 c1                	mov    %eax,%ecx
  8020b4:	31 d2                	xor    %edx,%edx
  8020b6:	89 f0                	mov    %esi,%eax
  8020b8:	f7 f1                	div    %ecx
  8020ba:	89 c6                	mov    %eax,%esi
  8020bc:	89 e8                	mov    %ebp,%eax
  8020be:	89 f7                	mov    %esi,%edi
  8020c0:	f7 f1                	div    %ecx
  8020c2:	89 fa                	mov    %edi,%edx
  8020c4:	83 c4 1c             	add    $0x1c,%esp
  8020c7:	5b                   	pop    %ebx
  8020c8:	5e                   	pop    %esi
  8020c9:	5f                   	pop    %edi
  8020ca:	5d                   	pop    %ebp
  8020cb:	c3                   	ret    
  8020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020d0:	39 f2                	cmp    %esi,%edx
  8020d2:	77 7c                	ja     802150 <__udivdi3+0xd0>
  8020d4:	0f bd fa             	bsr    %edx,%edi
  8020d7:	83 f7 1f             	xor    $0x1f,%edi
  8020da:	0f 84 98 00 00 00    	je     802178 <__udivdi3+0xf8>
  8020e0:	89 f9                	mov    %edi,%ecx
  8020e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020e7:	29 f8                	sub    %edi,%eax
  8020e9:	d3 e2                	shl    %cl,%edx
  8020eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020ef:	89 c1                	mov    %eax,%ecx
  8020f1:	89 da                	mov    %ebx,%edx
  8020f3:	d3 ea                	shr    %cl,%edx
  8020f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020f9:	09 d1                	or     %edx,%ecx
  8020fb:	89 f2                	mov    %esi,%edx
  8020fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802101:	89 f9                	mov    %edi,%ecx
  802103:	d3 e3                	shl    %cl,%ebx
  802105:	89 c1                	mov    %eax,%ecx
  802107:	d3 ea                	shr    %cl,%edx
  802109:	89 f9                	mov    %edi,%ecx
  80210b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80210f:	d3 e6                	shl    %cl,%esi
  802111:	89 eb                	mov    %ebp,%ebx
  802113:	89 c1                	mov    %eax,%ecx
  802115:	d3 eb                	shr    %cl,%ebx
  802117:	09 de                	or     %ebx,%esi
  802119:	89 f0                	mov    %esi,%eax
  80211b:	f7 74 24 08          	divl   0x8(%esp)
  80211f:	89 d6                	mov    %edx,%esi
  802121:	89 c3                	mov    %eax,%ebx
  802123:	f7 64 24 0c          	mull   0xc(%esp)
  802127:	39 d6                	cmp    %edx,%esi
  802129:	72 0c                	jb     802137 <__udivdi3+0xb7>
  80212b:	89 f9                	mov    %edi,%ecx
  80212d:	d3 e5                	shl    %cl,%ebp
  80212f:	39 c5                	cmp    %eax,%ebp
  802131:	73 5d                	jae    802190 <__udivdi3+0x110>
  802133:	39 d6                	cmp    %edx,%esi
  802135:	75 59                	jne    802190 <__udivdi3+0x110>
  802137:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80213a:	31 ff                	xor    %edi,%edi
  80213c:	89 fa                	mov    %edi,%edx
  80213e:	83 c4 1c             	add    $0x1c,%esp
  802141:	5b                   	pop    %ebx
  802142:	5e                   	pop    %esi
  802143:	5f                   	pop    %edi
  802144:	5d                   	pop    %ebp
  802145:	c3                   	ret    
  802146:	8d 76 00             	lea    0x0(%esi),%esi
  802149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802150:	31 ff                	xor    %edi,%edi
  802152:	31 c0                	xor    %eax,%eax
  802154:	89 fa                	mov    %edi,%edx
  802156:	83 c4 1c             	add    $0x1c,%esp
  802159:	5b                   	pop    %ebx
  80215a:	5e                   	pop    %esi
  80215b:	5f                   	pop    %edi
  80215c:	5d                   	pop    %ebp
  80215d:	c3                   	ret    
  80215e:	66 90                	xchg   %ax,%ax
  802160:	31 ff                	xor    %edi,%edi
  802162:	89 e8                	mov    %ebp,%eax
  802164:	89 f2                	mov    %esi,%edx
  802166:	f7 f3                	div    %ebx
  802168:	89 fa                	mov    %edi,%edx
  80216a:	83 c4 1c             	add    $0x1c,%esp
  80216d:	5b                   	pop    %ebx
  80216e:	5e                   	pop    %esi
  80216f:	5f                   	pop    %edi
  802170:	5d                   	pop    %ebp
  802171:	c3                   	ret    
  802172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802178:	39 f2                	cmp    %esi,%edx
  80217a:	72 06                	jb     802182 <__udivdi3+0x102>
  80217c:	31 c0                	xor    %eax,%eax
  80217e:	39 eb                	cmp    %ebp,%ebx
  802180:	77 d2                	ja     802154 <__udivdi3+0xd4>
  802182:	b8 01 00 00 00       	mov    $0x1,%eax
  802187:	eb cb                	jmp    802154 <__udivdi3+0xd4>
  802189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802190:	89 d8                	mov    %ebx,%eax
  802192:	31 ff                	xor    %edi,%edi
  802194:	eb be                	jmp    802154 <__udivdi3+0xd4>
  802196:	66 90                	xchg   %ax,%ax
  802198:	66 90                	xchg   %ax,%ax
  80219a:	66 90                	xchg   %ax,%ax
  80219c:	66 90                	xchg   %ax,%ax
  80219e:	66 90                	xchg   %ax,%ax

008021a0 <__umoddi3>:
  8021a0:	55                   	push   %ebp
  8021a1:	57                   	push   %edi
  8021a2:	56                   	push   %esi
  8021a3:	53                   	push   %ebx
  8021a4:	83 ec 1c             	sub    $0x1c,%esp
  8021a7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8021ab:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021af:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021b7:	85 ed                	test   %ebp,%ebp
  8021b9:	89 f0                	mov    %esi,%eax
  8021bb:	89 da                	mov    %ebx,%edx
  8021bd:	75 19                	jne    8021d8 <__umoddi3+0x38>
  8021bf:	39 df                	cmp    %ebx,%edi
  8021c1:	0f 86 b1 00 00 00    	jbe    802278 <__umoddi3+0xd8>
  8021c7:	f7 f7                	div    %edi
  8021c9:	89 d0                	mov    %edx,%eax
  8021cb:	31 d2                	xor    %edx,%edx
  8021cd:	83 c4 1c             	add    $0x1c,%esp
  8021d0:	5b                   	pop    %ebx
  8021d1:	5e                   	pop    %esi
  8021d2:	5f                   	pop    %edi
  8021d3:	5d                   	pop    %ebp
  8021d4:	c3                   	ret    
  8021d5:	8d 76 00             	lea    0x0(%esi),%esi
  8021d8:	39 dd                	cmp    %ebx,%ebp
  8021da:	77 f1                	ja     8021cd <__umoddi3+0x2d>
  8021dc:	0f bd cd             	bsr    %ebp,%ecx
  8021df:	83 f1 1f             	xor    $0x1f,%ecx
  8021e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021e6:	0f 84 b4 00 00 00    	je     8022a0 <__umoddi3+0x100>
  8021ec:	b8 20 00 00 00       	mov    $0x20,%eax
  8021f1:	89 c2                	mov    %eax,%edx
  8021f3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021f7:	29 c2                	sub    %eax,%edx
  8021f9:	89 c1                	mov    %eax,%ecx
  8021fb:	89 f8                	mov    %edi,%eax
  8021fd:	d3 e5                	shl    %cl,%ebp
  8021ff:	89 d1                	mov    %edx,%ecx
  802201:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802205:	d3 e8                	shr    %cl,%eax
  802207:	09 c5                	or     %eax,%ebp
  802209:	8b 44 24 04          	mov    0x4(%esp),%eax
  80220d:	89 c1                	mov    %eax,%ecx
  80220f:	d3 e7                	shl    %cl,%edi
  802211:	89 d1                	mov    %edx,%ecx
  802213:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802217:	89 df                	mov    %ebx,%edi
  802219:	d3 ef                	shr    %cl,%edi
  80221b:	89 c1                	mov    %eax,%ecx
  80221d:	89 f0                	mov    %esi,%eax
  80221f:	d3 e3                	shl    %cl,%ebx
  802221:	89 d1                	mov    %edx,%ecx
  802223:	89 fa                	mov    %edi,%edx
  802225:	d3 e8                	shr    %cl,%eax
  802227:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80222c:	09 d8                	or     %ebx,%eax
  80222e:	f7 f5                	div    %ebp
  802230:	d3 e6                	shl    %cl,%esi
  802232:	89 d1                	mov    %edx,%ecx
  802234:	f7 64 24 08          	mull   0x8(%esp)
  802238:	39 d1                	cmp    %edx,%ecx
  80223a:	89 c3                	mov    %eax,%ebx
  80223c:	89 d7                	mov    %edx,%edi
  80223e:	72 06                	jb     802246 <__umoddi3+0xa6>
  802240:	75 0e                	jne    802250 <__umoddi3+0xb0>
  802242:	39 c6                	cmp    %eax,%esi
  802244:	73 0a                	jae    802250 <__umoddi3+0xb0>
  802246:	2b 44 24 08          	sub    0x8(%esp),%eax
  80224a:	19 ea                	sbb    %ebp,%edx
  80224c:	89 d7                	mov    %edx,%edi
  80224e:	89 c3                	mov    %eax,%ebx
  802250:	89 ca                	mov    %ecx,%edx
  802252:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802257:	29 de                	sub    %ebx,%esi
  802259:	19 fa                	sbb    %edi,%edx
  80225b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80225f:	89 d0                	mov    %edx,%eax
  802261:	d3 e0                	shl    %cl,%eax
  802263:	89 d9                	mov    %ebx,%ecx
  802265:	d3 ee                	shr    %cl,%esi
  802267:	d3 ea                	shr    %cl,%edx
  802269:	09 f0                	or     %esi,%eax
  80226b:	83 c4 1c             	add    $0x1c,%esp
  80226e:	5b                   	pop    %ebx
  80226f:	5e                   	pop    %esi
  802270:	5f                   	pop    %edi
  802271:	5d                   	pop    %ebp
  802272:	c3                   	ret    
  802273:	90                   	nop
  802274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802278:	85 ff                	test   %edi,%edi
  80227a:	89 f9                	mov    %edi,%ecx
  80227c:	75 0b                	jne    802289 <__umoddi3+0xe9>
  80227e:	b8 01 00 00 00       	mov    $0x1,%eax
  802283:	31 d2                	xor    %edx,%edx
  802285:	f7 f7                	div    %edi
  802287:	89 c1                	mov    %eax,%ecx
  802289:	89 d8                	mov    %ebx,%eax
  80228b:	31 d2                	xor    %edx,%edx
  80228d:	f7 f1                	div    %ecx
  80228f:	89 f0                	mov    %esi,%eax
  802291:	f7 f1                	div    %ecx
  802293:	e9 31 ff ff ff       	jmp    8021c9 <__umoddi3+0x29>
  802298:	90                   	nop
  802299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022a0:	39 dd                	cmp    %ebx,%ebp
  8022a2:	72 08                	jb     8022ac <__umoddi3+0x10c>
  8022a4:	39 f7                	cmp    %esi,%edi
  8022a6:	0f 87 21 ff ff ff    	ja     8021cd <__umoddi3+0x2d>
  8022ac:	89 da                	mov    %ebx,%edx
  8022ae:	89 f0                	mov    %esi,%eax
  8022b0:	29 f8                	sub    %edi,%eax
  8022b2:	19 ea                	sbb    %ebp,%edx
  8022b4:	e9 14 ff ff ff       	jmp    8021cd <__umoddi3+0x2d>
