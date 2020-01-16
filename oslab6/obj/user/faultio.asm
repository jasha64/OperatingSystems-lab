
obj/user/faultio.debug：     文件格式 elf32-i386


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
  80002c:	e8 3e 00 00 00       	call   80006f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  800039:	9c                   	pushf  
  80003a:	58                   	pop    %eax
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;

	if (read_eflags() & FL_IOPL_3)
  80003b:	f6 c4 30             	test   $0x30,%ah
  80003e:	75 1d                	jne    80005d <umain+0x2a>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800040:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800045:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80004a:	ee                   	out    %al,(%dx)

	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));

        cprintf("%s: made it here --- bug\n");
  80004b:	83 ec 0c             	sub    $0xc,%esp
  80004e:	68 0e 10 80 00       	push   $0x80100e
  800053:	e8 04 01 00 00       	call   80015c <cprintf>
}
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    
		cprintf("eflags wrong\n");
  80005d:	83 ec 0c             	sub    $0xc,%esp
  800060:	68 00 10 80 00       	push   $0x801000
  800065:	e8 f2 00 00 00       	call   80015c <cprintf>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	eb d1                	jmp    800040 <umain+0xd>

0080006f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800077:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  80007a:	e8 b7 0a 00 00       	call   800b36 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  80007f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800084:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800087:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008c:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800091:	85 db                	test   %ebx,%ebx
  800093:	7e 07                	jle    80009c <libmain+0x2d>
		binaryname = argv[0];
  800095:	8b 06                	mov    (%esi),%eax
  800097:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	56                   	push   %esi
  8000a0:	53                   	push   %ebx
  8000a1:	e8 8d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a6:	e8 0a 00 00 00       	call   8000b5 <exit>
}
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000b1:	5b                   	pop    %ebx
  8000b2:	5e                   	pop    %esi
  8000b3:	5d                   	pop    %ebp
  8000b4:	c3                   	ret    

008000b5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8000bb:	6a 00                	push   $0x0
  8000bd:	e8 33 0a 00 00       	call   800af5 <sys_env_destroy>
}
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	c9                   	leave  
  8000c6:	c3                   	ret    

008000c7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c7:	55                   	push   %ebp
  8000c8:	89 e5                	mov    %esp,%ebp
  8000ca:	53                   	push   %ebx
  8000cb:	83 ec 04             	sub    $0x4,%esp
  8000ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d1:	8b 13                	mov    (%ebx),%edx
  8000d3:	8d 42 01             	lea    0x1(%edx),%eax
  8000d6:	89 03                	mov    %eax,(%ebx)
  8000d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000db:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000df:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e4:	74 09                	je     8000ef <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000e6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000ed:	c9                   	leave  
  8000ee:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	68 ff 00 00 00       	push   $0xff
  8000f7:	8d 43 08             	lea    0x8(%ebx),%eax
  8000fa:	50                   	push   %eax
  8000fb:	e8 b8 09 00 00       	call   800ab8 <sys_cputs>
		b->idx = 0;
  800100:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	eb db                	jmp    8000e6 <putch+0x1f>

0080010b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800114:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80011b:	00 00 00 
	b.cnt = 0;
  80011e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800125:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800128:	ff 75 0c             	pushl  0xc(%ebp)
  80012b:	ff 75 08             	pushl  0x8(%ebp)
  80012e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800134:	50                   	push   %eax
  800135:	68 c7 00 80 00       	push   $0x8000c7
  80013a:	e8 1a 01 00 00       	call   800259 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80013f:	83 c4 08             	add    $0x8,%esp
  800142:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800148:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80014e:	50                   	push   %eax
  80014f:	e8 64 09 00 00       	call   800ab8 <sys_cputs>

	return b.cnt;
}
  800154:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80015a:	c9                   	leave  
  80015b:	c3                   	ret    

0080015c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800162:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800165:	50                   	push   %eax
  800166:	ff 75 08             	pushl  0x8(%ebp)
  800169:	e8 9d ff ff ff       	call   80010b <vcprintf>
	va_end(ap);

	return cnt;
}
  80016e:	c9                   	leave  
  80016f:	c3                   	ret    

00800170 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	57                   	push   %edi
  800174:	56                   	push   %esi
  800175:	53                   	push   %ebx
  800176:	83 ec 1c             	sub    $0x1c,%esp
  800179:	89 c7                	mov    %eax,%edi
  80017b:	89 d6                	mov    %edx,%esi
  80017d:	8b 45 08             	mov    0x8(%ebp),%eax
  800180:	8b 55 0c             	mov    0xc(%ebp),%edx
  800183:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800186:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800189:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80018c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800191:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800194:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800197:	39 d3                	cmp    %edx,%ebx
  800199:	72 05                	jb     8001a0 <printnum+0x30>
  80019b:	39 45 10             	cmp    %eax,0x10(%ebp)
  80019e:	77 7a                	ja     80021a <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	ff 75 18             	pushl  0x18(%ebp)
  8001a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001ac:	53                   	push   %ebx
  8001ad:	ff 75 10             	pushl  0x10(%ebp)
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b9:	ff 75 dc             	pushl  -0x24(%ebp)
  8001bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8001bf:	e8 ec 0b 00 00       	call   800db0 <__udivdi3>
  8001c4:	83 c4 18             	add    $0x18,%esp
  8001c7:	52                   	push   %edx
  8001c8:	50                   	push   %eax
  8001c9:	89 f2                	mov    %esi,%edx
  8001cb:	89 f8                	mov    %edi,%eax
  8001cd:	e8 9e ff ff ff       	call   800170 <printnum>
  8001d2:	83 c4 20             	add    $0x20,%esp
  8001d5:	eb 13                	jmp    8001ea <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	56                   	push   %esi
  8001db:	ff 75 18             	pushl  0x18(%ebp)
  8001de:	ff d7                	call   *%edi
  8001e0:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001e3:	83 eb 01             	sub    $0x1,%ebx
  8001e6:	85 db                	test   %ebx,%ebx
  8001e8:	7f ed                	jg     8001d7 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	56                   	push   %esi
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f7:	ff 75 dc             	pushl  -0x24(%ebp)
  8001fa:	ff 75 d8             	pushl  -0x28(%ebp)
  8001fd:	e8 ce 0c 00 00       	call   800ed0 <__umoddi3>
  800202:	83 c4 14             	add    $0x14,%esp
  800205:	0f be 80 32 10 80 00 	movsbl 0x801032(%eax),%eax
  80020c:	50                   	push   %eax
  80020d:	ff d7                	call   *%edi
}
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800215:	5b                   	pop    %ebx
  800216:	5e                   	pop    %esi
  800217:	5f                   	pop    %edi
  800218:	5d                   	pop    %ebp
  800219:	c3                   	ret    
  80021a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80021d:	eb c4                	jmp    8001e3 <printnum+0x73>

0080021f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80021f:	55                   	push   %ebp
  800220:	89 e5                	mov    %esp,%ebp
  800222:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800225:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800229:	8b 10                	mov    (%eax),%edx
  80022b:	3b 50 04             	cmp    0x4(%eax),%edx
  80022e:	73 0a                	jae    80023a <sprintputch+0x1b>
		*b->buf++ = ch;
  800230:	8d 4a 01             	lea    0x1(%edx),%ecx
  800233:	89 08                	mov    %ecx,(%eax)
  800235:	8b 45 08             	mov    0x8(%ebp),%eax
  800238:	88 02                	mov    %al,(%edx)
}
  80023a:	5d                   	pop    %ebp
  80023b:	c3                   	ret    

0080023c <printfmt>:
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800242:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800245:	50                   	push   %eax
  800246:	ff 75 10             	pushl  0x10(%ebp)
  800249:	ff 75 0c             	pushl  0xc(%ebp)
  80024c:	ff 75 08             	pushl  0x8(%ebp)
  80024f:	e8 05 00 00 00       	call   800259 <vprintfmt>
}
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <vprintfmt>:
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	57                   	push   %edi
  80025d:	56                   	push   %esi
  80025e:	53                   	push   %ebx
  80025f:	83 ec 2c             	sub    $0x2c,%esp
  800262:	8b 75 08             	mov    0x8(%ebp),%esi
  800265:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800268:	8b 7d 10             	mov    0x10(%ebp),%edi
  80026b:	e9 c1 03 00 00       	jmp    800631 <vprintfmt+0x3d8>
		padc = ' ';
  800270:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800274:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80027b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800282:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800289:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80028e:	8d 47 01             	lea    0x1(%edi),%eax
  800291:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800294:	0f b6 17             	movzbl (%edi),%edx
  800297:	8d 42 dd             	lea    -0x23(%edx),%eax
  80029a:	3c 55                	cmp    $0x55,%al
  80029c:	0f 87 12 04 00 00    	ja     8006b4 <vprintfmt+0x45b>
  8002a2:	0f b6 c0             	movzbl %al,%eax
  8002a5:	ff 24 85 80 11 80 00 	jmp    *0x801180(,%eax,4)
  8002ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002af:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002b3:	eb d9                	jmp    80028e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002b8:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002bc:	eb d0                	jmp    80028e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002be:	0f b6 d2             	movzbl %dl,%edx
  8002c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002cc:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002cf:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002d3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002d6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002d9:	83 f9 09             	cmp    $0x9,%ecx
  8002dc:	77 55                	ja     800333 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002de:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002e1:	eb e9                	jmp    8002cc <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e6:	8b 00                	mov    (%eax),%eax
  8002e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ee:	8d 40 04             	lea    0x4(%eax),%eax
  8002f1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002fb:	79 91                	jns    80028e <vprintfmt+0x35>
				width = precision, precision = -1;
  8002fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800300:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800303:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80030a:	eb 82                	jmp    80028e <vprintfmt+0x35>
  80030c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030f:	85 c0                	test   %eax,%eax
  800311:	ba 00 00 00 00       	mov    $0x0,%edx
  800316:	0f 49 d0             	cmovns %eax,%edx
  800319:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80031c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80031f:	e9 6a ff ff ff       	jmp    80028e <vprintfmt+0x35>
  800324:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800327:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80032e:	e9 5b ff ff ff       	jmp    80028e <vprintfmt+0x35>
  800333:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800336:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800339:	eb bc                	jmp    8002f7 <vprintfmt+0x9e>
			lflag++;
  80033b:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80033e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800341:	e9 48 ff ff ff       	jmp    80028e <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800346:	8b 45 14             	mov    0x14(%ebp),%eax
  800349:	8d 78 04             	lea    0x4(%eax),%edi
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	53                   	push   %ebx
  800350:	ff 30                	pushl  (%eax)
  800352:	ff d6                	call   *%esi
			break;
  800354:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800357:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80035a:	e9 cf 02 00 00       	jmp    80062e <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80035f:	8b 45 14             	mov    0x14(%ebp),%eax
  800362:	8d 78 04             	lea    0x4(%eax),%edi
  800365:	8b 00                	mov    (%eax),%eax
  800367:	99                   	cltd   
  800368:	31 d0                	xor    %edx,%eax
  80036a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80036c:	83 f8 0f             	cmp    $0xf,%eax
  80036f:	7f 23                	jg     800394 <vprintfmt+0x13b>
  800371:	8b 14 85 e0 12 80 00 	mov    0x8012e0(,%eax,4),%edx
  800378:	85 d2                	test   %edx,%edx
  80037a:	74 18                	je     800394 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80037c:	52                   	push   %edx
  80037d:	68 53 10 80 00       	push   $0x801053
  800382:	53                   	push   %ebx
  800383:	56                   	push   %esi
  800384:	e8 b3 fe ff ff       	call   80023c <printfmt>
  800389:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80038c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80038f:	e9 9a 02 00 00       	jmp    80062e <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800394:	50                   	push   %eax
  800395:	68 4a 10 80 00       	push   $0x80104a
  80039a:	53                   	push   %ebx
  80039b:	56                   	push   %esi
  80039c:	e8 9b fe ff ff       	call   80023c <printfmt>
  8003a1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003a7:	e9 82 02 00 00       	jmp    80062e <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8003ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8003af:	83 c0 04             	add    $0x4,%eax
  8003b2:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b8:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003ba:	85 ff                	test   %edi,%edi
  8003bc:	b8 43 10 80 00       	mov    $0x801043,%eax
  8003c1:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c8:	0f 8e bd 00 00 00    	jle    80048b <vprintfmt+0x232>
  8003ce:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003d2:	75 0e                	jne    8003e2 <vprintfmt+0x189>
  8003d4:	89 75 08             	mov    %esi,0x8(%ebp)
  8003d7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003da:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003dd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003e0:	eb 6d                	jmp    80044f <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e8:	57                   	push   %edi
  8003e9:	e8 6e 03 00 00       	call   80075c <strnlen>
  8003ee:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003f1:	29 c1                	sub    %eax,%ecx
  8003f3:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003f6:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003f9:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800400:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800403:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800405:	eb 0f                	jmp    800416 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	53                   	push   %ebx
  80040b:	ff 75 e0             	pushl  -0x20(%ebp)
  80040e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800410:	83 ef 01             	sub    $0x1,%edi
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	85 ff                	test   %edi,%edi
  800418:	7f ed                	jg     800407 <vprintfmt+0x1ae>
  80041a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80041d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800420:	85 c9                	test   %ecx,%ecx
  800422:	b8 00 00 00 00       	mov    $0x0,%eax
  800427:	0f 49 c1             	cmovns %ecx,%eax
  80042a:	29 c1                	sub    %eax,%ecx
  80042c:	89 75 08             	mov    %esi,0x8(%ebp)
  80042f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800432:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800435:	89 cb                	mov    %ecx,%ebx
  800437:	eb 16                	jmp    80044f <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800439:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80043d:	75 31                	jne    800470 <vprintfmt+0x217>
					putch(ch, putdat);
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	ff 75 0c             	pushl  0xc(%ebp)
  800445:	50                   	push   %eax
  800446:	ff 55 08             	call   *0x8(%ebp)
  800449:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80044c:	83 eb 01             	sub    $0x1,%ebx
  80044f:	83 c7 01             	add    $0x1,%edi
  800452:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800456:	0f be c2             	movsbl %dl,%eax
  800459:	85 c0                	test   %eax,%eax
  80045b:	74 59                	je     8004b6 <vprintfmt+0x25d>
  80045d:	85 f6                	test   %esi,%esi
  80045f:	78 d8                	js     800439 <vprintfmt+0x1e0>
  800461:	83 ee 01             	sub    $0x1,%esi
  800464:	79 d3                	jns    800439 <vprintfmt+0x1e0>
  800466:	89 df                	mov    %ebx,%edi
  800468:	8b 75 08             	mov    0x8(%ebp),%esi
  80046b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80046e:	eb 37                	jmp    8004a7 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800470:	0f be d2             	movsbl %dl,%edx
  800473:	83 ea 20             	sub    $0x20,%edx
  800476:	83 fa 5e             	cmp    $0x5e,%edx
  800479:	76 c4                	jbe    80043f <vprintfmt+0x1e6>
					putch('?', putdat);
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 0c             	pushl  0xc(%ebp)
  800481:	6a 3f                	push   $0x3f
  800483:	ff 55 08             	call   *0x8(%ebp)
  800486:	83 c4 10             	add    $0x10,%esp
  800489:	eb c1                	jmp    80044c <vprintfmt+0x1f3>
  80048b:	89 75 08             	mov    %esi,0x8(%ebp)
  80048e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800491:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800494:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800497:	eb b6                	jmp    80044f <vprintfmt+0x1f6>
				putch(' ', putdat);
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	53                   	push   %ebx
  80049d:	6a 20                	push   $0x20
  80049f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004a1:	83 ef 01             	sub    $0x1,%edi
  8004a4:	83 c4 10             	add    $0x10,%esp
  8004a7:	85 ff                	test   %edi,%edi
  8004a9:	7f ee                	jg     800499 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b1:	e9 78 01 00 00       	jmp    80062e <vprintfmt+0x3d5>
  8004b6:	89 df                	mov    %ebx,%edi
  8004b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8004bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004be:	eb e7                	jmp    8004a7 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004c0:	83 f9 01             	cmp    $0x1,%ecx
  8004c3:	7e 3f                	jle    800504 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c8:	8b 50 04             	mov    0x4(%eax),%edx
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	8d 40 08             	lea    0x8(%eax),%eax
  8004d9:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004e0:	79 5c                	jns    80053e <vprintfmt+0x2e5>
				putch('-', putdat);
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	53                   	push   %ebx
  8004e6:	6a 2d                	push   $0x2d
  8004e8:	ff d6                	call   *%esi
				num = -(long long) num;
  8004ea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004ed:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004f0:	f7 da                	neg    %edx
  8004f2:	83 d1 00             	adc    $0x0,%ecx
  8004f5:	f7 d9                	neg    %ecx
  8004f7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004fa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004ff:	e9 10 01 00 00       	jmp    800614 <vprintfmt+0x3bb>
	else if (lflag)
  800504:	85 c9                	test   %ecx,%ecx
  800506:	75 1b                	jne    800523 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800510:	89 c1                	mov    %eax,%ecx
  800512:	c1 f9 1f             	sar    $0x1f,%ecx
  800515:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8d 40 04             	lea    0x4(%eax),%eax
  80051e:	89 45 14             	mov    %eax,0x14(%ebp)
  800521:	eb b9                	jmp    8004dc <vprintfmt+0x283>
		return va_arg(*ap, long);
  800523:	8b 45 14             	mov    0x14(%ebp),%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052b:	89 c1                	mov    %eax,%ecx
  80052d:	c1 f9 1f             	sar    $0x1f,%ecx
  800530:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800533:	8b 45 14             	mov    0x14(%ebp),%eax
  800536:	8d 40 04             	lea    0x4(%eax),%eax
  800539:	89 45 14             	mov    %eax,0x14(%ebp)
  80053c:	eb 9e                	jmp    8004dc <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80053e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800541:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800544:	b8 0a 00 00 00       	mov    $0xa,%eax
  800549:	e9 c6 00 00 00       	jmp    800614 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80054e:	83 f9 01             	cmp    $0x1,%ecx
  800551:	7e 18                	jle    80056b <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	8b 10                	mov    (%eax),%edx
  800558:	8b 48 04             	mov    0x4(%eax),%ecx
  80055b:	8d 40 08             	lea    0x8(%eax),%eax
  80055e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800561:	b8 0a 00 00 00       	mov    $0xa,%eax
  800566:	e9 a9 00 00 00       	jmp    800614 <vprintfmt+0x3bb>
	else if (lflag)
  80056b:	85 c9                	test   %ecx,%ecx
  80056d:	75 1a                	jne    800589 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8b 10                	mov    (%eax),%edx
  800574:	b9 00 00 00 00       	mov    $0x0,%ecx
  800579:	8d 40 04             	lea    0x4(%eax),%eax
  80057c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800584:	e9 8b 00 00 00       	jmp    800614 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	8b 10                	mov    (%eax),%edx
  80058e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800593:	8d 40 04             	lea    0x4(%eax),%eax
  800596:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800599:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059e:	eb 74                	jmp    800614 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005a0:	83 f9 01             	cmp    $0x1,%ecx
  8005a3:	7e 15                	jle    8005ba <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 10                	mov    (%eax),%edx
  8005aa:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ad:	8d 40 08             	lea    0x8(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005b3:	b8 08 00 00 00       	mov    $0x8,%eax
  8005b8:	eb 5a                	jmp    800614 <vprintfmt+0x3bb>
	else if (lflag)
  8005ba:	85 c9                	test   %ecx,%ecx
  8005bc:	75 17                	jne    8005d5 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 10                	mov    (%eax),%edx
  8005c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c8:	8d 40 04             	lea    0x4(%eax),%eax
  8005cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8005d3:	eb 3f                	jmp    800614 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8b 10                	mov    (%eax),%edx
  8005da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005df:	8d 40 04             	lea    0x4(%eax),%eax
  8005e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005e5:	b8 08 00 00 00       	mov    $0x8,%eax
  8005ea:	eb 28                	jmp    800614 <vprintfmt+0x3bb>
			putch('0', putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	53                   	push   %ebx
  8005f0:	6a 30                	push   $0x30
  8005f2:	ff d6                	call   *%esi
			putch('x', putdat);
  8005f4:	83 c4 08             	add    $0x8,%esp
  8005f7:	53                   	push   %ebx
  8005f8:	6a 78                	push   $0x78
  8005fa:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 10                	mov    (%eax),%edx
  800601:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800606:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800609:	8d 40 04             	lea    0x4(%eax),%eax
  80060c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80060f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800614:	83 ec 0c             	sub    $0xc,%esp
  800617:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80061b:	57                   	push   %edi
  80061c:	ff 75 e0             	pushl  -0x20(%ebp)
  80061f:	50                   	push   %eax
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	89 da                	mov    %ebx,%edx
  800624:	89 f0                	mov    %esi,%eax
  800626:	e8 45 fb ff ff       	call   800170 <printnum>
			break;
  80062b:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80062e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  800631:	83 c7 01             	add    $0x1,%edi
  800634:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800638:	83 f8 25             	cmp    $0x25,%eax
  80063b:	0f 84 2f fc ff ff    	je     800270 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  800641:	85 c0                	test   %eax,%eax
  800643:	0f 84 8b 00 00 00    	je     8006d4 <vprintfmt+0x47b>
			putch(ch, putdat);
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	53                   	push   %ebx
  80064d:	50                   	push   %eax
  80064e:	ff d6                	call   *%esi
  800650:	83 c4 10             	add    $0x10,%esp
  800653:	eb dc                	jmp    800631 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800655:	83 f9 01             	cmp    $0x1,%ecx
  800658:	7e 15                	jle    80066f <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 10                	mov    (%eax),%edx
  80065f:	8b 48 04             	mov    0x4(%eax),%ecx
  800662:	8d 40 08             	lea    0x8(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800668:	b8 10 00 00 00       	mov    $0x10,%eax
  80066d:	eb a5                	jmp    800614 <vprintfmt+0x3bb>
	else if (lflag)
  80066f:	85 c9                	test   %ecx,%ecx
  800671:	75 17                	jne    80068a <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8b 10                	mov    (%eax),%edx
  800678:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067d:	8d 40 04             	lea    0x4(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800683:	b8 10 00 00 00       	mov    $0x10,%eax
  800688:	eb 8a                	jmp    800614 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 10                	mov    (%eax),%edx
  80068f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800694:	8d 40 04             	lea    0x4(%eax),%eax
  800697:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069a:	b8 10 00 00 00       	mov    $0x10,%eax
  80069f:	e9 70 ff ff ff       	jmp    800614 <vprintfmt+0x3bb>
			putch(ch, putdat);
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	53                   	push   %ebx
  8006a8:	6a 25                	push   $0x25
  8006aa:	ff d6                	call   *%esi
			break;
  8006ac:	83 c4 10             	add    $0x10,%esp
  8006af:	e9 7a ff ff ff       	jmp    80062e <vprintfmt+0x3d5>
			putch('%', putdat);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	6a 25                	push   $0x25
  8006ba:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	89 f8                	mov    %edi,%eax
  8006c1:	eb 03                	jmp    8006c6 <vprintfmt+0x46d>
  8006c3:	83 e8 01             	sub    $0x1,%eax
  8006c6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006ca:	75 f7                	jne    8006c3 <vprintfmt+0x46a>
  8006cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006cf:	e9 5a ff ff ff       	jmp    80062e <vprintfmt+0x3d5>
}
  8006d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d7:	5b                   	pop    %ebx
  8006d8:	5e                   	pop    %esi
  8006d9:	5f                   	pop    %edi
  8006da:	5d                   	pop    %ebp
  8006db:	c3                   	ret    

008006dc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006dc:	55                   	push   %ebp
  8006dd:	89 e5                	mov    %esp,%ebp
  8006df:	83 ec 18             	sub    $0x18,%esp
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006eb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006ef:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006f9:	85 c0                	test   %eax,%eax
  8006fb:	74 26                	je     800723 <vsnprintf+0x47>
  8006fd:	85 d2                	test   %edx,%edx
  8006ff:	7e 22                	jle    800723 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800701:	ff 75 14             	pushl  0x14(%ebp)
  800704:	ff 75 10             	pushl  0x10(%ebp)
  800707:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80070a:	50                   	push   %eax
  80070b:	68 1f 02 80 00       	push   $0x80021f
  800710:	e8 44 fb ff ff       	call   800259 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800715:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800718:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80071b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80071e:	83 c4 10             	add    $0x10,%esp
}
  800721:	c9                   	leave  
  800722:	c3                   	ret    
		return -E_INVAL;
  800723:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800728:	eb f7                	jmp    800721 <vsnprintf+0x45>

0080072a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
  80072d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800730:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800733:	50                   	push   %eax
  800734:	ff 75 10             	pushl  0x10(%ebp)
  800737:	ff 75 0c             	pushl  0xc(%ebp)
  80073a:	ff 75 08             	pushl  0x8(%ebp)
  80073d:	e8 9a ff ff ff       	call   8006dc <vsnprintf>
	va_end(ap);

	return rc;
}
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80074a:	b8 00 00 00 00       	mov    $0x0,%eax
  80074f:	eb 03                	jmp    800754 <strlen+0x10>
		n++;
  800751:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800754:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800758:	75 f7                	jne    800751 <strlen+0xd>
	return n;
}
  80075a:	5d                   	pop    %ebp
  80075b:	c3                   	ret    

0080075c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800762:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800765:	b8 00 00 00 00       	mov    $0x0,%eax
  80076a:	eb 03                	jmp    80076f <strnlen+0x13>
		n++;
  80076c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80076f:	39 d0                	cmp    %edx,%eax
  800771:	74 06                	je     800779 <strnlen+0x1d>
  800773:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800777:	75 f3                	jne    80076c <strnlen+0x10>
	return n;
}
  800779:	5d                   	pop    %ebp
  80077a:	c3                   	ret    

0080077b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	53                   	push   %ebx
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800785:	89 c2                	mov    %eax,%edx
  800787:	83 c1 01             	add    $0x1,%ecx
  80078a:	83 c2 01             	add    $0x1,%edx
  80078d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800791:	88 5a ff             	mov    %bl,-0x1(%edx)
  800794:	84 db                	test   %bl,%bl
  800796:	75 ef                	jne    800787 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800798:	5b                   	pop    %ebx
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	53                   	push   %ebx
  80079f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007a2:	53                   	push   %ebx
  8007a3:	e8 9c ff ff ff       	call   800744 <strlen>
  8007a8:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007ab:	ff 75 0c             	pushl  0xc(%ebp)
  8007ae:	01 d8                	add    %ebx,%eax
  8007b0:	50                   	push   %eax
  8007b1:	e8 c5 ff ff ff       	call   80077b <strcpy>
	return dst;
}
  8007b6:	89 d8                	mov    %ebx,%eax
  8007b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007bb:	c9                   	leave  
  8007bc:	c3                   	ret    

008007bd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	56                   	push   %esi
  8007c1:	53                   	push   %ebx
  8007c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c8:	89 f3                	mov    %esi,%ebx
  8007ca:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007cd:	89 f2                	mov    %esi,%edx
  8007cf:	eb 0f                	jmp    8007e0 <strncpy+0x23>
		*dst++ = *src;
  8007d1:	83 c2 01             	add    $0x1,%edx
  8007d4:	0f b6 01             	movzbl (%ecx),%eax
  8007d7:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007da:	80 39 01             	cmpb   $0x1,(%ecx)
  8007dd:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007e0:	39 da                	cmp    %ebx,%edx
  8007e2:	75 ed                	jne    8007d1 <strncpy+0x14>
	}
	return ret;
}
  8007e4:	89 f0                	mov    %esi,%eax
  8007e6:	5b                   	pop    %ebx
  8007e7:	5e                   	pop    %esi
  8007e8:	5d                   	pop    %ebp
  8007e9:	c3                   	ret    

008007ea <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	56                   	push   %esi
  8007ee:	53                   	push   %ebx
  8007ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007f8:	89 f0                	mov    %esi,%eax
  8007fa:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007fe:	85 c9                	test   %ecx,%ecx
  800800:	75 0b                	jne    80080d <strlcpy+0x23>
  800802:	eb 17                	jmp    80081b <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800804:	83 c2 01             	add    $0x1,%edx
  800807:	83 c0 01             	add    $0x1,%eax
  80080a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80080d:	39 d8                	cmp    %ebx,%eax
  80080f:	74 07                	je     800818 <strlcpy+0x2e>
  800811:	0f b6 0a             	movzbl (%edx),%ecx
  800814:	84 c9                	test   %cl,%cl
  800816:	75 ec                	jne    800804 <strlcpy+0x1a>
		*dst = '\0';
  800818:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80081b:	29 f0                	sub    %esi,%eax
}
  80081d:	5b                   	pop    %ebx
  80081e:	5e                   	pop    %esi
  80081f:	5d                   	pop    %ebp
  800820:	c3                   	ret    

00800821 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800827:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80082a:	eb 06                	jmp    800832 <strcmp+0x11>
		p++, q++;
  80082c:	83 c1 01             	add    $0x1,%ecx
  80082f:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800832:	0f b6 01             	movzbl (%ecx),%eax
  800835:	84 c0                	test   %al,%al
  800837:	74 04                	je     80083d <strcmp+0x1c>
  800839:	3a 02                	cmp    (%edx),%al
  80083b:	74 ef                	je     80082c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80083d:	0f b6 c0             	movzbl %al,%eax
  800840:	0f b6 12             	movzbl (%edx),%edx
  800843:	29 d0                	sub    %edx,%eax
}
  800845:	5d                   	pop    %ebp
  800846:	c3                   	ret    

00800847 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	53                   	push   %ebx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800851:	89 c3                	mov    %eax,%ebx
  800853:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800856:	eb 06                	jmp    80085e <strncmp+0x17>
		n--, p++, q++;
  800858:	83 c0 01             	add    $0x1,%eax
  80085b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80085e:	39 d8                	cmp    %ebx,%eax
  800860:	74 16                	je     800878 <strncmp+0x31>
  800862:	0f b6 08             	movzbl (%eax),%ecx
  800865:	84 c9                	test   %cl,%cl
  800867:	74 04                	je     80086d <strncmp+0x26>
  800869:	3a 0a                	cmp    (%edx),%cl
  80086b:	74 eb                	je     800858 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80086d:	0f b6 00             	movzbl (%eax),%eax
  800870:	0f b6 12             	movzbl (%edx),%edx
  800873:	29 d0                	sub    %edx,%eax
}
  800875:	5b                   	pop    %ebx
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    
		return 0;
  800878:	b8 00 00 00 00       	mov    $0x0,%eax
  80087d:	eb f6                	jmp    800875 <strncmp+0x2e>

0080087f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800889:	0f b6 10             	movzbl (%eax),%edx
  80088c:	84 d2                	test   %dl,%dl
  80088e:	74 09                	je     800899 <strchr+0x1a>
		if (*s == c)
  800890:	38 ca                	cmp    %cl,%dl
  800892:	74 0a                	je     80089e <strchr+0x1f>
	for (; *s; s++)
  800894:	83 c0 01             	add    $0x1,%eax
  800897:	eb f0                	jmp    800889 <strchr+0xa>
			return (char *) s;
	return 0;
  800899:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80089e:	5d                   	pop    %ebp
  80089f:	c3                   	ret    

008008a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008aa:	eb 03                	jmp    8008af <strfind+0xf>
  8008ac:	83 c0 01             	add    $0x1,%eax
  8008af:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008b2:	38 ca                	cmp    %cl,%dl
  8008b4:	74 04                	je     8008ba <strfind+0x1a>
  8008b6:	84 d2                	test   %dl,%dl
  8008b8:	75 f2                	jne    8008ac <strfind+0xc>
			break;
	return (char *) s;
}
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    

008008bc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008bc:	55                   	push   %ebp
  8008bd:	89 e5                	mov    %esp,%ebp
  8008bf:	57                   	push   %edi
  8008c0:	56                   	push   %esi
  8008c1:	53                   	push   %ebx
  8008c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008c8:	85 c9                	test   %ecx,%ecx
  8008ca:	74 13                	je     8008df <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008cc:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008d2:	75 05                	jne    8008d9 <memset+0x1d>
  8008d4:	f6 c1 03             	test   $0x3,%cl
  8008d7:	74 0d                	je     8008e6 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dc:	fc                   	cld    
  8008dd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008df:	89 f8                	mov    %edi,%eax
  8008e1:	5b                   	pop    %ebx
  8008e2:	5e                   	pop    %esi
  8008e3:	5f                   	pop    %edi
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    
		c &= 0xFF;
  8008e6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008ea:	89 d3                	mov    %edx,%ebx
  8008ec:	c1 e3 08             	shl    $0x8,%ebx
  8008ef:	89 d0                	mov    %edx,%eax
  8008f1:	c1 e0 18             	shl    $0x18,%eax
  8008f4:	89 d6                	mov    %edx,%esi
  8008f6:	c1 e6 10             	shl    $0x10,%esi
  8008f9:	09 f0                	or     %esi,%eax
  8008fb:	09 c2                	or     %eax,%edx
  8008fd:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008ff:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800902:	89 d0                	mov    %edx,%eax
  800904:	fc                   	cld    
  800905:	f3 ab                	rep stos %eax,%es:(%edi)
  800907:	eb d6                	jmp    8008df <memset+0x23>

00800909 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	57                   	push   %edi
  80090d:	56                   	push   %esi
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 75 0c             	mov    0xc(%ebp),%esi
  800914:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800917:	39 c6                	cmp    %eax,%esi
  800919:	73 35                	jae    800950 <memmove+0x47>
  80091b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80091e:	39 c2                	cmp    %eax,%edx
  800920:	76 2e                	jbe    800950 <memmove+0x47>
		s += n;
		d += n;
  800922:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800925:	89 d6                	mov    %edx,%esi
  800927:	09 fe                	or     %edi,%esi
  800929:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80092f:	74 0c                	je     80093d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800931:	83 ef 01             	sub    $0x1,%edi
  800934:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800937:	fd                   	std    
  800938:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80093a:	fc                   	cld    
  80093b:	eb 21                	jmp    80095e <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80093d:	f6 c1 03             	test   $0x3,%cl
  800940:	75 ef                	jne    800931 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800942:	83 ef 04             	sub    $0x4,%edi
  800945:	8d 72 fc             	lea    -0x4(%edx),%esi
  800948:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80094b:	fd                   	std    
  80094c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80094e:	eb ea                	jmp    80093a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800950:	89 f2                	mov    %esi,%edx
  800952:	09 c2                	or     %eax,%edx
  800954:	f6 c2 03             	test   $0x3,%dl
  800957:	74 09                	je     800962 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800959:	89 c7                	mov    %eax,%edi
  80095b:	fc                   	cld    
  80095c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80095e:	5e                   	pop    %esi
  80095f:	5f                   	pop    %edi
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800962:	f6 c1 03             	test   $0x3,%cl
  800965:	75 f2                	jne    800959 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800967:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80096a:	89 c7                	mov    %eax,%edi
  80096c:	fc                   	cld    
  80096d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80096f:	eb ed                	jmp    80095e <memmove+0x55>

00800971 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800974:	ff 75 10             	pushl  0x10(%ebp)
  800977:	ff 75 0c             	pushl  0xc(%ebp)
  80097a:	ff 75 08             	pushl  0x8(%ebp)
  80097d:	e8 87 ff ff ff       	call   800909 <memmove>
}
  800982:	c9                   	leave  
  800983:	c3                   	ret    

00800984 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	56                   	push   %esi
  800988:	53                   	push   %ebx
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098f:	89 c6                	mov    %eax,%esi
  800991:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800994:	39 f0                	cmp    %esi,%eax
  800996:	74 1c                	je     8009b4 <memcmp+0x30>
		if (*s1 != *s2)
  800998:	0f b6 08             	movzbl (%eax),%ecx
  80099b:	0f b6 1a             	movzbl (%edx),%ebx
  80099e:	38 d9                	cmp    %bl,%cl
  8009a0:	75 08                	jne    8009aa <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009a2:	83 c0 01             	add    $0x1,%eax
  8009a5:	83 c2 01             	add    $0x1,%edx
  8009a8:	eb ea                	jmp    800994 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009aa:	0f b6 c1             	movzbl %cl,%eax
  8009ad:	0f b6 db             	movzbl %bl,%ebx
  8009b0:	29 d8                	sub    %ebx,%eax
  8009b2:	eb 05                	jmp    8009b9 <memcmp+0x35>
	}

	return 0;
  8009b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009b9:	5b                   	pop    %ebx
  8009ba:	5e                   	pop    %esi
  8009bb:	5d                   	pop    %ebp
  8009bc:	c3                   	ret    

008009bd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009c6:	89 c2                	mov    %eax,%edx
  8009c8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009cb:	39 d0                	cmp    %edx,%eax
  8009cd:	73 09                	jae    8009d8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009cf:	38 08                	cmp    %cl,(%eax)
  8009d1:	74 05                	je     8009d8 <memfind+0x1b>
	for (; s < ends; s++)
  8009d3:	83 c0 01             	add    $0x1,%eax
  8009d6:	eb f3                	jmp    8009cb <memfind+0xe>
			break;
	return (void *) s;
}
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	57                   	push   %edi
  8009de:	56                   	push   %esi
  8009df:	53                   	push   %ebx
  8009e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009e6:	eb 03                	jmp    8009eb <strtol+0x11>
		s++;
  8009e8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009eb:	0f b6 01             	movzbl (%ecx),%eax
  8009ee:	3c 20                	cmp    $0x20,%al
  8009f0:	74 f6                	je     8009e8 <strtol+0xe>
  8009f2:	3c 09                	cmp    $0x9,%al
  8009f4:	74 f2                	je     8009e8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009f6:	3c 2b                	cmp    $0x2b,%al
  8009f8:	74 2e                	je     800a28 <strtol+0x4e>
	int neg = 0;
  8009fa:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009ff:	3c 2d                	cmp    $0x2d,%al
  800a01:	74 2f                	je     800a32 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a03:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a09:	75 05                	jne    800a10 <strtol+0x36>
  800a0b:	80 39 30             	cmpb   $0x30,(%ecx)
  800a0e:	74 2c                	je     800a3c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a10:	85 db                	test   %ebx,%ebx
  800a12:	75 0a                	jne    800a1e <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a14:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a19:	80 39 30             	cmpb   $0x30,(%ecx)
  800a1c:	74 28                	je     800a46 <strtol+0x6c>
		base = 10;
  800a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a23:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a26:	eb 50                	jmp    800a78 <strtol+0x9e>
		s++;
  800a28:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a2b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a30:	eb d1                	jmp    800a03 <strtol+0x29>
		s++, neg = 1;
  800a32:	83 c1 01             	add    $0x1,%ecx
  800a35:	bf 01 00 00 00       	mov    $0x1,%edi
  800a3a:	eb c7                	jmp    800a03 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a3c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a40:	74 0e                	je     800a50 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a42:	85 db                	test   %ebx,%ebx
  800a44:	75 d8                	jne    800a1e <strtol+0x44>
		s++, base = 8;
  800a46:	83 c1 01             	add    $0x1,%ecx
  800a49:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a4e:	eb ce                	jmp    800a1e <strtol+0x44>
		s += 2, base = 16;
  800a50:	83 c1 02             	add    $0x2,%ecx
  800a53:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a58:	eb c4                	jmp    800a1e <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a5a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a5d:	89 f3                	mov    %esi,%ebx
  800a5f:	80 fb 19             	cmp    $0x19,%bl
  800a62:	77 29                	ja     800a8d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a64:	0f be d2             	movsbl %dl,%edx
  800a67:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a6a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a6d:	7d 30                	jge    800a9f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a6f:	83 c1 01             	add    $0x1,%ecx
  800a72:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a76:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a78:	0f b6 11             	movzbl (%ecx),%edx
  800a7b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a7e:	89 f3                	mov    %esi,%ebx
  800a80:	80 fb 09             	cmp    $0x9,%bl
  800a83:	77 d5                	ja     800a5a <strtol+0x80>
			dig = *s - '0';
  800a85:	0f be d2             	movsbl %dl,%edx
  800a88:	83 ea 30             	sub    $0x30,%edx
  800a8b:	eb dd                	jmp    800a6a <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a8d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a90:	89 f3                	mov    %esi,%ebx
  800a92:	80 fb 19             	cmp    $0x19,%bl
  800a95:	77 08                	ja     800a9f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a97:	0f be d2             	movsbl %dl,%edx
  800a9a:	83 ea 37             	sub    $0x37,%edx
  800a9d:	eb cb                	jmp    800a6a <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa3:	74 05                	je     800aaa <strtol+0xd0>
		*endptr = (char *) s;
  800aa5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800aaa:	89 c2                	mov    %eax,%edx
  800aac:	f7 da                	neg    %edx
  800aae:	85 ff                	test   %edi,%edi
  800ab0:	0f 45 c2             	cmovne %edx,%eax
}
  800ab3:	5b                   	pop    %ebx
  800ab4:	5e                   	pop    %esi
  800ab5:	5f                   	pop    %edi
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    

00800ab8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	57                   	push   %edi
  800abc:	56                   	push   %esi
  800abd:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800abe:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac9:	89 c3                	mov    %eax,%ebx
  800acb:	89 c7                	mov    %eax,%edi
  800acd:	89 c6                	mov    %eax,%esi
  800acf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5f                   	pop    %edi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	57                   	push   %edi
  800ada:	56                   	push   %esi
  800adb:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800adc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae1:	b8 01 00 00 00       	mov    $0x1,%eax
  800ae6:	89 d1                	mov    %edx,%ecx
  800ae8:	89 d3                	mov    %edx,%ebx
  800aea:	89 d7                	mov    %edx,%edi
  800aec:	89 d6                	mov    %edx,%esi
  800aee:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800af0:	5b                   	pop    %ebx
  800af1:	5e                   	pop    %esi
  800af2:	5f                   	pop    %edi
  800af3:	5d                   	pop    %ebp
  800af4:	c3                   	ret    

00800af5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	57                   	push   %edi
  800af9:	56                   	push   %esi
  800afa:	53                   	push   %ebx
  800afb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800afe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b03:	8b 55 08             	mov    0x8(%ebp),%edx
  800b06:	b8 03 00 00 00       	mov    $0x3,%eax
  800b0b:	89 cb                	mov    %ecx,%ebx
  800b0d:	89 cf                	mov    %ecx,%edi
  800b0f:	89 ce                	mov    %ecx,%esi
  800b11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b13:	85 c0                	test   %eax,%eax
  800b15:	7f 08                	jg     800b1f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b1a:	5b                   	pop    %ebx
  800b1b:	5e                   	pop    %esi
  800b1c:	5f                   	pop    %edi
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b1f:	83 ec 0c             	sub    $0xc,%esp
  800b22:	50                   	push   %eax
  800b23:	6a 03                	push   $0x3
  800b25:	68 3f 13 80 00       	push   $0x80133f
  800b2a:	6a 23                	push   $0x23
  800b2c:	68 5c 13 80 00       	push   $0x80135c
  800b31:	e8 2f 02 00 00       	call   800d65 <_panic>

00800b36 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	57                   	push   %edi
  800b3a:	56                   	push   %esi
  800b3b:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b41:	b8 02 00 00 00       	mov    $0x2,%eax
  800b46:	89 d1                	mov    %edx,%ecx
  800b48:	89 d3                	mov    %edx,%ebx
  800b4a:	89 d7                	mov    %edx,%edi
  800b4c:	89 d6                	mov    %edx,%esi
  800b4e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b50:	5b                   	pop    %ebx
  800b51:	5e                   	pop    %esi
  800b52:	5f                   	pop    %edi
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <sys_yield>:

void
sys_yield(void)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	57                   	push   %edi
  800b59:	56                   	push   %esi
  800b5a:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b60:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b65:	89 d1                	mov    %edx,%ecx
  800b67:	89 d3                	mov    %edx,%ebx
  800b69:	89 d7                	mov    %edx,%edi
  800b6b:	89 d6                	mov    %edx,%esi
  800b6d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b6f:	5b                   	pop    %ebx
  800b70:	5e                   	pop    %esi
  800b71:	5f                   	pop    %edi
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	53                   	push   %ebx
  800b7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b7d:	be 00 00 00 00       	mov    $0x0,%esi
  800b82:	8b 55 08             	mov    0x8(%ebp),%edx
  800b85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b88:	b8 04 00 00 00       	mov    $0x4,%eax
  800b8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b90:	89 f7                	mov    %esi,%edi
  800b92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b94:	85 c0                	test   %eax,%eax
  800b96:	7f 08                	jg     800ba0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b9b:	5b                   	pop    %ebx
  800b9c:	5e                   	pop    %esi
  800b9d:	5f                   	pop    %edi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba0:	83 ec 0c             	sub    $0xc,%esp
  800ba3:	50                   	push   %eax
  800ba4:	6a 04                	push   $0x4
  800ba6:	68 3f 13 80 00       	push   $0x80133f
  800bab:	6a 23                	push   $0x23
  800bad:	68 5c 13 80 00       	push   $0x80135c
  800bb2:	e8 ae 01 00 00       	call   800d65 <_panic>

00800bb7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	57                   	push   %edi
  800bbb:	56                   	push   %esi
  800bbc:	53                   	push   %ebx
  800bbd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc6:	b8 05 00 00 00       	mov    $0x5,%eax
  800bcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bce:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bd1:	8b 75 18             	mov    0x18(%ebp),%esi
  800bd4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd6:	85 c0                	test   %eax,%eax
  800bd8:	7f 08                	jg     800be2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bdd:	5b                   	pop    %ebx
  800bde:	5e                   	pop    %esi
  800bdf:	5f                   	pop    %edi
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be2:	83 ec 0c             	sub    $0xc,%esp
  800be5:	50                   	push   %eax
  800be6:	6a 05                	push   $0x5
  800be8:	68 3f 13 80 00       	push   $0x80133f
  800bed:	6a 23                	push   $0x23
  800bef:	68 5c 13 80 00       	push   $0x80135c
  800bf4:	e8 6c 01 00 00       	call   800d65 <_panic>

00800bf9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	57                   	push   %edi
  800bfd:	56                   	push   %esi
  800bfe:	53                   	push   %ebx
  800bff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c02:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c07:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0d:	b8 06 00 00 00       	mov    $0x6,%eax
  800c12:	89 df                	mov    %ebx,%edi
  800c14:	89 de                	mov    %ebx,%esi
  800c16:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c18:	85 c0                	test   %eax,%eax
  800c1a:	7f 08                	jg     800c24 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c1f:	5b                   	pop    %ebx
  800c20:	5e                   	pop    %esi
  800c21:	5f                   	pop    %edi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c24:	83 ec 0c             	sub    $0xc,%esp
  800c27:	50                   	push   %eax
  800c28:	6a 06                	push   $0x6
  800c2a:	68 3f 13 80 00       	push   $0x80133f
  800c2f:	6a 23                	push   $0x23
  800c31:	68 5c 13 80 00       	push   $0x80135c
  800c36:	e8 2a 01 00 00       	call   800d65 <_panic>

00800c3b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	57                   	push   %edi
  800c3f:	56                   	push   %esi
  800c40:	53                   	push   %ebx
  800c41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c49:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4f:	b8 08 00 00 00       	mov    $0x8,%eax
  800c54:	89 df                	mov    %ebx,%edi
  800c56:	89 de                	mov    %ebx,%esi
  800c58:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5a:	85 c0                	test   %eax,%eax
  800c5c:	7f 08                	jg     800c66 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c61:	5b                   	pop    %ebx
  800c62:	5e                   	pop    %esi
  800c63:	5f                   	pop    %edi
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c66:	83 ec 0c             	sub    $0xc,%esp
  800c69:	50                   	push   %eax
  800c6a:	6a 08                	push   $0x8
  800c6c:	68 3f 13 80 00       	push   $0x80133f
  800c71:	6a 23                	push   $0x23
  800c73:	68 5c 13 80 00       	push   $0x80135c
  800c78:	e8 e8 00 00 00       	call   800d65 <_panic>

00800c7d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
  800c80:	57                   	push   %edi
  800c81:	56                   	push   %esi
  800c82:	53                   	push   %ebx
  800c83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c91:	b8 09 00 00 00       	mov    $0x9,%eax
  800c96:	89 df                	mov    %ebx,%edi
  800c98:	89 de                	mov    %ebx,%esi
  800c9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9c:	85 c0                	test   %eax,%eax
  800c9e:	7f 08                	jg     800ca8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ca0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca3:	5b                   	pop    %ebx
  800ca4:	5e                   	pop    %esi
  800ca5:	5f                   	pop    %edi
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca8:	83 ec 0c             	sub    $0xc,%esp
  800cab:	50                   	push   %eax
  800cac:	6a 09                	push   $0x9
  800cae:	68 3f 13 80 00       	push   $0x80133f
  800cb3:	6a 23                	push   $0x23
  800cb5:	68 5c 13 80 00       	push   $0x80135c
  800cba:	e8 a6 00 00 00       	call   800d65 <_panic>

00800cbf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	57                   	push   %edi
  800cc3:	56                   	push   %esi
  800cc4:	53                   	push   %ebx
  800cc5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800cc8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ccd:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cd8:	89 df                	mov    %ebx,%edi
  800cda:	89 de                	mov    %ebx,%esi
  800cdc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cde:	85 c0                	test   %eax,%eax
  800ce0:	7f 08                	jg     800cea <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ce2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5f                   	pop    %edi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cea:	83 ec 0c             	sub    $0xc,%esp
  800ced:	50                   	push   %eax
  800cee:	6a 0a                	push   $0xa
  800cf0:	68 3f 13 80 00       	push   $0x80133f
  800cf5:	6a 23                	push   $0x23
  800cf7:	68 5c 13 80 00       	push   $0x80135c
  800cfc:	e8 64 00 00 00       	call   800d65 <_panic>

00800d01 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	57                   	push   %edi
  800d05:	56                   	push   %esi
  800d06:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d07:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d12:	be 00 00 00 00       	mov    $0x0,%esi
  800d17:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d1d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d1f:	5b                   	pop    %ebx
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
  800d2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d32:	8b 55 08             	mov    0x8(%ebp),%edx
  800d35:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d3a:	89 cb                	mov    %ecx,%ebx
  800d3c:	89 cf                	mov    %ecx,%edi
  800d3e:	89 ce                	mov    %ecx,%esi
  800d40:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d42:	85 c0                	test   %eax,%eax
  800d44:	7f 08                	jg     800d4e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d49:	5b                   	pop    %ebx
  800d4a:	5e                   	pop    %esi
  800d4b:	5f                   	pop    %edi
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4e:	83 ec 0c             	sub    $0xc,%esp
  800d51:	50                   	push   %eax
  800d52:	6a 0d                	push   $0xd
  800d54:	68 3f 13 80 00       	push   $0x80133f
  800d59:	6a 23                	push   $0x23
  800d5b:	68 5c 13 80 00       	push   $0x80135c
  800d60:	e8 00 00 00 00       	call   800d65 <_panic>

00800d65 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800d6a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d6d:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800d73:	e8 be fd ff ff       	call   800b36 <sys_getenvid>
  800d78:	83 ec 0c             	sub    $0xc,%esp
  800d7b:	ff 75 0c             	pushl  0xc(%ebp)
  800d7e:	ff 75 08             	pushl  0x8(%ebp)
  800d81:	56                   	push   %esi
  800d82:	50                   	push   %eax
  800d83:	68 6c 13 80 00       	push   $0x80136c
  800d88:	e8 cf f3 ff ff       	call   80015c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800d8d:	83 c4 18             	add    $0x18,%esp
  800d90:	53                   	push   %ebx
  800d91:	ff 75 10             	pushl  0x10(%ebp)
  800d94:	e8 72 f3 ff ff       	call   80010b <vcprintf>
	cprintf("\n");
  800d99:	c7 04 24 0c 10 80 00 	movl   $0x80100c,(%esp)
  800da0:	e8 b7 f3 ff ff       	call   80015c <cprintf>
  800da5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800da8:	cc                   	int3   
  800da9:	eb fd                	jmp    800da8 <_panic+0x43>
  800dab:	66 90                	xchg   %ax,%ax
  800dad:	66 90                	xchg   %ax,%ax
  800daf:	90                   	nop

00800db0 <__udivdi3>:
  800db0:	55                   	push   %ebp
  800db1:	57                   	push   %edi
  800db2:	56                   	push   %esi
  800db3:	53                   	push   %ebx
  800db4:	83 ec 1c             	sub    $0x1c,%esp
  800db7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800dbb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800dbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800dc3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800dc7:	85 d2                	test   %edx,%edx
  800dc9:	75 35                	jne    800e00 <__udivdi3+0x50>
  800dcb:	39 f3                	cmp    %esi,%ebx
  800dcd:	0f 87 bd 00 00 00    	ja     800e90 <__udivdi3+0xe0>
  800dd3:	85 db                	test   %ebx,%ebx
  800dd5:	89 d9                	mov    %ebx,%ecx
  800dd7:	75 0b                	jne    800de4 <__udivdi3+0x34>
  800dd9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dde:	31 d2                	xor    %edx,%edx
  800de0:	f7 f3                	div    %ebx
  800de2:	89 c1                	mov    %eax,%ecx
  800de4:	31 d2                	xor    %edx,%edx
  800de6:	89 f0                	mov    %esi,%eax
  800de8:	f7 f1                	div    %ecx
  800dea:	89 c6                	mov    %eax,%esi
  800dec:	89 e8                	mov    %ebp,%eax
  800dee:	89 f7                	mov    %esi,%edi
  800df0:	f7 f1                	div    %ecx
  800df2:	89 fa                	mov    %edi,%edx
  800df4:	83 c4 1c             	add    $0x1c,%esp
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    
  800dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800e00:	39 f2                	cmp    %esi,%edx
  800e02:	77 7c                	ja     800e80 <__udivdi3+0xd0>
  800e04:	0f bd fa             	bsr    %edx,%edi
  800e07:	83 f7 1f             	xor    $0x1f,%edi
  800e0a:	0f 84 98 00 00 00    	je     800ea8 <__udivdi3+0xf8>
  800e10:	89 f9                	mov    %edi,%ecx
  800e12:	b8 20 00 00 00       	mov    $0x20,%eax
  800e17:	29 f8                	sub    %edi,%eax
  800e19:	d3 e2                	shl    %cl,%edx
  800e1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e1f:	89 c1                	mov    %eax,%ecx
  800e21:	89 da                	mov    %ebx,%edx
  800e23:	d3 ea                	shr    %cl,%edx
  800e25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800e29:	09 d1                	or     %edx,%ecx
  800e2b:	89 f2                	mov    %esi,%edx
  800e2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e31:	89 f9                	mov    %edi,%ecx
  800e33:	d3 e3                	shl    %cl,%ebx
  800e35:	89 c1                	mov    %eax,%ecx
  800e37:	d3 ea                	shr    %cl,%edx
  800e39:	89 f9                	mov    %edi,%ecx
  800e3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800e3f:	d3 e6                	shl    %cl,%esi
  800e41:	89 eb                	mov    %ebp,%ebx
  800e43:	89 c1                	mov    %eax,%ecx
  800e45:	d3 eb                	shr    %cl,%ebx
  800e47:	09 de                	or     %ebx,%esi
  800e49:	89 f0                	mov    %esi,%eax
  800e4b:	f7 74 24 08          	divl   0x8(%esp)
  800e4f:	89 d6                	mov    %edx,%esi
  800e51:	89 c3                	mov    %eax,%ebx
  800e53:	f7 64 24 0c          	mull   0xc(%esp)
  800e57:	39 d6                	cmp    %edx,%esi
  800e59:	72 0c                	jb     800e67 <__udivdi3+0xb7>
  800e5b:	89 f9                	mov    %edi,%ecx
  800e5d:	d3 e5                	shl    %cl,%ebp
  800e5f:	39 c5                	cmp    %eax,%ebp
  800e61:	73 5d                	jae    800ec0 <__udivdi3+0x110>
  800e63:	39 d6                	cmp    %edx,%esi
  800e65:	75 59                	jne    800ec0 <__udivdi3+0x110>
  800e67:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800e6a:	31 ff                	xor    %edi,%edi
  800e6c:	89 fa                	mov    %edi,%edx
  800e6e:	83 c4 1c             	add    $0x1c,%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    
  800e76:	8d 76 00             	lea    0x0(%esi),%esi
  800e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  800e80:	31 ff                	xor    %edi,%edi
  800e82:	31 c0                	xor    %eax,%eax
  800e84:	89 fa                	mov    %edi,%edx
  800e86:	83 c4 1c             	add    $0x1c,%esp
  800e89:	5b                   	pop    %ebx
  800e8a:	5e                   	pop    %esi
  800e8b:	5f                   	pop    %edi
  800e8c:	5d                   	pop    %ebp
  800e8d:	c3                   	ret    
  800e8e:	66 90                	xchg   %ax,%ax
  800e90:	31 ff                	xor    %edi,%edi
  800e92:	89 e8                	mov    %ebp,%eax
  800e94:	89 f2                	mov    %esi,%edx
  800e96:	f7 f3                	div    %ebx
  800e98:	89 fa                	mov    %edi,%edx
  800e9a:	83 c4 1c             	add    $0x1c,%esp
  800e9d:	5b                   	pop    %ebx
  800e9e:	5e                   	pop    %esi
  800e9f:	5f                   	pop    %edi
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    
  800ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800ea8:	39 f2                	cmp    %esi,%edx
  800eaa:	72 06                	jb     800eb2 <__udivdi3+0x102>
  800eac:	31 c0                	xor    %eax,%eax
  800eae:	39 eb                	cmp    %ebp,%ebx
  800eb0:	77 d2                	ja     800e84 <__udivdi3+0xd4>
  800eb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800eb7:	eb cb                	jmp    800e84 <__udivdi3+0xd4>
  800eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ec0:	89 d8                	mov    %ebx,%eax
  800ec2:	31 ff                	xor    %edi,%edi
  800ec4:	eb be                	jmp    800e84 <__udivdi3+0xd4>
  800ec6:	66 90                	xchg   %ax,%ax
  800ec8:	66 90                	xchg   %ax,%ax
  800eca:	66 90                	xchg   %ax,%ax
  800ecc:	66 90                	xchg   %ax,%ax
  800ece:	66 90                	xchg   %ax,%ax

00800ed0 <__umoddi3>:
  800ed0:	55                   	push   %ebp
  800ed1:	57                   	push   %edi
  800ed2:	56                   	push   %esi
  800ed3:	53                   	push   %ebx
  800ed4:	83 ec 1c             	sub    $0x1c,%esp
  800ed7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  800edb:	8b 74 24 30          	mov    0x30(%esp),%esi
  800edf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  800ee3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  800ee7:	85 ed                	test   %ebp,%ebp
  800ee9:	89 f0                	mov    %esi,%eax
  800eeb:	89 da                	mov    %ebx,%edx
  800eed:	75 19                	jne    800f08 <__umoddi3+0x38>
  800eef:	39 df                	cmp    %ebx,%edi
  800ef1:	0f 86 b1 00 00 00    	jbe    800fa8 <__umoddi3+0xd8>
  800ef7:	f7 f7                	div    %edi
  800ef9:	89 d0                	mov    %edx,%eax
  800efb:	31 d2                	xor    %edx,%edx
  800efd:	83 c4 1c             	add    $0x1c,%esp
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    
  800f05:	8d 76 00             	lea    0x0(%esi),%esi
  800f08:	39 dd                	cmp    %ebx,%ebp
  800f0a:	77 f1                	ja     800efd <__umoddi3+0x2d>
  800f0c:	0f bd cd             	bsr    %ebp,%ecx
  800f0f:	83 f1 1f             	xor    $0x1f,%ecx
  800f12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f16:	0f 84 b4 00 00 00    	je     800fd0 <__umoddi3+0x100>
  800f1c:	b8 20 00 00 00       	mov    $0x20,%eax
  800f21:	89 c2                	mov    %eax,%edx
  800f23:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f27:	29 c2                	sub    %eax,%edx
  800f29:	89 c1                	mov    %eax,%ecx
  800f2b:	89 f8                	mov    %edi,%eax
  800f2d:	d3 e5                	shl    %cl,%ebp
  800f2f:	89 d1                	mov    %edx,%ecx
  800f31:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f35:	d3 e8                	shr    %cl,%eax
  800f37:	09 c5                	or     %eax,%ebp
  800f39:	8b 44 24 04          	mov    0x4(%esp),%eax
  800f3d:	89 c1                	mov    %eax,%ecx
  800f3f:	d3 e7                	shl    %cl,%edi
  800f41:	89 d1                	mov    %edx,%ecx
  800f43:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f47:	89 df                	mov    %ebx,%edi
  800f49:	d3 ef                	shr    %cl,%edi
  800f4b:	89 c1                	mov    %eax,%ecx
  800f4d:	89 f0                	mov    %esi,%eax
  800f4f:	d3 e3                	shl    %cl,%ebx
  800f51:	89 d1                	mov    %edx,%ecx
  800f53:	89 fa                	mov    %edi,%edx
  800f55:	d3 e8                	shr    %cl,%eax
  800f57:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  800f5c:	09 d8                	or     %ebx,%eax
  800f5e:	f7 f5                	div    %ebp
  800f60:	d3 e6                	shl    %cl,%esi
  800f62:	89 d1                	mov    %edx,%ecx
  800f64:	f7 64 24 08          	mull   0x8(%esp)
  800f68:	39 d1                	cmp    %edx,%ecx
  800f6a:	89 c3                	mov    %eax,%ebx
  800f6c:	89 d7                	mov    %edx,%edi
  800f6e:	72 06                	jb     800f76 <__umoddi3+0xa6>
  800f70:	75 0e                	jne    800f80 <__umoddi3+0xb0>
  800f72:	39 c6                	cmp    %eax,%esi
  800f74:	73 0a                	jae    800f80 <__umoddi3+0xb0>
  800f76:	2b 44 24 08          	sub    0x8(%esp),%eax
  800f7a:	19 ea                	sbb    %ebp,%edx
  800f7c:	89 d7                	mov    %edx,%edi
  800f7e:	89 c3                	mov    %eax,%ebx
  800f80:	89 ca                	mov    %ecx,%edx
  800f82:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  800f87:	29 de                	sub    %ebx,%esi
  800f89:	19 fa                	sbb    %edi,%edx
  800f8b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  800f8f:	89 d0                	mov    %edx,%eax
  800f91:	d3 e0                	shl    %cl,%eax
  800f93:	89 d9                	mov    %ebx,%ecx
  800f95:	d3 ee                	shr    %cl,%esi
  800f97:	d3 ea                	shr    %cl,%edx
  800f99:	09 f0                	or     %esi,%eax
  800f9b:	83 c4 1c             	add    $0x1c,%esp
  800f9e:	5b                   	pop    %ebx
  800f9f:	5e                   	pop    %esi
  800fa0:	5f                   	pop    %edi
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    
  800fa3:	90                   	nop
  800fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800fa8:	85 ff                	test   %edi,%edi
  800faa:	89 f9                	mov    %edi,%ecx
  800fac:	75 0b                	jne    800fb9 <__umoddi3+0xe9>
  800fae:	b8 01 00 00 00       	mov    $0x1,%eax
  800fb3:	31 d2                	xor    %edx,%edx
  800fb5:	f7 f7                	div    %edi
  800fb7:	89 c1                	mov    %eax,%ecx
  800fb9:	89 d8                	mov    %ebx,%eax
  800fbb:	31 d2                	xor    %edx,%edx
  800fbd:	f7 f1                	div    %ecx
  800fbf:	89 f0                	mov    %esi,%eax
  800fc1:	f7 f1                	div    %ecx
  800fc3:	e9 31 ff ff ff       	jmp    800ef9 <__umoddi3+0x29>
  800fc8:	90                   	nop
  800fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fd0:	39 dd                	cmp    %ebx,%ebp
  800fd2:	72 08                	jb     800fdc <__umoddi3+0x10c>
  800fd4:	39 f7                	cmp    %esi,%edi
  800fd6:	0f 87 21 ff ff ff    	ja     800efd <__umoddi3+0x2d>
  800fdc:	89 da                	mov    %ebx,%edx
  800fde:	89 f0                	mov    %esi,%eax
  800fe0:	29 f8                	sub    %edi,%eax
  800fe2:	19 ea                	sbb    %ebp,%edx
  800fe4:	e9 14 ff ff ff       	jmp    800efd <__umoddi3+0x2d>
