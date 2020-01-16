
obj/user/primes.debug：     文件格式 elf32-i386


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
  80002c:	e8 c7 00 00 00       	call   8000f8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	83 ec 04             	sub    $0x4,%esp
  800042:	6a 00                	push   $0x0
  800044:	6a 00                	push   $0x0
  800046:	56                   	push   %esi
  800047:	e8 a4 10 00 00       	call   8010f0 <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 04 20 80 00       	mov    0x802004,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 c0 14 80 00       	push   $0x8014c0
  800060:	e8 c6 01 00 00       	call   80022b <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 9a 0e 00 00       	call   800f04 <fork>
  80006a:	89 c7                	mov    %eax,%edi
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	85 c0                	test   %eax,%eax
  800071:	78 30                	js     8000a3 <primeproc+0x70>
		panic("fork: %e", id);
	if (id == 0)
  800073:	85 c0                	test   %eax,%eax
  800075:	74 c8                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800077:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	6a 00                	push   $0x0
  80007f:	6a 00                	push   $0x0
  800081:	56                   	push   %esi
  800082:	e8 69 10 00 00       	call   8010f0 <ipc_recv>
  800087:	89 c1                	mov    %eax,%ecx
		if (i % p)
  800089:	99                   	cltd   
  80008a:	f7 fb                	idiv   %ebx
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	85 d2                	test   %edx,%edx
  800091:	74 e7                	je     80007a <primeproc+0x47>
			ipc_send(id, i, 0, 0);
  800093:	6a 00                	push   $0x0
  800095:	6a 00                	push   $0x0
  800097:	51                   	push   %ecx
  800098:	57                   	push   %edi
  800099:	e8 bb 10 00 00       	call   801159 <ipc_send>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	eb d7                	jmp    80007a <primeproc+0x47>
		panic("fork: %e", id);
  8000a3:	50                   	push   %eax
  8000a4:	68 85 18 80 00       	push   $0x801885
  8000a9:	6a 1a                	push   $0x1a
  8000ab:	68 cc 14 80 00       	push   $0x8014cc
  8000b0:	e8 9b 00 00 00       	call   800150 <_panic>

008000b5 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ba:	e8 45 0e 00 00       	call   800f04 <fork>
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	78 1c                	js     8000e1 <umain+0x2c>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000c5:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	74 25                	je     8000f3 <umain+0x3e>
		ipc_send(id, i, 0, 0);
  8000ce:	6a 00                	push   $0x0
  8000d0:	6a 00                	push   $0x0
  8000d2:	53                   	push   %ebx
  8000d3:	56                   	push   %esi
  8000d4:	e8 80 10 00 00       	call   801159 <ipc_send>
	for (i = 2; ; i++)
  8000d9:	83 c3 01             	add    $0x1,%ebx
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	eb ed                	jmp    8000ce <umain+0x19>
		panic("fork: %e", id);
  8000e1:	50                   	push   %eax
  8000e2:	68 85 18 80 00       	push   $0x801885
  8000e7:	6a 2d                	push   $0x2d
  8000e9:	68 cc 14 80 00       	push   $0x8014cc
  8000ee:	e8 5d 00 00 00       	call   800150 <_panic>
		primeproc();
  8000f3:	e8 3b ff ff ff       	call   800033 <primeproc>

008000f8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800100:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  800103:	e8 fd 0a 00 00       	call   800c05 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  800108:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800110:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800115:	a3 04 20 80 00       	mov    %eax,0x802004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011a:	85 db                	test   %ebx,%ebx
  80011c:	7e 07                	jle    800125 <libmain+0x2d>
		binaryname = argv[0];
  80011e:	8b 06                	mov    (%esi),%eax
  800120:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800125:	83 ec 08             	sub    $0x8,%esp
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	e8 86 ff ff ff       	call   8000b5 <umain>

	// exit gracefully
	exit();
  80012f:	e8 0a 00 00 00       	call   80013e <exit>
}
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5d                   	pop    %ebp
  80013d:	c3                   	ret    

0080013e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800144:	6a 00                	push   $0x0
  800146:	e8 79 0a 00 00       	call   800bc4 <sys_env_destroy>
}
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	c9                   	leave  
  80014f:	c3                   	ret    

00800150 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	56                   	push   %esi
  800154:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800155:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800158:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80015e:	e8 a2 0a 00 00       	call   800c05 <sys_getenvid>
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 0c             	pushl  0xc(%ebp)
  800169:	ff 75 08             	pushl  0x8(%ebp)
  80016c:	56                   	push   %esi
  80016d:	50                   	push   %eax
  80016e:	68 e4 14 80 00       	push   $0x8014e4
  800173:	e8 b3 00 00 00       	call   80022b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800178:	83 c4 18             	add    $0x18,%esp
  80017b:	53                   	push   %ebx
  80017c:	ff 75 10             	pushl  0x10(%ebp)
  80017f:	e8 56 00 00 00       	call   8001da <vcprintf>
	cprintf("\n");
  800184:	c7 04 24 07 15 80 00 	movl   $0x801507,(%esp)
  80018b:	e8 9b 00 00 00       	call   80022b <cprintf>
  800190:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800193:	cc                   	int3   
  800194:	eb fd                	jmp    800193 <_panic+0x43>

00800196 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	53                   	push   %ebx
  80019a:	83 ec 04             	sub    $0x4,%esp
  80019d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a0:	8b 13                	mov    (%ebx),%edx
  8001a2:	8d 42 01             	lea    0x1(%edx),%eax
  8001a5:	89 03                	mov    %eax,(%ebx)
  8001a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001aa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b3:	74 09                	je     8001be <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	68 ff 00 00 00       	push   $0xff
  8001c6:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c9:	50                   	push   %eax
  8001ca:	e8 b8 09 00 00       	call   800b87 <sys_cputs>
		b->idx = 0;
  8001cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	eb db                	jmp    8001b5 <putch+0x1f>

008001da <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ea:	00 00 00 
	b.cnt = 0;
  8001ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f7:	ff 75 0c             	pushl  0xc(%ebp)
  8001fa:	ff 75 08             	pushl  0x8(%ebp)
  8001fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800203:	50                   	push   %eax
  800204:	68 96 01 80 00       	push   $0x800196
  800209:	e8 1a 01 00 00       	call   800328 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80020e:	83 c4 08             	add    $0x8,%esp
  800211:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800217:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80021d:	50                   	push   %eax
  80021e:	e8 64 09 00 00       	call   800b87 <sys_cputs>

	return b.cnt;
}
  800223:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800231:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800234:	50                   	push   %eax
  800235:	ff 75 08             	pushl  0x8(%ebp)
  800238:	e8 9d ff ff ff       	call   8001da <vcprintf>
	va_end(ap);

	return cnt;
}
  80023d:	c9                   	leave  
  80023e:	c3                   	ret    

0080023f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	57                   	push   %edi
  800243:	56                   	push   %esi
  800244:	53                   	push   %ebx
  800245:	83 ec 1c             	sub    $0x1c,%esp
  800248:	89 c7                	mov    %eax,%edi
  80024a:	89 d6                	mov    %edx,%esi
  80024c:	8b 45 08             	mov    0x8(%ebp),%eax
  80024f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800252:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800255:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800258:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80025b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800260:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800263:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800266:	39 d3                	cmp    %edx,%ebx
  800268:	72 05                	jb     80026f <printnum+0x30>
  80026a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80026d:	77 7a                	ja     8002e9 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	ff 75 18             	pushl  0x18(%ebp)
  800275:	8b 45 14             	mov    0x14(%ebp),%eax
  800278:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80027b:	53                   	push   %ebx
  80027c:	ff 75 10             	pushl  0x10(%ebp)
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	ff 75 e4             	pushl  -0x1c(%ebp)
  800285:	ff 75 e0             	pushl  -0x20(%ebp)
  800288:	ff 75 dc             	pushl  -0x24(%ebp)
  80028b:	ff 75 d8             	pushl  -0x28(%ebp)
  80028e:	e8 dd 0f 00 00       	call   801270 <__udivdi3>
  800293:	83 c4 18             	add    $0x18,%esp
  800296:	52                   	push   %edx
  800297:	50                   	push   %eax
  800298:	89 f2                	mov    %esi,%edx
  80029a:	89 f8                	mov    %edi,%eax
  80029c:	e8 9e ff ff ff       	call   80023f <printnum>
  8002a1:	83 c4 20             	add    $0x20,%esp
  8002a4:	eb 13                	jmp    8002b9 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a6:	83 ec 08             	sub    $0x8,%esp
  8002a9:	56                   	push   %esi
  8002aa:	ff 75 18             	pushl  0x18(%ebp)
  8002ad:	ff d7                	call   *%edi
  8002af:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002b2:	83 eb 01             	sub    $0x1,%ebx
  8002b5:	85 db                	test   %ebx,%ebx
  8002b7:	7f ed                	jg     8002a6 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b9:	83 ec 08             	sub    $0x8,%esp
  8002bc:	56                   	push   %esi
  8002bd:	83 ec 04             	sub    $0x4,%esp
  8002c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002cc:	e8 bf 10 00 00       	call   801390 <__umoddi3>
  8002d1:	83 c4 14             	add    $0x14,%esp
  8002d4:	0f be 80 09 15 80 00 	movsbl 0x801509(%eax),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff d7                	call   *%edi
}
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e4:	5b                   	pop    %ebx
  8002e5:	5e                   	pop    %esi
  8002e6:	5f                   	pop    %edi
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    
  8002e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002ec:	eb c4                	jmp    8002b2 <printnum+0x73>

008002ee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f8:	8b 10                	mov    (%eax),%edx
  8002fa:	3b 50 04             	cmp    0x4(%eax),%edx
  8002fd:	73 0a                	jae    800309 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800302:	89 08                	mov    %ecx,(%eax)
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	88 02                	mov    %al,(%edx)
}
  800309:	5d                   	pop    %ebp
  80030a:	c3                   	ret    

0080030b <printfmt>:
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800311:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800314:	50                   	push   %eax
  800315:	ff 75 10             	pushl  0x10(%ebp)
  800318:	ff 75 0c             	pushl  0xc(%ebp)
  80031b:	ff 75 08             	pushl  0x8(%ebp)
  80031e:	e8 05 00 00 00       	call   800328 <vprintfmt>
}
  800323:	83 c4 10             	add    $0x10,%esp
  800326:	c9                   	leave  
  800327:	c3                   	ret    

00800328 <vprintfmt>:
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	57                   	push   %edi
  80032c:	56                   	push   %esi
  80032d:	53                   	push   %ebx
  80032e:	83 ec 2c             	sub    $0x2c,%esp
  800331:	8b 75 08             	mov    0x8(%ebp),%esi
  800334:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800337:	8b 7d 10             	mov    0x10(%ebp),%edi
  80033a:	e9 c1 03 00 00       	jmp    800700 <vprintfmt+0x3d8>
		padc = ' ';
  80033f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800343:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80034a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800351:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800358:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035d:	8d 47 01             	lea    0x1(%edi),%eax
  800360:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800363:	0f b6 17             	movzbl (%edi),%edx
  800366:	8d 42 dd             	lea    -0x23(%edx),%eax
  800369:	3c 55                	cmp    $0x55,%al
  80036b:	0f 87 12 04 00 00    	ja     800783 <vprintfmt+0x45b>
  800371:	0f b6 c0             	movzbl %al,%eax
  800374:	ff 24 85 40 16 80 00 	jmp    *0x801640(,%eax,4)
  80037b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800382:	eb d9                	jmp    80035d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800384:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800387:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80038b:	eb d0                	jmp    80035d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80038d:	0f b6 d2             	movzbl %dl,%edx
  800390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800393:	b8 00 00 00 00       	mov    $0x0,%eax
  800398:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80039b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80039e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a8:	83 f9 09             	cmp    $0x9,%ecx
  8003ab:	77 55                	ja     800402 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003ad:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b0:	eb e9                	jmp    80039b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	8b 00                	mov    (%eax),%eax
  8003b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bd:	8d 40 04             	lea    0x4(%eax),%eax
  8003c0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ca:	79 91                	jns    80035d <vprintfmt+0x35>
				width = precision, precision = -1;
  8003cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003d9:	eb 82                	jmp    80035d <vprintfmt+0x35>
  8003db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003de:	85 c0                	test   %eax,%eax
  8003e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e5:	0f 49 d0             	cmovns %eax,%edx
  8003e8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ee:	e9 6a ff ff ff       	jmp    80035d <vprintfmt+0x35>
  8003f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003f6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003fd:	e9 5b ff ff ff       	jmp    80035d <vprintfmt+0x35>
  800402:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800405:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800408:	eb bc                	jmp    8003c6 <vprintfmt+0x9e>
			lflag++;
  80040a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80040d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800410:	e9 48 ff ff ff       	jmp    80035d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800415:	8b 45 14             	mov    0x14(%ebp),%eax
  800418:	8d 78 04             	lea    0x4(%eax),%edi
  80041b:	83 ec 08             	sub    $0x8,%esp
  80041e:	53                   	push   %ebx
  80041f:	ff 30                	pushl  (%eax)
  800421:	ff d6                	call   *%esi
			break;
  800423:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800426:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800429:	e9 cf 02 00 00       	jmp    8006fd <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80042e:	8b 45 14             	mov    0x14(%ebp),%eax
  800431:	8d 78 04             	lea    0x4(%eax),%edi
  800434:	8b 00                	mov    (%eax),%eax
  800436:	99                   	cltd   
  800437:	31 d0                	xor    %edx,%eax
  800439:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043b:	83 f8 0f             	cmp    $0xf,%eax
  80043e:	7f 23                	jg     800463 <vprintfmt+0x13b>
  800440:	8b 14 85 a0 17 80 00 	mov    0x8017a0(,%eax,4),%edx
  800447:	85 d2                	test   %edx,%edx
  800449:	74 18                	je     800463 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80044b:	52                   	push   %edx
  80044c:	68 2a 15 80 00       	push   $0x80152a
  800451:	53                   	push   %ebx
  800452:	56                   	push   %esi
  800453:	e8 b3 fe ff ff       	call   80030b <printfmt>
  800458:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045e:	e9 9a 02 00 00       	jmp    8006fd <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800463:	50                   	push   %eax
  800464:	68 21 15 80 00       	push   $0x801521
  800469:	53                   	push   %ebx
  80046a:	56                   	push   %esi
  80046b:	e8 9b fe ff ff       	call   80030b <printfmt>
  800470:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800473:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800476:	e9 82 02 00 00       	jmp    8006fd <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80047b:	8b 45 14             	mov    0x14(%ebp),%eax
  80047e:	83 c0 04             	add    $0x4,%eax
  800481:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800484:	8b 45 14             	mov    0x14(%ebp),%eax
  800487:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800489:	85 ff                	test   %edi,%edi
  80048b:	b8 1a 15 80 00       	mov    $0x80151a,%eax
  800490:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800493:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800497:	0f 8e bd 00 00 00    	jle    80055a <vprintfmt+0x232>
  80049d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004a1:	75 0e                	jne    8004b1 <vprintfmt+0x189>
  8004a3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004a9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ac:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004af:	eb 6d                	jmp    80051e <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	ff 75 d0             	pushl  -0x30(%ebp)
  8004b7:	57                   	push   %edi
  8004b8:	e8 6e 03 00 00       	call   80082b <strnlen>
  8004bd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c0:	29 c1                	sub    %eax,%ecx
  8004c2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004c5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004c8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cf:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004d2:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d4:	eb 0f                	jmp    8004e5 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	53                   	push   %ebx
  8004da:	ff 75 e0             	pushl  -0x20(%ebp)
  8004dd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004df:	83 ef 01             	sub    $0x1,%edi
  8004e2:	83 c4 10             	add    $0x10,%esp
  8004e5:	85 ff                	test   %edi,%edi
  8004e7:	7f ed                	jg     8004d6 <vprintfmt+0x1ae>
  8004e9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004ec:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004ef:	85 c9                	test   %ecx,%ecx
  8004f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f6:	0f 49 c1             	cmovns %ecx,%eax
  8004f9:	29 c1                	sub    %eax,%ecx
  8004fb:	89 75 08             	mov    %esi,0x8(%ebp)
  8004fe:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800501:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800504:	89 cb                	mov    %ecx,%ebx
  800506:	eb 16                	jmp    80051e <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800508:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80050c:	75 31                	jne    80053f <vprintfmt+0x217>
					putch(ch, putdat);
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	ff 75 0c             	pushl  0xc(%ebp)
  800514:	50                   	push   %eax
  800515:	ff 55 08             	call   *0x8(%ebp)
  800518:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80051b:	83 eb 01             	sub    $0x1,%ebx
  80051e:	83 c7 01             	add    $0x1,%edi
  800521:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800525:	0f be c2             	movsbl %dl,%eax
  800528:	85 c0                	test   %eax,%eax
  80052a:	74 59                	je     800585 <vprintfmt+0x25d>
  80052c:	85 f6                	test   %esi,%esi
  80052e:	78 d8                	js     800508 <vprintfmt+0x1e0>
  800530:	83 ee 01             	sub    $0x1,%esi
  800533:	79 d3                	jns    800508 <vprintfmt+0x1e0>
  800535:	89 df                	mov    %ebx,%edi
  800537:	8b 75 08             	mov    0x8(%ebp),%esi
  80053a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80053d:	eb 37                	jmp    800576 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80053f:	0f be d2             	movsbl %dl,%edx
  800542:	83 ea 20             	sub    $0x20,%edx
  800545:	83 fa 5e             	cmp    $0x5e,%edx
  800548:	76 c4                	jbe    80050e <vprintfmt+0x1e6>
					putch('?', putdat);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 0c             	pushl  0xc(%ebp)
  800550:	6a 3f                	push   $0x3f
  800552:	ff 55 08             	call   *0x8(%ebp)
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	eb c1                	jmp    80051b <vprintfmt+0x1f3>
  80055a:	89 75 08             	mov    %esi,0x8(%ebp)
  80055d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800560:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800563:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800566:	eb b6                	jmp    80051e <vprintfmt+0x1f6>
				putch(' ', putdat);
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	53                   	push   %ebx
  80056c:	6a 20                	push   $0x20
  80056e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800570:	83 ef 01             	sub    $0x1,%edi
  800573:	83 c4 10             	add    $0x10,%esp
  800576:	85 ff                	test   %edi,%edi
  800578:	7f ee                	jg     800568 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80057a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057d:	89 45 14             	mov    %eax,0x14(%ebp)
  800580:	e9 78 01 00 00       	jmp    8006fd <vprintfmt+0x3d5>
  800585:	89 df                	mov    %ebx,%edi
  800587:	8b 75 08             	mov    0x8(%ebp),%esi
  80058a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80058d:	eb e7                	jmp    800576 <vprintfmt+0x24e>
	if (lflag >= 2)
  80058f:	83 f9 01             	cmp    $0x1,%ecx
  800592:	7e 3f                	jle    8005d3 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 50 04             	mov    0x4(%eax),%edx
  80059a:	8b 00                	mov    (%eax),%eax
  80059c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80059f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8d 40 08             	lea    0x8(%eax),%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005af:	79 5c                	jns    80060d <vprintfmt+0x2e5>
				putch('-', putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	53                   	push   %ebx
  8005b5:	6a 2d                	push   $0x2d
  8005b7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005bc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005bf:	f7 da                	neg    %edx
  8005c1:	83 d1 00             	adc    $0x0,%ecx
  8005c4:	f7 d9                	neg    %ecx
  8005c6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ce:	e9 10 01 00 00       	jmp    8006e3 <vprintfmt+0x3bb>
	else if (lflag)
  8005d3:	85 c9                	test   %ecx,%ecx
  8005d5:	75 1b                	jne    8005f2 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005df:	89 c1                	mov    %eax,%ecx
  8005e1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8d 40 04             	lea    0x4(%eax),%eax
  8005ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f0:	eb b9                	jmp    8005ab <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fa:	89 c1                	mov    %eax,%ecx
  8005fc:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ff:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	8d 40 04             	lea    0x4(%eax),%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
  80060b:	eb 9e                	jmp    8005ab <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80060d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800610:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800613:	b8 0a 00 00 00       	mov    $0xa,%eax
  800618:	e9 c6 00 00 00       	jmp    8006e3 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80061d:	83 f9 01             	cmp    $0x1,%ecx
  800620:	7e 18                	jle    80063a <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 10                	mov    (%eax),%edx
  800627:	8b 48 04             	mov    0x4(%eax),%ecx
  80062a:	8d 40 08             	lea    0x8(%eax),%eax
  80062d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800630:	b8 0a 00 00 00       	mov    $0xa,%eax
  800635:	e9 a9 00 00 00       	jmp    8006e3 <vprintfmt+0x3bb>
	else if (lflag)
  80063a:	85 c9                	test   %ecx,%ecx
  80063c:	75 1a                	jne    800658 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8b 10                	mov    (%eax),%edx
  800643:	b9 00 00 00 00       	mov    $0x0,%ecx
  800648:	8d 40 04             	lea    0x4(%eax),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800653:	e9 8b 00 00 00       	jmp    8006e3 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8b 10                	mov    (%eax),%edx
  80065d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800662:	8d 40 04             	lea    0x4(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800668:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066d:	eb 74                	jmp    8006e3 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80066f:	83 f9 01             	cmp    $0x1,%ecx
  800672:	7e 15                	jle    800689 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8b 10                	mov    (%eax),%edx
  800679:	8b 48 04             	mov    0x4(%eax),%ecx
  80067c:	8d 40 08             	lea    0x8(%eax),%eax
  80067f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800682:	b8 08 00 00 00       	mov    $0x8,%eax
  800687:	eb 5a                	jmp    8006e3 <vprintfmt+0x3bb>
	else if (lflag)
  800689:	85 c9                	test   %ecx,%ecx
  80068b:	75 17                	jne    8006a4 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8b 10                	mov    (%eax),%edx
  800692:	b9 00 00 00 00       	mov    $0x0,%ecx
  800697:	8d 40 04             	lea    0x4(%eax),%eax
  80069a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80069d:	b8 08 00 00 00       	mov    $0x8,%eax
  8006a2:	eb 3f                	jmp    8006e3 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8b 10                	mov    (%eax),%edx
  8006a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ae:	8d 40 04             	lea    0x4(%eax),%eax
  8006b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b9:	eb 28                	jmp    8006e3 <vprintfmt+0x3bb>
			putch('0', putdat);
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	53                   	push   %ebx
  8006bf:	6a 30                	push   $0x30
  8006c1:	ff d6                	call   *%esi
			putch('x', putdat);
  8006c3:	83 c4 08             	add    $0x8,%esp
  8006c6:	53                   	push   %ebx
  8006c7:	6a 78                	push   $0x78
  8006c9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8b 10                	mov    (%eax),%edx
  8006d0:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006d5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006d8:	8d 40 04             	lea    0x4(%eax),%eax
  8006db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006de:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006e3:	83 ec 0c             	sub    $0xc,%esp
  8006e6:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006ea:	57                   	push   %edi
  8006eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ee:	50                   	push   %eax
  8006ef:	51                   	push   %ecx
  8006f0:	52                   	push   %edx
  8006f1:	89 da                	mov    %ebx,%edx
  8006f3:	89 f0                	mov    %esi,%eax
  8006f5:	e8 45 fb ff ff       	call   80023f <printnum>
			break;
  8006fa:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  800700:	83 c7 01             	add    $0x1,%edi
  800703:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800707:	83 f8 25             	cmp    $0x25,%eax
  80070a:	0f 84 2f fc ff ff    	je     80033f <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  800710:	85 c0                	test   %eax,%eax
  800712:	0f 84 8b 00 00 00    	je     8007a3 <vprintfmt+0x47b>
			putch(ch, putdat);
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	53                   	push   %ebx
  80071c:	50                   	push   %eax
  80071d:	ff d6                	call   *%esi
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	eb dc                	jmp    800700 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800724:	83 f9 01             	cmp    $0x1,%ecx
  800727:	7e 15                	jle    80073e <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8b 10                	mov    (%eax),%edx
  80072e:	8b 48 04             	mov    0x4(%eax),%ecx
  800731:	8d 40 08             	lea    0x8(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800737:	b8 10 00 00 00       	mov    $0x10,%eax
  80073c:	eb a5                	jmp    8006e3 <vprintfmt+0x3bb>
	else if (lflag)
  80073e:	85 c9                	test   %ecx,%ecx
  800740:	75 17                	jne    800759 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8b 10                	mov    (%eax),%edx
  800747:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074c:	8d 40 04             	lea    0x4(%eax),%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800752:	b8 10 00 00 00       	mov    $0x10,%eax
  800757:	eb 8a                	jmp    8006e3 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8b 10                	mov    (%eax),%edx
  80075e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800763:	8d 40 04             	lea    0x4(%eax),%eax
  800766:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800769:	b8 10 00 00 00       	mov    $0x10,%eax
  80076e:	e9 70 ff ff ff       	jmp    8006e3 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	53                   	push   %ebx
  800777:	6a 25                	push   $0x25
  800779:	ff d6                	call   *%esi
			break;
  80077b:	83 c4 10             	add    $0x10,%esp
  80077e:	e9 7a ff ff ff       	jmp    8006fd <vprintfmt+0x3d5>
			putch('%', putdat);
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	53                   	push   %ebx
  800787:	6a 25                	push   $0x25
  800789:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80078b:	83 c4 10             	add    $0x10,%esp
  80078e:	89 f8                	mov    %edi,%eax
  800790:	eb 03                	jmp    800795 <vprintfmt+0x46d>
  800792:	83 e8 01             	sub    $0x1,%eax
  800795:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800799:	75 f7                	jne    800792 <vprintfmt+0x46a>
  80079b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80079e:	e9 5a ff ff ff       	jmp    8006fd <vprintfmt+0x3d5>
}
  8007a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007a6:	5b                   	pop    %ebx
  8007a7:	5e                   	pop    %esi
  8007a8:	5f                   	pop    %edi
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	83 ec 18             	sub    $0x18,%esp
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007ba:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007be:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c8:	85 c0                	test   %eax,%eax
  8007ca:	74 26                	je     8007f2 <vsnprintf+0x47>
  8007cc:	85 d2                	test   %edx,%edx
  8007ce:	7e 22                	jle    8007f2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d0:	ff 75 14             	pushl  0x14(%ebp)
  8007d3:	ff 75 10             	pushl  0x10(%ebp)
  8007d6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d9:	50                   	push   %eax
  8007da:	68 ee 02 80 00       	push   $0x8002ee
  8007df:	e8 44 fb ff ff       	call   800328 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ed:	83 c4 10             	add    $0x10,%esp
}
  8007f0:	c9                   	leave  
  8007f1:	c3                   	ret    
		return -E_INVAL;
  8007f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f7:	eb f7                	jmp    8007f0 <vsnprintf+0x45>

008007f9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007ff:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800802:	50                   	push   %eax
  800803:	ff 75 10             	pushl  0x10(%ebp)
  800806:	ff 75 0c             	pushl  0xc(%ebp)
  800809:	ff 75 08             	pushl  0x8(%ebp)
  80080c:	e8 9a ff ff ff       	call   8007ab <vsnprintf>
	va_end(ap);

	return rc;
}
  800811:	c9                   	leave  
  800812:	c3                   	ret    

00800813 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800819:	b8 00 00 00 00       	mov    $0x0,%eax
  80081e:	eb 03                	jmp    800823 <strlen+0x10>
		n++;
  800820:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800823:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800827:	75 f7                	jne    800820 <strlen+0xd>
	return n;
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800831:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800834:	b8 00 00 00 00       	mov    $0x0,%eax
  800839:	eb 03                	jmp    80083e <strnlen+0x13>
		n++;
  80083b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083e:	39 d0                	cmp    %edx,%eax
  800840:	74 06                	je     800848 <strnlen+0x1d>
  800842:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800846:	75 f3                	jne    80083b <strnlen+0x10>
	return n;
}
  800848:	5d                   	pop    %ebp
  800849:	c3                   	ret    

0080084a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80084a:	55                   	push   %ebp
  80084b:	89 e5                	mov    %esp,%ebp
  80084d:	53                   	push   %ebx
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800854:	89 c2                	mov    %eax,%edx
  800856:	83 c1 01             	add    $0x1,%ecx
  800859:	83 c2 01             	add    $0x1,%edx
  80085c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800860:	88 5a ff             	mov    %bl,-0x1(%edx)
  800863:	84 db                	test   %bl,%bl
  800865:	75 ef                	jne    800856 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800867:	5b                   	pop    %ebx
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	53                   	push   %ebx
  80086e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800871:	53                   	push   %ebx
  800872:	e8 9c ff ff ff       	call   800813 <strlen>
  800877:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80087a:	ff 75 0c             	pushl  0xc(%ebp)
  80087d:	01 d8                	add    %ebx,%eax
  80087f:	50                   	push   %eax
  800880:	e8 c5 ff ff ff       	call   80084a <strcpy>
	return dst;
}
  800885:	89 d8                	mov    %ebx,%eax
  800887:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088a:	c9                   	leave  
  80088b:	c3                   	ret    

0080088c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	56                   	push   %esi
  800890:	53                   	push   %ebx
  800891:	8b 75 08             	mov    0x8(%ebp),%esi
  800894:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800897:	89 f3                	mov    %esi,%ebx
  800899:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80089c:	89 f2                	mov    %esi,%edx
  80089e:	eb 0f                	jmp    8008af <strncpy+0x23>
		*dst++ = *src;
  8008a0:	83 c2 01             	add    $0x1,%edx
  8008a3:	0f b6 01             	movzbl (%ecx),%eax
  8008a6:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008a9:	80 39 01             	cmpb   $0x1,(%ecx)
  8008ac:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008af:	39 da                	cmp    %ebx,%edx
  8008b1:	75 ed                	jne    8008a0 <strncpy+0x14>
	}
	return ret;
}
  8008b3:	89 f0                	mov    %esi,%eax
  8008b5:	5b                   	pop    %ebx
  8008b6:	5e                   	pop    %esi
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    

008008b9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	56                   	push   %esi
  8008bd:	53                   	push   %ebx
  8008be:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008c7:	89 f0                	mov    %esi,%eax
  8008c9:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008cd:	85 c9                	test   %ecx,%ecx
  8008cf:	75 0b                	jne    8008dc <strlcpy+0x23>
  8008d1:	eb 17                	jmp    8008ea <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008d3:	83 c2 01             	add    $0x1,%edx
  8008d6:	83 c0 01             	add    $0x1,%eax
  8008d9:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008dc:	39 d8                	cmp    %ebx,%eax
  8008de:	74 07                	je     8008e7 <strlcpy+0x2e>
  8008e0:	0f b6 0a             	movzbl (%edx),%ecx
  8008e3:	84 c9                	test   %cl,%cl
  8008e5:	75 ec                	jne    8008d3 <strlcpy+0x1a>
		*dst = '\0';
  8008e7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ea:	29 f0                	sub    %esi,%eax
}
  8008ec:	5b                   	pop    %ebx
  8008ed:	5e                   	pop    %esi
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f9:	eb 06                	jmp    800901 <strcmp+0x11>
		p++, q++;
  8008fb:	83 c1 01             	add    $0x1,%ecx
  8008fe:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800901:	0f b6 01             	movzbl (%ecx),%eax
  800904:	84 c0                	test   %al,%al
  800906:	74 04                	je     80090c <strcmp+0x1c>
  800908:	3a 02                	cmp    (%edx),%al
  80090a:	74 ef                	je     8008fb <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80090c:	0f b6 c0             	movzbl %al,%eax
  80090f:	0f b6 12             	movzbl (%edx),%edx
  800912:	29 d0                	sub    %edx,%eax
}
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    

00800916 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	53                   	push   %ebx
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800920:	89 c3                	mov    %eax,%ebx
  800922:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800925:	eb 06                	jmp    80092d <strncmp+0x17>
		n--, p++, q++;
  800927:	83 c0 01             	add    $0x1,%eax
  80092a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80092d:	39 d8                	cmp    %ebx,%eax
  80092f:	74 16                	je     800947 <strncmp+0x31>
  800931:	0f b6 08             	movzbl (%eax),%ecx
  800934:	84 c9                	test   %cl,%cl
  800936:	74 04                	je     80093c <strncmp+0x26>
  800938:	3a 0a                	cmp    (%edx),%cl
  80093a:	74 eb                	je     800927 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80093c:	0f b6 00             	movzbl (%eax),%eax
  80093f:	0f b6 12             	movzbl (%edx),%edx
  800942:	29 d0                	sub    %edx,%eax
}
  800944:	5b                   	pop    %ebx
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    
		return 0;
  800947:	b8 00 00 00 00       	mov    $0x0,%eax
  80094c:	eb f6                	jmp    800944 <strncmp+0x2e>

0080094e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800958:	0f b6 10             	movzbl (%eax),%edx
  80095b:	84 d2                	test   %dl,%dl
  80095d:	74 09                	je     800968 <strchr+0x1a>
		if (*s == c)
  80095f:	38 ca                	cmp    %cl,%dl
  800961:	74 0a                	je     80096d <strchr+0x1f>
	for (; *s; s++)
  800963:	83 c0 01             	add    $0x1,%eax
  800966:	eb f0                	jmp    800958 <strchr+0xa>
			return (char *) s;
	return 0;
  800968:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    

0080096f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800979:	eb 03                	jmp    80097e <strfind+0xf>
  80097b:	83 c0 01             	add    $0x1,%eax
  80097e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800981:	38 ca                	cmp    %cl,%dl
  800983:	74 04                	je     800989 <strfind+0x1a>
  800985:	84 d2                	test   %dl,%dl
  800987:	75 f2                	jne    80097b <strfind+0xc>
			break;
	return (char *) s;
}
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	57                   	push   %edi
  80098f:	56                   	push   %esi
  800990:	53                   	push   %ebx
  800991:	8b 7d 08             	mov    0x8(%ebp),%edi
  800994:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800997:	85 c9                	test   %ecx,%ecx
  800999:	74 13                	je     8009ae <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80099b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009a1:	75 05                	jne    8009a8 <memset+0x1d>
  8009a3:	f6 c1 03             	test   $0x3,%cl
  8009a6:	74 0d                	je     8009b5 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ab:	fc                   	cld    
  8009ac:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ae:	89 f8                	mov    %edi,%eax
  8009b0:	5b                   	pop    %ebx
  8009b1:	5e                   	pop    %esi
  8009b2:	5f                   	pop    %edi
  8009b3:	5d                   	pop    %ebp
  8009b4:	c3                   	ret    
		c &= 0xFF;
  8009b5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009b9:	89 d3                	mov    %edx,%ebx
  8009bb:	c1 e3 08             	shl    $0x8,%ebx
  8009be:	89 d0                	mov    %edx,%eax
  8009c0:	c1 e0 18             	shl    $0x18,%eax
  8009c3:	89 d6                	mov    %edx,%esi
  8009c5:	c1 e6 10             	shl    $0x10,%esi
  8009c8:	09 f0                	or     %esi,%eax
  8009ca:	09 c2                	or     %eax,%edx
  8009cc:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009ce:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009d1:	89 d0                	mov    %edx,%eax
  8009d3:	fc                   	cld    
  8009d4:	f3 ab                	rep stos %eax,%es:(%edi)
  8009d6:	eb d6                	jmp    8009ae <memset+0x23>

008009d8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	57                   	push   %edi
  8009dc:	56                   	push   %esi
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009e6:	39 c6                	cmp    %eax,%esi
  8009e8:	73 35                	jae    800a1f <memmove+0x47>
  8009ea:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ed:	39 c2                	cmp    %eax,%edx
  8009ef:	76 2e                	jbe    800a1f <memmove+0x47>
		s += n;
		d += n;
  8009f1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f4:	89 d6                	mov    %edx,%esi
  8009f6:	09 fe                	or     %edi,%esi
  8009f8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009fe:	74 0c                	je     800a0c <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a00:	83 ef 01             	sub    $0x1,%edi
  800a03:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a06:	fd                   	std    
  800a07:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a09:	fc                   	cld    
  800a0a:	eb 21                	jmp    800a2d <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0c:	f6 c1 03             	test   $0x3,%cl
  800a0f:	75 ef                	jne    800a00 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a11:	83 ef 04             	sub    $0x4,%edi
  800a14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a17:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a1a:	fd                   	std    
  800a1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a1d:	eb ea                	jmp    800a09 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1f:	89 f2                	mov    %esi,%edx
  800a21:	09 c2                	or     %eax,%edx
  800a23:	f6 c2 03             	test   $0x3,%dl
  800a26:	74 09                	je     800a31 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a28:	89 c7                	mov    %eax,%edi
  800a2a:	fc                   	cld    
  800a2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a2d:	5e                   	pop    %esi
  800a2e:	5f                   	pop    %edi
  800a2f:	5d                   	pop    %ebp
  800a30:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a31:	f6 c1 03             	test   $0x3,%cl
  800a34:	75 f2                	jne    800a28 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a36:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a39:	89 c7                	mov    %eax,%edi
  800a3b:	fc                   	cld    
  800a3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3e:	eb ed                	jmp    800a2d <memmove+0x55>

00800a40 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a43:	ff 75 10             	pushl  0x10(%ebp)
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	ff 75 08             	pushl  0x8(%ebp)
  800a4c:	e8 87 ff ff ff       	call   8009d8 <memmove>
}
  800a51:	c9                   	leave  
  800a52:	c3                   	ret    

00800a53 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	56                   	push   %esi
  800a57:	53                   	push   %ebx
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5e:	89 c6                	mov    %eax,%esi
  800a60:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a63:	39 f0                	cmp    %esi,%eax
  800a65:	74 1c                	je     800a83 <memcmp+0x30>
		if (*s1 != *s2)
  800a67:	0f b6 08             	movzbl (%eax),%ecx
  800a6a:	0f b6 1a             	movzbl (%edx),%ebx
  800a6d:	38 d9                	cmp    %bl,%cl
  800a6f:	75 08                	jne    800a79 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a71:	83 c0 01             	add    $0x1,%eax
  800a74:	83 c2 01             	add    $0x1,%edx
  800a77:	eb ea                	jmp    800a63 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a79:	0f b6 c1             	movzbl %cl,%eax
  800a7c:	0f b6 db             	movzbl %bl,%ebx
  800a7f:	29 d8                	sub    %ebx,%eax
  800a81:	eb 05                	jmp    800a88 <memcmp+0x35>
	}

	return 0;
  800a83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a88:	5b                   	pop    %ebx
  800a89:	5e                   	pop    %esi
  800a8a:	5d                   	pop    %ebp
  800a8b:	c3                   	ret    

00800a8c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a95:	89 c2                	mov    %eax,%edx
  800a97:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a9a:	39 d0                	cmp    %edx,%eax
  800a9c:	73 09                	jae    800aa7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a9e:	38 08                	cmp    %cl,(%eax)
  800aa0:	74 05                	je     800aa7 <memfind+0x1b>
	for (; s < ends; s++)
  800aa2:	83 c0 01             	add    $0x1,%eax
  800aa5:	eb f3                	jmp    800a9a <memfind+0xe>
			break;
	return (void *) s;
}
  800aa7:	5d                   	pop    %ebp
  800aa8:	c3                   	ret    

00800aa9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	57                   	push   %edi
  800aad:	56                   	push   %esi
  800aae:	53                   	push   %ebx
  800aaf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ab5:	eb 03                	jmp    800aba <strtol+0x11>
		s++;
  800ab7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800aba:	0f b6 01             	movzbl (%ecx),%eax
  800abd:	3c 20                	cmp    $0x20,%al
  800abf:	74 f6                	je     800ab7 <strtol+0xe>
  800ac1:	3c 09                	cmp    $0x9,%al
  800ac3:	74 f2                	je     800ab7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ac5:	3c 2b                	cmp    $0x2b,%al
  800ac7:	74 2e                	je     800af7 <strtol+0x4e>
	int neg = 0;
  800ac9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ace:	3c 2d                	cmp    $0x2d,%al
  800ad0:	74 2f                	je     800b01 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ad8:	75 05                	jne    800adf <strtol+0x36>
  800ada:	80 39 30             	cmpb   $0x30,(%ecx)
  800add:	74 2c                	je     800b0b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800adf:	85 db                	test   %ebx,%ebx
  800ae1:	75 0a                	jne    800aed <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ae3:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ae8:	80 39 30             	cmpb   $0x30,(%ecx)
  800aeb:	74 28                	je     800b15 <strtol+0x6c>
		base = 10;
  800aed:	b8 00 00 00 00       	mov    $0x0,%eax
  800af2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800af5:	eb 50                	jmp    800b47 <strtol+0x9e>
		s++;
  800af7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800afa:	bf 00 00 00 00       	mov    $0x0,%edi
  800aff:	eb d1                	jmp    800ad2 <strtol+0x29>
		s++, neg = 1;
  800b01:	83 c1 01             	add    $0x1,%ecx
  800b04:	bf 01 00 00 00       	mov    $0x1,%edi
  800b09:	eb c7                	jmp    800ad2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b0b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b0f:	74 0e                	je     800b1f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b11:	85 db                	test   %ebx,%ebx
  800b13:	75 d8                	jne    800aed <strtol+0x44>
		s++, base = 8;
  800b15:	83 c1 01             	add    $0x1,%ecx
  800b18:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b1d:	eb ce                	jmp    800aed <strtol+0x44>
		s += 2, base = 16;
  800b1f:	83 c1 02             	add    $0x2,%ecx
  800b22:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b27:	eb c4                	jmp    800aed <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b29:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b2c:	89 f3                	mov    %esi,%ebx
  800b2e:	80 fb 19             	cmp    $0x19,%bl
  800b31:	77 29                	ja     800b5c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b33:	0f be d2             	movsbl %dl,%edx
  800b36:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b39:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b3c:	7d 30                	jge    800b6e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b3e:	83 c1 01             	add    $0x1,%ecx
  800b41:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b45:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b47:	0f b6 11             	movzbl (%ecx),%edx
  800b4a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b4d:	89 f3                	mov    %esi,%ebx
  800b4f:	80 fb 09             	cmp    $0x9,%bl
  800b52:	77 d5                	ja     800b29 <strtol+0x80>
			dig = *s - '0';
  800b54:	0f be d2             	movsbl %dl,%edx
  800b57:	83 ea 30             	sub    $0x30,%edx
  800b5a:	eb dd                	jmp    800b39 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b5c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b5f:	89 f3                	mov    %esi,%ebx
  800b61:	80 fb 19             	cmp    $0x19,%bl
  800b64:	77 08                	ja     800b6e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b66:	0f be d2             	movsbl %dl,%edx
  800b69:	83 ea 37             	sub    $0x37,%edx
  800b6c:	eb cb                	jmp    800b39 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b72:	74 05                	je     800b79 <strtol+0xd0>
		*endptr = (char *) s;
  800b74:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b77:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b79:	89 c2                	mov    %eax,%edx
  800b7b:	f7 da                	neg    %edx
  800b7d:	85 ff                	test   %edi,%edi
  800b7f:	0f 45 c2             	cmovne %edx,%eax
}
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5f                   	pop    %edi
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	57                   	push   %edi
  800b8b:	56                   	push   %esi
  800b8c:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800b8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b92:	8b 55 08             	mov    0x8(%ebp),%edx
  800b95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b98:	89 c3                	mov    %eax,%ebx
  800b9a:	89 c7                	mov    %eax,%edi
  800b9c:	89 c6                	mov    %eax,%esi
  800b9e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5f                   	pop    %edi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	57                   	push   %edi
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bab:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb0:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb5:	89 d1                	mov    %edx,%ecx
  800bb7:	89 d3                	mov    %edx,%ebx
  800bb9:	89 d7                	mov    %edx,%edi
  800bbb:	89 d6                	mov    %edx,%esi
  800bbd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	57                   	push   %edi
  800bc8:	56                   	push   %esi
  800bc9:	53                   	push   %ebx
  800bca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800bcd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	b8 03 00 00 00       	mov    $0x3,%eax
  800bda:	89 cb                	mov    %ecx,%ebx
  800bdc:	89 cf                	mov    %ecx,%edi
  800bde:	89 ce                	mov    %ecx,%esi
  800be0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800be2:	85 c0                	test   %eax,%eax
  800be4:	7f 08                	jg     800bee <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be9:	5b                   	pop    %ebx
  800bea:	5e                   	pop    %esi
  800beb:	5f                   	pop    %edi
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bee:	83 ec 0c             	sub    $0xc,%esp
  800bf1:	50                   	push   %eax
  800bf2:	6a 03                	push   $0x3
  800bf4:	68 ff 17 80 00       	push   $0x8017ff
  800bf9:	6a 23                	push   $0x23
  800bfb:	68 1c 18 80 00       	push   $0x80181c
  800c00:	e8 4b f5 ff ff       	call   800150 <_panic>

00800c05 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	57                   	push   %edi
  800c09:	56                   	push   %esi
  800c0a:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c10:	b8 02 00 00 00       	mov    $0x2,%eax
  800c15:	89 d1                	mov    %edx,%ecx
  800c17:	89 d3                	mov    %edx,%ebx
  800c19:	89 d7                	mov    %edx,%edi
  800c1b:	89 d6                	mov    %edx,%esi
  800c1d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c1f:	5b                   	pop    %ebx
  800c20:	5e                   	pop    %esi
  800c21:	5f                   	pop    %edi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <sys_yield>:

void
sys_yield(void)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c34:	89 d1                	mov    %edx,%ecx
  800c36:	89 d3                	mov    %edx,%ebx
  800c38:	89 d7                	mov    %edx,%edi
  800c3a:	89 d6                	mov    %edx,%esi
  800c3c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c3e:	5b                   	pop    %ebx
  800c3f:	5e                   	pop    %esi
  800c40:	5f                   	pop    %edi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	57                   	push   %edi
  800c47:	56                   	push   %esi
  800c48:	53                   	push   %ebx
  800c49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c4c:	be 00 00 00 00       	mov    $0x0,%esi
  800c51:	8b 55 08             	mov    0x8(%ebp),%edx
  800c54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c57:	b8 04 00 00 00       	mov    $0x4,%eax
  800c5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c5f:	89 f7                	mov    %esi,%edi
  800c61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c63:	85 c0                	test   %eax,%eax
  800c65:	7f 08                	jg     800c6f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6a:	5b                   	pop    %ebx
  800c6b:	5e                   	pop    %esi
  800c6c:	5f                   	pop    %edi
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6f:	83 ec 0c             	sub    $0xc,%esp
  800c72:	50                   	push   %eax
  800c73:	6a 04                	push   $0x4
  800c75:	68 ff 17 80 00       	push   $0x8017ff
  800c7a:	6a 23                	push   $0x23
  800c7c:	68 1c 18 80 00       	push   $0x80181c
  800c81:	e8 ca f4 ff ff       	call   800150 <_panic>

00800c86 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	57                   	push   %edi
  800c8a:	56                   	push   %esi
  800c8b:	53                   	push   %ebx
  800c8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c95:	b8 05 00 00 00       	mov    $0x5,%eax
  800c9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca0:	8b 75 18             	mov    0x18(%ebp),%esi
  800ca3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	7f 08                	jg     800cb1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ca9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cac:	5b                   	pop    %ebx
  800cad:	5e                   	pop    %esi
  800cae:	5f                   	pop    %edi
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb1:	83 ec 0c             	sub    $0xc,%esp
  800cb4:	50                   	push   %eax
  800cb5:	6a 05                	push   $0x5
  800cb7:	68 ff 17 80 00       	push   $0x8017ff
  800cbc:	6a 23                	push   $0x23
  800cbe:	68 1c 18 80 00       	push   $0x80181c
  800cc3:	e8 88 f4 ff ff       	call   800150 <_panic>

00800cc8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	57                   	push   %edi
  800ccc:	56                   	push   %esi
  800ccd:	53                   	push   %ebx
  800cce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800cd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdc:	b8 06 00 00 00       	mov    $0x6,%eax
  800ce1:	89 df                	mov    %ebx,%edi
  800ce3:	89 de                	mov    %ebx,%esi
  800ce5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce7:	85 c0                	test   %eax,%eax
  800ce9:	7f 08                	jg     800cf3 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ceb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf3:	83 ec 0c             	sub    $0xc,%esp
  800cf6:	50                   	push   %eax
  800cf7:	6a 06                	push   $0x6
  800cf9:	68 ff 17 80 00       	push   $0x8017ff
  800cfe:	6a 23                	push   $0x23
  800d00:	68 1c 18 80 00       	push   $0x80181c
  800d05:	e8 46 f4 ff ff       	call   800150 <_panic>

00800d0a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	57                   	push   %edi
  800d0e:	56                   	push   %esi
  800d0f:	53                   	push   %ebx
  800d10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d18:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1e:	b8 08 00 00 00       	mov    $0x8,%eax
  800d23:	89 df                	mov    %ebx,%edi
  800d25:	89 de                	mov    %ebx,%esi
  800d27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d29:	85 c0                	test   %eax,%eax
  800d2b:	7f 08                	jg     800d35 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d30:	5b                   	pop    %ebx
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d35:	83 ec 0c             	sub    $0xc,%esp
  800d38:	50                   	push   %eax
  800d39:	6a 08                	push   $0x8
  800d3b:	68 ff 17 80 00       	push   $0x8017ff
  800d40:	6a 23                	push   $0x23
  800d42:	68 1c 18 80 00       	push   $0x80181c
  800d47:	e8 04 f4 ff ff       	call   800150 <_panic>

00800d4c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	57                   	push   %edi
  800d50:	56                   	push   %esi
  800d51:	53                   	push   %ebx
  800d52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d60:	b8 09 00 00 00       	mov    $0x9,%eax
  800d65:	89 df                	mov    %ebx,%edi
  800d67:	89 de                	mov    %ebx,%esi
  800d69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6b:	85 c0                	test   %eax,%eax
  800d6d:	7f 08                	jg     800d77 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d72:	5b                   	pop    %ebx
  800d73:	5e                   	pop    %esi
  800d74:	5f                   	pop    %edi
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d77:	83 ec 0c             	sub    $0xc,%esp
  800d7a:	50                   	push   %eax
  800d7b:	6a 09                	push   $0x9
  800d7d:	68 ff 17 80 00       	push   $0x8017ff
  800d82:	6a 23                	push   $0x23
  800d84:	68 1c 18 80 00       	push   $0x80181c
  800d89:	e8 c2 f3 ff ff       	call   800150 <_panic>

00800d8e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	57                   	push   %edi
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800da7:	89 df                	mov    %ebx,%edi
  800da9:	89 de                	mov    %ebx,%esi
  800dab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dad:	85 c0                	test   %eax,%eax
  800daf:	7f 08                	jg     800db9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800db1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db4:	5b                   	pop    %ebx
  800db5:	5e                   	pop    %esi
  800db6:	5f                   	pop    %edi
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db9:	83 ec 0c             	sub    $0xc,%esp
  800dbc:	50                   	push   %eax
  800dbd:	6a 0a                	push   $0xa
  800dbf:	68 ff 17 80 00       	push   $0x8017ff
  800dc4:	6a 23                	push   $0x23
  800dc6:	68 1c 18 80 00       	push   $0x80181c
  800dcb:	e8 80 f3 ff ff       	call   800150 <_panic>

00800dd0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	57                   	push   %edi
  800dd4:	56                   	push   %esi
  800dd5:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800dd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddc:	b8 0c 00 00 00       	mov    $0xc,%eax
  800de1:	be 00 00 00 00       	mov    $0x0,%esi
  800de6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dec:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	57                   	push   %edi
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800dfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e01:	8b 55 08             	mov    0x8(%ebp),%edx
  800e04:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e09:	89 cb                	mov    %ecx,%ebx
  800e0b:	89 cf                	mov    %ecx,%edi
  800e0d:	89 ce                	mov    %ecx,%esi
  800e0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e11:	85 c0                	test   %eax,%eax
  800e13:	7f 08                	jg     800e1d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e18:	5b                   	pop    %ebx
  800e19:	5e                   	pop    %esi
  800e1a:	5f                   	pop    %edi
  800e1b:	5d                   	pop    %ebp
  800e1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1d:	83 ec 0c             	sub    $0xc,%esp
  800e20:	50                   	push   %eax
  800e21:	6a 0d                	push   $0xd
  800e23:	68 ff 17 80 00       	push   $0x8017ff
  800e28:	6a 23                	push   $0x23
  800e2a:	68 1c 18 80 00       	push   $0x80181c
  800e2f:	e8 1c f3 ff ff       	call   800150 <_panic>

00800e34 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	53                   	push   %ebx
  800e38:	83 ec 04             	sub    $0x4,%esp
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e3e:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) { //只有因为写操作写时拷贝的地址这中情况，才可以抢救。否则一律panic
  800e40:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e44:	74 74                	je     800eba <pgfault+0x86>
  800e46:	89 d8                	mov    %ebx,%eax
  800e48:	c1 e8 0c             	shr    $0xc,%eax
  800e4b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e52:	f6 c4 08             	test   $0x8,%ah
  800e55:	74 63                	je     800eba <pgfault+0x86>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800e57:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, PFTEMP, PTE_U|PTE_P)) < 0)		//将当前进程PFTEMP也映射到当前进程addr指向的物理页
  800e5d:	83 ec 0c             	sub    $0xc,%esp
  800e60:	6a 05                	push   $0x5
  800e62:	68 00 f0 7f 00       	push   $0x7ff000
  800e67:	6a 00                	push   $0x0
  800e69:	53                   	push   %ebx
  800e6a:	6a 00                	push   $0x0
  800e6c:	e8 15 fe ff ff       	call   800c86 <sys_page_map>
  800e71:	83 c4 20             	add    $0x20,%esp
  800e74:	85 c0                	test   %eax,%eax
  800e76:	78 56                	js     800ece <pgfault+0x9a>
		panic("sys_page_map: %e", r);
	if ((r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W)) < 0)	//令当前进程addr指向新分配的物理页
  800e78:	83 ec 04             	sub    $0x4,%esp
  800e7b:	6a 07                	push   $0x7
  800e7d:	53                   	push   %ebx
  800e7e:	6a 00                	push   $0x0
  800e80:	e8 be fd ff ff       	call   800c43 <sys_page_alloc>
  800e85:	83 c4 10             	add    $0x10,%esp
  800e88:	85 c0                	test   %eax,%eax
  800e8a:	78 54                	js     800ee0 <pgfault+0xac>
		panic("sys_page_alloc: %e", r);
	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800e8c:	83 ec 04             	sub    $0x4,%esp
  800e8f:	68 00 10 00 00       	push   $0x1000
  800e94:	68 00 f0 7f 00       	push   $0x7ff000
  800e99:	53                   	push   %ebx
  800e9a:	e8 39 fb ff ff       	call   8009d8 <memmove>
	if ((r = sys_page_unmap(0, PFTEMP)) < 0)					//解除当前进程PFTEMP映射
  800e9f:	83 c4 08             	add    $0x8,%esp
  800ea2:	68 00 f0 7f 00       	push   $0x7ff000
  800ea7:	6a 00                	push   $0x0
  800ea9:	e8 1a fe ff ff       	call   800cc8 <sys_page_unmap>
  800eae:	83 c4 10             	add    $0x10,%esp
  800eb1:	85 c0                	test   %eax,%eax
  800eb3:	78 3d                	js     800ef2 <pgfault+0xbe>
		panic("sys_page_unmap: %e", r);
}
  800eb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800eb8:	c9                   	leave  
  800eb9:	c3                   	ret    
		panic("pgfault():not cow");
  800eba:	83 ec 04             	sub    $0x4,%esp
  800ebd:	68 2a 18 80 00       	push   $0x80182a
  800ec2:	6a 1d                	push   $0x1d
  800ec4:	68 3c 18 80 00       	push   $0x80183c
  800ec9:	e8 82 f2 ff ff       	call   800150 <_panic>
		panic("sys_page_map: %e", r);
  800ece:	50                   	push   %eax
  800ecf:	68 47 18 80 00       	push   $0x801847
  800ed4:	6a 2a                	push   $0x2a
  800ed6:	68 3c 18 80 00       	push   $0x80183c
  800edb:	e8 70 f2 ff ff       	call   800150 <_panic>
		panic("sys_page_alloc: %e", r);
  800ee0:	50                   	push   %eax
  800ee1:	68 58 18 80 00       	push   $0x801858
  800ee6:	6a 2c                	push   $0x2c
  800ee8:	68 3c 18 80 00       	push   $0x80183c
  800eed:	e8 5e f2 ff ff       	call   800150 <_panic>
		panic("sys_page_unmap: %e", r);
  800ef2:	50                   	push   %eax
  800ef3:	68 6b 18 80 00       	push   $0x80186b
  800ef8:	6a 2f                	push   $0x2f
  800efa:	68 3c 18 80 00       	push   $0x80183c
  800eff:	e8 4c f2 ff ff       	call   800150 <_panic>

00800f04 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	57                   	push   %edi
  800f08:	56                   	push   %esi
  800f09:	53                   	push   %ebx
  800f0a:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);	//设置缺页处理函数
  800f0d:	68 34 0e 80 00       	push   $0x800e34
  800f12:	e8 cf 02 00 00       	call   8011e6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f17:	b8 07 00 00 00       	mov    $0x7,%eax
  800f1c:	cd 30                	int    $0x30
  800f1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();	//系统调用，只是简单创建一个Env结构，复制当前用户环境寄存器状态，UTOP以下的页目录还没有建立
	if (envid == 0) {				//子进程将走这个逻辑
  800f21:	83 c4 10             	add    $0x10,%esp
  800f24:	85 c0                	test   %eax,%eax
  800f26:	74 12                	je     800f3a <fork+0x36>
  800f28:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	if (envid < 0) {
  800f2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f2e:	78 26                	js     800f56 <fork+0x52>
		panic("sys_exofork: %e", envid);
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800f30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f35:	e9 94 00 00 00       	jmp    800fce <fork+0xca>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f3a:	e8 c6 fc ff ff       	call   800c05 <sys_getenvid>
  800f3f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f44:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f47:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f4c:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  800f51:	e9 51 01 00 00       	jmp    8010a7 <fork+0x1a3>
		panic("sys_exofork: %e", envid);
  800f56:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f59:	68 7e 18 80 00       	push   $0x80187e
  800f5e:	6a 6d                	push   $0x6d
  800f60:	68 3c 18 80 00       	push   $0x80183c
  800f65:	e8 e6 f1 ff ff       	call   800150 <_panic>
		sys_page_map(0, addr, envid, addr, PTE_SYSCALL);		//对于表示为PTE_SHARE的页，拷贝映射关系，并且两个进程都有读写权限
  800f6a:	83 ec 0c             	sub    $0xc,%esp
  800f6d:	68 07 0e 00 00       	push   $0xe07
  800f72:	56                   	push   %esi
  800f73:	57                   	push   %edi
  800f74:	56                   	push   %esi
  800f75:	6a 00                	push   $0x0
  800f77:	e8 0a fd ff ff       	call   800c86 <sys_page_map>
  800f7c:	83 c4 20             	add    $0x20,%esp
  800f7f:	eb 3b                	jmp    800fbc <fork+0xb8>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  800f81:	83 ec 0c             	sub    $0xc,%esp
  800f84:	68 05 08 00 00       	push   $0x805
  800f89:	56                   	push   %esi
  800f8a:	57                   	push   %edi
  800f8b:	56                   	push   %esi
  800f8c:	6a 00                	push   $0x0
  800f8e:	e8 f3 fc ff ff       	call   800c86 <sys_page_map>
  800f93:	83 c4 20             	add    $0x20,%esp
  800f96:	85 c0                	test   %eax,%eax
  800f98:	0f 88 a9 00 00 00    	js     801047 <fork+0x143>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  800f9e:	83 ec 0c             	sub    $0xc,%esp
  800fa1:	68 05 08 00 00       	push   $0x805
  800fa6:	56                   	push   %esi
  800fa7:	6a 00                	push   $0x0
  800fa9:	56                   	push   %esi
  800faa:	6a 00                	push   $0x0
  800fac:	e8 d5 fc ff ff       	call   800c86 <sys_page_map>
  800fb1:	83 c4 20             	add    $0x20,%esp
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	0f 88 9d 00 00 00    	js     801059 <fork+0x155>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  800fbc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fc2:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800fc8:	0f 84 9d 00 00 00    	je     80106b <fork+0x167>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) //为什么uvpt[pagenumber]能访问到第pagenumber项页表条目：https://pdos.csail.mit.edu/6.828/2018/labs/lab4/uvpt.html
  800fce:	89 d8                	mov    %ebx,%eax
  800fd0:	c1 e8 16             	shr    $0x16,%eax
  800fd3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fda:	a8 01                	test   $0x1,%al
  800fdc:	74 de                	je     800fbc <fork+0xb8>
  800fde:	89 d8                	mov    %ebx,%eax
  800fe0:	c1 e8 0c             	shr    $0xc,%eax
  800fe3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fea:	f6 c2 01             	test   $0x1,%dl
  800fed:	74 cd                	je     800fbc <fork+0xb8>
			&& (uvpt[PGNUM(addr)] & PTE_U)) {
  800fef:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ff6:	f6 c2 04             	test   $0x4,%dl
  800ff9:	74 c1                	je     800fbc <fork+0xb8>
	void *addr = (void*) (pn * PGSIZE);
  800ffb:	89 c6                	mov    %eax,%esi
  800ffd:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE) {
  801000:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801007:	f6 c6 04             	test   $0x4,%dh
  80100a:	0f 85 5a ff ff ff    	jne    800f6a <fork+0x66>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) { //对于UTOP以下的可写的或者写时拷贝的页，拷贝映射关系的同时，需要同时标记当前进程和子进程的页表项为PTE_COW
  801010:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801017:	f6 c2 02             	test   $0x2,%dl
  80101a:	0f 85 61 ff ff ff    	jne    800f81 <fork+0x7d>
  801020:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801027:	f6 c4 08             	test   $0x8,%ah
  80102a:	0f 85 51 ff ff ff    	jne    800f81 <fork+0x7d>
		sys_page_map(0, addr, envid, addr, PTE_U|PTE_P);	//对于只读的页，只需要拷贝映射关系即可
  801030:	83 ec 0c             	sub    $0xc,%esp
  801033:	6a 05                	push   $0x5
  801035:	56                   	push   %esi
  801036:	57                   	push   %edi
  801037:	56                   	push   %esi
  801038:	6a 00                	push   $0x0
  80103a:	e8 47 fc ff ff       	call   800c86 <sys_page_map>
  80103f:	83 c4 20             	add    $0x20,%esp
  801042:	e9 75 ff ff ff       	jmp    800fbc <fork+0xb8>
			panic("sys_page_map：%e", r);
  801047:	50                   	push   %eax
  801048:	68 8e 18 80 00       	push   $0x80188e
  80104d:	6a 48                	push   $0x48
  80104f:	68 3c 18 80 00       	push   $0x80183c
  801054:	e8 f7 f0 ff ff       	call   800150 <_panic>
			panic("sys_page_map：%e", r);
  801059:	50                   	push   %eax
  80105a:	68 8e 18 80 00       	push   $0x80188e
  80105f:	6a 4a                	push   $0x4a
  801061:	68 3c 18 80 00       	push   $0x80183c
  801066:	e8 e5 f0 ff ff       	call   800150 <_panic>
			duppage(envid, PGNUM(addr));	//拷贝当前进程映射关系到子进程
		}
	}
	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_W | PTE_U)) < 0)	//为子进程分配异常栈
  80106b:	83 ec 04             	sub    $0x4,%esp
  80106e:	6a 07                	push   $0x7
  801070:	68 00 f0 bf ee       	push   $0xeebff000
  801075:	ff 75 e4             	pushl  -0x1c(%ebp)
  801078:	e8 c6 fb ff ff       	call   800c43 <sys_page_alloc>
  80107d:	83 c4 10             	add    $0x10,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	78 2e                	js     8010b2 <fork+0x1ae>
		panic("sys_page_alloc: %e", r);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);		//为子进程设置_pgfault_upcall
  801084:	83 ec 08             	sub    $0x8,%esp
  801087:	68 3f 12 80 00       	push   $0x80123f
  80108c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80108f:	57                   	push   %edi
  801090:	e8 f9 fc ff ff       	call   800d8e <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)	//设置子进程为ENV_RUNNABLE状态
  801095:	83 c4 08             	add    $0x8,%esp
  801098:	6a 02                	push   $0x2
  80109a:	57                   	push   %edi
  80109b:	e8 6a fc ff ff       	call   800d0a <sys_env_set_status>
  8010a0:	83 c4 10             	add    $0x10,%esp
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	78 1d                	js     8010c4 <fork+0x1c0>
		panic("sys_env_set_status: %e", r);
	return envid;
}
  8010a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ad:	5b                   	pop    %ebx
  8010ae:	5e                   	pop    %esi
  8010af:	5f                   	pop    %edi
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8010b2:	50                   	push   %eax
  8010b3:	68 58 18 80 00       	push   $0x801858
  8010b8:	6a 79                	push   $0x79
  8010ba:	68 3c 18 80 00       	push   $0x80183c
  8010bf:	e8 8c f0 ff ff       	call   800150 <_panic>
		panic("sys_env_set_status: %e", r);
  8010c4:	50                   	push   %eax
  8010c5:	68 a0 18 80 00       	push   $0x8018a0
  8010ca:	6a 7d                	push   $0x7d
  8010cc:	68 3c 18 80 00       	push   $0x80183c
  8010d1:	e8 7a f0 ff ff       	call   800150 <_panic>

008010d6 <sfork>:

// Challenge!
int
sfork(void)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8010dc:	68 b7 18 80 00       	push   $0x8018b7
  8010e1:	68 85 00 00 00       	push   $0x85
  8010e6:	68 3c 18 80 00       	push   $0x80183c
  8010eb:	e8 60 f0 ff ff       	call   800150 <_panic>

008010f0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	56                   	push   %esi
  8010f4:	53                   	push   %ebx
  8010f5:	8b 75 08             	mov    0x8(%ebp),%esi
  8010f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  8010fe:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  801100:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801105:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  801108:	83 ec 0c             	sub    $0xc,%esp
  80110b:	50                   	push   %eax
  80110c:	e8 e2 fc ff ff       	call   800df3 <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  801111:	83 c4 10             	add    $0x10,%esp
  801114:	85 c0                	test   %eax,%eax
  801116:	78 2b                	js     801143 <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  801118:	85 f6                	test   %esi,%esi
  80111a:	74 0a                	je     801126 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80111c:	a1 04 20 80 00       	mov    0x802004,%eax
  801121:	8b 40 74             	mov    0x74(%eax),%eax
  801124:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  801126:	85 db                	test   %ebx,%ebx
  801128:	74 0a                	je     801134 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80112a:	a1 04 20 80 00       	mov    0x802004,%eax
  80112f:	8b 40 78             	mov    0x78(%eax),%eax
  801132:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801134:	a1 04 20 80 00       	mov    0x802004,%eax
  801139:	8b 40 70             	mov    0x70(%eax),%eax
}
  80113c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80113f:	5b                   	pop    %ebx
  801140:	5e                   	pop    %esi
  801141:	5d                   	pop    %ebp
  801142:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  801143:	85 f6                	test   %esi,%esi
  801145:	74 06                	je     80114d <ipc_recv+0x5d>
  801147:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  80114d:	85 db                	test   %ebx,%ebx
  80114f:	74 eb                	je     80113c <ipc_recv+0x4c>
  801151:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801157:	eb e3                	jmp    80113c <ipc_recv+0x4c>

00801159 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	57                   	push   %edi
  80115d:	56                   	push   %esi
  80115e:	53                   	push   %ebx
  80115f:	83 ec 0c             	sub    $0xc,%esp
  801162:	8b 7d 08             	mov    0x8(%ebp),%edi
  801165:	8b 75 0c             	mov    0xc(%ebp),%esi
  801168:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  80116b:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  80116d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801172:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801175:	ff 75 14             	pushl  0x14(%ebp)
  801178:	53                   	push   %ebx
  801179:	56                   	push   %esi
  80117a:	57                   	push   %edi
  80117b:	e8 50 fc ff ff       	call   800dd0 <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	85 c0                	test   %eax,%eax
  801185:	74 1e                	je     8011a5 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  801187:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80118a:	75 07                	jne    801193 <ipc_send+0x3a>
			sys_yield();
  80118c:	e8 93 fa ff ff       	call   800c24 <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801191:	eb e2                	jmp    801175 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  801193:	50                   	push   %eax
  801194:	68 cd 18 80 00       	push   $0x8018cd
  801199:	6a 41                	push   $0x41
  80119b:	68 db 18 80 00       	push   $0x8018db
  8011a0:	e8 ab ef ff ff       	call   800150 <_panic>
		}
	}
}
  8011a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a8:	5b                   	pop    %ebx
  8011a9:	5e                   	pop    %esi
  8011aa:	5f                   	pop    %edi
  8011ab:	5d                   	pop    %ebp
  8011ac:	c3                   	ret    

008011ad <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8011b3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8011b8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8011bb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8011c1:	8b 52 50             	mov    0x50(%edx),%edx
  8011c4:	39 ca                	cmp    %ecx,%edx
  8011c6:	74 11                	je     8011d9 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8011c8:	83 c0 01             	add    $0x1,%eax
  8011cb:	3d 00 04 00 00       	cmp    $0x400,%eax
  8011d0:	75 e6                	jne    8011b8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8011d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d7:	eb 0b                	jmp    8011e4 <ipc_find_env+0x37>
			return envs[i].env_id;
  8011d9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011e1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8011ec:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  8011f3:	74 0a                	je     8011ff <set_pgfault_handler+0x19>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	a3 08 20 80 00       	mov    %eax,0x802008
}
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    
		int r = sys_page_alloc(0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P);	//为当前进程分配异常栈
  8011ff:	83 ec 04             	sub    $0x4,%esp
  801202:	6a 07                	push   $0x7
  801204:	68 00 f0 bf ee       	push   $0xeebff000
  801209:	6a 00                	push   $0x0
  80120b:	e8 33 fa ff ff       	call   800c43 <sys_page_alloc>
		if (r < 0) {
  801210:	83 c4 10             	add    $0x10,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	78 14                	js     80122b <set_pgfault_handler+0x45>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
  801217:	83 ec 08             	sub    $0x8,%esp
  80121a:	68 3f 12 80 00       	push   $0x80123f
  80121f:	6a 00                	push   $0x0
  801221:	e8 68 fb ff ff       	call   800d8e <sys_env_set_pgfault_upcall>
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	eb ca                	jmp    8011f5 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler:sys_page_alloc failed");;
  80122b:	83 ec 04             	sub    $0x4,%esp
  80122e:	68 e8 18 80 00       	push   $0x8018e8
  801233:	6a 22                	push   $0x22
  801235:	68 14 19 80 00       	push   $0x801914
  80123a:	e8 11 ef ff ff       	call   800150 <_panic>

0080123f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80123f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801240:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax				//调用页处理函数
  801245:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801247:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp			//跳过utf_fault_va和utf_err
  80124a:	83 c4 08             	add    $0x8,%esp
	movl 40(%esp), %eax 	//保存中断发生时的esp到eax
  80124d:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl 32(%esp), %ecx 	//保存终端发生时的eip到ecx
  801251:	8b 4c 24 20          	mov    0x20(%esp),%ecx
	movl %ecx, -4(%eax) 	//将中断发生时的esp值亚入到到原来的栈中
  801255:	89 48 fc             	mov    %ecx,-0x4(%eax)
	popal
  801258:	61                   	popa   
	addl $4, %esp			//跳过eip
  801259:	83 c4 04             	add    $0x4,%esp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80125c:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80125d:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	lea -4(%esp), %esp		//因为之前压入了eip的值但是没有减esp的值，所以现在需要将esp寄存器中的值减4
  80125e:	8d 64 24 fc          	lea    -0x4(%esp),%esp
  801262:	c3                   	ret    
  801263:	66 90                	xchg   %ax,%ax
  801265:	66 90                	xchg   %ax,%ax
  801267:	66 90                	xchg   %ax,%ax
  801269:	66 90                	xchg   %ax,%ax
  80126b:	66 90                	xchg   %ax,%ax
  80126d:	66 90                	xchg   %ax,%ax
  80126f:	90                   	nop

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
