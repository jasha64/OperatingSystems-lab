
obj/user/icode.debug：     文件格式 elf32-i386


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
  80002c:	e8 03 01 00 00       	call   800134 <libmain>
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
  800038:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 30 80 00 60 	movl   $0x802460,0x803000
  800045:	24 80 00 

	cprintf("icode startup\n");
  800048:	68 66 24 80 00       	push   $0x802466
  80004d:	e8 15 02 00 00       	call   800267 <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 75 24 80 00 	movl   $0x802475,(%esp)
  800059:	e8 09 02 00 00       	call   800267 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 88 24 80 00       	push   $0x802488
  800068:	e8 98 15 00 00       	call   801605 <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 18                	js     80008e <umain+0x5b>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 b1 24 80 00       	push   $0x8024b1
  80007e:	e8 e4 01 00 00       	call   800267 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	eb 1f                	jmp    8000ad <umain+0x7a>
		panic("icode: open /motd: %e", fd);
  80008e:	50                   	push   %eax
  80008f:	68 8e 24 80 00       	push   $0x80248e
  800094:	6a 0f                	push   $0xf
  800096:	68 a4 24 80 00       	push   $0x8024a4
  80009b:	e8 ec 00 00 00       	call   80018c <_panic>
		sys_cputs(buf, n);
  8000a0:	83 ec 08             	sub    $0x8,%esp
  8000a3:	50                   	push   %eax
  8000a4:	53                   	push   %ebx
  8000a5:	e8 19 0b 00 00       	call   800bc3 <sys_cputs>
  8000aa:	83 c4 10             	add    $0x10,%esp
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	68 00 02 00 00       	push   $0x200
  8000b5:	53                   	push   %ebx
  8000b6:	56                   	push   %esi
  8000b7:	e8 9b 10 00 00       	call   801157 <read>
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	7f dd                	jg     8000a0 <umain+0x6d>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 c4 24 80 00       	push   $0x8024c4
  8000cb:	e8 97 01 00 00       	call   800267 <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 43 0f 00 00       	call   80101b <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 d8 24 80 00 	movl   $0x8024d8,(%esp)
  8000df:	e8 83 01 00 00       	call   800267 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 ec 24 80 00       	push   $0x8024ec
  8000f0:	68 f5 24 80 00       	push   $0x8024f5
  8000f5:	68 ff 24 80 00       	push   $0x8024ff
  8000fa:	68 fe 24 80 00       	push   $0x8024fe
  8000ff:	e8 97 1a 00 00       	call   801b9b <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 1b 25 80 00       	push   $0x80251b
  800113:	e8 4f 01 00 00       	call   800267 <cprintf>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800122:	50                   	push   %eax
  800123:	68 04 25 80 00       	push   $0x802504
  800128:	6a 1a                	push   $0x1a
  80012a:	68 a4 24 80 00       	push   $0x8024a4
  80012f:	e8 58 00 00 00       	call   80018c <_panic>

00800134 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  80013f:	e8 fd 0a 00 00       	call   800c41 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  800144:	25 ff 03 00 00       	and    $0x3ff,%eax
  800149:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80014c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800151:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800156:	85 db                	test   %ebx,%ebx
  800158:	7e 07                	jle    800161 <libmain+0x2d>
		binaryname = argv[0];
  80015a:	8b 06                	mov    (%esi),%eax
  80015c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	56                   	push   %esi
  800165:	53                   	push   %ebx
  800166:	e8 c8 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80016b:	e8 0a 00 00 00       	call   80017a <exit>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    

0080017a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800180:	6a 00                	push   $0x0
  800182:	e8 79 0a 00 00       	call   800c00 <sys_env_destroy>
}
  800187:	83 c4 10             	add    $0x10,%esp
  80018a:	c9                   	leave  
  80018b:	c3                   	ret    

0080018c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	56                   	push   %esi
  800190:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800191:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800194:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80019a:	e8 a2 0a 00 00       	call   800c41 <sys_getenvid>
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	ff 75 0c             	pushl  0xc(%ebp)
  8001a5:	ff 75 08             	pushl  0x8(%ebp)
  8001a8:	56                   	push   %esi
  8001a9:	50                   	push   %eax
  8001aa:	68 38 25 80 00       	push   $0x802538
  8001af:	e8 b3 00 00 00       	call   800267 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b4:	83 c4 18             	add    $0x18,%esp
  8001b7:	53                   	push   %ebx
  8001b8:	ff 75 10             	pushl  0x10(%ebp)
  8001bb:	e8 56 00 00 00       	call   800216 <vcprintf>
	cprintf("\n");
  8001c0:	c7 04 24 00 2a 80 00 	movl   $0x802a00,(%esp)
  8001c7:	e8 9b 00 00 00       	call   800267 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001cf:	cc                   	int3   
  8001d0:	eb fd                	jmp    8001cf <_panic+0x43>

008001d2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001dc:	8b 13                	mov    (%ebx),%edx
  8001de:	8d 42 01             	lea    0x1(%edx),%eax
  8001e1:	89 03                	mov    %eax,(%ebx)
  8001e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ea:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ef:	74 09                	je     8001fa <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f8:	c9                   	leave  
  8001f9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	68 ff 00 00 00       	push   $0xff
  800202:	8d 43 08             	lea    0x8(%ebx),%eax
  800205:	50                   	push   %eax
  800206:	e8 b8 09 00 00       	call   800bc3 <sys_cputs>
		b->idx = 0;
  80020b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800211:	83 c4 10             	add    $0x10,%esp
  800214:	eb db                	jmp    8001f1 <putch+0x1f>

00800216 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80021f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800226:	00 00 00 
	b.cnt = 0;
  800229:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800230:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800233:	ff 75 0c             	pushl  0xc(%ebp)
  800236:	ff 75 08             	pushl  0x8(%ebp)
  800239:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023f:	50                   	push   %eax
  800240:	68 d2 01 80 00       	push   $0x8001d2
  800245:	e8 1a 01 00 00       	call   800364 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024a:	83 c4 08             	add    $0x8,%esp
  80024d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800253:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800259:	50                   	push   %eax
  80025a:	e8 64 09 00 00       	call   800bc3 <sys_cputs>

	return b.cnt;
}
  80025f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80026d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800270:	50                   	push   %eax
  800271:	ff 75 08             	pushl  0x8(%ebp)
  800274:	e8 9d ff ff ff       	call   800216 <vcprintf>
	va_end(ap);

	return cnt;
}
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	57                   	push   %edi
  80027f:	56                   	push   %esi
  800280:	53                   	push   %ebx
  800281:	83 ec 1c             	sub    $0x1c,%esp
  800284:	89 c7                	mov    %eax,%edi
  800286:	89 d6                	mov    %edx,%esi
  800288:	8b 45 08             	mov    0x8(%ebp),%eax
  80028b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800291:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800294:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800297:	bb 00 00 00 00       	mov    $0x0,%ebx
  80029c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80029f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002a2:	39 d3                	cmp    %edx,%ebx
  8002a4:	72 05                	jb     8002ab <printnum+0x30>
  8002a6:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002a9:	77 7a                	ja     800325 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	ff 75 18             	pushl  0x18(%ebp)
  8002b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8002b4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002b7:	53                   	push   %ebx
  8002b8:	ff 75 10             	pushl  0x10(%ebp)
  8002bb:	83 ec 08             	sub    $0x8,%esp
  8002be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ca:	e8 51 1f 00 00       	call   802220 <__udivdi3>
  8002cf:	83 c4 18             	add    $0x18,%esp
  8002d2:	52                   	push   %edx
  8002d3:	50                   	push   %eax
  8002d4:	89 f2                	mov    %esi,%edx
  8002d6:	89 f8                	mov    %edi,%eax
  8002d8:	e8 9e ff ff ff       	call   80027b <printnum>
  8002dd:	83 c4 20             	add    $0x20,%esp
  8002e0:	eb 13                	jmp    8002f5 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002e2:	83 ec 08             	sub    $0x8,%esp
  8002e5:	56                   	push   %esi
  8002e6:	ff 75 18             	pushl  0x18(%ebp)
  8002e9:	ff d7                	call   *%edi
  8002eb:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002ee:	83 eb 01             	sub    $0x1,%ebx
  8002f1:	85 db                	test   %ebx,%ebx
  8002f3:	7f ed                	jg     8002e2 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002f5:	83 ec 08             	sub    $0x8,%esp
  8002f8:	56                   	push   %esi
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ff:	ff 75 e0             	pushl  -0x20(%ebp)
  800302:	ff 75 dc             	pushl  -0x24(%ebp)
  800305:	ff 75 d8             	pushl  -0x28(%ebp)
  800308:	e8 33 20 00 00       	call   802340 <__umoddi3>
  80030d:	83 c4 14             	add    $0x14,%esp
  800310:	0f be 80 5b 25 80 00 	movsbl 0x80255b(%eax),%eax
  800317:	50                   	push   %eax
  800318:	ff d7                	call   *%edi
}
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800320:	5b                   	pop    %ebx
  800321:	5e                   	pop    %esi
  800322:	5f                   	pop    %edi
  800323:	5d                   	pop    %ebp
  800324:	c3                   	ret    
  800325:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800328:	eb c4                	jmp    8002ee <printnum+0x73>

0080032a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80032a:	55                   	push   %ebp
  80032b:	89 e5                	mov    %esp,%ebp
  80032d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800330:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800334:	8b 10                	mov    (%eax),%edx
  800336:	3b 50 04             	cmp    0x4(%eax),%edx
  800339:	73 0a                	jae    800345 <sprintputch+0x1b>
		*b->buf++ = ch;
  80033b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80033e:	89 08                	mov    %ecx,(%eax)
  800340:	8b 45 08             	mov    0x8(%ebp),%eax
  800343:	88 02                	mov    %al,(%edx)
}
  800345:	5d                   	pop    %ebp
  800346:	c3                   	ret    

00800347 <printfmt>:
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80034d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800350:	50                   	push   %eax
  800351:	ff 75 10             	pushl  0x10(%ebp)
  800354:	ff 75 0c             	pushl  0xc(%ebp)
  800357:	ff 75 08             	pushl  0x8(%ebp)
  80035a:	e8 05 00 00 00       	call   800364 <vprintfmt>
}
  80035f:	83 c4 10             	add    $0x10,%esp
  800362:	c9                   	leave  
  800363:	c3                   	ret    

00800364 <vprintfmt>:
{
  800364:	55                   	push   %ebp
  800365:	89 e5                	mov    %esp,%ebp
  800367:	57                   	push   %edi
  800368:	56                   	push   %esi
  800369:	53                   	push   %ebx
  80036a:	83 ec 2c             	sub    $0x2c,%esp
  80036d:	8b 75 08             	mov    0x8(%ebp),%esi
  800370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800373:	8b 7d 10             	mov    0x10(%ebp),%edi
  800376:	e9 c1 03 00 00       	jmp    80073c <vprintfmt+0x3d8>
		padc = ' ';
  80037b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80037f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800386:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80038d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800394:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800399:	8d 47 01             	lea    0x1(%edi),%eax
  80039c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80039f:	0f b6 17             	movzbl (%edi),%edx
  8003a2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003a5:	3c 55                	cmp    $0x55,%al
  8003a7:	0f 87 12 04 00 00    	ja     8007bf <vprintfmt+0x45b>
  8003ad:	0f b6 c0             	movzbl %al,%eax
  8003b0:	ff 24 85 a0 26 80 00 	jmp    *0x8026a0(,%eax,4)
  8003b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ba:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003be:	eb d9                	jmp    800399 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003c3:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003c7:	eb d0                	jmp    800399 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003c9:	0f b6 d2             	movzbl %dl,%edx
  8003cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003d7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003da:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003de:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003e1:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003e4:	83 f9 09             	cmp    $0x9,%ecx
  8003e7:	77 55                	ja     80043e <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003e9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003ec:	eb e9                	jmp    8003d7 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f1:	8b 00                	mov    (%eax),%eax
  8003f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f9:	8d 40 04             	lea    0x4(%eax),%eax
  8003fc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800402:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800406:	79 91                	jns    800399 <vprintfmt+0x35>
				width = precision, precision = -1;
  800408:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80040b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80040e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800415:	eb 82                	jmp    800399 <vprintfmt+0x35>
  800417:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80041a:	85 c0                	test   %eax,%eax
  80041c:	ba 00 00 00 00       	mov    $0x0,%edx
  800421:	0f 49 d0             	cmovns %eax,%edx
  800424:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800427:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80042a:	e9 6a ff ff ff       	jmp    800399 <vprintfmt+0x35>
  80042f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800432:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800439:	e9 5b ff ff ff       	jmp    800399 <vprintfmt+0x35>
  80043e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800441:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800444:	eb bc                	jmp    800402 <vprintfmt+0x9e>
			lflag++;
  800446:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800449:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80044c:	e9 48 ff ff ff       	jmp    800399 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800451:	8b 45 14             	mov    0x14(%ebp),%eax
  800454:	8d 78 04             	lea    0x4(%eax),%edi
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	53                   	push   %ebx
  80045b:	ff 30                	pushl  (%eax)
  80045d:	ff d6                	call   *%esi
			break;
  80045f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800462:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800465:	e9 cf 02 00 00       	jmp    800739 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80046a:	8b 45 14             	mov    0x14(%ebp),%eax
  80046d:	8d 78 04             	lea    0x4(%eax),%edi
  800470:	8b 00                	mov    (%eax),%eax
  800472:	99                   	cltd   
  800473:	31 d0                	xor    %edx,%eax
  800475:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800477:	83 f8 0f             	cmp    $0xf,%eax
  80047a:	7f 23                	jg     80049f <vprintfmt+0x13b>
  80047c:	8b 14 85 00 28 80 00 	mov    0x802800(,%eax,4),%edx
  800483:	85 d2                	test   %edx,%edx
  800485:	74 18                	je     80049f <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800487:	52                   	push   %edx
  800488:	68 31 29 80 00       	push   $0x802931
  80048d:	53                   	push   %ebx
  80048e:	56                   	push   %esi
  80048f:	e8 b3 fe ff ff       	call   800347 <printfmt>
  800494:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800497:	89 7d 14             	mov    %edi,0x14(%ebp)
  80049a:	e9 9a 02 00 00       	jmp    800739 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80049f:	50                   	push   %eax
  8004a0:	68 73 25 80 00       	push   $0x802573
  8004a5:	53                   	push   %ebx
  8004a6:	56                   	push   %esi
  8004a7:	e8 9b fe ff ff       	call   800347 <printfmt>
  8004ac:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004af:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004b2:	e9 82 02 00 00       	jmp    800739 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ba:	83 c0 04             	add    $0x4,%eax
  8004bd:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c3:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004c5:	85 ff                	test   %edi,%edi
  8004c7:	b8 6c 25 80 00       	mov    $0x80256c,%eax
  8004cc:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d3:	0f 8e bd 00 00 00    	jle    800596 <vprintfmt+0x232>
  8004d9:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004dd:	75 0e                	jne    8004ed <vprintfmt+0x189>
  8004df:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004e5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004e8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004eb:	eb 6d                	jmp    80055a <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ed:	83 ec 08             	sub    $0x8,%esp
  8004f0:	ff 75 d0             	pushl  -0x30(%ebp)
  8004f3:	57                   	push   %edi
  8004f4:	e8 6e 03 00 00       	call   800867 <strnlen>
  8004f9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004fc:	29 c1                	sub    %eax,%ecx
  8004fe:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800501:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800504:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800508:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80050b:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80050e:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800510:	eb 0f                	jmp    800521 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800512:	83 ec 08             	sub    $0x8,%esp
  800515:	53                   	push   %ebx
  800516:	ff 75 e0             	pushl  -0x20(%ebp)
  800519:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80051b:	83 ef 01             	sub    $0x1,%edi
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	85 ff                	test   %edi,%edi
  800523:	7f ed                	jg     800512 <vprintfmt+0x1ae>
  800525:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800528:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80052b:	85 c9                	test   %ecx,%ecx
  80052d:	b8 00 00 00 00       	mov    $0x0,%eax
  800532:	0f 49 c1             	cmovns %ecx,%eax
  800535:	29 c1                	sub    %eax,%ecx
  800537:	89 75 08             	mov    %esi,0x8(%ebp)
  80053a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80053d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800540:	89 cb                	mov    %ecx,%ebx
  800542:	eb 16                	jmp    80055a <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800544:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800548:	75 31                	jne    80057b <vprintfmt+0x217>
					putch(ch, putdat);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 0c             	pushl  0xc(%ebp)
  800550:	50                   	push   %eax
  800551:	ff 55 08             	call   *0x8(%ebp)
  800554:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800557:	83 eb 01             	sub    $0x1,%ebx
  80055a:	83 c7 01             	add    $0x1,%edi
  80055d:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800561:	0f be c2             	movsbl %dl,%eax
  800564:	85 c0                	test   %eax,%eax
  800566:	74 59                	je     8005c1 <vprintfmt+0x25d>
  800568:	85 f6                	test   %esi,%esi
  80056a:	78 d8                	js     800544 <vprintfmt+0x1e0>
  80056c:	83 ee 01             	sub    $0x1,%esi
  80056f:	79 d3                	jns    800544 <vprintfmt+0x1e0>
  800571:	89 df                	mov    %ebx,%edi
  800573:	8b 75 08             	mov    0x8(%ebp),%esi
  800576:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800579:	eb 37                	jmp    8005b2 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80057b:	0f be d2             	movsbl %dl,%edx
  80057e:	83 ea 20             	sub    $0x20,%edx
  800581:	83 fa 5e             	cmp    $0x5e,%edx
  800584:	76 c4                	jbe    80054a <vprintfmt+0x1e6>
					putch('?', putdat);
  800586:	83 ec 08             	sub    $0x8,%esp
  800589:	ff 75 0c             	pushl  0xc(%ebp)
  80058c:	6a 3f                	push   $0x3f
  80058e:	ff 55 08             	call   *0x8(%ebp)
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	eb c1                	jmp    800557 <vprintfmt+0x1f3>
  800596:	89 75 08             	mov    %esi,0x8(%ebp)
  800599:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80059c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80059f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005a2:	eb b6                	jmp    80055a <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005a4:	83 ec 08             	sub    $0x8,%esp
  8005a7:	53                   	push   %ebx
  8005a8:	6a 20                	push   $0x20
  8005aa:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005ac:	83 ef 01             	sub    $0x1,%edi
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	85 ff                	test   %edi,%edi
  8005b4:	7f ee                	jg     8005a4 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8005b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bc:	e9 78 01 00 00       	jmp    800739 <vprintfmt+0x3d5>
  8005c1:	89 df                	mov    %ebx,%edi
  8005c3:	8b 75 08             	mov    0x8(%ebp),%esi
  8005c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005c9:	eb e7                	jmp    8005b2 <vprintfmt+0x24e>
	if (lflag >= 2)
  8005cb:	83 f9 01             	cmp    $0x1,%ecx
  8005ce:	7e 3f                	jle    80060f <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	8b 50 04             	mov    0x4(%eax),%edx
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8d 40 08             	lea    0x8(%eax),%eax
  8005e4:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005eb:	79 5c                	jns    800649 <vprintfmt+0x2e5>
				putch('-', putdat);
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	53                   	push   %ebx
  8005f1:	6a 2d                	push   $0x2d
  8005f3:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005f8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005fb:	f7 da                	neg    %edx
  8005fd:	83 d1 00             	adc    $0x0,%ecx
  800600:	f7 d9                	neg    %ecx
  800602:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800605:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060a:	e9 10 01 00 00       	jmp    80071f <vprintfmt+0x3bb>
	else if (lflag)
  80060f:	85 c9                	test   %ecx,%ecx
  800611:	75 1b                	jne    80062e <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061b:	89 c1                	mov    %eax,%ecx
  80061d:	c1 f9 1f             	sar    $0x1f,%ecx
  800620:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	8d 40 04             	lea    0x4(%eax),%eax
  800629:	89 45 14             	mov    %eax,0x14(%ebp)
  80062c:	eb b9                	jmp    8005e7 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8b 00                	mov    (%eax),%eax
  800633:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800636:	89 c1                	mov    %eax,%ecx
  800638:	c1 f9 1f             	sar    $0x1f,%ecx
  80063b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8d 40 04             	lea    0x4(%eax),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
  800647:	eb 9e                	jmp    8005e7 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800649:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80064c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80064f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800654:	e9 c6 00 00 00       	jmp    80071f <vprintfmt+0x3bb>
	if (lflag >= 2)
  800659:	83 f9 01             	cmp    $0x1,%ecx
  80065c:	7e 18                	jle    800676 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8b 10                	mov    (%eax),%edx
  800663:	8b 48 04             	mov    0x4(%eax),%ecx
  800666:	8d 40 08             	lea    0x8(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800671:	e9 a9 00 00 00       	jmp    80071f <vprintfmt+0x3bb>
	else if (lflag)
  800676:	85 c9                	test   %ecx,%ecx
  800678:	75 1a                	jne    800694 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8b 10                	mov    (%eax),%edx
  80067f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800684:	8d 40 04             	lea    0x4(%eax),%eax
  800687:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068f:	e9 8b 00 00 00       	jmp    80071f <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 10                	mov    (%eax),%edx
  800699:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069e:	8d 40 04             	lea    0x4(%eax),%eax
  8006a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a9:	eb 74                	jmp    80071f <vprintfmt+0x3bb>
	if (lflag >= 2)
  8006ab:	83 f9 01             	cmp    $0x1,%ecx
  8006ae:	7e 15                	jle    8006c5 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	8b 10                	mov    (%eax),%edx
  8006b5:	8b 48 04             	mov    0x4(%eax),%ecx
  8006b8:	8d 40 08             	lea    0x8(%eax),%eax
  8006bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006be:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c3:	eb 5a                	jmp    80071f <vprintfmt+0x3bb>
	else if (lflag)
  8006c5:	85 c9                	test   %ecx,%ecx
  8006c7:	75 17                	jne    8006e0 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8b 10                	mov    (%eax),%edx
  8006ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d3:	8d 40 04             	lea    0x4(%eax),%eax
  8006d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d9:	b8 08 00 00 00       	mov    $0x8,%eax
  8006de:	eb 3f                	jmp    80071f <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8b 10                	mov    (%eax),%edx
  8006e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ea:	8d 40 04             	lea    0x4(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f0:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f5:	eb 28                	jmp    80071f <vprintfmt+0x3bb>
			putch('0', putdat);
  8006f7:	83 ec 08             	sub    $0x8,%esp
  8006fa:	53                   	push   %ebx
  8006fb:	6a 30                	push   $0x30
  8006fd:	ff d6                	call   *%esi
			putch('x', putdat);
  8006ff:	83 c4 08             	add    $0x8,%esp
  800702:	53                   	push   %ebx
  800703:	6a 78                	push   $0x78
  800705:	ff d6                	call   *%esi
			num = (unsigned long long)
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 10                	mov    (%eax),%edx
  80070c:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800711:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800714:	8d 40 04             	lea    0x4(%eax),%eax
  800717:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80071f:	83 ec 0c             	sub    $0xc,%esp
  800722:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800726:	57                   	push   %edi
  800727:	ff 75 e0             	pushl  -0x20(%ebp)
  80072a:	50                   	push   %eax
  80072b:	51                   	push   %ecx
  80072c:	52                   	push   %edx
  80072d:	89 da                	mov    %ebx,%edx
  80072f:	89 f0                	mov    %esi,%eax
  800731:	e8 45 fb ff ff       	call   80027b <printnum>
			break;
  800736:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800739:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  80073c:	83 c7 01             	add    $0x1,%edi
  80073f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800743:	83 f8 25             	cmp    $0x25,%eax
  800746:	0f 84 2f fc ff ff    	je     80037b <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  80074c:	85 c0                	test   %eax,%eax
  80074e:	0f 84 8b 00 00 00    	je     8007df <vprintfmt+0x47b>
			putch(ch, putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	53                   	push   %ebx
  800758:	50                   	push   %eax
  800759:	ff d6                	call   *%esi
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	eb dc                	jmp    80073c <vprintfmt+0x3d8>
	if (lflag >= 2)
  800760:	83 f9 01             	cmp    $0x1,%ecx
  800763:	7e 15                	jle    80077a <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8b 10                	mov    (%eax),%edx
  80076a:	8b 48 04             	mov    0x4(%eax),%ecx
  80076d:	8d 40 08             	lea    0x8(%eax),%eax
  800770:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800773:	b8 10 00 00 00       	mov    $0x10,%eax
  800778:	eb a5                	jmp    80071f <vprintfmt+0x3bb>
	else if (lflag)
  80077a:	85 c9                	test   %ecx,%ecx
  80077c:	75 17                	jne    800795 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	8b 10                	mov    (%eax),%edx
  800783:	b9 00 00 00 00       	mov    $0x0,%ecx
  800788:	8d 40 04             	lea    0x4(%eax),%eax
  80078b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078e:	b8 10 00 00 00       	mov    $0x10,%eax
  800793:	eb 8a                	jmp    80071f <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8b 10                	mov    (%eax),%edx
  80079a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80079f:	8d 40 04             	lea    0x4(%eax),%eax
  8007a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a5:	b8 10 00 00 00       	mov    $0x10,%eax
  8007aa:	e9 70 ff ff ff       	jmp    80071f <vprintfmt+0x3bb>
			putch(ch, putdat);
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	53                   	push   %ebx
  8007b3:	6a 25                	push   $0x25
  8007b5:	ff d6                	call   *%esi
			break;
  8007b7:	83 c4 10             	add    $0x10,%esp
  8007ba:	e9 7a ff ff ff       	jmp    800739 <vprintfmt+0x3d5>
			putch('%', putdat);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	53                   	push   %ebx
  8007c3:	6a 25                	push   $0x25
  8007c5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007c7:	83 c4 10             	add    $0x10,%esp
  8007ca:	89 f8                	mov    %edi,%eax
  8007cc:	eb 03                	jmp    8007d1 <vprintfmt+0x46d>
  8007ce:	83 e8 01             	sub    $0x1,%eax
  8007d1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007d5:	75 f7                	jne    8007ce <vprintfmt+0x46a>
  8007d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007da:	e9 5a ff ff ff       	jmp    800739 <vprintfmt+0x3d5>
}
  8007df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007e2:	5b                   	pop    %ebx
  8007e3:	5e                   	pop    %esi
  8007e4:	5f                   	pop    %edi
  8007e5:	5d                   	pop    %ebp
  8007e6:	c3                   	ret    

008007e7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	83 ec 18             	sub    $0x18,%esp
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007f6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007fa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800804:	85 c0                	test   %eax,%eax
  800806:	74 26                	je     80082e <vsnprintf+0x47>
  800808:	85 d2                	test   %edx,%edx
  80080a:	7e 22                	jle    80082e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80080c:	ff 75 14             	pushl  0x14(%ebp)
  80080f:	ff 75 10             	pushl  0x10(%ebp)
  800812:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800815:	50                   	push   %eax
  800816:	68 2a 03 80 00       	push   $0x80032a
  80081b:	e8 44 fb ff ff       	call   800364 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800823:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800829:	83 c4 10             	add    $0x10,%esp
}
  80082c:	c9                   	leave  
  80082d:	c3                   	ret    
		return -E_INVAL;
  80082e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800833:	eb f7                	jmp    80082c <vsnprintf+0x45>

00800835 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80083b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80083e:	50                   	push   %eax
  80083f:	ff 75 10             	pushl  0x10(%ebp)
  800842:	ff 75 0c             	pushl  0xc(%ebp)
  800845:	ff 75 08             	pushl  0x8(%ebp)
  800848:	e8 9a ff ff ff       	call   8007e7 <vsnprintf>
	va_end(ap);

	return rc;
}
  80084d:	c9                   	leave  
  80084e:	c3                   	ret    

0080084f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800855:	b8 00 00 00 00       	mov    $0x0,%eax
  80085a:	eb 03                	jmp    80085f <strlen+0x10>
		n++;
  80085c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80085f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800863:	75 f7                	jne    80085c <strlen+0xd>
	return n;
}
  800865:	5d                   	pop    %ebp
  800866:	c3                   	ret    

00800867 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800870:	b8 00 00 00 00       	mov    $0x0,%eax
  800875:	eb 03                	jmp    80087a <strnlen+0x13>
		n++;
  800877:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80087a:	39 d0                	cmp    %edx,%eax
  80087c:	74 06                	je     800884 <strnlen+0x1d>
  80087e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800882:	75 f3                	jne    800877 <strnlen+0x10>
	return n;
}
  800884:	5d                   	pop    %ebp
  800885:	c3                   	ret    

00800886 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	53                   	push   %ebx
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800890:	89 c2                	mov    %eax,%edx
  800892:	83 c1 01             	add    $0x1,%ecx
  800895:	83 c2 01             	add    $0x1,%edx
  800898:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80089c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80089f:	84 db                	test   %bl,%bl
  8008a1:	75 ef                	jne    800892 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008a3:	5b                   	pop    %ebx
  8008a4:	5d                   	pop    %ebp
  8008a5:	c3                   	ret    

008008a6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	53                   	push   %ebx
  8008aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008ad:	53                   	push   %ebx
  8008ae:	e8 9c ff ff ff       	call   80084f <strlen>
  8008b3:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008b6:	ff 75 0c             	pushl  0xc(%ebp)
  8008b9:	01 d8                	add    %ebx,%eax
  8008bb:	50                   	push   %eax
  8008bc:	e8 c5 ff ff ff       	call   800886 <strcpy>
	return dst;
}
  8008c1:	89 d8                	mov    %ebx,%eax
  8008c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c6:	c9                   	leave  
  8008c7:	c3                   	ret    

008008c8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	56                   	push   %esi
  8008cc:	53                   	push   %ebx
  8008cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008d3:	89 f3                	mov    %esi,%ebx
  8008d5:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d8:	89 f2                	mov    %esi,%edx
  8008da:	eb 0f                	jmp    8008eb <strncpy+0x23>
		*dst++ = *src;
  8008dc:	83 c2 01             	add    $0x1,%edx
  8008df:	0f b6 01             	movzbl (%ecx),%eax
  8008e2:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008e5:	80 39 01             	cmpb   $0x1,(%ecx)
  8008e8:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008eb:	39 da                	cmp    %ebx,%edx
  8008ed:	75 ed                	jne    8008dc <strncpy+0x14>
	}
	return ret;
}
  8008ef:	89 f0                	mov    %esi,%eax
  8008f1:	5b                   	pop    %ebx
  8008f2:	5e                   	pop    %esi
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	56                   	push   %esi
  8008f9:	53                   	push   %ebx
  8008fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8008fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800900:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800903:	89 f0                	mov    %esi,%eax
  800905:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800909:	85 c9                	test   %ecx,%ecx
  80090b:	75 0b                	jne    800918 <strlcpy+0x23>
  80090d:	eb 17                	jmp    800926 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80090f:	83 c2 01             	add    $0x1,%edx
  800912:	83 c0 01             	add    $0x1,%eax
  800915:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800918:	39 d8                	cmp    %ebx,%eax
  80091a:	74 07                	je     800923 <strlcpy+0x2e>
  80091c:	0f b6 0a             	movzbl (%edx),%ecx
  80091f:	84 c9                	test   %cl,%cl
  800921:	75 ec                	jne    80090f <strlcpy+0x1a>
		*dst = '\0';
  800923:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800926:	29 f0                	sub    %esi,%eax
}
  800928:	5b                   	pop    %ebx
  800929:	5e                   	pop    %esi
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800932:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800935:	eb 06                	jmp    80093d <strcmp+0x11>
		p++, q++;
  800937:	83 c1 01             	add    $0x1,%ecx
  80093a:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80093d:	0f b6 01             	movzbl (%ecx),%eax
  800940:	84 c0                	test   %al,%al
  800942:	74 04                	je     800948 <strcmp+0x1c>
  800944:	3a 02                	cmp    (%edx),%al
  800946:	74 ef                	je     800937 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800948:	0f b6 c0             	movzbl %al,%eax
  80094b:	0f b6 12             	movzbl (%edx),%edx
  80094e:	29 d0                	sub    %edx,%eax
}
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	53                   	push   %ebx
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095c:	89 c3                	mov    %eax,%ebx
  80095e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800961:	eb 06                	jmp    800969 <strncmp+0x17>
		n--, p++, q++;
  800963:	83 c0 01             	add    $0x1,%eax
  800966:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800969:	39 d8                	cmp    %ebx,%eax
  80096b:	74 16                	je     800983 <strncmp+0x31>
  80096d:	0f b6 08             	movzbl (%eax),%ecx
  800970:	84 c9                	test   %cl,%cl
  800972:	74 04                	je     800978 <strncmp+0x26>
  800974:	3a 0a                	cmp    (%edx),%cl
  800976:	74 eb                	je     800963 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800978:	0f b6 00             	movzbl (%eax),%eax
  80097b:	0f b6 12             	movzbl (%edx),%edx
  80097e:	29 d0                	sub    %edx,%eax
}
  800980:	5b                   	pop    %ebx
  800981:	5d                   	pop    %ebp
  800982:	c3                   	ret    
		return 0;
  800983:	b8 00 00 00 00       	mov    $0x0,%eax
  800988:	eb f6                	jmp    800980 <strncmp+0x2e>

0080098a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800994:	0f b6 10             	movzbl (%eax),%edx
  800997:	84 d2                	test   %dl,%dl
  800999:	74 09                	je     8009a4 <strchr+0x1a>
		if (*s == c)
  80099b:	38 ca                	cmp    %cl,%dl
  80099d:	74 0a                	je     8009a9 <strchr+0x1f>
	for (; *s; s++)
  80099f:	83 c0 01             	add    $0x1,%eax
  8009a2:	eb f0                	jmp    800994 <strchr+0xa>
			return (char *) s;
	return 0;
  8009a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b5:	eb 03                	jmp    8009ba <strfind+0xf>
  8009b7:	83 c0 01             	add    $0x1,%eax
  8009ba:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009bd:	38 ca                	cmp    %cl,%dl
  8009bf:	74 04                	je     8009c5 <strfind+0x1a>
  8009c1:	84 d2                	test   %dl,%dl
  8009c3:	75 f2                	jne    8009b7 <strfind+0xc>
			break;
	return (char *) s;
}
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	57                   	push   %edi
  8009cb:	56                   	push   %esi
  8009cc:	53                   	push   %ebx
  8009cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d3:	85 c9                	test   %ecx,%ecx
  8009d5:	74 13                	je     8009ea <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009dd:	75 05                	jne    8009e4 <memset+0x1d>
  8009df:	f6 c1 03             	test   $0x3,%cl
  8009e2:	74 0d                	je     8009f1 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e7:	fc                   	cld    
  8009e8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ea:	89 f8                	mov    %edi,%eax
  8009ec:	5b                   	pop    %ebx
  8009ed:	5e                   	pop    %esi
  8009ee:	5f                   	pop    %edi
  8009ef:	5d                   	pop    %ebp
  8009f0:	c3                   	ret    
		c &= 0xFF;
  8009f1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009f5:	89 d3                	mov    %edx,%ebx
  8009f7:	c1 e3 08             	shl    $0x8,%ebx
  8009fa:	89 d0                	mov    %edx,%eax
  8009fc:	c1 e0 18             	shl    $0x18,%eax
  8009ff:	89 d6                	mov    %edx,%esi
  800a01:	c1 e6 10             	shl    $0x10,%esi
  800a04:	09 f0                	or     %esi,%eax
  800a06:	09 c2                	or     %eax,%edx
  800a08:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a0a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	fc                   	cld    
  800a10:	f3 ab                	rep stos %eax,%es:(%edi)
  800a12:	eb d6                	jmp    8009ea <memset+0x23>

00800a14 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	57                   	push   %edi
  800a18:	56                   	push   %esi
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a22:	39 c6                	cmp    %eax,%esi
  800a24:	73 35                	jae    800a5b <memmove+0x47>
  800a26:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a29:	39 c2                	cmp    %eax,%edx
  800a2b:	76 2e                	jbe    800a5b <memmove+0x47>
		s += n;
		d += n;
  800a2d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a30:	89 d6                	mov    %edx,%esi
  800a32:	09 fe                	or     %edi,%esi
  800a34:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a3a:	74 0c                	je     800a48 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a3c:	83 ef 01             	sub    $0x1,%edi
  800a3f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a42:	fd                   	std    
  800a43:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a45:	fc                   	cld    
  800a46:	eb 21                	jmp    800a69 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a48:	f6 c1 03             	test   $0x3,%cl
  800a4b:	75 ef                	jne    800a3c <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a4d:	83 ef 04             	sub    $0x4,%edi
  800a50:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a53:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a56:	fd                   	std    
  800a57:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a59:	eb ea                	jmp    800a45 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5b:	89 f2                	mov    %esi,%edx
  800a5d:	09 c2                	or     %eax,%edx
  800a5f:	f6 c2 03             	test   $0x3,%dl
  800a62:	74 09                	je     800a6d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a64:	89 c7                	mov    %eax,%edi
  800a66:	fc                   	cld    
  800a67:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a69:	5e                   	pop    %esi
  800a6a:	5f                   	pop    %edi
  800a6b:	5d                   	pop    %ebp
  800a6c:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a6d:	f6 c1 03             	test   $0x3,%cl
  800a70:	75 f2                	jne    800a64 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a72:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a75:	89 c7                	mov    %eax,%edi
  800a77:	fc                   	cld    
  800a78:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7a:	eb ed                	jmp    800a69 <memmove+0x55>

00800a7c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a7f:	ff 75 10             	pushl  0x10(%ebp)
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	ff 75 08             	pushl  0x8(%ebp)
  800a88:	e8 87 ff ff ff       	call   800a14 <memmove>
}
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    

00800a8f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	56                   	push   %esi
  800a93:	53                   	push   %ebx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9a:	89 c6                	mov    %eax,%esi
  800a9c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a9f:	39 f0                	cmp    %esi,%eax
  800aa1:	74 1c                	je     800abf <memcmp+0x30>
		if (*s1 != *s2)
  800aa3:	0f b6 08             	movzbl (%eax),%ecx
  800aa6:	0f b6 1a             	movzbl (%edx),%ebx
  800aa9:	38 d9                	cmp    %bl,%cl
  800aab:	75 08                	jne    800ab5 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aad:	83 c0 01             	add    $0x1,%eax
  800ab0:	83 c2 01             	add    $0x1,%edx
  800ab3:	eb ea                	jmp    800a9f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ab5:	0f b6 c1             	movzbl %cl,%eax
  800ab8:	0f b6 db             	movzbl %bl,%ebx
  800abb:	29 d8                	sub    %ebx,%eax
  800abd:	eb 05                	jmp    800ac4 <memcmp+0x35>
	}

	return 0;
  800abf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ad1:	89 c2                	mov    %eax,%edx
  800ad3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad6:	39 d0                	cmp    %edx,%eax
  800ad8:	73 09                	jae    800ae3 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ada:	38 08                	cmp    %cl,(%eax)
  800adc:	74 05                	je     800ae3 <memfind+0x1b>
	for (; s < ends; s++)
  800ade:	83 c0 01             	add    $0x1,%eax
  800ae1:	eb f3                	jmp    800ad6 <memfind+0xe>
			break;
	return (void *) s;
}
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	57                   	push   %edi
  800ae9:	56                   	push   %esi
  800aea:	53                   	push   %ebx
  800aeb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af1:	eb 03                	jmp    800af6 <strtol+0x11>
		s++;
  800af3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800af6:	0f b6 01             	movzbl (%ecx),%eax
  800af9:	3c 20                	cmp    $0x20,%al
  800afb:	74 f6                	je     800af3 <strtol+0xe>
  800afd:	3c 09                	cmp    $0x9,%al
  800aff:	74 f2                	je     800af3 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b01:	3c 2b                	cmp    $0x2b,%al
  800b03:	74 2e                	je     800b33 <strtol+0x4e>
	int neg = 0;
  800b05:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b0a:	3c 2d                	cmp    $0x2d,%al
  800b0c:	74 2f                	je     800b3d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b0e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b14:	75 05                	jne    800b1b <strtol+0x36>
  800b16:	80 39 30             	cmpb   $0x30,(%ecx)
  800b19:	74 2c                	je     800b47 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b1b:	85 db                	test   %ebx,%ebx
  800b1d:	75 0a                	jne    800b29 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b1f:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b24:	80 39 30             	cmpb   $0x30,(%ecx)
  800b27:	74 28                	je     800b51 <strtol+0x6c>
		base = 10;
  800b29:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b31:	eb 50                	jmp    800b83 <strtol+0x9e>
		s++;
  800b33:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b36:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3b:	eb d1                	jmp    800b0e <strtol+0x29>
		s++, neg = 1;
  800b3d:	83 c1 01             	add    $0x1,%ecx
  800b40:	bf 01 00 00 00       	mov    $0x1,%edi
  800b45:	eb c7                	jmp    800b0e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b47:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b4b:	74 0e                	je     800b5b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b4d:	85 db                	test   %ebx,%ebx
  800b4f:	75 d8                	jne    800b29 <strtol+0x44>
		s++, base = 8;
  800b51:	83 c1 01             	add    $0x1,%ecx
  800b54:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b59:	eb ce                	jmp    800b29 <strtol+0x44>
		s += 2, base = 16;
  800b5b:	83 c1 02             	add    $0x2,%ecx
  800b5e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b63:	eb c4                	jmp    800b29 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b65:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b68:	89 f3                	mov    %esi,%ebx
  800b6a:	80 fb 19             	cmp    $0x19,%bl
  800b6d:	77 29                	ja     800b98 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b6f:	0f be d2             	movsbl %dl,%edx
  800b72:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b75:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b78:	7d 30                	jge    800baa <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b7a:	83 c1 01             	add    $0x1,%ecx
  800b7d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b81:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b83:	0f b6 11             	movzbl (%ecx),%edx
  800b86:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b89:	89 f3                	mov    %esi,%ebx
  800b8b:	80 fb 09             	cmp    $0x9,%bl
  800b8e:	77 d5                	ja     800b65 <strtol+0x80>
			dig = *s - '0';
  800b90:	0f be d2             	movsbl %dl,%edx
  800b93:	83 ea 30             	sub    $0x30,%edx
  800b96:	eb dd                	jmp    800b75 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b98:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b9b:	89 f3                	mov    %esi,%ebx
  800b9d:	80 fb 19             	cmp    $0x19,%bl
  800ba0:	77 08                	ja     800baa <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ba2:	0f be d2             	movsbl %dl,%edx
  800ba5:	83 ea 37             	sub    $0x37,%edx
  800ba8:	eb cb                	jmp    800b75 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800baa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bae:	74 05                	je     800bb5 <strtol+0xd0>
		*endptr = (char *) s;
  800bb0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bb5:	89 c2                	mov    %eax,%edx
  800bb7:	f7 da                	neg    %edx
  800bb9:	85 ff                	test   %edi,%edi
  800bbb:	0f 45 c2             	cmovne %edx,%eax
}
  800bbe:	5b                   	pop    %ebx
  800bbf:	5e                   	pop    %esi
  800bc0:	5f                   	pop    %edi
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    

00800bc3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	57                   	push   %edi
  800bc7:	56                   	push   %esi
  800bc8:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bce:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd4:	89 c3                	mov    %eax,%ebx
  800bd6:	89 c7                	mov    %eax,%edi
  800bd8:	89 c6                	mov    %eax,%esi
  800bda:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bdc:	5b                   	pop    %ebx
  800bdd:	5e                   	pop    %esi
  800bde:	5f                   	pop    %edi
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	57                   	push   %edi
  800be5:	56                   	push   %esi
  800be6:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800be7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bec:	b8 01 00 00 00       	mov    $0x1,%eax
  800bf1:	89 d1                	mov    %edx,%ecx
  800bf3:	89 d3                	mov    %edx,%ebx
  800bf5:	89 d7                	mov    %edx,%edi
  800bf7:	89 d6                	mov    %edx,%esi
  800bf9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bfb:	5b                   	pop    %ebx
  800bfc:	5e                   	pop    %esi
  800bfd:	5f                   	pop    %edi
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    

00800c00 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	57                   	push   %edi
  800c04:	56                   	push   %esi
  800c05:	53                   	push   %ebx
  800c06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c09:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c11:	b8 03 00 00 00       	mov    $0x3,%eax
  800c16:	89 cb                	mov    %ecx,%ebx
  800c18:	89 cf                	mov    %ecx,%edi
  800c1a:	89 ce                	mov    %ecx,%esi
  800c1c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1e:	85 c0                	test   %eax,%eax
  800c20:	7f 08                	jg     800c2a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c25:	5b                   	pop    %ebx
  800c26:	5e                   	pop    %esi
  800c27:	5f                   	pop    %edi
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c2a:	83 ec 0c             	sub    $0xc,%esp
  800c2d:	50                   	push   %eax
  800c2e:	6a 03                	push   $0x3
  800c30:	68 5f 28 80 00       	push   $0x80285f
  800c35:	6a 23                	push   $0x23
  800c37:	68 7c 28 80 00       	push   $0x80287c
  800c3c:	e8 4b f5 ff ff       	call   80018c <_panic>

00800c41 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	57                   	push   %edi
  800c45:	56                   	push   %esi
  800c46:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c47:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4c:	b8 02 00 00 00       	mov    $0x2,%eax
  800c51:	89 d1                	mov    %edx,%ecx
  800c53:	89 d3                	mov    %edx,%ebx
  800c55:	89 d7                	mov    %edx,%edi
  800c57:	89 d6                	mov    %edx,%esi
  800c59:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c5b:	5b                   	pop    %ebx
  800c5c:	5e                   	pop    %esi
  800c5d:	5f                   	pop    %edi
  800c5e:	5d                   	pop    %ebp
  800c5f:	c3                   	ret    

00800c60 <sys_yield>:

void
sys_yield(void)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	57                   	push   %edi
  800c64:	56                   	push   %esi
  800c65:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c66:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c70:	89 d1                	mov    %edx,%ecx
  800c72:	89 d3                	mov    %edx,%ebx
  800c74:	89 d7                	mov    %edx,%edi
  800c76:	89 d6                	mov    %edx,%esi
  800c78:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c7a:	5b                   	pop    %ebx
  800c7b:	5e                   	pop    %esi
  800c7c:	5f                   	pop    %edi
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
  800c85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c88:	be 00 00 00 00       	mov    $0x0,%esi
  800c8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c93:	b8 04 00 00 00       	mov    $0x4,%eax
  800c98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9b:	89 f7                	mov    %esi,%edi
  800c9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9f:	85 c0                	test   %eax,%eax
  800ca1:	7f 08                	jg     800cab <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cab:	83 ec 0c             	sub    $0xc,%esp
  800cae:	50                   	push   %eax
  800caf:	6a 04                	push   $0x4
  800cb1:	68 5f 28 80 00       	push   $0x80285f
  800cb6:	6a 23                	push   $0x23
  800cb8:	68 7c 28 80 00       	push   $0x80287c
  800cbd:	e8 ca f4 ff ff       	call   80018c <_panic>

00800cc2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	53                   	push   %ebx
  800cc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ccb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd1:	b8 05 00 00 00       	mov    $0x5,%eax
  800cd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cd9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cdc:	8b 75 18             	mov    0x18(%ebp),%esi
  800cdf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce1:	85 c0                	test   %eax,%eax
  800ce3:	7f 08                	jg     800ced <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ce5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce8:	5b                   	pop    %ebx
  800ce9:	5e                   	pop    %esi
  800cea:	5f                   	pop    %edi
  800ceb:	5d                   	pop    %ebp
  800cec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ced:	83 ec 0c             	sub    $0xc,%esp
  800cf0:	50                   	push   %eax
  800cf1:	6a 05                	push   $0x5
  800cf3:	68 5f 28 80 00       	push   $0x80285f
  800cf8:	6a 23                	push   $0x23
  800cfa:	68 7c 28 80 00       	push   $0x80287c
  800cff:	e8 88 f4 ff ff       	call   80018c <_panic>

00800d04 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
  800d0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d12:	8b 55 08             	mov    0x8(%ebp),%edx
  800d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d18:	b8 06 00 00 00       	mov    $0x6,%eax
  800d1d:	89 df                	mov    %ebx,%edi
  800d1f:	89 de                	mov    %ebx,%esi
  800d21:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	7f 08                	jg     800d2f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2f:	83 ec 0c             	sub    $0xc,%esp
  800d32:	50                   	push   %eax
  800d33:	6a 06                	push   $0x6
  800d35:	68 5f 28 80 00       	push   $0x80285f
  800d3a:	6a 23                	push   $0x23
  800d3c:	68 7c 28 80 00       	push   $0x80287c
  800d41:	e8 46 f4 ff ff       	call   80018c <_panic>

00800d46 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	57                   	push   %edi
  800d4a:	56                   	push   %esi
  800d4b:	53                   	push   %ebx
  800d4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d54:	8b 55 08             	mov    0x8(%ebp),%edx
  800d57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5a:	b8 08 00 00 00       	mov    $0x8,%eax
  800d5f:	89 df                	mov    %ebx,%edi
  800d61:	89 de                	mov    %ebx,%esi
  800d63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d65:	85 c0                	test   %eax,%eax
  800d67:	7f 08                	jg     800d71 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6c:	5b                   	pop    %ebx
  800d6d:	5e                   	pop    %esi
  800d6e:	5f                   	pop    %edi
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d71:	83 ec 0c             	sub    $0xc,%esp
  800d74:	50                   	push   %eax
  800d75:	6a 08                	push   $0x8
  800d77:	68 5f 28 80 00       	push   $0x80285f
  800d7c:	6a 23                	push   $0x23
  800d7e:	68 7c 28 80 00       	push   $0x80287c
  800d83:	e8 04 f4 ff ff       	call   80018c <_panic>

00800d88 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	57                   	push   %edi
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
  800d8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d91:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d96:	8b 55 08             	mov    0x8(%ebp),%edx
  800d99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9c:	b8 09 00 00 00       	mov    $0x9,%eax
  800da1:	89 df                	mov    %ebx,%edi
  800da3:	89 de                	mov    %ebx,%esi
  800da5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da7:	85 c0                	test   %eax,%eax
  800da9:	7f 08                	jg     800db3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db3:	83 ec 0c             	sub    $0xc,%esp
  800db6:	50                   	push   %eax
  800db7:	6a 09                	push   $0x9
  800db9:	68 5f 28 80 00       	push   $0x80285f
  800dbe:	6a 23                	push   $0x23
  800dc0:	68 7c 28 80 00       	push   $0x80287c
  800dc5:	e8 c2 f3 ff ff       	call   80018c <_panic>

00800dca <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	53                   	push   %ebx
  800dd0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800dd3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dde:	b8 0a 00 00 00       	mov    $0xa,%eax
  800de3:	89 df                	mov    %ebx,%edi
  800de5:	89 de                	mov    %ebx,%esi
  800de7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de9:	85 c0                	test   %eax,%eax
  800deb:	7f 08                	jg     800df5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df5:	83 ec 0c             	sub    $0xc,%esp
  800df8:	50                   	push   %eax
  800df9:	6a 0a                	push   $0xa
  800dfb:	68 5f 28 80 00       	push   $0x80285f
  800e00:	6a 23                	push   $0x23
  800e02:	68 7c 28 80 00       	push   $0x80287c
  800e07:	e8 80 f3 ff ff       	call   80018c <_panic>

00800e0c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	57                   	push   %edi
  800e10:	56                   	push   %esi
  800e11:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e12:	8b 55 08             	mov    0x8(%ebp),%edx
  800e15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e18:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e1d:	be 00 00 00 00       	mov    $0x0,%esi
  800e22:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e25:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e28:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5f                   	pop    %edi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    

00800e2f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
  800e35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e38:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e40:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e45:	89 cb                	mov    %ecx,%ebx
  800e47:	89 cf                	mov    %ecx,%edi
  800e49:	89 ce                	mov    %ecx,%esi
  800e4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4d:	85 c0                	test   %eax,%eax
  800e4f:	7f 08                	jg     800e59 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e59:	83 ec 0c             	sub    $0xc,%esp
  800e5c:	50                   	push   %eax
  800e5d:	6a 0d                	push   $0xd
  800e5f:	68 5f 28 80 00       	push   $0x80285f
  800e64:	6a 23                	push   $0x23
  800e66:	68 7c 28 80 00       	push   $0x80287c
  800e6b:	e8 1c f3 ff ff       	call   80018c <_panic>

00800e70 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	05 00 00 00 30       	add    $0x30000000,%eax
  800e7b:	c1 e8 0c             	shr    $0xc,%eax
}
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e90:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e9d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ea2:	89 c2                	mov    %eax,%edx
  800ea4:	c1 ea 16             	shr    $0x16,%edx
  800ea7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800eae:	f6 c2 01             	test   $0x1,%dl
  800eb1:	74 2a                	je     800edd <fd_alloc+0x46>
  800eb3:	89 c2                	mov    %eax,%edx
  800eb5:	c1 ea 0c             	shr    $0xc,%edx
  800eb8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ebf:	f6 c2 01             	test   $0x1,%dl
  800ec2:	74 19                	je     800edd <fd_alloc+0x46>
  800ec4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ec9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ece:	75 d2                	jne    800ea2 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ed0:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ed6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800edb:	eb 07                	jmp    800ee4 <fd_alloc+0x4d>
			*fd_store = fd;
  800edd:	89 01                	mov    %eax,(%ecx)
			return 0;
  800edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800eec:	83 f8 1f             	cmp    $0x1f,%eax
  800eef:	77 36                	ja     800f27 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ef1:	c1 e0 0c             	shl    $0xc,%eax
  800ef4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ef9:	89 c2                	mov    %eax,%edx
  800efb:	c1 ea 16             	shr    $0x16,%edx
  800efe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f05:	f6 c2 01             	test   $0x1,%dl
  800f08:	74 24                	je     800f2e <fd_lookup+0x48>
  800f0a:	89 c2                	mov    %eax,%edx
  800f0c:	c1 ea 0c             	shr    $0xc,%edx
  800f0f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f16:	f6 c2 01             	test   $0x1,%dl
  800f19:	74 1a                	je     800f35 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1e:	89 02                	mov    %eax,(%edx)
	return 0;
  800f20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    
		return -E_INVAL;
  800f27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f2c:	eb f7                	jmp    800f25 <fd_lookup+0x3f>
		return -E_INVAL;
  800f2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f33:	eb f0                	jmp    800f25 <fd_lookup+0x3f>
  800f35:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f3a:	eb e9                	jmp    800f25 <fd_lookup+0x3f>

00800f3c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	83 ec 08             	sub    $0x8,%esp
  800f42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f45:	ba 08 29 80 00       	mov    $0x802908,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f4a:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f4f:	39 08                	cmp    %ecx,(%eax)
  800f51:	74 33                	je     800f86 <dev_lookup+0x4a>
  800f53:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f56:	8b 02                	mov    (%edx),%eax
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	75 f3                	jne    800f4f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f5c:	a1 04 40 80 00       	mov    0x804004,%eax
  800f61:	8b 40 48             	mov    0x48(%eax),%eax
  800f64:	83 ec 04             	sub    $0x4,%esp
  800f67:	51                   	push   %ecx
  800f68:	50                   	push   %eax
  800f69:	68 8c 28 80 00       	push   $0x80288c
  800f6e:	e8 f4 f2 ff ff       	call   800267 <cprintf>
	*dev = 0;
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f7c:	83 c4 10             	add    $0x10,%esp
  800f7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f84:	c9                   	leave  
  800f85:	c3                   	ret    
			*dev = devtab[i];
  800f86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f89:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f90:	eb f2                	jmp    800f84 <dev_lookup+0x48>

00800f92 <fd_close>:
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	57                   	push   %edi
  800f96:	56                   	push   %esi
  800f97:	53                   	push   %ebx
  800f98:	83 ec 1c             	sub    $0x1c,%esp
  800f9b:	8b 75 08             	mov    0x8(%ebp),%esi
  800f9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fa1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fa4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fab:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fae:	50                   	push   %eax
  800faf:	e8 32 ff ff ff       	call   800ee6 <fd_lookup>
  800fb4:	89 c3                	mov    %eax,%ebx
  800fb6:	83 c4 08             	add    $0x8,%esp
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	78 05                	js     800fc2 <fd_close+0x30>
	    || fd != fd2)
  800fbd:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fc0:	74 16                	je     800fd8 <fd_close+0x46>
		return (must_exist ? r : 0);
  800fc2:	89 f8                	mov    %edi,%eax
  800fc4:	84 c0                	test   %al,%al
  800fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fcb:	0f 44 d8             	cmove  %eax,%ebx
}
  800fce:	89 d8                	mov    %ebx,%eax
  800fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd3:	5b                   	pop    %ebx
  800fd4:	5e                   	pop    %esi
  800fd5:	5f                   	pop    %edi
  800fd6:	5d                   	pop    %ebp
  800fd7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fd8:	83 ec 08             	sub    $0x8,%esp
  800fdb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fde:	50                   	push   %eax
  800fdf:	ff 36                	pushl  (%esi)
  800fe1:	e8 56 ff ff ff       	call   800f3c <dev_lookup>
  800fe6:	89 c3                	mov    %eax,%ebx
  800fe8:	83 c4 10             	add    $0x10,%esp
  800feb:	85 c0                	test   %eax,%eax
  800fed:	78 15                	js     801004 <fd_close+0x72>
		if (dev->dev_close)
  800fef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ff2:	8b 40 10             	mov    0x10(%eax),%eax
  800ff5:	85 c0                	test   %eax,%eax
  800ff7:	74 1b                	je     801014 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800ff9:	83 ec 0c             	sub    $0xc,%esp
  800ffc:	56                   	push   %esi
  800ffd:	ff d0                	call   *%eax
  800fff:	89 c3                	mov    %eax,%ebx
  801001:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801004:	83 ec 08             	sub    $0x8,%esp
  801007:	56                   	push   %esi
  801008:	6a 00                	push   $0x0
  80100a:	e8 f5 fc ff ff       	call   800d04 <sys_page_unmap>
	return r;
  80100f:	83 c4 10             	add    $0x10,%esp
  801012:	eb ba                	jmp    800fce <fd_close+0x3c>
			r = 0;
  801014:	bb 00 00 00 00       	mov    $0x0,%ebx
  801019:	eb e9                	jmp    801004 <fd_close+0x72>

0080101b <close>:

int
close(int fdnum)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801021:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801024:	50                   	push   %eax
  801025:	ff 75 08             	pushl  0x8(%ebp)
  801028:	e8 b9 fe ff ff       	call   800ee6 <fd_lookup>
  80102d:	83 c4 08             	add    $0x8,%esp
  801030:	85 c0                	test   %eax,%eax
  801032:	78 10                	js     801044 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801034:	83 ec 08             	sub    $0x8,%esp
  801037:	6a 01                	push   $0x1
  801039:	ff 75 f4             	pushl  -0xc(%ebp)
  80103c:	e8 51 ff ff ff       	call   800f92 <fd_close>
  801041:	83 c4 10             	add    $0x10,%esp
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <close_all>:

void
close_all(void)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	53                   	push   %ebx
  80104a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80104d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801052:	83 ec 0c             	sub    $0xc,%esp
  801055:	53                   	push   %ebx
  801056:	e8 c0 ff ff ff       	call   80101b <close>
	for (i = 0; i < MAXFD; i++)
  80105b:	83 c3 01             	add    $0x1,%ebx
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	83 fb 20             	cmp    $0x20,%ebx
  801064:	75 ec                	jne    801052 <close_all+0xc>
}
  801066:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	53                   	push   %ebx
  801071:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801074:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801077:	50                   	push   %eax
  801078:	ff 75 08             	pushl  0x8(%ebp)
  80107b:	e8 66 fe ff ff       	call   800ee6 <fd_lookup>
  801080:	89 c3                	mov    %eax,%ebx
  801082:	83 c4 08             	add    $0x8,%esp
  801085:	85 c0                	test   %eax,%eax
  801087:	0f 88 81 00 00 00    	js     80110e <dup+0xa3>
		return r;
	close(newfdnum);
  80108d:	83 ec 0c             	sub    $0xc,%esp
  801090:	ff 75 0c             	pushl  0xc(%ebp)
  801093:	e8 83 ff ff ff       	call   80101b <close>

	newfd = INDEX2FD(newfdnum);
  801098:	8b 75 0c             	mov    0xc(%ebp),%esi
  80109b:	c1 e6 0c             	shl    $0xc,%esi
  80109e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010a4:	83 c4 04             	add    $0x4,%esp
  8010a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010aa:	e8 d1 fd ff ff       	call   800e80 <fd2data>
  8010af:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010b1:	89 34 24             	mov    %esi,(%esp)
  8010b4:	e8 c7 fd ff ff       	call   800e80 <fd2data>
  8010b9:	83 c4 10             	add    $0x10,%esp
  8010bc:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010be:	89 d8                	mov    %ebx,%eax
  8010c0:	c1 e8 16             	shr    $0x16,%eax
  8010c3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010ca:	a8 01                	test   $0x1,%al
  8010cc:	74 11                	je     8010df <dup+0x74>
  8010ce:	89 d8                	mov    %ebx,%eax
  8010d0:	c1 e8 0c             	shr    $0xc,%eax
  8010d3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010da:	f6 c2 01             	test   $0x1,%dl
  8010dd:	75 39                	jne    801118 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010e2:	89 d0                	mov    %edx,%eax
  8010e4:	c1 e8 0c             	shr    $0xc,%eax
  8010e7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010ee:	83 ec 0c             	sub    $0xc,%esp
  8010f1:	25 07 0e 00 00       	and    $0xe07,%eax
  8010f6:	50                   	push   %eax
  8010f7:	56                   	push   %esi
  8010f8:	6a 00                	push   $0x0
  8010fa:	52                   	push   %edx
  8010fb:	6a 00                	push   $0x0
  8010fd:	e8 c0 fb ff ff       	call   800cc2 <sys_page_map>
  801102:	89 c3                	mov    %eax,%ebx
  801104:	83 c4 20             	add    $0x20,%esp
  801107:	85 c0                	test   %eax,%eax
  801109:	78 31                	js     80113c <dup+0xd1>
		goto err;

	return newfdnum;
  80110b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80110e:	89 d8                	mov    %ebx,%eax
  801110:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801113:	5b                   	pop    %ebx
  801114:	5e                   	pop    %esi
  801115:	5f                   	pop    %edi
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801118:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80111f:	83 ec 0c             	sub    $0xc,%esp
  801122:	25 07 0e 00 00       	and    $0xe07,%eax
  801127:	50                   	push   %eax
  801128:	57                   	push   %edi
  801129:	6a 00                	push   $0x0
  80112b:	53                   	push   %ebx
  80112c:	6a 00                	push   $0x0
  80112e:	e8 8f fb ff ff       	call   800cc2 <sys_page_map>
  801133:	89 c3                	mov    %eax,%ebx
  801135:	83 c4 20             	add    $0x20,%esp
  801138:	85 c0                	test   %eax,%eax
  80113a:	79 a3                	jns    8010df <dup+0x74>
	sys_page_unmap(0, newfd);
  80113c:	83 ec 08             	sub    $0x8,%esp
  80113f:	56                   	push   %esi
  801140:	6a 00                	push   $0x0
  801142:	e8 bd fb ff ff       	call   800d04 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801147:	83 c4 08             	add    $0x8,%esp
  80114a:	57                   	push   %edi
  80114b:	6a 00                	push   $0x0
  80114d:	e8 b2 fb ff ff       	call   800d04 <sys_page_unmap>
	return r;
  801152:	83 c4 10             	add    $0x10,%esp
  801155:	eb b7                	jmp    80110e <dup+0xa3>

00801157 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	53                   	push   %ebx
  80115b:	83 ec 14             	sub    $0x14,%esp
  80115e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801161:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801164:	50                   	push   %eax
  801165:	53                   	push   %ebx
  801166:	e8 7b fd ff ff       	call   800ee6 <fd_lookup>
  80116b:	83 c4 08             	add    $0x8,%esp
  80116e:	85 c0                	test   %eax,%eax
  801170:	78 3f                	js     8011b1 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801172:	83 ec 08             	sub    $0x8,%esp
  801175:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801178:	50                   	push   %eax
  801179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80117c:	ff 30                	pushl  (%eax)
  80117e:	e8 b9 fd ff ff       	call   800f3c <dev_lookup>
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	85 c0                	test   %eax,%eax
  801188:	78 27                	js     8011b1 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80118a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80118d:	8b 42 08             	mov    0x8(%edx),%eax
  801190:	83 e0 03             	and    $0x3,%eax
  801193:	83 f8 01             	cmp    $0x1,%eax
  801196:	74 1e                	je     8011b6 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119b:	8b 40 08             	mov    0x8(%eax),%eax
  80119e:	85 c0                	test   %eax,%eax
  8011a0:	74 35                	je     8011d7 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011a2:	83 ec 04             	sub    $0x4,%esp
  8011a5:	ff 75 10             	pushl  0x10(%ebp)
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	52                   	push   %edx
  8011ac:	ff d0                	call   *%eax
  8011ae:	83 c4 10             	add    $0x10,%esp
}
  8011b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b4:	c9                   	leave  
  8011b5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011b6:	a1 04 40 80 00       	mov    0x804004,%eax
  8011bb:	8b 40 48             	mov    0x48(%eax),%eax
  8011be:	83 ec 04             	sub    $0x4,%esp
  8011c1:	53                   	push   %ebx
  8011c2:	50                   	push   %eax
  8011c3:	68 cd 28 80 00       	push   $0x8028cd
  8011c8:	e8 9a f0 ff ff       	call   800267 <cprintf>
		return -E_INVAL;
  8011cd:	83 c4 10             	add    $0x10,%esp
  8011d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d5:	eb da                	jmp    8011b1 <read+0x5a>
		return -E_NOT_SUPP;
  8011d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011dc:	eb d3                	jmp    8011b1 <read+0x5a>

008011de <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	57                   	push   %edi
  8011e2:	56                   	push   %esi
  8011e3:	53                   	push   %ebx
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011ea:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f2:	39 f3                	cmp    %esi,%ebx
  8011f4:	73 25                	jae    80121b <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	89 f0                	mov    %esi,%eax
  8011fb:	29 d8                	sub    %ebx,%eax
  8011fd:	50                   	push   %eax
  8011fe:	89 d8                	mov    %ebx,%eax
  801200:	03 45 0c             	add    0xc(%ebp),%eax
  801203:	50                   	push   %eax
  801204:	57                   	push   %edi
  801205:	e8 4d ff ff ff       	call   801157 <read>
		if (m < 0)
  80120a:	83 c4 10             	add    $0x10,%esp
  80120d:	85 c0                	test   %eax,%eax
  80120f:	78 08                	js     801219 <readn+0x3b>
			return m;
		if (m == 0)
  801211:	85 c0                	test   %eax,%eax
  801213:	74 06                	je     80121b <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801215:	01 c3                	add    %eax,%ebx
  801217:	eb d9                	jmp    8011f2 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801219:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80121b:	89 d8                	mov    %ebx,%eax
  80121d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801220:	5b                   	pop    %ebx
  801221:	5e                   	pop    %esi
  801222:	5f                   	pop    %edi
  801223:	5d                   	pop    %ebp
  801224:	c3                   	ret    

00801225 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	53                   	push   %ebx
  801229:	83 ec 14             	sub    $0x14,%esp
  80122c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80122f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801232:	50                   	push   %eax
  801233:	53                   	push   %ebx
  801234:	e8 ad fc ff ff       	call   800ee6 <fd_lookup>
  801239:	83 c4 08             	add    $0x8,%esp
  80123c:	85 c0                	test   %eax,%eax
  80123e:	78 3a                	js     80127a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801240:	83 ec 08             	sub    $0x8,%esp
  801243:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801246:	50                   	push   %eax
  801247:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124a:	ff 30                	pushl  (%eax)
  80124c:	e8 eb fc ff ff       	call   800f3c <dev_lookup>
  801251:	83 c4 10             	add    $0x10,%esp
  801254:	85 c0                	test   %eax,%eax
  801256:	78 22                	js     80127a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80125f:	74 1e                	je     80127f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801261:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801264:	8b 52 0c             	mov    0xc(%edx),%edx
  801267:	85 d2                	test   %edx,%edx
  801269:	74 35                	je     8012a0 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80126b:	83 ec 04             	sub    $0x4,%esp
  80126e:	ff 75 10             	pushl  0x10(%ebp)
  801271:	ff 75 0c             	pushl  0xc(%ebp)
  801274:	50                   	push   %eax
  801275:	ff d2                	call   *%edx
  801277:	83 c4 10             	add    $0x10,%esp
}
  80127a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80127f:	a1 04 40 80 00       	mov    0x804004,%eax
  801284:	8b 40 48             	mov    0x48(%eax),%eax
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	53                   	push   %ebx
  80128b:	50                   	push   %eax
  80128c:	68 e9 28 80 00       	push   $0x8028e9
  801291:	e8 d1 ef ff ff       	call   800267 <cprintf>
		return -E_INVAL;
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129e:	eb da                	jmp    80127a <write+0x55>
		return -E_NOT_SUPP;
  8012a0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012a5:	eb d3                	jmp    80127a <write+0x55>

008012a7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012ad:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012b0:	50                   	push   %eax
  8012b1:	ff 75 08             	pushl  0x8(%ebp)
  8012b4:	e8 2d fc ff ff       	call   800ee6 <fd_lookup>
  8012b9:	83 c4 08             	add    $0x8,%esp
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	78 0e                	js     8012ce <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ce:	c9                   	leave  
  8012cf:	c3                   	ret    

008012d0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	53                   	push   %ebx
  8012d4:	83 ec 14             	sub    $0x14,%esp
  8012d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012dd:	50                   	push   %eax
  8012de:	53                   	push   %ebx
  8012df:	e8 02 fc ff ff       	call   800ee6 <fd_lookup>
  8012e4:	83 c4 08             	add    $0x8,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	78 37                	js     801322 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012eb:	83 ec 08             	sub    $0x8,%esp
  8012ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f1:	50                   	push   %eax
  8012f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f5:	ff 30                	pushl  (%eax)
  8012f7:	e8 40 fc ff ff       	call   800f3c <dev_lookup>
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	78 1f                	js     801322 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801306:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80130a:	74 1b                	je     801327 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80130c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130f:	8b 52 18             	mov    0x18(%edx),%edx
  801312:	85 d2                	test   %edx,%edx
  801314:	74 32                	je     801348 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801316:	83 ec 08             	sub    $0x8,%esp
  801319:	ff 75 0c             	pushl  0xc(%ebp)
  80131c:	50                   	push   %eax
  80131d:	ff d2                	call   *%edx
  80131f:	83 c4 10             	add    $0x10,%esp
}
  801322:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801325:	c9                   	leave  
  801326:	c3                   	ret    
			thisenv->env_id, fdnum);
  801327:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80132c:	8b 40 48             	mov    0x48(%eax),%eax
  80132f:	83 ec 04             	sub    $0x4,%esp
  801332:	53                   	push   %ebx
  801333:	50                   	push   %eax
  801334:	68 ac 28 80 00       	push   $0x8028ac
  801339:	e8 29 ef ff ff       	call   800267 <cprintf>
		return -E_INVAL;
  80133e:	83 c4 10             	add    $0x10,%esp
  801341:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801346:	eb da                	jmp    801322 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801348:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80134d:	eb d3                	jmp    801322 <ftruncate+0x52>

0080134f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	53                   	push   %ebx
  801353:	83 ec 14             	sub    $0x14,%esp
  801356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801359:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80135c:	50                   	push   %eax
  80135d:	ff 75 08             	pushl  0x8(%ebp)
  801360:	e8 81 fb ff ff       	call   800ee6 <fd_lookup>
  801365:	83 c4 08             	add    $0x8,%esp
  801368:	85 c0                	test   %eax,%eax
  80136a:	78 4b                	js     8013b7 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80136c:	83 ec 08             	sub    $0x8,%esp
  80136f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801372:	50                   	push   %eax
  801373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801376:	ff 30                	pushl  (%eax)
  801378:	e8 bf fb ff ff       	call   800f3c <dev_lookup>
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	78 33                	js     8013b7 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801387:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80138b:	74 2f                	je     8013bc <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80138d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801390:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801397:	00 00 00 
	stat->st_isdir = 0;
  80139a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013a1:	00 00 00 
	stat->st_dev = dev;
  8013a4:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013aa:	83 ec 08             	sub    $0x8,%esp
  8013ad:	53                   	push   %ebx
  8013ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8013b1:	ff 50 14             	call   *0x14(%eax)
  8013b4:	83 c4 10             	add    $0x10,%esp
}
  8013b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    
		return -E_NOT_SUPP;
  8013bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c1:	eb f4                	jmp    8013b7 <fstat+0x68>

008013c3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	56                   	push   %esi
  8013c7:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013c8:	83 ec 08             	sub    $0x8,%esp
  8013cb:	6a 00                	push   $0x0
  8013cd:	ff 75 08             	pushl  0x8(%ebp)
  8013d0:	e8 30 02 00 00       	call   801605 <open>
  8013d5:	89 c3                	mov    %eax,%ebx
  8013d7:	83 c4 10             	add    $0x10,%esp
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	78 1b                	js     8013f9 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013de:	83 ec 08             	sub    $0x8,%esp
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	50                   	push   %eax
  8013e5:	e8 65 ff ff ff       	call   80134f <fstat>
  8013ea:	89 c6                	mov    %eax,%esi
	close(fd);
  8013ec:	89 1c 24             	mov    %ebx,(%esp)
  8013ef:	e8 27 fc ff ff       	call   80101b <close>
	return r;
  8013f4:	83 c4 10             	add    $0x10,%esp
  8013f7:	89 f3                	mov    %esi,%ebx
}
  8013f9:	89 d8                	mov    %ebx,%eax
  8013fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013fe:	5b                   	pop    %ebx
  8013ff:	5e                   	pop    %esi
  801400:	5d                   	pop    %ebp
  801401:	c3                   	ret    

00801402 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	56                   	push   %esi
  801406:	53                   	push   %ebx
  801407:	89 c6                	mov    %eax,%esi
  801409:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80140b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801412:	74 27                	je     80143b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801414:	6a 07                	push   $0x7
  801416:	68 00 50 80 00       	push   $0x805000
  80141b:	56                   	push   %esi
  80141c:	ff 35 00 40 80 00    	pushl  0x804000
  801422:	e8 24 0d 00 00       	call   80214b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801427:	83 c4 0c             	add    $0xc,%esp
  80142a:	6a 00                	push   $0x0
  80142c:	53                   	push   %ebx
  80142d:	6a 00                	push   $0x0
  80142f:	e8 ae 0c 00 00       	call   8020e2 <ipc_recv>
}
  801434:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801437:	5b                   	pop    %ebx
  801438:	5e                   	pop    %esi
  801439:	5d                   	pop    %ebp
  80143a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80143b:	83 ec 0c             	sub    $0xc,%esp
  80143e:	6a 01                	push   $0x1
  801440:	e8 5a 0d 00 00       	call   80219f <ipc_find_env>
  801445:	a3 00 40 80 00       	mov    %eax,0x804000
  80144a:	83 c4 10             	add    $0x10,%esp
  80144d:	eb c5                	jmp    801414 <fsipc+0x12>

0080144f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8b 40 0c             	mov    0xc(%eax),%eax
  80145b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801460:	8b 45 0c             	mov    0xc(%ebp),%eax
  801463:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801468:	ba 00 00 00 00       	mov    $0x0,%edx
  80146d:	b8 02 00 00 00       	mov    $0x2,%eax
  801472:	e8 8b ff ff ff       	call   801402 <fsipc>
}
  801477:	c9                   	leave  
  801478:	c3                   	ret    

00801479 <devfile_flush>:
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8b 40 0c             	mov    0xc(%eax),%eax
  801485:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80148a:	ba 00 00 00 00       	mov    $0x0,%edx
  80148f:	b8 06 00 00 00       	mov    $0x6,%eax
  801494:	e8 69 ff ff ff       	call   801402 <fsipc>
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <devfile_stat>:
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	53                   	push   %ebx
  80149f:	83 ec 04             	sub    $0x4,%esp
  8014a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ab:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b5:	b8 05 00 00 00       	mov    $0x5,%eax
  8014ba:	e8 43 ff ff ff       	call   801402 <fsipc>
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	78 2c                	js     8014ef <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014c3:	83 ec 08             	sub    $0x8,%esp
  8014c6:	68 00 50 80 00       	push   $0x805000
  8014cb:	53                   	push   %ebx
  8014cc:	e8 b5 f3 ff ff       	call   800886 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014d1:	a1 80 50 80 00       	mov    0x805080,%eax
  8014d6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014dc:	a1 84 50 80 00       	mov    0x805084,%eax
  8014e1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <devfile_write>:
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	53                   	push   %ebx
  8014f8:	83 ec 08             	sub    $0x8,%esp
  8014fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  8014fe:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801504:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801509:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	8b 40 0c             	mov    0xc(%eax),%eax
  801512:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801517:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80151d:	53                   	push   %ebx
  80151e:	ff 75 0c             	pushl  0xc(%ebp)
  801521:	68 08 50 80 00       	push   $0x805008
  801526:	e8 e9 f4 ff ff       	call   800a14 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80152b:	ba 00 00 00 00       	mov    $0x0,%edx
  801530:	b8 04 00 00 00       	mov    $0x4,%eax
  801535:	e8 c8 fe ff ff       	call   801402 <fsipc>
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	85 c0                	test   %eax,%eax
  80153f:	78 0b                	js     80154c <devfile_write+0x58>
	assert(r <= n);
  801541:	39 d8                	cmp    %ebx,%eax
  801543:	77 0c                	ja     801551 <devfile_write+0x5d>
	assert(r <= PGSIZE);
  801545:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80154a:	7f 1e                	jg     80156a <devfile_write+0x76>
}
  80154c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154f:	c9                   	leave  
  801550:	c3                   	ret    
	assert(r <= n);
  801551:	68 18 29 80 00       	push   $0x802918
  801556:	68 1f 29 80 00       	push   $0x80291f
  80155b:	68 98 00 00 00       	push   $0x98
  801560:	68 34 29 80 00       	push   $0x802934
  801565:	e8 22 ec ff ff       	call   80018c <_panic>
	assert(r <= PGSIZE);
  80156a:	68 3f 29 80 00       	push   $0x80293f
  80156f:	68 1f 29 80 00       	push   $0x80291f
  801574:	68 99 00 00 00       	push   $0x99
  801579:	68 34 29 80 00       	push   $0x802934
  80157e:	e8 09 ec ff ff       	call   80018c <_panic>

00801583 <devfile_read>:
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	56                   	push   %esi
  801587:	53                   	push   %ebx
  801588:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8b 40 0c             	mov    0xc(%eax),%eax
  801591:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801596:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80159c:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a1:	b8 03 00 00 00       	mov    $0x3,%eax
  8015a6:	e8 57 fe ff ff       	call   801402 <fsipc>
  8015ab:	89 c3                	mov    %eax,%ebx
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	78 1f                	js     8015d0 <devfile_read+0x4d>
	assert(r <= n);
  8015b1:	39 f0                	cmp    %esi,%eax
  8015b3:	77 24                	ja     8015d9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8015b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015ba:	7f 33                	jg     8015ef <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	50                   	push   %eax
  8015c0:	68 00 50 80 00       	push   $0x805000
  8015c5:	ff 75 0c             	pushl  0xc(%ebp)
  8015c8:	e8 47 f4 ff ff       	call   800a14 <memmove>
	return r;
  8015cd:	83 c4 10             	add    $0x10,%esp
}
  8015d0:	89 d8                	mov    %ebx,%eax
  8015d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d5:	5b                   	pop    %ebx
  8015d6:	5e                   	pop    %esi
  8015d7:	5d                   	pop    %ebp
  8015d8:	c3                   	ret    
	assert(r <= n);
  8015d9:	68 18 29 80 00       	push   $0x802918
  8015de:	68 1f 29 80 00       	push   $0x80291f
  8015e3:	6a 7c                	push   $0x7c
  8015e5:	68 34 29 80 00       	push   $0x802934
  8015ea:	e8 9d eb ff ff       	call   80018c <_panic>
	assert(r <= PGSIZE);
  8015ef:	68 3f 29 80 00       	push   $0x80293f
  8015f4:	68 1f 29 80 00       	push   $0x80291f
  8015f9:	6a 7d                	push   $0x7d
  8015fb:	68 34 29 80 00       	push   $0x802934
  801600:	e8 87 eb ff ff       	call   80018c <_panic>

00801605 <open>:
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	56                   	push   %esi
  801609:	53                   	push   %ebx
  80160a:	83 ec 1c             	sub    $0x1c,%esp
  80160d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801610:	56                   	push   %esi
  801611:	e8 39 f2 ff ff       	call   80084f <strlen>
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80161e:	7f 6c                	jg     80168c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801620:	83 ec 0c             	sub    $0xc,%esp
  801623:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801626:	50                   	push   %eax
  801627:	e8 6b f8 ff ff       	call   800e97 <fd_alloc>
  80162c:	89 c3                	mov    %eax,%ebx
  80162e:	83 c4 10             	add    $0x10,%esp
  801631:	85 c0                	test   %eax,%eax
  801633:	78 3c                	js     801671 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801635:	83 ec 08             	sub    $0x8,%esp
  801638:	56                   	push   %esi
  801639:	68 00 50 80 00       	push   $0x805000
  80163e:	e8 43 f2 ff ff       	call   800886 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801643:	8b 45 0c             	mov    0xc(%ebp),%eax
  801646:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80164b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80164e:	b8 01 00 00 00       	mov    $0x1,%eax
  801653:	e8 aa fd ff ff       	call   801402 <fsipc>
  801658:	89 c3                	mov    %eax,%ebx
  80165a:	83 c4 10             	add    $0x10,%esp
  80165d:	85 c0                	test   %eax,%eax
  80165f:	78 19                	js     80167a <open+0x75>
	return fd2num(fd);
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	ff 75 f4             	pushl  -0xc(%ebp)
  801667:	e8 04 f8 ff ff       	call   800e70 <fd2num>
  80166c:	89 c3                	mov    %eax,%ebx
  80166e:	83 c4 10             	add    $0x10,%esp
}
  801671:	89 d8                	mov    %ebx,%eax
  801673:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801676:	5b                   	pop    %ebx
  801677:	5e                   	pop    %esi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    
		fd_close(fd, 0);
  80167a:	83 ec 08             	sub    $0x8,%esp
  80167d:	6a 00                	push   $0x0
  80167f:	ff 75 f4             	pushl  -0xc(%ebp)
  801682:	e8 0b f9 ff ff       	call   800f92 <fd_close>
		return r;
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	eb e5                	jmp    801671 <open+0x6c>
		return -E_BAD_PATH;
  80168c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801691:	eb de                	jmp    801671 <open+0x6c>

00801693 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801699:	ba 00 00 00 00       	mov    $0x0,%edx
  80169e:	b8 08 00 00 00       	mov    $0x8,%eax
  8016a3:	e8 5a fd ff ff       	call   801402 <fsipc>
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	57                   	push   %edi
  8016ae:	56                   	push   %esi
  8016af:	53                   	push   %ebx
  8016b0:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8016b6:	6a 00                	push   $0x0
  8016b8:	ff 75 08             	pushl  0x8(%ebp)
  8016bb:	e8 45 ff ff ff       	call   801605 <open>
  8016c0:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	0f 88 40 03 00 00    	js     801a11 <spawn+0x367>
  8016d1:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8016d3:	83 ec 04             	sub    $0x4,%esp
  8016d6:	68 00 02 00 00       	push   $0x200
  8016db:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8016e1:	50                   	push   %eax
  8016e2:	52                   	push   %edx
  8016e3:	e8 f6 fa ff ff       	call   8011de <readn>
  8016e8:	83 c4 10             	add    $0x10,%esp
  8016eb:	3d 00 02 00 00       	cmp    $0x200,%eax
  8016f0:	75 5d                	jne    80174f <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  8016f2:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8016f9:	45 4c 46 
  8016fc:	75 51                	jne    80174f <spawn+0xa5>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8016fe:	b8 07 00 00 00       	mov    $0x7,%eax
  801703:	cd 30                	int    $0x30
  801705:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80170b:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801711:	85 c0                	test   %eax,%eax
  801713:	0f 88 2f 04 00 00    	js     801b48 <spawn+0x49e>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801719:	25 ff 03 00 00       	and    $0x3ff,%eax
  80171e:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801721:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801727:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80172d:	b9 11 00 00 00       	mov    $0x11,%ecx
  801732:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801734:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80173a:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801740:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801745:	be 00 00 00 00       	mov    $0x0,%esi
  80174a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80174d:	eb 4b                	jmp    80179a <spawn+0xf0>
		close(fd);
  80174f:	83 ec 0c             	sub    $0xc,%esp
  801752:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801758:	e8 be f8 ff ff       	call   80101b <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80175d:	83 c4 0c             	add    $0xc,%esp
  801760:	68 7f 45 4c 46       	push   $0x464c457f
  801765:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80176b:	68 4b 29 80 00       	push   $0x80294b
  801770:	e8 f2 ea ff ff       	call   800267 <cprintf>
		return -E_NOT_EXEC;
  801775:	83 c4 10             	add    $0x10,%esp
  801778:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  80177f:	ff ff ff 
  801782:	e9 8a 02 00 00       	jmp    801a11 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  801787:	83 ec 0c             	sub    $0xc,%esp
  80178a:	50                   	push   %eax
  80178b:	e8 bf f0 ff ff       	call   80084f <strlen>
  801790:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801794:	83 c3 01             	add    $0x1,%ebx
  801797:	83 c4 10             	add    $0x10,%esp
  80179a:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8017a1:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	75 df                	jne    801787 <spawn+0xdd>
  8017a8:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  8017ae:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8017b4:	bf 00 10 40 00       	mov    $0x401000,%edi
  8017b9:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8017bb:	89 fa                	mov    %edi,%edx
  8017bd:	83 e2 fc             	and    $0xfffffffc,%edx
  8017c0:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8017c7:	29 c2                	sub    %eax,%edx
  8017c9:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8017cf:	8d 42 f8             	lea    -0x8(%edx),%eax
  8017d2:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8017d7:	0f 86 7c 03 00 00    	jbe    801b59 <spawn+0x4af>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8017dd:	83 ec 04             	sub    $0x4,%esp
  8017e0:	6a 07                	push   $0x7
  8017e2:	68 00 00 40 00       	push   $0x400000
  8017e7:	6a 00                	push   $0x0
  8017e9:	e8 91 f4 ff ff       	call   800c7f <sys_page_alloc>
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	85 c0                	test   %eax,%eax
  8017f3:	0f 88 65 03 00 00    	js     801b5e <spawn+0x4b4>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8017f9:	be 00 00 00 00       	mov    $0x0,%esi
  8017fe:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801804:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801807:	eb 30                	jmp    801839 <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  801809:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80180f:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801815:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  801818:	83 ec 08             	sub    $0x8,%esp
  80181b:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80181e:	57                   	push   %edi
  80181f:	e8 62 f0 ff ff       	call   800886 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801824:	83 c4 04             	add    $0x4,%esp
  801827:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80182a:	e8 20 f0 ff ff       	call   80084f <strlen>
  80182f:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801833:	83 c6 01             	add    $0x1,%esi
  801836:	83 c4 10             	add    $0x10,%esp
  801839:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  80183f:	7f c8                	jg     801809 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801841:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801847:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80184d:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801854:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80185a:	0f 85 8c 00 00 00    	jne    8018ec <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801860:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801866:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80186c:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  80186f:	89 f8                	mov    %edi,%eax
  801871:	8b 8d 88 fd ff ff    	mov    -0x278(%ebp),%ecx
  801877:	89 4f f8             	mov    %ecx,-0x8(%edi)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80187a:	2d 08 30 80 11       	sub    $0x11803008,%eax
  80187f:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801885:	83 ec 0c             	sub    $0xc,%esp
  801888:	6a 07                	push   $0x7
  80188a:	68 00 d0 bf ee       	push   $0xeebfd000
  80188f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801895:	68 00 00 40 00       	push   $0x400000
  80189a:	6a 00                	push   $0x0
  80189c:	e8 21 f4 ff ff       	call   800cc2 <sys_page_map>
  8018a1:	89 c3                	mov    %eax,%ebx
  8018a3:	83 c4 20             	add    $0x20,%esp
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	0f 88 d0 02 00 00    	js     801b7e <spawn+0x4d4>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	68 00 00 40 00       	push   $0x400000
  8018b6:	6a 00                	push   $0x0
  8018b8:	e8 47 f4 ff ff       	call   800d04 <sys_page_unmap>
  8018bd:	89 c3                	mov    %eax,%ebx
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	0f 88 b4 02 00 00    	js     801b7e <spawn+0x4d4>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8018ca:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8018d0:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8018d7:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8018dd:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8018e4:	00 00 00 
  8018e7:	e9 56 01 00 00       	jmp    801a42 <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8018ec:	68 c0 29 80 00       	push   $0x8029c0
  8018f1:	68 1f 29 80 00       	push   $0x80291f
  8018f6:	68 f2 00 00 00       	push   $0xf2
  8018fb:	68 65 29 80 00       	push   $0x802965
  801900:	e8 87 e8 ff ff       	call   80018c <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801905:	83 ec 04             	sub    $0x4,%esp
  801908:	6a 07                	push   $0x7
  80190a:	68 00 00 40 00       	push   $0x400000
  80190f:	6a 00                	push   $0x0
  801911:	e8 69 f3 ff ff       	call   800c7f <sys_page_alloc>
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	85 c0                	test   %eax,%eax
  80191b:	0f 88 48 02 00 00    	js     801b69 <spawn+0x4bf>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801921:	83 ec 08             	sub    $0x8,%esp
  801924:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80192a:	01 f0                	add    %esi,%eax
  80192c:	50                   	push   %eax
  80192d:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801933:	e8 6f f9 ff ff       	call   8012a7 <seek>
  801938:	83 c4 10             	add    $0x10,%esp
  80193b:	85 c0                	test   %eax,%eax
  80193d:	0f 88 2d 02 00 00    	js     801b70 <spawn+0x4c6>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801943:	83 ec 04             	sub    $0x4,%esp
  801946:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80194c:	29 f0                	sub    %esi,%eax
  80194e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801953:	ba 00 10 00 00       	mov    $0x1000,%edx
  801958:	0f 47 c2             	cmova  %edx,%eax
  80195b:	50                   	push   %eax
  80195c:	68 00 00 40 00       	push   $0x400000
  801961:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801967:	e8 72 f8 ff ff       	call   8011de <readn>
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	85 c0                	test   %eax,%eax
  801971:	0f 88 00 02 00 00    	js     801b77 <spawn+0x4cd>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801977:	83 ec 0c             	sub    $0xc,%esp
  80197a:	57                   	push   %edi
  80197b:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801981:	56                   	push   %esi
  801982:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801988:	68 00 00 40 00       	push   $0x400000
  80198d:	6a 00                	push   $0x0
  80198f:	e8 2e f3 ff ff       	call   800cc2 <sys_page_map>
  801994:	83 c4 20             	add    $0x20,%esp
  801997:	85 c0                	test   %eax,%eax
  801999:	0f 88 80 00 00 00    	js     801a1f <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80199f:	83 ec 08             	sub    $0x8,%esp
  8019a2:	68 00 00 40 00       	push   $0x400000
  8019a7:	6a 00                	push   $0x0
  8019a9:	e8 56 f3 ff ff       	call   800d04 <sys_page_unmap>
  8019ae:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8019b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8019b7:	89 de                	mov    %ebx,%esi
  8019b9:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  8019bf:	76 73                	jbe    801a34 <spawn+0x38a>
		if (i >= filesz) {
  8019c1:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  8019c7:	0f 87 38 ff ff ff    	ja     801905 <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8019cd:	83 ec 04             	sub    $0x4,%esp
  8019d0:	57                   	push   %edi
  8019d1:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  8019d7:	56                   	push   %esi
  8019d8:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  8019de:	e8 9c f2 ff ff       	call   800c7f <sys_page_alloc>
  8019e3:	83 c4 10             	add    $0x10,%esp
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	79 c7                	jns    8019b1 <spawn+0x307>
  8019ea:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8019ec:	83 ec 0c             	sub    $0xc,%esp
  8019ef:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8019f5:	e8 06 f2 ff ff       	call   800c00 <sys_env_destroy>
	close(fd);
  8019fa:	83 c4 04             	add    $0x4,%esp
  8019fd:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801a03:	e8 13 f6 ff ff       	call   80101b <close>
	return r;
  801a08:	83 c4 10             	add    $0x10,%esp
  801a0b:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  801a11:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801a17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a1a:	5b                   	pop    %ebx
  801a1b:	5e                   	pop    %esi
  801a1c:	5f                   	pop    %edi
  801a1d:	5d                   	pop    %ebp
  801a1e:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801a1f:	50                   	push   %eax
  801a20:	68 71 29 80 00       	push   $0x802971
  801a25:	68 25 01 00 00       	push   $0x125
  801a2a:	68 65 29 80 00       	push   $0x802965
  801a2f:	e8 58 e7 ff ff       	call   80018c <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801a34:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801a3b:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801a42:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801a49:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801a4f:	7e 71                	jle    801ac2 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801a51:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  801a57:	83 39 01             	cmpl   $0x1,(%ecx)
  801a5a:	75 d8                	jne    801a34 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801a5c:	8b 41 18             	mov    0x18(%ecx),%eax
  801a5f:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801a62:	83 f8 01             	cmp    $0x1,%eax
  801a65:	19 ff                	sbb    %edi,%edi
  801a67:	83 e7 fe             	and    $0xfffffffe,%edi
  801a6a:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801a6d:	8b 59 04             	mov    0x4(%ecx),%ebx
  801a70:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
  801a76:	8b 71 10             	mov    0x10(%ecx),%esi
  801a79:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
  801a7f:	8b 41 14             	mov    0x14(%ecx),%eax
  801a82:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801a88:	8b 51 08             	mov    0x8(%ecx),%edx
  801a8b:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
	if ((i = PGOFF(va))) {
  801a91:	89 d0                	mov    %edx,%eax
  801a93:	25 ff 0f 00 00       	and    $0xfff,%eax
  801a98:	74 1e                	je     801ab8 <spawn+0x40e>
		va -= i;
  801a9a:	29 c2                	sub    %eax,%edx
  801a9c:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		memsz += i;
  801aa2:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801aa8:	01 c6                	add    %eax,%esi
  801aaa:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
		fileoffset -= i;
  801ab0:	29 c3                	sub    %eax,%ebx
  801ab2:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801ab8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801abd:	e9 f5 fe ff ff       	jmp    8019b7 <spawn+0x30d>
	close(fd);
  801ac2:	83 ec 0c             	sub    $0xc,%esp
  801ac5:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801acb:	e8 4b f5 ff ff       	call   80101b <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801ad0:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801ad7:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801ada:	83 c4 08             	add    $0x8,%esp
  801add:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801ae3:	50                   	push   %eax
  801ae4:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801aea:	e8 99 f2 ff ff       	call   800d88 <sys_env_set_trapframe>
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	85 c0                	test   %eax,%eax
  801af4:	78 28                	js     801b1e <spawn+0x474>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801af6:	83 ec 08             	sub    $0x8,%esp
  801af9:	6a 02                	push   $0x2
  801afb:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b01:	e8 40 f2 ff ff       	call   800d46 <sys_env_set_status>
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	78 26                	js     801b33 <spawn+0x489>
	return child;
  801b0d:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801b13:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801b19:	e9 f3 fe ff ff       	jmp    801a11 <spawn+0x367>
		panic("sys_env_set_trapframe: %e", r);
  801b1e:	50                   	push   %eax
  801b1f:	68 8e 29 80 00       	push   $0x80298e
  801b24:	68 86 00 00 00       	push   $0x86
  801b29:	68 65 29 80 00       	push   $0x802965
  801b2e:	e8 59 e6 ff ff       	call   80018c <_panic>
		panic("sys_env_set_status: %e", r);
  801b33:	50                   	push   %eax
  801b34:	68 a8 29 80 00       	push   $0x8029a8
  801b39:	68 89 00 00 00       	push   $0x89
  801b3e:	68 65 29 80 00       	push   $0x802965
  801b43:	e8 44 e6 ff ff       	call   80018c <_panic>
		return r;
  801b48:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801b4e:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801b54:	e9 b8 fe ff ff       	jmp    801a11 <spawn+0x367>
		return -E_NO_MEM;
  801b59:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801b5e:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801b64:	e9 a8 fe ff ff       	jmp    801a11 <spawn+0x367>
  801b69:	89 c7                	mov    %eax,%edi
  801b6b:	e9 7c fe ff ff       	jmp    8019ec <spawn+0x342>
  801b70:	89 c7                	mov    %eax,%edi
  801b72:	e9 75 fe ff ff       	jmp    8019ec <spawn+0x342>
  801b77:	89 c7                	mov    %eax,%edi
  801b79:	e9 6e fe ff ff       	jmp    8019ec <spawn+0x342>
	sys_page_unmap(0, UTEMP);
  801b7e:	83 ec 08             	sub    $0x8,%esp
  801b81:	68 00 00 40 00       	push   $0x400000
  801b86:	6a 00                	push   $0x0
  801b88:	e8 77 f1 ff ff       	call   800d04 <sys_page_unmap>
  801b8d:	83 c4 10             	add    $0x10,%esp
  801b90:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801b96:	e9 76 fe ff ff       	jmp    801a11 <spawn+0x367>

00801b9b <spawnl>:
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	57                   	push   %edi
  801b9f:	56                   	push   %esi
  801ba0:	53                   	push   %ebx
  801ba1:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801ba4:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801ba7:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801bac:	eb 05                	jmp    801bb3 <spawnl+0x18>
		argc++;
  801bae:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801bb1:	89 ca                	mov    %ecx,%edx
  801bb3:	8d 4a 04             	lea    0x4(%edx),%ecx
  801bb6:	83 3a 00             	cmpl   $0x0,(%edx)
  801bb9:	75 f3                	jne    801bae <spawnl+0x13>
	const char *argv[argc+2];
  801bbb:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801bc2:	83 e2 f0             	and    $0xfffffff0,%edx
  801bc5:	29 d4                	sub    %edx,%esp
  801bc7:	8d 54 24 03          	lea    0x3(%esp),%edx
  801bcb:	c1 ea 02             	shr    $0x2,%edx
  801bce:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801bd5:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801bd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bda:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801be1:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801be8:	00 
	va_start(vl, arg0);
  801be9:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801bec:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801bee:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf3:	eb 0b                	jmp    801c00 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801bf5:	83 c0 01             	add    $0x1,%eax
  801bf8:	8b 39                	mov    (%ecx),%edi
  801bfa:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801bfd:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801c00:	39 d0                	cmp    %edx,%eax
  801c02:	75 f1                	jne    801bf5 <spawnl+0x5a>
	return spawn(prog, argv);
  801c04:	83 ec 08             	sub    $0x8,%esp
  801c07:	56                   	push   %esi
  801c08:	ff 75 08             	pushl  0x8(%ebp)
  801c0b:	e8 9a fa ff ff       	call   8016aa <spawn>
}
  801c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c13:	5b                   	pop    %ebx
  801c14:	5e                   	pop    %esi
  801c15:	5f                   	pop    %edi
  801c16:	5d                   	pop    %ebp
  801c17:	c3                   	ret    

00801c18 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	56                   	push   %esi
  801c1c:	53                   	push   %ebx
  801c1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c20:	83 ec 0c             	sub    $0xc,%esp
  801c23:	ff 75 08             	pushl  0x8(%ebp)
  801c26:	e8 55 f2 ff ff       	call   800e80 <fd2data>
  801c2b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c2d:	83 c4 08             	add    $0x8,%esp
  801c30:	68 e8 29 80 00       	push   $0x8029e8
  801c35:	53                   	push   %ebx
  801c36:	e8 4b ec ff ff       	call   800886 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c3b:	8b 46 04             	mov    0x4(%esi),%eax
  801c3e:	2b 06                	sub    (%esi),%eax
  801c40:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c46:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c4d:	00 00 00 
	stat->st_dev = &devpipe;
  801c50:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c57:	30 80 00 
	return 0;
}
  801c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c62:	5b                   	pop    %ebx
  801c63:	5e                   	pop    %esi
  801c64:	5d                   	pop    %ebp
  801c65:	c3                   	ret    

00801c66 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	53                   	push   %ebx
  801c6a:	83 ec 0c             	sub    $0xc,%esp
  801c6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c70:	53                   	push   %ebx
  801c71:	6a 00                	push   $0x0
  801c73:	e8 8c f0 ff ff       	call   800d04 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c78:	89 1c 24             	mov    %ebx,(%esp)
  801c7b:	e8 00 f2 ff ff       	call   800e80 <fd2data>
  801c80:	83 c4 08             	add    $0x8,%esp
  801c83:	50                   	push   %eax
  801c84:	6a 00                	push   $0x0
  801c86:	e8 79 f0 ff ff       	call   800d04 <sys_page_unmap>
}
  801c8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <_pipeisclosed>:
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	57                   	push   %edi
  801c94:	56                   	push   %esi
  801c95:	53                   	push   %ebx
  801c96:	83 ec 1c             	sub    $0x1c,%esp
  801c99:	89 c7                	mov    %eax,%edi
  801c9b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c9d:	a1 04 40 80 00       	mov    0x804004,%eax
  801ca2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ca5:	83 ec 0c             	sub    $0xc,%esp
  801ca8:	57                   	push   %edi
  801ca9:	e8 2a 05 00 00       	call   8021d8 <pageref>
  801cae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cb1:	89 34 24             	mov    %esi,(%esp)
  801cb4:	e8 1f 05 00 00       	call   8021d8 <pageref>
		nn = thisenv->env_runs;
  801cb9:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cbf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cc2:	83 c4 10             	add    $0x10,%esp
  801cc5:	39 cb                	cmp    %ecx,%ebx
  801cc7:	74 1b                	je     801ce4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cc9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ccc:	75 cf                	jne    801c9d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cce:	8b 42 58             	mov    0x58(%edx),%eax
  801cd1:	6a 01                	push   $0x1
  801cd3:	50                   	push   %eax
  801cd4:	53                   	push   %ebx
  801cd5:	68 ef 29 80 00       	push   $0x8029ef
  801cda:	e8 88 e5 ff ff       	call   800267 <cprintf>
  801cdf:	83 c4 10             	add    $0x10,%esp
  801ce2:	eb b9                	jmp    801c9d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ce4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ce7:	0f 94 c0             	sete   %al
  801cea:	0f b6 c0             	movzbl %al,%eax
}
  801ced:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf0:	5b                   	pop    %ebx
  801cf1:	5e                   	pop    %esi
  801cf2:	5f                   	pop    %edi
  801cf3:	5d                   	pop    %ebp
  801cf4:	c3                   	ret    

00801cf5 <devpipe_write>:
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	57                   	push   %edi
  801cf9:	56                   	push   %esi
  801cfa:	53                   	push   %ebx
  801cfb:	83 ec 28             	sub    $0x28,%esp
  801cfe:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d01:	56                   	push   %esi
  801d02:	e8 79 f1 ff ff       	call   800e80 <fd2data>
  801d07:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d09:	83 c4 10             	add    $0x10,%esp
  801d0c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d11:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d14:	74 4f                	je     801d65 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d16:	8b 43 04             	mov    0x4(%ebx),%eax
  801d19:	8b 0b                	mov    (%ebx),%ecx
  801d1b:	8d 51 20             	lea    0x20(%ecx),%edx
  801d1e:	39 d0                	cmp    %edx,%eax
  801d20:	72 14                	jb     801d36 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d22:	89 da                	mov    %ebx,%edx
  801d24:	89 f0                	mov    %esi,%eax
  801d26:	e8 65 ff ff ff       	call   801c90 <_pipeisclosed>
  801d2b:	85 c0                	test   %eax,%eax
  801d2d:	75 3a                	jne    801d69 <devpipe_write+0x74>
			sys_yield();
  801d2f:	e8 2c ef ff ff       	call   800c60 <sys_yield>
  801d34:	eb e0                	jmp    801d16 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d39:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d3d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d40:	89 c2                	mov    %eax,%edx
  801d42:	c1 fa 1f             	sar    $0x1f,%edx
  801d45:	89 d1                	mov    %edx,%ecx
  801d47:	c1 e9 1b             	shr    $0x1b,%ecx
  801d4a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d4d:	83 e2 1f             	and    $0x1f,%edx
  801d50:	29 ca                	sub    %ecx,%edx
  801d52:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d56:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d5a:	83 c0 01             	add    $0x1,%eax
  801d5d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d60:	83 c7 01             	add    $0x1,%edi
  801d63:	eb ac                	jmp    801d11 <devpipe_write+0x1c>
	return i;
  801d65:	89 f8                	mov    %edi,%eax
  801d67:	eb 05                	jmp    801d6e <devpipe_write+0x79>
				return 0;
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d71:	5b                   	pop    %ebx
  801d72:	5e                   	pop    %esi
  801d73:	5f                   	pop    %edi
  801d74:	5d                   	pop    %ebp
  801d75:	c3                   	ret    

00801d76 <devpipe_read>:
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	57                   	push   %edi
  801d7a:	56                   	push   %esi
  801d7b:	53                   	push   %ebx
  801d7c:	83 ec 18             	sub    $0x18,%esp
  801d7f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d82:	57                   	push   %edi
  801d83:	e8 f8 f0 ff ff       	call   800e80 <fd2data>
  801d88:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	be 00 00 00 00       	mov    $0x0,%esi
  801d92:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d95:	74 47                	je     801dde <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801d97:	8b 03                	mov    (%ebx),%eax
  801d99:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d9c:	75 22                	jne    801dc0 <devpipe_read+0x4a>
			if (i > 0)
  801d9e:	85 f6                	test   %esi,%esi
  801da0:	75 14                	jne    801db6 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801da2:	89 da                	mov    %ebx,%edx
  801da4:	89 f8                	mov    %edi,%eax
  801da6:	e8 e5 fe ff ff       	call   801c90 <_pipeisclosed>
  801dab:	85 c0                	test   %eax,%eax
  801dad:	75 33                	jne    801de2 <devpipe_read+0x6c>
			sys_yield();
  801daf:	e8 ac ee ff ff       	call   800c60 <sys_yield>
  801db4:	eb e1                	jmp    801d97 <devpipe_read+0x21>
				return i;
  801db6:	89 f0                	mov    %esi,%eax
}
  801db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dbb:	5b                   	pop    %ebx
  801dbc:	5e                   	pop    %esi
  801dbd:	5f                   	pop    %edi
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dc0:	99                   	cltd   
  801dc1:	c1 ea 1b             	shr    $0x1b,%edx
  801dc4:	01 d0                	add    %edx,%eax
  801dc6:	83 e0 1f             	and    $0x1f,%eax
  801dc9:	29 d0                	sub    %edx,%eax
  801dcb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dd3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801dd6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801dd9:	83 c6 01             	add    $0x1,%esi
  801ddc:	eb b4                	jmp    801d92 <devpipe_read+0x1c>
	return i;
  801dde:	89 f0                	mov    %esi,%eax
  801de0:	eb d6                	jmp    801db8 <devpipe_read+0x42>
				return 0;
  801de2:	b8 00 00 00 00       	mov    $0x0,%eax
  801de7:	eb cf                	jmp    801db8 <devpipe_read+0x42>

00801de9 <pipe>:
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	56                   	push   %esi
  801ded:	53                   	push   %ebx
  801dee:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801df1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df4:	50                   	push   %eax
  801df5:	e8 9d f0 ff ff       	call   800e97 <fd_alloc>
  801dfa:	89 c3                	mov    %eax,%ebx
  801dfc:	83 c4 10             	add    $0x10,%esp
  801dff:	85 c0                	test   %eax,%eax
  801e01:	78 5b                	js     801e5e <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e03:	83 ec 04             	sub    $0x4,%esp
  801e06:	68 07 04 00 00       	push   $0x407
  801e0b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e0e:	6a 00                	push   $0x0
  801e10:	e8 6a ee ff ff       	call   800c7f <sys_page_alloc>
  801e15:	89 c3                	mov    %eax,%ebx
  801e17:	83 c4 10             	add    $0x10,%esp
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	78 40                	js     801e5e <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801e1e:	83 ec 0c             	sub    $0xc,%esp
  801e21:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e24:	50                   	push   %eax
  801e25:	e8 6d f0 ff ff       	call   800e97 <fd_alloc>
  801e2a:	89 c3                	mov    %eax,%ebx
  801e2c:	83 c4 10             	add    $0x10,%esp
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	78 1b                	js     801e4e <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e33:	83 ec 04             	sub    $0x4,%esp
  801e36:	68 07 04 00 00       	push   $0x407
  801e3b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e3e:	6a 00                	push   $0x0
  801e40:	e8 3a ee ff ff       	call   800c7f <sys_page_alloc>
  801e45:	89 c3                	mov    %eax,%ebx
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	79 19                	jns    801e67 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801e4e:	83 ec 08             	sub    $0x8,%esp
  801e51:	ff 75 f4             	pushl  -0xc(%ebp)
  801e54:	6a 00                	push   $0x0
  801e56:	e8 a9 ee ff ff       	call   800d04 <sys_page_unmap>
  801e5b:	83 c4 10             	add    $0x10,%esp
}
  801e5e:	89 d8                	mov    %ebx,%eax
  801e60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e63:	5b                   	pop    %ebx
  801e64:	5e                   	pop    %esi
  801e65:	5d                   	pop    %ebp
  801e66:	c3                   	ret    
	va = fd2data(fd0);
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6d:	e8 0e f0 ff ff       	call   800e80 <fd2data>
  801e72:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e74:	83 c4 0c             	add    $0xc,%esp
  801e77:	68 07 04 00 00       	push   $0x407
  801e7c:	50                   	push   %eax
  801e7d:	6a 00                	push   $0x0
  801e7f:	e8 fb ed ff ff       	call   800c7f <sys_page_alloc>
  801e84:	89 c3                	mov    %eax,%ebx
  801e86:	83 c4 10             	add    $0x10,%esp
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	0f 88 8c 00 00 00    	js     801f1d <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e91:	83 ec 0c             	sub    $0xc,%esp
  801e94:	ff 75 f0             	pushl  -0x10(%ebp)
  801e97:	e8 e4 ef ff ff       	call   800e80 <fd2data>
  801e9c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ea3:	50                   	push   %eax
  801ea4:	6a 00                	push   $0x0
  801ea6:	56                   	push   %esi
  801ea7:	6a 00                	push   $0x0
  801ea9:	e8 14 ee ff ff       	call   800cc2 <sys_page_map>
  801eae:	89 c3                	mov    %eax,%ebx
  801eb0:	83 c4 20             	add    $0x20,%esp
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	78 58                	js     801f0f <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eba:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ec0:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecf:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ed5:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eda:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ee1:	83 ec 0c             	sub    $0xc,%esp
  801ee4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee7:	e8 84 ef ff ff       	call   800e70 <fd2num>
  801eec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eef:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ef1:	83 c4 04             	add    $0x4,%esp
  801ef4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef7:	e8 74 ef ff ff       	call   800e70 <fd2num>
  801efc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eff:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f02:	83 c4 10             	add    $0x10,%esp
  801f05:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f0a:	e9 4f ff ff ff       	jmp    801e5e <pipe+0x75>
	sys_page_unmap(0, va);
  801f0f:	83 ec 08             	sub    $0x8,%esp
  801f12:	56                   	push   %esi
  801f13:	6a 00                	push   $0x0
  801f15:	e8 ea ed ff ff       	call   800d04 <sys_page_unmap>
  801f1a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f1d:	83 ec 08             	sub    $0x8,%esp
  801f20:	ff 75 f0             	pushl  -0x10(%ebp)
  801f23:	6a 00                	push   $0x0
  801f25:	e8 da ed ff ff       	call   800d04 <sys_page_unmap>
  801f2a:	83 c4 10             	add    $0x10,%esp
  801f2d:	e9 1c ff ff ff       	jmp    801e4e <pipe+0x65>

00801f32 <pipeisclosed>:
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f3b:	50                   	push   %eax
  801f3c:	ff 75 08             	pushl  0x8(%ebp)
  801f3f:	e8 a2 ef ff ff       	call   800ee6 <fd_lookup>
  801f44:	83 c4 10             	add    $0x10,%esp
  801f47:	85 c0                	test   %eax,%eax
  801f49:	78 18                	js     801f63 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f4b:	83 ec 0c             	sub    $0xc,%esp
  801f4e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f51:	e8 2a ef ff ff       	call   800e80 <fd2data>
	return _pipeisclosed(fd, p);
  801f56:	89 c2                	mov    %eax,%edx
  801f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5b:	e8 30 fd ff ff       	call   801c90 <_pipeisclosed>
  801f60:	83 c4 10             	add    $0x10,%esp
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f68:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6d:	5d                   	pop    %ebp
  801f6e:	c3                   	ret    

00801f6f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f75:	68 07 2a 80 00       	push   $0x802a07
  801f7a:	ff 75 0c             	pushl  0xc(%ebp)
  801f7d:	e8 04 e9 ff ff       	call   800886 <strcpy>
	return 0;
}
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <devcons_write>:
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	57                   	push   %edi
  801f8d:	56                   	push   %esi
  801f8e:	53                   	push   %ebx
  801f8f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f95:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f9a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fa0:	eb 2f                	jmp    801fd1 <devcons_write+0x48>
		m = n - tot;
  801fa2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fa5:	29 f3                	sub    %esi,%ebx
  801fa7:	83 fb 7f             	cmp    $0x7f,%ebx
  801faa:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801faf:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fb2:	83 ec 04             	sub    $0x4,%esp
  801fb5:	53                   	push   %ebx
  801fb6:	89 f0                	mov    %esi,%eax
  801fb8:	03 45 0c             	add    0xc(%ebp),%eax
  801fbb:	50                   	push   %eax
  801fbc:	57                   	push   %edi
  801fbd:	e8 52 ea ff ff       	call   800a14 <memmove>
		sys_cputs(buf, m);
  801fc2:	83 c4 08             	add    $0x8,%esp
  801fc5:	53                   	push   %ebx
  801fc6:	57                   	push   %edi
  801fc7:	e8 f7 eb ff ff       	call   800bc3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fcc:	01 de                	add    %ebx,%esi
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fd4:	72 cc                	jb     801fa2 <devcons_write+0x19>
}
  801fd6:	89 f0                	mov    %esi,%eax
  801fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5f                   	pop    %edi
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    

00801fe0 <devcons_read>:
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 08             	sub    $0x8,%esp
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801feb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fef:	75 07                	jne    801ff8 <devcons_read+0x18>
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    
		sys_yield();
  801ff3:	e8 68 ec ff ff       	call   800c60 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801ff8:	e8 e4 eb ff ff       	call   800be1 <sys_cgetc>
  801ffd:	85 c0                	test   %eax,%eax
  801fff:	74 f2                	je     801ff3 <devcons_read+0x13>
	if (c < 0)
  802001:	85 c0                	test   %eax,%eax
  802003:	78 ec                	js     801ff1 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802005:	83 f8 04             	cmp    $0x4,%eax
  802008:	74 0c                	je     802016 <devcons_read+0x36>
	*(char*)vbuf = c;
  80200a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200d:	88 02                	mov    %al,(%edx)
	return 1;
  80200f:	b8 01 00 00 00       	mov    $0x1,%eax
  802014:	eb db                	jmp    801ff1 <devcons_read+0x11>
		return 0;
  802016:	b8 00 00 00 00       	mov    $0x0,%eax
  80201b:	eb d4                	jmp    801ff1 <devcons_read+0x11>

0080201d <cputchar>:
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802029:	6a 01                	push   $0x1
  80202b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80202e:	50                   	push   %eax
  80202f:	e8 8f eb ff ff       	call   800bc3 <sys_cputs>
}
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <getchar>:
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80203f:	6a 01                	push   $0x1
  802041:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802044:	50                   	push   %eax
  802045:	6a 00                	push   $0x0
  802047:	e8 0b f1 ff ff       	call   801157 <read>
	if (r < 0)
  80204c:	83 c4 10             	add    $0x10,%esp
  80204f:	85 c0                	test   %eax,%eax
  802051:	78 08                	js     80205b <getchar+0x22>
	if (r < 1)
  802053:	85 c0                	test   %eax,%eax
  802055:	7e 06                	jle    80205d <getchar+0x24>
	return c;
  802057:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    
		return -E_EOF;
  80205d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802062:	eb f7                	jmp    80205b <getchar+0x22>

00802064 <iscons>:
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80206a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80206d:	50                   	push   %eax
  80206e:	ff 75 08             	pushl  0x8(%ebp)
  802071:	e8 70 ee ff ff       	call   800ee6 <fd_lookup>
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	85 c0                	test   %eax,%eax
  80207b:	78 11                	js     80208e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80207d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802080:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802086:	39 10                	cmp    %edx,(%eax)
  802088:	0f 94 c0             	sete   %al
  80208b:	0f b6 c0             	movzbl %al,%eax
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <opencons>:
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802096:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802099:	50                   	push   %eax
  80209a:	e8 f8 ed ff ff       	call   800e97 <fd_alloc>
  80209f:	83 c4 10             	add    $0x10,%esp
  8020a2:	85 c0                	test   %eax,%eax
  8020a4:	78 3a                	js     8020e0 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020a6:	83 ec 04             	sub    $0x4,%esp
  8020a9:	68 07 04 00 00       	push   $0x407
  8020ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b1:	6a 00                	push   $0x0
  8020b3:	e8 c7 eb ff ff       	call   800c7f <sys_page_alloc>
  8020b8:	83 c4 10             	add    $0x10,%esp
  8020bb:	85 c0                	test   %eax,%eax
  8020bd:	78 21                	js     8020e0 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020c8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020d4:	83 ec 0c             	sub    $0xc,%esp
  8020d7:	50                   	push   %eax
  8020d8:	e8 93 ed ff ff       	call   800e70 <fd2num>
  8020dd:	83 c4 10             	add    $0x10,%esp
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	56                   	push   %esi
  8020e6:	53                   	push   %ebx
  8020e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8020ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  8020f0:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  8020f2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8020f7:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  8020fa:	83 ec 0c             	sub    $0xc,%esp
  8020fd:	50                   	push   %eax
  8020fe:	e8 2c ed ff ff       	call   800e2f <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	85 c0                	test   %eax,%eax
  802108:	78 2b                	js     802135 <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  80210a:	85 f6                	test   %esi,%esi
  80210c:	74 0a                	je     802118 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80210e:	a1 04 40 80 00       	mov    0x804004,%eax
  802113:	8b 40 74             	mov    0x74(%eax),%eax
  802116:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  802118:	85 db                	test   %ebx,%ebx
  80211a:	74 0a                	je     802126 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80211c:	a1 04 40 80 00       	mov    0x804004,%eax
  802121:	8b 40 78             	mov    0x78(%eax),%eax
  802124:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802126:	a1 04 40 80 00       	mov    0x804004,%eax
  80212b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80212e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802131:	5b                   	pop    %ebx
  802132:	5e                   	pop    %esi
  802133:	5d                   	pop    %ebp
  802134:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802135:	85 f6                	test   %esi,%esi
  802137:	74 06                	je     80213f <ipc_recv+0x5d>
  802139:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  80213f:	85 db                	test   %ebx,%ebx
  802141:	74 eb                	je     80212e <ipc_recv+0x4c>
  802143:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802149:	eb e3                	jmp    80212e <ipc_recv+0x4c>

0080214b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	57                   	push   %edi
  80214f:	56                   	push   %esi
  802150:	53                   	push   %ebx
  802151:	83 ec 0c             	sub    $0xc,%esp
  802154:	8b 7d 08             	mov    0x8(%ebp),%edi
  802157:	8b 75 0c             	mov    0xc(%ebp),%esi
  80215a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  80215d:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  80215f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802164:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  802167:	ff 75 14             	pushl  0x14(%ebp)
  80216a:	53                   	push   %ebx
  80216b:	56                   	push   %esi
  80216c:	57                   	push   %edi
  80216d:	e8 9a ec ff ff       	call   800e0c <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  802172:	83 c4 10             	add    $0x10,%esp
  802175:	85 c0                	test   %eax,%eax
  802177:	74 1e                	je     802197 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  802179:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80217c:	75 07                	jne    802185 <ipc_send+0x3a>
			sys_yield();
  80217e:	e8 dd ea ff ff       	call   800c60 <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  802183:	eb e2                	jmp    802167 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  802185:	50                   	push   %eax
  802186:	68 13 2a 80 00       	push   $0x802a13
  80218b:	6a 41                	push   $0x41
  80218d:	68 21 2a 80 00       	push   $0x802a21
  802192:	e8 f5 df ff ff       	call   80018c <_panic>
		}
	}
}
  802197:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80219a:	5b                   	pop    %ebx
  80219b:	5e                   	pop    %esi
  80219c:	5f                   	pop    %edi
  80219d:	5d                   	pop    %ebp
  80219e:	c3                   	ret    

0080219f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021a5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021aa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021ad:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021b3:	8b 52 50             	mov    0x50(%edx),%edx
  8021b6:	39 ca                	cmp    %ecx,%edx
  8021b8:	74 11                	je     8021cb <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8021ba:	83 c0 01             	add    $0x1,%eax
  8021bd:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021c2:	75 e6                	jne    8021aa <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8021c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c9:	eb 0b                	jmp    8021d6 <ipc_find_env+0x37>
			return envs[i].env_id;
  8021cb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021ce:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021d3:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021d6:	5d                   	pop    %ebp
  8021d7:	c3                   	ret    

008021d8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021de:	89 d0                	mov    %edx,%eax
  8021e0:	c1 e8 16             	shr    $0x16,%eax
  8021e3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8021ea:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8021ef:	f6 c1 01             	test   $0x1,%cl
  8021f2:	74 1d                	je     802211 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8021f4:	c1 ea 0c             	shr    $0xc,%edx
  8021f7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8021fe:	f6 c2 01             	test   $0x1,%dl
  802201:	74 0e                	je     802211 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802203:	c1 ea 0c             	shr    $0xc,%edx
  802206:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80220d:	ef 
  80220e:	0f b7 c0             	movzwl %ax,%eax
}
  802211:	5d                   	pop    %ebp
  802212:	c3                   	ret    
  802213:	66 90                	xchg   %ax,%ax
  802215:	66 90                	xchg   %ax,%ax
  802217:	66 90                	xchg   %ax,%ax
  802219:	66 90                	xchg   %ax,%ax
  80221b:	66 90                	xchg   %ax,%ax
  80221d:	66 90                	xchg   %ax,%ax
  80221f:	90                   	nop

00802220 <__udivdi3>:
  802220:	55                   	push   %ebp
  802221:	57                   	push   %edi
  802222:	56                   	push   %esi
  802223:	53                   	push   %ebx
  802224:	83 ec 1c             	sub    $0x1c,%esp
  802227:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80222b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80222f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802233:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802237:	85 d2                	test   %edx,%edx
  802239:	75 35                	jne    802270 <__udivdi3+0x50>
  80223b:	39 f3                	cmp    %esi,%ebx
  80223d:	0f 87 bd 00 00 00    	ja     802300 <__udivdi3+0xe0>
  802243:	85 db                	test   %ebx,%ebx
  802245:	89 d9                	mov    %ebx,%ecx
  802247:	75 0b                	jne    802254 <__udivdi3+0x34>
  802249:	b8 01 00 00 00       	mov    $0x1,%eax
  80224e:	31 d2                	xor    %edx,%edx
  802250:	f7 f3                	div    %ebx
  802252:	89 c1                	mov    %eax,%ecx
  802254:	31 d2                	xor    %edx,%edx
  802256:	89 f0                	mov    %esi,%eax
  802258:	f7 f1                	div    %ecx
  80225a:	89 c6                	mov    %eax,%esi
  80225c:	89 e8                	mov    %ebp,%eax
  80225e:	89 f7                	mov    %esi,%edi
  802260:	f7 f1                	div    %ecx
  802262:	89 fa                	mov    %edi,%edx
  802264:	83 c4 1c             	add    $0x1c,%esp
  802267:	5b                   	pop    %ebx
  802268:	5e                   	pop    %esi
  802269:	5f                   	pop    %edi
  80226a:	5d                   	pop    %ebp
  80226b:	c3                   	ret    
  80226c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802270:	39 f2                	cmp    %esi,%edx
  802272:	77 7c                	ja     8022f0 <__udivdi3+0xd0>
  802274:	0f bd fa             	bsr    %edx,%edi
  802277:	83 f7 1f             	xor    $0x1f,%edi
  80227a:	0f 84 98 00 00 00    	je     802318 <__udivdi3+0xf8>
  802280:	89 f9                	mov    %edi,%ecx
  802282:	b8 20 00 00 00       	mov    $0x20,%eax
  802287:	29 f8                	sub    %edi,%eax
  802289:	d3 e2                	shl    %cl,%edx
  80228b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80228f:	89 c1                	mov    %eax,%ecx
  802291:	89 da                	mov    %ebx,%edx
  802293:	d3 ea                	shr    %cl,%edx
  802295:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802299:	09 d1                	or     %edx,%ecx
  80229b:	89 f2                	mov    %esi,%edx
  80229d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022a1:	89 f9                	mov    %edi,%ecx
  8022a3:	d3 e3                	shl    %cl,%ebx
  8022a5:	89 c1                	mov    %eax,%ecx
  8022a7:	d3 ea                	shr    %cl,%edx
  8022a9:	89 f9                	mov    %edi,%ecx
  8022ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022af:	d3 e6                	shl    %cl,%esi
  8022b1:	89 eb                	mov    %ebp,%ebx
  8022b3:	89 c1                	mov    %eax,%ecx
  8022b5:	d3 eb                	shr    %cl,%ebx
  8022b7:	09 de                	or     %ebx,%esi
  8022b9:	89 f0                	mov    %esi,%eax
  8022bb:	f7 74 24 08          	divl   0x8(%esp)
  8022bf:	89 d6                	mov    %edx,%esi
  8022c1:	89 c3                	mov    %eax,%ebx
  8022c3:	f7 64 24 0c          	mull   0xc(%esp)
  8022c7:	39 d6                	cmp    %edx,%esi
  8022c9:	72 0c                	jb     8022d7 <__udivdi3+0xb7>
  8022cb:	89 f9                	mov    %edi,%ecx
  8022cd:	d3 e5                	shl    %cl,%ebp
  8022cf:	39 c5                	cmp    %eax,%ebp
  8022d1:	73 5d                	jae    802330 <__udivdi3+0x110>
  8022d3:	39 d6                	cmp    %edx,%esi
  8022d5:	75 59                	jne    802330 <__udivdi3+0x110>
  8022d7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022da:	31 ff                	xor    %edi,%edi
  8022dc:	89 fa                	mov    %edi,%edx
  8022de:	83 c4 1c             	add    $0x1c,%esp
  8022e1:	5b                   	pop    %ebx
  8022e2:	5e                   	pop    %esi
  8022e3:	5f                   	pop    %edi
  8022e4:	5d                   	pop    %ebp
  8022e5:	c3                   	ret    
  8022e6:	8d 76 00             	lea    0x0(%esi),%esi
  8022e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8022f0:	31 ff                	xor    %edi,%edi
  8022f2:	31 c0                	xor    %eax,%eax
  8022f4:	89 fa                	mov    %edi,%edx
  8022f6:	83 c4 1c             	add    $0x1c,%esp
  8022f9:	5b                   	pop    %ebx
  8022fa:	5e                   	pop    %esi
  8022fb:	5f                   	pop    %edi
  8022fc:	5d                   	pop    %ebp
  8022fd:	c3                   	ret    
  8022fe:	66 90                	xchg   %ax,%ax
  802300:	31 ff                	xor    %edi,%edi
  802302:	89 e8                	mov    %ebp,%eax
  802304:	89 f2                	mov    %esi,%edx
  802306:	f7 f3                	div    %ebx
  802308:	89 fa                	mov    %edi,%edx
  80230a:	83 c4 1c             	add    $0x1c,%esp
  80230d:	5b                   	pop    %ebx
  80230e:	5e                   	pop    %esi
  80230f:	5f                   	pop    %edi
  802310:	5d                   	pop    %ebp
  802311:	c3                   	ret    
  802312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802318:	39 f2                	cmp    %esi,%edx
  80231a:	72 06                	jb     802322 <__udivdi3+0x102>
  80231c:	31 c0                	xor    %eax,%eax
  80231e:	39 eb                	cmp    %ebp,%ebx
  802320:	77 d2                	ja     8022f4 <__udivdi3+0xd4>
  802322:	b8 01 00 00 00       	mov    $0x1,%eax
  802327:	eb cb                	jmp    8022f4 <__udivdi3+0xd4>
  802329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802330:	89 d8                	mov    %ebx,%eax
  802332:	31 ff                	xor    %edi,%edi
  802334:	eb be                	jmp    8022f4 <__udivdi3+0xd4>
  802336:	66 90                	xchg   %ax,%ax
  802338:	66 90                	xchg   %ax,%ax
  80233a:	66 90                	xchg   %ax,%ax
  80233c:	66 90                	xchg   %ax,%ax
  80233e:	66 90                	xchg   %ax,%ax

00802340 <__umoddi3>:
  802340:	55                   	push   %ebp
  802341:	57                   	push   %edi
  802342:	56                   	push   %esi
  802343:	53                   	push   %ebx
  802344:	83 ec 1c             	sub    $0x1c,%esp
  802347:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80234b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80234f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802353:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802357:	85 ed                	test   %ebp,%ebp
  802359:	89 f0                	mov    %esi,%eax
  80235b:	89 da                	mov    %ebx,%edx
  80235d:	75 19                	jne    802378 <__umoddi3+0x38>
  80235f:	39 df                	cmp    %ebx,%edi
  802361:	0f 86 b1 00 00 00    	jbe    802418 <__umoddi3+0xd8>
  802367:	f7 f7                	div    %edi
  802369:	89 d0                	mov    %edx,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	83 c4 1c             	add    $0x1c,%esp
  802370:	5b                   	pop    %ebx
  802371:	5e                   	pop    %esi
  802372:	5f                   	pop    %edi
  802373:	5d                   	pop    %ebp
  802374:	c3                   	ret    
  802375:	8d 76 00             	lea    0x0(%esi),%esi
  802378:	39 dd                	cmp    %ebx,%ebp
  80237a:	77 f1                	ja     80236d <__umoddi3+0x2d>
  80237c:	0f bd cd             	bsr    %ebp,%ecx
  80237f:	83 f1 1f             	xor    $0x1f,%ecx
  802382:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802386:	0f 84 b4 00 00 00    	je     802440 <__umoddi3+0x100>
  80238c:	b8 20 00 00 00       	mov    $0x20,%eax
  802391:	89 c2                	mov    %eax,%edx
  802393:	8b 44 24 04          	mov    0x4(%esp),%eax
  802397:	29 c2                	sub    %eax,%edx
  802399:	89 c1                	mov    %eax,%ecx
  80239b:	89 f8                	mov    %edi,%eax
  80239d:	d3 e5                	shl    %cl,%ebp
  80239f:	89 d1                	mov    %edx,%ecx
  8023a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8023a5:	d3 e8                	shr    %cl,%eax
  8023a7:	09 c5                	or     %eax,%ebp
  8023a9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023ad:	89 c1                	mov    %eax,%ecx
  8023af:	d3 e7                	shl    %cl,%edi
  8023b1:	89 d1                	mov    %edx,%ecx
  8023b3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8023b7:	89 df                	mov    %ebx,%edi
  8023b9:	d3 ef                	shr    %cl,%edi
  8023bb:	89 c1                	mov    %eax,%ecx
  8023bd:	89 f0                	mov    %esi,%eax
  8023bf:	d3 e3                	shl    %cl,%ebx
  8023c1:	89 d1                	mov    %edx,%ecx
  8023c3:	89 fa                	mov    %edi,%edx
  8023c5:	d3 e8                	shr    %cl,%eax
  8023c7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023cc:	09 d8                	or     %ebx,%eax
  8023ce:	f7 f5                	div    %ebp
  8023d0:	d3 e6                	shl    %cl,%esi
  8023d2:	89 d1                	mov    %edx,%ecx
  8023d4:	f7 64 24 08          	mull   0x8(%esp)
  8023d8:	39 d1                	cmp    %edx,%ecx
  8023da:	89 c3                	mov    %eax,%ebx
  8023dc:	89 d7                	mov    %edx,%edi
  8023de:	72 06                	jb     8023e6 <__umoddi3+0xa6>
  8023e0:	75 0e                	jne    8023f0 <__umoddi3+0xb0>
  8023e2:	39 c6                	cmp    %eax,%esi
  8023e4:	73 0a                	jae    8023f0 <__umoddi3+0xb0>
  8023e6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8023ea:	19 ea                	sbb    %ebp,%edx
  8023ec:	89 d7                	mov    %edx,%edi
  8023ee:	89 c3                	mov    %eax,%ebx
  8023f0:	89 ca                	mov    %ecx,%edx
  8023f2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8023f7:	29 de                	sub    %ebx,%esi
  8023f9:	19 fa                	sbb    %edi,%edx
  8023fb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8023ff:	89 d0                	mov    %edx,%eax
  802401:	d3 e0                	shl    %cl,%eax
  802403:	89 d9                	mov    %ebx,%ecx
  802405:	d3 ee                	shr    %cl,%esi
  802407:	d3 ea                	shr    %cl,%edx
  802409:	09 f0                	or     %esi,%eax
  80240b:	83 c4 1c             	add    $0x1c,%esp
  80240e:	5b                   	pop    %ebx
  80240f:	5e                   	pop    %esi
  802410:	5f                   	pop    %edi
  802411:	5d                   	pop    %ebp
  802412:	c3                   	ret    
  802413:	90                   	nop
  802414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802418:	85 ff                	test   %edi,%edi
  80241a:	89 f9                	mov    %edi,%ecx
  80241c:	75 0b                	jne    802429 <__umoddi3+0xe9>
  80241e:	b8 01 00 00 00       	mov    $0x1,%eax
  802423:	31 d2                	xor    %edx,%edx
  802425:	f7 f7                	div    %edi
  802427:	89 c1                	mov    %eax,%ecx
  802429:	89 d8                	mov    %ebx,%eax
  80242b:	31 d2                	xor    %edx,%edx
  80242d:	f7 f1                	div    %ecx
  80242f:	89 f0                	mov    %esi,%eax
  802431:	f7 f1                	div    %ecx
  802433:	e9 31 ff ff ff       	jmp    802369 <__umoddi3+0x29>
  802438:	90                   	nop
  802439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802440:	39 dd                	cmp    %ebx,%ebp
  802442:	72 08                	jb     80244c <__umoddi3+0x10c>
  802444:	39 f7                	cmp    %esi,%edi
  802446:	0f 87 21 ff ff ff    	ja     80236d <__umoddi3+0x2d>
  80244c:	89 da                	mov    %ebx,%edx
  80244e:	89 f0                	mov    %esi,%eax
  802450:	29 f8                	sub    %edi,%eax
  802452:	19 ea                	sbb    %ebp,%edx
  802454:	e9 14 ff ff ff       	jmp    80236d <__umoddi3+0x2d>
