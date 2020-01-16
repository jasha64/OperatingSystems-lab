
obj/user/pingpongs.debug：     文件格式 elf32-i386


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
  80002c:	e8 d2 00 00 00       	call   800103 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 5a 10 00 00       	call   80109b <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 74                	jne    8000bc <umain+0x89>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800048:	83 ec 04             	sub    $0x4,%esp
  80004b:	6a 00                	push   $0x0
  80004d:	6a 00                	push   $0x0
  80004f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	e8 5d 10 00 00       	call   8010b5 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  800058:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  80005e:	8b 7b 48             	mov    0x48(%ebx),%edi
  800061:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800064:	a1 04 20 80 00       	mov    0x802004,%eax
  800069:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80006c:	e8 59 0b 00 00       	call   800bca <sys_getenvid>
  800071:	83 c4 08             	add    $0x8,%esp
  800074:	57                   	push   %edi
  800075:	53                   	push   %ebx
  800076:	56                   	push   %esi
  800077:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007a:	50                   	push   %eax
  80007b:	68 f0 14 80 00       	push   $0x8014f0
  800080:	e8 6b 01 00 00       	call   8001f0 <cprintf>
		if (val == 10)
  800085:	a1 04 20 80 00       	mov    0x802004,%eax
  80008a:	83 c4 20             	add    $0x20,%esp
  80008d:	83 f8 0a             	cmp    $0xa,%eax
  800090:	74 22                	je     8000b4 <umain+0x81>
			return;
		++val;
  800092:	83 c0 01             	add    $0x1,%eax
  800095:	a3 04 20 80 00       	mov    %eax,0x802004
		ipc_send(who, 0, 0, 0);
  80009a:	6a 00                	push   $0x0
  80009c:	6a 00                	push   $0x0
  80009e:	6a 00                	push   $0x0
  8000a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a3:	e8 76 10 00 00       	call   80111e <ipc_send>
		if (val == 10)
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	83 3d 04 20 80 00 0a 	cmpl   $0xa,0x802004
  8000b2:	75 94                	jne    800048 <umain+0x15>
			return;
	}

}
  8000b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  8000bc:	8b 1d 08 20 80 00    	mov    0x802008,%ebx
  8000c2:	e8 03 0b 00 00       	call   800bca <sys_getenvid>
  8000c7:	83 ec 04             	sub    $0x4,%esp
  8000ca:	53                   	push   %ebx
  8000cb:	50                   	push   %eax
  8000cc:	68 c0 14 80 00       	push   $0x8014c0
  8000d1:	e8 1a 01 00 00       	call   8001f0 <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000d6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000d9:	e8 ec 0a 00 00       	call   800bca <sys_getenvid>
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	53                   	push   %ebx
  8000e2:	50                   	push   %eax
  8000e3:	68 da 14 80 00       	push   $0x8014da
  8000e8:	e8 03 01 00 00       	call   8001f0 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ed:	6a 00                	push   $0x0
  8000ef:	6a 00                	push   $0x0
  8000f1:	6a 00                	push   $0x0
  8000f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f6:	e8 23 10 00 00       	call   80111e <ipc_send>
  8000fb:	83 c4 20             	add    $0x20,%esp
  8000fe:	e9 45 ff ff ff       	jmp    800048 <umain+0x15>

00800103 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  80010e:	e8 b7 0a 00 00       	call   800bca <sys_getenvid>
	thisenv = envs + ENVX(envid);
  800113:	25 ff 03 00 00       	and    $0x3ff,%eax
  800118:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800120:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800125:	85 db                	test   %ebx,%ebx
  800127:	7e 07                	jle    800130 <libmain+0x2d>
		binaryname = argv[0];
  800129:	8b 06                	mov    (%esi),%eax
  80012b:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800130:	83 ec 08             	sub    $0x8,%esp
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
  800135:	e8 f9 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80013a:	e8 0a 00 00 00       	call   800149 <exit>
}
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800145:	5b                   	pop    %ebx
  800146:	5e                   	pop    %esi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    

00800149 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80014f:	6a 00                	push   $0x0
  800151:	e8 33 0a 00 00       	call   800b89 <sys_env_destroy>
}
  800156:	83 c4 10             	add    $0x10,%esp
  800159:	c9                   	leave  
  80015a:	c3                   	ret    

0080015b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	53                   	push   %ebx
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800165:	8b 13                	mov    (%ebx),%edx
  800167:	8d 42 01             	lea    0x1(%edx),%eax
  80016a:	89 03                	mov    %eax,(%ebx)
  80016c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800173:	3d ff 00 00 00       	cmp    $0xff,%eax
  800178:	74 09                	je     800183 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800181:	c9                   	leave  
  800182:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	68 ff 00 00 00       	push   $0xff
  80018b:	8d 43 08             	lea    0x8(%ebx),%eax
  80018e:	50                   	push   %eax
  80018f:	e8 b8 09 00 00       	call   800b4c <sys_cputs>
		b->idx = 0;
  800194:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	eb db                	jmp    80017a <putch+0x1f>

0080019f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001af:	00 00 00 
	b.cnt = 0;
  8001b2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bc:	ff 75 0c             	pushl  0xc(%ebp)
  8001bf:	ff 75 08             	pushl  0x8(%ebp)
  8001c2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c8:	50                   	push   %eax
  8001c9:	68 5b 01 80 00       	push   $0x80015b
  8001ce:	e8 1a 01 00 00       	call   8002ed <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d3:	83 c4 08             	add    $0x8,%esp
  8001d6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001dc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e2:	50                   	push   %eax
  8001e3:	e8 64 09 00 00       	call   800b4c <sys_cputs>

	return b.cnt;
}
  8001e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ee:	c9                   	leave  
  8001ef:	c3                   	ret    

008001f0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f9:	50                   	push   %eax
  8001fa:	ff 75 08             	pushl  0x8(%ebp)
  8001fd:	e8 9d ff ff ff       	call   80019f <vcprintf>
	va_end(ap);

	return cnt;
}
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	57                   	push   %edi
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	83 ec 1c             	sub    $0x1c,%esp
  80020d:	89 c7                	mov    %eax,%edi
  80020f:	89 d6                	mov    %edx,%esi
  800211:	8b 45 08             	mov    0x8(%ebp),%eax
  800214:	8b 55 0c             	mov    0xc(%ebp),%edx
  800217:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80021d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800220:	bb 00 00 00 00       	mov    $0x0,%ebx
  800225:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800228:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80022b:	39 d3                	cmp    %edx,%ebx
  80022d:	72 05                	jb     800234 <printnum+0x30>
  80022f:	39 45 10             	cmp    %eax,0x10(%ebp)
  800232:	77 7a                	ja     8002ae <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	ff 75 18             	pushl  0x18(%ebp)
  80023a:	8b 45 14             	mov    0x14(%ebp),%eax
  80023d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800240:	53                   	push   %ebx
  800241:	ff 75 10             	pushl  0x10(%ebp)
  800244:	83 ec 08             	sub    $0x8,%esp
  800247:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024a:	ff 75 e0             	pushl  -0x20(%ebp)
  80024d:	ff 75 dc             	pushl  -0x24(%ebp)
  800250:	ff 75 d8             	pushl  -0x28(%ebp)
  800253:	e8 18 10 00 00       	call   801270 <__udivdi3>
  800258:	83 c4 18             	add    $0x18,%esp
  80025b:	52                   	push   %edx
  80025c:	50                   	push   %eax
  80025d:	89 f2                	mov    %esi,%edx
  80025f:	89 f8                	mov    %edi,%eax
  800261:	e8 9e ff ff ff       	call   800204 <printnum>
  800266:	83 c4 20             	add    $0x20,%esp
  800269:	eb 13                	jmp    80027e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	56                   	push   %esi
  80026f:	ff 75 18             	pushl  0x18(%ebp)
  800272:	ff d7                	call   *%edi
  800274:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800277:	83 eb 01             	sub    $0x1,%ebx
  80027a:	85 db                	test   %ebx,%ebx
  80027c:	7f ed                	jg     80026b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80027e:	83 ec 08             	sub    $0x8,%esp
  800281:	56                   	push   %esi
  800282:	83 ec 04             	sub    $0x4,%esp
  800285:	ff 75 e4             	pushl  -0x1c(%ebp)
  800288:	ff 75 e0             	pushl  -0x20(%ebp)
  80028b:	ff 75 dc             	pushl  -0x24(%ebp)
  80028e:	ff 75 d8             	pushl  -0x28(%ebp)
  800291:	e8 fa 10 00 00       	call   801390 <__umoddi3>
  800296:	83 c4 14             	add    $0x14,%esp
  800299:	0f be 80 20 15 80 00 	movsbl 0x801520(%eax),%eax
  8002a0:	50                   	push   %eax
  8002a1:	ff d7                	call   *%edi
}
  8002a3:	83 c4 10             	add    $0x10,%esp
  8002a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a9:	5b                   	pop    %ebx
  8002aa:	5e                   	pop    %esi
  8002ab:	5f                   	pop    %edi
  8002ac:	5d                   	pop    %ebp
  8002ad:	c3                   	ret    
  8002ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002b1:	eb c4                	jmp    800277 <printnum+0x73>

008002b3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002bd:	8b 10                	mov    (%eax),%edx
  8002bf:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c2:	73 0a                	jae    8002ce <sprintputch+0x1b>
		*b->buf++ = ch;
  8002c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002c7:	89 08                	mov    %ecx,(%eax)
  8002c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cc:	88 02                	mov    %al,(%edx)
}
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    

008002d0 <printfmt>:
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002d6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002d9:	50                   	push   %eax
  8002da:	ff 75 10             	pushl  0x10(%ebp)
  8002dd:	ff 75 0c             	pushl  0xc(%ebp)
  8002e0:	ff 75 08             	pushl  0x8(%ebp)
  8002e3:	e8 05 00 00 00       	call   8002ed <vprintfmt>
}
  8002e8:	83 c4 10             	add    $0x10,%esp
  8002eb:	c9                   	leave  
  8002ec:	c3                   	ret    

008002ed <vprintfmt>:
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	57                   	push   %edi
  8002f1:	56                   	push   %esi
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 2c             	sub    $0x2c,%esp
  8002f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8002f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002fc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ff:	e9 c1 03 00 00       	jmp    8006c5 <vprintfmt+0x3d8>
		padc = ' ';
  800304:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800308:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80030f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800316:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80031d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800322:	8d 47 01             	lea    0x1(%edi),%eax
  800325:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800328:	0f b6 17             	movzbl (%edi),%edx
  80032b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80032e:	3c 55                	cmp    $0x55,%al
  800330:	0f 87 12 04 00 00    	ja     800748 <vprintfmt+0x45b>
  800336:	0f b6 c0             	movzbl %al,%eax
  800339:	ff 24 85 60 16 80 00 	jmp    *0x801660(,%eax,4)
  800340:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800343:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800347:	eb d9                	jmp    800322 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800349:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80034c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800350:	eb d0                	jmp    800322 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800352:	0f b6 d2             	movzbl %dl,%edx
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800358:	b8 00 00 00 00       	mov    $0x0,%eax
  80035d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800360:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800363:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800367:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80036a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80036d:	83 f9 09             	cmp    $0x9,%ecx
  800370:	77 55                	ja     8003c7 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800372:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800375:	eb e9                	jmp    800360 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800377:	8b 45 14             	mov    0x14(%ebp),%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80037f:	8b 45 14             	mov    0x14(%ebp),%eax
  800382:	8d 40 04             	lea    0x4(%eax),%eax
  800385:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80038b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80038f:	79 91                	jns    800322 <vprintfmt+0x35>
				width = precision, precision = -1;
  800391:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800394:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800397:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80039e:	eb 82                	jmp    800322 <vprintfmt+0x35>
  8003a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a3:	85 c0                	test   %eax,%eax
  8003a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003aa:	0f 49 d0             	cmovns %eax,%edx
  8003ad:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b3:	e9 6a ff ff ff       	jmp    800322 <vprintfmt+0x35>
  8003b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003bb:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003c2:	e9 5b ff ff ff       	jmp    800322 <vprintfmt+0x35>
  8003c7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ca:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003cd:	eb bc                	jmp    80038b <vprintfmt+0x9e>
			lflag++;
  8003cf:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d5:	e9 48 ff ff ff       	jmp    800322 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003da:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dd:	8d 78 04             	lea    0x4(%eax),%edi
  8003e0:	83 ec 08             	sub    $0x8,%esp
  8003e3:	53                   	push   %ebx
  8003e4:	ff 30                	pushl  (%eax)
  8003e6:	ff d6                	call   *%esi
			break;
  8003e8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003eb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ee:	e9 cf 02 00 00       	jmp    8006c2 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8003f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f6:	8d 78 04             	lea    0x4(%eax),%edi
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	99                   	cltd   
  8003fc:	31 d0                	xor    %edx,%eax
  8003fe:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800400:	83 f8 0f             	cmp    $0xf,%eax
  800403:	7f 23                	jg     800428 <vprintfmt+0x13b>
  800405:	8b 14 85 c0 17 80 00 	mov    0x8017c0(,%eax,4),%edx
  80040c:	85 d2                	test   %edx,%edx
  80040e:	74 18                	je     800428 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800410:	52                   	push   %edx
  800411:	68 41 15 80 00       	push   $0x801541
  800416:	53                   	push   %ebx
  800417:	56                   	push   %esi
  800418:	e8 b3 fe ff ff       	call   8002d0 <printfmt>
  80041d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800420:	89 7d 14             	mov    %edi,0x14(%ebp)
  800423:	e9 9a 02 00 00       	jmp    8006c2 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800428:	50                   	push   %eax
  800429:	68 38 15 80 00       	push   $0x801538
  80042e:	53                   	push   %ebx
  80042f:	56                   	push   %esi
  800430:	e8 9b fe ff ff       	call   8002d0 <printfmt>
  800435:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800438:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80043b:	e9 82 02 00 00       	jmp    8006c2 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800440:	8b 45 14             	mov    0x14(%ebp),%eax
  800443:	83 c0 04             	add    $0x4,%eax
  800446:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800449:	8b 45 14             	mov    0x14(%ebp),%eax
  80044c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80044e:	85 ff                	test   %edi,%edi
  800450:	b8 31 15 80 00       	mov    $0x801531,%eax
  800455:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800458:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045c:	0f 8e bd 00 00 00    	jle    80051f <vprintfmt+0x232>
  800462:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800466:	75 0e                	jne    800476 <vprintfmt+0x189>
  800468:	89 75 08             	mov    %esi,0x8(%ebp)
  80046b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80046e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800471:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800474:	eb 6d                	jmp    8004e3 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	ff 75 d0             	pushl  -0x30(%ebp)
  80047c:	57                   	push   %edi
  80047d:	e8 6e 03 00 00       	call   8007f0 <strnlen>
  800482:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800485:	29 c1                	sub    %eax,%ecx
  800487:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80048a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80048d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800491:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800494:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800497:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800499:	eb 0f                	jmp    8004aa <vprintfmt+0x1bd>
					putch(padc, putdat);
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	53                   	push   %ebx
  80049f:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a4:	83 ef 01             	sub    $0x1,%edi
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	85 ff                	test   %edi,%edi
  8004ac:	7f ed                	jg     80049b <vprintfmt+0x1ae>
  8004ae:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004b1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004b4:	85 c9                	test   %ecx,%ecx
  8004b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bb:	0f 49 c1             	cmovns %ecx,%eax
  8004be:	29 c1                	sub    %eax,%ecx
  8004c0:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004c6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004c9:	89 cb                	mov    %ecx,%ebx
  8004cb:	eb 16                	jmp    8004e3 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004cd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d1:	75 31                	jne    800504 <vprintfmt+0x217>
					putch(ch, putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	50                   	push   %eax
  8004da:	ff 55 08             	call   *0x8(%ebp)
  8004dd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004e0:	83 eb 01             	sub    $0x1,%ebx
  8004e3:	83 c7 01             	add    $0x1,%edi
  8004e6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004ea:	0f be c2             	movsbl %dl,%eax
  8004ed:	85 c0                	test   %eax,%eax
  8004ef:	74 59                	je     80054a <vprintfmt+0x25d>
  8004f1:	85 f6                	test   %esi,%esi
  8004f3:	78 d8                	js     8004cd <vprintfmt+0x1e0>
  8004f5:	83 ee 01             	sub    $0x1,%esi
  8004f8:	79 d3                	jns    8004cd <vprintfmt+0x1e0>
  8004fa:	89 df                	mov    %ebx,%edi
  8004fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800502:	eb 37                	jmp    80053b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800504:	0f be d2             	movsbl %dl,%edx
  800507:	83 ea 20             	sub    $0x20,%edx
  80050a:	83 fa 5e             	cmp    $0x5e,%edx
  80050d:	76 c4                	jbe    8004d3 <vprintfmt+0x1e6>
					putch('?', putdat);
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	ff 75 0c             	pushl  0xc(%ebp)
  800515:	6a 3f                	push   $0x3f
  800517:	ff 55 08             	call   *0x8(%ebp)
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	eb c1                	jmp    8004e0 <vprintfmt+0x1f3>
  80051f:	89 75 08             	mov    %esi,0x8(%ebp)
  800522:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800525:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800528:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80052b:	eb b6                	jmp    8004e3 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	53                   	push   %ebx
  800531:	6a 20                	push   $0x20
  800533:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800535:	83 ef 01             	sub    $0x1,%edi
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	85 ff                	test   %edi,%edi
  80053d:	7f ee                	jg     80052d <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80053f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800542:	89 45 14             	mov    %eax,0x14(%ebp)
  800545:	e9 78 01 00 00       	jmp    8006c2 <vprintfmt+0x3d5>
  80054a:	89 df                	mov    %ebx,%edi
  80054c:	8b 75 08             	mov    0x8(%ebp),%esi
  80054f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800552:	eb e7                	jmp    80053b <vprintfmt+0x24e>
	if (lflag >= 2)
  800554:	83 f9 01             	cmp    $0x1,%ecx
  800557:	7e 3f                	jle    800598 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8b 50 04             	mov    0x4(%eax),%edx
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800564:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 08             	lea    0x8(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800570:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800574:	79 5c                	jns    8005d2 <vprintfmt+0x2e5>
				putch('-', putdat);
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	53                   	push   %ebx
  80057a:	6a 2d                	push   $0x2d
  80057c:	ff d6                	call   *%esi
				num = -(long long) num;
  80057e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800581:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800584:	f7 da                	neg    %edx
  800586:	83 d1 00             	adc    $0x0,%ecx
  800589:	f7 d9                	neg    %ecx
  80058b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80058e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800593:	e9 10 01 00 00       	jmp    8006a8 <vprintfmt+0x3bb>
	else if (lflag)
  800598:	85 c9                	test   %ecx,%ecx
  80059a:	75 1b                	jne    8005b7 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	89 c1                	mov    %eax,%ecx
  8005a6:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8005af:	8d 40 04             	lea    0x4(%eax),%eax
  8005b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b5:	eb b9                	jmp    800570 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bf:	89 c1                	mov    %eax,%ecx
  8005c1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 40 04             	lea    0x4(%eax),%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d0:	eb 9e                	jmp    800570 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005dd:	e9 c6 00 00 00       	jmp    8006a8 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005e2:	83 f9 01             	cmp    $0x1,%ecx
  8005e5:	7e 18                	jle    8005ff <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8b 10                	mov    (%eax),%edx
  8005ec:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ef:	8d 40 08             	lea    0x8(%eax),%eax
  8005f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fa:	e9 a9 00 00 00       	jmp    8006a8 <vprintfmt+0x3bb>
	else if (lflag)
  8005ff:	85 c9                	test   %ecx,%ecx
  800601:	75 1a                	jne    80061d <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8b 10                	mov    (%eax),%edx
  800608:	b9 00 00 00 00       	mov    $0x0,%ecx
  80060d:	8d 40 04             	lea    0x4(%eax),%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800613:	b8 0a 00 00 00       	mov    $0xa,%eax
  800618:	e9 8b 00 00 00       	jmp    8006a8 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8b 10                	mov    (%eax),%edx
  800622:	b9 00 00 00 00       	mov    $0x0,%ecx
  800627:	8d 40 04             	lea    0x4(%eax),%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800632:	eb 74                	jmp    8006a8 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800634:	83 f9 01             	cmp    $0x1,%ecx
  800637:	7e 15                	jle    80064e <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 10                	mov    (%eax),%edx
  80063e:	8b 48 04             	mov    0x4(%eax),%ecx
  800641:	8d 40 08             	lea    0x8(%eax),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800647:	b8 08 00 00 00       	mov    $0x8,%eax
  80064c:	eb 5a                	jmp    8006a8 <vprintfmt+0x3bb>
	else if (lflag)
  80064e:	85 c9                	test   %ecx,%ecx
  800650:	75 17                	jne    800669 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8b 10                	mov    (%eax),%edx
  800657:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065c:	8d 40 04             	lea    0x4(%eax),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800662:	b8 08 00 00 00       	mov    $0x8,%eax
  800667:	eb 3f                	jmp    8006a8 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8b 10                	mov    (%eax),%edx
  80066e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800673:	8d 40 04             	lea    0x4(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800679:	b8 08 00 00 00       	mov    $0x8,%eax
  80067e:	eb 28                	jmp    8006a8 <vprintfmt+0x3bb>
			putch('0', putdat);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	53                   	push   %ebx
  800684:	6a 30                	push   $0x30
  800686:	ff d6                	call   *%esi
			putch('x', putdat);
  800688:	83 c4 08             	add    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 78                	push   $0x78
  80068e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 10                	mov    (%eax),%edx
  800695:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80069a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80069d:	8d 40 04             	lea    0x4(%eax),%eax
  8006a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006a8:	83 ec 0c             	sub    $0xc,%esp
  8006ab:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006af:	57                   	push   %edi
  8006b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b3:	50                   	push   %eax
  8006b4:	51                   	push   %ecx
  8006b5:	52                   	push   %edx
  8006b6:	89 da                	mov    %ebx,%edx
  8006b8:	89 f0                	mov    %esi,%eax
  8006ba:	e8 45 fb ff ff       	call   800204 <printnum>
			break;
  8006bf:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  8006c5:	83 c7 01             	add    $0x1,%edi
  8006c8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006cc:	83 f8 25             	cmp    $0x25,%eax
  8006cf:	0f 84 2f fc ff ff    	je     800304 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  8006d5:	85 c0                	test   %eax,%eax
  8006d7:	0f 84 8b 00 00 00    	je     800768 <vprintfmt+0x47b>
			putch(ch, putdat);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	53                   	push   %ebx
  8006e1:	50                   	push   %eax
  8006e2:	ff d6                	call   *%esi
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	eb dc                	jmp    8006c5 <vprintfmt+0x3d8>
	if (lflag >= 2)
  8006e9:	83 f9 01             	cmp    $0x1,%ecx
  8006ec:	7e 15                	jle    800703 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8b 10                	mov    (%eax),%edx
  8006f3:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f6:	8d 40 08             	lea    0x8(%eax),%eax
  8006f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fc:	b8 10 00 00 00       	mov    $0x10,%eax
  800701:	eb a5                	jmp    8006a8 <vprintfmt+0x3bb>
	else if (lflag)
  800703:	85 c9                	test   %ecx,%ecx
  800705:	75 17                	jne    80071e <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 10                	mov    (%eax),%edx
  80070c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800711:	8d 40 04             	lea    0x4(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800717:	b8 10 00 00 00       	mov    $0x10,%eax
  80071c:	eb 8a                	jmp    8006a8 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8b 10                	mov    (%eax),%edx
  800723:	b9 00 00 00 00       	mov    $0x0,%ecx
  800728:	8d 40 04             	lea    0x4(%eax),%eax
  80072b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072e:	b8 10 00 00 00       	mov    $0x10,%eax
  800733:	e9 70 ff ff ff       	jmp    8006a8 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	53                   	push   %ebx
  80073c:	6a 25                	push   $0x25
  80073e:	ff d6                	call   *%esi
			break;
  800740:	83 c4 10             	add    $0x10,%esp
  800743:	e9 7a ff ff ff       	jmp    8006c2 <vprintfmt+0x3d5>
			putch('%', putdat);
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	53                   	push   %ebx
  80074c:	6a 25                	push   $0x25
  80074e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800750:	83 c4 10             	add    $0x10,%esp
  800753:	89 f8                	mov    %edi,%eax
  800755:	eb 03                	jmp    80075a <vprintfmt+0x46d>
  800757:	83 e8 01             	sub    $0x1,%eax
  80075a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80075e:	75 f7                	jne    800757 <vprintfmt+0x46a>
  800760:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800763:	e9 5a ff ff ff       	jmp    8006c2 <vprintfmt+0x3d5>
}
  800768:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80076b:	5b                   	pop    %ebx
  80076c:	5e                   	pop    %esi
  80076d:	5f                   	pop    %edi
  80076e:	5d                   	pop    %ebp
  80076f:	c3                   	ret    

00800770 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800770:	55                   	push   %ebp
  800771:	89 e5                	mov    %esp,%ebp
  800773:	83 ec 18             	sub    $0x18,%esp
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80077c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80077f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800783:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800786:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80078d:	85 c0                	test   %eax,%eax
  80078f:	74 26                	je     8007b7 <vsnprintf+0x47>
  800791:	85 d2                	test   %edx,%edx
  800793:	7e 22                	jle    8007b7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800795:	ff 75 14             	pushl  0x14(%ebp)
  800798:	ff 75 10             	pushl  0x10(%ebp)
  80079b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80079e:	50                   	push   %eax
  80079f:	68 b3 02 80 00       	push   $0x8002b3
  8007a4:	e8 44 fb ff ff       	call   8002ed <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b2:	83 c4 10             	add    $0x10,%esp
}
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    
		return -E_INVAL;
  8007b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007bc:	eb f7                	jmp    8007b5 <vsnprintf+0x45>

008007be <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007be:	55                   	push   %ebp
  8007bf:	89 e5                	mov    %esp,%ebp
  8007c1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c7:	50                   	push   %eax
  8007c8:	ff 75 10             	pushl  0x10(%ebp)
  8007cb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ce:	ff 75 08             	pushl  0x8(%ebp)
  8007d1:	e8 9a ff ff ff       	call   800770 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d6:	c9                   	leave  
  8007d7:	c3                   	ret    

008007d8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007de:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e3:	eb 03                	jmp    8007e8 <strlen+0x10>
		n++;
  8007e5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007e8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007ec:	75 f7                	jne    8007e5 <strlen+0xd>
	return n;
}
  8007ee:	5d                   	pop    %ebp
  8007ef:	c3                   	ret    

008007f0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fe:	eb 03                	jmp    800803 <strnlen+0x13>
		n++;
  800800:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800803:	39 d0                	cmp    %edx,%eax
  800805:	74 06                	je     80080d <strnlen+0x1d>
  800807:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80080b:	75 f3                	jne    800800 <strnlen+0x10>
	return n;
}
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	53                   	push   %ebx
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800819:	89 c2                	mov    %eax,%edx
  80081b:	83 c1 01             	add    $0x1,%ecx
  80081e:	83 c2 01             	add    $0x1,%edx
  800821:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800825:	88 5a ff             	mov    %bl,-0x1(%edx)
  800828:	84 db                	test   %bl,%bl
  80082a:	75 ef                	jne    80081b <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80082c:	5b                   	pop    %ebx
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	53                   	push   %ebx
  800833:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800836:	53                   	push   %ebx
  800837:	e8 9c ff ff ff       	call   8007d8 <strlen>
  80083c:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	01 d8                	add    %ebx,%eax
  800844:	50                   	push   %eax
  800845:	e8 c5 ff ff ff       	call   80080f <strcpy>
	return dst;
}
  80084a:	89 d8                	mov    %ebx,%eax
  80084c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	56                   	push   %esi
  800855:	53                   	push   %ebx
  800856:	8b 75 08             	mov    0x8(%ebp),%esi
  800859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085c:	89 f3                	mov    %esi,%ebx
  80085e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800861:	89 f2                	mov    %esi,%edx
  800863:	eb 0f                	jmp    800874 <strncpy+0x23>
		*dst++ = *src;
  800865:	83 c2 01             	add    $0x1,%edx
  800868:	0f b6 01             	movzbl (%ecx),%eax
  80086b:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80086e:	80 39 01             	cmpb   $0x1,(%ecx)
  800871:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800874:	39 da                	cmp    %ebx,%edx
  800876:	75 ed                	jne    800865 <strncpy+0x14>
	}
	return ret;
}
  800878:	89 f0                	mov    %esi,%eax
  80087a:	5b                   	pop    %ebx
  80087b:	5e                   	pop    %esi
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	56                   	push   %esi
  800882:	53                   	push   %ebx
  800883:	8b 75 08             	mov    0x8(%ebp),%esi
  800886:	8b 55 0c             	mov    0xc(%ebp),%edx
  800889:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80088c:	89 f0                	mov    %esi,%eax
  80088e:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800892:	85 c9                	test   %ecx,%ecx
  800894:	75 0b                	jne    8008a1 <strlcpy+0x23>
  800896:	eb 17                	jmp    8008af <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800898:	83 c2 01             	add    $0x1,%edx
  80089b:	83 c0 01             	add    $0x1,%eax
  80089e:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008a1:	39 d8                	cmp    %ebx,%eax
  8008a3:	74 07                	je     8008ac <strlcpy+0x2e>
  8008a5:	0f b6 0a             	movzbl (%edx),%ecx
  8008a8:	84 c9                	test   %cl,%cl
  8008aa:	75 ec                	jne    800898 <strlcpy+0x1a>
		*dst = '\0';
  8008ac:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008af:	29 f0                	sub    %esi,%eax
}
  8008b1:	5b                   	pop    %ebx
  8008b2:	5e                   	pop    %esi
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008be:	eb 06                	jmp    8008c6 <strcmp+0x11>
		p++, q++;
  8008c0:	83 c1 01             	add    $0x1,%ecx
  8008c3:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008c6:	0f b6 01             	movzbl (%ecx),%eax
  8008c9:	84 c0                	test   %al,%al
  8008cb:	74 04                	je     8008d1 <strcmp+0x1c>
  8008cd:	3a 02                	cmp    (%edx),%al
  8008cf:	74 ef                	je     8008c0 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d1:	0f b6 c0             	movzbl %al,%eax
  8008d4:	0f b6 12             	movzbl (%edx),%edx
  8008d7:	29 d0                	sub    %edx,%eax
}
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	53                   	push   %ebx
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e5:	89 c3                	mov    %eax,%ebx
  8008e7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008ea:	eb 06                	jmp    8008f2 <strncmp+0x17>
		n--, p++, q++;
  8008ec:	83 c0 01             	add    $0x1,%eax
  8008ef:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008f2:	39 d8                	cmp    %ebx,%eax
  8008f4:	74 16                	je     80090c <strncmp+0x31>
  8008f6:	0f b6 08             	movzbl (%eax),%ecx
  8008f9:	84 c9                	test   %cl,%cl
  8008fb:	74 04                	je     800901 <strncmp+0x26>
  8008fd:	3a 0a                	cmp    (%edx),%cl
  8008ff:	74 eb                	je     8008ec <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800901:	0f b6 00             	movzbl (%eax),%eax
  800904:	0f b6 12             	movzbl (%edx),%edx
  800907:	29 d0                	sub    %edx,%eax
}
  800909:	5b                   	pop    %ebx
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    
		return 0;
  80090c:	b8 00 00 00 00       	mov    $0x0,%eax
  800911:	eb f6                	jmp    800909 <strncmp+0x2e>

00800913 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80091d:	0f b6 10             	movzbl (%eax),%edx
  800920:	84 d2                	test   %dl,%dl
  800922:	74 09                	je     80092d <strchr+0x1a>
		if (*s == c)
  800924:	38 ca                	cmp    %cl,%dl
  800926:	74 0a                	je     800932 <strchr+0x1f>
	for (; *s; s++)
  800928:	83 c0 01             	add    $0x1,%eax
  80092b:	eb f0                	jmp    80091d <strchr+0xa>
			return (char *) s;
	return 0;
  80092d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80093e:	eb 03                	jmp    800943 <strfind+0xf>
  800940:	83 c0 01             	add    $0x1,%eax
  800943:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800946:	38 ca                	cmp    %cl,%dl
  800948:	74 04                	je     80094e <strfind+0x1a>
  80094a:	84 d2                	test   %dl,%dl
  80094c:	75 f2                	jne    800940 <strfind+0xc>
			break;
	return (char *) s;
}
  80094e:	5d                   	pop    %ebp
  80094f:	c3                   	ret    

00800950 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	57                   	push   %edi
  800954:	56                   	push   %esi
  800955:	53                   	push   %ebx
  800956:	8b 7d 08             	mov    0x8(%ebp),%edi
  800959:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80095c:	85 c9                	test   %ecx,%ecx
  80095e:	74 13                	je     800973 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800960:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800966:	75 05                	jne    80096d <memset+0x1d>
  800968:	f6 c1 03             	test   $0x3,%cl
  80096b:	74 0d                	je     80097a <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80096d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800970:	fc                   	cld    
  800971:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800973:	89 f8                	mov    %edi,%eax
  800975:	5b                   	pop    %ebx
  800976:	5e                   	pop    %esi
  800977:	5f                   	pop    %edi
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    
		c &= 0xFF;
  80097a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80097e:	89 d3                	mov    %edx,%ebx
  800980:	c1 e3 08             	shl    $0x8,%ebx
  800983:	89 d0                	mov    %edx,%eax
  800985:	c1 e0 18             	shl    $0x18,%eax
  800988:	89 d6                	mov    %edx,%esi
  80098a:	c1 e6 10             	shl    $0x10,%esi
  80098d:	09 f0                	or     %esi,%eax
  80098f:	09 c2                	or     %eax,%edx
  800991:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800993:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800996:	89 d0                	mov    %edx,%eax
  800998:	fc                   	cld    
  800999:	f3 ab                	rep stos %eax,%es:(%edi)
  80099b:	eb d6                	jmp    800973 <memset+0x23>

0080099d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	57                   	push   %edi
  8009a1:	56                   	push   %esi
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009ab:	39 c6                	cmp    %eax,%esi
  8009ad:	73 35                	jae    8009e4 <memmove+0x47>
  8009af:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009b2:	39 c2                	cmp    %eax,%edx
  8009b4:	76 2e                	jbe    8009e4 <memmove+0x47>
		s += n;
		d += n;
  8009b6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b9:	89 d6                	mov    %edx,%esi
  8009bb:	09 fe                	or     %edi,%esi
  8009bd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009c3:	74 0c                	je     8009d1 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009c5:	83 ef 01             	sub    $0x1,%edi
  8009c8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009cb:	fd                   	std    
  8009cc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009ce:	fc                   	cld    
  8009cf:	eb 21                	jmp    8009f2 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d1:	f6 c1 03             	test   $0x3,%cl
  8009d4:	75 ef                	jne    8009c5 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009d6:	83 ef 04             	sub    $0x4,%edi
  8009d9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009dc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009df:	fd                   	std    
  8009e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e2:	eb ea                	jmp    8009ce <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e4:	89 f2                	mov    %esi,%edx
  8009e6:	09 c2                	or     %eax,%edx
  8009e8:	f6 c2 03             	test   $0x3,%dl
  8009eb:	74 09                	je     8009f6 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009ed:	89 c7                	mov    %eax,%edi
  8009ef:	fc                   	cld    
  8009f0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009f2:	5e                   	pop    %esi
  8009f3:	5f                   	pop    %edi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f6:	f6 c1 03             	test   $0x3,%cl
  8009f9:	75 f2                	jne    8009ed <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009fb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009fe:	89 c7                	mov    %eax,%edi
  800a00:	fc                   	cld    
  800a01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a03:	eb ed                	jmp    8009f2 <memmove+0x55>

00800a05 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a08:	ff 75 10             	pushl  0x10(%ebp)
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	ff 75 08             	pushl  0x8(%ebp)
  800a11:	e8 87 ff ff ff       	call   80099d <memmove>
}
  800a16:	c9                   	leave  
  800a17:	c3                   	ret    

00800a18 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	56                   	push   %esi
  800a1c:	53                   	push   %ebx
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a23:	89 c6                	mov    %eax,%esi
  800a25:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a28:	39 f0                	cmp    %esi,%eax
  800a2a:	74 1c                	je     800a48 <memcmp+0x30>
		if (*s1 != *s2)
  800a2c:	0f b6 08             	movzbl (%eax),%ecx
  800a2f:	0f b6 1a             	movzbl (%edx),%ebx
  800a32:	38 d9                	cmp    %bl,%cl
  800a34:	75 08                	jne    800a3e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a36:	83 c0 01             	add    $0x1,%eax
  800a39:	83 c2 01             	add    $0x1,%edx
  800a3c:	eb ea                	jmp    800a28 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a3e:	0f b6 c1             	movzbl %cl,%eax
  800a41:	0f b6 db             	movzbl %bl,%ebx
  800a44:	29 d8                	sub    %ebx,%eax
  800a46:	eb 05                	jmp    800a4d <memcmp+0x35>
	}

	return 0;
  800a48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4d:	5b                   	pop    %ebx
  800a4e:	5e                   	pop    %esi
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a5a:	89 c2                	mov    %eax,%edx
  800a5c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a5f:	39 d0                	cmp    %edx,%eax
  800a61:	73 09                	jae    800a6c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a63:	38 08                	cmp    %cl,(%eax)
  800a65:	74 05                	je     800a6c <memfind+0x1b>
	for (; s < ends; s++)
  800a67:	83 c0 01             	add    $0x1,%eax
  800a6a:	eb f3                	jmp    800a5f <memfind+0xe>
			break;
	return (void *) s;
}
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    

00800a6e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	57                   	push   %edi
  800a72:	56                   	push   %esi
  800a73:	53                   	push   %ebx
  800a74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a77:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a7a:	eb 03                	jmp    800a7f <strtol+0x11>
		s++;
  800a7c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a7f:	0f b6 01             	movzbl (%ecx),%eax
  800a82:	3c 20                	cmp    $0x20,%al
  800a84:	74 f6                	je     800a7c <strtol+0xe>
  800a86:	3c 09                	cmp    $0x9,%al
  800a88:	74 f2                	je     800a7c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a8a:	3c 2b                	cmp    $0x2b,%al
  800a8c:	74 2e                	je     800abc <strtol+0x4e>
	int neg = 0;
  800a8e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a93:	3c 2d                	cmp    $0x2d,%al
  800a95:	74 2f                	je     800ac6 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a97:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a9d:	75 05                	jne    800aa4 <strtol+0x36>
  800a9f:	80 39 30             	cmpb   $0x30,(%ecx)
  800aa2:	74 2c                	je     800ad0 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aa4:	85 db                	test   %ebx,%ebx
  800aa6:	75 0a                	jne    800ab2 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa8:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800aad:	80 39 30             	cmpb   $0x30,(%ecx)
  800ab0:	74 28                	je     800ada <strtol+0x6c>
		base = 10;
  800ab2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aba:	eb 50                	jmp    800b0c <strtol+0x9e>
		s++;
  800abc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800abf:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac4:	eb d1                	jmp    800a97 <strtol+0x29>
		s++, neg = 1;
  800ac6:	83 c1 01             	add    $0x1,%ecx
  800ac9:	bf 01 00 00 00       	mov    $0x1,%edi
  800ace:	eb c7                	jmp    800a97 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ad4:	74 0e                	je     800ae4 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ad6:	85 db                	test   %ebx,%ebx
  800ad8:	75 d8                	jne    800ab2 <strtol+0x44>
		s++, base = 8;
  800ada:	83 c1 01             	add    $0x1,%ecx
  800add:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ae2:	eb ce                	jmp    800ab2 <strtol+0x44>
		s += 2, base = 16;
  800ae4:	83 c1 02             	add    $0x2,%ecx
  800ae7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aec:	eb c4                	jmp    800ab2 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800aee:	8d 72 9f             	lea    -0x61(%edx),%esi
  800af1:	89 f3                	mov    %esi,%ebx
  800af3:	80 fb 19             	cmp    $0x19,%bl
  800af6:	77 29                	ja     800b21 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800af8:	0f be d2             	movsbl %dl,%edx
  800afb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800afe:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b01:	7d 30                	jge    800b33 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b03:	83 c1 01             	add    $0x1,%ecx
  800b06:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b0a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b0c:	0f b6 11             	movzbl (%ecx),%edx
  800b0f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b12:	89 f3                	mov    %esi,%ebx
  800b14:	80 fb 09             	cmp    $0x9,%bl
  800b17:	77 d5                	ja     800aee <strtol+0x80>
			dig = *s - '0';
  800b19:	0f be d2             	movsbl %dl,%edx
  800b1c:	83 ea 30             	sub    $0x30,%edx
  800b1f:	eb dd                	jmp    800afe <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b21:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b24:	89 f3                	mov    %esi,%ebx
  800b26:	80 fb 19             	cmp    $0x19,%bl
  800b29:	77 08                	ja     800b33 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b2b:	0f be d2             	movsbl %dl,%edx
  800b2e:	83 ea 37             	sub    $0x37,%edx
  800b31:	eb cb                	jmp    800afe <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b37:	74 05                	je     800b3e <strtol+0xd0>
		*endptr = (char *) s;
  800b39:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b3e:	89 c2                	mov    %eax,%edx
  800b40:	f7 da                	neg    %edx
  800b42:	85 ff                	test   %edi,%edi
  800b44:	0f 45 c2             	cmovne %edx,%eax
}
  800b47:	5b                   	pop    %ebx
  800b48:	5e                   	pop    %esi
  800b49:	5f                   	pop    %edi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	56                   	push   %esi
  800b51:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b52:	b8 00 00 00 00       	mov    $0x0,%eax
  800b57:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5d:	89 c3                	mov    %eax,%ebx
  800b5f:	89 c7                	mov    %eax,%edi
  800b61:	89 c6                	mov    %eax,%esi
  800b63:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b65:	5b                   	pop    %ebx
  800b66:	5e                   	pop    %esi
  800b67:	5f                   	pop    %edi
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <sys_cgetc>:

int
sys_cgetc(void)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	57                   	push   %edi
  800b6e:	56                   	push   %esi
  800b6f:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b70:	ba 00 00 00 00       	mov    $0x0,%edx
  800b75:	b8 01 00 00 00       	mov    $0x1,%eax
  800b7a:	89 d1                	mov    %edx,%ecx
  800b7c:	89 d3                	mov    %edx,%ebx
  800b7e:	89 d7                	mov    %edx,%edi
  800b80:	89 d6                	mov    %edx,%esi
  800b82:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b84:	5b                   	pop    %ebx
  800b85:	5e                   	pop    %esi
  800b86:	5f                   	pop    %edi
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	57                   	push   %edi
  800b8d:	56                   	push   %esi
  800b8e:	53                   	push   %ebx
  800b8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b97:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9a:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9f:	89 cb                	mov    %ecx,%ebx
  800ba1:	89 cf                	mov    %ecx,%edi
  800ba3:	89 ce                	mov    %ecx,%esi
  800ba5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba7:	85 c0                	test   %eax,%eax
  800ba9:	7f 08                	jg     800bb3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bae:	5b                   	pop    %ebx
  800baf:	5e                   	pop    %esi
  800bb0:	5f                   	pop    %edi
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb3:	83 ec 0c             	sub    $0xc,%esp
  800bb6:	50                   	push   %eax
  800bb7:	6a 03                	push   $0x3
  800bb9:	68 1f 18 80 00       	push   $0x80181f
  800bbe:	6a 23                	push   $0x23
  800bc0:	68 3c 18 80 00       	push   $0x80183c
  800bc5:	e8 e1 05 00 00       	call   8011ab <_panic>

00800bca <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	57                   	push   %edi
  800bce:	56                   	push   %esi
  800bcf:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd5:	b8 02 00 00 00       	mov    $0x2,%eax
  800bda:	89 d1                	mov    %edx,%ecx
  800bdc:	89 d3                	mov    %edx,%ebx
  800bde:	89 d7                	mov    %edx,%edi
  800be0:	89 d6                	mov    %edx,%esi
  800be2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <sys_yield>:

void
sys_yield(void)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bef:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bf9:	89 d1                	mov    %edx,%ecx
  800bfb:	89 d3                	mov    %edx,%ebx
  800bfd:	89 d7                	mov    %edx,%edi
  800bff:	89 d6                	mov    %edx,%esi
  800c01:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c03:	5b                   	pop    %ebx
  800c04:	5e                   	pop    %esi
  800c05:	5f                   	pop    %edi
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    

00800c08 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	57                   	push   %edi
  800c0c:	56                   	push   %esi
  800c0d:	53                   	push   %ebx
  800c0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c11:	be 00 00 00 00       	mov    $0x0,%esi
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1c:	b8 04 00 00 00       	mov    $0x4,%eax
  800c21:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c24:	89 f7                	mov    %esi,%edi
  800c26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	7f 08                	jg     800c34 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800c38:	6a 04                	push   $0x4
  800c3a:	68 1f 18 80 00       	push   $0x80181f
  800c3f:	6a 23                	push   $0x23
  800c41:	68 3c 18 80 00       	push   $0x80183c
  800c46:	e8 60 05 00 00       	call   8011ab <_panic>

00800c4b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
  800c51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c54:	8b 55 08             	mov    0x8(%ebp),%edx
  800c57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5a:	b8 05 00 00 00       	mov    $0x5,%eax
  800c5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c62:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c65:	8b 75 18             	mov    0x18(%ebp),%esi
  800c68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6a:	85 c0                	test   %eax,%eax
  800c6c:	7f 08                	jg     800c76 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800c7a:	6a 05                	push   $0x5
  800c7c:	68 1f 18 80 00       	push   $0x80181f
  800c81:	6a 23                	push   $0x23
  800c83:	68 3c 18 80 00       	push   $0x80183c
  800c88:	e8 1e 05 00 00       	call   8011ab <_panic>

00800c8d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800ca1:	b8 06 00 00 00       	mov    $0x6,%eax
  800ca6:	89 df                	mov    %ebx,%edi
  800ca8:	89 de                	mov    %ebx,%esi
  800caa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cac:	85 c0                	test   %eax,%eax
  800cae:	7f 08                	jg     800cb8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800cbc:	6a 06                	push   $0x6
  800cbe:	68 1f 18 80 00       	push   $0x80181f
  800cc3:	6a 23                	push   $0x23
  800cc5:	68 3c 18 80 00       	push   $0x80183c
  800cca:	e8 dc 04 00 00       	call   8011ab <_panic>

00800ccf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800ce3:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce8:	89 df                	mov    %ebx,%edi
  800cea:	89 de                	mov    %ebx,%esi
  800cec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cee:	85 c0                	test   %eax,%eax
  800cf0:	7f 08                	jg     800cfa <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800cfe:	6a 08                	push   $0x8
  800d00:	68 1f 18 80 00       	push   $0x80181f
  800d05:	6a 23                	push   $0x23
  800d07:	68 3c 18 80 00       	push   $0x80183c
  800d0c:	e8 9a 04 00 00       	call   8011ab <_panic>

00800d11 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800d25:	b8 09 00 00 00       	mov    $0x9,%eax
  800d2a:	89 df                	mov    %ebx,%edi
  800d2c:	89 de                	mov    %ebx,%esi
  800d2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d30:	85 c0                	test   %eax,%eax
  800d32:	7f 08                	jg     800d3c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800d40:	6a 09                	push   $0x9
  800d42:	68 1f 18 80 00       	push   $0x80181f
  800d47:	6a 23                	push   $0x23
  800d49:	68 3c 18 80 00       	push   $0x80183c
  800d4e:	e8 58 04 00 00       	call   8011ab <_panic>

00800d53 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	57                   	push   %edi
  800d57:	56                   	push   %esi
  800d58:	53                   	push   %ebx
  800d59:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d61:	8b 55 08             	mov    0x8(%ebp),%edx
  800d64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d67:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d6c:	89 df                	mov    %ebx,%edi
  800d6e:	89 de                	mov    %ebx,%esi
  800d70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d72:	85 c0                	test   %eax,%eax
  800d74:	7f 08                	jg     800d7e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d79:	5b                   	pop    %ebx
  800d7a:	5e                   	pop    %esi
  800d7b:	5f                   	pop    %edi
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7e:	83 ec 0c             	sub    $0xc,%esp
  800d81:	50                   	push   %eax
  800d82:	6a 0a                	push   $0xa
  800d84:	68 1f 18 80 00       	push   $0x80181f
  800d89:	6a 23                	push   $0x23
  800d8b:	68 3c 18 80 00       	push   $0x80183c
  800d90:	e8 16 04 00 00       	call   8011ab <_panic>

00800d95 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	57                   	push   %edi
  800d99:	56                   	push   %esi
  800d9a:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800da6:	be 00 00 00 00       	mov    $0x0,%esi
  800dab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dae:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800db3:	5b                   	pop    %ebx
  800db4:	5e                   	pop    %esi
  800db5:	5f                   	pop    %edi
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	57                   	push   %edi
  800dbc:	56                   	push   %esi
  800dbd:	53                   	push   %ebx
  800dbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800dc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dce:	89 cb                	mov    %ecx,%ebx
  800dd0:	89 cf                	mov    %ecx,%edi
  800dd2:	89 ce                	mov    %ecx,%esi
  800dd4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd6:	85 c0                	test   %eax,%eax
  800dd8:	7f 08                	jg     800de2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddd:	5b                   	pop    %ebx
  800dde:	5e                   	pop    %esi
  800ddf:	5f                   	pop    %edi
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de2:	83 ec 0c             	sub    $0xc,%esp
  800de5:	50                   	push   %eax
  800de6:	6a 0d                	push   $0xd
  800de8:	68 1f 18 80 00       	push   $0x80181f
  800ded:	6a 23                	push   $0x23
  800def:	68 3c 18 80 00       	push   $0x80183c
  800df4:	e8 b2 03 00 00       	call   8011ab <_panic>

00800df9 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	53                   	push   %ebx
  800dfd:	83 ec 04             	sub    $0x4,%esp
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e03:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) { //只有因为写操作写时拷贝的地址这中情况，才可以抢救。否则一律panic
  800e05:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e09:	74 74                	je     800e7f <pgfault+0x86>
  800e0b:	89 d8                	mov    %ebx,%eax
  800e0d:	c1 e8 0c             	shr    $0xc,%eax
  800e10:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e17:	f6 c4 08             	test   $0x8,%ah
  800e1a:	74 63                	je     800e7f <pgfault+0x86>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800e1c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, PFTEMP, PTE_U|PTE_P)) < 0)		//将当前进程PFTEMP也映射到当前进程addr指向的物理页
  800e22:	83 ec 0c             	sub    $0xc,%esp
  800e25:	6a 05                	push   $0x5
  800e27:	68 00 f0 7f 00       	push   $0x7ff000
  800e2c:	6a 00                	push   $0x0
  800e2e:	53                   	push   %ebx
  800e2f:	6a 00                	push   $0x0
  800e31:	e8 15 fe ff ff       	call   800c4b <sys_page_map>
  800e36:	83 c4 20             	add    $0x20,%esp
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	78 56                	js     800e93 <pgfault+0x9a>
		panic("sys_page_map: %e", r);
	if ((r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W)) < 0)	//令当前进程addr指向新分配的物理页
  800e3d:	83 ec 04             	sub    $0x4,%esp
  800e40:	6a 07                	push   $0x7
  800e42:	53                   	push   %ebx
  800e43:	6a 00                	push   $0x0
  800e45:	e8 be fd ff ff       	call   800c08 <sys_page_alloc>
  800e4a:	83 c4 10             	add    $0x10,%esp
  800e4d:	85 c0                	test   %eax,%eax
  800e4f:	78 54                	js     800ea5 <pgfault+0xac>
		panic("sys_page_alloc: %e", r);
	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800e51:	83 ec 04             	sub    $0x4,%esp
  800e54:	68 00 10 00 00       	push   $0x1000
  800e59:	68 00 f0 7f 00       	push   $0x7ff000
  800e5e:	53                   	push   %ebx
  800e5f:	e8 39 fb ff ff       	call   80099d <memmove>
	if ((r = sys_page_unmap(0, PFTEMP)) < 0)					//解除当前进程PFTEMP映射
  800e64:	83 c4 08             	add    $0x8,%esp
  800e67:	68 00 f0 7f 00       	push   $0x7ff000
  800e6c:	6a 00                	push   $0x0
  800e6e:	e8 1a fe ff ff       	call   800c8d <sys_page_unmap>
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	85 c0                	test   %eax,%eax
  800e78:	78 3d                	js     800eb7 <pgfault+0xbe>
		panic("sys_page_unmap: %e", r);
}
  800e7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e7d:	c9                   	leave  
  800e7e:	c3                   	ret    
		panic("pgfault():not cow");
  800e7f:	83 ec 04             	sub    $0x4,%esp
  800e82:	68 4a 18 80 00       	push   $0x80184a
  800e87:	6a 1d                	push   $0x1d
  800e89:	68 5c 18 80 00       	push   $0x80185c
  800e8e:	e8 18 03 00 00       	call   8011ab <_panic>
		panic("sys_page_map: %e", r);
  800e93:	50                   	push   %eax
  800e94:	68 67 18 80 00       	push   $0x801867
  800e99:	6a 2a                	push   $0x2a
  800e9b:	68 5c 18 80 00       	push   $0x80185c
  800ea0:	e8 06 03 00 00       	call   8011ab <_panic>
		panic("sys_page_alloc: %e", r);
  800ea5:	50                   	push   %eax
  800ea6:	68 78 18 80 00       	push   $0x801878
  800eab:	6a 2c                	push   $0x2c
  800ead:	68 5c 18 80 00       	push   $0x80185c
  800eb2:	e8 f4 02 00 00       	call   8011ab <_panic>
		panic("sys_page_unmap: %e", r);
  800eb7:	50                   	push   %eax
  800eb8:	68 8b 18 80 00       	push   $0x80188b
  800ebd:	6a 2f                	push   $0x2f
  800ebf:	68 5c 18 80 00       	push   $0x80185c
  800ec4:	e8 e2 02 00 00       	call   8011ab <_panic>

00800ec9 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);	//设置缺页处理函数
  800ed2:	68 f9 0d 80 00       	push   $0x800df9
  800ed7:	e8 15 03 00 00       	call   8011f1 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800edc:	b8 07 00 00 00       	mov    $0x7,%eax
  800ee1:	cd 30                	int    $0x30
  800ee3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();	//系统调用，只是简单创建一个Env结构，复制当前用户环境寄存器状态，UTOP以下的页目录还没有建立
	if (envid == 0) {				//子进程将走这个逻辑
  800ee6:	83 c4 10             	add    $0x10,%esp
  800ee9:	85 c0                	test   %eax,%eax
  800eeb:	74 12                	je     800eff <fork+0x36>
  800eed:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	if (envid < 0) {
  800eef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ef3:	78 26                	js     800f1b <fork+0x52>
		panic("sys_exofork: %e", envid);
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800ef5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efa:	e9 94 00 00 00       	jmp    800f93 <fork+0xca>
		thisenv = &envs[ENVX(sys_getenvid())];
  800eff:	e8 c6 fc ff ff       	call   800bca <sys_getenvid>
  800f04:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f09:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f0c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f11:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  800f16:	e9 51 01 00 00       	jmp    80106c <fork+0x1a3>
		panic("sys_exofork: %e", envid);
  800f1b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f1e:	68 9e 18 80 00       	push   $0x80189e
  800f23:	6a 6d                	push   $0x6d
  800f25:	68 5c 18 80 00       	push   $0x80185c
  800f2a:	e8 7c 02 00 00       	call   8011ab <_panic>
		sys_page_map(0, addr, envid, addr, PTE_SYSCALL);		//对于表示为PTE_SHARE的页，拷贝映射关系，并且两个进程都有读写权限
  800f2f:	83 ec 0c             	sub    $0xc,%esp
  800f32:	68 07 0e 00 00       	push   $0xe07
  800f37:	56                   	push   %esi
  800f38:	57                   	push   %edi
  800f39:	56                   	push   %esi
  800f3a:	6a 00                	push   $0x0
  800f3c:	e8 0a fd ff ff       	call   800c4b <sys_page_map>
  800f41:	83 c4 20             	add    $0x20,%esp
  800f44:	eb 3b                	jmp    800f81 <fork+0xb8>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  800f46:	83 ec 0c             	sub    $0xc,%esp
  800f49:	68 05 08 00 00       	push   $0x805
  800f4e:	56                   	push   %esi
  800f4f:	57                   	push   %edi
  800f50:	56                   	push   %esi
  800f51:	6a 00                	push   $0x0
  800f53:	e8 f3 fc ff ff       	call   800c4b <sys_page_map>
  800f58:	83 c4 20             	add    $0x20,%esp
  800f5b:	85 c0                	test   %eax,%eax
  800f5d:	0f 88 a9 00 00 00    	js     80100c <fork+0x143>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  800f63:	83 ec 0c             	sub    $0xc,%esp
  800f66:	68 05 08 00 00       	push   $0x805
  800f6b:	56                   	push   %esi
  800f6c:	6a 00                	push   $0x0
  800f6e:	56                   	push   %esi
  800f6f:	6a 00                	push   $0x0
  800f71:	e8 d5 fc ff ff       	call   800c4b <sys_page_map>
  800f76:	83 c4 20             	add    $0x20,%esp
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	0f 88 9d 00 00 00    	js     80101e <fork+0x155>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f81:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800f87:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800f8d:	0f 84 9d 00 00 00    	je     801030 <fork+0x167>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) //为什么uvpt[pagenumber]能访问到第pagenumber项页表条目：https://pdos.csail.mit.edu/6.828/2018/labs/lab4/uvpt.html
  800f93:	89 d8                	mov    %ebx,%eax
  800f95:	c1 e8 16             	shr    $0x16,%eax
  800f98:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f9f:	a8 01                	test   $0x1,%al
  800fa1:	74 de                	je     800f81 <fork+0xb8>
  800fa3:	89 d8                	mov    %ebx,%eax
  800fa5:	c1 e8 0c             	shr    $0xc,%eax
  800fa8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800faf:	f6 c2 01             	test   $0x1,%dl
  800fb2:	74 cd                	je     800f81 <fork+0xb8>
			&& (uvpt[PGNUM(addr)] & PTE_U)) {
  800fb4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fbb:	f6 c2 04             	test   $0x4,%dl
  800fbe:	74 c1                	je     800f81 <fork+0xb8>
	void *addr = (void*) (pn * PGSIZE);
  800fc0:	89 c6                	mov    %eax,%esi
  800fc2:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE) {
  800fc5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fcc:	f6 c6 04             	test   $0x4,%dh
  800fcf:	0f 85 5a ff ff ff    	jne    800f2f <fork+0x66>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) { //对于UTOP以下的可写的或者写时拷贝的页，拷贝映射关系的同时，需要同时标记当前进程和子进程的页表项为PTE_COW
  800fd5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fdc:	f6 c2 02             	test   $0x2,%dl
  800fdf:	0f 85 61 ff ff ff    	jne    800f46 <fork+0x7d>
  800fe5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fec:	f6 c4 08             	test   $0x8,%ah
  800fef:	0f 85 51 ff ff ff    	jne    800f46 <fork+0x7d>
		sys_page_map(0, addr, envid, addr, PTE_U|PTE_P);	//对于只读的页，只需要拷贝映射关系即可
  800ff5:	83 ec 0c             	sub    $0xc,%esp
  800ff8:	6a 05                	push   $0x5
  800ffa:	56                   	push   %esi
  800ffb:	57                   	push   %edi
  800ffc:	56                   	push   %esi
  800ffd:	6a 00                	push   $0x0
  800fff:	e8 47 fc ff ff       	call   800c4b <sys_page_map>
  801004:	83 c4 20             	add    $0x20,%esp
  801007:	e9 75 ff ff ff       	jmp    800f81 <fork+0xb8>
			panic("sys_page_map：%e", r);
  80100c:	50                   	push   %eax
  80100d:	68 ae 18 80 00       	push   $0x8018ae
  801012:	6a 48                	push   $0x48
  801014:	68 5c 18 80 00       	push   $0x80185c
  801019:	e8 8d 01 00 00       	call   8011ab <_panic>
			panic("sys_page_map：%e", r);
  80101e:	50                   	push   %eax
  80101f:	68 ae 18 80 00       	push   $0x8018ae
  801024:	6a 4a                	push   $0x4a
  801026:	68 5c 18 80 00       	push   $0x80185c
  80102b:	e8 7b 01 00 00       	call   8011ab <_panic>
			duppage(envid, PGNUM(addr));	//拷贝当前进程映射关系到子进程
		}
	}
	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_W | PTE_U)) < 0)	//为子进程分配异常栈
  801030:	83 ec 04             	sub    $0x4,%esp
  801033:	6a 07                	push   $0x7
  801035:	68 00 f0 bf ee       	push   $0xeebff000
  80103a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80103d:	e8 c6 fb ff ff       	call   800c08 <sys_page_alloc>
  801042:	83 c4 10             	add    $0x10,%esp
  801045:	85 c0                	test   %eax,%eax
  801047:	78 2e                	js     801077 <fork+0x1ae>
		panic("sys_page_alloc: %e", r);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);		//为子进程设置_pgfault_upcall
  801049:	83 ec 08             	sub    $0x8,%esp
  80104c:	68 4a 12 80 00       	push   $0x80124a
  801051:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801054:	57                   	push   %edi
  801055:	e8 f9 fc ff ff       	call   800d53 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)	//设置子进程为ENV_RUNNABLE状态
  80105a:	83 c4 08             	add    $0x8,%esp
  80105d:	6a 02                	push   $0x2
  80105f:	57                   	push   %edi
  801060:	e8 6a fc ff ff       	call   800ccf <sys_env_set_status>
  801065:	83 c4 10             	add    $0x10,%esp
  801068:	85 c0                	test   %eax,%eax
  80106a:	78 1d                	js     801089 <fork+0x1c0>
		panic("sys_env_set_status: %e", r);
	return envid;
}
  80106c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80106f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801072:	5b                   	pop    %ebx
  801073:	5e                   	pop    %esi
  801074:	5f                   	pop    %edi
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801077:	50                   	push   %eax
  801078:	68 78 18 80 00       	push   $0x801878
  80107d:	6a 79                	push   $0x79
  80107f:	68 5c 18 80 00       	push   $0x80185c
  801084:	e8 22 01 00 00       	call   8011ab <_panic>
		panic("sys_env_set_status: %e", r);
  801089:	50                   	push   %eax
  80108a:	68 c0 18 80 00       	push   $0x8018c0
  80108f:	6a 7d                	push   $0x7d
  801091:	68 5c 18 80 00       	push   $0x80185c
  801096:	e8 10 01 00 00       	call   8011ab <_panic>

0080109b <sfork>:

// Challenge!
int
sfork(void)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8010a1:	68 d7 18 80 00       	push   $0x8018d7
  8010a6:	68 85 00 00 00       	push   $0x85
  8010ab:	68 5c 18 80 00       	push   $0x80185c
  8010b0:	e8 f6 00 00 00       	call   8011ab <_panic>

008010b5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	56                   	push   %esi
  8010b9:	53                   	push   %ebx
  8010ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8010bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  8010c3:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  8010c5:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8010ca:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  8010cd:	83 ec 0c             	sub    $0xc,%esp
  8010d0:	50                   	push   %eax
  8010d1:	e8 e2 fc ff ff       	call   800db8 <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  8010d6:	83 c4 10             	add    $0x10,%esp
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	78 2b                	js     801108 <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  8010dd:	85 f6                	test   %esi,%esi
  8010df:	74 0a                	je     8010eb <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8010e1:	a1 08 20 80 00       	mov    0x802008,%eax
  8010e6:	8b 40 74             	mov    0x74(%eax),%eax
  8010e9:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  8010eb:	85 db                	test   %ebx,%ebx
  8010ed:	74 0a                	je     8010f9 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8010ef:	a1 08 20 80 00       	mov    0x802008,%eax
  8010f4:	8b 40 78             	mov    0x78(%eax),%eax
  8010f7:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  8010f9:	a1 08 20 80 00       	mov    0x802008,%eax
  8010fe:	8b 40 70             	mov    0x70(%eax),%eax
}
  801101:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801104:	5b                   	pop    %ebx
  801105:	5e                   	pop    %esi
  801106:	5d                   	pop    %ebp
  801107:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  801108:	85 f6                	test   %esi,%esi
  80110a:	74 06                	je     801112 <ipc_recv+0x5d>
  80110c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801112:	85 db                	test   %ebx,%ebx
  801114:	74 eb                	je     801101 <ipc_recv+0x4c>
  801116:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80111c:	eb e3                	jmp    801101 <ipc_recv+0x4c>

0080111e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	57                   	push   %edi
  801122:	56                   	push   %esi
  801123:	53                   	push   %ebx
  801124:	83 ec 0c             	sub    $0xc,%esp
  801127:	8b 7d 08             	mov    0x8(%ebp),%edi
  80112a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80112d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801130:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  801132:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801137:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  80113a:	ff 75 14             	pushl  0x14(%ebp)
  80113d:	53                   	push   %ebx
  80113e:	56                   	push   %esi
  80113f:	57                   	push   %edi
  801140:	e8 50 fc ff ff       	call   800d95 <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  801145:	83 c4 10             	add    $0x10,%esp
  801148:	85 c0                	test   %eax,%eax
  80114a:	74 1e                	je     80116a <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  80114c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80114f:	75 07                	jne    801158 <ipc_send+0x3a>
			sys_yield();
  801151:	e8 93 fa ff ff       	call   800be9 <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801156:	eb e2                	jmp    80113a <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  801158:	50                   	push   %eax
  801159:	68 ed 18 80 00       	push   $0x8018ed
  80115e:	6a 41                	push   $0x41
  801160:	68 fb 18 80 00       	push   $0x8018fb
  801165:	e8 41 00 00 00       	call   8011ab <_panic>
		}
	}
}
  80116a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80116d:	5b                   	pop    %ebx
  80116e:	5e                   	pop    %esi
  80116f:	5f                   	pop    %edi
  801170:	5d                   	pop    %ebp
  801171:	c3                   	ret    

00801172 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
  801175:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801178:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80117d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801180:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801186:	8b 52 50             	mov    0x50(%edx),%edx
  801189:	39 ca                	cmp    %ecx,%edx
  80118b:	74 11                	je     80119e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80118d:	83 c0 01             	add    $0x1,%eax
  801190:	3d 00 04 00 00       	cmp    $0x400,%eax
  801195:	75 e6                	jne    80117d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801197:	b8 00 00 00 00       	mov    $0x0,%eax
  80119c:	eb 0b                	jmp    8011a9 <ipc_find_env+0x37>
			return envs[i].env_id;
  80119e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011a6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8011a9:	5d                   	pop    %ebp
  8011aa:	c3                   	ret    

008011ab <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	56                   	push   %esi
  8011af:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8011b0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8011b3:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8011b9:	e8 0c fa ff ff       	call   800bca <sys_getenvid>
  8011be:	83 ec 0c             	sub    $0xc,%esp
  8011c1:	ff 75 0c             	pushl  0xc(%ebp)
  8011c4:	ff 75 08             	pushl  0x8(%ebp)
  8011c7:	56                   	push   %esi
  8011c8:	50                   	push   %eax
  8011c9:	68 08 19 80 00       	push   $0x801908
  8011ce:	e8 1d f0 ff ff       	call   8001f0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8011d3:	83 c4 18             	add    $0x18,%esp
  8011d6:	53                   	push   %ebx
  8011d7:	ff 75 10             	pushl  0x10(%ebp)
  8011da:	e8 c0 ef ff ff       	call   80019f <vcprintf>
	cprintf("\n");
  8011df:	c7 04 24 d8 14 80 00 	movl   $0x8014d8,(%esp)
  8011e6:	e8 05 f0 ff ff       	call   8001f0 <cprintf>
  8011eb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8011ee:	cc                   	int3   
  8011ef:	eb fd                	jmp    8011ee <_panic+0x43>

008011f1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8011f7:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  8011fe:	74 0a                	je     80120a <set_pgfault_handler+0x19>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	a3 0c 20 80 00       	mov    %eax,0x80200c
}
  801208:	c9                   	leave  
  801209:	c3                   	ret    
		int r = sys_page_alloc(0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P);	//为当前进程分配异常栈
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	6a 07                	push   $0x7
  80120f:	68 00 f0 bf ee       	push   $0xeebff000
  801214:	6a 00                	push   $0x0
  801216:	e8 ed f9 ff ff       	call   800c08 <sys_page_alloc>
		if (r < 0) {
  80121b:	83 c4 10             	add    $0x10,%esp
  80121e:	85 c0                	test   %eax,%eax
  801220:	78 14                	js     801236 <set_pgfault_handler+0x45>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
  801222:	83 ec 08             	sub    $0x8,%esp
  801225:	68 4a 12 80 00       	push   $0x80124a
  80122a:	6a 00                	push   $0x0
  80122c:	e8 22 fb ff ff       	call   800d53 <sys_env_set_pgfault_upcall>
  801231:	83 c4 10             	add    $0x10,%esp
  801234:	eb ca                	jmp    801200 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler:sys_page_alloc failed");;
  801236:	83 ec 04             	sub    $0x4,%esp
  801239:	68 2c 19 80 00       	push   $0x80192c
  80123e:	6a 22                	push   $0x22
  801240:	68 58 19 80 00       	push   $0x801958
  801245:	e8 61 ff ff ff       	call   8011ab <_panic>

0080124a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80124a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80124b:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax				//调用页处理函数
  801250:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801252:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp			//跳过utf_fault_va和utf_err
  801255:	83 c4 08             	add    $0x8,%esp
	movl 40(%esp), %eax 	//保存中断发生时的esp到eax
  801258:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl 32(%esp), %ecx 	//保存终端发生时的eip到ecx
  80125c:	8b 4c 24 20          	mov    0x20(%esp),%ecx
	movl %ecx, -4(%eax) 	//将中断发生时的esp值亚入到到原来的栈中
  801260:	89 48 fc             	mov    %ecx,-0x4(%eax)
	popal
  801263:	61                   	popa   
	addl $4, %esp			//跳过eip
  801264:	83 c4 04             	add    $0x4,%esp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801267:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801268:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	lea -4(%esp), %esp		//因为之前压入了eip的值但是没有减esp的值，所以现在需要将esp寄存器中的值减4
  801269:	8d 64 24 fc          	lea    -0x4(%esp),%esp
  80126d:	c3                   	ret    
  80126e:	66 90                	xchg   %ax,%ax

00801270 <__udivdi3>:
  801270:	55                   	push   %ebp
  801271:	57                   	push   %edi
  801272:	56                   	push   %esi
  801273:	53                   	push   %ebx
  801274:	83 ec 1c             	sub    $0x1c,%esp
  801277:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80127b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80127f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801283:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801287:	85 d2                	test   %edx,%edx
  801289:	75 35                	jne    8012c0 <__udivdi3+0x50>
  80128b:	39 f3                	cmp    %esi,%ebx
  80128d:	0f 87 bd 00 00 00    	ja     801350 <__udivdi3+0xe0>
  801293:	85 db                	test   %ebx,%ebx
  801295:	89 d9                	mov    %ebx,%ecx
  801297:	75 0b                	jne    8012a4 <__udivdi3+0x34>
  801299:	b8 01 00 00 00       	mov    $0x1,%eax
  80129e:	31 d2                	xor    %edx,%edx
  8012a0:	f7 f3                	div    %ebx
  8012a2:	89 c1                	mov    %eax,%ecx
  8012a4:	31 d2                	xor    %edx,%edx
  8012a6:	89 f0                	mov    %esi,%eax
  8012a8:	f7 f1                	div    %ecx
  8012aa:	89 c6                	mov    %eax,%esi
  8012ac:	89 e8                	mov    %ebp,%eax
  8012ae:	89 f7                	mov    %esi,%edi
  8012b0:	f7 f1                	div    %ecx
  8012b2:	89 fa                	mov    %edi,%edx
  8012b4:	83 c4 1c             	add    $0x1c,%esp
  8012b7:	5b                   	pop    %ebx
  8012b8:	5e                   	pop    %esi
  8012b9:	5f                   	pop    %edi
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    
  8012bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012c0:	39 f2                	cmp    %esi,%edx
  8012c2:	77 7c                	ja     801340 <__udivdi3+0xd0>
  8012c4:	0f bd fa             	bsr    %edx,%edi
  8012c7:	83 f7 1f             	xor    $0x1f,%edi
  8012ca:	0f 84 98 00 00 00    	je     801368 <__udivdi3+0xf8>
  8012d0:	89 f9                	mov    %edi,%ecx
  8012d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8012d7:	29 f8                	sub    %edi,%eax
  8012d9:	d3 e2                	shl    %cl,%edx
  8012db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8012df:	89 c1                	mov    %eax,%ecx
  8012e1:	89 da                	mov    %ebx,%edx
  8012e3:	d3 ea                	shr    %cl,%edx
  8012e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8012e9:	09 d1                	or     %edx,%ecx
  8012eb:	89 f2                	mov    %esi,%edx
  8012ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012f1:	89 f9                	mov    %edi,%ecx
  8012f3:	d3 e3                	shl    %cl,%ebx
  8012f5:	89 c1                	mov    %eax,%ecx
  8012f7:	d3 ea                	shr    %cl,%edx
  8012f9:	89 f9                	mov    %edi,%ecx
  8012fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012ff:	d3 e6                	shl    %cl,%esi
  801301:	89 eb                	mov    %ebp,%ebx
  801303:	89 c1                	mov    %eax,%ecx
  801305:	d3 eb                	shr    %cl,%ebx
  801307:	09 de                	or     %ebx,%esi
  801309:	89 f0                	mov    %esi,%eax
  80130b:	f7 74 24 08          	divl   0x8(%esp)
  80130f:	89 d6                	mov    %edx,%esi
  801311:	89 c3                	mov    %eax,%ebx
  801313:	f7 64 24 0c          	mull   0xc(%esp)
  801317:	39 d6                	cmp    %edx,%esi
  801319:	72 0c                	jb     801327 <__udivdi3+0xb7>
  80131b:	89 f9                	mov    %edi,%ecx
  80131d:	d3 e5                	shl    %cl,%ebp
  80131f:	39 c5                	cmp    %eax,%ebp
  801321:	73 5d                	jae    801380 <__udivdi3+0x110>
  801323:	39 d6                	cmp    %edx,%esi
  801325:	75 59                	jne    801380 <__udivdi3+0x110>
  801327:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80132a:	31 ff                	xor    %edi,%edi
  80132c:	89 fa                	mov    %edi,%edx
  80132e:	83 c4 1c             	add    $0x1c,%esp
  801331:	5b                   	pop    %ebx
  801332:	5e                   	pop    %esi
  801333:	5f                   	pop    %edi
  801334:	5d                   	pop    %ebp
  801335:	c3                   	ret    
  801336:	8d 76 00             	lea    0x0(%esi),%esi
  801339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801340:	31 ff                	xor    %edi,%edi
  801342:	31 c0                	xor    %eax,%eax
  801344:	89 fa                	mov    %edi,%edx
  801346:	83 c4 1c             	add    $0x1c,%esp
  801349:	5b                   	pop    %ebx
  80134a:	5e                   	pop    %esi
  80134b:	5f                   	pop    %edi
  80134c:	5d                   	pop    %ebp
  80134d:	c3                   	ret    
  80134e:	66 90                	xchg   %ax,%ax
  801350:	31 ff                	xor    %edi,%edi
  801352:	89 e8                	mov    %ebp,%eax
  801354:	89 f2                	mov    %esi,%edx
  801356:	f7 f3                	div    %ebx
  801358:	89 fa                	mov    %edi,%edx
  80135a:	83 c4 1c             	add    $0x1c,%esp
  80135d:	5b                   	pop    %ebx
  80135e:	5e                   	pop    %esi
  80135f:	5f                   	pop    %edi
  801360:	5d                   	pop    %ebp
  801361:	c3                   	ret    
  801362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801368:	39 f2                	cmp    %esi,%edx
  80136a:	72 06                	jb     801372 <__udivdi3+0x102>
  80136c:	31 c0                	xor    %eax,%eax
  80136e:	39 eb                	cmp    %ebp,%ebx
  801370:	77 d2                	ja     801344 <__udivdi3+0xd4>
  801372:	b8 01 00 00 00       	mov    $0x1,%eax
  801377:	eb cb                	jmp    801344 <__udivdi3+0xd4>
  801379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801380:	89 d8                	mov    %ebx,%eax
  801382:	31 ff                	xor    %edi,%edi
  801384:	eb be                	jmp    801344 <__udivdi3+0xd4>
  801386:	66 90                	xchg   %ax,%ax
  801388:	66 90                	xchg   %ax,%ax
  80138a:	66 90                	xchg   %ax,%ax
  80138c:	66 90                	xchg   %ax,%ax
  80138e:	66 90                	xchg   %ax,%ax

00801390 <__umoddi3>:
  801390:	55                   	push   %ebp
  801391:	57                   	push   %edi
  801392:	56                   	push   %esi
  801393:	53                   	push   %ebx
  801394:	83 ec 1c             	sub    $0x1c,%esp
  801397:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80139b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80139f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8013a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8013a7:	85 ed                	test   %ebp,%ebp
  8013a9:	89 f0                	mov    %esi,%eax
  8013ab:	89 da                	mov    %ebx,%edx
  8013ad:	75 19                	jne    8013c8 <__umoddi3+0x38>
  8013af:	39 df                	cmp    %ebx,%edi
  8013b1:	0f 86 b1 00 00 00    	jbe    801468 <__umoddi3+0xd8>
  8013b7:	f7 f7                	div    %edi
  8013b9:	89 d0                	mov    %edx,%eax
  8013bb:	31 d2                	xor    %edx,%edx
  8013bd:	83 c4 1c             	add    $0x1c,%esp
  8013c0:	5b                   	pop    %ebx
  8013c1:	5e                   	pop    %esi
  8013c2:	5f                   	pop    %edi
  8013c3:	5d                   	pop    %ebp
  8013c4:	c3                   	ret    
  8013c5:	8d 76 00             	lea    0x0(%esi),%esi
  8013c8:	39 dd                	cmp    %ebx,%ebp
  8013ca:	77 f1                	ja     8013bd <__umoddi3+0x2d>
  8013cc:	0f bd cd             	bsr    %ebp,%ecx
  8013cf:	83 f1 1f             	xor    $0x1f,%ecx
  8013d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013d6:	0f 84 b4 00 00 00    	je     801490 <__umoddi3+0x100>
  8013dc:	b8 20 00 00 00       	mov    $0x20,%eax
  8013e1:	89 c2                	mov    %eax,%edx
  8013e3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8013e7:	29 c2                	sub    %eax,%edx
  8013e9:	89 c1                	mov    %eax,%ecx
  8013eb:	89 f8                	mov    %edi,%eax
  8013ed:	d3 e5                	shl    %cl,%ebp
  8013ef:	89 d1                	mov    %edx,%ecx
  8013f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013f5:	d3 e8                	shr    %cl,%eax
  8013f7:	09 c5                	or     %eax,%ebp
  8013f9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8013fd:	89 c1                	mov    %eax,%ecx
  8013ff:	d3 e7                	shl    %cl,%edi
  801401:	89 d1                	mov    %edx,%ecx
  801403:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801407:	89 df                	mov    %ebx,%edi
  801409:	d3 ef                	shr    %cl,%edi
  80140b:	89 c1                	mov    %eax,%ecx
  80140d:	89 f0                	mov    %esi,%eax
  80140f:	d3 e3                	shl    %cl,%ebx
  801411:	89 d1                	mov    %edx,%ecx
  801413:	89 fa                	mov    %edi,%edx
  801415:	d3 e8                	shr    %cl,%eax
  801417:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80141c:	09 d8                	or     %ebx,%eax
  80141e:	f7 f5                	div    %ebp
  801420:	d3 e6                	shl    %cl,%esi
  801422:	89 d1                	mov    %edx,%ecx
  801424:	f7 64 24 08          	mull   0x8(%esp)
  801428:	39 d1                	cmp    %edx,%ecx
  80142a:	89 c3                	mov    %eax,%ebx
  80142c:	89 d7                	mov    %edx,%edi
  80142e:	72 06                	jb     801436 <__umoddi3+0xa6>
  801430:	75 0e                	jne    801440 <__umoddi3+0xb0>
  801432:	39 c6                	cmp    %eax,%esi
  801434:	73 0a                	jae    801440 <__umoddi3+0xb0>
  801436:	2b 44 24 08          	sub    0x8(%esp),%eax
  80143a:	19 ea                	sbb    %ebp,%edx
  80143c:	89 d7                	mov    %edx,%edi
  80143e:	89 c3                	mov    %eax,%ebx
  801440:	89 ca                	mov    %ecx,%edx
  801442:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801447:	29 de                	sub    %ebx,%esi
  801449:	19 fa                	sbb    %edi,%edx
  80144b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80144f:	89 d0                	mov    %edx,%eax
  801451:	d3 e0                	shl    %cl,%eax
  801453:	89 d9                	mov    %ebx,%ecx
  801455:	d3 ee                	shr    %cl,%esi
  801457:	d3 ea                	shr    %cl,%edx
  801459:	09 f0                	or     %esi,%eax
  80145b:	83 c4 1c             	add    $0x1c,%esp
  80145e:	5b                   	pop    %ebx
  80145f:	5e                   	pop    %esi
  801460:	5f                   	pop    %edi
  801461:	5d                   	pop    %ebp
  801462:	c3                   	ret    
  801463:	90                   	nop
  801464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801468:	85 ff                	test   %edi,%edi
  80146a:	89 f9                	mov    %edi,%ecx
  80146c:	75 0b                	jne    801479 <__umoddi3+0xe9>
  80146e:	b8 01 00 00 00       	mov    $0x1,%eax
  801473:	31 d2                	xor    %edx,%edx
  801475:	f7 f7                	div    %edi
  801477:	89 c1                	mov    %eax,%ecx
  801479:	89 d8                	mov    %ebx,%eax
  80147b:	31 d2                	xor    %edx,%edx
  80147d:	f7 f1                	div    %ecx
  80147f:	89 f0                	mov    %esi,%eax
  801481:	f7 f1                	div    %ecx
  801483:	e9 31 ff ff ff       	jmp    8013b9 <__umoddi3+0x29>
  801488:	90                   	nop
  801489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801490:	39 dd                	cmp    %ebx,%ebp
  801492:	72 08                	jb     80149c <__umoddi3+0x10c>
  801494:	39 f7                	cmp    %esi,%edi
  801496:	0f 87 21 ff ff ff    	ja     8013bd <__umoddi3+0x2d>
  80149c:	89 da                	mov    %ebx,%edx
  80149e:	89 f0                	mov    %esi,%eax
  8014a0:	29 f8                	sub    %edi,%eax
  8014a2:	19 ea                	sbb    %ebp,%edx
  8014a4:	e9 14 ff ff ff       	jmp    8013bd <__umoddi3+0x2d>
