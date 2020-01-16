
obj/user/spawnhello.debug：     文件格式 elf32-i386


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
  80002c:	e8 4a 00 00 00       	call   80007b <libmain>
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
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 04 40 80 00       	mov    0x804004,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	50                   	push   %eax
  800042:	68 a0 23 80 00       	push   $0x8023a0
  800047:	e8 62 01 00 00       	call   8001ae <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 be 23 80 00       	push   $0x8023be
  800056:	68 be 23 80 00       	push   $0x8023be
  80005b:	e8 48 12 00 00       	call   8012a8 <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	78 02                	js     800069 <umain+0x36>
		panic("spawn(hello) failed: %e", r);
}
  800067:	c9                   	leave  
  800068:	c3                   	ret    
		panic("spawn(hello) failed: %e", r);
  800069:	50                   	push   %eax
  80006a:	68 c4 23 80 00       	push   $0x8023c4
  80006f:	6a 09                	push   $0x9
  800071:	68 dc 23 80 00       	push   $0x8023dc
  800076:	e8 58 00 00 00       	call   8000d3 <_panic>

0080007b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800083:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  800086:	e8 fd 0a 00 00       	call   800b88 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  80008b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800090:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800093:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800098:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009d:	85 db                	test   %ebx,%ebx
  80009f:	7e 07                	jle    8000a8 <libmain+0x2d>
		binaryname = argv[0];
  8000a1:	8b 06                	mov    (%esi),%eax
  8000a3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000a8:	83 ec 08             	sub    $0x8,%esp
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
  8000ad:	e8 81 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b2:	e8 0a 00 00 00       	call   8000c1 <exit>
}
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bd:	5b                   	pop    %ebx
  8000be:	5e                   	pop    %esi
  8000bf:	5d                   	pop    %ebp
  8000c0:	c3                   	ret    

008000c1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000c7:	6a 00                	push   $0x0
  8000c9:	e8 79 0a 00 00       	call   800b47 <sys_env_destroy>
}
  8000ce:	83 c4 10             	add    $0x10,%esp
  8000d1:	c9                   	leave  
  8000d2:	c3                   	ret    

008000d3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	56                   	push   %esi
  8000d7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8000d8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8000db:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8000e1:	e8 a2 0a 00 00       	call   800b88 <sys_getenvid>
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 0c             	pushl  0xc(%ebp)
  8000ec:	ff 75 08             	pushl  0x8(%ebp)
  8000ef:	56                   	push   %esi
  8000f0:	50                   	push   %eax
  8000f1:	68 f8 23 80 00       	push   $0x8023f8
  8000f6:	e8 b3 00 00 00       	call   8001ae <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8000fb:	83 c4 18             	add    $0x18,%esp
  8000fe:	53                   	push   %ebx
  8000ff:	ff 75 10             	pushl  0x10(%ebp)
  800102:	e8 56 00 00 00       	call   80015d <vcprintf>
	cprintf("\n");
  800107:	c7 04 24 c2 28 80 00 	movl   $0x8028c2,(%esp)
  80010e:	e8 9b 00 00 00       	call   8001ae <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800116:	cc                   	int3   
  800117:	eb fd                	jmp    800116 <_panic+0x43>

00800119 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	53                   	push   %ebx
  80011d:	83 ec 04             	sub    $0x4,%esp
  800120:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800123:	8b 13                	mov    (%ebx),%edx
  800125:	8d 42 01             	lea    0x1(%edx),%eax
  800128:	89 03                	mov    %eax,(%ebx)
  80012a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800131:	3d ff 00 00 00       	cmp    $0xff,%eax
  800136:	74 09                	je     800141 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800138:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013f:	c9                   	leave  
  800140:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800141:	83 ec 08             	sub    $0x8,%esp
  800144:	68 ff 00 00 00       	push   $0xff
  800149:	8d 43 08             	lea    0x8(%ebx),%eax
  80014c:	50                   	push   %eax
  80014d:	e8 b8 09 00 00       	call   800b0a <sys_cputs>
		b->idx = 0;
  800152:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800158:	83 c4 10             	add    $0x10,%esp
  80015b:	eb db                	jmp    800138 <putch+0x1f>

0080015d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015d:	55                   	push   %ebp
  80015e:	89 e5                	mov    %esp,%ebp
  800160:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800166:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016d:	00 00 00 
	b.cnt = 0;
  800170:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800177:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80017a:	ff 75 0c             	pushl  0xc(%ebp)
  80017d:	ff 75 08             	pushl  0x8(%ebp)
  800180:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800186:	50                   	push   %eax
  800187:	68 19 01 80 00       	push   $0x800119
  80018c:	e8 1a 01 00 00       	call   8002ab <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800191:	83 c4 08             	add    $0x8,%esp
  800194:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80019a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a0:	50                   	push   %eax
  8001a1:	e8 64 09 00 00       	call   800b0a <sys_cputs>

	return b.cnt;
}
  8001a6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ac:	c9                   	leave  
  8001ad:	c3                   	ret    

008001ae <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ae:	55                   	push   %ebp
  8001af:	89 e5                	mov    %esp,%ebp
  8001b1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b7:	50                   	push   %eax
  8001b8:	ff 75 08             	pushl  0x8(%ebp)
  8001bb:	e8 9d ff ff ff       	call   80015d <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    

008001c2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	57                   	push   %edi
  8001c6:	56                   	push   %esi
  8001c7:	53                   	push   %ebx
  8001c8:	83 ec 1c             	sub    $0x1c,%esp
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 d6                	mov    %edx,%esi
  8001cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001e6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001e9:	39 d3                	cmp    %edx,%ebx
  8001eb:	72 05                	jb     8001f2 <printnum+0x30>
  8001ed:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001f0:	77 7a                	ja     80026c <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f2:	83 ec 0c             	sub    $0xc,%esp
  8001f5:	ff 75 18             	pushl  0x18(%ebp)
  8001f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8001fb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001fe:	53                   	push   %ebx
  8001ff:	ff 75 10             	pushl  0x10(%ebp)
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	ff 75 e4             	pushl  -0x1c(%ebp)
  800208:	ff 75 e0             	pushl  -0x20(%ebp)
  80020b:	ff 75 dc             	pushl  -0x24(%ebp)
  80020e:	ff 75 d8             	pushl  -0x28(%ebp)
  800211:	e8 4a 1f 00 00       	call   802160 <__udivdi3>
  800216:	83 c4 18             	add    $0x18,%esp
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	89 f2                	mov    %esi,%edx
  80021d:	89 f8                	mov    %edi,%eax
  80021f:	e8 9e ff ff ff       	call   8001c2 <printnum>
  800224:	83 c4 20             	add    $0x20,%esp
  800227:	eb 13                	jmp    80023c <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	56                   	push   %esi
  80022d:	ff 75 18             	pushl  0x18(%ebp)
  800230:	ff d7                	call   *%edi
  800232:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800235:	83 eb 01             	sub    $0x1,%ebx
  800238:	85 db                	test   %ebx,%ebx
  80023a:	7f ed                	jg     800229 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023c:	83 ec 08             	sub    $0x8,%esp
  80023f:	56                   	push   %esi
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	ff 75 e4             	pushl  -0x1c(%ebp)
  800246:	ff 75 e0             	pushl  -0x20(%ebp)
  800249:	ff 75 dc             	pushl  -0x24(%ebp)
  80024c:	ff 75 d8             	pushl  -0x28(%ebp)
  80024f:	e8 2c 20 00 00       	call   802280 <__umoddi3>
  800254:	83 c4 14             	add    $0x14,%esp
  800257:	0f be 80 1b 24 80 00 	movsbl 0x80241b(%eax),%eax
  80025e:	50                   	push   %eax
  80025f:	ff d7                	call   *%edi
}
  800261:	83 c4 10             	add    $0x10,%esp
  800264:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800267:	5b                   	pop    %ebx
  800268:	5e                   	pop    %esi
  800269:	5f                   	pop    %edi
  80026a:	5d                   	pop    %ebp
  80026b:	c3                   	ret    
  80026c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80026f:	eb c4                	jmp    800235 <printnum+0x73>

00800271 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800277:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80027b:	8b 10                	mov    (%eax),%edx
  80027d:	3b 50 04             	cmp    0x4(%eax),%edx
  800280:	73 0a                	jae    80028c <sprintputch+0x1b>
		*b->buf++ = ch;
  800282:	8d 4a 01             	lea    0x1(%edx),%ecx
  800285:	89 08                	mov    %ecx,(%eax)
  800287:	8b 45 08             	mov    0x8(%ebp),%eax
  80028a:	88 02                	mov    %al,(%edx)
}
  80028c:	5d                   	pop    %ebp
  80028d:	c3                   	ret    

0080028e <printfmt>:
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800294:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800297:	50                   	push   %eax
  800298:	ff 75 10             	pushl  0x10(%ebp)
  80029b:	ff 75 0c             	pushl  0xc(%ebp)
  80029e:	ff 75 08             	pushl  0x8(%ebp)
  8002a1:	e8 05 00 00 00       	call   8002ab <vprintfmt>
}
  8002a6:	83 c4 10             	add    $0x10,%esp
  8002a9:	c9                   	leave  
  8002aa:	c3                   	ret    

008002ab <vprintfmt>:
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	57                   	push   %edi
  8002af:	56                   	push   %esi
  8002b0:	53                   	push   %ebx
  8002b1:	83 ec 2c             	sub    $0x2c,%esp
  8002b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002ba:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002bd:	e9 c1 03 00 00       	jmp    800683 <vprintfmt+0x3d8>
		padc = ' ';
  8002c2:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002c6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002cd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002db:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e0:	8d 47 01             	lea    0x1(%edi),%eax
  8002e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e6:	0f b6 17             	movzbl (%edi),%edx
  8002e9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002ec:	3c 55                	cmp    $0x55,%al
  8002ee:	0f 87 12 04 00 00    	ja     800706 <vprintfmt+0x45b>
  8002f4:	0f b6 c0             	movzbl %al,%eax
  8002f7:	ff 24 85 60 25 80 00 	jmp    *0x802560(,%eax,4)
  8002fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800301:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800305:	eb d9                	jmp    8002e0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800307:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80030a:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80030e:	eb d0                	jmp    8002e0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800310:	0f b6 d2             	movzbl %dl,%edx
  800313:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80031e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800321:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800325:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800328:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80032b:	83 f9 09             	cmp    $0x9,%ecx
  80032e:	77 55                	ja     800385 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800330:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800333:	eb e9                	jmp    80031e <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800335:	8b 45 14             	mov    0x14(%ebp),%eax
  800338:	8b 00                	mov    (%eax),%eax
  80033a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80033d:	8b 45 14             	mov    0x14(%ebp),%eax
  800340:	8d 40 04             	lea    0x4(%eax),%eax
  800343:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800346:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800349:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80034d:	79 91                	jns    8002e0 <vprintfmt+0x35>
				width = precision, precision = -1;
  80034f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800352:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800355:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80035c:	eb 82                	jmp    8002e0 <vprintfmt+0x35>
  80035e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800361:	85 c0                	test   %eax,%eax
  800363:	ba 00 00 00 00       	mov    $0x0,%edx
  800368:	0f 49 d0             	cmovns %eax,%edx
  80036b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800371:	e9 6a ff ff ff       	jmp    8002e0 <vprintfmt+0x35>
  800376:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800379:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800380:	e9 5b ff ff ff       	jmp    8002e0 <vprintfmt+0x35>
  800385:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800388:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80038b:	eb bc                	jmp    800349 <vprintfmt+0x9e>
			lflag++;
  80038d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800393:	e9 48 ff ff ff       	jmp    8002e0 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800398:	8b 45 14             	mov    0x14(%ebp),%eax
  80039b:	8d 78 04             	lea    0x4(%eax),%edi
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	53                   	push   %ebx
  8003a2:	ff 30                	pushl  (%eax)
  8003a4:	ff d6                	call   *%esi
			break;
  8003a6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ac:	e9 cf 02 00 00       	jmp    800680 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8003b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b4:	8d 78 04             	lea    0x4(%eax),%edi
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	99                   	cltd   
  8003ba:	31 d0                	xor    %edx,%eax
  8003bc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003be:	83 f8 0f             	cmp    $0xf,%eax
  8003c1:	7f 23                	jg     8003e6 <vprintfmt+0x13b>
  8003c3:	8b 14 85 c0 26 80 00 	mov    0x8026c0(,%eax,4),%edx
  8003ca:	85 d2                	test   %edx,%edx
  8003cc:	74 18                	je     8003e6 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003ce:	52                   	push   %edx
  8003cf:	68 76 27 80 00       	push   $0x802776
  8003d4:	53                   	push   %ebx
  8003d5:	56                   	push   %esi
  8003d6:	e8 b3 fe ff ff       	call   80028e <printfmt>
  8003db:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003de:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e1:	e9 9a 02 00 00       	jmp    800680 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8003e6:	50                   	push   %eax
  8003e7:	68 33 24 80 00       	push   $0x802433
  8003ec:	53                   	push   %ebx
  8003ed:	56                   	push   %esi
  8003ee:	e8 9b fe ff ff       	call   80028e <printfmt>
  8003f3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f6:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f9:	e9 82 02 00 00       	jmp    800680 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8003fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800401:	83 c0 04             	add    $0x4,%eax
  800404:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800407:	8b 45 14             	mov    0x14(%ebp),%eax
  80040a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80040c:	85 ff                	test   %edi,%edi
  80040e:	b8 2c 24 80 00       	mov    $0x80242c,%eax
  800413:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800416:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80041a:	0f 8e bd 00 00 00    	jle    8004dd <vprintfmt+0x232>
  800420:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800424:	75 0e                	jne    800434 <vprintfmt+0x189>
  800426:	89 75 08             	mov    %esi,0x8(%ebp)
  800429:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80042c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80042f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800432:	eb 6d                	jmp    8004a1 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800434:	83 ec 08             	sub    $0x8,%esp
  800437:	ff 75 d0             	pushl  -0x30(%ebp)
  80043a:	57                   	push   %edi
  80043b:	e8 6e 03 00 00       	call   8007ae <strnlen>
  800440:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800443:	29 c1                	sub    %eax,%ecx
  800445:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800448:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80044b:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80044f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800452:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800455:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800457:	eb 0f                	jmp    800468 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800459:	83 ec 08             	sub    $0x8,%esp
  80045c:	53                   	push   %ebx
  80045d:	ff 75 e0             	pushl  -0x20(%ebp)
  800460:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800462:	83 ef 01             	sub    $0x1,%edi
  800465:	83 c4 10             	add    $0x10,%esp
  800468:	85 ff                	test   %edi,%edi
  80046a:	7f ed                	jg     800459 <vprintfmt+0x1ae>
  80046c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80046f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800472:	85 c9                	test   %ecx,%ecx
  800474:	b8 00 00 00 00       	mov    $0x0,%eax
  800479:	0f 49 c1             	cmovns %ecx,%eax
  80047c:	29 c1                	sub    %eax,%ecx
  80047e:	89 75 08             	mov    %esi,0x8(%ebp)
  800481:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800484:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800487:	89 cb                	mov    %ecx,%ebx
  800489:	eb 16                	jmp    8004a1 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80048b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80048f:	75 31                	jne    8004c2 <vprintfmt+0x217>
					putch(ch, putdat);
  800491:	83 ec 08             	sub    $0x8,%esp
  800494:	ff 75 0c             	pushl  0xc(%ebp)
  800497:	50                   	push   %eax
  800498:	ff 55 08             	call   *0x8(%ebp)
  80049b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80049e:	83 eb 01             	sub    $0x1,%ebx
  8004a1:	83 c7 01             	add    $0x1,%edi
  8004a4:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004a8:	0f be c2             	movsbl %dl,%eax
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	74 59                	je     800508 <vprintfmt+0x25d>
  8004af:	85 f6                	test   %esi,%esi
  8004b1:	78 d8                	js     80048b <vprintfmt+0x1e0>
  8004b3:	83 ee 01             	sub    $0x1,%esi
  8004b6:	79 d3                	jns    80048b <vprintfmt+0x1e0>
  8004b8:	89 df                	mov    %ebx,%edi
  8004ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8004bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c0:	eb 37                	jmp    8004f9 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c2:	0f be d2             	movsbl %dl,%edx
  8004c5:	83 ea 20             	sub    $0x20,%edx
  8004c8:	83 fa 5e             	cmp    $0x5e,%edx
  8004cb:	76 c4                	jbe    800491 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004cd:	83 ec 08             	sub    $0x8,%esp
  8004d0:	ff 75 0c             	pushl  0xc(%ebp)
  8004d3:	6a 3f                	push   $0x3f
  8004d5:	ff 55 08             	call   *0x8(%ebp)
  8004d8:	83 c4 10             	add    $0x10,%esp
  8004db:	eb c1                	jmp    80049e <vprintfmt+0x1f3>
  8004dd:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004e3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004e6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e9:	eb b6                	jmp    8004a1 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004eb:	83 ec 08             	sub    $0x8,%esp
  8004ee:	53                   	push   %ebx
  8004ef:	6a 20                	push   $0x20
  8004f1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004f3:	83 ef 01             	sub    $0x1,%edi
  8004f6:	83 c4 10             	add    $0x10,%esp
  8004f9:	85 ff                	test   %edi,%edi
  8004fb:	7f ee                	jg     8004eb <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800500:	89 45 14             	mov    %eax,0x14(%ebp)
  800503:	e9 78 01 00 00       	jmp    800680 <vprintfmt+0x3d5>
  800508:	89 df                	mov    %ebx,%edi
  80050a:	8b 75 08             	mov    0x8(%ebp),%esi
  80050d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800510:	eb e7                	jmp    8004f9 <vprintfmt+0x24e>
	if (lflag >= 2)
  800512:	83 f9 01             	cmp    $0x1,%ecx
  800515:	7e 3f                	jle    800556 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800517:	8b 45 14             	mov    0x14(%ebp),%eax
  80051a:	8b 50 04             	mov    0x4(%eax),%edx
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800522:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800525:	8b 45 14             	mov    0x14(%ebp),%eax
  800528:	8d 40 08             	lea    0x8(%eax),%eax
  80052b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80052e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800532:	79 5c                	jns    800590 <vprintfmt+0x2e5>
				putch('-', putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	53                   	push   %ebx
  800538:	6a 2d                	push   $0x2d
  80053a:	ff d6                	call   *%esi
				num = -(long long) num;
  80053c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800542:	f7 da                	neg    %edx
  800544:	83 d1 00             	adc    $0x0,%ecx
  800547:	f7 d9                	neg    %ecx
  800549:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80054c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800551:	e9 10 01 00 00       	jmp    800666 <vprintfmt+0x3bb>
	else if (lflag)
  800556:	85 c9                	test   %ecx,%ecx
  800558:	75 1b                	jne    800575 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800562:	89 c1                	mov    %eax,%ecx
  800564:	c1 f9 1f             	sar    $0x1f,%ecx
  800567:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	8d 40 04             	lea    0x4(%eax),%eax
  800570:	89 45 14             	mov    %eax,0x14(%ebp)
  800573:	eb b9                	jmp    80052e <vprintfmt+0x283>
		return va_arg(*ap, long);
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057d:	89 c1                	mov    %eax,%ecx
  80057f:	c1 f9 1f             	sar    $0x1f,%ecx
  800582:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8d 40 04             	lea    0x4(%eax),%eax
  80058b:	89 45 14             	mov    %eax,0x14(%ebp)
  80058e:	eb 9e                	jmp    80052e <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800590:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800593:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800596:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059b:	e9 c6 00 00 00       	jmp    800666 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005a0:	83 f9 01             	cmp    $0x1,%ecx
  8005a3:	7e 18                	jle    8005bd <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 10                	mov    (%eax),%edx
  8005aa:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ad:	8d 40 08             	lea    0x8(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b8:	e9 a9 00 00 00       	jmp    800666 <vprintfmt+0x3bb>
	else if (lflag)
  8005bd:	85 c9                	test   %ecx,%ecx
  8005bf:	75 1a                	jne    8005db <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	8b 10                	mov    (%eax),%edx
  8005c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005cb:	8d 40 04             	lea    0x4(%eax),%eax
  8005ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d6:	e9 8b 00 00 00       	jmp    800666 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	8b 10                	mov    (%eax),%edx
  8005e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e5:	8d 40 04             	lea    0x4(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f0:	eb 74                	jmp    800666 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005f2:	83 f9 01             	cmp    $0x1,%ecx
  8005f5:	7e 15                	jle    80060c <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8b 10                	mov    (%eax),%edx
  8005fc:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ff:	8d 40 08             	lea    0x8(%eax),%eax
  800602:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800605:	b8 08 00 00 00       	mov    $0x8,%eax
  80060a:	eb 5a                	jmp    800666 <vprintfmt+0x3bb>
	else if (lflag)
  80060c:	85 c9                	test   %ecx,%ecx
  80060e:	75 17                	jne    800627 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8b 10                	mov    (%eax),%edx
  800615:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061a:	8d 40 04             	lea    0x4(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800620:	b8 08 00 00 00       	mov    $0x8,%eax
  800625:	eb 3f                	jmp    800666 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8b 10                	mov    (%eax),%edx
  80062c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800631:	8d 40 04             	lea    0x4(%eax),%eax
  800634:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800637:	b8 08 00 00 00       	mov    $0x8,%eax
  80063c:	eb 28                	jmp    800666 <vprintfmt+0x3bb>
			putch('0', putdat);
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	53                   	push   %ebx
  800642:	6a 30                	push   $0x30
  800644:	ff d6                	call   *%esi
			putch('x', putdat);
  800646:	83 c4 08             	add    $0x8,%esp
  800649:	53                   	push   %ebx
  80064a:	6a 78                	push   $0x78
  80064c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8b 10                	mov    (%eax),%edx
  800653:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800658:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80065b:	8d 40 04             	lea    0x4(%eax),%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800661:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80066d:	57                   	push   %edi
  80066e:	ff 75 e0             	pushl  -0x20(%ebp)
  800671:	50                   	push   %eax
  800672:	51                   	push   %ecx
  800673:	52                   	push   %edx
  800674:	89 da                	mov    %ebx,%edx
  800676:	89 f0                	mov    %esi,%eax
  800678:	e8 45 fb ff ff       	call   8001c2 <printnum>
			break;
  80067d:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800680:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  800683:	83 c7 01             	add    $0x1,%edi
  800686:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80068a:	83 f8 25             	cmp    $0x25,%eax
  80068d:	0f 84 2f fc ff ff    	je     8002c2 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  800693:	85 c0                	test   %eax,%eax
  800695:	0f 84 8b 00 00 00    	je     800726 <vprintfmt+0x47b>
			putch(ch, putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	53                   	push   %ebx
  80069f:	50                   	push   %eax
  8006a0:	ff d6                	call   *%esi
  8006a2:	83 c4 10             	add    $0x10,%esp
  8006a5:	eb dc                	jmp    800683 <vprintfmt+0x3d8>
	if (lflag >= 2)
  8006a7:	83 f9 01             	cmp    $0x1,%ecx
  8006aa:	7e 15                	jle    8006c1 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	8b 10                	mov    (%eax),%edx
  8006b1:	8b 48 04             	mov    0x4(%eax),%ecx
  8006b4:	8d 40 08             	lea    0x8(%eax),%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ba:	b8 10 00 00 00       	mov    $0x10,%eax
  8006bf:	eb a5                	jmp    800666 <vprintfmt+0x3bb>
	else if (lflag)
  8006c1:	85 c9                	test   %ecx,%ecx
  8006c3:	75 17                	jne    8006dc <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	8b 10                	mov    (%eax),%edx
  8006ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006cf:	8d 40 04             	lea    0x4(%eax),%eax
  8006d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d5:	b8 10 00 00 00       	mov    $0x10,%eax
  8006da:	eb 8a                	jmp    800666 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 10                	mov    (%eax),%edx
  8006e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e6:	8d 40 04             	lea    0x4(%eax),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ec:	b8 10 00 00 00       	mov    $0x10,%eax
  8006f1:	e9 70 ff ff ff       	jmp    800666 <vprintfmt+0x3bb>
			putch(ch, putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	6a 25                	push   $0x25
  8006fc:	ff d6                	call   *%esi
			break;
  8006fe:	83 c4 10             	add    $0x10,%esp
  800701:	e9 7a ff ff ff       	jmp    800680 <vprintfmt+0x3d5>
			putch('%', putdat);
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	53                   	push   %ebx
  80070a:	6a 25                	push   $0x25
  80070c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80070e:	83 c4 10             	add    $0x10,%esp
  800711:	89 f8                	mov    %edi,%eax
  800713:	eb 03                	jmp    800718 <vprintfmt+0x46d>
  800715:	83 e8 01             	sub    $0x1,%eax
  800718:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80071c:	75 f7                	jne    800715 <vprintfmt+0x46a>
  80071e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800721:	e9 5a ff ff ff       	jmp    800680 <vprintfmt+0x3d5>
}
  800726:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800729:	5b                   	pop    %ebx
  80072a:	5e                   	pop    %esi
  80072b:	5f                   	pop    %edi
  80072c:	5d                   	pop    %ebp
  80072d:	c3                   	ret    

0080072e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80072e:	55                   	push   %ebp
  80072f:	89 e5                	mov    %esp,%ebp
  800731:	83 ec 18             	sub    $0x18,%esp
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80073a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80073d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800741:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800744:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80074b:	85 c0                	test   %eax,%eax
  80074d:	74 26                	je     800775 <vsnprintf+0x47>
  80074f:	85 d2                	test   %edx,%edx
  800751:	7e 22                	jle    800775 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800753:	ff 75 14             	pushl  0x14(%ebp)
  800756:	ff 75 10             	pushl  0x10(%ebp)
  800759:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80075c:	50                   	push   %eax
  80075d:	68 71 02 80 00       	push   $0x800271
  800762:	e8 44 fb ff ff       	call   8002ab <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80076a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80076d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800770:	83 c4 10             	add    $0x10,%esp
}
  800773:	c9                   	leave  
  800774:	c3                   	ret    
		return -E_INVAL;
  800775:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80077a:	eb f7                	jmp    800773 <vsnprintf+0x45>

0080077c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80077c:	55                   	push   %ebp
  80077d:	89 e5                	mov    %esp,%ebp
  80077f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800782:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800785:	50                   	push   %eax
  800786:	ff 75 10             	pushl  0x10(%ebp)
  800789:	ff 75 0c             	pushl  0xc(%ebp)
  80078c:	ff 75 08             	pushl  0x8(%ebp)
  80078f:	e8 9a ff ff ff       	call   80072e <vsnprintf>
	va_end(ap);

	return rc;
}
  800794:	c9                   	leave  
  800795:	c3                   	ret    

00800796 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
  800799:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80079c:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a1:	eb 03                	jmp    8007a6 <strlen+0x10>
		n++;
  8007a3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007a6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007aa:	75 f7                	jne    8007a3 <strlen+0xd>
	return n;
}
  8007ac:	5d                   	pop    %ebp
  8007ad:	c3                   	ret    

008007ae <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b4:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007bc:	eb 03                	jmp    8007c1 <strnlen+0x13>
		n++;
  8007be:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007c1:	39 d0                	cmp    %edx,%eax
  8007c3:	74 06                	je     8007cb <strnlen+0x1d>
  8007c5:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007c9:	75 f3                	jne    8007be <strnlen+0x10>
	return n;
}
  8007cb:	5d                   	pop    %ebp
  8007cc:	c3                   	ret    

008007cd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007cd:	55                   	push   %ebp
  8007ce:	89 e5                	mov    %esp,%ebp
  8007d0:	53                   	push   %ebx
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d7:	89 c2                	mov    %eax,%edx
  8007d9:	83 c1 01             	add    $0x1,%ecx
  8007dc:	83 c2 01             	add    $0x1,%edx
  8007df:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007e3:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007e6:	84 db                	test   %bl,%bl
  8007e8:	75 ef                	jne    8007d9 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007ea:	5b                   	pop    %ebx
  8007eb:	5d                   	pop    %ebp
  8007ec:	c3                   	ret    

008007ed <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	53                   	push   %ebx
  8007f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007f4:	53                   	push   %ebx
  8007f5:	e8 9c ff ff ff       	call   800796 <strlen>
  8007fa:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007fd:	ff 75 0c             	pushl  0xc(%ebp)
  800800:	01 d8                	add    %ebx,%eax
  800802:	50                   	push   %eax
  800803:	e8 c5 ff ff ff       	call   8007cd <strcpy>
	return dst;
}
  800808:	89 d8                	mov    %ebx,%eax
  80080a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80080d:	c9                   	leave  
  80080e:	c3                   	ret    

0080080f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	56                   	push   %esi
  800813:	53                   	push   %ebx
  800814:	8b 75 08             	mov    0x8(%ebp),%esi
  800817:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80081a:	89 f3                	mov    %esi,%ebx
  80081c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80081f:	89 f2                	mov    %esi,%edx
  800821:	eb 0f                	jmp    800832 <strncpy+0x23>
		*dst++ = *src;
  800823:	83 c2 01             	add    $0x1,%edx
  800826:	0f b6 01             	movzbl (%ecx),%eax
  800829:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80082c:	80 39 01             	cmpb   $0x1,(%ecx)
  80082f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800832:	39 da                	cmp    %ebx,%edx
  800834:	75 ed                	jne    800823 <strncpy+0x14>
	}
	return ret;
}
  800836:	89 f0                	mov    %esi,%eax
  800838:	5b                   	pop    %ebx
  800839:	5e                   	pop    %esi
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    

0080083c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	56                   	push   %esi
  800840:	53                   	push   %ebx
  800841:	8b 75 08             	mov    0x8(%ebp),%esi
  800844:	8b 55 0c             	mov    0xc(%ebp),%edx
  800847:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80084a:	89 f0                	mov    %esi,%eax
  80084c:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800850:	85 c9                	test   %ecx,%ecx
  800852:	75 0b                	jne    80085f <strlcpy+0x23>
  800854:	eb 17                	jmp    80086d <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800856:	83 c2 01             	add    $0x1,%edx
  800859:	83 c0 01             	add    $0x1,%eax
  80085c:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80085f:	39 d8                	cmp    %ebx,%eax
  800861:	74 07                	je     80086a <strlcpy+0x2e>
  800863:	0f b6 0a             	movzbl (%edx),%ecx
  800866:	84 c9                	test   %cl,%cl
  800868:	75 ec                	jne    800856 <strlcpy+0x1a>
		*dst = '\0';
  80086a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80086d:	29 f0                	sub    %esi,%eax
}
  80086f:	5b                   	pop    %ebx
  800870:	5e                   	pop    %esi
  800871:	5d                   	pop    %ebp
  800872:	c3                   	ret    

00800873 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800879:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80087c:	eb 06                	jmp    800884 <strcmp+0x11>
		p++, q++;
  80087e:	83 c1 01             	add    $0x1,%ecx
  800881:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800884:	0f b6 01             	movzbl (%ecx),%eax
  800887:	84 c0                	test   %al,%al
  800889:	74 04                	je     80088f <strcmp+0x1c>
  80088b:	3a 02                	cmp    (%edx),%al
  80088d:	74 ef                	je     80087e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80088f:	0f b6 c0             	movzbl %al,%eax
  800892:	0f b6 12             	movzbl (%edx),%edx
  800895:	29 d0                	sub    %edx,%eax
}
  800897:	5d                   	pop    %ebp
  800898:	c3                   	ret    

00800899 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	53                   	push   %ebx
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a3:	89 c3                	mov    %eax,%ebx
  8008a5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008a8:	eb 06                	jmp    8008b0 <strncmp+0x17>
		n--, p++, q++;
  8008aa:	83 c0 01             	add    $0x1,%eax
  8008ad:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008b0:	39 d8                	cmp    %ebx,%eax
  8008b2:	74 16                	je     8008ca <strncmp+0x31>
  8008b4:	0f b6 08             	movzbl (%eax),%ecx
  8008b7:	84 c9                	test   %cl,%cl
  8008b9:	74 04                	je     8008bf <strncmp+0x26>
  8008bb:	3a 0a                	cmp    (%edx),%cl
  8008bd:	74 eb                	je     8008aa <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008bf:	0f b6 00             	movzbl (%eax),%eax
  8008c2:	0f b6 12             	movzbl (%edx),%edx
  8008c5:	29 d0                	sub    %edx,%eax
}
  8008c7:	5b                   	pop    %ebx
  8008c8:	5d                   	pop    %ebp
  8008c9:	c3                   	ret    
		return 0;
  8008ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cf:	eb f6                	jmp    8008c7 <strncmp+0x2e>

008008d1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008db:	0f b6 10             	movzbl (%eax),%edx
  8008de:	84 d2                	test   %dl,%dl
  8008e0:	74 09                	je     8008eb <strchr+0x1a>
		if (*s == c)
  8008e2:	38 ca                	cmp    %cl,%dl
  8008e4:	74 0a                	je     8008f0 <strchr+0x1f>
	for (; *s; s++)
  8008e6:	83 c0 01             	add    $0x1,%eax
  8008e9:	eb f0                	jmp    8008db <strchr+0xa>
			return (char *) s;
	return 0;
  8008eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f0:	5d                   	pop    %ebp
  8008f1:	c3                   	ret    

008008f2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fc:	eb 03                	jmp    800901 <strfind+0xf>
  8008fe:	83 c0 01             	add    $0x1,%eax
  800901:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800904:	38 ca                	cmp    %cl,%dl
  800906:	74 04                	je     80090c <strfind+0x1a>
  800908:	84 d2                	test   %dl,%dl
  80090a:	75 f2                	jne    8008fe <strfind+0xc>
			break;
	return (char *) s;
}
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	57                   	push   %edi
  800912:	56                   	push   %esi
  800913:	53                   	push   %ebx
  800914:	8b 7d 08             	mov    0x8(%ebp),%edi
  800917:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80091a:	85 c9                	test   %ecx,%ecx
  80091c:	74 13                	je     800931 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80091e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800924:	75 05                	jne    80092b <memset+0x1d>
  800926:	f6 c1 03             	test   $0x3,%cl
  800929:	74 0d                	je     800938 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80092b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092e:	fc                   	cld    
  80092f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800931:	89 f8                	mov    %edi,%eax
  800933:	5b                   	pop    %ebx
  800934:	5e                   	pop    %esi
  800935:	5f                   	pop    %edi
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    
		c &= 0xFF;
  800938:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80093c:	89 d3                	mov    %edx,%ebx
  80093e:	c1 e3 08             	shl    $0x8,%ebx
  800941:	89 d0                	mov    %edx,%eax
  800943:	c1 e0 18             	shl    $0x18,%eax
  800946:	89 d6                	mov    %edx,%esi
  800948:	c1 e6 10             	shl    $0x10,%esi
  80094b:	09 f0                	or     %esi,%eax
  80094d:	09 c2                	or     %eax,%edx
  80094f:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800951:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800954:	89 d0                	mov    %edx,%eax
  800956:	fc                   	cld    
  800957:	f3 ab                	rep stos %eax,%es:(%edi)
  800959:	eb d6                	jmp    800931 <memset+0x23>

0080095b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	57                   	push   %edi
  80095f:	56                   	push   %esi
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	8b 75 0c             	mov    0xc(%ebp),%esi
  800966:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800969:	39 c6                	cmp    %eax,%esi
  80096b:	73 35                	jae    8009a2 <memmove+0x47>
  80096d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800970:	39 c2                	cmp    %eax,%edx
  800972:	76 2e                	jbe    8009a2 <memmove+0x47>
		s += n;
		d += n;
  800974:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800977:	89 d6                	mov    %edx,%esi
  800979:	09 fe                	or     %edi,%esi
  80097b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800981:	74 0c                	je     80098f <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800983:	83 ef 01             	sub    $0x1,%edi
  800986:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800989:	fd                   	std    
  80098a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80098c:	fc                   	cld    
  80098d:	eb 21                	jmp    8009b0 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098f:	f6 c1 03             	test   $0x3,%cl
  800992:	75 ef                	jne    800983 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800994:	83 ef 04             	sub    $0x4,%edi
  800997:	8d 72 fc             	lea    -0x4(%edx),%esi
  80099a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80099d:	fd                   	std    
  80099e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a0:	eb ea                	jmp    80098c <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a2:	89 f2                	mov    %esi,%edx
  8009a4:	09 c2                	or     %eax,%edx
  8009a6:	f6 c2 03             	test   $0x3,%dl
  8009a9:	74 09                	je     8009b4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009ab:	89 c7                	mov    %eax,%edi
  8009ad:	fc                   	cld    
  8009ae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009b0:	5e                   	pop    %esi
  8009b1:	5f                   	pop    %edi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b4:	f6 c1 03             	test   $0x3,%cl
  8009b7:	75 f2                	jne    8009ab <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009b9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009bc:	89 c7                	mov    %eax,%edi
  8009be:	fc                   	cld    
  8009bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c1:	eb ed                	jmp    8009b0 <memmove+0x55>

008009c3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009c6:	ff 75 10             	pushl  0x10(%ebp)
  8009c9:	ff 75 0c             	pushl  0xc(%ebp)
  8009cc:	ff 75 08             	pushl  0x8(%ebp)
  8009cf:	e8 87 ff ff ff       	call   80095b <memmove>
}
  8009d4:	c9                   	leave  
  8009d5:	c3                   	ret    

008009d6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	56                   	push   %esi
  8009da:	53                   	push   %ebx
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e1:	89 c6                	mov    %eax,%esi
  8009e3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009e6:	39 f0                	cmp    %esi,%eax
  8009e8:	74 1c                	je     800a06 <memcmp+0x30>
		if (*s1 != *s2)
  8009ea:	0f b6 08             	movzbl (%eax),%ecx
  8009ed:	0f b6 1a             	movzbl (%edx),%ebx
  8009f0:	38 d9                	cmp    %bl,%cl
  8009f2:	75 08                	jne    8009fc <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009f4:	83 c0 01             	add    $0x1,%eax
  8009f7:	83 c2 01             	add    $0x1,%edx
  8009fa:	eb ea                	jmp    8009e6 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009fc:	0f b6 c1             	movzbl %cl,%eax
  8009ff:	0f b6 db             	movzbl %bl,%ebx
  800a02:	29 d8                	sub    %ebx,%eax
  800a04:	eb 05                	jmp    800a0b <memcmp+0x35>
	}

	return 0;
  800a06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0b:	5b                   	pop    %ebx
  800a0c:	5e                   	pop    %esi
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a18:	89 c2                	mov    %eax,%edx
  800a1a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a1d:	39 d0                	cmp    %edx,%eax
  800a1f:	73 09                	jae    800a2a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a21:	38 08                	cmp    %cl,(%eax)
  800a23:	74 05                	je     800a2a <memfind+0x1b>
	for (; s < ends; s++)
  800a25:	83 c0 01             	add    $0x1,%eax
  800a28:	eb f3                	jmp    800a1d <memfind+0xe>
			break;
	return (void *) s;
}
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	57                   	push   %edi
  800a30:	56                   	push   %esi
  800a31:	53                   	push   %ebx
  800a32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a35:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a38:	eb 03                	jmp    800a3d <strtol+0x11>
		s++;
  800a3a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a3d:	0f b6 01             	movzbl (%ecx),%eax
  800a40:	3c 20                	cmp    $0x20,%al
  800a42:	74 f6                	je     800a3a <strtol+0xe>
  800a44:	3c 09                	cmp    $0x9,%al
  800a46:	74 f2                	je     800a3a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a48:	3c 2b                	cmp    $0x2b,%al
  800a4a:	74 2e                	je     800a7a <strtol+0x4e>
	int neg = 0;
  800a4c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a51:	3c 2d                	cmp    $0x2d,%al
  800a53:	74 2f                	je     800a84 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a55:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a5b:	75 05                	jne    800a62 <strtol+0x36>
  800a5d:	80 39 30             	cmpb   $0x30,(%ecx)
  800a60:	74 2c                	je     800a8e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a62:	85 db                	test   %ebx,%ebx
  800a64:	75 0a                	jne    800a70 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a66:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a6b:	80 39 30             	cmpb   $0x30,(%ecx)
  800a6e:	74 28                	je     800a98 <strtol+0x6c>
		base = 10;
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
  800a75:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a78:	eb 50                	jmp    800aca <strtol+0x9e>
		s++;
  800a7a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a7d:	bf 00 00 00 00       	mov    $0x0,%edi
  800a82:	eb d1                	jmp    800a55 <strtol+0x29>
		s++, neg = 1;
  800a84:	83 c1 01             	add    $0x1,%ecx
  800a87:	bf 01 00 00 00       	mov    $0x1,%edi
  800a8c:	eb c7                	jmp    800a55 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a8e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a92:	74 0e                	je     800aa2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a94:	85 db                	test   %ebx,%ebx
  800a96:	75 d8                	jne    800a70 <strtol+0x44>
		s++, base = 8;
  800a98:	83 c1 01             	add    $0x1,%ecx
  800a9b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aa0:	eb ce                	jmp    800a70 <strtol+0x44>
		s += 2, base = 16;
  800aa2:	83 c1 02             	add    $0x2,%ecx
  800aa5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aaa:	eb c4                	jmp    800a70 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800aac:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aaf:	89 f3                	mov    %esi,%ebx
  800ab1:	80 fb 19             	cmp    $0x19,%bl
  800ab4:	77 29                	ja     800adf <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ab6:	0f be d2             	movsbl %dl,%edx
  800ab9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800abc:	3b 55 10             	cmp    0x10(%ebp),%edx
  800abf:	7d 30                	jge    800af1 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ac1:	83 c1 01             	add    $0x1,%ecx
  800ac4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ac8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aca:	0f b6 11             	movzbl (%ecx),%edx
  800acd:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ad0:	89 f3                	mov    %esi,%ebx
  800ad2:	80 fb 09             	cmp    $0x9,%bl
  800ad5:	77 d5                	ja     800aac <strtol+0x80>
			dig = *s - '0';
  800ad7:	0f be d2             	movsbl %dl,%edx
  800ada:	83 ea 30             	sub    $0x30,%edx
  800add:	eb dd                	jmp    800abc <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800adf:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ae2:	89 f3                	mov    %esi,%ebx
  800ae4:	80 fb 19             	cmp    $0x19,%bl
  800ae7:	77 08                	ja     800af1 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ae9:	0f be d2             	movsbl %dl,%edx
  800aec:	83 ea 37             	sub    $0x37,%edx
  800aef:	eb cb                	jmp    800abc <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800af1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af5:	74 05                	je     800afc <strtol+0xd0>
		*endptr = (char *) s;
  800af7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800afa:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800afc:	89 c2                	mov    %eax,%edx
  800afe:	f7 da                	neg    %edx
  800b00:	85 ff                	test   %edi,%edi
  800b02:	0f 45 c2             	cmovne %edx,%eax
}
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5f                   	pop    %edi
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	57                   	push   %edi
  800b0e:	56                   	push   %esi
  800b0f:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b10:	b8 00 00 00 00       	mov    $0x0,%eax
  800b15:	8b 55 08             	mov    0x8(%ebp),%edx
  800b18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b1b:	89 c3                	mov    %eax,%ebx
  800b1d:	89 c7                	mov    %eax,%edi
  800b1f:	89 c6                	mov    %eax,%esi
  800b21:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b23:	5b                   	pop    %ebx
  800b24:	5e                   	pop    %esi
  800b25:	5f                   	pop    %edi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	57                   	push   %edi
  800b2c:	56                   	push   %esi
  800b2d:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b33:	b8 01 00 00 00       	mov    $0x1,%eax
  800b38:	89 d1                	mov    %edx,%ecx
  800b3a:	89 d3                	mov    %edx,%ebx
  800b3c:	89 d7                	mov    %edx,%edi
  800b3e:	89 d6                	mov    %edx,%esi
  800b40:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b42:	5b                   	pop    %ebx
  800b43:	5e                   	pop    %esi
  800b44:	5f                   	pop    %edi
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	57                   	push   %edi
  800b4b:	56                   	push   %esi
  800b4c:	53                   	push   %ebx
  800b4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b50:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b55:	8b 55 08             	mov    0x8(%ebp),%edx
  800b58:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5d:	89 cb                	mov    %ecx,%ebx
  800b5f:	89 cf                	mov    %ecx,%edi
  800b61:	89 ce                	mov    %ecx,%esi
  800b63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b65:	85 c0                	test   %eax,%eax
  800b67:	7f 08                	jg     800b71 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b6c:	5b                   	pop    %ebx
  800b6d:	5e                   	pop    %esi
  800b6e:	5f                   	pop    %edi
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b71:	83 ec 0c             	sub    $0xc,%esp
  800b74:	50                   	push   %eax
  800b75:	6a 03                	push   $0x3
  800b77:	68 1f 27 80 00       	push   $0x80271f
  800b7c:	6a 23                	push   $0x23
  800b7e:	68 3c 27 80 00       	push   $0x80273c
  800b83:	e8 4b f5 ff ff       	call   8000d3 <_panic>

00800b88 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	57                   	push   %edi
  800b8c:	56                   	push   %esi
  800b8d:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b93:	b8 02 00 00 00       	mov    $0x2,%eax
  800b98:	89 d1                	mov    %edx,%ecx
  800b9a:	89 d3                	mov    %edx,%ebx
  800b9c:	89 d7                	mov    %edx,%edi
  800b9e:	89 d6                	mov    %edx,%esi
  800ba0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ba2:	5b                   	pop    %ebx
  800ba3:	5e                   	pop    %esi
  800ba4:	5f                   	pop    %edi
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <sys_yield>:

void
sys_yield(void)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bad:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bb7:	89 d1                	mov    %edx,%ecx
  800bb9:	89 d3                	mov    %edx,%ebx
  800bbb:	89 d7                	mov    %edx,%edi
  800bbd:	89 d6                	mov    %edx,%esi
  800bbf:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
  800bcc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bcf:	be 00 00 00 00       	mov    $0x0,%esi
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bda:	b8 04 00 00 00       	mov    $0x4,%eax
  800bdf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800be2:	89 f7                	mov    %esi,%edi
  800be4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800be6:	85 c0                	test   %eax,%eax
  800be8:	7f 08                	jg     800bf2 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bed:	5b                   	pop    %ebx
  800bee:	5e                   	pop    %esi
  800bef:	5f                   	pop    %edi
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf2:	83 ec 0c             	sub    $0xc,%esp
  800bf5:	50                   	push   %eax
  800bf6:	6a 04                	push   $0x4
  800bf8:	68 1f 27 80 00       	push   $0x80271f
  800bfd:	6a 23                	push   $0x23
  800bff:	68 3c 27 80 00       	push   $0x80273c
  800c04:	e8 ca f4 ff ff       	call   8000d3 <_panic>

00800c09 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	57                   	push   %edi
  800c0d:	56                   	push   %esi
  800c0e:	53                   	push   %ebx
  800c0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c12:	8b 55 08             	mov    0x8(%ebp),%edx
  800c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c18:	b8 05 00 00 00       	mov    $0x5,%eax
  800c1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c20:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c23:	8b 75 18             	mov    0x18(%ebp),%esi
  800c26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	7f 08                	jg     800c34 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c34:	83 ec 0c             	sub    $0xc,%esp
  800c37:	50                   	push   %eax
  800c38:	6a 05                	push   $0x5
  800c3a:	68 1f 27 80 00       	push   $0x80271f
  800c3f:	6a 23                	push   $0x23
  800c41:	68 3c 27 80 00       	push   $0x80273c
  800c46:	e8 88 f4 ff ff       	call   8000d3 <_panic>

00800c4b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
  800c51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c59:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5f:	b8 06 00 00 00       	mov    $0x6,%eax
  800c64:	89 df                	mov    %ebx,%edi
  800c66:	89 de                	mov    %ebx,%esi
  800c68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6a:	85 c0                	test   %eax,%eax
  800c6c:	7f 08                	jg     800c76 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c71:	5b                   	pop    %ebx
  800c72:	5e                   	pop    %esi
  800c73:	5f                   	pop    %edi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c76:	83 ec 0c             	sub    $0xc,%esp
  800c79:	50                   	push   %eax
  800c7a:	6a 06                	push   $0x6
  800c7c:	68 1f 27 80 00       	push   $0x80271f
  800c81:	6a 23                	push   $0x23
  800c83:	68 3c 27 80 00       	push   $0x80273c
  800c88:	e8 46 f4 ff ff       	call   8000d3 <_panic>

00800c8d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	57                   	push   %edi
  800c91:	56                   	push   %esi
  800c92:	53                   	push   %ebx
  800c93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ca6:	89 df                	mov    %ebx,%edi
  800ca8:	89 de                	mov    %ebx,%esi
  800caa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cac:	85 c0                	test   %eax,%eax
  800cae:	7f 08                	jg     800cb8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb3:	5b                   	pop    %ebx
  800cb4:	5e                   	pop    %esi
  800cb5:	5f                   	pop    %edi
  800cb6:	5d                   	pop    %ebp
  800cb7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb8:	83 ec 0c             	sub    $0xc,%esp
  800cbb:	50                   	push   %eax
  800cbc:	6a 08                	push   $0x8
  800cbe:	68 1f 27 80 00       	push   $0x80271f
  800cc3:	6a 23                	push   $0x23
  800cc5:	68 3c 27 80 00       	push   $0x80273c
  800cca:	e8 04 f4 ff ff       	call   8000d3 <_panic>

00800ccf <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	57                   	push   %edi
  800cd3:	56                   	push   %esi
  800cd4:	53                   	push   %ebx
  800cd5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800cd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce3:	b8 09 00 00 00       	mov    $0x9,%eax
  800ce8:	89 df                	mov    %ebx,%edi
  800cea:	89 de                	mov    %ebx,%esi
  800cec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cee:	85 c0                	test   %eax,%eax
  800cf0:	7f 08                	jg     800cfa <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf5:	5b                   	pop    %ebx
  800cf6:	5e                   	pop    %esi
  800cf7:	5f                   	pop    %edi
  800cf8:	5d                   	pop    %ebp
  800cf9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfa:	83 ec 0c             	sub    $0xc,%esp
  800cfd:	50                   	push   %eax
  800cfe:	6a 09                	push   $0x9
  800d00:	68 1f 27 80 00       	push   $0x80271f
  800d05:	6a 23                	push   $0x23
  800d07:	68 3c 27 80 00       	push   $0x80273c
  800d0c:	e8 c2 f3 ff ff       	call   8000d3 <_panic>

00800d11 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	57                   	push   %edi
  800d15:	56                   	push   %esi
  800d16:	53                   	push   %ebx
  800d17:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d1a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d2a:	89 df                	mov    %ebx,%edi
  800d2c:	89 de                	mov    %ebx,%esi
  800d2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d30:	85 c0                	test   %eax,%eax
  800d32:	7f 08                	jg     800d3c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d37:	5b                   	pop    %ebx
  800d38:	5e                   	pop    %esi
  800d39:	5f                   	pop    %edi
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3c:	83 ec 0c             	sub    $0xc,%esp
  800d3f:	50                   	push   %eax
  800d40:	6a 0a                	push   $0xa
  800d42:	68 1f 27 80 00       	push   $0x80271f
  800d47:	6a 23                	push   $0x23
  800d49:	68 3c 27 80 00       	push   $0x80273c
  800d4e:	e8 80 f3 ff ff       	call   8000d3 <_panic>

00800d53 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	57                   	push   %edi
  800d57:	56                   	push   %esi
  800d58:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d59:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d64:	be 00 00 00 00       	mov    $0x0,%esi
  800d69:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d6f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d71:	5b                   	pop    %ebx
  800d72:	5e                   	pop    %esi
  800d73:	5f                   	pop    %edi
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    

00800d76 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	57                   	push   %edi
  800d7a:	56                   	push   %esi
  800d7b:	53                   	push   %ebx
  800d7c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d84:	8b 55 08             	mov    0x8(%ebp),%edx
  800d87:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d8c:	89 cb                	mov    %ecx,%ebx
  800d8e:	89 cf                	mov    %ecx,%edi
  800d90:	89 ce                	mov    %ecx,%esi
  800d92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d94:	85 c0                	test   %eax,%eax
  800d96:	7f 08                	jg     800da0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	83 ec 0c             	sub    $0xc,%esp
  800da3:	50                   	push   %eax
  800da4:	6a 0d                	push   $0xd
  800da6:	68 1f 27 80 00       	push   $0x80271f
  800dab:	6a 23                	push   $0x23
  800dad:	68 3c 27 80 00       	push   $0x80273c
  800db2:	e8 1c f3 ff ff       	call   8000d3 <_panic>

00800db7 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	57                   	push   %edi
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
  800dbd:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  800dc3:	6a 00                	push   $0x0
  800dc5:	ff 75 08             	pushl  0x8(%ebp)
  800dc8:	e8 ed 0c 00 00       	call   801aba <open>
  800dcd:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  800dd3:	83 c4 10             	add    $0x10,%esp
  800dd6:	85 c0                	test   %eax,%eax
  800dd8:	0f 88 40 03 00 00    	js     80111e <spawn+0x367>
  800dde:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	68 00 02 00 00       	push   $0x200
  800de8:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  800dee:	50                   	push   %eax
  800def:	52                   	push   %edx
  800df0:	e8 9e 08 00 00       	call   801693 <readn>
  800df5:	83 c4 10             	add    $0x10,%esp
  800df8:	3d 00 02 00 00       	cmp    $0x200,%eax
  800dfd:	75 5d                	jne    800e5c <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  800dff:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  800e06:	45 4c 46 
  800e09:	75 51                	jne    800e5c <spawn+0xa5>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800e0b:	b8 07 00 00 00       	mov    $0x7,%eax
  800e10:	cd 30                	int    $0x30
  800e12:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  800e18:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  800e1e:	85 c0                	test   %eax,%eax
  800e20:	0f 88 2f 04 00 00    	js     801255 <spawn+0x49e>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  800e26:	25 ff 03 00 00       	and    $0x3ff,%eax
  800e2b:	6b f0 7c             	imul   $0x7c,%eax,%esi
  800e2e:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  800e34:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  800e3a:	b9 11 00 00 00       	mov    $0x11,%ecx
  800e3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  800e41:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  800e47:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  800e4d:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  800e52:	be 00 00 00 00       	mov    $0x0,%esi
  800e57:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e5a:	eb 4b                	jmp    800ea7 <spawn+0xf0>
		close(fd);
  800e5c:	83 ec 0c             	sub    $0xc,%esp
  800e5f:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  800e65:	e8 66 06 00 00       	call   8014d0 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  800e6a:	83 c4 0c             	add    $0xc,%esp
  800e6d:	68 7f 45 4c 46       	push   $0x464c457f
  800e72:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  800e78:	68 4a 27 80 00       	push   $0x80274a
  800e7d:	e8 2c f3 ff ff       	call   8001ae <cprintf>
		return -E_NOT_EXEC;
  800e82:	83 c4 10             	add    $0x10,%esp
  800e85:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  800e8c:	ff ff ff 
  800e8f:	e9 8a 02 00 00       	jmp    80111e <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  800e94:	83 ec 0c             	sub    $0xc,%esp
  800e97:	50                   	push   %eax
  800e98:	e8 f9 f8 ff ff       	call   800796 <strlen>
  800e9d:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  800ea1:	83 c3 01             	add    $0x1,%ebx
  800ea4:	83 c4 10             	add    $0x10,%esp
  800ea7:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  800eae:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800eb1:	85 c0                	test   %eax,%eax
  800eb3:	75 df                	jne    800e94 <spawn+0xdd>
  800eb5:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  800ebb:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  800ec1:	bf 00 10 40 00       	mov    $0x401000,%edi
  800ec6:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  800ec8:	89 fa                	mov    %edi,%edx
  800eca:	83 e2 fc             	and    $0xfffffffc,%edx
  800ecd:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  800ed4:	29 c2                	sub    %eax,%edx
  800ed6:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  800edc:	8d 42 f8             	lea    -0x8(%edx),%eax
  800edf:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  800ee4:	0f 86 7c 03 00 00    	jbe    801266 <spawn+0x4af>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800eea:	83 ec 04             	sub    $0x4,%esp
  800eed:	6a 07                	push   $0x7
  800eef:	68 00 00 40 00       	push   $0x400000
  800ef4:	6a 00                	push   $0x0
  800ef6:	e8 cb fc ff ff       	call   800bc6 <sys_page_alloc>
  800efb:	83 c4 10             	add    $0x10,%esp
  800efe:	85 c0                	test   %eax,%eax
  800f00:	0f 88 65 03 00 00    	js     80126b <spawn+0x4b4>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  800f06:	be 00 00 00 00       	mov    $0x0,%esi
  800f0b:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  800f11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f14:	eb 30                	jmp    800f46 <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  800f16:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  800f1c:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  800f22:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 34 b3             	pushl  (%ebx,%esi,4)
  800f2b:	57                   	push   %edi
  800f2c:	e8 9c f8 ff ff       	call   8007cd <strcpy>
		string_store += strlen(argv[i]) + 1;
  800f31:	83 c4 04             	add    $0x4,%esp
  800f34:	ff 34 b3             	pushl  (%ebx,%esi,4)
  800f37:	e8 5a f8 ff ff       	call   800796 <strlen>
  800f3c:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  800f40:	83 c6 01             	add    $0x1,%esi
  800f43:	83 c4 10             	add    $0x10,%esp
  800f46:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  800f4c:	7f c8                	jg     800f16 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  800f4e:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  800f54:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  800f5a:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  800f61:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  800f67:	0f 85 8c 00 00 00    	jne    800ff9 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  800f6d:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  800f73:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  800f79:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  800f7c:	89 f8                	mov    %edi,%eax
  800f7e:	8b 8d 88 fd ff ff    	mov    -0x278(%ebp),%ecx
  800f84:	89 4f f8             	mov    %ecx,-0x8(%edi)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  800f87:	2d 08 30 80 11       	sub    $0x11803008,%eax
  800f8c:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  800f92:	83 ec 0c             	sub    $0xc,%esp
  800f95:	6a 07                	push   $0x7
  800f97:	68 00 d0 bf ee       	push   $0xeebfd000
  800f9c:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  800fa2:	68 00 00 40 00       	push   $0x400000
  800fa7:	6a 00                	push   $0x0
  800fa9:	e8 5b fc ff ff       	call   800c09 <sys_page_map>
  800fae:	89 c3                	mov    %eax,%ebx
  800fb0:	83 c4 20             	add    $0x20,%esp
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	0f 88 d0 02 00 00    	js     80128b <spawn+0x4d4>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  800fbb:	83 ec 08             	sub    $0x8,%esp
  800fbe:	68 00 00 40 00       	push   $0x400000
  800fc3:	6a 00                	push   $0x0
  800fc5:	e8 81 fc ff ff       	call   800c4b <sys_page_unmap>
  800fca:	89 c3                	mov    %eax,%ebx
  800fcc:	83 c4 10             	add    $0x10,%esp
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	0f 88 b4 02 00 00    	js     80128b <spawn+0x4d4>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  800fd7:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  800fdd:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  800fe4:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  800fea:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  800ff1:	00 00 00 
  800ff4:	e9 56 01 00 00       	jmp    80114f <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  800ff9:	68 d4 27 80 00       	push   $0x8027d4
  800ffe:	68 64 27 80 00       	push   $0x802764
  801003:	68 f2 00 00 00       	push   $0xf2
  801008:	68 79 27 80 00       	push   $0x802779
  80100d:	e8 c1 f0 ff ff       	call   8000d3 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801012:	83 ec 04             	sub    $0x4,%esp
  801015:	6a 07                	push   $0x7
  801017:	68 00 00 40 00       	push   $0x400000
  80101c:	6a 00                	push   $0x0
  80101e:	e8 a3 fb ff ff       	call   800bc6 <sys_page_alloc>
  801023:	83 c4 10             	add    $0x10,%esp
  801026:	85 c0                	test   %eax,%eax
  801028:	0f 88 48 02 00 00    	js     801276 <spawn+0x4bf>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80102e:	83 ec 08             	sub    $0x8,%esp
  801031:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801037:	01 f0                	add    %esi,%eax
  801039:	50                   	push   %eax
  80103a:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801040:	e8 17 07 00 00       	call   80175c <seek>
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	85 c0                	test   %eax,%eax
  80104a:	0f 88 2d 02 00 00    	js     80127d <spawn+0x4c6>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801050:	83 ec 04             	sub    $0x4,%esp
  801053:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801059:	29 f0                	sub    %esi,%eax
  80105b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801060:	ba 00 10 00 00       	mov    $0x1000,%edx
  801065:	0f 47 c2             	cmova  %edx,%eax
  801068:	50                   	push   %eax
  801069:	68 00 00 40 00       	push   $0x400000
  80106e:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801074:	e8 1a 06 00 00       	call   801693 <readn>
  801079:	83 c4 10             	add    $0x10,%esp
  80107c:	85 c0                	test   %eax,%eax
  80107e:	0f 88 00 02 00 00    	js     801284 <spawn+0x4cd>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801084:	83 ec 0c             	sub    $0xc,%esp
  801087:	57                   	push   %edi
  801088:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  80108e:	56                   	push   %esi
  80108f:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801095:	68 00 00 40 00       	push   $0x400000
  80109a:	6a 00                	push   $0x0
  80109c:	e8 68 fb ff ff       	call   800c09 <sys_page_map>
  8010a1:	83 c4 20             	add    $0x20,%esp
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	0f 88 80 00 00 00    	js     80112c <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8010ac:	83 ec 08             	sub    $0x8,%esp
  8010af:	68 00 00 40 00       	push   $0x400000
  8010b4:	6a 00                	push   $0x0
  8010b6:	e8 90 fb ff ff       	call   800c4b <sys_page_unmap>
  8010bb:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8010be:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010c4:	89 de                	mov    %ebx,%esi
  8010c6:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  8010cc:	76 73                	jbe    801141 <spawn+0x38a>
		if (i >= filesz) {
  8010ce:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  8010d4:	0f 87 38 ff ff ff    	ja     801012 <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8010da:	83 ec 04             	sub    $0x4,%esp
  8010dd:	57                   	push   %edi
  8010de:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  8010e4:	56                   	push   %esi
  8010e5:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  8010eb:	e8 d6 fa ff ff       	call   800bc6 <sys_page_alloc>
  8010f0:	83 c4 10             	add    $0x10,%esp
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	79 c7                	jns    8010be <spawn+0x307>
  8010f7:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8010f9:	83 ec 0c             	sub    $0xc,%esp
  8010fc:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801102:	e8 40 fa ff ff       	call   800b47 <sys_env_destroy>
	close(fd);
  801107:	83 c4 04             	add    $0x4,%esp
  80110a:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801110:	e8 bb 03 00 00       	call   8014d0 <close>
	return r;
  801115:	83 c4 10             	add    $0x10,%esp
  801118:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  80111e:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801124:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801127:	5b                   	pop    %ebx
  801128:	5e                   	pop    %esi
  801129:	5f                   	pop    %edi
  80112a:	5d                   	pop    %ebp
  80112b:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  80112c:	50                   	push   %eax
  80112d:	68 85 27 80 00       	push   $0x802785
  801132:	68 25 01 00 00       	push   $0x125
  801137:	68 79 27 80 00       	push   $0x802779
  80113c:	e8 92 ef ff ff       	call   8000d3 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801141:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801148:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  80114f:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801156:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  80115c:	7e 71                	jle    8011cf <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  80115e:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  801164:	83 39 01             	cmpl   $0x1,(%ecx)
  801167:	75 d8                	jne    801141 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801169:	8b 41 18             	mov    0x18(%ecx),%eax
  80116c:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  80116f:	83 f8 01             	cmp    $0x1,%eax
  801172:	19 ff                	sbb    %edi,%edi
  801174:	83 e7 fe             	and    $0xfffffffe,%edi
  801177:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80117a:	8b 59 04             	mov    0x4(%ecx),%ebx
  80117d:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
  801183:	8b 71 10             	mov    0x10(%ecx),%esi
  801186:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
  80118c:	8b 41 14             	mov    0x14(%ecx),%eax
  80118f:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801195:	8b 51 08             	mov    0x8(%ecx),%edx
  801198:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
	if ((i = PGOFF(va))) {
  80119e:	89 d0                	mov    %edx,%eax
  8011a0:	25 ff 0f 00 00       	and    $0xfff,%eax
  8011a5:	74 1e                	je     8011c5 <spawn+0x40e>
		va -= i;
  8011a7:	29 c2                	sub    %eax,%edx
  8011a9:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		memsz += i;
  8011af:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  8011b5:	01 c6                	add    %eax,%esi
  8011b7:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
		fileoffset -= i;
  8011bd:	29 c3                	sub    %eax,%ebx
  8011bf:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  8011c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ca:	e9 f5 fe ff ff       	jmp    8010c4 <spawn+0x30d>
	close(fd);
  8011cf:	83 ec 0c             	sub    $0xc,%esp
  8011d2:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8011d8:	e8 f3 02 00 00       	call   8014d0 <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  8011dd:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  8011e4:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8011e7:	83 c4 08             	add    $0x8,%esp
  8011ea:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8011f0:	50                   	push   %eax
  8011f1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8011f7:	e8 d3 fa ff ff       	call   800ccf <sys_env_set_trapframe>
  8011fc:	83 c4 10             	add    $0x10,%esp
  8011ff:	85 c0                	test   %eax,%eax
  801201:	78 28                	js     80122b <spawn+0x474>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	6a 02                	push   $0x2
  801208:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80120e:	e8 7a fa ff ff       	call   800c8d <sys_env_set_status>
  801213:	83 c4 10             	add    $0x10,%esp
  801216:	85 c0                	test   %eax,%eax
  801218:	78 26                	js     801240 <spawn+0x489>
	return child;
  80121a:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801220:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801226:	e9 f3 fe ff ff       	jmp    80111e <spawn+0x367>
		panic("sys_env_set_trapframe: %e", r);
  80122b:	50                   	push   %eax
  80122c:	68 a2 27 80 00       	push   $0x8027a2
  801231:	68 86 00 00 00       	push   $0x86
  801236:	68 79 27 80 00       	push   $0x802779
  80123b:	e8 93 ee ff ff       	call   8000d3 <_panic>
		panic("sys_env_set_status: %e", r);
  801240:	50                   	push   %eax
  801241:	68 bc 27 80 00       	push   $0x8027bc
  801246:	68 89 00 00 00       	push   $0x89
  80124b:	68 79 27 80 00       	push   $0x802779
  801250:	e8 7e ee ff ff       	call   8000d3 <_panic>
		return r;
  801255:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80125b:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801261:	e9 b8 fe ff ff       	jmp    80111e <spawn+0x367>
		return -E_NO_MEM;
  801266:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  80126b:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801271:	e9 a8 fe ff ff       	jmp    80111e <spawn+0x367>
  801276:	89 c7                	mov    %eax,%edi
  801278:	e9 7c fe ff ff       	jmp    8010f9 <spawn+0x342>
  80127d:	89 c7                	mov    %eax,%edi
  80127f:	e9 75 fe ff ff       	jmp    8010f9 <spawn+0x342>
  801284:	89 c7                	mov    %eax,%edi
  801286:	e9 6e fe ff ff       	jmp    8010f9 <spawn+0x342>
	sys_page_unmap(0, UTEMP);
  80128b:	83 ec 08             	sub    $0x8,%esp
  80128e:	68 00 00 40 00       	push   $0x400000
  801293:	6a 00                	push   $0x0
  801295:	e8 b1 f9 ff ff       	call   800c4b <sys_page_unmap>
  80129a:	83 c4 10             	add    $0x10,%esp
  80129d:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  8012a3:	e9 76 fe ff ff       	jmp    80111e <spawn+0x367>

008012a8 <spawnl>:
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	57                   	push   %edi
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  8012b1:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  8012b4:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8012b9:	eb 05                	jmp    8012c0 <spawnl+0x18>
		argc++;
  8012bb:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8012be:	89 ca                	mov    %ecx,%edx
  8012c0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8012c3:	83 3a 00             	cmpl   $0x0,(%edx)
  8012c6:	75 f3                	jne    8012bb <spawnl+0x13>
	const char *argv[argc+2];
  8012c8:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  8012cf:	83 e2 f0             	and    $0xfffffff0,%edx
  8012d2:	29 d4                	sub    %edx,%esp
  8012d4:	8d 54 24 03          	lea    0x3(%esp),%edx
  8012d8:	c1 ea 02             	shr    $0x2,%edx
  8012db:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8012e2:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8012e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e7:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8012ee:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8012f5:	00 
	va_start(vl, arg0);
  8012f6:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8012f9:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8012fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801300:	eb 0b                	jmp    80130d <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801302:	83 c0 01             	add    $0x1,%eax
  801305:	8b 39                	mov    (%ecx),%edi
  801307:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80130a:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  80130d:	39 d0                	cmp    %edx,%eax
  80130f:	75 f1                	jne    801302 <spawnl+0x5a>
	return spawn(prog, argv);
  801311:	83 ec 08             	sub    $0x8,%esp
  801314:	56                   	push   %esi
  801315:	ff 75 08             	pushl  0x8(%ebp)
  801318:	e8 9a fa ff ff       	call   800db7 <spawn>
}
  80131d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801320:	5b                   	pop    %ebx
  801321:	5e                   	pop    %esi
  801322:	5f                   	pop    %edi
  801323:	5d                   	pop    %ebp
  801324:	c3                   	ret    

00801325 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	05 00 00 00 30       	add    $0x30000000,%eax
  801330:	c1 e8 0c             	shr    $0xc,%eax
}
  801333:	5d                   	pop    %ebp
  801334:	c3                   	ret    

00801335 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801340:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801345:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80134a:	5d                   	pop    %ebp
  80134b:	c3                   	ret    

0080134c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801352:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801357:	89 c2                	mov    %eax,%edx
  801359:	c1 ea 16             	shr    $0x16,%edx
  80135c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801363:	f6 c2 01             	test   $0x1,%dl
  801366:	74 2a                	je     801392 <fd_alloc+0x46>
  801368:	89 c2                	mov    %eax,%edx
  80136a:	c1 ea 0c             	shr    $0xc,%edx
  80136d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801374:	f6 c2 01             	test   $0x1,%dl
  801377:	74 19                	je     801392 <fd_alloc+0x46>
  801379:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80137e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801383:	75 d2                	jne    801357 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801385:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80138b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801390:	eb 07                	jmp    801399 <fd_alloc+0x4d>
			*fd_store = fd;
  801392:	89 01                	mov    %eax,(%ecx)
			return 0;
  801394:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801399:	5d                   	pop    %ebp
  80139a:	c3                   	ret    

0080139b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013a1:	83 f8 1f             	cmp    $0x1f,%eax
  8013a4:	77 36                	ja     8013dc <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013a6:	c1 e0 0c             	shl    $0xc,%eax
  8013a9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013ae:	89 c2                	mov    %eax,%edx
  8013b0:	c1 ea 16             	shr    $0x16,%edx
  8013b3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013ba:	f6 c2 01             	test   $0x1,%dl
  8013bd:	74 24                	je     8013e3 <fd_lookup+0x48>
  8013bf:	89 c2                	mov    %eax,%edx
  8013c1:	c1 ea 0c             	shr    $0xc,%edx
  8013c4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013cb:	f6 c2 01             	test   $0x1,%dl
  8013ce:	74 1a                	je     8013ea <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d3:	89 02                	mov    %eax,(%edx)
	return 0;
  8013d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013da:	5d                   	pop    %ebp
  8013db:	c3                   	ret    
		return -E_INVAL;
  8013dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e1:	eb f7                	jmp    8013da <fd_lookup+0x3f>
		return -E_INVAL;
  8013e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e8:	eb f0                	jmp    8013da <fd_lookup+0x3f>
  8013ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ef:	eb e9                	jmp    8013da <fd_lookup+0x3f>

008013f1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 08             	sub    $0x8,%esp
  8013f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013fa:	ba 7c 28 80 00       	mov    $0x80287c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013ff:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801404:	39 08                	cmp    %ecx,(%eax)
  801406:	74 33                	je     80143b <dev_lookup+0x4a>
  801408:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80140b:	8b 02                	mov    (%edx),%eax
  80140d:	85 c0                	test   %eax,%eax
  80140f:	75 f3                	jne    801404 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801411:	a1 04 40 80 00       	mov    0x804004,%eax
  801416:	8b 40 48             	mov    0x48(%eax),%eax
  801419:	83 ec 04             	sub    $0x4,%esp
  80141c:	51                   	push   %ecx
  80141d:	50                   	push   %eax
  80141e:	68 fc 27 80 00       	push   $0x8027fc
  801423:	e8 86 ed ff ff       	call   8001ae <cprintf>
	*dev = 0;
  801428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801431:	83 c4 10             	add    $0x10,%esp
  801434:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801439:	c9                   	leave  
  80143a:	c3                   	ret    
			*dev = devtab[i];
  80143b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80143e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801440:	b8 00 00 00 00       	mov    $0x0,%eax
  801445:	eb f2                	jmp    801439 <dev_lookup+0x48>

00801447 <fd_close>:
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	57                   	push   %edi
  80144b:	56                   	push   %esi
  80144c:	53                   	push   %ebx
  80144d:	83 ec 1c             	sub    $0x1c,%esp
  801450:	8b 75 08             	mov    0x8(%ebp),%esi
  801453:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801456:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801459:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80145a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801460:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801463:	50                   	push   %eax
  801464:	e8 32 ff ff ff       	call   80139b <fd_lookup>
  801469:	89 c3                	mov    %eax,%ebx
  80146b:	83 c4 08             	add    $0x8,%esp
  80146e:	85 c0                	test   %eax,%eax
  801470:	78 05                	js     801477 <fd_close+0x30>
	    || fd != fd2)
  801472:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801475:	74 16                	je     80148d <fd_close+0x46>
		return (must_exist ? r : 0);
  801477:	89 f8                	mov    %edi,%eax
  801479:	84 c0                	test   %al,%al
  80147b:	b8 00 00 00 00       	mov    $0x0,%eax
  801480:	0f 44 d8             	cmove  %eax,%ebx
}
  801483:	89 d8                	mov    %ebx,%eax
  801485:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801488:	5b                   	pop    %ebx
  801489:	5e                   	pop    %esi
  80148a:	5f                   	pop    %edi
  80148b:	5d                   	pop    %ebp
  80148c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80148d:	83 ec 08             	sub    $0x8,%esp
  801490:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801493:	50                   	push   %eax
  801494:	ff 36                	pushl  (%esi)
  801496:	e8 56 ff ff ff       	call   8013f1 <dev_lookup>
  80149b:	89 c3                	mov    %eax,%ebx
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	78 15                	js     8014b9 <fd_close+0x72>
		if (dev->dev_close)
  8014a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a7:	8b 40 10             	mov    0x10(%eax),%eax
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	74 1b                	je     8014c9 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8014ae:	83 ec 0c             	sub    $0xc,%esp
  8014b1:	56                   	push   %esi
  8014b2:	ff d0                	call   *%eax
  8014b4:	89 c3                	mov    %eax,%ebx
  8014b6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	56                   	push   %esi
  8014bd:	6a 00                	push   $0x0
  8014bf:	e8 87 f7 ff ff       	call   800c4b <sys_page_unmap>
	return r;
  8014c4:	83 c4 10             	add    $0x10,%esp
  8014c7:	eb ba                	jmp    801483 <fd_close+0x3c>
			r = 0;
  8014c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014ce:	eb e9                	jmp    8014b9 <fd_close+0x72>

008014d0 <close>:

int
close(int fdnum)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d9:	50                   	push   %eax
  8014da:	ff 75 08             	pushl  0x8(%ebp)
  8014dd:	e8 b9 fe ff ff       	call   80139b <fd_lookup>
  8014e2:	83 c4 08             	add    $0x8,%esp
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	78 10                	js     8014f9 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8014e9:	83 ec 08             	sub    $0x8,%esp
  8014ec:	6a 01                	push   $0x1
  8014ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f1:	e8 51 ff ff ff       	call   801447 <fd_close>
  8014f6:	83 c4 10             	add    $0x10,%esp
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <close_all>:

void
close_all(void)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	53                   	push   %ebx
  8014ff:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801502:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801507:	83 ec 0c             	sub    $0xc,%esp
  80150a:	53                   	push   %ebx
  80150b:	e8 c0 ff ff ff       	call   8014d0 <close>
	for (i = 0; i < MAXFD; i++)
  801510:	83 c3 01             	add    $0x1,%ebx
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	83 fb 20             	cmp    $0x20,%ebx
  801519:	75 ec                	jne    801507 <close_all+0xc>
}
  80151b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	57                   	push   %edi
  801524:	56                   	push   %esi
  801525:	53                   	push   %ebx
  801526:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801529:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80152c:	50                   	push   %eax
  80152d:	ff 75 08             	pushl  0x8(%ebp)
  801530:	e8 66 fe ff ff       	call   80139b <fd_lookup>
  801535:	89 c3                	mov    %eax,%ebx
  801537:	83 c4 08             	add    $0x8,%esp
  80153a:	85 c0                	test   %eax,%eax
  80153c:	0f 88 81 00 00 00    	js     8015c3 <dup+0xa3>
		return r;
	close(newfdnum);
  801542:	83 ec 0c             	sub    $0xc,%esp
  801545:	ff 75 0c             	pushl  0xc(%ebp)
  801548:	e8 83 ff ff ff       	call   8014d0 <close>

	newfd = INDEX2FD(newfdnum);
  80154d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801550:	c1 e6 0c             	shl    $0xc,%esi
  801553:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801559:	83 c4 04             	add    $0x4,%esp
  80155c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80155f:	e8 d1 fd ff ff       	call   801335 <fd2data>
  801564:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801566:	89 34 24             	mov    %esi,(%esp)
  801569:	e8 c7 fd ff ff       	call   801335 <fd2data>
  80156e:	83 c4 10             	add    $0x10,%esp
  801571:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801573:	89 d8                	mov    %ebx,%eax
  801575:	c1 e8 16             	shr    $0x16,%eax
  801578:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80157f:	a8 01                	test   $0x1,%al
  801581:	74 11                	je     801594 <dup+0x74>
  801583:	89 d8                	mov    %ebx,%eax
  801585:	c1 e8 0c             	shr    $0xc,%eax
  801588:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80158f:	f6 c2 01             	test   $0x1,%dl
  801592:	75 39                	jne    8015cd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801594:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801597:	89 d0                	mov    %edx,%eax
  801599:	c1 e8 0c             	shr    $0xc,%eax
  80159c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015a3:	83 ec 0c             	sub    $0xc,%esp
  8015a6:	25 07 0e 00 00       	and    $0xe07,%eax
  8015ab:	50                   	push   %eax
  8015ac:	56                   	push   %esi
  8015ad:	6a 00                	push   $0x0
  8015af:	52                   	push   %edx
  8015b0:	6a 00                	push   $0x0
  8015b2:	e8 52 f6 ff ff       	call   800c09 <sys_page_map>
  8015b7:	89 c3                	mov    %eax,%ebx
  8015b9:	83 c4 20             	add    $0x20,%esp
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	78 31                	js     8015f1 <dup+0xd1>
		goto err;

	return newfdnum;
  8015c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015c3:	89 d8                	mov    %ebx,%eax
  8015c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015c8:	5b                   	pop    %ebx
  8015c9:	5e                   	pop    %esi
  8015ca:	5f                   	pop    %edi
  8015cb:	5d                   	pop    %ebp
  8015cc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015cd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015d4:	83 ec 0c             	sub    $0xc,%esp
  8015d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8015dc:	50                   	push   %eax
  8015dd:	57                   	push   %edi
  8015de:	6a 00                	push   $0x0
  8015e0:	53                   	push   %ebx
  8015e1:	6a 00                	push   $0x0
  8015e3:	e8 21 f6 ff ff       	call   800c09 <sys_page_map>
  8015e8:	89 c3                	mov    %eax,%ebx
  8015ea:	83 c4 20             	add    $0x20,%esp
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	79 a3                	jns    801594 <dup+0x74>
	sys_page_unmap(0, newfd);
  8015f1:	83 ec 08             	sub    $0x8,%esp
  8015f4:	56                   	push   %esi
  8015f5:	6a 00                	push   $0x0
  8015f7:	e8 4f f6 ff ff       	call   800c4b <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015fc:	83 c4 08             	add    $0x8,%esp
  8015ff:	57                   	push   %edi
  801600:	6a 00                	push   $0x0
  801602:	e8 44 f6 ff ff       	call   800c4b <sys_page_unmap>
	return r;
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	eb b7                	jmp    8015c3 <dup+0xa3>

0080160c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	53                   	push   %ebx
  801610:	83 ec 14             	sub    $0x14,%esp
  801613:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801616:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801619:	50                   	push   %eax
  80161a:	53                   	push   %ebx
  80161b:	e8 7b fd ff ff       	call   80139b <fd_lookup>
  801620:	83 c4 08             	add    $0x8,%esp
  801623:	85 c0                	test   %eax,%eax
  801625:	78 3f                	js     801666 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162d:	50                   	push   %eax
  80162e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801631:	ff 30                	pushl  (%eax)
  801633:	e8 b9 fd ff ff       	call   8013f1 <dev_lookup>
  801638:	83 c4 10             	add    $0x10,%esp
  80163b:	85 c0                	test   %eax,%eax
  80163d:	78 27                	js     801666 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80163f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801642:	8b 42 08             	mov    0x8(%edx),%eax
  801645:	83 e0 03             	and    $0x3,%eax
  801648:	83 f8 01             	cmp    $0x1,%eax
  80164b:	74 1e                	je     80166b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80164d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801650:	8b 40 08             	mov    0x8(%eax),%eax
  801653:	85 c0                	test   %eax,%eax
  801655:	74 35                	je     80168c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801657:	83 ec 04             	sub    $0x4,%esp
  80165a:	ff 75 10             	pushl  0x10(%ebp)
  80165d:	ff 75 0c             	pushl  0xc(%ebp)
  801660:	52                   	push   %edx
  801661:	ff d0                	call   *%eax
  801663:	83 c4 10             	add    $0x10,%esp
}
  801666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801669:	c9                   	leave  
  80166a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80166b:	a1 04 40 80 00       	mov    0x804004,%eax
  801670:	8b 40 48             	mov    0x48(%eax),%eax
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	53                   	push   %ebx
  801677:	50                   	push   %eax
  801678:	68 40 28 80 00       	push   $0x802840
  80167d:	e8 2c eb ff ff       	call   8001ae <cprintf>
		return -E_INVAL;
  801682:	83 c4 10             	add    $0x10,%esp
  801685:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80168a:	eb da                	jmp    801666 <read+0x5a>
		return -E_NOT_SUPP;
  80168c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801691:	eb d3                	jmp    801666 <read+0x5a>

00801693 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	57                   	push   %edi
  801697:	56                   	push   %esi
  801698:	53                   	push   %ebx
  801699:	83 ec 0c             	sub    $0xc,%esp
  80169c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80169f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016a7:	39 f3                	cmp    %esi,%ebx
  8016a9:	73 25                	jae    8016d0 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016ab:	83 ec 04             	sub    $0x4,%esp
  8016ae:	89 f0                	mov    %esi,%eax
  8016b0:	29 d8                	sub    %ebx,%eax
  8016b2:	50                   	push   %eax
  8016b3:	89 d8                	mov    %ebx,%eax
  8016b5:	03 45 0c             	add    0xc(%ebp),%eax
  8016b8:	50                   	push   %eax
  8016b9:	57                   	push   %edi
  8016ba:	e8 4d ff ff ff       	call   80160c <read>
		if (m < 0)
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	78 08                	js     8016ce <readn+0x3b>
			return m;
		if (m == 0)
  8016c6:	85 c0                	test   %eax,%eax
  8016c8:	74 06                	je     8016d0 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8016ca:	01 c3                	add    %eax,%ebx
  8016cc:	eb d9                	jmp    8016a7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016ce:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016d0:	89 d8                	mov    %ebx,%eax
  8016d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d5:	5b                   	pop    %ebx
  8016d6:	5e                   	pop    %esi
  8016d7:	5f                   	pop    %edi
  8016d8:	5d                   	pop    %ebp
  8016d9:	c3                   	ret    

008016da <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 14             	sub    $0x14,%esp
  8016e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e7:	50                   	push   %eax
  8016e8:	53                   	push   %ebx
  8016e9:	e8 ad fc ff ff       	call   80139b <fd_lookup>
  8016ee:	83 c4 08             	add    $0x8,%esp
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	78 3a                	js     80172f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f5:	83 ec 08             	sub    $0x8,%esp
  8016f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016fb:	50                   	push   %eax
  8016fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ff:	ff 30                	pushl  (%eax)
  801701:	e8 eb fc ff ff       	call   8013f1 <dev_lookup>
  801706:	83 c4 10             	add    $0x10,%esp
  801709:	85 c0                	test   %eax,%eax
  80170b:	78 22                	js     80172f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80170d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801710:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801714:	74 1e                	je     801734 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801716:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801719:	8b 52 0c             	mov    0xc(%edx),%edx
  80171c:	85 d2                	test   %edx,%edx
  80171e:	74 35                	je     801755 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801720:	83 ec 04             	sub    $0x4,%esp
  801723:	ff 75 10             	pushl  0x10(%ebp)
  801726:	ff 75 0c             	pushl  0xc(%ebp)
  801729:	50                   	push   %eax
  80172a:	ff d2                	call   *%edx
  80172c:	83 c4 10             	add    $0x10,%esp
}
  80172f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801732:	c9                   	leave  
  801733:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801734:	a1 04 40 80 00       	mov    0x804004,%eax
  801739:	8b 40 48             	mov    0x48(%eax),%eax
  80173c:	83 ec 04             	sub    $0x4,%esp
  80173f:	53                   	push   %ebx
  801740:	50                   	push   %eax
  801741:	68 5c 28 80 00       	push   $0x80285c
  801746:	e8 63 ea ff ff       	call   8001ae <cprintf>
		return -E_INVAL;
  80174b:	83 c4 10             	add    $0x10,%esp
  80174e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801753:	eb da                	jmp    80172f <write+0x55>
		return -E_NOT_SUPP;
  801755:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80175a:	eb d3                	jmp    80172f <write+0x55>

0080175c <seek>:

int
seek(int fdnum, off_t offset)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801762:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801765:	50                   	push   %eax
  801766:	ff 75 08             	pushl  0x8(%ebp)
  801769:	e8 2d fc ff ff       	call   80139b <fd_lookup>
  80176e:	83 c4 08             	add    $0x8,%esp
  801771:	85 c0                	test   %eax,%eax
  801773:	78 0e                	js     801783 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801775:	8b 55 0c             	mov    0xc(%ebp),%edx
  801778:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80177e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	53                   	push   %ebx
  801789:	83 ec 14             	sub    $0x14,%esp
  80178c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801792:	50                   	push   %eax
  801793:	53                   	push   %ebx
  801794:	e8 02 fc ff ff       	call   80139b <fd_lookup>
  801799:	83 c4 08             	add    $0x8,%esp
  80179c:	85 c0                	test   %eax,%eax
  80179e:	78 37                	js     8017d7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a0:	83 ec 08             	sub    $0x8,%esp
  8017a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a6:	50                   	push   %eax
  8017a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017aa:	ff 30                	pushl  (%eax)
  8017ac:	e8 40 fc ff ff       	call   8013f1 <dev_lookup>
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	78 1f                	js     8017d7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017bf:	74 1b                	je     8017dc <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c4:	8b 52 18             	mov    0x18(%edx),%edx
  8017c7:	85 d2                	test   %edx,%edx
  8017c9:	74 32                	je     8017fd <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017cb:	83 ec 08             	sub    $0x8,%esp
  8017ce:	ff 75 0c             	pushl  0xc(%ebp)
  8017d1:	50                   	push   %eax
  8017d2:	ff d2                	call   *%edx
  8017d4:	83 c4 10             	add    $0x10,%esp
}
  8017d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017dc:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017e1:	8b 40 48             	mov    0x48(%eax),%eax
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	53                   	push   %ebx
  8017e8:	50                   	push   %eax
  8017e9:	68 1c 28 80 00       	push   $0x80281c
  8017ee:	e8 bb e9 ff ff       	call   8001ae <cprintf>
		return -E_INVAL;
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017fb:	eb da                	jmp    8017d7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8017fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801802:	eb d3                	jmp    8017d7 <ftruncate+0x52>

00801804 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	53                   	push   %ebx
  801808:	83 ec 14             	sub    $0x14,%esp
  80180b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80180e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801811:	50                   	push   %eax
  801812:	ff 75 08             	pushl  0x8(%ebp)
  801815:	e8 81 fb ff ff       	call   80139b <fd_lookup>
  80181a:	83 c4 08             	add    $0x8,%esp
  80181d:	85 c0                	test   %eax,%eax
  80181f:	78 4b                	js     80186c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801821:	83 ec 08             	sub    $0x8,%esp
  801824:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801827:	50                   	push   %eax
  801828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182b:	ff 30                	pushl  (%eax)
  80182d:	e8 bf fb ff ff       	call   8013f1 <dev_lookup>
  801832:	83 c4 10             	add    $0x10,%esp
  801835:	85 c0                	test   %eax,%eax
  801837:	78 33                	js     80186c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801840:	74 2f                	je     801871 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801842:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801845:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80184c:	00 00 00 
	stat->st_isdir = 0;
  80184f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801856:	00 00 00 
	stat->st_dev = dev;
  801859:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80185f:	83 ec 08             	sub    $0x8,%esp
  801862:	53                   	push   %ebx
  801863:	ff 75 f0             	pushl  -0x10(%ebp)
  801866:	ff 50 14             	call   *0x14(%eax)
  801869:	83 c4 10             	add    $0x10,%esp
}
  80186c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186f:	c9                   	leave  
  801870:	c3                   	ret    
		return -E_NOT_SUPP;
  801871:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801876:	eb f4                	jmp    80186c <fstat+0x68>

00801878 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	56                   	push   %esi
  80187c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80187d:	83 ec 08             	sub    $0x8,%esp
  801880:	6a 00                	push   $0x0
  801882:	ff 75 08             	pushl  0x8(%ebp)
  801885:	e8 30 02 00 00       	call   801aba <open>
  80188a:	89 c3                	mov    %eax,%ebx
  80188c:	83 c4 10             	add    $0x10,%esp
  80188f:	85 c0                	test   %eax,%eax
  801891:	78 1b                	js     8018ae <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801893:	83 ec 08             	sub    $0x8,%esp
  801896:	ff 75 0c             	pushl  0xc(%ebp)
  801899:	50                   	push   %eax
  80189a:	e8 65 ff ff ff       	call   801804 <fstat>
  80189f:	89 c6                	mov    %eax,%esi
	close(fd);
  8018a1:	89 1c 24             	mov    %ebx,(%esp)
  8018a4:	e8 27 fc ff ff       	call   8014d0 <close>
	return r;
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	89 f3                	mov    %esi,%ebx
}
  8018ae:	89 d8                	mov    %ebx,%eax
  8018b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b3:	5b                   	pop    %ebx
  8018b4:	5e                   	pop    %esi
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	56                   	push   %esi
  8018bb:	53                   	push   %ebx
  8018bc:	89 c6                	mov    %eax,%esi
  8018be:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018c0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018c7:	74 27                	je     8018f0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018c9:	6a 07                	push   $0x7
  8018cb:	68 00 50 80 00       	push   $0x805000
  8018d0:	56                   	push   %esi
  8018d1:	ff 35 00 40 80 00    	pushl  0x804000
  8018d7:	e8 b6 07 00 00       	call   802092 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018dc:	83 c4 0c             	add    $0xc,%esp
  8018df:	6a 00                	push   $0x0
  8018e1:	53                   	push   %ebx
  8018e2:	6a 00                	push   $0x0
  8018e4:	e8 40 07 00 00       	call   802029 <ipc_recv>
}
  8018e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ec:	5b                   	pop    %ebx
  8018ed:	5e                   	pop    %esi
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018f0:	83 ec 0c             	sub    $0xc,%esp
  8018f3:	6a 01                	push   $0x1
  8018f5:	e8 ec 07 00 00       	call   8020e6 <ipc_find_env>
  8018fa:	a3 00 40 80 00       	mov    %eax,0x804000
  8018ff:	83 c4 10             	add    $0x10,%esp
  801902:	eb c5                	jmp    8018c9 <fsipc+0x12>

00801904 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	8b 40 0c             	mov    0xc(%eax),%eax
  801910:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801915:	8b 45 0c             	mov    0xc(%ebp),%eax
  801918:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80191d:	ba 00 00 00 00       	mov    $0x0,%edx
  801922:	b8 02 00 00 00       	mov    $0x2,%eax
  801927:	e8 8b ff ff ff       	call   8018b7 <fsipc>
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <devfile_flush>:
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8b 40 0c             	mov    0xc(%eax),%eax
  80193a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80193f:	ba 00 00 00 00       	mov    $0x0,%edx
  801944:	b8 06 00 00 00       	mov    $0x6,%eax
  801949:	e8 69 ff ff ff       	call   8018b7 <fsipc>
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <devfile_stat>:
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	53                   	push   %ebx
  801954:	83 ec 04             	sub    $0x4,%esp
  801957:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	8b 40 0c             	mov    0xc(%eax),%eax
  801960:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801965:	ba 00 00 00 00       	mov    $0x0,%edx
  80196a:	b8 05 00 00 00       	mov    $0x5,%eax
  80196f:	e8 43 ff ff ff       	call   8018b7 <fsipc>
  801974:	85 c0                	test   %eax,%eax
  801976:	78 2c                	js     8019a4 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801978:	83 ec 08             	sub    $0x8,%esp
  80197b:	68 00 50 80 00       	push   $0x805000
  801980:	53                   	push   %ebx
  801981:	e8 47 ee ff ff       	call   8007cd <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801986:	a1 80 50 80 00       	mov    0x805080,%eax
  80198b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801991:	a1 84 50 80 00       	mov    0x805084,%eax
  801996:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80199c:	83 c4 10             	add    $0x10,%esp
  80199f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <devfile_write>:
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	53                   	push   %ebx
  8019ad:	83 ec 08             	sub    $0x8,%esp
  8019b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  8019b3:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8019b9:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8019be:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8019cc:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8019d2:	53                   	push   %ebx
  8019d3:	ff 75 0c             	pushl  0xc(%ebp)
  8019d6:	68 08 50 80 00       	push   $0x805008
  8019db:	e8 7b ef ff ff       	call   80095b <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e5:	b8 04 00 00 00       	mov    $0x4,%eax
  8019ea:	e8 c8 fe ff ff       	call   8018b7 <fsipc>
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	78 0b                	js     801a01 <devfile_write+0x58>
	assert(r <= n);
  8019f6:	39 d8                	cmp    %ebx,%eax
  8019f8:	77 0c                	ja     801a06 <devfile_write+0x5d>
	assert(r <= PGSIZE);
  8019fa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019ff:	7f 1e                	jg     801a1f <devfile_write+0x76>
}
  801a01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    
	assert(r <= n);
  801a06:	68 8c 28 80 00       	push   $0x80288c
  801a0b:	68 64 27 80 00       	push   $0x802764
  801a10:	68 98 00 00 00       	push   $0x98
  801a15:	68 93 28 80 00       	push   $0x802893
  801a1a:	e8 b4 e6 ff ff       	call   8000d3 <_panic>
	assert(r <= PGSIZE);
  801a1f:	68 9e 28 80 00       	push   $0x80289e
  801a24:	68 64 27 80 00       	push   $0x802764
  801a29:	68 99 00 00 00       	push   $0x99
  801a2e:	68 93 28 80 00       	push   $0x802893
  801a33:	e8 9b e6 ff ff       	call   8000d3 <_panic>

00801a38 <devfile_read>:
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	56                   	push   %esi
  801a3c:	53                   	push   %ebx
  801a3d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	8b 40 0c             	mov    0xc(%eax),%eax
  801a46:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a4b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a51:	ba 00 00 00 00       	mov    $0x0,%edx
  801a56:	b8 03 00 00 00       	mov    $0x3,%eax
  801a5b:	e8 57 fe ff ff       	call   8018b7 <fsipc>
  801a60:	89 c3                	mov    %eax,%ebx
  801a62:	85 c0                	test   %eax,%eax
  801a64:	78 1f                	js     801a85 <devfile_read+0x4d>
	assert(r <= n);
  801a66:	39 f0                	cmp    %esi,%eax
  801a68:	77 24                	ja     801a8e <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a6a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a6f:	7f 33                	jg     801aa4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	50                   	push   %eax
  801a75:	68 00 50 80 00       	push   $0x805000
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	e8 d9 ee ff ff       	call   80095b <memmove>
	return r;
  801a82:	83 c4 10             	add    $0x10,%esp
}
  801a85:	89 d8                	mov    %ebx,%eax
  801a87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8a:	5b                   	pop    %ebx
  801a8b:	5e                   	pop    %esi
  801a8c:	5d                   	pop    %ebp
  801a8d:	c3                   	ret    
	assert(r <= n);
  801a8e:	68 8c 28 80 00       	push   $0x80288c
  801a93:	68 64 27 80 00       	push   $0x802764
  801a98:	6a 7c                	push   $0x7c
  801a9a:	68 93 28 80 00       	push   $0x802893
  801a9f:	e8 2f e6 ff ff       	call   8000d3 <_panic>
	assert(r <= PGSIZE);
  801aa4:	68 9e 28 80 00       	push   $0x80289e
  801aa9:	68 64 27 80 00       	push   $0x802764
  801aae:	6a 7d                	push   $0x7d
  801ab0:	68 93 28 80 00       	push   $0x802893
  801ab5:	e8 19 e6 ff ff       	call   8000d3 <_panic>

00801aba <open>:
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	56                   	push   %esi
  801abe:	53                   	push   %ebx
  801abf:	83 ec 1c             	sub    $0x1c,%esp
  801ac2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ac5:	56                   	push   %esi
  801ac6:	e8 cb ec ff ff       	call   800796 <strlen>
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ad3:	7f 6c                	jg     801b41 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ad5:	83 ec 0c             	sub    $0xc,%esp
  801ad8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801adb:	50                   	push   %eax
  801adc:	e8 6b f8 ff ff       	call   80134c <fd_alloc>
  801ae1:	89 c3                	mov    %eax,%ebx
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	78 3c                	js     801b26 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801aea:	83 ec 08             	sub    $0x8,%esp
  801aed:	56                   	push   %esi
  801aee:	68 00 50 80 00       	push   $0x805000
  801af3:	e8 d5 ec ff ff       	call   8007cd <strcpy>
	fsipcbuf.open.req_omode = mode;
  801af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afb:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b03:	b8 01 00 00 00       	mov    $0x1,%eax
  801b08:	e8 aa fd ff ff       	call   8018b7 <fsipc>
  801b0d:	89 c3                	mov    %eax,%ebx
  801b0f:	83 c4 10             	add    $0x10,%esp
  801b12:	85 c0                	test   %eax,%eax
  801b14:	78 19                	js     801b2f <open+0x75>
	return fd2num(fd);
  801b16:	83 ec 0c             	sub    $0xc,%esp
  801b19:	ff 75 f4             	pushl  -0xc(%ebp)
  801b1c:	e8 04 f8 ff ff       	call   801325 <fd2num>
  801b21:	89 c3                	mov    %eax,%ebx
  801b23:	83 c4 10             	add    $0x10,%esp
}
  801b26:	89 d8                	mov    %ebx,%eax
  801b28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5d                   	pop    %ebp
  801b2e:	c3                   	ret    
		fd_close(fd, 0);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	6a 00                	push   $0x0
  801b34:	ff 75 f4             	pushl  -0xc(%ebp)
  801b37:	e8 0b f9 ff ff       	call   801447 <fd_close>
		return r;
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	eb e5                	jmp    801b26 <open+0x6c>
		return -E_BAD_PATH;
  801b41:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b46:	eb de                	jmp    801b26 <open+0x6c>

00801b48 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b53:	b8 08 00 00 00       	mov    $0x8,%eax
  801b58:	e8 5a fd ff ff       	call   8018b7 <fsipc>
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	56                   	push   %esi
  801b63:	53                   	push   %ebx
  801b64:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b67:	83 ec 0c             	sub    $0xc,%esp
  801b6a:	ff 75 08             	pushl  0x8(%ebp)
  801b6d:	e8 c3 f7 ff ff       	call   801335 <fd2data>
  801b72:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b74:	83 c4 08             	add    $0x8,%esp
  801b77:	68 aa 28 80 00       	push   $0x8028aa
  801b7c:	53                   	push   %ebx
  801b7d:	e8 4b ec ff ff       	call   8007cd <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b82:	8b 46 04             	mov    0x4(%esi),%eax
  801b85:	2b 06                	sub    (%esi),%eax
  801b87:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b8d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b94:	00 00 00 
	stat->st_dev = &devpipe;
  801b97:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801b9e:	30 80 00 
	return 0;
}
  801ba1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba9:	5b                   	pop    %ebx
  801baa:	5e                   	pop    %esi
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    

00801bad <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	53                   	push   %ebx
  801bb1:	83 ec 0c             	sub    $0xc,%esp
  801bb4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bb7:	53                   	push   %ebx
  801bb8:	6a 00                	push   $0x0
  801bba:	e8 8c f0 ff ff       	call   800c4b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bbf:	89 1c 24             	mov    %ebx,(%esp)
  801bc2:	e8 6e f7 ff ff       	call   801335 <fd2data>
  801bc7:	83 c4 08             	add    $0x8,%esp
  801bca:	50                   	push   %eax
  801bcb:	6a 00                	push   $0x0
  801bcd:	e8 79 f0 ff ff       	call   800c4b <sys_page_unmap>
}
  801bd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <_pipeisclosed>:
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	57                   	push   %edi
  801bdb:	56                   	push   %esi
  801bdc:	53                   	push   %ebx
  801bdd:	83 ec 1c             	sub    $0x1c,%esp
  801be0:	89 c7                	mov    %eax,%edi
  801be2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801be4:	a1 04 40 80 00       	mov    0x804004,%eax
  801be9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bec:	83 ec 0c             	sub    $0xc,%esp
  801bef:	57                   	push   %edi
  801bf0:	e8 2a 05 00 00       	call   80211f <pageref>
  801bf5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bf8:	89 34 24             	mov    %esi,(%esp)
  801bfb:	e8 1f 05 00 00       	call   80211f <pageref>
		nn = thisenv->env_runs;
  801c00:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c06:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c09:	83 c4 10             	add    $0x10,%esp
  801c0c:	39 cb                	cmp    %ecx,%ebx
  801c0e:	74 1b                	je     801c2b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c10:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c13:	75 cf                	jne    801be4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c15:	8b 42 58             	mov    0x58(%edx),%eax
  801c18:	6a 01                	push   $0x1
  801c1a:	50                   	push   %eax
  801c1b:	53                   	push   %ebx
  801c1c:	68 b1 28 80 00       	push   $0x8028b1
  801c21:	e8 88 e5 ff ff       	call   8001ae <cprintf>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	eb b9                	jmp    801be4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c2b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c2e:	0f 94 c0             	sete   %al
  801c31:	0f b6 c0             	movzbl %al,%eax
}
  801c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c37:	5b                   	pop    %ebx
  801c38:	5e                   	pop    %esi
  801c39:	5f                   	pop    %edi
  801c3a:	5d                   	pop    %ebp
  801c3b:	c3                   	ret    

00801c3c <devpipe_write>:
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	57                   	push   %edi
  801c40:	56                   	push   %esi
  801c41:	53                   	push   %ebx
  801c42:	83 ec 28             	sub    $0x28,%esp
  801c45:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c48:	56                   	push   %esi
  801c49:	e8 e7 f6 ff ff       	call   801335 <fd2data>
  801c4e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c50:	83 c4 10             	add    $0x10,%esp
  801c53:	bf 00 00 00 00       	mov    $0x0,%edi
  801c58:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c5b:	74 4f                	je     801cac <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c5d:	8b 43 04             	mov    0x4(%ebx),%eax
  801c60:	8b 0b                	mov    (%ebx),%ecx
  801c62:	8d 51 20             	lea    0x20(%ecx),%edx
  801c65:	39 d0                	cmp    %edx,%eax
  801c67:	72 14                	jb     801c7d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c69:	89 da                	mov    %ebx,%edx
  801c6b:	89 f0                	mov    %esi,%eax
  801c6d:	e8 65 ff ff ff       	call   801bd7 <_pipeisclosed>
  801c72:	85 c0                	test   %eax,%eax
  801c74:	75 3a                	jne    801cb0 <devpipe_write+0x74>
			sys_yield();
  801c76:	e8 2c ef ff ff       	call   800ba7 <sys_yield>
  801c7b:	eb e0                	jmp    801c5d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c80:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c84:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c87:	89 c2                	mov    %eax,%edx
  801c89:	c1 fa 1f             	sar    $0x1f,%edx
  801c8c:	89 d1                	mov    %edx,%ecx
  801c8e:	c1 e9 1b             	shr    $0x1b,%ecx
  801c91:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c94:	83 e2 1f             	and    $0x1f,%edx
  801c97:	29 ca                	sub    %ecx,%edx
  801c99:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c9d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ca1:	83 c0 01             	add    $0x1,%eax
  801ca4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ca7:	83 c7 01             	add    $0x1,%edi
  801caa:	eb ac                	jmp    801c58 <devpipe_write+0x1c>
	return i;
  801cac:	89 f8                	mov    %edi,%eax
  801cae:	eb 05                	jmp    801cb5 <devpipe_write+0x79>
				return 0;
  801cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb8:	5b                   	pop    %ebx
  801cb9:	5e                   	pop    %esi
  801cba:	5f                   	pop    %edi
  801cbb:	5d                   	pop    %ebp
  801cbc:	c3                   	ret    

00801cbd <devpipe_read>:
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	57                   	push   %edi
  801cc1:	56                   	push   %esi
  801cc2:	53                   	push   %ebx
  801cc3:	83 ec 18             	sub    $0x18,%esp
  801cc6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cc9:	57                   	push   %edi
  801cca:	e8 66 f6 ff ff       	call   801335 <fd2data>
  801ccf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cd1:	83 c4 10             	add    $0x10,%esp
  801cd4:	be 00 00 00 00       	mov    $0x0,%esi
  801cd9:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cdc:	74 47                	je     801d25 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801cde:	8b 03                	mov    (%ebx),%eax
  801ce0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ce3:	75 22                	jne    801d07 <devpipe_read+0x4a>
			if (i > 0)
  801ce5:	85 f6                	test   %esi,%esi
  801ce7:	75 14                	jne    801cfd <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801ce9:	89 da                	mov    %ebx,%edx
  801ceb:	89 f8                	mov    %edi,%eax
  801ced:	e8 e5 fe ff ff       	call   801bd7 <_pipeisclosed>
  801cf2:	85 c0                	test   %eax,%eax
  801cf4:	75 33                	jne    801d29 <devpipe_read+0x6c>
			sys_yield();
  801cf6:	e8 ac ee ff ff       	call   800ba7 <sys_yield>
  801cfb:	eb e1                	jmp    801cde <devpipe_read+0x21>
				return i;
  801cfd:	89 f0                	mov    %esi,%eax
}
  801cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d02:	5b                   	pop    %ebx
  801d03:	5e                   	pop    %esi
  801d04:	5f                   	pop    %edi
  801d05:	5d                   	pop    %ebp
  801d06:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d07:	99                   	cltd   
  801d08:	c1 ea 1b             	shr    $0x1b,%edx
  801d0b:	01 d0                	add    %edx,%eax
  801d0d:	83 e0 1f             	and    $0x1f,%eax
  801d10:	29 d0                	sub    %edx,%eax
  801d12:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d1a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d1d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d20:	83 c6 01             	add    $0x1,%esi
  801d23:	eb b4                	jmp    801cd9 <devpipe_read+0x1c>
	return i;
  801d25:	89 f0                	mov    %esi,%eax
  801d27:	eb d6                	jmp    801cff <devpipe_read+0x42>
				return 0;
  801d29:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2e:	eb cf                	jmp    801cff <devpipe_read+0x42>

00801d30 <pipe>:
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	56                   	push   %esi
  801d34:	53                   	push   %ebx
  801d35:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d3b:	50                   	push   %eax
  801d3c:	e8 0b f6 ff ff       	call   80134c <fd_alloc>
  801d41:	89 c3                	mov    %eax,%ebx
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	85 c0                	test   %eax,%eax
  801d48:	78 5b                	js     801da5 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d4a:	83 ec 04             	sub    $0x4,%esp
  801d4d:	68 07 04 00 00       	push   $0x407
  801d52:	ff 75 f4             	pushl  -0xc(%ebp)
  801d55:	6a 00                	push   $0x0
  801d57:	e8 6a ee ff ff       	call   800bc6 <sys_page_alloc>
  801d5c:	89 c3                	mov    %eax,%ebx
  801d5e:	83 c4 10             	add    $0x10,%esp
  801d61:	85 c0                	test   %eax,%eax
  801d63:	78 40                	js     801da5 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801d65:	83 ec 0c             	sub    $0xc,%esp
  801d68:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d6b:	50                   	push   %eax
  801d6c:	e8 db f5 ff ff       	call   80134c <fd_alloc>
  801d71:	89 c3                	mov    %eax,%ebx
  801d73:	83 c4 10             	add    $0x10,%esp
  801d76:	85 c0                	test   %eax,%eax
  801d78:	78 1b                	js     801d95 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d7a:	83 ec 04             	sub    $0x4,%esp
  801d7d:	68 07 04 00 00       	push   $0x407
  801d82:	ff 75 f0             	pushl  -0x10(%ebp)
  801d85:	6a 00                	push   $0x0
  801d87:	e8 3a ee ff ff       	call   800bc6 <sys_page_alloc>
  801d8c:	89 c3                	mov    %eax,%ebx
  801d8e:	83 c4 10             	add    $0x10,%esp
  801d91:	85 c0                	test   %eax,%eax
  801d93:	79 19                	jns    801dae <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801d95:	83 ec 08             	sub    $0x8,%esp
  801d98:	ff 75 f4             	pushl  -0xc(%ebp)
  801d9b:	6a 00                	push   $0x0
  801d9d:	e8 a9 ee ff ff       	call   800c4b <sys_page_unmap>
  801da2:	83 c4 10             	add    $0x10,%esp
}
  801da5:	89 d8                	mov    %ebx,%eax
  801da7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801daa:	5b                   	pop    %ebx
  801dab:	5e                   	pop    %esi
  801dac:	5d                   	pop    %ebp
  801dad:	c3                   	ret    
	va = fd2data(fd0);
  801dae:	83 ec 0c             	sub    $0xc,%esp
  801db1:	ff 75 f4             	pushl  -0xc(%ebp)
  801db4:	e8 7c f5 ff ff       	call   801335 <fd2data>
  801db9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dbb:	83 c4 0c             	add    $0xc,%esp
  801dbe:	68 07 04 00 00       	push   $0x407
  801dc3:	50                   	push   %eax
  801dc4:	6a 00                	push   $0x0
  801dc6:	e8 fb ed ff ff       	call   800bc6 <sys_page_alloc>
  801dcb:	89 c3                	mov    %eax,%ebx
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	0f 88 8c 00 00 00    	js     801e64 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dd8:	83 ec 0c             	sub    $0xc,%esp
  801ddb:	ff 75 f0             	pushl  -0x10(%ebp)
  801dde:	e8 52 f5 ff ff       	call   801335 <fd2data>
  801de3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801dea:	50                   	push   %eax
  801deb:	6a 00                	push   $0x0
  801ded:	56                   	push   %esi
  801dee:	6a 00                	push   $0x0
  801df0:	e8 14 ee ff ff       	call   800c09 <sys_page_map>
  801df5:	89 c3                	mov    %eax,%ebx
  801df7:	83 c4 20             	add    $0x20,%esp
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	78 58                	js     801e56 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e01:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e07:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e16:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e1c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e21:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e28:	83 ec 0c             	sub    $0xc,%esp
  801e2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2e:	e8 f2 f4 ff ff       	call   801325 <fd2num>
  801e33:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e36:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e38:	83 c4 04             	add    $0x4,%esp
  801e3b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e3e:	e8 e2 f4 ff ff       	call   801325 <fd2num>
  801e43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e46:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e49:	83 c4 10             	add    $0x10,%esp
  801e4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e51:	e9 4f ff ff ff       	jmp    801da5 <pipe+0x75>
	sys_page_unmap(0, va);
  801e56:	83 ec 08             	sub    $0x8,%esp
  801e59:	56                   	push   %esi
  801e5a:	6a 00                	push   $0x0
  801e5c:	e8 ea ed ff ff       	call   800c4b <sys_page_unmap>
  801e61:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e64:	83 ec 08             	sub    $0x8,%esp
  801e67:	ff 75 f0             	pushl  -0x10(%ebp)
  801e6a:	6a 00                	push   $0x0
  801e6c:	e8 da ed ff ff       	call   800c4b <sys_page_unmap>
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	e9 1c ff ff ff       	jmp    801d95 <pipe+0x65>

00801e79 <pipeisclosed>:
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e82:	50                   	push   %eax
  801e83:	ff 75 08             	pushl  0x8(%ebp)
  801e86:	e8 10 f5 ff ff       	call   80139b <fd_lookup>
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	78 18                	js     801eaa <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e92:	83 ec 0c             	sub    $0xc,%esp
  801e95:	ff 75 f4             	pushl  -0xc(%ebp)
  801e98:	e8 98 f4 ff ff       	call   801335 <fd2data>
	return _pipeisclosed(fd, p);
  801e9d:	89 c2                	mov    %eax,%edx
  801e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea2:	e8 30 fd ff ff       	call   801bd7 <_pipeisclosed>
  801ea7:	83 c4 10             	add    $0x10,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb4:	5d                   	pop    %ebp
  801eb5:	c3                   	ret    

00801eb6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ebc:	68 c9 28 80 00       	push   $0x8028c9
  801ec1:	ff 75 0c             	pushl  0xc(%ebp)
  801ec4:	e8 04 e9 ff ff       	call   8007cd <strcpy>
	return 0;
}
  801ec9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <devcons_write>:
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	57                   	push   %edi
  801ed4:	56                   	push   %esi
  801ed5:	53                   	push   %ebx
  801ed6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801edc:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ee1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ee7:	eb 2f                	jmp    801f18 <devcons_write+0x48>
		m = n - tot;
  801ee9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801eec:	29 f3                	sub    %esi,%ebx
  801eee:	83 fb 7f             	cmp    $0x7f,%ebx
  801ef1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ef6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ef9:	83 ec 04             	sub    $0x4,%esp
  801efc:	53                   	push   %ebx
  801efd:	89 f0                	mov    %esi,%eax
  801eff:	03 45 0c             	add    0xc(%ebp),%eax
  801f02:	50                   	push   %eax
  801f03:	57                   	push   %edi
  801f04:	e8 52 ea ff ff       	call   80095b <memmove>
		sys_cputs(buf, m);
  801f09:	83 c4 08             	add    $0x8,%esp
  801f0c:	53                   	push   %ebx
  801f0d:	57                   	push   %edi
  801f0e:	e8 f7 eb ff ff       	call   800b0a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f13:	01 de                	add    %ebx,%esi
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f1b:	72 cc                	jb     801ee9 <devcons_write+0x19>
}
  801f1d:	89 f0                	mov    %esi,%eax
  801f1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f22:	5b                   	pop    %ebx
  801f23:	5e                   	pop    %esi
  801f24:	5f                   	pop    %edi
  801f25:	5d                   	pop    %ebp
  801f26:	c3                   	ret    

00801f27 <devcons_read>:
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 08             	sub    $0x8,%esp
  801f2d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f36:	75 07                	jne    801f3f <devcons_read+0x18>
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    
		sys_yield();
  801f3a:	e8 68 ec ff ff       	call   800ba7 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801f3f:	e8 e4 eb ff ff       	call   800b28 <sys_cgetc>
  801f44:	85 c0                	test   %eax,%eax
  801f46:	74 f2                	je     801f3a <devcons_read+0x13>
	if (c < 0)
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	78 ec                	js     801f38 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801f4c:	83 f8 04             	cmp    $0x4,%eax
  801f4f:	74 0c                	je     801f5d <devcons_read+0x36>
	*(char*)vbuf = c;
  801f51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f54:	88 02                	mov    %al,(%edx)
	return 1;
  801f56:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5b:	eb db                	jmp    801f38 <devcons_read+0x11>
		return 0;
  801f5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f62:	eb d4                	jmp    801f38 <devcons_read+0x11>

00801f64 <cputchar>:
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f70:	6a 01                	push   $0x1
  801f72:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f75:	50                   	push   %eax
  801f76:	e8 8f eb ff ff       	call   800b0a <sys_cputs>
}
  801f7b:	83 c4 10             	add    $0x10,%esp
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <getchar>:
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f86:	6a 01                	push   $0x1
  801f88:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f8b:	50                   	push   %eax
  801f8c:	6a 00                	push   $0x0
  801f8e:	e8 79 f6 ff ff       	call   80160c <read>
	if (r < 0)
  801f93:	83 c4 10             	add    $0x10,%esp
  801f96:	85 c0                	test   %eax,%eax
  801f98:	78 08                	js     801fa2 <getchar+0x22>
	if (r < 1)
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	7e 06                	jle    801fa4 <getchar+0x24>
	return c;
  801f9e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    
		return -E_EOF;
  801fa4:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fa9:	eb f7                	jmp    801fa2 <getchar+0x22>

00801fab <iscons>:
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb4:	50                   	push   %eax
  801fb5:	ff 75 08             	pushl  0x8(%ebp)
  801fb8:	e8 de f3 ff ff       	call   80139b <fd_lookup>
  801fbd:	83 c4 10             	add    $0x10,%esp
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	78 11                	js     801fd5 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fcd:	39 10                	cmp    %edx,(%eax)
  801fcf:	0f 94 c0             	sete   %al
  801fd2:	0f b6 c0             	movzbl %al,%eax
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <opencons>:
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fdd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe0:	50                   	push   %eax
  801fe1:	e8 66 f3 ff ff       	call   80134c <fd_alloc>
  801fe6:	83 c4 10             	add    $0x10,%esp
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	78 3a                	js     802027 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fed:	83 ec 04             	sub    $0x4,%esp
  801ff0:	68 07 04 00 00       	push   $0x407
  801ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff8:	6a 00                	push   $0x0
  801ffa:	e8 c7 eb ff ff       	call   800bc6 <sys_page_alloc>
  801fff:	83 c4 10             	add    $0x10,%esp
  802002:	85 c0                	test   %eax,%eax
  802004:	78 21                	js     802027 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802009:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80200f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80201b:	83 ec 0c             	sub    $0xc,%esp
  80201e:	50                   	push   %eax
  80201f:	e8 01 f3 ff ff       	call   801325 <fd2num>
  802024:	83 c4 10             	add    $0x10,%esp
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	56                   	push   %esi
  80202d:	53                   	push   %ebx
  80202e:	8b 75 08             	mov    0x8(%ebp),%esi
  802031:	8b 45 0c             	mov    0xc(%ebp),%eax
  802034:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  802037:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  802039:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80203e:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  802041:	83 ec 0c             	sub    $0xc,%esp
  802044:	50                   	push   %eax
  802045:	e8 2c ed ff ff       	call   800d76 <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  80204a:	83 c4 10             	add    $0x10,%esp
  80204d:	85 c0                	test   %eax,%eax
  80204f:	78 2b                	js     80207c <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  802051:	85 f6                	test   %esi,%esi
  802053:	74 0a                	je     80205f <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802055:	a1 04 40 80 00       	mov    0x804004,%eax
  80205a:	8b 40 74             	mov    0x74(%eax),%eax
  80205d:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  80205f:	85 db                	test   %ebx,%ebx
  802061:	74 0a                	je     80206d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802063:	a1 04 40 80 00       	mov    0x804004,%eax
  802068:	8b 40 78             	mov    0x78(%eax),%eax
  80206b:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  80206d:	a1 04 40 80 00       	mov    0x804004,%eax
  802072:	8b 40 70             	mov    0x70(%eax),%eax
}
  802075:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802078:	5b                   	pop    %ebx
  802079:	5e                   	pop    %esi
  80207a:	5d                   	pop    %ebp
  80207b:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80207c:	85 f6                	test   %esi,%esi
  80207e:	74 06                	je     802086 <ipc_recv+0x5d>
  802080:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802086:	85 db                	test   %ebx,%ebx
  802088:	74 eb                	je     802075 <ipc_recv+0x4c>
  80208a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802090:	eb e3                	jmp    802075 <ipc_recv+0x4c>

00802092 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	57                   	push   %edi
  802096:	56                   	push   %esi
  802097:	53                   	push   %ebx
  802098:	83 ec 0c             	sub    $0xc,%esp
  80209b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80209e:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  8020a4:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  8020a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020ab:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  8020ae:	ff 75 14             	pushl  0x14(%ebp)
  8020b1:	53                   	push   %ebx
  8020b2:	56                   	push   %esi
  8020b3:	57                   	push   %edi
  8020b4:	e8 9a ec ff ff       	call   800d53 <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  8020b9:	83 c4 10             	add    $0x10,%esp
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	74 1e                	je     8020de <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  8020c0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020c3:	75 07                	jne    8020cc <ipc_send+0x3a>
			sys_yield();
  8020c5:	e8 dd ea ff ff       	call   800ba7 <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  8020ca:	eb e2                	jmp    8020ae <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  8020cc:	50                   	push   %eax
  8020cd:	68 d5 28 80 00       	push   $0x8028d5
  8020d2:	6a 41                	push   $0x41
  8020d4:	68 e3 28 80 00       	push   $0x8028e3
  8020d9:	e8 f5 df ff ff       	call   8000d3 <_panic>
		}
	}
}
  8020de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020e1:	5b                   	pop    %ebx
  8020e2:	5e                   	pop    %esi
  8020e3:	5f                   	pop    %edi
  8020e4:	5d                   	pop    %ebp
  8020e5:	c3                   	ret    

008020e6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020ec:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020f1:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020f4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020fa:	8b 52 50             	mov    0x50(%edx),%edx
  8020fd:	39 ca                	cmp    %ecx,%edx
  8020ff:	74 11                	je     802112 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802101:	83 c0 01             	add    $0x1,%eax
  802104:	3d 00 04 00 00       	cmp    $0x400,%eax
  802109:	75 e6                	jne    8020f1 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80210b:	b8 00 00 00 00       	mov    $0x0,%eax
  802110:	eb 0b                	jmp    80211d <ipc_find_env+0x37>
			return envs[i].env_id;
  802112:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802115:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80211a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80211d:	5d                   	pop    %ebp
  80211e:	c3                   	ret    

0080211f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802125:	89 d0                	mov    %edx,%eax
  802127:	c1 e8 16             	shr    $0x16,%eax
  80212a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802131:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802136:	f6 c1 01             	test   $0x1,%cl
  802139:	74 1d                	je     802158 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80213b:	c1 ea 0c             	shr    $0xc,%edx
  80213e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802145:	f6 c2 01             	test   $0x1,%dl
  802148:	74 0e                	je     802158 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80214a:	c1 ea 0c             	shr    $0xc,%edx
  80214d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802154:	ef 
  802155:	0f b7 c0             	movzwl %ax,%eax
}
  802158:	5d                   	pop    %ebp
  802159:	c3                   	ret    
  80215a:	66 90                	xchg   %ax,%ax
  80215c:	66 90                	xchg   %ax,%ax
  80215e:	66 90                	xchg   %ax,%ax

00802160 <__udivdi3>:
  802160:	55                   	push   %ebp
  802161:	57                   	push   %edi
  802162:	56                   	push   %esi
  802163:	53                   	push   %ebx
  802164:	83 ec 1c             	sub    $0x1c,%esp
  802167:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80216b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80216f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802173:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802177:	85 d2                	test   %edx,%edx
  802179:	75 35                	jne    8021b0 <__udivdi3+0x50>
  80217b:	39 f3                	cmp    %esi,%ebx
  80217d:	0f 87 bd 00 00 00    	ja     802240 <__udivdi3+0xe0>
  802183:	85 db                	test   %ebx,%ebx
  802185:	89 d9                	mov    %ebx,%ecx
  802187:	75 0b                	jne    802194 <__udivdi3+0x34>
  802189:	b8 01 00 00 00       	mov    $0x1,%eax
  80218e:	31 d2                	xor    %edx,%edx
  802190:	f7 f3                	div    %ebx
  802192:	89 c1                	mov    %eax,%ecx
  802194:	31 d2                	xor    %edx,%edx
  802196:	89 f0                	mov    %esi,%eax
  802198:	f7 f1                	div    %ecx
  80219a:	89 c6                	mov    %eax,%esi
  80219c:	89 e8                	mov    %ebp,%eax
  80219e:	89 f7                	mov    %esi,%edi
  8021a0:	f7 f1                	div    %ecx
  8021a2:	89 fa                	mov    %edi,%edx
  8021a4:	83 c4 1c             	add    $0x1c,%esp
  8021a7:	5b                   	pop    %ebx
  8021a8:	5e                   	pop    %esi
  8021a9:	5f                   	pop    %edi
  8021aa:	5d                   	pop    %ebp
  8021ab:	c3                   	ret    
  8021ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021b0:	39 f2                	cmp    %esi,%edx
  8021b2:	77 7c                	ja     802230 <__udivdi3+0xd0>
  8021b4:	0f bd fa             	bsr    %edx,%edi
  8021b7:	83 f7 1f             	xor    $0x1f,%edi
  8021ba:	0f 84 98 00 00 00    	je     802258 <__udivdi3+0xf8>
  8021c0:	89 f9                	mov    %edi,%ecx
  8021c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8021c7:	29 f8                	sub    %edi,%eax
  8021c9:	d3 e2                	shl    %cl,%edx
  8021cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021cf:	89 c1                	mov    %eax,%ecx
  8021d1:	89 da                	mov    %ebx,%edx
  8021d3:	d3 ea                	shr    %cl,%edx
  8021d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021d9:	09 d1                	or     %edx,%ecx
  8021db:	89 f2                	mov    %esi,%edx
  8021dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021e1:	89 f9                	mov    %edi,%ecx
  8021e3:	d3 e3                	shl    %cl,%ebx
  8021e5:	89 c1                	mov    %eax,%ecx
  8021e7:	d3 ea                	shr    %cl,%edx
  8021e9:	89 f9                	mov    %edi,%ecx
  8021eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021ef:	d3 e6                	shl    %cl,%esi
  8021f1:	89 eb                	mov    %ebp,%ebx
  8021f3:	89 c1                	mov    %eax,%ecx
  8021f5:	d3 eb                	shr    %cl,%ebx
  8021f7:	09 de                	or     %ebx,%esi
  8021f9:	89 f0                	mov    %esi,%eax
  8021fb:	f7 74 24 08          	divl   0x8(%esp)
  8021ff:	89 d6                	mov    %edx,%esi
  802201:	89 c3                	mov    %eax,%ebx
  802203:	f7 64 24 0c          	mull   0xc(%esp)
  802207:	39 d6                	cmp    %edx,%esi
  802209:	72 0c                	jb     802217 <__udivdi3+0xb7>
  80220b:	89 f9                	mov    %edi,%ecx
  80220d:	d3 e5                	shl    %cl,%ebp
  80220f:	39 c5                	cmp    %eax,%ebp
  802211:	73 5d                	jae    802270 <__udivdi3+0x110>
  802213:	39 d6                	cmp    %edx,%esi
  802215:	75 59                	jne    802270 <__udivdi3+0x110>
  802217:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80221a:	31 ff                	xor    %edi,%edi
  80221c:	89 fa                	mov    %edi,%edx
  80221e:	83 c4 1c             	add    $0x1c,%esp
  802221:	5b                   	pop    %ebx
  802222:	5e                   	pop    %esi
  802223:	5f                   	pop    %edi
  802224:	5d                   	pop    %ebp
  802225:	c3                   	ret    
  802226:	8d 76 00             	lea    0x0(%esi),%esi
  802229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802230:	31 ff                	xor    %edi,%edi
  802232:	31 c0                	xor    %eax,%eax
  802234:	89 fa                	mov    %edi,%edx
  802236:	83 c4 1c             	add    $0x1c,%esp
  802239:	5b                   	pop    %ebx
  80223a:	5e                   	pop    %esi
  80223b:	5f                   	pop    %edi
  80223c:	5d                   	pop    %ebp
  80223d:	c3                   	ret    
  80223e:	66 90                	xchg   %ax,%ax
  802240:	31 ff                	xor    %edi,%edi
  802242:	89 e8                	mov    %ebp,%eax
  802244:	89 f2                	mov    %esi,%edx
  802246:	f7 f3                	div    %ebx
  802248:	89 fa                	mov    %edi,%edx
  80224a:	83 c4 1c             	add    $0x1c,%esp
  80224d:	5b                   	pop    %ebx
  80224e:	5e                   	pop    %esi
  80224f:	5f                   	pop    %edi
  802250:	5d                   	pop    %ebp
  802251:	c3                   	ret    
  802252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802258:	39 f2                	cmp    %esi,%edx
  80225a:	72 06                	jb     802262 <__udivdi3+0x102>
  80225c:	31 c0                	xor    %eax,%eax
  80225e:	39 eb                	cmp    %ebp,%ebx
  802260:	77 d2                	ja     802234 <__udivdi3+0xd4>
  802262:	b8 01 00 00 00       	mov    $0x1,%eax
  802267:	eb cb                	jmp    802234 <__udivdi3+0xd4>
  802269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802270:	89 d8                	mov    %ebx,%eax
  802272:	31 ff                	xor    %edi,%edi
  802274:	eb be                	jmp    802234 <__udivdi3+0xd4>
  802276:	66 90                	xchg   %ax,%ax
  802278:	66 90                	xchg   %ax,%ax
  80227a:	66 90                	xchg   %ax,%ax
  80227c:	66 90                	xchg   %ax,%ax
  80227e:	66 90                	xchg   %ax,%ax

00802280 <__umoddi3>:
  802280:	55                   	push   %ebp
  802281:	57                   	push   %edi
  802282:	56                   	push   %esi
  802283:	53                   	push   %ebx
  802284:	83 ec 1c             	sub    $0x1c,%esp
  802287:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80228b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80228f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802293:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802297:	85 ed                	test   %ebp,%ebp
  802299:	89 f0                	mov    %esi,%eax
  80229b:	89 da                	mov    %ebx,%edx
  80229d:	75 19                	jne    8022b8 <__umoddi3+0x38>
  80229f:	39 df                	cmp    %ebx,%edi
  8022a1:	0f 86 b1 00 00 00    	jbe    802358 <__umoddi3+0xd8>
  8022a7:	f7 f7                	div    %edi
  8022a9:	89 d0                	mov    %edx,%eax
  8022ab:	31 d2                	xor    %edx,%edx
  8022ad:	83 c4 1c             	add    $0x1c,%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5e                   	pop    %esi
  8022b2:	5f                   	pop    %edi
  8022b3:	5d                   	pop    %ebp
  8022b4:	c3                   	ret    
  8022b5:	8d 76 00             	lea    0x0(%esi),%esi
  8022b8:	39 dd                	cmp    %ebx,%ebp
  8022ba:	77 f1                	ja     8022ad <__umoddi3+0x2d>
  8022bc:	0f bd cd             	bsr    %ebp,%ecx
  8022bf:	83 f1 1f             	xor    $0x1f,%ecx
  8022c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022c6:	0f 84 b4 00 00 00    	je     802380 <__umoddi3+0x100>
  8022cc:	b8 20 00 00 00       	mov    $0x20,%eax
  8022d1:	89 c2                	mov    %eax,%edx
  8022d3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022d7:	29 c2                	sub    %eax,%edx
  8022d9:	89 c1                	mov    %eax,%ecx
  8022db:	89 f8                	mov    %edi,%eax
  8022dd:	d3 e5                	shl    %cl,%ebp
  8022df:	89 d1                	mov    %edx,%ecx
  8022e1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022e5:	d3 e8                	shr    %cl,%eax
  8022e7:	09 c5                	or     %eax,%ebp
  8022e9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8022ed:	89 c1                	mov    %eax,%ecx
  8022ef:	d3 e7                	shl    %cl,%edi
  8022f1:	89 d1                	mov    %edx,%ecx
  8022f3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8022f7:	89 df                	mov    %ebx,%edi
  8022f9:	d3 ef                	shr    %cl,%edi
  8022fb:	89 c1                	mov    %eax,%ecx
  8022fd:	89 f0                	mov    %esi,%eax
  8022ff:	d3 e3                	shl    %cl,%ebx
  802301:	89 d1                	mov    %edx,%ecx
  802303:	89 fa                	mov    %edi,%edx
  802305:	d3 e8                	shr    %cl,%eax
  802307:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80230c:	09 d8                	or     %ebx,%eax
  80230e:	f7 f5                	div    %ebp
  802310:	d3 e6                	shl    %cl,%esi
  802312:	89 d1                	mov    %edx,%ecx
  802314:	f7 64 24 08          	mull   0x8(%esp)
  802318:	39 d1                	cmp    %edx,%ecx
  80231a:	89 c3                	mov    %eax,%ebx
  80231c:	89 d7                	mov    %edx,%edi
  80231e:	72 06                	jb     802326 <__umoddi3+0xa6>
  802320:	75 0e                	jne    802330 <__umoddi3+0xb0>
  802322:	39 c6                	cmp    %eax,%esi
  802324:	73 0a                	jae    802330 <__umoddi3+0xb0>
  802326:	2b 44 24 08          	sub    0x8(%esp),%eax
  80232a:	19 ea                	sbb    %ebp,%edx
  80232c:	89 d7                	mov    %edx,%edi
  80232e:	89 c3                	mov    %eax,%ebx
  802330:	89 ca                	mov    %ecx,%edx
  802332:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802337:	29 de                	sub    %ebx,%esi
  802339:	19 fa                	sbb    %edi,%edx
  80233b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80233f:	89 d0                	mov    %edx,%eax
  802341:	d3 e0                	shl    %cl,%eax
  802343:	89 d9                	mov    %ebx,%ecx
  802345:	d3 ee                	shr    %cl,%esi
  802347:	d3 ea                	shr    %cl,%edx
  802349:	09 f0                	or     %esi,%eax
  80234b:	83 c4 1c             	add    $0x1c,%esp
  80234e:	5b                   	pop    %ebx
  80234f:	5e                   	pop    %esi
  802350:	5f                   	pop    %edi
  802351:	5d                   	pop    %ebp
  802352:	c3                   	ret    
  802353:	90                   	nop
  802354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802358:	85 ff                	test   %edi,%edi
  80235a:	89 f9                	mov    %edi,%ecx
  80235c:	75 0b                	jne    802369 <__umoddi3+0xe9>
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
  802363:	31 d2                	xor    %edx,%edx
  802365:	f7 f7                	div    %edi
  802367:	89 c1                	mov    %eax,%ecx
  802369:	89 d8                	mov    %ebx,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	f7 f1                	div    %ecx
  80236f:	89 f0                	mov    %esi,%eax
  802371:	f7 f1                	div    %ecx
  802373:	e9 31 ff ff ff       	jmp    8022a9 <__umoddi3+0x29>
  802378:	90                   	nop
  802379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802380:	39 dd                	cmp    %ebx,%ebp
  802382:	72 08                	jb     80238c <__umoddi3+0x10c>
  802384:	39 f7                	cmp    %esi,%edi
  802386:	0f 87 21 ff ff ff    	ja     8022ad <__umoddi3+0x2d>
  80238c:	89 da                	mov    %ebx,%edx
  80238e:	89 f0                	mov    %esi,%eax
  802390:	29 f8                	sub    %edi,%eax
  802392:	19 ea                	sbb    %ebp,%edx
  802394:	e9 14 ff ff ff       	jmp    8022ad <__umoddi3+0x2d>
