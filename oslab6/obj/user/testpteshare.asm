
obj/user/testpteshare.debug：     文件格式 elf32-i386


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
  80002c:	e8 65 01 00 00       	call   800196 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  800039:	ff 35 00 30 80 00    	pushl  0x803000
  80003f:	68 00 00 00 a0       	push   $0xa0000000
  800044:	e8 9f 08 00 00       	call   8008e8 <strcpy>
	exit();
  800049:	e8 8e 01 00 00       	call   8001dc <exit>
}
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	c9                   	leave  
  800052:	c3                   	ret    

00800053 <umain>:
{
  800053:	55                   	push   %ebp
  800054:	89 e5                	mov    %esp,%ebp
  800056:	53                   	push   %ebx
  800057:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  80005a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80005e:	0f 85 d2 00 00 00    	jne    800136 <umain+0xe3>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 07 04 00 00       	push   $0x407
  80006c:	68 00 00 00 a0       	push   $0xa0000000
  800071:	6a 00                	push   $0x0
  800073:	e8 69 0c 00 00       	call   800ce1 <sys_page_alloc>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	85 c0                	test   %eax,%eax
  80007d:	0f 88 bd 00 00 00    	js     800140 <umain+0xed>
	if ((r = fork()) < 0)
  800083:	e8 1a 0f 00 00       	call   800fa2 <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 c0 00 00 00    	js     800152 <umain+0xff>
	if (r == 0) {
  800092:	85 c0                	test   %eax,%eax
  800094:	0f 84 ca 00 00 00    	je     800164 <umain+0x111>
	wait(r);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	53                   	push   %ebx
  80009e:	e8 59 16 00 00       	call   8016fc <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a3:	83 c4 08             	add    $0x8,%esp
  8000a6:	ff 35 04 30 80 00    	pushl  0x803004
  8000ac:	68 00 00 00 a0       	push   $0xa0000000
  8000b1:	e8 d8 08 00 00       	call   80098e <strcmp>
  8000b6:	83 c4 08             	add    $0x8,%esp
  8000b9:	85 c0                	test   %eax,%eax
  8000bb:	b8 40 28 80 00       	mov    $0x802840,%eax
  8000c0:	ba 46 28 80 00       	mov    $0x802846,%edx
  8000c5:	0f 45 c2             	cmovne %edx,%eax
  8000c8:	50                   	push   %eax
  8000c9:	68 73 28 80 00       	push   $0x802873
  8000ce:	e8 f6 01 00 00       	call   8002c9 <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d3:	6a 00                	push   $0x0
  8000d5:	68 8e 28 80 00       	push   $0x80288e
  8000da:	68 93 28 80 00       	push   $0x802893
  8000df:	68 92 28 80 00       	push   $0x802892
  8000e4:	e8 96 15 00 00       	call   80167f <spawnl>
  8000e9:	83 c4 20             	add    $0x20,%esp
  8000ec:	85 c0                	test   %eax,%eax
  8000ee:	0f 88 90 00 00 00    	js     800184 <umain+0x131>
	wait(r);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 ff 15 00 00       	call   8016fc <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fd:	83 c4 08             	add    $0x8,%esp
  800100:	ff 35 00 30 80 00    	pushl  0x803000
  800106:	68 00 00 00 a0       	push   $0xa0000000
  80010b:	e8 7e 08 00 00       	call   80098e <strcmp>
  800110:	83 c4 08             	add    $0x8,%esp
  800113:	85 c0                	test   %eax,%eax
  800115:	b8 40 28 80 00       	mov    $0x802840,%eax
  80011a:	ba 46 28 80 00       	mov    $0x802846,%edx
  80011f:	0f 45 c2             	cmovne %edx,%eax
  800122:	50                   	push   %eax
  800123:	68 aa 28 80 00       	push   $0x8028aa
  800128:	e8 9c 01 00 00       	call   8002c9 <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80012d:	cc                   	int3   
}
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800134:	c9                   	leave  
  800135:	c3                   	ret    
		childofspawn();
  800136:	e8 f8 fe ff ff       	call   800033 <childofspawn>
  80013b:	e9 24 ff ff ff       	jmp    800064 <umain+0x11>
		panic("sys_page_alloc: %e", r);
  800140:	50                   	push   %eax
  800141:	68 4c 28 80 00       	push   $0x80284c
  800146:	6a 13                	push   $0x13
  800148:	68 5f 28 80 00       	push   $0x80285f
  80014d:	e8 9c 00 00 00       	call   8001ee <_panic>
		panic("fork: %e", r);
  800152:	50                   	push   %eax
  800153:	68 92 2c 80 00       	push   $0x802c92
  800158:	6a 17                	push   $0x17
  80015a:	68 5f 28 80 00       	push   $0x80285f
  80015f:	e8 8a 00 00 00       	call   8001ee <_panic>
		strcpy(VA, msg);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	ff 35 04 30 80 00    	pushl  0x803004
  80016d:	68 00 00 00 a0       	push   $0xa0000000
  800172:	e8 71 07 00 00       	call   8008e8 <strcpy>
		exit();
  800177:	e8 60 00 00 00       	call   8001dc <exit>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	e9 16 ff ff ff       	jmp    80009a <umain+0x47>
		panic("spawn: %e", r);
  800184:	50                   	push   %eax
  800185:	68 a0 28 80 00       	push   $0x8028a0
  80018a:	6a 21                	push   $0x21
  80018c:	68 5f 28 80 00       	push   $0x80285f
  800191:	e8 58 00 00 00       	call   8001ee <_panic>

00800196 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	56                   	push   %esi
  80019a:	53                   	push   %ebx
  80019b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80019e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  8001a1:	e8 fd 0a 00 00       	call   800ca3 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  8001a6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ab:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001b3:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b8:	85 db                	test   %ebx,%ebx
  8001ba:	7e 07                	jle    8001c3 <libmain+0x2d>
		binaryname = argv[0];
  8001bc:	8b 06                	mov    (%esi),%eax
  8001be:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	umain(argc, argv);
  8001c3:	83 ec 08             	sub    $0x8,%esp
  8001c6:	56                   	push   %esi
  8001c7:	53                   	push   %ebx
  8001c8:	e8 86 fe ff ff       	call   800053 <umain>

	// exit gracefully
	exit();
  8001cd:	e8 0a 00 00 00       	call   8001dc <exit>
}
  8001d2:	83 c4 10             	add    $0x10,%esp
  8001d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001d8:	5b                   	pop    %ebx
  8001d9:	5e                   	pop    %esi
  8001da:	5d                   	pop    %ebp
  8001db:	c3                   	ret    

008001dc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8001e2:	6a 00                	push   $0x0
  8001e4:	e8 79 0a 00 00       	call   800c62 <sys_env_destroy>
}
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	c9                   	leave  
  8001ed:	c3                   	ret    

008001ee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	56                   	push   %esi
  8001f2:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001f3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001f6:	8b 35 08 30 80 00    	mov    0x803008,%esi
  8001fc:	e8 a2 0a 00 00       	call   800ca3 <sys_getenvid>
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 0c             	pushl  0xc(%ebp)
  800207:	ff 75 08             	pushl  0x8(%ebp)
  80020a:	56                   	push   %esi
  80020b:	50                   	push   %eax
  80020c:	68 f0 28 80 00       	push   $0x8028f0
  800211:	e8 b3 00 00 00       	call   8002c9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800216:	83 c4 18             	add    $0x18,%esp
  800219:	53                   	push   %ebx
  80021a:	ff 75 10             	pushl  0x10(%ebp)
  80021d:	e8 56 00 00 00       	call   800278 <vcprintf>
	cprintf("\n");
  800222:	c7 04 24 86 2e 80 00 	movl   $0x802e86,(%esp)
  800229:	e8 9b 00 00 00       	call   8002c9 <cprintf>
  80022e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800231:	cc                   	int3   
  800232:	eb fd                	jmp    800231 <_panic+0x43>

00800234 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	53                   	push   %ebx
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80023e:	8b 13                	mov    (%ebx),%edx
  800240:	8d 42 01             	lea    0x1(%edx),%eax
  800243:	89 03                	mov    %eax,(%ebx)
  800245:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800248:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80024c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800251:	74 09                	je     80025c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800253:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800257:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80025a:	c9                   	leave  
  80025b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80025c:	83 ec 08             	sub    $0x8,%esp
  80025f:	68 ff 00 00 00       	push   $0xff
  800264:	8d 43 08             	lea    0x8(%ebx),%eax
  800267:	50                   	push   %eax
  800268:	e8 b8 09 00 00       	call   800c25 <sys_cputs>
		b->idx = 0;
  80026d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	eb db                	jmp    800253 <putch+0x1f>

00800278 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800281:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800288:	00 00 00 
	b.cnt = 0;
  80028b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800292:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800295:	ff 75 0c             	pushl  0xc(%ebp)
  800298:	ff 75 08             	pushl  0x8(%ebp)
  80029b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a1:	50                   	push   %eax
  8002a2:	68 34 02 80 00       	push   $0x800234
  8002a7:	e8 1a 01 00 00       	call   8003c6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ac:	83 c4 08             	add    $0x8,%esp
  8002af:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002b5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002bb:	50                   	push   %eax
  8002bc:	e8 64 09 00 00       	call   800c25 <sys_cputs>

	return b.cnt;
}
  8002c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002cf:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002d2:	50                   	push   %eax
  8002d3:	ff 75 08             	pushl  0x8(%ebp)
  8002d6:	e8 9d ff ff ff       	call   800278 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	57                   	push   %edi
  8002e1:	56                   	push   %esi
  8002e2:	53                   	push   %ebx
  8002e3:	83 ec 1c             	sub    $0x1c,%esp
  8002e6:	89 c7                	mov    %eax,%edi
  8002e8:	89 d6                	mov    %edx,%esi
  8002ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002fe:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800301:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800304:	39 d3                	cmp    %edx,%ebx
  800306:	72 05                	jb     80030d <printnum+0x30>
  800308:	39 45 10             	cmp    %eax,0x10(%ebp)
  80030b:	77 7a                	ja     800387 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80030d:	83 ec 0c             	sub    $0xc,%esp
  800310:	ff 75 18             	pushl  0x18(%ebp)
  800313:	8b 45 14             	mov    0x14(%ebp),%eax
  800316:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800319:	53                   	push   %ebx
  80031a:	ff 75 10             	pushl  0x10(%ebp)
  80031d:	83 ec 08             	sub    $0x8,%esp
  800320:	ff 75 e4             	pushl  -0x1c(%ebp)
  800323:	ff 75 e0             	pushl  -0x20(%ebp)
  800326:	ff 75 dc             	pushl  -0x24(%ebp)
  800329:	ff 75 d8             	pushl  -0x28(%ebp)
  80032c:	e8 cf 22 00 00       	call   802600 <__udivdi3>
  800331:	83 c4 18             	add    $0x18,%esp
  800334:	52                   	push   %edx
  800335:	50                   	push   %eax
  800336:	89 f2                	mov    %esi,%edx
  800338:	89 f8                	mov    %edi,%eax
  80033a:	e8 9e ff ff ff       	call   8002dd <printnum>
  80033f:	83 c4 20             	add    $0x20,%esp
  800342:	eb 13                	jmp    800357 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800344:	83 ec 08             	sub    $0x8,%esp
  800347:	56                   	push   %esi
  800348:	ff 75 18             	pushl  0x18(%ebp)
  80034b:	ff d7                	call   *%edi
  80034d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800350:	83 eb 01             	sub    $0x1,%ebx
  800353:	85 db                	test   %ebx,%ebx
  800355:	7f ed                	jg     800344 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	56                   	push   %esi
  80035b:	83 ec 04             	sub    $0x4,%esp
  80035e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800361:	ff 75 e0             	pushl  -0x20(%ebp)
  800364:	ff 75 dc             	pushl  -0x24(%ebp)
  800367:	ff 75 d8             	pushl  -0x28(%ebp)
  80036a:	e8 b1 23 00 00       	call   802720 <__umoddi3>
  80036f:	83 c4 14             	add    $0x14,%esp
  800372:	0f be 80 13 29 80 00 	movsbl 0x802913(%eax),%eax
  800379:	50                   	push   %eax
  80037a:	ff d7                	call   *%edi
}
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800382:	5b                   	pop    %ebx
  800383:	5e                   	pop    %esi
  800384:	5f                   	pop    %edi
  800385:	5d                   	pop    %ebp
  800386:	c3                   	ret    
  800387:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80038a:	eb c4                	jmp    800350 <printnum+0x73>

0080038c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800392:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800396:	8b 10                	mov    (%eax),%edx
  800398:	3b 50 04             	cmp    0x4(%eax),%edx
  80039b:	73 0a                	jae    8003a7 <sprintputch+0x1b>
		*b->buf++ = ch;
  80039d:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003a0:	89 08                	mov    %ecx,(%eax)
  8003a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a5:	88 02                	mov    %al,(%edx)
}
  8003a7:	5d                   	pop    %ebp
  8003a8:	c3                   	ret    

008003a9 <printfmt>:
{
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003af:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003b2:	50                   	push   %eax
  8003b3:	ff 75 10             	pushl  0x10(%ebp)
  8003b6:	ff 75 0c             	pushl  0xc(%ebp)
  8003b9:	ff 75 08             	pushl  0x8(%ebp)
  8003bc:	e8 05 00 00 00       	call   8003c6 <vprintfmt>
}
  8003c1:	83 c4 10             	add    $0x10,%esp
  8003c4:	c9                   	leave  
  8003c5:	c3                   	ret    

008003c6 <vprintfmt>:
{
  8003c6:	55                   	push   %ebp
  8003c7:	89 e5                	mov    %esp,%ebp
  8003c9:	57                   	push   %edi
  8003ca:	56                   	push   %esi
  8003cb:	53                   	push   %ebx
  8003cc:	83 ec 2c             	sub    $0x2c,%esp
  8003cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8003d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003d5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003d8:	e9 c1 03 00 00       	jmp    80079e <vprintfmt+0x3d8>
		padc = ' ';
  8003dd:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003e1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003e8:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8003ef:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003f6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003fb:	8d 47 01             	lea    0x1(%edi),%eax
  8003fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800401:	0f b6 17             	movzbl (%edi),%edx
  800404:	8d 42 dd             	lea    -0x23(%edx),%eax
  800407:	3c 55                	cmp    $0x55,%al
  800409:	0f 87 12 04 00 00    	ja     800821 <vprintfmt+0x45b>
  80040f:	0f b6 c0             	movzbl %al,%eax
  800412:	ff 24 85 60 2a 80 00 	jmp    *0x802a60(,%eax,4)
  800419:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80041c:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800420:	eb d9                	jmp    8003fb <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800422:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800425:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800429:	eb d0                	jmp    8003fb <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80042b:	0f b6 d2             	movzbl %dl,%edx
  80042e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800431:	b8 00 00 00 00       	mov    $0x0,%eax
  800436:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800439:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80043c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800440:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800443:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800446:	83 f9 09             	cmp    $0x9,%ecx
  800449:	77 55                	ja     8004a0 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80044b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80044e:	eb e9                	jmp    800439 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800450:	8b 45 14             	mov    0x14(%ebp),%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800458:	8b 45 14             	mov    0x14(%ebp),%eax
  80045b:	8d 40 04             	lea    0x4(%eax),%eax
  80045e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800461:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800464:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800468:	79 91                	jns    8003fb <vprintfmt+0x35>
				width = precision, precision = -1;
  80046a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80046d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800470:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800477:	eb 82                	jmp    8003fb <vprintfmt+0x35>
  800479:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047c:	85 c0                	test   %eax,%eax
  80047e:	ba 00 00 00 00       	mov    $0x0,%edx
  800483:	0f 49 d0             	cmovns %eax,%edx
  800486:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800489:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80048c:	e9 6a ff ff ff       	jmp    8003fb <vprintfmt+0x35>
  800491:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800494:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80049b:	e9 5b ff ff ff       	jmp    8003fb <vprintfmt+0x35>
  8004a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004a6:	eb bc                	jmp    800464 <vprintfmt+0x9e>
			lflag++;
  8004a8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004ae:	e9 48 ff ff ff       	jmp    8003fb <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b6:	8d 78 04             	lea    0x4(%eax),%edi
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	53                   	push   %ebx
  8004bd:	ff 30                	pushl  (%eax)
  8004bf:	ff d6                	call   *%esi
			break;
  8004c1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004c4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004c7:	e9 cf 02 00 00       	jmp    80079b <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8004cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cf:	8d 78 04             	lea    0x4(%eax),%edi
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	99                   	cltd   
  8004d5:	31 d0                	xor    %edx,%eax
  8004d7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004d9:	83 f8 0f             	cmp    $0xf,%eax
  8004dc:	7f 23                	jg     800501 <vprintfmt+0x13b>
  8004de:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  8004e5:	85 d2                	test   %edx,%edx
  8004e7:	74 18                	je     800501 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8004e9:	52                   	push   %edx
  8004ea:	68 06 2d 80 00       	push   $0x802d06
  8004ef:	53                   	push   %ebx
  8004f0:	56                   	push   %esi
  8004f1:	e8 b3 fe ff ff       	call   8003a9 <printfmt>
  8004f6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004f9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004fc:	e9 9a 02 00 00       	jmp    80079b <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800501:	50                   	push   %eax
  800502:	68 2b 29 80 00       	push   $0x80292b
  800507:	53                   	push   %ebx
  800508:	56                   	push   %esi
  800509:	e8 9b fe ff ff       	call   8003a9 <printfmt>
  80050e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800511:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800514:	e9 82 02 00 00       	jmp    80079b <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	83 c0 04             	add    $0x4,%eax
  80051f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800522:	8b 45 14             	mov    0x14(%ebp),%eax
  800525:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800527:	85 ff                	test   %edi,%edi
  800529:	b8 24 29 80 00       	mov    $0x802924,%eax
  80052e:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800531:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800535:	0f 8e bd 00 00 00    	jle    8005f8 <vprintfmt+0x232>
  80053b:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80053f:	75 0e                	jne    80054f <vprintfmt+0x189>
  800541:	89 75 08             	mov    %esi,0x8(%ebp)
  800544:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800547:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80054a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80054d:	eb 6d                	jmp    8005bc <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	ff 75 d0             	pushl  -0x30(%ebp)
  800555:	57                   	push   %edi
  800556:	e8 6e 03 00 00       	call   8008c9 <strnlen>
  80055b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80055e:	29 c1                	sub    %eax,%ecx
  800560:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800563:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800566:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80056a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80056d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800570:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800572:	eb 0f                	jmp    800583 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	53                   	push   %ebx
  800578:	ff 75 e0             	pushl  -0x20(%ebp)
  80057b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80057d:	83 ef 01             	sub    $0x1,%edi
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	85 ff                	test   %edi,%edi
  800585:	7f ed                	jg     800574 <vprintfmt+0x1ae>
  800587:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80058a:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80058d:	85 c9                	test   %ecx,%ecx
  80058f:	b8 00 00 00 00       	mov    $0x0,%eax
  800594:	0f 49 c1             	cmovns %ecx,%eax
  800597:	29 c1                	sub    %eax,%ecx
  800599:	89 75 08             	mov    %esi,0x8(%ebp)
  80059c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80059f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005a2:	89 cb                	mov    %ecx,%ebx
  8005a4:	eb 16                	jmp    8005bc <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005aa:	75 31                	jne    8005dd <vprintfmt+0x217>
					putch(ch, putdat);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	ff 75 0c             	pushl  0xc(%ebp)
  8005b2:	50                   	push   %eax
  8005b3:	ff 55 08             	call   *0x8(%ebp)
  8005b6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b9:	83 eb 01             	sub    $0x1,%ebx
  8005bc:	83 c7 01             	add    $0x1,%edi
  8005bf:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005c3:	0f be c2             	movsbl %dl,%eax
  8005c6:	85 c0                	test   %eax,%eax
  8005c8:	74 59                	je     800623 <vprintfmt+0x25d>
  8005ca:	85 f6                	test   %esi,%esi
  8005cc:	78 d8                	js     8005a6 <vprintfmt+0x1e0>
  8005ce:	83 ee 01             	sub    $0x1,%esi
  8005d1:	79 d3                	jns    8005a6 <vprintfmt+0x1e0>
  8005d3:	89 df                	mov    %ebx,%edi
  8005d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8005d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005db:	eb 37                	jmp    800614 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005dd:	0f be d2             	movsbl %dl,%edx
  8005e0:	83 ea 20             	sub    $0x20,%edx
  8005e3:	83 fa 5e             	cmp    $0x5e,%edx
  8005e6:	76 c4                	jbe    8005ac <vprintfmt+0x1e6>
					putch('?', putdat);
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	ff 75 0c             	pushl  0xc(%ebp)
  8005ee:	6a 3f                	push   $0x3f
  8005f0:	ff 55 08             	call   *0x8(%ebp)
  8005f3:	83 c4 10             	add    $0x10,%esp
  8005f6:	eb c1                	jmp    8005b9 <vprintfmt+0x1f3>
  8005f8:	89 75 08             	mov    %esi,0x8(%ebp)
  8005fb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005fe:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800601:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800604:	eb b6                	jmp    8005bc <vprintfmt+0x1f6>
				putch(' ', putdat);
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	53                   	push   %ebx
  80060a:	6a 20                	push   $0x20
  80060c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80060e:	83 ef 01             	sub    $0x1,%edi
  800611:	83 c4 10             	add    $0x10,%esp
  800614:	85 ff                	test   %edi,%edi
  800616:	7f ee                	jg     800606 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800618:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80061b:	89 45 14             	mov    %eax,0x14(%ebp)
  80061e:	e9 78 01 00 00       	jmp    80079b <vprintfmt+0x3d5>
  800623:	89 df                	mov    %ebx,%edi
  800625:	8b 75 08             	mov    0x8(%ebp),%esi
  800628:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80062b:	eb e7                	jmp    800614 <vprintfmt+0x24e>
	if (lflag >= 2)
  80062d:	83 f9 01             	cmp    $0x1,%ecx
  800630:	7e 3f                	jle    800671 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 50 04             	mov    0x4(%eax),%edx
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8d 40 08             	lea    0x8(%eax),%eax
  800646:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800649:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80064d:	79 5c                	jns    8006ab <vprintfmt+0x2e5>
				putch('-', putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	53                   	push   %ebx
  800653:	6a 2d                	push   $0x2d
  800655:	ff d6                	call   *%esi
				num = -(long long) num;
  800657:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80065a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80065d:	f7 da                	neg    %edx
  80065f:	83 d1 00             	adc    $0x0,%ecx
  800662:	f7 d9                	neg    %ecx
  800664:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800667:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066c:	e9 10 01 00 00       	jmp    800781 <vprintfmt+0x3bb>
	else if (lflag)
  800671:	85 c9                	test   %ecx,%ecx
  800673:	75 1b                	jne    800690 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067d:	89 c1                	mov    %eax,%ecx
  80067f:	c1 f9 1f             	sar    $0x1f,%ecx
  800682:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 40 04             	lea    0x4(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
  80068e:	eb b9                	jmp    800649 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800698:	89 c1                	mov    %eax,%ecx
  80069a:	c1 f9 1f             	sar    $0x1f,%ecx
  80069d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 40 04             	lea    0x4(%eax),%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a9:	eb 9e                	jmp    800649 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006ab:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ae:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b6:	e9 c6 00 00 00       	jmp    800781 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8006bb:	83 f9 01             	cmp    $0x1,%ecx
  8006be:	7e 18                	jle    8006d8 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8b 10                	mov    (%eax),%edx
  8006c5:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c8:	8d 40 08             	lea    0x8(%eax),%eax
  8006cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ce:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d3:	e9 a9 00 00 00       	jmp    800781 <vprintfmt+0x3bb>
	else if (lflag)
  8006d8:	85 c9                	test   %ecx,%ecx
  8006da:	75 1a                	jne    8006f6 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 10                	mov    (%eax),%edx
  8006e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e6:	8d 40 04             	lea    0x4(%eax),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ec:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f1:	e9 8b 00 00 00       	jmp    800781 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8b 10                	mov    (%eax),%edx
  8006fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800700:	8d 40 04             	lea    0x4(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800706:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070b:	eb 74                	jmp    800781 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80070d:	83 f9 01             	cmp    $0x1,%ecx
  800710:	7e 15                	jle    800727 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8b 10                	mov    (%eax),%edx
  800717:	8b 48 04             	mov    0x4(%eax),%ecx
  80071a:	8d 40 08             	lea    0x8(%eax),%eax
  80071d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800720:	b8 08 00 00 00       	mov    $0x8,%eax
  800725:	eb 5a                	jmp    800781 <vprintfmt+0x3bb>
	else if (lflag)
  800727:	85 c9                	test   %ecx,%ecx
  800729:	75 17                	jne    800742 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	8b 10                	mov    (%eax),%edx
  800730:	b9 00 00 00 00       	mov    $0x0,%ecx
  800735:	8d 40 04             	lea    0x4(%eax),%eax
  800738:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073b:	b8 08 00 00 00       	mov    $0x8,%eax
  800740:	eb 3f                	jmp    800781 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8b 10                	mov    (%eax),%edx
  800747:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074c:	8d 40 04             	lea    0x4(%eax),%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800752:	b8 08 00 00 00       	mov    $0x8,%eax
  800757:	eb 28                	jmp    800781 <vprintfmt+0x3bb>
			putch('0', putdat);
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	53                   	push   %ebx
  80075d:	6a 30                	push   $0x30
  80075f:	ff d6                	call   *%esi
			putch('x', putdat);
  800761:	83 c4 08             	add    $0x8,%esp
  800764:	53                   	push   %ebx
  800765:	6a 78                	push   $0x78
  800767:	ff d6                	call   *%esi
			num = (unsigned long long)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8b 10                	mov    (%eax),%edx
  80076e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800773:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800776:	8d 40 04             	lea    0x4(%eax),%eax
  800779:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800781:	83 ec 0c             	sub    $0xc,%esp
  800784:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800788:	57                   	push   %edi
  800789:	ff 75 e0             	pushl  -0x20(%ebp)
  80078c:	50                   	push   %eax
  80078d:	51                   	push   %ecx
  80078e:	52                   	push   %edx
  80078f:	89 da                	mov    %ebx,%edx
  800791:	89 f0                	mov    %esi,%eax
  800793:	e8 45 fb ff ff       	call   8002dd <printnum>
			break;
  800798:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80079b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  80079e:	83 c7 01             	add    $0x1,%edi
  8007a1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007a5:	83 f8 25             	cmp    $0x25,%eax
  8007a8:	0f 84 2f fc ff ff    	je     8003dd <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  8007ae:	85 c0                	test   %eax,%eax
  8007b0:	0f 84 8b 00 00 00    	je     800841 <vprintfmt+0x47b>
			putch(ch, putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	53                   	push   %ebx
  8007ba:	50                   	push   %eax
  8007bb:	ff d6                	call   *%esi
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	eb dc                	jmp    80079e <vprintfmt+0x3d8>
	if (lflag >= 2)
  8007c2:	83 f9 01             	cmp    $0x1,%ecx
  8007c5:	7e 15                	jle    8007dc <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8b 10                	mov    (%eax),%edx
  8007cc:	8b 48 04             	mov    0x4(%eax),%ecx
  8007cf:	8d 40 08             	lea    0x8(%eax),%eax
  8007d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d5:	b8 10 00 00 00       	mov    $0x10,%eax
  8007da:	eb a5                	jmp    800781 <vprintfmt+0x3bb>
	else if (lflag)
  8007dc:	85 c9                	test   %ecx,%ecx
  8007de:	75 17                	jne    8007f7 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8b 10                	mov    (%eax),%edx
  8007e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ea:	8d 40 04             	lea    0x4(%eax),%eax
  8007ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f0:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f5:	eb 8a                	jmp    800781 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	8b 10                	mov    (%eax),%edx
  8007fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800801:	8d 40 04             	lea    0x4(%eax),%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800807:	b8 10 00 00 00       	mov    $0x10,%eax
  80080c:	e9 70 ff ff ff       	jmp    800781 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	53                   	push   %ebx
  800815:	6a 25                	push   $0x25
  800817:	ff d6                	call   *%esi
			break;
  800819:	83 c4 10             	add    $0x10,%esp
  80081c:	e9 7a ff ff ff       	jmp    80079b <vprintfmt+0x3d5>
			putch('%', putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	53                   	push   %ebx
  800825:	6a 25                	push   $0x25
  800827:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800829:	83 c4 10             	add    $0x10,%esp
  80082c:	89 f8                	mov    %edi,%eax
  80082e:	eb 03                	jmp    800833 <vprintfmt+0x46d>
  800830:	83 e8 01             	sub    $0x1,%eax
  800833:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800837:	75 f7                	jne    800830 <vprintfmt+0x46a>
  800839:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083c:	e9 5a ff ff ff       	jmp    80079b <vprintfmt+0x3d5>
}
  800841:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800844:	5b                   	pop    %ebx
  800845:	5e                   	pop    %esi
  800846:	5f                   	pop    %edi
  800847:	5d                   	pop    %ebp
  800848:	c3                   	ret    

00800849 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	83 ec 18             	sub    $0x18,%esp
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800855:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800858:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80085c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80085f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800866:	85 c0                	test   %eax,%eax
  800868:	74 26                	je     800890 <vsnprintf+0x47>
  80086a:	85 d2                	test   %edx,%edx
  80086c:	7e 22                	jle    800890 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80086e:	ff 75 14             	pushl  0x14(%ebp)
  800871:	ff 75 10             	pushl  0x10(%ebp)
  800874:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800877:	50                   	push   %eax
  800878:	68 8c 03 80 00       	push   $0x80038c
  80087d:	e8 44 fb ff ff       	call   8003c6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800885:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088b:	83 c4 10             	add    $0x10,%esp
}
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    
		return -E_INVAL;
  800890:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800895:	eb f7                	jmp    80088e <vsnprintf+0x45>

00800897 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80089d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008a0:	50                   	push   %eax
  8008a1:	ff 75 10             	pushl  0x10(%ebp)
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	ff 75 08             	pushl  0x8(%ebp)
  8008aa:	e8 9a ff ff ff       	call   800849 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008af:	c9                   	leave  
  8008b0:	c3                   	ret    

008008b1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bc:	eb 03                	jmp    8008c1 <strlen+0x10>
		n++;
  8008be:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008c1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c5:	75 f7                	jne    8008be <strlen+0xd>
	return n;
}
  8008c7:	5d                   	pop    %ebp
  8008c8:	c3                   	ret    

008008c9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008cf:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d7:	eb 03                	jmp    8008dc <strnlen+0x13>
		n++;
  8008d9:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008dc:	39 d0                	cmp    %edx,%eax
  8008de:	74 06                	je     8008e6 <strnlen+0x1d>
  8008e0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008e4:	75 f3                	jne    8008d9 <strnlen+0x10>
	return n;
}
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	53                   	push   %ebx
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f2:	89 c2                	mov    %eax,%edx
  8008f4:	83 c1 01             	add    $0x1,%ecx
  8008f7:	83 c2 01             	add    $0x1,%edx
  8008fa:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008fe:	88 5a ff             	mov    %bl,-0x1(%edx)
  800901:	84 db                	test   %bl,%bl
  800903:	75 ef                	jne    8008f4 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800905:	5b                   	pop    %ebx
  800906:	5d                   	pop    %ebp
  800907:	c3                   	ret    

00800908 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	53                   	push   %ebx
  80090c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80090f:	53                   	push   %ebx
  800910:	e8 9c ff ff ff       	call   8008b1 <strlen>
  800915:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800918:	ff 75 0c             	pushl  0xc(%ebp)
  80091b:	01 d8                	add    %ebx,%eax
  80091d:	50                   	push   %eax
  80091e:	e8 c5 ff ff ff       	call   8008e8 <strcpy>
	return dst;
}
  800923:	89 d8                	mov    %ebx,%eax
  800925:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	56                   	push   %esi
  80092e:	53                   	push   %ebx
  80092f:	8b 75 08             	mov    0x8(%ebp),%esi
  800932:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800935:	89 f3                	mov    %esi,%ebx
  800937:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80093a:	89 f2                	mov    %esi,%edx
  80093c:	eb 0f                	jmp    80094d <strncpy+0x23>
		*dst++ = *src;
  80093e:	83 c2 01             	add    $0x1,%edx
  800941:	0f b6 01             	movzbl (%ecx),%eax
  800944:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800947:	80 39 01             	cmpb   $0x1,(%ecx)
  80094a:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80094d:	39 da                	cmp    %ebx,%edx
  80094f:	75 ed                	jne    80093e <strncpy+0x14>
	}
	return ret;
}
  800951:	89 f0                	mov    %esi,%eax
  800953:	5b                   	pop    %ebx
  800954:	5e                   	pop    %esi
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	56                   	push   %esi
  80095b:	53                   	push   %ebx
  80095c:	8b 75 08             	mov    0x8(%ebp),%esi
  80095f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800962:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800965:	89 f0                	mov    %esi,%eax
  800967:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80096b:	85 c9                	test   %ecx,%ecx
  80096d:	75 0b                	jne    80097a <strlcpy+0x23>
  80096f:	eb 17                	jmp    800988 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800971:	83 c2 01             	add    $0x1,%edx
  800974:	83 c0 01             	add    $0x1,%eax
  800977:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80097a:	39 d8                	cmp    %ebx,%eax
  80097c:	74 07                	je     800985 <strlcpy+0x2e>
  80097e:	0f b6 0a             	movzbl (%edx),%ecx
  800981:	84 c9                	test   %cl,%cl
  800983:	75 ec                	jne    800971 <strlcpy+0x1a>
		*dst = '\0';
  800985:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800988:	29 f0                	sub    %esi,%eax
}
  80098a:	5b                   	pop    %ebx
  80098b:	5e                   	pop    %esi
  80098c:	5d                   	pop    %ebp
  80098d:	c3                   	ret    

0080098e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800994:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800997:	eb 06                	jmp    80099f <strcmp+0x11>
		p++, q++;
  800999:	83 c1 01             	add    $0x1,%ecx
  80099c:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80099f:	0f b6 01             	movzbl (%ecx),%eax
  8009a2:	84 c0                	test   %al,%al
  8009a4:	74 04                	je     8009aa <strcmp+0x1c>
  8009a6:	3a 02                	cmp    (%edx),%al
  8009a8:	74 ef                	je     800999 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009aa:	0f b6 c0             	movzbl %al,%eax
  8009ad:	0f b6 12             	movzbl (%edx),%edx
  8009b0:	29 d0                	sub    %edx,%eax
}
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	53                   	push   %ebx
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009be:	89 c3                	mov    %eax,%ebx
  8009c0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c3:	eb 06                	jmp    8009cb <strncmp+0x17>
		n--, p++, q++;
  8009c5:	83 c0 01             	add    $0x1,%eax
  8009c8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009cb:	39 d8                	cmp    %ebx,%eax
  8009cd:	74 16                	je     8009e5 <strncmp+0x31>
  8009cf:	0f b6 08             	movzbl (%eax),%ecx
  8009d2:	84 c9                	test   %cl,%cl
  8009d4:	74 04                	je     8009da <strncmp+0x26>
  8009d6:	3a 0a                	cmp    (%edx),%cl
  8009d8:	74 eb                	je     8009c5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009da:	0f b6 00             	movzbl (%eax),%eax
  8009dd:	0f b6 12             	movzbl (%edx),%edx
  8009e0:	29 d0                	sub    %edx,%eax
}
  8009e2:	5b                   	pop    %ebx
  8009e3:	5d                   	pop    %ebp
  8009e4:	c3                   	ret    
		return 0;
  8009e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ea:	eb f6                	jmp    8009e2 <strncmp+0x2e>

008009ec <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f6:	0f b6 10             	movzbl (%eax),%edx
  8009f9:	84 d2                	test   %dl,%dl
  8009fb:	74 09                	je     800a06 <strchr+0x1a>
		if (*s == c)
  8009fd:	38 ca                	cmp    %cl,%dl
  8009ff:	74 0a                	je     800a0b <strchr+0x1f>
	for (; *s; s++)
  800a01:	83 c0 01             	add    $0x1,%eax
  800a04:	eb f0                	jmp    8009f6 <strchr+0xa>
			return (char *) s;
	return 0;
  800a06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a17:	eb 03                	jmp    800a1c <strfind+0xf>
  800a19:	83 c0 01             	add    $0x1,%eax
  800a1c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a1f:	38 ca                	cmp    %cl,%dl
  800a21:	74 04                	je     800a27 <strfind+0x1a>
  800a23:	84 d2                	test   %dl,%dl
  800a25:	75 f2                	jne    800a19 <strfind+0xc>
			break;
	return (char *) s;
}
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	57                   	push   %edi
  800a2d:	56                   	push   %esi
  800a2e:	53                   	push   %ebx
  800a2f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a32:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a35:	85 c9                	test   %ecx,%ecx
  800a37:	74 13                	je     800a4c <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a39:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a3f:	75 05                	jne    800a46 <memset+0x1d>
  800a41:	f6 c1 03             	test   $0x3,%cl
  800a44:	74 0d                	je     800a53 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a49:	fc                   	cld    
  800a4a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a4c:	89 f8                	mov    %edi,%eax
  800a4e:	5b                   	pop    %ebx
  800a4f:	5e                   	pop    %esi
  800a50:	5f                   	pop    %edi
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    
		c &= 0xFF;
  800a53:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a57:	89 d3                	mov    %edx,%ebx
  800a59:	c1 e3 08             	shl    $0x8,%ebx
  800a5c:	89 d0                	mov    %edx,%eax
  800a5e:	c1 e0 18             	shl    $0x18,%eax
  800a61:	89 d6                	mov    %edx,%esi
  800a63:	c1 e6 10             	shl    $0x10,%esi
  800a66:	09 f0                	or     %esi,%eax
  800a68:	09 c2                	or     %eax,%edx
  800a6a:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a6c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a6f:	89 d0                	mov    %edx,%eax
  800a71:	fc                   	cld    
  800a72:	f3 ab                	rep stos %eax,%es:(%edi)
  800a74:	eb d6                	jmp    800a4c <memset+0x23>

00800a76 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	57                   	push   %edi
  800a7a:	56                   	push   %esi
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a81:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a84:	39 c6                	cmp    %eax,%esi
  800a86:	73 35                	jae    800abd <memmove+0x47>
  800a88:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a8b:	39 c2                	cmp    %eax,%edx
  800a8d:	76 2e                	jbe    800abd <memmove+0x47>
		s += n;
		d += n;
  800a8f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a92:	89 d6                	mov    %edx,%esi
  800a94:	09 fe                	or     %edi,%esi
  800a96:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9c:	74 0c                	je     800aaa <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a9e:	83 ef 01             	sub    $0x1,%edi
  800aa1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aa4:	fd                   	std    
  800aa5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aa7:	fc                   	cld    
  800aa8:	eb 21                	jmp    800acb <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aaa:	f6 c1 03             	test   $0x3,%cl
  800aad:	75 ef                	jne    800a9e <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aaf:	83 ef 04             	sub    $0x4,%edi
  800ab2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ab8:	fd                   	std    
  800ab9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abb:	eb ea                	jmp    800aa7 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abd:	89 f2                	mov    %esi,%edx
  800abf:	09 c2                	or     %eax,%edx
  800ac1:	f6 c2 03             	test   $0x3,%dl
  800ac4:	74 09                	je     800acf <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ac6:	89 c7                	mov    %eax,%edi
  800ac8:	fc                   	cld    
  800ac9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800acb:	5e                   	pop    %esi
  800acc:	5f                   	pop    %edi
  800acd:	5d                   	pop    %ebp
  800ace:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acf:	f6 c1 03             	test   $0x3,%cl
  800ad2:	75 f2                	jne    800ac6 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ad7:	89 c7                	mov    %eax,%edi
  800ad9:	fc                   	cld    
  800ada:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800adc:	eb ed                	jmp    800acb <memmove+0x55>

00800ade <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ae1:	ff 75 10             	pushl  0x10(%ebp)
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	ff 75 08             	pushl  0x8(%ebp)
  800aea:	e8 87 ff ff ff       	call   800a76 <memmove>
}
  800aef:	c9                   	leave  
  800af0:	c3                   	ret    

00800af1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	56                   	push   %esi
  800af5:	53                   	push   %ebx
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	89 c6                	mov    %eax,%esi
  800afe:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b01:	39 f0                	cmp    %esi,%eax
  800b03:	74 1c                	je     800b21 <memcmp+0x30>
		if (*s1 != *s2)
  800b05:	0f b6 08             	movzbl (%eax),%ecx
  800b08:	0f b6 1a             	movzbl (%edx),%ebx
  800b0b:	38 d9                	cmp    %bl,%cl
  800b0d:	75 08                	jne    800b17 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b0f:	83 c0 01             	add    $0x1,%eax
  800b12:	83 c2 01             	add    $0x1,%edx
  800b15:	eb ea                	jmp    800b01 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b17:	0f b6 c1             	movzbl %cl,%eax
  800b1a:	0f b6 db             	movzbl %bl,%ebx
  800b1d:	29 d8                	sub    %ebx,%eax
  800b1f:	eb 05                	jmp    800b26 <memcmp+0x35>
	}

	return 0;
  800b21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b26:	5b                   	pop    %ebx
  800b27:	5e                   	pop    %esi
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b33:	89 c2                	mov    %eax,%edx
  800b35:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b38:	39 d0                	cmp    %edx,%eax
  800b3a:	73 09                	jae    800b45 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b3c:	38 08                	cmp    %cl,(%eax)
  800b3e:	74 05                	je     800b45 <memfind+0x1b>
	for (; s < ends; s++)
  800b40:	83 c0 01             	add    $0x1,%eax
  800b43:	eb f3                	jmp    800b38 <memfind+0xe>
			break;
	return (void *) s;
}
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	57                   	push   %edi
  800b4b:	56                   	push   %esi
  800b4c:	53                   	push   %ebx
  800b4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b50:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b53:	eb 03                	jmp    800b58 <strtol+0x11>
		s++;
  800b55:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b58:	0f b6 01             	movzbl (%ecx),%eax
  800b5b:	3c 20                	cmp    $0x20,%al
  800b5d:	74 f6                	je     800b55 <strtol+0xe>
  800b5f:	3c 09                	cmp    $0x9,%al
  800b61:	74 f2                	je     800b55 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b63:	3c 2b                	cmp    $0x2b,%al
  800b65:	74 2e                	je     800b95 <strtol+0x4e>
	int neg = 0;
  800b67:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b6c:	3c 2d                	cmp    $0x2d,%al
  800b6e:	74 2f                	je     800b9f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b70:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b76:	75 05                	jne    800b7d <strtol+0x36>
  800b78:	80 39 30             	cmpb   $0x30,(%ecx)
  800b7b:	74 2c                	je     800ba9 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b7d:	85 db                	test   %ebx,%ebx
  800b7f:	75 0a                	jne    800b8b <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b81:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b86:	80 39 30             	cmpb   $0x30,(%ecx)
  800b89:	74 28                	je     800bb3 <strtol+0x6c>
		base = 10;
  800b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b90:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b93:	eb 50                	jmp    800be5 <strtol+0x9e>
		s++;
  800b95:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b98:	bf 00 00 00 00       	mov    $0x0,%edi
  800b9d:	eb d1                	jmp    800b70 <strtol+0x29>
		s++, neg = 1;
  800b9f:	83 c1 01             	add    $0x1,%ecx
  800ba2:	bf 01 00 00 00       	mov    $0x1,%edi
  800ba7:	eb c7                	jmp    800b70 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bad:	74 0e                	je     800bbd <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800baf:	85 db                	test   %ebx,%ebx
  800bb1:	75 d8                	jne    800b8b <strtol+0x44>
		s++, base = 8;
  800bb3:	83 c1 01             	add    $0x1,%ecx
  800bb6:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bbb:	eb ce                	jmp    800b8b <strtol+0x44>
		s += 2, base = 16;
  800bbd:	83 c1 02             	add    $0x2,%ecx
  800bc0:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bc5:	eb c4                	jmp    800b8b <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bc7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bca:	89 f3                	mov    %esi,%ebx
  800bcc:	80 fb 19             	cmp    $0x19,%bl
  800bcf:	77 29                	ja     800bfa <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bd1:	0f be d2             	movsbl %dl,%edx
  800bd4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bd7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bda:	7d 30                	jge    800c0c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bdc:	83 c1 01             	add    $0x1,%ecx
  800bdf:	0f af 45 10          	imul   0x10(%ebp),%eax
  800be3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800be5:	0f b6 11             	movzbl (%ecx),%edx
  800be8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800beb:	89 f3                	mov    %esi,%ebx
  800bed:	80 fb 09             	cmp    $0x9,%bl
  800bf0:	77 d5                	ja     800bc7 <strtol+0x80>
			dig = *s - '0';
  800bf2:	0f be d2             	movsbl %dl,%edx
  800bf5:	83 ea 30             	sub    $0x30,%edx
  800bf8:	eb dd                	jmp    800bd7 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800bfa:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bfd:	89 f3                	mov    %esi,%ebx
  800bff:	80 fb 19             	cmp    $0x19,%bl
  800c02:	77 08                	ja     800c0c <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c04:	0f be d2             	movsbl %dl,%edx
  800c07:	83 ea 37             	sub    $0x37,%edx
  800c0a:	eb cb                	jmp    800bd7 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c10:	74 05                	je     800c17 <strtol+0xd0>
		*endptr = (char *) s;
  800c12:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c15:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c17:	89 c2                	mov    %eax,%edx
  800c19:	f7 da                	neg    %edx
  800c1b:	85 ff                	test   %edi,%edi
  800c1d:	0f 45 c2             	cmovne %edx,%eax
}
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	57                   	push   %edi
  800c29:	56                   	push   %esi
  800c2a:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c30:	8b 55 08             	mov    0x8(%ebp),%edx
  800c33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c36:	89 c3                	mov    %eax,%ebx
  800c38:	89 c7                	mov    %eax,%edi
  800c3a:	89 c6                	mov    %eax,%esi
  800c3c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c3e:	5b                   	pop    %ebx
  800c3f:	5e                   	pop    %esi
  800c40:	5f                   	pop    %edi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	57                   	push   %edi
  800c47:	56                   	push   %esi
  800c48:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c49:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4e:	b8 01 00 00 00       	mov    $0x1,%eax
  800c53:	89 d1                	mov    %edx,%ecx
  800c55:	89 d3                	mov    %edx,%ebx
  800c57:	89 d7                	mov    %edx,%edi
  800c59:	89 d6                	mov    %edx,%esi
  800c5b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5f                   	pop    %edi
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	57                   	push   %edi
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
  800c68:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c6b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c70:	8b 55 08             	mov    0x8(%ebp),%edx
  800c73:	b8 03 00 00 00       	mov    $0x3,%eax
  800c78:	89 cb                	mov    %ecx,%ebx
  800c7a:	89 cf                	mov    %ecx,%edi
  800c7c:	89 ce                	mov    %ecx,%esi
  800c7e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c80:	85 c0                	test   %eax,%eax
  800c82:	7f 08                	jg     800c8c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5f                   	pop    %edi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8c:	83 ec 0c             	sub    $0xc,%esp
  800c8f:	50                   	push   %eax
  800c90:	6a 03                	push   $0x3
  800c92:	68 1f 2c 80 00       	push   $0x802c1f
  800c97:	6a 23                	push   $0x23
  800c99:	68 3c 2c 80 00       	push   $0x802c3c
  800c9e:	e8 4b f5 ff ff       	call   8001ee <_panic>

00800ca3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ca9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cae:	b8 02 00 00 00       	mov    $0x2,%eax
  800cb3:	89 d1                	mov    %edx,%ecx
  800cb5:	89 d3                	mov    %edx,%ebx
  800cb7:	89 d7                	mov    %edx,%edi
  800cb9:	89 d6                	mov    %edx,%esi
  800cbb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cbd:	5b                   	pop    %ebx
  800cbe:	5e                   	pop    %esi
  800cbf:	5f                   	pop    %edi
  800cc0:	5d                   	pop    %ebp
  800cc1:	c3                   	ret    

00800cc2 <sys_yield>:

void
sys_yield(void)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800cc8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccd:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cd2:	89 d1                	mov    %edx,%ecx
  800cd4:	89 d3                	mov    %edx,%ebx
  800cd6:	89 d7                	mov    %edx,%edi
  800cd8:	89 d6                	mov    %edx,%esi
  800cda:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5f                   	pop    %edi
  800cdf:	5d                   	pop    %ebp
  800ce0:	c3                   	ret    

00800ce1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	57                   	push   %edi
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
  800ce7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800cea:	be 00 00 00 00       	mov    $0x0,%esi
  800cef:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf5:	b8 04 00 00 00       	mov    $0x4,%eax
  800cfa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfd:	89 f7                	mov    %esi,%edi
  800cff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d01:	85 c0                	test   %eax,%eax
  800d03:	7f 08                	jg     800d0d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d08:	5b                   	pop    %ebx
  800d09:	5e                   	pop    %esi
  800d0a:	5f                   	pop    %edi
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0d:	83 ec 0c             	sub    $0xc,%esp
  800d10:	50                   	push   %eax
  800d11:	6a 04                	push   $0x4
  800d13:	68 1f 2c 80 00       	push   $0x802c1f
  800d18:	6a 23                	push   $0x23
  800d1a:	68 3c 2c 80 00       	push   $0x802c3c
  800d1f:	e8 ca f4 ff ff       	call   8001ee <_panic>

00800d24 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
  800d2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d33:	b8 05 00 00 00       	mov    $0x5,%eax
  800d38:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d3b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d3e:	8b 75 18             	mov    0x18(%ebp),%esi
  800d41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d43:	85 c0                	test   %eax,%eax
  800d45:	7f 08                	jg     800d4f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4a:	5b                   	pop    %ebx
  800d4b:	5e                   	pop    %esi
  800d4c:	5f                   	pop    %edi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4f:	83 ec 0c             	sub    $0xc,%esp
  800d52:	50                   	push   %eax
  800d53:	6a 05                	push   $0x5
  800d55:	68 1f 2c 80 00       	push   $0x802c1f
  800d5a:	6a 23                	push   $0x23
  800d5c:	68 3c 2c 80 00       	push   $0x802c3c
  800d61:	e8 88 f4 ff ff       	call   8001ee <_panic>

00800d66 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	57                   	push   %edi
  800d6a:	56                   	push   %esi
  800d6b:	53                   	push   %ebx
  800d6c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d74:	8b 55 08             	mov    0x8(%ebp),%edx
  800d77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7a:	b8 06 00 00 00       	mov    $0x6,%eax
  800d7f:	89 df                	mov    %ebx,%edi
  800d81:	89 de                	mov    %ebx,%esi
  800d83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d85:	85 c0                	test   %eax,%eax
  800d87:	7f 08                	jg     800d91 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8c:	5b                   	pop    %ebx
  800d8d:	5e                   	pop    %esi
  800d8e:	5f                   	pop    %edi
  800d8f:	5d                   	pop    %ebp
  800d90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d91:	83 ec 0c             	sub    $0xc,%esp
  800d94:	50                   	push   %eax
  800d95:	6a 06                	push   $0x6
  800d97:	68 1f 2c 80 00       	push   $0x802c1f
  800d9c:	6a 23                	push   $0x23
  800d9e:	68 3c 2c 80 00       	push   $0x802c3c
  800da3:	e8 46 f4 ff ff       	call   8001ee <_panic>

00800da8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	57                   	push   %edi
  800dac:	56                   	push   %esi
  800dad:	53                   	push   %ebx
  800dae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800db1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db6:	8b 55 08             	mov    0x8(%ebp),%edx
  800db9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbc:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc1:	89 df                	mov    %ebx,%edi
  800dc3:	89 de                	mov    %ebx,%esi
  800dc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	7f 08                	jg     800dd3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd3:	83 ec 0c             	sub    $0xc,%esp
  800dd6:	50                   	push   %eax
  800dd7:	6a 08                	push   $0x8
  800dd9:	68 1f 2c 80 00       	push   $0x802c1f
  800dde:	6a 23                	push   $0x23
  800de0:	68 3c 2c 80 00       	push   $0x802c3c
  800de5:	e8 04 f4 ff ff       	call   8001ee <_panic>

00800dea <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	57                   	push   %edi
  800dee:	56                   	push   %esi
  800def:	53                   	push   %ebx
  800df0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800df3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfe:	b8 09 00 00 00       	mov    $0x9,%eax
  800e03:	89 df                	mov    %ebx,%edi
  800e05:	89 de                	mov    %ebx,%esi
  800e07:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	7f 08                	jg     800e15 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e10:	5b                   	pop    %ebx
  800e11:	5e                   	pop    %esi
  800e12:	5f                   	pop    %edi
  800e13:	5d                   	pop    %ebp
  800e14:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e15:	83 ec 0c             	sub    $0xc,%esp
  800e18:	50                   	push   %eax
  800e19:	6a 09                	push   $0x9
  800e1b:	68 1f 2c 80 00       	push   $0x802c1f
  800e20:	6a 23                	push   $0x23
  800e22:	68 3c 2c 80 00       	push   $0x802c3c
  800e27:	e8 c2 f3 ff ff       	call   8001ee <_panic>

00800e2c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	57                   	push   %edi
  800e30:	56                   	push   %esi
  800e31:	53                   	push   %ebx
  800e32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e35:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e40:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e45:	89 df                	mov    %ebx,%edi
  800e47:	89 de                	mov    %ebx,%esi
  800e49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4b:	85 c0                	test   %eax,%eax
  800e4d:	7f 08                	jg     800e57 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e52:	5b                   	pop    %ebx
  800e53:	5e                   	pop    %esi
  800e54:	5f                   	pop    %edi
  800e55:	5d                   	pop    %ebp
  800e56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e57:	83 ec 0c             	sub    $0xc,%esp
  800e5a:	50                   	push   %eax
  800e5b:	6a 0a                	push   $0xa
  800e5d:	68 1f 2c 80 00       	push   $0x802c1f
  800e62:	6a 23                	push   $0x23
  800e64:	68 3c 2c 80 00       	push   $0x802c3c
  800e69:	e8 80 f3 ff ff       	call   8001ee <_panic>

00800e6e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	57                   	push   %edi
  800e72:	56                   	push   %esi
  800e73:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e74:	8b 55 08             	mov    0x8(%ebp),%edx
  800e77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e7f:	be 00 00 00 00       	mov    $0x0,%esi
  800e84:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e87:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e8a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e8c:	5b                   	pop    %ebx
  800e8d:	5e                   	pop    %esi
  800e8e:	5f                   	pop    %edi
  800e8f:	5d                   	pop    %ebp
  800e90:	c3                   	ret    

00800e91 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	57                   	push   %edi
  800e95:	56                   	push   %esi
  800e96:	53                   	push   %ebx
  800e97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e9a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea2:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ea7:	89 cb                	mov    %ecx,%ebx
  800ea9:	89 cf                	mov    %ecx,%edi
  800eab:	89 ce                	mov    %ecx,%esi
  800ead:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	7f 08                	jg     800ebb <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb6:	5b                   	pop    %ebx
  800eb7:	5e                   	pop    %esi
  800eb8:	5f                   	pop    %edi
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebb:	83 ec 0c             	sub    $0xc,%esp
  800ebe:	50                   	push   %eax
  800ebf:	6a 0d                	push   $0xd
  800ec1:	68 1f 2c 80 00       	push   $0x802c1f
  800ec6:	6a 23                	push   $0x23
  800ec8:	68 3c 2c 80 00       	push   $0x802c3c
  800ecd:	e8 1c f3 ff ff       	call   8001ee <_panic>

00800ed2 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	53                   	push   %ebx
  800ed6:	83 ec 04             	sub    $0x4,%esp
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800edc:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) { //只有因为写操作写时拷贝的地址这中情况，才可以抢救。否则一律panic
  800ede:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ee2:	74 74                	je     800f58 <pgfault+0x86>
  800ee4:	89 d8                	mov    %ebx,%eax
  800ee6:	c1 e8 0c             	shr    $0xc,%eax
  800ee9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ef0:	f6 c4 08             	test   $0x8,%ah
  800ef3:	74 63                	je     800f58 <pgfault+0x86>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800ef5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, PFTEMP, PTE_U|PTE_P)) < 0)		//将当前进程PFTEMP也映射到当前进程addr指向的物理页
  800efb:	83 ec 0c             	sub    $0xc,%esp
  800efe:	6a 05                	push   $0x5
  800f00:	68 00 f0 7f 00       	push   $0x7ff000
  800f05:	6a 00                	push   $0x0
  800f07:	53                   	push   %ebx
  800f08:	6a 00                	push   $0x0
  800f0a:	e8 15 fe ff ff       	call   800d24 <sys_page_map>
  800f0f:	83 c4 20             	add    $0x20,%esp
  800f12:	85 c0                	test   %eax,%eax
  800f14:	78 56                	js     800f6c <pgfault+0x9a>
		panic("sys_page_map: %e", r);
	if ((r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W)) < 0)	//令当前进程addr指向新分配的物理页
  800f16:	83 ec 04             	sub    $0x4,%esp
  800f19:	6a 07                	push   $0x7
  800f1b:	53                   	push   %ebx
  800f1c:	6a 00                	push   $0x0
  800f1e:	e8 be fd ff ff       	call   800ce1 <sys_page_alloc>
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	85 c0                	test   %eax,%eax
  800f28:	78 54                	js     800f7e <pgfault+0xac>
		panic("sys_page_alloc: %e", r);
	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800f2a:	83 ec 04             	sub    $0x4,%esp
  800f2d:	68 00 10 00 00       	push   $0x1000
  800f32:	68 00 f0 7f 00       	push   $0x7ff000
  800f37:	53                   	push   %ebx
  800f38:	e8 39 fb ff ff       	call   800a76 <memmove>
	if ((r = sys_page_unmap(0, PFTEMP)) < 0)					//解除当前进程PFTEMP映射
  800f3d:	83 c4 08             	add    $0x8,%esp
  800f40:	68 00 f0 7f 00       	push   $0x7ff000
  800f45:	6a 00                	push   $0x0
  800f47:	e8 1a fe ff ff       	call   800d66 <sys_page_unmap>
  800f4c:	83 c4 10             	add    $0x10,%esp
  800f4f:	85 c0                	test   %eax,%eax
  800f51:	78 3d                	js     800f90 <pgfault+0xbe>
		panic("sys_page_unmap: %e", r);
}
  800f53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    
		panic("pgfault():not cow");
  800f58:	83 ec 04             	sub    $0x4,%esp
  800f5b:	68 4a 2c 80 00       	push   $0x802c4a
  800f60:	6a 1d                	push   $0x1d
  800f62:	68 5c 2c 80 00       	push   $0x802c5c
  800f67:	e8 82 f2 ff ff       	call   8001ee <_panic>
		panic("sys_page_map: %e", r);
  800f6c:	50                   	push   %eax
  800f6d:	68 67 2c 80 00       	push   $0x802c67
  800f72:	6a 2a                	push   $0x2a
  800f74:	68 5c 2c 80 00       	push   $0x802c5c
  800f79:	e8 70 f2 ff ff       	call   8001ee <_panic>
		panic("sys_page_alloc: %e", r);
  800f7e:	50                   	push   %eax
  800f7f:	68 4c 28 80 00       	push   $0x80284c
  800f84:	6a 2c                	push   $0x2c
  800f86:	68 5c 2c 80 00       	push   $0x802c5c
  800f8b:	e8 5e f2 ff ff       	call   8001ee <_panic>
		panic("sys_page_unmap: %e", r);
  800f90:	50                   	push   %eax
  800f91:	68 78 2c 80 00       	push   $0x802c78
  800f96:	6a 2f                	push   $0x2f
  800f98:	68 5c 2c 80 00       	push   $0x802c5c
  800f9d:	e8 4c f2 ff ff       	call   8001ee <_panic>

00800fa2 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	57                   	push   %edi
  800fa6:	56                   	push   %esi
  800fa7:	53                   	push   %ebx
  800fa8:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);	//设置缺页处理函数
  800fab:	68 d2 0e 80 00       	push   $0x800ed2
  800fb0:	e8 96 07 00 00       	call   80174b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fb5:	b8 07 00 00 00       	mov    $0x7,%eax
  800fba:	cd 30                	int    $0x30
  800fbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();	//系统调用，只是简单创建一个Env结构，复制当前用户环境寄存器状态，UTOP以下的页目录还没有建立
	if (envid == 0) {				//子进程将走这个逻辑
  800fbf:	83 c4 10             	add    $0x10,%esp
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	74 12                	je     800fd8 <fork+0x36>
  800fc6:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	if (envid < 0) {
  800fc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fcc:	78 26                	js     800ff4 <fork+0x52>
		panic("sys_exofork: %e", envid);
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fce:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd3:	e9 94 00 00 00       	jmp    80106c <fork+0xca>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fd8:	e8 c6 fc ff ff       	call   800ca3 <sys_getenvid>
  800fdd:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fe2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fe5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fea:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800fef:	e9 51 01 00 00       	jmp    801145 <fork+0x1a3>
		panic("sys_exofork: %e", envid);
  800ff4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ff7:	68 8b 2c 80 00       	push   $0x802c8b
  800ffc:	6a 6d                	push   $0x6d
  800ffe:	68 5c 2c 80 00       	push   $0x802c5c
  801003:	e8 e6 f1 ff ff       	call   8001ee <_panic>
		sys_page_map(0, addr, envid, addr, PTE_SYSCALL);		//对于表示为PTE_SHARE的页，拷贝映射关系，并且两个进程都有读写权限
  801008:	83 ec 0c             	sub    $0xc,%esp
  80100b:	68 07 0e 00 00       	push   $0xe07
  801010:	56                   	push   %esi
  801011:	57                   	push   %edi
  801012:	56                   	push   %esi
  801013:	6a 00                	push   $0x0
  801015:	e8 0a fd ff ff       	call   800d24 <sys_page_map>
  80101a:	83 c4 20             	add    $0x20,%esp
  80101d:	eb 3b                	jmp    80105a <fork+0xb8>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  80101f:	83 ec 0c             	sub    $0xc,%esp
  801022:	68 05 08 00 00       	push   $0x805
  801027:	56                   	push   %esi
  801028:	57                   	push   %edi
  801029:	56                   	push   %esi
  80102a:	6a 00                	push   $0x0
  80102c:	e8 f3 fc ff ff       	call   800d24 <sys_page_map>
  801031:	83 c4 20             	add    $0x20,%esp
  801034:	85 c0                	test   %eax,%eax
  801036:	0f 88 a9 00 00 00    	js     8010e5 <fork+0x143>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  80103c:	83 ec 0c             	sub    $0xc,%esp
  80103f:	68 05 08 00 00       	push   $0x805
  801044:	56                   	push   %esi
  801045:	6a 00                	push   $0x0
  801047:	56                   	push   %esi
  801048:	6a 00                	push   $0x0
  80104a:	e8 d5 fc ff ff       	call   800d24 <sys_page_map>
  80104f:	83 c4 20             	add    $0x20,%esp
  801052:	85 c0                	test   %eax,%eax
  801054:	0f 88 9d 00 00 00    	js     8010f7 <fork+0x155>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80105a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801060:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801066:	0f 84 9d 00 00 00    	je     801109 <fork+0x167>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) //为什么uvpt[pagenumber]能访问到第pagenumber项页表条目：https://pdos.csail.mit.edu/6.828/2018/labs/lab4/uvpt.html
  80106c:	89 d8                	mov    %ebx,%eax
  80106e:	c1 e8 16             	shr    $0x16,%eax
  801071:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801078:	a8 01                	test   $0x1,%al
  80107a:	74 de                	je     80105a <fork+0xb8>
  80107c:	89 d8                	mov    %ebx,%eax
  80107e:	c1 e8 0c             	shr    $0xc,%eax
  801081:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801088:	f6 c2 01             	test   $0x1,%dl
  80108b:	74 cd                	je     80105a <fork+0xb8>
			&& (uvpt[PGNUM(addr)] & PTE_U)) {
  80108d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801094:	f6 c2 04             	test   $0x4,%dl
  801097:	74 c1                	je     80105a <fork+0xb8>
	void *addr = (void*) (pn * PGSIZE);
  801099:	89 c6                	mov    %eax,%esi
  80109b:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE) {
  80109e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010a5:	f6 c6 04             	test   $0x4,%dh
  8010a8:	0f 85 5a ff ff ff    	jne    801008 <fork+0x66>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) { //对于UTOP以下的可写的或者写时拷贝的页，拷贝映射关系的同时，需要同时标记当前进程和子进程的页表项为PTE_COW
  8010ae:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010b5:	f6 c2 02             	test   $0x2,%dl
  8010b8:	0f 85 61 ff ff ff    	jne    80101f <fork+0x7d>
  8010be:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010c5:	f6 c4 08             	test   $0x8,%ah
  8010c8:	0f 85 51 ff ff ff    	jne    80101f <fork+0x7d>
		sys_page_map(0, addr, envid, addr, PTE_U|PTE_P);	//对于只读的页，只需要拷贝映射关系即可
  8010ce:	83 ec 0c             	sub    $0xc,%esp
  8010d1:	6a 05                	push   $0x5
  8010d3:	56                   	push   %esi
  8010d4:	57                   	push   %edi
  8010d5:	56                   	push   %esi
  8010d6:	6a 00                	push   $0x0
  8010d8:	e8 47 fc ff ff       	call   800d24 <sys_page_map>
  8010dd:	83 c4 20             	add    $0x20,%esp
  8010e0:	e9 75 ff ff ff       	jmp    80105a <fork+0xb8>
			panic("sys_page_map：%e", r);
  8010e5:	50                   	push   %eax
  8010e6:	68 9b 2c 80 00       	push   $0x802c9b
  8010eb:	6a 48                	push   $0x48
  8010ed:	68 5c 2c 80 00       	push   $0x802c5c
  8010f2:	e8 f7 f0 ff ff       	call   8001ee <_panic>
			panic("sys_page_map：%e", r);
  8010f7:	50                   	push   %eax
  8010f8:	68 9b 2c 80 00       	push   $0x802c9b
  8010fd:	6a 4a                	push   $0x4a
  8010ff:	68 5c 2c 80 00       	push   $0x802c5c
  801104:	e8 e5 f0 ff ff       	call   8001ee <_panic>
			duppage(envid, PGNUM(addr));	//拷贝当前进程映射关系到子进程
		}
	}
	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_W | PTE_U)) < 0)	//为子进程分配异常栈
  801109:	83 ec 04             	sub    $0x4,%esp
  80110c:	6a 07                	push   $0x7
  80110e:	68 00 f0 bf ee       	push   $0xeebff000
  801113:	ff 75 e4             	pushl  -0x1c(%ebp)
  801116:	e8 c6 fb ff ff       	call   800ce1 <sys_page_alloc>
  80111b:	83 c4 10             	add    $0x10,%esp
  80111e:	85 c0                	test   %eax,%eax
  801120:	78 2e                	js     801150 <fork+0x1ae>
		panic("sys_page_alloc: %e", r);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);		//为子进程设置_pgfault_upcall
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	68 a4 17 80 00       	push   $0x8017a4
  80112a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80112d:	57                   	push   %edi
  80112e:	e8 f9 fc ff ff       	call   800e2c <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)	//设置子进程为ENV_RUNNABLE状态
  801133:	83 c4 08             	add    $0x8,%esp
  801136:	6a 02                	push   $0x2
  801138:	57                   	push   %edi
  801139:	e8 6a fc ff ff       	call   800da8 <sys_env_set_status>
  80113e:	83 c4 10             	add    $0x10,%esp
  801141:	85 c0                	test   %eax,%eax
  801143:	78 1d                	js     801162 <fork+0x1c0>
		panic("sys_env_set_status: %e", r);
	return envid;
}
  801145:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801148:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114b:	5b                   	pop    %ebx
  80114c:	5e                   	pop    %esi
  80114d:	5f                   	pop    %edi
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801150:	50                   	push   %eax
  801151:	68 4c 28 80 00       	push   $0x80284c
  801156:	6a 79                	push   $0x79
  801158:	68 5c 2c 80 00       	push   $0x802c5c
  80115d:	e8 8c f0 ff ff       	call   8001ee <_panic>
		panic("sys_env_set_status: %e", r);
  801162:	50                   	push   %eax
  801163:	68 ad 2c 80 00       	push   $0x802cad
  801168:	6a 7d                	push   $0x7d
  80116a:	68 5c 2c 80 00       	push   $0x802c5c
  80116f:	e8 7a f0 ff ff       	call   8001ee <_panic>

00801174 <sfork>:

// Challenge!
int
sfork(void)
{
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80117a:	68 c4 2c 80 00       	push   $0x802cc4
  80117f:	68 85 00 00 00       	push   $0x85
  801184:	68 5c 2c 80 00       	push   $0x802c5c
  801189:	e8 60 f0 ff ff       	call   8001ee <_panic>

0080118e <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	57                   	push   %edi
  801192:	56                   	push   %esi
  801193:	53                   	push   %ebx
  801194:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80119a:	6a 00                	push   $0x0
  80119c:	ff 75 08             	pushl  0x8(%ebp)
  80119f:	e8 b9 0d 00 00       	call   801f5d <open>
  8011a4:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	85 c0                	test   %eax,%eax
  8011af:	0f 88 40 03 00 00    	js     8014f5 <spawn+0x367>
  8011b5:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8011b7:	83 ec 04             	sub    $0x4,%esp
  8011ba:	68 00 02 00 00       	push   $0x200
  8011bf:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8011c5:	50                   	push   %eax
  8011c6:	52                   	push   %edx
  8011c7:	e8 6a 09 00 00       	call   801b36 <readn>
  8011cc:	83 c4 10             	add    $0x10,%esp
  8011cf:	3d 00 02 00 00       	cmp    $0x200,%eax
  8011d4:	75 5d                	jne    801233 <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  8011d6:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8011dd:	45 4c 46 
  8011e0:	75 51                	jne    801233 <spawn+0xa5>
  8011e2:	b8 07 00 00 00       	mov    $0x7,%eax
  8011e7:	cd 30                	int    $0x30
  8011e9:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8011ef:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	0f 88 2f 04 00 00    	js     80162c <spawn+0x49e>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8011fd:	25 ff 03 00 00       	and    $0x3ff,%eax
  801202:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801205:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80120b:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801211:	b9 11 00 00 00       	mov    $0x11,%ecx
  801216:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801218:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80121e:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801224:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801229:	be 00 00 00 00       	mov    $0x0,%esi
  80122e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801231:	eb 4b                	jmp    80127e <spawn+0xf0>
		close(fd);
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80123c:	e8 32 07 00 00       	call   801973 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801241:	83 c4 0c             	add    $0xc,%esp
  801244:	68 7f 45 4c 46       	push   $0x464c457f
  801249:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80124f:	68 da 2c 80 00       	push   $0x802cda
  801254:	e8 70 f0 ff ff       	call   8002c9 <cprintf>
		return -E_NOT_EXEC;
  801259:	83 c4 10             	add    $0x10,%esp
  80125c:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  801263:	ff ff ff 
  801266:	e9 8a 02 00 00       	jmp    8014f5 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  80126b:	83 ec 0c             	sub    $0xc,%esp
  80126e:	50                   	push   %eax
  80126f:	e8 3d f6 ff ff       	call   8008b1 <strlen>
  801274:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801278:	83 c3 01             	add    $0x1,%ebx
  80127b:	83 c4 10             	add    $0x10,%esp
  80127e:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801285:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801288:	85 c0                	test   %eax,%eax
  80128a:	75 df                	jne    80126b <spawn+0xdd>
  80128c:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801292:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801298:	bf 00 10 40 00       	mov    $0x401000,%edi
  80129d:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80129f:	89 fa                	mov    %edi,%edx
  8012a1:	83 e2 fc             	and    $0xfffffffc,%edx
  8012a4:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8012ab:	29 c2                	sub    %eax,%edx
  8012ad:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8012b3:	8d 42 f8             	lea    -0x8(%edx),%eax
  8012b6:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8012bb:	0f 86 7c 03 00 00    	jbe    80163d <spawn+0x4af>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8012c1:	83 ec 04             	sub    $0x4,%esp
  8012c4:	6a 07                	push   $0x7
  8012c6:	68 00 00 40 00       	push   $0x400000
  8012cb:	6a 00                	push   $0x0
  8012cd:	e8 0f fa ff ff       	call   800ce1 <sys_page_alloc>
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	0f 88 65 03 00 00    	js     801642 <spawn+0x4b4>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8012dd:	be 00 00 00 00       	mov    $0x0,%esi
  8012e2:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8012e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012eb:	eb 30                	jmp    80131d <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  8012ed:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8012f3:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8012f9:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  8012fc:	83 ec 08             	sub    $0x8,%esp
  8012ff:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801302:	57                   	push   %edi
  801303:	e8 e0 f5 ff ff       	call   8008e8 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801308:	83 c4 04             	add    $0x4,%esp
  80130b:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80130e:	e8 9e f5 ff ff       	call   8008b1 <strlen>
  801313:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801317:	83 c6 01             	add    $0x1,%esi
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801323:	7f c8                	jg     8012ed <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801325:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80132b:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801331:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801338:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80133e:	0f 85 8c 00 00 00    	jne    8013d0 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801344:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  80134a:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801350:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801353:	89 f8                	mov    %edi,%eax
  801355:	8b 8d 88 fd ff ff    	mov    -0x278(%ebp),%ecx
  80135b:	89 4f f8             	mov    %ecx,-0x8(%edi)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80135e:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801363:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801369:	83 ec 0c             	sub    $0xc,%esp
  80136c:	6a 07                	push   $0x7
  80136e:	68 00 d0 bf ee       	push   $0xeebfd000
  801373:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801379:	68 00 00 40 00       	push   $0x400000
  80137e:	6a 00                	push   $0x0
  801380:	e8 9f f9 ff ff       	call   800d24 <sys_page_map>
  801385:	89 c3                	mov    %eax,%ebx
  801387:	83 c4 20             	add    $0x20,%esp
  80138a:	85 c0                	test   %eax,%eax
  80138c:	0f 88 d0 02 00 00    	js     801662 <spawn+0x4d4>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801392:	83 ec 08             	sub    $0x8,%esp
  801395:	68 00 00 40 00       	push   $0x400000
  80139a:	6a 00                	push   $0x0
  80139c:	e8 c5 f9 ff ff       	call   800d66 <sys_page_unmap>
  8013a1:	89 c3                	mov    %eax,%ebx
  8013a3:	83 c4 10             	add    $0x10,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	0f 88 b4 02 00 00    	js     801662 <spawn+0x4d4>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8013ae:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8013b4:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8013bb:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8013c1:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8013c8:	00 00 00 
  8013cb:	e9 56 01 00 00       	jmp    801526 <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8013d0:	68 4c 2d 80 00       	push   $0x802d4c
  8013d5:	68 f4 2c 80 00       	push   $0x802cf4
  8013da:	68 f2 00 00 00       	push   $0xf2
  8013df:	68 09 2d 80 00       	push   $0x802d09
  8013e4:	e8 05 ee ff ff       	call   8001ee <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8013e9:	83 ec 04             	sub    $0x4,%esp
  8013ec:	6a 07                	push   $0x7
  8013ee:	68 00 00 40 00       	push   $0x400000
  8013f3:	6a 00                	push   $0x0
  8013f5:	e8 e7 f8 ff ff       	call   800ce1 <sys_page_alloc>
  8013fa:	83 c4 10             	add    $0x10,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	0f 88 48 02 00 00    	js     80164d <spawn+0x4bf>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801405:	83 ec 08             	sub    $0x8,%esp
  801408:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80140e:	01 f0                	add    %esi,%eax
  801410:	50                   	push   %eax
  801411:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801417:	e8 e3 07 00 00       	call   801bff <seek>
  80141c:	83 c4 10             	add    $0x10,%esp
  80141f:	85 c0                	test   %eax,%eax
  801421:	0f 88 2d 02 00 00    	js     801654 <spawn+0x4c6>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801427:	83 ec 04             	sub    $0x4,%esp
  80142a:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801430:	29 f0                	sub    %esi,%eax
  801432:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801437:	ba 00 10 00 00       	mov    $0x1000,%edx
  80143c:	0f 47 c2             	cmova  %edx,%eax
  80143f:	50                   	push   %eax
  801440:	68 00 00 40 00       	push   $0x400000
  801445:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80144b:	e8 e6 06 00 00       	call   801b36 <readn>
  801450:	83 c4 10             	add    $0x10,%esp
  801453:	85 c0                	test   %eax,%eax
  801455:	0f 88 00 02 00 00    	js     80165b <spawn+0x4cd>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80145b:	83 ec 0c             	sub    $0xc,%esp
  80145e:	57                   	push   %edi
  80145f:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801465:	56                   	push   %esi
  801466:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  80146c:	68 00 00 40 00       	push   $0x400000
  801471:	6a 00                	push   $0x0
  801473:	e8 ac f8 ff ff       	call   800d24 <sys_page_map>
  801478:	83 c4 20             	add    $0x20,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	0f 88 80 00 00 00    	js     801503 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801483:	83 ec 08             	sub    $0x8,%esp
  801486:	68 00 00 40 00       	push   $0x400000
  80148b:	6a 00                	push   $0x0
  80148d:	e8 d4 f8 ff ff       	call   800d66 <sys_page_unmap>
  801492:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801495:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80149b:	89 de                	mov    %ebx,%esi
  80149d:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  8014a3:	76 73                	jbe    801518 <spawn+0x38a>
		if (i >= filesz) {
  8014a5:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  8014ab:	0f 87 38 ff ff ff    	ja     8013e9 <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	57                   	push   %edi
  8014b5:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  8014bb:	56                   	push   %esi
  8014bc:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  8014c2:	e8 1a f8 ff ff       	call   800ce1 <sys_page_alloc>
  8014c7:	83 c4 10             	add    $0x10,%esp
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	79 c7                	jns    801495 <spawn+0x307>
  8014ce:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8014d0:	83 ec 0c             	sub    $0xc,%esp
  8014d3:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8014d9:	e8 84 f7 ff ff       	call   800c62 <sys_env_destroy>
	close(fd);
  8014de:	83 c4 04             	add    $0x4,%esp
  8014e1:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8014e7:	e8 87 04 00 00       	call   801973 <close>
	return r;
  8014ec:	83 c4 10             	add    $0x10,%esp
  8014ef:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  8014f5:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8014fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014fe:	5b                   	pop    %ebx
  8014ff:	5e                   	pop    %esi
  801500:	5f                   	pop    %edi
  801501:	5d                   	pop    %ebp
  801502:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801503:	50                   	push   %eax
  801504:	68 15 2d 80 00       	push   $0x802d15
  801509:	68 25 01 00 00       	push   $0x125
  80150e:	68 09 2d 80 00       	push   $0x802d09
  801513:	e8 d6 ec ff ff       	call   8001ee <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801518:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  80151f:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801526:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80152d:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801533:	7e 71                	jle    8015a6 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801535:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  80153b:	83 39 01             	cmpl   $0x1,(%ecx)
  80153e:	75 d8                	jne    801518 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801540:	8b 41 18             	mov    0x18(%ecx),%eax
  801543:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801546:	83 f8 01             	cmp    $0x1,%eax
  801549:	19 ff                	sbb    %edi,%edi
  80154b:	83 e7 fe             	and    $0xfffffffe,%edi
  80154e:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801551:	8b 59 04             	mov    0x4(%ecx),%ebx
  801554:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
  80155a:	8b 71 10             	mov    0x10(%ecx),%esi
  80155d:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
  801563:	8b 41 14             	mov    0x14(%ecx),%eax
  801566:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  80156c:	8b 51 08             	mov    0x8(%ecx),%edx
  80156f:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
	if ((i = PGOFF(va))) {
  801575:	89 d0                	mov    %edx,%eax
  801577:	25 ff 0f 00 00       	and    $0xfff,%eax
  80157c:	74 1e                	je     80159c <spawn+0x40e>
		va -= i;
  80157e:	29 c2                	sub    %eax,%edx
  801580:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		memsz += i;
  801586:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  80158c:	01 c6                	add    %eax,%esi
  80158e:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
		fileoffset -= i;
  801594:	29 c3                	sub    %eax,%ebx
  801596:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  80159c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a1:	e9 f5 fe ff ff       	jmp    80149b <spawn+0x30d>
	close(fd);
  8015a6:	83 ec 0c             	sub    $0xc,%esp
  8015a9:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8015af:	e8 bf 03 00 00       	call   801973 <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  8015b4:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  8015bb:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8015be:	83 c4 08             	add    $0x8,%esp
  8015c1:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8015c7:	50                   	push   %eax
  8015c8:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8015ce:	e8 17 f8 ff ff       	call   800dea <sys_env_set_trapframe>
  8015d3:	83 c4 10             	add    $0x10,%esp
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	78 28                	js     801602 <spawn+0x474>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8015da:	83 ec 08             	sub    $0x8,%esp
  8015dd:	6a 02                	push   $0x2
  8015df:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8015e5:	e8 be f7 ff ff       	call   800da8 <sys_env_set_status>
  8015ea:	83 c4 10             	add    $0x10,%esp
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	78 26                	js     801617 <spawn+0x489>
	return child;
  8015f1:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8015f7:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8015fd:	e9 f3 fe ff ff       	jmp    8014f5 <spawn+0x367>
		panic("sys_env_set_trapframe: %e", r);
  801602:	50                   	push   %eax
  801603:	68 32 2d 80 00       	push   $0x802d32
  801608:	68 86 00 00 00       	push   $0x86
  80160d:	68 09 2d 80 00       	push   $0x802d09
  801612:	e8 d7 eb ff ff       	call   8001ee <_panic>
		panic("sys_env_set_status: %e", r);
  801617:	50                   	push   %eax
  801618:	68 ad 2c 80 00       	push   $0x802cad
  80161d:	68 89 00 00 00       	push   $0x89
  801622:	68 09 2d 80 00       	push   $0x802d09
  801627:	e8 c2 eb ff ff       	call   8001ee <_panic>
		return r;
  80162c:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801632:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801638:	e9 b8 fe ff ff       	jmp    8014f5 <spawn+0x367>
		return -E_NO_MEM;
  80163d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801642:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801648:	e9 a8 fe ff ff       	jmp    8014f5 <spawn+0x367>
  80164d:	89 c7                	mov    %eax,%edi
  80164f:	e9 7c fe ff ff       	jmp    8014d0 <spawn+0x342>
  801654:	89 c7                	mov    %eax,%edi
  801656:	e9 75 fe ff ff       	jmp    8014d0 <spawn+0x342>
  80165b:	89 c7                	mov    %eax,%edi
  80165d:	e9 6e fe ff ff       	jmp    8014d0 <spawn+0x342>
	sys_page_unmap(0, UTEMP);
  801662:	83 ec 08             	sub    $0x8,%esp
  801665:	68 00 00 40 00       	push   $0x400000
  80166a:	6a 00                	push   $0x0
  80166c:	e8 f5 f6 ff ff       	call   800d66 <sys_page_unmap>
  801671:	83 c4 10             	add    $0x10,%esp
  801674:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  80167a:	e9 76 fe ff ff       	jmp    8014f5 <spawn+0x367>

0080167f <spawnl>:
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	57                   	push   %edi
  801683:	56                   	push   %esi
  801684:	53                   	push   %ebx
  801685:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801688:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  80168b:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801690:	eb 05                	jmp    801697 <spawnl+0x18>
		argc++;
  801692:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801695:	89 ca                	mov    %ecx,%edx
  801697:	8d 4a 04             	lea    0x4(%edx),%ecx
  80169a:	83 3a 00             	cmpl   $0x0,(%edx)
  80169d:	75 f3                	jne    801692 <spawnl+0x13>
	const char *argv[argc+2];
  80169f:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  8016a6:	83 e2 f0             	and    $0xfffffff0,%edx
  8016a9:	29 d4                	sub    %edx,%esp
  8016ab:	8d 54 24 03          	lea    0x3(%esp),%edx
  8016af:	c1 ea 02             	shr    $0x2,%edx
  8016b2:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8016b9:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8016bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016be:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8016c5:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8016cc:	00 
	va_start(vl, arg0);
  8016cd:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8016d0:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8016d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d7:	eb 0b                	jmp    8016e4 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  8016d9:	83 c0 01             	add    $0x1,%eax
  8016dc:	8b 39                	mov    (%ecx),%edi
  8016de:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8016e1:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8016e4:	39 d0                	cmp    %edx,%eax
  8016e6:	75 f1                	jne    8016d9 <spawnl+0x5a>
	return spawn(prog, argv);
  8016e8:	83 ec 08             	sub    $0x8,%esp
  8016eb:	56                   	push   %esi
  8016ec:	ff 75 08             	pushl  0x8(%ebp)
  8016ef:	e8 9a fa ff ff       	call   80118e <spawn>
}
  8016f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f7:	5b                   	pop    %ebx
  8016f8:	5e                   	pop    %esi
  8016f9:	5f                   	pop    %edi
  8016fa:	5d                   	pop    %ebp
  8016fb:	c3                   	ret    

008016fc <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	56                   	push   %esi
  801700:	53                   	push   %ebx
  801701:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801704:	85 f6                	test   %esi,%esi
  801706:	74 13                	je     80171b <wait+0x1f>
	e = &envs[ENVX(envid)];
  801708:	89 f3                	mov    %esi,%ebx
  80170a:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801710:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801713:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801719:	eb 1b                	jmp    801736 <wait+0x3a>
	assert(envid != 0);
  80171b:	68 72 2d 80 00       	push   $0x802d72
  801720:	68 f4 2c 80 00       	push   $0x802cf4
  801725:	6a 09                	push   $0x9
  801727:	68 7d 2d 80 00       	push   $0x802d7d
  80172c:	e8 bd ea ff ff       	call   8001ee <_panic>
		sys_yield();
  801731:	e8 8c f5 ff ff       	call   800cc2 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801736:	8b 43 48             	mov    0x48(%ebx),%eax
  801739:	39 f0                	cmp    %esi,%eax
  80173b:	75 07                	jne    801744 <wait+0x48>
  80173d:	8b 43 54             	mov    0x54(%ebx),%eax
  801740:	85 c0                	test   %eax,%eax
  801742:	75 ed                	jne    801731 <wait+0x35>
}
  801744:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801747:	5b                   	pop    %ebx
  801748:	5e                   	pop    %esi
  801749:	5d                   	pop    %ebp
  80174a:	c3                   	ret    

0080174b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801751:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801758:	74 0a                	je     801764 <set_pgfault_handler+0x19>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	a3 08 40 80 00       	mov    %eax,0x804008
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    
		int r = sys_page_alloc(0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P);	//为当前进程分配异常栈
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	6a 07                	push   $0x7
  801769:	68 00 f0 bf ee       	push   $0xeebff000
  80176e:	6a 00                	push   $0x0
  801770:	e8 6c f5 ff ff       	call   800ce1 <sys_page_alloc>
		if (r < 0) {
  801775:	83 c4 10             	add    $0x10,%esp
  801778:	85 c0                	test   %eax,%eax
  80177a:	78 14                	js     801790 <set_pgfault_handler+0x45>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
  80177c:	83 ec 08             	sub    $0x8,%esp
  80177f:	68 a4 17 80 00       	push   $0x8017a4
  801784:	6a 00                	push   $0x0
  801786:	e8 a1 f6 ff ff       	call   800e2c <sys_env_set_pgfault_upcall>
  80178b:	83 c4 10             	add    $0x10,%esp
  80178e:	eb ca                	jmp    80175a <set_pgfault_handler+0xf>
			panic("set_pgfault_handler:sys_page_alloc failed");;
  801790:	83 ec 04             	sub    $0x4,%esp
  801793:	68 88 2d 80 00       	push   $0x802d88
  801798:	6a 22                	push   $0x22
  80179a:	68 b2 2d 80 00       	push   $0x802db2
  80179f:	e8 4a ea ff ff       	call   8001ee <_panic>

008017a4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8017a4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8017a5:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax				//调用页处理函数
  8017aa:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8017ac:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp			//跳过utf_fault_va和utf_err
  8017af:	83 c4 08             	add    $0x8,%esp
	movl 40(%esp), %eax 	//保存中断发生时的esp到eax
  8017b2:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl 32(%esp), %ecx 	//保存终端发生时的eip到ecx
  8017b6:	8b 4c 24 20          	mov    0x20(%esp),%ecx
	movl %ecx, -4(%eax) 	//将中断发生时的esp值亚入到到原来的栈中
  8017ba:	89 48 fc             	mov    %ecx,-0x4(%eax)
	popal
  8017bd:	61                   	popa   
	addl $4, %esp			//跳过eip
  8017be:	83 c4 04             	add    $0x4,%esp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  8017c1:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8017c2:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	lea -4(%esp), %esp		//因为之前压入了eip的值但是没有减esp的值，所以现在需要将esp寄存器中的值减4
  8017c3:	8d 64 24 fc          	lea    -0x4(%esp),%esp
  8017c7:	c3                   	ret    

008017c8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	05 00 00 00 30       	add    $0x30000000,%eax
  8017d3:	c1 e8 0c             	shr    $0xc,%eax
}
  8017d6:	5d                   	pop    %ebp
  8017d7:	c3                   	ret    

008017d8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8017e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017e8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017ed:	5d                   	pop    %ebp
  8017ee:	c3                   	ret    

008017ef <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017fa:	89 c2                	mov    %eax,%edx
  8017fc:	c1 ea 16             	shr    $0x16,%edx
  8017ff:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801806:	f6 c2 01             	test   $0x1,%dl
  801809:	74 2a                	je     801835 <fd_alloc+0x46>
  80180b:	89 c2                	mov    %eax,%edx
  80180d:	c1 ea 0c             	shr    $0xc,%edx
  801810:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801817:	f6 c2 01             	test   $0x1,%dl
  80181a:	74 19                	je     801835 <fd_alloc+0x46>
  80181c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801821:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801826:	75 d2                	jne    8017fa <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801828:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80182e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801833:	eb 07                	jmp    80183c <fd_alloc+0x4d>
			*fd_store = fd;
  801835:	89 01                	mov    %eax,(%ecx)
			return 0;
  801837:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183c:	5d                   	pop    %ebp
  80183d:	c3                   	ret    

0080183e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801844:	83 f8 1f             	cmp    $0x1f,%eax
  801847:	77 36                	ja     80187f <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801849:	c1 e0 0c             	shl    $0xc,%eax
  80184c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801851:	89 c2                	mov    %eax,%edx
  801853:	c1 ea 16             	shr    $0x16,%edx
  801856:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80185d:	f6 c2 01             	test   $0x1,%dl
  801860:	74 24                	je     801886 <fd_lookup+0x48>
  801862:	89 c2                	mov    %eax,%edx
  801864:	c1 ea 0c             	shr    $0xc,%edx
  801867:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80186e:	f6 c2 01             	test   $0x1,%dl
  801871:	74 1a                	je     80188d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801873:	8b 55 0c             	mov    0xc(%ebp),%edx
  801876:	89 02                	mov    %eax,(%edx)
	return 0;
  801878:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187d:	5d                   	pop    %ebp
  80187e:	c3                   	ret    
		return -E_INVAL;
  80187f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801884:	eb f7                	jmp    80187d <fd_lookup+0x3f>
		return -E_INVAL;
  801886:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80188b:	eb f0                	jmp    80187d <fd_lookup+0x3f>
  80188d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801892:	eb e9                	jmp    80187d <fd_lookup+0x3f>

00801894 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 08             	sub    $0x8,%esp
  80189a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80189d:	ba 40 2e 80 00       	mov    $0x802e40,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8018a2:	b8 0c 30 80 00       	mov    $0x80300c,%eax
		if (devtab[i]->dev_id == dev_id) {
  8018a7:	39 08                	cmp    %ecx,(%eax)
  8018a9:	74 33                	je     8018de <dev_lookup+0x4a>
  8018ab:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8018ae:	8b 02                	mov    (%edx),%eax
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	75 f3                	jne    8018a7 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018b4:	a1 04 40 80 00       	mov    0x804004,%eax
  8018b9:	8b 40 48             	mov    0x48(%eax),%eax
  8018bc:	83 ec 04             	sub    $0x4,%esp
  8018bf:	51                   	push   %ecx
  8018c0:	50                   	push   %eax
  8018c1:	68 c0 2d 80 00       	push   $0x802dc0
  8018c6:	e8 fe e9 ff ff       	call   8002c9 <cprintf>
	*dev = 0;
  8018cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    
			*dev = devtab[i];
  8018de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018e1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8018e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e8:	eb f2                	jmp    8018dc <dev_lookup+0x48>

008018ea <fd_close>:
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	57                   	push   %edi
  8018ee:	56                   	push   %esi
  8018ef:	53                   	push   %ebx
  8018f0:	83 ec 1c             	sub    $0x1c,%esp
  8018f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8018f6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018f9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018fc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018fd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801903:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801906:	50                   	push   %eax
  801907:	e8 32 ff ff ff       	call   80183e <fd_lookup>
  80190c:	89 c3                	mov    %eax,%ebx
  80190e:	83 c4 08             	add    $0x8,%esp
  801911:	85 c0                	test   %eax,%eax
  801913:	78 05                	js     80191a <fd_close+0x30>
	    || fd != fd2)
  801915:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801918:	74 16                	je     801930 <fd_close+0x46>
		return (must_exist ? r : 0);
  80191a:	89 f8                	mov    %edi,%eax
  80191c:	84 c0                	test   %al,%al
  80191e:	b8 00 00 00 00       	mov    $0x0,%eax
  801923:	0f 44 d8             	cmove  %eax,%ebx
}
  801926:	89 d8                	mov    %ebx,%eax
  801928:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80192b:	5b                   	pop    %ebx
  80192c:	5e                   	pop    %esi
  80192d:	5f                   	pop    %edi
  80192e:	5d                   	pop    %ebp
  80192f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801930:	83 ec 08             	sub    $0x8,%esp
  801933:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801936:	50                   	push   %eax
  801937:	ff 36                	pushl  (%esi)
  801939:	e8 56 ff ff ff       	call   801894 <dev_lookup>
  80193e:	89 c3                	mov    %eax,%ebx
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	85 c0                	test   %eax,%eax
  801945:	78 15                	js     80195c <fd_close+0x72>
		if (dev->dev_close)
  801947:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80194a:	8b 40 10             	mov    0x10(%eax),%eax
  80194d:	85 c0                	test   %eax,%eax
  80194f:	74 1b                	je     80196c <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801951:	83 ec 0c             	sub    $0xc,%esp
  801954:	56                   	push   %esi
  801955:	ff d0                	call   *%eax
  801957:	89 c3                	mov    %eax,%ebx
  801959:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80195c:	83 ec 08             	sub    $0x8,%esp
  80195f:	56                   	push   %esi
  801960:	6a 00                	push   $0x0
  801962:	e8 ff f3 ff ff       	call   800d66 <sys_page_unmap>
	return r;
  801967:	83 c4 10             	add    $0x10,%esp
  80196a:	eb ba                	jmp    801926 <fd_close+0x3c>
			r = 0;
  80196c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801971:	eb e9                	jmp    80195c <fd_close+0x72>

00801973 <close>:

int
close(int fdnum)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801979:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80197c:	50                   	push   %eax
  80197d:	ff 75 08             	pushl  0x8(%ebp)
  801980:	e8 b9 fe ff ff       	call   80183e <fd_lookup>
  801985:	83 c4 08             	add    $0x8,%esp
  801988:	85 c0                	test   %eax,%eax
  80198a:	78 10                	js     80199c <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80198c:	83 ec 08             	sub    $0x8,%esp
  80198f:	6a 01                	push   $0x1
  801991:	ff 75 f4             	pushl  -0xc(%ebp)
  801994:	e8 51 ff ff ff       	call   8018ea <fd_close>
  801999:	83 c4 10             	add    $0x10,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <close_all>:

void
close_all(void)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	53                   	push   %ebx
  8019a2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8019a5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8019aa:	83 ec 0c             	sub    $0xc,%esp
  8019ad:	53                   	push   %ebx
  8019ae:	e8 c0 ff ff ff       	call   801973 <close>
	for (i = 0; i < MAXFD; i++)
  8019b3:	83 c3 01             	add    $0x1,%ebx
  8019b6:	83 c4 10             	add    $0x10,%esp
  8019b9:	83 fb 20             	cmp    $0x20,%ebx
  8019bc:	75 ec                	jne    8019aa <close_all+0xc>
}
  8019be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	57                   	push   %edi
  8019c7:	56                   	push   %esi
  8019c8:	53                   	push   %ebx
  8019c9:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019cc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019cf:	50                   	push   %eax
  8019d0:	ff 75 08             	pushl  0x8(%ebp)
  8019d3:	e8 66 fe ff ff       	call   80183e <fd_lookup>
  8019d8:	89 c3                	mov    %eax,%ebx
  8019da:	83 c4 08             	add    $0x8,%esp
  8019dd:	85 c0                	test   %eax,%eax
  8019df:	0f 88 81 00 00 00    	js     801a66 <dup+0xa3>
		return r;
	close(newfdnum);
  8019e5:	83 ec 0c             	sub    $0xc,%esp
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	e8 83 ff ff ff       	call   801973 <close>

	newfd = INDEX2FD(newfdnum);
  8019f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019f3:	c1 e6 0c             	shl    $0xc,%esi
  8019f6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8019fc:	83 c4 04             	add    $0x4,%esp
  8019ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a02:	e8 d1 fd ff ff       	call   8017d8 <fd2data>
  801a07:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a09:	89 34 24             	mov    %esi,(%esp)
  801a0c:	e8 c7 fd ff ff       	call   8017d8 <fd2data>
  801a11:	83 c4 10             	add    $0x10,%esp
  801a14:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a16:	89 d8                	mov    %ebx,%eax
  801a18:	c1 e8 16             	shr    $0x16,%eax
  801a1b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a22:	a8 01                	test   $0x1,%al
  801a24:	74 11                	je     801a37 <dup+0x74>
  801a26:	89 d8                	mov    %ebx,%eax
  801a28:	c1 e8 0c             	shr    $0xc,%eax
  801a2b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a32:	f6 c2 01             	test   $0x1,%dl
  801a35:	75 39                	jne    801a70 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a3a:	89 d0                	mov    %edx,%eax
  801a3c:	c1 e8 0c             	shr    $0xc,%eax
  801a3f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a46:	83 ec 0c             	sub    $0xc,%esp
  801a49:	25 07 0e 00 00       	and    $0xe07,%eax
  801a4e:	50                   	push   %eax
  801a4f:	56                   	push   %esi
  801a50:	6a 00                	push   $0x0
  801a52:	52                   	push   %edx
  801a53:	6a 00                	push   $0x0
  801a55:	e8 ca f2 ff ff       	call   800d24 <sys_page_map>
  801a5a:	89 c3                	mov    %eax,%ebx
  801a5c:	83 c4 20             	add    $0x20,%esp
  801a5f:	85 c0                	test   %eax,%eax
  801a61:	78 31                	js     801a94 <dup+0xd1>
		goto err;

	return newfdnum;
  801a63:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801a66:	89 d8                	mov    %ebx,%eax
  801a68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a6b:	5b                   	pop    %ebx
  801a6c:	5e                   	pop    %esi
  801a6d:	5f                   	pop    %edi
  801a6e:	5d                   	pop    %ebp
  801a6f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a70:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a77:	83 ec 0c             	sub    $0xc,%esp
  801a7a:	25 07 0e 00 00       	and    $0xe07,%eax
  801a7f:	50                   	push   %eax
  801a80:	57                   	push   %edi
  801a81:	6a 00                	push   $0x0
  801a83:	53                   	push   %ebx
  801a84:	6a 00                	push   $0x0
  801a86:	e8 99 f2 ff ff       	call   800d24 <sys_page_map>
  801a8b:	89 c3                	mov    %eax,%ebx
  801a8d:	83 c4 20             	add    $0x20,%esp
  801a90:	85 c0                	test   %eax,%eax
  801a92:	79 a3                	jns    801a37 <dup+0x74>
	sys_page_unmap(0, newfd);
  801a94:	83 ec 08             	sub    $0x8,%esp
  801a97:	56                   	push   %esi
  801a98:	6a 00                	push   $0x0
  801a9a:	e8 c7 f2 ff ff       	call   800d66 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a9f:	83 c4 08             	add    $0x8,%esp
  801aa2:	57                   	push   %edi
  801aa3:	6a 00                	push   $0x0
  801aa5:	e8 bc f2 ff ff       	call   800d66 <sys_page_unmap>
	return r;
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	eb b7                	jmp    801a66 <dup+0xa3>

00801aaf <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	53                   	push   %ebx
  801ab3:	83 ec 14             	sub    $0x14,%esp
  801ab6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ab9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801abc:	50                   	push   %eax
  801abd:	53                   	push   %ebx
  801abe:	e8 7b fd ff ff       	call   80183e <fd_lookup>
  801ac3:	83 c4 08             	add    $0x8,%esp
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	78 3f                	js     801b09 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aca:	83 ec 08             	sub    $0x8,%esp
  801acd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad0:	50                   	push   %eax
  801ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad4:	ff 30                	pushl  (%eax)
  801ad6:	e8 b9 fd ff ff       	call   801894 <dev_lookup>
  801adb:	83 c4 10             	add    $0x10,%esp
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	78 27                	js     801b09 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ae2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ae5:	8b 42 08             	mov    0x8(%edx),%eax
  801ae8:	83 e0 03             	and    $0x3,%eax
  801aeb:	83 f8 01             	cmp    $0x1,%eax
  801aee:	74 1e                	je     801b0e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af3:	8b 40 08             	mov    0x8(%eax),%eax
  801af6:	85 c0                	test   %eax,%eax
  801af8:	74 35                	je     801b2f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801afa:	83 ec 04             	sub    $0x4,%esp
  801afd:	ff 75 10             	pushl  0x10(%ebp)
  801b00:	ff 75 0c             	pushl  0xc(%ebp)
  801b03:	52                   	push   %edx
  801b04:	ff d0                	call   *%eax
  801b06:	83 c4 10             	add    $0x10,%esp
}
  801b09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b0e:	a1 04 40 80 00       	mov    0x804004,%eax
  801b13:	8b 40 48             	mov    0x48(%eax),%eax
  801b16:	83 ec 04             	sub    $0x4,%esp
  801b19:	53                   	push   %ebx
  801b1a:	50                   	push   %eax
  801b1b:	68 04 2e 80 00       	push   $0x802e04
  801b20:	e8 a4 e7 ff ff       	call   8002c9 <cprintf>
		return -E_INVAL;
  801b25:	83 c4 10             	add    $0x10,%esp
  801b28:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b2d:	eb da                	jmp    801b09 <read+0x5a>
		return -E_NOT_SUPP;
  801b2f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b34:	eb d3                	jmp    801b09 <read+0x5a>

00801b36 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	57                   	push   %edi
  801b3a:	56                   	push   %esi
  801b3b:	53                   	push   %ebx
  801b3c:	83 ec 0c             	sub    $0xc,%esp
  801b3f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b42:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b45:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b4a:	39 f3                	cmp    %esi,%ebx
  801b4c:	73 25                	jae    801b73 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b4e:	83 ec 04             	sub    $0x4,%esp
  801b51:	89 f0                	mov    %esi,%eax
  801b53:	29 d8                	sub    %ebx,%eax
  801b55:	50                   	push   %eax
  801b56:	89 d8                	mov    %ebx,%eax
  801b58:	03 45 0c             	add    0xc(%ebp),%eax
  801b5b:	50                   	push   %eax
  801b5c:	57                   	push   %edi
  801b5d:	e8 4d ff ff ff       	call   801aaf <read>
		if (m < 0)
  801b62:	83 c4 10             	add    $0x10,%esp
  801b65:	85 c0                	test   %eax,%eax
  801b67:	78 08                	js     801b71 <readn+0x3b>
			return m;
		if (m == 0)
  801b69:	85 c0                	test   %eax,%eax
  801b6b:	74 06                	je     801b73 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801b6d:	01 c3                	add    %eax,%ebx
  801b6f:	eb d9                	jmp    801b4a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b71:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801b73:	89 d8                	mov    %ebx,%eax
  801b75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b78:	5b                   	pop    %ebx
  801b79:	5e                   	pop    %esi
  801b7a:	5f                   	pop    %edi
  801b7b:	5d                   	pop    %ebp
  801b7c:	c3                   	ret    

00801b7d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	53                   	push   %ebx
  801b81:	83 ec 14             	sub    $0x14,%esp
  801b84:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b87:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b8a:	50                   	push   %eax
  801b8b:	53                   	push   %ebx
  801b8c:	e8 ad fc ff ff       	call   80183e <fd_lookup>
  801b91:	83 c4 08             	add    $0x8,%esp
  801b94:	85 c0                	test   %eax,%eax
  801b96:	78 3a                	js     801bd2 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b98:	83 ec 08             	sub    $0x8,%esp
  801b9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b9e:	50                   	push   %eax
  801b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba2:	ff 30                	pushl  (%eax)
  801ba4:	e8 eb fc ff ff       	call   801894 <dev_lookup>
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	85 c0                	test   %eax,%eax
  801bae:	78 22                	js     801bd2 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bb7:	74 1e                	je     801bd7 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bbc:	8b 52 0c             	mov    0xc(%edx),%edx
  801bbf:	85 d2                	test   %edx,%edx
  801bc1:	74 35                	je     801bf8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801bc3:	83 ec 04             	sub    $0x4,%esp
  801bc6:	ff 75 10             	pushl  0x10(%ebp)
  801bc9:	ff 75 0c             	pushl  0xc(%ebp)
  801bcc:	50                   	push   %eax
  801bcd:	ff d2                	call   *%edx
  801bcf:	83 c4 10             	add    $0x10,%esp
}
  801bd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bd7:	a1 04 40 80 00       	mov    0x804004,%eax
  801bdc:	8b 40 48             	mov    0x48(%eax),%eax
  801bdf:	83 ec 04             	sub    $0x4,%esp
  801be2:	53                   	push   %ebx
  801be3:	50                   	push   %eax
  801be4:	68 20 2e 80 00       	push   $0x802e20
  801be9:	e8 db e6 ff ff       	call   8002c9 <cprintf>
		return -E_INVAL;
  801bee:	83 c4 10             	add    $0x10,%esp
  801bf1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bf6:	eb da                	jmp    801bd2 <write+0x55>
		return -E_NOT_SUPP;
  801bf8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bfd:	eb d3                	jmp    801bd2 <write+0x55>

00801bff <seek>:

int
seek(int fdnum, off_t offset)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c05:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801c08:	50                   	push   %eax
  801c09:	ff 75 08             	pushl  0x8(%ebp)
  801c0c:	e8 2d fc ff ff       	call   80183e <fd_lookup>
  801c11:	83 c4 08             	add    $0x8,%esp
  801c14:	85 c0                	test   %eax,%eax
  801c16:	78 0e                	js     801c26 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801c18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c1e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	53                   	push   %ebx
  801c2c:	83 ec 14             	sub    $0x14,%esp
  801c2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c32:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c35:	50                   	push   %eax
  801c36:	53                   	push   %ebx
  801c37:	e8 02 fc ff ff       	call   80183e <fd_lookup>
  801c3c:	83 c4 08             	add    $0x8,%esp
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	78 37                	js     801c7a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c43:	83 ec 08             	sub    $0x8,%esp
  801c46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c49:	50                   	push   %eax
  801c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4d:	ff 30                	pushl  (%eax)
  801c4f:	e8 40 fc ff ff       	call   801894 <dev_lookup>
  801c54:	83 c4 10             	add    $0x10,%esp
  801c57:	85 c0                	test   %eax,%eax
  801c59:	78 1f                	js     801c7a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c62:	74 1b                	je     801c7f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801c64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c67:	8b 52 18             	mov    0x18(%edx),%edx
  801c6a:	85 d2                	test   %edx,%edx
  801c6c:	74 32                	je     801ca0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c6e:	83 ec 08             	sub    $0x8,%esp
  801c71:	ff 75 0c             	pushl  0xc(%ebp)
  801c74:	50                   	push   %eax
  801c75:	ff d2                	call   *%edx
  801c77:	83 c4 10             	add    $0x10,%esp
}
  801c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    
			thisenv->env_id, fdnum);
  801c7f:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c84:	8b 40 48             	mov    0x48(%eax),%eax
  801c87:	83 ec 04             	sub    $0x4,%esp
  801c8a:	53                   	push   %ebx
  801c8b:	50                   	push   %eax
  801c8c:	68 e0 2d 80 00       	push   $0x802de0
  801c91:	e8 33 e6 ff ff       	call   8002c9 <cprintf>
		return -E_INVAL;
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c9e:	eb da                	jmp    801c7a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801ca0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ca5:	eb d3                	jmp    801c7a <ftruncate+0x52>

00801ca7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	53                   	push   %ebx
  801cab:	83 ec 14             	sub    $0x14,%esp
  801cae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cb1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cb4:	50                   	push   %eax
  801cb5:	ff 75 08             	pushl  0x8(%ebp)
  801cb8:	e8 81 fb ff ff       	call   80183e <fd_lookup>
  801cbd:	83 c4 08             	add    $0x8,%esp
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	78 4b                	js     801d0f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cc4:	83 ec 08             	sub    $0x8,%esp
  801cc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cca:	50                   	push   %eax
  801ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cce:	ff 30                	pushl  (%eax)
  801cd0:	e8 bf fb ff ff       	call   801894 <dev_lookup>
  801cd5:	83 c4 10             	add    $0x10,%esp
  801cd8:	85 c0                	test   %eax,%eax
  801cda:	78 33                	js     801d0f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cdf:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ce3:	74 2f                	je     801d14 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ce5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ce8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801cef:	00 00 00 
	stat->st_isdir = 0;
  801cf2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cf9:	00 00 00 
	stat->st_dev = dev;
  801cfc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d02:	83 ec 08             	sub    $0x8,%esp
  801d05:	53                   	push   %ebx
  801d06:	ff 75 f0             	pushl  -0x10(%ebp)
  801d09:	ff 50 14             	call   *0x14(%eax)
  801d0c:	83 c4 10             	add    $0x10,%esp
}
  801d0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    
		return -E_NOT_SUPP;
  801d14:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d19:	eb f4                	jmp    801d0f <fstat+0x68>

00801d1b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	56                   	push   %esi
  801d1f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d20:	83 ec 08             	sub    $0x8,%esp
  801d23:	6a 00                	push   $0x0
  801d25:	ff 75 08             	pushl  0x8(%ebp)
  801d28:	e8 30 02 00 00       	call   801f5d <open>
  801d2d:	89 c3                	mov    %eax,%ebx
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	85 c0                	test   %eax,%eax
  801d34:	78 1b                	js     801d51 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801d36:	83 ec 08             	sub    $0x8,%esp
  801d39:	ff 75 0c             	pushl  0xc(%ebp)
  801d3c:	50                   	push   %eax
  801d3d:	e8 65 ff ff ff       	call   801ca7 <fstat>
  801d42:	89 c6                	mov    %eax,%esi
	close(fd);
  801d44:	89 1c 24             	mov    %ebx,(%esp)
  801d47:	e8 27 fc ff ff       	call   801973 <close>
	return r;
  801d4c:	83 c4 10             	add    $0x10,%esp
  801d4f:	89 f3                	mov    %esi,%ebx
}
  801d51:	89 d8                	mov    %ebx,%eax
  801d53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d56:	5b                   	pop    %ebx
  801d57:	5e                   	pop    %esi
  801d58:	5d                   	pop    %ebp
  801d59:	c3                   	ret    

00801d5a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	56                   	push   %esi
  801d5e:	53                   	push   %ebx
  801d5f:	89 c6                	mov    %eax,%esi
  801d61:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d63:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801d6a:	74 27                	je     801d93 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d6c:	6a 07                	push   $0x7
  801d6e:	68 00 50 80 00       	push   $0x805000
  801d73:	56                   	push   %esi
  801d74:	ff 35 00 40 80 00    	pushl  0x804000
  801d7a:	e8 b6 07 00 00       	call   802535 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d7f:	83 c4 0c             	add    $0xc,%esp
  801d82:	6a 00                	push   $0x0
  801d84:	53                   	push   %ebx
  801d85:	6a 00                	push   $0x0
  801d87:	e8 40 07 00 00       	call   8024cc <ipc_recv>
}
  801d8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5d                   	pop    %ebp
  801d92:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d93:	83 ec 0c             	sub    $0xc,%esp
  801d96:	6a 01                	push   $0x1
  801d98:	e8 ec 07 00 00       	call   802589 <ipc_find_env>
  801d9d:	a3 00 40 80 00       	mov    %eax,0x804000
  801da2:	83 c4 10             	add    $0x10,%esp
  801da5:	eb c5                	jmp    801d6c <fsipc+0x12>

00801da7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dad:	8b 45 08             	mov    0x8(%ebp),%eax
  801db0:	8b 40 0c             	mov    0xc(%eax),%eax
  801db3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbb:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801dc0:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc5:	b8 02 00 00 00       	mov    $0x2,%eax
  801dca:	e8 8b ff ff ff       	call   801d5a <fsipc>
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <devfile_flush>:
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	8b 40 0c             	mov    0xc(%eax),%eax
  801ddd:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801de2:	ba 00 00 00 00       	mov    $0x0,%edx
  801de7:	b8 06 00 00 00       	mov    $0x6,%eax
  801dec:	e8 69 ff ff ff       	call   801d5a <fsipc>
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <devfile_stat>:
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	53                   	push   %ebx
  801df7:	83 ec 04             	sub    $0x4,%esp
  801dfa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	8b 40 0c             	mov    0xc(%eax),%eax
  801e03:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e08:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0d:	b8 05 00 00 00       	mov    $0x5,%eax
  801e12:	e8 43 ff ff ff       	call   801d5a <fsipc>
  801e17:	85 c0                	test   %eax,%eax
  801e19:	78 2c                	js     801e47 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e1b:	83 ec 08             	sub    $0x8,%esp
  801e1e:	68 00 50 80 00       	push   $0x805000
  801e23:	53                   	push   %ebx
  801e24:	e8 bf ea ff ff       	call   8008e8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e29:	a1 80 50 80 00       	mov    0x805080,%eax
  801e2e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e34:	a1 84 50 80 00       	mov    0x805084,%eax
  801e39:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e3f:	83 c4 10             	add    $0x10,%esp
  801e42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <devfile_write>:
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	53                   	push   %ebx
  801e50:	83 ec 08             	sub    $0x8,%esp
  801e53:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  801e56:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801e5c:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801e61:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e64:	8b 45 08             	mov    0x8(%ebp),%eax
  801e67:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801e6f:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801e75:	53                   	push   %ebx
  801e76:	ff 75 0c             	pushl  0xc(%ebp)
  801e79:	68 08 50 80 00       	push   $0x805008
  801e7e:	e8 f3 eb ff ff       	call   800a76 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801e83:	ba 00 00 00 00       	mov    $0x0,%edx
  801e88:	b8 04 00 00 00       	mov    $0x4,%eax
  801e8d:	e8 c8 fe ff ff       	call   801d5a <fsipc>
  801e92:	83 c4 10             	add    $0x10,%esp
  801e95:	85 c0                	test   %eax,%eax
  801e97:	78 0b                	js     801ea4 <devfile_write+0x58>
	assert(r <= n);
  801e99:	39 d8                	cmp    %ebx,%eax
  801e9b:	77 0c                	ja     801ea9 <devfile_write+0x5d>
	assert(r <= PGSIZE);
  801e9d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ea2:	7f 1e                	jg     801ec2 <devfile_write+0x76>
}
  801ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    
	assert(r <= n);
  801ea9:	68 50 2e 80 00       	push   $0x802e50
  801eae:	68 f4 2c 80 00       	push   $0x802cf4
  801eb3:	68 98 00 00 00       	push   $0x98
  801eb8:	68 57 2e 80 00       	push   $0x802e57
  801ebd:	e8 2c e3 ff ff       	call   8001ee <_panic>
	assert(r <= PGSIZE);
  801ec2:	68 62 2e 80 00       	push   $0x802e62
  801ec7:	68 f4 2c 80 00       	push   $0x802cf4
  801ecc:	68 99 00 00 00       	push   $0x99
  801ed1:	68 57 2e 80 00       	push   $0x802e57
  801ed6:	e8 13 e3 ff ff       	call   8001ee <_panic>

00801edb <devfile_read>:
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	56                   	push   %esi
  801edf:	53                   	push   %ebx
  801ee0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801eee:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ef4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef9:	b8 03 00 00 00       	mov    $0x3,%eax
  801efe:	e8 57 fe ff ff       	call   801d5a <fsipc>
  801f03:	89 c3                	mov    %eax,%ebx
  801f05:	85 c0                	test   %eax,%eax
  801f07:	78 1f                	js     801f28 <devfile_read+0x4d>
	assert(r <= n);
  801f09:	39 f0                	cmp    %esi,%eax
  801f0b:	77 24                	ja     801f31 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801f0d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f12:	7f 33                	jg     801f47 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f14:	83 ec 04             	sub    $0x4,%esp
  801f17:	50                   	push   %eax
  801f18:	68 00 50 80 00       	push   $0x805000
  801f1d:	ff 75 0c             	pushl  0xc(%ebp)
  801f20:	e8 51 eb ff ff       	call   800a76 <memmove>
	return r;
  801f25:	83 c4 10             	add    $0x10,%esp
}
  801f28:	89 d8                	mov    %ebx,%eax
  801f2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f2d:	5b                   	pop    %ebx
  801f2e:	5e                   	pop    %esi
  801f2f:	5d                   	pop    %ebp
  801f30:	c3                   	ret    
	assert(r <= n);
  801f31:	68 50 2e 80 00       	push   $0x802e50
  801f36:	68 f4 2c 80 00       	push   $0x802cf4
  801f3b:	6a 7c                	push   $0x7c
  801f3d:	68 57 2e 80 00       	push   $0x802e57
  801f42:	e8 a7 e2 ff ff       	call   8001ee <_panic>
	assert(r <= PGSIZE);
  801f47:	68 62 2e 80 00       	push   $0x802e62
  801f4c:	68 f4 2c 80 00       	push   $0x802cf4
  801f51:	6a 7d                	push   $0x7d
  801f53:	68 57 2e 80 00       	push   $0x802e57
  801f58:	e8 91 e2 ff ff       	call   8001ee <_panic>

00801f5d <open>:
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	56                   	push   %esi
  801f61:	53                   	push   %ebx
  801f62:	83 ec 1c             	sub    $0x1c,%esp
  801f65:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801f68:	56                   	push   %esi
  801f69:	e8 43 e9 ff ff       	call   8008b1 <strlen>
  801f6e:	83 c4 10             	add    $0x10,%esp
  801f71:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f76:	7f 6c                	jg     801fe4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801f78:	83 ec 0c             	sub    $0xc,%esp
  801f7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7e:	50                   	push   %eax
  801f7f:	e8 6b f8 ff ff       	call   8017ef <fd_alloc>
  801f84:	89 c3                	mov    %eax,%ebx
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	78 3c                	js     801fc9 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801f8d:	83 ec 08             	sub    $0x8,%esp
  801f90:	56                   	push   %esi
  801f91:	68 00 50 80 00       	push   $0x805000
  801f96:	e8 4d e9 ff ff       	call   8008e8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f9e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fab:	e8 aa fd ff ff       	call   801d5a <fsipc>
  801fb0:	89 c3                	mov    %eax,%ebx
  801fb2:	83 c4 10             	add    $0x10,%esp
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	78 19                	js     801fd2 <open+0x75>
	return fd2num(fd);
  801fb9:	83 ec 0c             	sub    $0xc,%esp
  801fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbf:	e8 04 f8 ff ff       	call   8017c8 <fd2num>
  801fc4:	89 c3                	mov    %eax,%ebx
  801fc6:	83 c4 10             	add    $0x10,%esp
}
  801fc9:	89 d8                	mov    %ebx,%eax
  801fcb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fce:	5b                   	pop    %ebx
  801fcf:	5e                   	pop    %esi
  801fd0:	5d                   	pop    %ebp
  801fd1:	c3                   	ret    
		fd_close(fd, 0);
  801fd2:	83 ec 08             	sub    $0x8,%esp
  801fd5:	6a 00                	push   $0x0
  801fd7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fda:	e8 0b f9 ff ff       	call   8018ea <fd_close>
		return r;
  801fdf:	83 c4 10             	add    $0x10,%esp
  801fe2:	eb e5                	jmp    801fc9 <open+0x6c>
		return -E_BAD_PATH;
  801fe4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801fe9:	eb de                	jmp    801fc9 <open+0x6c>

00801feb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ff1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff6:	b8 08 00 00 00       	mov    $0x8,%eax
  801ffb:	e8 5a fd ff ff       	call   801d5a <fsipc>
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	56                   	push   %esi
  802006:	53                   	push   %ebx
  802007:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80200a:	83 ec 0c             	sub    $0xc,%esp
  80200d:	ff 75 08             	pushl  0x8(%ebp)
  802010:	e8 c3 f7 ff ff       	call   8017d8 <fd2data>
  802015:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802017:	83 c4 08             	add    $0x8,%esp
  80201a:	68 6e 2e 80 00       	push   $0x802e6e
  80201f:	53                   	push   %ebx
  802020:	e8 c3 e8 ff ff       	call   8008e8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802025:	8b 46 04             	mov    0x4(%esi),%eax
  802028:	2b 06                	sub    (%esi),%eax
  80202a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802030:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802037:	00 00 00 
	stat->st_dev = &devpipe;
  80203a:	c7 83 88 00 00 00 28 	movl   $0x803028,0x88(%ebx)
  802041:	30 80 00 
	return 0;
}
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
  802049:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80204c:	5b                   	pop    %ebx
  80204d:	5e                   	pop    %esi
  80204e:	5d                   	pop    %ebp
  80204f:	c3                   	ret    

00802050 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	53                   	push   %ebx
  802054:	83 ec 0c             	sub    $0xc,%esp
  802057:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80205a:	53                   	push   %ebx
  80205b:	6a 00                	push   $0x0
  80205d:	e8 04 ed ff ff       	call   800d66 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802062:	89 1c 24             	mov    %ebx,(%esp)
  802065:	e8 6e f7 ff ff       	call   8017d8 <fd2data>
  80206a:	83 c4 08             	add    $0x8,%esp
  80206d:	50                   	push   %eax
  80206e:	6a 00                	push   $0x0
  802070:	e8 f1 ec ff ff       	call   800d66 <sys_page_unmap>
}
  802075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <_pipeisclosed>:
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	57                   	push   %edi
  80207e:	56                   	push   %esi
  80207f:	53                   	push   %ebx
  802080:	83 ec 1c             	sub    $0x1c,%esp
  802083:	89 c7                	mov    %eax,%edi
  802085:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802087:	a1 04 40 80 00       	mov    0x804004,%eax
  80208c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80208f:	83 ec 0c             	sub    $0xc,%esp
  802092:	57                   	push   %edi
  802093:	e8 2a 05 00 00       	call   8025c2 <pageref>
  802098:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80209b:	89 34 24             	mov    %esi,(%esp)
  80209e:	e8 1f 05 00 00       	call   8025c2 <pageref>
		nn = thisenv->env_runs;
  8020a3:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8020a9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020ac:	83 c4 10             	add    $0x10,%esp
  8020af:	39 cb                	cmp    %ecx,%ebx
  8020b1:	74 1b                	je     8020ce <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020b3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020b6:	75 cf                	jne    802087 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020b8:	8b 42 58             	mov    0x58(%edx),%eax
  8020bb:	6a 01                	push   $0x1
  8020bd:	50                   	push   %eax
  8020be:	53                   	push   %ebx
  8020bf:	68 75 2e 80 00       	push   $0x802e75
  8020c4:	e8 00 e2 ff ff       	call   8002c9 <cprintf>
  8020c9:	83 c4 10             	add    $0x10,%esp
  8020cc:	eb b9                	jmp    802087 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020ce:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020d1:	0f 94 c0             	sete   %al
  8020d4:	0f b6 c0             	movzbl %al,%eax
}
  8020d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020da:	5b                   	pop    %ebx
  8020db:	5e                   	pop    %esi
  8020dc:	5f                   	pop    %edi
  8020dd:	5d                   	pop    %ebp
  8020de:	c3                   	ret    

008020df <devpipe_write>:
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	57                   	push   %edi
  8020e3:	56                   	push   %esi
  8020e4:	53                   	push   %ebx
  8020e5:	83 ec 28             	sub    $0x28,%esp
  8020e8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8020eb:	56                   	push   %esi
  8020ec:	e8 e7 f6 ff ff       	call   8017d8 <fd2data>
  8020f1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020f3:	83 c4 10             	add    $0x10,%esp
  8020f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8020fb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020fe:	74 4f                	je     80214f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802100:	8b 43 04             	mov    0x4(%ebx),%eax
  802103:	8b 0b                	mov    (%ebx),%ecx
  802105:	8d 51 20             	lea    0x20(%ecx),%edx
  802108:	39 d0                	cmp    %edx,%eax
  80210a:	72 14                	jb     802120 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80210c:	89 da                	mov    %ebx,%edx
  80210e:	89 f0                	mov    %esi,%eax
  802110:	e8 65 ff ff ff       	call   80207a <_pipeisclosed>
  802115:	85 c0                	test   %eax,%eax
  802117:	75 3a                	jne    802153 <devpipe_write+0x74>
			sys_yield();
  802119:	e8 a4 eb ff ff       	call   800cc2 <sys_yield>
  80211e:	eb e0                	jmp    802100 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802120:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802123:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802127:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80212a:	89 c2                	mov    %eax,%edx
  80212c:	c1 fa 1f             	sar    $0x1f,%edx
  80212f:	89 d1                	mov    %edx,%ecx
  802131:	c1 e9 1b             	shr    $0x1b,%ecx
  802134:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802137:	83 e2 1f             	and    $0x1f,%edx
  80213a:	29 ca                	sub    %ecx,%edx
  80213c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802140:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802144:	83 c0 01             	add    $0x1,%eax
  802147:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80214a:	83 c7 01             	add    $0x1,%edi
  80214d:	eb ac                	jmp    8020fb <devpipe_write+0x1c>
	return i;
  80214f:	89 f8                	mov    %edi,%eax
  802151:	eb 05                	jmp    802158 <devpipe_write+0x79>
				return 0;
  802153:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802158:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80215b:	5b                   	pop    %ebx
  80215c:	5e                   	pop    %esi
  80215d:	5f                   	pop    %edi
  80215e:	5d                   	pop    %ebp
  80215f:	c3                   	ret    

00802160 <devpipe_read>:
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	57                   	push   %edi
  802164:	56                   	push   %esi
  802165:	53                   	push   %ebx
  802166:	83 ec 18             	sub    $0x18,%esp
  802169:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80216c:	57                   	push   %edi
  80216d:	e8 66 f6 ff ff       	call   8017d8 <fd2data>
  802172:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802174:	83 c4 10             	add    $0x10,%esp
  802177:	be 00 00 00 00       	mov    $0x0,%esi
  80217c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80217f:	74 47                	je     8021c8 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802181:	8b 03                	mov    (%ebx),%eax
  802183:	3b 43 04             	cmp    0x4(%ebx),%eax
  802186:	75 22                	jne    8021aa <devpipe_read+0x4a>
			if (i > 0)
  802188:	85 f6                	test   %esi,%esi
  80218a:	75 14                	jne    8021a0 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80218c:	89 da                	mov    %ebx,%edx
  80218e:	89 f8                	mov    %edi,%eax
  802190:	e8 e5 fe ff ff       	call   80207a <_pipeisclosed>
  802195:	85 c0                	test   %eax,%eax
  802197:	75 33                	jne    8021cc <devpipe_read+0x6c>
			sys_yield();
  802199:	e8 24 eb ff ff       	call   800cc2 <sys_yield>
  80219e:	eb e1                	jmp    802181 <devpipe_read+0x21>
				return i;
  8021a0:	89 f0                	mov    %esi,%eax
}
  8021a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021a5:	5b                   	pop    %ebx
  8021a6:	5e                   	pop    %esi
  8021a7:	5f                   	pop    %edi
  8021a8:	5d                   	pop    %ebp
  8021a9:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021aa:	99                   	cltd   
  8021ab:	c1 ea 1b             	shr    $0x1b,%edx
  8021ae:	01 d0                	add    %edx,%eax
  8021b0:	83 e0 1f             	and    $0x1f,%eax
  8021b3:	29 d0                	sub    %edx,%eax
  8021b5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021bd:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021c0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021c3:	83 c6 01             	add    $0x1,%esi
  8021c6:	eb b4                	jmp    80217c <devpipe_read+0x1c>
	return i;
  8021c8:	89 f0                	mov    %esi,%eax
  8021ca:	eb d6                	jmp    8021a2 <devpipe_read+0x42>
				return 0;
  8021cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d1:	eb cf                	jmp    8021a2 <devpipe_read+0x42>

008021d3 <pipe>:
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	56                   	push   %esi
  8021d7:	53                   	push   %ebx
  8021d8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8021db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021de:	50                   	push   %eax
  8021df:	e8 0b f6 ff ff       	call   8017ef <fd_alloc>
  8021e4:	89 c3                	mov    %eax,%ebx
  8021e6:	83 c4 10             	add    $0x10,%esp
  8021e9:	85 c0                	test   %eax,%eax
  8021eb:	78 5b                	js     802248 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021ed:	83 ec 04             	sub    $0x4,%esp
  8021f0:	68 07 04 00 00       	push   $0x407
  8021f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f8:	6a 00                	push   $0x0
  8021fa:	e8 e2 ea ff ff       	call   800ce1 <sys_page_alloc>
  8021ff:	89 c3                	mov    %eax,%ebx
  802201:	83 c4 10             	add    $0x10,%esp
  802204:	85 c0                	test   %eax,%eax
  802206:	78 40                	js     802248 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  802208:	83 ec 0c             	sub    $0xc,%esp
  80220b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80220e:	50                   	push   %eax
  80220f:	e8 db f5 ff ff       	call   8017ef <fd_alloc>
  802214:	89 c3                	mov    %eax,%ebx
  802216:	83 c4 10             	add    $0x10,%esp
  802219:	85 c0                	test   %eax,%eax
  80221b:	78 1b                	js     802238 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80221d:	83 ec 04             	sub    $0x4,%esp
  802220:	68 07 04 00 00       	push   $0x407
  802225:	ff 75 f0             	pushl  -0x10(%ebp)
  802228:	6a 00                	push   $0x0
  80222a:	e8 b2 ea ff ff       	call   800ce1 <sys_page_alloc>
  80222f:	89 c3                	mov    %eax,%ebx
  802231:	83 c4 10             	add    $0x10,%esp
  802234:	85 c0                	test   %eax,%eax
  802236:	79 19                	jns    802251 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802238:	83 ec 08             	sub    $0x8,%esp
  80223b:	ff 75 f4             	pushl  -0xc(%ebp)
  80223e:	6a 00                	push   $0x0
  802240:	e8 21 eb ff ff       	call   800d66 <sys_page_unmap>
  802245:	83 c4 10             	add    $0x10,%esp
}
  802248:	89 d8                	mov    %ebx,%eax
  80224a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80224d:	5b                   	pop    %ebx
  80224e:	5e                   	pop    %esi
  80224f:	5d                   	pop    %ebp
  802250:	c3                   	ret    
	va = fd2data(fd0);
  802251:	83 ec 0c             	sub    $0xc,%esp
  802254:	ff 75 f4             	pushl  -0xc(%ebp)
  802257:	e8 7c f5 ff ff       	call   8017d8 <fd2data>
  80225c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80225e:	83 c4 0c             	add    $0xc,%esp
  802261:	68 07 04 00 00       	push   $0x407
  802266:	50                   	push   %eax
  802267:	6a 00                	push   $0x0
  802269:	e8 73 ea ff ff       	call   800ce1 <sys_page_alloc>
  80226e:	89 c3                	mov    %eax,%ebx
  802270:	83 c4 10             	add    $0x10,%esp
  802273:	85 c0                	test   %eax,%eax
  802275:	0f 88 8c 00 00 00    	js     802307 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80227b:	83 ec 0c             	sub    $0xc,%esp
  80227e:	ff 75 f0             	pushl  -0x10(%ebp)
  802281:	e8 52 f5 ff ff       	call   8017d8 <fd2data>
  802286:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80228d:	50                   	push   %eax
  80228e:	6a 00                	push   $0x0
  802290:	56                   	push   %esi
  802291:	6a 00                	push   $0x0
  802293:	e8 8c ea ff ff       	call   800d24 <sys_page_map>
  802298:	89 c3                	mov    %eax,%ebx
  80229a:	83 c4 20             	add    $0x20,%esp
  80229d:	85 c0                	test   %eax,%eax
  80229f:	78 58                	js     8022f9 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8022a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a4:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8022aa:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8022ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022af:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8022b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b9:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8022bf:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8022c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022cb:	83 ec 0c             	sub    $0xc,%esp
  8022ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d1:	e8 f2 f4 ff ff       	call   8017c8 <fd2num>
  8022d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022d9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022db:	83 c4 04             	add    $0x4,%esp
  8022de:	ff 75 f0             	pushl  -0x10(%ebp)
  8022e1:	e8 e2 f4 ff ff       	call   8017c8 <fd2num>
  8022e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022e9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022ec:	83 c4 10             	add    $0x10,%esp
  8022ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022f4:	e9 4f ff ff ff       	jmp    802248 <pipe+0x75>
	sys_page_unmap(0, va);
  8022f9:	83 ec 08             	sub    $0x8,%esp
  8022fc:	56                   	push   %esi
  8022fd:	6a 00                	push   $0x0
  8022ff:	e8 62 ea ff ff       	call   800d66 <sys_page_unmap>
  802304:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802307:	83 ec 08             	sub    $0x8,%esp
  80230a:	ff 75 f0             	pushl  -0x10(%ebp)
  80230d:	6a 00                	push   $0x0
  80230f:	e8 52 ea ff ff       	call   800d66 <sys_page_unmap>
  802314:	83 c4 10             	add    $0x10,%esp
  802317:	e9 1c ff ff ff       	jmp    802238 <pipe+0x65>

0080231c <pipeisclosed>:
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802322:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802325:	50                   	push   %eax
  802326:	ff 75 08             	pushl  0x8(%ebp)
  802329:	e8 10 f5 ff ff       	call   80183e <fd_lookup>
  80232e:	83 c4 10             	add    $0x10,%esp
  802331:	85 c0                	test   %eax,%eax
  802333:	78 18                	js     80234d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802335:	83 ec 0c             	sub    $0xc,%esp
  802338:	ff 75 f4             	pushl  -0xc(%ebp)
  80233b:	e8 98 f4 ff ff       	call   8017d8 <fd2data>
	return _pipeisclosed(fd, p);
  802340:	89 c2                	mov    %eax,%edx
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	e8 30 fd ff ff       	call   80207a <_pipeisclosed>
  80234a:	83 c4 10             	add    $0x10,%esp
}
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802352:	b8 00 00 00 00       	mov    $0x0,%eax
  802357:	5d                   	pop    %ebp
  802358:	c3                   	ret    

00802359 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80235f:	68 8d 2e 80 00       	push   $0x802e8d
  802364:	ff 75 0c             	pushl  0xc(%ebp)
  802367:	e8 7c e5 ff ff       	call   8008e8 <strcpy>
	return 0;
}
  80236c:	b8 00 00 00 00       	mov    $0x0,%eax
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <devcons_write>:
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	57                   	push   %edi
  802377:	56                   	push   %esi
  802378:	53                   	push   %ebx
  802379:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80237f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802384:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80238a:	eb 2f                	jmp    8023bb <devcons_write+0x48>
		m = n - tot;
  80238c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80238f:	29 f3                	sub    %esi,%ebx
  802391:	83 fb 7f             	cmp    $0x7f,%ebx
  802394:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802399:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80239c:	83 ec 04             	sub    $0x4,%esp
  80239f:	53                   	push   %ebx
  8023a0:	89 f0                	mov    %esi,%eax
  8023a2:	03 45 0c             	add    0xc(%ebp),%eax
  8023a5:	50                   	push   %eax
  8023a6:	57                   	push   %edi
  8023a7:	e8 ca e6 ff ff       	call   800a76 <memmove>
		sys_cputs(buf, m);
  8023ac:	83 c4 08             	add    $0x8,%esp
  8023af:	53                   	push   %ebx
  8023b0:	57                   	push   %edi
  8023b1:	e8 6f e8 ff ff       	call   800c25 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023b6:	01 de                	add    %ebx,%esi
  8023b8:	83 c4 10             	add    $0x10,%esp
  8023bb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023be:	72 cc                	jb     80238c <devcons_write+0x19>
}
  8023c0:	89 f0                	mov    %esi,%eax
  8023c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023c5:	5b                   	pop    %ebx
  8023c6:	5e                   	pop    %esi
  8023c7:	5f                   	pop    %edi
  8023c8:	5d                   	pop    %ebp
  8023c9:	c3                   	ret    

008023ca <devcons_read>:
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	83 ec 08             	sub    $0x8,%esp
  8023d0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8023d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023d9:	75 07                	jne    8023e2 <devcons_read+0x18>
}
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    
		sys_yield();
  8023dd:	e8 e0 e8 ff ff       	call   800cc2 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8023e2:	e8 5c e8 ff ff       	call   800c43 <sys_cgetc>
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	74 f2                	je     8023dd <devcons_read+0x13>
	if (c < 0)
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	78 ec                	js     8023db <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8023ef:	83 f8 04             	cmp    $0x4,%eax
  8023f2:	74 0c                	je     802400 <devcons_read+0x36>
	*(char*)vbuf = c;
  8023f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f7:	88 02                	mov    %al,(%edx)
	return 1;
  8023f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023fe:	eb db                	jmp    8023db <devcons_read+0x11>
		return 0;
  802400:	b8 00 00 00 00       	mov    $0x0,%eax
  802405:	eb d4                	jmp    8023db <devcons_read+0x11>

00802407 <cputchar>:
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
  80240a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802413:	6a 01                	push   $0x1
  802415:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802418:	50                   	push   %eax
  802419:	e8 07 e8 ff ff       	call   800c25 <sys_cputs>
}
  80241e:	83 c4 10             	add    $0x10,%esp
  802421:	c9                   	leave  
  802422:	c3                   	ret    

00802423 <getchar>:
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
  802426:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802429:	6a 01                	push   $0x1
  80242b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80242e:	50                   	push   %eax
  80242f:	6a 00                	push   $0x0
  802431:	e8 79 f6 ff ff       	call   801aaf <read>
	if (r < 0)
  802436:	83 c4 10             	add    $0x10,%esp
  802439:	85 c0                	test   %eax,%eax
  80243b:	78 08                	js     802445 <getchar+0x22>
	if (r < 1)
  80243d:	85 c0                	test   %eax,%eax
  80243f:	7e 06                	jle    802447 <getchar+0x24>
	return c;
  802441:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    
		return -E_EOF;
  802447:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80244c:	eb f7                	jmp    802445 <getchar+0x22>

0080244e <iscons>:
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802454:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802457:	50                   	push   %eax
  802458:	ff 75 08             	pushl  0x8(%ebp)
  80245b:	e8 de f3 ff ff       	call   80183e <fd_lookup>
  802460:	83 c4 10             	add    $0x10,%esp
  802463:	85 c0                	test   %eax,%eax
  802465:	78 11                	js     802478 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 15 44 30 80 00    	mov    0x803044,%edx
  802470:	39 10                	cmp    %edx,(%eax)
  802472:	0f 94 c0             	sete   %al
  802475:	0f b6 c0             	movzbl %al,%eax
}
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <opencons>:
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802480:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802483:	50                   	push   %eax
  802484:	e8 66 f3 ff ff       	call   8017ef <fd_alloc>
  802489:	83 c4 10             	add    $0x10,%esp
  80248c:	85 c0                	test   %eax,%eax
  80248e:	78 3a                	js     8024ca <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802490:	83 ec 04             	sub    $0x4,%esp
  802493:	68 07 04 00 00       	push   $0x407
  802498:	ff 75 f4             	pushl  -0xc(%ebp)
  80249b:	6a 00                	push   $0x0
  80249d:	e8 3f e8 ff ff       	call   800ce1 <sys_page_alloc>
  8024a2:	83 c4 10             	add    $0x10,%esp
  8024a5:	85 c0                	test   %eax,%eax
  8024a7:	78 21                	js     8024ca <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 15 44 30 80 00    	mov    0x803044,%edx
  8024b2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024be:	83 ec 0c             	sub    $0xc,%esp
  8024c1:	50                   	push   %eax
  8024c2:	e8 01 f3 ff ff       	call   8017c8 <fd2num>
  8024c7:	83 c4 10             	add    $0x10,%esp
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	56                   	push   %esi
  8024d0:	53                   	push   %ebx
  8024d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8024d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  8024da:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  8024dc:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8024e1:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  8024e4:	83 ec 0c             	sub    $0xc,%esp
  8024e7:	50                   	push   %eax
  8024e8:	e8 a4 e9 ff ff       	call   800e91 <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  8024ed:	83 c4 10             	add    $0x10,%esp
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	78 2b                	js     80251f <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  8024f4:	85 f6                	test   %esi,%esi
  8024f6:	74 0a                	je     802502 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8024f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8024fd:	8b 40 74             	mov    0x74(%eax),%eax
  802500:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  802502:	85 db                	test   %ebx,%ebx
  802504:	74 0a                	je     802510 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802506:	a1 04 40 80 00       	mov    0x804004,%eax
  80250b:	8b 40 78             	mov    0x78(%eax),%eax
  80250e:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802510:	a1 04 40 80 00       	mov    0x804004,%eax
  802515:	8b 40 70             	mov    0x70(%eax),%eax
}
  802518:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80251b:	5b                   	pop    %ebx
  80251c:	5e                   	pop    %esi
  80251d:	5d                   	pop    %ebp
  80251e:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80251f:	85 f6                	test   %esi,%esi
  802521:	74 06                	je     802529 <ipc_recv+0x5d>
  802523:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802529:	85 db                	test   %ebx,%ebx
  80252b:	74 eb                	je     802518 <ipc_recv+0x4c>
  80252d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802533:	eb e3                	jmp    802518 <ipc_recv+0x4c>

00802535 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802535:	55                   	push   %ebp
  802536:	89 e5                	mov    %esp,%ebp
  802538:	57                   	push   %edi
  802539:	56                   	push   %esi
  80253a:	53                   	push   %ebx
  80253b:	83 ec 0c             	sub    $0xc,%esp
  80253e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802541:	8b 75 0c             	mov    0xc(%ebp),%esi
  802544:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  802547:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  802549:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80254e:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  802551:	ff 75 14             	pushl  0x14(%ebp)
  802554:	53                   	push   %ebx
  802555:	56                   	push   %esi
  802556:	57                   	push   %edi
  802557:	e8 12 e9 ff ff       	call   800e6e <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  80255c:	83 c4 10             	add    $0x10,%esp
  80255f:	85 c0                	test   %eax,%eax
  802561:	74 1e                	je     802581 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  802563:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802566:	75 07                	jne    80256f <ipc_send+0x3a>
			sys_yield();
  802568:	e8 55 e7 ff ff       	call   800cc2 <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  80256d:	eb e2                	jmp    802551 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  80256f:	50                   	push   %eax
  802570:	68 99 2e 80 00       	push   $0x802e99
  802575:	6a 41                	push   $0x41
  802577:	68 a7 2e 80 00       	push   $0x802ea7
  80257c:	e8 6d dc ff ff       	call   8001ee <_panic>
		}
	}
}
  802581:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802584:	5b                   	pop    %ebx
  802585:	5e                   	pop    %esi
  802586:	5f                   	pop    %edi
  802587:	5d                   	pop    %ebp
  802588:	c3                   	ret    

00802589 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
  80258c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80258f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802594:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802597:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80259d:	8b 52 50             	mov    0x50(%edx),%edx
  8025a0:	39 ca                	cmp    %ecx,%edx
  8025a2:	74 11                	je     8025b5 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8025a4:	83 c0 01             	add    $0x1,%eax
  8025a7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025ac:	75 e6                	jne    802594 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b3:	eb 0b                	jmp    8025c0 <ipc_find_env+0x37>
			return envs[i].env_id;
  8025b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025bd:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025c0:	5d                   	pop    %ebp
  8025c1:	c3                   	ret    

008025c2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
  8025c5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025c8:	89 d0                	mov    %edx,%eax
  8025ca:	c1 e8 16             	shr    $0x16,%eax
  8025cd:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025d4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8025d9:	f6 c1 01             	test   $0x1,%cl
  8025dc:	74 1d                	je     8025fb <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8025de:	c1 ea 0c             	shr    $0xc,%edx
  8025e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025e8:	f6 c2 01             	test   $0x1,%dl
  8025eb:	74 0e                	je     8025fb <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025ed:	c1 ea 0c             	shr    $0xc,%edx
  8025f0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025f7:	ef 
  8025f8:	0f b7 c0             	movzwl %ax,%eax
}
  8025fb:	5d                   	pop    %ebp
  8025fc:	c3                   	ret    
  8025fd:	66 90                	xchg   %ax,%ax
  8025ff:	90                   	nop

00802600 <__udivdi3>:
  802600:	55                   	push   %ebp
  802601:	57                   	push   %edi
  802602:	56                   	push   %esi
  802603:	53                   	push   %ebx
  802604:	83 ec 1c             	sub    $0x1c,%esp
  802607:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80260b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80260f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802613:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802617:	85 d2                	test   %edx,%edx
  802619:	75 35                	jne    802650 <__udivdi3+0x50>
  80261b:	39 f3                	cmp    %esi,%ebx
  80261d:	0f 87 bd 00 00 00    	ja     8026e0 <__udivdi3+0xe0>
  802623:	85 db                	test   %ebx,%ebx
  802625:	89 d9                	mov    %ebx,%ecx
  802627:	75 0b                	jne    802634 <__udivdi3+0x34>
  802629:	b8 01 00 00 00       	mov    $0x1,%eax
  80262e:	31 d2                	xor    %edx,%edx
  802630:	f7 f3                	div    %ebx
  802632:	89 c1                	mov    %eax,%ecx
  802634:	31 d2                	xor    %edx,%edx
  802636:	89 f0                	mov    %esi,%eax
  802638:	f7 f1                	div    %ecx
  80263a:	89 c6                	mov    %eax,%esi
  80263c:	89 e8                	mov    %ebp,%eax
  80263e:	89 f7                	mov    %esi,%edi
  802640:	f7 f1                	div    %ecx
  802642:	89 fa                	mov    %edi,%edx
  802644:	83 c4 1c             	add    $0x1c,%esp
  802647:	5b                   	pop    %ebx
  802648:	5e                   	pop    %esi
  802649:	5f                   	pop    %edi
  80264a:	5d                   	pop    %ebp
  80264b:	c3                   	ret    
  80264c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802650:	39 f2                	cmp    %esi,%edx
  802652:	77 7c                	ja     8026d0 <__udivdi3+0xd0>
  802654:	0f bd fa             	bsr    %edx,%edi
  802657:	83 f7 1f             	xor    $0x1f,%edi
  80265a:	0f 84 98 00 00 00    	je     8026f8 <__udivdi3+0xf8>
  802660:	89 f9                	mov    %edi,%ecx
  802662:	b8 20 00 00 00       	mov    $0x20,%eax
  802667:	29 f8                	sub    %edi,%eax
  802669:	d3 e2                	shl    %cl,%edx
  80266b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80266f:	89 c1                	mov    %eax,%ecx
  802671:	89 da                	mov    %ebx,%edx
  802673:	d3 ea                	shr    %cl,%edx
  802675:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802679:	09 d1                	or     %edx,%ecx
  80267b:	89 f2                	mov    %esi,%edx
  80267d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802681:	89 f9                	mov    %edi,%ecx
  802683:	d3 e3                	shl    %cl,%ebx
  802685:	89 c1                	mov    %eax,%ecx
  802687:	d3 ea                	shr    %cl,%edx
  802689:	89 f9                	mov    %edi,%ecx
  80268b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80268f:	d3 e6                	shl    %cl,%esi
  802691:	89 eb                	mov    %ebp,%ebx
  802693:	89 c1                	mov    %eax,%ecx
  802695:	d3 eb                	shr    %cl,%ebx
  802697:	09 de                	or     %ebx,%esi
  802699:	89 f0                	mov    %esi,%eax
  80269b:	f7 74 24 08          	divl   0x8(%esp)
  80269f:	89 d6                	mov    %edx,%esi
  8026a1:	89 c3                	mov    %eax,%ebx
  8026a3:	f7 64 24 0c          	mull   0xc(%esp)
  8026a7:	39 d6                	cmp    %edx,%esi
  8026a9:	72 0c                	jb     8026b7 <__udivdi3+0xb7>
  8026ab:	89 f9                	mov    %edi,%ecx
  8026ad:	d3 e5                	shl    %cl,%ebp
  8026af:	39 c5                	cmp    %eax,%ebp
  8026b1:	73 5d                	jae    802710 <__udivdi3+0x110>
  8026b3:	39 d6                	cmp    %edx,%esi
  8026b5:	75 59                	jne    802710 <__udivdi3+0x110>
  8026b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026ba:	31 ff                	xor    %edi,%edi
  8026bc:	89 fa                	mov    %edi,%edx
  8026be:	83 c4 1c             	add    $0x1c,%esp
  8026c1:	5b                   	pop    %ebx
  8026c2:	5e                   	pop    %esi
  8026c3:	5f                   	pop    %edi
  8026c4:	5d                   	pop    %ebp
  8026c5:	c3                   	ret    
  8026c6:	8d 76 00             	lea    0x0(%esi),%esi
  8026c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8026d0:	31 ff                	xor    %edi,%edi
  8026d2:	31 c0                	xor    %eax,%eax
  8026d4:	89 fa                	mov    %edi,%edx
  8026d6:	83 c4 1c             	add    $0x1c,%esp
  8026d9:	5b                   	pop    %ebx
  8026da:	5e                   	pop    %esi
  8026db:	5f                   	pop    %edi
  8026dc:	5d                   	pop    %ebp
  8026dd:	c3                   	ret    
  8026de:	66 90                	xchg   %ax,%ax
  8026e0:	31 ff                	xor    %edi,%edi
  8026e2:	89 e8                	mov    %ebp,%eax
  8026e4:	89 f2                	mov    %esi,%edx
  8026e6:	f7 f3                	div    %ebx
  8026e8:	89 fa                	mov    %edi,%edx
  8026ea:	83 c4 1c             	add    $0x1c,%esp
  8026ed:	5b                   	pop    %ebx
  8026ee:	5e                   	pop    %esi
  8026ef:	5f                   	pop    %edi
  8026f0:	5d                   	pop    %ebp
  8026f1:	c3                   	ret    
  8026f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026f8:	39 f2                	cmp    %esi,%edx
  8026fa:	72 06                	jb     802702 <__udivdi3+0x102>
  8026fc:	31 c0                	xor    %eax,%eax
  8026fe:	39 eb                	cmp    %ebp,%ebx
  802700:	77 d2                	ja     8026d4 <__udivdi3+0xd4>
  802702:	b8 01 00 00 00       	mov    $0x1,%eax
  802707:	eb cb                	jmp    8026d4 <__udivdi3+0xd4>
  802709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802710:	89 d8                	mov    %ebx,%eax
  802712:	31 ff                	xor    %edi,%edi
  802714:	eb be                	jmp    8026d4 <__udivdi3+0xd4>
  802716:	66 90                	xchg   %ax,%ax
  802718:	66 90                	xchg   %ax,%ax
  80271a:	66 90                	xchg   %ax,%ax
  80271c:	66 90                	xchg   %ax,%ax
  80271e:	66 90                	xchg   %ax,%ax

00802720 <__umoddi3>:
  802720:	55                   	push   %ebp
  802721:	57                   	push   %edi
  802722:	56                   	push   %esi
  802723:	53                   	push   %ebx
  802724:	83 ec 1c             	sub    $0x1c,%esp
  802727:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80272b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80272f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802733:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802737:	85 ed                	test   %ebp,%ebp
  802739:	89 f0                	mov    %esi,%eax
  80273b:	89 da                	mov    %ebx,%edx
  80273d:	75 19                	jne    802758 <__umoddi3+0x38>
  80273f:	39 df                	cmp    %ebx,%edi
  802741:	0f 86 b1 00 00 00    	jbe    8027f8 <__umoddi3+0xd8>
  802747:	f7 f7                	div    %edi
  802749:	89 d0                	mov    %edx,%eax
  80274b:	31 d2                	xor    %edx,%edx
  80274d:	83 c4 1c             	add    $0x1c,%esp
  802750:	5b                   	pop    %ebx
  802751:	5e                   	pop    %esi
  802752:	5f                   	pop    %edi
  802753:	5d                   	pop    %ebp
  802754:	c3                   	ret    
  802755:	8d 76 00             	lea    0x0(%esi),%esi
  802758:	39 dd                	cmp    %ebx,%ebp
  80275a:	77 f1                	ja     80274d <__umoddi3+0x2d>
  80275c:	0f bd cd             	bsr    %ebp,%ecx
  80275f:	83 f1 1f             	xor    $0x1f,%ecx
  802762:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802766:	0f 84 b4 00 00 00    	je     802820 <__umoddi3+0x100>
  80276c:	b8 20 00 00 00       	mov    $0x20,%eax
  802771:	89 c2                	mov    %eax,%edx
  802773:	8b 44 24 04          	mov    0x4(%esp),%eax
  802777:	29 c2                	sub    %eax,%edx
  802779:	89 c1                	mov    %eax,%ecx
  80277b:	89 f8                	mov    %edi,%eax
  80277d:	d3 e5                	shl    %cl,%ebp
  80277f:	89 d1                	mov    %edx,%ecx
  802781:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802785:	d3 e8                	shr    %cl,%eax
  802787:	09 c5                	or     %eax,%ebp
  802789:	8b 44 24 04          	mov    0x4(%esp),%eax
  80278d:	89 c1                	mov    %eax,%ecx
  80278f:	d3 e7                	shl    %cl,%edi
  802791:	89 d1                	mov    %edx,%ecx
  802793:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802797:	89 df                	mov    %ebx,%edi
  802799:	d3 ef                	shr    %cl,%edi
  80279b:	89 c1                	mov    %eax,%ecx
  80279d:	89 f0                	mov    %esi,%eax
  80279f:	d3 e3                	shl    %cl,%ebx
  8027a1:	89 d1                	mov    %edx,%ecx
  8027a3:	89 fa                	mov    %edi,%edx
  8027a5:	d3 e8                	shr    %cl,%eax
  8027a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027ac:	09 d8                	or     %ebx,%eax
  8027ae:	f7 f5                	div    %ebp
  8027b0:	d3 e6                	shl    %cl,%esi
  8027b2:	89 d1                	mov    %edx,%ecx
  8027b4:	f7 64 24 08          	mull   0x8(%esp)
  8027b8:	39 d1                	cmp    %edx,%ecx
  8027ba:	89 c3                	mov    %eax,%ebx
  8027bc:	89 d7                	mov    %edx,%edi
  8027be:	72 06                	jb     8027c6 <__umoddi3+0xa6>
  8027c0:	75 0e                	jne    8027d0 <__umoddi3+0xb0>
  8027c2:	39 c6                	cmp    %eax,%esi
  8027c4:	73 0a                	jae    8027d0 <__umoddi3+0xb0>
  8027c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8027ca:	19 ea                	sbb    %ebp,%edx
  8027cc:	89 d7                	mov    %edx,%edi
  8027ce:	89 c3                	mov    %eax,%ebx
  8027d0:	89 ca                	mov    %ecx,%edx
  8027d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8027d7:	29 de                	sub    %ebx,%esi
  8027d9:	19 fa                	sbb    %edi,%edx
  8027db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8027df:	89 d0                	mov    %edx,%eax
  8027e1:	d3 e0                	shl    %cl,%eax
  8027e3:	89 d9                	mov    %ebx,%ecx
  8027e5:	d3 ee                	shr    %cl,%esi
  8027e7:	d3 ea                	shr    %cl,%edx
  8027e9:	09 f0                	or     %esi,%eax
  8027eb:	83 c4 1c             	add    $0x1c,%esp
  8027ee:	5b                   	pop    %ebx
  8027ef:	5e                   	pop    %esi
  8027f0:	5f                   	pop    %edi
  8027f1:	5d                   	pop    %ebp
  8027f2:	c3                   	ret    
  8027f3:	90                   	nop
  8027f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027f8:	85 ff                	test   %edi,%edi
  8027fa:	89 f9                	mov    %edi,%ecx
  8027fc:	75 0b                	jne    802809 <__umoddi3+0xe9>
  8027fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802803:	31 d2                	xor    %edx,%edx
  802805:	f7 f7                	div    %edi
  802807:	89 c1                	mov    %eax,%ecx
  802809:	89 d8                	mov    %ebx,%eax
  80280b:	31 d2                	xor    %edx,%edx
  80280d:	f7 f1                	div    %ecx
  80280f:	89 f0                	mov    %esi,%eax
  802811:	f7 f1                	div    %ecx
  802813:	e9 31 ff ff ff       	jmp    802749 <__umoddi3+0x29>
  802818:	90                   	nop
  802819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802820:	39 dd                	cmp    %ebx,%ebp
  802822:	72 08                	jb     80282c <__umoddi3+0x10c>
  802824:	39 f7                	cmp    %esi,%edi
  802826:	0f 87 21 ff ff ff    	ja     80274d <__umoddi3+0x2d>
  80282c:	89 da                	mov    %ebx,%edx
  80282e:	89 f0                	mov    %esi,%eax
  802830:	29 f8                	sub    %edi,%eax
  802832:	19 ea                	sbb    %ebp,%edx
  802834:	e9 14 ff ff ff       	jmp    80274d <__umoddi3+0x2d>
