
obj/user/pingpong.debug：     文件格式 elf32-i386


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
  80002c:	e8 8f 00 00 00       	call   8000c0 <libmain>
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
  800039:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 45 0e 00 00       	call   800e86 <fork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 4f                	jne    800097 <umain+0x64>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800048:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004b:	83 ec 04             	sub    $0x4,%esp
  80004e:	6a 00                	push   $0x0
  800050:	6a 00                	push   $0x0
  800052:	56                   	push   %esi
  800053:	e8 1a 10 00 00       	call   801072 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 25 0b 00 00       	call   800b87 <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 96 14 80 00       	push   $0x801496
  80006a:	e8 3e 01 00 00       	call   8001ad <cprintf>
		if (i == 10)
  80006f:	83 c4 20             	add    $0x20,%esp
  800072:	83 fb 0a             	cmp    $0xa,%ebx
  800075:	74 18                	je     80008f <umain+0x5c>
			return;
		i++;
  800077:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007a:	6a 00                	push   $0x0
  80007c:	6a 00                	push   $0x0
  80007e:	53                   	push   %ebx
  80007f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800082:	e8 54 10 00 00       	call   8010db <ipc_send>
		if (i == 10)
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	83 fb 0a             	cmp    $0xa,%ebx
  80008d:	75 bc                	jne    80004b <umain+0x18>
			return;
	}

}
  80008f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800092:	5b                   	pop    %ebx
  800093:	5e                   	pop    %esi
  800094:	5f                   	pop    %edi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    
  800097:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800099:	e8 e9 0a 00 00       	call   800b87 <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 80 14 80 00       	push   $0x801480
  8000a8:	e8 00 01 00 00       	call   8001ad <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 20 10 00 00       	call   8010db <ipc_send>
  8000bb:	83 c4 20             	add    $0x20,%esp
  8000be:	eb 88                	jmp    800048 <umain+0x15>

008000c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	56                   	push   %esi
  8000c4:	53                   	push   %ebx
  8000c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  8000cb:	e8 b7 0a 00 00       	call   800b87 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  8000d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000dd:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e2:	85 db                	test   %ebx,%ebx
  8000e4:	7e 07                	jle    8000ed <libmain+0x2d>
		binaryname = argv[0];
  8000e6:	8b 06                	mov    (%esi),%eax
  8000e8:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	56                   	push   %esi
  8000f1:	53                   	push   %ebx
  8000f2:	e8 3c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f7:	e8 0a 00 00 00       	call   800106 <exit>
}
  8000fc:	83 c4 10             	add    $0x10,%esp
  8000ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800102:	5b                   	pop    %ebx
  800103:	5e                   	pop    %esi
  800104:	5d                   	pop    %ebp
  800105:	c3                   	ret    

00800106 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800106:	55                   	push   %ebp
  800107:	89 e5                	mov    %esp,%ebp
  800109:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80010c:	6a 00                	push   $0x0
  80010e:	e8 33 0a 00 00       	call   800b46 <sys_env_destroy>
}
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	c9                   	leave  
  800117:	c3                   	ret    

00800118 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	53                   	push   %ebx
  80011c:	83 ec 04             	sub    $0x4,%esp
  80011f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800122:	8b 13                	mov    (%ebx),%edx
  800124:	8d 42 01             	lea    0x1(%edx),%eax
  800127:	89 03                	mov    %eax,(%ebx)
  800129:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800130:	3d ff 00 00 00       	cmp    $0xff,%eax
  800135:	74 09                	je     800140 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800137:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013e:	c9                   	leave  
  80013f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800140:	83 ec 08             	sub    $0x8,%esp
  800143:	68 ff 00 00 00       	push   $0xff
  800148:	8d 43 08             	lea    0x8(%ebx),%eax
  80014b:	50                   	push   %eax
  80014c:	e8 b8 09 00 00       	call   800b09 <sys_cputs>
		b->idx = 0;
  800151:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	eb db                	jmp    800137 <putch+0x1f>

0080015c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800165:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016c:	00 00 00 
	b.cnt = 0;
  80016f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800176:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800179:	ff 75 0c             	pushl  0xc(%ebp)
  80017c:	ff 75 08             	pushl  0x8(%ebp)
  80017f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800185:	50                   	push   %eax
  800186:	68 18 01 80 00       	push   $0x800118
  80018b:	e8 1a 01 00 00       	call   8002aa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800190:	83 c4 08             	add    $0x8,%esp
  800193:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800199:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019f:	50                   	push   %eax
  8001a0:	e8 64 09 00 00       	call   800b09 <sys_cputs>

	return b.cnt;
}
  8001a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b6:	50                   	push   %eax
  8001b7:	ff 75 08             	pushl  0x8(%ebp)
  8001ba:	e8 9d ff ff ff       	call   80015c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001bf:	c9                   	leave  
  8001c0:	c3                   	ret    

008001c1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c1:	55                   	push   %ebp
  8001c2:	89 e5                	mov    %esp,%ebp
  8001c4:	57                   	push   %edi
  8001c5:	56                   	push   %esi
  8001c6:	53                   	push   %ebx
  8001c7:	83 ec 1c             	sub    $0x1c,%esp
  8001ca:	89 c7                	mov    %eax,%edi
  8001cc:	89 d6                	mov    %edx,%esi
  8001ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001e5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001e8:	39 d3                	cmp    %edx,%ebx
  8001ea:	72 05                	jb     8001f1 <printnum+0x30>
  8001ec:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001ef:	77 7a                	ja     80026b <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f1:	83 ec 0c             	sub    $0xc,%esp
  8001f4:	ff 75 18             	pushl  0x18(%ebp)
  8001f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8001fa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001fd:	53                   	push   %ebx
  8001fe:	ff 75 10             	pushl  0x10(%ebp)
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	ff 75 e4             	pushl  -0x1c(%ebp)
  800207:	ff 75 e0             	pushl  -0x20(%ebp)
  80020a:	ff 75 dc             	pushl  -0x24(%ebp)
  80020d:	ff 75 d8             	pushl  -0x28(%ebp)
  800210:	e8 1b 10 00 00       	call   801230 <__udivdi3>
  800215:	83 c4 18             	add    $0x18,%esp
  800218:	52                   	push   %edx
  800219:	50                   	push   %eax
  80021a:	89 f2                	mov    %esi,%edx
  80021c:	89 f8                	mov    %edi,%eax
  80021e:	e8 9e ff ff ff       	call   8001c1 <printnum>
  800223:	83 c4 20             	add    $0x20,%esp
  800226:	eb 13                	jmp    80023b <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	56                   	push   %esi
  80022c:	ff 75 18             	pushl  0x18(%ebp)
  80022f:	ff d7                	call   *%edi
  800231:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800234:	83 eb 01             	sub    $0x1,%ebx
  800237:	85 db                	test   %ebx,%ebx
  800239:	7f ed                	jg     800228 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	56                   	push   %esi
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	ff 75 e4             	pushl  -0x1c(%ebp)
  800245:	ff 75 e0             	pushl  -0x20(%ebp)
  800248:	ff 75 dc             	pushl  -0x24(%ebp)
  80024b:	ff 75 d8             	pushl  -0x28(%ebp)
  80024e:	e8 fd 10 00 00       	call   801350 <__umoddi3>
  800253:	83 c4 14             	add    $0x14,%esp
  800256:	0f be 80 b3 14 80 00 	movsbl 0x8014b3(%eax),%eax
  80025d:	50                   	push   %eax
  80025e:	ff d7                	call   *%edi
}
  800260:	83 c4 10             	add    $0x10,%esp
  800263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    
  80026b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80026e:	eb c4                	jmp    800234 <printnum+0x73>

00800270 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800276:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80027a:	8b 10                	mov    (%eax),%edx
  80027c:	3b 50 04             	cmp    0x4(%eax),%edx
  80027f:	73 0a                	jae    80028b <sprintputch+0x1b>
		*b->buf++ = ch;
  800281:	8d 4a 01             	lea    0x1(%edx),%ecx
  800284:	89 08                	mov    %ecx,(%eax)
  800286:	8b 45 08             	mov    0x8(%ebp),%eax
  800289:	88 02                	mov    %al,(%edx)
}
  80028b:	5d                   	pop    %ebp
  80028c:	c3                   	ret    

0080028d <printfmt>:
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800293:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800296:	50                   	push   %eax
  800297:	ff 75 10             	pushl  0x10(%ebp)
  80029a:	ff 75 0c             	pushl  0xc(%ebp)
  80029d:	ff 75 08             	pushl  0x8(%ebp)
  8002a0:	e8 05 00 00 00       	call   8002aa <vprintfmt>
}
  8002a5:	83 c4 10             	add    $0x10,%esp
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <vprintfmt>:
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	57                   	push   %edi
  8002ae:	56                   	push   %esi
  8002af:	53                   	push   %ebx
  8002b0:	83 ec 2c             	sub    $0x2c,%esp
  8002b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002bc:	e9 c1 03 00 00       	jmp    800682 <vprintfmt+0x3d8>
		padc = ' ';
  8002c1:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002c5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002cc:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002da:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002df:	8d 47 01             	lea    0x1(%edi),%eax
  8002e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e5:	0f b6 17             	movzbl (%edi),%edx
  8002e8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002eb:	3c 55                	cmp    $0x55,%al
  8002ed:	0f 87 12 04 00 00    	ja     800705 <vprintfmt+0x45b>
  8002f3:	0f b6 c0             	movzbl %al,%eax
  8002f6:	ff 24 85 00 16 80 00 	jmp    *0x801600(,%eax,4)
  8002fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800300:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800304:	eb d9                	jmp    8002df <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800306:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800309:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80030d:	eb d0                	jmp    8002df <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80030f:	0f b6 d2             	movzbl %dl,%edx
  800312:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800315:	b8 00 00 00 00       	mov    $0x0,%eax
  80031a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80031d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800320:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800324:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800327:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80032a:	83 f9 09             	cmp    $0x9,%ecx
  80032d:	77 55                	ja     800384 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80032f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800332:	eb e9                	jmp    80031d <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800334:	8b 45 14             	mov    0x14(%ebp),%eax
  800337:	8b 00                	mov    (%eax),%eax
  800339:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80033c:	8b 45 14             	mov    0x14(%ebp),%eax
  80033f:	8d 40 04             	lea    0x4(%eax),%eax
  800342:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800345:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800348:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80034c:	79 91                	jns    8002df <vprintfmt+0x35>
				width = precision, precision = -1;
  80034e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800351:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800354:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80035b:	eb 82                	jmp    8002df <vprintfmt+0x35>
  80035d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800360:	85 c0                	test   %eax,%eax
  800362:	ba 00 00 00 00       	mov    $0x0,%edx
  800367:	0f 49 d0             	cmovns %eax,%edx
  80036a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800370:	e9 6a ff ff ff       	jmp    8002df <vprintfmt+0x35>
  800375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800378:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80037f:	e9 5b ff ff ff       	jmp    8002df <vprintfmt+0x35>
  800384:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800387:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80038a:	eb bc                	jmp    800348 <vprintfmt+0x9e>
			lflag++;
  80038c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800392:	e9 48 ff ff ff       	jmp    8002df <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800397:	8b 45 14             	mov    0x14(%ebp),%eax
  80039a:	8d 78 04             	lea    0x4(%eax),%edi
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	53                   	push   %ebx
  8003a1:	ff 30                	pushl  (%eax)
  8003a3:	ff d6                	call   *%esi
			break;
  8003a5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ab:	e9 cf 02 00 00       	jmp    80067f <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8003b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b3:	8d 78 04             	lea    0x4(%eax),%edi
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	99                   	cltd   
  8003b9:	31 d0                	xor    %edx,%eax
  8003bb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003bd:	83 f8 0f             	cmp    $0xf,%eax
  8003c0:	7f 23                	jg     8003e5 <vprintfmt+0x13b>
  8003c2:	8b 14 85 60 17 80 00 	mov    0x801760(,%eax,4),%edx
  8003c9:	85 d2                	test   %edx,%edx
  8003cb:	74 18                	je     8003e5 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003cd:	52                   	push   %edx
  8003ce:	68 d4 14 80 00       	push   $0x8014d4
  8003d3:	53                   	push   %ebx
  8003d4:	56                   	push   %esi
  8003d5:	e8 b3 fe ff ff       	call   80028d <printfmt>
  8003da:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003dd:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e0:	e9 9a 02 00 00       	jmp    80067f <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8003e5:	50                   	push   %eax
  8003e6:	68 cb 14 80 00       	push   $0x8014cb
  8003eb:	53                   	push   %ebx
  8003ec:	56                   	push   %esi
  8003ed:	e8 9b fe ff ff       	call   80028d <printfmt>
  8003f2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f8:	e9 82 02 00 00       	jmp    80067f <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8003fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800400:	83 c0 04             	add    $0x4,%eax
  800403:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800406:	8b 45 14             	mov    0x14(%ebp),%eax
  800409:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80040b:	85 ff                	test   %edi,%edi
  80040d:	b8 c4 14 80 00       	mov    $0x8014c4,%eax
  800412:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800415:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800419:	0f 8e bd 00 00 00    	jle    8004dc <vprintfmt+0x232>
  80041f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800423:	75 0e                	jne    800433 <vprintfmt+0x189>
  800425:	89 75 08             	mov    %esi,0x8(%ebp)
  800428:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80042b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80042e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800431:	eb 6d                	jmp    8004a0 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800433:	83 ec 08             	sub    $0x8,%esp
  800436:	ff 75 d0             	pushl  -0x30(%ebp)
  800439:	57                   	push   %edi
  80043a:	e8 6e 03 00 00       	call   8007ad <strnlen>
  80043f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800442:	29 c1                	sub    %eax,%ecx
  800444:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800447:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80044a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80044e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800451:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800454:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800456:	eb 0f                	jmp    800467 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	53                   	push   %ebx
  80045c:	ff 75 e0             	pushl  -0x20(%ebp)
  80045f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800461:	83 ef 01             	sub    $0x1,%edi
  800464:	83 c4 10             	add    $0x10,%esp
  800467:	85 ff                	test   %edi,%edi
  800469:	7f ed                	jg     800458 <vprintfmt+0x1ae>
  80046b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80046e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800471:	85 c9                	test   %ecx,%ecx
  800473:	b8 00 00 00 00       	mov    $0x0,%eax
  800478:	0f 49 c1             	cmovns %ecx,%eax
  80047b:	29 c1                	sub    %eax,%ecx
  80047d:	89 75 08             	mov    %esi,0x8(%ebp)
  800480:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800483:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800486:	89 cb                	mov    %ecx,%ebx
  800488:	eb 16                	jmp    8004a0 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80048a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80048e:	75 31                	jne    8004c1 <vprintfmt+0x217>
					putch(ch, putdat);
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	ff 75 0c             	pushl  0xc(%ebp)
  800496:	50                   	push   %eax
  800497:	ff 55 08             	call   *0x8(%ebp)
  80049a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80049d:	83 eb 01             	sub    $0x1,%ebx
  8004a0:	83 c7 01             	add    $0x1,%edi
  8004a3:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004a7:	0f be c2             	movsbl %dl,%eax
  8004aa:	85 c0                	test   %eax,%eax
  8004ac:	74 59                	je     800507 <vprintfmt+0x25d>
  8004ae:	85 f6                	test   %esi,%esi
  8004b0:	78 d8                	js     80048a <vprintfmt+0x1e0>
  8004b2:	83 ee 01             	sub    $0x1,%esi
  8004b5:	79 d3                	jns    80048a <vprintfmt+0x1e0>
  8004b7:	89 df                	mov    %ebx,%edi
  8004b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8004bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004bf:	eb 37                	jmp    8004f8 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c1:	0f be d2             	movsbl %dl,%edx
  8004c4:	83 ea 20             	sub    $0x20,%edx
  8004c7:	83 fa 5e             	cmp    $0x5e,%edx
  8004ca:	76 c4                	jbe    800490 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	ff 75 0c             	pushl  0xc(%ebp)
  8004d2:	6a 3f                	push   $0x3f
  8004d4:	ff 55 08             	call   *0x8(%ebp)
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	eb c1                	jmp    80049d <vprintfmt+0x1f3>
  8004dc:	89 75 08             	mov    %esi,0x8(%ebp)
  8004df:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004e2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004e5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e8:	eb b6                	jmp    8004a0 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	53                   	push   %ebx
  8004ee:	6a 20                	push   $0x20
  8004f0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004f2:	83 ef 01             	sub    $0x1,%edi
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	85 ff                	test   %edi,%edi
  8004fa:	7f ee                	jg     8004ea <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800502:	e9 78 01 00 00       	jmp    80067f <vprintfmt+0x3d5>
  800507:	89 df                	mov    %ebx,%edi
  800509:	8b 75 08             	mov    0x8(%ebp),%esi
  80050c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050f:	eb e7                	jmp    8004f8 <vprintfmt+0x24e>
	if (lflag >= 2)
  800511:	83 f9 01             	cmp    $0x1,%ecx
  800514:	7e 3f                	jle    800555 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800516:	8b 45 14             	mov    0x14(%ebp),%eax
  800519:	8b 50 04             	mov    0x4(%eax),%edx
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800521:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8d 40 08             	lea    0x8(%eax),%eax
  80052a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80052d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800531:	79 5c                	jns    80058f <vprintfmt+0x2e5>
				putch('-', putdat);
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	53                   	push   %ebx
  800537:	6a 2d                	push   $0x2d
  800539:	ff d6                	call   *%esi
				num = -(long long) num;
  80053b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800541:	f7 da                	neg    %edx
  800543:	83 d1 00             	adc    $0x0,%ecx
  800546:	f7 d9                	neg    %ecx
  800548:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80054b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800550:	e9 10 01 00 00       	jmp    800665 <vprintfmt+0x3bb>
	else if (lflag)
  800555:	85 c9                	test   %ecx,%ecx
  800557:	75 1b                	jne    800574 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800561:	89 c1                	mov    %eax,%ecx
  800563:	c1 f9 1f             	sar    $0x1f,%ecx
  800566:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8d 40 04             	lea    0x4(%eax),%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
  800572:	eb b9                	jmp    80052d <vprintfmt+0x283>
		return va_arg(*ap, long);
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8b 00                	mov    (%eax),%eax
  800579:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057c:	89 c1                	mov    %eax,%ecx
  80057e:	c1 f9 1f             	sar    $0x1f,%ecx
  800581:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8d 40 04             	lea    0x4(%eax),%eax
  80058a:	89 45 14             	mov    %eax,0x14(%ebp)
  80058d:	eb 9e                	jmp    80052d <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80058f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800592:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800595:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059a:	e9 c6 00 00 00       	jmp    800665 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80059f:	83 f9 01             	cmp    $0x1,%ecx
  8005a2:	7e 18                	jle    8005bc <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8b 10                	mov    (%eax),%edx
  8005a9:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ac:	8d 40 08             	lea    0x8(%eax),%eax
  8005af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b7:	e9 a9 00 00 00       	jmp    800665 <vprintfmt+0x3bb>
	else if (lflag)
  8005bc:	85 c9                	test   %ecx,%ecx
  8005be:	75 1a                	jne    8005da <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	8b 10                	mov    (%eax),%edx
  8005c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ca:	8d 40 04             	lea    0x4(%eax),%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d5:	e9 8b 00 00 00       	jmp    800665 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	8b 10                	mov    (%eax),%edx
  8005df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e4:	8d 40 04             	lea    0x4(%eax),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ef:	eb 74                	jmp    800665 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005f1:	83 f9 01             	cmp    $0x1,%ecx
  8005f4:	7e 15                	jle    80060b <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8005f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f9:	8b 10                	mov    (%eax),%edx
  8005fb:	8b 48 04             	mov    0x4(%eax),%ecx
  8005fe:	8d 40 08             	lea    0x8(%eax),%eax
  800601:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800604:	b8 08 00 00 00       	mov    $0x8,%eax
  800609:	eb 5a                	jmp    800665 <vprintfmt+0x3bb>
	else if (lflag)
  80060b:	85 c9                	test   %ecx,%ecx
  80060d:	75 17                	jne    800626 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	8b 10                	mov    (%eax),%edx
  800614:	b9 00 00 00 00       	mov    $0x0,%ecx
  800619:	8d 40 04             	lea    0x4(%eax),%eax
  80061c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80061f:	b8 08 00 00 00       	mov    $0x8,%eax
  800624:	eb 3f                	jmp    800665 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8b 10                	mov    (%eax),%edx
  80062b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800630:	8d 40 04             	lea    0x4(%eax),%eax
  800633:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800636:	b8 08 00 00 00       	mov    $0x8,%eax
  80063b:	eb 28                	jmp    800665 <vprintfmt+0x3bb>
			putch('0', putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	6a 30                	push   $0x30
  800643:	ff d6                	call   *%esi
			putch('x', putdat);
  800645:	83 c4 08             	add    $0x8,%esp
  800648:	53                   	push   %ebx
  800649:	6a 78                	push   $0x78
  80064b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8b 10                	mov    (%eax),%edx
  800652:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800657:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80065a:	8d 40 04             	lea    0x4(%eax),%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800660:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800665:	83 ec 0c             	sub    $0xc,%esp
  800668:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80066c:	57                   	push   %edi
  80066d:	ff 75 e0             	pushl  -0x20(%ebp)
  800670:	50                   	push   %eax
  800671:	51                   	push   %ecx
  800672:	52                   	push   %edx
  800673:	89 da                	mov    %ebx,%edx
  800675:	89 f0                	mov    %esi,%eax
  800677:	e8 45 fb ff ff       	call   8001c1 <printnum>
			break;
  80067c:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80067f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  800682:	83 c7 01             	add    $0x1,%edi
  800685:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800689:	83 f8 25             	cmp    $0x25,%eax
  80068c:	0f 84 2f fc ff ff    	je     8002c1 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  800692:	85 c0                	test   %eax,%eax
  800694:	0f 84 8b 00 00 00    	je     800725 <vprintfmt+0x47b>
			putch(ch, putdat);
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	53                   	push   %ebx
  80069e:	50                   	push   %eax
  80069f:	ff d6                	call   *%esi
  8006a1:	83 c4 10             	add    $0x10,%esp
  8006a4:	eb dc                	jmp    800682 <vprintfmt+0x3d8>
	if (lflag >= 2)
  8006a6:	83 f9 01             	cmp    $0x1,%ecx
  8006a9:	7e 15                	jle    8006c0 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8b 10                	mov    (%eax),%edx
  8006b0:	8b 48 04             	mov    0x4(%eax),%ecx
  8006b3:	8d 40 08             	lea    0x8(%eax),%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b9:	b8 10 00 00 00       	mov    $0x10,%eax
  8006be:	eb a5                	jmp    800665 <vprintfmt+0x3bb>
	else if (lflag)
  8006c0:	85 c9                	test   %ecx,%ecx
  8006c2:	75 17                	jne    8006db <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 10                	mov    (%eax),%edx
  8006c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ce:	8d 40 04             	lea    0x4(%eax),%eax
  8006d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d4:	b8 10 00 00 00       	mov    $0x10,%eax
  8006d9:	eb 8a                	jmp    800665 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8b 10                	mov    (%eax),%edx
  8006e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e5:	8d 40 04             	lea    0x4(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006eb:	b8 10 00 00 00       	mov    $0x10,%eax
  8006f0:	e9 70 ff ff ff       	jmp    800665 <vprintfmt+0x3bb>
			putch(ch, putdat);
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	53                   	push   %ebx
  8006f9:	6a 25                	push   $0x25
  8006fb:	ff d6                	call   *%esi
			break;
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	e9 7a ff ff ff       	jmp    80067f <vprintfmt+0x3d5>
			putch('%', putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	53                   	push   %ebx
  800709:	6a 25                	push   $0x25
  80070b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80070d:	83 c4 10             	add    $0x10,%esp
  800710:	89 f8                	mov    %edi,%eax
  800712:	eb 03                	jmp    800717 <vprintfmt+0x46d>
  800714:	83 e8 01             	sub    $0x1,%eax
  800717:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80071b:	75 f7                	jne    800714 <vprintfmt+0x46a>
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800720:	e9 5a ff ff ff       	jmp    80067f <vprintfmt+0x3d5>
}
  800725:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800728:	5b                   	pop    %ebx
  800729:	5e                   	pop    %esi
  80072a:	5f                   	pop    %edi
  80072b:	5d                   	pop    %ebp
  80072c:	c3                   	ret    

0080072d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
  800730:	83 ec 18             	sub    $0x18,%esp
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800739:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80073c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800740:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800743:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80074a:	85 c0                	test   %eax,%eax
  80074c:	74 26                	je     800774 <vsnprintf+0x47>
  80074e:	85 d2                	test   %edx,%edx
  800750:	7e 22                	jle    800774 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800752:	ff 75 14             	pushl  0x14(%ebp)
  800755:	ff 75 10             	pushl  0x10(%ebp)
  800758:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80075b:	50                   	push   %eax
  80075c:	68 70 02 80 00       	push   $0x800270
  800761:	e8 44 fb ff ff       	call   8002aa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800769:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80076c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80076f:	83 c4 10             	add    $0x10,%esp
}
  800772:	c9                   	leave  
  800773:	c3                   	ret    
		return -E_INVAL;
  800774:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800779:	eb f7                	jmp    800772 <vsnprintf+0x45>

0080077b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800781:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800784:	50                   	push   %eax
  800785:	ff 75 10             	pushl  0x10(%ebp)
  800788:	ff 75 0c             	pushl  0xc(%ebp)
  80078b:	ff 75 08             	pushl  0x8(%ebp)
  80078e:	e8 9a ff ff ff       	call   80072d <vsnprintf>
	va_end(ap);

	return rc;
}
  800793:	c9                   	leave  
  800794:	c3                   	ret    

00800795 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800795:	55                   	push   %ebp
  800796:	89 e5                	mov    %esp,%ebp
  800798:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80079b:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a0:	eb 03                	jmp    8007a5 <strlen+0x10>
		n++;
  8007a2:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007a5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a9:	75 f7                	jne    8007a2 <strlen+0xd>
	return n;
}
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007bb:	eb 03                	jmp    8007c0 <strnlen+0x13>
		n++;
  8007bd:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007c0:	39 d0                	cmp    %edx,%eax
  8007c2:	74 06                	je     8007ca <strnlen+0x1d>
  8007c4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007c8:	75 f3                	jne    8007bd <strnlen+0x10>
	return n;
}
  8007ca:	5d                   	pop    %ebp
  8007cb:	c3                   	ret    

008007cc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	53                   	push   %ebx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d6:	89 c2                	mov    %eax,%edx
  8007d8:	83 c1 01             	add    $0x1,%ecx
  8007db:	83 c2 01             	add    $0x1,%edx
  8007de:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007e2:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007e5:	84 db                	test   %bl,%bl
  8007e7:	75 ef                	jne    8007d8 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007e9:	5b                   	pop    %ebx
  8007ea:	5d                   	pop    %ebp
  8007eb:	c3                   	ret    

008007ec <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	53                   	push   %ebx
  8007f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007f3:	53                   	push   %ebx
  8007f4:	e8 9c ff ff ff       	call   800795 <strlen>
  8007f9:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007fc:	ff 75 0c             	pushl  0xc(%ebp)
  8007ff:	01 d8                	add    %ebx,%eax
  800801:	50                   	push   %eax
  800802:	e8 c5 ff ff ff       	call   8007cc <strcpy>
	return dst;
}
  800807:	89 d8                	mov    %ebx,%eax
  800809:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80080c:	c9                   	leave  
  80080d:	c3                   	ret    

0080080e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	56                   	push   %esi
  800812:	53                   	push   %ebx
  800813:	8b 75 08             	mov    0x8(%ebp),%esi
  800816:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800819:	89 f3                	mov    %esi,%ebx
  80081b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80081e:	89 f2                	mov    %esi,%edx
  800820:	eb 0f                	jmp    800831 <strncpy+0x23>
		*dst++ = *src;
  800822:	83 c2 01             	add    $0x1,%edx
  800825:	0f b6 01             	movzbl (%ecx),%eax
  800828:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80082b:	80 39 01             	cmpb   $0x1,(%ecx)
  80082e:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800831:	39 da                	cmp    %ebx,%edx
  800833:	75 ed                	jne    800822 <strncpy+0x14>
	}
	return ret;
}
  800835:	89 f0                	mov    %esi,%eax
  800837:	5b                   	pop    %ebx
  800838:	5e                   	pop    %esi
  800839:	5d                   	pop    %ebp
  80083a:	c3                   	ret    

0080083b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80083b:	55                   	push   %ebp
  80083c:	89 e5                	mov    %esp,%ebp
  80083e:	56                   	push   %esi
  80083f:	53                   	push   %ebx
  800840:	8b 75 08             	mov    0x8(%ebp),%esi
  800843:	8b 55 0c             	mov    0xc(%ebp),%edx
  800846:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800849:	89 f0                	mov    %esi,%eax
  80084b:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80084f:	85 c9                	test   %ecx,%ecx
  800851:	75 0b                	jne    80085e <strlcpy+0x23>
  800853:	eb 17                	jmp    80086c <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800855:	83 c2 01             	add    $0x1,%edx
  800858:	83 c0 01             	add    $0x1,%eax
  80085b:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80085e:	39 d8                	cmp    %ebx,%eax
  800860:	74 07                	je     800869 <strlcpy+0x2e>
  800862:	0f b6 0a             	movzbl (%edx),%ecx
  800865:	84 c9                	test   %cl,%cl
  800867:	75 ec                	jne    800855 <strlcpy+0x1a>
		*dst = '\0';
  800869:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80086c:	29 f0                	sub    %esi,%eax
}
  80086e:	5b                   	pop    %ebx
  80086f:	5e                   	pop    %esi
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800878:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80087b:	eb 06                	jmp    800883 <strcmp+0x11>
		p++, q++;
  80087d:	83 c1 01             	add    $0x1,%ecx
  800880:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800883:	0f b6 01             	movzbl (%ecx),%eax
  800886:	84 c0                	test   %al,%al
  800888:	74 04                	je     80088e <strcmp+0x1c>
  80088a:	3a 02                	cmp    (%edx),%al
  80088c:	74 ef                	je     80087d <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80088e:	0f b6 c0             	movzbl %al,%eax
  800891:	0f b6 12             	movzbl (%edx),%edx
  800894:	29 d0                	sub    %edx,%eax
}
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	53                   	push   %ebx
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a2:	89 c3                	mov    %eax,%ebx
  8008a4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008a7:	eb 06                	jmp    8008af <strncmp+0x17>
		n--, p++, q++;
  8008a9:	83 c0 01             	add    $0x1,%eax
  8008ac:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008af:	39 d8                	cmp    %ebx,%eax
  8008b1:	74 16                	je     8008c9 <strncmp+0x31>
  8008b3:	0f b6 08             	movzbl (%eax),%ecx
  8008b6:	84 c9                	test   %cl,%cl
  8008b8:	74 04                	je     8008be <strncmp+0x26>
  8008ba:	3a 0a                	cmp    (%edx),%cl
  8008bc:	74 eb                	je     8008a9 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008be:	0f b6 00             	movzbl (%eax),%eax
  8008c1:	0f b6 12             	movzbl (%edx),%edx
  8008c4:	29 d0                	sub    %edx,%eax
}
  8008c6:	5b                   	pop    %ebx
  8008c7:	5d                   	pop    %ebp
  8008c8:	c3                   	ret    
		return 0;
  8008c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ce:	eb f6                	jmp    8008c6 <strncmp+0x2e>

008008d0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008da:	0f b6 10             	movzbl (%eax),%edx
  8008dd:	84 d2                	test   %dl,%dl
  8008df:	74 09                	je     8008ea <strchr+0x1a>
		if (*s == c)
  8008e1:	38 ca                	cmp    %cl,%dl
  8008e3:	74 0a                	je     8008ef <strchr+0x1f>
	for (; *s; s++)
  8008e5:	83 c0 01             	add    $0x1,%eax
  8008e8:	eb f0                	jmp    8008da <strchr+0xa>
			return (char *) s;
	return 0;
  8008ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fb:	eb 03                	jmp    800900 <strfind+0xf>
  8008fd:	83 c0 01             	add    $0x1,%eax
  800900:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800903:	38 ca                	cmp    %cl,%dl
  800905:	74 04                	je     80090b <strfind+0x1a>
  800907:	84 d2                	test   %dl,%dl
  800909:	75 f2                	jne    8008fd <strfind+0xc>
			break;
	return (char *) s;
}
  80090b:	5d                   	pop    %ebp
  80090c:	c3                   	ret    

0080090d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80090d:	55                   	push   %ebp
  80090e:	89 e5                	mov    %esp,%ebp
  800910:	57                   	push   %edi
  800911:	56                   	push   %esi
  800912:	53                   	push   %ebx
  800913:	8b 7d 08             	mov    0x8(%ebp),%edi
  800916:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800919:	85 c9                	test   %ecx,%ecx
  80091b:	74 13                	je     800930 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80091d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800923:	75 05                	jne    80092a <memset+0x1d>
  800925:	f6 c1 03             	test   $0x3,%cl
  800928:	74 0d                	je     800937 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80092a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092d:	fc                   	cld    
  80092e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800930:	89 f8                	mov    %edi,%eax
  800932:	5b                   	pop    %ebx
  800933:	5e                   	pop    %esi
  800934:	5f                   	pop    %edi
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    
		c &= 0xFF;
  800937:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80093b:	89 d3                	mov    %edx,%ebx
  80093d:	c1 e3 08             	shl    $0x8,%ebx
  800940:	89 d0                	mov    %edx,%eax
  800942:	c1 e0 18             	shl    $0x18,%eax
  800945:	89 d6                	mov    %edx,%esi
  800947:	c1 e6 10             	shl    $0x10,%esi
  80094a:	09 f0                	or     %esi,%eax
  80094c:	09 c2                	or     %eax,%edx
  80094e:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800950:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800953:	89 d0                	mov    %edx,%eax
  800955:	fc                   	cld    
  800956:	f3 ab                	rep stos %eax,%es:(%edi)
  800958:	eb d6                	jmp    800930 <memset+0x23>

0080095a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	57                   	push   %edi
  80095e:	56                   	push   %esi
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 75 0c             	mov    0xc(%ebp),%esi
  800965:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800968:	39 c6                	cmp    %eax,%esi
  80096a:	73 35                	jae    8009a1 <memmove+0x47>
  80096c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80096f:	39 c2                	cmp    %eax,%edx
  800971:	76 2e                	jbe    8009a1 <memmove+0x47>
		s += n;
		d += n;
  800973:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800976:	89 d6                	mov    %edx,%esi
  800978:	09 fe                	or     %edi,%esi
  80097a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800980:	74 0c                	je     80098e <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800982:	83 ef 01             	sub    $0x1,%edi
  800985:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800988:	fd                   	std    
  800989:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80098b:	fc                   	cld    
  80098c:	eb 21                	jmp    8009af <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098e:	f6 c1 03             	test   $0x3,%cl
  800991:	75 ef                	jne    800982 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800993:	83 ef 04             	sub    $0x4,%edi
  800996:	8d 72 fc             	lea    -0x4(%edx),%esi
  800999:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80099c:	fd                   	std    
  80099d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80099f:	eb ea                	jmp    80098b <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a1:	89 f2                	mov    %esi,%edx
  8009a3:	09 c2                	or     %eax,%edx
  8009a5:	f6 c2 03             	test   $0x3,%dl
  8009a8:	74 09                	je     8009b3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009aa:	89 c7                	mov    %eax,%edi
  8009ac:	fc                   	cld    
  8009ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009af:	5e                   	pop    %esi
  8009b0:	5f                   	pop    %edi
  8009b1:	5d                   	pop    %ebp
  8009b2:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b3:	f6 c1 03             	test   $0x3,%cl
  8009b6:	75 f2                	jne    8009aa <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009b8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009bb:	89 c7                	mov    %eax,%edi
  8009bd:	fc                   	cld    
  8009be:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c0:	eb ed                	jmp    8009af <memmove+0x55>

008009c2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009c5:	ff 75 10             	pushl  0x10(%ebp)
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	ff 75 08             	pushl  0x8(%ebp)
  8009ce:	e8 87 ff ff ff       	call   80095a <memmove>
}
  8009d3:	c9                   	leave  
  8009d4:	c3                   	ret    

008009d5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	56                   	push   %esi
  8009d9:	53                   	push   %ebx
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e0:	89 c6                	mov    %eax,%esi
  8009e2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009e5:	39 f0                	cmp    %esi,%eax
  8009e7:	74 1c                	je     800a05 <memcmp+0x30>
		if (*s1 != *s2)
  8009e9:	0f b6 08             	movzbl (%eax),%ecx
  8009ec:	0f b6 1a             	movzbl (%edx),%ebx
  8009ef:	38 d9                	cmp    %bl,%cl
  8009f1:	75 08                	jne    8009fb <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009f3:	83 c0 01             	add    $0x1,%eax
  8009f6:	83 c2 01             	add    $0x1,%edx
  8009f9:	eb ea                	jmp    8009e5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009fb:	0f b6 c1             	movzbl %cl,%eax
  8009fe:	0f b6 db             	movzbl %bl,%ebx
  800a01:	29 d8                	sub    %ebx,%eax
  800a03:	eb 05                	jmp    800a0a <memcmp+0x35>
	}

	return 0;
  800a05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0a:	5b                   	pop    %ebx
  800a0b:	5e                   	pop    %esi
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    

00800a0e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a17:	89 c2                	mov    %eax,%edx
  800a19:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a1c:	39 d0                	cmp    %edx,%eax
  800a1e:	73 09                	jae    800a29 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a20:	38 08                	cmp    %cl,(%eax)
  800a22:	74 05                	je     800a29 <memfind+0x1b>
	for (; s < ends; s++)
  800a24:	83 c0 01             	add    $0x1,%eax
  800a27:	eb f3                	jmp    800a1c <memfind+0xe>
			break;
	return (void *) s;
}
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	57                   	push   %edi
  800a2f:	56                   	push   %esi
  800a30:	53                   	push   %ebx
  800a31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a34:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a37:	eb 03                	jmp    800a3c <strtol+0x11>
		s++;
  800a39:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a3c:	0f b6 01             	movzbl (%ecx),%eax
  800a3f:	3c 20                	cmp    $0x20,%al
  800a41:	74 f6                	je     800a39 <strtol+0xe>
  800a43:	3c 09                	cmp    $0x9,%al
  800a45:	74 f2                	je     800a39 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a47:	3c 2b                	cmp    $0x2b,%al
  800a49:	74 2e                	je     800a79 <strtol+0x4e>
	int neg = 0;
  800a4b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a50:	3c 2d                	cmp    $0x2d,%al
  800a52:	74 2f                	je     800a83 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a54:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a5a:	75 05                	jne    800a61 <strtol+0x36>
  800a5c:	80 39 30             	cmpb   $0x30,(%ecx)
  800a5f:	74 2c                	je     800a8d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a61:	85 db                	test   %ebx,%ebx
  800a63:	75 0a                	jne    800a6f <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a65:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a6a:	80 39 30             	cmpb   $0x30,(%ecx)
  800a6d:	74 28                	je     800a97 <strtol+0x6c>
		base = 10;
  800a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a74:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a77:	eb 50                	jmp    800ac9 <strtol+0x9e>
		s++;
  800a79:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a7c:	bf 00 00 00 00       	mov    $0x0,%edi
  800a81:	eb d1                	jmp    800a54 <strtol+0x29>
		s++, neg = 1;
  800a83:	83 c1 01             	add    $0x1,%ecx
  800a86:	bf 01 00 00 00       	mov    $0x1,%edi
  800a8b:	eb c7                	jmp    800a54 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a8d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a91:	74 0e                	je     800aa1 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a93:	85 db                	test   %ebx,%ebx
  800a95:	75 d8                	jne    800a6f <strtol+0x44>
		s++, base = 8;
  800a97:	83 c1 01             	add    $0x1,%ecx
  800a9a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a9f:	eb ce                	jmp    800a6f <strtol+0x44>
		s += 2, base = 16;
  800aa1:	83 c1 02             	add    $0x2,%ecx
  800aa4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aa9:	eb c4                	jmp    800a6f <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800aab:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aae:	89 f3                	mov    %esi,%ebx
  800ab0:	80 fb 19             	cmp    $0x19,%bl
  800ab3:	77 29                	ja     800ade <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ab5:	0f be d2             	movsbl %dl,%edx
  800ab8:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800abb:	3b 55 10             	cmp    0x10(%ebp),%edx
  800abe:	7d 30                	jge    800af0 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ac0:	83 c1 01             	add    $0x1,%ecx
  800ac3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ac7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ac9:	0f b6 11             	movzbl (%ecx),%edx
  800acc:	8d 72 d0             	lea    -0x30(%edx),%esi
  800acf:	89 f3                	mov    %esi,%ebx
  800ad1:	80 fb 09             	cmp    $0x9,%bl
  800ad4:	77 d5                	ja     800aab <strtol+0x80>
			dig = *s - '0';
  800ad6:	0f be d2             	movsbl %dl,%edx
  800ad9:	83 ea 30             	sub    $0x30,%edx
  800adc:	eb dd                	jmp    800abb <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ade:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ae1:	89 f3                	mov    %esi,%ebx
  800ae3:	80 fb 19             	cmp    $0x19,%bl
  800ae6:	77 08                	ja     800af0 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ae8:	0f be d2             	movsbl %dl,%edx
  800aeb:	83 ea 37             	sub    $0x37,%edx
  800aee:	eb cb                	jmp    800abb <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800af0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af4:	74 05                	je     800afb <strtol+0xd0>
		*endptr = (char *) s;
  800af6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800afb:	89 c2                	mov    %eax,%edx
  800afd:	f7 da                	neg    %edx
  800aff:	85 ff                	test   %edi,%edi
  800b01:	0f 45 c2             	cmovne %edx,%eax
}
  800b04:	5b                   	pop    %ebx
  800b05:	5e                   	pop    %esi
  800b06:	5f                   	pop    %edi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	57                   	push   %edi
  800b0d:	56                   	push   %esi
  800b0e:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b14:	8b 55 08             	mov    0x8(%ebp),%edx
  800b17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b1a:	89 c3                	mov    %eax,%ebx
  800b1c:	89 c7                	mov    %eax,%edi
  800b1e:	89 c6                	mov    %eax,%esi
  800b20:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b22:	5b                   	pop    %ebx
  800b23:	5e                   	pop    %esi
  800b24:	5f                   	pop    %edi
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	57                   	push   %edi
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b32:	b8 01 00 00 00       	mov    $0x1,%eax
  800b37:	89 d1                	mov    %edx,%ecx
  800b39:	89 d3                	mov    %edx,%ebx
  800b3b:	89 d7                	mov    %edx,%edi
  800b3d:	89 d6                	mov    %edx,%esi
  800b3f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b41:	5b                   	pop    %ebx
  800b42:	5e                   	pop    %esi
  800b43:	5f                   	pop    %edi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	57                   	push   %edi
  800b4a:	56                   	push   %esi
  800b4b:	53                   	push   %ebx
  800b4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b4f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b54:	8b 55 08             	mov    0x8(%ebp),%edx
  800b57:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5c:	89 cb                	mov    %ecx,%ebx
  800b5e:	89 cf                	mov    %ecx,%edi
  800b60:	89 ce                	mov    %ecx,%esi
  800b62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b64:	85 c0                	test   %eax,%eax
  800b66:	7f 08                	jg     800b70 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5f                   	pop    %edi
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b70:	83 ec 0c             	sub    $0xc,%esp
  800b73:	50                   	push   %eax
  800b74:	6a 03                	push   $0x3
  800b76:	68 bf 17 80 00       	push   $0x8017bf
  800b7b:	6a 23                	push   $0x23
  800b7d:	68 dc 17 80 00       	push   $0x8017dc
  800b82:	e8 e1 05 00 00       	call   801168 <_panic>

00800b87 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	57                   	push   %edi
  800b8b:	56                   	push   %esi
  800b8c:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b92:	b8 02 00 00 00       	mov    $0x2,%eax
  800b97:	89 d1                	mov    %edx,%ecx
  800b99:	89 d3                	mov    %edx,%ebx
  800b9b:	89 d7                	mov    %edx,%edi
  800b9d:	89 d6                	mov    %edx,%esi
  800b9f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ba1:	5b                   	pop    %ebx
  800ba2:	5e                   	pop    %esi
  800ba3:	5f                   	pop    %edi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <sys_yield>:

void
sys_yield(void)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	57                   	push   %edi
  800baa:	56                   	push   %esi
  800bab:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bac:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bb6:	89 d1                	mov    %edx,%ecx
  800bb8:	89 d3                	mov    %edx,%ebx
  800bba:	89 d7                	mov    %edx,%edi
  800bbc:	89 d6                	mov    %edx,%esi
  800bbe:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bc0:	5b                   	pop    %ebx
  800bc1:	5e                   	pop    %esi
  800bc2:	5f                   	pop    %edi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	57                   	push   %edi
  800bc9:	56                   	push   %esi
  800bca:	53                   	push   %ebx
  800bcb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bce:	be 00 00 00 00       	mov    $0x0,%esi
  800bd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd9:	b8 04 00 00 00       	mov    $0x4,%eax
  800bde:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800be1:	89 f7                	mov    %esi,%edi
  800be3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800be5:	85 c0                	test   %eax,%eax
  800be7:	7f 08                	jg     800bf1 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800be9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bec:	5b                   	pop    %ebx
  800bed:	5e                   	pop    %esi
  800bee:	5f                   	pop    %edi
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf1:	83 ec 0c             	sub    $0xc,%esp
  800bf4:	50                   	push   %eax
  800bf5:	6a 04                	push   $0x4
  800bf7:	68 bf 17 80 00       	push   $0x8017bf
  800bfc:	6a 23                	push   $0x23
  800bfe:	68 dc 17 80 00       	push   $0x8017dc
  800c03:	e8 60 05 00 00       	call   801168 <_panic>

00800c08 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	57                   	push   %edi
  800c0c:	56                   	push   %esi
  800c0d:	53                   	push   %ebx
  800c0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c11:	8b 55 08             	mov    0x8(%ebp),%edx
  800c14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c17:	b8 05 00 00 00       	mov    $0x5,%eax
  800c1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c22:	8b 75 18             	mov    0x18(%ebp),%esi
  800c25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c27:	85 c0                	test   %eax,%eax
  800c29:	7f 08                	jg     800c33 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2e:	5b                   	pop    %ebx
  800c2f:	5e                   	pop    %esi
  800c30:	5f                   	pop    %edi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c33:	83 ec 0c             	sub    $0xc,%esp
  800c36:	50                   	push   %eax
  800c37:	6a 05                	push   $0x5
  800c39:	68 bf 17 80 00       	push   $0x8017bf
  800c3e:	6a 23                	push   $0x23
  800c40:	68 dc 17 80 00       	push   $0x8017dc
  800c45:	e8 1e 05 00 00       	call   801168 <_panic>

00800c4a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	57                   	push   %edi
  800c4e:	56                   	push   %esi
  800c4f:	53                   	push   %ebx
  800c50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c58:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5e:	b8 06 00 00 00       	mov    $0x6,%eax
  800c63:	89 df                	mov    %ebx,%edi
  800c65:	89 de                	mov    %ebx,%esi
  800c67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c69:	85 c0                	test   %eax,%eax
  800c6b:	7f 08                	jg     800c75 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5f                   	pop    %edi
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c75:	83 ec 0c             	sub    $0xc,%esp
  800c78:	50                   	push   %eax
  800c79:	6a 06                	push   $0x6
  800c7b:	68 bf 17 80 00       	push   $0x8017bf
  800c80:	6a 23                	push   $0x23
  800c82:	68 dc 17 80 00       	push   $0x8017dc
  800c87:	e8 dc 04 00 00       	call   801168 <_panic>

00800c8c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
  800c92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca0:	b8 08 00 00 00       	mov    $0x8,%eax
  800ca5:	89 df                	mov    %ebx,%edi
  800ca7:	89 de                	mov    %ebx,%esi
  800ca9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cab:	85 c0                	test   %eax,%eax
  800cad:	7f 08                	jg     800cb7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb2:	5b                   	pop    %ebx
  800cb3:	5e                   	pop    %esi
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb7:	83 ec 0c             	sub    $0xc,%esp
  800cba:	50                   	push   %eax
  800cbb:	6a 08                	push   $0x8
  800cbd:	68 bf 17 80 00       	push   $0x8017bf
  800cc2:	6a 23                	push   $0x23
  800cc4:	68 dc 17 80 00       	push   $0x8017dc
  800cc9:	e8 9a 04 00 00       	call   801168 <_panic>

00800cce <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	57                   	push   %edi
  800cd2:	56                   	push   %esi
  800cd3:	53                   	push   %ebx
  800cd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800cd7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce2:	b8 09 00 00 00       	mov    $0x9,%eax
  800ce7:	89 df                	mov    %ebx,%edi
  800ce9:	89 de                	mov    %ebx,%esi
  800ceb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ced:	85 c0                	test   %eax,%eax
  800cef:	7f 08                	jg     800cf9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf9:	83 ec 0c             	sub    $0xc,%esp
  800cfc:	50                   	push   %eax
  800cfd:	6a 09                	push   $0x9
  800cff:	68 bf 17 80 00       	push   $0x8017bf
  800d04:	6a 23                	push   $0x23
  800d06:	68 dc 17 80 00       	push   $0x8017dc
  800d0b:	e8 58 04 00 00       	call   801168 <_panic>

00800d10 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	57                   	push   %edi
  800d14:	56                   	push   %esi
  800d15:	53                   	push   %ebx
  800d16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d19:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d24:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d29:	89 df                	mov    %ebx,%edi
  800d2b:	89 de                	mov    %ebx,%esi
  800d2d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2f:	85 c0                	test   %eax,%eax
  800d31:	7f 08                	jg     800d3b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d36:	5b                   	pop    %ebx
  800d37:	5e                   	pop    %esi
  800d38:	5f                   	pop    %edi
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3b:	83 ec 0c             	sub    $0xc,%esp
  800d3e:	50                   	push   %eax
  800d3f:	6a 0a                	push   $0xa
  800d41:	68 bf 17 80 00       	push   $0x8017bf
  800d46:	6a 23                	push   $0x23
  800d48:	68 dc 17 80 00       	push   $0x8017dc
  800d4d:	e8 16 04 00 00       	call   801168 <_panic>

00800d52 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	57                   	push   %edi
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d58:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d63:	be 00 00 00 00       	mov    $0x0,%esi
  800d68:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d6e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
  800d86:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d8b:	89 cb                	mov    %ecx,%ebx
  800d8d:	89 cf                	mov    %ecx,%edi
  800d8f:	89 ce                	mov    %ecx,%esi
  800d91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d93:	85 c0                	test   %eax,%eax
  800d95:	7f 08                	jg     800d9f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9f:	83 ec 0c             	sub    $0xc,%esp
  800da2:	50                   	push   %eax
  800da3:	6a 0d                	push   $0xd
  800da5:	68 bf 17 80 00       	push   $0x8017bf
  800daa:	6a 23                	push   $0x23
  800dac:	68 dc 17 80 00       	push   $0x8017dc
  800db1:	e8 b2 03 00 00       	call   801168 <_panic>

00800db6 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	53                   	push   %ebx
  800dba:	83 ec 04             	sub    $0x4,%esp
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800dc0:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) { //只有因为写操作写时拷贝的地址这中情况，才可以抢救。否则一律panic
  800dc2:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800dc6:	74 74                	je     800e3c <pgfault+0x86>
  800dc8:	89 d8                	mov    %ebx,%eax
  800dca:	c1 e8 0c             	shr    $0xc,%eax
  800dcd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800dd4:	f6 c4 08             	test   $0x8,%ah
  800dd7:	74 63                	je     800e3c <pgfault+0x86>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800dd9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, PFTEMP, PTE_U|PTE_P)) < 0)		//将当前进程PFTEMP也映射到当前进程addr指向的物理页
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	6a 05                	push   $0x5
  800de4:	68 00 f0 7f 00       	push   $0x7ff000
  800de9:	6a 00                	push   $0x0
  800deb:	53                   	push   %ebx
  800dec:	6a 00                	push   $0x0
  800dee:	e8 15 fe ff ff       	call   800c08 <sys_page_map>
  800df3:	83 c4 20             	add    $0x20,%esp
  800df6:	85 c0                	test   %eax,%eax
  800df8:	78 56                	js     800e50 <pgfault+0x9a>
		panic("sys_page_map: %e", r);
	if ((r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W)) < 0)	//令当前进程addr指向新分配的物理页
  800dfa:	83 ec 04             	sub    $0x4,%esp
  800dfd:	6a 07                	push   $0x7
  800dff:	53                   	push   %ebx
  800e00:	6a 00                	push   $0x0
  800e02:	e8 be fd ff ff       	call   800bc5 <sys_page_alloc>
  800e07:	83 c4 10             	add    $0x10,%esp
  800e0a:	85 c0                	test   %eax,%eax
  800e0c:	78 54                	js     800e62 <pgfault+0xac>
		panic("sys_page_alloc: %e", r);
	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800e0e:	83 ec 04             	sub    $0x4,%esp
  800e11:	68 00 10 00 00       	push   $0x1000
  800e16:	68 00 f0 7f 00       	push   $0x7ff000
  800e1b:	53                   	push   %ebx
  800e1c:	e8 39 fb ff ff       	call   80095a <memmove>
	if ((r = sys_page_unmap(0, PFTEMP)) < 0)					//解除当前进程PFTEMP映射
  800e21:	83 c4 08             	add    $0x8,%esp
  800e24:	68 00 f0 7f 00       	push   $0x7ff000
  800e29:	6a 00                	push   $0x0
  800e2b:	e8 1a fe ff ff       	call   800c4a <sys_page_unmap>
  800e30:	83 c4 10             	add    $0x10,%esp
  800e33:	85 c0                	test   %eax,%eax
  800e35:	78 3d                	js     800e74 <pgfault+0xbe>
		panic("sys_page_unmap: %e", r);
}
  800e37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    
		panic("pgfault():not cow");
  800e3c:	83 ec 04             	sub    $0x4,%esp
  800e3f:	68 ea 17 80 00       	push   $0x8017ea
  800e44:	6a 1d                	push   $0x1d
  800e46:	68 fc 17 80 00       	push   $0x8017fc
  800e4b:	e8 18 03 00 00       	call   801168 <_panic>
		panic("sys_page_map: %e", r);
  800e50:	50                   	push   %eax
  800e51:	68 07 18 80 00       	push   $0x801807
  800e56:	6a 2a                	push   $0x2a
  800e58:	68 fc 17 80 00       	push   $0x8017fc
  800e5d:	e8 06 03 00 00       	call   801168 <_panic>
		panic("sys_page_alloc: %e", r);
  800e62:	50                   	push   %eax
  800e63:	68 18 18 80 00       	push   $0x801818
  800e68:	6a 2c                	push   $0x2c
  800e6a:	68 fc 17 80 00       	push   $0x8017fc
  800e6f:	e8 f4 02 00 00       	call   801168 <_panic>
		panic("sys_page_unmap: %e", r);
  800e74:	50                   	push   %eax
  800e75:	68 2b 18 80 00       	push   $0x80182b
  800e7a:	6a 2f                	push   $0x2f
  800e7c:	68 fc 17 80 00       	push   $0x8017fc
  800e81:	e8 e2 02 00 00       	call   801168 <_panic>

00800e86 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
  800e8c:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);	//设置缺页处理函数
  800e8f:	68 b6 0d 80 00       	push   $0x800db6
  800e94:	e8 15 03 00 00       	call   8011ae <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800e99:	b8 07 00 00 00       	mov    $0x7,%eax
  800e9e:	cd 30                	int    $0x30
  800ea0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();	//系统调用，只是简单创建一个Env结构，复制当前用户环境寄存器状态，UTOP以下的页目录还没有建立
	if (envid == 0) {				//子进程将走这个逻辑
  800ea3:	83 c4 10             	add    $0x10,%esp
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	74 12                	je     800ebc <fork+0x36>
  800eaa:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	if (envid < 0) {
  800eac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eb0:	78 26                	js     800ed8 <fork+0x52>
		panic("sys_exofork: %e", envid);
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800eb2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb7:	e9 94 00 00 00       	jmp    800f50 <fork+0xca>
		thisenv = &envs[ENVX(sys_getenvid())];
  800ebc:	e8 c6 fc ff ff       	call   800b87 <sys_getenvid>
  800ec1:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ec6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ec9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ece:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  800ed3:	e9 51 01 00 00       	jmp    801029 <fork+0x1a3>
		panic("sys_exofork: %e", envid);
  800ed8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800edb:	68 3e 18 80 00       	push   $0x80183e
  800ee0:	6a 6d                	push   $0x6d
  800ee2:	68 fc 17 80 00       	push   $0x8017fc
  800ee7:	e8 7c 02 00 00       	call   801168 <_panic>
		sys_page_map(0, addr, envid, addr, PTE_SYSCALL);		//对于表示为PTE_SHARE的页，拷贝映射关系，并且两个进程都有读写权限
  800eec:	83 ec 0c             	sub    $0xc,%esp
  800eef:	68 07 0e 00 00       	push   $0xe07
  800ef4:	56                   	push   %esi
  800ef5:	57                   	push   %edi
  800ef6:	56                   	push   %esi
  800ef7:	6a 00                	push   $0x0
  800ef9:	e8 0a fd ff ff       	call   800c08 <sys_page_map>
  800efe:	83 c4 20             	add    $0x20,%esp
  800f01:	eb 3b                	jmp    800f3e <fork+0xb8>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  800f03:	83 ec 0c             	sub    $0xc,%esp
  800f06:	68 05 08 00 00       	push   $0x805
  800f0b:	56                   	push   %esi
  800f0c:	57                   	push   %edi
  800f0d:	56                   	push   %esi
  800f0e:	6a 00                	push   $0x0
  800f10:	e8 f3 fc ff ff       	call   800c08 <sys_page_map>
  800f15:	83 c4 20             	add    $0x20,%esp
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	0f 88 a9 00 00 00    	js     800fc9 <fork+0x143>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  800f20:	83 ec 0c             	sub    $0xc,%esp
  800f23:	68 05 08 00 00       	push   $0x805
  800f28:	56                   	push   %esi
  800f29:	6a 00                	push   $0x0
  800f2b:	56                   	push   %esi
  800f2c:	6a 00                	push   $0x0
  800f2e:	e8 d5 fc ff ff       	call   800c08 <sys_page_map>
  800f33:	83 c4 20             	add    $0x20,%esp
  800f36:	85 c0                	test   %eax,%eax
  800f38:	0f 88 9d 00 00 00    	js     800fdb <fork+0x155>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f3e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800f44:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800f4a:	0f 84 9d 00 00 00    	je     800fed <fork+0x167>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) //为什么uvpt[pagenumber]能访问到第pagenumber项页表条目：https://pdos.csail.mit.edu/6.828/2018/labs/lab4/uvpt.html
  800f50:	89 d8                	mov    %ebx,%eax
  800f52:	c1 e8 16             	shr    $0x16,%eax
  800f55:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f5c:	a8 01                	test   $0x1,%al
  800f5e:	74 de                	je     800f3e <fork+0xb8>
  800f60:	89 d8                	mov    %ebx,%eax
  800f62:	c1 e8 0c             	shr    $0xc,%eax
  800f65:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f6c:	f6 c2 01             	test   $0x1,%dl
  800f6f:	74 cd                	je     800f3e <fork+0xb8>
			&& (uvpt[PGNUM(addr)] & PTE_U)) {
  800f71:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f78:	f6 c2 04             	test   $0x4,%dl
  800f7b:	74 c1                	je     800f3e <fork+0xb8>
	void *addr = (void*) (pn * PGSIZE);
  800f7d:	89 c6                	mov    %eax,%esi
  800f7f:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE) {
  800f82:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f89:	f6 c6 04             	test   $0x4,%dh
  800f8c:	0f 85 5a ff ff ff    	jne    800eec <fork+0x66>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) { //对于UTOP以下的可写的或者写时拷贝的页，拷贝映射关系的同时，需要同时标记当前进程和子进程的页表项为PTE_COW
  800f92:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f99:	f6 c2 02             	test   $0x2,%dl
  800f9c:	0f 85 61 ff ff ff    	jne    800f03 <fork+0x7d>
  800fa2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fa9:	f6 c4 08             	test   $0x8,%ah
  800fac:	0f 85 51 ff ff ff    	jne    800f03 <fork+0x7d>
		sys_page_map(0, addr, envid, addr, PTE_U|PTE_P);	//对于只读的页，只需要拷贝映射关系即可
  800fb2:	83 ec 0c             	sub    $0xc,%esp
  800fb5:	6a 05                	push   $0x5
  800fb7:	56                   	push   %esi
  800fb8:	57                   	push   %edi
  800fb9:	56                   	push   %esi
  800fba:	6a 00                	push   $0x0
  800fbc:	e8 47 fc ff ff       	call   800c08 <sys_page_map>
  800fc1:	83 c4 20             	add    $0x20,%esp
  800fc4:	e9 75 ff ff ff       	jmp    800f3e <fork+0xb8>
			panic("sys_page_map：%e", r);
  800fc9:	50                   	push   %eax
  800fca:	68 4e 18 80 00       	push   $0x80184e
  800fcf:	6a 48                	push   $0x48
  800fd1:	68 fc 17 80 00       	push   $0x8017fc
  800fd6:	e8 8d 01 00 00       	call   801168 <_panic>
			panic("sys_page_map：%e", r);
  800fdb:	50                   	push   %eax
  800fdc:	68 4e 18 80 00       	push   $0x80184e
  800fe1:	6a 4a                	push   $0x4a
  800fe3:	68 fc 17 80 00       	push   $0x8017fc
  800fe8:	e8 7b 01 00 00       	call   801168 <_panic>
			duppage(envid, PGNUM(addr));	//拷贝当前进程映射关系到子进程
		}
	}
	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_W | PTE_U)) < 0)	//为子进程分配异常栈
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	6a 07                	push   $0x7
  800ff2:	68 00 f0 bf ee       	push   $0xeebff000
  800ff7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ffa:	e8 c6 fb ff ff       	call   800bc5 <sys_page_alloc>
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	85 c0                	test   %eax,%eax
  801004:	78 2e                	js     801034 <fork+0x1ae>
		panic("sys_page_alloc: %e", r);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);		//为子进程设置_pgfault_upcall
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	68 07 12 80 00       	push   $0x801207
  80100e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801011:	57                   	push   %edi
  801012:	e8 f9 fc ff ff       	call   800d10 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)	//设置子进程为ENV_RUNNABLE状态
  801017:	83 c4 08             	add    $0x8,%esp
  80101a:	6a 02                	push   $0x2
  80101c:	57                   	push   %edi
  80101d:	e8 6a fc ff ff       	call   800c8c <sys_env_set_status>
  801022:	83 c4 10             	add    $0x10,%esp
  801025:	85 c0                	test   %eax,%eax
  801027:	78 1d                	js     801046 <fork+0x1c0>
		panic("sys_env_set_status: %e", r);
	return envid;
}
  801029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80102c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102f:	5b                   	pop    %ebx
  801030:	5e                   	pop    %esi
  801031:	5f                   	pop    %edi
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801034:	50                   	push   %eax
  801035:	68 18 18 80 00       	push   $0x801818
  80103a:	6a 79                	push   $0x79
  80103c:	68 fc 17 80 00       	push   $0x8017fc
  801041:	e8 22 01 00 00       	call   801168 <_panic>
		panic("sys_env_set_status: %e", r);
  801046:	50                   	push   %eax
  801047:	68 60 18 80 00       	push   $0x801860
  80104c:	6a 7d                	push   $0x7d
  80104e:	68 fc 17 80 00       	push   $0x8017fc
  801053:	e8 10 01 00 00       	call   801168 <_panic>

00801058 <sfork>:

// Challenge!
int
sfork(void)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80105e:	68 77 18 80 00       	push   $0x801877
  801063:	68 85 00 00 00       	push   $0x85
  801068:	68 fc 17 80 00       	push   $0x8017fc
  80106d:	e8 f6 00 00 00       	call   801168 <_panic>

00801072 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	56                   	push   %esi
  801076:	53                   	push   %ebx
  801077:	8b 75 08             	mov    0x8(%ebp),%esi
  80107a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801080:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  801082:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801087:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  80108a:	83 ec 0c             	sub    $0xc,%esp
  80108d:	50                   	push   %eax
  80108e:	e8 e2 fc ff ff       	call   800d75 <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	85 c0                	test   %eax,%eax
  801098:	78 2b                	js     8010c5 <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  80109a:	85 f6                	test   %esi,%esi
  80109c:	74 0a                	je     8010a8 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80109e:	a1 04 20 80 00       	mov    0x802004,%eax
  8010a3:	8b 40 74             	mov    0x74(%eax),%eax
  8010a6:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  8010a8:	85 db                	test   %ebx,%ebx
  8010aa:	74 0a                	je     8010b6 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8010ac:	a1 04 20 80 00       	mov    0x802004,%eax
  8010b1:	8b 40 78             	mov    0x78(%eax),%eax
  8010b4:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  8010b6:	a1 04 20 80 00       	mov    0x802004,%eax
  8010bb:	8b 40 70             	mov    0x70(%eax),%eax
}
  8010be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010c1:	5b                   	pop    %ebx
  8010c2:	5e                   	pop    %esi
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8010c5:	85 f6                	test   %esi,%esi
  8010c7:	74 06                	je     8010cf <ipc_recv+0x5d>
  8010c9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  8010cf:	85 db                	test   %ebx,%ebx
  8010d1:	74 eb                	je     8010be <ipc_recv+0x4c>
  8010d3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8010d9:	eb e3                	jmp    8010be <ipc_recv+0x4c>

008010db <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	57                   	push   %edi
  8010df:	56                   	push   %esi
  8010e0:	53                   	push   %ebx
  8010e1:	83 ec 0c             	sub    $0xc,%esp
  8010e4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  8010ed:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  8010ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8010f4:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  8010f7:	ff 75 14             	pushl  0x14(%ebp)
  8010fa:	53                   	push   %ebx
  8010fb:	56                   	push   %esi
  8010fc:	57                   	push   %edi
  8010fd:	e8 50 fc ff ff       	call   800d52 <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  801102:	83 c4 10             	add    $0x10,%esp
  801105:	85 c0                	test   %eax,%eax
  801107:	74 1e                	je     801127 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  801109:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80110c:	75 07                	jne    801115 <ipc_send+0x3a>
			sys_yield();
  80110e:	e8 93 fa ff ff       	call   800ba6 <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801113:	eb e2                	jmp    8010f7 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  801115:	50                   	push   %eax
  801116:	68 8d 18 80 00       	push   $0x80188d
  80111b:	6a 41                	push   $0x41
  80111d:	68 9b 18 80 00       	push   $0x80189b
  801122:	e8 41 00 00 00       	call   801168 <_panic>
		}
	}
}
  801127:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80112a:	5b                   	pop    %ebx
  80112b:	5e                   	pop    %esi
  80112c:	5f                   	pop    %edi
  80112d:	5d                   	pop    %ebp
  80112e:	c3                   	ret    

0080112f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801135:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80113a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80113d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801143:	8b 52 50             	mov    0x50(%edx),%edx
  801146:	39 ca                	cmp    %ecx,%edx
  801148:	74 11                	je     80115b <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80114a:	83 c0 01             	add    $0x1,%eax
  80114d:	3d 00 04 00 00       	cmp    $0x400,%eax
  801152:	75 e6                	jne    80113a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801154:	b8 00 00 00 00       	mov    $0x0,%eax
  801159:	eb 0b                	jmp    801166 <ipc_find_env+0x37>
			return envs[i].env_id;
  80115b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80115e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801163:	8b 40 48             	mov    0x48(%eax),%eax
}
  801166:	5d                   	pop    %ebp
  801167:	c3                   	ret    

00801168 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	56                   	push   %esi
  80116c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80116d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801170:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801176:	e8 0c fa ff ff       	call   800b87 <sys_getenvid>
  80117b:	83 ec 0c             	sub    $0xc,%esp
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	ff 75 08             	pushl  0x8(%ebp)
  801184:	56                   	push   %esi
  801185:	50                   	push   %eax
  801186:	68 a8 18 80 00       	push   $0x8018a8
  80118b:	e8 1d f0 ff ff       	call   8001ad <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801190:	83 c4 18             	add    $0x18,%esp
  801193:	53                   	push   %ebx
  801194:	ff 75 10             	pushl  0x10(%ebp)
  801197:	e8 c0 ef ff ff       	call   80015c <vcprintf>
	cprintf("\n");
  80119c:	c7 04 24 a7 14 80 00 	movl   $0x8014a7,(%esp)
  8011a3:	e8 05 f0 ff ff       	call   8001ad <cprintf>
  8011a8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8011ab:	cc                   	int3   
  8011ac:	eb fd                	jmp    8011ab <_panic+0x43>

008011ae <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8011b4:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  8011bb:	74 0a                	je     8011c7 <set_pgfault_handler+0x19>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	a3 08 20 80 00       	mov    %eax,0x802008
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    
		int r = sys_page_alloc(0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P);	//为当前进程分配异常栈
  8011c7:	83 ec 04             	sub    $0x4,%esp
  8011ca:	6a 07                	push   $0x7
  8011cc:	68 00 f0 bf ee       	push   $0xeebff000
  8011d1:	6a 00                	push   $0x0
  8011d3:	e8 ed f9 ff ff       	call   800bc5 <sys_page_alloc>
		if (r < 0) {
  8011d8:	83 c4 10             	add    $0x10,%esp
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	78 14                	js     8011f3 <set_pgfault_handler+0x45>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
  8011df:	83 ec 08             	sub    $0x8,%esp
  8011e2:	68 07 12 80 00       	push   $0x801207
  8011e7:	6a 00                	push   $0x0
  8011e9:	e8 22 fb ff ff       	call   800d10 <sys_env_set_pgfault_upcall>
  8011ee:	83 c4 10             	add    $0x10,%esp
  8011f1:	eb ca                	jmp    8011bd <set_pgfault_handler+0xf>
			panic("set_pgfault_handler:sys_page_alloc failed");;
  8011f3:	83 ec 04             	sub    $0x4,%esp
  8011f6:	68 cc 18 80 00       	push   $0x8018cc
  8011fb:	6a 22                	push   $0x22
  8011fd:	68 f8 18 80 00       	push   $0x8018f8
  801202:	e8 61 ff ff ff       	call   801168 <_panic>

00801207 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801207:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801208:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax				//调用页处理函数
  80120d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80120f:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp			//跳过utf_fault_va和utf_err
  801212:	83 c4 08             	add    $0x8,%esp
	movl 40(%esp), %eax 	//保存中断发生时的esp到eax
  801215:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl 32(%esp), %ecx 	//保存终端发生时的eip到ecx
  801219:	8b 4c 24 20          	mov    0x20(%esp),%ecx
	movl %ecx, -4(%eax) 	//将中断发生时的esp值亚入到到原来的栈中
  80121d:	89 48 fc             	mov    %ecx,-0x4(%eax)
	popal
  801220:	61                   	popa   
	addl $4, %esp			//跳过eip
  801221:	83 c4 04             	add    $0x4,%esp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801224:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801225:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	lea -4(%esp), %esp		//因为之前压入了eip的值但是没有减esp的值，所以现在需要将esp寄存器中的值减4
  801226:	8d 64 24 fc          	lea    -0x4(%esp),%esp
  80122a:	c3                   	ret    
  80122b:	66 90                	xchg   %ax,%ax
  80122d:	66 90                	xchg   %ax,%ax
  80122f:	90                   	nop

00801230 <__udivdi3>:
  801230:	55                   	push   %ebp
  801231:	57                   	push   %edi
  801232:	56                   	push   %esi
  801233:	53                   	push   %ebx
  801234:	83 ec 1c             	sub    $0x1c,%esp
  801237:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80123b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80123f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801243:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801247:	85 d2                	test   %edx,%edx
  801249:	75 35                	jne    801280 <__udivdi3+0x50>
  80124b:	39 f3                	cmp    %esi,%ebx
  80124d:	0f 87 bd 00 00 00    	ja     801310 <__udivdi3+0xe0>
  801253:	85 db                	test   %ebx,%ebx
  801255:	89 d9                	mov    %ebx,%ecx
  801257:	75 0b                	jne    801264 <__udivdi3+0x34>
  801259:	b8 01 00 00 00       	mov    $0x1,%eax
  80125e:	31 d2                	xor    %edx,%edx
  801260:	f7 f3                	div    %ebx
  801262:	89 c1                	mov    %eax,%ecx
  801264:	31 d2                	xor    %edx,%edx
  801266:	89 f0                	mov    %esi,%eax
  801268:	f7 f1                	div    %ecx
  80126a:	89 c6                	mov    %eax,%esi
  80126c:	89 e8                	mov    %ebp,%eax
  80126e:	89 f7                	mov    %esi,%edi
  801270:	f7 f1                	div    %ecx
  801272:	89 fa                	mov    %edi,%edx
  801274:	83 c4 1c             	add    $0x1c,%esp
  801277:	5b                   	pop    %ebx
  801278:	5e                   	pop    %esi
  801279:	5f                   	pop    %edi
  80127a:	5d                   	pop    %ebp
  80127b:	c3                   	ret    
  80127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801280:	39 f2                	cmp    %esi,%edx
  801282:	77 7c                	ja     801300 <__udivdi3+0xd0>
  801284:	0f bd fa             	bsr    %edx,%edi
  801287:	83 f7 1f             	xor    $0x1f,%edi
  80128a:	0f 84 98 00 00 00    	je     801328 <__udivdi3+0xf8>
  801290:	89 f9                	mov    %edi,%ecx
  801292:	b8 20 00 00 00       	mov    $0x20,%eax
  801297:	29 f8                	sub    %edi,%eax
  801299:	d3 e2                	shl    %cl,%edx
  80129b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80129f:	89 c1                	mov    %eax,%ecx
  8012a1:	89 da                	mov    %ebx,%edx
  8012a3:	d3 ea                	shr    %cl,%edx
  8012a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8012a9:	09 d1                	or     %edx,%ecx
  8012ab:	89 f2                	mov    %esi,%edx
  8012ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012b1:	89 f9                	mov    %edi,%ecx
  8012b3:	d3 e3                	shl    %cl,%ebx
  8012b5:	89 c1                	mov    %eax,%ecx
  8012b7:	d3 ea                	shr    %cl,%edx
  8012b9:	89 f9                	mov    %edi,%ecx
  8012bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012bf:	d3 e6                	shl    %cl,%esi
  8012c1:	89 eb                	mov    %ebp,%ebx
  8012c3:	89 c1                	mov    %eax,%ecx
  8012c5:	d3 eb                	shr    %cl,%ebx
  8012c7:	09 de                	or     %ebx,%esi
  8012c9:	89 f0                	mov    %esi,%eax
  8012cb:	f7 74 24 08          	divl   0x8(%esp)
  8012cf:	89 d6                	mov    %edx,%esi
  8012d1:	89 c3                	mov    %eax,%ebx
  8012d3:	f7 64 24 0c          	mull   0xc(%esp)
  8012d7:	39 d6                	cmp    %edx,%esi
  8012d9:	72 0c                	jb     8012e7 <__udivdi3+0xb7>
  8012db:	89 f9                	mov    %edi,%ecx
  8012dd:	d3 e5                	shl    %cl,%ebp
  8012df:	39 c5                	cmp    %eax,%ebp
  8012e1:	73 5d                	jae    801340 <__udivdi3+0x110>
  8012e3:	39 d6                	cmp    %edx,%esi
  8012e5:	75 59                	jne    801340 <__udivdi3+0x110>
  8012e7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8012ea:	31 ff                	xor    %edi,%edi
  8012ec:	89 fa                	mov    %edi,%edx
  8012ee:	83 c4 1c             	add    $0x1c,%esp
  8012f1:	5b                   	pop    %ebx
  8012f2:	5e                   	pop    %esi
  8012f3:	5f                   	pop    %edi
  8012f4:	5d                   	pop    %ebp
  8012f5:	c3                   	ret    
  8012f6:	8d 76 00             	lea    0x0(%esi),%esi
  8012f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801300:	31 ff                	xor    %edi,%edi
  801302:	31 c0                	xor    %eax,%eax
  801304:	89 fa                	mov    %edi,%edx
  801306:	83 c4 1c             	add    $0x1c,%esp
  801309:	5b                   	pop    %ebx
  80130a:	5e                   	pop    %esi
  80130b:	5f                   	pop    %edi
  80130c:	5d                   	pop    %ebp
  80130d:	c3                   	ret    
  80130e:	66 90                	xchg   %ax,%ax
  801310:	31 ff                	xor    %edi,%edi
  801312:	89 e8                	mov    %ebp,%eax
  801314:	89 f2                	mov    %esi,%edx
  801316:	f7 f3                	div    %ebx
  801318:	89 fa                	mov    %edi,%edx
  80131a:	83 c4 1c             	add    $0x1c,%esp
  80131d:	5b                   	pop    %ebx
  80131e:	5e                   	pop    %esi
  80131f:	5f                   	pop    %edi
  801320:	5d                   	pop    %ebp
  801321:	c3                   	ret    
  801322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801328:	39 f2                	cmp    %esi,%edx
  80132a:	72 06                	jb     801332 <__udivdi3+0x102>
  80132c:	31 c0                	xor    %eax,%eax
  80132e:	39 eb                	cmp    %ebp,%ebx
  801330:	77 d2                	ja     801304 <__udivdi3+0xd4>
  801332:	b8 01 00 00 00       	mov    $0x1,%eax
  801337:	eb cb                	jmp    801304 <__udivdi3+0xd4>
  801339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801340:	89 d8                	mov    %ebx,%eax
  801342:	31 ff                	xor    %edi,%edi
  801344:	eb be                	jmp    801304 <__udivdi3+0xd4>
  801346:	66 90                	xchg   %ax,%ax
  801348:	66 90                	xchg   %ax,%ax
  80134a:	66 90                	xchg   %ax,%ax
  80134c:	66 90                	xchg   %ax,%ax
  80134e:	66 90                	xchg   %ax,%ax

00801350 <__umoddi3>:
  801350:	55                   	push   %ebp
  801351:	57                   	push   %edi
  801352:	56                   	push   %esi
  801353:	53                   	push   %ebx
  801354:	83 ec 1c             	sub    $0x1c,%esp
  801357:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80135b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80135f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801363:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801367:	85 ed                	test   %ebp,%ebp
  801369:	89 f0                	mov    %esi,%eax
  80136b:	89 da                	mov    %ebx,%edx
  80136d:	75 19                	jne    801388 <__umoddi3+0x38>
  80136f:	39 df                	cmp    %ebx,%edi
  801371:	0f 86 b1 00 00 00    	jbe    801428 <__umoddi3+0xd8>
  801377:	f7 f7                	div    %edi
  801379:	89 d0                	mov    %edx,%eax
  80137b:	31 d2                	xor    %edx,%edx
  80137d:	83 c4 1c             	add    $0x1c,%esp
  801380:	5b                   	pop    %ebx
  801381:	5e                   	pop    %esi
  801382:	5f                   	pop    %edi
  801383:	5d                   	pop    %ebp
  801384:	c3                   	ret    
  801385:	8d 76 00             	lea    0x0(%esi),%esi
  801388:	39 dd                	cmp    %ebx,%ebp
  80138a:	77 f1                	ja     80137d <__umoddi3+0x2d>
  80138c:	0f bd cd             	bsr    %ebp,%ecx
  80138f:	83 f1 1f             	xor    $0x1f,%ecx
  801392:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801396:	0f 84 b4 00 00 00    	je     801450 <__umoddi3+0x100>
  80139c:	b8 20 00 00 00       	mov    $0x20,%eax
  8013a1:	89 c2                	mov    %eax,%edx
  8013a3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8013a7:	29 c2                	sub    %eax,%edx
  8013a9:	89 c1                	mov    %eax,%ecx
  8013ab:	89 f8                	mov    %edi,%eax
  8013ad:	d3 e5                	shl    %cl,%ebp
  8013af:	89 d1                	mov    %edx,%ecx
  8013b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013b5:	d3 e8                	shr    %cl,%eax
  8013b7:	09 c5                	or     %eax,%ebp
  8013b9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8013bd:	89 c1                	mov    %eax,%ecx
  8013bf:	d3 e7                	shl    %cl,%edi
  8013c1:	89 d1                	mov    %edx,%ecx
  8013c3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013c7:	89 df                	mov    %ebx,%edi
  8013c9:	d3 ef                	shr    %cl,%edi
  8013cb:	89 c1                	mov    %eax,%ecx
  8013cd:	89 f0                	mov    %esi,%eax
  8013cf:	d3 e3                	shl    %cl,%ebx
  8013d1:	89 d1                	mov    %edx,%ecx
  8013d3:	89 fa                	mov    %edi,%edx
  8013d5:	d3 e8                	shr    %cl,%eax
  8013d7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8013dc:	09 d8                	or     %ebx,%eax
  8013de:	f7 f5                	div    %ebp
  8013e0:	d3 e6                	shl    %cl,%esi
  8013e2:	89 d1                	mov    %edx,%ecx
  8013e4:	f7 64 24 08          	mull   0x8(%esp)
  8013e8:	39 d1                	cmp    %edx,%ecx
  8013ea:	89 c3                	mov    %eax,%ebx
  8013ec:	89 d7                	mov    %edx,%edi
  8013ee:	72 06                	jb     8013f6 <__umoddi3+0xa6>
  8013f0:	75 0e                	jne    801400 <__umoddi3+0xb0>
  8013f2:	39 c6                	cmp    %eax,%esi
  8013f4:	73 0a                	jae    801400 <__umoddi3+0xb0>
  8013f6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8013fa:	19 ea                	sbb    %ebp,%edx
  8013fc:	89 d7                	mov    %edx,%edi
  8013fe:	89 c3                	mov    %eax,%ebx
  801400:	89 ca                	mov    %ecx,%edx
  801402:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801407:	29 de                	sub    %ebx,%esi
  801409:	19 fa                	sbb    %edi,%edx
  80140b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80140f:	89 d0                	mov    %edx,%eax
  801411:	d3 e0                	shl    %cl,%eax
  801413:	89 d9                	mov    %ebx,%ecx
  801415:	d3 ee                	shr    %cl,%esi
  801417:	d3 ea                	shr    %cl,%edx
  801419:	09 f0                	or     %esi,%eax
  80141b:	83 c4 1c             	add    $0x1c,%esp
  80141e:	5b                   	pop    %ebx
  80141f:	5e                   	pop    %esi
  801420:	5f                   	pop    %edi
  801421:	5d                   	pop    %ebp
  801422:	c3                   	ret    
  801423:	90                   	nop
  801424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801428:	85 ff                	test   %edi,%edi
  80142a:	89 f9                	mov    %edi,%ecx
  80142c:	75 0b                	jne    801439 <__umoddi3+0xe9>
  80142e:	b8 01 00 00 00       	mov    $0x1,%eax
  801433:	31 d2                	xor    %edx,%edx
  801435:	f7 f7                	div    %edi
  801437:	89 c1                	mov    %eax,%ecx
  801439:	89 d8                	mov    %ebx,%eax
  80143b:	31 d2                	xor    %edx,%edx
  80143d:	f7 f1                	div    %ecx
  80143f:	89 f0                	mov    %esi,%eax
  801441:	f7 f1                	div    %ecx
  801443:	e9 31 ff ff ff       	jmp    801379 <__umoddi3+0x29>
  801448:	90                   	nop
  801449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801450:	39 dd                	cmp    %ebx,%ebp
  801452:	72 08                	jb     80145c <__umoddi3+0x10c>
  801454:	39 f7                	cmp    %esi,%edi
  801456:	0f 87 21 ff ff ff    	ja     80137d <__umoddi3+0x2d>
  80145c:	89 da                	mov    %ebx,%edx
  80145e:	89 f0                	mov    %esi,%eax
  801460:	29 f8                	sub    %edi,%eax
  801462:	19 ea                	sbb    %ebp,%edx
  801464:	e9 14 ff ff ff       	jmp    80137d <__umoddi3+0x2d>
