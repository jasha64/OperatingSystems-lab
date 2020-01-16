
obj/user/stresssched.debug：     文件格式 elf32-i386


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
  80002c:	e8 b7 00 00 00       	call   8000e8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800038:	e8 b8 0b 00 00       	call   800bf5 <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 ab 0e 00 00       	call   800ef4 <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0f                	je     80005c <umain+0x29>
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800055:	e8 ba 0b 00 00       	call   800c14 <sys_yield>
		return;
  80005a:	eb 6e                	jmp    8000ca <umain+0x97>
	if (i == 20) {
  80005c:	83 fb 14             	cmp    $0x14,%ebx
  80005f:	74 f4                	je     800055 <umain+0x22>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800061:	89 f0                	mov    %esi,%eax
  800063:	25 ff 03 00 00       	and    $0x3ff,%eax
  800068:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800070:	eb 02                	jmp    800074 <umain+0x41>
		asm volatile("pause");
  800072:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800074:	8b 50 54             	mov    0x54(%eax),%edx
  800077:	85 d2                	test   %edx,%edx
  800079:	75 f7                	jne    800072 <umain+0x3f>
  80007b:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  800080:	e8 8f 0b 00 00       	call   800c14 <sys_yield>
  800085:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  80008a:	a1 04 20 80 00       	mov    0x802004,%eax
  80008f:	83 c0 01             	add    $0x1,%eax
  800092:	a3 04 20 80 00       	mov    %eax,0x802004
		for (j = 0; j < 10000; j++)
  800097:	83 ea 01             	sub    $0x1,%edx
  80009a:	75 ee                	jne    80008a <umain+0x57>
	for (i = 0; i < 10; i++) {
  80009c:	83 eb 01             	sub    $0x1,%ebx
  80009f:	75 df                	jne    800080 <umain+0x4d>
	}

	if (counter != 10*10000)
  8000a1:	a1 04 20 80 00       	mov    0x802004,%eax
  8000a6:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000ab:	75 24                	jne    8000d1 <umain+0x9e>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ad:	a1 08 20 80 00       	mov    0x802008,%eax
  8000b2:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b5:	8b 40 48             	mov    0x48(%eax),%eax
  8000b8:	83 ec 04             	sub    $0x4,%esp
  8000bb:	52                   	push   %edx
  8000bc:	50                   	push   %eax
  8000bd:	68 db 13 80 00       	push   $0x8013db
  8000c2:	e8 54 01 00 00       	call   80021b <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp

}
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000d1:	a1 04 20 80 00       	mov    0x802004,%eax
  8000d6:	50                   	push   %eax
  8000d7:	68 a0 13 80 00       	push   $0x8013a0
  8000dc:	6a 21                	push   $0x21
  8000de:	68 c8 13 80 00       	push   $0x8013c8
  8000e3:	e8 58 00 00 00       	call   800140 <_panic>

008000e8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e8:	55                   	push   %ebp
  8000e9:	89 e5                	mov    %esp,%ebp
  8000eb:	56                   	push   %esi
  8000ec:	53                   	push   %ebx
  8000ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000f0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  8000f3:	e8 fd 0a 00 00       	call   800bf5 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  8000f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000fd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800100:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800105:	a3 08 20 80 00       	mov    %eax,0x802008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010a:	85 db                	test   %ebx,%ebx
  80010c:	7e 07                	jle    800115 <libmain+0x2d>
		binaryname = argv[0];
  80010e:	8b 06                	mov    (%esi),%eax
  800110:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
  80011a:	e8 14 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011f:	e8 0a 00 00 00       	call   80012e <exit>
}
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012a:	5b                   	pop    %ebx
  80012b:	5e                   	pop    %esi
  80012c:	5d                   	pop    %ebp
  80012d:	c3                   	ret    

0080012e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800134:	6a 00                	push   $0x0
  800136:	e8 79 0a 00 00       	call   800bb4 <sys_env_destroy>
}
  80013b:	83 c4 10             	add    $0x10,%esp
  80013e:	c9                   	leave  
  80013f:	c3                   	ret    

00800140 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	56                   	push   %esi
  800144:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800145:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800148:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80014e:	e8 a2 0a 00 00       	call   800bf5 <sys_getenvid>
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	ff 75 0c             	pushl  0xc(%ebp)
  800159:	ff 75 08             	pushl  0x8(%ebp)
  80015c:	56                   	push   %esi
  80015d:	50                   	push   %eax
  80015e:	68 04 14 80 00       	push   $0x801404
  800163:	e8 b3 00 00 00       	call   80021b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800168:	83 c4 18             	add    $0x18,%esp
  80016b:	53                   	push   %ebx
  80016c:	ff 75 10             	pushl  0x10(%ebp)
  80016f:	e8 56 00 00 00       	call   8001ca <vcprintf>
	cprintf("\n");
  800174:	c7 04 24 f7 13 80 00 	movl   $0x8013f7,(%esp)
  80017b:	e8 9b 00 00 00       	call   80021b <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800183:	cc                   	int3   
  800184:	eb fd                	jmp    800183 <_panic+0x43>

00800186 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800186:	55                   	push   %ebp
  800187:	89 e5                	mov    %esp,%ebp
  800189:	53                   	push   %ebx
  80018a:	83 ec 04             	sub    $0x4,%esp
  80018d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800190:	8b 13                	mov    (%ebx),%edx
  800192:	8d 42 01             	lea    0x1(%edx),%eax
  800195:	89 03                	mov    %eax,(%ebx)
  800197:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80019a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80019e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a3:	74 09                	je     8001ae <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ac:	c9                   	leave  
  8001ad:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	68 ff 00 00 00       	push   $0xff
  8001b6:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b9:	50                   	push   %eax
  8001ba:	e8 b8 09 00 00       	call   800b77 <sys_cputs>
		b->idx = 0;
  8001bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c5:	83 c4 10             	add    $0x10,%esp
  8001c8:	eb db                	jmp    8001a5 <putch+0x1f>

008001ca <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001da:	00 00 00 
	b.cnt = 0;
  8001dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ea:	ff 75 08             	pushl  0x8(%ebp)
  8001ed:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f3:	50                   	push   %eax
  8001f4:	68 86 01 80 00       	push   $0x800186
  8001f9:	e8 1a 01 00 00       	call   800318 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001fe:	83 c4 08             	add    $0x8,%esp
  800201:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800207:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80020d:	50                   	push   %eax
  80020e:	e8 64 09 00 00       	call   800b77 <sys_cputs>

	return b.cnt;
}
  800213:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800219:	c9                   	leave  
  80021a:	c3                   	ret    

0080021b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800221:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800224:	50                   	push   %eax
  800225:	ff 75 08             	pushl  0x8(%ebp)
  800228:	e8 9d ff ff ff       	call   8001ca <vcprintf>
	va_end(ap);

	return cnt;
}
  80022d:	c9                   	leave  
  80022e:	c3                   	ret    

0080022f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	57                   	push   %edi
  800233:	56                   	push   %esi
  800234:	53                   	push   %ebx
  800235:	83 ec 1c             	sub    $0x1c,%esp
  800238:	89 c7                	mov    %eax,%edi
  80023a:	89 d6                	mov    %edx,%esi
  80023c:	8b 45 08             	mov    0x8(%ebp),%eax
  80023f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800242:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800245:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800248:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80024b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800250:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800253:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800256:	39 d3                	cmp    %edx,%ebx
  800258:	72 05                	jb     80025f <printnum+0x30>
  80025a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80025d:	77 7a                	ja     8002d9 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	ff 75 18             	pushl  0x18(%ebp)
  800265:	8b 45 14             	mov    0x14(%ebp),%eax
  800268:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80026b:	53                   	push   %ebx
  80026c:	ff 75 10             	pushl  0x10(%ebp)
  80026f:	83 ec 08             	sub    $0x8,%esp
  800272:	ff 75 e4             	pushl  -0x1c(%ebp)
  800275:	ff 75 e0             	pushl  -0x20(%ebp)
  800278:	ff 75 dc             	pushl  -0x24(%ebp)
  80027b:	ff 75 d8             	pushl  -0x28(%ebp)
  80027e:	e8 dd 0e 00 00       	call   801160 <__udivdi3>
  800283:	83 c4 18             	add    $0x18,%esp
  800286:	52                   	push   %edx
  800287:	50                   	push   %eax
  800288:	89 f2                	mov    %esi,%edx
  80028a:	89 f8                	mov    %edi,%eax
  80028c:	e8 9e ff ff ff       	call   80022f <printnum>
  800291:	83 c4 20             	add    $0x20,%esp
  800294:	eb 13                	jmp    8002a9 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	56                   	push   %esi
  80029a:	ff 75 18             	pushl  0x18(%ebp)
  80029d:	ff d7                	call   *%edi
  80029f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002a2:	83 eb 01             	sub    $0x1,%ebx
  8002a5:	85 db                	test   %ebx,%ebx
  8002a7:	7f ed                	jg     800296 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002a9:	83 ec 08             	sub    $0x8,%esp
  8002ac:	56                   	push   %esi
  8002ad:	83 ec 04             	sub    $0x4,%esp
  8002b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b3:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002bc:	e8 bf 0f 00 00       	call   801280 <__umoddi3>
  8002c1:	83 c4 14             	add    $0x14,%esp
  8002c4:	0f be 80 27 14 80 00 	movsbl 0x801427(%eax),%eax
  8002cb:	50                   	push   %eax
  8002cc:	ff d7                	call   *%edi
}
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d4:	5b                   	pop    %ebx
  8002d5:	5e                   	pop    %esi
  8002d6:	5f                   	pop    %edi
  8002d7:	5d                   	pop    %ebp
  8002d8:	c3                   	ret    
  8002d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002dc:	eb c4                	jmp    8002a2 <printnum+0x73>

008002de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e8:	8b 10                	mov    (%eax),%edx
  8002ea:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ed:	73 0a                	jae    8002f9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ef:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f2:	89 08                	mov    %ecx,(%eax)
  8002f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f7:	88 02                	mov    %al,(%edx)
}
  8002f9:	5d                   	pop    %ebp
  8002fa:	c3                   	ret    

008002fb <printfmt>:
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800301:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800304:	50                   	push   %eax
  800305:	ff 75 10             	pushl  0x10(%ebp)
  800308:	ff 75 0c             	pushl  0xc(%ebp)
  80030b:	ff 75 08             	pushl  0x8(%ebp)
  80030e:	e8 05 00 00 00       	call   800318 <vprintfmt>
}
  800313:	83 c4 10             	add    $0x10,%esp
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <vprintfmt>:
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	57                   	push   %edi
  80031c:	56                   	push   %esi
  80031d:	53                   	push   %ebx
  80031e:	83 ec 2c             	sub    $0x2c,%esp
  800321:	8b 75 08             	mov    0x8(%ebp),%esi
  800324:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800327:	8b 7d 10             	mov    0x10(%ebp),%edi
  80032a:	e9 c1 03 00 00       	jmp    8006f0 <vprintfmt+0x3d8>
		padc = ' ';
  80032f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800333:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80033a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800341:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800348:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	8d 47 01             	lea    0x1(%edi),%eax
  800350:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800353:	0f b6 17             	movzbl (%edi),%edx
  800356:	8d 42 dd             	lea    -0x23(%edx),%eax
  800359:	3c 55                	cmp    $0x55,%al
  80035b:	0f 87 12 04 00 00    	ja     800773 <vprintfmt+0x45b>
  800361:	0f b6 c0             	movzbl %al,%eax
  800364:	ff 24 85 60 15 80 00 	jmp    *0x801560(,%eax,4)
  80036b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800372:	eb d9                	jmp    80034d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800377:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80037b:	eb d0                	jmp    80034d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80037d:	0f b6 d2             	movzbl %dl,%edx
  800380:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800383:	b8 00 00 00 00       	mov    $0x0,%eax
  800388:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80038b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800392:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800395:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800398:	83 f9 09             	cmp    $0x9,%ecx
  80039b:	77 55                	ja     8003f2 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80039d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a0:	eb e9                	jmp    80038b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a5:	8b 00                	mov    (%eax),%eax
  8003a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ad:	8d 40 04             	lea    0x4(%eax),%eax
  8003b0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ba:	79 91                	jns    80034d <vprintfmt+0x35>
				width = precision, precision = -1;
  8003bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003c9:	eb 82                	jmp    80034d <vprintfmt+0x35>
  8003cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ce:	85 c0                	test   %eax,%eax
  8003d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d5:	0f 49 d0             	cmovns %eax,%edx
  8003d8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003de:	e9 6a ff ff ff       	jmp    80034d <vprintfmt+0x35>
  8003e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003ed:	e9 5b ff ff ff       	jmp    80034d <vprintfmt+0x35>
  8003f2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003f8:	eb bc                	jmp    8003b6 <vprintfmt+0x9e>
			lflag++;
  8003fa:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800400:	e9 48 ff ff ff       	jmp    80034d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800405:	8b 45 14             	mov    0x14(%ebp),%eax
  800408:	8d 78 04             	lea    0x4(%eax),%edi
  80040b:	83 ec 08             	sub    $0x8,%esp
  80040e:	53                   	push   %ebx
  80040f:	ff 30                	pushl  (%eax)
  800411:	ff d6                	call   *%esi
			break;
  800413:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800416:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800419:	e9 cf 02 00 00       	jmp    8006ed <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80041e:	8b 45 14             	mov    0x14(%ebp),%eax
  800421:	8d 78 04             	lea    0x4(%eax),%edi
  800424:	8b 00                	mov    (%eax),%eax
  800426:	99                   	cltd   
  800427:	31 d0                	xor    %edx,%eax
  800429:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80042b:	83 f8 0f             	cmp    $0xf,%eax
  80042e:	7f 23                	jg     800453 <vprintfmt+0x13b>
  800430:	8b 14 85 c0 16 80 00 	mov    0x8016c0(,%eax,4),%edx
  800437:	85 d2                	test   %edx,%edx
  800439:	74 18                	je     800453 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80043b:	52                   	push   %edx
  80043c:	68 48 14 80 00       	push   $0x801448
  800441:	53                   	push   %ebx
  800442:	56                   	push   %esi
  800443:	e8 b3 fe ff ff       	call   8002fb <printfmt>
  800448:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044e:	e9 9a 02 00 00       	jmp    8006ed <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800453:	50                   	push   %eax
  800454:	68 3f 14 80 00       	push   $0x80143f
  800459:	53                   	push   %ebx
  80045a:	56                   	push   %esi
  80045b:	e8 9b fe ff ff       	call   8002fb <printfmt>
  800460:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800463:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800466:	e9 82 02 00 00       	jmp    8006ed <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80046b:	8b 45 14             	mov    0x14(%ebp),%eax
  80046e:	83 c0 04             	add    $0x4,%eax
  800471:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800479:	85 ff                	test   %edi,%edi
  80047b:	b8 38 14 80 00       	mov    $0x801438,%eax
  800480:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800483:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800487:	0f 8e bd 00 00 00    	jle    80054a <vprintfmt+0x232>
  80048d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800491:	75 0e                	jne    8004a1 <vprintfmt+0x189>
  800493:	89 75 08             	mov    %esi,0x8(%ebp)
  800496:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800499:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80049c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80049f:	eb 6d                	jmp    80050e <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	ff 75 d0             	pushl  -0x30(%ebp)
  8004a7:	57                   	push   %edi
  8004a8:	e8 6e 03 00 00       	call   80081b <strnlen>
  8004ad:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b0:	29 c1                	sub    %eax,%ecx
  8004b2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004b5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004b8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004bf:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004c2:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c4:	eb 0f                	jmp    8004d5 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004c6:	83 ec 08             	sub    $0x8,%esp
  8004c9:	53                   	push   %ebx
  8004ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8004cd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cf:	83 ef 01             	sub    $0x1,%edi
  8004d2:	83 c4 10             	add    $0x10,%esp
  8004d5:	85 ff                	test   %edi,%edi
  8004d7:	7f ed                	jg     8004c6 <vprintfmt+0x1ae>
  8004d9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004dc:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004df:	85 c9                	test   %ecx,%ecx
  8004e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e6:	0f 49 c1             	cmovns %ecx,%eax
  8004e9:	29 c1                	sub    %eax,%ecx
  8004eb:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ee:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004f1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004f4:	89 cb                	mov    %ecx,%ebx
  8004f6:	eb 16                	jmp    80050e <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004fc:	75 31                	jne    80052f <vprintfmt+0x217>
					putch(ch, putdat);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	ff 75 0c             	pushl  0xc(%ebp)
  800504:	50                   	push   %eax
  800505:	ff 55 08             	call   *0x8(%ebp)
  800508:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050b:	83 eb 01             	sub    $0x1,%ebx
  80050e:	83 c7 01             	add    $0x1,%edi
  800511:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800515:	0f be c2             	movsbl %dl,%eax
  800518:	85 c0                	test   %eax,%eax
  80051a:	74 59                	je     800575 <vprintfmt+0x25d>
  80051c:	85 f6                	test   %esi,%esi
  80051e:	78 d8                	js     8004f8 <vprintfmt+0x1e0>
  800520:	83 ee 01             	sub    $0x1,%esi
  800523:	79 d3                	jns    8004f8 <vprintfmt+0x1e0>
  800525:	89 df                	mov    %ebx,%edi
  800527:	8b 75 08             	mov    0x8(%ebp),%esi
  80052a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80052d:	eb 37                	jmp    800566 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80052f:	0f be d2             	movsbl %dl,%edx
  800532:	83 ea 20             	sub    $0x20,%edx
  800535:	83 fa 5e             	cmp    $0x5e,%edx
  800538:	76 c4                	jbe    8004fe <vprintfmt+0x1e6>
					putch('?', putdat);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	ff 75 0c             	pushl  0xc(%ebp)
  800540:	6a 3f                	push   $0x3f
  800542:	ff 55 08             	call   *0x8(%ebp)
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	eb c1                	jmp    80050b <vprintfmt+0x1f3>
  80054a:	89 75 08             	mov    %esi,0x8(%ebp)
  80054d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800550:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800553:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800556:	eb b6                	jmp    80050e <vprintfmt+0x1f6>
				putch(' ', putdat);
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	53                   	push   %ebx
  80055c:	6a 20                	push   $0x20
  80055e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800560:	83 ef 01             	sub    $0x1,%edi
  800563:	83 c4 10             	add    $0x10,%esp
  800566:	85 ff                	test   %edi,%edi
  800568:	7f ee                	jg     800558 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80056a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
  800570:	e9 78 01 00 00       	jmp    8006ed <vprintfmt+0x3d5>
  800575:	89 df                	mov    %ebx,%edi
  800577:	8b 75 08             	mov    0x8(%ebp),%esi
  80057a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80057d:	eb e7                	jmp    800566 <vprintfmt+0x24e>
	if (lflag >= 2)
  80057f:	83 f9 01             	cmp    $0x1,%ecx
  800582:	7e 3f                	jle    8005c3 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8b 50 04             	mov    0x4(%eax),%edx
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 08             	lea    0x8(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80059b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80059f:	79 5c                	jns    8005fd <vprintfmt+0x2e5>
				putch('-', putdat);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	53                   	push   %ebx
  8005a5:	6a 2d                	push   $0x2d
  8005a7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005ac:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005af:	f7 da                	neg    %edx
  8005b1:	83 d1 00             	adc    $0x0,%ecx
  8005b4:	f7 d9                	neg    %ecx
  8005b6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005be:	e9 10 01 00 00       	jmp    8006d3 <vprintfmt+0x3bb>
	else if (lflag)
  8005c3:	85 c9                	test   %ecx,%ecx
  8005c5:	75 1b                	jne    8005e2 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8b 00                	mov    (%eax),%eax
  8005cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cf:	89 c1                	mov    %eax,%ecx
  8005d1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8d 40 04             	lea    0x4(%eax),%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	eb b9                	jmp    80059b <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ea:	89 c1                	mov    %eax,%ecx
  8005ec:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ef:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8d 40 04             	lea    0x4(%eax),%eax
  8005f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fb:	eb 9e                	jmp    80059b <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005fd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800600:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800603:	b8 0a 00 00 00       	mov    $0xa,%eax
  800608:	e9 c6 00 00 00       	jmp    8006d3 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80060d:	83 f9 01             	cmp    $0x1,%ecx
  800610:	7e 18                	jle    80062a <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8b 10                	mov    (%eax),%edx
  800617:	8b 48 04             	mov    0x4(%eax),%ecx
  80061a:	8d 40 08             	lea    0x8(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800620:	b8 0a 00 00 00       	mov    $0xa,%eax
  800625:	e9 a9 00 00 00       	jmp    8006d3 <vprintfmt+0x3bb>
	else if (lflag)
  80062a:	85 c9                	test   %ecx,%ecx
  80062c:	75 1a                	jne    800648 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8b 10                	mov    (%eax),%edx
  800633:	b9 00 00 00 00       	mov    $0x0,%ecx
  800638:	8d 40 04             	lea    0x4(%eax),%eax
  80063b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800643:	e9 8b 00 00 00       	jmp    8006d3 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8b 10                	mov    (%eax),%edx
  80064d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800652:	8d 40 04             	lea    0x4(%eax),%eax
  800655:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800658:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065d:	eb 74                	jmp    8006d3 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80065f:	83 f9 01             	cmp    $0x1,%ecx
  800662:	7e 15                	jle    800679 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8b 10                	mov    (%eax),%edx
  800669:	8b 48 04             	mov    0x4(%eax),%ecx
  80066c:	8d 40 08             	lea    0x8(%eax),%eax
  80066f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800672:	b8 08 00 00 00       	mov    $0x8,%eax
  800677:	eb 5a                	jmp    8006d3 <vprintfmt+0x3bb>
	else if (lflag)
  800679:	85 c9                	test   %ecx,%ecx
  80067b:	75 17                	jne    800694 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 10                	mov    (%eax),%edx
  800682:	b9 00 00 00 00       	mov    $0x0,%ecx
  800687:	8d 40 04             	lea    0x4(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068d:	b8 08 00 00 00       	mov    $0x8,%eax
  800692:	eb 3f                	jmp    8006d3 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 10                	mov    (%eax),%edx
  800699:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069e:	8d 40 04             	lea    0x4(%eax),%eax
  8006a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a4:	b8 08 00 00 00       	mov    $0x8,%eax
  8006a9:	eb 28                	jmp    8006d3 <vprintfmt+0x3bb>
			putch('0', putdat);
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	53                   	push   %ebx
  8006af:	6a 30                	push   $0x30
  8006b1:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b3:	83 c4 08             	add    $0x8,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	6a 78                	push   $0x78
  8006b9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8b 10                	mov    (%eax),%edx
  8006c0:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006c5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006c8:	8d 40 04             	lea    0x4(%eax),%eax
  8006cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ce:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006d3:	83 ec 0c             	sub    $0xc,%esp
  8006d6:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006da:	57                   	push   %edi
  8006db:	ff 75 e0             	pushl  -0x20(%ebp)
  8006de:	50                   	push   %eax
  8006df:	51                   	push   %ecx
  8006e0:	52                   	push   %edx
  8006e1:	89 da                	mov    %ebx,%edx
  8006e3:	89 f0                	mov    %esi,%eax
  8006e5:	e8 45 fb ff ff       	call   80022f <printnum>
			break;
  8006ea:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  8006f0:	83 c7 01             	add    $0x1,%edi
  8006f3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006f7:	83 f8 25             	cmp    $0x25,%eax
  8006fa:	0f 84 2f fc ff ff    	je     80032f <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  800700:	85 c0                	test   %eax,%eax
  800702:	0f 84 8b 00 00 00    	je     800793 <vprintfmt+0x47b>
			putch(ch, putdat);
  800708:	83 ec 08             	sub    $0x8,%esp
  80070b:	53                   	push   %ebx
  80070c:	50                   	push   %eax
  80070d:	ff d6                	call   *%esi
  80070f:	83 c4 10             	add    $0x10,%esp
  800712:	eb dc                	jmp    8006f0 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800714:	83 f9 01             	cmp    $0x1,%ecx
  800717:	7e 15                	jle    80072e <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	8b 10                	mov    (%eax),%edx
  80071e:	8b 48 04             	mov    0x4(%eax),%ecx
  800721:	8d 40 08             	lea    0x8(%eax),%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800727:	b8 10 00 00 00       	mov    $0x10,%eax
  80072c:	eb a5                	jmp    8006d3 <vprintfmt+0x3bb>
	else if (lflag)
  80072e:	85 c9                	test   %ecx,%ecx
  800730:	75 17                	jne    800749 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8b 10                	mov    (%eax),%edx
  800737:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073c:	8d 40 04             	lea    0x4(%eax),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800742:	b8 10 00 00 00       	mov    $0x10,%eax
  800747:	eb 8a                	jmp    8006d3 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8b 10                	mov    (%eax),%edx
  80074e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800753:	8d 40 04             	lea    0x4(%eax),%eax
  800756:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800759:	b8 10 00 00 00       	mov    $0x10,%eax
  80075e:	e9 70 ff ff ff       	jmp    8006d3 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	53                   	push   %ebx
  800767:	6a 25                	push   $0x25
  800769:	ff d6                	call   *%esi
			break;
  80076b:	83 c4 10             	add    $0x10,%esp
  80076e:	e9 7a ff ff ff       	jmp    8006ed <vprintfmt+0x3d5>
			putch('%', putdat);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	53                   	push   %ebx
  800777:	6a 25                	push   $0x25
  800779:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80077b:	83 c4 10             	add    $0x10,%esp
  80077e:	89 f8                	mov    %edi,%eax
  800780:	eb 03                	jmp    800785 <vprintfmt+0x46d>
  800782:	83 e8 01             	sub    $0x1,%eax
  800785:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800789:	75 f7                	jne    800782 <vprintfmt+0x46a>
  80078b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80078e:	e9 5a ff ff ff       	jmp    8006ed <vprintfmt+0x3d5>
}
  800793:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800796:	5b                   	pop    %ebx
  800797:	5e                   	pop    %esi
  800798:	5f                   	pop    %edi
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007aa:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007ae:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007b8:	85 c0                	test   %eax,%eax
  8007ba:	74 26                	je     8007e2 <vsnprintf+0x47>
  8007bc:	85 d2                	test   %edx,%edx
  8007be:	7e 22                	jle    8007e2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c0:	ff 75 14             	pushl  0x14(%ebp)
  8007c3:	ff 75 10             	pushl  0x10(%ebp)
  8007c6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007c9:	50                   	push   %eax
  8007ca:	68 de 02 80 00       	push   $0x8002de
  8007cf:	e8 44 fb ff ff       	call   800318 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007d7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007dd:	83 c4 10             	add    $0x10,%esp
}
  8007e0:	c9                   	leave  
  8007e1:	c3                   	ret    
		return -E_INVAL;
  8007e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007e7:	eb f7                	jmp    8007e0 <vsnprintf+0x45>

008007e9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007ef:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007f2:	50                   	push   %eax
  8007f3:	ff 75 10             	pushl  0x10(%ebp)
  8007f6:	ff 75 0c             	pushl  0xc(%ebp)
  8007f9:	ff 75 08             	pushl  0x8(%ebp)
  8007fc:	e8 9a ff ff ff       	call   80079b <vsnprintf>
	va_end(ap);

	return rc;
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800809:	b8 00 00 00 00       	mov    $0x0,%eax
  80080e:	eb 03                	jmp    800813 <strlen+0x10>
		n++;
  800810:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800813:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800817:	75 f7                	jne    800810 <strlen+0xd>
	return n;
}
  800819:	5d                   	pop    %ebp
  80081a:	c3                   	ret    

0080081b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800821:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800824:	b8 00 00 00 00       	mov    $0x0,%eax
  800829:	eb 03                	jmp    80082e <strnlen+0x13>
		n++;
  80082b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80082e:	39 d0                	cmp    %edx,%eax
  800830:	74 06                	je     800838 <strnlen+0x1d>
  800832:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800836:	75 f3                	jne    80082b <strnlen+0x10>
	return n;
}
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    

0080083a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	53                   	push   %ebx
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800844:	89 c2                	mov    %eax,%edx
  800846:	83 c1 01             	add    $0x1,%ecx
  800849:	83 c2 01             	add    $0x1,%edx
  80084c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800850:	88 5a ff             	mov    %bl,-0x1(%edx)
  800853:	84 db                	test   %bl,%bl
  800855:	75 ef                	jne    800846 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800857:	5b                   	pop    %ebx
  800858:	5d                   	pop    %ebp
  800859:	c3                   	ret    

0080085a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	53                   	push   %ebx
  80085e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800861:	53                   	push   %ebx
  800862:	e8 9c ff ff ff       	call   800803 <strlen>
  800867:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	01 d8                	add    %ebx,%eax
  80086f:	50                   	push   %eax
  800870:	e8 c5 ff ff ff       	call   80083a <strcpy>
	return dst;
}
  800875:	89 d8                	mov    %ebx,%eax
  800877:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80087a:	c9                   	leave  
  80087b:	c3                   	ret    

0080087c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	56                   	push   %esi
  800880:	53                   	push   %ebx
  800881:	8b 75 08             	mov    0x8(%ebp),%esi
  800884:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800887:	89 f3                	mov    %esi,%ebx
  800889:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80088c:	89 f2                	mov    %esi,%edx
  80088e:	eb 0f                	jmp    80089f <strncpy+0x23>
		*dst++ = *src;
  800890:	83 c2 01             	add    $0x1,%edx
  800893:	0f b6 01             	movzbl (%ecx),%eax
  800896:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800899:	80 39 01             	cmpb   $0x1,(%ecx)
  80089c:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80089f:	39 da                	cmp    %ebx,%edx
  8008a1:	75 ed                	jne    800890 <strncpy+0x14>
	}
	return ret;
}
  8008a3:	89 f0                	mov    %esi,%eax
  8008a5:	5b                   	pop    %ebx
  8008a6:	5e                   	pop    %esi
  8008a7:	5d                   	pop    %ebp
  8008a8:	c3                   	ret    

008008a9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	56                   	push   %esi
  8008ad:	53                   	push   %ebx
  8008ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008b7:	89 f0                	mov    %esi,%eax
  8008b9:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008bd:	85 c9                	test   %ecx,%ecx
  8008bf:	75 0b                	jne    8008cc <strlcpy+0x23>
  8008c1:	eb 17                	jmp    8008da <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008c3:	83 c2 01             	add    $0x1,%edx
  8008c6:	83 c0 01             	add    $0x1,%eax
  8008c9:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008cc:	39 d8                	cmp    %ebx,%eax
  8008ce:	74 07                	je     8008d7 <strlcpy+0x2e>
  8008d0:	0f b6 0a             	movzbl (%edx),%ecx
  8008d3:	84 c9                	test   %cl,%cl
  8008d5:	75 ec                	jne    8008c3 <strlcpy+0x1a>
		*dst = '\0';
  8008d7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008da:	29 f0                	sub    %esi,%eax
}
  8008dc:	5b                   	pop    %ebx
  8008dd:	5e                   	pop    %esi
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008e9:	eb 06                	jmp    8008f1 <strcmp+0x11>
		p++, q++;
  8008eb:	83 c1 01             	add    $0x1,%ecx
  8008ee:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008f1:	0f b6 01             	movzbl (%ecx),%eax
  8008f4:	84 c0                	test   %al,%al
  8008f6:	74 04                	je     8008fc <strcmp+0x1c>
  8008f8:	3a 02                	cmp    (%edx),%al
  8008fa:	74 ef                	je     8008eb <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008fc:	0f b6 c0             	movzbl %al,%eax
  8008ff:	0f b6 12             	movzbl (%edx),%edx
  800902:	29 d0                	sub    %edx,%eax
}
  800904:	5d                   	pop    %ebp
  800905:	c3                   	ret    

00800906 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	53                   	push   %ebx
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800910:	89 c3                	mov    %eax,%ebx
  800912:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800915:	eb 06                	jmp    80091d <strncmp+0x17>
		n--, p++, q++;
  800917:	83 c0 01             	add    $0x1,%eax
  80091a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80091d:	39 d8                	cmp    %ebx,%eax
  80091f:	74 16                	je     800937 <strncmp+0x31>
  800921:	0f b6 08             	movzbl (%eax),%ecx
  800924:	84 c9                	test   %cl,%cl
  800926:	74 04                	je     80092c <strncmp+0x26>
  800928:	3a 0a                	cmp    (%edx),%cl
  80092a:	74 eb                	je     800917 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80092c:	0f b6 00             	movzbl (%eax),%eax
  80092f:	0f b6 12             	movzbl (%edx),%edx
  800932:	29 d0                	sub    %edx,%eax
}
  800934:	5b                   	pop    %ebx
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    
		return 0;
  800937:	b8 00 00 00 00       	mov    $0x0,%eax
  80093c:	eb f6                	jmp    800934 <strncmp+0x2e>

0080093e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800948:	0f b6 10             	movzbl (%eax),%edx
  80094b:	84 d2                	test   %dl,%dl
  80094d:	74 09                	je     800958 <strchr+0x1a>
		if (*s == c)
  80094f:	38 ca                	cmp    %cl,%dl
  800951:	74 0a                	je     80095d <strchr+0x1f>
	for (; *s; s++)
  800953:	83 c0 01             	add    $0x1,%eax
  800956:	eb f0                	jmp    800948 <strchr+0xa>
			return (char *) s;
	return 0;
  800958:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800969:	eb 03                	jmp    80096e <strfind+0xf>
  80096b:	83 c0 01             	add    $0x1,%eax
  80096e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800971:	38 ca                	cmp    %cl,%dl
  800973:	74 04                	je     800979 <strfind+0x1a>
  800975:	84 d2                	test   %dl,%dl
  800977:	75 f2                	jne    80096b <strfind+0xc>
			break;
	return (char *) s;
}
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	57                   	push   %edi
  80097f:	56                   	push   %esi
  800980:	53                   	push   %ebx
  800981:	8b 7d 08             	mov    0x8(%ebp),%edi
  800984:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800987:	85 c9                	test   %ecx,%ecx
  800989:	74 13                	je     80099e <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80098b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800991:	75 05                	jne    800998 <memset+0x1d>
  800993:	f6 c1 03             	test   $0x3,%cl
  800996:	74 0d                	je     8009a5 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800998:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099b:	fc                   	cld    
  80099c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80099e:	89 f8                	mov    %edi,%eax
  8009a0:	5b                   	pop    %ebx
  8009a1:	5e                   	pop    %esi
  8009a2:	5f                   	pop    %edi
  8009a3:	5d                   	pop    %ebp
  8009a4:	c3                   	ret    
		c &= 0xFF;
  8009a5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009a9:	89 d3                	mov    %edx,%ebx
  8009ab:	c1 e3 08             	shl    $0x8,%ebx
  8009ae:	89 d0                	mov    %edx,%eax
  8009b0:	c1 e0 18             	shl    $0x18,%eax
  8009b3:	89 d6                	mov    %edx,%esi
  8009b5:	c1 e6 10             	shl    $0x10,%esi
  8009b8:	09 f0                	or     %esi,%eax
  8009ba:	09 c2                	or     %eax,%edx
  8009bc:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009be:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009c1:	89 d0                	mov    %edx,%eax
  8009c3:	fc                   	cld    
  8009c4:	f3 ab                	rep stos %eax,%es:(%edi)
  8009c6:	eb d6                	jmp    80099e <memset+0x23>

008009c8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	57                   	push   %edi
  8009cc:	56                   	push   %esi
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009d6:	39 c6                	cmp    %eax,%esi
  8009d8:	73 35                	jae    800a0f <memmove+0x47>
  8009da:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009dd:	39 c2                	cmp    %eax,%edx
  8009df:	76 2e                	jbe    800a0f <memmove+0x47>
		s += n;
		d += n;
  8009e1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e4:	89 d6                	mov    %edx,%esi
  8009e6:	09 fe                	or     %edi,%esi
  8009e8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ee:	74 0c                	je     8009fc <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009f0:	83 ef 01             	sub    $0x1,%edi
  8009f3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009f6:	fd                   	std    
  8009f7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009f9:	fc                   	cld    
  8009fa:	eb 21                	jmp    800a1d <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fc:	f6 c1 03             	test   $0x3,%cl
  8009ff:	75 ef                	jne    8009f0 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a01:	83 ef 04             	sub    $0x4,%edi
  800a04:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a07:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a0a:	fd                   	std    
  800a0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a0d:	eb ea                	jmp    8009f9 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0f:	89 f2                	mov    %esi,%edx
  800a11:	09 c2                	or     %eax,%edx
  800a13:	f6 c2 03             	test   $0x3,%dl
  800a16:	74 09                	je     800a21 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a18:	89 c7                	mov    %eax,%edi
  800a1a:	fc                   	cld    
  800a1b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a1d:	5e                   	pop    %esi
  800a1e:	5f                   	pop    %edi
  800a1f:	5d                   	pop    %ebp
  800a20:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a21:	f6 c1 03             	test   $0x3,%cl
  800a24:	75 f2                	jne    800a18 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a26:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a29:	89 c7                	mov    %eax,%edi
  800a2b:	fc                   	cld    
  800a2c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a2e:	eb ed                	jmp    800a1d <memmove+0x55>

00800a30 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a33:	ff 75 10             	pushl  0x10(%ebp)
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	ff 75 08             	pushl  0x8(%ebp)
  800a3c:	e8 87 ff ff ff       	call   8009c8 <memmove>
}
  800a41:	c9                   	leave  
  800a42:	c3                   	ret    

00800a43 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	56                   	push   %esi
  800a47:	53                   	push   %ebx
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4e:	89 c6                	mov    %eax,%esi
  800a50:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a53:	39 f0                	cmp    %esi,%eax
  800a55:	74 1c                	je     800a73 <memcmp+0x30>
		if (*s1 != *s2)
  800a57:	0f b6 08             	movzbl (%eax),%ecx
  800a5a:	0f b6 1a             	movzbl (%edx),%ebx
  800a5d:	38 d9                	cmp    %bl,%cl
  800a5f:	75 08                	jne    800a69 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a61:	83 c0 01             	add    $0x1,%eax
  800a64:	83 c2 01             	add    $0x1,%edx
  800a67:	eb ea                	jmp    800a53 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a69:	0f b6 c1             	movzbl %cl,%eax
  800a6c:	0f b6 db             	movzbl %bl,%ebx
  800a6f:	29 d8                	sub    %ebx,%eax
  800a71:	eb 05                	jmp    800a78 <memcmp+0x35>
	}

	return 0;
  800a73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a78:	5b                   	pop    %ebx
  800a79:	5e                   	pop    %esi
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a85:	89 c2                	mov    %eax,%edx
  800a87:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a8a:	39 d0                	cmp    %edx,%eax
  800a8c:	73 09                	jae    800a97 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a8e:	38 08                	cmp    %cl,(%eax)
  800a90:	74 05                	je     800a97 <memfind+0x1b>
	for (; s < ends; s++)
  800a92:	83 c0 01             	add    $0x1,%eax
  800a95:	eb f3                	jmp    800a8a <memfind+0xe>
			break;
	return (void *) s;
}
  800a97:	5d                   	pop    %ebp
  800a98:	c3                   	ret    

00800a99 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	57                   	push   %edi
  800a9d:	56                   	push   %esi
  800a9e:	53                   	push   %ebx
  800a9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aa5:	eb 03                	jmp    800aaa <strtol+0x11>
		s++;
  800aa7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800aaa:	0f b6 01             	movzbl (%ecx),%eax
  800aad:	3c 20                	cmp    $0x20,%al
  800aaf:	74 f6                	je     800aa7 <strtol+0xe>
  800ab1:	3c 09                	cmp    $0x9,%al
  800ab3:	74 f2                	je     800aa7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ab5:	3c 2b                	cmp    $0x2b,%al
  800ab7:	74 2e                	je     800ae7 <strtol+0x4e>
	int neg = 0;
  800ab9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800abe:	3c 2d                	cmp    $0x2d,%al
  800ac0:	74 2f                	je     800af1 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ac8:	75 05                	jne    800acf <strtol+0x36>
  800aca:	80 39 30             	cmpb   $0x30,(%ecx)
  800acd:	74 2c                	je     800afb <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800acf:	85 db                	test   %ebx,%ebx
  800ad1:	75 0a                	jne    800add <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ad3:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ad8:	80 39 30             	cmpb   $0x30,(%ecx)
  800adb:	74 28                	je     800b05 <strtol+0x6c>
		base = 10;
  800add:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ae5:	eb 50                	jmp    800b37 <strtol+0x9e>
		s++;
  800ae7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aea:	bf 00 00 00 00       	mov    $0x0,%edi
  800aef:	eb d1                	jmp    800ac2 <strtol+0x29>
		s++, neg = 1;
  800af1:	83 c1 01             	add    $0x1,%ecx
  800af4:	bf 01 00 00 00       	mov    $0x1,%edi
  800af9:	eb c7                	jmp    800ac2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800afb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aff:	74 0e                	je     800b0f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b01:	85 db                	test   %ebx,%ebx
  800b03:	75 d8                	jne    800add <strtol+0x44>
		s++, base = 8;
  800b05:	83 c1 01             	add    $0x1,%ecx
  800b08:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b0d:	eb ce                	jmp    800add <strtol+0x44>
		s += 2, base = 16;
  800b0f:	83 c1 02             	add    $0x2,%ecx
  800b12:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b17:	eb c4                	jmp    800add <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b19:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b1c:	89 f3                	mov    %esi,%ebx
  800b1e:	80 fb 19             	cmp    $0x19,%bl
  800b21:	77 29                	ja     800b4c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b23:	0f be d2             	movsbl %dl,%edx
  800b26:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b29:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b2c:	7d 30                	jge    800b5e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b2e:	83 c1 01             	add    $0x1,%ecx
  800b31:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b35:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b37:	0f b6 11             	movzbl (%ecx),%edx
  800b3a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b3d:	89 f3                	mov    %esi,%ebx
  800b3f:	80 fb 09             	cmp    $0x9,%bl
  800b42:	77 d5                	ja     800b19 <strtol+0x80>
			dig = *s - '0';
  800b44:	0f be d2             	movsbl %dl,%edx
  800b47:	83 ea 30             	sub    $0x30,%edx
  800b4a:	eb dd                	jmp    800b29 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b4c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b4f:	89 f3                	mov    %esi,%ebx
  800b51:	80 fb 19             	cmp    $0x19,%bl
  800b54:	77 08                	ja     800b5e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b56:	0f be d2             	movsbl %dl,%edx
  800b59:	83 ea 37             	sub    $0x37,%edx
  800b5c:	eb cb                	jmp    800b29 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b62:	74 05                	je     800b69 <strtol+0xd0>
		*endptr = (char *) s;
  800b64:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b67:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b69:	89 c2                	mov    %eax,%edx
  800b6b:	f7 da                	neg    %edx
  800b6d:	85 ff                	test   %edi,%edi
  800b6f:	0f 45 c2             	cmovne %edx,%eax
}
  800b72:	5b                   	pop    %ebx
  800b73:	5e                   	pop    %esi
  800b74:	5f                   	pop    %edi
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	57                   	push   %edi
  800b7b:	56                   	push   %esi
  800b7c:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b82:	8b 55 08             	mov    0x8(%ebp),%edx
  800b85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b88:	89 c3                	mov    %eax,%ebx
  800b8a:	89 c7                	mov    %eax,%edi
  800b8c:	89 c6                	mov    %eax,%esi
  800b8e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b90:	5b                   	pop    %ebx
  800b91:	5e                   	pop    %esi
  800b92:	5f                   	pop    %edi
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	57                   	push   %edi
  800b99:	56                   	push   %esi
  800b9a:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba5:	89 d1                	mov    %edx,%ecx
  800ba7:	89 d3                	mov    %edx,%ebx
  800ba9:	89 d7                	mov    %edx,%edi
  800bab:	89 d6                	mov    %edx,%esi
  800bad:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800baf:	5b                   	pop    %ebx
  800bb0:	5e                   	pop    %esi
  800bb1:	5f                   	pop    %edi
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
  800bba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc5:	b8 03 00 00 00       	mov    $0x3,%eax
  800bca:	89 cb                	mov    %ecx,%ebx
  800bcc:	89 cf                	mov    %ecx,%edi
  800bce:	89 ce                	mov    %ecx,%esi
  800bd0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd2:	85 c0                	test   %eax,%eax
  800bd4:	7f 08                	jg     800bde <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd9:	5b                   	pop    %ebx
  800bda:	5e                   	pop    %esi
  800bdb:	5f                   	pop    %edi
  800bdc:	5d                   	pop    %ebp
  800bdd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bde:	83 ec 0c             	sub    $0xc,%esp
  800be1:	50                   	push   %eax
  800be2:	6a 03                	push   $0x3
  800be4:	68 1f 17 80 00       	push   $0x80171f
  800be9:	6a 23                	push   $0x23
  800beb:	68 3c 17 80 00       	push   $0x80173c
  800bf0:	e8 4b f5 ff ff       	call   800140 <_panic>

00800bf5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	57                   	push   %edi
  800bf9:	56                   	push   %esi
  800bfa:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800c00:	b8 02 00 00 00       	mov    $0x2,%eax
  800c05:	89 d1                	mov    %edx,%ecx
  800c07:	89 d3                	mov    %edx,%ebx
  800c09:	89 d7                	mov    %edx,%edi
  800c0b:	89 d6                	mov    %edx,%esi
  800c0d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c0f:	5b                   	pop    %ebx
  800c10:	5e                   	pop    %esi
  800c11:	5f                   	pop    %edi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <sys_yield>:

void
sys_yield(void)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	57                   	push   %edi
  800c18:	56                   	push   %esi
  800c19:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c24:	89 d1                	mov    %edx,%ecx
  800c26:	89 d3                	mov    %edx,%ebx
  800c28:	89 d7                	mov    %edx,%edi
  800c2a:	89 d6                	mov    %edx,%esi
  800c2c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c2e:	5b                   	pop    %ebx
  800c2f:	5e                   	pop    %esi
  800c30:	5f                   	pop    %edi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c3c:	be 00 00 00 00       	mov    $0x0,%esi
  800c41:	8b 55 08             	mov    0x8(%ebp),%edx
  800c44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c47:	b8 04 00 00 00       	mov    $0x4,%eax
  800c4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c4f:	89 f7                	mov    %esi,%edi
  800c51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c53:	85 c0                	test   %eax,%eax
  800c55:	7f 08                	jg     800c5f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5a:	5b                   	pop    %ebx
  800c5b:	5e                   	pop    %esi
  800c5c:	5f                   	pop    %edi
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5f:	83 ec 0c             	sub    $0xc,%esp
  800c62:	50                   	push   %eax
  800c63:	6a 04                	push   $0x4
  800c65:	68 1f 17 80 00       	push   $0x80171f
  800c6a:	6a 23                	push   $0x23
  800c6c:	68 3c 17 80 00       	push   $0x80173c
  800c71:	e8 ca f4 ff ff       	call   800140 <_panic>

00800c76 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	57                   	push   %edi
  800c7a:	56                   	push   %esi
  800c7b:	53                   	push   %ebx
  800c7c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c85:	b8 05 00 00 00       	mov    $0x5,%eax
  800c8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c8d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c90:	8b 75 18             	mov    0x18(%ebp),%esi
  800c93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c95:	85 c0                	test   %eax,%eax
  800c97:	7f 08                	jg     800ca1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c9c:	5b                   	pop    %ebx
  800c9d:	5e                   	pop    %esi
  800c9e:	5f                   	pop    %edi
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca1:	83 ec 0c             	sub    $0xc,%esp
  800ca4:	50                   	push   %eax
  800ca5:	6a 05                	push   $0x5
  800ca7:	68 1f 17 80 00       	push   $0x80171f
  800cac:	6a 23                	push   $0x23
  800cae:	68 3c 17 80 00       	push   $0x80173c
  800cb3:	e8 88 f4 ff ff       	call   800140 <_panic>

00800cb8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	57                   	push   %edi
  800cbc:	56                   	push   %esi
  800cbd:	53                   	push   %ebx
  800cbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800cc1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccc:	b8 06 00 00 00       	mov    $0x6,%eax
  800cd1:	89 df                	mov    %ebx,%edi
  800cd3:	89 de                	mov    %ebx,%esi
  800cd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd7:	85 c0                	test   %eax,%eax
  800cd9:	7f 08                	jg     800ce3 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce3:	83 ec 0c             	sub    $0xc,%esp
  800ce6:	50                   	push   %eax
  800ce7:	6a 06                	push   $0x6
  800ce9:	68 1f 17 80 00       	push   $0x80171f
  800cee:	6a 23                	push   $0x23
  800cf0:	68 3c 17 80 00       	push   $0x80173c
  800cf5:	e8 46 f4 ff ff       	call   800140 <_panic>

00800cfa <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	57                   	push   %edi
  800cfe:	56                   	push   %esi
  800cff:	53                   	push   %ebx
  800d00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d08:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0e:	b8 08 00 00 00       	mov    $0x8,%eax
  800d13:	89 df                	mov    %ebx,%edi
  800d15:	89 de                	mov    %ebx,%esi
  800d17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d19:	85 c0                	test   %eax,%eax
  800d1b:	7f 08                	jg     800d25 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5f                   	pop    %edi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d25:	83 ec 0c             	sub    $0xc,%esp
  800d28:	50                   	push   %eax
  800d29:	6a 08                	push   $0x8
  800d2b:	68 1f 17 80 00       	push   $0x80171f
  800d30:	6a 23                	push   $0x23
  800d32:	68 3c 17 80 00       	push   $0x80173c
  800d37:	e8 04 f4 ff ff       	call   800140 <_panic>

00800d3c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	57                   	push   %edi
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
  800d42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d50:	b8 09 00 00 00       	mov    $0x9,%eax
  800d55:	89 df                	mov    %ebx,%edi
  800d57:	89 de                	mov    %ebx,%esi
  800d59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	7f 08                	jg     800d67 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d67:	83 ec 0c             	sub    $0xc,%esp
  800d6a:	50                   	push   %eax
  800d6b:	6a 09                	push   $0x9
  800d6d:	68 1f 17 80 00       	push   $0x80171f
  800d72:	6a 23                	push   $0x23
  800d74:	68 3c 17 80 00       	push   $0x80173c
  800d79:	e8 c2 f3 ff ff       	call   800140 <_panic>

00800d7e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d87:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d92:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d97:	89 df                	mov    %ebx,%edi
  800d99:	89 de                	mov    %ebx,%esi
  800d9b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9d:	85 c0                	test   %eax,%eax
  800d9f:	7f 08                	jg     800da9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da4:	5b                   	pop    %ebx
  800da5:	5e                   	pop    %esi
  800da6:	5f                   	pop    %edi
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da9:	83 ec 0c             	sub    $0xc,%esp
  800dac:	50                   	push   %eax
  800dad:	6a 0a                	push   $0xa
  800daf:	68 1f 17 80 00       	push   $0x80171f
  800db4:	6a 23                	push   $0x23
  800db6:	68 3c 17 80 00       	push   $0x80173c
  800dbb:	e8 80 f3 ff ff       	call   800140 <_panic>

00800dc0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	57                   	push   %edi
  800dc4:	56                   	push   %esi
  800dc5:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcc:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dd1:	be 00 00 00 00       	mov    $0x0,%esi
  800dd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ddc:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dde:	5b                   	pop    %ebx
  800ddf:	5e                   	pop    %esi
  800de0:	5f                   	pop    %edi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
  800de9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800dec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df1:	8b 55 08             	mov    0x8(%ebp),%edx
  800df4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800df9:	89 cb                	mov    %ecx,%ebx
  800dfb:	89 cf                	mov    %ecx,%edi
  800dfd:	89 ce                	mov    %ecx,%esi
  800dff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e01:	85 c0                	test   %eax,%eax
  800e03:	7f 08                	jg     800e0d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e08:	5b                   	pop    %ebx
  800e09:	5e                   	pop    %esi
  800e0a:	5f                   	pop    %edi
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0d:	83 ec 0c             	sub    $0xc,%esp
  800e10:	50                   	push   %eax
  800e11:	6a 0d                	push   $0xd
  800e13:	68 1f 17 80 00       	push   $0x80171f
  800e18:	6a 23                	push   $0x23
  800e1a:	68 3c 17 80 00       	push   $0x80173c
  800e1f:	e8 1c f3 ff ff       	call   800140 <_panic>

00800e24 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	53                   	push   %ebx
  800e28:	83 ec 04             	sub    $0x4,%esp
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e2e:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) { //只有因为写操作写时拷贝的地址这中情况，才可以抢救。否则一律panic
  800e30:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e34:	74 74                	je     800eaa <pgfault+0x86>
  800e36:	89 d8                	mov    %ebx,%eax
  800e38:	c1 e8 0c             	shr    $0xc,%eax
  800e3b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e42:	f6 c4 08             	test   $0x8,%ah
  800e45:	74 63                	je     800eaa <pgfault+0x86>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800e47:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, PFTEMP, PTE_U|PTE_P)) < 0)		//将当前进程PFTEMP也映射到当前进程addr指向的物理页
  800e4d:	83 ec 0c             	sub    $0xc,%esp
  800e50:	6a 05                	push   $0x5
  800e52:	68 00 f0 7f 00       	push   $0x7ff000
  800e57:	6a 00                	push   $0x0
  800e59:	53                   	push   %ebx
  800e5a:	6a 00                	push   $0x0
  800e5c:	e8 15 fe ff ff       	call   800c76 <sys_page_map>
  800e61:	83 c4 20             	add    $0x20,%esp
  800e64:	85 c0                	test   %eax,%eax
  800e66:	78 56                	js     800ebe <pgfault+0x9a>
		panic("sys_page_map: %e", r);
	if ((r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W)) < 0)	//令当前进程addr指向新分配的物理页
  800e68:	83 ec 04             	sub    $0x4,%esp
  800e6b:	6a 07                	push   $0x7
  800e6d:	53                   	push   %ebx
  800e6e:	6a 00                	push   $0x0
  800e70:	e8 be fd ff ff       	call   800c33 <sys_page_alloc>
  800e75:	83 c4 10             	add    $0x10,%esp
  800e78:	85 c0                	test   %eax,%eax
  800e7a:	78 54                	js     800ed0 <pgfault+0xac>
		panic("sys_page_alloc: %e", r);
	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800e7c:	83 ec 04             	sub    $0x4,%esp
  800e7f:	68 00 10 00 00       	push   $0x1000
  800e84:	68 00 f0 7f 00       	push   $0x7ff000
  800e89:	53                   	push   %ebx
  800e8a:	e8 39 fb ff ff       	call   8009c8 <memmove>
	if ((r = sys_page_unmap(0, PFTEMP)) < 0)					//解除当前进程PFTEMP映射
  800e8f:	83 c4 08             	add    $0x8,%esp
  800e92:	68 00 f0 7f 00       	push   $0x7ff000
  800e97:	6a 00                	push   $0x0
  800e99:	e8 1a fe ff ff       	call   800cb8 <sys_page_unmap>
  800e9e:	83 c4 10             	add    $0x10,%esp
  800ea1:	85 c0                	test   %eax,%eax
  800ea3:	78 3d                	js     800ee2 <pgfault+0xbe>
		panic("sys_page_unmap: %e", r);
}
  800ea5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    
		panic("pgfault():not cow");
  800eaa:	83 ec 04             	sub    $0x4,%esp
  800ead:	68 4a 17 80 00       	push   $0x80174a
  800eb2:	6a 1d                	push   $0x1d
  800eb4:	68 5c 17 80 00       	push   $0x80175c
  800eb9:	e8 82 f2 ff ff       	call   800140 <_panic>
		panic("sys_page_map: %e", r);
  800ebe:	50                   	push   %eax
  800ebf:	68 67 17 80 00       	push   $0x801767
  800ec4:	6a 2a                	push   $0x2a
  800ec6:	68 5c 17 80 00       	push   $0x80175c
  800ecb:	e8 70 f2 ff ff       	call   800140 <_panic>
		panic("sys_page_alloc: %e", r);
  800ed0:	50                   	push   %eax
  800ed1:	68 78 17 80 00       	push   $0x801778
  800ed6:	6a 2c                	push   $0x2c
  800ed8:	68 5c 17 80 00       	push   $0x80175c
  800edd:	e8 5e f2 ff ff       	call   800140 <_panic>
		panic("sys_page_unmap: %e", r);
  800ee2:	50                   	push   %eax
  800ee3:	68 8b 17 80 00       	push   $0x80178b
  800ee8:	6a 2f                	push   $0x2f
  800eea:	68 5c 17 80 00       	push   $0x80175c
  800eef:	e8 4c f2 ff ff       	call   800140 <_panic>

00800ef4 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	57                   	push   %edi
  800ef8:	56                   	push   %esi
  800ef9:	53                   	push   %ebx
  800efa:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);	//设置缺页处理函数
  800efd:	68 24 0e 80 00       	push   $0x800e24
  800f02:	e8 d9 01 00 00       	call   8010e0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f07:	b8 07 00 00 00       	mov    $0x7,%eax
  800f0c:	cd 30                	int    $0x30
  800f0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();	//系统调用，只是简单创建一个Env结构，复制当前用户环境寄存器状态，UTOP以下的页目录还没有建立
	if (envid == 0) {				//子进程将走这个逻辑
  800f11:	83 c4 10             	add    $0x10,%esp
  800f14:	85 c0                	test   %eax,%eax
  800f16:	74 12                	je     800f2a <fork+0x36>
  800f18:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	if (envid < 0) {
  800f1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1e:	78 26                	js     800f46 <fork+0x52>
		panic("sys_exofork: %e", envid);
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f25:	e9 94 00 00 00       	jmp    800fbe <fork+0xca>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f2a:	e8 c6 fc ff ff       	call   800bf5 <sys_getenvid>
  800f2f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f34:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f37:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f3c:	a3 08 20 80 00       	mov    %eax,0x802008
		return 0;
  800f41:	e9 51 01 00 00       	jmp    801097 <fork+0x1a3>
		panic("sys_exofork: %e", envid);
  800f46:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f49:	68 9e 17 80 00       	push   $0x80179e
  800f4e:	6a 6d                	push   $0x6d
  800f50:	68 5c 17 80 00       	push   $0x80175c
  800f55:	e8 e6 f1 ff ff       	call   800140 <_panic>
		sys_page_map(0, addr, envid, addr, PTE_SYSCALL);		//对于表示为PTE_SHARE的页，拷贝映射关系，并且两个进程都有读写权限
  800f5a:	83 ec 0c             	sub    $0xc,%esp
  800f5d:	68 07 0e 00 00       	push   $0xe07
  800f62:	56                   	push   %esi
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	6a 00                	push   $0x0
  800f67:	e8 0a fd ff ff       	call   800c76 <sys_page_map>
  800f6c:	83 c4 20             	add    $0x20,%esp
  800f6f:	eb 3b                	jmp    800fac <fork+0xb8>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  800f71:	83 ec 0c             	sub    $0xc,%esp
  800f74:	68 05 08 00 00       	push   $0x805
  800f79:	56                   	push   %esi
  800f7a:	57                   	push   %edi
  800f7b:	56                   	push   %esi
  800f7c:	6a 00                	push   $0x0
  800f7e:	e8 f3 fc ff ff       	call   800c76 <sys_page_map>
  800f83:	83 c4 20             	add    $0x20,%esp
  800f86:	85 c0                	test   %eax,%eax
  800f88:	0f 88 a9 00 00 00    	js     801037 <fork+0x143>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  800f8e:	83 ec 0c             	sub    $0xc,%esp
  800f91:	68 05 08 00 00       	push   $0x805
  800f96:	56                   	push   %esi
  800f97:	6a 00                	push   $0x0
  800f99:	56                   	push   %esi
  800f9a:	6a 00                	push   $0x0
  800f9c:	e8 d5 fc ff ff       	call   800c76 <sys_page_map>
  800fa1:	83 c4 20             	add    $0x20,%esp
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	0f 88 9d 00 00 00    	js     801049 <fork+0x155>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fac:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fb2:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800fb8:	0f 84 9d 00 00 00    	je     80105b <fork+0x167>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) //为什么uvpt[pagenumber]能访问到第pagenumber项页表条目：https://pdos.csail.mit.edu/6.828/2018/labs/lab4/uvpt.html
  800fbe:	89 d8                	mov    %ebx,%eax
  800fc0:	c1 e8 16             	shr    $0x16,%eax
  800fc3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fca:	a8 01                	test   $0x1,%al
  800fcc:	74 de                	je     800fac <fork+0xb8>
  800fce:	89 d8                	mov    %ebx,%eax
  800fd0:	c1 e8 0c             	shr    $0xc,%eax
  800fd3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fda:	f6 c2 01             	test   $0x1,%dl
  800fdd:	74 cd                	je     800fac <fork+0xb8>
			&& (uvpt[PGNUM(addr)] & PTE_U)) {
  800fdf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fe6:	f6 c2 04             	test   $0x4,%dl
  800fe9:	74 c1                	je     800fac <fork+0xb8>
	void *addr = (void*) (pn * PGSIZE);
  800feb:	89 c6                	mov    %eax,%esi
  800fed:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE) {
  800ff0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ff7:	f6 c6 04             	test   $0x4,%dh
  800ffa:	0f 85 5a ff ff ff    	jne    800f5a <fork+0x66>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) { //对于UTOP以下的可写的或者写时拷贝的页，拷贝映射关系的同时，需要同时标记当前进程和子进程的页表项为PTE_COW
  801000:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801007:	f6 c2 02             	test   $0x2,%dl
  80100a:	0f 85 61 ff ff ff    	jne    800f71 <fork+0x7d>
  801010:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801017:	f6 c4 08             	test   $0x8,%ah
  80101a:	0f 85 51 ff ff ff    	jne    800f71 <fork+0x7d>
		sys_page_map(0, addr, envid, addr, PTE_U|PTE_P);	//对于只读的页，只需要拷贝映射关系即可
  801020:	83 ec 0c             	sub    $0xc,%esp
  801023:	6a 05                	push   $0x5
  801025:	56                   	push   %esi
  801026:	57                   	push   %edi
  801027:	56                   	push   %esi
  801028:	6a 00                	push   $0x0
  80102a:	e8 47 fc ff ff       	call   800c76 <sys_page_map>
  80102f:	83 c4 20             	add    $0x20,%esp
  801032:	e9 75 ff ff ff       	jmp    800fac <fork+0xb8>
			panic("sys_page_map：%e", r);
  801037:	50                   	push   %eax
  801038:	68 ae 17 80 00       	push   $0x8017ae
  80103d:	6a 48                	push   $0x48
  80103f:	68 5c 17 80 00       	push   $0x80175c
  801044:	e8 f7 f0 ff ff       	call   800140 <_panic>
			panic("sys_page_map：%e", r);
  801049:	50                   	push   %eax
  80104a:	68 ae 17 80 00       	push   $0x8017ae
  80104f:	6a 4a                	push   $0x4a
  801051:	68 5c 17 80 00       	push   $0x80175c
  801056:	e8 e5 f0 ff ff       	call   800140 <_panic>
			duppage(envid, PGNUM(addr));	//拷贝当前进程映射关系到子进程
		}
	}
	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_W | PTE_U)) < 0)	//为子进程分配异常栈
  80105b:	83 ec 04             	sub    $0x4,%esp
  80105e:	6a 07                	push   $0x7
  801060:	68 00 f0 bf ee       	push   $0xeebff000
  801065:	ff 75 e4             	pushl  -0x1c(%ebp)
  801068:	e8 c6 fb ff ff       	call   800c33 <sys_page_alloc>
  80106d:	83 c4 10             	add    $0x10,%esp
  801070:	85 c0                	test   %eax,%eax
  801072:	78 2e                	js     8010a2 <fork+0x1ae>
		panic("sys_page_alloc: %e", r);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);		//为子进程设置_pgfault_upcall
  801074:	83 ec 08             	sub    $0x8,%esp
  801077:	68 39 11 80 00       	push   $0x801139
  80107c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80107f:	57                   	push   %edi
  801080:	e8 f9 fc ff ff       	call   800d7e <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)	//设置子进程为ENV_RUNNABLE状态
  801085:	83 c4 08             	add    $0x8,%esp
  801088:	6a 02                	push   $0x2
  80108a:	57                   	push   %edi
  80108b:	e8 6a fc ff ff       	call   800cfa <sys_env_set_status>
  801090:	83 c4 10             	add    $0x10,%esp
  801093:	85 c0                	test   %eax,%eax
  801095:	78 1d                	js     8010b4 <fork+0x1c0>
		panic("sys_env_set_status: %e", r);
	return envid;
}
  801097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80109a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109d:	5b                   	pop    %ebx
  80109e:	5e                   	pop    %esi
  80109f:	5f                   	pop    %edi
  8010a0:	5d                   	pop    %ebp
  8010a1:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8010a2:	50                   	push   %eax
  8010a3:	68 78 17 80 00       	push   $0x801778
  8010a8:	6a 79                	push   $0x79
  8010aa:	68 5c 17 80 00       	push   $0x80175c
  8010af:	e8 8c f0 ff ff       	call   800140 <_panic>
		panic("sys_env_set_status: %e", r);
  8010b4:	50                   	push   %eax
  8010b5:	68 c0 17 80 00       	push   $0x8017c0
  8010ba:	6a 7d                	push   $0x7d
  8010bc:	68 5c 17 80 00       	push   $0x80175c
  8010c1:	e8 7a f0 ff ff       	call   800140 <_panic>

008010c6 <sfork>:

// Challenge!
int
sfork(void)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8010cc:	68 d7 17 80 00       	push   $0x8017d7
  8010d1:	68 85 00 00 00       	push   $0x85
  8010d6:	68 5c 17 80 00       	push   $0x80175c
  8010db:	e8 60 f0 ff ff       	call   800140 <_panic>

008010e0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8010e6:	83 3d 0c 20 80 00 00 	cmpl   $0x0,0x80200c
  8010ed:	74 0a                	je     8010f9 <set_pgfault_handler+0x19>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	a3 0c 20 80 00       	mov    %eax,0x80200c
}
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    
		int r = sys_page_alloc(0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P);	//为当前进程分配异常栈
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	6a 07                	push   $0x7
  8010fe:	68 00 f0 bf ee       	push   $0xeebff000
  801103:	6a 00                	push   $0x0
  801105:	e8 29 fb ff ff       	call   800c33 <sys_page_alloc>
		if (r < 0) {
  80110a:	83 c4 10             	add    $0x10,%esp
  80110d:	85 c0                	test   %eax,%eax
  80110f:	78 14                	js     801125 <set_pgfault_handler+0x45>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
  801111:	83 ec 08             	sub    $0x8,%esp
  801114:	68 39 11 80 00       	push   $0x801139
  801119:	6a 00                	push   $0x0
  80111b:	e8 5e fc ff ff       	call   800d7e <sys_env_set_pgfault_upcall>
  801120:	83 c4 10             	add    $0x10,%esp
  801123:	eb ca                	jmp    8010ef <set_pgfault_handler+0xf>
			panic("set_pgfault_handler:sys_page_alloc failed");;
  801125:	83 ec 04             	sub    $0x4,%esp
  801128:	68 f0 17 80 00       	push   $0x8017f0
  80112d:	6a 22                	push   $0x22
  80112f:	68 1c 18 80 00       	push   $0x80181c
  801134:	e8 07 f0 ff ff       	call   800140 <_panic>

00801139 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801139:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80113a:	a1 0c 20 80 00       	mov    0x80200c,%eax
	call *%eax				//调用页处理函数
  80113f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801141:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp			//跳过utf_fault_va和utf_err
  801144:	83 c4 08             	add    $0x8,%esp
	movl 40(%esp), %eax 	//保存中断发生时的esp到eax
  801147:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl 32(%esp), %ecx 	//保存终端发生时的eip到ecx
  80114b:	8b 4c 24 20          	mov    0x20(%esp),%ecx
	movl %ecx, -4(%eax) 	//将中断发生时的esp值亚入到到原来的栈中
  80114f:	89 48 fc             	mov    %ecx,-0x4(%eax)
	popal
  801152:	61                   	popa   
	addl $4, %esp			//跳过eip
  801153:	83 c4 04             	add    $0x4,%esp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801156:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801157:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	lea -4(%esp), %esp		//因为之前压入了eip的值但是没有减esp的值，所以现在需要将esp寄存器中的值减4
  801158:	8d 64 24 fc          	lea    -0x4(%esp),%esp
  80115c:	c3                   	ret    
  80115d:	66 90                	xchg   %ax,%ax
  80115f:	90                   	nop

00801160 <__udivdi3>:
  801160:	55                   	push   %ebp
  801161:	57                   	push   %edi
  801162:	56                   	push   %esi
  801163:	53                   	push   %ebx
  801164:	83 ec 1c             	sub    $0x1c,%esp
  801167:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80116b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80116f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801173:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801177:	85 d2                	test   %edx,%edx
  801179:	75 35                	jne    8011b0 <__udivdi3+0x50>
  80117b:	39 f3                	cmp    %esi,%ebx
  80117d:	0f 87 bd 00 00 00    	ja     801240 <__udivdi3+0xe0>
  801183:	85 db                	test   %ebx,%ebx
  801185:	89 d9                	mov    %ebx,%ecx
  801187:	75 0b                	jne    801194 <__udivdi3+0x34>
  801189:	b8 01 00 00 00       	mov    $0x1,%eax
  80118e:	31 d2                	xor    %edx,%edx
  801190:	f7 f3                	div    %ebx
  801192:	89 c1                	mov    %eax,%ecx
  801194:	31 d2                	xor    %edx,%edx
  801196:	89 f0                	mov    %esi,%eax
  801198:	f7 f1                	div    %ecx
  80119a:	89 c6                	mov    %eax,%esi
  80119c:	89 e8                	mov    %ebp,%eax
  80119e:	89 f7                	mov    %esi,%edi
  8011a0:	f7 f1                	div    %ecx
  8011a2:	89 fa                	mov    %edi,%edx
  8011a4:	83 c4 1c             	add    $0x1c,%esp
  8011a7:	5b                   	pop    %ebx
  8011a8:	5e                   	pop    %esi
  8011a9:	5f                   	pop    %edi
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    
  8011ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8011b0:	39 f2                	cmp    %esi,%edx
  8011b2:	77 7c                	ja     801230 <__udivdi3+0xd0>
  8011b4:	0f bd fa             	bsr    %edx,%edi
  8011b7:	83 f7 1f             	xor    $0x1f,%edi
  8011ba:	0f 84 98 00 00 00    	je     801258 <__udivdi3+0xf8>
  8011c0:	89 f9                	mov    %edi,%ecx
  8011c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8011c7:	29 f8                	sub    %edi,%eax
  8011c9:	d3 e2                	shl    %cl,%edx
  8011cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8011cf:	89 c1                	mov    %eax,%ecx
  8011d1:	89 da                	mov    %ebx,%edx
  8011d3:	d3 ea                	shr    %cl,%edx
  8011d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8011d9:	09 d1                	or     %edx,%ecx
  8011db:	89 f2                	mov    %esi,%edx
  8011dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011e1:	89 f9                	mov    %edi,%ecx
  8011e3:	d3 e3                	shl    %cl,%ebx
  8011e5:	89 c1                	mov    %eax,%ecx
  8011e7:	d3 ea                	shr    %cl,%edx
  8011e9:	89 f9                	mov    %edi,%ecx
  8011eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011ef:	d3 e6                	shl    %cl,%esi
  8011f1:	89 eb                	mov    %ebp,%ebx
  8011f3:	89 c1                	mov    %eax,%ecx
  8011f5:	d3 eb                	shr    %cl,%ebx
  8011f7:	09 de                	or     %ebx,%esi
  8011f9:	89 f0                	mov    %esi,%eax
  8011fb:	f7 74 24 08          	divl   0x8(%esp)
  8011ff:	89 d6                	mov    %edx,%esi
  801201:	89 c3                	mov    %eax,%ebx
  801203:	f7 64 24 0c          	mull   0xc(%esp)
  801207:	39 d6                	cmp    %edx,%esi
  801209:	72 0c                	jb     801217 <__udivdi3+0xb7>
  80120b:	89 f9                	mov    %edi,%ecx
  80120d:	d3 e5                	shl    %cl,%ebp
  80120f:	39 c5                	cmp    %eax,%ebp
  801211:	73 5d                	jae    801270 <__udivdi3+0x110>
  801213:	39 d6                	cmp    %edx,%esi
  801215:	75 59                	jne    801270 <__udivdi3+0x110>
  801217:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80121a:	31 ff                	xor    %edi,%edi
  80121c:	89 fa                	mov    %edi,%edx
  80121e:	83 c4 1c             	add    $0x1c,%esp
  801221:	5b                   	pop    %ebx
  801222:	5e                   	pop    %esi
  801223:	5f                   	pop    %edi
  801224:	5d                   	pop    %ebp
  801225:	c3                   	ret    
  801226:	8d 76 00             	lea    0x0(%esi),%esi
  801229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801230:	31 ff                	xor    %edi,%edi
  801232:	31 c0                	xor    %eax,%eax
  801234:	89 fa                	mov    %edi,%edx
  801236:	83 c4 1c             	add    $0x1c,%esp
  801239:	5b                   	pop    %ebx
  80123a:	5e                   	pop    %esi
  80123b:	5f                   	pop    %edi
  80123c:	5d                   	pop    %ebp
  80123d:	c3                   	ret    
  80123e:	66 90                	xchg   %ax,%ax
  801240:	31 ff                	xor    %edi,%edi
  801242:	89 e8                	mov    %ebp,%eax
  801244:	89 f2                	mov    %esi,%edx
  801246:	f7 f3                	div    %ebx
  801248:	89 fa                	mov    %edi,%edx
  80124a:	83 c4 1c             	add    $0x1c,%esp
  80124d:	5b                   	pop    %ebx
  80124e:	5e                   	pop    %esi
  80124f:	5f                   	pop    %edi
  801250:	5d                   	pop    %ebp
  801251:	c3                   	ret    
  801252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801258:	39 f2                	cmp    %esi,%edx
  80125a:	72 06                	jb     801262 <__udivdi3+0x102>
  80125c:	31 c0                	xor    %eax,%eax
  80125e:	39 eb                	cmp    %ebp,%ebx
  801260:	77 d2                	ja     801234 <__udivdi3+0xd4>
  801262:	b8 01 00 00 00       	mov    $0x1,%eax
  801267:	eb cb                	jmp    801234 <__udivdi3+0xd4>
  801269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801270:	89 d8                	mov    %ebx,%eax
  801272:	31 ff                	xor    %edi,%edi
  801274:	eb be                	jmp    801234 <__udivdi3+0xd4>
  801276:	66 90                	xchg   %ax,%ax
  801278:	66 90                	xchg   %ax,%ax
  80127a:	66 90                	xchg   %ax,%ax
  80127c:	66 90                	xchg   %ax,%ax
  80127e:	66 90                	xchg   %ax,%ax

00801280 <__umoddi3>:
  801280:	55                   	push   %ebp
  801281:	57                   	push   %edi
  801282:	56                   	push   %esi
  801283:	53                   	push   %ebx
  801284:	83 ec 1c             	sub    $0x1c,%esp
  801287:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80128b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80128f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801293:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801297:	85 ed                	test   %ebp,%ebp
  801299:	89 f0                	mov    %esi,%eax
  80129b:	89 da                	mov    %ebx,%edx
  80129d:	75 19                	jne    8012b8 <__umoddi3+0x38>
  80129f:	39 df                	cmp    %ebx,%edi
  8012a1:	0f 86 b1 00 00 00    	jbe    801358 <__umoddi3+0xd8>
  8012a7:	f7 f7                	div    %edi
  8012a9:	89 d0                	mov    %edx,%eax
  8012ab:	31 d2                	xor    %edx,%edx
  8012ad:	83 c4 1c             	add    $0x1c,%esp
  8012b0:	5b                   	pop    %ebx
  8012b1:	5e                   	pop    %esi
  8012b2:	5f                   	pop    %edi
  8012b3:	5d                   	pop    %ebp
  8012b4:	c3                   	ret    
  8012b5:	8d 76 00             	lea    0x0(%esi),%esi
  8012b8:	39 dd                	cmp    %ebx,%ebp
  8012ba:	77 f1                	ja     8012ad <__umoddi3+0x2d>
  8012bc:	0f bd cd             	bsr    %ebp,%ecx
  8012bf:	83 f1 1f             	xor    $0x1f,%ecx
  8012c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8012c6:	0f 84 b4 00 00 00    	je     801380 <__umoddi3+0x100>
  8012cc:	b8 20 00 00 00       	mov    $0x20,%eax
  8012d1:	89 c2                	mov    %eax,%edx
  8012d3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8012d7:	29 c2                	sub    %eax,%edx
  8012d9:	89 c1                	mov    %eax,%ecx
  8012db:	89 f8                	mov    %edi,%eax
  8012dd:	d3 e5                	shl    %cl,%ebp
  8012df:	89 d1                	mov    %edx,%ecx
  8012e1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8012e5:	d3 e8                	shr    %cl,%eax
  8012e7:	09 c5                	or     %eax,%ebp
  8012e9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8012ed:	89 c1                	mov    %eax,%ecx
  8012ef:	d3 e7                	shl    %cl,%edi
  8012f1:	89 d1                	mov    %edx,%ecx
  8012f3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012f7:	89 df                	mov    %ebx,%edi
  8012f9:	d3 ef                	shr    %cl,%edi
  8012fb:	89 c1                	mov    %eax,%ecx
  8012fd:	89 f0                	mov    %esi,%eax
  8012ff:	d3 e3                	shl    %cl,%ebx
  801301:	89 d1                	mov    %edx,%ecx
  801303:	89 fa                	mov    %edi,%edx
  801305:	d3 e8                	shr    %cl,%eax
  801307:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80130c:	09 d8                	or     %ebx,%eax
  80130e:	f7 f5                	div    %ebp
  801310:	d3 e6                	shl    %cl,%esi
  801312:	89 d1                	mov    %edx,%ecx
  801314:	f7 64 24 08          	mull   0x8(%esp)
  801318:	39 d1                	cmp    %edx,%ecx
  80131a:	89 c3                	mov    %eax,%ebx
  80131c:	89 d7                	mov    %edx,%edi
  80131e:	72 06                	jb     801326 <__umoddi3+0xa6>
  801320:	75 0e                	jne    801330 <__umoddi3+0xb0>
  801322:	39 c6                	cmp    %eax,%esi
  801324:	73 0a                	jae    801330 <__umoddi3+0xb0>
  801326:	2b 44 24 08          	sub    0x8(%esp),%eax
  80132a:	19 ea                	sbb    %ebp,%edx
  80132c:	89 d7                	mov    %edx,%edi
  80132e:	89 c3                	mov    %eax,%ebx
  801330:	89 ca                	mov    %ecx,%edx
  801332:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801337:	29 de                	sub    %ebx,%esi
  801339:	19 fa                	sbb    %edi,%edx
  80133b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80133f:	89 d0                	mov    %edx,%eax
  801341:	d3 e0                	shl    %cl,%eax
  801343:	89 d9                	mov    %ebx,%ecx
  801345:	d3 ee                	shr    %cl,%esi
  801347:	d3 ea                	shr    %cl,%edx
  801349:	09 f0                	or     %esi,%eax
  80134b:	83 c4 1c             	add    $0x1c,%esp
  80134e:	5b                   	pop    %ebx
  80134f:	5e                   	pop    %esi
  801350:	5f                   	pop    %edi
  801351:	5d                   	pop    %ebp
  801352:	c3                   	ret    
  801353:	90                   	nop
  801354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801358:	85 ff                	test   %edi,%edi
  80135a:	89 f9                	mov    %edi,%ecx
  80135c:	75 0b                	jne    801369 <__umoddi3+0xe9>
  80135e:	b8 01 00 00 00       	mov    $0x1,%eax
  801363:	31 d2                	xor    %edx,%edx
  801365:	f7 f7                	div    %edi
  801367:	89 c1                	mov    %eax,%ecx
  801369:	89 d8                	mov    %ebx,%eax
  80136b:	31 d2                	xor    %edx,%edx
  80136d:	f7 f1                	div    %ecx
  80136f:	89 f0                	mov    %esi,%eax
  801371:	f7 f1                	div    %ecx
  801373:	e9 31 ff ff ff       	jmp    8012a9 <__umoddi3+0x29>
  801378:	90                   	nop
  801379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801380:	39 dd                	cmp    %ebx,%ebp
  801382:	72 08                	jb     80138c <__umoddi3+0x10c>
  801384:	39 f7                	cmp    %esi,%edi
  801386:	0f 87 21 ff ff ff    	ja     8012ad <__umoddi3+0x2d>
  80138c:	89 da                	mov    %ebx,%edx
  80138e:	89 f0                	mov    %esi,%eax
  801390:	29 f8                	sub    %edi,%eax
  801392:	19 ea                	sbb    %ebp,%edx
  801394:	e9 14 ff ff ff       	jmp    8012ad <__umoddi3+0x2d>
