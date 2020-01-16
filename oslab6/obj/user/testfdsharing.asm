
obj/user/testfdsharing.debug：     文件格式 elf32-i386


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
  80002c:	e8 9b 01 00 00       	call   8001cc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	6a 00                	push   $0x0
  80003e:	68 20 23 80 00       	push   $0x802320
  800043:	e8 11 19 00 00       	call   801959 <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 01 01 00 00    	js     800156 <umain+0x123>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 9b 15 00 00       	call   8015fb <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 42 80 00       	push   $0x804220
  80006d:	53                   	push   %ebx
  80006e:	e8 bf 14 00 00       	call   801532 <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e8 00 00 00    	jle    800168 <umain+0x135>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 53 0f 00 00       	call   800fd8 <fork>
  800085:	89 c7                	mov    %eax,%edi
  800087:	85 c0                	test   %eax,%eax
  800089:	0f 88 eb 00 00 00    	js     80017a <umain+0x147>
		panic("fork: %e", r);
	if (r == 0) {
  80008f:	85 c0                	test   %eax,%eax
  800091:	75 7b                	jne    80010e <umain+0xdb>
		seek(fd, 0);
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	6a 00                	push   $0x0
  800098:	53                   	push   %ebx
  800099:	e8 5d 15 00 00       	call   8015fb <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009e:	c7 04 24 88 23 80 00 	movl   $0x802388,(%esp)
  8000a5:	e8 55 02 00 00       	call   8002ff <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 02 00 00       	push   $0x200
  8000b2:	68 20 40 80 00       	push   $0x804020
  8000b7:	53                   	push   %ebx
  8000b8:	e8 75 14 00 00       	call   801532 <readn>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	39 c6                	cmp    %eax,%esi
  8000c2:	0f 85 c4 00 00 00    	jne    80018c <umain+0x159>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000c8:	83 ec 04             	sub    $0x4,%esp
  8000cb:	56                   	push   %esi
  8000cc:	68 20 40 80 00       	push   $0x804020
  8000d1:	68 20 42 80 00       	push   $0x804220
  8000d6:	e8 4c 0a 00 00       	call   800b27 <memcmp>
  8000db:	83 c4 10             	add    $0x10,%esp
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	0f 85 bc 00 00 00    	jne    8001a2 <umain+0x16f>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 52 23 80 00       	push   $0x802352
  8000ee:	e8 0c 02 00 00       	call   8002ff <cprintf>
		seek(fd, 0);
  8000f3:	83 c4 08             	add    $0x8,%esp
  8000f6:	6a 00                	push   $0x0
  8000f8:	53                   	push   %ebx
  8000f9:	e8 fd 14 00 00       	call   8015fb <seek>
		close(fd);
  8000fe:	89 1c 24             	mov    %ebx,(%esp)
  800101:	e8 69 12 00 00       	call   80136f <close>
		exit();
  800106:	e8 07 01 00 00       	call   800212 <exit>
  80010b:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	57                   	push   %edi
  800112:	e8 34 1c 00 00       	call   801d4b <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800117:	83 c4 0c             	add    $0xc,%esp
  80011a:	68 00 02 00 00       	push   $0x200
  80011f:	68 20 40 80 00       	push   $0x804020
  800124:	53                   	push   %ebx
  800125:	e8 08 14 00 00       	call   801532 <readn>
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	39 c6                	cmp    %eax,%esi
  80012f:	0f 85 81 00 00 00    	jne    8001b6 <umain+0x183>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	68 6b 23 80 00       	push   $0x80236b
  80013d:	e8 bd 01 00 00       	call   8002ff <cprintf>
	close(fd);
  800142:	89 1c 24             	mov    %ebx,(%esp)
  800145:	e8 25 12 00 00       	call   80136f <close>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80014a:	cc                   	int3   

	breakpoint();
}
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800151:	5b                   	pop    %ebx
  800152:	5e                   	pop    %esi
  800153:	5f                   	pop    %edi
  800154:	5d                   	pop    %ebp
  800155:	c3                   	ret    
		panic("open motd: %e", fd);
  800156:	50                   	push   %eax
  800157:	68 25 23 80 00       	push   $0x802325
  80015c:	6a 0c                	push   $0xc
  80015e:	68 33 23 80 00       	push   $0x802333
  800163:	e8 bc 00 00 00       	call   800224 <_panic>
		panic("readn: %e", n);
  800168:	50                   	push   %eax
  800169:	68 48 23 80 00       	push   $0x802348
  80016e:	6a 0f                	push   $0xf
  800170:	68 33 23 80 00       	push   $0x802333
  800175:	e8 aa 00 00 00       	call   800224 <_panic>
		panic("fork: %e", r);
  80017a:	50                   	push   %eax
  80017b:	68 05 28 80 00       	push   $0x802805
  800180:	6a 12                	push   $0x12
  800182:	68 33 23 80 00       	push   $0x802333
  800187:	e8 98 00 00 00       	call   800224 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	50                   	push   %eax
  800190:	56                   	push   %esi
  800191:	68 cc 23 80 00       	push   $0x8023cc
  800196:	6a 17                	push   $0x17
  800198:	68 33 23 80 00       	push   $0x802333
  80019d:	e8 82 00 00 00       	call   800224 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 f8 23 80 00       	push   $0x8023f8
  8001aa:	6a 19                	push   $0x19
  8001ac:	68 33 23 80 00       	push   $0x802333
  8001b1:	e8 6e 00 00 00       	call   800224 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	50                   	push   %eax
  8001ba:	56                   	push   %esi
  8001bb:	68 30 24 80 00       	push   $0x802430
  8001c0:	6a 21                	push   $0x21
  8001c2:	68 33 23 80 00       	push   $0x802333
  8001c7:	e8 58 00 00 00       	call   800224 <_panic>

008001cc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	56                   	push   %esi
  8001d0:	53                   	push   %ebx
  8001d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  8001d7:	e8 fd 0a 00 00       	call   800cd9 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  8001dc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e9:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ee:	85 db                	test   %ebx,%ebx
  8001f0:	7e 07                	jle    8001f9 <libmain+0x2d>
		binaryname = argv[0];
  8001f2:	8b 06                	mov    (%esi),%eax
  8001f4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	56                   	push   %esi
  8001fd:	53                   	push   %ebx
  8001fe:	e8 30 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800203:	e8 0a 00 00 00       	call   800212 <exit>
}
  800208:	83 c4 10             	add    $0x10,%esp
  80020b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80020e:	5b                   	pop    %ebx
  80020f:	5e                   	pop    %esi
  800210:	5d                   	pop    %ebp
  800211:	c3                   	ret    

00800212 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800218:	6a 00                	push   $0x0
  80021a:	e8 79 0a 00 00       	call   800c98 <sys_env_destroy>
}
  80021f:	83 c4 10             	add    $0x10,%esp
  800222:	c9                   	leave  
  800223:	c3                   	ret    

00800224 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	56                   	push   %esi
  800228:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800229:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80022c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800232:	e8 a2 0a 00 00       	call   800cd9 <sys_getenvid>
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	ff 75 0c             	pushl  0xc(%ebp)
  80023d:	ff 75 08             	pushl  0x8(%ebp)
  800240:	56                   	push   %esi
  800241:	50                   	push   %eax
  800242:	68 60 24 80 00       	push   $0x802460
  800247:	e8 b3 00 00 00       	call   8002ff <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80024c:	83 c4 18             	add    $0x18,%esp
  80024f:	53                   	push   %ebx
  800250:	ff 75 10             	pushl  0x10(%ebp)
  800253:	e8 56 00 00 00       	call   8002ae <vcprintf>
	cprintf("\n");
  800258:	c7 04 24 69 23 80 00 	movl   $0x802369,(%esp)
  80025f:	e8 9b 00 00 00       	call   8002ff <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800267:	cc                   	int3   
  800268:	eb fd                	jmp    800267 <_panic+0x43>

0080026a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	53                   	push   %ebx
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800274:	8b 13                	mov    (%ebx),%edx
  800276:	8d 42 01             	lea    0x1(%edx),%eax
  800279:	89 03                	mov    %eax,(%ebx)
  80027b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80027e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800282:	3d ff 00 00 00       	cmp    $0xff,%eax
  800287:	74 09                	je     800292 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800289:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80028d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800290:	c9                   	leave  
  800291:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	68 ff 00 00 00       	push   $0xff
  80029a:	8d 43 08             	lea    0x8(%ebx),%eax
  80029d:	50                   	push   %eax
  80029e:	e8 b8 09 00 00       	call   800c5b <sys_cputs>
		b->idx = 0;
  8002a3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002a9:	83 c4 10             	add    $0x10,%esp
  8002ac:	eb db                	jmp    800289 <putch+0x1f>

008002ae <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ae:	55                   	push   %ebp
  8002af:	89 e5                	mov    %esp,%ebp
  8002b1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002b7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002be:	00 00 00 
	b.cnt = 0;
  8002c1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002c8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002cb:	ff 75 0c             	pushl  0xc(%ebp)
  8002ce:	ff 75 08             	pushl  0x8(%ebp)
  8002d1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d7:	50                   	push   %eax
  8002d8:	68 6a 02 80 00       	push   $0x80026a
  8002dd:	e8 1a 01 00 00       	call   8003fc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e2:	83 c4 08             	add    $0x8,%esp
  8002e5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002eb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f1:	50                   	push   %eax
  8002f2:	e8 64 09 00 00       	call   800c5b <sys_cputs>

	return b.cnt;
}
  8002f7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    

008002ff <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800305:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800308:	50                   	push   %eax
  800309:	ff 75 08             	pushl  0x8(%ebp)
  80030c:	e8 9d ff ff ff       	call   8002ae <vcprintf>
	va_end(ap);

	return cnt;
}
  800311:	c9                   	leave  
  800312:	c3                   	ret    

00800313 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	57                   	push   %edi
  800317:	56                   	push   %esi
  800318:	53                   	push   %ebx
  800319:	83 ec 1c             	sub    $0x1c,%esp
  80031c:	89 c7                	mov    %eax,%edi
  80031e:	89 d6                	mov    %edx,%esi
  800320:	8b 45 08             	mov    0x8(%ebp),%eax
  800323:	8b 55 0c             	mov    0xc(%ebp),%edx
  800326:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800329:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80032c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80032f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800334:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800337:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80033a:	39 d3                	cmp    %edx,%ebx
  80033c:	72 05                	jb     800343 <printnum+0x30>
  80033e:	39 45 10             	cmp    %eax,0x10(%ebp)
  800341:	77 7a                	ja     8003bd <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800343:	83 ec 0c             	sub    $0xc,%esp
  800346:	ff 75 18             	pushl  0x18(%ebp)
  800349:	8b 45 14             	mov    0x14(%ebp),%eax
  80034c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80034f:	53                   	push   %ebx
  800350:	ff 75 10             	pushl  0x10(%ebp)
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	ff 75 e4             	pushl  -0x1c(%ebp)
  800359:	ff 75 e0             	pushl  -0x20(%ebp)
  80035c:	ff 75 dc             	pushl  -0x24(%ebp)
  80035f:	ff 75 d8             	pushl  -0x28(%ebp)
  800362:	e8 69 1d 00 00       	call   8020d0 <__udivdi3>
  800367:	83 c4 18             	add    $0x18,%esp
  80036a:	52                   	push   %edx
  80036b:	50                   	push   %eax
  80036c:	89 f2                	mov    %esi,%edx
  80036e:	89 f8                	mov    %edi,%eax
  800370:	e8 9e ff ff ff       	call   800313 <printnum>
  800375:	83 c4 20             	add    $0x20,%esp
  800378:	eb 13                	jmp    80038d <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	56                   	push   %esi
  80037e:	ff 75 18             	pushl  0x18(%ebp)
  800381:	ff d7                	call   *%edi
  800383:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800386:	83 eb 01             	sub    $0x1,%ebx
  800389:	85 db                	test   %ebx,%ebx
  80038b:	7f ed                	jg     80037a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80038d:	83 ec 08             	sub    $0x8,%esp
  800390:	56                   	push   %esi
  800391:	83 ec 04             	sub    $0x4,%esp
  800394:	ff 75 e4             	pushl  -0x1c(%ebp)
  800397:	ff 75 e0             	pushl  -0x20(%ebp)
  80039a:	ff 75 dc             	pushl  -0x24(%ebp)
  80039d:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a0:	e8 4b 1e 00 00       	call   8021f0 <__umoddi3>
  8003a5:	83 c4 14             	add    $0x14,%esp
  8003a8:	0f be 80 83 24 80 00 	movsbl 0x802483(%eax),%eax
  8003af:	50                   	push   %eax
  8003b0:	ff d7                	call   *%edi
}
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003b8:	5b                   	pop    %ebx
  8003b9:	5e                   	pop    %esi
  8003ba:	5f                   	pop    %edi
  8003bb:	5d                   	pop    %ebp
  8003bc:	c3                   	ret    
  8003bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003c0:	eb c4                	jmp    800386 <printnum+0x73>

008003c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003c8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003cc:	8b 10                	mov    (%eax),%edx
  8003ce:	3b 50 04             	cmp    0x4(%eax),%edx
  8003d1:	73 0a                	jae    8003dd <sprintputch+0x1b>
		*b->buf++ = ch;
  8003d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003d6:	89 08                	mov    %ecx,(%eax)
  8003d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003db:	88 02                	mov    %al,(%edx)
}
  8003dd:	5d                   	pop    %ebp
  8003de:	c3                   	ret    

008003df <printfmt>:
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003e5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003e8:	50                   	push   %eax
  8003e9:	ff 75 10             	pushl  0x10(%ebp)
  8003ec:	ff 75 0c             	pushl  0xc(%ebp)
  8003ef:	ff 75 08             	pushl  0x8(%ebp)
  8003f2:	e8 05 00 00 00       	call   8003fc <vprintfmt>
}
  8003f7:	83 c4 10             	add    $0x10,%esp
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <vprintfmt>:
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	57                   	push   %edi
  800400:	56                   	push   %esi
  800401:	53                   	push   %ebx
  800402:	83 ec 2c             	sub    $0x2c,%esp
  800405:	8b 75 08             	mov    0x8(%ebp),%esi
  800408:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80040b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80040e:	e9 c1 03 00 00       	jmp    8007d4 <vprintfmt+0x3d8>
		padc = ' ';
  800413:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800417:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80041e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800425:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80042c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800431:	8d 47 01             	lea    0x1(%edi),%eax
  800434:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800437:	0f b6 17             	movzbl (%edi),%edx
  80043a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80043d:	3c 55                	cmp    $0x55,%al
  80043f:	0f 87 12 04 00 00    	ja     800857 <vprintfmt+0x45b>
  800445:	0f b6 c0             	movzbl %al,%eax
  800448:	ff 24 85 c0 25 80 00 	jmp    *0x8025c0(,%eax,4)
  80044f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800452:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800456:	eb d9                	jmp    800431 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800458:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80045b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80045f:	eb d0                	jmp    800431 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800461:	0f b6 d2             	movzbl %dl,%edx
  800464:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800467:	b8 00 00 00 00       	mov    $0x0,%eax
  80046c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80046f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800472:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800476:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800479:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80047c:	83 f9 09             	cmp    $0x9,%ecx
  80047f:	77 55                	ja     8004d6 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800481:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800484:	eb e9                	jmp    80046f <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800486:	8b 45 14             	mov    0x14(%ebp),%eax
  800489:	8b 00                	mov    (%eax),%eax
  80048b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80048e:	8b 45 14             	mov    0x14(%ebp),%eax
  800491:	8d 40 04             	lea    0x4(%eax),%eax
  800494:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800497:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80049a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049e:	79 91                	jns    800431 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004ad:	eb 82                	jmp    800431 <vprintfmt+0x35>
  8004af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b2:	85 c0                	test   %eax,%eax
  8004b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b9:	0f 49 d0             	cmovns %eax,%edx
  8004bc:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004c2:	e9 6a ff ff ff       	jmp    800431 <vprintfmt+0x35>
  8004c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004ca:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004d1:	e9 5b ff ff ff       	jmp    800431 <vprintfmt+0x35>
  8004d6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004dc:	eb bc                	jmp    80049a <vprintfmt+0x9e>
			lflag++;
  8004de:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004e4:	e9 48 ff ff ff       	jmp    800431 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ec:	8d 78 04             	lea    0x4(%eax),%edi
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	53                   	push   %ebx
  8004f3:	ff 30                	pushl  (%eax)
  8004f5:	ff d6                	call   *%esi
			break;
  8004f7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004fa:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004fd:	e9 cf 02 00 00       	jmp    8007d1 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800502:	8b 45 14             	mov    0x14(%ebp),%eax
  800505:	8d 78 04             	lea    0x4(%eax),%edi
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	99                   	cltd   
  80050b:	31 d0                	xor    %edx,%eax
  80050d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80050f:	83 f8 0f             	cmp    $0xf,%eax
  800512:	7f 23                	jg     800537 <vprintfmt+0x13b>
  800514:	8b 14 85 20 27 80 00 	mov    0x802720(,%eax,4),%edx
  80051b:	85 d2                	test   %edx,%edx
  80051d:	74 18                	je     800537 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80051f:	52                   	push   %edx
  800520:	68 f5 28 80 00       	push   $0x8028f5
  800525:	53                   	push   %ebx
  800526:	56                   	push   %esi
  800527:	e8 b3 fe ff ff       	call   8003df <printfmt>
  80052c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80052f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800532:	e9 9a 02 00 00       	jmp    8007d1 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800537:	50                   	push   %eax
  800538:	68 9b 24 80 00       	push   $0x80249b
  80053d:	53                   	push   %ebx
  80053e:	56                   	push   %esi
  80053f:	e8 9b fe ff ff       	call   8003df <printfmt>
  800544:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800547:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80054a:	e9 82 02 00 00       	jmp    8007d1 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	83 c0 04             	add    $0x4,%eax
  800555:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80055d:	85 ff                	test   %edi,%edi
  80055f:	b8 94 24 80 00       	mov    $0x802494,%eax
  800564:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800567:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80056b:	0f 8e bd 00 00 00    	jle    80062e <vprintfmt+0x232>
  800571:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800575:	75 0e                	jne    800585 <vprintfmt+0x189>
  800577:	89 75 08             	mov    %esi,0x8(%ebp)
  80057a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80057d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800580:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800583:	eb 6d                	jmp    8005f2 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 d0             	pushl  -0x30(%ebp)
  80058b:	57                   	push   %edi
  80058c:	e8 6e 03 00 00       	call   8008ff <strnlen>
  800591:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800594:	29 c1                	sub    %eax,%ecx
  800596:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800599:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80059c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005a6:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a8:	eb 0f                	jmp    8005b9 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	53                   	push   %ebx
  8005ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8005b1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b3:	83 ef 01             	sub    $0x1,%edi
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	85 ff                	test   %edi,%edi
  8005bb:	7f ed                	jg     8005aa <vprintfmt+0x1ae>
  8005bd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005c0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005c3:	85 c9                	test   %ecx,%ecx
  8005c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ca:	0f 49 c1             	cmovns %ecx,%eax
  8005cd:	29 c1                	sub    %eax,%ecx
  8005cf:	89 75 08             	mov    %esi,0x8(%ebp)
  8005d2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005d5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005d8:	89 cb                	mov    %ecx,%ebx
  8005da:	eb 16                	jmp    8005f2 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005e0:	75 31                	jne    800613 <vprintfmt+0x217>
					putch(ch, putdat);
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	ff 75 0c             	pushl  0xc(%ebp)
  8005e8:	50                   	push   %eax
  8005e9:	ff 55 08             	call   *0x8(%ebp)
  8005ec:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ef:	83 eb 01             	sub    $0x1,%ebx
  8005f2:	83 c7 01             	add    $0x1,%edi
  8005f5:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005f9:	0f be c2             	movsbl %dl,%eax
  8005fc:	85 c0                	test   %eax,%eax
  8005fe:	74 59                	je     800659 <vprintfmt+0x25d>
  800600:	85 f6                	test   %esi,%esi
  800602:	78 d8                	js     8005dc <vprintfmt+0x1e0>
  800604:	83 ee 01             	sub    $0x1,%esi
  800607:	79 d3                	jns    8005dc <vprintfmt+0x1e0>
  800609:	89 df                	mov    %ebx,%edi
  80060b:	8b 75 08             	mov    0x8(%ebp),%esi
  80060e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800611:	eb 37                	jmp    80064a <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800613:	0f be d2             	movsbl %dl,%edx
  800616:	83 ea 20             	sub    $0x20,%edx
  800619:	83 fa 5e             	cmp    $0x5e,%edx
  80061c:	76 c4                	jbe    8005e2 <vprintfmt+0x1e6>
					putch('?', putdat);
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	ff 75 0c             	pushl  0xc(%ebp)
  800624:	6a 3f                	push   $0x3f
  800626:	ff 55 08             	call   *0x8(%ebp)
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	eb c1                	jmp    8005ef <vprintfmt+0x1f3>
  80062e:	89 75 08             	mov    %esi,0x8(%ebp)
  800631:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800634:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800637:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80063a:	eb b6                	jmp    8005f2 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	53                   	push   %ebx
  800640:	6a 20                	push   $0x20
  800642:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800644:	83 ef 01             	sub    $0x1,%edi
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	85 ff                	test   %edi,%edi
  80064c:	7f ee                	jg     80063c <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80064e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800651:	89 45 14             	mov    %eax,0x14(%ebp)
  800654:	e9 78 01 00 00       	jmp    8007d1 <vprintfmt+0x3d5>
  800659:	89 df                	mov    %ebx,%edi
  80065b:	8b 75 08             	mov    0x8(%ebp),%esi
  80065e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800661:	eb e7                	jmp    80064a <vprintfmt+0x24e>
	if (lflag >= 2)
  800663:	83 f9 01             	cmp    $0x1,%ecx
  800666:	7e 3f                	jle    8006a7 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8b 50 04             	mov    0x4(%eax),%edx
  80066e:	8b 00                	mov    (%eax),%eax
  800670:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800673:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8d 40 08             	lea    0x8(%eax),%eax
  80067c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80067f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800683:	79 5c                	jns    8006e1 <vprintfmt+0x2e5>
				putch('-', putdat);
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	53                   	push   %ebx
  800689:	6a 2d                	push   $0x2d
  80068b:	ff d6                	call   *%esi
				num = -(long long) num;
  80068d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800690:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800693:	f7 da                	neg    %edx
  800695:	83 d1 00             	adc    $0x0,%ecx
  800698:	f7 d9                	neg    %ecx
  80069a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80069d:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a2:	e9 10 01 00 00       	jmp    8007b7 <vprintfmt+0x3bb>
	else if (lflag)
  8006a7:	85 c9                	test   %ecx,%ecx
  8006a9:	75 1b                	jne    8006c6 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b3:	89 c1                	mov    %eax,%ecx
  8006b5:	c1 f9 1f             	sar    $0x1f,%ecx
  8006b8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8d 40 04             	lea    0x4(%eax),%eax
  8006c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c4:	eb b9                	jmp    80067f <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ce:	89 c1                	mov    %eax,%ecx
  8006d0:	c1 f9 1f             	sar    $0x1f,%ecx
  8006d3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8d 40 04             	lea    0x4(%eax),%eax
  8006dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006df:	eb 9e                	jmp    80067f <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006e4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ec:	e9 c6 00 00 00       	jmp    8007b7 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8006f1:	83 f9 01             	cmp    $0x1,%ecx
  8006f4:	7e 18                	jle    80070e <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8b 10                	mov    (%eax),%edx
  8006fb:	8b 48 04             	mov    0x4(%eax),%ecx
  8006fe:	8d 40 08             	lea    0x8(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800704:	b8 0a 00 00 00       	mov    $0xa,%eax
  800709:	e9 a9 00 00 00       	jmp    8007b7 <vprintfmt+0x3bb>
	else if (lflag)
  80070e:	85 c9                	test   %ecx,%ecx
  800710:	75 1a                	jne    80072c <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8b 10                	mov    (%eax),%edx
  800717:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071c:	8d 40 04             	lea    0x4(%eax),%eax
  80071f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800722:	b8 0a 00 00 00       	mov    $0xa,%eax
  800727:	e9 8b 00 00 00       	jmp    8007b7 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 10                	mov    (%eax),%edx
  800731:	b9 00 00 00 00       	mov    $0x0,%ecx
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800741:	eb 74                	jmp    8007b7 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800743:	83 f9 01             	cmp    $0x1,%ecx
  800746:	7e 15                	jle    80075d <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8b 10                	mov    (%eax),%edx
  80074d:	8b 48 04             	mov    0x4(%eax),%ecx
  800750:	8d 40 08             	lea    0x8(%eax),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800756:	b8 08 00 00 00       	mov    $0x8,%eax
  80075b:	eb 5a                	jmp    8007b7 <vprintfmt+0x3bb>
	else if (lflag)
  80075d:	85 c9                	test   %ecx,%ecx
  80075f:	75 17                	jne    800778 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8b 10                	mov    (%eax),%edx
  800766:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076b:	8d 40 04             	lea    0x4(%eax),%eax
  80076e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800771:	b8 08 00 00 00       	mov    $0x8,%eax
  800776:	eb 3f                	jmp    8007b7 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 10                	mov    (%eax),%edx
  80077d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800782:	8d 40 04             	lea    0x4(%eax),%eax
  800785:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800788:	b8 08 00 00 00       	mov    $0x8,%eax
  80078d:	eb 28                	jmp    8007b7 <vprintfmt+0x3bb>
			putch('0', putdat);
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	53                   	push   %ebx
  800793:	6a 30                	push   $0x30
  800795:	ff d6                	call   *%esi
			putch('x', putdat);
  800797:	83 c4 08             	add    $0x8,%esp
  80079a:	53                   	push   %ebx
  80079b:	6a 78                	push   $0x78
  80079d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	8b 10                	mov    (%eax),%edx
  8007a4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007a9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007ac:	8d 40 04             	lea    0x4(%eax),%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007b7:	83 ec 0c             	sub    $0xc,%esp
  8007ba:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007be:	57                   	push   %edi
  8007bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	51                   	push   %ecx
  8007c4:	52                   	push   %edx
  8007c5:	89 da                	mov    %ebx,%edx
  8007c7:	89 f0                	mov    %esi,%eax
  8007c9:	e8 45 fb ff ff       	call   800313 <printnum>
			break;
  8007ce:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  8007d4:	83 c7 01             	add    $0x1,%edi
  8007d7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007db:	83 f8 25             	cmp    $0x25,%eax
  8007de:	0f 84 2f fc ff ff    	je     800413 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  8007e4:	85 c0                	test   %eax,%eax
  8007e6:	0f 84 8b 00 00 00    	je     800877 <vprintfmt+0x47b>
			putch(ch, putdat);
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	53                   	push   %ebx
  8007f0:	50                   	push   %eax
  8007f1:	ff d6                	call   *%esi
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	eb dc                	jmp    8007d4 <vprintfmt+0x3d8>
	if (lflag >= 2)
  8007f8:	83 f9 01             	cmp    $0x1,%ecx
  8007fb:	7e 15                	jle    800812 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	8b 10                	mov    (%eax),%edx
  800802:	8b 48 04             	mov    0x4(%eax),%ecx
  800805:	8d 40 08             	lea    0x8(%eax),%eax
  800808:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080b:	b8 10 00 00 00       	mov    $0x10,%eax
  800810:	eb a5                	jmp    8007b7 <vprintfmt+0x3bb>
	else if (lflag)
  800812:	85 c9                	test   %ecx,%ecx
  800814:	75 17                	jne    80082d <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	8b 10                	mov    (%eax),%edx
  80081b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800820:	8d 40 04             	lea    0x4(%eax),%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800826:	b8 10 00 00 00       	mov    $0x10,%eax
  80082b:	eb 8a                	jmp    8007b7 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8b 10                	mov    (%eax),%edx
  800832:	b9 00 00 00 00       	mov    $0x0,%ecx
  800837:	8d 40 04             	lea    0x4(%eax),%eax
  80083a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083d:	b8 10 00 00 00       	mov    $0x10,%eax
  800842:	e9 70 ff ff ff       	jmp    8007b7 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	53                   	push   %ebx
  80084b:	6a 25                	push   $0x25
  80084d:	ff d6                	call   *%esi
			break;
  80084f:	83 c4 10             	add    $0x10,%esp
  800852:	e9 7a ff ff ff       	jmp    8007d1 <vprintfmt+0x3d5>
			putch('%', putdat);
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	53                   	push   %ebx
  80085b:	6a 25                	push   $0x25
  80085d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	89 f8                	mov    %edi,%eax
  800864:	eb 03                	jmp    800869 <vprintfmt+0x46d>
  800866:	83 e8 01             	sub    $0x1,%eax
  800869:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80086d:	75 f7                	jne    800866 <vprintfmt+0x46a>
  80086f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800872:	e9 5a ff ff ff       	jmp    8007d1 <vprintfmt+0x3d5>
}
  800877:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80087a:	5b                   	pop    %ebx
  80087b:	5e                   	pop    %esi
  80087c:	5f                   	pop    %edi
  80087d:	5d                   	pop    %ebp
  80087e:	c3                   	ret    

0080087f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	83 ec 18             	sub    $0x18,%esp
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80088e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800892:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800895:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80089c:	85 c0                	test   %eax,%eax
  80089e:	74 26                	je     8008c6 <vsnprintf+0x47>
  8008a0:	85 d2                	test   %edx,%edx
  8008a2:	7e 22                	jle    8008c6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a4:	ff 75 14             	pushl  0x14(%ebp)
  8008a7:	ff 75 10             	pushl  0x10(%ebp)
  8008aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ad:	50                   	push   %eax
  8008ae:	68 c2 03 80 00       	push   $0x8003c2
  8008b3:	e8 44 fb ff ff       	call   8003fc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c1:	83 c4 10             	add    $0x10,%esp
}
  8008c4:	c9                   	leave  
  8008c5:	c3                   	ret    
		return -E_INVAL;
  8008c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008cb:	eb f7                	jmp    8008c4 <vsnprintf+0x45>

008008cd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d6:	50                   	push   %eax
  8008d7:	ff 75 10             	pushl  0x10(%ebp)
  8008da:	ff 75 0c             	pushl  0xc(%ebp)
  8008dd:	ff 75 08             	pushl  0x8(%ebp)
  8008e0:	e8 9a ff ff ff       	call   80087f <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e5:	c9                   	leave  
  8008e6:	c3                   	ret    

008008e7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f2:	eb 03                	jmp    8008f7 <strlen+0x10>
		n++;
  8008f4:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008f7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008fb:	75 f7                	jne    8008f4 <strlen+0xd>
	return n;
}
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800905:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800908:	b8 00 00 00 00       	mov    $0x0,%eax
  80090d:	eb 03                	jmp    800912 <strnlen+0x13>
		n++;
  80090f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800912:	39 d0                	cmp    %edx,%eax
  800914:	74 06                	je     80091c <strnlen+0x1d>
  800916:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80091a:	75 f3                	jne    80090f <strnlen+0x10>
	return n;
}
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	53                   	push   %ebx
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800928:	89 c2                	mov    %eax,%edx
  80092a:	83 c1 01             	add    $0x1,%ecx
  80092d:	83 c2 01             	add    $0x1,%edx
  800930:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800934:	88 5a ff             	mov    %bl,-0x1(%edx)
  800937:	84 db                	test   %bl,%bl
  800939:	75 ef                	jne    80092a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80093b:	5b                   	pop    %ebx
  80093c:	5d                   	pop    %ebp
  80093d:	c3                   	ret    

0080093e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	53                   	push   %ebx
  800942:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800945:	53                   	push   %ebx
  800946:	e8 9c ff ff ff       	call   8008e7 <strlen>
  80094b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	01 d8                	add    %ebx,%eax
  800953:	50                   	push   %eax
  800954:	e8 c5 ff ff ff       	call   80091e <strcpy>
	return dst;
}
  800959:	89 d8                	mov    %ebx,%eax
  80095b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	56                   	push   %esi
  800964:	53                   	push   %ebx
  800965:	8b 75 08             	mov    0x8(%ebp),%esi
  800968:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80096b:	89 f3                	mov    %esi,%ebx
  80096d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800970:	89 f2                	mov    %esi,%edx
  800972:	eb 0f                	jmp    800983 <strncpy+0x23>
		*dst++ = *src;
  800974:	83 c2 01             	add    $0x1,%edx
  800977:	0f b6 01             	movzbl (%ecx),%eax
  80097a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80097d:	80 39 01             	cmpb   $0x1,(%ecx)
  800980:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800983:	39 da                	cmp    %ebx,%edx
  800985:	75 ed                	jne    800974 <strncpy+0x14>
	}
	return ret;
}
  800987:	89 f0                	mov    %esi,%eax
  800989:	5b                   	pop    %ebx
  80098a:	5e                   	pop    %esi
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	56                   	push   %esi
  800991:	53                   	push   %ebx
  800992:	8b 75 08             	mov    0x8(%ebp),%esi
  800995:	8b 55 0c             	mov    0xc(%ebp),%edx
  800998:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80099b:	89 f0                	mov    %esi,%eax
  80099d:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009a1:	85 c9                	test   %ecx,%ecx
  8009a3:	75 0b                	jne    8009b0 <strlcpy+0x23>
  8009a5:	eb 17                	jmp    8009be <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009a7:	83 c2 01             	add    $0x1,%edx
  8009aa:	83 c0 01             	add    $0x1,%eax
  8009ad:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009b0:	39 d8                	cmp    %ebx,%eax
  8009b2:	74 07                	je     8009bb <strlcpy+0x2e>
  8009b4:	0f b6 0a             	movzbl (%edx),%ecx
  8009b7:	84 c9                	test   %cl,%cl
  8009b9:	75 ec                	jne    8009a7 <strlcpy+0x1a>
		*dst = '\0';
  8009bb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009be:	29 f0                	sub    %esi,%eax
}
  8009c0:	5b                   	pop    %ebx
  8009c1:	5e                   	pop    %esi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ca:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009cd:	eb 06                	jmp    8009d5 <strcmp+0x11>
		p++, q++;
  8009cf:	83 c1 01             	add    $0x1,%ecx
  8009d2:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009d5:	0f b6 01             	movzbl (%ecx),%eax
  8009d8:	84 c0                	test   %al,%al
  8009da:	74 04                	je     8009e0 <strcmp+0x1c>
  8009dc:	3a 02                	cmp    (%edx),%al
  8009de:	74 ef                	je     8009cf <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e0:	0f b6 c0             	movzbl %al,%eax
  8009e3:	0f b6 12             	movzbl (%edx),%edx
  8009e6:	29 d0                	sub    %edx,%eax
}
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	53                   	push   %ebx
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f4:	89 c3                	mov    %eax,%ebx
  8009f6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009f9:	eb 06                	jmp    800a01 <strncmp+0x17>
		n--, p++, q++;
  8009fb:	83 c0 01             	add    $0x1,%eax
  8009fe:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a01:	39 d8                	cmp    %ebx,%eax
  800a03:	74 16                	je     800a1b <strncmp+0x31>
  800a05:	0f b6 08             	movzbl (%eax),%ecx
  800a08:	84 c9                	test   %cl,%cl
  800a0a:	74 04                	je     800a10 <strncmp+0x26>
  800a0c:	3a 0a                	cmp    (%edx),%cl
  800a0e:	74 eb                	je     8009fb <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a10:	0f b6 00             	movzbl (%eax),%eax
  800a13:	0f b6 12             	movzbl (%edx),%edx
  800a16:	29 d0                	sub    %edx,%eax
}
  800a18:	5b                   	pop    %ebx
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    
		return 0;
  800a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a20:	eb f6                	jmp    800a18 <strncmp+0x2e>

00800a22 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a2c:	0f b6 10             	movzbl (%eax),%edx
  800a2f:	84 d2                	test   %dl,%dl
  800a31:	74 09                	je     800a3c <strchr+0x1a>
		if (*s == c)
  800a33:	38 ca                	cmp    %cl,%dl
  800a35:	74 0a                	je     800a41 <strchr+0x1f>
	for (; *s; s++)
  800a37:	83 c0 01             	add    $0x1,%eax
  800a3a:	eb f0                	jmp    800a2c <strchr+0xa>
			return (char *) s;
	return 0;
  800a3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4d:	eb 03                	jmp    800a52 <strfind+0xf>
  800a4f:	83 c0 01             	add    $0x1,%eax
  800a52:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a55:	38 ca                	cmp    %cl,%dl
  800a57:	74 04                	je     800a5d <strfind+0x1a>
  800a59:	84 d2                	test   %dl,%dl
  800a5b:	75 f2                	jne    800a4f <strfind+0xc>
			break;
	return (char *) s;
}
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	57                   	push   %edi
  800a63:	56                   	push   %esi
  800a64:	53                   	push   %ebx
  800a65:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a68:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a6b:	85 c9                	test   %ecx,%ecx
  800a6d:	74 13                	je     800a82 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a6f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a75:	75 05                	jne    800a7c <memset+0x1d>
  800a77:	f6 c1 03             	test   $0x3,%cl
  800a7a:	74 0d                	je     800a89 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7f:	fc                   	cld    
  800a80:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a82:	89 f8                	mov    %edi,%eax
  800a84:	5b                   	pop    %ebx
  800a85:	5e                   	pop    %esi
  800a86:	5f                   	pop    %edi
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    
		c &= 0xFF;
  800a89:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a8d:	89 d3                	mov    %edx,%ebx
  800a8f:	c1 e3 08             	shl    $0x8,%ebx
  800a92:	89 d0                	mov    %edx,%eax
  800a94:	c1 e0 18             	shl    $0x18,%eax
  800a97:	89 d6                	mov    %edx,%esi
  800a99:	c1 e6 10             	shl    $0x10,%esi
  800a9c:	09 f0                	or     %esi,%eax
  800a9e:	09 c2                	or     %eax,%edx
  800aa0:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800aa2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aa5:	89 d0                	mov    %edx,%eax
  800aa7:	fc                   	cld    
  800aa8:	f3 ab                	rep stos %eax,%es:(%edi)
  800aaa:	eb d6                	jmp    800a82 <memset+0x23>

00800aac <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	57                   	push   %edi
  800ab0:	56                   	push   %esi
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ab7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aba:	39 c6                	cmp    %eax,%esi
  800abc:	73 35                	jae    800af3 <memmove+0x47>
  800abe:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac1:	39 c2                	cmp    %eax,%edx
  800ac3:	76 2e                	jbe    800af3 <memmove+0x47>
		s += n;
		d += n;
  800ac5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac8:	89 d6                	mov    %edx,%esi
  800aca:	09 fe                	or     %edi,%esi
  800acc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ad2:	74 0c                	je     800ae0 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad4:	83 ef 01             	sub    $0x1,%edi
  800ad7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ada:	fd                   	std    
  800adb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800add:	fc                   	cld    
  800ade:	eb 21                	jmp    800b01 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae0:	f6 c1 03             	test   $0x3,%cl
  800ae3:	75 ef                	jne    800ad4 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ae5:	83 ef 04             	sub    $0x4,%edi
  800ae8:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aeb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aee:	fd                   	std    
  800aef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af1:	eb ea                	jmp    800add <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af3:	89 f2                	mov    %esi,%edx
  800af5:	09 c2                	or     %eax,%edx
  800af7:	f6 c2 03             	test   $0x3,%dl
  800afa:	74 09                	je     800b05 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800afc:	89 c7                	mov    %eax,%edi
  800afe:	fc                   	cld    
  800aff:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b01:	5e                   	pop    %esi
  800b02:	5f                   	pop    %edi
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b05:	f6 c1 03             	test   $0x3,%cl
  800b08:	75 f2                	jne    800afc <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b0a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b0d:	89 c7                	mov    %eax,%edi
  800b0f:	fc                   	cld    
  800b10:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b12:	eb ed                	jmp    800b01 <memmove+0x55>

00800b14 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b17:	ff 75 10             	pushl  0x10(%ebp)
  800b1a:	ff 75 0c             	pushl  0xc(%ebp)
  800b1d:	ff 75 08             	pushl  0x8(%ebp)
  800b20:	e8 87 ff ff ff       	call   800aac <memmove>
}
  800b25:	c9                   	leave  
  800b26:	c3                   	ret    

00800b27 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	56                   	push   %esi
  800b2b:	53                   	push   %ebx
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b32:	89 c6                	mov    %eax,%esi
  800b34:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b37:	39 f0                	cmp    %esi,%eax
  800b39:	74 1c                	je     800b57 <memcmp+0x30>
		if (*s1 != *s2)
  800b3b:	0f b6 08             	movzbl (%eax),%ecx
  800b3e:	0f b6 1a             	movzbl (%edx),%ebx
  800b41:	38 d9                	cmp    %bl,%cl
  800b43:	75 08                	jne    800b4d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b45:	83 c0 01             	add    $0x1,%eax
  800b48:	83 c2 01             	add    $0x1,%edx
  800b4b:	eb ea                	jmp    800b37 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b4d:	0f b6 c1             	movzbl %cl,%eax
  800b50:	0f b6 db             	movzbl %bl,%ebx
  800b53:	29 d8                	sub    %ebx,%eax
  800b55:	eb 05                	jmp    800b5c <memcmp+0x35>
	}

	return 0;
  800b57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b5c:	5b                   	pop    %ebx
  800b5d:	5e                   	pop    %esi
  800b5e:	5d                   	pop    %ebp
  800b5f:	c3                   	ret    

00800b60 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b69:	89 c2                	mov    %eax,%edx
  800b6b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b6e:	39 d0                	cmp    %edx,%eax
  800b70:	73 09                	jae    800b7b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b72:	38 08                	cmp    %cl,(%eax)
  800b74:	74 05                	je     800b7b <memfind+0x1b>
	for (; s < ends; s++)
  800b76:	83 c0 01             	add    $0x1,%eax
  800b79:	eb f3                	jmp    800b6e <memfind+0xe>
			break;
	return (void *) s;
}
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	57                   	push   %edi
  800b81:	56                   	push   %esi
  800b82:	53                   	push   %ebx
  800b83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b86:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b89:	eb 03                	jmp    800b8e <strtol+0x11>
		s++;
  800b8b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b8e:	0f b6 01             	movzbl (%ecx),%eax
  800b91:	3c 20                	cmp    $0x20,%al
  800b93:	74 f6                	je     800b8b <strtol+0xe>
  800b95:	3c 09                	cmp    $0x9,%al
  800b97:	74 f2                	je     800b8b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b99:	3c 2b                	cmp    $0x2b,%al
  800b9b:	74 2e                	je     800bcb <strtol+0x4e>
	int neg = 0;
  800b9d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ba2:	3c 2d                	cmp    $0x2d,%al
  800ba4:	74 2f                	je     800bd5 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bac:	75 05                	jne    800bb3 <strtol+0x36>
  800bae:	80 39 30             	cmpb   $0x30,(%ecx)
  800bb1:	74 2c                	je     800bdf <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb3:	85 db                	test   %ebx,%ebx
  800bb5:	75 0a                	jne    800bc1 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb7:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800bbc:	80 39 30             	cmpb   $0x30,(%ecx)
  800bbf:	74 28                	je     800be9 <strtol+0x6c>
		base = 10;
  800bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bc9:	eb 50                	jmp    800c1b <strtol+0x9e>
		s++;
  800bcb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bce:	bf 00 00 00 00       	mov    $0x0,%edi
  800bd3:	eb d1                	jmp    800ba6 <strtol+0x29>
		s++, neg = 1;
  800bd5:	83 c1 01             	add    $0x1,%ecx
  800bd8:	bf 01 00 00 00       	mov    $0x1,%edi
  800bdd:	eb c7                	jmp    800ba6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bdf:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800be3:	74 0e                	je     800bf3 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800be5:	85 db                	test   %ebx,%ebx
  800be7:	75 d8                	jne    800bc1 <strtol+0x44>
		s++, base = 8;
  800be9:	83 c1 01             	add    $0x1,%ecx
  800bec:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bf1:	eb ce                	jmp    800bc1 <strtol+0x44>
		s += 2, base = 16;
  800bf3:	83 c1 02             	add    $0x2,%ecx
  800bf6:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bfb:	eb c4                	jmp    800bc1 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bfd:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c00:	89 f3                	mov    %esi,%ebx
  800c02:	80 fb 19             	cmp    $0x19,%bl
  800c05:	77 29                	ja     800c30 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c07:	0f be d2             	movsbl %dl,%edx
  800c0a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c0d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c10:	7d 30                	jge    800c42 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c12:	83 c1 01             	add    $0x1,%ecx
  800c15:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c19:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c1b:	0f b6 11             	movzbl (%ecx),%edx
  800c1e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c21:	89 f3                	mov    %esi,%ebx
  800c23:	80 fb 09             	cmp    $0x9,%bl
  800c26:	77 d5                	ja     800bfd <strtol+0x80>
			dig = *s - '0';
  800c28:	0f be d2             	movsbl %dl,%edx
  800c2b:	83 ea 30             	sub    $0x30,%edx
  800c2e:	eb dd                	jmp    800c0d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c30:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c33:	89 f3                	mov    %esi,%ebx
  800c35:	80 fb 19             	cmp    $0x19,%bl
  800c38:	77 08                	ja     800c42 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c3a:	0f be d2             	movsbl %dl,%edx
  800c3d:	83 ea 37             	sub    $0x37,%edx
  800c40:	eb cb                	jmp    800c0d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c46:	74 05                	je     800c4d <strtol+0xd0>
		*endptr = (char *) s;
  800c48:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c4b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c4d:	89 c2                	mov    %eax,%edx
  800c4f:	f7 da                	neg    %edx
  800c51:	85 ff                	test   %edi,%edi
  800c53:	0f 45 c2             	cmovne %edx,%eax
}
  800c56:	5b                   	pop    %ebx
  800c57:	5e                   	pop    %esi
  800c58:	5f                   	pop    %edi
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	57                   	push   %edi
  800c5f:	56                   	push   %esi
  800c60:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c61:	b8 00 00 00 00       	mov    $0x0,%eax
  800c66:	8b 55 08             	mov    0x8(%ebp),%edx
  800c69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6c:	89 c3                	mov    %eax,%ebx
  800c6e:	89 c7                	mov    %eax,%edi
  800c70:	89 c6                	mov    %eax,%esi
  800c72:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c74:	5b                   	pop    %ebx
  800c75:	5e                   	pop    %esi
  800c76:	5f                   	pop    %edi
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    

00800c79 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	57                   	push   %edi
  800c7d:	56                   	push   %esi
  800c7e:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800c7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c84:	b8 01 00 00 00       	mov    $0x1,%eax
  800c89:	89 d1                	mov    %edx,%ecx
  800c8b:	89 d3                	mov    %edx,%ebx
  800c8d:	89 d7                	mov    %edx,%edi
  800c8f:	89 d6                	mov    %edx,%esi
  800c91:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5f                   	pop    %edi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	57                   	push   %edi
  800c9c:	56                   	push   %esi
  800c9d:	53                   	push   %ebx
  800c9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ca1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca9:	b8 03 00 00 00       	mov    $0x3,%eax
  800cae:	89 cb                	mov    %ecx,%ebx
  800cb0:	89 cf                	mov    %ecx,%edi
  800cb2:	89 ce                	mov    %ecx,%esi
  800cb4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb6:	85 c0                	test   %eax,%eax
  800cb8:	7f 08                	jg     800cc2 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbd:	5b                   	pop    %ebx
  800cbe:	5e                   	pop    %esi
  800cbf:	5f                   	pop    %edi
  800cc0:	5d                   	pop    %ebp
  800cc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc2:	83 ec 0c             	sub    $0xc,%esp
  800cc5:	50                   	push   %eax
  800cc6:	6a 03                	push   $0x3
  800cc8:	68 7f 27 80 00       	push   $0x80277f
  800ccd:	6a 23                	push   $0x23
  800ccf:	68 9c 27 80 00       	push   $0x80279c
  800cd4:	e8 4b f5 ff ff       	call   800224 <_panic>

00800cd9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	57                   	push   %edi
  800cdd:	56                   	push   %esi
  800cde:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800cdf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce4:	b8 02 00 00 00       	mov    $0x2,%eax
  800ce9:	89 d1                	mov    %edx,%ecx
  800ceb:	89 d3                	mov    %edx,%ebx
  800ced:	89 d7                	mov    %edx,%edi
  800cef:	89 d6                	mov    %edx,%esi
  800cf1:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cf3:	5b                   	pop    %ebx
  800cf4:	5e                   	pop    %esi
  800cf5:	5f                   	pop    %edi
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <sys_yield>:

void
sys_yield(void)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	57                   	push   %edi
  800cfc:	56                   	push   %esi
  800cfd:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800cfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800d03:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d08:	89 d1                	mov    %edx,%ecx
  800d0a:	89 d3                	mov    %edx,%ebx
  800d0c:	89 d7                	mov    %edx,%edi
  800d0e:	89 d6                	mov    %edx,%esi
  800d10:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
  800d1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d20:	be 00 00 00 00       	mov    $0x0,%esi
  800d25:	8b 55 08             	mov    0x8(%ebp),%edx
  800d28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2b:	b8 04 00 00 00       	mov    $0x4,%eax
  800d30:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d33:	89 f7                	mov    %esi,%edi
  800d35:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d37:	85 c0                	test   %eax,%eax
  800d39:	7f 08                	jg     800d43 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d43:	83 ec 0c             	sub    $0xc,%esp
  800d46:	50                   	push   %eax
  800d47:	6a 04                	push   $0x4
  800d49:	68 7f 27 80 00       	push   $0x80277f
  800d4e:	6a 23                	push   $0x23
  800d50:	68 9c 27 80 00       	push   $0x80279c
  800d55:	e8 ca f4 ff ff       	call   800224 <_panic>

00800d5a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	57                   	push   %edi
  800d5e:	56                   	push   %esi
  800d5f:	53                   	push   %ebx
  800d60:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d63:	8b 55 08             	mov    0x8(%ebp),%edx
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	b8 05 00 00 00       	mov    $0x5,%eax
  800d6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d71:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d74:	8b 75 18             	mov    0x18(%ebp),%esi
  800d77:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d79:	85 c0                	test   %eax,%eax
  800d7b:	7f 08                	jg     800d85 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d85:	83 ec 0c             	sub    $0xc,%esp
  800d88:	50                   	push   %eax
  800d89:	6a 05                	push   $0x5
  800d8b:	68 7f 27 80 00       	push   $0x80277f
  800d90:	6a 23                	push   $0x23
  800d92:	68 9c 27 80 00       	push   $0x80279c
  800d97:	e8 88 f4 ff ff       	call   800224 <_panic>

00800d9c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	57                   	push   %edi
  800da0:	56                   	push   %esi
  800da1:	53                   	push   %ebx
  800da2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800da5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800daa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db0:	b8 06 00 00 00       	mov    $0x6,%eax
  800db5:	89 df                	mov    %ebx,%edi
  800db7:	89 de                	mov    %ebx,%esi
  800db9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbb:	85 c0                	test   %eax,%eax
  800dbd:	7f 08                	jg     800dc7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc2:	5b                   	pop    %ebx
  800dc3:	5e                   	pop    %esi
  800dc4:	5f                   	pop    %edi
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc7:	83 ec 0c             	sub    $0xc,%esp
  800dca:	50                   	push   %eax
  800dcb:	6a 06                	push   $0x6
  800dcd:	68 7f 27 80 00       	push   $0x80277f
  800dd2:	6a 23                	push   $0x23
  800dd4:	68 9c 27 80 00       	push   $0x80279c
  800dd9:	e8 46 f4 ff ff       	call   800224 <_panic>

00800dde <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	57                   	push   %edi
  800de2:	56                   	push   %esi
  800de3:	53                   	push   %ebx
  800de4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800de7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dec:	8b 55 08             	mov    0x8(%ebp),%edx
  800def:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df2:	b8 08 00 00 00       	mov    $0x8,%eax
  800df7:	89 df                	mov    %ebx,%edi
  800df9:	89 de                	mov    %ebx,%esi
  800dfb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfd:	85 c0                	test   %eax,%eax
  800dff:	7f 08                	jg     800e09 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e04:	5b                   	pop    %ebx
  800e05:	5e                   	pop    %esi
  800e06:	5f                   	pop    %edi
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e09:	83 ec 0c             	sub    $0xc,%esp
  800e0c:	50                   	push   %eax
  800e0d:	6a 08                	push   $0x8
  800e0f:	68 7f 27 80 00       	push   $0x80277f
  800e14:	6a 23                	push   $0x23
  800e16:	68 9c 27 80 00       	push   $0x80279c
  800e1b:	e8 04 f4 ff ff       	call   800224 <_panic>

00800e20 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	57                   	push   %edi
  800e24:	56                   	push   %esi
  800e25:	53                   	push   %ebx
  800e26:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e29:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e34:	b8 09 00 00 00       	mov    $0x9,%eax
  800e39:	89 df                	mov    %ebx,%edi
  800e3b:	89 de                	mov    %ebx,%esi
  800e3d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3f:	85 c0                	test   %eax,%eax
  800e41:	7f 08                	jg     800e4b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e46:	5b                   	pop    %ebx
  800e47:	5e                   	pop    %esi
  800e48:	5f                   	pop    %edi
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4b:	83 ec 0c             	sub    $0xc,%esp
  800e4e:	50                   	push   %eax
  800e4f:	6a 09                	push   $0x9
  800e51:	68 7f 27 80 00       	push   $0x80277f
  800e56:	6a 23                	push   $0x23
  800e58:	68 9c 27 80 00       	push   $0x80279c
  800e5d:	e8 c2 f3 ff ff       	call   800224 <_panic>

00800e62 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	57                   	push   %edi
  800e66:	56                   	push   %esi
  800e67:	53                   	push   %ebx
  800e68:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e6b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e70:	8b 55 08             	mov    0x8(%ebp),%edx
  800e73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e76:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e7b:	89 df                	mov    %ebx,%edi
  800e7d:	89 de                	mov    %ebx,%esi
  800e7f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e81:	85 c0                	test   %eax,%eax
  800e83:	7f 08                	jg     800e8d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e88:	5b                   	pop    %ebx
  800e89:	5e                   	pop    %esi
  800e8a:	5f                   	pop    %edi
  800e8b:	5d                   	pop    %ebp
  800e8c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8d:	83 ec 0c             	sub    $0xc,%esp
  800e90:	50                   	push   %eax
  800e91:	6a 0a                	push   $0xa
  800e93:	68 7f 27 80 00       	push   $0x80277f
  800e98:	6a 23                	push   $0x23
  800e9a:	68 9c 27 80 00       	push   $0x80279c
  800e9f:	e8 80 f3 ff ff       	call   800224 <_panic>

00800ea4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	57                   	push   %edi
  800ea8:	56                   	push   %esi
  800ea9:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800eaa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ead:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb0:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eb5:	be 00 00 00 00       	mov    $0x0,%esi
  800eba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec2:	5b                   	pop    %ebx
  800ec3:	5e                   	pop    %esi
  800ec4:	5f                   	pop    %edi
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    

00800ec7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	57                   	push   %edi
  800ecb:	56                   	push   %esi
  800ecc:	53                   	push   %ebx
  800ecd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ed0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	b8 0d 00 00 00       	mov    $0xd,%eax
  800edd:	89 cb                	mov    %ecx,%ebx
  800edf:	89 cf                	mov    %ecx,%edi
  800ee1:	89 ce                	mov    %ecx,%esi
  800ee3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee5:	85 c0                	test   %eax,%eax
  800ee7:	7f 08                	jg     800ef1 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ee9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eec:	5b                   	pop    %ebx
  800eed:	5e                   	pop    %esi
  800eee:	5f                   	pop    %edi
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef1:	83 ec 0c             	sub    $0xc,%esp
  800ef4:	50                   	push   %eax
  800ef5:	6a 0d                	push   $0xd
  800ef7:	68 7f 27 80 00       	push   $0x80277f
  800efc:	6a 23                	push   $0x23
  800efe:	68 9c 27 80 00       	push   $0x80279c
  800f03:	e8 1c f3 ff ff       	call   800224 <_panic>

00800f08 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	53                   	push   %ebx
  800f0c:	83 ec 04             	sub    $0x4,%esp
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f12:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) { //只有因为写操作写时拷贝的地址这中情况，才可以抢救。否则一律panic
  800f14:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f18:	74 74                	je     800f8e <pgfault+0x86>
  800f1a:	89 d8                	mov    %ebx,%eax
  800f1c:	c1 e8 0c             	shr    $0xc,%eax
  800f1f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f26:	f6 c4 08             	test   $0x8,%ah
  800f29:	74 63                	je     800f8e <pgfault+0x86>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800f2b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, PFTEMP, PTE_U|PTE_P)) < 0)		//将当前进程PFTEMP也映射到当前进程addr指向的物理页
  800f31:	83 ec 0c             	sub    $0xc,%esp
  800f34:	6a 05                	push   $0x5
  800f36:	68 00 f0 7f 00       	push   $0x7ff000
  800f3b:	6a 00                	push   $0x0
  800f3d:	53                   	push   %ebx
  800f3e:	6a 00                	push   $0x0
  800f40:	e8 15 fe ff ff       	call   800d5a <sys_page_map>
  800f45:	83 c4 20             	add    $0x20,%esp
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	78 56                	js     800fa2 <pgfault+0x9a>
		panic("sys_page_map: %e", r);
	if ((r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W)) < 0)	//令当前进程addr指向新分配的物理页
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	6a 07                	push   $0x7
  800f51:	53                   	push   %ebx
  800f52:	6a 00                	push   $0x0
  800f54:	e8 be fd ff ff       	call   800d17 <sys_page_alloc>
  800f59:	83 c4 10             	add    $0x10,%esp
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	78 54                	js     800fb4 <pgfault+0xac>
		panic("sys_page_alloc: %e", r);
	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800f60:	83 ec 04             	sub    $0x4,%esp
  800f63:	68 00 10 00 00       	push   $0x1000
  800f68:	68 00 f0 7f 00       	push   $0x7ff000
  800f6d:	53                   	push   %ebx
  800f6e:	e8 39 fb ff ff       	call   800aac <memmove>
	if ((r = sys_page_unmap(0, PFTEMP)) < 0)					//解除当前进程PFTEMP映射
  800f73:	83 c4 08             	add    $0x8,%esp
  800f76:	68 00 f0 7f 00       	push   $0x7ff000
  800f7b:	6a 00                	push   $0x0
  800f7d:	e8 1a fe ff ff       	call   800d9c <sys_page_unmap>
  800f82:	83 c4 10             	add    $0x10,%esp
  800f85:	85 c0                	test   %eax,%eax
  800f87:	78 3d                	js     800fc6 <pgfault+0xbe>
		panic("sys_page_unmap: %e", r);
}
  800f89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    
		panic("pgfault():not cow");
  800f8e:	83 ec 04             	sub    $0x4,%esp
  800f91:	68 aa 27 80 00       	push   $0x8027aa
  800f96:	6a 1d                	push   $0x1d
  800f98:	68 bc 27 80 00       	push   $0x8027bc
  800f9d:	e8 82 f2 ff ff       	call   800224 <_panic>
		panic("sys_page_map: %e", r);
  800fa2:	50                   	push   %eax
  800fa3:	68 c7 27 80 00       	push   $0x8027c7
  800fa8:	6a 2a                	push   $0x2a
  800faa:	68 bc 27 80 00       	push   $0x8027bc
  800faf:	e8 70 f2 ff ff       	call   800224 <_panic>
		panic("sys_page_alloc: %e", r);
  800fb4:	50                   	push   %eax
  800fb5:	68 d8 27 80 00       	push   $0x8027d8
  800fba:	6a 2c                	push   $0x2c
  800fbc:	68 bc 27 80 00       	push   $0x8027bc
  800fc1:	e8 5e f2 ff ff       	call   800224 <_panic>
		panic("sys_page_unmap: %e", r);
  800fc6:	50                   	push   %eax
  800fc7:	68 eb 27 80 00       	push   $0x8027eb
  800fcc:	6a 2f                	push   $0x2f
  800fce:	68 bc 27 80 00       	push   $0x8027bc
  800fd3:	e8 4c f2 ff ff       	call   800224 <_panic>

00800fd8 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	57                   	push   %edi
  800fdc:	56                   	push   %esi
  800fdd:	53                   	push   %ebx
  800fde:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);	//设置缺页处理函数
  800fe1:	68 08 0f 80 00       	push   $0x800f08
  800fe6:	e8 2c 0f 00 00       	call   801f17 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800feb:	b8 07 00 00 00       	mov    $0x7,%eax
  800ff0:	cd 30                	int    $0x30
  800ff2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();	//系统调用，只是简单创建一个Env结构，复制当前用户环境寄存器状态，UTOP以下的页目录还没有建立
	if (envid == 0) {				//子进程将走这个逻辑
  800ff5:	83 c4 10             	add    $0x10,%esp
  800ff8:	85 c0                	test   %eax,%eax
  800ffa:	74 12                	je     80100e <fork+0x36>
  800ffc:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	if (envid < 0) {
  800ffe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801002:	78 26                	js     80102a <fork+0x52>
		panic("sys_exofork: %e", envid);
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801004:	bb 00 00 00 00       	mov    $0x0,%ebx
  801009:	e9 94 00 00 00       	jmp    8010a2 <fork+0xca>
		thisenv = &envs[ENVX(sys_getenvid())];
  80100e:	e8 c6 fc ff ff       	call   800cd9 <sys_getenvid>
  801013:	25 ff 03 00 00       	and    $0x3ff,%eax
  801018:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80101b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801020:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  801025:	e9 51 01 00 00       	jmp    80117b <fork+0x1a3>
		panic("sys_exofork: %e", envid);
  80102a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80102d:	68 fe 27 80 00       	push   $0x8027fe
  801032:	6a 6d                	push   $0x6d
  801034:	68 bc 27 80 00       	push   $0x8027bc
  801039:	e8 e6 f1 ff ff       	call   800224 <_panic>
		sys_page_map(0, addr, envid, addr, PTE_SYSCALL);		//对于表示为PTE_SHARE的页，拷贝映射关系，并且两个进程都有读写权限
  80103e:	83 ec 0c             	sub    $0xc,%esp
  801041:	68 07 0e 00 00       	push   $0xe07
  801046:	56                   	push   %esi
  801047:	57                   	push   %edi
  801048:	56                   	push   %esi
  801049:	6a 00                	push   $0x0
  80104b:	e8 0a fd ff ff       	call   800d5a <sys_page_map>
  801050:	83 c4 20             	add    $0x20,%esp
  801053:	eb 3b                	jmp    801090 <fork+0xb8>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  801055:	83 ec 0c             	sub    $0xc,%esp
  801058:	68 05 08 00 00       	push   $0x805
  80105d:	56                   	push   %esi
  80105e:	57                   	push   %edi
  80105f:	56                   	push   %esi
  801060:	6a 00                	push   $0x0
  801062:	e8 f3 fc ff ff       	call   800d5a <sys_page_map>
  801067:	83 c4 20             	add    $0x20,%esp
  80106a:	85 c0                	test   %eax,%eax
  80106c:	0f 88 a9 00 00 00    	js     80111b <fork+0x143>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  801072:	83 ec 0c             	sub    $0xc,%esp
  801075:	68 05 08 00 00       	push   $0x805
  80107a:	56                   	push   %esi
  80107b:	6a 00                	push   $0x0
  80107d:	56                   	push   %esi
  80107e:	6a 00                	push   $0x0
  801080:	e8 d5 fc ff ff       	call   800d5a <sys_page_map>
  801085:	83 c4 20             	add    $0x20,%esp
  801088:	85 c0                	test   %eax,%eax
  80108a:	0f 88 9d 00 00 00    	js     80112d <fork+0x155>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801090:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801096:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80109c:	0f 84 9d 00 00 00    	je     80113f <fork+0x167>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) //为什么uvpt[pagenumber]能访问到第pagenumber项页表条目：https://pdos.csail.mit.edu/6.828/2018/labs/lab4/uvpt.html
  8010a2:	89 d8                	mov    %ebx,%eax
  8010a4:	c1 e8 16             	shr    $0x16,%eax
  8010a7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010ae:	a8 01                	test   $0x1,%al
  8010b0:	74 de                	je     801090 <fork+0xb8>
  8010b2:	89 d8                	mov    %ebx,%eax
  8010b4:	c1 e8 0c             	shr    $0xc,%eax
  8010b7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010be:	f6 c2 01             	test   $0x1,%dl
  8010c1:	74 cd                	je     801090 <fork+0xb8>
			&& (uvpt[PGNUM(addr)] & PTE_U)) {
  8010c3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010ca:	f6 c2 04             	test   $0x4,%dl
  8010cd:	74 c1                	je     801090 <fork+0xb8>
	void *addr = (void*) (pn * PGSIZE);
  8010cf:	89 c6                	mov    %eax,%esi
  8010d1:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE) {
  8010d4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010db:	f6 c6 04             	test   $0x4,%dh
  8010de:	0f 85 5a ff ff ff    	jne    80103e <fork+0x66>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) { //对于UTOP以下的可写的或者写时拷贝的页，拷贝映射关系的同时，需要同时标记当前进程和子进程的页表项为PTE_COW
  8010e4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010eb:	f6 c2 02             	test   $0x2,%dl
  8010ee:	0f 85 61 ff ff ff    	jne    801055 <fork+0x7d>
  8010f4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010fb:	f6 c4 08             	test   $0x8,%ah
  8010fe:	0f 85 51 ff ff ff    	jne    801055 <fork+0x7d>
		sys_page_map(0, addr, envid, addr, PTE_U|PTE_P);	//对于只读的页，只需要拷贝映射关系即可
  801104:	83 ec 0c             	sub    $0xc,%esp
  801107:	6a 05                	push   $0x5
  801109:	56                   	push   %esi
  80110a:	57                   	push   %edi
  80110b:	56                   	push   %esi
  80110c:	6a 00                	push   $0x0
  80110e:	e8 47 fc ff ff       	call   800d5a <sys_page_map>
  801113:	83 c4 20             	add    $0x20,%esp
  801116:	e9 75 ff ff ff       	jmp    801090 <fork+0xb8>
			panic("sys_page_map：%e", r);
  80111b:	50                   	push   %eax
  80111c:	68 0e 28 80 00       	push   $0x80280e
  801121:	6a 48                	push   $0x48
  801123:	68 bc 27 80 00       	push   $0x8027bc
  801128:	e8 f7 f0 ff ff       	call   800224 <_panic>
			panic("sys_page_map：%e", r);
  80112d:	50                   	push   %eax
  80112e:	68 0e 28 80 00       	push   $0x80280e
  801133:	6a 4a                	push   $0x4a
  801135:	68 bc 27 80 00       	push   $0x8027bc
  80113a:	e8 e5 f0 ff ff       	call   800224 <_panic>
			duppage(envid, PGNUM(addr));	//拷贝当前进程映射关系到子进程
		}
	}
	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_W | PTE_U)) < 0)	//为子进程分配异常栈
  80113f:	83 ec 04             	sub    $0x4,%esp
  801142:	6a 07                	push   $0x7
  801144:	68 00 f0 bf ee       	push   $0xeebff000
  801149:	ff 75 e4             	pushl  -0x1c(%ebp)
  80114c:	e8 c6 fb ff ff       	call   800d17 <sys_page_alloc>
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	85 c0                	test   %eax,%eax
  801156:	78 2e                	js     801186 <fork+0x1ae>
		panic("sys_page_alloc: %e", r);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);		//为子进程设置_pgfault_upcall
  801158:	83 ec 08             	sub    $0x8,%esp
  80115b:	68 70 1f 80 00       	push   $0x801f70
  801160:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801163:	57                   	push   %edi
  801164:	e8 f9 fc ff ff       	call   800e62 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)	//设置子进程为ENV_RUNNABLE状态
  801169:	83 c4 08             	add    $0x8,%esp
  80116c:	6a 02                	push   $0x2
  80116e:	57                   	push   %edi
  80116f:	e8 6a fc ff ff       	call   800dde <sys_env_set_status>
  801174:	83 c4 10             	add    $0x10,%esp
  801177:	85 c0                	test   %eax,%eax
  801179:	78 1d                	js     801198 <fork+0x1c0>
		panic("sys_env_set_status: %e", r);
	return envid;
}
  80117b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80117e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801181:	5b                   	pop    %ebx
  801182:	5e                   	pop    %esi
  801183:	5f                   	pop    %edi
  801184:	5d                   	pop    %ebp
  801185:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801186:	50                   	push   %eax
  801187:	68 d8 27 80 00       	push   $0x8027d8
  80118c:	6a 79                	push   $0x79
  80118e:	68 bc 27 80 00       	push   $0x8027bc
  801193:	e8 8c f0 ff ff       	call   800224 <_panic>
		panic("sys_env_set_status: %e", r);
  801198:	50                   	push   %eax
  801199:	68 20 28 80 00       	push   $0x802820
  80119e:	6a 7d                	push   $0x7d
  8011a0:	68 bc 27 80 00       	push   $0x8027bc
  8011a5:	e8 7a f0 ff ff       	call   800224 <_panic>

008011aa <sfork>:

// Challenge!
int
sfork(void)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011b0:	68 37 28 80 00       	push   $0x802837
  8011b5:	68 85 00 00 00       	push   $0x85
  8011ba:	68 bc 27 80 00       	push   $0x8027bc
  8011bf:	e8 60 f0 ff ff       	call   800224 <_panic>

008011c4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	05 00 00 00 30       	add    $0x30000000,%eax
  8011cf:	c1 e8 0c             	shr    $0xc,%eax
}
  8011d2:	5d                   	pop    %ebp
  8011d3:	c3                   	ret    

008011d4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011e4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011e9:	5d                   	pop    %ebp
  8011ea:	c3                   	ret    

008011eb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011f6:	89 c2                	mov    %eax,%edx
  8011f8:	c1 ea 16             	shr    $0x16,%edx
  8011fb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801202:	f6 c2 01             	test   $0x1,%dl
  801205:	74 2a                	je     801231 <fd_alloc+0x46>
  801207:	89 c2                	mov    %eax,%edx
  801209:	c1 ea 0c             	shr    $0xc,%edx
  80120c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801213:	f6 c2 01             	test   $0x1,%dl
  801216:	74 19                	je     801231 <fd_alloc+0x46>
  801218:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80121d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801222:	75 d2                	jne    8011f6 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801224:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80122a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80122f:	eb 07                	jmp    801238 <fd_alloc+0x4d>
			*fd_store = fd;
  801231:	89 01                	mov    %eax,(%ecx)
			return 0;
  801233:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801238:	5d                   	pop    %ebp
  801239:	c3                   	ret    

0080123a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801240:	83 f8 1f             	cmp    $0x1f,%eax
  801243:	77 36                	ja     80127b <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801245:	c1 e0 0c             	shl    $0xc,%eax
  801248:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80124d:	89 c2                	mov    %eax,%edx
  80124f:	c1 ea 16             	shr    $0x16,%edx
  801252:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801259:	f6 c2 01             	test   $0x1,%dl
  80125c:	74 24                	je     801282 <fd_lookup+0x48>
  80125e:	89 c2                	mov    %eax,%edx
  801260:	c1 ea 0c             	shr    $0xc,%edx
  801263:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80126a:	f6 c2 01             	test   $0x1,%dl
  80126d:	74 1a                	je     801289 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80126f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801272:	89 02                	mov    %eax,(%edx)
	return 0;
  801274:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    
		return -E_INVAL;
  80127b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801280:	eb f7                	jmp    801279 <fd_lookup+0x3f>
		return -E_INVAL;
  801282:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801287:	eb f0                	jmp    801279 <fd_lookup+0x3f>
  801289:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128e:	eb e9                	jmp    801279 <fd_lookup+0x3f>

00801290 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801299:	ba cc 28 80 00       	mov    $0x8028cc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80129e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012a3:	39 08                	cmp    %ecx,(%eax)
  8012a5:	74 33                	je     8012da <dev_lookup+0x4a>
  8012a7:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012aa:	8b 02                	mov    (%edx),%eax
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	75 f3                	jne    8012a3 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012b0:	a1 20 44 80 00       	mov    0x804420,%eax
  8012b5:	8b 40 48             	mov    0x48(%eax),%eax
  8012b8:	83 ec 04             	sub    $0x4,%esp
  8012bb:	51                   	push   %ecx
  8012bc:	50                   	push   %eax
  8012bd:	68 50 28 80 00       	push   $0x802850
  8012c2:	e8 38 f0 ff ff       	call   8002ff <cprintf>
	*dev = 0;
  8012c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    
			*dev = devtab[i];
  8012da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012dd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012df:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e4:	eb f2                	jmp    8012d8 <dev_lookup+0x48>

008012e6 <fd_close>:
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	57                   	push   %edi
  8012ea:	56                   	push   %esi
  8012eb:	53                   	push   %ebx
  8012ec:	83 ec 1c             	sub    $0x1c,%esp
  8012ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8012f2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012f8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012f9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012ff:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801302:	50                   	push   %eax
  801303:	e8 32 ff ff ff       	call   80123a <fd_lookup>
  801308:	89 c3                	mov    %eax,%ebx
  80130a:	83 c4 08             	add    $0x8,%esp
  80130d:	85 c0                	test   %eax,%eax
  80130f:	78 05                	js     801316 <fd_close+0x30>
	    || fd != fd2)
  801311:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801314:	74 16                	je     80132c <fd_close+0x46>
		return (must_exist ? r : 0);
  801316:	89 f8                	mov    %edi,%eax
  801318:	84 c0                	test   %al,%al
  80131a:	b8 00 00 00 00       	mov    $0x0,%eax
  80131f:	0f 44 d8             	cmove  %eax,%ebx
}
  801322:	89 d8                	mov    %ebx,%eax
  801324:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801327:	5b                   	pop    %ebx
  801328:	5e                   	pop    %esi
  801329:	5f                   	pop    %edi
  80132a:	5d                   	pop    %ebp
  80132b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80132c:	83 ec 08             	sub    $0x8,%esp
  80132f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801332:	50                   	push   %eax
  801333:	ff 36                	pushl  (%esi)
  801335:	e8 56 ff ff ff       	call   801290 <dev_lookup>
  80133a:	89 c3                	mov    %eax,%ebx
  80133c:	83 c4 10             	add    $0x10,%esp
  80133f:	85 c0                	test   %eax,%eax
  801341:	78 15                	js     801358 <fd_close+0x72>
		if (dev->dev_close)
  801343:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801346:	8b 40 10             	mov    0x10(%eax),%eax
  801349:	85 c0                	test   %eax,%eax
  80134b:	74 1b                	je     801368 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80134d:	83 ec 0c             	sub    $0xc,%esp
  801350:	56                   	push   %esi
  801351:	ff d0                	call   *%eax
  801353:	89 c3                	mov    %eax,%ebx
  801355:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801358:	83 ec 08             	sub    $0x8,%esp
  80135b:	56                   	push   %esi
  80135c:	6a 00                	push   $0x0
  80135e:	e8 39 fa ff ff       	call   800d9c <sys_page_unmap>
	return r;
  801363:	83 c4 10             	add    $0x10,%esp
  801366:	eb ba                	jmp    801322 <fd_close+0x3c>
			r = 0;
  801368:	bb 00 00 00 00       	mov    $0x0,%ebx
  80136d:	eb e9                	jmp    801358 <fd_close+0x72>

0080136f <close>:

int
close(int fdnum)
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801375:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801378:	50                   	push   %eax
  801379:	ff 75 08             	pushl  0x8(%ebp)
  80137c:	e8 b9 fe ff ff       	call   80123a <fd_lookup>
  801381:	83 c4 08             	add    $0x8,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	78 10                	js     801398 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801388:	83 ec 08             	sub    $0x8,%esp
  80138b:	6a 01                	push   $0x1
  80138d:	ff 75 f4             	pushl  -0xc(%ebp)
  801390:	e8 51 ff ff ff       	call   8012e6 <fd_close>
  801395:	83 c4 10             	add    $0x10,%esp
}
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <close_all>:

void
close_all(void)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	53                   	push   %ebx
  80139e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013a6:	83 ec 0c             	sub    $0xc,%esp
  8013a9:	53                   	push   %ebx
  8013aa:	e8 c0 ff ff ff       	call   80136f <close>
	for (i = 0; i < MAXFD; i++)
  8013af:	83 c3 01             	add    $0x1,%ebx
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	83 fb 20             	cmp    $0x20,%ebx
  8013b8:	75 ec                	jne    8013a6 <close_all+0xc>
}
  8013ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	57                   	push   %edi
  8013c3:	56                   	push   %esi
  8013c4:	53                   	push   %ebx
  8013c5:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013c8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013cb:	50                   	push   %eax
  8013cc:	ff 75 08             	pushl  0x8(%ebp)
  8013cf:	e8 66 fe ff ff       	call   80123a <fd_lookup>
  8013d4:	89 c3                	mov    %eax,%ebx
  8013d6:	83 c4 08             	add    $0x8,%esp
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	0f 88 81 00 00 00    	js     801462 <dup+0xa3>
		return r;
	close(newfdnum);
  8013e1:	83 ec 0c             	sub    $0xc,%esp
  8013e4:	ff 75 0c             	pushl  0xc(%ebp)
  8013e7:	e8 83 ff ff ff       	call   80136f <close>

	newfd = INDEX2FD(newfdnum);
  8013ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013ef:	c1 e6 0c             	shl    $0xc,%esi
  8013f2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013f8:	83 c4 04             	add    $0x4,%esp
  8013fb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013fe:	e8 d1 fd ff ff       	call   8011d4 <fd2data>
  801403:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801405:	89 34 24             	mov    %esi,(%esp)
  801408:	e8 c7 fd ff ff       	call   8011d4 <fd2data>
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801412:	89 d8                	mov    %ebx,%eax
  801414:	c1 e8 16             	shr    $0x16,%eax
  801417:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80141e:	a8 01                	test   $0x1,%al
  801420:	74 11                	je     801433 <dup+0x74>
  801422:	89 d8                	mov    %ebx,%eax
  801424:	c1 e8 0c             	shr    $0xc,%eax
  801427:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80142e:	f6 c2 01             	test   $0x1,%dl
  801431:	75 39                	jne    80146c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801433:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801436:	89 d0                	mov    %edx,%eax
  801438:	c1 e8 0c             	shr    $0xc,%eax
  80143b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801442:	83 ec 0c             	sub    $0xc,%esp
  801445:	25 07 0e 00 00       	and    $0xe07,%eax
  80144a:	50                   	push   %eax
  80144b:	56                   	push   %esi
  80144c:	6a 00                	push   $0x0
  80144e:	52                   	push   %edx
  80144f:	6a 00                	push   $0x0
  801451:	e8 04 f9 ff ff       	call   800d5a <sys_page_map>
  801456:	89 c3                	mov    %eax,%ebx
  801458:	83 c4 20             	add    $0x20,%esp
  80145b:	85 c0                	test   %eax,%eax
  80145d:	78 31                	js     801490 <dup+0xd1>
		goto err;

	return newfdnum;
  80145f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801462:	89 d8                	mov    %ebx,%eax
  801464:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801467:	5b                   	pop    %ebx
  801468:	5e                   	pop    %esi
  801469:	5f                   	pop    %edi
  80146a:	5d                   	pop    %ebp
  80146b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80146c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801473:	83 ec 0c             	sub    $0xc,%esp
  801476:	25 07 0e 00 00       	and    $0xe07,%eax
  80147b:	50                   	push   %eax
  80147c:	57                   	push   %edi
  80147d:	6a 00                	push   $0x0
  80147f:	53                   	push   %ebx
  801480:	6a 00                	push   $0x0
  801482:	e8 d3 f8 ff ff       	call   800d5a <sys_page_map>
  801487:	89 c3                	mov    %eax,%ebx
  801489:	83 c4 20             	add    $0x20,%esp
  80148c:	85 c0                	test   %eax,%eax
  80148e:	79 a3                	jns    801433 <dup+0x74>
	sys_page_unmap(0, newfd);
  801490:	83 ec 08             	sub    $0x8,%esp
  801493:	56                   	push   %esi
  801494:	6a 00                	push   $0x0
  801496:	e8 01 f9 ff ff       	call   800d9c <sys_page_unmap>
	sys_page_unmap(0, nva);
  80149b:	83 c4 08             	add    $0x8,%esp
  80149e:	57                   	push   %edi
  80149f:	6a 00                	push   $0x0
  8014a1:	e8 f6 f8 ff ff       	call   800d9c <sys_page_unmap>
	return r;
  8014a6:	83 c4 10             	add    $0x10,%esp
  8014a9:	eb b7                	jmp    801462 <dup+0xa3>

008014ab <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	53                   	push   %ebx
  8014af:	83 ec 14             	sub    $0x14,%esp
  8014b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b8:	50                   	push   %eax
  8014b9:	53                   	push   %ebx
  8014ba:	e8 7b fd ff ff       	call   80123a <fd_lookup>
  8014bf:	83 c4 08             	add    $0x8,%esp
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	78 3f                	js     801505 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c6:	83 ec 08             	sub    $0x8,%esp
  8014c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014cc:	50                   	push   %eax
  8014cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d0:	ff 30                	pushl  (%eax)
  8014d2:	e8 b9 fd ff ff       	call   801290 <dev_lookup>
  8014d7:	83 c4 10             	add    $0x10,%esp
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	78 27                	js     801505 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014e1:	8b 42 08             	mov    0x8(%edx),%eax
  8014e4:	83 e0 03             	and    $0x3,%eax
  8014e7:	83 f8 01             	cmp    $0x1,%eax
  8014ea:	74 1e                	je     80150a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ef:	8b 40 08             	mov    0x8(%eax),%eax
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	74 35                	je     80152b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014f6:	83 ec 04             	sub    $0x4,%esp
  8014f9:	ff 75 10             	pushl  0x10(%ebp)
  8014fc:	ff 75 0c             	pushl  0xc(%ebp)
  8014ff:	52                   	push   %edx
  801500:	ff d0                	call   *%eax
  801502:	83 c4 10             	add    $0x10,%esp
}
  801505:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801508:	c9                   	leave  
  801509:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80150a:	a1 20 44 80 00       	mov    0x804420,%eax
  80150f:	8b 40 48             	mov    0x48(%eax),%eax
  801512:	83 ec 04             	sub    $0x4,%esp
  801515:	53                   	push   %ebx
  801516:	50                   	push   %eax
  801517:	68 91 28 80 00       	push   $0x802891
  80151c:	e8 de ed ff ff       	call   8002ff <cprintf>
		return -E_INVAL;
  801521:	83 c4 10             	add    $0x10,%esp
  801524:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801529:	eb da                	jmp    801505 <read+0x5a>
		return -E_NOT_SUPP;
  80152b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801530:	eb d3                	jmp    801505 <read+0x5a>

00801532 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	57                   	push   %edi
  801536:	56                   	push   %esi
  801537:	53                   	push   %ebx
  801538:	83 ec 0c             	sub    $0xc,%esp
  80153b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80153e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801541:	bb 00 00 00 00       	mov    $0x0,%ebx
  801546:	39 f3                	cmp    %esi,%ebx
  801548:	73 25                	jae    80156f <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80154a:	83 ec 04             	sub    $0x4,%esp
  80154d:	89 f0                	mov    %esi,%eax
  80154f:	29 d8                	sub    %ebx,%eax
  801551:	50                   	push   %eax
  801552:	89 d8                	mov    %ebx,%eax
  801554:	03 45 0c             	add    0xc(%ebp),%eax
  801557:	50                   	push   %eax
  801558:	57                   	push   %edi
  801559:	e8 4d ff ff ff       	call   8014ab <read>
		if (m < 0)
  80155e:	83 c4 10             	add    $0x10,%esp
  801561:	85 c0                	test   %eax,%eax
  801563:	78 08                	js     80156d <readn+0x3b>
			return m;
		if (m == 0)
  801565:	85 c0                	test   %eax,%eax
  801567:	74 06                	je     80156f <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801569:	01 c3                	add    %eax,%ebx
  80156b:	eb d9                	jmp    801546 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80156d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80156f:	89 d8                	mov    %ebx,%eax
  801571:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801574:	5b                   	pop    %ebx
  801575:	5e                   	pop    %esi
  801576:	5f                   	pop    %edi
  801577:	5d                   	pop    %ebp
  801578:	c3                   	ret    

00801579 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	53                   	push   %ebx
  80157d:	83 ec 14             	sub    $0x14,%esp
  801580:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801583:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801586:	50                   	push   %eax
  801587:	53                   	push   %ebx
  801588:	e8 ad fc ff ff       	call   80123a <fd_lookup>
  80158d:	83 c4 08             	add    $0x8,%esp
  801590:	85 c0                	test   %eax,%eax
  801592:	78 3a                	js     8015ce <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801594:	83 ec 08             	sub    $0x8,%esp
  801597:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159a:	50                   	push   %eax
  80159b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159e:	ff 30                	pushl  (%eax)
  8015a0:	e8 eb fc ff ff       	call   801290 <dev_lookup>
  8015a5:	83 c4 10             	add    $0x10,%esp
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	78 22                	js     8015ce <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015af:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015b3:	74 1e                	je     8015d3 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b8:	8b 52 0c             	mov    0xc(%edx),%edx
  8015bb:	85 d2                	test   %edx,%edx
  8015bd:	74 35                	je     8015f4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	ff 75 10             	pushl  0x10(%ebp)
  8015c5:	ff 75 0c             	pushl  0xc(%ebp)
  8015c8:	50                   	push   %eax
  8015c9:	ff d2                	call   *%edx
  8015cb:	83 c4 10             	add    $0x10,%esp
}
  8015ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015d3:	a1 20 44 80 00       	mov    0x804420,%eax
  8015d8:	8b 40 48             	mov    0x48(%eax),%eax
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	53                   	push   %ebx
  8015df:	50                   	push   %eax
  8015e0:	68 ad 28 80 00       	push   $0x8028ad
  8015e5:	e8 15 ed ff ff       	call   8002ff <cprintf>
		return -E_INVAL;
  8015ea:	83 c4 10             	add    $0x10,%esp
  8015ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f2:	eb da                	jmp    8015ce <write+0x55>
		return -E_NOT_SUPP;
  8015f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f9:	eb d3                	jmp    8015ce <write+0x55>

008015fb <seek>:

int
seek(int fdnum, off_t offset)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801601:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801604:	50                   	push   %eax
  801605:	ff 75 08             	pushl  0x8(%ebp)
  801608:	e8 2d fc ff ff       	call   80123a <fd_lookup>
  80160d:	83 c4 08             	add    $0x8,%esp
  801610:	85 c0                	test   %eax,%eax
  801612:	78 0e                	js     801622 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801614:	8b 55 0c             	mov    0xc(%ebp),%edx
  801617:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80161a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80161d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	53                   	push   %ebx
  801628:	83 ec 14             	sub    $0x14,%esp
  80162b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801631:	50                   	push   %eax
  801632:	53                   	push   %ebx
  801633:	e8 02 fc ff ff       	call   80123a <fd_lookup>
  801638:	83 c4 08             	add    $0x8,%esp
  80163b:	85 c0                	test   %eax,%eax
  80163d:	78 37                	js     801676 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80163f:	83 ec 08             	sub    $0x8,%esp
  801642:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801645:	50                   	push   %eax
  801646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801649:	ff 30                	pushl  (%eax)
  80164b:	e8 40 fc ff ff       	call   801290 <dev_lookup>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	85 c0                	test   %eax,%eax
  801655:	78 1f                	js     801676 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80165e:	74 1b                	je     80167b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801660:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801663:	8b 52 18             	mov    0x18(%edx),%edx
  801666:	85 d2                	test   %edx,%edx
  801668:	74 32                	je     80169c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80166a:	83 ec 08             	sub    $0x8,%esp
  80166d:	ff 75 0c             	pushl  0xc(%ebp)
  801670:	50                   	push   %eax
  801671:	ff d2                	call   *%edx
  801673:	83 c4 10             	add    $0x10,%esp
}
  801676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801679:	c9                   	leave  
  80167a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80167b:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801680:	8b 40 48             	mov    0x48(%eax),%eax
  801683:	83 ec 04             	sub    $0x4,%esp
  801686:	53                   	push   %ebx
  801687:	50                   	push   %eax
  801688:	68 70 28 80 00       	push   $0x802870
  80168d:	e8 6d ec ff ff       	call   8002ff <cprintf>
		return -E_INVAL;
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80169a:	eb da                	jmp    801676 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80169c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a1:	eb d3                	jmp    801676 <ftruncate+0x52>

008016a3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	53                   	push   %ebx
  8016a7:	83 ec 14             	sub    $0x14,%esp
  8016aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b0:	50                   	push   %eax
  8016b1:	ff 75 08             	pushl  0x8(%ebp)
  8016b4:	e8 81 fb ff ff       	call   80123a <fd_lookup>
  8016b9:	83 c4 08             	add    $0x8,%esp
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	78 4b                	js     80170b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c0:	83 ec 08             	sub    $0x8,%esp
  8016c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c6:	50                   	push   %eax
  8016c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ca:	ff 30                	pushl  (%eax)
  8016cc:	e8 bf fb ff ff       	call   801290 <dev_lookup>
  8016d1:	83 c4 10             	add    $0x10,%esp
  8016d4:	85 c0                	test   %eax,%eax
  8016d6:	78 33                	js     80170b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016db:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016df:	74 2f                	je     801710 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016e1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016e4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016eb:	00 00 00 
	stat->st_isdir = 0;
  8016ee:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016f5:	00 00 00 
	stat->st_dev = dev;
  8016f8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016fe:	83 ec 08             	sub    $0x8,%esp
  801701:	53                   	push   %ebx
  801702:	ff 75 f0             	pushl  -0x10(%ebp)
  801705:	ff 50 14             	call   *0x14(%eax)
  801708:	83 c4 10             	add    $0x10,%esp
}
  80170b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    
		return -E_NOT_SUPP;
  801710:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801715:	eb f4                	jmp    80170b <fstat+0x68>

00801717 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	56                   	push   %esi
  80171b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80171c:	83 ec 08             	sub    $0x8,%esp
  80171f:	6a 00                	push   $0x0
  801721:	ff 75 08             	pushl  0x8(%ebp)
  801724:	e8 30 02 00 00       	call   801959 <open>
  801729:	89 c3                	mov    %eax,%ebx
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	85 c0                	test   %eax,%eax
  801730:	78 1b                	js     80174d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801732:	83 ec 08             	sub    $0x8,%esp
  801735:	ff 75 0c             	pushl  0xc(%ebp)
  801738:	50                   	push   %eax
  801739:	e8 65 ff ff ff       	call   8016a3 <fstat>
  80173e:	89 c6                	mov    %eax,%esi
	close(fd);
  801740:	89 1c 24             	mov    %ebx,(%esp)
  801743:	e8 27 fc ff ff       	call   80136f <close>
	return r;
  801748:	83 c4 10             	add    $0x10,%esp
  80174b:	89 f3                	mov    %esi,%ebx
}
  80174d:	89 d8                	mov    %ebx,%eax
  80174f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801752:	5b                   	pop    %ebx
  801753:	5e                   	pop    %esi
  801754:	5d                   	pop    %ebp
  801755:	c3                   	ret    

00801756 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	56                   	push   %esi
  80175a:	53                   	push   %ebx
  80175b:	89 c6                	mov    %eax,%esi
  80175d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80175f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801766:	74 27                	je     80178f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801768:	6a 07                	push   $0x7
  80176a:	68 00 50 80 00       	push   $0x805000
  80176f:	56                   	push   %esi
  801770:	ff 35 00 40 80 00    	pushl  0x804000
  801776:	e8 82 08 00 00       	call   801ffd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80177b:	83 c4 0c             	add    $0xc,%esp
  80177e:	6a 00                	push   $0x0
  801780:	53                   	push   %ebx
  801781:	6a 00                	push   $0x0
  801783:	e8 0c 08 00 00       	call   801f94 <ipc_recv>
}
  801788:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178b:	5b                   	pop    %ebx
  80178c:	5e                   	pop    %esi
  80178d:	5d                   	pop    %ebp
  80178e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80178f:	83 ec 0c             	sub    $0xc,%esp
  801792:	6a 01                	push   $0x1
  801794:	e8 b8 08 00 00       	call   802051 <ipc_find_env>
  801799:	a3 00 40 80 00       	mov    %eax,0x804000
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	eb c5                	jmp    801768 <fsipc+0x12>

008017a3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8017af:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b7:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c1:	b8 02 00 00 00       	mov    $0x2,%eax
  8017c6:	e8 8b ff ff ff       	call   801756 <fsipc>
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <devfile_flush>:
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d9:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017de:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e3:	b8 06 00 00 00       	mov    $0x6,%eax
  8017e8:	e8 69 ff ff ff       	call   801756 <fsipc>
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <devfile_stat>:
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	53                   	push   %ebx
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ff:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801804:	ba 00 00 00 00       	mov    $0x0,%edx
  801809:	b8 05 00 00 00       	mov    $0x5,%eax
  80180e:	e8 43 ff ff ff       	call   801756 <fsipc>
  801813:	85 c0                	test   %eax,%eax
  801815:	78 2c                	js     801843 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801817:	83 ec 08             	sub    $0x8,%esp
  80181a:	68 00 50 80 00       	push   $0x805000
  80181f:	53                   	push   %ebx
  801820:	e8 f9 f0 ff ff       	call   80091e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801825:	a1 80 50 80 00       	mov    0x805080,%eax
  80182a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801830:	a1 84 50 80 00       	mov    0x805084,%eax
  801835:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801843:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <devfile_write>:
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	53                   	push   %ebx
  80184c:	83 ec 08             	sub    $0x8,%esp
  80184f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  801852:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801858:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  80185d:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8b 40 0c             	mov    0xc(%eax),%eax
  801866:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80186b:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801871:	53                   	push   %ebx
  801872:	ff 75 0c             	pushl  0xc(%ebp)
  801875:	68 08 50 80 00       	push   $0x805008
  80187a:	e8 2d f2 ff ff       	call   800aac <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80187f:	ba 00 00 00 00       	mov    $0x0,%edx
  801884:	b8 04 00 00 00       	mov    $0x4,%eax
  801889:	e8 c8 fe ff ff       	call   801756 <fsipc>
  80188e:	83 c4 10             	add    $0x10,%esp
  801891:	85 c0                	test   %eax,%eax
  801893:	78 0b                	js     8018a0 <devfile_write+0x58>
	assert(r <= n);
  801895:	39 d8                	cmp    %ebx,%eax
  801897:	77 0c                	ja     8018a5 <devfile_write+0x5d>
	assert(r <= PGSIZE);
  801899:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80189e:	7f 1e                	jg     8018be <devfile_write+0x76>
}
  8018a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    
	assert(r <= n);
  8018a5:	68 dc 28 80 00       	push   $0x8028dc
  8018aa:	68 e3 28 80 00       	push   $0x8028e3
  8018af:	68 98 00 00 00       	push   $0x98
  8018b4:	68 f8 28 80 00       	push   $0x8028f8
  8018b9:	e8 66 e9 ff ff       	call   800224 <_panic>
	assert(r <= PGSIZE);
  8018be:	68 03 29 80 00       	push   $0x802903
  8018c3:	68 e3 28 80 00       	push   $0x8028e3
  8018c8:	68 99 00 00 00       	push   $0x99
  8018cd:	68 f8 28 80 00       	push   $0x8028f8
  8018d2:	e8 4d e9 ff ff       	call   800224 <_panic>

008018d7 <devfile_read>:
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	56                   	push   %esi
  8018db:	53                   	push   %ebx
  8018dc:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018ea:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f5:	b8 03 00 00 00       	mov    $0x3,%eax
  8018fa:	e8 57 fe ff ff       	call   801756 <fsipc>
  8018ff:	89 c3                	mov    %eax,%ebx
  801901:	85 c0                	test   %eax,%eax
  801903:	78 1f                	js     801924 <devfile_read+0x4d>
	assert(r <= n);
  801905:	39 f0                	cmp    %esi,%eax
  801907:	77 24                	ja     80192d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801909:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80190e:	7f 33                	jg     801943 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801910:	83 ec 04             	sub    $0x4,%esp
  801913:	50                   	push   %eax
  801914:	68 00 50 80 00       	push   $0x805000
  801919:	ff 75 0c             	pushl  0xc(%ebp)
  80191c:	e8 8b f1 ff ff       	call   800aac <memmove>
	return r;
  801921:	83 c4 10             	add    $0x10,%esp
}
  801924:	89 d8                	mov    %ebx,%eax
  801926:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801929:	5b                   	pop    %ebx
  80192a:	5e                   	pop    %esi
  80192b:	5d                   	pop    %ebp
  80192c:	c3                   	ret    
	assert(r <= n);
  80192d:	68 dc 28 80 00       	push   $0x8028dc
  801932:	68 e3 28 80 00       	push   $0x8028e3
  801937:	6a 7c                	push   $0x7c
  801939:	68 f8 28 80 00       	push   $0x8028f8
  80193e:	e8 e1 e8 ff ff       	call   800224 <_panic>
	assert(r <= PGSIZE);
  801943:	68 03 29 80 00       	push   $0x802903
  801948:	68 e3 28 80 00       	push   $0x8028e3
  80194d:	6a 7d                	push   $0x7d
  80194f:	68 f8 28 80 00       	push   $0x8028f8
  801954:	e8 cb e8 ff ff       	call   800224 <_panic>

00801959 <open>:
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	56                   	push   %esi
  80195d:	53                   	push   %ebx
  80195e:	83 ec 1c             	sub    $0x1c,%esp
  801961:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801964:	56                   	push   %esi
  801965:	e8 7d ef ff ff       	call   8008e7 <strlen>
  80196a:	83 c4 10             	add    $0x10,%esp
  80196d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801972:	7f 6c                	jg     8019e0 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801974:	83 ec 0c             	sub    $0xc,%esp
  801977:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80197a:	50                   	push   %eax
  80197b:	e8 6b f8 ff ff       	call   8011eb <fd_alloc>
  801980:	89 c3                	mov    %eax,%ebx
  801982:	83 c4 10             	add    $0x10,%esp
  801985:	85 c0                	test   %eax,%eax
  801987:	78 3c                	js     8019c5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801989:	83 ec 08             	sub    $0x8,%esp
  80198c:	56                   	push   %esi
  80198d:	68 00 50 80 00       	push   $0x805000
  801992:	e8 87 ef ff ff       	call   80091e <strcpy>
	fsipcbuf.open.req_omode = mode;
  801997:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80199f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a7:	e8 aa fd ff ff       	call   801756 <fsipc>
  8019ac:	89 c3                	mov    %eax,%ebx
  8019ae:	83 c4 10             	add    $0x10,%esp
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	78 19                	js     8019ce <open+0x75>
	return fd2num(fd);
  8019b5:	83 ec 0c             	sub    $0xc,%esp
  8019b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019bb:	e8 04 f8 ff ff       	call   8011c4 <fd2num>
  8019c0:	89 c3                	mov    %eax,%ebx
  8019c2:	83 c4 10             	add    $0x10,%esp
}
  8019c5:	89 d8                	mov    %ebx,%eax
  8019c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ca:	5b                   	pop    %ebx
  8019cb:	5e                   	pop    %esi
  8019cc:	5d                   	pop    %ebp
  8019cd:	c3                   	ret    
		fd_close(fd, 0);
  8019ce:	83 ec 08             	sub    $0x8,%esp
  8019d1:	6a 00                	push   $0x0
  8019d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d6:	e8 0b f9 ff ff       	call   8012e6 <fd_close>
		return r;
  8019db:	83 c4 10             	add    $0x10,%esp
  8019de:	eb e5                	jmp    8019c5 <open+0x6c>
		return -E_BAD_PATH;
  8019e0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019e5:	eb de                	jmp    8019c5 <open+0x6c>

008019e7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8019f7:	e8 5a fd ff ff       	call   801756 <fsipc>
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	56                   	push   %esi
  801a02:	53                   	push   %ebx
  801a03:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a06:	83 ec 0c             	sub    $0xc,%esp
  801a09:	ff 75 08             	pushl  0x8(%ebp)
  801a0c:	e8 c3 f7 ff ff       	call   8011d4 <fd2data>
  801a11:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a13:	83 c4 08             	add    $0x8,%esp
  801a16:	68 0f 29 80 00       	push   $0x80290f
  801a1b:	53                   	push   %ebx
  801a1c:	e8 fd ee ff ff       	call   80091e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a21:	8b 46 04             	mov    0x4(%esi),%eax
  801a24:	2b 06                	sub    (%esi),%eax
  801a26:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a2c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a33:	00 00 00 
	stat->st_dev = &devpipe;
  801a36:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a3d:	30 80 00 
	return 0;
}
  801a40:	b8 00 00 00 00       	mov    $0x0,%eax
  801a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a48:	5b                   	pop    %ebx
  801a49:	5e                   	pop    %esi
  801a4a:	5d                   	pop    %ebp
  801a4b:	c3                   	ret    

00801a4c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	53                   	push   %ebx
  801a50:	83 ec 0c             	sub    $0xc,%esp
  801a53:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a56:	53                   	push   %ebx
  801a57:	6a 00                	push   $0x0
  801a59:	e8 3e f3 ff ff       	call   800d9c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a5e:	89 1c 24             	mov    %ebx,(%esp)
  801a61:	e8 6e f7 ff ff       	call   8011d4 <fd2data>
  801a66:	83 c4 08             	add    $0x8,%esp
  801a69:	50                   	push   %eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	e8 2b f3 ff ff       	call   800d9c <sys_page_unmap>
}
  801a71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <_pipeisclosed>:
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	57                   	push   %edi
  801a7a:	56                   	push   %esi
  801a7b:	53                   	push   %ebx
  801a7c:	83 ec 1c             	sub    $0x1c,%esp
  801a7f:	89 c7                	mov    %eax,%edi
  801a81:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a83:	a1 20 44 80 00       	mov    0x804420,%eax
  801a88:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a8b:	83 ec 0c             	sub    $0xc,%esp
  801a8e:	57                   	push   %edi
  801a8f:	e8 f6 05 00 00       	call   80208a <pageref>
  801a94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a97:	89 34 24             	mov    %esi,(%esp)
  801a9a:	e8 eb 05 00 00       	call   80208a <pageref>
		nn = thisenv->env_runs;
  801a9f:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801aa5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801aa8:	83 c4 10             	add    $0x10,%esp
  801aab:	39 cb                	cmp    %ecx,%ebx
  801aad:	74 1b                	je     801aca <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801aaf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ab2:	75 cf                	jne    801a83 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ab4:	8b 42 58             	mov    0x58(%edx),%eax
  801ab7:	6a 01                	push   $0x1
  801ab9:	50                   	push   %eax
  801aba:	53                   	push   %ebx
  801abb:	68 16 29 80 00       	push   $0x802916
  801ac0:	e8 3a e8 ff ff       	call   8002ff <cprintf>
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	eb b9                	jmp    801a83 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801aca:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801acd:	0f 94 c0             	sete   %al
  801ad0:	0f b6 c0             	movzbl %al,%eax
}
  801ad3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ad6:	5b                   	pop    %ebx
  801ad7:	5e                   	pop    %esi
  801ad8:	5f                   	pop    %edi
  801ad9:	5d                   	pop    %ebp
  801ada:	c3                   	ret    

00801adb <devpipe_write>:
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	57                   	push   %edi
  801adf:	56                   	push   %esi
  801ae0:	53                   	push   %ebx
  801ae1:	83 ec 28             	sub    $0x28,%esp
  801ae4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ae7:	56                   	push   %esi
  801ae8:	e8 e7 f6 ff ff       	call   8011d4 <fd2data>
  801aed:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	bf 00 00 00 00       	mov    $0x0,%edi
  801af7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801afa:	74 4f                	je     801b4b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801afc:	8b 43 04             	mov    0x4(%ebx),%eax
  801aff:	8b 0b                	mov    (%ebx),%ecx
  801b01:	8d 51 20             	lea    0x20(%ecx),%edx
  801b04:	39 d0                	cmp    %edx,%eax
  801b06:	72 14                	jb     801b1c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b08:	89 da                	mov    %ebx,%edx
  801b0a:	89 f0                	mov    %esi,%eax
  801b0c:	e8 65 ff ff ff       	call   801a76 <_pipeisclosed>
  801b11:	85 c0                	test   %eax,%eax
  801b13:	75 3a                	jne    801b4f <devpipe_write+0x74>
			sys_yield();
  801b15:	e8 de f1 ff ff       	call   800cf8 <sys_yield>
  801b1a:	eb e0                	jmp    801afc <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b1f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b23:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b26:	89 c2                	mov    %eax,%edx
  801b28:	c1 fa 1f             	sar    $0x1f,%edx
  801b2b:	89 d1                	mov    %edx,%ecx
  801b2d:	c1 e9 1b             	shr    $0x1b,%ecx
  801b30:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b33:	83 e2 1f             	and    $0x1f,%edx
  801b36:	29 ca                	sub    %ecx,%edx
  801b38:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b3c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b40:	83 c0 01             	add    $0x1,%eax
  801b43:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b46:	83 c7 01             	add    $0x1,%edi
  801b49:	eb ac                	jmp    801af7 <devpipe_write+0x1c>
	return i;
  801b4b:	89 f8                	mov    %edi,%eax
  801b4d:	eb 05                	jmp    801b54 <devpipe_write+0x79>
				return 0;
  801b4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b57:	5b                   	pop    %ebx
  801b58:	5e                   	pop    %esi
  801b59:	5f                   	pop    %edi
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    

00801b5c <devpipe_read>:
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	57                   	push   %edi
  801b60:	56                   	push   %esi
  801b61:	53                   	push   %ebx
  801b62:	83 ec 18             	sub    $0x18,%esp
  801b65:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b68:	57                   	push   %edi
  801b69:	e8 66 f6 ff ff       	call   8011d4 <fd2data>
  801b6e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b70:	83 c4 10             	add    $0x10,%esp
  801b73:	be 00 00 00 00       	mov    $0x0,%esi
  801b78:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b7b:	74 47                	je     801bc4 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801b7d:	8b 03                	mov    (%ebx),%eax
  801b7f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b82:	75 22                	jne    801ba6 <devpipe_read+0x4a>
			if (i > 0)
  801b84:	85 f6                	test   %esi,%esi
  801b86:	75 14                	jne    801b9c <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801b88:	89 da                	mov    %ebx,%edx
  801b8a:	89 f8                	mov    %edi,%eax
  801b8c:	e8 e5 fe ff ff       	call   801a76 <_pipeisclosed>
  801b91:	85 c0                	test   %eax,%eax
  801b93:	75 33                	jne    801bc8 <devpipe_read+0x6c>
			sys_yield();
  801b95:	e8 5e f1 ff ff       	call   800cf8 <sys_yield>
  801b9a:	eb e1                	jmp    801b7d <devpipe_read+0x21>
				return i;
  801b9c:	89 f0                	mov    %esi,%eax
}
  801b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba1:	5b                   	pop    %ebx
  801ba2:	5e                   	pop    %esi
  801ba3:	5f                   	pop    %edi
  801ba4:	5d                   	pop    %ebp
  801ba5:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ba6:	99                   	cltd   
  801ba7:	c1 ea 1b             	shr    $0x1b,%edx
  801baa:	01 d0                	add    %edx,%eax
  801bac:	83 e0 1f             	and    $0x1f,%eax
  801baf:	29 d0                	sub    %edx,%eax
  801bb1:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801bb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bb9:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801bbc:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801bbf:	83 c6 01             	add    $0x1,%esi
  801bc2:	eb b4                	jmp    801b78 <devpipe_read+0x1c>
	return i;
  801bc4:	89 f0                	mov    %esi,%eax
  801bc6:	eb d6                	jmp    801b9e <devpipe_read+0x42>
				return 0;
  801bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcd:	eb cf                	jmp    801b9e <devpipe_read+0x42>

00801bcf <pipe>:
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	56                   	push   %esi
  801bd3:	53                   	push   %ebx
  801bd4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801bd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bda:	50                   	push   %eax
  801bdb:	e8 0b f6 ff ff       	call   8011eb <fd_alloc>
  801be0:	89 c3                	mov    %eax,%ebx
  801be2:	83 c4 10             	add    $0x10,%esp
  801be5:	85 c0                	test   %eax,%eax
  801be7:	78 5b                	js     801c44 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801be9:	83 ec 04             	sub    $0x4,%esp
  801bec:	68 07 04 00 00       	push   $0x407
  801bf1:	ff 75 f4             	pushl  -0xc(%ebp)
  801bf4:	6a 00                	push   $0x0
  801bf6:	e8 1c f1 ff ff       	call   800d17 <sys_page_alloc>
  801bfb:	89 c3                	mov    %eax,%ebx
  801bfd:	83 c4 10             	add    $0x10,%esp
  801c00:	85 c0                	test   %eax,%eax
  801c02:	78 40                	js     801c44 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801c04:	83 ec 0c             	sub    $0xc,%esp
  801c07:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c0a:	50                   	push   %eax
  801c0b:	e8 db f5 ff ff       	call   8011eb <fd_alloc>
  801c10:	89 c3                	mov    %eax,%ebx
  801c12:	83 c4 10             	add    $0x10,%esp
  801c15:	85 c0                	test   %eax,%eax
  801c17:	78 1b                	js     801c34 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c19:	83 ec 04             	sub    $0x4,%esp
  801c1c:	68 07 04 00 00       	push   $0x407
  801c21:	ff 75 f0             	pushl  -0x10(%ebp)
  801c24:	6a 00                	push   $0x0
  801c26:	e8 ec f0 ff ff       	call   800d17 <sys_page_alloc>
  801c2b:	89 c3                	mov    %eax,%ebx
  801c2d:	83 c4 10             	add    $0x10,%esp
  801c30:	85 c0                	test   %eax,%eax
  801c32:	79 19                	jns    801c4d <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801c34:	83 ec 08             	sub    $0x8,%esp
  801c37:	ff 75 f4             	pushl  -0xc(%ebp)
  801c3a:	6a 00                	push   $0x0
  801c3c:	e8 5b f1 ff ff       	call   800d9c <sys_page_unmap>
  801c41:	83 c4 10             	add    $0x10,%esp
}
  801c44:	89 d8                	mov    %ebx,%eax
  801c46:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c49:	5b                   	pop    %ebx
  801c4a:	5e                   	pop    %esi
  801c4b:	5d                   	pop    %ebp
  801c4c:	c3                   	ret    
	va = fd2data(fd0);
  801c4d:	83 ec 0c             	sub    $0xc,%esp
  801c50:	ff 75 f4             	pushl  -0xc(%ebp)
  801c53:	e8 7c f5 ff ff       	call   8011d4 <fd2data>
  801c58:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c5a:	83 c4 0c             	add    $0xc,%esp
  801c5d:	68 07 04 00 00       	push   $0x407
  801c62:	50                   	push   %eax
  801c63:	6a 00                	push   $0x0
  801c65:	e8 ad f0 ff ff       	call   800d17 <sys_page_alloc>
  801c6a:	89 c3                	mov    %eax,%ebx
  801c6c:	83 c4 10             	add    $0x10,%esp
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	0f 88 8c 00 00 00    	js     801d03 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c77:	83 ec 0c             	sub    $0xc,%esp
  801c7a:	ff 75 f0             	pushl  -0x10(%ebp)
  801c7d:	e8 52 f5 ff ff       	call   8011d4 <fd2data>
  801c82:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c89:	50                   	push   %eax
  801c8a:	6a 00                	push   $0x0
  801c8c:	56                   	push   %esi
  801c8d:	6a 00                	push   $0x0
  801c8f:	e8 c6 f0 ff ff       	call   800d5a <sys_page_map>
  801c94:	89 c3                	mov    %eax,%ebx
  801c96:	83 c4 20             	add    $0x20,%esp
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	78 58                	js     801cf5 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ca6:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb5:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cbb:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801cc7:	83 ec 0c             	sub    $0xc,%esp
  801cca:	ff 75 f4             	pushl  -0xc(%ebp)
  801ccd:	e8 f2 f4 ff ff       	call   8011c4 <fd2num>
  801cd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cd5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801cd7:	83 c4 04             	add    $0x4,%esp
  801cda:	ff 75 f0             	pushl  -0x10(%ebp)
  801cdd:	e8 e2 f4 ff ff       	call   8011c4 <fd2num>
  801ce2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cf0:	e9 4f ff ff ff       	jmp    801c44 <pipe+0x75>
	sys_page_unmap(0, va);
  801cf5:	83 ec 08             	sub    $0x8,%esp
  801cf8:	56                   	push   %esi
  801cf9:	6a 00                	push   $0x0
  801cfb:	e8 9c f0 ff ff       	call   800d9c <sys_page_unmap>
  801d00:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d03:	83 ec 08             	sub    $0x8,%esp
  801d06:	ff 75 f0             	pushl  -0x10(%ebp)
  801d09:	6a 00                	push   $0x0
  801d0b:	e8 8c f0 ff ff       	call   800d9c <sys_page_unmap>
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	e9 1c ff ff ff       	jmp    801c34 <pipe+0x65>

00801d18 <pipeisclosed>:
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d21:	50                   	push   %eax
  801d22:	ff 75 08             	pushl  0x8(%ebp)
  801d25:	e8 10 f5 ff ff       	call   80123a <fd_lookup>
  801d2a:	83 c4 10             	add    $0x10,%esp
  801d2d:	85 c0                	test   %eax,%eax
  801d2f:	78 18                	js     801d49 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d31:	83 ec 0c             	sub    $0xc,%esp
  801d34:	ff 75 f4             	pushl  -0xc(%ebp)
  801d37:	e8 98 f4 ff ff       	call   8011d4 <fd2data>
	return _pipeisclosed(fd, p);
  801d3c:	89 c2                	mov    %eax,%edx
  801d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d41:	e8 30 fd ff ff       	call   801a76 <_pipeisclosed>
  801d46:	83 c4 10             	add    $0x10,%esp
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	56                   	push   %esi
  801d4f:	53                   	push   %ebx
  801d50:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801d53:	85 f6                	test   %esi,%esi
  801d55:	74 13                	je     801d6a <wait+0x1f>
	e = &envs[ENVX(envid)];
  801d57:	89 f3                	mov    %esi,%ebx
  801d59:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801d5f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801d62:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801d68:	eb 1b                	jmp    801d85 <wait+0x3a>
	assert(envid != 0);
  801d6a:	68 2e 29 80 00       	push   $0x80292e
  801d6f:	68 e3 28 80 00       	push   $0x8028e3
  801d74:	6a 09                	push   $0x9
  801d76:	68 39 29 80 00       	push   $0x802939
  801d7b:	e8 a4 e4 ff ff       	call   800224 <_panic>
		sys_yield();
  801d80:	e8 73 ef ff ff       	call   800cf8 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801d85:	8b 43 48             	mov    0x48(%ebx),%eax
  801d88:	39 f0                	cmp    %esi,%eax
  801d8a:	75 07                	jne    801d93 <wait+0x48>
  801d8c:	8b 43 54             	mov    0x54(%ebx),%eax
  801d8f:	85 c0                	test   %eax,%eax
  801d91:	75 ed                	jne    801d80 <wait+0x35>
}
  801d93:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d96:	5b                   	pop    %ebx
  801d97:	5e                   	pop    %esi
  801d98:	5d                   	pop    %ebp
  801d99:	c3                   	ret    

00801d9a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    

00801da4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801daa:	68 44 29 80 00       	push   $0x802944
  801daf:	ff 75 0c             	pushl  0xc(%ebp)
  801db2:	e8 67 eb ff ff       	call   80091e <strcpy>
	return 0;
}
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <devcons_write>:
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	57                   	push   %edi
  801dc2:	56                   	push   %esi
  801dc3:	53                   	push   %ebx
  801dc4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801dca:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801dcf:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801dd5:	eb 2f                	jmp    801e06 <devcons_write+0x48>
		m = n - tot;
  801dd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801dda:	29 f3                	sub    %esi,%ebx
  801ddc:	83 fb 7f             	cmp    $0x7f,%ebx
  801ddf:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801de4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801de7:	83 ec 04             	sub    $0x4,%esp
  801dea:	53                   	push   %ebx
  801deb:	89 f0                	mov    %esi,%eax
  801ded:	03 45 0c             	add    0xc(%ebp),%eax
  801df0:	50                   	push   %eax
  801df1:	57                   	push   %edi
  801df2:	e8 b5 ec ff ff       	call   800aac <memmove>
		sys_cputs(buf, m);
  801df7:	83 c4 08             	add    $0x8,%esp
  801dfa:	53                   	push   %ebx
  801dfb:	57                   	push   %edi
  801dfc:	e8 5a ee ff ff       	call   800c5b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e01:	01 de                	add    %ebx,%esi
  801e03:	83 c4 10             	add    $0x10,%esp
  801e06:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e09:	72 cc                	jb     801dd7 <devcons_write+0x19>
}
  801e0b:	89 f0                	mov    %esi,%eax
  801e0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e10:	5b                   	pop    %ebx
  801e11:	5e                   	pop    %esi
  801e12:	5f                   	pop    %edi
  801e13:	5d                   	pop    %ebp
  801e14:	c3                   	ret    

00801e15 <devcons_read>:
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	83 ec 08             	sub    $0x8,%esp
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e24:	75 07                	jne    801e2d <devcons_read+0x18>
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    
		sys_yield();
  801e28:	e8 cb ee ff ff       	call   800cf8 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e2d:	e8 47 ee ff ff       	call   800c79 <sys_cgetc>
  801e32:	85 c0                	test   %eax,%eax
  801e34:	74 f2                	je     801e28 <devcons_read+0x13>
	if (c < 0)
  801e36:	85 c0                	test   %eax,%eax
  801e38:	78 ec                	js     801e26 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801e3a:	83 f8 04             	cmp    $0x4,%eax
  801e3d:	74 0c                	je     801e4b <devcons_read+0x36>
	*(char*)vbuf = c;
  801e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e42:	88 02                	mov    %al,(%edx)
	return 1;
  801e44:	b8 01 00 00 00       	mov    $0x1,%eax
  801e49:	eb db                	jmp    801e26 <devcons_read+0x11>
		return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e50:	eb d4                	jmp    801e26 <devcons_read+0x11>

00801e52 <cputchar>:
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e5e:	6a 01                	push   $0x1
  801e60:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e63:	50                   	push   %eax
  801e64:	e8 f2 ed ff ff       	call   800c5b <sys_cputs>
}
  801e69:	83 c4 10             	add    $0x10,%esp
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <getchar>:
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e74:	6a 01                	push   $0x1
  801e76:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e79:	50                   	push   %eax
  801e7a:	6a 00                	push   $0x0
  801e7c:	e8 2a f6 ff ff       	call   8014ab <read>
	if (r < 0)
  801e81:	83 c4 10             	add    $0x10,%esp
  801e84:	85 c0                	test   %eax,%eax
  801e86:	78 08                	js     801e90 <getchar+0x22>
	if (r < 1)
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	7e 06                	jle    801e92 <getchar+0x24>
	return c;
  801e8c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    
		return -E_EOF;
  801e92:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e97:	eb f7                	jmp    801e90 <getchar+0x22>

00801e99 <iscons>:
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea2:	50                   	push   %eax
  801ea3:	ff 75 08             	pushl  0x8(%ebp)
  801ea6:	e8 8f f3 ff ff       	call   80123a <fd_lookup>
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	78 11                	js     801ec3 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ebb:	39 10                	cmp    %edx,(%eax)
  801ebd:	0f 94 c0             	sete   %al
  801ec0:	0f b6 c0             	movzbl %al,%eax
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <opencons>:
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801ecb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ece:	50                   	push   %eax
  801ecf:	e8 17 f3 ff ff       	call   8011eb <fd_alloc>
  801ed4:	83 c4 10             	add    $0x10,%esp
  801ed7:	85 c0                	test   %eax,%eax
  801ed9:	78 3a                	js     801f15 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801edb:	83 ec 04             	sub    $0x4,%esp
  801ede:	68 07 04 00 00       	push   $0x407
  801ee3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee6:	6a 00                	push   $0x0
  801ee8:	e8 2a ee ff ff       	call   800d17 <sys_page_alloc>
  801eed:	83 c4 10             	add    $0x10,%esp
  801ef0:	85 c0                	test   %eax,%eax
  801ef2:	78 21                	js     801f15 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef7:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801efd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f02:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f09:	83 ec 0c             	sub    $0xc,%esp
  801f0c:	50                   	push   %eax
  801f0d:	e8 b2 f2 ff ff       	call   8011c4 <fd2num>
  801f12:	83 c4 10             	add    $0x10,%esp
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801f1d:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801f24:	74 0a                	je     801f30 <set_pgfault_handler+0x19>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    
		int r = sys_page_alloc(0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P);	//为当前进程分配异常栈
  801f30:	83 ec 04             	sub    $0x4,%esp
  801f33:	6a 07                	push   $0x7
  801f35:	68 00 f0 bf ee       	push   $0xeebff000
  801f3a:	6a 00                	push   $0x0
  801f3c:	e8 d6 ed ff ff       	call   800d17 <sys_page_alloc>
		if (r < 0) {
  801f41:	83 c4 10             	add    $0x10,%esp
  801f44:	85 c0                	test   %eax,%eax
  801f46:	78 14                	js     801f5c <set_pgfault_handler+0x45>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
  801f48:	83 ec 08             	sub    $0x8,%esp
  801f4b:	68 70 1f 80 00       	push   $0x801f70
  801f50:	6a 00                	push   $0x0
  801f52:	e8 0b ef ff ff       	call   800e62 <sys_env_set_pgfault_upcall>
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	eb ca                	jmp    801f26 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler:sys_page_alloc failed");;
  801f5c:	83 ec 04             	sub    $0x4,%esp
  801f5f:	68 50 29 80 00       	push   $0x802950
  801f64:	6a 22                	push   $0x22
  801f66:	68 7c 29 80 00       	push   $0x80297c
  801f6b:	e8 b4 e2 ff ff       	call   800224 <_panic>

00801f70 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f70:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f71:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax				//调用页处理函数
  801f76:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801f78:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp			//跳过utf_fault_va和utf_err
  801f7b:	83 c4 08             	add    $0x8,%esp
	movl 40(%esp), %eax 	//保存中断发生时的esp到eax
  801f7e:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl 32(%esp), %ecx 	//保存终端发生时的eip到ecx
  801f82:	8b 4c 24 20          	mov    0x20(%esp),%ecx
	movl %ecx, -4(%eax) 	//将中断发生时的esp值亚入到到原来的栈中
  801f86:	89 48 fc             	mov    %ecx,-0x4(%eax)
	popal
  801f89:	61                   	popa   
	addl $4, %esp			//跳过eip
  801f8a:	83 c4 04             	add    $0x4,%esp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801f8d:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801f8e:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	lea -4(%esp), %esp		//因为之前压入了eip的值但是没有减esp的值，所以现在需要将esp寄存器中的值减4
  801f8f:	8d 64 24 fc          	lea    -0x4(%esp),%esp
  801f93:	c3                   	ret    

00801f94 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	56                   	push   %esi
  801f98:	53                   	push   %ebx
  801f99:	8b 75 08             	mov    0x8(%ebp),%esi
  801f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801fa2:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  801fa4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801fa9:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  801fac:	83 ec 0c             	sub    $0xc,%esp
  801faf:	50                   	push   %eax
  801fb0:	e8 12 ef ff ff       	call   800ec7 <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	78 2b                	js     801fe7 <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  801fbc:	85 f6                	test   %esi,%esi
  801fbe:	74 0a                	je     801fca <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801fc0:	a1 20 44 80 00       	mov    0x804420,%eax
  801fc5:	8b 40 74             	mov    0x74(%eax),%eax
  801fc8:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  801fca:	85 db                	test   %ebx,%ebx
  801fcc:	74 0a                	je     801fd8 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801fce:	a1 20 44 80 00       	mov    0x804420,%eax
  801fd3:	8b 40 78             	mov    0x78(%eax),%eax
  801fd6:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801fd8:	a1 20 44 80 00       	mov    0x804420,%eax
  801fdd:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fe0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe3:	5b                   	pop    %ebx
  801fe4:	5e                   	pop    %esi
  801fe5:	5d                   	pop    %ebp
  801fe6:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  801fe7:	85 f6                	test   %esi,%esi
  801fe9:	74 06                	je     801ff1 <ipc_recv+0x5d>
  801feb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801ff1:	85 db                	test   %ebx,%ebx
  801ff3:	74 eb                	je     801fe0 <ipc_recv+0x4c>
  801ff5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ffb:	eb e3                	jmp    801fe0 <ipc_recv+0x4c>

00801ffd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	57                   	push   %edi
  802001:	56                   	push   %esi
  802002:	53                   	push   %ebx
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	8b 7d 08             	mov    0x8(%ebp),%edi
  802009:	8b 75 0c             	mov    0xc(%ebp),%esi
  80200c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  80200f:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  802011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802016:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  802019:	ff 75 14             	pushl  0x14(%ebp)
  80201c:	53                   	push   %ebx
  80201d:	56                   	push   %esi
  80201e:	57                   	push   %edi
  80201f:	e8 80 ee ff ff       	call   800ea4 <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	85 c0                	test   %eax,%eax
  802029:	74 1e                	je     802049 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  80202b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80202e:	75 07                	jne    802037 <ipc_send+0x3a>
			sys_yield();
  802030:	e8 c3 ec ff ff       	call   800cf8 <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  802035:	eb e2                	jmp    802019 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  802037:	50                   	push   %eax
  802038:	68 8a 29 80 00       	push   $0x80298a
  80203d:	6a 41                	push   $0x41
  80203f:	68 98 29 80 00       	push   $0x802998
  802044:	e8 db e1 ff ff       	call   800224 <_panic>
		}
	}
}
  802049:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80204c:	5b                   	pop    %ebx
  80204d:	5e                   	pop    %esi
  80204e:	5f                   	pop    %edi
  80204f:	5d                   	pop    %ebp
  802050:	c3                   	ret    

00802051 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80205c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80205f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802065:	8b 52 50             	mov    0x50(%edx),%edx
  802068:	39 ca                	cmp    %ecx,%edx
  80206a:	74 11                	je     80207d <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80206c:	83 c0 01             	add    $0x1,%eax
  80206f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802074:	75 e6                	jne    80205c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802076:	b8 00 00 00 00       	mov    $0x0,%eax
  80207b:	eb 0b                	jmp    802088 <ipc_find_env+0x37>
			return envs[i].env_id;
  80207d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802080:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802085:	8b 40 48             	mov    0x48(%eax),%eax
}
  802088:	5d                   	pop    %ebp
  802089:	c3                   	ret    

0080208a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802090:	89 d0                	mov    %edx,%eax
  802092:	c1 e8 16             	shr    $0x16,%eax
  802095:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80209c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020a1:	f6 c1 01             	test   $0x1,%cl
  8020a4:	74 1d                	je     8020c3 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020a6:	c1 ea 0c             	shr    $0xc,%edx
  8020a9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020b0:	f6 c2 01             	test   $0x1,%dl
  8020b3:	74 0e                	je     8020c3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020b5:	c1 ea 0c             	shr    $0xc,%edx
  8020b8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020bf:	ef 
  8020c0:	0f b7 c0             	movzwl %ax,%eax
}
  8020c3:	5d                   	pop    %ebp
  8020c4:	c3                   	ret    
  8020c5:	66 90                	xchg   %ax,%ax
  8020c7:	66 90                	xchg   %ax,%ax
  8020c9:	66 90                	xchg   %ax,%ax
  8020cb:	66 90                	xchg   %ax,%ax
  8020cd:	66 90                	xchg   %ax,%ax
  8020cf:	90                   	nop

008020d0 <__udivdi3>:
  8020d0:	55                   	push   %ebp
  8020d1:	57                   	push   %edi
  8020d2:	56                   	push   %esi
  8020d3:	53                   	push   %ebx
  8020d4:	83 ec 1c             	sub    $0x1c,%esp
  8020d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020e7:	85 d2                	test   %edx,%edx
  8020e9:	75 35                	jne    802120 <__udivdi3+0x50>
  8020eb:	39 f3                	cmp    %esi,%ebx
  8020ed:	0f 87 bd 00 00 00    	ja     8021b0 <__udivdi3+0xe0>
  8020f3:	85 db                	test   %ebx,%ebx
  8020f5:	89 d9                	mov    %ebx,%ecx
  8020f7:	75 0b                	jne    802104 <__udivdi3+0x34>
  8020f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020fe:	31 d2                	xor    %edx,%edx
  802100:	f7 f3                	div    %ebx
  802102:	89 c1                	mov    %eax,%ecx
  802104:	31 d2                	xor    %edx,%edx
  802106:	89 f0                	mov    %esi,%eax
  802108:	f7 f1                	div    %ecx
  80210a:	89 c6                	mov    %eax,%esi
  80210c:	89 e8                	mov    %ebp,%eax
  80210e:	89 f7                	mov    %esi,%edi
  802110:	f7 f1                	div    %ecx
  802112:	89 fa                	mov    %edi,%edx
  802114:	83 c4 1c             	add    $0x1c,%esp
  802117:	5b                   	pop    %ebx
  802118:	5e                   	pop    %esi
  802119:	5f                   	pop    %edi
  80211a:	5d                   	pop    %ebp
  80211b:	c3                   	ret    
  80211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802120:	39 f2                	cmp    %esi,%edx
  802122:	77 7c                	ja     8021a0 <__udivdi3+0xd0>
  802124:	0f bd fa             	bsr    %edx,%edi
  802127:	83 f7 1f             	xor    $0x1f,%edi
  80212a:	0f 84 98 00 00 00    	je     8021c8 <__udivdi3+0xf8>
  802130:	89 f9                	mov    %edi,%ecx
  802132:	b8 20 00 00 00       	mov    $0x20,%eax
  802137:	29 f8                	sub    %edi,%eax
  802139:	d3 e2                	shl    %cl,%edx
  80213b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80213f:	89 c1                	mov    %eax,%ecx
  802141:	89 da                	mov    %ebx,%edx
  802143:	d3 ea                	shr    %cl,%edx
  802145:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802149:	09 d1                	or     %edx,%ecx
  80214b:	89 f2                	mov    %esi,%edx
  80214d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802151:	89 f9                	mov    %edi,%ecx
  802153:	d3 e3                	shl    %cl,%ebx
  802155:	89 c1                	mov    %eax,%ecx
  802157:	d3 ea                	shr    %cl,%edx
  802159:	89 f9                	mov    %edi,%ecx
  80215b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80215f:	d3 e6                	shl    %cl,%esi
  802161:	89 eb                	mov    %ebp,%ebx
  802163:	89 c1                	mov    %eax,%ecx
  802165:	d3 eb                	shr    %cl,%ebx
  802167:	09 de                	or     %ebx,%esi
  802169:	89 f0                	mov    %esi,%eax
  80216b:	f7 74 24 08          	divl   0x8(%esp)
  80216f:	89 d6                	mov    %edx,%esi
  802171:	89 c3                	mov    %eax,%ebx
  802173:	f7 64 24 0c          	mull   0xc(%esp)
  802177:	39 d6                	cmp    %edx,%esi
  802179:	72 0c                	jb     802187 <__udivdi3+0xb7>
  80217b:	89 f9                	mov    %edi,%ecx
  80217d:	d3 e5                	shl    %cl,%ebp
  80217f:	39 c5                	cmp    %eax,%ebp
  802181:	73 5d                	jae    8021e0 <__udivdi3+0x110>
  802183:	39 d6                	cmp    %edx,%esi
  802185:	75 59                	jne    8021e0 <__udivdi3+0x110>
  802187:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80218a:	31 ff                	xor    %edi,%edi
  80218c:	89 fa                	mov    %edi,%edx
  80218e:	83 c4 1c             	add    $0x1c,%esp
  802191:	5b                   	pop    %ebx
  802192:	5e                   	pop    %esi
  802193:	5f                   	pop    %edi
  802194:	5d                   	pop    %ebp
  802195:	c3                   	ret    
  802196:	8d 76 00             	lea    0x0(%esi),%esi
  802199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021a0:	31 ff                	xor    %edi,%edi
  8021a2:	31 c0                	xor    %eax,%eax
  8021a4:	89 fa                	mov    %edi,%edx
  8021a6:	83 c4 1c             	add    $0x1c,%esp
  8021a9:	5b                   	pop    %ebx
  8021aa:	5e                   	pop    %esi
  8021ab:	5f                   	pop    %edi
  8021ac:	5d                   	pop    %ebp
  8021ad:	c3                   	ret    
  8021ae:	66 90                	xchg   %ax,%ax
  8021b0:	31 ff                	xor    %edi,%edi
  8021b2:	89 e8                	mov    %ebp,%eax
  8021b4:	89 f2                	mov    %esi,%edx
  8021b6:	f7 f3                	div    %ebx
  8021b8:	89 fa                	mov    %edi,%edx
  8021ba:	83 c4 1c             	add    $0x1c,%esp
  8021bd:	5b                   	pop    %ebx
  8021be:	5e                   	pop    %esi
  8021bf:	5f                   	pop    %edi
  8021c0:	5d                   	pop    %ebp
  8021c1:	c3                   	ret    
  8021c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021c8:	39 f2                	cmp    %esi,%edx
  8021ca:	72 06                	jb     8021d2 <__udivdi3+0x102>
  8021cc:	31 c0                	xor    %eax,%eax
  8021ce:	39 eb                	cmp    %ebp,%ebx
  8021d0:	77 d2                	ja     8021a4 <__udivdi3+0xd4>
  8021d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d7:	eb cb                	jmp    8021a4 <__udivdi3+0xd4>
  8021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021e0:	89 d8                	mov    %ebx,%eax
  8021e2:	31 ff                	xor    %edi,%edi
  8021e4:	eb be                	jmp    8021a4 <__udivdi3+0xd4>
  8021e6:	66 90                	xchg   %ax,%ax
  8021e8:	66 90                	xchg   %ax,%ax
  8021ea:	66 90                	xchg   %ax,%ax
  8021ec:	66 90                	xchg   %ax,%ax
  8021ee:	66 90                	xchg   %ax,%ax

008021f0 <__umoddi3>:
  8021f0:	55                   	push   %ebp
  8021f1:	57                   	push   %edi
  8021f2:	56                   	push   %esi
  8021f3:	53                   	push   %ebx
  8021f4:	83 ec 1c             	sub    $0x1c,%esp
  8021f7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8021fb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021ff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802203:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802207:	85 ed                	test   %ebp,%ebp
  802209:	89 f0                	mov    %esi,%eax
  80220b:	89 da                	mov    %ebx,%edx
  80220d:	75 19                	jne    802228 <__umoddi3+0x38>
  80220f:	39 df                	cmp    %ebx,%edi
  802211:	0f 86 b1 00 00 00    	jbe    8022c8 <__umoddi3+0xd8>
  802217:	f7 f7                	div    %edi
  802219:	89 d0                	mov    %edx,%eax
  80221b:	31 d2                	xor    %edx,%edx
  80221d:	83 c4 1c             	add    $0x1c,%esp
  802220:	5b                   	pop    %ebx
  802221:	5e                   	pop    %esi
  802222:	5f                   	pop    %edi
  802223:	5d                   	pop    %ebp
  802224:	c3                   	ret    
  802225:	8d 76 00             	lea    0x0(%esi),%esi
  802228:	39 dd                	cmp    %ebx,%ebp
  80222a:	77 f1                	ja     80221d <__umoddi3+0x2d>
  80222c:	0f bd cd             	bsr    %ebp,%ecx
  80222f:	83 f1 1f             	xor    $0x1f,%ecx
  802232:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802236:	0f 84 b4 00 00 00    	je     8022f0 <__umoddi3+0x100>
  80223c:	b8 20 00 00 00       	mov    $0x20,%eax
  802241:	89 c2                	mov    %eax,%edx
  802243:	8b 44 24 04          	mov    0x4(%esp),%eax
  802247:	29 c2                	sub    %eax,%edx
  802249:	89 c1                	mov    %eax,%ecx
  80224b:	89 f8                	mov    %edi,%eax
  80224d:	d3 e5                	shl    %cl,%ebp
  80224f:	89 d1                	mov    %edx,%ecx
  802251:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802255:	d3 e8                	shr    %cl,%eax
  802257:	09 c5                	or     %eax,%ebp
  802259:	8b 44 24 04          	mov    0x4(%esp),%eax
  80225d:	89 c1                	mov    %eax,%ecx
  80225f:	d3 e7                	shl    %cl,%edi
  802261:	89 d1                	mov    %edx,%ecx
  802263:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802267:	89 df                	mov    %ebx,%edi
  802269:	d3 ef                	shr    %cl,%edi
  80226b:	89 c1                	mov    %eax,%ecx
  80226d:	89 f0                	mov    %esi,%eax
  80226f:	d3 e3                	shl    %cl,%ebx
  802271:	89 d1                	mov    %edx,%ecx
  802273:	89 fa                	mov    %edi,%edx
  802275:	d3 e8                	shr    %cl,%eax
  802277:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80227c:	09 d8                	or     %ebx,%eax
  80227e:	f7 f5                	div    %ebp
  802280:	d3 e6                	shl    %cl,%esi
  802282:	89 d1                	mov    %edx,%ecx
  802284:	f7 64 24 08          	mull   0x8(%esp)
  802288:	39 d1                	cmp    %edx,%ecx
  80228a:	89 c3                	mov    %eax,%ebx
  80228c:	89 d7                	mov    %edx,%edi
  80228e:	72 06                	jb     802296 <__umoddi3+0xa6>
  802290:	75 0e                	jne    8022a0 <__umoddi3+0xb0>
  802292:	39 c6                	cmp    %eax,%esi
  802294:	73 0a                	jae    8022a0 <__umoddi3+0xb0>
  802296:	2b 44 24 08          	sub    0x8(%esp),%eax
  80229a:	19 ea                	sbb    %ebp,%edx
  80229c:	89 d7                	mov    %edx,%edi
  80229e:	89 c3                	mov    %eax,%ebx
  8022a0:	89 ca                	mov    %ecx,%edx
  8022a2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022a7:	29 de                	sub    %ebx,%esi
  8022a9:	19 fa                	sbb    %edi,%edx
  8022ab:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8022af:	89 d0                	mov    %edx,%eax
  8022b1:	d3 e0                	shl    %cl,%eax
  8022b3:	89 d9                	mov    %ebx,%ecx
  8022b5:	d3 ee                	shr    %cl,%esi
  8022b7:	d3 ea                	shr    %cl,%edx
  8022b9:	09 f0                	or     %esi,%eax
  8022bb:	83 c4 1c             	add    $0x1c,%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5e                   	pop    %esi
  8022c0:	5f                   	pop    %edi
  8022c1:	5d                   	pop    %ebp
  8022c2:	c3                   	ret    
  8022c3:	90                   	nop
  8022c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022c8:	85 ff                	test   %edi,%edi
  8022ca:	89 f9                	mov    %edi,%ecx
  8022cc:	75 0b                	jne    8022d9 <__umoddi3+0xe9>
  8022ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d3:	31 d2                	xor    %edx,%edx
  8022d5:	f7 f7                	div    %edi
  8022d7:	89 c1                	mov    %eax,%ecx
  8022d9:	89 d8                	mov    %ebx,%eax
  8022db:	31 d2                	xor    %edx,%edx
  8022dd:	f7 f1                	div    %ecx
  8022df:	89 f0                	mov    %esi,%eax
  8022e1:	f7 f1                	div    %ecx
  8022e3:	e9 31 ff ff ff       	jmp    802219 <__umoddi3+0x29>
  8022e8:	90                   	nop
  8022e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022f0:	39 dd                	cmp    %ebx,%ebp
  8022f2:	72 08                	jb     8022fc <__umoddi3+0x10c>
  8022f4:	39 f7                	cmp    %esi,%edi
  8022f6:	0f 87 21 ff ff ff    	ja     80221d <__umoddi3+0x2d>
  8022fc:	89 da                	mov    %ebx,%edx
  8022fe:	89 f0                	mov    %esi,%eax
  802300:	29 f8                	sub    %edi,%eax
  802302:	19 ea                	sbb    %ebp,%edx
  802304:	e9 14 ff ff ff       	jmp    80221d <__umoddi3+0x2d>
