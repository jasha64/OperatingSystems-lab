
obj/user/num.debug：     文件格式 elf32-i386


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
  80002c:	e8 52 01 00 00       	call   800183 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	eb 1b                	jmp    80005e <num+0x2b>
		if (bol) {
			printf("%5d ", ++line);
			bol = 0;
		}
		if ((r = write(1, &c, 1)) != 1)
  800043:	83 ec 04             	sub    $0x4,%esp
  800046:	6a 01                	push   $0x1
  800048:	53                   	push   %ebx
  800049:	6a 01                	push   $0x1
  80004b:	e8 24 12 00 00       	call   801274 <write>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	83 f8 01             	cmp    $0x1,%eax
  800056:	75 4c                	jne    8000a4 <num+0x71>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800058:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  80005c:	74 5e                	je     8000bc <num+0x89>
	while ((n = read(f, &c, 1)) > 0) {
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	6a 01                	push   $0x1
  800063:	53                   	push   %ebx
  800064:	56                   	push   %esi
  800065:	e8 3c 11 00 00       	call   8011a6 <read>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	85 c0                	test   %eax,%eax
  80006f:	7e 57                	jle    8000c8 <num+0x95>
		if (bol) {
  800071:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  800078:	74 c9                	je     800043 <num+0x10>
			printf("%5d ", ++line);
  80007a:	a1 00 40 80 00       	mov    0x804000,%eax
  80007f:	83 c0 01             	add    $0x1,%eax
  800082:	a3 00 40 80 00       	mov    %eax,0x804000
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	50                   	push   %eax
  80008b:	68 60 20 80 00       	push   $0x802060
  800090:	e8 63 17 00 00       	call   8017f8 <printf>
			bol = 0;
  800095:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  80009c:	00 00 00 
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	eb 9f                	jmp    800043 <num+0x10>
			panic("write error copying %s: %e", s, r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	50                   	push   %eax
  8000a8:	ff 75 0c             	pushl  0xc(%ebp)
  8000ab:	68 65 20 80 00       	push   $0x802065
  8000b0:	6a 13                	push   $0x13
  8000b2:	68 80 20 80 00       	push   $0x802080
  8000b7:	e8 1f 01 00 00       	call   8001db <_panic>
			bol = 1;
  8000bc:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c3:	00 00 00 
  8000c6:	eb 96                	jmp    80005e <num+0x2b>
	}
	if (n < 0)
  8000c8:	85 c0                	test   %eax,%eax
  8000ca:	78 07                	js     8000d3 <num+0xa0>
		panic("error reading %s: %e", s, n);
}
  8000cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cf:	5b                   	pop    %ebx
  8000d0:	5e                   	pop    %esi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	50                   	push   %eax
  8000d7:	ff 75 0c             	pushl  0xc(%ebp)
  8000da:	68 8b 20 80 00       	push   $0x80208b
  8000df:	6a 18                	push   $0x18
  8000e1:	68 80 20 80 00       	push   $0x802080
  8000e6:	e8 f0 00 00 00       	call   8001db <_panic>

008000eb <umain>:

void
umain(int argc, char **argv)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000f4:	c7 05 04 30 80 00 a0 	movl   $0x8020a0,0x803004
  8000fb:	20 80 00 
	if (argc == 1)
  8000fe:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800102:	74 46                	je     80014a <umain+0x5f>
  800104:	8b 45 0c             	mov    0xc(%ebp),%eax
  800107:	8d 58 04             	lea    0x4(%eax),%ebx
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  80010a:	bf 01 00 00 00       	mov    $0x1,%edi
  80010f:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800112:	7d 48                	jge    80015c <umain+0x71>
			f = open(argv[i], O_RDONLY);
  800114:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	6a 00                	push   $0x0
  80011c:	ff 33                	pushl  (%ebx)
  80011e:	e8 31 15 00 00       	call   801654 <open>
  800123:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	85 c0                	test   %eax,%eax
  80012a:	78 3d                	js     800169 <umain+0x7e>
				panic("can't open %s: %e", argv[i], f);
			else {
				num(f, argv[i]);
  80012c:	83 ec 08             	sub    $0x8,%esp
  80012f:	ff 33                	pushl  (%ebx)
  800131:	50                   	push   %eax
  800132:	e8 fc fe ff ff       	call   800033 <num>
				close(f);
  800137:	89 34 24             	mov    %esi,(%esp)
  80013a:	e8 2b 0f 00 00       	call   80106a <close>
		for (i = 1; i < argc; i++) {
  80013f:	83 c7 01             	add    $0x1,%edi
  800142:	83 c3 04             	add    $0x4,%ebx
  800145:	83 c4 10             	add    $0x10,%esp
  800148:	eb c5                	jmp    80010f <umain+0x24>
		num(0, "<stdin>");
  80014a:	83 ec 08             	sub    $0x8,%esp
  80014d:	68 a4 20 80 00       	push   $0x8020a4
  800152:	6a 00                	push   $0x0
  800154:	e8 da fe ff ff       	call   800033 <num>
  800159:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  80015c:	e8 68 00 00 00       	call   8001c9 <exit>
}
  800161:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800164:	5b                   	pop    %ebx
  800165:	5e                   	pop    %esi
  800166:	5f                   	pop    %edi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    
				panic("can't open %s: %e", argv[i], f);
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	50                   	push   %eax
  80016d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800170:	ff 30                	pushl  (%eax)
  800172:	68 ac 20 80 00       	push   $0x8020ac
  800177:	6a 27                	push   $0x27
  800179:	68 80 20 80 00       	push   $0x802080
  80017e:	e8 58 00 00 00       	call   8001db <_panic>

00800183 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800183:	55                   	push   %ebp
  800184:	89 e5                	mov    %esp,%ebp
  800186:	56                   	push   %esi
  800187:	53                   	push   %ebx
  800188:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80018b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  80018e:	e8 fd 0a 00 00       	call   800c90 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  800193:	25 ff 03 00 00       	and    $0x3ff,%eax
  800198:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80019b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a0:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a5:	85 db                	test   %ebx,%ebx
  8001a7:	7e 07                	jle    8001b0 <libmain+0x2d>
		binaryname = argv[0];
  8001a9:	8b 06                	mov    (%esi),%eax
  8001ab:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	56                   	push   %esi
  8001b4:	53                   	push   %ebx
  8001b5:	e8 31 ff ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8001ba:	e8 0a 00 00 00       	call   8001c9 <exit>
}
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001c5:	5b                   	pop    %ebx
  8001c6:	5e                   	pop    %esi
  8001c7:	5d                   	pop    %ebp
  8001c8:	c3                   	ret    

008001c9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8001cf:	6a 00                	push   $0x0
  8001d1:	e8 79 0a 00 00       	call   800c4f <sys_env_destroy>
}
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	c9                   	leave  
  8001da:	c3                   	ret    

008001db <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	56                   	push   %esi
  8001df:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001e0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001e3:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8001e9:	e8 a2 0a 00 00       	call   800c90 <sys_getenvid>
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	ff 75 0c             	pushl  0xc(%ebp)
  8001f4:	ff 75 08             	pushl  0x8(%ebp)
  8001f7:	56                   	push   %esi
  8001f8:	50                   	push   %eax
  8001f9:	68 c8 20 80 00       	push   $0x8020c8
  8001fe:	e8 b3 00 00 00       	call   8002b6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800203:	83 c4 18             	add    $0x18,%esp
  800206:	53                   	push   %ebx
  800207:	ff 75 10             	pushl  0x10(%ebp)
  80020a:	e8 56 00 00 00       	call   800265 <vcprintf>
	cprintf("\n");
  80020f:	c7 04 24 e7 24 80 00 	movl   $0x8024e7,(%esp)
  800216:	e8 9b 00 00 00       	call   8002b6 <cprintf>
  80021b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80021e:	cc                   	int3   
  80021f:	eb fd                	jmp    80021e <_panic+0x43>

00800221 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	53                   	push   %ebx
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80022b:	8b 13                	mov    (%ebx),%edx
  80022d:	8d 42 01             	lea    0x1(%edx),%eax
  800230:	89 03                	mov    %eax,(%ebx)
  800232:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800235:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800239:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023e:	74 09                	je     800249 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800240:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800244:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800247:	c9                   	leave  
  800248:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	68 ff 00 00 00       	push   $0xff
  800251:	8d 43 08             	lea    0x8(%ebx),%eax
  800254:	50                   	push   %eax
  800255:	e8 b8 09 00 00       	call   800c12 <sys_cputs>
		b->idx = 0;
  80025a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800260:	83 c4 10             	add    $0x10,%esp
  800263:	eb db                	jmp    800240 <putch+0x1f>

00800265 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80026e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800275:	00 00 00 
	b.cnt = 0;
  800278:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80027f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800282:	ff 75 0c             	pushl  0xc(%ebp)
  800285:	ff 75 08             	pushl  0x8(%ebp)
  800288:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028e:	50                   	push   %eax
  80028f:	68 21 02 80 00       	push   $0x800221
  800294:	e8 1a 01 00 00       	call   8003b3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800299:	83 c4 08             	add    $0x8,%esp
  80029c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002a2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002a8:	50                   	push   %eax
  8002a9:	e8 64 09 00 00       	call   800c12 <sys_cputs>

	return b.cnt;
}
  8002ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    

008002b6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002bc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002bf:	50                   	push   %eax
  8002c0:	ff 75 08             	pushl  0x8(%ebp)
  8002c3:	e8 9d ff ff ff       	call   800265 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c8:	c9                   	leave  
  8002c9:	c3                   	ret    

008002ca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	57                   	push   %edi
  8002ce:	56                   	push   %esi
  8002cf:	53                   	push   %ebx
  8002d0:	83 ec 1c             	sub    $0x1c,%esp
  8002d3:	89 c7                	mov    %eax,%edi
  8002d5:	89 d6                	mov    %edx,%esi
  8002d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002eb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002ee:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002f1:	39 d3                	cmp    %edx,%ebx
  8002f3:	72 05                	jb     8002fa <printnum+0x30>
  8002f5:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002f8:	77 7a                	ja     800374 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	ff 75 18             	pushl  0x18(%ebp)
  800300:	8b 45 14             	mov    0x14(%ebp),%eax
  800303:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800306:	53                   	push   %ebx
  800307:	ff 75 10             	pushl  0x10(%ebp)
  80030a:	83 ec 08             	sub    $0x8,%esp
  80030d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800310:	ff 75 e0             	pushl  -0x20(%ebp)
  800313:	ff 75 dc             	pushl  -0x24(%ebp)
  800316:	ff 75 d8             	pushl  -0x28(%ebp)
  800319:	e8 f2 1a 00 00       	call   801e10 <__udivdi3>
  80031e:	83 c4 18             	add    $0x18,%esp
  800321:	52                   	push   %edx
  800322:	50                   	push   %eax
  800323:	89 f2                	mov    %esi,%edx
  800325:	89 f8                	mov    %edi,%eax
  800327:	e8 9e ff ff ff       	call   8002ca <printnum>
  80032c:	83 c4 20             	add    $0x20,%esp
  80032f:	eb 13                	jmp    800344 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800331:	83 ec 08             	sub    $0x8,%esp
  800334:	56                   	push   %esi
  800335:	ff 75 18             	pushl  0x18(%ebp)
  800338:	ff d7                	call   *%edi
  80033a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80033d:	83 eb 01             	sub    $0x1,%ebx
  800340:	85 db                	test   %ebx,%ebx
  800342:	7f ed                	jg     800331 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800344:	83 ec 08             	sub    $0x8,%esp
  800347:	56                   	push   %esi
  800348:	83 ec 04             	sub    $0x4,%esp
  80034b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80034e:	ff 75 e0             	pushl  -0x20(%ebp)
  800351:	ff 75 dc             	pushl  -0x24(%ebp)
  800354:	ff 75 d8             	pushl  -0x28(%ebp)
  800357:	e8 d4 1b 00 00       	call   801f30 <__umoddi3>
  80035c:	83 c4 14             	add    $0x14,%esp
  80035f:	0f be 80 eb 20 80 00 	movsbl 0x8020eb(%eax),%eax
  800366:	50                   	push   %eax
  800367:	ff d7                	call   *%edi
}
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80036f:	5b                   	pop    %ebx
  800370:	5e                   	pop    %esi
  800371:	5f                   	pop    %edi
  800372:	5d                   	pop    %ebp
  800373:	c3                   	ret    
  800374:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800377:	eb c4                	jmp    80033d <printnum+0x73>

00800379 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80037f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800383:	8b 10                	mov    (%eax),%edx
  800385:	3b 50 04             	cmp    0x4(%eax),%edx
  800388:	73 0a                	jae    800394 <sprintputch+0x1b>
		*b->buf++ = ch;
  80038a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80038d:	89 08                	mov    %ecx,(%eax)
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	88 02                	mov    %al,(%edx)
}
  800394:	5d                   	pop    %ebp
  800395:	c3                   	ret    

00800396 <printfmt>:
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80039c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80039f:	50                   	push   %eax
  8003a0:	ff 75 10             	pushl  0x10(%ebp)
  8003a3:	ff 75 0c             	pushl  0xc(%ebp)
  8003a6:	ff 75 08             	pushl  0x8(%ebp)
  8003a9:	e8 05 00 00 00       	call   8003b3 <vprintfmt>
}
  8003ae:	83 c4 10             	add    $0x10,%esp
  8003b1:	c9                   	leave  
  8003b2:	c3                   	ret    

008003b3 <vprintfmt>:
{
  8003b3:	55                   	push   %ebp
  8003b4:	89 e5                	mov    %esp,%ebp
  8003b6:	57                   	push   %edi
  8003b7:	56                   	push   %esi
  8003b8:	53                   	push   %ebx
  8003b9:	83 ec 2c             	sub    $0x2c,%esp
  8003bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8003bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003c2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003c5:	e9 c1 03 00 00       	jmp    80078b <vprintfmt+0x3d8>
		padc = ' ';
  8003ca:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003ce:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003d5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8003dc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003e3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e8:	8d 47 01             	lea    0x1(%edi),%eax
  8003eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ee:	0f b6 17             	movzbl (%edi),%edx
  8003f1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003f4:	3c 55                	cmp    $0x55,%al
  8003f6:	0f 87 12 04 00 00    	ja     80080e <vprintfmt+0x45b>
  8003fc:	0f b6 c0             	movzbl %al,%eax
  8003ff:	ff 24 85 20 22 80 00 	jmp    *0x802220(,%eax,4)
  800406:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800409:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80040d:	eb d9                	jmp    8003e8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80040f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800412:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800416:	eb d0                	jmp    8003e8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800418:	0f b6 d2             	movzbl %dl,%edx
  80041b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80041e:	b8 00 00 00 00       	mov    $0x0,%eax
  800423:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800426:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800429:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80042d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800430:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800433:	83 f9 09             	cmp    $0x9,%ecx
  800436:	77 55                	ja     80048d <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800438:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80043b:	eb e9                	jmp    800426 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80043d:	8b 45 14             	mov    0x14(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800445:	8b 45 14             	mov    0x14(%ebp),%eax
  800448:	8d 40 04             	lea    0x4(%eax),%eax
  80044b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800451:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800455:	79 91                	jns    8003e8 <vprintfmt+0x35>
				width = precision, precision = -1;
  800457:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80045a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800464:	eb 82                	jmp    8003e8 <vprintfmt+0x35>
  800466:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800469:	85 c0                	test   %eax,%eax
  80046b:	ba 00 00 00 00       	mov    $0x0,%edx
  800470:	0f 49 d0             	cmovns %eax,%edx
  800473:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800476:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800479:	e9 6a ff ff ff       	jmp    8003e8 <vprintfmt+0x35>
  80047e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800481:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800488:	e9 5b ff ff ff       	jmp    8003e8 <vprintfmt+0x35>
  80048d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800490:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800493:	eb bc                	jmp    800451 <vprintfmt+0x9e>
			lflag++;
  800495:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800498:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80049b:	e9 48 ff ff ff       	jmp    8003e8 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a3:	8d 78 04             	lea    0x4(%eax),%edi
  8004a6:	83 ec 08             	sub    $0x8,%esp
  8004a9:	53                   	push   %ebx
  8004aa:	ff 30                	pushl  (%eax)
  8004ac:	ff d6                	call   *%esi
			break;
  8004ae:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004b1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004b4:	e9 cf 02 00 00       	jmp    800788 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8004b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bc:	8d 78 04             	lea    0x4(%eax),%edi
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	99                   	cltd   
  8004c2:	31 d0                	xor    %edx,%eax
  8004c4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c6:	83 f8 0f             	cmp    $0xf,%eax
  8004c9:	7f 23                	jg     8004ee <vprintfmt+0x13b>
  8004cb:	8b 14 85 80 23 80 00 	mov    0x802380(,%eax,4),%edx
  8004d2:	85 d2                	test   %edx,%edx
  8004d4:	74 18                	je     8004ee <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8004d6:	52                   	push   %edx
  8004d7:	68 b5 24 80 00       	push   $0x8024b5
  8004dc:	53                   	push   %ebx
  8004dd:	56                   	push   %esi
  8004de:	e8 b3 fe ff ff       	call   800396 <printfmt>
  8004e3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004e9:	e9 9a 02 00 00       	jmp    800788 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8004ee:	50                   	push   %eax
  8004ef:	68 03 21 80 00       	push   $0x802103
  8004f4:	53                   	push   %ebx
  8004f5:	56                   	push   %esi
  8004f6:	e8 9b fe ff ff       	call   800396 <printfmt>
  8004fb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004fe:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800501:	e9 82 02 00 00       	jmp    800788 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	83 c0 04             	add    $0x4,%eax
  80050c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800514:	85 ff                	test   %edi,%edi
  800516:	b8 fc 20 80 00       	mov    $0x8020fc,%eax
  80051b:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80051e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800522:	0f 8e bd 00 00 00    	jle    8005e5 <vprintfmt+0x232>
  800528:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80052c:	75 0e                	jne    80053c <vprintfmt+0x189>
  80052e:	89 75 08             	mov    %esi,0x8(%ebp)
  800531:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800534:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800537:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80053a:	eb 6d                	jmp    8005a9 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 d0             	pushl  -0x30(%ebp)
  800542:	57                   	push   %edi
  800543:	e8 6e 03 00 00       	call   8008b6 <strnlen>
  800548:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80054b:	29 c1                	sub    %eax,%ecx
  80054d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800550:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800553:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800557:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80055a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80055d:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80055f:	eb 0f                	jmp    800570 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	53                   	push   %ebx
  800565:	ff 75 e0             	pushl  -0x20(%ebp)
  800568:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80056a:	83 ef 01             	sub    $0x1,%edi
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	85 ff                	test   %edi,%edi
  800572:	7f ed                	jg     800561 <vprintfmt+0x1ae>
  800574:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800577:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80057a:	85 c9                	test   %ecx,%ecx
  80057c:	b8 00 00 00 00       	mov    $0x0,%eax
  800581:	0f 49 c1             	cmovns %ecx,%eax
  800584:	29 c1                	sub    %eax,%ecx
  800586:	89 75 08             	mov    %esi,0x8(%ebp)
  800589:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80058c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80058f:	89 cb                	mov    %ecx,%ebx
  800591:	eb 16                	jmp    8005a9 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800593:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800597:	75 31                	jne    8005ca <vprintfmt+0x217>
					putch(ch, putdat);
  800599:	83 ec 08             	sub    $0x8,%esp
  80059c:	ff 75 0c             	pushl  0xc(%ebp)
  80059f:	50                   	push   %eax
  8005a0:	ff 55 08             	call   *0x8(%ebp)
  8005a3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005a6:	83 eb 01             	sub    $0x1,%ebx
  8005a9:	83 c7 01             	add    $0x1,%edi
  8005ac:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005b0:	0f be c2             	movsbl %dl,%eax
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	74 59                	je     800610 <vprintfmt+0x25d>
  8005b7:	85 f6                	test   %esi,%esi
  8005b9:	78 d8                	js     800593 <vprintfmt+0x1e0>
  8005bb:	83 ee 01             	sub    $0x1,%esi
  8005be:	79 d3                	jns    800593 <vprintfmt+0x1e0>
  8005c0:	89 df                	mov    %ebx,%edi
  8005c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8005c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005c8:	eb 37                	jmp    800601 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ca:	0f be d2             	movsbl %dl,%edx
  8005cd:	83 ea 20             	sub    $0x20,%edx
  8005d0:	83 fa 5e             	cmp    $0x5e,%edx
  8005d3:	76 c4                	jbe    800599 <vprintfmt+0x1e6>
					putch('?', putdat);
  8005d5:	83 ec 08             	sub    $0x8,%esp
  8005d8:	ff 75 0c             	pushl  0xc(%ebp)
  8005db:	6a 3f                	push   $0x3f
  8005dd:	ff 55 08             	call   *0x8(%ebp)
  8005e0:	83 c4 10             	add    $0x10,%esp
  8005e3:	eb c1                	jmp    8005a6 <vprintfmt+0x1f3>
  8005e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005eb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005ee:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005f1:	eb b6                	jmp    8005a9 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	53                   	push   %ebx
  8005f7:	6a 20                	push   $0x20
  8005f9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005fb:	83 ef 01             	sub    $0x1,%edi
  8005fe:	83 c4 10             	add    $0x10,%esp
  800601:	85 ff                	test   %edi,%edi
  800603:	7f ee                	jg     8005f3 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800605:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
  80060b:	e9 78 01 00 00       	jmp    800788 <vprintfmt+0x3d5>
  800610:	89 df                	mov    %ebx,%edi
  800612:	8b 75 08             	mov    0x8(%ebp),%esi
  800615:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800618:	eb e7                	jmp    800601 <vprintfmt+0x24e>
	if (lflag >= 2)
  80061a:	83 f9 01             	cmp    $0x1,%ecx
  80061d:	7e 3f                	jle    80065e <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8b 50 04             	mov    0x4(%eax),%edx
  800625:	8b 00                	mov    (%eax),%eax
  800627:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8d 40 08             	lea    0x8(%eax),%eax
  800633:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800636:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80063a:	79 5c                	jns    800698 <vprintfmt+0x2e5>
				putch('-', putdat);
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	53                   	push   %ebx
  800640:	6a 2d                	push   $0x2d
  800642:	ff d6                	call   *%esi
				num = -(long long) num;
  800644:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800647:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80064a:	f7 da                	neg    %edx
  80064c:	83 d1 00             	adc    $0x0,%ecx
  80064f:	f7 d9                	neg    %ecx
  800651:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800654:	b8 0a 00 00 00       	mov    $0xa,%eax
  800659:	e9 10 01 00 00       	jmp    80076e <vprintfmt+0x3bb>
	else if (lflag)
  80065e:	85 c9                	test   %ecx,%ecx
  800660:	75 1b                	jne    80067d <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066a:	89 c1                	mov    %eax,%ecx
  80066c:	c1 f9 1f             	sar    $0x1f,%ecx
  80066f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8d 40 04             	lea    0x4(%eax),%eax
  800678:	89 45 14             	mov    %eax,0x14(%ebp)
  80067b:	eb b9                	jmp    800636 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800685:	89 c1                	mov    %eax,%ecx
  800687:	c1 f9 1f             	sar    $0x1f,%ecx
  80068a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
  800696:	eb 9e                	jmp    800636 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800698:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80069b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80069e:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a3:	e9 c6 00 00 00       	jmp    80076e <vprintfmt+0x3bb>
	if (lflag >= 2)
  8006a8:	83 f9 01             	cmp    $0x1,%ecx
  8006ab:	7e 18                	jle    8006c5 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 10                	mov    (%eax),%edx
  8006b2:	8b 48 04             	mov    0x4(%eax),%ecx
  8006b5:	8d 40 08             	lea    0x8(%eax),%eax
  8006b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c0:	e9 a9 00 00 00       	jmp    80076e <vprintfmt+0x3bb>
	else if (lflag)
  8006c5:	85 c9                	test   %ecx,%ecx
  8006c7:	75 1a                	jne    8006e3 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8b 10                	mov    (%eax),%edx
  8006ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d3:	8d 40 04             	lea    0x4(%eax),%eax
  8006d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006de:	e9 8b 00 00 00       	jmp    80076e <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8b 10                	mov    (%eax),%edx
  8006e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ed:	8d 40 04             	lea    0x4(%eax),%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f8:	eb 74                	jmp    80076e <vprintfmt+0x3bb>
	if (lflag >= 2)
  8006fa:	83 f9 01             	cmp    $0x1,%ecx
  8006fd:	7e 15                	jle    800714 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8b 10                	mov    (%eax),%edx
  800704:	8b 48 04             	mov    0x4(%eax),%ecx
  800707:	8d 40 08             	lea    0x8(%eax),%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070d:	b8 08 00 00 00       	mov    $0x8,%eax
  800712:	eb 5a                	jmp    80076e <vprintfmt+0x3bb>
	else if (lflag)
  800714:	85 c9                	test   %ecx,%ecx
  800716:	75 17                	jne    80072f <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8b 10                	mov    (%eax),%edx
  80071d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800722:	8d 40 04             	lea    0x4(%eax),%eax
  800725:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800728:	b8 08 00 00 00       	mov    $0x8,%eax
  80072d:	eb 3f                	jmp    80076e <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8b 10                	mov    (%eax),%edx
  800734:	b9 00 00 00 00       	mov    $0x0,%ecx
  800739:	8d 40 04             	lea    0x4(%eax),%eax
  80073c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073f:	b8 08 00 00 00       	mov    $0x8,%eax
  800744:	eb 28                	jmp    80076e <vprintfmt+0x3bb>
			putch('0', putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	53                   	push   %ebx
  80074a:	6a 30                	push   $0x30
  80074c:	ff d6                	call   *%esi
			putch('x', putdat);
  80074e:	83 c4 08             	add    $0x8,%esp
  800751:	53                   	push   %ebx
  800752:	6a 78                	push   $0x78
  800754:	ff d6                	call   *%esi
			num = (unsigned long long)
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8b 10                	mov    (%eax),%edx
  80075b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800760:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800763:	8d 40 04             	lea    0x4(%eax),%eax
  800766:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800769:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80076e:	83 ec 0c             	sub    $0xc,%esp
  800771:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800775:	57                   	push   %edi
  800776:	ff 75 e0             	pushl  -0x20(%ebp)
  800779:	50                   	push   %eax
  80077a:	51                   	push   %ecx
  80077b:	52                   	push   %edx
  80077c:	89 da                	mov    %ebx,%edx
  80077e:	89 f0                	mov    %esi,%eax
  800780:	e8 45 fb ff ff       	call   8002ca <printnum>
			break;
  800785:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800788:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  80078b:	83 c7 01             	add    $0x1,%edi
  80078e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800792:	83 f8 25             	cmp    $0x25,%eax
  800795:	0f 84 2f fc ff ff    	je     8003ca <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  80079b:	85 c0                	test   %eax,%eax
  80079d:	0f 84 8b 00 00 00    	je     80082e <vprintfmt+0x47b>
			putch(ch, putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	53                   	push   %ebx
  8007a7:	50                   	push   %eax
  8007a8:	ff d6                	call   *%esi
  8007aa:	83 c4 10             	add    $0x10,%esp
  8007ad:	eb dc                	jmp    80078b <vprintfmt+0x3d8>
	if (lflag >= 2)
  8007af:	83 f9 01             	cmp    $0x1,%ecx
  8007b2:	7e 15                	jle    8007c9 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8b 10                	mov    (%eax),%edx
  8007b9:	8b 48 04             	mov    0x4(%eax),%ecx
  8007bc:	8d 40 08             	lea    0x8(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c2:	b8 10 00 00 00       	mov    $0x10,%eax
  8007c7:	eb a5                	jmp    80076e <vprintfmt+0x3bb>
	else if (lflag)
  8007c9:	85 c9                	test   %ecx,%ecx
  8007cb:	75 17                	jne    8007e4 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8b 10                	mov    (%eax),%edx
  8007d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d7:	8d 40 04             	lea    0x4(%eax),%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007dd:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e2:	eb 8a                	jmp    80076e <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	8b 10                	mov    (%eax),%edx
  8007e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ee:	8d 40 04             	lea    0x4(%eax),%eax
  8007f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f4:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f9:	e9 70 ff ff ff       	jmp    80076e <vprintfmt+0x3bb>
			putch(ch, putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	53                   	push   %ebx
  800802:	6a 25                	push   $0x25
  800804:	ff d6                	call   *%esi
			break;
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	e9 7a ff ff ff       	jmp    800788 <vprintfmt+0x3d5>
			putch('%', putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	53                   	push   %ebx
  800812:	6a 25                	push   $0x25
  800814:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800816:	83 c4 10             	add    $0x10,%esp
  800819:	89 f8                	mov    %edi,%eax
  80081b:	eb 03                	jmp    800820 <vprintfmt+0x46d>
  80081d:	83 e8 01             	sub    $0x1,%eax
  800820:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800824:	75 f7                	jne    80081d <vprintfmt+0x46a>
  800826:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800829:	e9 5a ff ff ff       	jmp    800788 <vprintfmt+0x3d5>
}
  80082e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800831:	5b                   	pop    %ebx
  800832:	5e                   	pop    %esi
  800833:	5f                   	pop    %edi
  800834:	5d                   	pop    %ebp
  800835:	c3                   	ret    

00800836 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	83 ec 18             	sub    $0x18,%esp
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800842:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800845:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800849:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80084c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800853:	85 c0                	test   %eax,%eax
  800855:	74 26                	je     80087d <vsnprintf+0x47>
  800857:	85 d2                	test   %edx,%edx
  800859:	7e 22                	jle    80087d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80085b:	ff 75 14             	pushl  0x14(%ebp)
  80085e:	ff 75 10             	pushl  0x10(%ebp)
  800861:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800864:	50                   	push   %eax
  800865:	68 79 03 80 00       	push   $0x800379
  80086a:	e8 44 fb ff ff       	call   8003b3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80086f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800872:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800878:	83 c4 10             	add    $0x10,%esp
}
  80087b:	c9                   	leave  
  80087c:	c3                   	ret    
		return -E_INVAL;
  80087d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800882:	eb f7                	jmp    80087b <vsnprintf+0x45>

00800884 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80088a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80088d:	50                   	push   %eax
  80088e:	ff 75 10             	pushl  0x10(%ebp)
  800891:	ff 75 0c             	pushl  0xc(%ebp)
  800894:	ff 75 08             	pushl  0x8(%ebp)
  800897:	e8 9a ff ff ff       	call   800836 <vsnprintf>
	va_end(ap);

	return rc;
}
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a9:	eb 03                	jmp    8008ae <strlen+0x10>
		n++;
  8008ab:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008ae:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b2:	75 f7                	jne    8008ab <strlen+0xd>
	return n;
}
  8008b4:	5d                   	pop    %ebp
  8008b5:	c3                   	ret    

008008b6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008bc:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c4:	eb 03                	jmp    8008c9 <strnlen+0x13>
		n++;
  8008c6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c9:	39 d0                	cmp    %edx,%eax
  8008cb:	74 06                	je     8008d3 <strnlen+0x1d>
  8008cd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008d1:	75 f3                	jne    8008c6 <strnlen+0x10>
	return n;
}
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	53                   	push   %ebx
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008df:	89 c2                	mov    %eax,%edx
  8008e1:	83 c1 01             	add    $0x1,%ecx
  8008e4:	83 c2 01             	add    $0x1,%edx
  8008e7:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008eb:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008ee:	84 db                	test   %bl,%bl
  8008f0:	75 ef                	jne    8008e1 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008f2:	5b                   	pop    %ebx
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	53                   	push   %ebx
  8008f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008fc:	53                   	push   %ebx
  8008fd:	e8 9c ff ff ff       	call   80089e <strlen>
  800902:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	01 d8                	add    %ebx,%eax
  80090a:	50                   	push   %eax
  80090b:	e8 c5 ff ff ff       	call   8008d5 <strcpy>
	return dst;
}
  800910:	89 d8                	mov    %ebx,%eax
  800912:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800915:	c9                   	leave  
  800916:	c3                   	ret    

00800917 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
  80091c:	8b 75 08             	mov    0x8(%ebp),%esi
  80091f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800922:	89 f3                	mov    %esi,%ebx
  800924:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800927:	89 f2                	mov    %esi,%edx
  800929:	eb 0f                	jmp    80093a <strncpy+0x23>
		*dst++ = *src;
  80092b:	83 c2 01             	add    $0x1,%edx
  80092e:	0f b6 01             	movzbl (%ecx),%eax
  800931:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800934:	80 39 01             	cmpb   $0x1,(%ecx)
  800937:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80093a:	39 da                	cmp    %ebx,%edx
  80093c:	75 ed                	jne    80092b <strncpy+0x14>
	}
	return ret;
}
  80093e:	89 f0                	mov    %esi,%eax
  800940:	5b                   	pop    %ebx
  800941:	5e                   	pop    %esi
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	56                   	push   %esi
  800948:	53                   	push   %ebx
  800949:	8b 75 08             	mov    0x8(%ebp),%esi
  80094c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800952:	89 f0                	mov    %esi,%eax
  800954:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800958:	85 c9                	test   %ecx,%ecx
  80095a:	75 0b                	jne    800967 <strlcpy+0x23>
  80095c:	eb 17                	jmp    800975 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80095e:	83 c2 01             	add    $0x1,%edx
  800961:	83 c0 01             	add    $0x1,%eax
  800964:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800967:	39 d8                	cmp    %ebx,%eax
  800969:	74 07                	je     800972 <strlcpy+0x2e>
  80096b:	0f b6 0a             	movzbl (%edx),%ecx
  80096e:	84 c9                	test   %cl,%cl
  800970:	75 ec                	jne    80095e <strlcpy+0x1a>
		*dst = '\0';
  800972:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800975:	29 f0                	sub    %esi,%eax
}
  800977:	5b                   	pop    %ebx
  800978:	5e                   	pop    %esi
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800981:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800984:	eb 06                	jmp    80098c <strcmp+0x11>
		p++, q++;
  800986:	83 c1 01             	add    $0x1,%ecx
  800989:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80098c:	0f b6 01             	movzbl (%ecx),%eax
  80098f:	84 c0                	test   %al,%al
  800991:	74 04                	je     800997 <strcmp+0x1c>
  800993:	3a 02                	cmp    (%edx),%al
  800995:	74 ef                	je     800986 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800997:	0f b6 c0             	movzbl %al,%eax
  80099a:	0f b6 12             	movzbl (%edx),%edx
  80099d:	29 d0                	sub    %edx,%eax
}
  80099f:	5d                   	pop    %ebp
  8009a0:	c3                   	ret    

008009a1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	53                   	push   %ebx
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ab:	89 c3                	mov    %eax,%ebx
  8009ad:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b0:	eb 06                	jmp    8009b8 <strncmp+0x17>
		n--, p++, q++;
  8009b2:	83 c0 01             	add    $0x1,%eax
  8009b5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009b8:	39 d8                	cmp    %ebx,%eax
  8009ba:	74 16                	je     8009d2 <strncmp+0x31>
  8009bc:	0f b6 08             	movzbl (%eax),%ecx
  8009bf:	84 c9                	test   %cl,%cl
  8009c1:	74 04                	je     8009c7 <strncmp+0x26>
  8009c3:	3a 0a                	cmp    (%edx),%cl
  8009c5:	74 eb                	je     8009b2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c7:	0f b6 00             	movzbl (%eax),%eax
  8009ca:	0f b6 12             	movzbl (%edx),%edx
  8009cd:	29 d0                	sub    %edx,%eax
}
  8009cf:	5b                   	pop    %ebx
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    
		return 0;
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d7:	eb f6                	jmp    8009cf <strncmp+0x2e>

008009d9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e3:	0f b6 10             	movzbl (%eax),%edx
  8009e6:	84 d2                	test   %dl,%dl
  8009e8:	74 09                	je     8009f3 <strchr+0x1a>
		if (*s == c)
  8009ea:	38 ca                	cmp    %cl,%dl
  8009ec:	74 0a                	je     8009f8 <strchr+0x1f>
	for (; *s; s++)
  8009ee:	83 c0 01             	add    $0x1,%eax
  8009f1:	eb f0                	jmp    8009e3 <strchr+0xa>
			return (char *) s;
	return 0;
  8009f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a04:	eb 03                	jmp    800a09 <strfind+0xf>
  800a06:	83 c0 01             	add    $0x1,%eax
  800a09:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a0c:	38 ca                	cmp    %cl,%dl
  800a0e:	74 04                	je     800a14 <strfind+0x1a>
  800a10:	84 d2                	test   %dl,%dl
  800a12:	75 f2                	jne    800a06 <strfind+0xc>
			break;
	return (char *) s;
}
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	57                   	push   %edi
  800a1a:	56                   	push   %esi
  800a1b:	53                   	push   %ebx
  800a1c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a22:	85 c9                	test   %ecx,%ecx
  800a24:	74 13                	je     800a39 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a26:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a2c:	75 05                	jne    800a33 <memset+0x1d>
  800a2e:	f6 c1 03             	test   $0x3,%cl
  800a31:	74 0d                	je     800a40 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a36:	fc                   	cld    
  800a37:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a39:	89 f8                	mov    %edi,%eax
  800a3b:	5b                   	pop    %ebx
  800a3c:	5e                   	pop    %esi
  800a3d:	5f                   	pop    %edi
  800a3e:	5d                   	pop    %ebp
  800a3f:	c3                   	ret    
		c &= 0xFF;
  800a40:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a44:	89 d3                	mov    %edx,%ebx
  800a46:	c1 e3 08             	shl    $0x8,%ebx
  800a49:	89 d0                	mov    %edx,%eax
  800a4b:	c1 e0 18             	shl    $0x18,%eax
  800a4e:	89 d6                	mov    %edx,%esi
  800a50:	c1 e6 10             	shl    $0x10,%esi
  800a53:	09 f0                	or     %esi,%eax
  800a55:	09 c2                	or     %eax,%edx
  800a57:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a59:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a5c:	89 d0                	mov    %edx,%eax
  800a5e:	fc                   	cld    
  800a5f:	f3 ab                	rep stos %eax,%es:(%edi)
  800a61:	eb d6                	jmp    800a39 <memset+0x23>

00800a63 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	57                   	push   %edi
  800a67:	56                   	push   %esi
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a71:	39 c6                	cmp    %eax,%esi
  800a73:	73 35                	jae    800aaa <memmove+0x47>
  800a75:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a78:	39 c2                	cmp    %eax,%edx
  800a7a:	76 2e                	jbe    800aaa <memmove+0x47>
		s += n;
		d += n;
  800a7c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7f:	89 d6                	mov    %edx,%esi
  800a81:	09 fe                	or     %edi,%esi
  800a83:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a89:	74 0c                	je     800a97 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a8b:	83 ef 01             	sub    $0x1,%edi
  800a8e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a91:	fd                   	std    
  800a92:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a94:	fc                   	cld    
  800a95:	eb 21                	jmp    800ab8 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a97:	f6 c1 03             	test   $0x3,%cl
  800a9a:	75 ef                	jne    800a8b <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a9c:	83 ef 04             	sub    $0x4,%edi
  800a9f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aa5:	fd                   	std    
  800aa6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa8:	eb ea                	jmp    800a94 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aaa:	89 f2                	mov    %esi,%edx
  800aac:	09 c2                	or     %eax,%edx
  800aae:	f6 c2 03             	test   $0x3,%dl
  800ab1:	74 09                	je     800abc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ab3:	89 c7                	mov    %eax,%edi
  800ab5:	fc                   	cld    
  800ab6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ab8:	5e                   	pop    %esi
  800ab9:	5f                   	pop    %edi
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abc:	f6 c1 03             	test   $0x3,%cl
  800abf:	75 f2                	jne    800ab3 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac4:	89 c7                	mov    %eax,%edi
  800ac6:	fc                   	cld    
  800ac7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac9:	eb ed                	jmp    800ab8 <memmove+0x55>

00800acb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ace:	ff 75 10             	pushl  0x10(%ebp)
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	ff 75 08             	pushl  0x8(%ebp)
  800ad7:	e8 87 ff ff ff       	call   800a63 <memmove>
}
  800adc:	c9                   	leave  
  800add:	c3                   	ret    

00800ade <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	56                   	push   %esi
  800ae2:	53                   	push   %ebx
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae9:	89 c6                	mov    %eax,%esi
  800aeb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aee:	39 f0                	cmp    %esi,%eax
  800af0:	74 1c                	je     800b0e <memcmp+0x30>
		if (*s1 != *s2)
  800af2:	0f b6 08             	movzbl (%eax),%ecx
  800af5:	0f b6 1a             	movzbl (%edx),%ebx
  800af8:	38 d9                	cmp    %bl,%cl
  800afa:	75 08                	jne    800b04 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800afc:	83 c0 01             	add    $0x1,%eax
  800aff:	83 c2 01             	add    $0x1,%edx
  800b02:	eb ea                	jmp    800aee <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b04:	0f b6 c1             	movzbl %cl,%eax
  800b07:	0f b6 db             	movzbl %bl,%ebx
  800b0a:	29 d8                	sub    %ebx,%eax
  800b0c:	eb 05                	jmp    800b13 <memcmp+0x35>
	}

	return 0;
  800b0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b13:	5b                   	pop    %ebx
  800b14:	5e                   	pop    %esi
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b20:	89 c2                	mov    %eax,%edx
  800b22:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b25:	39 d0                	cmp    %edx,%eax
  800b27:	73 09                	jae    800b32 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b29:	38 08                	cmp    %cl,(%eax)
  800b2b:	74 05                	je     800b32 <memfind+0x1b>
	for (; s < ends; s++)
  800b2d:	83 c0 01             	add    $0x1,%eax
  800b30:	eb f3                	jmp    800b25 <memfind+0xe>
			break;
	return (void *) s;
}
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	57                   	push   %edi
  800b38:	56                   	push   %esi
  800b39:	53                   	push   %ebx
  800b3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b40:	eb 03                	jmp    800b45 <strtol+0x11>
		s++;
  800b42:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b45:	0f b6 01             	movzbl (%ecx),%eax
  800b48:	3c 20                	cmp    $0x20,%al
  800b4a:	74 f6                	je     800b42 <strtol+0xe>
  800b4c:	3c 09                	cmp    $0x9,%al
  800b4e:	74 f2                	je     800b42 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b50:	3c 2b                	cmp    $0x2b,%al
  800b52:	74 2e                	je     800b82 <strtol+0x4e>
	int neg = 0;
  800b54:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b59:	3c 2d                	cmp    $0x2d,%al
  800b5b:	74 2f                	je     800b8c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b5d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b63:	75 05                	jne    800b6a <strtol+0x36>
  800b65:	80 39 30             	cmpb   $0x30,(%ecx)
  800b68:	74 2c                	je     800b96 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b6a:	85 db                	test   %ebx,%ebx
  800b6c:	75 0a                	jne    800b78 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b6e:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b73:	80 39 30             	cmpb   $0x30,(%ecx)
  800b76:	74 28                	je     800ba0 <strtol+0x6c>
		base = 10;
  800b78:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b80:	eb 50                	jmp    800bd2 <strtol+0x9e>
		s++;
  800b82:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b85:	bf 00 00 00 00       	mov    $0x0,%edi
  800b8a:	eb d1                	jmp    800b5d <strtol+0x29>
		s++, neg = 1;
  800b8c:	83 c1 01             	add    $0x1,%ecx
  800b8f:	bf 01 00 00 00       	mov    $0x1,%edi
  800b94:	eb c7                	jmp    800b5d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b96:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b9a:	74 0e                	je     800baa <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b9c:	85 db                	test   %ebx,%ebx
  800b9e:	75 d8                	jne    800b78 <strtol+0x44>
		s++, base = 8;
  800ba0:	83 c1 01             	add    $0x1,%ecx
  800ba3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ba8:	eb ce                	jmp    800b78 <strtol+0x44>
		s += 2, base = 16;
  800baa:	83 c1 02             	add    $0x2,%ecx
  800bad:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bb2:	eb c4                	jmp    800b78 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bb4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bb7:	89 f3                	mov    %esi,%ebx
  800bb9:	80 fb 19             	cmp    $0x19,%bl
  800bbc:	77 29                	ja     800be7 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bbe:	0f be d2             	movsbl %dl,%edx
  800bc1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bc4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bc7:	7d 30                	jge    800bf9 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bc9:	83 c1 01             	add    $0x1,%ecx
  800bcc:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bd0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bd2:	0f b6 11             	movzbl (%ecx),%edx
  800bd5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bd8:	89 f3                	mov    %esi,%ebx
  800bda:	80 fb 09             	cmp    $0x9,%bl
  800bdd:	77 d5                	ja     800bb4 <strtol+0x80>
			dig = *s - '0';
  800bdf:	0f be d2             	movsbl %dl,%edx
  800be2:	83 ea 30             	sub    $0x30,%edx
  800be5:	eb dd                	jmp    800bc4 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800be7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bea:	89 f3                	mov    %esi,%ebx
  800bec:	80 fb 19             	cmp    $0x19,%bl
  800bef:	77 08                	ja     800bf9 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bf1:	0f be d2             	movsbl %dl,%edx
  800bf4:	83 ea 37             	sub    $0x37,%edx
  800bf7:	eb cb                	jmp    800bc4 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfd:	74 05                	je     800c04 <strtol+0xd0>
		*endptr = (char *) s;
  800bff:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c02:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c04:	89 c2                	mov    %eax,%edx
  800c06:	f7 da                	neg    %edx
  800c08:	85 ff                	test   %edi,%edi
  800c0a:	0f 45 c2             	cmovne %edx,%eax
}
  800c0d:	5b                   	pop    %ebx
  800c0e:	5e                   	pop    %esi
  800c0f:	5f                   	pop    %edi
  800c10:	5d                   	pop    %ebp
  800c11:	c3                   	ret    

00800c12 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c18:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c23:	89 c3                	mov    %eax,%ebx
  800c25:	89 c7                	mov    %eax,%edi
  800c27:	89 c6                	mov    %eax,%esi
  800c29:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c2b:	5b                   	pop    %ebx
  800c2c:	5e                   	pop    %esi
  800c2d:	5f                   	pop    %edi
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    

00800c30 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	57                   	push   %edi
  800c34:	56                   	push   %esi
  800c35:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c36:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3b:	b8 01 00 00 00       	mov    $0x1,%eax
  800c40:	89 d1                	mov    %edx,%ecx
  800c42:	89 d3                	mov    %edx,%ebx
  800c44:	89 d7                	mov    %edx,%edi
  800c46:	89 d6                	mov    %edx,%esi
  800c48:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c4a:	5b                   	pop    %ebx
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	57                   	push   %edi
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
  800c55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c58:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c60:	b8 03 00 00 00       	mov    $0x3,%eax
  800c65:	89 cb                	mov    %ecx,%ebx
  800c67:	89 cf                	mov    %ecx,%edi
  800c69:	89 ce                	mov    %ecx,%esi
  800c6b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6d:	85 c0                	test   %eax,%eax
  800c6f:	7f 08                	jg     800c79 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c74:	5b                   	pop    %ebx
  800c75:	5e                   	pop    %esi
  800c76:	5f                   	pop    %edi
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c79:	83 ec 0c             	sub    $0xc,%esp
  800c7c:	50                   	push   %eax
  800c7d:	6a 03                	push   $0x3
  800c7f:	68 df 23 80 00       	push   $0x8023df
  800c84:	6a 23                	push   $0x23
  800c86:	68 fc 23 80 00       	push   $0x8023fc
  800c8b:	e8 4b f5 ff ff       	call   8001db <_panic>

00800c90 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	57                   	push   %edi
  800c94:	56                   	push   %esi
  800c95:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c96:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9b:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca0:	89 d1                	mov    %edx,%ecx
  800ca2:	89 d3                	mov    %edx,%ebx
  800ca4:	89 d7                	mov    %edx,%edi
  800ca6:	89 d6                	mov    %edx,%esi
  800ca8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800caa:	5b                   	pop    %ebx
  800cab:	5e                   	pop    %esi
  800cac:	5f                   	pop    %edi
  800cad:	5d                   	pop    %ebp
  800cae:	c3                   	ret    

00800caf <sys_yield>:

void
sys_yield(void)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	57                   	push   %edi
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800cb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cba:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cbf:	89 d1                	mov    %edx,%ecx
  800cc1:	89 d3                	mov    %edx,%ebx
  800cc3:	89 d7                	mov    %edx,%edi
  800cc5:	89 d6                	mov    %edx,%esi
  800cc7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5f                   	pop    %edi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	57                   	push   %edi
  800cd2:	56                   	push   %esi
  800cd3:	53                   	push   %ebx
  800cd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800cd7:	be 00 00 00 00       	mov    $0x0,%esi
  800cdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ce7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cea:	89 f7                	mov    %esi,%edi
  800cec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cee:	85 c0                	test   %eax,%eax
  800cf0:	7f 08                	jg     800cfa <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800cfe:	6a 04                	push   $0x4
  800d00:	68 df 23 80 00       	push   $0x8023df
  800d05:	6a 23                	push   $0x23
  800d07:	68 fc 23 80 00       	push   $0x8023fc
  800d0c:	e8 ca f4 ff ff       	call   8001db <_panic>

00800d11 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	57                   	push   %edi
  800d15:	56                   	push   %esi
  800d16:	53                   	push   %ebx
  800d17:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d20:	b8 05 00 00 00       	mov    $0x5,%eax
  800d25:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d28:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d2b:	8b 75 18             	mov    0x18(%ebp),%esi
  800d2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d30:	85 c0                	test   %eax,%eax
  800d32:	7f 08                	jg     800d3c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d40:	6a 05                	push   $0x5
  800d42:	68 df 23 80 00       	push   $0x8023df
  800d47:	6a 23                	push   $0x23
  800d49:	68 fc 23 80 00       	push   $0x8023fc
  800d4e:	e8 88 f4 ff ff       	call   8001db <_panic>

00800d53 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d67:	b8 06 00 00 00       	mov    $0x6,%eax
  800d6c:	89 df                	mov    %ebx,%edi
  800d6e:	89 de                	mov    %ebx,%esi
  800d70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d72:	85 c0                	test   %eax,%eax
  800d74:	7f 08                	jg     800d7e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800d82:	6a 06                	push   $0x6
  800d84:	68 df 23 80 00       	push   $0x8023df
  800d89:	6a 23                	push   $0x23
  800d8b:	68 fc 23 80 00       	push   $0x8023fc
  800d90:	e8 46 f4 ff ff       	call   8001db <_panic>

00800d95 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	57                   	push   %edi
  800d99:	56                   	push   %esi
  800d9a:	53                   	push   %ebx
  800d9b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
  800da6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da9:	b8 08 00 00 00       	mov    $0x8,%eax
  800dae:	89 df                	mov    %ebx,%edi
  800db0:	89 de                	mov    %ebx,%esi
  800db2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db4:	85 c0                	test   %eax,%eax
  800db6:	7f 08                	jg     800dc0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbb:	5b                   	pop    %ebx
  800dbc:	5e                   	pop    %esi
  800dbd:	5f                   	pop    %edi
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc0:	83 ec 0c             	sub    $0xc,%esp
  800dc3:	50                   	push   %eax
  800dc4:	6a 08                	push   $0x8
  800dc6:	68 df 23 80 00       	push   $0x8023df
  800dcb:	6a 23                	push   $0x23
  800dcd:	68 fc 23 80 00       	push   $0x8023fc
  800dd2:	e8 04 f4 ff ff       	call   8001db <_panic>

00800dd7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	57                   	push   %edi
  800ddb:	56                   	push   %esi
  800ddc:	53                   	push   %ebx
  800ddd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800de0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de5:	8b 55 08             	mov    0x8(%ebp),%edx
  800de8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800deb:	b8 09 00 00 00       	mov    $0x9,%eax
  800df0:	89 df                	mov    %ebx,%edi
  800df2:	89 de                	mov    %ebx,%esi
  800df4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df6:	85 c0                	test   %eax,%eax
  800df8:	7f 08                	jg     800e02 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5f                   	pop    %edi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e02:	83 ec 0c             	sub    $0xc,%esp
  800e05:	50                   	push   %eax
  800e06:	6a 09                	push   $0x9
  800e08:	68 df 23 80 00       	push   $0x8023df
  800e0d:	6a 23                	push   $0x23
  800e0f:	68 fc 23 80 00       	push   $0x8023fc
  800e14:	e8 c2 f3 ff ff       	call   8001db <_panic>

00800e19 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	57                   	push   %edi
  800e1d:	56                   	push   %esi
  800e1e:	53                   	push   %ebx
  800e1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e22:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e27:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e32:	89 df                	mov    %ebx,%edi
  800e34:	89 de                	mov    %ebx,%esi
  800e36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	7f 08                	jg     800e44 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3f:	5b                   	pop    %ebx
  800e40:	5e                   	pop    %esi
  800e41:	5f                   	pop    %edi
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e44:	83 ec 0c             	sub    $0xc,%esp
  800e47:	50                   	push   %eax
  800e48:	6a 0a                	push   $0xa
  800e4a:	68 df 23 80 00       	push   $0x8023df
  800e4f:	6a 23                	push   $0x23
  800e51:	68 fc 23 80 00       	push   $0x8023fc
  800e56:	e8 80 f3 ff ff       	call   8001db <_panic>

00800e5b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e61:	8b 55 08             	mov    0x8(%ebp),%edx
  800e64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e67:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e6c:	be 00 00 00 00       	mov    $0x0,%esi
  800e71:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e74:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e77:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e79:	5b                   	pop    %ebx
  800e7a:	5e                   	pop    %esi
  800e7b:	5f                   	pop    %edi
  800e7c:	5d                   	pop    %ebp
  800e7d:	c3                   	ret    

00800e7e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	57                   	push   %edi
  800e82:	56                   	push   %esi
  800e83:	53                   	push   %ebx
  800e84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e87:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e94:	89 cb                	mov    %ecx,%ebx
  800e96:	89 cf                	mov    %ecx,%edi
  800e98:	89 ce                	mov    %ecx,%esi
  800e9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	7f 08                	jg     800ea8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea3:	5b                   	pop    %ebx
  800ea4:	5e                   	pop    %esi
  800ea5:	5f                   	pop    %edi
  800ea6:	5d                   	pop    %ebp
  800ea7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea8:	83 ec 0c             	sub    $0xc,%esp
  800eab:	50                   	push   %eax
  800eac:	6a 0d                	push   $0xd
  800eae:	68 df 23 80 00       	push   $0x8023df
  800eb3:	6a 23                	push   $0x23
  800eb5:	68 fc 23 80 00       	push   $0x8023fc
  800eba:	e8 1c f3 ff ff       	call   8001db <_panic>

00800ebf <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	05 00 00 00 30       	add    $0x30000000,%eax
  800eca:	c1 e8 0c             	shr    $0xc,%eax
}
  800ecd:	5d                   	pop    %ebp
  800ece:	c3                   	ret    

00800ecf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800eda:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800edf:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eec:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ef1:	89 c2                	mov    %eax,%edx
  800ef3:	c1 ea 16             	shr    $0x16,%edx
  800ef6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800efd:	f6 c2 01             	test   $0x1,%dl
  800f00:	74 2a                	je     800f2c <fd_alloc+0x46>
  800f02:	89 c2                	mov    %eax,%edx
  800f04:	c1 ea 0c             	shr    $0xc,%edx
  800f07:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f0e:	f6 c2 01             	test   $0x1,%dl
  800f11:	74 19                	je     800f2c <fd_alloc+0x46>
  800f13:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f18:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f1d:	75 d2                	jne    800ef1 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f1f:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f25:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f2a:	eb 07                	jmp    800f33 <fd_alloc+0x4d>
			*fd_store = fd;
  800f2c:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f3b:	83 f8 1f             	cmp    $0x1f,%eax
  800f3e:	77 36                	ja     800f76 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f40:	c1 e0 0c             	shl    $0xc,%eax
  800f43:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f48:	89 c2                	mov    %eax,%edx
  800f4a:	c1 ea 16             	shr    $0x16,%edx
  800f4d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f54:	f6 c2 01             	test   $0x1,%dl
  800f57:	74 24                	je     800f7d <fd_lookup+0x48>
  800f59:	89 c2                	mov    %eax,%edx
  800f5b:	c1 ea 0c             	shr    $0xc,%edx
  800f5e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f65:	f6 c2 01             	test   $0x1,%dl
  800f68:	74 1a                	je     800f84 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6d:	89 02                	mov    %eax,(%edx)
	return 0;
  800f6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    
		return -E_INVAL;
  800f76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7b:	eb f7                	jmp    800f74 <fd_lookup+0x3f>
		return -E_INVAL;
  800f7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f82:	eb f0                	jmp    800f74 <fd_lookup+0x3f>
  800f84:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f89:	eb e9                	jmp    800f74 <fd_lookup+0x3f>

00800f8b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 08             	sub    $0x8,%esp
  800f91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f94:	ba 8c 24 80 00       	mov    $0x80248c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f99:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f9e:	39 08                	cmp    %ecx,(%eax)
  800fa0:	74 33                	je     800fd5 <dev_lookup+0x4a>
  800fa2:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800fa5:	8b 02                	mov    (%edx),%eax
  800fa7:	85 c0                	test   %eax,%eax
  800fa9:	75 f3                	jne    800f9e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fab:	a1 08 40 80 00       	mov    0x804008,%eax
  800fb0:	8b 40 48             	mov    0x48(%eax),%eax
  800fb3:	83 ec 04             	sub    $0x4,%esp
  800fb6:	51                   	push   %ecx
  800fb7:	50                   	push   %eax
  800fb8:	68 0c 24 80 00       	push   $0x80240c
  800fbd:	e8 f4 f2 ff ff       	call   8002b6 <cprintf>
	*dev = 0;
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fcb:	83 c4 10             	add    $0x10,%esp
  800fce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fd3:	c9                   	leave  
  800fd4:	c3                   	ret    
			*dev = devtab[i];
  800fd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd8:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fda:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdf:	eb f2                	jmp    800fd3 <dev_lookup+0x48>

00800fe1 <fd_close>:
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	57                   	push   %edi
  800fe5:	56                   	push   %esi
  800fe6:	53                   	push   %ebx
  800fe7:	83 ec 1c             	sub    $0x1c,%esp
  800fea:	8b 75 08             	mov    0x8(%ebp),%esi
  800fed:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ff0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ff3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ff4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800ffa:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ffd:	50                   	push   %eax
  800ffe:	e8 32 ff ff ff       	call   800f35 <fd_lookup>
  801003:	89 c3                	mov    %eax,%ebx
  801005:	83 c4 08             	add    $0x8,%esp
  801008:	85 c0                	test   %eax,%eax
  80100a:	78 05                	js     801011 <fd_close+0x30>
	    || fd != fd2)
  80100c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80100f:	74 16                	je     801027 <fd_close+0x46>
		return (must_exist ? r : 0);
  801011:	89 f8                	mov    %edi,%eax
  801013:	84 c0                	test   %al,%al
  801015:	b8 00 00 00 00       	mov    $0x0,%eax
  80101a:	0f 44 d8             	cmove  %eax,%ebx
}
  80101d:	89 d8                	mov    %ebx,%eax
  80101f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801022:	5b                   	pop    %ebx
  801023:	5e                   	pop    %esi
  801024:	5f                   	pop    %edi
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801027:	83 ec 08             	sub    $0x8,%esp
  80102a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80102d:	50                   	push   %eax
  80102e:	ff 36                	pushl  (%esi)
  801030:	e8 56 ff ff ff       	call   800f8b <dev_lookup>
  801035:	89 c3                	mov    %eax,%ebx
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	85 c0                	test   %eax,%eax
  80103c:	78 15                	js     801053 <fd_close+0x72>
		if (dev->dev_close)
  80103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801041:	8b 40 10             	mov    0x10(%eax),%eax
  801044:	85 c0                	test   %eax,%eax
  801046:	74 1b                	je     801063 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801048:	83 ec 0c             	sub    $0xc,%esp
  80104b:	56                   	push   %esi
  80104c:	ff d0                	call   *%eax
  80104e:	89 c3                	mov    %eax,%ebx
  801050:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801053:	83 ec 08             	sub    $0x8,%esp
  801056:	56                   	push   %esi
  801057:	6a 00                	push   $0x0
  801059:	e8 f5 fc ff ff       	call   800d53 <sys_page_unmap>
	return r;
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	eb ba                	jmp    80101d <fd_close+0x3c>
			r = 0;
  801063:	bb 00 00 00 00       	mov    $0x0,%ebx
  801068:	eb e9                	jmp    801053 <fd_close+0x72>

0080106a <close>:

int
close(int fdnum)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801070:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801073:	50                   	push   %eax
  801074:	ff 75 08             	pushl  0x8(%ebp)
  801077:	e8 b9 fe ff ff       	call   800f35 <fd_lookup>
  80107c:	83 c4 08             	add    $0x8,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	78 10                	js     801093 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801083:	83 ec 08             	sub    $0x8,%esp
  801086:	6a 01                	push   $0x1
  801088:	ff 75 f4             	pushl  -0xc(%ebp)
  80108b:	e8 51 ff ff ff       	call   800fe1 <fd_close>
  801090:	83 c4 10             	add    $0x10,%esp
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <close_all>:

void
close_all(void)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	53                   	push   %ebx
  801099:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80109c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010a1:	83 ec 0c             	sub    $0xc,%esp
  8010a4:	53                   	push   %ebx
  8010a5:	e8 c0 ff ff ff       	call   80106a <close>
	for (i = 0; i < MAXFD; i++)
  8010aa:	83 c3 01             	add    $0x1,%ebx
  8010ad:	83 c4 10             	add    $0x10,%esp
  8010b0:	83 fb 20             	cmp    $0x20,%ebx
  8010b3:	75 ec                	jne    8010a1 <close_all+0xc>
}
  8010b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	57                   	push   %edi
  8010be:	56                   	push   %esi
  8010bf:	53                   	push   %ebx
  8010c0:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010c3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010c6:	50                   	push   %eax
  8010c7:	ff 75 08             	pushl  0x8(%ebp)
  8010ca:	e8 66 fe ff ff       	call   800f35 <fd_lookup>
  8010cf:	89 c3                	mov    %eax,%ebx
  8010d1:	83 c4 08             	add    $0x8,%esp
  8010d4:	85 c0                	test   %eax,%eax
  8010d6:	0f 88 81 00 00 00    	js     80115d <dup+0xa3>
		return r;
	close(newfdnum);
  8010dc:	83 ec 0c             	sub    $0xc,%esp
  8010df:	ff 75 0c             	pushl  0xc(%ebp)
  8010e2:	e8 83 ff ff ff       	call   80106a <close>

	newfd = INDEX2FD(newfdnum);
  8010e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010ea:	c1 e6 0c             	shl    $0xc,%esi
  8010ed:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010f3:	83 c4 04             	add    $0x4,%esp
  8010f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f9:	e8 d1 fd ff ff       	call   800ecf <fd2data>
  8010fe:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801100:	89 34 24             	mov    %esi,(%esp)
  801103:	e8 c7 fd ff ff       	call   800ecf <fd2data>
  801108:	83 c4 10             	add    $0x10,%esp
  80110b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80110d:	89 d8                	mov    %ebx,%eax
  80110f:	c1 e8 16             	shr    $0x16,%eax
  801112:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801119:	a8 01                	test   $0x1,%al
  80111b:	74 11                	je     80112e <dup+0x74>
  80111d:	89 d8                	mov    %ebx,%eax
  80111f:	c1 e8 0c             	shr    $0xc,%eax
  801122:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801129:	f6 c2 01             	test   $0x1,%dl
  80112c:	75 39                	jne    801167 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80112e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801131:	89 d0                	mov    %edx,%eax
  801133:	c1 e8 0c             	shr    $0xc,%eax
  801136:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80113d:	83 ec 0c             	sub    $0xc,%esp
  801140:	25 07 0e 00 00       	and    $0xe07,%eax
  801145:	50                   	push   %eax
  801146:	56                   	push   %esi
  801147:	6a 00                	push   $0x0
  801149:	52                   	push   %edx
  80114a:	6a 00                	push   $0x0
  80114c:	e8 c0 fb ff ff       	call   800d11 <sys_page_map>
  801151:	89 c3                	mov    %eax,%ebx
  801153:	83 c4 20             	add    $0x20,%esp
  801156:	85 c0                	test   %eax,%eax
  801158:	78 31                	js     80118b <dup+0xd1>
		goto err;

	return newfdnum;
  80115a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80115d:	89 d8                	mov    %ebx,%eax
  80115f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801162:	5b                   	pop    %ebx
  801163:	5e                   	pop    %esi
  801164:	5f                   	pop    %edi
  801165:	5d                   	pop    %ebp
  801166:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801167:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80116e:	83 ec 0c             	sub    $0xc,%esp
  801171:	25 07 0e 00 00       	and    $0xe07,%eax
  801176:	50                   	push   %eax
  801177:	57                   	push   %edi
  801178:	6a 00                	push   $0x0
  80117a:	53                   	push   %ebx
  80117b:	6a 00                	push   $0x0
  80117d:	e8 8f fb ff ff       	call   800d11 <sys_page_map>
  801182:	89 c3                	mov    %eax,%ebx
  801184:	83 c4 20             	add    $0x20,%esp
  801187:	85 c0                	test   %eax,%eax
  801189:	79 a3                	jns    80112e <dup+0x74>
	sys_page_unmap(0, newfd);
  80118b:	83 ec 08             	sub    $0x8,%esp
  80118e:	56                   	push   %esi
  80118f:	6a 00                	push   $0x0
  801191:	e8 bd fb ff ff       	call   800d53 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801196:	83 c4 08             	add    $0x8,%esp
  801199:	57                   	push   %edi
  80119a:	6a 00                	push   $0x0
  80119c:	e8 b2 fb ff ff       	call   800d53 <sys_page_unmap>
	return r;
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	eb b7                	jmp    80115d <dup+0xa3>

008011a6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	53                   	push   %ebx
  8011aa:	83 ec 14             	sub    $0x14,%esp
  8011ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011b3:	50                   	push   %eax
  8011b4:	53                   	push   %ebx
  8011b5:	e8 7b fd ff ff       	call   800f35 <fd_lookup>
  8011ba:	83 c4 08             	add    $0x8,%esp
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	78 3f                	js     801200 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011c1:	83 ec 08             	sub    $0x8,%esp
  8011c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c7:	50                   	push   %eax
  8011c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cb:	ff 30                	pushl  (%eax)
  8011cd:	e8 b9 fd ff ff       	call   800f8b <dev_lookup>
  8011d2:	83 c4 10             	add    $0x10,%esp
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	78 27                	js     801200 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011dc:	8b 42 08             	mov    0x8(%edx),%eax
  8011df:	83 e0 03             	and    $0x3,%eax
  8011e2:	83 f8 01             	cmp    $0x1,%eax
  8011e5:	74 1e                	je     801205 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ea:	8b 40 08             	mov    0x8(%eax),%eax
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	74 35                	je     801226 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011f1:	83 ec 04             	sub    $0x4,%esp
  8011f4:	ff 75 10             	pushl  0x10(%ebp)
  8011f7:	ff 75 0c             	pushl  0xc(%ebp)
  8011fa:	52                   	push   %edx
  8011fb:	ff d0                	call   *%eax
  8011fd:	83 c4 10             	add    $0x10,%esp
}
  801200:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801203:	c9                   	leave  
  801204:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801205:	a1 08 40 80 00       	mov    0x804008,%eax
  80120a:	8b 40 48             	mov    0x48(%eax),%eax
  80120d:	83 ec 04             	sub    $0x4,%esp
  801210:	53                   	push   %ebx
  801211:	50                   	push   %eax
  801212:	68 50 24 80 00       	push   $0x802450
  801217:	e8 9a f0 ff ff       	call   8002b6 <cprintf>
		return -E_INVAL;
  80121c:	83 c4 10             	add    $0x10,%esp
  80121f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801224:	eb da                	jmp    801200 <read+0x5a>
		return -E_NOT_SUPP;
  801226:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80122b:	eb d3                	jmp    801200 <read+0x5a>

0080122d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	57                   	push   %edi
  801231:	56                   	push   %esi
  801232:	53                   	push   %ebx
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	8b 7d 08             	mov    0x8(%ebp),%edi
  801239:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80123c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801241:	39 f3                	cmp    %esi,%ebx
  801243:	73 25                	jae    80126a <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801245:	83 ec 04             	sub    $0x4,%esp
  801248:	89 f0                	mov    %esi,%eax
  80124a:	29 d8                	sub    %ebx,%eax
  80124c:	50                   	push   %eax
  80124d:	89 d8                	mov    %ebx,%eax
  80124f:	03 45 0c             	add    0xc(%ebp),%eax
  801252:	50                   	push   %eax
  801253:	57                   	push   %edi
  801254:	e8 4d ff ff ff       	call   8011a6 <read>
		if (m < 0)
  801259:	83 c4 10             	add    $0x10,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	78 08                	js     801268 <readn+0x3b>
			return m;
		if (m == 0)
  801260:	85 c0                	test   %eax,%eax
  801262:	74 06                	je     80126a <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801264:	01 c3                	add    %eax,%ebx
  801266:	eb d9                	jmp    801241 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801268:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80126a:	89 d8                	mov    %ebx,%eax
  80126c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126f:	5b                   	pop    %ebx
  801270:	5e                   	pop    %esi
  801271:	5f                   	pop    %edi
  801272:	5d                   	pop    %ebp
  801273:	c3                   	ret    

00801274 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	53                   	push   %ebx
  801278:	83 ec 14             	sub    $0x14,%esp
  80127b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80127e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801281:	50                   	push   %eax
  801282:	53                   	push   %ebx
  801283:	e8 ad fc ff ff       	call   800f35 <fd_lookup>
  801288:	83 c4 08             	add    $0x8,%esp
  80128b:	85 c0                	test   %eax,%eax
  80128d:	78 3a                	js     8012c9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80128f:	83 ec 08             	sub    $0x8,%esp
  801292:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801295:	50                   	push   %eax
  801296:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801299:	ff 30                	pushl  (%eax)
  80129b:	e8 eb fc ff ff       	call   800f8b <dev_lookup>
  8012a0:	83 c4 10             	add    $0x10,%esp
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	78 22                	js     8012c9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012ae:	74 1e                	je     8012ce <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b3:	8b 52 0c             	mov    0xc(%edx),%edx
  8012b6:	85 d2                	test   %edx,%edx
  8012b8:	74 35                	je     8012ef <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012ba:	83 ec 04             	sub    $0x4,%esp
  8012bd:	ff 75 10             	pushl  0x10(%ebp)
  8012c0:	ff 75 0c             	pushl  0xc(%ebp)
  8012c3:	50                   	push   %eax
  8012c4:	ff d2                	call   *%edx
  8012c6:	83 c4 10             	add    $0x10,%esp
}
  8012c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012ce:	a1 08 40 80 00       	mov    0x804008,%eax
  8012d3:	8b 40 48             	mov    0x48(%eax),%eax
  8012d6:	83 ec 04             	sub    $0x4,%esp
  8012d9:	53                   	push   %ebx
  8012da:	50                   	push   %eax
  8012db:	68 6c 24 80 00       	push   $0x80246c
  8012e0:	e8 d1 ef ff ff       	call   8002b6 <cprintf>
		return -E_INVAL;
  8012e5:	83 c4 10             	add    $0x10,%esp
  8012e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ed:	eb da                	jmp    8012c9 <write+0x55>
		return -E_NOT_SUPP;
  8012ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012f4:	eb d3                	jmp    8012c9 <write+0x55>

008012f6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012fc:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012ff:	50                   	push   %eax
  801300:	ff 75 08             	pushl  0x8(%ebp)
  801303:	e8 2d fc ff ff       	call   800f35 <fd_lookup>
  801308:	83 c4 08             	add    $0x8,%esp
  80130b:	85 c0                	test   %eax,%eax
  80130d:	78 0e                	js     80131d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80130f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801312:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801315:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801318:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	53                   	push   %ebx
  801323:	83 ec 14             	sub    $0x14,%esp
  801326:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801329:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80132c:	50                   	push   %eax
  80132d:	53                   	push   %ebx
  80132e:	e8 02 fc ff ff       	call   800f35 <fd_lookup>
  801333:	83 c4 08             	add    $0x8,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	78 37                	js     801371 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80133a:	83 ec 08             	sub    $0x8,%esp
  80133d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801340:	50                   	push   %eax
  801341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801344:	ff 30                	pushl  (%eax)
  801346:	e8 40 fc ff ff       	call   800f8b <dev_lookup>
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	78 1f                	js     801371 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801352:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801355:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801359:	74 1b                	je     801376 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80135b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135e:	8b 52 18             	mov    0x18(%edx),%edx
  801361:	85 d2                	test   %edx,%edx
  801363:	74 32                	je     801397 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801365:	83 ec 08             	sub    $0x8,%esp
  801368:	ff 75 0c             	pushl  0xc(%ebp)
  80136b:	50                   	push   %eax
  80136c:	ff d2                	call   *%edx
  80136e:	83 c4 10             	add    $0x10,%esp
}
  801371:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801374:	c9                   	leave  
  801375:	c3                   	ret    
			thisenv->env_id, fdnum);
  801376:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80137b:	8b 40 48             	mov    0x48(%eax),%eax
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	53                   	push   %ebx
  801382:	50                   	push   %eax
  801383:	68 2c 24 80 00       	push   $0x80242c
  801388:	e8 29 ef ff ff       	call   8002b6 <cprintf>
		return -E_INVAL;
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801395:	eb da                	jmp    801371 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801397:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139c:	eb d3                	jmp    801371 <ftruncate+0x52>

0080139e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	53                   	push   %ebx
  8013a2:	83 ec 14             	sub    $0x14,%esp
  8013a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ab:	50                   	push   %eax
  8013ac:	ff 75 08             	pushl  0x8(%ebp)
  8013af:	e8 81 fb ff ff       	call   800f35 <fd_lookup>
  8013b4:	83 c4 08             	add    $0x8,%esp
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	78 4b                	js     801406 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013bb:	83 ec 08             	sub    $0x8,%esp
  8013be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c1:	50                   	push   %eax
  8013c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c5:	ff 30                	pushl  (%eax)
  8013c7:	e8 bf fb ff ff       	call   800f8b <dev_lookup>
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	78 33                	js     801406 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013da:	74 2f                	je     80140b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013dc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013df:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013e6:	00 00 00 
	stat->st_isdir = 0;
  8013e9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013f0:	00 00 00 
	stat->st_dev = dev;
  8013f3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013f9:	83 ec 08             	sub    $0x8,%esp
  8013fc:	53                   	push   %ebx
  8013fd:	ff 75 f0             	pushl  -0x10(%ebp)
  801400:	ff 50 14             	call   *0x14(%eax)
  801403:	83 c4 10             	add    $0x10,%esp
}
  801406:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801409:	c9                   	leave  
  80140a:	c3                   	ret    
		return -E_NOT_SUPP;
  80140b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801410:	eb f4                	jmp    801406 <fstat+0x68>

00801412 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	56                   	push   %esi
  801416:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801417:	83 ec 08             	sub    $0x8,%esp
  80141a:	6a 00                	push   $0x0
  80141c:	ff 75 08             	pushl  0x8(%ebp)
  80141f:	e8 30 02 00 00       	call   801654 <open>
  801424:	89 c3                	mov    %eax,%ebx
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	85 c0                	test   %eax,%eax
  80142b:	78 1b                	js     801448 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80142d:	83 ec 08             	sub    $0x8,%esp
  801430:	ff 75 0c             	pushl  0xc(%ebp)
  801433:	50                   	push   %eax
  801434:	e8 65 ff ff ff       	call   80139e <fstat>
  801439:	89 c6                	mov    %eax,%esi
	close(fd);
  80143b:	89 1c 24             	mov    %ebx,(%esp)
  80143e:	e8 27 fc ff ff       	call   80106a <close>
	return r;
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	89 f3                	mov    %esi,%ebx
}
  801448:	89 d8                	mov    %ebx,%eax
  80144a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80144d:	5b                   	pop    %ebx
  80144e:	5e                   	pop    %esi
  80144f:	5d                   	pop    %ebp
  801450:	c3                   	ret    

00801451 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	56                   	push   %esi
  801455:	53                   	push   %ebx
  801456:	89 c6                	mov    %eax,%esi
  801458:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80145a:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801461:	74 27                	je     80148a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801463:	6a 07                	push   $0x7
  801465:	68 00 50 80 00       	push   $0x805000
  80146a:	56                   	push   %esi
  80146b:	ff 35 04 40 80 00    	pushl  0x804004
  801471:	e8 cb 08 00 00       	call   801d41 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801476:	83 c4 0c             	add    $0xc,%esp
  801479:	6a 00                	push   $0x0
  80147b:	53                   	push   %ebx
  80147c:	6a 00                	push   $0x0
  80147e:	e8 55 08 00 00       	call   801cd8 <ipc_recv>
}
  801483:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801486:	5b                   	pop    %ebx
  801487:	5e                   	pop    %esi
  801488:	5d                   	pop    %ebp
  801489:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80148a:	83 ec 0c             	sub    $0xc,%esp
  80148d:	6a 01                	push   $0x1
  80148f:	e8 01 09 00 00       	call   801d95 <ipc_find_env>
  801494:	a3 04 40 80 00       	mov    %eax,0x804004
  801499:	83 c4 10             	add    $0x10,%esp
  80149c:	eb c5                	jmp    801463 <fsipc+0x12>

0080149e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8014aa:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b2:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014bc:	b8 02 00 00 00       	mov    $0x2,%eax
  8014c1:	e8 8b ff ff ff       	call   801451 <fsipc>
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <devfile_flush>:
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8014d4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8014de:	b8 06 00 00 00       	mov    $0x6,%eax
  8014e3:	e8 69 ff ff ff       	call   801451 <fsipc>
}
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <devfile_stat>:
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	53                   	push   %ebx
  8014ee:	83 ec 04             	sub    $0x4,%esp
  8014f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8014fa:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801504:	b8 05 00 00 00       	mov    $0x5,%eax
  801509:	e8 43 ff ff ff       	call   801451 <fsipc>
  80150e:	85 c0                	test   %eax,%eax
  801510:	78 2c                	js     80153e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801512:	83 ec 08             	sub    $0x8,%esp
  801515:	68 00 50 80 00       	push   $0x805000
  80151a:	53                   	push   %ebx
  80151b:	e8 b5 f3 ff ff       	call   8008d5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801520:	a1 80 50 80 00       	mov    0x805080,%eax
  801525:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80152b:	a1 84 50 80 00       	mov    0x805084,%eax
  801530:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801536:	83 c4 10             	add    $0x10,%esp
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <devfile_write>:
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	53                   	push   %ebx
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  80154d:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801553:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801558:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	8b 40 0c             	mov    0xc(%eax),%eax
  801561:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801566:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80156c:	53                   	push   %ebx
  80156d:	ff 75 0c             	pushl  0xc(%ebp)
  801570:	68 08 50 80 00       	push   $0x805008
  801575:	e8 e9 f4 ff ff       	call   800a63 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80157a:	ba 00 00 00 00       	mov    $0x0,%edx
  80157f:	b8 04 00 00 00       	mov    $0x4,%eax
  801584:	e8 c8 fe ff ff       	call   801451 <fsipc>
  801589:	83 c4 10             	add    $0x10,%esp
  80158c:	85 c0                	test   %eax,%eax
  80158e:	78 0b                	js     80159b <devfile_write+0x58>
	assert(r <= n);
  801590:	39 d8                	cmp    %ebx,%eax
  801592:	77 0c                	ja     8015a0 <devfile_write+0x5d>
	assert(r <= PGSIZE);
  801594:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801599:	7f 1e                	jg     8015b9 <devfile_write+0x76>
}
  80159b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    
	assert(r <= n);
  8015a0:	68 9c 24 80 00       	push   $0x80249c
  8015a5:	68 a3 24 80 00       	push   $0x8024a3
  8015aa:	68 98 00 00 00       	push   $0x98
  8015af:	68 b8 24 80 00       	push   $0x8024b8
  8015b4:	e8 22 ec ff ff       	call   8001db <_panic>
	assert(r <= PGSIZE);
  8015b9:	68 c3 24 80 00       	push   $0x8024c3
  8015be:	68 a3 24 80 00       	push   $0x8024a3
  8015c3:	68 99 00 00 00       	push   $0x99
  8015c8:	68 b8 24 80 00       	push   $0x8024b8
  8015cd:	e8 09 ec ff ff       	call   8001db <_panic>

008015d2 <devfile_read>:
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	56                   	push   %esi
  8015d6:	53                   	push   %ebx
  8015d7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015e5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8015f5:	e8 57 fe ff ff       	call   801451 <fsipc>
  8015fa:	89 c3                	mov    %eax,%ebx
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	78 1f                	js     80161f <devfile_read+0x4d>
	assert(r <= n);
  801600:	39 f0                	cmp    %esi,%eax
  801602:	77 24                	ja     801628 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801604:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801609:	7f 33                	jg     80163e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80160b:	83 ec 04             	sub    $0x4,%esp
  80160e:	50                   	push   %eax
  80160f:	68 00 50 80 00       	push   $0x805000
  801614:	ff 75 0c             	pushl  0xc(%ebp)
  801617:	e8 47 f4 ff ff       	call   800a63 <memmove>
	return r;
  80161c:	83 c4 10             	add    $0x10,%esp
}
  80161f:	89 d8                	mov    %ebx,%eax
  801621:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801624:	5b                   	pop    %ebx
  801625:	5e                   	pop    %esi
  801626:	5d                   	pop    %ebp
  801627:	c3                   	ret    
	assert(r <= n);
  801628:	68 9c 24 80 00       	push   $0x80249c
  80162d:	68 a3 24 80 00       	push   $0x8024a3
  801632:	6a 7c                	push   $0x7c
  801634:	68 b8 24 80 00       	push   $0x8024b8
  801639:	e8 9d eb ff ff       	call   8001db <_panic>
	assert(r <= PGSIZE);
  80163e:	68 c3 24 80 00       	push   $0x8024c3
  801643:	68 a3 24 80 00       	push   $0x8024a3
  801648:	6a 7d                	push   $0x7d
  80164a:	68 b8 24 80 00       	push   $0x8024b8
  80164f:	e8 87 eb ff ff       	call   8001db <_panic>

00801654 <open>:
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	56                   	push   %esi
  801658:	53                   	push   %ebx
  801659:	83 ec 1c             	sub    $0x1c,%esp
  80165c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80165f:	56                   	push   %esi
  801660:	e8 39 f2 ff ff       	call   80089e <strlen>
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80166d:	7f 6c                	jg     8016db <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80166f:	83 ec 0c             	sub    $0xc,%esp
  801672:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801675:	50                   	push   %eax
  801676:	e8 6b f8 ff ff       	call   800ee6 <fd_alloc>
  80167b:	89 c3                	mov    %eax,%ebx
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	85 c0                	test   %eax,%eax
  801682:	78 3c                	js     8016c0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801684:	83 ec 08             	sub    $0x8,%esp
  801687:	56                   	push   %esi
  801688:	68 00 50 80 00       	push   $0x805000
  80168d:	e8 43 f2 ff ff       	call   8008d5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80169a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169d:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a2:	e8 aa fd ff ff       	call   801451 <fsipc>
  8016a7:	89 c3                	mov    %eax,%ebx
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	78 19                	js     8016c9 <open+0x75>
	return fd2num(fd);
  8016b0:	83 ec 0c             	sub    $0xc,%esp
  8016b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8016b6:	e8 04 f8 ff ff       	call   800ebf <fd2num>
  8016bb:	89 c3                	mov    %eax,%ebx
  8016bd:	83 c4 10             	add    $0x10,%esp
}
  8016c0:	89 d8                	mov    %ebx,%eax
  8016c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c5:	5b                   	pop    %ebx
  8016c6:	5e                   	pop    %esi
  8016c7:	5d                   	pop    %ebp
  8016c8:	c3                   	ret    
		fd_close(fd, 0);
  8016c9:	83 ec 08             	sub    $0x8,%esp
  8016cc:	6a 00                	push   $0x0
  8016ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d1:	e8 0b f9 ff ff       	call   800fe1 <fd_close>
		return r;
  8016d6:	83 c4 10             	add    $0x10,%esp
  8016d9:	eb e5                	jmp    8016c0 <open+0x6c>
		return -E_BAD_PATH;
  8016db:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016e0:	eb de                	jmp    8016c0 <open+0x6c>

008016e2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ed:	b8 08 00 00 00       	mov    $0x8,%eax
  8016f2:	e8 5a fd ff ff       	call   801451 <fsipc>
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8016f9:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8016fd:	7e 38                	jle    801737 <writebuf+0x3e>
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	53                   	push   %ebx
  801703:	83 ec 08             	sub    $0x8,%esp
  801706:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801708:	ff 70 04             	pushl  0x4(%eax)
  80170b:	8d 40 10             	lea    0x10(%eax),%eax
  80170e:	50                   	push   %eax
  80170f:	ff 33                	pushl  (%ebx)
  801711:	e8 5e fb ff ff       	call   801274 <write>
		if (result > 0)
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	85 c0                	test   %eax,%eax
  80171b:	7e 03                	jle    801720 <writebuf+0x27>
			b->result += result;
  80171d:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801720:	39 43 04             	cmp    %eax,0x4(%ebx)
  801723:	74 0d                	je     801732 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  801725:	85 c0                	test   %eax,%eax
  801727:	ba 00 00 00 00       	mov    $0x0,%edx
  80172c:	0f 4f c2             	cmovg  %edx,%eax
  80172f:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801732:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801735:	c9                   	leave  
  801736:	c3                   	ret    
  801737:	f3 c3                	repz ret 

00801739 <putch>:

static void
putch(int ch, void *thunk)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	53                   	push   %ebx
  80173d:	83 ec 04             	sub    $0x4,%esp
  801740:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801743:	8b 53 04             	mov    0x4(%ebx),%edx
  801746:	8d 42 01             	lea    0x1(%edx),%eax
  801749:	89 43 04             	mov    %eax,0x4(%ebx)
  80174c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80174f:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801753:	3d 00 01 00 00       	cmp    $0x100,%eax
  801758:	74 06                	je     801760 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  80175a:	83 c4 04             	add    $0x4,%esp
  80175d:	5b                   	pop    %ebx
  80175e:	5d                   	pop    %ebp
  80175f:	c3                   	ret    
		writebuf(b);
  801760:	89 d8                	mov    %ebx,%eax
  801762:	e8 92 ff ff ff       	call   8016f9 <writebuf>
		b->idx = 0;
  801767:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  80176e:	eb ea                	jmp    80175a <putch+0x21>

00801770 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801782:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801789:	00 00 00 
	b.result = 0;
  80178c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801793:	00 00 00 
	b.error = 1;
  801796:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  80179d:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8017a0:	ff 75 10             	pushl  0x10(%ebp)
  8017a3:	ff 75 0c             	pushl  0xc(%ebp)
  8017a6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8017ac:	50                   	push   %eax
  8017ad:	68 39 17 80 00       	push   $0x801739
  8017b2:	e8 fc eb ff ff       	call   8003b3 <vprintfmt>
	if (b.idx > 0)
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8017c1:	7f 11                	jg     8017d4 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8017c3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    
		writebuf(&b);
  8017d4:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8017da:	e8 1a ff ff ff       	call   8016f9 <writebuf>
  8017df:	eb e2                	jmp    8017c3 <vfprintf+0x53>

008017e1 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8017e7:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8017ea:	50                   	push   %eax
  8017eb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ee:	ff 75 08             	pushl  0x8(%ebp)
  8017f1:	e8 7a ff ff ff       	call   801770 <vfprintf>
	va_end(ap);

	return cnt;
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <printf>:

int
printf(const char *fmt, ...)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8017fe:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801801:	50                   	push   %eax
  801802:	ff 75 08             	pushl  0x8(%ebp)
  801805:	6a 01                	push   $0x1
  801807:	e8 64 ff ff ff       	call   801770 <vfprintf>
	va_end(ap);

	return cnt;
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	56                   	push   %esi
  801812:	53                   	push   %ebx
  801813:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801816:	83 ec 0c             	sub    $0xc,%esp
  801819:	ff 75 08             	pushl  0x8(%ebp)
  80181c:	e8 ae f6 ff ff       	call   800ecf <fd2data>
  801821:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801823:	83 c4 08             	add    $0x8,%esp
  801826:	68 cf 24 80 00       	push   $0x8024cf
  80182b:	53                   	push   %ebx
  80182c:	e8 a4 f0 ff ff       	call   8008d5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801831:	8b 46 04             	mov    0x4(%esi),%eax
  801834:	2b 06                	sub    (%esi),%eax
  801836:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80183c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801843:	00 00 00 
	stat->st_dev = &devpipe;
  801846:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  80184d:	30 80 00 
	return 0;
}
  801850:	b8 00 00 00 00       	mov    $0x0,%eax
  801855:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801858:	5b                   	pop    %ebx
  801859:	5e                   	pop    %esi
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    

0080185c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	53                   	push   %ebx
  801860:	83 ec 0c             	sub    $0xc,%esp
  801863:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801866:	53                   	push   %ebx
  801867:	6a 00                	push   $0x0
  801869:	e8 e5 f4 ff ff       	call   800d53 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80186e:	89 1c 24             	mov    %ebx,(%esp)
  801871:	e8 59 f6 ff ff       	call   800ecf <fd2data>
  801876:	83 c4 08             	add    $0x8,%esp
  801879:	50                   	push   %eax
  80187a:	6a 00                	push   $0x0
  80187c:	e8 d2 f4 ff ff       	call   800d53 <sys_page_unmap>
}
  801881:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <_pipeisclosed>:
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	57                   	push   %edi
  80188a:	56                   	push   %esi
  80188b:	53                   	push   %ebx
  80188c:	83 ec 1c             	sub    $0x1c,%esp
  80188f:	89 c7                	mov    %eax,%edi
  801891:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801893:	a1 08 40 80 00       	mov    0x804008,%eax
  801898:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80189b:	83 ec 0c             	sub    $0xc,%esp
  80189e:	57                   	push   %edi
  80189f:	e8 2a 05 00 00       	call   801dce <pageref>
  8018a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018a7:	89 34 24             	mov    %esi,(%esp)
  8018aa:	e8 1f 05 00 00       	call   801dce <pageref>
		nn = thisenv->env_runs;
  8018af:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8018b5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	39 cb                	cmp    %ecx,%ebx
  8018bd:	74 1b                	je     8018da <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8018bf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018c2:	75 cf                	jne    801893 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8018c4:	8b 42 58             	mov    0x58(%edx),%eax
  8018c7:	6a 01                	push   $0x1
  8018c9:	50                   	push   %eax
  8018ca:	53                   	push   %ebx
  8018cb:	68 d6 24 80 00       	push   $0x8024d6
  8018d0:	e8 e1 e9 ff ff       	call   8002b6 <cprintf>
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	eb b9                	jmp    801893 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8018da:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018dd:	0f 94 c0             	sete   %al
  8018e0:	0f b6 c0             	movzbl %al,%eax
}
  8018e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018e6:	5b                   	pop    %ebx
  8018e7:	5e                   	pop    %esi
  8018e8:	5f                   	pop    %edi
  8018e9:	5d                   	pop    %ebp
  8018ea:	c3                   	ret    

008018eb <devpipe_write>:
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	57                   	push   %edi
  8018ef:	56                   	push   %esi
  8018f0:	53                   	push   %ebx
  8018f1:	83 ec 28             	sub    $0x28,%esp
  8018f4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8018f7:	56                   	push   %esi
  8018f8:	e8 d2 f5 ff ff       	call   800ecf <fd2data>
  8018fd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018ff:	83 c4 10             	add    $0x10,%esp
  801902:	bf 00 00 00 00       	mov    $0x0,%edi
  801907:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80190a:	74 4f                	je     80195b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80190c:	8b 43 04             	mov    0x4(%ebx),%eax
  80190f:	8b 0b                	mov    (%ebx),%ecx
  801911:	8d 51 20             	lea    0x20(%ecx),%edx
  801914:	39 d0                	cmp    %edx,%eax
  801916:	72 14                	jb     80192c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801918:	89 da                	mov    %ebx,%edx
  80191a:	89 f0                	mov    %esi,%eax
  80191c:	e8 65 ff ff ff       	call   801886 <_pipeisclosed>
  801921:	85 c0                	test   %eax,%eax
  801923:	75 3a                	jne    80195f <devpipe_write+0x74>
			sys_yield();
  801925:	e8 85 f3 ff ff       	call   800caf <sys_yield>
  80192a:	eb e0                	jmp    80190c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80192c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80192f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801933:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801936:	89 c2                	mov    %eax,%edx
  801938:	c1 fa 1f             	sar    $0x1f,%edx
  80193b:	89 d1                	mov    %edx,%ecx
  80193d:	c1 e9 1b             	shr    $0x1b,%ecx
  801940:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801943:	83 e2 1f             	and    $0x1f,%edx
  801946:	29 ca                	sub    %ecx,%edx
  801948:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80194c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801950:	83 c0 01             	add    $0x1,%eax
  801953:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801956:	83 c7 01             	add    $0x1,%edi
  801959:	eb ac                	jmp    801907 <devpipe_write+0x1c>
	return i;
  80195b:	89 f8                	mov    %edi,%eax
  80195d:	eb 05                	jmp    801964 <devpipe_write+0x79>
				return 0;
  80195f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801964:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801967:	5b                   	pop    %ebx
  801968:	5e                   	pop    %esi
  801969:	5f                   	pop    %edi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    

0080196c <devpipe_read>:
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	57                   	push   %edi
  801970:	56                   	push   %esi
  801971:	53                   	push   %ebx
  801972:	83 ec 18             	sub    $0x18,%esp
  801975:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801978:	57                   	push   %edi
  801979:	e8 51 f5 ff ff       	call   800ecf <fd2data>
  80197e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801980:	83 c4 10             	add    $0x10,%esp
  801983:	be 00 00 00 00       	mov    $0x0,%esi
  801988:	3b 75 10             	cmp    0x10(%ebp),%esi
  80198b:	74 47                	je     8019d4 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  80198d:	8b 03                	mov    (%ebx),%eax
  80198f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801992:	75 22                	jne    8019b6 <devpipe_read+0x4a>
			if (i > 0)
  801994:	85 f6                	test   %esi,%esi
  801996:	75 14                	jne    8019ac <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801998:	89 da                	mov    %ebx,%edx
  80199a:	89 f8                	mov    %edi,%eax
  80199c:	e8 e5 fe ff ff       	call   801886 <_pipeisclosed>
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	75 33                	jne    8019d8 <devpipe_read+0x6c>
			sys_yield();
  8019a5:	e8 05 f3 ff ff       	call   800caf <sys_yield>
  8019aa:	eb e1                	jmp    80198d <devpipe_read+0x21>
				return i;
  8019ac:	89 f0                	mov    %esi,%eax
}
  8019ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019b1:	5b                   	pop    %ebx
  8019b2:	5e                   	pop    %esi
  8019b3:	5f                   	pop    %edi
  8019b4:	5d                   	pop    %ebp
  8019b5:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8019b6:	99                   	cltd   
  8019b7:	c1 ea 1b             	shr    $0x1b,%edx
  8019ba:	01 d0                	add    %edx,%eax
  8019bc:	83 e0 1f             	and    $0x1f,%eax
  8019bf:	29 d0                	sub    %edx,%eax
  8019c1:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8019c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019c9:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8019cc:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8019cf:	83 c6 01             	add    $0x1,%esi
  8019d2:	eb b4                	jmp    801988 <devpipe_read+0x1c>
	return i;
  8019d4:	89 f0                	mov    %esi,%eax
  8019d6:	eb d6                	jmp    8019ae <devpipe_read+0x42>
				return 0;
  8019d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019dd:	eb cf                	jmp    8019ae <devpipe_read+0x42>

008019df <pipe>:
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	56                   	push   %esi
  8019e3:	53                   	push   %ebx
  8019e4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8019e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ea:	50                   	push   %eax
  8019eb:	e8 f6 f4 ff ff       	call   800ee6 <fd_alloc>
  8019f0:	89 c3                	mov    %eax,%ebx
  8019f2:	83 c4 10             	add    $0x10,%esp
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	78 5b                	js     801a54 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019f9:	83 ec 04             	sub    $0x4,%esp
  8019fc:	68 07 04 00 00       	push   $0x407
  801a01:	ff 75 f4             	pushl  -0xc(%ebp)
  801a04:	6a 00                	push   $0x0
  801a06:	e8 c3 f2 ff ff       	call   800cce <sys_page_alloc>
  801a0b:	89 c3                	mov    %eax,%ebx
  801a0d:	83 c4 10             	add    $0x10,%esp
  801a10:	85 c0                	test   %eax,%eax
  801a12:	78 40                	js     801a54 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801a14:	83 ec 0c             	sub    $0xc,%esp
  801a17:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a1a:	50                   	push   %eax
  801a1b:	e8 c6 f4 ff ff       	call   800ee6 <fd_alloc>
  801a20:	89 c3                	mov    %eax,%ebx
  801a22:	83 c4 10             	add    $0x10,%esp
  801a25:	85 c0                	test   %eax,%eax
  801a27:	78 1b                	js     801a44 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a29:	83 ec 04             	sub    $0x4,%esp
  801a2c:	68 07 04 00 00       	push   $0x407
  801a31:	ff 75 f0             	pushl  -0x10(%ebp)
  801a34:	6a 00                	push   $0x0
  801a36:	e8 93 f2 ff ff       	call   800cce <sys_page_alloc>
  801a3b:	89 c3                	mov    %eax,%ebx
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	85 c0                	test   %eax,%eax
  801a42:	79 19                	jns    801a5d <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801a44:	83 ec 08             	sub    $0x8,%esp
  801a47:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4a:	6a 00                	push   $0x0
  801a4c:	e8 02 f3 ff ff       	call   800d53 <sys_page_unmap>
  801a51:	83 c4 10             	add    $0x10,%esp
}
  801a54:	89 d8                	mov    %ebx,%eax
  801a56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a59:	5b                   	pop    %ebx
  801a5a:	5e                   	pop    %esi
  801a5b:	5d                   	pop    %ebp
  801a5c:	c3                   	ret    
	va = fd2data(fd0);
  801a5d:	83 ec 0c             	sub    $0xc,%esp
  801a60:	ff 75 f4             	pushl  -0xc(%ebp)
  801a63:	e8 67 f4 ff ff       	call   800ecf <fd2data>
  801a68:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a6a:	83 c4 0c             	add    $0xc,%esp
  801a6d:	68 07 04 00 00       	push   $0x407
  801a72:	50                   	push   %eax
  801a73:	6a 00                	push   $0x0
  801a75:	e8 54 f2 ff ff       	call   800cce <sys_page_alloc>
  801a7a:	89 c3                	mov    %eax,%ebx
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	0f 88 8c 00 00 00    	js     801b13 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a87:	83 ec 0c             	sub    $0xc,%esp
  801a8a:	ff 75 f0             	pushl  -0x10(%ebp)
  801a8d:	e8 3d f4 ff ff       	call   800ecf <fd2data>
  801a92:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a99:	50                   	push   %eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	56                   	push   %esi
  801a9d:	6a 00                	push   $0x0
  801a9f:	e8 6d f2 ff ff       	call   800d11 <sys_page_map>
  801aa4:	89 c3                	mov    %eax,%ebx
  801aa6:	83 c4 20             	add    $0x20,%esp
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	78 58                	js     801b05 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab0:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801ab6:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac5:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801acb:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ad7:	83 ec 0c             	sub    $0xc,%esp
  801ada:	ff 75 f4             	pushl  -0xc(%ebp)
  801add:	e8 dd f3 ff ff       	call   800ebf <fd2num>
  801ae2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ae5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ae7:	83 c4 04             	add    $0x4,%esp
  801aea:	ff 75 f0             	pushl  -0x10(%ebp)
  801aed:	e8 cd f3 ff ff       	call   800ebf <fd2num>
  801af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801af8:	83 c4 10             	add    $0x10,%esp
  801afb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b00:	e9 4f ff ff ff       	jmp    801a54 <pipe+0x75>
	sys_page_unmap(0, va);
  801b05:	83 ec 08             	sub    $0x8,%esp
  801b08:	56                   	push   %esi
  801b09:	6a 00                	push   $0x0
  801b0b:	e8 43 f2 ff ff       	call   800d53 <sys_page_unmap>
  801b10:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801b13:	83 ec 08             	sub    $0x8,%esp
  801b16:	ff 75 f0             	pushl  -0x10(%ebp)
  801b19:	6a 00                	push   $0x0
  801b1b:	e8 33 f2 ff ff       	call   800d53 <sys_page_unmap>
  801b20:	83 c4 10             	add    $0x10,%esp
  801b23:	e9 1c ff ff ff       	jmp    801a44 <pipe+0x65>

00801b28 <pipeisclosed>:
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b31:	50                   	push   %eax
  801b32:	ff 75 08             	pushl  0x8(%ebp)
  801b35:	e8 fb f3 ff ff       	call   800f35 <fd_lookup>
  801b3a:	83 c4 10             	add    $0x10,%esp
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	78 18                	js     801b59 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801b41:	83 ec 0c             	sub    $0xc,%esp
  801b44:	ff 75 f4             	pushl  -0xc(%ebp)
  801b47:	e8 83 f3 ff ff       	call   800ecf <fd2data>
	return _pipeisclosed(fd, p);
  801b4c:	89 c2                	mov    %eax,%edx
  801b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b51:	e8 30 fd ff ff       	call   801886 <_pipeisclosed>
  801b56:	83 c4 10             	add    $0x10,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b63:	5d                   	pop    %ebp
  801b64:	c3                   	ret    

00801b65 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801b6b:	68 ee 24 80 00       	push   $0x8024ee
  801b70:	ff 75 0c             	pushl  0xc(%ebp)
  801b73:	e8 5d ed ff ff       	call   8008d5 <strcpy>
	return 0;
}
  801b78:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <devcons_write>:
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	57                   	push   %edi
  801b83:	56                   	push   %esi
  801b84:	53                   	push   %ebx
  801b85:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b8b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b90:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801b96:	eb 2f                	jmp    801bc7 <devcons_write+0x48>
		m = n - tot;
  801b98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b9b:	29 f3                	sub    %esi,%ebx
  801b9d:	83 fb 7f             	cmp    $0x7f,%ebx
  801ba0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ba5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ba8:	83 ec 04             	sub    $0x4,%esp
  801bab:	53                   	push   %ebx
  801bac:	89 f0                	mov    %esi,%eax
  801bae:	03 45 0c             	add    0xc(%ebp),%eax
  801bb1:	50                   	push   %eax
  801bb2:	57                   	push   %edi
  801bb3:	e8 ab ee ff ff       	call   800a63 <memmove>
		sys_cputs(buf, m);
  801bb8:	83 c4 08             	add    $0x8,%esp
  801bbb:	53                   	push   %ebx
  801bbc:	57                   	push   %edi
  801bbd:	e8 50 f0 ff ff       	call   800c12 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801bc2:	01 de                	add    %ebx,%esi
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bca:	72 cc                	jb     801b98 <devcons_write+0x19>
}
  801bcc:	89 f0                	mov    %esi,%eax
  801bce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bd1:	5b                   	pop    %ebx
  801bd2:	5e                   	pop    %esi
  801bd3:	5f                   	pop    %edi
  801bd4:	5d                   	pop    %ebp
  801bd5:	c3                   	ret    

00801bd6 <devcons_read>:
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 08             	sub    $0x8,%esp
  801bdc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801be1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801be5:	75 07                	jne    801bee <devcons_read+0x18>
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    
		sys_yield();
  801be9:	e8 c1 f0 ff ff       	call   800caf <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801bee:	e8 3d f0 ff ff       	call   800c30 <sys_cgetc>
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	74 f2                	je     801be9 <devcons_read+0x13>
	if (c < 0)
  801bf7:	85 c0                	test   %eax,%eax
  801bf9:	78 ec                	js     801be7 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801bfb:	83 f8 04             	cmp    $0x4,%eax
  801bfe:	74 0c                	je     801c0c <devcons_read+0x36>
	*(char*)vbuf = c;
  801c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c03:	88 02                	mov    %al,(%edx)
	return 1;
  801c05:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0a:	eb db                	jmp    801be7 <devcons_read+0x11>
		return 0;
  801c0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c11:	eb d4                	jmp    801be7 <devcons_read+0x11>

00801c13 <cputchar>:
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801c1f:	6a 01                	push   $0x1
  801c21:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c24:	50                   	push   %eax
  801c25:	e8 e8 ef ff ff       	call   800c12 <sys_cputs>
}
  801c2a:	83 c4 10             	add    $0x10,%esp
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <getchar>:
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801c35:	6a 01                	push   $0x1
  801c37:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c3a:	50                   	push   %eax
  801c3b:	6a 00                	push   $0x0
  801c3d:	e8 64 f5 ff ff       	call   8011a6 <read>
	if (r < 0)
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	85 c0                	test   %eax,%eax
  801c47:	78 08                	js     801c51 <getchar+0x22>
	if (r < 1)
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	7e 06                	jle    801c53 <getchar+0x24>
	return c;
  801c4d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    
		return -E_EOF;
  801c53:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801c58:	eb f7                	jmp    801c51 <getchar+0x22>

00801c5a <iscons>:
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c63:	50                   	push   %eax
  801c64:	ff 75 08             	pushl  0x8(%ebp)
  801c67:	e8 c9 f2 ff ff       	call   800f35 <fd_lookup>
  801c6c:	83 c4 10             	add    $0x10,%esp
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	78 11                	js     801c84 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c76:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801c7c:	39 10                	cmp    %edx,(%eax)
  801c7e:	0f 94 c0             	sete   %al
  801c81:	0f b6 c0             	movzbl %al,%eax
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <opencons>:
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c8f:	50                   	push   %eax
  801c90:	e8 51 f2 ff ff       	call   800ee6 <fd_alloc>
  801c95:	83 c4 10             	add    $0x10,%esp
  801c98:	85 c0                	test   %eax,%eax
  801c9a:	78 3a                	js     801cd6 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c9c:	83 ec 04             	sub    $0x4,%esp
  801c9f:	68 07 04 00 00       	push   $0x407
  801ca4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca7:	6a 00                	push   $0x0
  801ca9:	e8 20 f0 ff ff       	call   800cce <sys_page_alloc>
  801cae:	83 c4 10             	add    $0x10,%esp
  801cb1:	85 c0                	test   %eax,%eax
  801cb3:	78 21                	js     801cd6 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb8:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801cbe:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801cca:	83 ec 0c             	sub    $0xc,%esp
  801ccd:	50                   	push   %eax
  801cce:	e8 ec f1 ff ff       	call   800ebf <fd2num>
  801cd3:	83 c4 10             	add    $0x10,%esp
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	56                   	push   %esi
  801cdc:	53                   	push   %ebx
  801cdd:	8b 75 08             	mov    0x8(%ebp),%esi
  801ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801ce6:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  801ce8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801ced:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  801cf0:	83 ec 0c             	sub    $0xc,%esp
  801cf3:	50                   	push   %eax
  801cf4:	e8 85 f1 ff ff       	call   800e7e <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  801cf9:	83 c4 10             	add    $0x10,%esp
  801cfc:	85 c0                	test   %eax,%eax
  801cfe:	78 2b                	js     801d2b <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  801d00:	85 f6                	test   %esi,%esi
  801d02:	74 0a                	je     801d0e <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801d04:	a1 08 40 80 00       	mov    0x804008,%eax
  801d09:	8b 40 74             	mov    0x74(%eax),%eax
  801d0c:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  801d0e:	85 db                	test   %ebx,%ebx
  801d10:	74 0a                	je     801d1c <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801d12:	a1 08 40 80 00       	mov    0x804008,%eax
  801d17:	8b 40 78             	mov    0x78(%eax),%eax
  801d1a:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801d1c:	a1 08 40 80 00       	mov    0x804008,%eax
  801d21:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d27:	5b                   	pop    %ebx
  801d28:	5e                   	pop    %esi
  801d29:	5d                   	pop    %ebp
  801d2a:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  801d2b:	85 f6                	test   %esi,%esi
  801d2d:	74 06                	je     801d35 <ipc_recv+0x5d>
  801d2f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801d35:	85 db                	test   %ebx,%ebx
  801d37:	74 eb                	je     801d24 <ipc_recv+0x4c>
  801d39:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d3f:	eb e3                	jmp    801d24 <ipc_recv+0x4c>

00801d41 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	57                   	push   %edi
  801d45:	56                   	push   %esi
  801d46:	53                   	push   %ebx
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d4d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d50:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801d53:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  801d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801d5a:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801d5d:	ff 75 14             	pushl  0x14(%ebp)
  801d60:	53                   	push   %ebx
  801d61:	56                   	push   %esi
  801d62:	57                   	push   %edi
  801d63:	e8 f3 f0 ff ff       	call   800e5b <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  801d68:	83 c4 10             	add    $0x10,%esp
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	74 1e                	je     801d8d <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  801d6f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d72:	75 07                	jne    801d7b <ipc_send+0x3a>
			sys_yield();
  801d74:	e8 36 ef ff ff       	call   800caf <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801d79:	eb e2                	jmp    801d5d <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  801d7b:	50                   	push   %eax
  801d7c:	68 fa 24 80 00       	push   $0x8024fa
  801d81:	6a 41                	push   $0x41
  801d83:	68 08 25 80 00       	push   $0x802508
  801d88:	e8 4e e4 ff ff       	call   8001db <_panic>
		}
	}
}
  801d8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d90:	5b                   	pop    %ebx
  801d91:	5e                   	pop    %esi
  801d92:	5f                   	pop    %edi
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    

00801d95 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801da0:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801da3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801da9:	8b 52 50             	mov    0x50(%edx),%edx
  801dac:	39 ca                	cmp    %ecx,%edx
  801dae:	74 11                	je     801dc1 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801db0:	83 c0 01             	add    $0x1,%eax
  801db3:	3d 00 04 00 00       	cmp    $0x400,%eax
  801db8:	75 e6                	jne    801da0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbf:	eb 0b                	jmp    801dcc <ipc_find_env+0x37>
			return envs[i].env_id;
  801dc1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801dc4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801dc9:	8b 40 48             	mov    0x48(%eax),%eax
}
  801dcc:	5d                   	pop    %ebp
  801dcd:	c3                   	ret    

00801dce <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801dd4:	89 d0                	mov    %edx,%eax
  801dd6:	c1 e8 16             	shr    $0x16,%eax
  801dd9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801de5:	f6 c1 01             	test   $0x1,%cl
  801de8:	74 1d                	je     801e07 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801dea:	c1 ea 0c             	shr    $0xc,%edx
  801ded:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801df4:	f6 c2 01             	test   $0x1,%dl
  801df7:	74 0e                	je     801e07 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801df9:	c1 ea 0c             	shr    $0xc,%edx
  801dfc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e03:	ef 
  801e04:	0f b7 c0             	movzwl %ax,%eax
}
  801e07:	5d                   	pop    %ebp
  801e08:	c3                   	ret    
  801e09:	66 90                	xchg   %ax,%ax
  801e0b:	66 90                	xchg   %ax,%ax
  801e0d:	66 90                	xchg   %ax,%ax
  801e0f:	90                   	nop

00801e10 <__udivdi3>:
  801e10:	55                   	push   %ebp
  801e11:	57                   	push   %edi
  801e12:	56                   	push   %esi
  801e13:	53                   	push   %ebx
  801e14:	83 ec 1c             	sub    $0x1c,%esp
  801e17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801e1b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801e1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e23:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801e27:	85 d2                	test   %edx,%edx
  801e29:	75 35                	jne    801e60 <__udivdi3+0x50>
  801e2b:	39 f3                	cmp    %esi,%ebx
  801e2d:	0f 87 bd 00 00 00    	ja     801ef0 <__udivdi3+0xe0>
  801e33:	85 db                	test   %ebx,%ebx
  801e35:	89 d9                	mov    %ebx,%ecx
  801e37:	75 0b                	jne    801e44 <__udivdi3+0x34>
  801e39:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3e:	31 d2                	xor    %edx,%edx
  801e40:	f7 f3                	div    %ebx
  801e42:	89 c1                	mov    %eax,%ecx
  801e44:	31 d2                	xor    %edx,%edx
  801e46:	89 f0                	mov    %esi,%eax
  801e48:	f7 f1                	div    %ecx
  801e4a:	89 c6                	mov    %eax,%esi
  801e4c:	89 e8                	mov    %ebp,%eax
  801e4e:	89 f7                	mov    %esi,%edi
  801e50:	f7 f1                	div    %ecx
  801e52:	89 fa                	mov    %edi,%edx
  801e54:	83 c4 1c             	add    $0x1c,%esp
  801e57:	5b                   	pop    %ebx
  801e58:	5e                   	pop    %esi
  801e59:	5f                   	pop    %edi
  801e5a:	5d                   	pop    %ebp
  801e5b:	c3                   	ret    
  801e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e60:	39 f2                	cmp    %esi,%edx
  801e62:	77 7c                	ja     801ee0 <__udivdi3+0xd0>
  801e64:	0f bd fa             	bsr    %edx,%edi
  801e67:	83 f7 1f             	xor    $0x1f,%edi
  801e6a:	0f 84 98 00 00 00    	je     801f08 <__udivdi3+0xf8>
  801e70:	89 f9                	mov    %edi,%ecx
  801e72:	b8 20 00 00 00       	mov    $0x20,%eax
  801e77:	29 f8                	sub    %edi,%eax
  801e79:	d3 e2                	shl    %cl,%edx
  801e7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e7f:	89 c1                	mov    %eax,%ecx
  801e81:	89 da                	mov    %ebx,%edx
  801e83:	d3 ea                	shr    %cl,%edx
  801e85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e89:	09 d1                	or     %edx,%ecx
  801e8b:	89 f2                	mov    %esi,%edx
  801e8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e91:	89 f9                	mov    %edi,%ecx
  801e93:	d3 e3                	shl    %cl,%ebx
  801e95:	89 c1                	mov    %eax,%ecx
  801e97:	d3 ea                	shr    %cl,%edx
  801e99:	89 f9                	mov    %edi,%ecx
  801e9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e9f:	d3 e6                	shl    %cl,%esi
  801ea1:	89 eb                	mov    %ebp,%ebx
  801ea3:	89 c1                	mov    %eax,%ecx
  801ea5:	d3 eb                	shr    %cl,%ebx
  801ea7:	09 de                	or     %ebx,%esi
  801ea9:	89 f0                	mov    %esi,%eax
  801eab:	f7 74 24 08          	divl   0x8(%esp)
  801eaf:	89 d6                	mov    %edx,%esi
  801eb1:	89 c3                	mov    %eax,%ebx
  801eb3:	f7 64 24 0c          	mull   0xc(%esp)
  801eb7:	39 d6                	cmp    %edx,%esi
  801eb9:	72 0c                	jb     801ec7 <__udivdi3+0xb7>
  801ebb:	89 f9                	mov    %edi,%ecx
  801ebd:	d3 e5                	shl    %cl,%ebp
  801ebf:	39 c5                	cmp    %eax,%ebp
  801ec1:	73 5d                	jae    801f20 <__udivdi3+0x110>
  801ec3:	39 d6                	cmp    %edx,%esi
  801ec5:	75 59                	jne    801f20 <__udivdi3+0x110>
  801ec7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801eca:	31 ff                	xor    %edi,%edi
  801ecc:	89 fa                	mov    %edi,%edx
  801ece:	83 c4 1c             	add    $0x1c,%esp
  801ed1:	5b                   	pop    %ebx
  801ed2:	5e                   	pop    %esi
  801ed3:	5f                   	pop    %edi
  801ed4:	5d                   	pop    %ebp
  801ed5:	c3                   	ret    
  801ed6:	8d 76 00             	lea    0x0(%esi),%esi
  801ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801ee0:	31 ff                	xor    %edi,%edi
  801ee2:	31 c0                	xor    %eax,%eax
  801ee4:	89 fa                	mov    %edi,%edx
  801ee6:	83 c4 1c             	add    $0x1c,%esp
  801ee9:	5b                   	pop    %ebx
  801eea:	5e                   	pop    %esi
  801eeb:	5f                   	pop    %edi
  801eec:	5d                   	pop    %ebp
  801eed:	c3                   	ret    
  801eee:	66 90                	xchg   %ax,%ax
  801ef0:	31 ff                	xor    %edi,%edi
  801ef2:	89 e8                	mov    %ebp,%eax
  801ef4:	89 f2                	mov    %esi,%edx
  801ef6:	f7 f3                	div    %ebx
  801ef8:	89 fa                	mov    %edi,%edx
  801efa:	83 c4 1c             	add    $0x1c,%esp
  801efd:	5b                   	pop    %ebx
  801efe:	5e                   	pop    %esi
  801eff:	5f                   	pop    %edi
  801f00:	5d                   	pop    %ebp
  801f01:	c3                   	ret    
  801f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f08:	39 f2                	cmp    %esi,%edx
  801f0a:	72 06                	jb     801f12 <__udivdi3+0x102>
  801f0c:	31 c0                	xor    %eax,%eax
  801f0e:	39 eb                	cmp    %ebp,%ebx
  801f10:	77 d2                	ja     801ee4 <__udivdi3+0xd4>
  801f12:	b8 01 00 00 00       	mov    $0x1,%eax
  801f17:	eb cb                	jmp    801ee4 <__udivdi3+0xd4>
  801f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f20:	89 d8                	mov    %ebx,%eax
  801f22:	31 ff                	xor    %edi,%edi
  801f24:	eb be                	jmp    801ee4 <__udivdi3+0xd4>
  801f26:	66 90                	xchg   %ax,%ax
  801f28:	66 90                	xchg   %ax,%ax
  801f2a:	66 90                	xchg   %ax,%ax
  801f2c:	66 90                	xchg   %ax,%ax
  801f2e:	66 90                	xchg   %ax,%ax

00801f30 <__umoddi3>:
  801f30:	55                   	push   %ebp
  801f31:	57                   	push   %edi
  801f32:	56                   	push   %esi
  801f33:	53                   	push   %ebx
  801f34:	83 ec 1c             	sub    $0x1c,%esp
  801f37:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801f3b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801f3f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801f43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f47:	85 ed                	test   %ebp,%ebp
  801f49:	89 f0                	mov    %esi,%eax
  801f4b:	89 da                	mov    %ebx,%edx
  801f4d:	75 19                	jne    801f68 <__umoddi3+0x38>
  801f4f:	39 df                	cmp    %ebx,%edi
  801f51:	0f 86 b1 00 00 00    	jbe    802008 <__umoddi3+0xd8>
  801f57:	f7 f7                	div    %edi
  801f59:	89 d0                	mov    %edx,%eax
  801f5b:	31 d2                	xor    %edx,%edx
  801f5d:	83 c4 1c             	add    $0x1c,%esp
  801f60:	5b                   	pop    %ebx
  801f61:	5e                   	pop    %esi
  801f62:	5f                   	pop    %edi
  801f63:	5d                   	pop    %ebp
  801f64:	c3                   	ret    
  801f65:	8d 76 00             	lea    0x0(%esi),%esi
  801f68:	39 dd                	cmp    %ebx,%ebp
  801f6a:	77 f1                	ja     801f5d <__umoddi3+0x2d>
  801f6c:	0f bd cd             	bsr    %ebp,%ecx
  801f6f:	83 f1 1f             	xor    $0x1f,%ecx
  801f72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f76:	0f 84 b4 00 00 00    	je     802030 <__umoddi3+0x100>
  801f7c:	b8 20 00 00 00       	mov    $0x20,%eax
  801f81:	89 c2                	mov    %eax,%edx
  801f83:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f87:	29 c2                	sub    %eax,%edx
  801f89:	89 c1                	mov    %eax,%ecx
  801f8b:	89 f8                	mov    %edi,%eax
  801f8d:	d3 e5                	shl    %cl,%ebp
  801f8f:	89 d1                	mov    %edx,%ecx
  801f91:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801f95:	d3 e8                	shr    %cl,%eax
  801f97:	09 c5                	or     %eax,%ebp
  801f99:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f9d:	89 c1                	mov    %eax,%ecx
  801f9f:	d3 e7                	shl    %cl,%edi
  801fa1:	89 d1                	mov    %edx,%ecx
  801fa3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801fa7:	89 df                	mov    %ebx,%edi
  801fa9:	d3 ef                	shr    %cl,%edi
  801fab:	89 c1                	mov    %eax,%ecx
  801fad:	89 f0                	mov    %esi,%eax
  801faf:	d3 e3                	shl    %cl,%ebx
  801fb1:	89 d1                	mov    %edx,%ecx
  801fb3:	89 fa                	mov    %edi,%edx
  801fb5:	d3 e8                	shr    %cl,%eax
  801fb7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fbc:	09 d8                	or     %ebx,%eax
  801fbe:	f7 f5                	div    %ebp
  801fc0:	d3 e6                	shl    %cl,%esi
  801fc2:	89 d1                	mov    %edx,%ecx
  801fc4:	f7 64 24 08          	mull   0x8(%esp)
  801fc8:	39 d1                	cmp    %edx,%ecx
  801fca:	89 c3                	mov    %eax,%ebx
  801fcc:	89 d7                	mov    %edx,%edi
  801fce:	72 06                	jb     801fd6 <__umoddi3+0xa6>
  801fd0:	75 0e                	jne    801fe0 <__umoddi3+0xb0>
  801fd2:	39 c6                	cmp    %eax,%esi
  801fd4:	73 0a                	jae    801fe0 <__umoddi3+0xb0>
  801fd6:	2b 44 24 08          	sub    0x8(%esp),%eax
  801fda:	19 ea                	sbb    %ebp,%edx
  801fdc:	89 d7                	mov    %edx,%edi
  801fde:	89 c3                	mov    %eax,%ebx
  801fe0:	89 ca                	mov    %ecx,%edx
  801fe2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801fe7:	29 de                	sub    %ebx,%esi
  801fe9:	19 fa                	sbb    %edi,%edx
  801feb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801fef:	89 d0                	mov    %edx,%eax
  801ff1:	d3 e0                	shl    %cl,%eax
  801ff3:	89 d9                	mov    %ebx,%ecx
  801ff5:	d3 ee                	shr    %cl,%esi
  801ff7:	d3 ea                	shr    %cl,%edx
  801ff9:	09 f0                	or     %esi,%eax
  801ffb:	83 c4 1c             	add    $0x1c,%esp
  801ffe:	5b                   	pop    %ebx
  801fff:	5e                   	pop    %esi
  802000:	5f                   	pop    %edi
  802001:	5d                   	pop    %ebp
  802002:	c3                   	ret    
  802003:	90                   	nop
  802004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802008:	85 ff                	test   %edi,%edi
  80200a:	89 f9                	mov    %edi,%ecx
  80200c:	75 0b                	jne    802019 <__umoddi3+0xe9>
  80200e:	b8 01 00 00 00       	mov    $0x1,%eax
  802013:	31 d2                	xor    %edx,%edx
  802015:	f7 f7                	div    %edi
  802017:	89 c1                	mov    %eax,%ecx
  802019:	89 d8                	mov    %ebx,%eax
  80201b:	31 d2                	xor    %edx,%edx
  80201d:	f7 f1                	div    %ecx
  80201f:	89 f0                	mov    %esi,%eax
  802021:	f7 f1                	div    %ecx
  802023:	e9 31 ff ff ff       	jmp    801f59 <__umoddi3+0x29>
  802028:	90                   	nop
  802029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802030:	39 dd                	cmp    %ebx,%ebp
  802032:	72 08                	jb     80203c <__umoddi3+0x10c>
  802034:	39 f7                	cmp    %esi,%edi
  802036:	0f 87 21 ff ff ff    	ja     801f5d <__umoddi3+0x2d>
  80203c:	89 da                	mov    %ebx,%edx
  80203e:	89 f0                	mov    %esi,%eax
  802040:	29 f8                	sub    %edi,%eax
  802042:	19 ea                	sbb    %ebp,%edx
  802044:	e9 14 ff ff ff       	jmp    801f5d <__umoddi3+0x2d>
