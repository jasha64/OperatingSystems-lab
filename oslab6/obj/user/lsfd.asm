
obj/user/lsfd.debug：     文件格式 elf32-i386


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
  80002c:	e8 e0 00 00 00       	call   800111 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	68 40 21 80 00       	push   $0x802140
  80003e:	e8 bb 01 00 00       	call   8001fe <cprintf>
	exit();
  800043:	e8 0f 01 00 00       	call   800157 <exit>
}
  800048:	83 c4 10             	add    $0x10,%esp
  80004b:	c9                   	leave  
  80004c:	c3                   	ret    

0080004d <umain>:

void
umain(int argc, char **argv)
{
  80004d:	55                   	push   %ebp
  80004e:	89 e5                	mov    %esp,%ebp
  800050:	57                   	push   %edi
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800059:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	ff 75 0c             	pushl  0xc(%ebp)
  800063:	8d 45 08             	lea    0x8(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	e8 9b 0d 00 00       	call   800e07 <argstart>
	while ((i = argnext(&args)) >= 0)
  80006c:	83 c4 10             	add    $0x10,%esp
	int i, usefprint = 0;
  80006f:	bf 00 00 00 00       	mov    $0x0,%edi
	while ((i = argnext(&args)) >= 0)
  800074:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
		if (i == '1')
			usefprint = 1;
  80007a:	be 01 00 00 00       	mov    $0x1,%esi
	while ((i = argnext(&args)) >= 0)
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	53                   	push   %ebx
  800083:	e8 af 0d 00 00       	call   800e37 <argnext>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	85 c0                	test   %eax,%eax
  80008d:	78 10                	js     80009f <umain+0x52>
		if (i == '1')
  80008f:	83 f8 31             	cmp    $0x31,%eax
  800092:	75 04                	jne    800098 <umain+0x4b>
			usefprint = 1;
  800094:	89 f7                	mov    %esi,%edi
  800096:	eb e7                	jmp    80007f <umain+0x32>
		else
			usage();
  800098:	e8 96 ff ff ff       	call   800033 <usage>
  80009d:	eb e0                	jmp    80007f <umain+0x32>

	for (i = 0; i < 32; i++)
  80009f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fstat(i, &st) >= 0) {
  8000a4:	8d b5 5c ff ff ff    	lea    -0xa4(%ebp),%esi
  8000aa:	eb 26                	jmp    8000d2 <umain+0x85>
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b2:	ff 70 04             	pushl  0x4(%eax)
  8000b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8000b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
  8000bd:	68 54 21 80 00       	push   $0x802154
  8000c2:	e8 37 01 00 00       	call   8001fe <cprintf>
  8000c7:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000ca:	83 c3 01             	add    $0x1,%ebx
  8000cd:	83 fb 20             	cmp    $0x20,%ebx
  8000d0:	74 37                	je     800109 <umain+0xbc>
		if (fstat(i, &st) >= 0) {
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
  8000d7:	e8 5e 13 00 00       	call   80143a <fstat>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	78 e7                	js     8000ca <umain+0x7d>
			if (usefprint)
  8000e3:	85 ff                	test   %edi,%edi
  8000e5:	74 c5                	je     8000ac <umain+0x5f>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000e7:	83 ec 04             	sub    $0x4,%esp
  8000ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ed:	ff 70 04             	pushl  0x4(%eax)
  8000f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8000f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	68 54 21 80 00       	push   $0x802154
  8000fd:	6a 01                	push   $0x1
  8000ff:	e8 79 17 00 00       	call   80187d <fprintf>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	eb c1                	jmp    8000ca <umain+0x7d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5f                   	pop    %edi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    

00800111 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800119:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  80011c:	e8 b7 0a 00 00       	call   800bd8 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  800121:	25 ff 03 00 00       	and    $0x3ff,%eax
  800126:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800129:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80012e:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800133:	85 db                	test   %ebx,%ebx
  800135:	7e 07                	jle    80013e <libmain+0x2d>
		binaryname = argv[0];
  800137:	8b 06                	mov    (%esi),%eax
  800139:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	56                   	push   %esi
  800142:	53                   	push   %ebx
  800143:	e8 05 ff ff ff       	call   80004d <umain>

	// exit gracefully
	exit();
  800148:	e8 0a 00 00 00       	call   800157 <exit>
}
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    

00800157 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80015d:	6a 00                	push   $0x0
  80015f:	e8 33 0a 00 00       	call   800b97 <sys_env_destroy>
}
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	c9                   	leave  
  800168:	c3                   	ret    

00800169 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	53                   	push   %ebx
  80016d:	83 ec 04             	sub    $0x4,%esp
  800170:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800173:	8b 13                	mov    (%ebx),%edx
  800175:	8d 42 01             	lea    0x1(%edx),%eax
  800178:	89 03                	mov    %eax,(%ebx)
  80017a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800181:	3d ff 00 00 00       	cmp    $0xff,%eax
  800186:	74 09                	je     800191 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800188:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80018f:	c9                   	leave  
  800190:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	68 ff 00 00 00       	push   $0xff
  800199:	8d 43 08             	lea    0x8(%ebx),%eax
  80019c:	50                   	push   %eax
  80019d:	e8 b8 09 00 00       	call   800b5a <sys_cputs>
		b->idx = 0;
  8001a2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a8:	83 c4 10             	add    $0x10,%esp
  8001ab:	eb db                	jmp    800188 <putch+0x1f>

008001ad <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001bd:	00 00 00 
	b.cnt = 0;
  8001c0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ca:	ff 75 0c             	pushl  0xc(%ebp)
  8001cd:	ff 75 08             	pushl  0x8(%ebp)
  8001d0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d6:	50                   	push   %eax
  8001d7:	68 69 01 80 00       	push   $0x800169
  8001dc:	e8 1a 01 00 00       	call   8002fb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e1:	83 c4 08             	add    $0x8,%esp
  8001e4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ea:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f0:	50                   	push   %eax
  8001f1:	e8 64 09 00 00       	call   800b5a <sys_cputs>

	return b.cnt;
}
  8001f6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001fc:	c9                   	leave  
  8001fd:	c3                   	ret    

008001fe <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800204:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800207:	50                   	push   %eax
  800208:	ff 75 08             	pushl  0x8(%ebp)
  80020b:	e8 9d ff ff ff       	call   8001ad <vcprintf>
	va_end(ap);

	return cnt;
}
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	57                   	push   %edi
  800216:	56                   	push   %esi
  800217:	53                   	push   %ebx
  800218:	83 ec 1c             	sub    $0x1c,%esp
  80021b:	89 c7                	mov    %eax,%edi
  80021d:	89 d6                	mov    %edx,%esi
  80021f:	8b 45 08             	mov    0x8(%ebp),%eax
  800222:	8b 55 0c             	mov    0xc(%ebp),%edx
  800225:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800228:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80022b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80022e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800233:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800236:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800239:	39 d3                	cmp    %edx,%ebx
  80023b:	72 05                	jb     800242 <printnum+0x30>
  80023d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800240:	77 7a                	ja     8002bc <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	ff 75 18             	pushl  0x18(%ebp)
  800248:	8b 45 14             	mov    0x14(%ebp),%eax
  80024b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80024e:	53                   	push   %ebx
  80024f:	ff 75 10             	pushl  0x10(%ebp)
  800252:	83 ec 08             	sub    $0x8,%esp
  800255:	ff 75 e4             	pushl  -0x1c(%ebp)
  800258:	ff 75 e0             	pushl  -0x20(%ebp)
  80025b:	ff 75 dc             	pushl  -0x24(%ebp)
  80025e:	ff 75 d8             	pushl  -0x28(%ebp)
  800261:	e8 8a 1c 00 00       	call   801ef0 <__udivdi3>
  800266:	83 c4 18             	add    $0x18,%esp
  800269:	52                   	push   %edx
  80026a:	50                   	push   %eax
  80026b:	89 f2                	mov    %esi,%edx
  80026d:	89 f8                	mov    %edi,%eax
  80026f:	e8 9e ff ff ff       	call   800212 <printnum>
  800274:	83 c4 20             	add    $0x20,%esp
  800277:	eb 13                	jmp    80028c <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800279:	83 ec 08             	sub    $0x8,%esp
  80027c:	56                   	push   %esi
  80027d:	ff 75 18             	pushl  0x18(%ebp)
  800280:	ff d7                	call   *%edi
  800282:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800285:	83 eb 01             	sub    $0x1,%ebx
  800288:	85 db                	test   %ebx,%ebx
  80028a:	7f ed                	jg     800279 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	56                   	push   %esi
  800290:	83 ec 04             	sub    $0x4,%esp
  800293:	ff 75 e4             	pushl  -0x1c(%ebp)
  800296:	ff 75 e0             	pushl  -0x20(%ebp)
  800299:	ff 75 dc             	pushl  -0x24(%ebp)
  80029c:	ff 75 d8             	pushl  -0x28(%ebp)
  80029f:	e8 6c 1d 00 00       	call   802010 <__umoddi3>
  8002a4:	83 c4 14             	add    $0x14,%esp
  8002a7:	0f be 80 86 21 80 00 	movsbl 0x802186(%eax),%eax
  8002ae:	50                   	push   %eax
  8002af:	ff d7                	call   *%edi
}
  8002b1:	83 c4 10             	add    $0x10,%esp
  8002b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b7:	5b                   	pop    %ebx
  8002b8:	5e                   	pop    %esi
  8002b9:	5f                   	pop    %edi
  8002ba:	5d                   	pop    %ebp
  8002bb:	c3                   	ret    
  8002bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002bf:	eb c4                	jmp    800285 <printnum+0x73>

008002c1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002cb:	8b 10                	mov    (%eax),%edx
  8002cd:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d0:	73 0a                	jae    8002dc <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002d5:	89 08                	mov    %ecx,(%eax)
  8002d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002da:	88 02                	mov    %al,(%edx)
}
  8002dc:	5d                   	pop    %ebp
  8002dd:	c3                   	ret    

008002de <printfmt>:
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002e4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e7:	50                   	push   %eax
  8002e8:	ff 75 10             	pushl  0x10(%ebp)
  8002eb:	ff 75 0c             	pushl  0xc(%ebp)
  8002ee:	ff 75 08             	pushl  0x8(%ebp)
  8002f1:	e8 05 00 00 00       	call   8002fb <vprintfmt>
}
  8002f6:	83 c4 10             	add    $0x10,%esp
  8002f9:	c9                   	leave  
  8002fa:	c3                   	ret    

008002fb <vprintfmt>:
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	57                   	push   %edi
  8002ff:	56                   	push   %esi
  800300:	53                   	push   %ebx
  800301:	83 ec 2c             	sub    $0x2c,%esp
  800304:	8b 75 08             	mov    0x8(%ebp),%esi
  800307:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80030a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80030d:	e9 c1 03 00 00       	jmp    8006d3 <vprintfmt+0x3d8>
		padc = ' ';
  800312:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800316:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80031d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800324:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80032b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800330:	8d 47 01             	lea    0x1(%edi),%eax
  800333:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800336:	0f b6 17             	movzbl (%edi),%edx
  800339:	8d 42 dd             	lea    -0x23(%edx),%eax
  80033c:	3c 55                	cmp    $0x55,%al
  80033e:	0f 87 12 04 00 00    	ja     800756 <vprintfmt+0x45b>
  800344:	0f b6 c0             	movzbl %al,%eax
  800347:	ff 24 85 c0 22 80 00 	jmp    *0x8022c0(,%eax,4)
  80034e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800351:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800355:	eb d9                	jmp    800330 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800357:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80035a:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80035e:	eb d0                	jmp    800330 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800360:	0f b6 d2             	movzbl %dl,%edx
  800363:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800366:	b8 00 00 00 00       	mov    $0x0,%eax
  80036b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80036e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800371:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800375:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800378:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80037b:	83 f9 09             	cmp    $0x9,%ecx
  80037e:	77 55                	ja     8003d5 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800380:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800383:	eb e9                	jmp    80036e <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800385:	8b 45 14             	mov    0x14(%ebp),%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80038d:	8b 45 14             	mov    0x14(%ebp),%eax
  800390:	8d 40 04             	lea    0x4(%eax),%eax
  800393:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800396:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800399:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80039d:	79 91                	jns    800330 <vprintfmt+0x35>
				width = precision, precision = -1;
  80039f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003ac:	eb 82                	jmp    800330 <vprintfmt+0x35>
  8003ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b1:	85 c0                	test   %eax,%eax
  8003b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b8:	0f 49 d0             	cmovns %eax,%edx
  8003bb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c1:	e9 6a ff ff ff       	jmp    800330 <vprintfmt+0x35>
  8003c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003d0:	e9 5b ff ff ff       	jmp    800330 <vprintfmt+0x35>
  8003d5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003db:	eb bc                	jmp    800399 <vprintfmt+0x9e>
			lflag++;
  8003dd:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003e3:	e9 48 ff ff ff       	jmp    800330 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003eb:	8d 78 04             	lea    0x4(%eax),%edi
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	53                   	push   %ebx
  8003f2:	ff 30                	pushl  (%eax)
  8003f4:	ff d6                	call   *%esi
			break;
  8003f6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003fc:	e9 cf 02 00 00       	jmp    8006d0 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8d 78 04             	lea    0x4(%eax),%edi
  800407:	8b 00                	mov    (%eax),%eax
  800409:	99                   	cltd   
  80040a:	31 d0                	xor    %edx,%eax
  80040c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80040e:	83 f8 0f             	cmp    $0xf,%eax
  800411:	7f 23                	jg     800436 <vprintfmt+0x13b>
  800413:	8b 14 85 20 24 80 00 	mov    0x802420(,%eax,4),%edx
  80041a:	85 d2                	test   %edx,%edx
  80041c:	74 18                	je     800436 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80041e:	52                   	push   %edx
  80041f:	68 51 25 80 00       	push   $0x802551
  800424:	53                   	push   %ebx
  800425:	56                   	push   %esi
  800426:	e8 b3 fe ff ff       	call   8002de <printfmt>
  80042b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80042e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800431:	e9 9a 02 00 00       	jmp    8006d0 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800436:	50                   	push   %eax
  800437:	68 9e 21 80 00       	push   $0x80219e
  80043c:	53                   	push   %ebx
  80043d:	56                   	push   %esi
  80043e:	e8 9b fe ff ff       	call   8002de <printfmt>
  800443:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800446:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800449:	e9 82 02 00 00       	jmp    8006d0 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80044e:	8b 45 14             	mov    0x14(%ebp),%eax
  800451:	83 c0 04             	add    $0x4,%eax
  800454:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800457:	8b 45 14             	mov    0x14(%ebp),%eax
  80045a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80045c:	85 ff                	test   %edi,%edi
  80045e:	b8 97 21 80 00       	mov    $0x802197,%eax
  800463:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800466:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80046a:	0f 8e bd 00 00 00    	jle    80052d <vprintfmt+0x232>
  800470:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800474:	75 0e                	jne    800484 <vprintfmt+0x189>
  800476:	89 75 08             	mov    %esi,0x8(%ebp)
  800479:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80047c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80047f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800482:	eb 6d                	jmp    8004f1 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	ff 75 d0             	pushl  -0x30(%ebp)
  80048a:	57                   	push   %edi
  80048b:	e8 6e 03 00 00       	call   8007fe <strnlen>
  800490:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800493:	29 c1                	sub    %eax,%ecx
  800495:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800498:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80049b:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80049f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004a5:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a7:	eb 0f                	jmp    8004b8 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	53                   	push   %ebx
  8004ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b2:	83 ef 01             	sub    $0x1,%edi
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	85 ff                	test   %edi,%edi
  8004ba:	7f ed                	jg     8004a9 <vprintfmt+0x1ae>
  8004bc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004bf:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004c2:	85 c9                	test   %ecx,%ecx
  8004c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c9:	0f 49 c1             	cmovns %ecx,%eax
  8004cc:	29 c1                	sub    %eax,%ecx
  8004ce:	89 75 08             	mov    %esi,0x8(%ebp)
  8004d1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004d4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004d7:	89 cb                	mov    %ecx,%ebx
  8004d9:	eb 16                	jmp    8004f1 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004db:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004df:	75 31                	jne    800512 <vprintfmt+0x217>
					putch(ch, putdat);
  8004e1:	83 ec 08             	sub    $0x8,%esp
  8004e4:	ff 75 0c             	pushl  0xc(%ebp)
  8004e7:	50                   	push   %eax
  8004e8:	ff 55 08             	call   *0x8(%ebp)
  8004eb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ee:	83 eb 01             	sub    $0x1,%ebx
  8004f1:	83 c7 01             	add    $0x1,%edi
  8004f4:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004f8:	0f be c2             	movsbl %dl,%eax
  8004fb:	85 c0                	test   %eax,%eax
  8004fd:	74 59                	je     800558 <vprintfmt+0x25d>
  8004ff:	85 f6                	test   %esi,%esi
  800501:	78 d8                	js     8004db <vprintfmt+0x1e0>
  800503:	83 ee 01             	sub    $0x1,%esi
  800506:	79 d3                	jns    8004db <vprintfmt+0x1e0>
  800508:	89 df                	mov    %ebx,%edi
  80050a:	8b 75 08             	mov    0x8(%ebp),%esi
  80050d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800510:	eb 37                	jmp    800549 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800512:	0f be d2             	movsbl %dl,%edx
  800515:	83 ea 20             	sub    $0x20,%edx
  800518:	83 fa 5e             	cmp    $0x5e,%edx
  80051b:	76 c4                	jbe    8004e1 <vprintfmt+0x1e6>
					putch('?', putdat);
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	ff 75 0c             	pushl  0xc(%ebp)
  800523:	6a 3f                	push   $0x3f
  800525:	ff 55 08             	call   *0x8(%ebp)
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	eb c1                	jmp    8004ee <vprintfmt+0x1f3>
  80052d:	89 75 08             	mov    %esi,0x8(%ebp)
  800530:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800533:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800536:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800539:	eb b6                	jmp    8004f1 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	53                   	push   %ebx
  80053f:	6a 20                	push   $0x20
  800541:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800543:	83 ef 01             	sub    $0x1,%edi
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	85 ff                	test   %edi,%edi
  80054b:	7f ee                	jg     80053b <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80054d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800550:	89 45 14             	mov    %eax,0x14(%ebp)
  800553:	e9 78 01 00 00       	jmp    8006d0 <vprintfmt+0x3d5>
  800558:	89 df                	mov    %ebx,%edi
  80055a:	8b 75 08             	mov    0x8(%ebp),%esi
  80055d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800560:	eb e7                	jmp    800549 <vprintfmt+0x24e>
	if (lflag >= 2)
  800562:	83 f9 01             	cmp    $0x1,%ecx
  800565:	7e 3f                	jle    8005a6 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8b 50 04             	mov    0x4(%eax),%edx
  80056d:	8b 00                	mov    (%eax),%eax
  80056f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800572:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8d 40 08             	lea    0x8(%eax),%eax
  80057b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80057e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800582:	79 5c                	jns    8005e0 <vprintfmt+0x2e5>
				putch('-', putdat);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	53                   	push   %ebx
  800588:	6a 2d                	push   $0x2d
  80058a:	ff d6                	call   *%esi
				num = -(long long) num;
  80058c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80058f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800592:	f7 da                	neg    %edx
  800594:	83 d1 00             	adc    $0x0,%ecx
  800597:	f7 d9                	neg    %ecx
  800599:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a1:	e9 10 01 00 00       	jmp    8006b6 <vprintfmt+0x3bb>
	else if (lflag)
  8005a6:	85 c9                	test   %ecx,%ecx
  8005a8:	75 1b                	jne    8005c5 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b2:	89 c1                	mov    %eax,%ecx
  8005b4:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8d 40 04             	lea    0x4(%eax),%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c3:	eb b9                	jmp    80057e <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cd:	89 c1                	mov    %eax,%ecx
  8005cf:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8d 40 04             	lea    0x4(%eax),%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
  8005de:	eb 9e                	jmp    80057e <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005e0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005eb:	e9 c6 00 00 00       	jmp    8006b6 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005f0:	83 f9 01             	cmp    $0x1,%ecx
  8005f3:	7e 18                	jle    80060d <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8b 10                	mov    (%eax),%edx
  8005fa:	8b 48 04             	mov    0x4(%eax),%ecx
  8005fd:	8d 40 08             	lea    0x8(%eax),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800603:	b8 0a 00 00 00       	mov    $0xa,%eax
  800608:	e9 a9 00 00 00       	jmp    8006b6 <vprintfmt+0x3bb>
	else if (lflag)
  80060d:	85 c9                	test   %ecx,%ecx
  80060f:	75 1a                	jne    80062b <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8b 10                	mov    (%eax),%edx
  800616:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061b:	8d 40 04             	lea    0x4(%eax),%eax
  80061e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800621:	b8 0a 00 00 00       	mov    $0xa,%eax
  800626:	e9 8b 00 00 00       	jmp    8006b6 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8b 10                	mov    (%eax),%edx
  800630:	b9 00 00 00 00       	mov    $0x0,%ecx
  800635:	8d 40 04             	lea    0x4(%eax),%eax
  800638:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800640:	eb 74                	jmp    8006b6 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800642:	83 f9 01             	cmp    $0x1,%ecx
  800645:	7e 15                	jle    80065c <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8b 10                	mov    (%eax),%edx
  80064c:	8b 48 04             	mov    0x4(%eax),%ecx
  80064f:	8d 40 08             	lea    0x8(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800655:	b8 08 00 00 00       	mov    $0x8,%eax
  80065a:	eb 5a                	jmp    8006b6 <vprintfmt+0x3bb>
	else if (lflag)
  80065c:	85 c9                	test   %ecx,%ecx
  80065e:	75 17                	jne    800677 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8b 10                	mov    (%eax),%edx
  800665:	b9 00 00 00 00       	mov    $0x0,%ecx
  80066a:	8d 40 04             	lea    0x4(%eax),%eax
  80066d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800670:	b8 08 00 00 00       	mov    $0x8,%eax
  800675:	eb 3f                	jmp    8006b6 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 10                	mov    (%eax),%edx
  80067c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800681:	8d 40 04             	lea    0x4(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800687:	b8 08 00 00 00       	mov    $0x8,%eax
  80068c:	eb 28                	jmp    8006b6 <vprintfmt+0x3bb>
			putch('0', putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	53                   	push   %ebx
  800692:	6a 30                	push   $0x30
  800694:	ff d6                	call   *%esi
			putch('x', putdat);
  800696:	83 c4 08             	add    $0x8,%esp
  800699:	53                   	push   %ebx
  80069a:	6a 78                	push   $0x78
  80069c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8b 10                	mov    (%eax),%edx
  8006a3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006a8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ab:	8d 40 04             	lea    0x4(%eax),%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006b6:	83 ec 0c             	sub    $0xc,%esp
  8006b9:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006bd:	57                   	push   %edi
  8006be:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c1:	50                   	push   %eax
  8006c2:	51                   	push   %ecx
  8006c3:	52                   	push   %edx
  8006c4:	89 da                	mov    %ebx,%edx
  8006c6:	89 f0                	mov    %esi,%eax
  8006c8:	e8 45 fb ff ff       	call   800212 <printnum>
			break;
  8006cd:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  8006d3:	83 c7 01             	add    $0x1,%edi
  8006d6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006da:	83 f8 25             	cmp    $0x25,%eax
  8006dd:	0f 84 2f fc ff ff    	je     800312 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	0f 84 8b 00 00 00    	je     800776 <vprintfmt+0x47b>
			putch(ch, putdat);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	53                   	push   %ebx
  8006ef:	50                   	push   %eax
  8006f0:	ff d6                	call   *%esi
  8006f2:	83 c4 10             	add    $0x10,%esp
  8006f5:	eb dc                	jmp    8006d3 <vprintfmt+0x3d8>
	if (lflag >= 2)
  8006f7:	83 f9 01             	cmp    $0x1,%ecx
  8006fa:	7e 15                	jle    800711 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 10                	mov    (%eax),%edx
  800701:	8b 48 04             	mov    0x4(%eax),%ecx
  800704:	8d 40 08             	lea    0x8(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070a:	b8 10 00 00 00       	mov    $0x10,%eax
  80070f:	eb a5                	jmp    8006b6 <vprintfmt+0x3bb>
	else if (lflag)
  800711:	85 c9                	test   %ecx,%ecx
  800713:	75 17                	jne    80072c <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8b 10                	mov    (%eax),%edx
  80071a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071f:	8d 40 04             	lea    0x4(%eax),%eax
  800722:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800725:	b8 10 00 00 00       	mov    $0x10,%eax
  80072a:	eb 8a                	jmp    8006b6 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 10                	mov    (%eax),%edx
  800731:	b9 00 00 00 00       	mov    $0x0,%ecx
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073c:	b8 10 00 00 00       	mov    $0x10,%eax
  800741:	e9 70 ff ff ff       	jmp    8006b6 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	53                   	push   %ebx
  80074a:	6a 25                	push   $0x25
  80074c:	ff d6                	call   *%esi
			break;
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	e9 7a ff ff ff       	jmp    8006d0 <vprintfmt+0x3d5>
			putch('%', putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	53                   	push   %ebx
  80075a:	6a 25                	push   $0x25
  80075c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	89 f8                	mov    %edi,%eax
  800763:	eb 03                	jmp    800768 <vprintfmt+0x46d>
  800765:	83 e8 01             	sub    $0x1,%eax
  800768:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80076c:	75 f7                	jne    800765 <vprintfmt+0x46a>
  80076e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800771:	e9 5a ff ff ff       	jmp    8006d0 <vprintfmt+0x3d5>
}
  800776:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800779:	5b                   	pop    %ebx
  80077a:	5e                   	pop    %esi
  80077b:	5f                   	pop    %edi
  80077c:	5d                   	pop    %ebp
  80077d:	c3                   	ret    

0080077e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	83 ec 18             	sub    $0x18,%esp
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80078a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80078d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800791:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800794:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80079b:	85 c0                	test   %eax,%eax
  80079d:	74 26                	je     8007c5 <vsnprintf+0x47>
  80079f:	85 d2                	test   %edx,%edx
  8007a1:	7e 22                	jle    8007c5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007a3:	ff 75 14             	pushl  0x14(%ebp)
  8007a6:	ff 75 10             	pushl  0x10(%ebp)
  8007a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007ac:	50                   	push   %eax
  8007ad:	68 c1 02 80 00       	push   $0x8002c1
  8007b2:	e8 44 fb ff ff       	call   8002fb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c0:	83 c4 10             	add    $0x10,%esp
}
  8007c3:	c9                   	leave  
  8007c4:	c3                   	ret    
		return -E_INVAL;
  8007c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ca:	eb f7                	jmp    8007c3 <vsnprintf+0x45>

008007cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007d2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007d5:	50                   	push   %eax
  8007d6:	ff 75 10             	pushl  0x10(%ebp)
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	ff 75 08             	pushl  0x8(%ebp)
  8007df:	e8 9a ff ff ff       	call   80077e <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    

008007e6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f1:	eb 03                	jmp    8007f6 <strlen+0x10>
		n++;
  8007f3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007f6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007fa:	75 f7                	jne    8007f3 <strlen+0xd>
	return n;
}
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800804:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800807:	b8 00 00 00 00       	mov    $0x0,%eax
  80080c:	eb 03                	jmp    800811 <strnlen+0x13>
		n++;
  80080e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800811:	39 d0                	cmp    %edx,%eax
  800813:	74 06                	je     80081b <strnlen+0x1d>
  800815:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800819:	75 f3                	jne    80080e <strnlen+0x10>
	return n;
}
  80081b:	5d                   	pop    %ebp
  80081c:	c3                   	ret    

0080081d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	53                   	push   %ebx
  800821:	8b 45 08             	mov    0x8(%ebp),%eax
  800824:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800827:	89 c2                	mov    %eax,%edx
  800829:	83 c1 01             	add    $0x1,%ecx
  80082c:	83 c2 01             	add    $0x1,%edx
  80082f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800833:	88 5a ff             	mov    %bl,-0x1(%edx)
  800836:	84 db                	test   %bl,%bl
  800838:	75 ef                	jne    800829 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80083a:	5b                   	pop    %ebx
  80083b:	5d                   	pop    %ebp
  80083c:	c3                   	ret    

0080083d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	53                   	push   %ebx
  800841:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800844:	53                   	push   %ebx
  800845:	e8 9c ff ff ff       	call   8007e6 <strlen>
  80084a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80084d:	ff 75 0c             	pushl  0xc(%ebp)
  800850:	01 d8                	add    %ebx,%eax
  800852:	50                   	push   %eax
  800853:	e8 c5 ff ff ff       	call   80081d <strcpy>
	return dst;
}
  800858:	89 d8                	mov    %ebx,%eax
  80085a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085d:	c9                   	leave  
  80085e:	c3                   	ret    

0080085f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	56                   	push   %esi
  800863:	53                   	push   %ebx
  800864:	8b 75 08             	mov    0x8(%ebp),%esi
  800867:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80086a:	89 f3                	mov    %esi,%ebx
  80086c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80086f:	89 f2                	mov    %esi,%edx
  800871:	eb 0f                	jmp    800882 <strncpy+0x23>
		*dst++ = *src;
  800873:	83 c2 01             	add    $0x1,%edx
  800876:	0f b6 01             	movzbl (%ecx),%eax
  800879:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80087c:	80 39 01             	cmpb   $0x1,(%ecx)
  80087f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800882:	39 da                	cmp    %ebx,%edx
  800884:	75 ed                	jne    800873 <strncpy+0x14>
	}
	return ret;
}
  800886:	89 f0                	mov    %esi,%eax
  800888:	5b                   	pop    %ebx
  800889:	5e                   	pop    %esi
  80088a:	5d                   	pop    %ebp
  80088b:	c3                   	ret    

0080088c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	56                   	push   %esi
  800890:	53                   	push   %ebx
  800891:	8b 75 08             	mov    0x8(%ebp),%esi
  800894:	8b 55 0c             	mov    0xc(%ebp),%edx
  800897:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80089a:	89 f0                	mov    %esi,%eax
  80089c:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008a0:	85 c9                	test   %ecx,%ecx
  8008a2:	75 0b                	jne    8008af <strlcpy+0x23>
  8008a4:	eb 17                	jmp    8008bd <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008a6:	83 c2 01             	add    $0x1,%edx
  8008a9:	83 c0 01             	add    $0x1,%eax
  8008ac:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008af:	39 d8                	cmp    %ebx,%eax
  8008b1:	74 07                	je     8008ba <strlcpy+0x2e>
  8008b3:	0f b6 0a             	movzbl (%edx),%ecx
  8008b6:	84 c9                	test   %cl,%cl
  8008b8:	75 ec                	jne    8008a6 <strlcpy+0x1a>
		*dst = '\0';
  8008ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008bd:	29 f0                	sub    %esi,%eax
}
  8008bf:	5b                   	pop    %ebx
  8008c0:	5e                   	pop    %esi
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008cc:	eb 06                	jmp    8008d4 <strcmp+0x11>
		p++, q++;
  8008ce:	83 c1 01             	add    $0x1,%ecx
  8008d1:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008d4:	0f b6 01             	movzbl (%ecx),%eax
  8008d7:	84 c0                	test   %al,%al
  8008d9:	74 04                	je     8008df <strcmp+0x1c>
  8008db:	3a 02                	cmp    (%edx),%al
  8008dd:	74 ef                	je     8008ce <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008df:	0f b6 c0             	movzbl %al,%eax
  8008e2:	0f b6 12             	movzbl (%edx),%edx
  8008e5:	29 d0                	sub    %edx,%eax
}
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	53                   	push   %ebx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f3:	89 c3                	mov    %eax,%ebx
  8008f5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008f8:	eb 06                	jmp    800900 <strncmp+0x17>
		n--, p++, q++;
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800900:	39 d8                	cmp    %ebx,%eax
  800902:	74 16                	je     80091a <strncmp+0x31>
  800904:	0f b6 08             	movzbl (%eax),%ecx
  800907:	84 c9                	test   %cl,%cl
  800909:	74 04                	je     80090f <strncmp+0x26>
  80090b:	3a 0a                	cmp    (%edx),%cl
  80090d:	74 eb                	je     8008fa <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80090f:	0f b6 00             	movzbl (%eax),%eax
  800912:	0f b6 12             	movzbl (%edx),%edx
  800915:	29 d0                	sub    %edx,%eax
}
  800917:	5b                   	pop    %ebx
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    
		return 0;
  80091a:	b8 00 00 00 00       	mov    $0x0,%eax
  80091f:	eb f6                	jmp    800917 <strncmp+0x2e>

00800921 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092b:	0f b6 10             	movzbl (%eax),%edx
  80092e:	84 d2                	test   %dl,%dl
  800930:	74 09                	je     80093b <strchr+0x1a>
		if (*s == c)
  800932:	38 ca                	cmp    %cl,%dl
  800934:	74 0a                	je     800940 <strchr+0x1f>
	for (; *s; s++)
  800936:	83 c0 01             	add    $0x1,%eax
  800939:	eb f0                	jmp    80092b <strchr+0xa>
			return (char *) s;
	return 0;
  80093b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80094c:	eb 03                	jmp    800951 <strfind+0xf>
  80094e:	83 c0 01             	add    $0x1,%eax
  800951:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800954:	38 ca                	cmp    %cl,%dl
  800956:	74 04                	je     80095c <strfind+0x1a>
  800958:	84 d2                	test   %dl,%dl
  80095a:	75 f2                	jne    80094e <strfind+0xc>
			break;
	return (char *) s;
}
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    

0080095e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	57                   	push   %edi
  800962:	56                   	push   %esi
  800963:	53                   	push   %ebx
  800964:	8b 7d 08             	mov    0x8(%ebp),%edi
  800967:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80096a:	85 c9                	test   %ecx,%ecx
  80096c:	74 13                	je     800981 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80096e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800974:	75 05                	jne    80097b <memset+0x1d>
  800976:	f6 c1 03             	test   $0x3,%cl
  800979:	74 0d                	je     800988 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80097b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097e:	fc                   	cld    
  80097f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800981:	89 f8                	mov    %edi,%eax
  800983:	5b                   	pop    %ebx
  800984:	5e                   	pop    %esi
  800985:	5f                   	pop    %edi
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    
		c &= 0xFF;
  800988:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80098c:	89 d3                	mov    %edx,%ebx
  80098e:	c1 e3 08             	shl    $0x8,%ebx
  800991:	89 d0                	mov    %edx,%eax
  800993:	c1 e0 18             	shl    $0x18,%eax
  800996:	89 d6                	mov    %edx,%esi
  800998:	c1 e6 10             	shl    $0x10,%esi
  80099b:	09 f0                	or     %esi,%eax
  80099d:	09 c2                	or     %eax,%edx
  80099f:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009a1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	fc                   	cld    
  8009a7:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a9:	eb d6                	jmp    800981 <memset+0x23>

008009ab <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	57                   	push   %edi
  8009af:	56                   	push   %esi
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009b9:	39 c6                	cmp    %eax,%esi
  8009bb:	73 35                	jae    8009f2 <memmove+0x47>
  8009bd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009c0:	39 c2                	cmp    %eax,%edx
  8009c2:	76 2e                	jbe    8009f2 <memmove+0x47>
		s += n;
		d += n;
  8009c4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c7:	89 d6                	mov    %edx,%esi
  8009c9:	09 fe                	or     %edi,%esi
  8009cb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009d1:	74 0c                	je     8009df <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009d3:	83 ef 01             	sub    $0x1,%edi
  8009d6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009d9:	fd                   	std    
  8009da:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009dc:	fc                   	cld    
  8009dd:	eb 21                	jmp    800a00 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009df:	f6 c1 03             	test   $0x3,%cl
  8009e2:	75 ef                	jne    8009d3 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009e4:	83 ef 04             	sub    $0x4,%edi
  8009e7:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009ea:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009ed:	fd                   	std    
  8009ee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009f0:	eb ea                	jmp    8009dc <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f2:	89 f2                	mov    %esi,%edx
  8009f4:	09 c2                	or     %eax,%edx
  8009f6:	f6 c2 03             	test   $0x3,%dl
  8009f9:	74 09                	je     800a04 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009fb:	89 c7                	mov    %eax,%edi
  8009fd:	fc                   	cld    
  8009fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a00:	5e                   	pop    %esi
  800a01:	5f                   	pop    %edi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a04:	f6 c1 03             	test   $0x3,%cl
  800a07:	75 f2                	jne    8009fb <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a09:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a0c:	89 c7                	mov    %eax,%edi
  800a0e:	fc                   	cld    
  800a0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a11:	eb ed                	jmp    800a00 <memmove+0x55>

00800a13 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a16:	ff 75 10             	pushl  0x10(%ebp)
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	ff 75 08             	pushl  0x8(%ebp)
  800a1f:	e8 87 ff ff ff       	call   8009ab <memmove>
}
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	56                   	push   %esi
  800a2a:	53                   	push   %ebx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a31:	89 c6                	mov    %eax,%esi
  800a33:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a36:	39 f0                	cmp    %esi,%eax
  800a38:	74 1c                	je     800a56 <memcmp+0x30>
		if (*s1 != *s2)
  800a3a:	0f b6 08             	movzbl (%eax),%ecx
  800a3d:	0f b6 1a             	movzbl (%edx),%ebx
  800a40:	38 d9                	cmp    %bl,%cl
  800a42:	75 08                	jne    800a4c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a44:	83 c0 01             	add    $0x1,%eax
  800a47:	83 c2 01             	add    $0x1,%edx
  800a4a:	eb ea                	jmp    800a36 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a4c:	0f b6 c1             	movzbl %cl,%eax
  800a4f:	0f b6 db             	movzbl %bl,%ebx
  800a52:	29 d8                	sub    %ebx,%eax
  800a54:	eb 05                	jmp    800a5b <memcmp+0x35>
	}

	return 0;
  800a56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a5b:	5b                   	pop    %ebx
  800a5c:	5e                   	pop    %esi
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a68:	89 c2                	mov    %eax,%edx
  800a6a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a6d:	39 d0                	cmp    %edx,%eax
  800a6f:	73 09                	jae    800a7a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a71:	38 08                	cmp    %cl,(%eax)
  800a73:	74 05                	je     800a7a <memfind+0x1b>
	for (; s < ends; s++)
  800a75:	83 c0 01             	add    $0x1,%eax
  800a78:	eb f3                	jmp    800a6d <memfind+0xe>
			break;
	return (void *) s;
}
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	57                   	push   %edi
  800a80:	56                   	push   %esi
  800a81:	53                   	push   %ebx
  800a82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a88:	eb 03                	jmp    800a8d <strtol+0x11>
		s++;
  800a8a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a8d:	0f b6 01             	movzbl (%ecx),%eax
  800a90:	3c 20                	cmp    $0x20,%al
  800a92:	74 f6                	je     800a8a <strtol+0xe>
  800a94:	3c 09                	cmp    $0x9,%al
  800a96:	74 f2                	je     800a8a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a98:	3c 2b                	cmp    $0x2b,%al
  800a9a:	74 2e                	je     800aca <strtol+0x4e>
	int neg = 0;
  800a9c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800aa1:	3c 2d                	cmp    $0x2d,%al
  800aa3:	74 2f                	je     800ad4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aa5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aab:	75 05                	jne    800ab2 <strtol+0x36>
  800aad:	80 39 30             	cmpb   $0x30,(%ecx)
  800ab0:	74 2c                	je     800ade <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ab2:	85 db                	test   %ebx,%ebx
  800ab4:	75 0a                	jne    800ac0 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ab6:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800abb:	80 39 30             	cmpb   $0x30,(%ecx)
  800abe:	74 28                	je     800ae8 <strtol+0x6c>
		base = 10;
  800ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ac8:	eb 50                	jmp    800b1a <strtol+0x9e>
		s++;
  800aca:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800acd:	bf 00 00 00 00       	mov    $0x0,%edi
  800ad2:	eb d1                	jmp    800aa5 <strtol+0x29>
		s++, neg = 1;
  800ad4:	83 c1 01             	add    $0x1,%ecx
  800ad7:	bf 01 00 00 00       	mov    $0x1,%edi
  800adc:	eb c7                	jmp    800aa5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ade:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ae2:	74 0e                	je     800af2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ae4:	85 db                	test   %ebx,%ebx
  800ae6:	75 d8                	jne    800ac0 <strtol+0x44>
		s++, base = 8;
  800ae8:	83 c1 01             	add    $0x1,%ecx
  800aeb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800af0:	eb ce                	jmp    800ac0 <strtol+0x44>
		s += 2, base = 16;
  800af2:	83 c1 02             	add    $0x2,%ecx
  800af5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800afa:	eb c4                	jmp    800ac0 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800afc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aff:	89 f3                	mov    %esi,%ebx
  800b01:	80 fb 19             	cmp    $0x19,%bl
  800b04:	77 29                	ja     800b2f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b06:	0f be d2             	movsbl %dl,%edx
  800b09:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b0c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b0f:	7d 30                	jge    800b41 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b11:	83 c1 01             	add    $0x1,%ecx
  800b14:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b18:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b1a:	0f b6 11             	movzbl (%ecx),%edx
  800b1d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b20:	89 f3                	mov    %esi,%ebx
  800b22:	80 fb 09             	cmp    $0x9,%bl
  800b25:	77 d5                	ja     800afc <strtol+0x80>
			dig = *s - '0';
  800b27:	0f be d2             	movsbl %dl,%edx
  800b2a:	83 ea 30             	sub    $0x30,%edx
  800b2d:	eb dd                	jmp    800b0c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b2f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b32:	89 f3                	mov    %esi,%ebx
  800b34:	80 fb 19             	cmp    $0x19,%bl
  800b37:	77 08                	ja     800b41 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b39:	0f be d2             	movsbl %dl,%edx
  800b3c:	83 ea 37             	sub    $0x37,%edx
  800b3f:	eb cb                	jmp    800b0c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b45:	74 05                	je     800b4c <strtol+0xd0>
		*endptr = (char *) s;
  800b47:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b4a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b4c:	89 c2                	mov    %eax,%edx
  800b4e:	f7 da                	neg    %edx
  800b50:	85 ff                	test   %edi,%edi
  800b52:	0f 45 c2             	cmovne %edx,%eax
}
  800b55:	5b                   	pop    %ebx
  800b56:	5e                   	pop    %esi
  800b57:	5f                   	pop    %edi
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	57                   	push   %edi
  800b5e:	56                   	push   %esi
  800b5f:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b60:	b8 00 00 00 00       	mov    $0x0,%eax
  800b65:	8b 55 08             	mov    0x8(%ebp),%edx
  800b68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b6b:	89 c3                	mov    %eax,%ebx
  800b6d:	89 c7                	mov    %eax,%edi
  800b6f:	89 c6                	mov    %eax,%esi
  800b71:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b73:	5b                   	pop    %ebx
  800b74:	5e                   	pop    %esi
  800b75:	5f                   	pop    %edi
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	57                   	push   %edi
  800b7c:	56                   	push   %esi
  800b7d:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b83:	b8 01 00 00 00       	mov    $0x1,%eax
  800b88:	89 d1                	mov    %edx,%ecx
  800b8a:	89 d3                	mov    %edx,%ebx
  800b8c:	89 d7                	mov    %edx,%edi
  800b8e:	89 d6                	mov    %edx,%esi
  800b90:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b92:	5b                   	pop    %ebx
  800b93:	5e                   	pop    %esi
  800b94:	5f                   	pop    %edi
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	57                   	push   %edi
  800b9b:	56                   	push   %esi
  800b9c:	53                   	push   %ebx
  800b9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ba0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bad:	89 cb                	mov    %ecx,%ebx
  800baf:	89 cf                	mov    %ecx,%edi
  800bb1:	89 ce                	mov    %ecx,%esi
  800bb3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bb5:	85 c0                	test   %eax,%eax
  800bb7:	7f 08                	jg     800bc1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bbc:	5b                   	pop    %ebx
  800bbd:	5e                   	pop    %esi
  800bbe:	5f                   	pop    %edi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	50                   	push   %eax
  800bc5:	6a 03                	push   $0x3
  800bc7:	68 7f 24 80 00       	push   $0x80247f
  800bcc:	6a 23                	push   $0x23
  800bce:	68 9c 24 80 00       	push   $0x80249c
  800bd3:	e8 9c 11 00 00       	call   801d74 <_panic>

00800bd8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	57                   	push   %edi
  800bdc:	56                   	push   %esi
  800bdd:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bde:	ba 00 00 00 00       	mov    $0x0,%edx
  800be3:	b8 02 00 00 00       	mov    $0x2,%eax
  800be8:	89 d1                	mov    %edx,%ecx
  800bea:	89 d3                	mov    %edx,%ebx
  800bec:	89 d7                	mov    %edx,%edi
  800bee:	89 d6                	mov    %edx,%esi
  800bf0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <sys_yield>:

void
sys_yield(void)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	57                   	push   %edi
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800c02:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c07:	89 d1                	mov    %edx,%ecx
  800c09:	89 d3                	mov    %edx,%ebx
  800c0b:	89 d7                	mov    %edx,%edi
  800c0d:	89 d6                	mov    %edx,%esi
  800c0f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c11:	5b                   	pop    %ebx
  800c12:	5e                   	pop    %esi
  800c13:	5f                   	pop    %edi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
  800c1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c1f:	be 00 00 00 00       	mov    $0x0,%esi
  800c24:	8b 55 08             	mov    0x8(%ebp),%edx
  800c27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c32:	89 f7                	mov    %esi,%edi
  800c34:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c36:	85 c0                	test   %eax,%eax
  800c38:	7f 08                	jg     800c42 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c3d:	5b                   	pop    %ebx
  800c3e:	5e                   	pop    %esi
  800c3f:	5f                   	pop    %edi
  800c40:	5d                   	pop    %ebp
  800c41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c42:	83 ec 0c             	sub    $0xc,%esp
  800c45:	50                   	push   %eax
  800c46:	6a 04                	push   $0x4
  800c48:	68 7f 24 80 00       	push   $0x80247f
  800c4d:	6a 23                	push   $0x23
  800c4f:	68 9c 24 80 00       	push   $0x80249c
  800c54:	e8 1b 11 00 00       	call   801d74 <_panic>

00800c59 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	57                   	push   %edi
  800c5d:	56                   	push   %esi
  800c5e:	53                   	push   %ebx
  800c5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c62:	8b 55 08             	mov    0x8(%ebp),%edx
  800c65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c68:	b8 05 00 00 00       	mov    $0x5,%eax
  800c6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c70:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c73:	8b 75 18             	mov    0x18(%ebp),%esi
  800c76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c78:	85 c0                	test   %eax,%eax
  800c7a:	7f 08                	jg     800c84 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5f                   	pop    %edi
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c84:	83 ec 0c             	sub    $0xc,%esp
  800c87:	50                   	push   %eax
  800c88:	6a 05                	push   $0x5
  800c8a:	68 7f 24 80 00       	push   $0x80247f
  800c8f:	6a 23                	push   $0x23
  800c91:	68 9c 24 80 00       	push   $0x80249c
  800c96:	e8 d9 10 00 00       	call   801d74 <_panic>

00800c9b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ca4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	b8 06 00 00 00       	mov    $0x6,%eax
  800cb4:	89 df                	mov    %ebx,%edi
  800cb6:	89 de                	mov    %ebx,%esi
  800cb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	7f 08                	jg     800cc6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc6:	83 ec 0c             	sub    $0xc,%esp
  800cc9:	50                   	push   %eax
  800cca:	6a 06                	push   $0x6
  800ccc:	68 7f 24 80 00       	push   $0x80247f
  800cd1:	6a 23                	push   $0x23
  800cd3:	68 9c 24 80 00       	push   $0x80249c
  800cd8:	e8 97 10 00 00       	call   801d74 <_panic>

00800cdd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	57                   	push   %edi
  800ce1:	56                   	push   %esi
  800ce2:	53                   	push   %ebx
  800ce3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ce6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf1:	b8 08 00 00 00       	mov    $0x8,%eax
  800cf6:	89 df                	mov    %ebx,%edi
  800cf8:	89 de                	mov    %ebx,%esi
  800cfa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfc:	85 c0                	test   %eax,%eax
  800cfe:	7f 08                	jg     800d08 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d03:	5b                   	pop    %ebx
  800d04:	5e                   	pop    %esi
  800d05:	5f                   	pop    %edi
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d08:	83 ec 0c             	sub    $0xc,%esp
  800d0b:	50                   	push   %eax
  800d0c:	6a 08                	push   $0x8
  800d0e:	68 7f 24 80 00       	push   $0x80247f
  800d13:	6a 23                	push   $0x23
  800d15:	68 9c 24 80 00       	push   $0x80249c
  800d1a:	e8 55 10 00 00       	call   801d74 <_panic>

00800d1f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	57                   	push   %edi
  800d23:	56                   	push   %esi
  800d24:	53                   	push   %ebx
  800d25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d33:	b8 09 00 00 00       	mov    $0x9,%eax
  800d38:	89 df                	mov    %ebx,%edi
  800d3a:	89 de                	mov    %ebx,%esi
  800d3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3e:	85 c0                	test   %eax,%eax
  800d40:	7f 08                	jg     800d4a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4a:	83 ec 0c             	sub    $0xc,%esp
  800d4d:	50                   	push   %eax
  800d4e:	6a 09                	push   $0x9
  800d50:	68 7f 24 80 00       	push   $0x80247f
  800d55:	6a 23                	push   $0x23
  800d57:	68 9c 24 80 00       	push   $0x80249c
  800d5c:	e8 13 10 00 00       	call   801d74 <_panic>

00800d61 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	57                   	push   %edi
  800d65:	56                   	push   %esi
  800d66:	53                   	push   %ebx
  800d67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d6a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d75:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d7a:	89 df                	mov    %ebx,%edi
  800d7c:	89 de                	mov    %ebx,%esi
  800d7e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d80:	85 c0                	test   %eax,%eax
  800d82:	7f 08                	jg     800d8c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d87:	5b                   	pop    %ebx
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8c:	83 ec 0c             	sub    $0xc,%esp
  800d8f:	50                   	push   %eax
  800d90:	6a 0a                	push   $0xa
  800d92:	68 7f 24 80 00       	push   $0x80247f
  800d97:	6a 23                	push   $0x23
  800d99:	68 9c 24 80 00       	push   $0x80249c
  800d9e:	e8 d1 0f 00 00       	call   801d74 <_panic>

00800da3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	57                   	push   %edi
  800da7:	56                   	push   %esi
  800da8:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800da9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800daf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800db4:	be 00 00 00 00       	mov    $0x0,%esi
  800db9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dbc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dbf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5f                   	pop    %edi
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    

00800dc6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	57                   	push   %edi
  800dca:	56                   	push   %esi
  800dcb:	53                   	push   %ebx
  800dcc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800dcf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ddc:	89 cb                	mov    %ecx,%ebx
  800dde:	89 cf                	mov    %ecx,%edi
  800de0:	89 ce                	mov    %ecx,%esi
  800de2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de4:	85 c0                	test   %eax,%eax
  800de6:	7f 08                	jg     800df0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df0:	83 ec 0c             	sub    $0xc,%esp
  800df3:	50                   	push   %eax
  800df4:	6a 0d                	push   $0xd
  800df6:	68 7f 24 80 00       	push   $0x80247f
  800dfb:	6a 23                	push   $0x23
  800dfd:	68 9c 24 80 00       	push   $0x80249c
  800e02:	e8 6d 0f 00 00       	call   801d74 <_panic>

00800e07 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800e13:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800e15:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800e18:	83 3a 01             	cmpl   $0x1,(%edx)
  800e1b:	7e 09                	jle    800e26 <argstart+0x1f>
  800e1d:	ba 51 21 80 00       	mov    $0x802151,%edx
  800e22:	85 c9                	test   %ecx,%ecx
  800e24:	75 05                	jne    800e2b <argstart+0x24>
  800e26:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2b:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800e2e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    

00800e37 <argnext>:

int
argnext(struct Argstate *args)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	53                   	push   %ebx
  800e3b:	83 ec 04             	sub    $0x4,%esp
  800e3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800e41:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800e48:	8b 43 08             	mov    0x8(%ebx),%eax
  800e4b:	85 c0                	test   %eax,%eax
  800e4d:	74 72                	je     800ec1 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  800e4f:	80 38 00             	cmpb   $0x0,(%eax)
  800e52:	75 48                	jne    800e9c <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800e54:	8b 0b                	mov    (%ebx),%ecx
  800e56:	83 39 01             	cmpl   $0x1,(%ecx)
  800e59:	74 58                	je     800eb3 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  800e5b:	8b 53 04             	mov    0x4(%ebx),%edx
  800e5e:	8b 42 04             	mov    0x4(%edx),%eax
  800e61:	80 38 2d             	cmpb   $0x2d,(%eax)
  800e64:	75 4d                	jne    800eb3 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  800e66:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800e6a:	74 47                	je     800eb3 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800e6c:	83 c0 01             	add    $0x1,%eax
  800e6f:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	8b 01                	mov    (%ecx),%eax
  800e77:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800e7e:	50                   	push   %eax
  800e7f:	8d 42 08             	lea    0x8(%edx),%eax
  800e82:	50                   	push   %eax
  800e83:	83 c2 04             	add    $0x4,%edx
  800e86:	52                   	push   %edx
  800e87:	e8 1f fb ff ff       	call   8009ab <memmove>
		(*args->argc)--;
  800e8c:	8b 03                	mov    (%ebx),%eax
  800e8e:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800e91:	8b 43 08             	mov    0x8(%ebx),%eax
  800e94:	83 c4 10             	add    $0x10,%esp
  800e97:	80 38 2d             	cmpb   $0x2d,(%eax)
  800e9a:	74 11                	je     800ead <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800e9c:	8b 53 08             	mov    0x8(%ebx),%edx
  800e9f:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  800ea2:	83 c2 01             	add    $0x1,%edx
  800ea5:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  800ea8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800ead:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800eb1:	75 e9                	jne    800e9c <argnext+0x65>
	args->curarg = 0;
  800eb3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  800eba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800ebf:	eb e7                	jmp    800ea8 <argnext+0x71>
		return -1;
  800ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800ec6:	eb e0                	jmp    800ea8 <argnext+0x71>

00800ec8 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	53                   	push   %ebx
  800ecc:	83 ec 04             	sub    $0x4,%esp
  800ecf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  800ed2:	8b 43 08             	mov    0x8(%ebx),%eax
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	74 5b                	je     800f34 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  800ed9:	80 38 00             	cmpb   $0x0,(%eax)
  800edc:	74 12                	je     800ef0 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  800ede:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  800ee1:	c7 43 08 51 21 80 00 	movl   $0x802151,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  800ee8:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  800eeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eee:	c9                   	leave  
  800eef:	c3                   	ret    
	} else if (*args->argc > 1) {
  800ef0:	8b 13                	mov    (%ebx),%edx
  800ef2:	83 3a 01             	cmpl   $0x1,(%edx)
  800ef5:	7f 10                	jg     800f07 <argnextvalue+0x3f>
		args->argvalue = 0;
  800ef7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  800efe:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  800f05:	eb e1                	jmp    800ee8 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  800f07:	8b 43 04             	mov    0x4(%ebx),%eax
  800f0a:	8b 48 04             	mov    0x4(%eax),%ecx
  800f0d:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800f10:	83 ec 04             	sub    $0x4,%esp
  800f13:	8b 12                	mov    (%edx),%edx
  800f15:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  800f1c:	52                   	push   %edx
  800f1d:	8d 50 08             	lea    0x8(%eax),%edx
  800f20:	52                   	push   %edx
  800f21:	83 c0 04             	add    $0x4,%eax
  800f24:	50                   	push   %eax
  800f25:	e8 81 fa ff ff       	call   8009ab <memmove>
		(*args->argc)--;
  800f2a:	8b 03                	mov    (%ebx),%eax
  800f2c:	83 28 01             	subl   $0x1,(%eax)
  800f2f:	83 c4 10             	add    $0x10,%esp
  800f32:	eb b4                	jmp    800ee8 <argnextvalue+0x20>
		return 0;
  800f34:	b8 00 00 00 00       	mov    $0x0,%eax
  800f39:	eb b0                	jmp    800eeb <argnextvalue+0x23>

00800f3b <argvalue>:
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 08             	sub    $0x8,%esp
  800f41:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800f44:	8b 42 0c             	mov    0xc(%edx),%eax
  800f47:	85 c0                	test   %eax,%eax
  800f49:	74 02                	je     800f4d <argvalue+0x12>
}
  800f4b:	c9                   	leave  
  800f4c:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800f4d:	83 ec 0c             	sub    $0xc,%esp
  800f50:	52                   	push   %edx
  800f51:	e8 72 ff ff ff       	call   800ec8 <argnextvalue>
  800f56:	83 c4 10             	add    $0x10,%esp
  800f59:	eb f0                	jmp    800f4b <argvalue+0x10>

00800f5b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	05 00 00 00 30       	add    $0x30000000,%eax
  800f66:	c1 e8 0c             	shr    $0xc,%eax
}
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f7b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    

00800f82 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f88:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f8d:	89 c2                	mov    %eax,%edx
  800f8f:	c1 ea 16             	shr    $0x16,%edx
  800f92:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f99:	f6 c2 01             	test   $0x1,%dl
  800f9c:	74 2a                	je     800fc8 <fd_alloc+0x46>
  800f9e:	89 c2                	mov    %eax,%edx
  800fa0:	c1 ea 0c             	shr    $0xc,%edx
  800fa3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800faa:	f6 c2 01             	test   $0x1,%dl
  800fad:	74 19                	je     800fc8 <fd_alloc+0x46>
  800faf:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800fb4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fb9:	75 d2                	jne    800f8d <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fbb:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800fc1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fc6:	eb 07                	jmp    800fcf <fd_alloc+0x4d>
			*fd_store = fd;
  800fc8:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    

00800fd1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fd7:	83 f8 1f             	cmp    $0x1f,%eax
  800fda:	77 36                	ja     801012 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fdc:	c1 e0 0c             	shl    $0xc,%eax
  800fdf:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fe4:	89 c2                	mov    %eax,%edx
  800fe6:	c1 ea 16             	shr    $0x16,%edx
  800fe9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ff0:	f6 c2 01             	test   $0x1,%dl
  800ff3:	74 24                	je     801019 <fd_lookup+0x48>
  800ff5:	89 c2                	mov    %eax,%edx
  800ff7:	c1 ea 0c             	shr    $0xc,%edx
  800ffa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801001:	f6 c2 01             	test   $0x1,%dl
  801004:	74 1a                	je     801020 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801006:	8b 55 0c             	mov    0xc(%ebp),%edx
  801009:	89 02                	mov    %eax,(%edx)
	return 0;
  80100b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    
		return -E_INVAL;
  801012:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801017:	eb f7                	jmp    801010 <fd_lookup+0x3f>
		return -E_INVAL;
  801019:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80101e:	eb f0                	jmp    801010 <fd_lookup+0x3f>
  801020:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801025:	eb e9                	jmp    801010 <fd_lookup+0x3f>

00801027 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	83 ec 08             	sub    $0x8,%esp
  80102d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801030:	ba 28 25 80 00       	mov    $0x802528,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801035:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80103a:	39 08                	cmp    %ecx,(%eax)
  80103c:	74 33                	je     801071 <dev_lookup+0x4a>
  80103e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801041:	8b 02                	mov    (%edx),%eax
  801043:	85 c0                	test   %eax,%eax
  801045:	75 f3                	jne    80103a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801047:	a1 04 40 80 00       	mov    0x804004,%eax
  80104c:	8b 40 48             	mov    0x48(%eax),%eax
  80104f:	83 ec 04             	sub    $0x4,%esp
  801052:	51                   	push   %ecx
  801053:	50                   	push   %eax
  801054:	68 ac 24 80 00       	push   $0x8024ac
  801059:	e8 a0 f1 ff ff       	call   8001fe <cprintf>
	*dev = 0;
  80105e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801061:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801067:	83 c4 10             	add    $0x10,%esp
  80106a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80106f:	c9                   	leave  
  801070:	c3                   	ret    
			*dev = devtab[i];
  801071:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801074:	89 01                	mov    %eax,(%ecx)
			return 0;
  801076:	b8 00 00 00 00       	mov    $0x0,%eax
  80107b:	eb f2                	jmp    80106f <dev_lookup+0x48>

0080107d <fd_close>:
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	57                   	push   %edi
  801081:	56                   	push   %esi
  801082:	53                   	push   %ebx
  801083:	83 ec 1c             	sub    $0x1c,%esp
  801086:	8b 75 08             	mov    0x8(%ebp),%esi
  801089:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80108c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80108f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801090:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801096:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801099:	50                   	push   %eax
  80109a:	e8 32 ff ff ff       	call   800fd1 <fd_lookup>
  80109f:	89 c3                	mov    %eax,%ebx
  8010a1:	83 c4 08             	add    $0x8,%esp
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	78 05                	js     8010ad <fd_close+0x30>
	    || fd != fd2)
  8010a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010ab:	74 16                	je     8010c3 <fd_close+0x46>
		return (must_exist ? r : 0);
  8010ad:	89 f8                	mov    %edi,%eax
  8010af:	84 c0                	test   %al,%al
  8010b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b6:	0f 44 d8             	cmove  %eax,%ebx
}
  8010b9:	89 d8                	mov    %ebx,%eax
  8010bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010be:	5b                   	pop    %ebx
  8010bf:	5e                   	pop    %esi
  8010c0:	5f                   	pop    %edi
  8010c1:	5d                   	pop    %ebp
  8010c2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010c3:	83 ec 08             	sub    $0x8,%esp
  8010c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010c9:	50                   	push   %eax
  8010ca:	ff 36                	pushl  (%esi)
  8010cc:	e8 56 ff ff ff       	call   801027 <dev_lookup>
  8010d1:	89 c3                	mov    %eax,%ebx
  8010d3:	83 c4 10             	add    $0x10,%esp
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	78 15                	js     8010ef <fd_close+0x72>
		if (dev->dev_close)
  8010da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010dd:	8b 40 10             	mov    0x10(%eax),%eax
  8010e0:	85 c0                	test   %eax,%eax
  8010e2:	74 1b                	je     8010ff <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8010e4:	83 ec 0c             	sub    $0xc,%esp
  8010e7:	56                   	push   %esi
  8010e8:	ff d0                	call   *%eax
  8010ea:	89 c3                	mov    %eax,%ebx
  8010ec:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010ef:	83 ec 08             	sub    $0x8,%esp
  8010f2:	56                   	push   %esi
  8010f3:	6a 00                	push   $0x0
  8010f5:	e8 a1 fb ff ff       	call   800c9b <sys_page_unmap>
	return r;
  8010fa:	83 c4 10             	add    $0x10,%esp
  8010fd:	eb ba                	jmp    8010b9 <fd_close+0x3c>
			r = 0;
  8010ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801104:	eb e9                	jmp    8010ef <fd_close+0x72>

00801106 <close>:

int
close(int fdnum)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80110c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80110f:	50                   	push   %eax
  801110:	ff 75 08             	pushl  0x8(%ebp)
  801113:	e8 b9 fe ff ff       	call   800fd1 <fd_lookup>
  801118:	83 c4 08             	add    $0x8,%esp
  80111b:	85 c0                	test   %eax,%eax
  80111d:	78 10                	js     80112f <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80111f:	83 ec 08             	sub    $0x8,%esp
  801122:	6a 01                	push   $0x1
  801124:	ff 75 f4             	pushl  -0xc(%ebp)
  801127:	e8 51 ff ff ff       	call   80107d <fd_close>
  80112c:	83 c4 10             	add    $0x10,%esp
}
  80112f:	c9                   	leave  
  801130:	c3                   	ret    

00801131 <close_all>:

void
close_all(void)
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	53                   	push   %ebx
  801135:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801138:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80113d:	83 ec 0c             	sub    $0xc,%esp
  801140:	53                   	push   %ebx
  801141:	e8 c0 ff ff ff       	call   801106 <close>
	for (i = 0; i < MAXFD; i++)
  801146:	83 c3 01             	add    $0x1,%ebx
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	83 fb 20             	cmp    $0x20,%ebx
  80114f:	75 ec                	jne    80113d <close_all+0xc>
}
  801151:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	57                   	push   %edi
  80115a:	56                   	push   %esi
  80115b:	53                   	push   %ebx
  80115c:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80115f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801162:	50                   	push   %eax
  801163:	ff 75 08             	pushl  0x8(%ebp)
  801166:	e8 66 fe ff ff       	call   800fd1 <fd_lookup>
  80116b:	89 c3                	mov    %eax,%ebx
  80116d:	83 c4 08             	add    $0x8,%esp
  801170:	85 c0                	test   %eax,%eax
  801172:	0f 88 81 00 00 00    	js     8011f9 <dup+0xa3>
		return r;
	close(newfdnum);
  801178:	83 ec 0c             	sub    $0xc,%esp
  80117b:	ff 75 0c             	pushl  0xc(%ebp)
  80117e:	e8 83 ff ff ff       	call   801106 <close>

	newfd = INDEX2FD(newfdnum);
  801183:	8b 75 0c             	mov    0xc(%ebp),%esi
  801186:	c1 e6 0c             	shl    $0xc,%esi
  801189:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80118f:	83 c4 04             	add    $0x4,%esp
  801192:	ff 75 e4             	pushl  -0x1c(%ebp)
  801195:	e8 d1 fd ff ff       	call   800f6b <fd2data>
  80119a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80119c:	89 34 24             	mov    %esi,(%esp)
  80119f:	e8 c7 fd ff ff       	call   800f6b <fd2data>
  8011a4:	83 c4 10             	add    $0x10,%esp
  8011a7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011a9:	89 d8                	mov    %ebx,%eax
  8011ab:	c1 e8 16             	shr    $0x16,%eax
  8011ae:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011b5:	a8 01                	test   $0x1,%al
  8011b7:	74 11                	je     8011ca <dup+0x74>
  8011b9:	89 d8                	mov    %ebx,%eax
  8011bb:	c1 e8 0c             	shr    $0xc,%eax
  8011be:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011c5:	f6 c2 01             	test   $0x1,%dl
  8011c8:	75 39                	jne    801203 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011cd:	89 d0                	mov    %edx,%eax
  8011cf:	c1 e8 0c             	shr    $0xc,%eax
  8011d2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011d9:	83 ec 0c             	sub    $0xc,%esp
  8011dc:	25 07 0e 00 00       	and    $0xe07,%eax
  8011e1:	50                   	push   %eax
  8011e2:	56                   	push   %esi
  8011e3:	6a 00                	push   $0x0
  8011e5:	52                   	push   %edx
  8011e6:	6a 00                	push   $0x0
  8011e8:	e8 6c fa ff ff       	call   800c59 <sys_page_map>
  8011ed:	89 c3                	mov    %eax,%ebx
  8011ef:	83 c4 20             	add    $0x20,%esp
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	78 31                	js     801227 <dup+0xd1>
		goto err;

	return newfdnum;
  8011f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011f9:	89 d8                	mov    %ebx,%eax
  8011fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011fe:	5b                   	pop    %ebx
  8011ff:	5e                   	pop    %esi
  801200:	5f                   	pop    %edi
  801201:	5d                   	pop    %ebp
  801202:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801203:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80120a:	83 ec 0c             	sub    $0xc,%esp
  80120d:	25 07 0e 00 00       	and    $0xe07,%eax
  801212:	50                   	push   %eax
  801213:	57                   	push   %edi
  801214:	6a 00                	push   $0x0
  801216:	53                   	push   %ebx
  801217:	6a 00                	push   $0x0
  801219:	e8 3b fa ff ff       	call   800c59 <sys_page_map>
  80121e:	89 c3                	mov    %eax,%ebx
  801220:	83 c4 20             	add    $0x20,%esp
  801223:	85 c0                	test   %eax,%eax
  801225:	79 a3                	jns    8011ca <dup+0x74>
	sys_page_unmap(0, newfd);
  801227:	83 ec 08             	sub    $0x8,%esp
  80122a:	56                   	push   %esi
  80122b:	6a 00                	push   $0x0
  80122d:	e8 69 fa ff ff       	call   800c9b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801232:	83 c4 08             	add    $0x8,%esp
  801235:	57                   	push   %edi
  801236:	6a 00                	push   $0x0
  801238:	e8 5e fa ff ff       	call   800c9b <sys_page_unmap>
	return r;
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	eb b7                	jmp    8011f9 <dup+0xa3>

00801242 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	53                   	push   %ebx
  801246:	83 ec 14             	sub    $0x14,%esp
  801249:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80124c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80124f:	50                   	push   %eax
  801250:	53                   	push   %ebx
  801251:	e8 7b fd ff ff       	call   800fd1 <fd_lookup>
  801256:	83 c4 08             	add    $0x8,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	78 3f                	js     80129c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80125d:	83 ec 08             	sub    $0x8,%esp
  801260:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801263:	50                   	push   %eax
  801264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801267:	ff 30                	pushl  (%eax)
  801269:	e8 b9 fd ff ff       	call   801027 <dev_lookup>
  80126e:	83 c4 10             	add    $0x10,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	78 27                	js     80129c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801275:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801278:	8b 42 08             	mov    0x8(%edx),%eax
  80127b:	83 e0 03             	and    $0x3,%eax
  80127e:	83 f8 01             	cmp    $0x1,%eax
  801281:	74 1e                	je     8012a1 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801286:	8b 40 08             	mov    0x8(%eax),%eax
  801289:	85 c0                	test   %eax,%eax
  80128b:	74 35                	je     8012c2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80128d:	83 ec 04             	sub    $0x4,%esp
  801290:	ff 75 10             	pushl  0x10(%ebp)
  801293:	ff 75 0c             	pushl  0xc(%ebp)
  801296:	52                   	push   %edx
  801297:	ff d0                	call   *%eax
  801299:	83 c4 10             	add    $0x10,%esp
}
  80129c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012a1:	a1 04 40 80 00       	mov    0x804004,%eax
  8012a6:	8b 40 48             	mov    0x48(%eax),%eax
  8012a9:	83 ec 04             	sub    $0x4,%esp
  8012ac:	53                   	push   %ebx
  8012ad:	50                   	push   %eax
  8012ae:	68 ed 24 80 00       	push   $0x8024ed
  8012b3:	e8 46 ef ff ff       	call   8001fe <cprintf>
		return -E_INVAL;
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c0:	eb da                	jmp    80129c <read+0x5a>
		return -E_NOT_SUPP;
  8012c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012c7:	eb d3                	jmp    80129c <read+0x5a>

008012c9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	57                   	push   %edi
  8012cd:	56                   	push   %esi
  8012ce:	53                   	push   %ebx
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012d5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012dd:	39 f3                	cmp    %esi,%ebx
  8012df:	73 25                	jae    801306 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012e1:	83 ec 04             	sub    $0x4,%esp
  8012e4:	89 f0                	mov    %esi,%eax
  8012e6:	29 d8                	sub    %ebx,%eax
  8012e8:	50                   	push   %eax
  8012e9:	89 d8                	mov    %ebx,%eax
  8012eb:	03 45 0c             	add    0xc(%ebp),%eax
  8012ee:	50                   	push   %eax
  8012ef:	57                   	push   %edi
  8012f0:	e8 4d ff ff ff       	call   801242 <read>
		if (m < 0)
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	78 08                	js     801304 <readn+0x3b>
			return m;
		if (m == 0)
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	74 06                	je     801306 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801300:	01 c3                	add    %eax,%ebx
  801302:	eb d9                	jmp    8012dd <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801304:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801306:	89 d8                	mov    %ebx,%eax
  801308:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130b:	5b                   	pop    %ebx
  80130c:	5e                   	pop    %esi
  80130d:	5f                   	pop    %edi
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    

00801310 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	53                   	push   %ebx
  801314:	83 ec 14             	sub    $0x14,%esp
  801317:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80131a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80131d:	50                   	push   %eax
  80131e:	53                   	push   %ebx
  80131f:	e8 ad fc ff ff       	call   800fd1 <fd_lookup>
  801324:	83 c4 08             	add    $0x8,%esp
  801327:	85 c0                	test   %eax,%eax
  801329:	78 3a                	js     801365 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80132b:	83 ec 08             	sub    $0x8,%esp
  80132e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801335:	ff 30                	pushl  (%eax)
  801337:	e8 eb fc ff ff       	call   801027 <dev_lookup>
  80133c:	83 c4 10             	add    $0x10,%esp
  80133f:	85 c0                	test   %eax,%eax
  801341:	78 22                	js     801365 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801346:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80134a:	74 1e                	je     80136a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80134c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80134f:	8b 52 0c             	mov    0xc(%edx),%edx
  801352:	85 d2                	test   %edx,%edx
  801354:	74 35                	je     80138b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801356:	83 ec 04             	sub    $0x4,%esp
  801359:	ff 75 10             	pushl  0x10(%ebp)
  80135c:	ff 75 0c             	pushl  0xc(%ebp)
  80135f:	50                   	push   %eax
  801360:	ff d2                	call   *%edx
  801362:	83 c4 10             	add    $0x10,%esp
}
  801365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801368:	c9                   	leave  
  801369:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80136a:	a1 04 40 80 00       	mov    0x804004,%eax
  80136f:	8b 40 48             	mov    0x48(%eax),%eax
  801372:	83 ec 04             	sub    $0x4,%esp
  801375:	53                   	push   %ebx
  801376:	50                   	push   %eax
  801377:	68 09 25 80 00       	push   $0x802509
  80137c:	e8 7d ee ff ff       	call   8001fe <cprintf>
		return -E_INVAL;
  801381:	83 c4 10             	add    $0x10,%esp
  801384:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801389:	eb da                	jmp    801365 <write+0x55>
		return -E_NOT_SUPP;
  80138b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801390:	eb d3                	jmp    801365 <write+0x55>

00801392 <seek>:

int
seek(int fdnum, off_t offset)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801398:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80139b:	50                   	push   %eax
  80139c:	ff 75 08             	pushl  0x8(%ebp)
  80139f:	e8 2d fc ff ff       	call   800fd1 <fd_lookup>
  8013a4:	83 c4 08             	add    $0x8,%esp
  8013a7:	85 c0                	test   %eax,%eax
  8013a9:	78 0e                	js     8013b9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	53                   	push   %ebx
  8013bf:	83 ec 14             	sub    $0x14,%esp
  8013c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c8:	50                   	push   %eax
  8013c9:	53                   	push   %ebx
  8013ca:	e8 02 fc ff ff       	call   800fd1 <fd_lookup>
  8013cf:	83 c4 08             	add    $0x8,%esp
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	78 37                	js     80140d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d6:	83 ec 08             	sub    $0x8,%esp
  8013d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013dc:	50                   	push   %eax
  8013dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e0:	ff 30                	pushl  (%eax)
  8013e2:	e8 40 fc ff ff       	call   801027 <dev_lookup>
  8013e7:	83 c4 10             	add    $0x10,%esp
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	78 1f                	js     80140d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013f5:	74 1b                	je     801412 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fa:	8b 52 18             	mov    0x18(%edx),%edx
  8013fd:	85 d2                	test   %edx,%edx
  8013ff:	74 32                	je     801433 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801401:	83 ec 08             	sub    $0x8,%esp
  801404:	ff 75 0c             	pushl  0xc(%ebp)
  801407:	50                   	push   %eax
  801408:	ff d2                	call   *%edx
  80140a:	83 c4 10             	add    $0x10,%esp
}
  80140d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801410:	c9                   	leave  
  801411:	c3                   	ret    
			thisenv->env_id, fdnum);
  801412:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801417:	8b 40 48             	mov    0x48(%eax),%eax
  80141a:	83 ec 04             	sub    $0x4,%esp
  80141d:	53                   	push   %ebx
  80141e:	50                   	push   %eax
  80141f:	68 cc 24 80 00       	push   $0x8024cc
  801424:	e8 d5 ed ff ff       	call   8001fe <cprintf>
		return -E_INVAL;
  801429:	83 c4 10             	add    $0x10,%esp
  80142c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801431:	eb da                	jmp    80140d <ftruncate+0x52>
		return -E_NOT_SUPP;
  801433:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801438:	eb d3                	jmp    80140d <ftruncate+0x52>

0080143a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	53                   	push   %ebx
  80143e:	83 ec 14             	sub    $0x14,%esp
  801441:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801444:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801447:	50                   	push   %eax
  801448:	ff 75 08             	pushl  0x8(%ebp)
  80144b:	e8 81 fb ff ff       	call   800fd1 <fd_lookup>
  801450:	83 c4 08             	add    $0x8,%esp
  801453:	85 c0                	test   %eax,%eax
  801455:	78 4b                	js     8014a2 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801457:	83 ec 08             	sub    $0x8,%esp
  80145a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145d:	50                   	push   %eax
  80145e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801461:	ff 30                	pushl  (%eax)
  801463:	e8 bf fb ff ff       	call   801027 <dev_lookup>
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	85 c0                	test   %eax,%eax
  80146d:	78 33                	js     8014a2 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80146f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801472:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801476:	74 2f                	je     8014a7 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801478:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80147b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801482:	00 00 00 
	stat->st_isdir = 0;
  801485:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80148c:	00 00 00 
	stat->st_dev = dev;
  80148f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801495:	83 ec 08             	sub    $0x8,%esp
  801498:	53                   	push   %ebx
  801499:	ff 75 f0             	pushl  -0x10(%ebp)
  80149c:	ff 50 14             	call   *0x14(%eax)
  80149f:	83 c4 10             	add    $0x10,%esp
}
  8014a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    
		return -E_NOT_SUPP;
  8014a7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ac:	eb f4                	jmp    8014a2 <fstat+0x68>

008014ae <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	56                   	push   %esi
  8014b2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014b3:	83 ec 08             	sub    $0x8,%esp
  8014b6:	6a 00                	push   $0x0
  8014b8:	ff 75 08             	pushl  0x8(%ebp)
  8014bb:	e8 30 02 00 00       	call   8016f0 <open>
  8014c0:	89 c3                	mov    %eax,%ebx
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	78 1b                	js     8014e4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	ff 75 0c             	pushl  0xc(%ebp)
  8014cf:	50                   	push   %eax
  8014d0:	e8 65 ff ff ff       	call   80143a <fstat>
  8014d5:	89 c6                	mov    %eax,%esi
	close(fd);
  8014d7:	89 1c 24             	mov    %ebx,(%esp)
  8014da:	e8 27 fc ff ff       	call   801106 <close>
	return r;
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	89 f3                	mov    %esi,%ebx
}
  8014e4:	89 d8                	mov    %ebx,%eax
  8014e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e9:	5b                   	pop    %ebx
  8014ea:	5e                   	pop    %esi
  8014eb:	5d                   	pop    %ebp
  8014ec:	c3                   	ret    

008014ed <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	56                   	push   %esi
  8014f1:	53                   	push   %ebx
  8014f2:	89 c6                	mov    %eax,%esi
  8014f4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014f6:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014fd:	74 27                	je     801526 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014ff:	6a 07                	push   $0x7
  801501:	68 00 50 80 00       	push   $0x805000
  801506:	56                   	push   %esi
  801507:	ff 35 00 40 80 00    	pushl  0x804000
  80150d:	e8 11 09 00 00       	call   801e23 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801512:	83 c4 0c             	add    $0xc,%esp
  801515:	6a 00                	push   $0x0
  801517:	53                   	push   %ebx
  801518:	6a 00                	push   $0x0
  80151a:	e8 9b 08 00 00       	call   801dba <ipc_recv>
}
  80151f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801522:	5b                   	pop    %ebx
  801523:	5e                   	pop    %esi
  801524:	5d                   	pop    %ebp
  801525:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	6a 01                	push   $0x1
  80152b:	e8 47 09 00 00       	call   801e77 <ipc_find_env>
  801530:	a3 00 40 80 00       	mov    %eax,0x804000
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	eb c5                	jmp    8014ff <fsipc+0x12>

0080153a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	8b 40 0c             	mov    0xc(%eax),%eax
  801546:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80154b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801553:	ba 00 00 00 00       	mov    $0x0,%edx
  801558:	b8 02 00 00 00       	mov    $0x2,%eax
  80155d:	e8 8b ff ff ff       	call   8014ed <fsipc>
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <devfile_flush>:
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	8b 40 0c             	mov    0xc(%eax),%eax
  801570:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801575:	ba 00 00 00 00       	mov    $0x0,%edx
  80157a:	b8 06 00 00 00       	mov    $0x6,%eax
  80157f:	e8 69 ff ff ff       	call   8014ed <fsipc>
}
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <devfile_stat>:
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	53                   	push   %ebx
  80158a:	83 ec 04             	sub    $0x4,%esp
  80158d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	8b 40 0c             	mov    0xc(%eax),%eax
  801596:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80159b:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8015a5:	e8 43 ff ff ff       	call   8014ed <fsipc>
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	78 2c                	js     8015da <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015ae:	83 ec 08             	sub    $0x8,%esp
  8015b1:	68 00 50 80 00       	push   $0x805000
  8015b6:	53                   	push   %ebx
  8015b7:	e8 61 f2 ff ff       	call   80081d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015bc:	a1 80 50 80 00       	mov    0x805080,%eax
  8015c1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015c7:	a1 84 50 80 00       	mov    0x805084,%eax
  8015cc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <devfile_write>:
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	53                   	push   %ebx
  8015e3:	83 ec 08             	sub    $0x8,%esp
  8015e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  8015e9:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8015ef:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8015f4:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8015fd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801602:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801608:	53                   	push   %ebx
  801609:	ff 75 0c             	pushl  0xc(%ebp)
  80160c:	68 08 50 80 00       	push   $0x805008
  801611:	e8 95 f3 ff ff       	call   8009ab <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801616:	ba 00 00 00 00       	mov    $0x0,%edx
  80161b:	b8 04 00 00 00       	mov    $0x4,%eax
  801620:	e8 c8 fe ff ff       	call   8014ed <fsipc>
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	85 c0                	test   %eax,%eax
  80162a:	78 0b                	js     801637 <devfile_write+0x58>
	assert(r <= n);
  80162c:	39 d8                	cmp    %ebx,%eax
  80162e:	77 0c                	ja     80163c <devfile_write+0x5d>
	assert(r <= PGSIZE);
  801630:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801635:	7f 1e                	jg     801655 <devfile_write+0x76>
}
  801637:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    
	assert(r <= n);
  80163c:	68 38 25 80 00       	push   $0x802538
  801641:	68 3f 25 80 00       	push   $0x80253f
  801646:	68 98 00 00 00       	push   $0x98
  80164b:	68 54 25 80 00       	push   $0x802554
  801650:	e8 1f 07 00 00       	call   801d74 <_panic>
	assert(r <= PGSIZE);
  801655:	68 5f 25 80 00       	push   $0x80255f
  80165a:	68 3f 25 80 00       	push   $0x80253f
  80165f:	68 99 00 00 00       	push   $0x99
  801664:	68 54 25 80 00       	push   $0x802554
  801669:	e8 06 07 00 00       	call   801d74 <_panic>

0080166e <devfile_read>:
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	56                   	push   %esi
  801672:	53                   	push   %ebx
  801673:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8b 40 0c             	mov    0xc(%eax),%eax
  80167c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801681:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801687:	ba 00 00 00 00       	mov    $0x0,%edx
  80168c:	b8 03 00 00 00       	mov    $0x3,%eax
  801691:	e8 57 fe ff ff       	call   8014ed <fsipc>
  801696:	89 c3                	mov    %eax,%ebx
  801698:	85 c0                	test   %eax,%eax
  80169a:	78 1f                	js     8016bb <devfile_read+0x4d>
	assert(r <= n);
  80169c:	39 f0                	cmp    %esi,%eax
  80169e:	77 24                	ja     8016c4 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016a0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016a5:	7f 33                	jg     8016da <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016a7:	83 ec 04             	sub    $0x4,%esp
  8016aa:	50                   	push   %eax
  8016ab:	68 00 50 80 00       	push   $0x805000
  8016b0:	ff 75 0c             	pushl  0xc(%ebp)
  8016b3:	e8 f3 f2 ff ff       	call   8009ab <memmove>
	return r;
  8016b8:	83 c4 10             	add    $0x10,%esp
}
  8016bb:	89 d8                	mov    %ebx,%eax
  8016bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c0:	5b                   	pop    %ebx
  8016c1:	5e                   	pop    %esi
  8016c2:	5d                   	pop    %ebp
  8016c3:	c3                   	ret    
	assert(r <= n);
  8016c4:	68 38 25 80 00       	push   $0x802538
  8016c9:	68 3f 25 80 00       	push   $0x80253f
  8016ce:	6a 7c                	push   $0x7c
  8016d0:	68 54 25 80 00       	push   $0x802554
  8016d5:	e8 9a 06 00 00       	call   801d74 <_panic>
	assert(r <= PGSIZE);
  8016da:	68 5f 25 80 00       	push   $0x80255f
  8016df:	68 3f 25 80 00       	push   $0x80253f
  8016e4:	6a 7d                	push   $0x7d
  8016e6:	68 54 25 80 00       	push   $0x802554
  8016eb:	e8 84 06 00 00       	call   801d74 <_panic>

008016f0 <open>:
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	56                   	push   %esi
  8016f4:	53                   	push   %ebx
  8016f5:	83 ec 1c             	sub    $0x1c,%esp
  8016f8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016fb:	56                   	push   %esi
  8016fc:	e8 e5 f0 ff ff       	call   8007e6 <strlen>
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801709:	7f 6c                	jg     801777 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80170b:	83 ec 0c             	sub    $0xc,%esp
  80170e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801711:	50                   	push   %eax
  801712:	e8 6b f8 ff ff       	call   800f82 <fd_alloc>
  801717:	89 c3                	mov    %eax,%ebx
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	85 c0                	test   %eax,%eax
  80171e:	78 3c                	js     80175c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801720:	83 ec 08             	sub    $0x8,%esp
  801723:	56                   	push   %esi
  801724:	68 00 50 80 00       	push   $0x805000
  801729:	e8 ef f0 ff ff       	call   80081d <strcpy>
	fsipcbuf.open.req_omode = mode;
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801736:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801739:	b8 01 00 00 00       	mov    $0x1,%eax
  80173e:	e8 aa fd ff ff       	call   8014ed <fsipc>
  801743:	89 c3                	mov    %eax,%ebx
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	85 c0                	test   %eax,%eax
  80174a:	78 19                	js     801765 <open+0x75>
	return fd2num(fd);
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	ff 75 f4             	pushl  -0xc(%ebp)
  801752:	e8 04 f8 ff ff       	call   800f5b <fd2num>
  801757:	89 c3                	mov    %eax,%ebx
  801759:	83 c4 10             	add    $0x10,%esp
}
  80175c:	89 d8                	mov    %ebx,%eax
  80175e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801761:	5b                   	pop    %ebx
  801762:	5e                   	pop    %esi
  801763:	5d                   	pop    %ebp
  801764:	c3                   	ret    
		fd_close(fd, 0);
  801765:	83 ec 08             	sub    $0x8,%esp
  801768:	6a 00                	push   $0x0
  80176a:	ff 75 f4             	pushl  -0xc(%ebp)
  80176d:	e8 0b f9 ff ff       	call   80107d <fd_close>
		return r;
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	eb e5                	jmp    80175c <open+0x6c>
		return -E_BAD_PATH;
  801777:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80177c:	eb de                	jmp    80175c <open+0x6c>

0080177e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801784:	ba 00 00 00 00       	mov    $0x0,%edx
  801789:	b8 08 00 00 00       	mov    $0x8,%eax
  80178e:	e8 5a fd ff ff       	call   8014ed <fsipc>
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801795:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801799:	7e 38                	jle    8017d3 <writebuf+0x3e>
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	53                   	push   %ebx
  80179f:	83 ec 08             	sub    $0x8,%esp
  8017a2:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8017a4:	ff 70 04             	pushl  0x4(%eax)
  8017a7:	8d 40 10             	lea    0x10(%eax),%eax
  8017aa:	50                   	push   %eax
  8017ab:	ff 33                	pushl  (%ebx)
  8017ad:	e8 5e fb ff ff       	call   801310 <write>
		if (result > 0)
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	7e 03                	jle    8017bc <writebuf+0x27>
			b->result += result;
  8017b9:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8017bc:	39 43 04             	cmp    %eax,0x4(%ebx)
  8017bf:	74 0d                	je     8017ce <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c8:	0f 4f c2             	cmovg  %edx,%eax
  8017cb:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8017ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    
  8017d3:	f3 c3                	repz ret 

008017d5 <putch>:

static void
putch(int ch, void *thunk)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	53                   	push   %ebx
  8017d9:	83 ec 04             	sub    $0x4,%esp
  8017dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8017df:	8b 53 04             	mov    0x4(%ebx),%edx
  8017e2:	8d 42 01             	lea    0x1(%edx),%eax
  8017e5:	89 43 04             	mov    %eax,0x4(%ebx)
  8017e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017eb:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8017ef:	3d 00 01 00 00       	cmp    $0x100,%eax
  8017f4:	74 06                	je     8017fc <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8017f6:	83 c4 04             	add    $0x4,%esp
  8017f9:	5b                   	pop    %ebx
  8017fa:	5d                   	pop    %ebp
  8017fb:	c3                   	ret    
		writebuf(b);
  8017fc:	89 d8                	mov    %ebx,%eax
  8017fe:	e8 92 ff ff ff       	call   801795 <writebuf>
		b->idx = 0;
  801803:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  80180a:	eb ea                	jmp    8017f6 <putch+0x21>

0080180c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80181e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801825:	00 00 00 
	b.result = 0;
  801828:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80182f:	00 00 00 
	b.error = 1;
  801832:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801839:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80183c:	ff 75 10             	pushl  0x10(%ebp)
  80183f:	ff 75 0c             	pushl  0xc(%ebp)
  801842:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801848:	50                   	push   %eax
  801849:	68 d5 17 80 00       	push   $0x8017d5
  80184e:	e8 a8 ea ff ff       	call   8002fb <vprintfmt>
	if (b.idx > 0)
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80185d:	7f 11                	jg     801870 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80185f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801865:	85 c0                	test   %eax,%eax
  801867:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    
		writebuf(&b);
  801870:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801876:	e8 1a ff ff ff       	call   801795 <writebuf>
  80187b:	eb e2                	jmp    80185f <vfprintf+0x53>

0080187d <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801883:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801886:	50                   	push   %eax
  801887:	ff 75 0c             	pushl  0xc(%ebp)
  80188a:	ff 75 08             	pushl  0x8(%ebp)
  80188d:	e8 7a ff ff ff       	call   80180c <vfprintf>
	va_end(ap);

	return cnt;
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <printf>:

int
printf(const char *fmt, ...)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80189a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80189d:	50                   	push   %eax
  80189e:	ff 75 08             	pushl  0x8(%ebp)
  8018a1:	6a 01                	push   $0x1
  8018a3:	e8 64 ff ff ff       	call   80180c <vfprintf>
	va_end(ap);

	return cnt;
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	56                   	push   %esi
  8018ae:	53                   	push   %ebx
  8018af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018b2:	83 ec 0c             	sub    $0xc,%esp
  8018b5:	ff 75 08             	pushl  0x8(%ebp)
  8018b8:	e8 ae f6 ff ff       	call   800f6b <fd2data>
  8018bd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8018bf:	83 c4 08             	add    $0x8,%esp
  8018c2:	68 6b 25 80 00       	push   $0x80256b
  8018c7:	53                   	push   %ebx
  8018c8:	e8 50 ef ff ff       	call   80081d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8018cd:	8b 46 04             	mov    0x4(%esi),%eax
  8018d0:	2b 06                	sub    (%esi),%eax
  8018d2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8018d8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018df:	00 00 00 
	stat->st_dev = &devpipe;
  8018e2:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8018e9:	30 80 00 
	return 0;
}
  8018ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f4:	5b                   	pop    %ebx
  8018f5:	5e                   	pop    %esi
  8018f6:	5d                   	pop    %ebp
  8018f7:	c3                   	ret    

008018f8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	53                   	push   %ebx
  8018fc:	83 ec 0c             	sub    $0xc,%esp
  8018ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801902:	53                   	push   %ebx
  801903:	6a 00                	push   $0x0
  801905:	e8 91 f3 ff ff       	call   800c9b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80190a:	89 1c 24             	mov    %ebx,(%esp)
  80190d:	e8 59 f6 ff ff       	call   800f6b <fd2data>
  801912:	83 c4 08             	add    $0x8,%esp
  801915:	50                   	push   %eax
  801916:	6a 00                	push   $0x0
  801918:	e8 7e f3 ff ff       	call   800c9b <sys_page_unmap>
}
  80191d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <_pipeisclosed>:
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	57                   	push   %edi
  801926:	56                   	push   %esi
  801927:	53                   	push   %ebx
  801928:	83 ec 1c             	sub    $0x1c,%esp
  80192b:	89 c7                	mov    %eax,%edi
  80192d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80192f:	a1 04 40 80 00       	mov    0x804004,%eax
  801934:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801937:	83 ec 0c             	sub    $0xc,%esp
  80193a:	57                   	push   %edi
  80193b:	e8 70 05 00 00       	call   801eb0 <pageref>
  801940:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801943:	89 34 24             	mov    %esi,(%esp)
  801946:	e8 65 05 00 00       	call   801eb0 <pageref>
		nn = thisenv->env_runs;
  80194b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801951:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	39 cb                	cmp    %ecx,%ebx
  801959:	74 1b                	je     801976 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80195b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80195e:	75 cf                	jne    80192f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801960:	8b 42 58             	mov    0x58(%edx),%eax
  801963:	6a 01                	push   $0x1
  801965:	50                   	push   %eax
  801966:	53                   	push   %ebx
  801967:	68 72 25 80 00       	push   $0x802572
  80196c:	e8 8d e8 ff ff       	call   8001fe <cprintf>
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	eb b9                	jmp    80192f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801976:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801979:	0f 94 c0             	sete   %al
  80197c:	0f b6 c0             	movzbl %al,%eax
}
  80197f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801982:	5b                   	pop    %ebx
  801983:	5e                   	pop    %esi
  801984:	5f                   	pop    %edi
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    

00801987 <devpipe_write>:
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	57                   	push   %edi
  80198b:	56                   	push   %esi
  80198c:	53                   	push   %ebx
  80198d:	83 ec 28             	sub    $0x28,%esp
  801990:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801993:	56                   	push   %esi
  801994:	e8 d2 f5 ff ff       	call   800f6b <fd2data>
  801999:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80199b:	83 c4 10             	add    $0x10,%esp
  80199e:	bf 00 00 00 00       	mov    $0x0,%edi
  8019a3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8019a6:	74 4f                	je     8019f7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019a8:	8b 43 04             	mov    0x4(%ebx),%eax
  8019ab:	8b 0b                	mov    (%ebx),%ecx
  8019ad:	8d 51 20             	lea    0x20(%ecx),%edx
  8019b0:	39 d0                	cmp    %edx,%eax
  8019b2:	72 14                	jb     8019c8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8019b4:	89 da                	mov    %ebx,%edx
  8019b6:	89 f0                	mov    %esi,%eax
  8019b8:	e8 65 ff ff ff       	call   801922 <_pipeisclosed>
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	75 3a                	jne    8019fb <devpipe_write+0x74>
			sys_yield();
  8019c1:	e8 31 f2 ff ff       	call   800bf7 <sys_yield>
  8019c6:	eb e0                	jmp    8019a8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019cb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8019cf:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8019d2:	89 c2                	mov    %eax,%edx
  8019d4:	c1 fa 1f             	sar    $0x1f,%edx
  8019d7:	89 d1                	mov    %edx,%ecx
  8019d9:	c1 e9 1b             	shr    $0x1b,%ecx
  8019dc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8019df:	83 e2 1f             	and    $0x1f,%edx
  8019e2:	29 ca                	sub    %ecx,%edx
  8019e4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8019e8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8019ec:	83 c0 01             	add    $0x1,%eax
  8019ef:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8019f2:	83 c7 01             	add    $0x1,%edi
  8019f5:	eb ac                	jmp    8019a3 <devpipe_write+0x1c>
	return i;
  8019f7:	89 f8                	mov    %edi,%eax
  8019f9:	eb 05                	jmp    801a00 <devpipe_write+0x79>
				return 0;
  8019fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a03:	5b                   	pop    %ebx
  801a04:	5e                   	pop    %esi
  801a05:	5f                   	pop    %edi
  801a06:	5d                   	pop    %ebp
  801a07:	c3                   	ret    

00801a08 <devpipe_read>:
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	57                   	push   %edi
  801a0c:	56                   	push   %esi
  801a0d:	53                   	push   %ebx
  801a0e:	83 ec 18             	sub    $0x18,%esp
  801a11:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a14:	57                   	push   %edi
  801a15:	e8 51 f5 ff ff       	call   800f6b <fd2data>
  801a1a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	be 00 00 00 00       	mov    $0x0,%esi
  801a24:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a27:	74 47                	je     801a70 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801a29:	8b 03                	mov    (%ebx),%eax
  801a2b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a2e:	75 22                	jne    801a52 <devpipe_read+0x4a>
			if (i > 0)
  801a30:	85 f6                	test   %esi,%esi
  801a32:	75 14                	jne    801a48 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801a34:	89 da                	mov    %ebx,%edx
  801a36:	89 f8                	mov    %edi,%eax
  801a38:	e8 e5 fe ff ff       	call   801922 <_pipeisclosed>
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	75 33                	jne    801a74 <devpipe_read+0x6c>
			sys_yield();
  801a41:	e8 b1 f1 ff ff       	call   800bf7 <sys_yield>
  801a46:	eb e1                	jmp    801a29 <devpipe_read+0x21>
				return i;
  801a48:	89 f0                	mov    %esi,%eax
}
  801a4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a4d:	5b                   	pop    %ebx
  801a4e:	5e                   	pop    %esi
  801a4f:	5f                   	pop    %edi
  801a50:	5d                   	pop    %ebp
  801a51:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a52:	99                   	cltd   
  801a53:	c1 ea 1b             	shr    $0x1b,%edx
  801a56:	01 d0                	add    %edx,%eax
  801a58:	83 e0 1f             	and    $0x1f,%eax
  801a5b:	29 d0                	sub    %edx,%eax
  801a5d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a65:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a68:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801a6b:	83 c6 01             	add    $0x1,%esi
  801a6e:	eb b4                	jmp    801a24 <devpipe_read+0x1c>
	return i;
  801a70:	89 f0                	mov    %esi,%eax
  801a72:	eb d6                	jmp    801a4a <devpipe_read+0x42>
				return 0;
  801a74:	b8 00 00 00 00       	mov    $0x0,%eax
  801a79:	eb cf                	jmp    801a4a <devpipe_read+0x42>

00801a7b <pipe>:
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
  801a7e:	56                   	push   %esi
  801a7f:	53                   	push   %ebx
  801a80:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801a83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a86:	50                   	push   %eax
  801a87:	e8 f6 f4 ff ff       	call   800f82 <fd_alloc>
  801a8c:	89 c3                	mov    %eax,%ebx
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	85 c0                	test   %eax,%eax
  801a93:	78 5b                	js     801af0 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a95:	83 ec 04             	sub    $0x4,%esp
  801a98:	68 07 04 00 00       	push   $0x407
  801a9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa0:	6a 00                	push   $0x0
  801aa2:	e8 6f f1 ff ff       	call   800c16 <sys_page_alloc>
  801aa7:	89 c3                	mov    %eax,%ebx
  801aa9:	83 c4 10             	add    $0x10,%esp
  801aac:	85 c0                	test   %eax,%eax
  801aae:	78 40                	js     801af0 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801ab0:	83 ec 0c             	sub    $0xc,%esp
  801ab3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ab6:	50                   	push   %eax
  801ab7:	e8 c6 f4 ff ff       	call   800f82 <fd_alloc>
  801abc:	89 c3                	mov    %eax,%ebx
  801abe:	83 c4 10             	add    $0x10,%esp
  801ac1:	85 c0                	test   %eax,%eax
  801ac3:	78 1b                	js     801ae0 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ac5:	83 ec 04             	sub    $0x4,%esp
  801ac8:	68 07 04 00 00       	push   $0x407
  801acd:	ff 75 f0             	pushl  -0x10(%ebp)
  801ad0:	6a 00                	push   $0x0
  801ad2:	e8 3f f1 ff ff       	call   800c16 <sys_page_alloc>
  801ad7:	89 c3                	mov    %eax,%ebx
  801ad9:	83 c4 10             	add    $0x10,%esp
  801adc:	85 c0                	test   %eax,%eax
  801ade:	79 19                	jns    801af9 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801ae0:	83 ec 08             	sub    $0x8,%esp
  801ae3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae6:	6a 00                	push   $0x0
  801ae8:	e8 ae f1 ff ff       	call   800c9b <sys_page_unmap>
  801aed:	83 c4 10             	add    $0x10,%esp
}
  801af0:	89 d8                	mov    %ebx,%eax
  801af2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af5:	5b                   	pop    %ebx
  801af6:	5e                   	pop    %esi
  801af7:	5d                   	pop    %ebp
  801af8:	c3                   	ret    
	va = fd2data(fd0);
  801af9:	83 ec 0c             	sub    $0xc,%esp
  801afc:	ff 75 f4             	pushl  -0xc(%ebp)
  801aff:	e8 67 f4 ff ff       	call   800f6b <fd2data>
  801b04:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b06:	83 c4 0c             	add    $0xc,%esp
  801b09:	68 07 04 00 00       	push   $0x407
  801b0e:	50                   	push   %eax
  801b0f:	6a 00                	push   $0x0
  801b11:	e8 00 f1 ff ff       	call   800c16 <sys_page_alloc>
  801b16:	89 c3                	mov    %eax,%ebx
  801b18:	83 c4 10             	add    $0x10,%esp
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	0f 88 8c 00 00 00    	js     801baf <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b23:	83 ec 0c             	sub    $0xc,%esp
  801b26:	ff 75 f0             	pushl  -0x10(%ebp)
  801b29:	e8 3d f4 ff ff       	call   800f6b <fd2data>
  801b2e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b35:	50                   	push   %eax
  801b36:	6a 00                	push   $0x0
  801b38:	56                   	push   %esi
  801b39:	6a 00                	push   $0x0
  801b3b:	e8 19 f1 ff ff       	call   800c59 <sys_page_map>
  801b40:	89 c3                	mov    %eax,%ebx
  801b42:	83 c4 20             	add    $0x20,%esp
  801b45:	85 c0                	test   %eax,%eax
  801b47:	78 58                	js     801ba1 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b52:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b61:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b67:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801b73:	83 ec 0c             	sub    $0xc,%esp
  801b76:	ff 75 f4             	pushl  -0xc(%ebp)
  801b79:	e8 dd f3 ff ff       	call   800f5b <fd2num>
  801b7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b81:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b83:	83 c4 04             	add    $0x4,%esp
  801b86:	ff 75 f0             	pushl  -0x10(%ebp)
  801b89:	e8 cd f3 ff ff       	call   800f5b <fd2num>
  801b8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b91:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b9c:	e9 4f ff ff ff       	jmp    801af0 <pipe+0x75>
	sys_page_unmap(0, va);
  801ba1:	83 ec 08             	sub    $0x8,%esp
  801ba4:	56                   	push   %esi
  801ba5:	6a 00                	push   $0x0
  801ba7:	e8 ef f0 ff ff       	call   800c9b <sys_page_unmap>
  801bac:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801baf:	83 ec 08             	sub    $0x8,%esp
  801bb2:	ff 75 f0             	pushl  -0x10(%ebp)
  801bb5:	6a 00                	push   $0x0
  801bb7:	e8 df f0 ff ff       	call   800c9b <sys_page_unmap>
  801bbc:	83 c4 10             	add    $0x10,%esp
  801bbf:	e9 1c ff ff ff       	jmp    801ae0 <pipe+0x65>

00801bc4 <pipeisclosed>:
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bcd:	50                   	push   %eax
  801bce:	ff 75 08             	pushl  0x8(%ebp)
  801bd1:	e8 fb f3 ff ff       	call   800fd1 <fd_lookup>
  801bd6:	83 c4 10             	add    $0x10,%esp
  801bd9:	85 c0                	test   %eax,%eax
  801bdb:	78 18                	js     801bf5 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801bdd:	83 ec 0c             	sub    $0xc,%esp
  801be0:	ff 75 f4             	pushl  -0xc(%ebp)
  801be3:	e8 83 f3 ff ff       	call   800f6b <fd2data>
	return _pipeisclosed(fd, p);
  801be8:	89 c2                	mov    %eax,%edx
  801bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bed:	e8 30 fd ff ff       	call   801922 <_pipeisclosed>
  801bf2:	83 c4 10             	add    $0x10,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801bfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801bff:	5d                   	pop    %ebp
  801c00:	c3                   	ret    

00801c01 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801c07:	68 8a 25 80 00       	push   $0x80258a
  801c0c:	ff 75 0c             	pushl  0xc(%ebp)
  801c0f:	e8 09 ec ff ff       	call   80081d <strcpy>
	return 0;
}
  801c14:	b8 00 00 00 00       	mov    $0x0,%eax
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <devcons_write>:
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	57                   	push   %edi
  801c1f:	56                   	push   %esi
  801c20:	53                   	push   %ebx
  801c21:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801c27:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801c2c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801c32:	eb 2f                	jmp    801c63 <devcons_write+0x48>
		m = n - tot;
  801c34:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c37:	29 f3                	sub    %esi,%ebx
  801c39:	83 fb 7f             	cmp    $0x7f,%ebx
  801c3c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801c41:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801c44:	83 ec 04             	sub    $0x4,%esp
  801c47:	53                   	push   %ebx
  801c48:	89 f0                	mov    %esi,%eax
  801c4a:	03 45 0c             	add    0xc(%ebp),%eax
  801c4d:	50                   	push   %eax
  801c4e:	57                   	push   %edi
  801c4f:	e8 57 ed ff ff       	call   8009ab <memmove>
		sys_cputs(buf, m);
  801c54:	83 c4 08             	add    $0x8,%esp
  801c57:	53                   	push   %ebx
  801c58:	57                   	push   %edi
  801c59:	e8 fc ee ff ff       	call   800b5a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801c5e:	01 de                	add    %ebx,%esi
  801c60:	83 c4 10             	add    $0x10,%esp
  801c63:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c66:	72 cc                	jb     801c34 <devcons_write+0x19>
}
  801c68:	89 f0                	mov    %esi,%eax
  801c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c6d:	5b                   	pop    %ebx
  801c6e:	5e                   	pop    %esi
  801c6f:	5f                   	pop    %edi
  801c70:	5d                   	pop    %ebp
  801c71:	c3                   	ret    

00801c72 <devcons_read>:
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
  801c75:	83 ec 08             	sub    $0x8,%esp
  801c78:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801c7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c81:	75 07                	jne    801c8a <devcons_read+0x18>
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    
		sys_yield();
  801c85:	e8 6d ef ff ff       	call   800bf7 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801c8a:	e8 e9 ee ff ff       	call   800b78 <sys_cgetc>
  801c8f:	85 c0                	test   %eax,%eax
  801c91:	74 f2                	je     801c85 <devcons_read+0x13>
	if (c < 0)
  801c93:	85 c0                	test   %eax,%eax
  801c95:	78 ec                	js     801c83 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801c97:	83 f8 04             	cmp    $0x4,%eax
  801c9a:	74 0c                	je     801ca8 <devcons_read+0x36>
	*(char*)vbuf = c;
  801c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9f:	88 02                	mov    %al,(%edx)
	return 1;
  801ca1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca6:	eb db                	jmp    801c83 <devcons_read+0x11>
		return 0;
  801ca8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cad:	eb d4                	jmp    801c83 <devcons_read+0x11>

00801caf <cputchar>:
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801cbb:	6a 01                	push   $0x1
  801cbd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801cc0:	50                   	push   %eax
  801cc1:	e8 94 ee ff ff       	call   800b5a <sys_cputs>
}
  801cc6:	83 c4 10             	add    $0x10,%esp
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <getchar>:
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801cd1:	6a 01                	push   $0x1
  801cd3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801cd6:	50                   	push   %eax
  801cd7:	6a 00                	push   $0x0
  801cd9:	e8 64 f5 ff ff       	call   801242 <read>
	if (r < 0)
  801cde:	83 c4 10             	add    $0x10,%esp
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	78 08                	js     801ced <getchar+0x22>
	if (r < 1)
  801ce5:	85 c0                	test   %eax,%eax
  801ce7:	7e 06                	jle    801cef <getchar+0x24>
	return c;
  801ce9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    
		return -E_EOF;
  801cef:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801cf4:	eb f7                	jmp    801ced <getchar+0x22>

00801cf6 <iscons>:
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cfc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cff:	50                   	push   %eax
  801d00:	ff 75 08             	pushl  0x8(%ebp)
  801d03:	e8 c9 f2 ff ff       	call   800fd1 <fd_lookup>
  801d08:	83 c4 10             	add    $0x10,%esp
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	78 11                	js     801d20 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d12:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d18:	39 10                	cmp    %edx,(%eax)
  801d1a:	0f 94 c0             	sete   %al
  801d1d:	0f b6 c0             	movzbl %al,%eax
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <opencons>:
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801d28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d2b:	50                   	push   %eax
  801d2c:	e8 51 f2 ff ff       	call   800f82 <fd_alloc>
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	85 c0                	test   %eax,%eax
  801d36:	78 3a                	js     801d72 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d38:	83 ec 04             	sub    $0x4,%esp
  801d3b:	68 07 04 00 00       	push   $0x407
  801d40:	ff 75 f4             	pushl  -0xc(%ebp)
  801d43:	6a 00                	push   $0x0
  801d45:	e8 cc ee ff ff       	call   800c16 <sys_page_alloc>
  801d4a:	83 c4 10             	add    $0x10,%esp
  801d4d:	85 c0                	test   %eax,%eax
  801d4f:	78 21                	js     801d72 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d54:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d5a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d66:	83 ec 0c             	sub    $0xc,%esp
  801d69:	50                   	push   %eax
  801d6a:	e8 ec f1 ff ff       	call   800f5b <fd2num>
  801d6f:	83 c4 10             	add    $0x10,%esp
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	56                   	push   %esi
  801d78:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801d79:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801d7c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801d82:	e8 51 ee ff ff       	call   800bd8 <sys_getenvid>
  801d87:	83 ec 0c             	sub    $0xc,%esp
  801d8a:	ff 75 0c             	pushl  0xc(%ebp)
  801d8d:	ff 75 08             	pushl  0x8(%ebp)
  801d90:	56                   	push   %esi
  801d91:	50                   	push   %eax
  801d92:	68 98 25 80 00       	push   $0x802598
  801d97:	e8 62 e4 ff ff       	call   8001fe <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d9c:	83 c4 18             	add    $0x18,%esp
  801d9f:	53                   	push   %ebx
  801da0:	ff 75 10             	pushl  0x10(%ebp)
  801da3:	e8 05 e4 ff ff       	call   8001ad <vcprintf>
	cprintf("\n");
  801da8:	c7 04 24 50 21 80 00 	movl   $0x802150,(%esp)
  801daf:	e8 4a e4 ff ff       	call   8001fe <cprintf>
  801db4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801db7:	cc                   	int3   
  801db8:	eb fd                	jmp    801db7 <_panic+0x43>

00801dba <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	56                   	push   %esi
  801dbe:	53                   	push   %ebx
  801dbf:	8b 75 08             	mov    0x8(%ebp),%esi
  801dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801dc8:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  801dca:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801dcf:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  801dd2:	83 ec 0c             	sub    $0xc,%esp
  801dd5:	50                   	push   %eax
  801dd6:	e8 eb ef ff ff       	call   800dc6 <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  801ddb:	83 c4 10             	add    $0x10,%esp
  801dde:	85 c0                	test   %eax,%eax
  801de0:	78 2b                	js     801e0d <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  801de2:	85 f6                	test   %esi,%esi
  801de4:	74 0a                	je     801df0 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801de6:	a1 04 40 80 00       	mov    0x804004,%eax
  801deb:	8b 40 74             	mov    0x74(%eax),%eax
  801dee:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  801df0:	85 db                	test   %ebx,%ebx
  801df2:	74 0a                	je     801dfe <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801df4:	a1 04 40 80 00       	mov    0x804004,%eax
  801df9:	8b 40 78             	mov    0x78(%eax),%eax
  801dfc:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801dfe:	a1 04 40 80 00       	mov    0x804004,%eax
  801e03:	8b 40 70             	mov    0x70(%eax),%eax
}
  801e06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e09:	5b                   	pop    %ebx
  801e0a:	5e                   	pop    %esi
  801e0b:	5d                   	pop    %ebp
  801e0c:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  801e0d:	85 f6                	test   %esi,%esi
  801e0f:	74 06                	je     801e17 <ipc_recv+0x5d>
  801e11:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801e17:	85 db                	test   %ebx,%ebx
  801e19:	74 eb                	je     801e06 <ipc_recv+0x4c>
  801e1b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801e21:	eb e3                	jmp    801e06 <ipc_recv+0x4c>

00801e23 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	57                   	push   %edi
  801e27:	56                   	push   %esi
  801e28:	53                   	push   %ebx
  801e29:	83 ec 0c             	sub    $0xc,%esp
  801e2c:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801e35:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  801e37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e3c:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801e3f:	ff 75 14             	pushl  0x14(%ebp)
  801e42:	53                   	push   %ebx
  801e43:	56                   	push   %esi
  801e44:	57                   	push   %edi
  801e45:	e8 59 ef ff ff       	call   800da3 <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  801e4a:	83 c4 10             	add    $0x10,%esp
  801e4d:	85 c0                	test   %eax,%eax
  801e4f:	74 1e                	je     801e6f <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  801e51:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e54:	75 07                	jne    801e5d <ipc_send+0x3a>
			sys_yield();
  801e56:	e8 9c ed ff ff       	call   800bf7 <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801e5b:	eb e2                	jmp    801e3f <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  801e5d:	50                   	push   %eax
  801e5e:	68 bc 25 80 00       	push   $0x8025bc
  801e63:	6a 41                	push   $0x41
  801e65:	68 ca 25 80 00       	push   $0x8025ca
  801e6a:	e8 05 ff ff ff       	call   801d74 <_panic>
		}
	}
}
  801e6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e72:	5b                   	pop    %ebx
  801e73:	5e                   	pop    %esi
  801e74:	5f                   	pop    %edi
  801e75:	5d                   	pop    %ebp
  801e76:	c3                   	ret    

00801e77 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801e7d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801e82:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e85:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e8b:	8b 52 50             	mov    0x50(%edx),%edx
  801e8e:	39 ca                	cmp    %ecx,%edx
  801e90:	74 11                	je     801ea3 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801e92:	83 c0 01             	add    $0x1,%eax
  801e95:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e9a:	75 e6                	jne    801e82 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea1:	eb 0b                	jmp    801eae <ipc_find_env+0x37>
			return envs[i].env_id;
  801ea3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ea6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801eab:	8b 40 48             	mov    0x48(%eax),%eax
}
  801eae:	5d                   	pop    %ebp
  801eaf:	c3                   	ret    

00801eb0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801eb6:	89 d0                	mov    %edx,%eax
  801eb8:	c1 e8 16             	shr    $0x16,%eax
  801ebb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ec2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ec7:	f6 c1 01             	test   $0x1,%cl
  801eca:	74 1d                	je     801ee9 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ecc:	c1 ea 0c             	shr    $0xc,%edx
  801ecf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ed6:	f6 c2 01             	test   $0x1,%dl
  801ed9:	74 0e                	je     801ee9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801edb:	c1 ea 0c             	shr    $0xc,%edx
  801ede:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ee5:	ef 
  801ee6:	0f b7 c0             	movzwl %ax,%eax
}
  801ee9:	5d                   	pop    %ebp
  801eea:	c3                   	ret    
  801eeb:	66 90                	xchg   %ax,%ax
  801eed:	66 90                	xchg   %ax,%ax
  801eef:	90                   	nop

00801ef0 <__udivdi3>:
  801ef0:	55                   	push   %ebp
  801ef1:	57                   	push   %edi
  801ef2:	56                   	push   %esi
  801ef3:	53                   	push   %ebx
  801ef4:	83 ec 1c             	sub    $0x1c,%esp
  801ef7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801efb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801eff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f03:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801f07:	85 d2                	test   %edx,%edx
  801f09:	75 35                	jne    801f40 <__udivdi3+0x50>
  801f0b:	39 f3                	cmp    %esi,%ebx
  801f0d:	0f 87 bd 00 00 00    	ja     801fd0 <__udivdi3+0xe0>
  801f13:	85 db                	test   %ebx,%ebx
  801f15:	89 d9                	mov    %ebx,%ecx
  801f17:	75 0b                	jne    801f24 <__udivdi3+0x34>
  801f19:	b8 01 00 00 00       	mov    $0x1,%eax
  801f1e:	31 d2                	xor    %edx,%edx
  801f20:	f7 f3                	div    %ebx
  801f22:	89 c1                	mov    %eax,%ecx
  801f24:	31 d2                	xor    %edx,%edx
  801f26:	89 f0                	mov    %esi,%eax
  801f28:	f7 f1                	div    %ecx
  801f2a:	89 c6                	mov    %eax,%esi
  801f2c:	89 e8                	mov    %ebp,%eax
  801f2e:	89 f7                	mov    %esi,%edi
  801f30:	f7 f1                	div    %ecx
  801f32:	89 fa                	mov    %edi,%edx
  801f34:	83 c4 1c             	add    $0x1c,%esp
  801f37:	5b                   	pop    %ebx
  801f38:	5e                   	pop    %esi
  801f39:	5f                   	pop    %edi
  801f3a:	5d                   	pop    %ebp
  801f3b:	c3                   	ret    
  801f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f40:	39 f2                	cmp    %esi,%edx
  801f42:	77 7c                	ja     801fc0 <__udivdi3+0xd0>
  801f44:	0f bd fa             	bsr    %edx,%edi
  801f47:	83 f7 1f             	xor    $0x1f,%edi
  801f4a:	0f 84 98 00 00 00    	je     801fe8 <__udivdi3+0xf8>
  801f50:	89 f9                	mov    %edi,%ecx
  801f52:	b8 20 00 00 00       	mov    $0x20,%eax
  801f57:	29 f8                	sub    %edi,%eax
  801f59:	d3 e2                	shl    %cl,%edx
  801f5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f5f:	89 c1                	mov    %eax,%ecx
  801f61:	89 da                	mov    %ebx,%edx
  801f63:	d3 ea                	shr    %cl,%edx
  801f65:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f69:	09 d1                	or     %edx,%ecx
  801f6b:	89 f2                	mov    %esi,%edx
  801f6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f71:	89 f9                	mov    %edi,%ecx
  801f73:	d3 e3                	shl    %cl,%ebx
  801f75:	89 c1                	mov    %eax,%ecx
  801f77:	d3 ea                	shr    %cl,%edx
  801f79:	89 f9                	mov    %edi,%ecx
  801f7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f7f:	d3 e6                	shl    %cl,%esi
  801f81:	89 eb                	mov    %ebp,%ebx
  801f83:	89 c1                	mov    %eax,%ecx
  801f85:	d3 eb                	shr    %cl,%ebx
  801f87:	09 de                	or     %ebx,%esi
  801f89:	89 f0                	mov    %esi,%eax
  801f8b:	f7 74 24 08          	divl   0x8(%esp)
  801f8f:	89 d6                	mov    %edx,%esi
  801f91:	89 c3                	mov    %eax,%ebx
  801f93:	f7 64 24 0c          	mull   0xc(%esp)
  801f97:	39 d6                	cmp    %edx,%esi
  801f99:	72 0c                	jb     801fa7 <__udivdi3+0xb7>
  801f9b:	89 f9                	mov    %edi,%ecx
  801f9d:	d3 e5                	shl    %cl,%ebp
  801f9f:	39 c5                	cmp    %eax,%ebp
  801fa1:	73 5d                	jae    802000 <__udivdi3+0x110>
  801fa3:	39 d6                	cmp    %edx,%esi
  801fa5:	75 59                	jne    802000 <__udivdi3+0x110>
  801fa7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801faa:	31 ff                	xor    %edi,%edi
  801fac:	89 fa                	mov    %edi,%edx
  801fae:	83 c4 1c             	add    $0x1c,%esp
  801fb1:	5b                   	pop    %ebx
  801fb2:	5e                   	pop    %esi
  801fb3:	5f                   	pop    %edi
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    
  801fb6:	8d 76 00             	lea    0x0(%esi),%esi
  801fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801fc0:	31 ff                	xor    %edi,%edi
  801fc2:	31 c0                	xor    %eax,%eax
  801fc4:	89 fa                	mov    %edi,%edx
  801fc6:	83 c4 1c             	add    $0x1c,%esp
  801fc9:	5b                   	pop    %ebx
  801fca:	5e                   	pop    %esi
  801fcb:	5f                   	pop    %edi
  801fcc:	5d                   	pop    %ebp
  801fcd:	c3                   	ret    
  801fce:	66 90                	xchg   %ax,%ax
  801fd0:	31 ff                	xor    %edi,%edi
  801fd2:	89 e8                	mov    %ebp,%eax
  801fd4:	89 f2                	mov    %esi,%edx
  801fd6:	f7 f3                	div    %ebx
  801fd8:	89 fa                	mov    %edi,%edx
  801fda:	83 c4 1c             	add    $0x1c,%esp
  801fdd:	5b                   	pop    %ebx
  801fde:	5e                   	pop    %esi
  801fdf:	5f                   	pop    %edi
  801fe0:	5d                   	pop    %ebp
  801fe1:	c3                   	ret    
  801fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801fe8:	39 f2                	cmp    %esi,%edx
  801fea:	72 06                	jb     801ff2 <__udivdi3+0x102>
  801fec:	31 c0                	xor    %eax,%eax
  801fee:	39 eb                	cmp    %ebp,%ebx
  801ff0:	77 d2                	ja     801fc4 <__udivdi3+0xd4>
  801ff2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff7:	eb cb                	jmp    801fc4 <__udivdi3+0xd4>
  801ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802000:	89 d8                	mov    %ebx,%eax
  802002:	31 ff                	xor    %edi,%edi
  802004:	eb be                	jmp    801fc4 <__udivdi3+0xd4>
  802006:	66 90                	xchg   %ax,%ax
  802008:	66 90                	xchg   %ax,%ax
  80200a:	66 90                	xchg   %ax,%ax
  80200c:	66 90                	xchg   %ax,%ax
  80200e:	66 90                	xchg   %ax,%ax

00802010 <__umoddi3>:
  802010:	55                   	push   %ebp
  802011:	57                   	push   %edi
  802012:	56                   	push   %esi
  802013:	53                   	push   %ebx
  802014:	83 ec 1c             	sub    $0x1c,%esp
  802017:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80201b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80201f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802023:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802027:	85 ed                	test   %ebp,%ebp
  802029:	89 f0                	mov    %esi,%eax
  80202b:	89 da                	mov    %ebx,%edx
  80202d:	75 19                	jne    802048 <__umoddi3+0x38>
  80202f:	39 df                	cmp    %ebx,%edi
  802031:	0f 86 b1 00 00 00    	jbe    8020e8 <__umoddi3+0xd8>
  802037:	f7 f7                	div    %edi
  802039:	89 d0                	mov    %edx,%eax
  80203b:	31 d2                	xor    %edx,%edx
  80203d:	83 c4 1c             	add    $0x1c,%esp
  802040:	5b                   	pop    %ebx
  802041:	5e                   	pop    %esi
  802042:	5f                   	pop    %edi
  802043:	5d                   	pop    %ebp
  802044:	c3                   	ret    
  802045:	8d 76 00             	lea    0x0(%esi),%esi
  802048:	39 dd                	cmp    %ebx,%ebp
  80204a:	77 f1                	ja     80203d <__umoddi3+0x2d>
  80204c:	0f bd cd             	bsr    %ebp,%ecx
  80204f:	83 f1 1f             	xor    $0x1f,%ecx
  802052:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802056:	0f 84 b4 00 00 00    	je     802110 <__umoddi3+0x100>
  80205c:	b8 20 00 00 00       	mov    $0x20,%eax
  802061:	89 c2                	mov    %eax,%edx
  802063:	8b 44 24 04          	mov    0x4(%esp),%eax
  802067:	29 c2                	sub    %eax,%edx
  802069:	89 c1                	mov    %eax,%ecx
  80206b:	89 f8                	mov    %edi,%eax
  80206d:	d3 e5                	shl    %cl,%ebp
  80206f:	89 d1                	mov    %edx,%ecx
  802071:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802075:	d3 e8                	shr    %cl,%eax
  802077:	09 c5                	or     %eax,%ebp
  802079:	8b 44 24 04          	mov    0x4(%esp),%eax
  80207d:	89 c1                	mov    %eax,%ecx
  80207f:	d3 e7                	shl    %cl,%edi
  802081:	89 d1                	mov    %edx,%ecx
  802083:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802087:	89 df                	mov    %ebx,%edi
  802089:	d3 ef                	shr    %cl,%edi
  80208b:	89 c1                	mov    %eax,%ecx
  80208d:	89 f0                	mov    %esi,%eax
  80208f:	d3 e3                	shl    %cl,%ebx
  802091:	89 d1                	mov    %edx,%ecx
  802093:	89 fa                	mov    %edi,%edx
  802095:	d3 e8                	shr    %cl,%eax
  802097:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80209c:	09 d8                	or     %ebx,%eax
  80209e:	f7 f5                	div    %ebp
  8020a0:	d3 e6                	shl    %cl,%esi
  8020a2:	89 d1                	mov    %edx,%ecx
  8020a4:	f7 64 24 08          	mull   0x8(%esp)
  8020a8:	39 d1                	cmp    %edx,%ecx
  8020aa:	89 c3                	mov    %eax,%ebx
  8020ac:	89 d7                	mov    %edx,%edi
  8020ae:	72 06                	jb     8020b6 <__umoddi3+0xa6>
  8020b0:	75 0e                	jne    8020c0 <__umoddi3+0xb0>
  8020b2:	39 c6                	cmp    %eax,%esi
  8020b4:	73 0a                	jae    8020c0 <__umoddi3+0xb0>
  8020b6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8020ba:	19 ea                	sbb    %ebp,%edx
  8020bc:	89 d7                	mov    %edx,%edi
  8020be:	89 c3                	mov    %eax,%ebx
  8020c0:	89 ca                	mov    %ecx,%edx
  8020c2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8020c7:	29 de                	sub    %ebx,%esi
  8020c9:	19 fa                	sbb    %edi,%edx
  8020cb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8020cf:	89 d0                	mov    %edx,%eax
  8020d1:	d3 e0                	shl    %cl,%eax
  8020d3:	89 d9                	mov    %ebx,%ecx
  8020d5:	d3 ee                	shr    %cl,%esi
  8020d7:	d3 ea                	shr    %cl,%edx
  8020d9:	09 f0                	or     %esi,%eax
  8020db:	83 c4 1c             	add    $0x1c,%esp
  8020de:	5b                   	pop    %ebx
  8020df:	5e                   	pop    %esi
  8020e0:	5f                   	pop    %edi
  8020e1:	5d                   	pop    %ebp
  8020e2:	c3                   	ret    
  8020e3:	90                   	nop
  8020e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020e8:	85 ff                	test   %edi,%edi
  8020ea:	89 f9                	mov    %edi,%ecx
  8020ec:	75 0b                	jne    8020f9 <__umoddi3+0xe9>
  8020ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f3:	31 d2                	xor    %edx,%edx
  8020f5:	f7 f7                	div    %edi
  8020f7:	89 c1                	mov    %eax,%ecx
  8020f9:	89 d8                	mov    %ebx,%eax
  8020fb:	31 d2                	xor    %edx,%edx
  8020fd:	f7 f1                	div    %ecx
  8020ff:	89 f0                	mov    %esi,%eax
  802101:	f7 f1                	div    %ecx
  802103:	e9 31 ff ff ff       	jmp    802039 <__umoddi3+0x29>
  802108:	90                   	nop
  802109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802110:	39 dd                	cmp    %ebx,%ebp
  802112:	72 08                	jb     80211c <__umoddi3+0x10c>
  802114:	39 f7                	cmp    %esi,%edi
  802116:	0f 87 21 ff ff ff    	ja     80203d <__umoddi3+0x2d>
  80211c:	89 da                	mov    %ebx,%edx
  80211e:	89 f0                	mov    %esi,%eax
  802120:	29 f8                	sub    %edi,%eax
  802122:	19 ea                	sbb    %ebp,%edx
  802124:	e9 14 ff ff ff       	jmp    80203d <__umoddi3+0x2d>
