
obj/user/cat.debug：     文件格式 elf32-i386


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
  80002c:	e8 fe 00 00 00       	call   80012f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	68 00 20 00 00       	push   $0x2000
  800043:	68 20 40 80 00       	push   $0x804020
  800048:	56                   	push   %esi
  800049:	e8 04 11 00 00       	call   801152 <read>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	7e 2f                	jle    800086 <cat+0x53>
		if ((r = write(1, buf, n)) != n)
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	53                   	push   %ebx
  80005b:	68 20 40 80 00       	push   $0x804020
  800060:	6a 01                	push   $0x1
  800062:	e8 b9 11 00 00       	call   801220 <write>
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	39 c3                	cmp    %eax,%ebx
  80006c:	74 cd                	je     80003b <cat+0x8>
			panic("write error copying %s: %e", s, r);
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	50                   	push   %eax
  800072:	ff 75 0c             	pushl  0xc(%ebp)
  800075:	68 00 20 80 00       	push   $0x802000
  80007a:	6a 0d                	push   $0xd
  80007c:	68 1b 20 80 00       	push   $0x80201b
  800081:	e8 01 01 00 00       	call   800187 <_panic>
	if (n < 0)
  800086:	85 c0                	test   %eax,%eax
  800088:	78 07                	js     800091 <cat+0x5e>
		panic("error reading %s: %e", s, n);
}
  80008a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008d:	5b                   	pop    %ebx
  80008e:	5e                   	pop    %esi
  80008f:	5d                   	pop    %ebp
  800090:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	50                   	push   %eax
  800095:	ff 75 0c             	pushl  0xc(%ebp)
  800098:	68 26 20 80 00       	push   $0x802026
  80009d:	6a 0f                	push   $0xf
  80009f:	68 1b 20 80 00       	push   $0x80201b
  8000a4:	e8 de 00 00 00       	call   800187 <_panic>

008000a9 <umain>:

void
umain(int argc, char **argv)
{
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	57                   	push   %edi
  8000ad:	56                   	push   %esi
  8000ae:	53                   	push   %ebx
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000b5:	c7 05 00 30 80 00 3b 	movl   $0x80203b,0x803000
  8000bc:	20 80 00 
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000bf:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  8000c4:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c8:	75 31                	jne    8000fb <umain+0x52>
		cat(0, "<stdin>");
  8000ca:	83 ec 08             	sub    $0x8,%esp
  8000cd:	68 3f 20 80 00       	push   $0x80203f
  8000d2:	6a 00                	push   $0x0
  8000d4:	e8 5a ff ff ff       	call   800033 <cat>
  8000d9:	83 c4 10             	add    $0x10,%esp
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8000dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000df:	5b                   	pop    %ebx
  8000e0:	5e                   	pop    %esi
  8000e1:	5f                   	pop    %edi
  8000e2:	5d                   	pop    %ebp
  8000e3:	c3                   	ret    
				printf("can't open %s: %e\n", argv[i], f);
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	50                   	push   %eax
  8000e8:	ff 34 9f             	pushl  (%edi,%ebx,4)
  8000eb:	68 47 20 80 00       	push   $0x802047
  8000f0:	e8 af 16 00 00       	call   8017a4 <printf>
  8000f5:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000f8:	83 c3 01             	add    $0x1,%ebx
  8000fb:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8000fe:	7d dc                	jge    8000dc <umain+0x33>
			f = open(argv[i], O_RDONLY);
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	6a 00                	push   $0x0
  800105:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800108:	e8 f3 14 00 00       	call   801600 <open>
  80010d:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	85 c0                	test   %eax,%eax
  800114:	78 ce                	js     8000e4 <umain+0x3b>
				cat(f, argv[i]);
  800116:	83 ec 08             	sub    $0x8,%esp
  800119:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80011c:	50                   	push   %eax
  80011d:	e8 11 ff ff ff       	call   800033 <cat>
				close(f);
  800122:	89 34 24             	mov    %esi,(%esp)
  800125:	e8 ec 0e 00 00       	call   801016 <close>
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	eb c9                	jmp    8000f8 <umain+0x4f>

0080012f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
  800134:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800137:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  80013a:	e8 fd 0a 00 00       	call   800c3c <sys_getenvid>
	thisenv = envs + ENVX(envid);
  80013f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800144:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800147:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014c:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800151:	85 db                	test   %ebx,%ebx
  800153:	7e 07                	jle    80015c <libmain+0x2d>
		binaryname = argv[0];
  800155:	8b 06                	mov    (%esi),%eax
  800157:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	56                   	push   %esi
  800160:	53                   	push   %ebx
  800161:	e8 43 ff ff ff       	call   8000a9 <umain>

	// exit gracefully
	exit();
  800166:	e8 0a 00 00 00       	call   800175 <exit>
}
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800171:	5b                   	pop    %ebx
  800172:	5e                   	pop    %esi
  800173:	5d                   	pop    %ebp
  800174:	c3                   	ret    

00800175 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80017b:	6a 00                	push   $0x0
  80017d:	e8 79 0a 00 00       	call   800bfb <sys_env_destroy>
}
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	c9                   	leave  
  800186:	c3                   	ret    

00800187 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	56                   	push   %esi
  80018b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80018c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80018f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800195:	e8 a2 0a 00 00       	call   800c3c <sys_getenvid>
  80019a:	83 ec 0c             	sub    $0xc,%esp
  80019d:	ff 75 0c             	pushl  0xc(%ebp)
  8001a0:	ff 75 08             	pushl  0x8(%ebp)
  8001a3:	56                   	push   %esi
  8001a4:	50                   	push   %eax
  8001a5:	68 64 20 80 00       	push   $0x802064
  8001aa:	e8 b3 00 00 00       	call   800262 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001af:	83 c4 18             	add    $0x18,%esp
  8001b2:	53                   	push   %ebx
  8001b3:	ff 75 10             	pushl  0x10(%ebp)
  8001b6:	e8 56 00 00 00       	call   800211 <vcprintf>
	cprintf("\n");
  8001bb:	c7 04 24 87 24 80 00 	movl   $0x802487,(%esp)
  8001c2:	e8 9b 00 00 00       	call   800262 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ca:	cc                   	int3   
  8001cb:	eb fd                	jmp    8001ca <_panic+0x43>

008001cd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	53                   	push   %ebx
  8001d1:	83 ec 04             	sub    $0x4,%esp
  8001d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d7:	8b 13                	mov    (%ebx),%edx
  8001d9:	8d 42 01             	lea    0x1(%edx),%eax
  8001dc:	89 03                	mov    %eax,(%ebx)
  8001de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ea:	74 09                	je     8001f5 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ec:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f3:	c9                   	leave  
  8001f4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	68 ff 00 00 00       	push   $0xff
  8001fd:	8d 43 08             	lea    0x8(%ebx),%eax
  800200:	50                   	push   %eax
  800201:	e8 b8 09 00 00       	call   800bbe <sys_cputs>
		b->idx = 0;
  800206:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	eb db                	jmp    8001ec <putch+0x1f>

00800211 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80021a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800221:	00 00 00 
	b.cnt = 0;
  800224:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80022e:	ff 75 0c             	pushl  0xc(%ebp)
  800231:	ff 75 08             	pushl  0x8(%ebp)
  800234:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023a:	50                   	push   %eax
  80023b:	68 cd 01 80 00       	push   $0x8001cd
  800240:	e8 1a 01 00 00       	call   80035f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800245:	83 c4 08             	add    $0x8,%esp
  800248:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80024e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800254:	50                   	push   %eax
  800255:	e8 64 09 00 00       	call   800bbe <sys_cputs>

	return b.cnt;
}
  80025a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800260:	c9                   	leave  
  800261:	c3                   	ret    

00800262 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800268:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80026b:	50                   	push   %eax
  80026c:	ff 75 08             	pushl  0x8(%ebp)
  80026f:	e8 9d ff ff ff       	call   800211 <vcprintf>
	va_end(ap);

	return cnt;
}
  800274:	c9                   	leave  
  800275:	c3                   	ret    

00800276 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
  800279:	57                   	push   %edi
  80027a:	56                   	push   %esi
  80027b:	53                   	push   %ebx
  80027c:	83 ec 1c             	sub    $0x1c,%esp
  80027f:	89 c7                	mov    %eax,%edi
  800281:	89 d6                	mov    %edx,%esi
  800283:	8b 45 08             	mov    0x8(%ebp),%eax
  800286:	8b 55 0c             	mov    0xc(%ebp),%edx
  800289:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80028c:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80028f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800292:	bb 00 00 00 00       	mov    $0x0,%ebx
  800297:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80029a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80029d:	39 d3                	cmp    %edx,%ebx
  80029f:	72 05                	jb     8002a6 <printnum+0x30>
  8002a1:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002a4:	77 7a                	ja     800320 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002a6:	83 ec 0c             	sub    $0xc,%esp
  8002a9:	ff 75 18             	pushl  0x18(%ebp)
  8002ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8002af:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002b2:	53                   	push   %ebx
  8002b3:	ff 75 10             	pushl  0x10(%ebp)
  8002b6:	83 ec 08             	sub    $0x8,%esp
  8002b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8002bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c2:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c5:	e8 f6 1a 00 00       	call   801dc0 <__udivdi3>
  8002ca:	83 c4 18             	add    $0x18,%esp
  8002cd:	52                   	push   %edx
  8002ce:	50                   	push   %eax
  8002cf:	89 f2                	mov    %esi,%edx
  8002d1:	89 f8                	mov    %edi,%eax
  8002d3:	e8 9e ff ff ff       	call   800276 <printnum>
  8002d8:	83 c4 20             	add    $0x20,%esp
  8002db:	eb 13                	jmp    8002f0 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	56                   	push   %esi
  8002e1:	ff 75 18             	pushl  0x18(%ebp)
  8002e4:	ff d7                	call   *%edi
  8002e6:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002e9:	83 eb 01             	sub    $0x1,%ebx
  8002ec:	85 db                	test   %ebx,%ebx
  8002ee:	7f ed                	jg     8002dd <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002f0:	83 ec 08             	sub    $0x8,%esp
  8002f3:	56                   	push   %esi
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8002fd:	ff 75 dc             	pushl  -0x24(%ebp)
  800300:	ff 75 d8             	pushl  -0x28(%ebp)
  800303:	e8 d8 1b 00 00       	call   801ee0 <__umoddi3>
  800308:	83 c4 14             	add    $0x14,%esp
  80030b:	0f be 80 87 20 80 00 	movsbl 0x802087(%eax),%eax
  800312:	50                   	push   %eax
  800313:	ff d7                	call   *%edi
}
  800315:	83 c4 10             	add    $0x10,%esp
  800318:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031b:	5b                   	pop    %ebx
  80031c:	5e                   	pop    %esi
  80031d:	5f                   	pop    %edi
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    
  800320:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800323:	eb c4                	jmp    8002e9 <printnum+0x73>

00800325 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80032b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80032f:	8b 10                	mov    (%eax),%edx
  800331:	3b 50 04             	cmp    0x4(%eax),%edx
  800334:	73 0a                	jae    800340 <sprintputch+0x1b>
		*b->buf++ = ch;
  800336:	8d 4a 01             	lea    0x1(%edx),%ecx
  800339:	89 08                	mov    %ecx,(%eax)
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	88 02                	mov    %al,(%edx)
}
  800340:	5d                   	pop    %ebp
  800341:	c3                   	ret    

00800342 <printfmt>:
{
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800348:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80034b:	50                   	push   %eax
  80034c:	ff 75 10             	pushl  0x10(%ebp)
  80034f:	ff 75 0c             	pushl  0xc(%ebp)
  800352:	ff 75 08             	pushl  0x8(%ebp)
  800355:	e8 05 00 00 00       	call   80035f <vprintfmt>
}
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	c9                   	leave  
  80035e:	c3                   	ret    

0080035f <vprintfmt>:
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	57                   	push   %edi
  800363:	56                   	push   %esi
  800364:	53                   	push   %ebx
  800365:	83 ec 2c             	sub    $0x2c,%esp
  800368:	8b 75 08             	mov    0x8(%ebp),%esi
  80036b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80036e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800371:	e9 c1 03 00 00       	jmp    800737 <vprintfmt+0x3d8>
		padc = ' ';
  800376:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80037a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800381:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800388:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80038f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800394:	8d 47 01             	lea    0x1(%edi),%eax
  800397:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80039a:	0f b6 17             	movzbl (%edi),%edx
  80039d:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003a0:	3c 55                	cmp    $0x55,%al
  8003a2:	0f 87 12 04 00 00    	ja     8007ba <vprintfmt+0x45b>
  8003a8:	0f b6 c0             	movzbl %al,%eax
  8003ab:	ff 24 85 c0 21 80 00 	jmp    *0x8021c0(,%eax,4)
  8003b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003b5:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003b9:	eb d9                	jmp    800394 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003be:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003c2:	eb d0                	jmp    800394 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003c4:	0f b6 d2             	movzbl %dl,%edx
  8003c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003d2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003d5:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003d9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003dc:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003df:	83 f9 09             	cmp    $0x9,%ecx
  8003e2:	77 55                	ja     800439 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003e4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003e7:	eb e9                	jmp    8003d2 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ec:	8b 00                	mov    (%eax),%eax
  8003ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f4:	8d 40 04             	lea    0x4(%eax),%eax
  8003f7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800401:	79 91                	jns    800394 <vprintfmt+0x35>
				width = precision, precision = -1;
  800403:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800406:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800409:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800410:	eb 82                	jmp    800394 <vprintfmt+0x35>
  800412:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800415:	85 c0                	test   %eax,%eax
  800417:	ba 00 00 00 00       	mov    $0x0,%edx
  80041c:	0f 49 d0             	cmovns %eax,%edx
  80041f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800422:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800425:	e9 6a ff ff ff       	jmp    800394 <vprintfmt+0x35>
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80042d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800434:	e9 5b ff ff ff       	jmp    800394 <vprintfmt+0x35>
  800439:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80043c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80043f:	eb bc                	jmp    8003fd <vprintfmt+0x9e>
			lflag++;
  800441:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800444:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800447:	e9 48 ff ff ff       	jmp    800394 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80044c:	8b 45 14             	mov    0x14(%ebp),%eax
  80044f:	8d 78 04             	lea    0x4(%eax),%edi
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	53                   	push   %ebx
  800456:	ff 30                	pushl  (%eax)
  800458:	ff d6                	call   *%esi
			break;
  80045a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80045d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800460:	e9 cf 02 00 00       	jmp    800734 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800465:	8b 45 14             	mov    0x14(%ebp),%eax
  800468:	8d 78 04             	lea    0x4(%eax),%edi
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	99                   	cltd   
  80046e:	31 d0                	xor    %edx,%eax
  800470:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800472:	83 f8 0f             	cmp    $0xf,%eax
  800475:	7f 23                	jg     80049a <vprintfmt+0x13b>
  800477:	8b 14 85 20 23 80 00 	mov    0x802320(,%eax,4),%edx
  80047e:	85 d2                	test   %edx,%edx
  800480:	74 18                	je     80049a <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800482:	52                   	push   %edx
  800483:	68 55 24 80 00       	push   $0x802455
  800488:	53                   	push   %ebx
  800489:	56                   	push   %esi
  80048a:	e8 b3 fe ff ff       	call   800342 <printfmt>
  80048f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800492:	89 7d 14             	mov    %edi,0x14(%ebp)
  800495:	e9 9a 02 00 00       	jmp    800734 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80049a:	50                   	push   %eax
  80049b:	68 9f 20 80 00       	push   $0x80209f
  8004a0:	53                   	push   %ebx
  8004a1:	56                   	push   %esi
  8004a2:	e8 9b fe ff ff       	call   800342 <printfmt>
  8004a7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004aa:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004ad:	e9 82 02 00 00       	jmp    800734 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b5:	83 c0 04             	add    $0x4,%eax
  8004b8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004c0:	85 ff                	test   %edi,%edi
  8004c2:	b8 98 20 80 00       	mov    $0x802098,%eax
  8004c7:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ce:	0f 8e bd 00 00 00    	jle    800591 <vprintfmt+0x232>
  8004d4:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004d8:	75 0e                	jne    8004e8 <vprintfmt+0x189>
  8004da:	89 75 08             	mov    %esi,0x8(%ebp)
  8004dd:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004e0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004e3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e6:	eb 6d                	jmp    800555 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e8:	83 ec 08             	sub    $0x8,%esp
  8004eb:	ff 75 d0             	pushl  -0x30(%ebp)
  8004ee:	57                   	push   %edi
  8004ef:	e8 6e 03 00 00       	call   800862 <strnlen>
  8004f4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f7:	29 c1                	sub    %eax,%ecx
  8004f9:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004fc:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004ff:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800503:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800506:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800509:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80050b:	eb 0f                	jmp    80051c <vprintfmt+0x1bd>
					putch(padc, putdat);
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	53                   	push   %ebx
  800511:	ff 75 e0             	pushl  -0x20(%ebp)
  800514:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800516:	83 ef 01             	sub    $0x1,%edi
  800519:	83 c4 10             	add    $0x10,%esp
  80051c:	85 ff                	test   %edi,%edi
  80051e:	7f ed                	jg     80050d <vprintfmt+0x1ae>
  800520:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800523:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800526:	85 c9                	test   %ecx,%ecx
  800528:	b8 00 00 00 00       	mov    $0x0,%eax
  80052d:	0f 49 c1             	cmovns %ecx,%eax
  800530:	29 c1                	sub    %eax,%ecx
  800532:	89 75 08             	mov    %esi,0x8(%ebp)
  800535:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800538:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80053b:	89 cb                	mov    %ecx,%ebx
  80053d:	eb 16                	jmp    800555 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80053f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800543:	75 31                	jne    800576 <vprintfmt+0x217>
					putch(ch, putdat);
  800545:	83 ec 08             	sub    $0x8,%esp
  800548:	ff 75 0c             	pushl  0xc(%ebp)
  80054b:	50                   	push   %eax
  80054c:	ff 55 08             	call   *0x8(%ebp)
  80054f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800552:	83 eb 01             	sub    $0x1,%ebx
  800555:	83 c7 01             	add    $0x1,%edi
  800558:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80055c:	0f be c2             	movsbl %dl,%eax
  80055f:	85 c0                	test   %eax,%eax
  800561:	74 59                	je     8005bc <vprintfmt+0x25d>
  800563:	85 f6                	test   %esi,%esi
  800565:	78 d8                	js     80053f <vprintfmt+0x1e0>
  800567:	83 ee 01             	sub    $0x1,%esi
  80056a:	79 d3                	jns    80053f <vprintfmt+0x1e0>
  80056c:	89 df                	mov    %ebx,%edi
  80056e:	8b 75 08             	mov    0x8(%ebp),%esi
  800571:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800574:	eb 37                	jmp    8005ad <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800576:	0f be d2             	movsbl %dl,%edx
  800579:	83 ea 20             	sub    $0x20,%edx
  80057c:	83 fa 5e             	cmp    $0x5e,%edx
  80057f:	76 c4                	jbe    800545 <vprintfmt+0x1e6>
					putch('?', putdat);
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	ff 75 0c             	pushl  0xc(%ebp)
  800587:	6a 3f                	push   $0x3f
  800589:	ff 55 08             	call   *0x8(%ebp)
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	eb c1                	jmp    800552 <vprintfmt+0x1f3>
  800591:	89 75 08             	mov    %esi,0x8(%ebp)
  800594:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800597:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80059a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059d:	eb b6                	jmp    800555 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	53                   	push   %ebx
  8005a3:	6a 20                	push   $0x20
  8005a5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005a7:	83 ef 01             	sub    $0x1,%edi
  8005aa:	83 c4 10             	add    $0x10,%esp
  8005ad:	85 ff                	test   %edi,%edi
  8005af:	7f ee                	jg     80059f <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8005b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b7:	e9 78 01 00 00       	jmp    800734 <vprintfmt+0x3d5>
  8005bc:	89 df                	mov    %ebx,%edi
  8005be:	8b 75 08             	mov    0x8(%ebp),%esi
  8005c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005c4:	eb e7                	jmp    8005ad <vprintfmt+0x24e>
	if (lflag >= 2)
  8005c6:	83 f9 01             	cmp    $0x1,%ecx
  8005c9:	7e 3f                	jle    80060a <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8b 50 04             	mov    0x4(%eax),%edx
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8d 40 08             	lea    0x8(%eax),%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005e2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005e6:	79 5c                	jns    800644 <vprintfmt+0x2e5>
				putch('-', putdat);
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	53                   	push   %ebx
  8005ec:	6a 2d                	push   $0x2d
  8005ee:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005f3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005f6:	f7 da                	neg    %edx
  8005f8:	83 d1 00             	adc    $0x0,%ecx
  8005fb:	f7 d9                	neg    %ecx
  8005fd:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800600:	b8 0a 00 00 00       	mov    $0xa,%eax
  800605:	e9 10 01 00 00       	jmp    80071a <vprintfmt+0x3bb>
	else if (lflag)
  80060a:	85 c9                	test   %ecx,%ecx
  80060c:	75 1b                	jne    800629 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800616:	89 c1                	mov    %eax,%ecx
  800618:	c1 f9 1f             	sar    $0x1f,%ecx
  80061b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8d 40 04             	lea    0x4(%eax),%eax
  800624:	89 45 14             	mov    %eax,0x14(%ebp)
  800627:	eb b9                	jmp    8005e2 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800629:	8b 45 14             	mov    0x14(%ebp),%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800631:	89 c1                	mov    %eax,%ecx
  800633:	c1 f9 1f             	sar    $0x1f,%ecx
  800636:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8d 40 04             	lea    0x4(%eax),%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
  800642:	eb 9e                	jmp    8005e2 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800644:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800647:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80064a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80064f:	e9 c6 00 00 00       	jmp    80071a <vprintfmt+0x3bb>
	if (lflag >= 2)
  800654:	83 f9 01             	cmp    $0x1,%ecx
  800657:	7e 18                	jle    800671 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 10                	mov    (%eax),%edx
  80065e:	8b 48 04             	mov    0x4(%eax),%ecx
  800661:	8d 40 08             	lea    0x8(%eax),%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800667:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066c:	e9 a9 00 00 00       	jmp    80071a <vprintfmt+0x3bb>
	else if (lflag)
  800671:	85 c9                	test   %ecx,%ecx
  800673:	75 1a                	jne    80068f <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8b 10                	mov    (%eax),%edx
  80067a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067f:	8d 40 04             	lea    0x4(%eax),%eax
  800682:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800685:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068a:	e9 8b 00 00 00       	jmp    80071a <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8b 10                	mov    (%eax),%edx
  800694:	b9 00 00 00 00       	mov    $0x0,%ecx
  800699:	8d 40 04             	lea    0x4(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069f:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a4:	eb 74                	jmp    80071a <vprintfmt+0x3bb>
	if (lflag >= 2)
  8006a6:	83 f9 01             	cmp    $0x1,%ecx
  8006a9:	7e 15                	jle    8006c0 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8b 10                	mov    (%eax),%edx
  8006b0:	8b 48 04             	mov    0x4(%eax),%ecx
  8006b3:	8d 40 08             	lea    0x8(%eax),%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b9:	b8 08 00 00 00       	mov    $0x8,%eax
  8006be:	eb 5a                	jmp    80071a <vprintfmt+0x3bb>
	else if (lflag)
  8006c0:	85 c9                	test   %ecx,%ecx
  8006c2:	75 17                	jne    8006db <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 10                	mov    (%eax),%edx
  8006c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ce:	8d 40 04             	lea    0x4(%eax),%eax
  8006d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d4:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d9:	eb 3f                	jmp    80071a <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8b 10                	mov    (%eax),%edx
  8006e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e5:	8d 40 04             	lea    0x4(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f0:	eb 28                	jmp    80071a <vprintfmt+0x3bb>
			putch('0', putdat);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	6a 30                	push   $0x30
  8006f8:	ff d6                	call   *%esi
			putch('x', putdat);
  8006fa:	83 c4 08             	add    $0x8,%esp
  8006fd:	53                   	push   %ebx
  8006fe:	6a 78                	push   $0x78
  800700:	ff d6                	call   *%esi
			num = (unsigned long long)
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8b 10                	mov    (%eax),%edx
  800707:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80070c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80070f:	8d 40 04             	lea    0x4(%eax),%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800715:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80071a:	83 ec 0c             	sub    $0xc,%esp
  80071d:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800721:	57                   	push   %edi
  800722:	ff 75 e0             	pushl  -0x20(%ebp)
  800725:	50                   	push   %eax
  800726:	51                   	push   %ecx
  800727:	52                   	push   %edx
  800728:	89 da                	mov    %ebx,%edx
  80072a:	89 f0                	mov    %esi,%eax
  80072c:	e8 45 fb ff ff       	call   800276 <printnum>
			break;
  800731:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800734:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  800737:	83 c7 01             	add    $0x1,%edi
  80073a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80073e:	83 f8 25             	cmp    $0x25,%eax
  800741:	0f 84 2f fc ff ff    	je     800376 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  800747:	85 c0                	test   %eax,%eax
  800749:	0f 84 8b 00 00 00    	je     8007da <vprintfmt+0x47b>
			putch(ch, putdat);
  80074f:	83 ec 08             	sub    $0x8,%esp
  800752:	53                   	push   %ebx
  800753:	50                   	push   %eax
  800754:	ff d6                	call   *%esi
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	eb dc                	jmp    800737 <vprintfmt+0x3d8>
	if (lflag >= 2)
  80075b:	83 f9 01             	cmp    $0x1,%ecx
  80075e:	7e 15                	jle    800775 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8b 10                	mov    (%eax),%edx
  800765:	8b 48 04             	mov    0x4(%eax),%ecx
  800768:	8d 40 08             	lea    0x8(%eax),%eax
  80076b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076e:	b8 10 00 00 00       	mov    $0x10,%eax
  800773:	eb a5                	jmp    80071a <vprintfmt+0x3bb>
	else if (lflag)
  800775:	85 c9                	test   %ecx,%ecx
  800777:	75 17                	jne    800790 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 10                	mov    (%eax),%edx
  80077e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800783:	8d 40 04             	lea    0x4(%eax),%eax
  800786:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800789:	b8 10 00 00 00       	mov    $0x10,%eax
  80078e:	eb 8a                	jmp    80071a <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8b 10                	mov    (%eax),%edx
  800795:	b9 00 00 00 00       	mov    $0x0,%ecx
  80079a:	8d 40 04             	lea    0x4(%eax),%eax
  80079d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a0:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a5:	e9 70 ff ff ff       	jmp    80071a <vprintfmt+0x3bb>
			putch(ch, putdat);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	53                   	push   %ebx
  8007ae:	6a 25                	push   $0x25
  8007b0:	ff d6                	call   *%esi
			break;
  8007b2:	83 c4 10             	add    $0x10,%esp
  8007b5:	e9 7a ff ff ff       	jmp    800734 <vprintfmt+0x3d5>
			putch('%', putdat);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	53                   	push   %ebx
  8007be:	6a 25                	push   $0x25
  8007c0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007c2:	83 c4 10             	add    $0x10,%esp
  8007c5:	89 f8                	mov    %edi,%eax
  8007c7:	eb 03                	jmp    8007cc <vprintfmt+0x46d>
  8007c9:	83 e8 01             	sub    $0x1,%eax
  8007cc:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007d0:	75 f7                	jne    8007c9 <vprintfmt+0x46a>
  8007d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d5:	e9 5a ff ff ff       	jmp    800734 <vprintfmt+0x3d5>
}
  8007da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007dd:	5b                   	pop    %ebx
  8007de:	5e                   	pop    %esi
  8007df:	5f                   	pop    %edi
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	83 ec 18             	sub    $0x18,%esp
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007f1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007f5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ff:	85 c0                	test   %eax,%eax
  800801:	74 26                	je     800829 <vsnprintf+0x47>
  800803:	85 d2                	test   %edx,%edx
  800805:	7e 22                	jle    800829 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800807:	ff 75 14             	pushl  0x14(%ebp)
  80080a:	ff 75 10             	pushl  0x10(%ebp)
  80080d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800810:	50                   	push   %eax
  800811:	68 25 03 80 00       	push   $0x800325
  800816:	e8 44 fb ff ff       	call   80035f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80081b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800824:	83 c4 10             	add    $0x10,%esp
}
  800827:	c9                   	leave  
  800828:	c3                   	ret    
		return -E_INVAL;
  800829:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80082e:	eb f7                	jmp    800827 <vsnprintf+0x45>

00800830 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800836:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800839:	50                   	push   %eax
  80083a:	ff 75 10             	pushl  0x10(%ebp)
  80083d:	ff 75 0c             	pushl  0xc(%ebp)
  800840:	ff 75 08             	pushl  0x8(%ebp)
  800843:	e8 9a ff ff ff       	call   8007e2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800848:	c9                   	leave  
  800849:	c3                   	ret    

0080084a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80084a:	55                   	push   %ebp
  80084b:	89 e5                	mov    %esp,%ebp
  80084d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800850:	b8 00 00 00 00       	mov    $0x0,%eax
  800855:	eb 03                	jmp    80085a <strlen+0x10>
		n++;
  800857:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80085a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80085e:	75 f7                	jne    800857 <strlen+0xd>
	return n;
}
  800860:	5d                   	pop    %ebp
  800861:	c3                   	ret    

00800862 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800868:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086b:	b8 00 00 00 00       	mov    $0x0,%eax
  800870:	eb 03                	jmp    800875 <strnlen+0x13>
		n++;
  800872:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800875:	39 d0                	cmp    %edx,%eax
  800877:	74 06                	je     80087f <strnlen+0x1d>
  800879:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80087d:	75 f3                	jne    800872 <strnlen+0x10>
	return n;
}
  80087f:	5d                   	pop    %ebp
  800880:	c3                   	ret    

00800881 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	53                   	push   %ebx
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80088b:	89 c2                	mov    %eax,%edx
  80088d:	83 c1 01             	add    $0x1,%ecx
  800890:	83 c2 01             	add    $0x1,%edx
  800893:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800897:	88 5a ff             	mov    %bl,-0x1(%edx)
  80089a:	84 db                	test   %bl,%bl
  80089c:	75 ef                	jne    80088d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80089e:	5b                   	pop    %ebx
  80089f:	5d                   	pop    %ebp
  8008a0:	c3                   	ret    

008008a1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	53                   	push   %ebx
  8008a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a8:	53                   	push   %ebx
  8008a9:	e8 9c ff ff ff       	call   80084a <strlen>
  8008ae:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	01 d8                	add    %ebx,%eax
  8008b6:	50                   	push   %eax
  8008b7:	e8 c5 ff ff ff       	call   800881 <strcpy>
	return dst;
}
  8008bc:	89 d8                	mov    %ebx,%eax
  8008be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c1:	c9                   	leave  
  8008c2:	c3                   	ret    

008008c3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	56                   	push   %esi
  8008c7:	53                   	push   %ebx
  8008c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8008cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ce:	89 f3                	mov    %esi,%ebx
  8008d0:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d3:	89 f2                	mov    %esi,%edx
  8008d5:	eb 0f                	jmp    8008e6 <strncpy+0x23>
		*dst++ = *src;
  8008d7:	83 c2 01             	add    $0x1,%edx
  8008da:	0f b6 01             	movzbl (%ecx),%eax
  8008dd:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008e0:	80 39 01             	cmpb   $0x1,(%ecx)
  8008e3:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008e6:	39 da                	cmp    %ebx,%edx
  8008e8:	75 ed                	jne    8008d7 <strncpy+0x14>
	}
	return ret;
}
  8008ea:	89 f0                	mov    %esi,%eax
  8008ec:	5b                   	pop    %ebx
  8008ed:	5e                   	pop    %esi
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	56                   	push   %esi
  8008f4:	53                   	push   %ebx
  8008f5:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008fe:	89 f0                	mov    %esi,%eax
  800900:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800904:	85 c9                	test   %ecx,%ecx
  800906:	75 0b                	jne    800913 <strlcpy+0x23>
  800908:	eb 17                	jmp    800921 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80090a:	83 c2 01             	add    $0x1,%edx
  80090d:	83 c0 01             	add    $0x1,%eax
  800910:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800913:	39 d8                	cmp    %ebx,%eax
  800915:	74 07                	je     80091e <strlcpy+0x2e>
  800917:	0f b6 0a             	movzbl (%edx),%ecx
  80091a:	84 c9                	test   %cl,%cl
  80091c:	75 ec                	jne    80090a <strlcpy+0x1a>
		*dst = '\0';
  80091e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800921:	29 f0                	sub    %esi,%eax
}
  800923:	5b                   	pop    %ebx
  800924:	5e                   	pop    %esi
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800930:	eb 06                	jmp    800938 <strcmp+0x11>
		p++, q++;
  800932:	83 c1 01             	add    $0x1,%ecx
  800935:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800938:	0f b6 01             	movzbl (%ecx),%eax
  80093b:	84 c0                	test   %al,%al
  80093d:	74 04                	je     800943 <strcmp+0x1c>
  80093f:	3a 02                	cmp    (%edx),%al
  800941:	74 ef                	je     800932 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800943:	0f b6 c0             	movzbl %al,%eax
  800946:	0f b6 12             	movzbl (%edx),%edx
  800949:	29 d0                	sub    %edx,%eax
}
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	53                   	push   %ebx
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	8b 55 0c             	mov    0xc(%ebp),%edx
  800957:	89 c3                	mov    %eax,%ebx
  800959:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80095c:	eb 06                	jmp    800964 <strncmp+0x17>
		n--, p++, q++;
  80095e:	83 c0 01             	add    $0x1,%eax
  800961:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800964:	39 d8                	cmp    %ebx,%eax
  800966:	74 16                	je     80097e <strncmp+0x31>
  800968:	0f b6 08             	movzbl (%eax),%ecx
  80096b:	84 c9                	test   %cl,%cl
  80096d:	74 04                	je     800973 <strncmp+0x26>
  80096f:	3a 0a                	cmp    (%edx),%cl
  800971:	74 eb                	je     80095e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800973:	0f b6 00             	movzbl (%eax),%eax
  800976:	0f b6 12             	movzbl (%edx),%edx
  800979:	29 d0                	sub    %edx,%eax
}
  80097b:	5b                   	pop    %ebx
  80097c:	5d                   	pop    %ebp
  80097d:	c3                   	ret    
		return 0;
  80097e:	b8 00 00 00 00       	mov    $0x0,%eax
  800983:	eb f6                	jmp    80097b <strncmp+0x2e>

00800985 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80098f:	0f b6 10             	movzbl (%eax),%edx
  800992:	84 d2                	test   %dl,%dl
  800994:	74 09                	je     80099f <strchr+0x1a>
		if (*s == c)
  800996:	38 ca                	cmp    %cl,%dl
  800998:	74 0a                	je     8009a4 <strchr+0x1f>
	for (; *s; s++)
  80099a:	83 c0 01             	add    $0x1,%eax
  80099d:	eb f0                	jmp    80098f <strchr+0xa>
			return (char *) s;
	return 0;
  80099f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a4:	5d                   	pop    %ebp
  8009a5:	c3                   	ret    

008009a6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b0:	eb 03                	jmp    8009b5 <strfind+0xf>
  8009b2:	83 c0 01             	add    $0x1,%eax
  8009b5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009b8:	38 ca                	cmp    %cl,%dl
  8009ba:	74 04                	je     8009c0 <strfind+0x1a>
  8009bc:	84 d2                	test   %dl,%dl
  8009be:	75 f2                	jne    8009b2 <strfind+0xc>
			break;
	return (char *) s;
}
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	57                   	push   %edi
  8009c6:	56                   	push   %esi
  8009c7:	53                   	push   %ebx
  8009c8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ce:	85 c9                	test   %ecx,%ecx
  8009d0:	74 13                	je     8009e5 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d2:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009d8:	75 05                	jne    8009df <memset+0x1d>
  8009da:	f6 c1 03             	test   $0x3,%cl
  8009dd:	74 0d                	je     8009ec <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e2:	fc                   	cld    
  8009e3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009e5:	89 f8                	mov    %edi,%eax
  8009e7:	5b                   	pop    %ebx
  8009e8:	5e                   	pop    %esi
  8009e9:	5f                   	pop    %edi
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    
		c &= 0xFF;
  8009ec:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009f0:	89 d3                	mov    %edx,%ebx
  8009f2:	c1 e3 08             	shl    $0x8,%ebx
  8009f5:	89 d0                	mov    %edx,%eax
  8009f7:	c1 e0 18             	shl    $0x18,%eax
  8009fa:	89 d6                	mov    %edx,%esi
  8009fc:	c1 e6 10             	shl    $0x10,%esi
  8009ff:	09 f0                	or     %esi,%eax
  800a01:	09 c2                	or     %eax,%edx
  800a03:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a05:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a08:	89 d0                	mov    %edx,%eax
  800a0a:	fc                   	cld    
  800a0b:	f3 ab                	rep stos %eax,%es:(%edi)
  800a0d:	eb d6                	jmp    8009e5 <memset+0x23>

00800a0f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	57                   	push   %edi
  800a13:	56                   	push   %esi
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a1d:	39 c6                	cmp    %eax,%esi
  800a1f:	73 35                	jae    800a56 <memmove+0x47>
  800a21:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a24:	39 c2                	cmp    %eax,%edx
  800a26:	76 2e                	jbe    800a56 <memmove+0x47>
		s += n;
		d += n;
  800a28:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2b:	89 d6                	mov    %edx,%esi
  800a2d:	09 fe                	or     %edi,%esi
  800a2f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a35:	74 0c                	je     800a43 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a37:	83 ef 01             	sub    $0x1,%edi
  800a3a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a3d:	fd                   	std    
  800a3e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a40:	fc                   	cld    
  800a41:	eb 21                	jmp    800a64 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a43:	f6 c1 03             	test   $0x3,%cl
  800a46:	75 ef                	jne    800a37 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a48:	83 ef 04             	sub    $0x4,%edi
  800a4b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a4e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a51:	fd                   	std    
  800a52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a54:	eb ea                	jmp    800a40 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a56:	89 f2                	mov    %esi,%edx
  800a58:	09 c2                	or     %eax,%edx
  800a5a:	f6 c2 03             	test   $0x3,%dl
  800a5d:	74 09                	je     800a68 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a5f:	89 c7                	mov    %eax,%edi
  800a61:	fc                   	cld    
  800a62:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a64:	5e                   	pop    %esi
  800a65:	5f                   	pop    %edi
  800a66:	5d                   	pop    %ebp
  800a67:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a68:	f6 c1 03             	test   $0x3,%cl
  800a6b:	75 f2                	jne    800a5f <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a6d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a70:	89 c7                	mov    %eax,%edi
  800a72:	fc                   	cld    
  800a73:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a75:	eb ed                	jmp    800a64 <memmove+0x55>

00800a77 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a7a:	ff 75 10             	pushl  0x10(%ebp)
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	ff 75 08             	pushl  0x8(%ebp)
  800a83:	e8 87 ff ff ff       	call   800a0f <memmove>
}
  800a88:	c9                   	leave  
  800a89:	c3                   	ret    

00800a8a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	56                   	push   %esi
  800a8e:	53                   	push   %ebx
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a95:	89 c6                	mov    %eax,%esi
  800a97:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a9a:	39 f0                	cmp    %esi,%eax
  800a9c:	74 1c                	je     800aba <memcmp+0x30>
		if (*s1 != *s2)
  800a9e:	0f b6 08             	movzbl (%eax),%ecx
  800aa1:	0f b6 1a             	movzbl (%edx),%ebx
  800aa4:	38 d9                	cmp    %bl,%cl
  800aa6:	75 08                	jne    800ab0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aa8:	83 c0 01             	add    $0x1,%eax
  800aab:	83 c2 01             	add    $0x1,%edx
  800aae:	eb ea                	jmp    800a9a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ab0:	0f b6 c1             	movzbl %cl,%eax
  800ab3:	0f b6 db             	movzbl %bl,%ebx
  800ab6:	29 d8                	sub    %ebx,%eax
  800ab8:	eb 05                	jmp    800abf <memcmp+0x35>
	}

	return 0;
  800aba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800abf:	5b                   	pop    %ebx
  800ac0:	5e                   	pop    %esi
  800ac1:	5d                   	pop    %ebp
  800ac2:	c3                   	ret    

00800ac3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800acc:	89 c2                	mov    %eax,%edx
  800ace:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad1:	39 d0                	cmp    %edx,%eax
  800ad3:	73 09                	jae    800ade <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad5:	38 08                	cmp    %cl,(%eax)
  800ad7:	74 05                	je     800ade <memfind+0x1b>
	for (; s < ends; s++)
  800ad9:	83 c0 01             	add    $0x1,%eax
  800adc:	eb f3                	jmp    800ad1 <memfind+0xe>
			break;
	return (void *) s;
}
  800ade:	5d                   	pop    %ebp
  800adf:	c3                   	ret    

00800ae0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	57                   	push   %edi
  800ae4:	56                   	push   %esi
  800ae5:	53                   	push   %ebx
  800ae6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aec:	eb 03                	jmp    800af1 <strtol+0x11>
		s++;
  800aee:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800af1:	0f b6 01             	movzbl (%ecx),%eax
  800af4:	3c 20                	cmp    $0x20,%al
  800af6:	74 f6                	je     800aee <strtol+0xe>
  800af8:	3c 09                	cmp    $0x9,%al
  800afa:	74 f2                	je     800aee <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800afc:	3c 2b                	cmp    $0x2b,%al
  800afe:	74 2e                	je     800b2e <strtol+0x4e>
	int neg = 0;
  800b00:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b05:	3c 2d                	cmp    $0x2d,%al
  800b07:	74 2f                	je     800b38 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b09:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b0f:	75 05                	jne    800b16 <strtol+0x36>
  800b11:	80 39 30             	cmpb   $0x30,(%ecx)
  800b14:	74 2c                	je     800b42 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b16:	85 db                	test   %ebx,%ebx
  800b18:	75 0a                	jne    800b24 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b1a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b1f:	80 39 30             	cmpb   $0x30,(%ecx)
  800b22:	74 28                	je     800b4c <strtol+0x6c>
		base = 10;
  800b24:	b8 00 00 00 00       	mov    $0x0,%eax
  800b29:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b2c:	eb 50                	jmp    800b7e <strtol+0x9e>
		s++;
  800b2e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b31:	bf 00 00 00 00       	mov    $0x0,%edi
  800b36:	eb d1                	jmp    800b09 <strtol+0x29>
		s++, neg = 1;
  800b38:	83 c1 01             	add    $0x1,%ecx
  800b3b:	bf 01 00 00 00       	mov    $0x1,%edi
  800b40:	eb c7                	jmp    800b09 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b42:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b46:	74 0e                	je     800b56 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b48:	85 db                	test   %ebx,%ebx
  800b4a:	75 d8                	jne    800b24 <strtol+0x44>
		s++, base = 8;
  800b4c:	83 c1 01             	add    $0x1,%ecx
  800b4f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b54:	eb ce                	jmp    800b24 <strtol+0x44>
		s += 2, base = 16;
  800b56:	83 c1 02             	add    $0x2,%ecx
  800b59:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b5e:	eb c4                	jmp    800b24 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b60:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b63:	89 f3                	mov    %esi,%ebx
  800b65:	80 fb 19             	cmp    $0x19,%bl
  800b68:	77 29                	ja     800b93 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b6a:	0f be d2             	movsbl %dl,%edx
  800b6d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b70:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b73:	7d 30                	jge    800ba5 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b75:	83 c1 01             	add    $0x1,%ecx
  800b78:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b7c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b7e:	0f b6 11             	movzbl (%ecx),%edx
  800b81:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b84:	89 f3                	mov    %esi,%ebx
  800b86:	80 fb 09             	cmp    $0x9,%bl
  800b89:	77 d5                	ja     800b60 <strtol+0x80>
			dig = *s - '0';
  800b8b:	0f be d2             	movsbl %dl,%edx
  800b8e:	83 ea 30             	sub    $0x30,%edx
  800b91:	eb dd                	jmp    800b70 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b93:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b96:	89 f3                	mov    %esi,%ebx
  800b98:	80 fb 19             	cmp    $0x19,%bl
  800b9b:	77 08                	ja     800ba5 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b9d:	0f be d2             	movsbl %dl,%edx
  800ba0:	83 ea 37             	sub    $0x37,%edx
  800ba3:	eb cb                	jmp    800b70 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ba5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba9:	74 05                	je     800bb0 <strtol+0xd0>
		*endptr = (char *) s;
  800bab:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bae:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bb0:	89 c2                	mov    %eax,%edx
  800bb2:	f7 da                	neg    %edx
  800bb4:	85 ff                	test   %edi,%edi
  800bb6:	0f 45 c2             	cmovne %edx,%eax
}
  800bb9:	5b                   	pop    %ebx
  800bba:	5e                   	pop    %esi
  800bbb:	5f                   	pop    %edi
  800bbc:	5d                   	pop    %ebp
  800bbd:	c3                   	ret    

00800bbe <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	57                   	push   %edi
  800bc2:	56                   	push   %esi
  800bc3:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bcf:	89 c3                	mov    %eax,%ebx
  800bd1:	89 c7                	mov    %eax,%edi
  800bd3:	89 c6                	mov    %eax,%esi
  800bd5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bd7:	5b                   	pop    %ebx
  800bd8:	5e                   	pop    %esi
  800bd9:	5f                   	pop    %edi
  800bda:	5d                   	pop    %ebp
  800bdb:	c3                   	ret    

00800bdc <sys_cgetc>:

int
sys_cgetc(void)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	57                   	push   %edi
  800be0:	56                   	push   %esi
  800be1:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800be2:	ba 00 00 00 00       	mov    $0x0,%edx
  800be7:	b8 01 00 00 00       	mov    $0x1,%eax
  800bec:	89 d1                	mov    %edx,%ecx
  800bee:	89 d3                	mov    %edx,%ebx
  800bf0:	89 d7                	mov    %edx,%edi
  800bf2:	89 d6                	mov    %edx,%esi
  800bf4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bf6:	5b                   	pop    %ebx
  800bf7:	5e                   	pop    %esi
  800bf8:	5f                   	pop    %edi
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    

00800bfb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	57                   	push   %edi
  800bff:	56                   	push   %esi
  800c00:	53                   	push   %ebx
  800c01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c04:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c09:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c11:	89 cb                	mov    %ecx,%ebx
  800c13:	89 cf                	mov    %ecx,%edi
  800c15:	89 ce                	mov    %ecx,%esi
  800c17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c19:	85 c0                	test   %eax,%eax
  800c1b:	7f 08                	jg     800c25 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c25:	83 ec 0c             	sub    $0xc,%esp
  800c28:	50                   	push   %eax
  800c29:	6a 03                	push   $0x3
  800c2b:	68 7f 23 80 00       	push   $0x80237f
  800c30:	6a 23                	push   $0x23
  800c32:	68 9c 23 80 00       	push   $0x80239c
  800c37:	e8 4b f5 ff ff       	call   800187 <_panic>

00800c3c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	57                   	push   %edi
  800c40:	56                   	push   %esi
  800c41:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c42:	ba 00 00 00 00       	mov    $0x0,%edx
  800c47:	b8 02 00 00 00       	mov    $0x2,%eax
  800c4c:	89 d1                	mov    %edx,%ecx
  800c4e:	89 d3                	mov    %edx,%ebx
  800c50:	89 d7                	mov    %edx,%edi
  800c52:	89 d6                	mov    %edx,%esi
  800c54:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c56:	5b                   	pop    %ebx
  800c57:	5e                   	pop    %esi
  800c58:	5f                   	pop    %edi
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <sys_yield>:

void
sys_yield(void)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	57                   	push   %edi
  800c5f:	56                   	push   %esi
  800c60:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c61:	ba 00 00 00 00       	mov    $0x0,%edx
  800c66:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c6b:	89 d1                	mov    %edx,%ecx
  800c6d:	89 d3                	mov    %edx,%ebx
  800c6f:	89 d7                	mov    %edx,%edi
  800c71:	89 d6                	mov    %edx,%esi
  800c73:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5f                   	pop    %edi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
  800c80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c83:	be 00 00 00 00       	mov    $0x0,%esi
  800c88:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8e:	b8 04 00 00 00       	mov    $0x4,%eax
  800c93:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c96:	89 f7                	mov    %esi,%edi
  800c98:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9a:	85 c0                	test   %eax,%eax
  800c9c:	7f 08                	jg     800ca6 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5f                   	pop    %edi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	50                   	push   %eax
  800caa:	6a 04                	push   $0x4
  800cac:	68 7f 23 80 00       	push   $0x80237f
  800cb1:	6a 23                	push   $0x23
  800cb3:	68 9c 23 80 00       	push   $0x80239c
  800cb8:	e8 ca f4 ff ff       	call   800187 <_panic>

00800cbd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	57                   	push   %edi
  800cc1:	56                   	push   %esi
  800cc2:	53                   	push   %ebx
  800cc3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccc:	b8 05 00 00 00       	mov    $0x5,%eax
  800cd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cd4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cd7:	8b 75 18             	mov    0x18(%ebp),%esi
  800cda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cdc:	85 c0                	test   %eax,%eax
  800cde:	7f 08                	jg     800ce8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce3:	5b                   	pop    %ebx
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce8:	83 ec 0c             	sub    $0xc,%esp
  800ceb:	50                   	push   %eax
  800cec:	6a 05                	push   $0x5
  800cee:	68 7f 23 80 00       	push   $0x80237f
  800cf3:	6a 23                	push   $0x23
  800cf5:	68 9c 23 80 00       	push   $0x80239c
  800cfa:	e8 88 f4 ff ff       	call   800187 <_panic>

00800cff <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	57                   	push   %edi
  800d03:	56                   	push   %esi
  800d04:	53                   	push   %ebx
  800d05:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d08:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d13:	b8 06 00 00 00       	mov    $0x6,%eax
  800d18:	89 df                	mov    %ebx,%edi
  800d1a:	89 de                	mov    %ebx,%esi
  800d1c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1e:	85 c0                	test   %eax,%eax
  800d20:	7f 08                	jg     800d2a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2a:	83 ec 0c             	sub    $0xc,%esp
  800d2d:	50                   	push   %eax
  800d2e:	6a 06                	push   $0x6
  800d30:	68 7f 23 80 00       	push   $0x80237f
  800d35:	6a 23                	push   $0x23
  800d37:	68 9c 23 80 00       	push   $0x80239c
  800d3c:	e8 46 f4 ff ff       	call   800187 <_panic>

00800d41 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	57                   	push   %edi
  800d45:	56                   	push   %esi
  800d46:	53                   	push   %ebx
  800d47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d55:	b8 08 00 00 00       	mov    $0x8,%eax
  800d5a:	89 df                	mov    %ebx,%edi
  800d5c:	89 de                	mov    %ebx,%esi
  800d5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d60:	85 c0                	test   %eax,%eax
  800d62:	7f 08                	jg     800d6c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d67:	5b                   	pop    %ebx
  800d68:	5e                   	pop    %esi
  800d69:	5f                   	pop    %edi
  800d6a:	5d                   	pop    %ebp
  800d6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6c:	83 ec 0c             	sub    $0xc,%esp
  800d6f:	50                   	push   %eax
  800d70:	6a 08                	push   $0x8
  800d72:	68 7f 23 80 00       	push   $0x80237f
  800d77:	6a 23                	push   $0x23
  800d79:	68 9c 23 80 00       	push   $0x80239c
  800d7e:	e8 04 f4 ff ff       	call   800187 <_panic>

00800d83 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	57                   	push   %edi
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
  800d89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d91:	8b 55 08             	mov    0x8(%ebp),%edx
  800d94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d97:	b8 09 00 00 00       	mov    $0x9,%eax
  800d9c:	89 df                	mov    %ebx,%edi
  800d9e:	89 de                	mov    %ebx,%esi
  800da0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da2:	85 c0                	test   %eax,%eax
  800da4:	7f 08                	jg     800dae <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800da6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da9:	5b                   	pop    %ebx
  800daa:	5e                   	pop    %esi
  800dab:	5f                   	pop    %edi
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dae:	83 ec 0c             	sub    $0xc,%esp
  800db1:	50                   	push   %eax
  800db2:	6a 09                	push   $0x9
  800db4:	68 7f 23 80 00       	push   $0x80237f
  800db9:	6a 23                	push   $0x23
  800dbb:	68 9c 23 80 00       	push   $0x80239c
  800dc0:	e8 c2 f3 ff ff       	call   800187 <_panic>

00800dc5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	57                   	push   %edi
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
  800dcb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800dce:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dde:	89 df                	mov    %ebx,%edi
  800de0:	89 de                	mov    %ebx,%esi
  800de2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de4:	85 c0                	test   %eax,%eax
  800de6:	7f 08                	jg     800df0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800df4:	6a 0a                	push   $0xa
  800df6:	68 7f 23 80 00       	push   $0x80237f
  800dfb:	6a 23                	push   $0x23
  800dfd:	68 9c 23 80 00       	push   $0x80239c
  800e02:	e8 80 f3 ff ff       	call   800187 <_panic>

00800e07 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	57                   	push   %edi
  800e0b:	56                   	push   %esi
  800e0c:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e13:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e18:	be 00 00 00 00       	mov    $0x0,%esi
  800e1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e20:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e23:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e25:	5b                   	pop    %ebx
  800e26:	5e                   	pop    %esi
  800e27:	5f                   	pop    %edi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
  800e30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e33:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e38:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e40:	89 cb                	mov    %ecx,%ebx
  800e42:	89 cf                	mov    %ecx,%edi
  800e44:	89 ce                	mov    %ecx,%esi
  800e46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e48:	85 c0                	test   %eax,%eax
  800e4a:	7f 08                	jg     800e54 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4f:	5b                   	pop    %ebx
  800e50:	5e                   	pop    %esi
  800e51:	5f                   	pop    %edi
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e54:	83 ec 0c             	sub    $0xc,%esp
  800e57:	50                   	push   %eax
  800e58:	6a 0d                	push   $0xd
  800e5a:	68 7f 23 80 00       	push   $0x80237f
  800e5f:	6a 23                	push   $0x23
  800e61:	68 9c 23 80 00       	push   $0x80239c
  800e66:	e8 1c f3 ff ff       	call   800187 <_panic>

00800e6b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	05 00 00 00 30       	add    $0x30000000,%eax
  800e76:	c1 e8 0c             	shr    $0xc,%eax
}
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e8b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e90:	5d                   	pop    %ebp
  800e91:	c3                   	ret    

00800e92 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e98:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e9d:	89 c2                	mov    %eax,%edx
  800e9f:	c1 ea 16             	shr    $0x16,%edx
  800ea2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ea9:	f6 c2 01             	test   $0x1,%dl
  800eac:	74 2a                	je     800ed8 <fd_alloc+0x46>
  800eae:	89 c2                	mov    %eax,%edx
  800eb0:	c1 ea 0c             	shr    $0xc,%edx
  800eb3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800eba:	f6 c2 01             	test   $0x1,%dl
  800ebd:	74 19                	je     800ed8 <fd_alloc+0x46>
  800ebf:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ec4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ec9:	75 d2                	jne    800e9d <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ecb:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ed1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ed6:	eb 07                	jmp    800edf <fd_alloc+0x4d>
			*fd_store = fd;
  800ed8:	89 01                	mov    %eax,(%ecx)
			return 0;
  800eda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800edf:	5d                   	pop    %ebp
  800ee0:	c3                   	ret    

00800ee1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ee7:	83 f8 1f             	cmp    $0x1f,%eax
  800eea:	77 36                	ja     800f22 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800eec:	c1 e0 0c             	shl    $0xc,%eax
  800eef:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ef4:	89 c2                	mov    %eax,%edx
  800ef6:	c1 ea 16             	shr    $0x16,%edx
  800ef9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f00:	f6 c2 01             	test   $0x1,%dl
  800f03:	74 24                	je     800f29 <fd_lookup+0x48>
  800f05:	89 c2                	mov    %eax,%edx
  800f07:	c1 ea 0c             	shr    $0xc,%edx
  800f0a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f11:	f6 c2 01             	test   $0x1,%dl
  800f14:	74 1a                	je     800f30 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f19:	89 02                	mov    %eax,(%edx)
	return 0;
  800f1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    
		return -E_INVAL;
  800f22:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f27:	eb f7                	jmp    800f20 <fd_lookup+0x3f>
		return -E_INVAL;
  800f29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f2e:	eb f0                	jmp    800f20 <fd_lookup+0x3f>
  800f30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f35:	eb e9                	jmp    800f20 <fd_lookup+0x3f>

00800f37 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 08             	sub    $0x8,%esp
  800f3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f40:	ba 2c 24 80 00       	mov    $0x80242c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f45:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f4a:	39 08                	cmp    %ecx,(%eax)
  800f4c:	74 33                	je     800f81 <dev_lookup+0x4a>
  800f4e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f51:	8b 02                	mov    (%edx),%eax
  800f53:	85 c0                	test   %eax,%eax
  800f55:	75 f3                	jne    800f4a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f57:	a1 20 60 80 00       	mov    0x806020,%eax
  800f5c:	8b 40 48             	mov    0x48(%eax),%eax
  800f5f:	83 ec 04             	sub    $0x4,%esp
  800f62:	51                   	push   %ecx
  800f63:	50                   	push   %eax
  800f64:	68 ac 23 80 00       	push   $0x8023ac
  800f69:	e8 f4 f2 ff ff       	call   800262 <cprintf>
	*dev = 0;
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f77:	83 c4 10             	add    $0x10,%esp
  800f7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    
			*dev = devtab[i];
  800f81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f84:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f86:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8b:	eb f2                	jmp    800f7f <dev_lookup+0x48>

00800f8d <fd_close>:
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	57                   	push   %edi
  800f91:	56                   	push   %esi
  800f92:	53                   	push   %ebx
  800f93:	83 ec 1c             	sub    $0x1c,%esp
  800f96:	8b 75 08             	mov    0x8(%ebp),%esi
  800f99:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f9c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f9f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa0:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fa6:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fa9:	50                   	push   %eax
  800faa:	e8 32 ff ff ff       	call   800ee1 <fd_lookup>
  800faf:	89 c3                	mov    %eax,%ebx
  800fb1:	83 c4 08             	add    $0x8,%esp
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	78 05                	js     800fbd <fd_close+0x30>
	    || fd != fd2)
  800fb8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fbb:	74 16                	je     800fd3 <fd_close+0x46>
		return (must_exist ? r : 0);
  800fbd:	89 f8                	mov    %edi,%eax
  800fbf:	84 c0                	test   %al,%al
  800fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc6:	0f 44 d8             	cmove  %eax,%ebx
}
  800fc9:	89 d8                	mov    %ebx,%eax
  800fcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fce:	5b                   	pop    %ebx
  800fcf:	5e                   	pop    %esi
  800fd0:	5f                   	pop    %edi
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fd3:	83 ec 08             	sub    $0x8,%esp
  800fd6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fd9:	50                   	push   %eax
  800fda:	ff 36                	pushl  (%esi)
  800fdc:	e8 56 ff ff ff       	call   800f37 <dev_lookup>
  800fe1:	89 c3                	mov    %eax,%ebx
  800fe3:	83 c4 10             	add    $0x10,%esp
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	78 15                	js     800fff <fd_close+0x72>
		if (dev->dev_close)
  800fea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fed:	8b 40 10             	mov    0x10(%eax),%eax
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	74 1b                	je     80100f <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800ff4:	83 ec 0c             	sub    $0xc,%esp
  800ff7:	56                   	push   %esi
  800ff8:	ff d0                	call   *%eax
  800ffa:	89 c3                	mov    %eax,%ebx
  800ffc:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fff:	83 ec 08             	sub    $0x8,%esp
  801002:	56                   	push   %esi
  801003:	6a 00                	push   $0x0
  801005:	e8 f5 fc ff ff       	call   800cff <sys_page_unmap>
	return r;
  80100a:	83 c4 10             	add    $0x10,%esp
  80100d:	eb ba                	jmp    800fc9 <fd_close+0x3c>
			r = 0;
  80100f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801014:	eb e9                	jmp    800fff <fd_close+0x72>

00801016 <close>:

int
close(int fdnum)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80101c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80101f:	50                   	push   %eax
  801020:	ff 75 08             	pushl  0x8(%ebp)
  801023:	e8 b9 fe ff ff       	call   800ee1 <fd_lookup>
  801028:	83 c4 08             	add    $0x8,%esp
  80102b:	85 c0                	test   %eax,%eax
  80102d:	78 10                	js     80103f <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80102f:	83 ec 08             	sub    $0x8,%esp
  801032:	6a 01                	push   $0x1
  801034:	ff 75 f4             	pushl  -0xc(%ebp)
  801037:	e8 51 ff ff ff       	call   800f8d <fd_close>
  80103c:	83 c4 10             	add    $0x10,%esp
}
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <close_all>:

void
close_all(void)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	53                   	push   %ebx
  801045:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801048:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80104d:	83 ec 0c             	sub    $0xc,%esp
  801050:	53                   	push   %ebx
  801051:	e8 c0 ff ff ff       	call   801016 <close>
	for (i = 0; i < MAXFD; i++)
  801056:	83 c3 01             	add    $0x1,%ebx
  801059:	83 c4 10             	add    $0x10,%esp
  80105c:	83 fb 20             	cmp    $0x20,%ebx
  80105f:	75 ec                	jne    80104d <close_all+0xc>
}
  801061:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	57                   	push   %edi
  80106a:	56                   	push   %esi
  80106b:	53                   	push   %ebx
  80106c:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80106f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801072:	50                   	push   %eax
  801073:	ff 75 08             	pushl  0x8(%ebp)
  801076:	e8 66 fe ff ff       	call   800ee1 <fd_lookup>
  80107b:	89 c3                	mov    %eax,%ebx
  80107d:	83 c4 08             	add    $0x8,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	0f 88 81 00 00 00    	js     801109 <dup+0xa3>
		return r;
	close(newfdnum);
  801088:	83 ec 0c             	sub    $0xc,%esp
  80108b:	ff 75 0c             	pushl  0xc(%ebp)
  80108e:	e8 83 ff ff ff       	call   801016 <close>

	newfd = INDEX2FD(newfdnum);
  801093:	8b 75 0c             	mov    0xc(%ebp),%esi
  801096:	c1 e6 0c             	shl    $0xc,%esi
  801099:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80109f:	83 c4 04             	add    $0x4,%esp
  8010a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010a5:	e8 d1 fd ff ff       	call   800e7b <fd2data>
  8010aa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010ac:	89 34 24             	mov    %esi,(%esp)
  8010af:	e8 c7 fd ff ff       	call   800e7b <fd2data>
  8010b4:	83 c4 10             	add    $0x10,%esp
  8010b7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010b9:	89 d8                	mov    %ebx,%eax
  8010bb:	c1 e8 16             	shr    $0x16,%eax
  8010be:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010c5:	a8 01                	test   $0x1,%al
  8010c7:	74 11                	je     8010da <dup+0x74>
  8010c9:	89 d8                	mov    %ebx,%eax
  8010cb:	c1 e8 0c             	shr    $0xc,%eax
  8010ce:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010d5:	f6 c2 01             	test   $0x1,%dl
  8010d8:	75 39                	jne    801113 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010dd:	89 d0                	mov    %edx,%eax
  8010df:	c1 e8 0c             	shr    $0xc,%eax
  8010e2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010e9:	83 ec 0c             	sub    $0xc,%esp
  8010ec:	25 07 0e 00 00       	and    $0xe07,%eax
  8010f1:	50                   	push   %eax
  8010f2:	56                   	push   %esi
  8010f3:	6a 00                	push   $0x0
  8010f5:	52                   	push   %edx
  8010f6:	6a 00                	push   $0x0
  8010f8:	e8 c0 fb ff ff       	call   800cbd <sys_page_map>
  8010fd:	89 c3                	mov    %eax,%ebx
  8010ff:	83 c4 20             	add    $0x20,%esp
  801102:	85 c0                	test   %eax,%eax
  801104:	78 31                	js     801137 <dup+0xd1>
		goto err;

	return newfdnum;
  801106:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801109:	89 d8                	mov    %ebx,%eax
  80110b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110e:	5b                   	pop    %ebx
  80110f:	5e                   	pop    %esi
  801110:	5f                   	pop    %edi
  801111:	5d                   	pop    %ebp
  801112:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801113:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	25 07 0e 00 00       	and    $0xe07,%eax
  801122:	50                   	push   %eax
  801123:	57                   	push   %edi
  801124:	6a 00                	push   $0x0
  801126:	53                   	push   %ebx
  801127:	6a 00                	push   $0x0
  801129:	e8 8f fb ff ff       	call   800cbd <sys_page_map>
  80112e:	89 c3                	mov    %eax,%ebx
  801130:	83 c4 20             	add    $0x20,%esp
  801133:	85 c0                	test   %eax,%eax
  801135:	79 a3                	jns    8010da <dup+0x74>
	sys_page_unmap(0, newfd);
  801137:	83 ec 08             	sub    $0x8,%esp
  80113a:	56                   	push   %esi
  80113b:	6a 00                	push   $0x0
  80113d:	e8 bd fb ff ff       	call   800cff <sys_page_unmap>
	sys_page_unmap(0, nva);
  801142:	83 c4 08             	add    $0x8,%esp
  801145:	57                   	push   %edi
  801146:	6a 00                	push   $0x0
  801148:	e8 b2 fb ff ff       	call   800cff <sys_page_unmap>
	return r;
  80114d:	83 c4 10             	add    $0x10,%esp
  801150:	eb b7                	jmp    801109 <dup+0xa3>

00801152 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	53                   	push   %ebx
  801156:	83 ec 14             	sub    $0x14,%esp
  801159:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80115c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80115f:	50                   	push   %eax
  801160:	53                   	push   %ebx
  801161:	e8 7b fd ff ff       	call   800ee1 <fd_lookup>
  801166:	83 c4 08             	add    $0x8,%esp
  801169:	85 c0                	test   %eax,%eax
  80116b:	78 3f                	js     8011ac <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80116d:	83 ec 08             	sub    $0x8,%esp
  801170:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801173:	50                   	push   %eax
  801174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801177:	ff 30                	pushl  (%eax)
  801179:	e8 b9 fd ff ff       	call   800f37 <dev_lookup>
  80117e:	83 c4 10             	add    $0x10,%esp
  801181:	85 c0                	test   %eax,%eax
  801183:	78 27                	js     8011ac <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801185:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801188:	8b 42 08             	mov    0x8(%edx),%eax
  80118b:	83 e0 03             	and    $0x3,%eax
  80118e:	83 f8 01             	cmp    $0x1,%eax
  801191:	74 1e                	je     8011b1 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801196:	8b 40 08             	mov    0x8(%eax),%eax
  801199:	85 c0                	test   %eax,%eax
  80119b:	74 35                	je     8011d2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80119d:	83 ec 04             	sub    $0x4,%esp
  8011a0:	ff 75 10             	pushl  0x10(%ebp)
  8011a3:	ff 75 0c             	pushl  0xc(%ebp)
  8011a6:	52                   	push   %edx
  8011a7:	ff d0                	call   *%eax
  8011a9:	83 c4 10             	add    $0x10,%esp
}
  8011ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011b1:	a1 20 60 80 00       	mov    0x806020,%eax
  8011b6:	8b 40 48             	mov    0x48(%eax),%eax
  8011b9:	83 ec 04             	sub    $0x4,%esp
  8011bc:	53                   	push   %ebx
  8011bd:	50                   	push   %eax
  8011be:	68 f0 23 80 00       	push   $0x8023f0
  8011c3:	e8 9a f0 ff ff       	call   800262 <cprintf>
		return -E_INVAL;
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d0:	eb da                	jmp    8011ac <read+0x5a>
		return -E_NOT_SUPP;
  8011d2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011d7:	eb d3                	jmp    8011ac <read+0x5a>

008011d9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	57                   	push   %edi
  8011dd:	56                   	push   %esi
  8011de:	53                   	push   %ebx
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011e5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ed:	39 f3                	cmp    %esi,%ebx
  8011ef:	73 25                	jae    801216 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011f1:	83 ec 04             	sub    $0x4,%esp
  8011f4:	89 f0                	mov    %esi,%eax
  8011f6:	29 d8                	sub    %ebx,%eax
  8011f8:	50                   	push   %eax
  8011f9:	89 d8                	mov    %ebx,%eax
  8011fb:	03 45 0c             	add    0xc(%ebp),%eax
  8011fe:	50                   	push   %eax
  8011ff:	57                   	push   %edi
  801200:	e8 4d ff ff ff       	call   801152 <read>
		if (m < 0)
  801205:	83 c4 10             	add    $0x10,%esp
  801208:	85 c0                	test   %eax,%eax
  80120a:	78 08                	js     801214 <readn+0x3b>
			return m;
		if (m == 0)
  80120c:	85 c0                	test   %eax,%eax
  80120e:	74 06                	je     801216 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801210:	01 c3                	add    %eax,%ebx
  801212:	eb d9                	jmp    8011ed <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801214:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801216:	89 d8                	mov    %ebx,%eax
  801218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80121b:	5b                   	pop    %ebx
  80121c:	5e                   	pop    %esi
  80121d:	5f                   	pop    %edi
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    

00801220 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	53                   	push   %ebx
  801224:	83 ec 14             	sub    $0x14,%esp
  801227:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80122a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80122d:	50                   	push   %eax
  80122e:	53                   	push   %ebx
  80122f:	e8 ad fc ff ff       	call   800ee1 <fd_lookup>
  801234:	83 c4 08             	add    $0x8,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	78 3a                	js     801275 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80123b:	83 ec 08             	sub    $0x8,%esp
  80123e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801241:	50                   	push   %eax
  801242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801245:	ff 30                	pushl  (%eax)
  801247:	e8 eb fc ff ff       	call   800f37 <dev_lookup>
  80124c:	83 c4 10             	add    $0x10,%esp
  80124f:	85 c0                	test   %eax,%eax
  801251:	78 22                	js     801275 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801256:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80125a:	74 1e                	je     80127a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80125c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125f:	8b 52 0c             	mov    0xc(%edx),%edx
  801262:	85 d2                	test   %edx,%edx
  801264:	74 35                	je     80129b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	ff 75 10             	pushl  0x10(%ebp)
  80126c:	ff 75 0c             	pushl  0xc(%ebp)
  80126f:	50                   	push   %eax
  801270:	ff d2                	call   *%edx
  801272:	83 c4 10             	add    $0x10,%esp
}
  801275:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801278:	c9                   	leave  
  801279:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80127a:	a1 20 60 80 00       	mov    0x806020,%eax
  80127f:	8b 40 48             	mov    0x48(%eax),%eax
  801282:	83 ec 04             	sub    $0x4,%esp
  801285:	53                   	push   %ebx
  801286:	50                   	push   %eax
  801287:	68 0c 24 80 00       	push   $0x80240c
  80128c:	e8 d1 ef ff ff       	call   800262 <cprintf>
		return -E_INVAL;
  801291:	83 c4 10             	add    $0x10,%esp
  801294:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801299:	eb da                	jmp    801275 <write+0x55>
		return -E_NOT_SUPP;
  80129b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012a0:	eb d3                	jmp    801275 <write+0x55>

008012a2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012a8:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012ab:	50                   	push   %eax
  8012ac:	ff 75 08             	pushl  0x8(%ebp)
  8012af:	e8 2d fc ff ff       	call   800ee1 <fd_lookup>
  8012b4:	83 c4 08             	add    $0x8,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	78 0e                	js     8012c9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c9:	c9                   	leave  
  8012ca:	c3                   	ret    

008012cb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	53                   	push   %ebx
  8012cf:	83 ec 14             	sub    $0x14,%esp
  8012d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d8:	50                   	push   %eax
  8012d9:	53                   	push   %ebx
  8012da:	e8 02 fc ff ff       	call   800ee1 <fd_lookup>
  8012df:	83 c4 08             	add    $0x8,%esp
  8012e2:	85 c0                	test   %eax,%eax
  8012e4:	78 37                	js     80131d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012e6:	83 ec 08             	sub    $0x8,%esp
  8012e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ec:	50                   	push   %eax
  8012ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f0:	ff 30                	pushl  (%eax)
  8012f2:	e8 40 fc ff ff       	call   800f37 <dev_lookup>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	78 1f                	js     80131d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801301:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801305:	74 1b                	je     801322 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801307:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130a:	8b 52 18             	mov    0x18(%edx),%edx
  80130d:	85 d2                	test   %edx,%edx
  80130f:	74 32                	je     801343 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801311:	83 ec 08             	sub    $0x8,%esp
  801314:	ff 75 0c             	pushl  0xc(%ebp)
  801317:	50                   	push   %eax
  801318:	ff d2                	call   *%edx
  80131a:	83 c4 10             	add    $0x10,%esp
}
  80131d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801320:	c9                   	leave  
  801321:	c3                   	ret    
			thisenv->env_id, fdnum);
  801322:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801327:	8b 40 48             	mov    0x48(%eax),%eax
  80132a:	83 ec 04             	sub    $0x4,%esp
  80132d:	53                   	push   %ebx
  80132e:	50                   	push   %eax
  80132f:	68 cc 23 80 00       	push   $0x8023cc
  801334:	e8 29 ef ff ff       	call   800262 <cprintf>
		return -E_INVAL;
  801339:	83 c4 10             	add    $0x10,%esp
  80133c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801341:	eb da                	jmp    80131d <ftruncate+0x52>
		return -E_NOT_SUPP;
  801343:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801348:	eb d3                	jmp    80131d <ftruncate+0x52>

0080134a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	53                   	push   %ebx
  80134e:	83 ec 14             	sub    $0x14,%esp
  801351:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801354:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801357:	50                   	push   %eax
  801358:	ff 75 08             	pushl  0x8(%ebp)
  80135b:	e8 81 fb ff ff       	call   800ee1 <fd_lookup>
  801360:	83 c4 08             	add    $0x8,%esp
  801363:	85 c0                	test   %eax,%eax
  801365:	78 4b                	js     8013b2 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801367:	83 ec 08             	sub    $0x8,%esp
  80136a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136d:	50                   	push   %eax
  80136e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801371:	ff 30                	pushl  (%eax)
  801373:	e8 bf fb ff ff       	call   800f37 <dev_lookup>
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	85 c0                	test   %eax,%eax
  80137d:	78 33                	js     8013b2 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80137f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801382:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801386:	74 2f                	je     8013b7 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801388:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80138b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801392:	00 00 00 
	stat->st_isdir = 0;
  801395:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80139c:	00 00 00 
	stat->st_dev = dev;
  80139f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013a5:	83 ec 08             	sub    $0x8,%esp
  8013a8:	53                   	push   %ebx
  8013a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8013ac:	ff 50 14             	call   *0x14(%eax)
  8013af:	83 c4 10             	add    $0x10,%esp
}
  8013b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    
		return -E_NOT_SUPP;
  8013b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013bc:	eb f4                	jmp    8013b2 <fstat+0x68>

008013be <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	56                   	push   %esi
  8013c2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013c3:	83 ec 08             	sub    $0x8,%esp
  8013c6:	6a 00                	push   $0x0
  8013c8:	ff 75 08             	pushl  0x8(%ebp)
  8013cb:	e8 30 02 00 00       	call   801600 <open>
  8013d0:	89 c3                	mov    %eax,%ebx
  8013d2:	83 c4 10             	add    $0x10,%esp
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	78 1b                	js     8013f4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013d9:	83 ec 08             	sub    $0x8,%esp
  8013dc:	ff 75 0c             	pushl  0xc(%ebp)
  8013df:	50                   	push   %eax
  8013e0:	e8 65 ff ff ff       	call   80134a <fstat>
  8013e5:	89 c6                	mov    %eax,%esi
	close(fd);
  8013e7:	89 1c 24             	mov    %ebx,(%esp)
  8013ea:	e8 27 fc ff ff       	call   801016 <close>
	return r;
  8013ef:	83 c4 10             	add    $0x10,%esp
  8013f2:	89 f3                	mov    %esi,%ebx
}
  8013f4:	89 d8                	mov    %ebx,%eax
  8013f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013f9:	5b                   	pop    %ebx
  8013fa:	5e                   	pop    %esi
  8013fb:	5d                   	pop    %ebp
  8013fc:	c3                   	ret    

008013fd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	56                   	push   %esi
  801401:	53                   	push   %ebx
  801402:	89 c6                	mov    %eax,%esi
  801404:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801406:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80140d:	74 27                	je     801436 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80140f:	6a 07                	push   $0x7
  801411:	68 00 70 80 00       	push   $0x807000
  801416:	56                   	push   %esi
  801417:	ff 35 00 40 80 00    	pushl  0x804000
  80141d:	e8 cb 08 00 00       	call   801ced <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801422:	83 c4 0c             	add    $0xc,%esp
  801425:	6a 00                	push   $0x0
  801427:	53                   	push   %ebx
  801428:	6a 00                	push   $0x0
  80142a:	e8 55 08 00 00       	call   801c84 <ipc_recv>
}
  80142f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801432:	5b                   	pop    %ebx
  801433:	5e                   	pop    %esi
  801434:	5d                   	pop    %ebp
  801435:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801436:	83 ec 0c             	sub    $0xc,%esp
  801439:	6a 01                	push   $0x1
  80143b:	e8 01 09 00 00       	call   801d41 <ipc_find_env>
  801440:	a3 00 40 80 00       	mov    %eax,0x804000
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	eb c5                	jmp    80140f <fsipc+0x12>

0080144a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	8b 40 0c             	mov    0xc(%eax),%eax
  801456:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80145b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145e:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801463:	ba 00 00 00 00       	mov    $0x0,%edx
  801468:	b8 02 00 00 00       	mov    $0x2,%eax
  80146d:	e8 8b ff ff ff       	call   8013fd <fsipc>
}
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <devfile_flush>:
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8b 40 0c             	mov    0xc(%eax),%eax
  801480:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801485:	ba 00 00 00 00       	mov    $0x0,%edx
  80148a:	b8 06 00 00 00       	mov    $0x6,%eax
  80148f:	e8 69 ff ff ff       	call   8013fd <fsipc>
}
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <devfile_stat>:
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	53                   	push   %ebx
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a6:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8014b5:	e8 43 ff ff ff       	call   8013fd <fsipc>
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	78 2c                	js     8014ea <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014be:	83 ec 08             	sub    $0x8,%esp
  8014c1:	68 00 70 80 00       	push   $0x807000
  8014c6:	53                   	push   %ebx
  8014c7:	e8 b5 f3 ff ff       	call   800881 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014cc:	a1 80 70 80 00       	mov    0x807080,%eax
  8014d1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014d7:	a1 84 70 80 00       	mov    0x807084,%eax
  8014dc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <devfile_write>:
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	53                   	push   %ebx
  8014f3:	83 ec 08             	sub    $0x8,%esp
  8014f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  8014f9:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8014ff:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801504:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8b 40 0c             	mov    0xc(%eax),%eax
  80150d:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  801512:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801518:	53                   	push   %ebx
  801519:	ff 75 0c             	pushl  0xc(%ebp)
  80151c:	68 08 70 80 00       	push   $0x807008
  801521:	e8 e9 f4 ff ff       	call   800a0f <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801526:	ba 00 00 00 00       	mov    $0x0,%edx
  80152b:	b8 04 00 00 00       	mov    $0x4,%eax
  801530:	e8 c8 fe ff ff       	call   8013fd <fsipc>
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	85 c0                	test   %eax,%eax
  80153a:	78 0b                	js     801547 <devfile_write+0x58>
	assert(r <= n);
  80153c:	39 d8                	cmp    %ebx,%eax
  80153e:	77 0c                	ja     80154c <devfile_write+0x5d>
	assert(r <= PGSIZE);
  801540:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801545:	7f 1e                	jg     801565 <devfile_write+0x76>
}
  801547:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    
	assert(r <= n);
  80154c:	68 3c 24 80 00       	push   $0x80243c
  801551:	68 43 24 80 00       	push   $0x802443
  801556:	68 98 00 00 00       	push   $0x98
  80155b:	68 58 24 80 00       	push   $0x802458
  801560:	e8 22 ec ff ff       	call   800187 <_panic>
	assert(r <= PGSIZE);
  801565:	68 63 24 80 00       	push   $0x802463
  80156a:	68 43 24 80 00       	push   $0x802443
  80156f:	68 99 00 00 00       	push   $0x99
  801574:	68 58 24 80 00       	push   $0x802458
  801579:	e8 09 ec ff ff       	call   800187 <_panic>

0080157e <devfile_read>:
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	56                   	push   %esi
  801582:	53                   	push   %ebx
  801583:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	8b 40 0c             	mov    0xc(%eax),%eax
  80158c:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801591:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801597:	ba 00 00 00 00       	mov    $0x0,%edx
  80159c:	b8 03 00 00 00       	mov    $0x3,%eax
  8015a1:	e8 57 fe ff ff       	call   8013fd <fsipc>
  8015a6:	89 c3                	mov    %eax,%ebx
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	78 1f                	js     8015cb <devfile_read+0x4d>
	assert(r <= n);
  8015ac:	39 f0                	cmp    %esi,%eax
  8015ae:	77 24                	ja     8015d4 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8015b0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015b5:	7f 33                	jg     8015ea <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015b7:	83 ec 04             	sub    $0x4,%esp
  8015ba:	50                   	push   %eax
  8015bb:	68 00 70 80 00       	push   $0x807000
  8015c0:	ff 75 0c             	pushl  0xc(%ebp)
  8015c3:	e8 47 f4 ff ff       	call   800a0f <memmove>
	return r;
  8015c8:	83 c4 10             	add    $0x10,%esp
}
  8015cb:	89 d8                	mov    %ebx,%eax
  8015cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d0:	5b                   	pop    %ebx
  8015d1:	5e                   	pop    %esi
  8015d2:	5d                   	pop    %ebp
  8015d3:	c3                   	ret    
	assert(r <= n);
  8015d4:	68 3c 24 80 00       	push   $0x80243c
  8015d9:	68 43 24 80 00       	push   $0x802443
  8015de:	6a 7c                	push   $0x7c
  8015e0:	68 58 24 80 00       	push   $0x802458
  8015e5:	e8 9d eb ff ff       	call   800187 <_panic>
	assert(r <= PGSIZE);
  8015ea:	68 63 24 80 00       	push   $0x802463
  8015ef:	68 43 24 80 00       	push   $0x802443
  8015f4:	6a 7d                	push   $0x7d
  8015f6:	68 58 24 80 00       	push   $0x802458
  8015fb:	e8 87 eb ff ff       	call   800187 <_panic>

00801600 <open>:
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	56                   	push   %esi
  801604:	53                   	push   %ebx
  801605:	83 ec 1c             	sub    $0x1c,%esp
  801608:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80160b:	56                   	push   %esi
  80160c:	e8 39 f2 ff ff       	call   80084a <strlen>
  801611:	83 c4 10             	add    $0x10,%esp
  801614:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801619:	7f 6c                	jg     801687 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80161b:	83 ec 0c             	sub    $0xc,%esp
  80161e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801621:	50                   	push   %eax
  801622:	e8 6b f8 ff ff       	call   800e92 <fd_alloc>
  801627:	89 c3                	mov    %eax,%ebx
  801629:	83 c4 10             	add    $0x10,%esp
  80162c:	85 c0                	test   %eax,%eax
  80162e:	78 3c                	js     80166c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801630:	83 ec 08             	sub    $0x8,%esp
  801633:	56                   	push   %esi
  801634:	68 00 70 80 00       	push   $0x807000
  801639:	e8 43 f2 ff ff       	call   800881 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80163e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801641:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801649:	b8 01 00 00 00       	mov    $0x1,%eax
  80164e:	e8 aa fd ff ff       	call   8013fd <fsipc>
  801653:	89 c3                	mov    %eax,%ebx
  801655:	83 c4 10             	add    $0x10,%esp
  801658:	85 c0                	test   %eax,%eax
  80165a:	78 19                	js     801675 <open+0x75>
	return fd2num(fd);
  80165c:	83 ec 0c             	sub    $0xc,%esp
  80165f:	ff 75 f4             	pushl  -0xc(%ebp)
  801662:	e8 04 f8 ff ff       	call   800e6b <fd2num>
  801667:	89 c3                	mov    %eax,%ebx
  801669:	83 c4 10             	add    $0x10,%esp
}
  80166c:	89 d8                	mov    %ebx,%eax
  80166e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801671:	5b                   	pop    %ebx
  801672:	5e                   	pop    %esi
  801673:	5d                   	pop    %ebp
  801674:	c3                   	ret    
		fd_close(fd, 0);
  801675:	83 ec 08             	sub    $0x8,%esp
  801678:	6a 00                	push   $0x0
  80167a:	ff 75 f4             	pushl  -0xc(%ebp)
  80167d:	e8 0b f9 ff ff       	call   800f8d <fd_close>
		return r;
  801682:	83 c4 10             	add    $0x10,%esp
  801685:	eb e5                	jmp    80166c <open+0x6c>
		return -E_BAD_PATH;
  801687:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80168c:	eb de                	jmp    80166c <open+0x6c>

0080168e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801694:	ba 00 00 00 00       	mov    $0x0,%edx
  801699:	b8 08 00 00 00       	mov    $0x8,%eax
  80169e:	e8 5a fd ff ff       	call   8013fd <fsipc>
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8016a5:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8016a9:	7e 38                	jle    8016e3 <writebuf+0x3e>
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	53                   	push   %ebx
  8016af:	83 ec 08             	sub    $0x8,%esp
  8016b2:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8016b4:	ff 70 04             	pushl  0x4(%eax)
  8016b7:	8d 40 10             	lea    0x10(%eax),%eax
  8016ba:	50                   	push   %eax
  8016bb:	ff 33                	pushl  (%ebx)
  8016bd:	e8 5e fb ff ff       	call   801220 <write>
		if (result > 0)
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	7e 03                	jle    8016cc <writebuf+0x27>
			b->result += result;
  8016c9:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8016cc:	39 43 04             	cmp    %eax,0x4(%ebx)
  8016cf:	74 0d                	je     8016de <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  8016d1:	85 c0                	test   %eax,%eax
  8016d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d8:	0f 4f c2             	cmovg  %edx,%eax
  8016db:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8016de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    
  8016e3:	f3 c3                	repz ret 

008016e5 <putch>:

static void
putch(int ch, void *thunk)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	53                   	push   %ebx
  8016e9:	83 ec 04             	sub    $0x4,%esp
  8016ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8016ef:	8b 53 04             	mov    0x4(%ebx),%edx
  8016f2:	8d 42 01             	lea    0x1(%edx),%eax
  8016f5:	89 43 04             	mov    %eax,0x4(%ebx)
  8016f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016fb:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8016ff:	3d 00 01 00 00       	cmp    $0x100,%eax
  801704:	74 06                	je     80170c <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801706:	83 c4 04             	add    $0x4,%esp
  801709:	5b                   	pop    %ebx
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    
		writebuf(b);
  80170c:	89 d8                	mov    %ebx,%eax
  80170e:	e8 92 ff ff ff       	call   8016a5 <writebuf>
		b->idx = 0;
  801713:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  80171a:	eb ea                	jmp    801706 <putch+0x21>

0080171c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80172e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801735:	00 00 00 
	b.result = 0;
  801738:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80173f:	00 00 00 
	b.error = 1;
  801742:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801749:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80174c:	ff 75 10             	pushl  0x10(%ebp)
  80174f:	ff 75 0c             	pushl  0xc(%ebp)
  801752:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801758:	50                   	push   %eax
  801759:	68 e5 16 80 00       	push   $0x8016e5
  80175e:	e8 fc eb ff ff       	call   80035f <vprintfmt>
	if (b.idx > 0)
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80176d:	7f 11                	jg     801780 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80176f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801775:	85 c0                	test   %eax,%eax
  801777:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    
		writebuf(&b);
  801780:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801786:	e8 1a ff ff ff       	call   8016a5 <writebuf>
  80178b:	eb e2                	jmp    80176f <vfprintf+0x53>

0080178d <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801793:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801796:	50                   	push   %eax
  801797:	ff 75 0c             	pushl  0xc(%ebp)
  80179a:	ff 75 08             	pushl  0x8(%ebp)
  80179d:	e8 7a ff ff ff       	call   80171c <vfprintf>
	va_end(ap);

	return cnt;
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <printf>:

int
printf(const char *fmt, ...)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8017aa:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8017ad:	50                   	push   %eax
  8017ae:	ff 75 08             	pushl  0x8(%ebp)
  8017b1:	6a 01                	push   $0x1
  8017b3:	e8 64 ff ff ff       	call   80171c <vfprintf>
	va_end(ap);

	return cnt;
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	56                   	push   %esi
  8017be:	53                   	push   %ebx
  8017bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8017c2:	83 ec 0c             	sub    $0xc,%esp
  8017c5:	ff 75 08             	pushl  0x8(%ebp)
  8017c8:	e8 ae f6 ff ff       	call   800e7b <fd2data>
  8017cd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8017cf:	83 c4 08             	add    $0x8,%esp
  8017d2:	68 6f 24 80 00       	push   $0x80246f
  8017d7:	53                   	push   %ebx
  8017d8:	e8 a4 f0 ff ff       	call   800881 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8017dd:	8b 46 04             	mov    0x4(%esi),%eax
  8017e0:	2b 06                	sub    (%esi),%eax
  8017e2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8017e8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017ef:	00 00 00 
	stat->st_dev = &devpipe;
  8017f2:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8017f9:	30 80 00 
	return 0;
}
  8017fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801801:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801804:	5b                   	pop    %ebx
  801805:	5e                   	pop    %esi
  801806:	5d                   	pop    %ebp
  801807:	c3                   	ret    

00801808 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	53                   	push   %ebx
  80180c:	83 ec 0c             	sub    $0xc,%esp
  80180f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801812:	53                   	push   %ebx
  801813:	6a 00                	push   $0x0
  801815:	e8 e5 f4 ff ff       	call   800cff <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80181a:	89 1c 24             	mov    %ebx,(%esp)
  80181d:	e8 59 f6 ff ff       	call   800e7b <fd2data>
  801822:	83 c4 08             	add    $0x8,%esp
  801825:	50                   	push   %eax
  801826:	6a 00                	push   $0x0
  801828:	e8 d2 f4 ff ff       	call   800cff <sys_page_unmap>
}
  80182d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <_pipeisclosed>:
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	57                   	push   %edi
  801836:	56                   	push   %esi
  801837:	53                   	push   %ebx
  801838:	83 ec 1c             	sub    $0x1c,%esp
  80183b:	89 c7                	mov    %eax,%edi
  80183d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80183f:	a1 20 60 80 00       	mov    0x806020,%eax
  801844:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801847:	83 ec 0c             	sub    $0xc,%esp
  80184a:	57                   	push   %edi
  80184b:	e8 2a 05 00 00       	call   801d7a <pageref>
  801850:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801853:	89 34 24             	mov    %esi,(%esp)
  801856:	e8 1f 05 00 00       	call   801d7a <pageref>
		nn = thisenv->env_runs;
  80185b:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801861:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	39 cb                	cmp    %ecx,%ebx
  801869:	74 1b                	je     801886 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80186b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80186e:	75 cf                	jne    80183f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801870:	8b 42 58             	mov    0x58(%edx),%eax
  801873:	6a 01                	push   $0x1
  801875:	50                   	push   %eax
  801876:	53                   	push   %ebx
  801877:	68 76 24 80 00       	push   $0x802476
  80187c:	e8 e1 e9 ff ff       	call   800262 <cprintf>
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	eb b9                	jmp    80183f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801886:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801889:	0f 94 c0             	sete   %al
  80188c:	0f b6 c0             	movzbl %al,%eax
}
  80188f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801892:	5b                   	pop    %ebx
  801893:	5e                   	pop    %esi
  801894:	5f                   	pop    %edi
  801895:	5d                   	pop    %ebp
  801896:	c3                   	ret    

00801897 <devpipe_write>:
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	57                   	push   %edi
  80189b:	56                   	push   %esi
  80189c:	53                   	push   %ebx
  80189d:	83 ec 28             	sub    $0x28,%esp
  8018a0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8018a3:	56                   	push   %esi
  8018a4:	e8 d2 f5 ff ff       	call   800e7b <fd2data>
  8018a9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018ab:	83 c4 10             	add    $0x10,%esp
  8018ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8018b3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018b6:	74 4f                	je     801907 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018b8:	8b 43 04             	mov    0x4(%ebx),%eax
  8018bb:	8b 0b                	mov    (%ebx),%ecx
  8018bd:	8d 51 20             	lea    0x20(%ecx),%edx
  8018c0:	39 d0                	cmp    %edx,%eax
  8018c2:	72 14                	jb     8018d8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8018c4:	89 da                	mov    %ebx,%edx
  8018c6:	89 f0                	mov    %esi,%eax
  8018c8:	e8 65 ff ff ff       	call   801832 <_pipeisclosed>
  8018cd:	85 c0                	test   %eax,%eax
  8018cf:	75 3a                	jne    80190b <devpipe_write+0x74>
			sys_yield();
  8018d1:	e8 85 f3 ff ff       	call   800c5b <sys_yield>
  8018d6:	eb e0                	jmp    8018b8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018db:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8018df:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8018e2:	89 c2                	mov    %eax,%edx
  8018e4:	c1 fa 1f             	sar    $0x1f,%edx
  8018e7:	89 d1                	mov    %edx,%ecx
  8018e9:	c1 e9 1b             	shr    $0x1b,%ecx
  8018ec:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8018ef:	83 e2 1f             	and    $0x1f,%edx
  8018f2:	29 ca                	sub    %ecx,%edx
  8018f4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8018f8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8018fc:	83 c0 01             	add    $0x1,%eax
  8018ff:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801902:	83 c7 01             	add    $0x1,%edi
  801905:	eb ac                	jmp    8018b3 <devpipe_write+0x1c>
	return i;
  801907:	89 f8                	mov    %edi,%eax
  801909:	eb 05                	jmp    801910 <devpipe_write+0x79>
				return 0;
  80190b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801910:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801913:	5b                   	pop    %ebx
  801914:	5e                   	pop    %esi
  801915:	5f                   	pop    %edi
  801916:	5d                   	pop    %ebp
  801917:	c3                   	ret    

00801918 <devpipe_read>:
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	57                   	push   %edi
  80191c:	56                   	push   %esi
  80191d:	53                   	push   %ebx
  80191e:	83 ec 18             	sub    $0x18,%esp
  801921:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801924:	57                   	push   %edi
  801925:	e8 51 f5 ff ff       	call   800e7b <fd2data>
  80192a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	be 00 00 00 00       	mov    $0x0,%esi
  801934:	3b 75 10             	cmp    0x10(%ebp),%esi
  801937:	74 47                	je     801980 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801939:	8b 03                	mov    (%ebx),%eax
  80193b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80193e:	75 22                	jne    801962 <devpipe_read+0x4a>
			if (i > 0)
  801940:	85 f6                	test   %esi,%esi
  801942:	75 14                	jne    801958 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801944:	89 da                	mov    %ebx,%edx
  801946:	89 f8                	mov    %edi,%eax
  801948:	e8 e5 fe ff ff       	call   801832 <_pipeisclosed>
  80194d:	85 c0                	test   %eax,%eax
  80194f:	75 33                	jne    801984 <devpipe_read+0x6c>
			sys_yield();
  801951:	e8 05 f3 ff ff       	call   800c5b <sys_yield>
  801956:	eb e1                	jmp    801939 <devpipe_read+0x21>
				return i;
  801958:	89 f0                	mov    %esi,%eax
}
  80195a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80195d:	5b                   	pop    %ebx
  80195e:	5e                   	pop    %esi
  80195f:	5f                   	pop    %edi
  801960:	5d                   	pop    %ebp
  801961:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801962:	99                   	cltd   
  801963:	c1 ea 1b             	shr    $0x1b,%edx
  801966:	01 d0                	add    %edx,%eax
  801968:	83 e0 1f             	and    $0x1f,%eax
  80196b:	29 d0                	sub    %edx,%eax
  80196d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801972:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801975:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801978:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80197b:	83 c6 01             	add    $0x1,%esi
  80197e:	eb b4                	jmp    801934 <devpipe_read+0x1c>
	return i;
  801980:	89 f0                	mov    %esi,%eax
  801982:	eb d6                	jmp    80195a <devpipe_read+0x42>
				return 0;
  801984:	b8 00 00 00 00       	mov    $0x0,%eax
  801989:	eb cf                	jmp    80195a <devpipe_read+0x42>

0080198b <pipe>:
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	56                   	push   %esi
  80198f:	53                   	push   %ebx
  801990:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801993:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801996:	50                   	push   %eax
  801997:	e8 f6 f4 ff ff       	call   800e92 <fd_alloc>
  80199c:	89 c3                	mov    %eax,%ebx
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	78 5b                	js     801a00 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019a5:	83 ec 04             	sub    $0x4,%esp
  8019a8:	68 07 04 00 00       	push   $0x407
  8019ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b0:	6a 00                	push   $0x0
  8019b2:	e8 c3 f2 ff ff       	call   800c7a <sys_page_alloc>
  8019b7:	89 c3                	mov    %eax,%ebx
  8019b9:	83 c4 10             	add    $0x10,%esp
  8019bc:	85 c0                	test   %eax,%eax
  8019be:	78 40                	js     801a00 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8019c0:	83 ec 0c             	sub    $0xc,%esp
  8019c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019c6:	50                   	push   %eax
  8019c7:	e8 c6 f4 ff ff       	call   800e92 <fd_alloc>
  8019cc:	89 c3                	mov    %eax,%ebx
  8019ce:	83 c4 10             	add    $0x10,%esp
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	78 1b                	js     8019f0 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019d5:	83 ec 04             	sub    $0x4,%esp
  8019d8:	68 07 04 00 00       	push   $0x407
  8019dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8019e0:	6a 00                	push   $0x0
  8019e2:	e8 93 f2 ff ff       	call   800c7a <sys_page_alloc>
  8019e7:	89 c3                	mov    %eax,%ebx
  8019e9:	83 c4 10             	add    $0x10,%esp
  8019ec:	85 c0                	test   %eax,%eax
  8019ee:	79 19                	jns    801a09 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8019f0:	83 ec 08             	sub    $0x8,%esp
  8019f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8019f6:	6a 00                	push   $0x0
  8019f8:	e8 02 f3 ff ff       	call   800cff <sys_page_unmap>
  8019fd:	83 c4 10             	add    $0x10,%esp
}
  801a00:	89 d8                	mov    %ebx,%eax
  801a02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a05:	5b                   	pop    %ebx
  801a06:	5e                   	pop    %esi
  801a07:	5d                   	pop    %ebp
  801a08:	c3                   	ret    
	va = fd2data(fd0);
  801a09:	83 ec 0c             	sub    $0xc,%esp
  801a0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a0f:	e8 67 f4 ff ff       	call   800e7b <fd2data>
  801a14:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a16:	83 c4 0c             	add    $0xc,%esp
  801a19:	68 07 04 00 00       	push   $0x407
  801a1e:	50                   	push   %eax
  801a1f:	6a 00                	push   $0x0
  801a21:	e8 54 f2 ff ff       	call   800c7a <sys_page_alloc>
  801a26:	89 c3                	mov    %eax,%ebx
  801a28:	83 c4 10             	add    $0x10,%esp
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	0f 88 8c 00 00 00    	js     801abf <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a33:	83 ec 0c             	sub    $0xc,%esp
  801a36:	ff 75 f0             	pushl  -0x10(%ebp)
  801a39:	e8 3d f4 ff ff       	call   800e7b <fd2data>
  801a3e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a45:	50                   	push   %eax
  801a46:	6a 00                	push   $0x0
  801a48:	56                   	push   %esi
  801a49:	6a 00                	push   $0x0
  801a4b:	e8 6d f2 ff ff       	call   800cbd <sys_page_map>
  801a50:	89 c3                	mov    %eax,%ebx
  801a52:	83 c4 20             	add    $0x20,%esp
  801a55:	85 c0                	test   %eax,%eax
  801a57:	78 58                	js     801ab1 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a62:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a67:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a71:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a77:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a83:	83 ec 0c             	sub    $0xc,%esp
  801a86:	ff 75 f4             	pushl  -0xc(%ebp)
  801a89:	e8 dd f3 ff ff       	call   800e6b <fd2num>
  801a8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a91:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a93:	83 c4 04             	add    $0x4,%esp
  801a96:	ff 75 f0             	pushl  -0x10(%ebp)
  801a99:	e8 cd f3 ff ff       	call   800e6b <fd2num>
  801a9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aa1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aac:	e9 4f ff ff ff       	jmp    801a00 <pipe+0x75>
	sys_page_unmap(0, va);
  801ab1:	83 ec 08             	sub    $0x8,%esp
  801ab4:	56                   	push   %esi
  801ab5:	6a 00                	push   $0x0
  801ab7:	e8 43 f2 ff ff       	call   800cff <sys_page_unmap>
  801abc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801abf:	83 ec 08             	sub    $0x8,%esp
  801ac2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ac5:	6a 00                	push   $0x0
  801ac7:	e8 33 f2 ff ff       	call   800cff <sys_page_unmap>
  801acc:	83 c4 10             	add    $0x10,%esp
  801acf:	e9 1c ff ff ff       	jmp    8019f0 <pipe+0x65>

00801ad4 <pipeisclosed>:
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ada:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801add:	50                   	push   %eax
  801ade:	ff 75 08             	pushl  0x8(%ebp)
  801ae1:	e8 fb f3 ff ff       	call   800ee1 <fd_lookup>
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	85 c0                	test   %eax,%eax
  801aeb:	78 18                	js     801b05 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801aed:	83 ec 0c             	sub    $0xc,%esp
  801af0:	ff 75 f4             	pushl  -0xc(%ebp)
  801af3:	e8 83 f3 ff ff       	call   800e7b <fd2data>
	return _pipeisclosed(fd, p);
  801af8:	89 c2                	mov    %eax,%edx
  801afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afd:	e8 30 fd ff ff       	call   801832 <_pipeisclosed>
  801b02:	83 c4 10             	add    $0x10,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0f:	5d                   	pop    %ebp
  801b10:	c3                   	ret    

00801b11 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801b17:	68 8e 24 80 00       	push   $0x80248e
  801b1c:	ff 75 0c             	pushl  0xc(%ebp)
  801b1f:	e8 5d ed ff ff       	call   800881 <strcpy>
	return 0;
}
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <devcons_write>:
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	57                   	push   %edi
  801b2f:	56                   	push   %esi
  801b30:	53                   	push   %ebx
  801b31:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b37:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b3c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801b42:	eb 2f                	jmp    801b73 <devcons_write+0x48>
		m = n - tot;
  801b44:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b47:	29 f3                	sub    %esi,%ebx
  801b49:	83 fb 7f             	cmp    $0x7f,%ebx
  801b4c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801b51:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801b54:	83 ec 04             	sub    $0x4,%esp
  801b57:	53                   	push   %ebx
  801b58:	89 f0                	mov    %esi,%eax
  801b5a:	03 45 0c             	add    0xc(%ebp),%eax
  801b5d:	50                   	push   %eax
  801b5e:	57                   	push   %edi
  801b5f:	e8 ab ee ff ff       	call   800a0f <memmove>
		sys_cputs(buf, m);
  801b64:	83 c4 08             	add    $0x8,%esp
  801b67:	53                   	push   %ebx
  801b68:	57                   	push   %edi
  801b69:	e8 50 f0 ff ff       	call   800bbe <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801b6e:	01 de                	add    %ebx,%esi
  801b70:	83 c4 10             	add    $0x10,%esp
  801b73:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b76:	72 cc                	jb     801b44 <devcons_write+0x19>
}
  801b78:	89 f0                	mov    %esi,%eax
  801b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b7d:	5b                   	pop    %ebx
  801b7e:	5e                   	pop    %esi
  801b7f:	5f                   	pop    %edi
  801b80:	5d                   	pop    %ebp
  801b81:	c3                   	ret    

00801b82 <devcons_read>:
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	83 ec 08             	sub    $0x8,%esp
  801b88:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801b8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b91:	75 07                	jne    801b9a <devcons_read+0x18>
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    
		sys_yield();
  801b95:	e8 c1 f0 ff ff       	call   800c5b <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801b9a:	e8 3d f0 ff ff       	call   800bdc <sys_cgetc>
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	74 f2                	je     801b95 <devcons_read+0x13>
	if (c < 0)
  801ba3:	85 c0                	test   %eax,%eax
  801ba5:	78 ec                	js     801b93 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801ba7:	83 f8 04             	cmp    $0x4,%eax
  801baa:	74 0c                	je     801bb8 <devcons_read+0x36>
	*(char*)vbuf = c;
  801bac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801baf:	88 02                	mov    %al,(%edx)
	return 1;
  801bb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb6:	eb db                	jmp    801b93 <devcons_read+0x11>
		return 0;
  801bb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbd:	eb d4                	jmp    801b93 <devcons_read+0x11>

00801bbf <cputchar>:
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801bcb:	6a 01                	push   $0x1
  801bcd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bd0:	50                   	push   %eax
  801bd1:	e8 e8 ef ff ff       	call   800bbe <sys_cputs>
}
  801bd6:	83 c4 10             	add    $0x10,%esp
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <getchar>:
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801be1:	6a 01                	push   $0x1
  801be3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801be6:	50                   	push   %eax
  801be7:	6a 00                	push   $0x0
  801be9:	e8 64 f5 ff ff       	call   801152 <read>
	if (r < 0)
  801bee:	83 c4 10             	add    $0x10,%esp
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	78 08                	js     801bfd <getchar+0x22>
	if (r < 1)
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	7e 06                	jle    801bff <getchar+0x24>
	return c;
  801bf9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    
		return -E_EOF;
  801bff:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801c04:	eb f7                	jmp    801bfd <getchar+0x22>

00801c06 <iscons>:
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c0f:	50                   	push   %eax
  801c10:	ff 75 08             	pushl  0x8(%ebp)
  801c13:	e8 c9 f2 ff ff       	call   800ee1 <fd_lookup>
  801c18:	83 c4 10             	add    $0x10,%esp
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	78 11                	js     801c30 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c22:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c28:	39 10                	cmp    %edx,(%eax)
  801c2a:	0f 94 c0             	sete   %al
  801c2d:	0f b6 c0             	movzbl %al,%eax
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <opencons>:
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c3b:	50                   	push   %eax
  801c3c:	e8 51 f2 ff ff       	call   800e92 <fd_alloc>
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	85 c0                	test   %eax,%eax
  801c46:	78 3a                	js     801c82 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c48:	83 ec 04             	sub    $0x4,%esp
  801c4b:	68 07 04 00 00       	push   $0x407
  801c50:	ff 75 f4             	pushl  -0xc(%ebp)
  801c53:	6a 00                	push   $0x0
  801c55:	e8 20 f0 ff ff       	call   800c7a <sys_page_alloc>
  801c5a:	83 c4 10             	add    $0x10,%esp
  801c5d:	85 c0                	test   %eax,%eax
  801c5f:	78 21                	js     801c82 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c64:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c6a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c76:	83 ec 0c             	sub    $0xc,%esp
  801c79:	50                   	push   %eax
  801c7a:	e8 ec f1 ff ff       	call   800e6b <fd2num>
  801c7f:	83 c4 10             	add    $0x10,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	56                   	push   %esi
  801c88:	53                   	push   %ebx
  801c89:	8b 75 08             	mov    0x8(%ebp),%esi
  801c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801c92:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  801c94:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801c99:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  801c9c:	83 ec 0c             	sub    $0xc,%esp
  801c9f:	50                   	push   %eax
  801ca0:	e8 85 f1 ff ff       	call   800e2a <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  801ca5:	83 c4 10             	add    $0x10,%esp
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	78 2b                	js     801cd7 <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  801cac:	85 f6                	test   %esi,%esi
  801cae:	74 0a                	je     801cba <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801cb0:	a1 20 60 80 00       	mov    0x806020,%eax
  801cb5:	8b 40 74             	mov    0x74(%eax),%eax
  801cb8:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  801cba:	85 db                	test   %ebx,%ebx
  801cbc:	74 0a                	je     801cc8 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801cbe:	a1 20 60 80 00       	mov    0x806020,%eax
  801cc3:	8b 40 78             	mov    0x78(%eax),%eax
  801cc6:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801cc8:	a1 20 60 80 00       	mov    0x806020,%eax
  801ccd:	8b 40 70             	mov    0x70(%eax),%eax
}
  801cd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd3:	5b                   	pop    %ebx
  801cd4:	5e                   	pop    %esi
  801cd5:	5d                   	pop    %ebp
  801cd6:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  801cd7:	85 f6                	test   %esi,%esi
  801cd9:	74 06                	je     801ce1 <ipc_recv+0x5d>
  801cdb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801ce1:	85 db                	test   %ebx,%ebx
  801ce3:	74 eb                	je     801cd0 <ipc_recv+0x4c>
  801ce5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ceb:	eb e3                	jmp    801cd0 <ipc_recv+0x4c>

00801ced <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	57                   	push   %edi
  801cf1:	56                   	push   %esi
  801cf2:	53                   	push   %ebx
  801cf3:	83 ec 0c             	sub    $0xc,%esp
  801cf6:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cf9:	8b 75 0c             	mov    0xc(%ebp),%esi
  801cfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801cff:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  801d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801d06:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801d09:	ff 75 14             	pushl  0x14(%ebp)
  801d0c:	53                   	push   %ebx
  801d0d:	56                   	push   %esi
  801d0e:	57                   	push   %edi
  801d0f:	e8 f3 f0 ff ff       	call   800e07 <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	85 c0                	test   %eax,%eax
  801d19:	74 1e                	je     801d39 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  801d1b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d1e:	75 07                	jne    801d27 <ipc_send+0x3a>
			sys_yield();
  801d20:	e8 36 ef ff ff       	call   800c5b <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801d25:	eb e2                	jmp    801d09 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  801d27:	50                   	push   %eax
  801d28:	68 9a 24 80 00       	push   $0x80249a
  801d2d:	6a 41                	push   $0x41
  801d2f:	68 a8 24 80 00       	push   $0x8024a8
  801d34:	e8 4e e4 ff ff       	call   800187 <_panic>
		}
	}
}
  801d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d3c:	5b                   	pop    %ebx
  801d3d:	5e                   	pop    %esi
  801d3e:	5f                   	pop    %edi
  801d3f:	5d                   	pop    %ebp
  801d40:	c3                   	ret    

00801d41 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d47:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801d4c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801d4f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801d55:	8b 52 50             	mov    0x50(%edx),%edx
  801d58:	39 ca                	cmp    %ecx,%edx
  801d5a:	74 11                	je     801d6d <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801d5c:	83 c0 01             	add    $0x1,%eax
  801d5f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801d64:	75 e6                	jne    801d4c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801d66:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6b:	eb 0b                	jmp    801d78 <ipc_find_env+0x37>
			return envs[i].env_id;
  801d6d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801d70:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d75:	8b 40 48             	mov    0x48(%eax),%eax
}
  801d78:	5d                   	pop    %ebp
  801d79:	c3                   	ret    

00801d7a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d80:	89 d0                	mov    %edx,%eax
  801d82:	c1 e8 16             	shr    $0x16,%eax
  801d85:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801d8c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801d91:	f6 c1 01             	test   $0x1,%cl
  801d94:	74 1d                	je     801db3 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801d96:	c1 ea 0c             	shr    $0xc,%edx
  801d99:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801da0:	f6 c2 01             	test   $0x1,%dl
  801da3:	74 0e                	je     801db3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801da5:	c1 ea 0c             	shr    $0xc,%edx
  801da8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801daf:	ef 
  801db0:	0f b7 c0             	movzwl %ax,%eax
}
  801db3:	5d                   	pop    %ebp
  801db4:	c3                   	ret    
  801db5:	66 90                	xchg   %ax,%ax
  801db7:	66 90                	xchg   %ax,%ax
  801db9:	66 90                	xchg   %ax,%ax
  801dbb:	66 90                	xchg   %ax,%ax
  801dbd:	66 90                	xchg   %ax,%ax
  801dbf:	90                   	nop

00801dc0 <__udivdi3>:
  801dc0:	55                   	push   %ebp
  801dc1:	57                   	push   %edi
  801dc2:	56                   	push   %esi
  801dc3:	53                   	push   %ebx
  801dc4:	83 ec 1c             	sub    $0x1c,%esp
  801dc7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801dcb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801dcf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dd3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801dd7:	85 d2                	test   %edx,%edx
  801dd9:	75 35                	jne    801e10 <__udivdi3+0x50>
  801ddb:	39 f3                	cmp    %esi,%ebx
  801ddd:	0f 87 bd 00 00 00    	ja     801ea0 <__udivdi3+0xe0>
  801de3:	85 db                	test   %ebx,%ebx
  801de5:	89 d9                	mov    %ebx,%ecx
  801de7:	75 0b                	jne    801df4 <__udivdi3+0x34>
  801de9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dee:	31 d2                	xor    %edx,%edx
  801df0:	f7 f3                	div    %ebx
  801df2:	89 c1                	mov    %eax,%ecx
  801df4:	31 d2                	xor    %edx,%edx
  801df6:	89 f0                	mov    %esi,%eax
  801df8:	f7 f1                	div    %ecx
  801dfa:	89 c6                	mov    %eax,%esi
  801dfc:	89 e8                	mov    %ebp,%eax
  801dfe:	89 f7                	mov    %esi,%edi
  801e00:	f7 f1                	div    %ecx
  801e02:	89 fa                	mov    %edi,%edx
  801e04:	83 c4 1c             	add    $0x1c,%esp
  801e07:	5b                   	pop    %ebx
  801e08:	5e                   	pop    %esi
  801e09:	5f                   	pop    %edi
  801e0a:	5d                   	pop    %ebp
  801e0b:	c3                   	ret    
  801e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e10:	39 f2                	cmp    %esi,%edx
  801e12:	77 7c                	ja     801e90 <__udivdi3+0xd0>
  801e14:	0f bd fa             	bsr    %edx,%edi
  801e17:	83 f7 1f             	xor    $0x1f,%edi
  801e1a:	0f 84 98 00 00 00    	je     801eb8 <__udivdi3+0xf8>
  801e20:	89 f9                	mov    %edi,%ecx
  801e22:	b8 20 00 00 00       	mov    $0x20,%eax
  801e27:	29 f8                	sub    %edi,%eax
  801e29:	d3 e2                	shl    %cl,%edx
  801e2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e2f:	89 c1                	mov    %eax,%ecx
  801e31:	89 da                	mov    %ebx,%edx
  801e33:	d3 ea                	shr    %cl,%edx
  801e35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e39:	09 d1                	or     %edx,%ecx
  801e3b:	89 f2                	mov    %esi,%edx
  801e3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e41:	89 f9                	mov    %edi,%ecx
  801e43:	d3 e3                	shl    %cl,%ebx
  801e45:	89 c1                	mov    %eax,%ecx
  801e47:	d3 ea                	shr    %cl,%edx
  801e49:	89 f9                	mov    %edi,%ecx
  801e4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e4f:	d3 e6                	shl    %cl,%esi
  801e51:	89 eb                	mov    %ebp,%ebx
  801e53:	89 c1                	mov    %eax,%ecx
  801e55:	d3 eb                	shr    %cl,%ebx
  801e57:	09 de                	or     %ebx,%esi
  801e59:	89 f0                	mov    %esi,%eax
  801e5b:	f7 74 24 08          	divl   0x8(%esp)
  801e5f:	89 d6                	mov    %edx,%esi
  801e61:	89 c3                	mov    %eax,%ebx
  801e63:	f7 64 24 0c          	mull   0xc(%esp)
  801e67:	39 d6                	cmp    %edx,%esi
  801e69:	72 0c                	jb     801e77 <__udivdi3+0xb7>
  801e6b:	89 f9                	mov    %edi,%ecx
  801e6d:	d3 e5                	shl    %cl,%ebp
  801e6f:	39 c5                	cmp    %eax,%ebp
  801e71:	73 5d                	jae    801ed0 <__udivdi3+0x110>
  801e73:	39 d6                	cmp    %edx,%esi
  801e75:	75 59                	jne    801ed0 <__udivdi3+0x110>
  801e77:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e7a:	31 ff                	xor    %edi,%edi
  801e7c:	89 fa                	mov    %edi,%edx
  801e7e:	83 c4 1c             	add    $0x1c,%esp
  801e81:	5b                   	pop    %ebx
  801e82:	5e                   	pop    %esi
  801e83:	5f                   	pop    %edi
  801e84:	5d                   	pop    %ebp
  801e85:	c3                   	ret    
  801e86:	8d 76 00             	lea    0x0(%esi),%esi
  801e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801e90:	31 ff                	xor    %edi,%edi
  801e92:	31 c0                	xor    %eax,%eax
  801e94:	89 fa                	mov    %edi,%edx
  801e96:	83 c4 1c             	add    $0x1c,%esp
  801e99:	5b                   	pop    %ebx
  801e9a:	5e                   	pop    %esi
  801e9b:	5f                   	pop    %edi
  801e9c:	5d                   	pop    %ebp
  801e9d:	c3                   	ret    
  801e9e:	66 90                	xchg   %ax,%ax
  801ea0:	31 ff                	xor    %edi,%edi
  801ea2:	89 e8                	mov    %ebp,%eax
  801ea4:	89 f2                	mov    %esi,%edx
  801ea6:	f7 f3                	div    %ebx
  801ea8:	89 fa                	mov    %edi,%edx
  801eaa:	83 c4 1c             	add    $0x1c,%esp
  801ead:	5b                   	pop    %ebx
  801eae:	5e                   	pop    %esi
  801eaf:	5f                   	pop    %edi
  801eb0:	5d                   	pop    %ebp
  801eb1:	c3                   	ret    
  801eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801eb8:	39 f2                	cmp    %esi,%edx
  801eba:	72 06                	jb     801ec2 <__udivdi3+0x102>
  801ebc:	31 c0                	xor    %eax,%eax
  801ebe:	39 eb                	cmp    %ebp,%ebx
  801ec0:	77 d2                	ja     801e94 <__udivdi3+0xd4>
  801ec2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec7:	eb cb                	jmp    801e94 <__udivdi3+0xd4>
  801ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ed0:	89 d8                	mov    %ebx,%eax
  801ed2:	31 ff                	xor    %edi,%edi
  801ed4:	eb be                	jmp    801e94 <__udivdi3+0xd4>
  801ed6:	66 90                	xchg   %ax,%ax
  801ed8:	66 90                	xchg   %ax,%ax
  801eda:	66 90                	xchg   %ax,%ax
  801edc:	66 90                	xchg   %ax,%ax
  801ede:	66 90                	xchg   %ax,%ax

00801ee0 <__umoddi3>:
  801ee0:	55                   	push   %ebp
  801ee1:	57                   	push   %edi
  801ee2:	56                   	push   %esi
  801ee3:	53                   	push   %ebx
  801ee4:	83 ec 1c             	sub    $0x1c,%esp
  801ee7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801eeb:	8b 74 24 30          	mov    0x30(%esp),%esi
  801eef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801ef3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ef7:	85 ed                	test   %ebp,%ebp
  801ef9:	89 f0                	mov    %esi,%eax
  801efb:	89 da                	mov    %ebx,%edx
  801efd:	75 19                	jne    801f18 <__umoddi3+0x38>
  801eff:	39 df                	cmp    %ebx,%edi
  801f01:	0f 86 b1 00 00 00    	jbe    801fb8 <__umoddi3+0xd8>
  801f07:	f7 f7                	div    %edi
  801f09:	89 d0                	mov    %edx,%eax
  801f0b:	31 d2                	xor    %edx,%edx
  801f0d:	83 c4 1c             	add    $0x1c,%esp
  801f10:	5b                   	pop    %ebx
  801f11:	5e                   	pop    %esi
  801f12:	5f                   	pop    %edi
  801f13:	5d                   	pop    %ebp
  801f14:	c3                   	ret    
  801f15:	8d 76 00             	lea    0x0(%esi),%esi
  801f18:	39 dd                	cmp    %ebx,%ebp
  801f1a:	77 f1                	ja     801f0d <__umoddi3+0x2d>
  801f1c:	0f bd cd             	bsr    %ebp,%ecx
  801f1f:	83 f1 1f             	xor    $0x1f,%ecx
  801f22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f26:	0f 84 b4 00 00 00    	je     801fe0 <__umoddi3+0x100>
  801f2c:	b8 20 00 00 00       	mov    $0x20,%eax
  801f31:	89 c2                	mov    %eax,%edx
  801f33:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f37:	29 c2                	sub    %eax,%edx
  801f39:	89 c1                	mov    %eax,%ecx
  801f3b:	89 f8                	mov    %edi,%eax
  801f3d:	d3 e5                	shl    %cl,%ebp
  801f3f:	89 d1                	mov    %edx,%ecx
  801f41:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801f45:	d3 e8                	shr    %cl,%eax
  801f47:	09 c5                	or     %eax,%ebp
  801f49:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f4d:	89 c1                	mov    %eax,%ecx
  801f4f:	d3 e7                	shl    %cl,%edi
  801f51:	89 d1                	mov    %edx,%ecx
  801f53:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f57:	89 df                	mov    %ebx,%edi
  801f59:	d3 ef                	shr    %cl,%edi
  801f5b:	89 c1                	mov    %eax,%ecx
  801f5d:	89 f0                	mov    %esi,%eax
  801f5f:	d3 e3                	shl    %cl,%ebx
  801f61:	89 d1                	mov    %edx,%ecx
  801f63:	89 fa                	mov    %edi,%edx
  801f65:	d3 e8                	shr    %cl,%eax
  801f67:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801f6c:	09 d8                	or     %ebx,%eax
  801f6e:	f7 f5                	div    %ebp
  801f70:	d3 e6                	shl    %cl,%esi
  801f72:	89 d1                	mov    %edx,%ecx
  801f74:	f7 64 24 08          	mull   0x8(%esp)
  801f78:	39 d1                	cmp    %edx,%ecx
  801f7a:	89 c3                	mov    %eax,%ebx
  801f7c:	89 d7                	mov    %edx,%edi
  801f7e:	72 06                	jb     801f86 <__umoddi3+0xa6>
  801f80:	75 0e                	jne    801f90 <__umoddi3+0xb0>
  801f82:	39 c6                	cmp    %eax,%esi
  801f84:	73 0a                	jae    801f90 <__umoddi3+0xb0>
  801f86:	2b 44 24 08          	sub    0x8(%esp),%eax
  801f8a:	19 ea                	sbb    %ebp,%edx
  801f8c:	89 d7                	mov    %edx,%edi
  801f8e:	89 c3                	mov    %eax,%ebx
  801f90:	89 ca                	mov    %ecx,%edx
  801f92:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801f97:	29 de                	sub    %ebx,%esi
  801f99:	19 fa                	sbb    %edi,%edx
  801f9b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801f9f:	89 d0                	mov    %edx,%eax
  801fa1:	d3 e0                	shl    %cl,%eax
  801fa3:	89 d9                	mov    %ebx,%ecx
  801fa5:	d3 ee                	shr    %cl,%esi
  801fa7:	d3 ea                	shr    %cl,%edx
  801fa9:	09 f0                	or     %esi,%eax
  801fab:	83 c4 1c             	add    $0x1c,%esp
  801fae:	5b                   	pop    %ebx
  801faf:	5e                   	pop    %esi
  801fb0:	5f                   	pop    %edi
  801fb1:	5d                   	pop    %ebp
  801fb2:	c3                   	ret    
  801fb3:	90                   	nop
  801fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801fb8:	85 ff                	test   %edi,%edi
  801fba:	89 f9                	mov    %edi,%ecx
  801fbc:	75 0b                	jne    801fc9 <__umoddi3+0xe9>
  801fbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc3:	31 d2                	xor    %edx,%edx
  801fc5:	f7 f7                	div    %edi
  801fc7:	89 c1                	mov    %eax,%ecx
  801fc9:	89 d8                	mov    %ebx,%eax
  801fcb:	31 d2                	xor    %edx,%edx
  801fcd:	f7 f1                	div    %ecx
  801fcf:	89 f0                	mov    %esi,%eax
  801fd1:	f7 f1                	div    %ecx
  801fd3:	e9 31 ff ff ff       	jmp    801f09 <__umoddi3+0x29>
  801fd8:	90                   	nop
  801fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fe0:	39 dd                	cmp    %ebx,%ebp
  801fe2:	72 08                	jb     801fec <__umoddi3+0x10c>
  801fe4:	39 f7                	cmp    %esi,%edi
  801fe6:	0f 87 21 ff ff ff    	ja     801f0d <__umoddi3+0x2d>
  801fec:	89 da                	mov    %ebx,%edx
  801fee:	89 f0                	mov    %esi,%eax
  801ff0:	29 f8                	sub    %edi,%eax
  801ff2:	19 ea                	sbb    %ebp,%edx
  801ff4:	e9 14 ff ff ff       	jmp    801f0d <__umoddi3+0x2d>
