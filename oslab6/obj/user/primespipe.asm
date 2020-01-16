
obj/user/primespipe.debug：     文件格式 elf32-i386


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
  80002c:	e8 04 02 00 00       	call   800235 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
	if ((r = readn(fd, &p, 4)) != 4)
  800045:	83 ec 04             	sub    $0x4,%esp
  800048:	6a 04                	push   $0x4
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	e8 4a 15 00 00       	call   80159b <readn>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	83 f8 04             	cmp    $0x4,%eax
  800057:	75 4b                	jne    8000a4 <primeproc+0x71>
	cprintf("%d\n", p);
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	ff 75 e0             	pushl  -0x20(%ebp)
  80005f:	68 61 23 80 00       	push   $0x802361
  800064:	e8 ff 02 00 00       	call   800368 <cprintf>
	if ((i=pipe(pfd)) < 0)
  800069:	89 3c 24             	mov    %edi,(%esp)
  80006c:	e8 c7 1b 00 00       	call   801c38 <pipe>
  800071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	85 c0                	test   %eax,%eax
  800079:	78 49                	js     8000c4 <primeproc+0x91>
		panic("pipe: %e", i);
	if ((id = fork()) < 0)
  80007b:	e8 c1 0f 00 00       	call   801041 <fork>
  800080:	85 c0                	test   %eax,%eax
  800082:	78 52                	js     8000d6 <primeproc+0xa3>
		panic("fork: %e", id);
	if (id == 0) {
  800084:	85 c0                	test   %eax,%eax
  800086:	75 60                	jne    8000e8 <primeproc+0xb5>
		close(fd);
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	53                   	push   %ebx
  80008c:	e8 47 13 00 00       	call   8013d8 <close>
		close(pfd[1]);
  800091:	83 c4 04             	add    $0x4,%esp
  800094:	ff 75 dc             	pushl  -0x24(%ebp)
  800097:	e8 3c 13 00 00       	call   8013d8 <close>
		fd = pfd[0];
  80009c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	eb a1                	jmp    800045 <primeproc+0x12>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	85 c0                	test   %eax,%eax
  8000a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ae:	0f 4e d0             	cmovle %eax,%edx
  8000b1:	52                   	push   %edx
  8000b2:	50                   	push   %eax
  8000b3:	68 20 23 80 00       	push   $0x802320
  8000b8:	6a 15                	push   $0x15
  8000ba:	68 4f 23 80 00       	push   $0x80234f
  8000bf:	e8 c9 01 00 00       	call   80028d <_panic>
		panic("pipe: %e", i);
  8000c4:	50                   	push   %eax
  8000c5:	68 65 23 80 00       	push   $0x802365
  8000ca:	6a 1b                	push   $0x1b
  8000cc:	68 4f 23 80 00       	push   $0x80234f
  8000d1:	e8 b7 01 00 00       	call   80028d <_panic>
		panic("fork: %e", id);
  8000d6:	50                   	push   %eax
  8000d7:	68 85 27 80 00       	push   $0x802785
  8000dc:	6a 1d                	push   $0x1d
  8000de:	68 4f 23 80 00       	push   $0x80234f
  8000e3:	e8 a5 01 00 00       	call   80028d <_panic>
	}

	close(pfd[0]);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8000ee:	e8 e5 12 00 00       	call   8013d8 <close>
	wfd = pfd[1];
  8000f3:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f6:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000f9:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 04                	push   $0x4
  800101:	56                   	push   %esi
  800102:	53                   	push   %ebx
  800103:	e8 93 14 00 00       	call   80159b <readn>
  800108:	83 c4 10             	add    $0x10,%esp
  80010b:	83 f8 04             	cmp    $0x4,%eax
  80010e:	75 42                	jne    800152 <primeproc+0x11f>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
  800110:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800113:	99                   	cltd   
  800114:	f7 7d e0             	idivl  -0x20(%ebp)
  800117:	85 d2                	test   %edx,%edx
  800119:	74 e1                	je     8000fc <primeproc+0xc9>
			if ((r=write(wfd, &i, 4)) != 4)
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 04                	push   $0x4
  800120:	56                   	push   %esi
  800121:	57                   	push   %edi
  800122:	e8 bb 14 00 00       	call   8015e2 <write>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	83 f8 04             	cmp    $0x4,%eax
  80012d:	74 cd                	je     8000fc <primeproc+0xc9>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80012f:	83 ec 08             	sub    $0x8,%esp
  800132:	85 c0                	test   %eax,%eax
  800134:	ba 00 00 00 00       	mov    $0x0,%edx
  800139:	0f 4e d0             	cmovle %eax,%edx
  80013c:	52                   	push   %edx
  80013d:	50                   	push   %eax
  80013e:	ff 75 e0             	pushl  -0x20(%ebp)
  800141:	68 8a 23 80 00       	push   $0x80238a
  800146:	6a 2e                	push   $0x2e
  800148:	68 4f 23 80 00       	push   $0x80234f
  80014d:	e8 3b 01 00 00       	call   80028d <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	85 c0                	test   %eax,%eax
  800157:	ba 00 00 00 00       	mov    $0x0,%edx
  80015c:	0f 4e d0             	cmovle %eax,%edx
  80015f:	52                   	push   %edx
  800160:	50                   	push   %eax
  800161:	53                   	push   %ebx
  800162:	ff 75 e0             	pushl  -0x20(%ebp)
  800165:	68 6e 23 80 00       	push   $0x80236e
  80016a:	6a 2b                	push   $0x2b
  80016c:	68 4f 23 80 00       	push   $0x80234f
  800171:	e8 17 01 00 00       	call   80028d <_panic>

00800176 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800176:	55                   	push   %ebp
  800177:	89 e5                	mov    %esp,%ebp
  800179:	53                   	push   %ebx
  80017a:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  80017d:	c7 05 00 30 80 00 a4 	movl   $0x8023a4,0x803000
  800184:	23 80 00 

	if ((i=pipe(p)) < 0)
  800187:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80018a:	50                   	push   %eax
  80018b:	e8 a8 1a 00 00       	call   801c38 <pipe>
  800190:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	85 c0                	test   %eax,%eax
  800198:	78 23                	js     8001bd <umain+0x47>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80019a:	e8 a2 0e 00 00       	call   801041 <fork>
  80019f:	85 c0                	test   %eax,%eax
  8001a1:	78 2c                	js     8001cf <umain+0x59>
		panic("fork: %e", id);

	if (id == 0) {
  8001a3:	85 c0                	test   %eax,%eax
  8001a5:	75 3a                	jne    8001e1 <umain+0x6b>
		close(p[1]);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ad:	e8 26 12 00 00       	call   8013d8 <close>
		primeproc(p[0]);
  8001b2:	83 c4 04             	add    $0x4,%esp
  8001b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b8:	e8 76 fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001bd:	50                   	push   %eax
  8001be:	68 65 23 80 00       	push   $0x802365
  8001c3:	6a 3a                	push   $0x3a
  8001c5:	68 4f 23 80 00       	push   $0x80234f
  8001ca:	e8 be 00 00 00       	call   80028d <_panic>
		panic("fork: %e", id);
  8001cf:	50                   	push   %eax
  8001d0:	68 85 27 80 00       	push   $0x802785
  8001d5:	6a 3e                	push   $0x3e
  8001d7:	68 4f 23 80 00       	push   $0x80234f
  8001dc:	e8 ac 00 00 00       	call   80028d <_panic>
	}

	close(p[0]);
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e7:	e8 ec 11 00 00       	call   8013d8 <close>

	// feed all the integers through
	for (i=2;; i++)
  8001ec:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  8001f3:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001f6:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001f9:	83 ec 04             	sub    $0x4,%esp
  8001fc:	6a 04                	push   $0x4
  8001fe:	53                   	push   %ebx
  8001ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800202:	e8 db 13 00 00       	call   8015e2 <write>
  800207:	83 c4 10             	add    $0x10,%esp
  80020a:	83 f8 04             	cmp    $0x4,%eax
  80020d:	75 06                	jne    800215 <umain+0x9f>
	for (i=2;; i++)
  80020f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  800213:	eb e4                	jmp    8001f9 <umain+0x83>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	85 c0                	test   %eax,%eax
  80021a:	ba 00 00 00 00       	mov    $0x0,%edx
  80021f:	0f 4e d0             	cmovle %eax,%edx
  800222:	52                   	push   %edx
  800223:	50                   	push   %eax
  800224:	68 af 23 80 00       	push   $0x8023af
  800229:	6a 4a                	push   $0x4a
  80022b:	68 4f 23 80 00       	push   $0x80234f
  800230:	e8 58 00 00 00       	call   80028d <_panic>

00800235 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	56                   	push   %esi
  800239:	53                   	push   %ebx
  80023a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80023d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  800240:	e8 fd 0a 00 00       	call   800d42 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  800245:	25 ff 03 00 00       	and    $0x3ff,%eax
  80024a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80024d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800252:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800257:	85 db                	test   %ebx,%ebx
  800259:	7e 07                	jle    800262 <libmain+0x2d>
		binaryname = argv[0];
  80025b:	8b 06                	mov    (%esi),%eax
  80025d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	56                   	push   %esi
  800266:	53                   	push   %ebx
  800267:	e8 0a ff ff ff       	call   800176 <umain>

	// exit gracefully
	exit();
  80026c:	e8 0a 00 00 00       	call   80027b <exit>
}
  800271:	83 c4 10             	add    $0x10,%esp
  800274:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800277:	5b                   	pop    %ebx
  800278:	5e                   	pop    %esi
  800279:	5d                   	pop    %ebp
  80027a:	c3                   	ret    

0080027b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800281:	6a 00                	push   $0x0
  800283:	e8 79 0a 00 00       	call   800d01 <sys_env_destroy>
}
  800288:	83 c4 10             	add    $0x10,%esp
  80028b:	c9                   	leave  
  80028c:	c3                   	ret    

0080028d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	56                   	push   %esi
  800291:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800292:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800295:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80029b:	e8 a2 0a 00 00       	call   800d42 <sys_getenvid>
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	ff 75 0c             	pushl  0xc(%ebp)
  8002a6:	ff 75 08             	pushl  0x8(%ebp)
  8002a9:	56                   	push   %esi
  8002aa:	50                   	push   %eax
  8002ab:	68 d4 23 80 00       	push   $0x8023d4
  8002b0:	e8 b3 00 00 00       	call   800368 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b5:	83 c4 18             	add    $0x18,%esp
  8002b8:	53                   	push   %ebx
  8002b9:	ff 75 10             	pushl  0x10(%ebp)
  8002bc:	e8 56 00 00 00       	call   800317 <vcprintf>
	cprintf("\n");
  8002c1:	c7 04 24 63 23 80 00 	movl   $0x802363,(%esp)
  8002c8:	e8 9b 00 00 00       	call   800368 <cprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002d0:	cc                   	int3   
  8002d1:	eb fd                	jmp    8002d0 <_panic+0x43>

008002d3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	53                   	push   %ebx
  8002d7:	83 ec 04             	sub    $0x4,%esp
  8002da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002dd:	8b 13                	mov    (%ebx),%edx
  8002df:	8d 42 01             	lea    0x1(%edx),%eax
  8002e2:	89 03                	mov    %eax,(%ebx)
  8002e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002eb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002f0:	74 09                	je     8002fb <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002f2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002f9:	c9                   	leave  
  8002fa:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002fb:	83 ec 08             	sub    $0x8,%esp
  8002fe:	68 ff 00 00 00       	push   $0xff
  800303:	8d 43 08             	lea    0x8(%ebx),%eax
  800306:	50                   	push   %eax
  800307:	e8 b8 09 00 00       	call   800cc4 <sys_cputs>
		b->idx = 0;
  80030c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800312:	83 c4 10             	add    $0x10,%esp
  800315:	eb db                	jmp    8002f2 <putch+0x1f>

00800317 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800320:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800327:	00 00 00 
	b.cnt = 0;
  80032a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800331:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800334:	ff 75 0c             	pushl  0xc(%ebp)
  800337:	ff 75 08             	pushl  0x8(%ebp)
  80033a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800340:	50                   	push   %eax
  800341:	68 d3 02 80 00       	push   $0x8002d3
  800346:	e8 1a 01 00 00       	call   800465 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80034b:	83 c4 08             	add    $0x8,%esp
  80034e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800354:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80035a:	50                   	push   %eax
  80035b:	e8 64 09 00 00       	call   800cc4 <sys_cputs>

	return b.cnt;
}
  800360:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80036e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800371:	50                   	push   %eax
  800372:	ff 75 08             	pushl  0x8(%ebp)
  800375:	e8 9d ff ff ff       	call   800317 <vcprintf>
	va_end(ap);

	return cnt;
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	57                   	push   %edi
  800380:	56                   	push   %esi
  800381:	53                   	push   %ebx
  800382:	83 ec 1c             	sub    $0x1c,%esp
  800385:	89 c7                	mov    %eax,%edi
  800387:	89 d6                	mov    %edx,%esi
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800392:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800395:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800398:	bb 00 00 00 00       	mov    $0x0,%ebx
  80039d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003a0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8003a3:	39 d3                	cmp    %edx,%ebx
  8003a5:	72 05                	jb     8003ac <printnum+0x30>
  8003a7:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003aa:	77 7a                	ja     800426 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	ff 75 18             	pushl  0x18(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003b8:	53                   	push   %ebx
  8003b9:	ff 75 10             	pushl  0x10(%ebp)
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003c5:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8003cb:	e8 10 1d 00 00       	call   8020e0 <__udivdi3>
  8003d0:	83 c4 18             	add    $0x18,%esp
  8003d3:	52                   	push   %edx
  8003d4:	50                   	push   %eax
  8003d5:	89 f2                	mov    %esi,%edx
  8003d7:	89 f8                	mov    %edi,%eax
  8003d9:	e8 9e ff ff ff       	call   80037c <printnum>
  8003de:	83 c4 20             	add    $0x20,%esp
  8003e1:	eb 13                	jmp    8003f6 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003e3:	83 ec 08             	sub    $0x8,%esp
  8003e6:	56                   	push   %esi
  8003e7:	ff 75 18             	pushl  0x18(%ebp)
  8003ea:	ff d7                	call   *%edi
  8003ec:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003ef:	83 eb 01             	sub    $0x1,%ebx
  8003f2:	85 db                	test   %ebx,%ebx
  8003f4:	7f ed                	jg     8003e3 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	56                   	push   %esi
  8003fa:	83 ec 04             	sub    $0x4,%esp
  8003fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800400:	ff 75 e0             	pushl  -0x20(%ebp)
  800403:	ff 75 dc             	pushl  -0x24(%ebp)
  800406:	ff 75 d8             	pushl  -0x28(%ebp)
  800409:	e8 f2 1d 00 00       	call   802200 <__umoddi3>
  80040e:	83 c4 14             	add    $0x14,%esp
  800411:	0f be 80 f7 23 80 00 	movsbl 0x8023f7(%eax),%eax
  800418:	50                   	push   %eax
  800419:	ff d7                	call   *%edi
}
  80041b:	83 c4 10             	add    $0x10,%esp
  80041e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800421:	5b                   	pop    %ebx
  800422:	5e                   	pop    %esi
  800423:	5f                   	pop    %edi
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    
  800426:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800429:	eb c4                	jmp    8003ef <printnum+0x73>

0080042b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80042b:	55                   	push   %ebp
  80042c:	89 e5                	mov    %esp,%ebp
  80042e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800431:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800435:	8b 10                	mov    (%eax),%edx
  800437:	3b 50 04             	cmp    0x4(%eax),%edx
  80043a:	73 0a                	jae    800446 <sprintputch+0x1b>
		*b->buf++ = ch;
  80043c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80043f:	89 08                	mov    %ecx,(%eax)
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	88 02                	mov    %al,(%edx)
}
  800446:	5d                   	pop    %ebp
  800447:	c3                   	ret    

00800448 <printfmt>:
{
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80044e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800451:	50                   	push   %eax
  800452:	ff 75 10             	pushl  0x10(%ebp)
  800455:	ff 75 0c             	pushl  0xc(%ebp)
  800458:	ff 75 08             	pushl  0x8(%ebp)
  80045b:	e8 05 00 00 00       	call   800465 <vprintfmt>
}
  800460:	83 c4 10             	add    $0x10,%esp
  800463:	c9                   	leave  
  800464:	c3                   	ret    

00800465 <vprintfmt>:
{
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
  800468:	57                   	push   %edi
  800469:	56                   	push   %esi
  80046a:	53                   	push   %ebx
  80046b:	83 ec 2c             	sub    $0x2c,%esp
  80046e:	8b 75 08             	mov    0x8(%ebp),%esi
  800471:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800474:	8b 7d 10             	mov    0x10(%ebp),%edi
  800477:	e9 c1 03 00 00       	jmp    80083d <vprintfmt+0x3d8>
		padc = ' ';
  80047c:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800480:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800487:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80048e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800495:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	8d 47 01             	lea    0x1(%edi),%eax
  80049d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004a0:	0f b6 17             	movzbl (%edi),%edx
  8004a3:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004a6:	3c 55                	cmp    $0x55,%al
  8004a8:	0f 87 12 04 00 00    	ja     8008c0 <vprintfmt+0x45b>
  8004ae:	0f b6 c0             	movzbl %al,%eax
  8004b1:	ff 24 85 40 25 80 00 	jmp    *0x802540(,%eax,4)
  8004b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004bb:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8004bf:	eb d9                	jmp    80049a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004c4:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004c8:	eb d0                	jmp    80049a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004ca:	0f b6 d2             	movzbl %dl,%edx
  8004cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004d8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004db:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004df:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004e2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004e5:	83 f9 09             	cmp    $0x9,%ecx
  8004e8:	77 55                	ja     80053f <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8004ea:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004ed:	eb e9                	jmp    8004d8 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8004ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8d 40 04             	lea    0x4(%eax),%eax
  8004fd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800500:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800503:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800507:	79 91                	jns    80049a <vprintfmt+0x35>
				width = precision, precision = -1;
  800509:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80050c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80050f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800516:	eb 82                	jmp    80049a <vprintfmt+0x35>
  800518:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051b:	85 c0                	test   %eax,%eax
  80051d:	ba 00 00 00 00       	mov    $0x0,%edx
  800522:	0f 49 d0             	cmovns %eax,%edx
  800525:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800528:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80052b:	e9 6a ff ff ff       	jmp    80049a <vprintfmt+0x35>
  800530:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800533:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80053a:	e9 5b ff ff ff       	jmp    80049a <vprintfmt+0x35>
  80053f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800542:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800545:	eb bc                	jmp    800503 <vprintfmt+0x9e>
			lflag++;
  800547:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80054d:	e9 48 ff ff ff       	jmp    80049a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8d 78 04             	lea    0x4(%eax),%edi
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	53                   	push   %ebx
  80055c:	ff 30                	pushl  (%eax)
  80055e:	ff d6                	call   *%esi
			break;
  800560:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800563:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800566:	e9 cf 02 00 00       	jmp    80083a <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	8d 78 04             	lea    0x4(%eax),%edi
  800571:	8b 00                	mov    (%eax),%eax
  800573:	99                   	cltd   
  800574:	31 d0                	xor    %edx,%eax
  800576:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800578:	83 f8 0f             	cmp    $0xf,%eax
  80057b:	7f 23                	jg     8005a0 <vprintfmt+0x13b>
  80057d:	8b 14 85 a0 26 80 00 	mov    0x8026a0(,%eax,4),%edx
  800584:	85 d2                	test   %edx,%edx
  800586:	74 18                	je     8005a0 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800588:	52                   	push   %edx
  800589:	68 75 28 80 00       	push   $0x802875
  80058e:	53                   	push   %ebx
  80058f:	56                   	push   %esi
  800590:	e8 b3 fe ff ff       	call   800448 <printfmt>
  800595:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800598:	89 7d 14             	mov    %edi,0x14(%ebp)
  80059b:	e9 9a 02 00 00       	jmp    80083a <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8005a0:	50                   	push   %eax
  8005a1:	68 0f 24 80 00       	push   $0x80240f
  8005a6:	53                   	push   %ebx
  8005a7:	56                   	push   %esi
  8005a8:	e8 9b fe ff ff       	call   800448 <printfmt>
  8005ad:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005b3:	e9 82 02 00 00       	jmp    80083a <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	83 c0 04             	add    $0x4,%eax
  8005be:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005c6:	85 ff                	test   %edi,%edi
  8005c8:	b8 08 24 80 00       	mov    $0x802408,%eax
  8005cd:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8005d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005d4:	0f 8e bd 00 00 00    	jle    800697 <vprintfmt+0x232>
  8005da:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005de:	75 0e                	jne    8005ee <vprintfmt+0x189>
  8005e0:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005e6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005e9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005ec:	eb 6d                	jmp    80065b <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	ff 75 d0             	pushl  -0x30(%ebp)
  8005f4:	57                   	push   %edi
  8005f5:	e8 6e 03 00 00       	call   800968 <strnlen>
  8005fa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005fd:	29 c1                	sub    %eax,%ecx
  8005ff:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800602:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800605:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800609:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80060c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80060f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800611:	eb 0f                	jmp    800622 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	53                   	push   %ebx
  800617:	ff 75 e0             	pushl  -0x20(%ebp)
  80061a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80061c:	83 ef 01             	sub    $0x1,%edi
  80061f:	83 c4 10             	add    $0x10,%esp
  800622:	85 ff                	test   %edi,%edi
  800624:	7f ed                	jg     800613 <vprintfmt+0x1ae>
  800626:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800629:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80062c:	85 c9                	test   %ecx,%ecx
  80062e:	b8 00 00 00 00       	mov    $0x0,%eax
  800633:	0f 49 c1             	cmovns %ecx,%eax
  800636:	29 c1                	sub    %eax,%ecx
  800638:	89 75 08             	mov    %esi,0x8(%ebp)
  80063b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80063e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800641:	89 cb                	mov    %ecx,%ebx
  800643:	eb 16                	jmp    80065b <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800645:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800649:	75 31                	jne    80067c <vprintfmt+0x217>
					putch(ch, putdat);
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	50                   	push   %eax
  800652:	ff 55 08             	call   *0x8(%ebp)
  800655:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800658:	83 eb 01             	sub    $0x1,%ebx
  80065b:	83 c7 01             	add    $0x1,%edi
  80065e:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800662:	0f be c2             	movsbl %dl,%eax
  800665:	85 c0                	test   %eax,%eax
  800667:	74 59                	je     8006c2 <vprintfmt+0x25d>
  800669:	85 f6                	test   %esi,%esi
  80066b:	78 d8                	js     800645 <vprintfmt+0x1e0>
  80066d:	83 ee 01             	sub    $0x1,%esi
  800670:	79 d3                	jns    800645 <vprintfmt+0x1e0>
  800672:	89 df                	mov    %ebx,%edi
  800674:	8b 75 08             	mov    0x8(%ebp),%esi
  800677:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80067a:	eb 37                	jmp    8006b3 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80067c:	0f be d2             	movsbl %dl,%edx
  80067f:	83 ea 20             	sub    $0x20,%edx
  800682:	83 fa 5e             	cmp    $0x5e,%edx
  800685:	76 c4                	jbe    80064b <vprintfmt+0x1e6>
					putch('?', putdat);
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	ff 75 0c             	pushl  0xc(%ebp)
  80068d:	6a 3f                	push   $0x3f
  80068f:	ff 55 08             	call   *0x8(%ebp)
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	eb c1                	jmp    800658 <vprintfmt+0x1f3>
  800697:	89 75 08             	mov    %esi,0x8(%ebp)
  80069a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80069d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006a0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006a3:	eb b6                	jmp    80065b <vprintfmt+0x1f6>
				putch(' ', putdat);
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	53                   	push   %ebx
  8006a9:	6a 20                	push   $0x20
  8006ab:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006ad:	83 ef 01             	sub    $0x1,%edi
  8006b0:	83 c4 10             	add    $0x10,%esp
  8006b3:	85 ff                	test   %edi,%edi
  8006b5:	7f ee                	jg     8006a5 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8006b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8006bd:	e9 78 01 00 00       	jmp    80083a <vprintfmt+0x3d5>
  8006c2:	89 df                	mov    %ebx,%edi
  8006c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8006c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006ca:	eb e7                	jmp    8006b3 <vprintfmt+0x24e>
	if (lflag >= 2)
  8006cc:	83 f9 01             	cmp    $0x1,%ecx
  8006cf:	7e 3f                	jle    800710 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 50 04             	mov    0x4(%eax),%edx
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8d 40 08             	lea    0x8(%eax),%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006ec:	79 5c                	jns    80074a <vprintfmt+0x2e5>
				putch('-', putdat);
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	53                   	push   %ebx
  8006f2:	6a 2d                	push   $0x2d
  8006f4:	ff d6                	call   *%esi
				num = -(long long) num;
  8006f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006f9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006fc:	f7 da                	neg    %edx
  8006fe:	83 d1 00             	adc    $0x0,%ecx
  800701:	f7 d9                	neg    %ecx
  800703:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800706:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070b:	e9 10 01 00 00       	jmp    800820 <vprintfmt+0x3bb>
	else if (lflag)
  800710:	85 c9                	test   %ecx,%ecx
  800712:	75 1b                	jne    80072f <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8b 00                	mov    (%eax),%eax
  800719:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071c:	89 c1                	mov    %eax,%ecx
  80071e:	c1 f9 1f             	sar    $0x1f,%ecx
  800721:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8d 40 04             	lea    0x4(%eax),%eax
  80072a:	89 45 14             	mov    %eax,0x14(%ebp)
  80072d:	eb b9                	jmp    8006e8 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800737:	89 c1                	mov    %eax,%ecx
  800739:	c1 f9 1f             	sar    $0x1f,%ecx
  80073c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8d 40 04             	lea    0x4(%eax),%eax
  800745:	89 45 14             	mov    %eax,0x14(%ebp)
  800748:	eb 9e                	jmp    8006e8 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80074a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80074d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800750:	b8 0a 00 00 00       	mov    $0xa,%eax
  800755:	e9 c6 00 00 00       	jmp    800820 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80075a:	83 f9 01             	cmp    $0x1,%ecx
  80075d:	7e 18                	jle    800777 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8b 10                	mov    (%eax),%edx
  800764:	8b 48 04             	mov    0x4(%eax),%ecx
  800767:	8d 40 08             	lea    0x8(%eax),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80076d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800772:	e9 a9 00 00 00       	jmp    800820 <vprintfmt+0x3bb>
	else if (lflag)
  800777:	85 c9                	test   %ecx,%ecx
  800779:	75 1a                	jne    800795 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8b 10                	mov    (%eax),%edx
  800780:	b9 00 00 00 00       	mov    $0x0,%ecx
  800785:	8d 40 04             	lea    0x4(%eax),%eax
  800788:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80078b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800790:	e9 8b 00 00 00       	jmp    800820 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8b 10                	mov    (%eax),%edx
  80079a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80079f:	8d 40 04             	lea    0x4(%eax),%eax
  8007a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007aa:	eb 74                	jmp    800820 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8007ac:	83 f9 01             	cmp    $0x1,%ecx
  8007af:	7e 15                	jle    8007c6 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8b 10                	mov    (%eax),%edx
  8007b6:	8b 48 04             	mov    0x4(%eax),%ecx
  8007b9:	8d 40 08             	lea    0x8(%eax),%eax
  8007bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007bf:	b8 08 00 00 00       	mov    $0x8,%eax
  8007c4:	eb 5a                	jmp    800820 <vprintfmt+0x3bb>
	else if (lflag)
  8007c6:	85 c9                	test   %ecx,%ecx
  8007c8:	75 17                	jne    8007e1 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8b 10                	mov    (%eax),%edx
  8007cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d4:	8d 40 04             	lea    0x4(%eax),%eax
  8007d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007da:	b8 08 00 00 00       	mov    $0x8,%eax
  8007df:	eb 3f                	jmp    800820 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	8b 10                	mov    (%eax),%edx
  8007e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007eb:	8d 40 04             	lea    0x4(%eax),%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007f1:	b8 08 00 00 00       	mov    $0x8,%eax
  8007f6:	eb 28                	jmp    800820 <vprintfmt+0x3bb>
			putch('0', putdat);
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	53                   	push   %ebx
  8007fc:	6a 30                	push   $0x30
  8007fe:	ff d6                	call   *%esi
			putch('x', putdat);
  800800:	83 c4 08             	add    $0x8,%esp
  800803:	53                   	push   %ebx
  800804:	6a 78                	push   $0x78
  800806:	ff d6                	call   *%esi
			num = (unsigned long long)
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 10                	mov    (%eax),%edx
  80080d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800812:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800815:	8d 40 04             	lea    0x4(%eax),%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800820:	83 ec 0c             	sub    $0xc,%esp
  800823:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800827:	57                   	push   %edi
  800828:	ff 75 e0             	pushl  -0x20(%ebp)
  80082b:	50                   	push   %eax
  80082c:	51                   	push   %ecx
  80082d:	52                   	push   %edx
  80082e:	89 da                	mov    %ebx,%edx
  800830:	89 f0                	mov    %esi,%eax
  800832:	e8 45 fb ff ff       	call   80037c <printnum>
			break;
  800837:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80083a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  80083d:	83 c7 01             	add    $0x1,%edi
  800840:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800844:	83 f8 25             	cmp    $0x25,%eax
  800847:	0f 84 2f fc ff ff    	je     80047c <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  80084d:	85 c0                	test   %eax,%eax
  80084f:	0f 84 8b 00 00 00    	je     8008e0 <vprintfmt+0x47b>
			putch(ch, putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	53                   	push   %ebx
  800859:	50                   	push   %eax
  80085a:	ff d6                	call   *%esi
  80085c:	83 c4 10             	add    $0x10,%esp
  80085f:	eb dc                	jmp    80083d <vprintfmt+0x3d8>
	if (lflag >= 2)
  800861:	83 f9 01             	cmp    $0x1,%ecx
  800864:	7e 15                	jle    80087b <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8b 10                	mov    (%eax),%edx
  80086b:	8b 48 04             	mov    0x4(%eax),%ecx
  80086e:	8d 40 08             	lea    0x8(%eax),%eax
  800871:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800874:	b8 10 00 00 00       	mov    $0x10,%eax
  800879:	eb a5                	jmp    800820 <vprintfmt+0x3bb>
	else if (lflag)
  80087b:	85 c9                	test   %ecx,%ecx
  80087d:	75 17                	jne    800896 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8b 10                	mov    (%eax),%edx
  800884:	b9 00 00 00 00       	mov    $0x0,%ecx
  800889:	8d 40 04             	lea    0x4(%eax),%eax
  80088c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80088f:	b8 10 00 00 00       	mov    $0x10,%eax
  800894:	eb 8a                	jmp    800820 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800896:	8b 45 14             	mov    0x14(%ebp),%eax
  800899:	8b 10                	mov    (%eax),%edx
  80089b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008a0:	8d 40 04             	lea    0x4(%eax),%eax
  8008a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a6:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ab:	e9 70 ff ff ff       	jmp    800820 <vprintfmt+0x3bb>
			putch(ch, putdat);
  8008b0:	83 ec 08             	sub    $0x8,%esp
  8008b3:	53                   	push   %ebx
  8008b4:	6a 25                	push   $0x25
  8008b6:	ff d6                	call   *%esi
			break;
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	e9 7a ff ff ff       	jmp    80083a <vprintfmt+0x3d5>
			putch('%', putdat);
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	53                   	push   %ebx
  8008c4:	6a 25                	push   $0x25
  8008c6:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c8:	83 c4 10             	add    $0x10,%esp
  8008cb:	89 f8                	mov    %edi,%eax
  8008cd:	eb 03                	jmp    8008d2 <vprintfmt+0x46d>
  8008cf:	83 e8 01             	sub    $0x1,%eax
  8008d2:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008d6:	75 f7                	jne    8008cf <vprintfmt+0x46a>
  8008d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008db:	e9 5a ff ff ff       	jmp    80083a <vprintfmt+0x3d5>
}
  8008e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e3:	5b                   	pop    %ebx
  8008e4:	5e                   	pop    %esi
  8008e5:	5f                   	pop    %edi
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 18             	sub    $0x18,%esp
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008fb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800905:	85 c0                	test   %eax,%eax
  800907:	74 26                	je     80092f <vsnprintf+0x47>
  800909:	85 d2                	test   %edx,%edx
  80090b:	7e 22                	jle    80092f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80090d:	ff 75 14             	pushl  0x14(%ebp)
  800910:	ff 75 10             	pushl  0x10(%ebp)
  800913:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800916:	50                   	push   %eax
  800917:	68 2b 04 80 00       	push   $0x80042b
  80091c:	e8 44 fb ff ff       	call   800465 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800924:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80092a:	83 c4 10             	add    $0x10,%esp
}
  80092d:	c9                   	leave  
  80092e:	c3                   	ret    
		return -E_INVAL;
  80092f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800934:	eb f7                	jmp    80092d <vsnprintf+0x45>

00800936 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80093f:	50                   	push   %eax
  800940:	ff 75 10             	pushl  0x10(%ebp)
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	ff 75 08             	pushl  0x8(%ebp)
  800949:	e8 9a ff ff ff       	call   8008e8 <vsnprintf>
	va_end(ap);

	return rc;
}
  80094e:	c9                   	leave  
  80094f:	c3                   	ret    

00800950 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800956:	b8 00 00 00 00       	mov    $0x0,%eax
  80095b:	eb 03                	jmp    800960 <strlen+0x10>
		n++;
  80095d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800960:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800964:	75 f7                	jne    80095d <strlen+0xd>
	return n;
}
  800966:	5d                   	pop    %ebp
  800967:	c3                   	ret    

00800968 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800971:	b8 00 00 00 00       	mov    $0x0,%eax
  800976:	eb 03                	jmp    80097b <strnlen+0x13>
		n++;
  800978:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097b:	39 d0                	cmp    %edx,%eax
  80097d:	74 06                	je     800985 <strnlen+0x1d>
  80097f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800983:	75 f3                	jne    800978 <strnlen+0x10>
	return n;
}
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    

00800987 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	53                   	push   %ebx
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800991:	89 c2                	mov    %eax,%edx
  800993:	83 c1 01             	add    $0x1,%ecx
  800996:	83 c2 01             	add    $0x1,%edx
  800999:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80099d:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009a0:	84 db                	test   %bl,%bl
  8009a2:	75 ef                	jne    800993 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009a4:	5b                   	pop    %ebx
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	53                   	push   %ebx
  8009ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009ae:	53                   	push   %ebx
  8009af:	e8 9c ff ff ff       	call   800950 <strlen>
  8009b4:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	01 d8                	add    %ebx,%eax
  8009bc:	50                   	push   %eax
  8009bd:	e8 c5 ff ff ff       	call   800987 <strcpy>
	return dst;
}
  8009c2:	89 d8                	mov    %ebx,%eax
  8009c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	56                   	push   %esi
  8009cd:	53                   	push   %ebx
  8009ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d4:	89 f3                	mov    %esi,%ebx
  8009d6:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d9:	89 f2                	mov    %esi,%edx
  8009db:	eb 0f                	jmp    8009ec <strncpy+0x23>
		*dst++ = *src;
  8009dd:	83 c2 01             	add    $0x1,%edx
  8009e0:	0f b6 01             	movzbl (%ecx),%eax
  8009e3:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009e6:	80 39 01             	cmpb   $0x1,(%ecx)
  8009e9:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8009ec:	39 da                	cmp    %ebx,%edx
  8009ee:	75 ed                	jne    8009dd <strncpy+0x14>
	}
	return ret;
}
  8009f0:	89 f0                	mov    %esi,%eax
  8009f2:	5b                   	pop    %ebx
  8009f3:	5e                   	pop    %esi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	56                   	push   %esi
  8009fa:	53                   	push   %ebx
  8009fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8009fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a01:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a04:	89 f0                	mov    %esi,%eax
  800a06:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a0a:	85 c9                	test   %ecx,%ecx
  800a0c:	75 0b                	jne    800a19 <strlcpy+0x23>
  800a0e:	eb 17                	jmp    800a27 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a10:	83 c2 01             	add    $0x1,%edx
  800a13:	83 c0 01             	add    $0x1,%eax
  800a16:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a19:	39 d8                	cmp    %ebx,%eax
  800a1b:	74 07                	je     800a24 <strlcpy+0x2e>
  800a1d:	0f b6 0a             	movzbl (%edx),%ecx
  800a20:	84 c9                	test   %cl,%cl
  800a22:	75 ec                	jne    800a10 <strlcpy+0x1a>
		*dst = '\0';
  800a24:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a27:	29 f0                	sub    %esi,%eax
}
  800a29:	5b                   	pop    %ebx
  800a2a:	5e                   	pop    %esi
  800a2b:	5d                   	pop    %ebp
  800a2c:	c3                   	ret    

00800a2d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a33:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a36:	eb 06                	jmp    800a3e <strcmp+0x11>
		p++, q++;
  800a38:	83 c1 01             	add    $0x1,%ecx
  800a3b:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a3e:	0f b6 01             	movzbl (%ecx),%eax
  800a41:	84 c0                	test   %al,%al
  800a43:	74 04                	je     800a49 <strcmp+0x1c>
  800a45:	3a 02                	cmp    (%edx),%al
  800a47:	74 ef                	je     800a38 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a49:	0f b6 c0             	movzbl %al,%eax
  800a4c:	0f b6 12             	movzbl (%edx),%edx
  800a4f:	29 d0                	sub    %edx,%eax
}
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	53                   	push   %ebx
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5d:	89 c3                	mov    %eax,%ebx
  800a5f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a62:	eb 06                	jmp    800a6a <strncmp+0x17>
		n--, p++, q++;
  800a64:	83 c0 01             	add    $0x1,%eax
  800a67:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a6a:	39 d8                	cmp    %ebx,%eax
  800a6c:	74 16                	je     800a84 <strncmp+0x31>
  800a6e:	0f b6 08             	movzbl (%eax),%ecx
  800a71:	84 c9                	test   %cl,%cl
  800a73:	74 04                	je     800a79 <strncmp+0x26>
  800a75:	3a 0a                	cmp    (%edx),%cl
  800a77:	74 eb                	je     800a64 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a79:	0f b6 00             	movzbl (%eax),%eax
  800a7c:	0f b6 12             	movzbl (%edx),%edx
  800a7f:	29 d0                	sub    %edx,%eax
}
  800a81:	5b                   	pop    %ebx
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    
		return 0;
  800a84:	b8 00 00 00 00       	mov    $0x0,%eax
  800a89:	eb f6                	jmp    800a81 <strncmp+0x2e>

00800a8b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a95:	0f b6 10             	movzbl (%eax),%edx
  800a98:	84 d2                	test   %dl,%dl
  800a9a:	74 09                	je     800aa5 <strchr+0x1a>
		if (*s == c)
  800a9c:	38 ca                	cmp    %cl,%dl
  800a9e:	74 0a                	je     800aaa <strchr+0x1f>
	for (; *s; s++)
  800aa0:	83 c0 01             	add    $0x1,%eax
  800aa3:	eb f0                	jmp    800a95 <strchr+0xa>
			return (char *) s;
	return 0;
  800aa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab6:	eb 03                	jmp    800abb <strfind+0xf>
  800ab8:	83 c0 01             	add    $0x1,%eax
  800abb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800abe:	38 ca                	cmp    %cl,%dl
  800ac0:	74 04                	je     800ac6 <strfind+0x1a>
  800ac2:	84 d2                	test   %dl,%dl
  800ac4:	75 f2                	jne    800ab8 <strfind+0xc>
			break;
	return (char *) s;
}
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	57                   	push   %edi
  800acc:	56                   	push   %esi
  800acd:	53                   	push   %ebx
  800ace:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad4:	85 c9                	test   %ecx,%ecx
  800ad6:	74 13                	je     800aeb <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ad8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ade:	75 05                	jne    800ae5 <memset+0x1d>
  800ae0:	f6 c1 03             	test   $0x3,%cl
  800ae3:	74 0d                	je     800af2 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae8:	fc                   	cld    
  800ae9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aeb:	89 f8                	mov    %edi,%eax
  800aed:	5b                   	pop    %ebx
  800aee:	5e                   	pop    %esi
  800aef:	5f                   	pop    %edi
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    
		c &= 0xFF;
  800af2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800af6:	89 d3                	mov    %edx,%ebx
  800af8:	c1 e3 08             	shl    $0x8,%ebx
  800afb:	89 d0                	mov    %edx,%eax
  800afd:	c1 e0 18             	shl    $0x18,%eax
  800b00:	89 d6                	mov    %edx,%esi
  800b02:	c1 e6 10             	shl    $0x10,%esi
  800b05:	09 f0                	or     %esi,%eax
  800b07:	09 c2                	or     %eax,%edx
  800b09:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800b0b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b0e:	89 d0                	mov    %edx,%eax
  800b10:	fc                   	cld    
  800b11:	f3 ab                	rep stos %eax,%es:(%edi)
  800b13:	eb d6                	jmp    800aeb <memset+0x23>

00800b15 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	57                   	push   %edi
  800b19:	56                   	push   %esi
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b20:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b23:	39 c6                	cmp    %eax,%esi
  800b25:	73 35                	jae    800b5c <memmove+0x47>
  800b27:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b2a:	39 c2                	cmp    %eax,%edx
  800b2c:	76 2e                	jbe    800b5c <memmove+0x47>
		s += n;
		d += n;
  800b2e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b31:	89 d6                	mov    %edx,%esi
  800b33:	09 fe                	or     %edi,%esi
  800b35:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b3b:	74 0c                	je     800b49 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b3d:	83 ef 01             	sub    $0x1,%edi
  800b40:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b43:	fd                   	std    
  800b44:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b46:	fc                   	cld    
  800b47:	eb 21                	jmp    800b6a <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b49:	f6 c1 03             	test   $0x3,%cl
  800b4c:	75 ef                	jne    800b3d <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b4e:	83 ef 04             	sub    $0x4,%edi
  800b51:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b54:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b57:	fd                   	std    
  800b58:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b5a:	eb ea                	jmp    800b46 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b5c:	89 f2                	mov    %esi,%edx
  800b5e:	09 c2                	or     %eax,%edx
  800b60:	f6 c2 03             	test   $0x3,%dl
  800b63:	74 09                	je     800b6e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b65:	89 c7                	mov    %eax,%edi
  800b67:	fc                   	cld    
  800b68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b6a:	5e                   	pop    %esi
  800b6b:	5f                   	pop    %edi
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6e:	f6 c1 03             	test   $0x3,%cl
  800b71:	75 f2                	jne    800b65 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b73:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b76:	89 c7                	mov    %eax,%edi
  800b78:	fc                   	cld    
  800b79:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b7b:	eb ed                	jmp    800b6a <memmove+0x55>

00800b7d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b80:	ff 75 10             	pushl  0x10(%ebp)
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	ff 75 08             	pushl  0x8(%ebp)
  800b89:	e8 87 ff ff ff       	call   800b15 <memmove>
}
  800b8e:	c9                   	leave  
  800b8f:	c3                   	ret    

00800b90 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9b:	89 c6                	mov    %eax,%esi
  800b9d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba0:	39 f0                	cmp    %esi,%eax
  800ba2:	74 1c                	je     800bc0 <memcmp+0x30>
		if (*s1 != *s2)
  800ba4:	0f b6 08             	movzbl (%eax),%ecx
  800ba7:	0f b6 1a             	movzbl (%edx),%ebx
  800baa:	38 d9                	cmp    %bl,%cl
  800bac:	75 08                	jne    800bb6 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bae:	83 c0 01             	add    $0x1,%eax
  800bb1:	83 c2 01             	add    $0x1,%edx
  800bb4:	eb ea                	jmp    800ba0 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bb6:	0f b6 c1             	movzbl %cl,%eax
  800bb9:	0f b6 db             	movzbl %bl,%ebx
  800bbc:	29 d8                	sub    %ebx,%eax
  800bbe:	eb 05                	jmp    800bc5 <memcmp+0x35>
	}

	return 0;
  800bc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc5:	5b                   	pop    %ebx
  800bc6:	5e                   	pop    %esi
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bd2:	89 c2                	mov    %eax,%edx
  800bd4:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bd7:	39 d0                	cmp    %edx,%eax
  800bd9:	73 09                	jae    800be4 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bdb:	38 08                	cmp    %cl,(%eax)
  800bdd:	74 05                	je     800be4 <memfind+0x1b>
	for (; s < ends; s++)
  800bdf:	83 c0 01             	add    $0x1,%eax
  800be2:	eb f3                	jmp    800bd7 <memfind+0xe>
			break;
	return (void *) s;
}
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    

00800be6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	57                   	push   %edi
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
  800bec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bf2:	eb 03                	jmp    800bf7 <strtol+0x11>
		s++;
  800bf4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bf7:	0f b6 01             	movzbl (%ecx),%eax
  800bfa:	3c 20                	cmp    $0x20,%al
  800bfc:	74 f6                	je     800bf4 <strtol+0xe>
  800bfe:	3c 09                	cmp    $0x9,%al
  800c00:	74 f2                	je     800bf4 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c02:	3c 2b                	cmp    $0x2b,%al
  800c04:	74 2e                	je     800c34 <strtol+0x4e>
	int neg = 0;
  800c06:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c0b:	3c 2d                	cmp    $0x2d,%al
  800c0d:	74 2f                	je     800c3e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c15:	75 05                	jne    800c1c <strtol+0x36>
  800c17:	80 39 30             	cmpb   $0x30,(%ecx)
  800c1a:	74 2c                	je     800c48 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c1c:	85 db                	test   %ebx,%ebx
  800c1e:	75 0a                	jne    800c2a <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c20:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800c25:	80 39 30             	cmpb   $0x30,(%ecx)
  800c28:	74 28                	je     800c52 <strtol+0x6c>
		base = 10;
  800c2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c32:	eb 50                	jmp    800c84 <strtol+0x9e>
		s++;
  800c34:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c37:	bf 00 00 00 00       	mov    $0x0,%edi
  800c3c:	eb d1                	jmp    800c0f <strtol+0x29>
		s++, neg = 1;
  800c3e:	83 c1 01             	add    $0x1,%ecx
  800c41:	bf 01 00 00 00       	mov    $0x1,%edi
  800c46:	eb c7                	jmp    800c0f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c48:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c4c:	74 0e                	je     800c5c <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c4e:	85 db                	test   %ebx,%ebx
  800c50:	75 d8                	jne    800c2a <strtol+0x44>
		s++, base = 8;
  800c52:	83 c1 01             	add    $0x1,%ecx
  800c55:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c5a:	eb ce                	jmp    800c2a <strtol+0x44>
		s += 2, base = 16;
  800c5c:	83 c1 02             	add    $0x2,%ecx
  800c5f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c64:	eb c4                	jmp    800c2a <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c66:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c69:	89 f3                	mov    %esi,%ebx
  800c6b:	80 fb 19             	cmp    $0x19,%bl
  800c6e:	77 29                	ja     800c99 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c70:	0f be d2             	movsbl %dl,%edx
  800c73:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c76:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c79:	7d 30                	jge    800cab <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c7b:	83 c1 01             	add    $0x1,%ecx
  800c7e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c82:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c84:	0f b6 11             	movzbl (%ecx),%edx
  800c87:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c8a:	89 f3                	mov    %esi,%ebx
  800c8c:	80 fb 09             	cmp    $0x9,%bl
  800c8f:	77 d5                	ja     800c66 <strtol+0x80>
			dig = *s - '0';
  800c91:	0f be d2             	movsbl %dl,%edx
  800c94:	83 ea 30             	sub    $0x30,%edx
  800c97:	eb dd                	jmp    800c76 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c99:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c9c:	89 f3                	mov    %esi,%ebx
  800c9e:	80 fb 19             	cmp    $0x19,%bl
  800ca1:	77 08                	ja     800cab <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ca3:	0f be d2             	movsbl %dl,%edx
  800ca6:	83 ea 37             	sub    $0x37,%edx
  800ca9:	eb cb                	jmp    800c76 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800caf:	74 05                	je     800cb6 <strtol+0xd0>
		*endptr = (char *) s;
  800cb1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cb4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cb6:	89 c2                	mov    %eax,%edx
  800cb8:	f7 da                	neg    %edx
  800cba:	85 ff                	test   %edi,%edi
  800cbc:	0f 45 c2             	cmovne %edx,%eax
}
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800cca:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd5:	89 c3                	mov    %eax,%ebx
  800cd7:	89 c7                	mov    %eax,%edi
  800cd9:	89 c6                	mov    %eax,%esi
  800cdb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cdd:	5b                   	pop    %ebx
  800cde:	5e                   	pop    %esi
  800cdf:	5f                   	pop    %edi
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    

00800ce2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ce8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ced:	b8 01 00 00 00       	mov    $0x1,%eax
  800cf2:	89 d1                	mov    %edx,%ecx
  800cf4:	89 d3                	mov    %edx,%ebx
  800cf6:	89 d7                	mov    %edx,%edi
  800cf8:	89 d6                	mov    %edx,%esi
  800cfa:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cfc:	5b                   	pop    %ebx
  800cfd:	5e                   	pop    %esi
  800cfe:	5f                   	pop    %edi
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    

00800d01 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	57                   	push   %edi
  800d05:	56                   	push   %esi
  800d06:	53                   	push   %ebx
  800d07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d12:	b8 03 00 00 00       	mov    $0x3,%eax
  800d17:	89 cb                	mov    %ecx,%ebx
  800d19:	89 cf                	mov    %ecx,%edi
  800d1b:	89 ce                	mov    %ecx,%esi
  800d1d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	7f 08                	jg     800d2b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d26:	5b                   	pop    %ebx
  800d27:	5e                   	pop    %esi
  800d28:	5f                   	pop    %edi
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2b:	83 ec 0c             	sub    $0xc,%esp
  800d2e:	50                   	push   %eax
  800d2f:	6a 03                	push   $0x3
  800d31:	68 ff 26 80 00       	push   $0x8026ff
  800d36:	6a 23                	push   $0x23
  800d38:	68 1c 27 80 00       	push   $0x80271c
  800d3d:	e8 4b f5 ff ff       	call   80028d <_panic>

00800d42 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	57                   	push   %edi
  800d46:	56                   	push   %esi
  800d47:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d48:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4d:	b8 02 00 00 00       	mov    $0x2,%eax
  800d52:	89 d1                	mov    %edx,%ecx
  800d54:	89 d3                	mov    %edx,%ebx
  800d56:	89 d7                	mov    %edx,%edi
  800d58:	89 d6                	mov    %edx,%esi
  800d5a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d5c:	5b                   	pop    %ebx
  800d5d:	5e                   	pop    %esi
  800d5e:	5f                   	pop    %edi
  800d5f:	5d                   	pop    %ebp
  800d60:	c3                   	ret    

00800d61 <sys_yield>:

void
sys_yield(void)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	57                   	push   %edi
  800d65:	56                   	push   %esi
  800d66:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d67:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d71:	89 d1                	mov    %edx,%ecx
  800d73:	89 d3                	mov    %edx,%ebx
  800d75:	89 d7                	mov    %edx,%edi
  800d77:	89 d6                	mov    %edx,%esi
  800d79:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d89:	be 00 00 00 00       	mov    $0x0,%esi
  800d8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d94:	b8 04 00 00 00       	mov    $0x4,%eax
  800d99:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9c:	89 f7                	mov    %esi,%edi
  800d9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da0:	85 c0                	test   %eax,%eax
  800da2:	7f 08                	jg     800dac <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800da4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da7:	5b                   	pop    %ebx
  800da8:	5e                   	pop    %esi
  800da9:	5f                   	pop    %edi
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dac:	83 ec 0c             	sub    $0xc,%esp
  800daf:	50                   	push   %eax
  800db0:	6a 04                	push   $0x4
  800db2:	68 ff 26 80 00       	push   $0x8026ff
  800db7:	6a 23                	push   $0x23
  800db9:	68 1c 27 80 00       	push   $0x80271c
  800dbe:	e8 ca f4 ff ff       	call   80028d <_panic>

00800dc3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
  800dc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd2:	b8 05 00 00 00       	mov    $0x5,%eax
  800dd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dda:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ddd:	8b 75 18             	mov    0x18(%ebp),%esi
  800de0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de2:	85 c0                	test   %eax,%eax
  800de4:	7f 08                	jg     800dee <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de9:	5b                   	pop    %ebx
  800dea:	5e                   	pop    %esi
  800deb:	5f                   	pop    %edi
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dee:	83 ec 0c             	sub    $0xc,%esp
  800df1:	50                   	push   %eax
  800df2:	6a 05                	push   $0x5
  800df4:	68 ff 26 80 00       	push   $0x8026ff
  800df9:	6a 23                	push   $0x23
  800dfb:	68 1c 27 80 00       	push   $0x80271c
  800e00:	e8 88 f4 ff ff       	call   80028d <_panic>

00800e05 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	57                   	push   %edi
  800e09:	56                   	push   %esi
  800e0a:	53                   	push   %ebx
  800e0b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e13:	8b 55 08             	mov    0x8(%ebp),%edx
  800e16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e19:	b8 06 00 00 00       	mov    $0x6,%eax
  800e1e:	89 df                	mov    %ebx,%edi
  800e20:	89 de                	mov    %ebx,%esi
  800e22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e24:	85 c0                	test   %eax,%eax
  800e26:	7f 08                	jg     800e30 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e30:	83 ec 0c             	sub    $0xc,%esp
  800e33:	50                   	push   %eax
  800e34:	6a 06                	push   $0x6
  800e36:	68 ff 26 80 00       	push   $0x8026ff
  800e3b:	6a 23                	push   $0x23
  800e3d:	68 1c 27 80 00       	push   $0x80271c
  800e42:	e8 46 f4 ff ff       	call   80028d <_panic>

00800e47 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	57                   	push   %edi
  800e4b:	56                   	push   %esi
  800e4c:	53                   	push   %ebx
  800e4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e50:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e55:	8b 55 08             	mov    0x8(%ebp),%edx
  800e58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e60:	89 df                	mov    %ebx,%edi
  800e62:	89 de                	mov    %ebx,%esi
  800e64:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e66:	85 c0                	test   %eax,%eax
  800e68:	7f 08                	jg     800e72 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6d:	5b                   	pop    %ebx
  800e6e:	5e                   	pop    %esi
  800e6f:	5f                   	pop    %edi
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e72:	83 ec 0c             	sub    $0xc,%esp
  800e75:	50                   	push   %eax
  800e76:	6a 08                	push   $0x8
  800e78:	68 ff 26 80 00       	push   $0x8026ff
  800e7d:	6a 23                	push   $0x23
  800e7f:	68 1c 27 80 00       	push   $0x80271c
  800e84:	e8 04 f4 ff ff       	call   80028d <_panic>

00800e89 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	57                   	push   %edi
  800e8d:	56                   	push   %esi
  800e8e:	53                   	push   %ebx
  800e8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e92:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e97:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9d:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea2:	89 df                	mov    %ebx,%edi
  800ea4:	89 de                	mov    %ebx,%esi
  800ea6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea8:	85 c0                	test   %eax,%eax
  800eaa:	7f 08                	jg     800eb4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb4:	83 ec 0c             	sub    $0xc,%esp
  800eb7:	50                   	push   %eax
  800eb8:	6a 09                	push   $0x9
  800eba:	68 ff 26 80 00       	push   $0x8026ff
  800ebf:	6a 23                	push   $0x23
  800ec1:	68 1c 27 80 00       	push   $0x80271c
  800ec6:	e8 c2 f3 ff ff       	call   80028d <_panic>

00800ecb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	57                   	push   %edi
  800ecf:	56                   	push   %esi
  800ed0:	53                   	push   %ebx
  800ed1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ed4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ee4:	89 df                	mov    %ebx,%edi
  800ee6:	89 de                	mov    %ebx,%esi
  800ee8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eea:	85 c0                	test   %eax,%eax
  800eec:	7f 08                	jg     800ef6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef1:	5b                   	pop    %ebx
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef6:	83 ec 0c             	sub    $0xc,%esp
  800ef9:	50                   	push   %eax
  800efa:	6a 0a                	push   $0xa
  800efc:	68 ff 26 80 00       	push   $0x8026ff
  800f01:	6a 23                	push   $0x23
  800f03:	68 1c 27 80 00       	push   $0x80271c
  800f08:	e8 80 f3 ff ff       	call   80028d <_panic>

00800f0d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	57                   	push   %edi
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800f13:	8b 55 08             	mov    0x8(%ebp),%edx
  800f16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f19:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f1e:	be 00 00 00 00       	mov    $0x0,%esi
  800f23:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f26:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f29:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f2b:	5b                   	pop    %ebx
  800f2c:	5e                   	pop    %esi
  800f2d:	5f                   	pop    %edi
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    

00800f30 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	57                   	push   %edi
  800f34:	56                   	push   %esi
  800f35:	53                   	push   %ebx
  800f36:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800f39:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f46:	89 cb                	mov    %ecx,%ebx
  800f48:	89 cf                	mov    %ecx,%edi
  800f4a:	89 ce                	mov    %ecx,%esi
  800f4c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4e:	85 c0                	test   %eax,%eax
  800f50:	7f 08                	jg     800f5a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f55:	5b                   	pop    %ebx
  800f56:	5e                   	pop    %esi
  800f57:	5f                   	pop    %edi
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5a:	83 ec 0c             	sub    $0xc,%esp
  800f5d:	50                   	push   %eax
  800f5e:	6a 0d                	push   $0xd
  800f60:	68 ff 26 80 00       	push   $0x8026ff
  800f65:	6a 23                	push   $0x23
  800f67:	68 1c 27 80 00       	push   $0x80271c
  800f6c:	e8 1c f3 ff ff       	call   80028d <_panic>

00800f71 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	53                   	push   %ebx
  800f75:	83 ec 04             	sub    $0x4,%esp
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f7b:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) { //只有因为写操作写时拷贝的地址这中情况，才可以抢救。否则一律panic
  800f7d:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f81:	74 74                	je     800ff7 <pgfault+0x86>
  800f83:	89 d8                	mov    %ebx,%eax
  800f85:	c1 e8 0c             	shr    $0xc,%eax
  800f88:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f8f:	f6 c4 08             	test   $0x8,%ah
  800f92:	74 63                	je     800ff7 <pgfault+0x86>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  800f94:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, PFTEMP, PTE_U|PTE_P)) < 0)		//将当前进程PFTEMP也映射到当前进程addr指向的物理页
  800f9a:	83 ec 0c             	sub    $0xc,%esp
  800f9d:	6a 05                	push   $0x5
  800f9f:	68 00 f0 7f 00       	push   $0x7ff000
  800fa4:	6a 00                	push   $0x0
  800fa6:	53                   	push   %ebx
  800fa7:	6a 00                	push   $0x0
  800fa9:	e8 15 fe ff ff       	call   800dc3 <sys_page_map>
  800fae:	83 c4 20             	add    $0x20,%esp
  800fb1:	85 c0                	test   %eax,%eax
  800fb3:	78 56                	js     80100b <pgfault+0x9a>
		panic("sys_page_map: %e", r);
	if ((r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W)) < 0)	//令当前进程addr指向新分配的物理页
  800fb5:	83 ec 04             	sub    $0x4,%esp
  800fb8:	6a 07                	push   $0x7
  800fba:	53                   	push   %ebx
  800fbb:	6a 00                	push   $0x0
  800fbd:	e8 be fd ff ff       	call   800d80 <sys_page_alloc>
  800fc2:	83 c4 10             	add    $0x10,%esp
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	78 54                	js     80101d <pgfault+0xac>
		panic("sys_page_alloc: %e", r);
	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  800fc9:	83 ec 04             	sub    $0x4,%esp
  800fcc:	68 00 10 00 00       	push   $0x1000
  800fd1:	68 00 f0 7f 00       	push   $0x7ff000
  800fd6:	53                   	push   %ebx
  800fd7:	e8 39 fb ff ff       	call   800b15 <memmove>
	if ((r = sys_page_unmap(0, PFTEMP)) < 0)					//解除当前进程PFTEMP映射
  800fdc:	83 c4 08             	add    $0x8,%esp
  800fdf:	68 00 f0 7f 00       	push   $0x7ff000
  800fe4:	6a 00                	push   $0x0
  800fe6:	e8 1a fe ff ff       	call   800e05 <sys_page_unmap>
  800feb:	83 c4 10             	add    $0x10,%esp
  800fee:	85 c0                	test   %eax,%eax
  800ff0:	78 3d                	js     80102f <pgfault+0xbe>
		panic("sys_page_unmap: %e", r);
}
  800ff2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ff5:	c9                   	leave  
  800ff6:	c3                   	ret    
		panic("pgfault():not cow");
  800ff7:	83 ec 04             	sub    $0x4,%esp
  800ffa:	68 2a 27 80 00       	push   $0x80272a
  800fff:	6a 1d                	push   $0x1d
  801001:	68 3c 27 80 00       	push   $0x80273c
  801006:	e8 82 f2 ff ff       	call   80028d <_panic>
		panic("sys_page_map: %e", r);
  80100b:	50                   	push   %eax
  80100c:	68 47 27 80 00       	push   $0x802747
  801011:	6a 2a                	push   $0x2a
  801013:	68 3c 27 80 00       	push   $0x80273c
  801018:	e8 70 f2 ff ff       	call   80028d <_panic>
		panic("sys_page_alloc: %e", r);
  80101d:	50                   	push   %eax
  80101e:	68 58 27 80 00       	push   $0x802758
  801023:	6a 2c                	push   $0x2c
  801025:	68 3c 27 80 00       	push   $0x80273c
  80102a:	e8 5e f2 ff ff       	call   80028d <_panic>
		panic("sys_page_unmap: %e", r);
  80102f:	50                   	push   %eax
  801030:	68 6b 27 80 00       	push   $0x80276b
  801035:	6a 2f                	push   $0x2f
  801037:	68 3c 27 80 00       	push   $0x80273c
  80103c:	e8 4c f2 ff ff       	call   80028d <_panic>

00801041 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	57                   	push   %edi
  801045:	56                   	push   %esi
  801046:	53                   	push   %ebx
  801047:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);	//设置缺页处理函数
  80104a:	68 71 0f 80 00       	push   $0x800f71
  80104f:	e8 dd 0e 00 00       	call   801f31 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801054:	b8 07 00 00 00       	mov    $0x7,%eax
  801059:	cd 30                	int    $0x30
  80105b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();	//系统调用，只是简单创建一个Env结构，复制当前用户环境寄存器状态，UTOP以下的页目录还没有建立
	if (envid == 0) {				//子进程将走这个逻辑
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	85 c0                	test   %eax,%eax
  801063:	74 12                	je     801077 <fork+0x36>
  801065:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	if (envid < 0) {
  801067:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80106b:	78 26                	js     801093 <fork+0x52>
		panic("sys_exofork: %e", envid);
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80106d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801072:	e9 94 00 00 00       	jmp    80110b <fork+0xca>
		thisenv = &envs[ENVX(sys_getenvid())];
  801077:	e8 c6 fc ff ff       	call   800d42 <sys_getenvid>
  80107c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801081:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801084:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801089:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80108e:	e9 51 01 00 00       	jmp    8011e4 <fork+0x1a3>
		panic("sys_exofork: %e", envid);
  801093:	ff 75 e4             	pushl  -0x1c(%ebp)
  801096:	68 7e 27 80 00       	push   $0x80277e
  80109b:	6a 6d                	push   $0x6d
  80109d:	68 3c 27 80 00       	push   $0x80273c
  8010a2:	e8 e6 f1 ff ff       	call   80028d <_panic>
		sys_page_map(0, addr, envid, addr, PTE_SYSCALL);		//对于表示为PTE_SHARE的页，拷贝映射关系，并且两个进程都有读写权限
  8010a7:	83 ec 0c             	sub    $0xc,%esp
  8010aa:	68 07 0e 00 00       	push   $0xe07
  8010af:	56                   	push   %esi
  8010b0:	57                   	push   %edi
  8010b1:	56                   	push   %esi
  8010b2:	6a 00                	push   $0x0
  8010b4:	e8 0a fd ff ff       	call   800dc3 <sys_page_map>
  8010b9:	83 c4 20             	add    $0x20,%esp
  8010bc:	eb 3b                	jmp    8010f9 <fork+0xb8>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  8010be:	83 ec 0c             	sub    $0xc,%esp
  8010c1:	68 05 08 00 00       	push   $0x805
  8010c6:	56                   	push   %esi
  8010c7:	57                   	push   %edi
  8010c8:	56                   	push   %esi
  8010c9:	6a 00                	push   $0x0
  8010cb:	e8 f3 fc ff ff       	call   800dc3 <sys_page_map>
  8010d0:	83 c4 20             	add    $0x20,%esp
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	0f 88 a9 00 00 00    	js     801184 <fork+0x143>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  8010db:	83 ec 0c             	sub    $0xc,%esp
  8010de:	68 05 08 00 00       	push   $0x805
  8010e3:	56                   	push   %esi
  8010e4:	6a 00                	push   $0x0
  8010e6:	56                   	push   %esi
  8010e7:	6a 00                	push   $0x0
  8010e9:	e8 d5 fc ff ff       	call   800dc3 <sys_page_map>
  8010ee:	83 c4 20             	add    $0x20,%esp
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	0f 88 9d 00 00 00    	js     801196 <fork+0x155>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8010f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8010ff:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801105:	0f 84 9d 00 00 00    	je     8011a8 <fork+0x167>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) //为什么uvpt[pagenumber]能访问到第pagenumber项页表条目：https://pdos.csail.mit.edu/6.828/2018/labs/lab4/uvpt.html
  80110b:	89 d8                	mov    %ebx,%eax
  80110d:	c1 e8 16             	shr    $0x16,%eax
  801110:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801117:	a8 01                	test   $0x1,%al
  801119:	74 de                	je     8010f9 <fork+0xb8>
  80111b:	89 d8                	mov    %ebx,%eax
  80111d:	c1 e8 0c             	shr    $0xc,%eax
  801120:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801127:	f6 c2 01             	test   $0x1,%dl
  80112a:	74 cd                	je     8010f9 <fork+0xb8>
			&& (uvpt[PGNUM(addr)] & PTE_U)) {
  80112c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801133:	f6 c2 04             	test   $0x4,%dl
  801136:	74 c1                	je     8010f9 <fork+0xb8>
	void *addr = (void*) (pn * PGSIZE);
  801138:	89 c6                	mov    %eax,%esi
  80113a:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE) {
  80113d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801144:	f6 c6 04             	test   $0x4,%dh
  801147:	0f 85 5a ff ff ff    	jne    8010a7 <fork+0x66>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) { //对于UTOP以下的可写的或者写时拷贝的页，拷贝映射关系的同时，需要同时标记当前进程和子进程的页表项为PTE_COW
  80114d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801154:	f6 c2 02             	test   $0x2,%dl
  801157:	0f 85 61 ff ff ff    	jne    8010be <fork+0x7d>
  80115d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801164:	f6 c4 08             	test   $0x8,%ah
  801167:	0f 85 51 ff ff ff    	jne    8010be <fork+0x7d>
		sys_page_map(0, addr, envid, addr, PTE_U|PTE_P);	//对于只读的页，只需要拷贝映射关系即可
  80116d:	83 ec 0c             	sub    $0xc,%esp
  801170:	6a 05                	push   $0x5
  801172:	56                   	push   %esi
  801173:	57                   	push   %edi
  801174:	56                   	push   %esi
  801175:	6a 00                	push   $0x0
  801177:	e8 47 fc ff ff       	call   800dc3 <sys_page_map>
  80117c:	83 c4 20             	add    $0x20,%esp
  80117f:	e9 75 ff ff ff       	jmp    8010f9 <fork+0xb8>
			panic("sys_page_map：%e", r);
  801184:	50                   	push   %eax
  801185:	68 8e 27 80 00       	push   $0x80278e
  80118a:	6a 48                	push   $0x48
  80118c:	68 3c 27 80 00       	push   $0x80273c
  801191:	e8 f7 f0 ff ff       	call   80028d <_panic>
			panic("sys_page_map：%e", r);
  801196:	50                   	push   %eax
  801197:	68 8e 27 80 00       	push   $0x80278e
  80119c:	6a 4a                	push   $0x4a
  80119e:	68 3c 27 80 00       	push   $0x80273c
  8011a3:	e8 e5 f0 ff ff       	call   80028d <_panic>
			duppage(envid, PGNUM(addr));	//拷贝当前进程映射关系到子进程
		}
	}
	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_W | PTE_U)) < 0)	//为子进程分配异常栈
  8011a8:	83 ec 04             	sub    $0x4,%esp
  8011ab:	6a 07                	push   $0x7
  8011ad:	68 00 f0 bf ee       	push   $0xeebff000
  8011b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b5:	e8 c6 fb ff ff       	call   800d80 <sys_page_alloc>
  8011ba:	83 c4 10             	add    $0x10,%esp
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	78 2e                	js     8011ef <fork+0x1ae>
		panic("sys_page_alloc: %e", r);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);		//为子进程设置_pgfault_upcall
  8011c1:	83 ec 08             	sub    $0x8,%esp
  8011c4:	68 8a 1f 80 00       	push   $0x801f8a
  8011c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8011cc:	57                   	push   %edi
  8011cd:	e8 f9 fc ff ff       	call   800ecb <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)	//设置子进程为ENV_RUNNABLE状态
  8011d2:	83 c4 08             	add    $0x8,%esp
  8011d5:	6a 02                	push   $0x2
  8011d7:	57                   	push   %edi
  8011d8:	e8 6a fc ff ff       	call   800e47 <sys_env_set_status>
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	78 1d                	js     801201 <fork+0x1c0>
		panic("sys_env_set_status: %e", r);
	return envid;
}
  8011e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ea:	5b                   	pop    %ebx
  8011eb:	5e                   	pop    %esi
  8011ec:	5f                   	pop    %edi
  8011ed:	5d                   	pop    %ebp
  8011ee:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8011ef:	50                   	push   %eax
  8011f0:	68 58 27 80 00       	push   $0x802758
  8011f5:	6a 79                	push   $0x79
  8011f7:	68 3c 27 80 00       	push   $0x80273c
  8011fc:	e8 8c f0 ff ff       	call   80028d <_panic>
		panic("sys_env_set_status: %e", r);
  801201:	50                   	push   %eax
  801202:	68 a0 27 80 00       	push   $0x8027a0
  801207:	6a 7d                	push   $0x7d
  801209:	68 3c 27 80 00       	push   $0x80273c
  80120e:	e8 7a f0 ff ff       	call   80028d <_panic>

00801213 <sfork>:

// Challenge!
int
sfork(void)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801219:	68 b7 27 80 00       	push   $0x8027b7
  80121e:	68 85 00 00 00       	push   $0x85
  801223:	68 3c 27 80 00       	push   $0x80273c
  801228:	e8 60 f0 ff ff       	call   80028d <_panic>

0080122d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	05 00 00 00 30       	add    $0x30000000,%eax
  801238:	c1 e8 0c             	shr    $0xc,%eax
}
  80123b:	5d                   	pop    %ebp
  80123c:	c3                   	ret    

0080123d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801248:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80124d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801252:	5d                   	pop    %ebp
  801253:	c3                   	ret    

00801254 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80125a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80125f:	89 c2                	mov    %eax,%edx
  801261:	c1 ea 16             	shr    $0x16,%edx
  801264:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80126b:	f6 c2 01             	test   $0x1,%dl
  80126e:	74 2a                	je     80129a <fd_alloc+0x46>
  801270:	89 c2                	mov    %eax,%edx
  801272:	c1 ea 0c             	shr    $0xc,%edx
  801275:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80127c:	f6 c2 01             	test   $0x1,%dl
  80127f:	74 19                	je     80129a <fd_alloc+0x46>
  801281:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801286:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80128b:	75 d2                	jne    80125f <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80128d:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801293:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801298:	eb 07                	jmp    8012a1 <fd_alloc+0x4d>
			*fd_store = fd;
  80129a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80129c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a1:	5d                   	pop    %ebp
  8012a2:	c3                   	ret    

008012a3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012a9:	83 f8 1f             	cmp    $0x1f,%eax
  8012ac:	77 36                	ja     8012e4 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012ae:	c1 e0 0c             	shl    $0xc,%eax
  8012b1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012b6:	89 c2                	mov    %eax,%edx
  8012b8:	c1 ea 16             	shr    $0x16,%edx
  8012bb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012c2:	f6 c2 01             	test   $0x1,%dl
  8012c5:	74 24                	je     8012eb <fd_lookup+0x48>
  8012c7:	89 c2                	mov    %eax,%edx
  8012c9:	c1 ea 0c             	shr    $0xc,%edx
  8012cc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012d3:	f6 c2 01             	test   $0x1,%dl
  8012d6:	74 1a                	je     8012f2 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012db:	89 02                	mov    %eax,(%edx)
	return 0;
  8012dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e2:	5d                   	pop    %ebp
  8012e3:	c3                   	ret    
		return -E_INVAL;
  8012e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e9:	eb f7                	jmp    8012e2 <fd_lookup+0x3f>
		return -E_INVAL;
  8012eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f0:	eb f0                	jmp    8012e2 <fd_lookup+0x3f>
  8012f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f7:	eb e9                	jmp    8012e2 <fd_lookup+0x3f>

008012f9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	83 ec 08             	sub    $0x8,%esp
  8012ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801302:	ba 4c 28 80 00       	mov    $0x80284c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801307:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80130c:	39 08                	cmp    %ecx,(%eax)
  80130e:	74 33                	je     801343 <dev_lookup+0x4a>
  801310:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801313:	8b 02                	mov    (%edx),%eax
  801315:	85 c0                	test   %eax,%eax
  801317:	75 f3                	jne    80130c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801319:	a1 04 40 80 00       	mov    0x804004,%eax
  80131e:	8b 40 48             	mov    0x48(%eax),%eax
  801321:	83 ec 04             	sub    $0x4,%esp
  801324:	51                   	push   %ecx
  801325:	50                   	push   %eax
  801326:	68 d0 27 80 00       	push   $0x8027d0
  80132b:	e8 38 f0 ff ff       	call   800368 <cprintf>
	*dev = 0;
  801330:	8b 45 0c             	mov    0xc(%ebp),%eax
  801333:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801339:	83 c4 10             	add    $0x10,%esp
  80133c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801341:	c9                   	leave  
  801342:	c3                   	ret    
			*dev = devtab[i];
  801343:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801346:	89 01                	mov    %eax,(%ecx)
			return 0;
  801348:	b8 00 00 00 00       	mov    $0x0,%eax
  80134d:	eb f2                	jmp    801341 <dev_lookup+0x48>

0080134f <fd_close>:
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	57                   	push   %edi
  801353:	56                   	push   %esi
  801354:	53                   	push   %ebx
  801355:	83 ec 1c             	sub    $0x1c,%esp
  801358:	8b 75 08             	mov    0x8(%ebp),%esi
  80135b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80135e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801361:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801362:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801368:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80136b:	50                   	push   %eax
  80136c:	e8 32 ff ff ff       	call   8012a3 <fd_lookup>
  801371:	89 c3                	mov    %eax,%ebx
  801373:	83 c4 08             	add    $0x8,%esp
  801376:	85 c0                	test   %eax,%eax
  801378:	78 05                	js     80137f <fd_close+0x30>
	    || fd != fd2)
  80137a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80137d:	74 16                	je     801395 <fd_close+0x46>
		return (must_exist ? r : 0);
  80137f:	89 f8                	mov    %edi,%eax
  801381:	84 c0                	test   %al,%al
  801383:	b8 00 00 00 00       	mov    $0x0,%eax
  801388:	0f 44 d8             	cmove  %eax,%ebx
}
  80138b:	89 d8                	mov    %ebx,%eax
  80138d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801390:	5b                   	pop    %ebx
  801391:	5e                   	pop    %esi
  801392:	5f                   	pop    %edi
  801393:	5d                   	pop    %ebp
  801394:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801395:	83 ec 08             	sub    $0x8,%esp
  801398:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80139b:	50                   	push   %eax
  80139c:	ff 36                	pushl  (%esi)
  80139e:	e8 56 ff ff ff       	call   8012f9 <dev_lookup>
  8013a3:	89 c3                	mov    %eax,%ebx
  8013a5:	83 c4 10             	add    $0x10,%esp
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	78 15                	js     8013c1 <fd_close+0x72>
		if (dev->dev_close)
  8013ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013af:	8b 40 10             	mov    0x10(%eax),%eax
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	74 1b                	je     8013d1 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	56                   	push   %esi
  8013ba:	ff d0                	call   *%eax
  8013bc:	89 c3                	mov    %eax,%ebx
  8013be:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013c1:	83 ec 08             	sub    $0x8,%esp
  8013c4:	56                   	push   %esi
  8013c5:	6a 00                	push   $0x0
  8013c7:	e8 39 fa ff ff       	call   800e05 <sys_page_unmap>
	return r;
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	eb ba                	jmp    80138b <fd_close+0x3c>
			r = 0;
  8013d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d6:	eb e9                	jmp    8013c1 <fd_close+0x72>

008013d8 <close>:

int
close(int fdnum)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e1:	50                   	push   %eax
  8013e2:	ff 75 08             	pushl  0x8(%ebp)
  8013e5:	e8 b9 fe ff ff       	call   8012a3 <fd_lookup>
  8013ea:	83 c4 08             	add    $0x8,%esp
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	78 10                	js     801401 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8013f1:	83 ec 08             	sub    $0x8,%esp
  8013f4:	6a 01                	push   $0x1
  8013f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8013f9:	e8 51 ff ff ff       	call   80134f <fd_close>
  8013fe:	83 c4 10             	add    $0x10,%esp
}
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <close_all>:

void
close_all(void)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	53                   	push   %ebx
  801407:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80140a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80140f:	83 ec 0c             	sub    $0xc,%esp
  801412:	53                   	push   %ebx
  801413:	e8 c0 ff ff ff       	call   8013d8 <close>
	for (i = 0; i < MAXFD; i++)
  801418:	83 c3 01             	add    $0x1,%ebx
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	83 fb 20             	cmp    $0x20,%ebx
  801421:	75 ec                	jne    80140f <close_all+0xc>
}
  801423:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	57                   	push   %edi
  80142c:	56                   	push   %esi
  80142d:	53                   	push   %ebx
  80142e:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801431:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801434:	50                   	push   %eax
  801435:	ff 75 08             	pushl  0x8(%ebp)
  801438:	e8 66 fe ff ff       	call   8012a3 <fd_lookup>
  80143d:	89 c3                	mov    %eax,%ebx
  80143f:	83 c4 08             	add    $0x8,%esp
  801442:	85 c0                	test   %eax,%eax
  801444:	0f 88 81 00 00 00    	js     8014cb <dup+0xa3>
		return r;
	close(newfdnum);
  80144a:	83 ec 0c             	sub    $0xc,%esp
  80144d:	ff 75 0c             	pushl  0xc(%ebp)
  801450:	e8 83 ff ff ff       	call   8013d8 <close>

	newfd = INDEX2FD(newfdnum);
  801455:	8b 75 0c             	mov    0xc(%ebp),%esi
  801458:	c1 e6 0c             	shl    $0xc,%esi
  80145b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801461:	83 c4 04             	add    $0x4,%esp
  801464:	ff 75 e4             	pushl  -0x1c(%ebp)
  801467:	e8 d1 fd ff ff       	call   80123d <fd2data>
  80146c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80146e:	89 34 24             	mov    %esi,(%esp)
  801471:	e8 c7 fd ff ff       	call   80123d <fd2data>
  801476:	83 c4 10             	add    $0x10,%esp
  801479:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80147b:	89 d8                	mov    %ebx,%eax
  80147d:	c1 e8 16             	shr    $0x16,%eax
  801480:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801487:	a8 01                	test   $0x1,%al
  801489:	74 11                	je     80149c <dup+0x74>
  80148b:	89 d8                	mov    %ebx,%eax
  80148d:	c1 e8 0c             	shr    $0xc,%eax
  801490:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801497:	f6 c2 01             	test   $0x1,%dl
  80149a:	75 39                	jne    8014d5 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80149c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80149f:	89 d0                	mov    %edx,%eax
  8014a1:	c1 e8 0c             	shr    $0xc,%eax
  8014a4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014ab:	83 ec 0c             	sub    $0xc,%esp
  8014ae:	25 07 0e 00 00       	and    $0xe07,%eax
  8014b3:	50                   	push   %eax
  8014b4:	56                   	push   %esi
  8014b5:	6a 00                	push   $0x0
  8014b7:	52                   	push   %edx
  8014b8:	6a 00                	push   $0x0
  8014ba:	e8 04 f9 ff ff       	call   800dc3 <sys_page_map>
  8014bf:	89 c3                	mov    %eax,%ebx
  8014c1:	83 c4 20             	add    $0x20,%esp
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	78 31                	js     8014f9 <dup+0xd1>
		goto err;

	return newfdnum;
  8014c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014cb:	89 d8                	mov    %ebx,%eax
  8014cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d0:	5b                   	pop    %ebx
  8014d1:	5e                   	pop    %esi
  8014d2:	5f                   	pop    %edi
  8014d3:	5d                   	pop    %ebp
  8014d4:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014d5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014dc:	83 ec 0c             	sub    $0xc,%esp
  8014df:	25 07 0e 00 00       	and    $0xe07,%eax
  8014e4:	50                   	push   %eax
  8014e5:	57                   	push   %edi
  8014e6:	6a 00                	push   $0x0
  8014e8:	53                   	push   %ebx
  8014e9:	6a 00                	push   $0x0
  8014eb:	e8 d3 f8 ff ff       	call   800dc3 <sys_page_map>
  8014f0:	89 c3                	mov    %eax,%ebx
  8014f2:	83 c4 20             	add    $0x20,%esp
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	79 a3                	jns    80149c <dup+0x74>
	sys_page_unmap(0, newfd);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	56                   	push   %esi
  8014fd:	6a 00                	push   $0x0
  8014ff:	e8 01 f9 ff ff       	call   800e05 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801504:	83 c4 08             	add    $0x8,%esp
  801507:	57                   	push   %edi
  801508:	6a 00                	push   $0x0
  80150a:	e8 f6 f8 ff ff       	call   800e05 <sys_page_unmap>
	return r;
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	eb b7                	jmp    8014cb <dup+0xa3>

00801514 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	53                   	push   %ebx
  801518:	83 ec 14             	sub    $0x14,%esp
  80151b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801521:	50                   	push   %eax
  801522:	53                   	push   %ebx
  801523:	e8 7b fd ff ff       	call   8012a3 <fd_lookup>
  801528:	83 c4 08             	add    $0x8,%esp
  80152b:	85 c0                	test   %eax,%eax
  80152d:	78 3f                	js     80156e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152f:	83 ec 08             	sub    $0x8,%esp
  801532:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801535:	50                   	push   %eax
  801536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801539:	ff 30                	pushl  (%eax)
  80153b:	e8 b9 fd ff ff       	call   8012f9 <dev_lookup>
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	85 c0                	test   %eax,%eax
  801545:	78 27                	js     80156e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801547:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80154a:	8b 42 08             	mov    0x8(%edx),%eax
  80154d:	83 e0 03             	and    $0x3,%eax
  801550:	83 f8 01             	cmp    $0x1,%eax
  801553:	74 1e                	je     801573 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801558:	8b 40 08             	mov    0x8(%eax),%eax
  80155b:	85 c0                	test   %eax,%eax
  80155d:	74 35                	je     801594 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80155f:	83 ec 04             	sub    $0x4,%esp
  801562:	ff 75 10             	pushl  0x10(%ebp)
  801565:	ff 75 0c             	pushl  0xc(%ebp)
  801568:	52                   	push   %edx
  801569:	ff d0                	call   *%eax
  80156b:	83 c4 10             	add    $0x10,%esp
}
  80156e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801571:	c9                   	leave  
  801572:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801573:	a1 04 40 80 00       	mov    0x804004,%eax
  801578:	8b 40 48             	mov    0x48(%eax),%eax
  80157b:	83 ec 04             	sub    $0x4,%esp
  80157e:	53                   	push   %ebx
  80157f:	50                   	push   %eax
  801580:	68 11 28 80 00       	push   $0x802811
  801585:	e8 de ed ff ff       	call   800368 <cprintf>
		return -E_INVAL;
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801592:	eb da                	jmp    80156e <read+0x5a>
		return -E_NOT_SUPP;
  801594:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801599:	eb d3                	jmp    80156e <read+0x5a>

0080159b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	57                   	push   %edi
  80159f:	56                   	push   %esi
  8015a0:	53                   	push   %ebx
  8015a1:	83 ec 0c             	sub    $0xc,%esp
  8015a4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015a7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015af:	39 f3                	cmp    %esi,%ebx
  8015b1:	73 25                	jae    8015d8 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015b3:	83 ec 04             	sub    $0x4,%esp
  8015b6:	89 f0                	mov    %esi,%eax
  8015b8:	29 d8                	sub    %ebx,%eax
  8015ba:	50                   	push   %eax
  8015bb:	89 d8                	mov    %ebx,%eax
  8015bd:	03 45 0c             	add    0xc(%ebp),%eax
  8015c0:	50                   	push   %eax
  8015c1:	57                   	push   %edi
  8015c2:	e8 4d ff ff ff       	call   801514 <read>
		if (m < 0)
  8015c7:	83 c4 10             	add    $0x10,%esp
  8015ca:	85 c0                	test   %eax,%eax
  8015cc:	78 08                	js     8015d6 <readn+0x3b>
			return m;
		if (m == 0)
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	74 06                	je     8015d8 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8015d2:	01 c3                	add    %eax,%ebx
  8015d4:	eb d9                	jmp    8015af <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015d6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015d8:	89 d8                	mov    %ebx,%eax
  8015da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015dd:	5b                   	pop    %ebx
  8015de:	5e                   	pop    %esi
  8015df:	5f                   	pop    %edi
  8015e0:	5d                   	pop    %ebp
  8015e1:	c3                   	ret    

008015e2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	53                   	push   %ebx
  8015e6:	83 ec 14             	sub    $0x14,%esp
  8015e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ef:	50                   	push   %eax
  8015f0:	53                   	push   %ebx
  8015f1:	e8 ad fc ff ff       	call   8012a3 <fd_lookup>
  8015f6:	83 c4 08             	add    $0x8,%esp
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	78 3a                	js     801637 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801603:	50                   	push   %eax
  801604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801607:	ff 30                	pushl  (%eax)
  801609:	e8 eb fc ff ff       	call   8012f9 <dev_lookup>
  80160e:	83 c4 10             	add    $0x10,%esp
  801611:	85 c0                	test   %eax,%eax
  801613:	78 22                	js     801637 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801618:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80161c:	74 1e                	je     80163c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80161e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801621:	8b 52 0c             	mov    0xc(%edx),%edx
  801624:	85 d2                	test   %edx,%edx
  801626:	74 35                	je     80165d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801628:	83 ec 04             	sub    $0x4,%esp
  80162b:	ff 75 10             	pushl  0x10(%ebp)
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	50                   	push   %eax
  801632:	ff d2                	call   *%edx
  801634:	83 c4 10             	add    $0x10,%esp
}
  801637:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80163c:	a1 04 40 80 00       	mov    0x804004,%eax
  801641:	8b 40 48             	mov    0x48(%eax),%eax
  801644:	83 ec 04             	sub    $0x4,%esp
  801647:	53                   	push   %ebx
  801648:	50                   	push   %eax
  801649:	68 2d 28 80 00       	push   $0x80282d
  80164e:	e8 15 ed ff ff       	call   800368 <cprintf>
		return -E_INVAL;
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80165b:	eb da                	jmp    801637 <write+0x55>
		return -E_NOT_SUPP;
  80165d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801662:	eb d3                	jmp    801637 <write+0x55>

00801664 <seek>:

int
seek(int fdnum, off_t offset)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80166a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80166d:	50                   	push   %eax
  80166e:	ff 75 08             	pushl  0x8(%ebp)
  801671:	e8 2d fc ff ff       	call   8012a3 <fd_lookup>
  801676:	83 c4 08             	add    $0x8,%esp
  801679:	85 c0                	test   %eax,%eax
  80167b:	78 0e                	js     80168b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80167d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801680:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801683:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801686:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	53                   	push   %ebx
  801691:	83 ec 14             	sub    $0x14,%esp
  801694:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801697:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80169a:	50                   	push   %eax
  80169b:	53                   	push   %ebx
  80169c:	e8 02 fc ff ff       	call   8012a3 <fd_lookup>
  8016a1:	83 c4 08             	add    $0x8,%esp
  8016a4:	85 c0                	test   %eax,%eax
  8016a6:	78 37                	js     8016df <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a8:	83 ec 08             	sub    $0x8,%esp
  8016ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ae:	50                   	push   %eax
  8016af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b2:	ff 30                	pushl  (%eax)
  8016b4:	e8 40 fc ff ff       	call   8012f9 <dev_lookup>
  8016b9:	83 c4 10             	add    $0x10,%esp
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	78 1f                	js     8016df <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016c7:	74 1b                	je     8016e4 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016cc:	8b 52 18             	mov    0x18(%edx),%edx
  8016cf:	85 d2                	test   %edx,%edx
  8016d1:	74 32                	je     801705 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016d3:	83 ec 08             	sub    $0x8,%esp
  8016d6:	ff 75 0c             	pushl  0xc(%ebp)
  8016d9:	50                   	push   %eax
  8016da:	ff d2                	call   *%edx
  8016dc:	83 c4 10             	add    $0x10,%esp
}
  8016df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016e4:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016e9:	8b 40 48             	mov    0x48(%eax),%eax
  8016ec:	83 ec 04             	sub    $0x4,%esp
  8016ef:	53                   	push   %ebx
  8016f0:	50                   	push   %eax
  8016f1:	68 f0 27 80 00       	push   $0x8027f0
  8016f6:	e8 6d ec ff ff       	call   800368 <cprintf>
		return -E_INVAL;
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801703:	eb da                	jmp    8016df <ftruncate+0x52>
		return -E_NOT_SUPP;
  801705:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80170a:	eb d3                	jmp    8016df <ftruncate+0x52>

0080170c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	53                   	push   %ebx
  801710:	83 ec 14             	sub    $0x14,%esp
  801713:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801716:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801719:	50                   	push   %eax
  80171a:	ff 75 08             	pushl  0x8(%ebp)
  80171d:	e8 81 fb ff ff       	call   8012a3 <fd_lookup>
  801722:	83 c4 08             	add    $0x8,%esp
  801725:	85 c0                	test   %eax,%eax
  801727:	78 4b                	js     801774 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801729:	83 ec 08             	sub    $0x8,%esp
  80172c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80172f:	50                   	push   %eax
  801730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801733:	ff 30                	pushl  (%eax)
  801735:	e8 bf fb ff ff       	call   8012f9 <dev_lookup>
  80173a:	83 c4 10             	add    $0x10,%esp
  80173d:	85 c0                	test   %eax,%eax
  80173f:	78 33                	js     801774 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801744:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801748:	74 2f                	je     801779 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80174a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80174d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801754:	00 00 00 
	stat->st_isdir = 0;
  801757:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80175e:	00 00 00 
	stat->st_dev = dev;
  801761:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801767:	83 ec 08             	sub    $0x8,%esp
  80176a:	53                   	push   %ebx
  80176b:	ff 75 f0             	pushl  -0x10(%ebp)
  80176e:	ff 50 14             	call   *0x14(%eax)
  801771:	83 c4 10             	add    $0x10,%esp
}
  801774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801777:	c9                   	leave  
  801778:	c3                   	ret    
		return -E_NOT_SUPP;
  801779:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80177e:	eb f4                	jmp    801774 <fstat+0x68>

00801780 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	56                   	push   %esi
  801784:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801785:	83 ec 08             	sub    $0x8,%esp
  801788:	6a 00                	push   $0x0
  80178a:	ff 75 08             	pushl  0x8(%ebp)
  80178d:	e8 30 02 00 00       	call   8019c2 <open>
  801792:	89 c3                	mov    %eax,%ebx
  801794:	83 c4 10             	add    $0x10,%esp
  801797:	85 c0                	test   %eax,%eax
  801799:	78 1b                	js     8017b6 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80179b:	83 ec 08             	sub    $0x8,%esp
  80179e:	ff 75 0c             	pushl  0xc(%ebp)
  8017a1:	50                   	push   %eax
  8017a2:	e8 65 ff ff ff       	call   80170c <fstat>
  8017a7:	89 c6                	mov    %eax,%esi
	close(fd);
  8017a9:	89 1c 24             	mov    %ebx,(%esp)
  8017ac:	e8 27 fc ff ff       	call   8013d8 <close>
	return r;
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	89 f3                	mov    %esi,%ebx
}
  8017b6:	89 d8                	mov    %ebx,%eax
  8017b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017bb:	5b                   	pop    %ebx
  8017bc:	5e                   	pop    %esi
  8017bd:	5d                   	pop    %ebp
  8017be:	c3                   	ret    

008017bf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	56                   	push   %esi
  8017c3:	53                   	push   %ebx
  8017c4:	89 c6                	mov    %eax,%esi
  8017c6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017c8:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017cf:	74 27                	je     8017f8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017d1:	6a 07                	push   $0x7
  8017d3:	68 00 50 80 00       	push   $0x805000
  8017d8:	56                   	push   %esi
  8017d9:	ff 35 00 40 80 00    	pushl  0x804000
  8017df:	e8 33 08 00 00       	call   802017 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017e4:	83 c4 0c             	add    $0xc,%esp
  8017e7:	6a 00                	push   $0x0
  8017e9:	53                   	push   %ebx
  8017ea:	6a 00                	push   $0x0
  8017ec:	e8 bd 07 00 00       	call   801fae <ipc_recv>
}
  8017f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f4:	5b                   	pop    %ebx
  8017f5:	5e                   	pop    %esi
  8017f6:	5d                   	pop    %ebp
  8017f7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017f8:	83 ec 0c             	sub    $0xc,%esp
  8017fb:	6a 01                	push   $0x1
  8017fd:	e8 69 08 00 00       	call   80206b <ipc_find_env>
  801802:	a3 00 40 80 00       	mov    %eax,0x804000
  801807:	83 c4 10             	add    $0x10,%esp
  80180a:	eb c5                	jmp    8017d1 <fsipc+0x12>

0080180c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	8b 40 0c             	mov    0xc(%eax),%eax
  801818:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80181d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801820:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801825:	ba 00 00 00 00       	mov    $0x0,%edx
  80182a:	b8 02 00 00 00       	mov    $0x2,%eax
  80182f:	e8 8b ff ff ff       	call   8017bf <fsipc>
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <devfile_flush>:
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	8b 40 0c             	mov    0xc(%eax),%eax
  801842:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801847:	ba 00 00 00 00       	mov    $0x0,%edx
  80184c:	b8 06 00 00 00       	mov    $0x6,%eax
  801851:	e8 69 ff ff ff       	call   8017bf <fsipc>
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <devfile_stat>:
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	53                   	push   %ebx
  80185c:	83 ec 04             	sub    $0x4,%esp
  80185f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	8b 40 0c             	mov    0xc(%eax),%eax
  801868:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80186d:	ba 00 00 00 00       	mov    $0x0,%edx
  801872:	b8 05 00 00 00       	mov    $0x5,%eax
  801877:	e8 43 ff ff ff       	call   8017bf <fsipc>
  80187c:	85 c0                	test   %eax,%eax
  80187e:	78 2c                	js     8018ac <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801880:	83 ec 08             	sub    $0x8,%esp
  801883:	68 00 50 80 00       	push   $0x805000
  801888:	53                   	push   %ebx
  801889:	e8 f9 f0 ff ff       	call   800987 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80188e:	a1 80 50 80 00       	mov    0x805080,%eax
  801893:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801899:	a1 84 50 80 00       	mov    0x805084,%eax
  80189e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <devfile_write>:
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	53                   	push   %ebx
  8018b5:	83 ec 08             	sub    $0x8,%esp
  8018b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  8018bb:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8018c1:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8018c6:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8018cf:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8018d4:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8018da:	53                   	push   %ebx
  8018db:	ff 75 0c             	pushl  0xc(%ebp)
  8018de:	68 08 50 80 00       	push   $0x805008
  8018e3:	e8 2d f2 ff ff       	call   800b15 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ed:	b8 04 00 00 00       	mov    $0x4,%eax
  8018f2:	e8 c8 fe ff ff       	call   8017bf <fsipc>
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	78 0b                	js     801909 <devfile_write+0x58>
	assert(r <= n);
  8018fe:	39 d8                	cmp    %ebx,%eax
  801900:	77 0c                	ja     80190e <devfile_write+0x5d>
	assert(r <= PGSIZE);
  801902:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801907:	7f 1e                	jg     801927 <devfile_write+0x76>
}
  801909:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    
	assert(r <= n);
  80190e:	68 5c 28 80 00       	push   $0x80285c
  801913:	68 63 28 80 00       	push   $0x802863
  801918:	68 98 00 00 00       	push   $0x98
  80191d:	68 78 28 80 00       	push   $0x802878
  801922:	e8 66 e9 ff ff       	call   80028d <_panic>
	assert(r <= PGSIZE);
  801927:	68 83 28 80 00       	push   $0x802883
  80192c:	68 63 28 80 00       	push   $0x802863
  801931:	68 99 00 00 00       	push   $0x99
  801936:	68 78 28 80 00       	push   $0x802878
  80193b:	e8 4d e9 ff ff       	call   80028d <_panic>

00801940 <devfile_read>:
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	56                   	push   %esi
  801944:	53                   	push   %ebx
  801945:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	8b 40 0c             	mov    0xc(%eax),%eax
  80194e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801953:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801959:	ba 00 00 00 00       	mov    $0x0,%edx
  80195e:	b8 03 00 00 00       	mov    $0x3,%eax
  801963:	e8 57 fe ff ff       	call   8017bf <fsipc>
  801968:	89 c3                	mov    %eax,%ebx
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 1f                	js     80198d <devfile_read+0x4d>
	assert(r <= n);
  80196e:	39 f0                	cmp    %esi,%eax
  801970:	77 24                	ja     801996 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801972:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801977:	7f 33                	jg     8019ac <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801979:	83 ec 04             	sub    $0x4,%esp
  80197c:	50                   	push   %eax
  80197d:	68 00 50 80 00       	push   $0x805000
  801982:	ff 75 0c             	pushl  0xc(%ebp)
  801985:	e8 8b f1 ff ff       	call   800b15 <memmove>
	return r;
  80198a:	83 c4 10             	add    $0x10,%esp
}
  80198d:	89 d8                	mov    %ebx,%eax
  80198f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801992:	5b                   	pop    %ebx
  801993:	5e                   	pop    %esi
  801994:	5d                   	pop    %ebp
  801995:	c3                   	ret    
	assert(r <= n);
  801996:	68 5c 28 80 00       	push   $0x80285c
  80199b:	68 63 28 80 00       	push   $0x802863
  8019a0:	6a 7c                	push   $0x7c
  8019a2:	68 78 28 80 00       	push   $0x802878
  8019a7:	e8 e1 e8 ff ff       	call   80028d <_panic>
	assert(r <= PGSIZE);
  8019ac:	68 83 28 80 00       	push   $0x802883
  8019b1:	68 63 28 80 00       	push   $0x802863
  8019b6:	6a 7d                	push   $0x7d
  8019b8:	68 78 28 80 00       	push   $0x802878
  8019bd:	e8 cb e8 ff ff       	call   80028d <_panic>

008019c2 <open>:
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	56                   	push   %esi
  8019c6:	53                   	push   %ebx
  8019c7:	83 ec 1c             	sub    $0x1c,%esp
  8019ca:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019cd:	56                   	push   %esi
  8019ce:	e8 7d ef ff ff       	call   800950 <strlen>
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019db:	7f 6c                	jg     801a49 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019dd:	83 ec 0c             	sub    $0xc,%esp
  8019e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e3:	50                   	push   %eax
  8019e4:	e8 6b f8 ff ff       	call   801254 <fd_alloc>
  8019e9:	89 c3                	mov    %eax,%ebx
  8019eb:	83 c4 10             	add    $0x10,%esp
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	78 3c                	js     801a2e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019f2:	83 ec 08             	sub    $0x8,%esp
  8019f5:	56                   	push   %esi
  8019f6:	68 00 50 80 00       	push   $0x805000
  8019fb:	e8 87 ef ff ff       	call   800987 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a03:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a10:	e8 aa fd ff ff       	call   8017bf <fsipc>
  801a15:	89 c3                	mov    %eax,%ebx
  801a17:	83 c4 10             	add    $0x10,%esp
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	78 19                	js     801a37 <open+0x75>
	return fd2num(fd);
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	ff 75 f4             	pushl  -0xc(%ebp)
  801a24:	e8 04 f8 ff ff       	call   80122d <fd2num>
  801a29:	89 c3                	mov    %eax,%ebx
  801a2b:	83 c4 10             	add    $0x10,%esp
}
  801a2e:	89 d8                	mov    %ebx,%eax
  801a30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5e                   	pop    %esi
  801a35:	5d                   	pop    %ebp
  801a36:	c3                   	ret    
		fd_close(fd, 0);
  801a37:	83 ec 08             	sub    $0x8,%esp
  801a3a:	6a 00                	push   $0x0
  801a3c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3f:	e8 0b f9 ff ff       	call   80134f <fd_close>
		return r;
  801a44:	83 c4 10             	add    $0x10,%esp
  801a47:	eb e5                	jmp    801a2e <open+0x6c>
		return -E_BAD_PATH;
  801a49:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a4e:	eb de                	jmp    801a2e <open+0x6c>

00801a50 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a56:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5b:	b8 08 00 00 00       	mov    $0x8,%eax
  801a60:	e8 5a fd ff ff       	call   8017bf <fsipc>
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a6f:	83 ec 0c             	sub    $0xc,%esp
  801a72:	ff 75 08             	pushl  0x8(%ebp)
  801a75:	e8 c3 f7 ff ff       	call   80123d <fd2data>
  801a7a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a7c:	83 c4 08             	add    $0x8,%esp
  801a7f:	68 8f 28 80 00       	push   $0x80288f
  801a84:	53                   	push   %ebx
  801a85:	e8 fd ee ff ff       	call   800987 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a8a:	8b 46 04             	mov    0x4(%esi),%eax
  801a8d:	2b 06                	sub    (%esi),%eax
  801a8f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a95:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a9c:	00 00 00 
	stat->st_dev = &devpipe;
  801a9f:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801aa6:	30 80 00 
	return 0;
}
  801aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  801aae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab1:	5b                   	pop    %ebx
  801ab2:	5e                   	pop    %esi
  801ab3:	5d                   	pop    %ebp
  801ab4:	c3                   	ret    

00801ab5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	53                   	push   %ebx
  801ab9:	83 ec 0c             	sub    $0xc,%esp
  801abc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801abf:	53                   	push   %ebx
  801ac0:	6a 00                	push   $0x0
  801ac2:	e8 3e f3 ff ff       	call   800e05 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ac7:	89 1c 24             	mov    %ebx,(%esp)
  801aca:	e8 6e f7 ff ff       	call   80123d <fd2data>
  801acf:	83 c4 08             	add    $0x8,%esp
  801ad2:	50                   	push   %eax
  801ad3:	6a 00                	push   $0x0
  801ad5:	e8 2b f3 ff ff       	call   800e05 <sys_page_unmap>
}
  801ada:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <_pipeisclosed>:
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	57                   	push   %edi
  801ae3:	56                   	push   %esi
  801ae4:	53                   	push   %ebx
  801ae5:	83 ec 1c             	sub    $0x1c,%esp
  801ae8:	89 c7                	mov    %eax,%edi
  801aea:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801aec:	a1 04 40 80 00       	mov    0x804004,%eax
  801af1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801af4:	83 ec 0c             	sub    $0xc,%esp
  801af7:	57                   	push   %edi
  801af8:	e8 a7 05 00 00       	call   8020a4 <pageref>
  801afd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b00:	89 34 24             	mov    %esi,(%esp)
  801b03:	e8 9c 05 00 00       	call   8020a4 <pageref>
		nn = thisenv->env_runs;
  801b08:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b0e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	39 cb                	cmp    %ecx,%ebx
  801b16:	74 1b                	je     801b33 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b18:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b1b:	75 cf                	jne    801aec <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b1d:	8b 42 58             	mov    0x58(%edx),%eax
  801b20:	6a 01                	push   $0x1
  801b22:	50                   	push   %eax
  801b23:	53                   	push   %ebx
  801b24:	68 96 28 80 00       	push   $0x802896
  801b29:	e8 3a e8 ff ff       	call   800368 <cprintf>
  801b2e:	83 c4 10             	add    $0x10,%esp
  801b31:	eb b9                	jmp    801aec <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b33:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b36:	0f 94 c0             	sete   %al
  801b39:	0f b6 c0             	movzbl %al,%eax
}
  801b3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5f                   	pop    %edi
  801b42:	5d                   	pop    %ebp
  801b43:	c3                   	ret    

00801b44 <devpipe_write>:
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	57                   	push   %edi
  801b48:	56                   	push   %esi
  801b49:	53                   	push   %ebx
  801b4a:	83 ec 28             	sub    $0x28,%esp
  801b4d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b50:	56                   	push   %esi
  801b51:	e8 e7 f6 ff ff       	call   80123d <fd2data>
  801b56:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b58:	83 c4 10             	add    $0x10,%esp
  801b5b:	bf 00 00 00 00       	mov    $0x0,%edi
  801b60:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b63:	74 4f                	je     801bb4 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b65:	8b 43 04             	mov    0x4(%ebx),%eax
  801b68:	8b 0b                	mov    (%ebx),%ecx
  801b6a:	8d 51 20             	lea    0x20(%ecx),%edx
  801b6d:	39 d0                	cmp    %edx,%eax
  801b6f:	72 14                	jb     801b85 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b71:	89 da                	mov    %ebx,%edx
  801b73:	89 f0                	mov    %esi,%eax
  801b75:	e8 65 ff ff ff       	call   801adf <_pipeisclosed>
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	75 3a                	jne    801bb8 <devpipe_write+0x74>
			sys_yield();
  801b7e:	e8 de f1 ff ff       	call   800d61 <sys_yield>
  801b83:	eb e0                	jmp    801b65 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b88:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b8c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b8f:	89 c2                	mov    %eax,%edx
  801b91:	c1 fa 1f             	sar    $0x1f,%edx
  801b94:	89 d1                	mov    %edx,%ecx
  801b96:	c1 e9 1b             	shr    $0x1b,%ecx
  801b99:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b9c:	83 e2 1f             	and    $0x1f,%edx
  801b9f:	29 ca                	sub    %ecx,%edx
  801ba1:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ba5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ba9:	83 c0 01             	add    $0x1,%eax
  801bac:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801baf:	83 c7 01             	add    $0x1,%edi
  801bb2:	eb ac                	jmp    801b60 <devpipe_write+0x1c>
	return i;
  801bb4:	89 f8                	mov    %edi,%eax
  801bb6:	eb 05                	jmp    801bbd <devpipe_write+0x79>
				return 0;
  801bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc0:	5b                   	pop    %ebx
  801bc1:	5e                   	pop    %esi
  801bc2:	5f                   	pop    %edi
  801bc3:	5d                   	pop    %ebp
  801bc4:	c3                   	ret    

00801bc5 <devpipe_read>:
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	57                   	push   %edi
  801bc9:	56                   	push   %esi
  801bca:	53                   	push   %ebx
  801bcb:	83 ec 18             	sub    $0x18,%esp
  801bce:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801bd1:	57                   	push   %edi
  801bd2:	e8 66 f6 ff ff       	call   80123d <fd2data>
  801bd7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bd9:	83 c4 10             	add    $0x10,%esp
  801bdc:	be 00 00 00 00       	mov    $0x0,%esi
  801be1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801be4:	74 47                	je     801c2d <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801be6:	8b 03                	mov    (%ebx),%eax
  801be8:	3b 43 04             	cmp    0x4(%ebx),%eax
  801beb:	75 22                	jne    801c0f <devpipe_read+0x4a>
			if (i > 0)
  801bed:	85 f6                	test   %esi,%esi
  801bef:	75 14                	jne    801c05 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801bf1:	89 da                	mov    %ebx,%edx
  801bf3:	89 f8                	mov    %edi,%eax
  801bf5:	e8 e5 fe ff ff       	call   801adf <_pipeisclosed>
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	75 33                	jne    801c31 <devpipe_read+0x6c>
			sys_yield();
  801bfe:	e8 5e f1 ff ff       	call   800d61 <sys_yield>
  801c03:	eb e1                	jmp    801be6 <devpipe_read+0x21>
				return i;
  801c05:	89 f0                	mov    %esi,%eax
}
  801c07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c0a:	5b                   	pop    %ebx
  801c0b:	5e                   	pop    %esi
  801c0c:	5f                   	pop    %edi
  801c0d:	5d                   	pop    %ebp
  801c0e:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c0f:	99                   	cltd   
  801c10:	c1 ea 1b             	shr    $0x1b,%edx
  801c13:	01 d0                	add    %edx,%eax
  801c15:	83 e0 1f             	and    $0x1f,%eax
  801c18:	29 d0                	sub    %edx,%eax
  801c1a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c22:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c25:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c28:	83 c6 01             	add    $0x1,%esi
  801c2b:	eb b4                	jmp    801be1 <devpipe_read+0x1c>
	return i;
  801c2d:	89 f0                	mov    %esi,%eax
  801c2f:	eb d6                	jmp    801c07 <devpipe_read+0x42>
				return 0;
  801c31:	b8 00 00 00 00       	mov    $0x0,%eax
  801c36:	eb cf                	jmp    801c07 <devpipe_read+0x42>

00801c38 <pipe>:
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	56                   	push   %esi
  801c3c:	53                   	push   %ebx
  801c3d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c43:	50                   	push   %eax
  801c44:	e8 0b f6 ff ff       	call   801254 <fd_alloc>
  801c49:	89 c3                	mov    %eax,%ebx
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	78 5b                	js     801cad <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c52:	83 ec 04             	sub    $0x4,%esp
  801c55:	68 07 04 00 00       	push   $0x407
  801c5a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c5d:	6a 00                	push   $0x0
  801c5f:	e8 1c f1 ff ff       	call   800d80 <sys_page_alloc>
  801c64:	89 c3                	mov    %eax,%ebx
  801c66:	83 c4 10             	add    $0x10,%esp
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	78 40                	js     801cad <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801c6d:	83 ec 0c             	sub    $0xc,%esp
  801c70:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c73:	50                   	push   %eax
  801c74:	e8 db f5 ff ff       	call   801254 <fd_alloc>
  801c79:	89 c3                	mov    %eax,%ebx
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	78 1b                	js     801c9d <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c82:	83 ec 04             	sub    $0x4,%esp
  801c85:	68 07 04 00 00       	push   $0x407
  801c8a:	ff 75 f0             	pushl  -0x10(%ebp)
  801c8d:	6a 00                	push   $0x0
  801c8f:	e8 ec f0 ff ff       	call   800d80 <sys_page_alloc>
  801c94:	89 c3                	mov    %eax,%ebx
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	79 19                	jns    801cb6 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801c9d:	83 ec 08             	sub    $0x8,%esp
  801ca0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca3:	6a 00                	push   $0x0
  801ca5:	e8 5b f1 ff ff       	call   800e05 <sys_page_unmap>
  801caa:	83 c4 10             	add    $0x10,%esp
}
  801cad:	89 d8                	mov    %ebx,%eax
  801caf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb2:	5b                   	pop    %ebx
  801cb3:	5e                   	pop    %esi
  801cb4:	5d                   	pop    %ebp
  801cb5:	c3                   	ret    
	va = fd2data(fd0);
  801cb6:	83 ec 0c             	sub    $0xc,%esp
  801cb9:	ff 75 f4             	pushl  -0xc(%ebp)
  801cbc:	e8 7c f5 ff ff       	call   80123d <fd2data>
  801cc1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc3:	83 c4 0c             	add    $0xc,%esp
  801cc6:	68 07 04 00 00       	push   $0x407
  801ccb:	50                   	push   %eax
  801ccc:	6a 00                	push   $0x0
  801cce:	e8 ad f0 ff ff       	call   800d80 <sys_page_alloc>
  801cd3:	89 c3                	mov    %eax,%ebx
  801cd5:	83 c4 10             	add    $0x10,%esp
  801cd8:	85 c0                	test   %eax,%eax
  801cda:	0f 88 8c 00 00 00    	js     801d6c <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ce0:	83 ec 0c             	sub    $0xc,%esp
  801ce3:	ff 75 f0             	pushl  -0x10(%ebp)
  801ce6:	e8 52 f5 ff ff       	call   80123d <fd2data>
  801ceb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801cf2:	50                   	push   %eax
  801cf3:	6a 00                	push   $0x0
  801cf5:	56                   	push   %esi
  801cf6:	6a 00                	push   $0x0
  801cf8:	e8 c6 f0 ff ff       	call   800dc3 <sys_page_map>
  801cfd:	89 c3                	mov    %eax,%ebx
  801cff:	83 c4 20             	add    $0x20,%esp
  801d02:	85 c0                	test   %eax,%eax
  801d04:	78 58                	js     801d5e <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d09:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d0f:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d14:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d24:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d29:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d30:	83 ec 0c             	sub    $0xc,%esp
  801d33:	ff 75 f4             	pushl  -0xc(%ebp)
  801d36:	e8 f2 f4 ff ff       	call   80122d <fd2num>
  801d3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d3e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d40:	83 c4 04             	add    $0x4,%esp
  801d43:	ff 75 f0             	pushl  -0x10(%ebp)
  801d46:	e8 e2 f4 ff ff       	call   80122d <fd2num>
  801d4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d4e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d51:	83 c4 10             	add    $0x10,%esp
  801d54:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d59:	e9 4f ff ff ff       	jmp    801cad <pipe+0x75>
	sys_page_unmap(0, va);
  801d5e:	83 ec 08             	sub    $0x8,%esp
  801d61:	56                   	push   %esi
  801d62:	6a 00                	push   $0x0
  801d64:	e8 9c f0 ff ff       	call   800e05 <sys_page_unmap>
  801d69:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d6c:	83 ec 08             	sub    $0x8,%esp
  801d6f:	ff 75 f0             	pushl  -0x10(%ebp)
  801d72:	6a 00                	push   $0x0
  801d74:	e8 8c f0 ff ff       	call   800e05 <sys_page_unmap>
  801d79:	83 c4 10             	add    $0x10,%esp
  801d7c:	e9 1c ff ff ff       	jmp    801c9d <pipe+0x65>

00801d81 <pipeisclosed>:
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d8a:	50                   	push   %eax
  801d8b:	ff 75 08             	pushl  0x8(%ebp)
  801d8e:	e8 10 f5 ff ff       	call   8012a3 <fd_lookup>
  801d93:	83 c4 10             	add    $0x10,%esp
  801d96:	85 c0                	test   %eax,%eax
  801d98:	78 18                	js     801db2 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d9a:	83 ec 0c             	sub    $0xc,%esp
  801d9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801da0:	e8 98 f4 ff ff       	call   80123d <fd2data>
	return _pipeisclosed(fd, p);
  801da5:	89 c2                	mov    %eax,%edx
  801da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daa:	e8 30 fd ff ff       	call   801adf <_pipeisclosed>
  801daf:	83 c4 10             	add    $0x10,%esp
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbc:	5d                   	pop    %ebp
  801dbd:	c3                   	ret    

00801dbe <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801dc4:	68 a9 28 80 00       	push   $0x8028a9
  801dc9:	ff 75 0c             	pushl  0xc(%ebp)
  801dcc:	e8 b6 eb ff ff       	call   800987 <strcpy>
	return 0;
}
  801dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <devcons_write>:
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	57                   	push   %edi
  801ddc:	56                   	push   %esi
  801ddd:	53                   	push   %ebx
  801dde:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801de4:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801de9:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801def:	eb 2f                	jmp    801e20 <devcons_write+0x48>
		m = n - tot;
  801df1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801df4:	29 f3                	sub    %esi,%ebx
  801df6:	83 fb 7f             	cmp    $0x7f,%ebx
  801df9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801dfe:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e01:	83 ec 04             	sub    $0x4,%esp
  801e04:	53                   	push   %ebx
  801e05:	89 f0                	mov    %esi,%eax
  801e07:	03 45 0c             	add    0xc(%ebp),%eax
  801e0a:	50                   	push   %eax
  801e0b:	57                   	push   %edi
  801e0c:	e8 04 ed ff ff       	call   800b15 <memmove>
		sys_cputs(buf, m);
  801e11:	83 c4 08             	add    $0x8,%esp
  801e14:	53                   	push   %ebx
  801e15:	57                   	push   %edi
  801e16:	e8 a9 ee ff ff       	call   800cc4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e1b:	01 de                	add    %ebx,%esi
  801e1d:	83 c4 10             	add    $0x10,%esp
  801e20:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e23:	72 cc                	jb     801df1 <devcons_write+0x19>
}
  801e25:	89 f0                	mov    %esi,%eax
  801e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e2a:	5b                   	pop    %ebx
  801e2b:	5e                   	pop    %esi
  801e2c:	5f                   	pop    %edi
  801e2d:	5d                   	pop    %ebp
  801e2e:	c3                   	ret    

00801e2f <devcons_read>:
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	83 ec 08             	sub    $0x8,%esp
  801e35:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e3e:	75 07                	jne    801e47 <devcons_read+0x18>
}
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    
		sys_yield();
  801e42:	e8 1a ef ff ff       	call   800d61 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e47:	e8 96 ee ff ff       	call   800ce2 <sys_cgetc>
  801e4c:	85 c0                	test   %eax,%eax
  801e4e:	74 f2                	je     801e42 <devcons_read+0x13>
	if (c < 0)
  801e50:	85 c0                	test   %eax,%eax
  801e52:	78 ec                	js     801e40 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801e54:	83 f8 04             	cmp    $0x4,%eax
  801e57:	74 0c                	je     801e65 <devcons_read+0x36>
	*(char*)vbuf = c;
  801e59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5c:	88 02                	mov    %al,(%edx)
	return 1;
  801e5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e63:	eb db                	jmp    801e40 <devcons_read+0x11>
		return 0;
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6a:	eb d4                	jmp    801e40 <devcons_read+0x11>

00801e6c <cputchar>:
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e78:	6a 01                	push   $0x1
  801e7a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e7d:	50                   	push   %eax
  801e7e:	e8 41 ee ff ff       	call   800cc4 <sys_cputs>
}
  801e83:	83 c4 10             	add    $0x10,%esp
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <getchar>:
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e8e:	6a 01                	push   $0x1
  801e90:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e93:	50                   	push   %eax
  801e94:	6a 00                	push   $0x0
  801e96:	e8 79 f6 ff ff       	call   801514 <read>
	if (r < 0)
  801e9b:	83 c4 10             	add    $0x10,%esp
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	78 08                	js     801eaa <getchar+0x22>
	if (r < 1)
  801ea2:	85 c0                	test   %eax,%eax
  801ea4:	7e 06                	jle    801eac <getchar+0x24>
	return c;
  801ea6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    
		return -E_EOF;
  801eac:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801eb1:	eb f7                	jmp    801eaa <getchar+0x22>

00801eb3 <iscons>:
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ebc:	50                   	push   %eax
  801ebd:	ff 75 08             	pushl  0x8(%ebp)
  801ec0:	e8 de f3 ff ff       	call   8012a3 <fd_lookup>
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	78 11                	js     801edd <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecf:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ed5:	39 10                	cmp    %edx,(%eax)
  801ed7:	0f 94 c0             	sete   %al
  801eda:	0f b6 c0             	movzbl %al,%eax
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <opencons>:
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801ee5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee8:	50                   	push   %eax
  801ee9:	e8 66 f3 ff ff       	call   801254 <fd_alloc>
  801eee:	83 c4 10             	add    $0x10,%esp
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	78 3a                	js     801f2f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ef5:	83 ec 04             	sub    $0x4,%esp
  801ef8:	68 07 04 00 00       	push   $0x407
  801efd:	ff 75 f4             	pushl  -0xc(%ebp)
  801f00:	6a 00                	push   $0x0
  801f02:	e8 79 ee ff ff       	call   800d80 <sys_page_alloc>
  801f07:	83 c4 10             	add    $0x10,%esp
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	78 21                	js     801f2f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f17:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f23:	83 ec 0c             	sub    $0xc,%esp
  801f26:	50                   	push   %eax
  801f27:	e8 01 f3 ff ff       	call   80122d <fd2num>
  801f2c:	83 c4 10             	add    $0x10,%esp
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801f37:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801f3e:	74 0a                	je     801f4a <set_pgfault_handler+0x19>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    
		int r = sys_page_alloc(0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P);	//为当前进程分配异常栈
  801f4a:	83 ec 04             	sub    $0x4,%esp
  801f4d:	6a 07                	push   $0x7
  801f4f:	68 00 f0 bf ee       	push   $0xeebff000
  801f54:	6a 00                	push   $0x0
  801f56:	e8 25 ee ff ff       	call   800d80 <sys_page_alloc>
		if (r < 0) {
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	78 14                	js     801f76 <set_pgfault_handler+0x45>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
  801f62:	83 ec 08             	sub    $0x8,%esp
  801f65:	68 8a 1f 80 00       	push   $0x801f8a
  801f6a:	6a 00                	push   $0x0
  801f6c:	e8 5a ef ff ff       	call   800ecb <sys_env_set_pgfault_upcall>
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	eb ca                	jmp    801f40 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler:sys_page_alloc failed");;
  801f76:	83 ec 04             	sub    $0x4,%esp
  801f79:	68 b8 28 80 00       	push   $0x8028b8
  801f7e:	6a 22                	push   $0x22
  801f80:	68 e4 28 80 00       	push   $0x8028e4
  801f85:	e8 03 e3 ff ff       	call   80028d <_panic>

00801f8a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f8a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f8b:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax				//调用页处理函数
  801f90:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801f92:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp			//跳过utf_fault_va和utf_err
  801f95:	83 c4 08             	add    $0x8,%esp
	movl 40(%esp), %eax 	//保存中断发生时的esp到eax
  801f98:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl 32(%esp), %ecx 	//保存终端发生时的eip到ecx
  801f9c:	8b 4c 24 20          	mov    0x20(%esp),%ecx
	movl %ecx, -4(%eax) 	//将中断发生时的esp值亚入到到原来的栈中
  801fa0:	89 48 fc             	mov    %ecx,-0x4(%eax)
	popal
  801fa3:	61                   	popa   
	addl $4, %esp			//跳过eip
  801fa4:	83 c4 04             	add    $0x4,%esp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801fa7:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801fa8:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	lea -4(%esp), %esp		//因为之前压入了eip的值但是没有减esp的值，所以现在需要将esp寄存器中的值减4
  801fa9:	8d 64 24 fc          	lea    -0x4(%esp),%esp
  801fad:	c3                   	ret    

00801fae <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	56                   	push   %esi
  801fb2:	53                   	push   %ebx
  801fb3:	8b 75 08             	mov    0x8(%ebp),%esi
  801fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801fbc:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  801fbe:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801fc3:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  801fc6:	83 ec 0c             	sub    $0xc,%esp
  801fc9:	50                   	push   %eax
  801fca:	e8 61 ef ff ff       	call   800f30 <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  801fcf:	83 c4 10             	add    $0x10,%esp
  801fd2:	85 c0                	test   %eax,%eax
  801fd4:	78 2b                	js     802001 <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  801fd6:	85 f6                	test   %esi,%esi
  801fd8:	74 0a                	je     801fe4 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801fda:	a1 04 40 80 00       	mov    0x804004,%eax
  801fdf:	8b 40 74             	mov    0x74(%eax),%eax
  801fe2:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  801fe4:	85 db                	test   %ebx,%ebx
  801fe6:	74 0a                	je     801ff2 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801fe8:	a1 04 40 80 00       	mov    0x804004,%eax
  801fed:	8b 40 78             	mov    0x78(%eax),%eax
  801ff0:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801ff2:	a1 04 40 80 00       	mov    0x804004,%eax
  801ff7:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ffa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ffd:	5b                   	pop    %ebx
  801ffe:	5e                   	pop    %esi
  801fff:	5d                   	pop    %ebp
  802000:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802001:	85 f6                	test   %esi,%esi
  802003:	74 06                	je     80200b <ipc_recv+0x5d>
  802005:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  80200b:	85 db                	test   %ebx,%ebx
  80200d:	74 eb                	je     801ffa <ipc_recv+0x4c>
  80200f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802015:	eb e3                	jmp    801ffa <ipc_recv+0x4c>

00802017 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	57                   	push   %edi
  80201b:	56                   	push   %esi
  80201c:	53                   	push   %ebx
  80201d:	83 ec 0c             	sub    $0xc,%esp
  802020:	8b 7d 08             	mov    0x8(%ebp),%edi
  802023:	8b 75 0c             	mov    0xc(%ebp),%esi
  802026:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  802029:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  80202b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802030:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  802033:	ff 75 14             	pushl  0x14(%ebp)
  802036:	53                   	push   %ebx
  802037:	56                   	push   %esi
  802038:	57                   	push   %edi
  802039:	e8 cf ee ff ff       	call   800f0d <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  80203e:	83 c4 10             	add    $0x10,%esp
  802041:	85 c0                	test   %eax,%eax
  802043:	74 1e                	je     802063 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  802045:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802048:	75 07                	jne    802051 <ipc_send+0x3a>
			sys_yield();
  80204a:	e8 12 ed ff ff       	call   800d61 <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  80204f:	eb e2                	jmp    802033 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  802051:	50                   	push   %eax
  802052:	68 f2 28 80 00       	push   $0x8028f2
  802057:	6a 41                	push   $0x41
  802059:	68 00 29 80 00       	push   $0x802900
  80205e:	e8 2a e2 ff ff       	call   80028d <_panic>
		}
	}
}
  802063:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802066:	5b                   	pop    %ebx
  802067:	5e                   	pop    %esi
  802068:	5f                   	pop    %edi
  802069:	5d                   	pop    %ebp
  80206a:	c3                   	ret    

0080206b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802076:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802079:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80207f:	8b 52 50             	mov    0x50(%edx),%edx
  802082:	39 ca                	cmp    %ecx,%edx
  802084:	74 11                	je     802097 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802086:	83 c0 01             	add    $0x1,%eax
  802089:	3d 00 04 00 00       	cmp    $0x400,%eax
  80208e:	75 e6                	jne    802076 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802090:	b8 00 00 00 00       	mov    $0x0,%eax
  802095:	eb 0b                	jmp    8020a2 <ipc_find_env+0x37>
			return envs[i].env_id;
  802097:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80209a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80209f:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020a2:	5d                   	pop    %ebp
  8020a3:	c3                   	ret    

008020a4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020aa:	89 d0                	mov    %edx,%eax
  8020ac:	c1 e8 16             	shr    $0x16,%eax
  8020af:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020b6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020bb:	f6 c1 01             	test   $0x1,%cl
  8020be:	74 1d                	je     8020dd <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020c0:	c1 ea 0c             	shr    $0xc,%edx
  8020c3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020ca:	f6 c2 01             	test   $0x1,%dl
  8020cd:	74 0e                	je     8020dd <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020cf:	c1 ea 0c             	shr    $0xc,%edx
  8020d2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020d9:	ef 
  8020da:	0f b7 c0             	movzwl %ax,%eax
}
  8020dd:	5d                   	pop    %ebp
  8020de:	c3                   	ret    
  8020df:	90                   	nop

008020e0 <__udivdi3>:
  8020e0:	55                   	push   %ebp
  8020e1:	57                   	push   %edi
  8020e2:	56                   	push   %esi
  8020e3:	53                   	push   %ebx
  8020e4:	83 ec 1c             	sub    $0x1c,%esp
  8020e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020f7:	85 d2                	test   %edx,%edx
  8020f9:	75 35                	jne    802130 <__udivdi3+0x50>
  8020fb:	39 f3                	cmp    %esi,%ebx
  8020fd:	0f 87 bd 00 00 00    	ja     8021c0 <__udivdi3+0xe0>
  802103:	85 db                	test   %ebx,%ebx
  802105:	89 d9                	mov    %ebx,%ecx
  802107:	75 0b                	jne    802114 <__udivdi3+0x34>
  802109:	b8 01 00 00 00       	mov    $0x1,%eax
  80210e:	31 d2                	xor    %edx,%edx
  802110:	f7 f3                	div    %ebx
  802112:	89 c1                	mov    %eax,%ecx
  802114:	31 d2                	xor    %edx,%edx
  802116:	89 f0                	mov    %esi,%eax
  802118:	f7 f1                	div    %ecx
  80211a:	89 c6                	mov    %eax,%esi
  80211c:	89 e8                	mov    %ebp,%eax
  80211e:	89 f7                	mov    %esi,%edi
  802120:	f7 f1                	div    %ecx
  802122:	89 fa                	mov    %edi,%edx
  802124:	83 c4 1c             	add    $0x1c,%esp
  802127:	5b                   	pop    %ebx
  802128:	5e                   	pop    %esi
  802129:	5f                   	pop    %edi
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    
  80212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802130:	39 f2                	cmp    %esi,%edx
  802132:	77 7c                	ja     8021b0 <__udivdi3+0xd0>
  802134:	0f bd fa             	bsr    %edx,%edi
  802137:	83 f7 1f             	xor    $0x1f,%edi
  80213a:	0f 84 98 00 00 00    	je     8021d8 <__udivdi3+0xf8>
  802140:	89 f9                	mov    %edi,%ecx
  802142:	b8 20 00 00 00       	mov    $0x20,%eax
  802147:	29 f8                	sub    %edi,%eax
  802149:	d3 e2                	shl    %cl,%edx
  80214b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80214f:	89 c1                	mov    %eax,%ecx
  802151:	89 da                	mov    %ebx,%edx
  802153:	d3 ea                	shr    %cl,%edx
  802155:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802159:	09 d1                	or     %edx,%ecx
  80215b:	89 f2                	mov    %esi,%edx
  80215d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802161:	89 f9                	mov    %edi,%ecx
  802163:	d3 e3                	shl    %cl,%ebx
  802165:	89 c1                	mov    %eax,%ecx
  802167:	d3 ea                	shr    %cl,%edx
  802169:	89 f9                	mov    %edi,%ecx
  80216b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80216f:	d3 e6                	shl    %cl,%esi
  802171:	89 eb                	mov    %ebp,%ebx
  802173:	89 c1                	mov    %eax,%ecx
  802175:	d3 eb                	shr    %cl,%ebx
  802177:	09 de                	or     %ebx,%esi
  802179:	89 f0                	mov    %esi,%eax
  80217b:	f7 74 24 08          	divl   0x8(%esp)
  80217f:	89 d6                	mov    %edx,%esi
  802181:	89 c3                	mov    %eax,%ebx
  802183:	f7 64 24 0c          	mull   0xc(%esp)
  802187:	39 d6                	cmp    %edx,%esi
  802189:	72 0c                	jb     802197 <__udivdi3+0xb7>
  80218b:	89 f9                	mov    %edi,%ecx
  80218d:	d3 e5                	shl    %cl,%ebp
  80218f:	39 c5                	cmp    %eax,%ebp
  802191:	73 5d                	jae    8021f0 <__udivdi3+0x110>
  802193:	39 d6                	cmp    %edx,%esi
  802195:	75 59                	jne    8021f0 <__udivdi3+0x110>
  802197:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80219a:	31 ff                	xor    %edi,%edi
  80219c:	89 fa                	mov    %edi,%edx
  80219e:	83 c4 1c             	add    $0x1c,%esp
  8021a1:	5b                   	pop    %ebx
  8021a2:	5e                   	pop    %esi
  8021a3:	5f                   	pop    %edi
  8021a4:	5d                   	pop    %ebp
  8021a5:	c3                   	ret    
  8021a6:	8d 76 00             	lea    0x0(%esi),%esi
  8021a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021b0:	31 ff                	xor    %edi,%edi
  8021b2:	31 c0                	xor    %eax,%eax
  8021b4:	89 fa                	mov    %edi,%edx
  8021b6:	83 c4 1c             	add    $0x1c,%esp
  8021b9:	5b                   	pop    %ebx
  8021ba:	5e                   	pop    %esi
  8021bb:	5f                   	pop    %edi
  8021bc:	5d                   	pop    %ebp
  8021bd:	c3                   	ret    
  8021be:	66 90                	xchg   %ax,%ax
  8021c0:	31 ff                	xor    %edi,%edi
  8021c2:	89 e8                	mov    %ebp,%eax
  8021c4:	89 f2                	mov    %esi,%edx
  8021c6:	f7 f3                	div    %ebx
  8021c8:	89 fa                	mov    %edi,%edx
  8021ca:	83 c4 1c             	add    $0x1c,%esp
  8021cd:	5b                   	pop    %ebx
  8021ce:	5e                   	pop    %esi
  8021cf:	5f                   	pop    %edi
  8021d0:	5d                   	pop    %ebp
  8021d1:	c3                   	ret    
  8021d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021d8:	39 f2                	cmp    %esi,%edx
  8021da:	72 06                	jb     8021e2 <__udivdi3+0x102>
  8021dc:	31 c0                	xor    %eax,%eax
  8021de:	39 eb                	cmp    %ebp,%ebx
  8021e0:	77 d2                	ja     8021b4 <__udivdi3+0xd4>
  8021e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e7:	eb cb                	jmp    8021b4 <__udivdi3+0xd4>
  8021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021f0:	89 d8                	mov    %ebx,%eax
  8021f2:	31 ff                	xor    %edi,%edi
  8021f4:	eb be                	jmp    8021b4 <__udivdi3+0xd4>
  8021f6:	66 90                	xchg   %ax,%ax
  8021f8:	66 90                	xchg   %ax,%ax
  8021fa:	66 90                	xchg   %ax,%ax
  8021fc:	66 90                	xchg   %ax,%ax
  8021fe:	66 90                	xchg   %ax,%ax

00802200 <__umoddi3>:
  802200:	55                   	push   %ebp
  802201:	57                   	push   %edi
  802202:	56                   	push   %esi
  802203:	53                   	push   %ebx
  802204:	83 ec 1c             	sub    $0x1c,%esp
  802207:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80220b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80220f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802213:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802217:	85 ed                	test   %ebp,%ebp
  802219:	89 f0                	mov    %esi,%eax
  80221b:	89 da                	mov    %ebx,%edx
  80221d:	75 19                	jne    802238 <__umoddi3+0x38>
  80221f:	39 df                	cmp    %ebx,%edi
  802221:	0f 86 b1 00 00 00    	jbe    8022d8 <__umoddi3+0xd8>
  802227:	f7 f7                	div    %edi
  802229:	89 d0                	mov    %edx,%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	83 c4 1c             	add    $0x1c,%esp
  802230:	5b                   	pop    %ebx
  802231:	5e                   	pop    %esi
  802232:	5f                   	pop    %edi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    
  802235:	8d 76 00             	lea    0x0(%esi),%esi
  802238:	39 dd                	cmp    %ebx,%ebp
  80223a:	77 f1                	ja     80222d <__umoddi3+0x2d>
  80223c:	0f bd cd             	bsr    %ebp,%ecx
  80223f:	83 f1 1f             	xor    $0x1f,%ecx
  802242:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802246:	0f 84 b4 00 00 00    	je     802300 <__umoddi3+0x100>
  80224c:	b8 20 00 00 00       	mov    $0x20,%eax
  802251:	89 c2                	mov    %eax,%edx
  802253:	8b 44 24 04          	mov    0x4(%esp),%eax
  802257:	29 c2                	sub    %eax,%edx
  802259:	89 c1                	mov    %eax,%ecx
  80225b:	89 f8                	mov    %edi,%eax
  80225d:	d3 e5                	shl    %cl,%ebp
  80225f:	89 d1                	mov    %edx,%ecx
  802261:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802265:	d3 e8                	shr    %cl,%eax
  802267:	09 c5                	or     %eax,%ebp
  802269:	8b 44 24 04          	mov    0x4(%esp),%eax
  80226d:	89 c1                	mov    %eax,%ecx
  80226f:	d3 e7                	shl    %cl,%edi
  802271:	89 d1                	mov    %edx,%ecx
  802273:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802277:	89 df                	mov    %ebx,%edi
  802279:	d3 ef                	shr    %cl,%edi
  80227b:	89 c1                	mov    %eax,%ecx
  80227d:	89 f0                	mov    %esi,%eax
  80227f:	d3 e3                	shl    %cl,%ebx
  802281:	89 d1                	mov    %edx,%ecx
  802283:	89 fa                	mov    %edi,%edx
  802285:	d3 e8                	shr    %cl,%eax
  802287:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80228c:	09 d8                	or     %ebx,%eax
  80228e:	f7 f5                	div    %ebp
  802290:	d3 e6                	shl    %cl,%esi
  802292:	89 d1                	mov    %edx,%ecx
  802294:	f7 64 24 08          	mull   0x8(%esp)
  802298:	39 d1                	cmp    %edx,%ecx
  80229a:	89 c3                	mov    %eax,%ebx
  80229c:	89 d7                	mov    %edx,%edi
  80229e:	72 06                	jb     8022a6 <__umoddi3+0xa6>
  8022a0:	75 0e                	jne    8022b0 <__umoddi3+0xb0>
  8022a2:	39 c6                	cmp    %eax,%esi
  8022a4:	73 0a                	jae    8022b0 <__umoddi3+0xb0>
  8022a6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8022aa:	19 ea                	sbb    %ebp,%edx
  8022ac:	89 d7                	mov    %edx,%edi
  8022ae:	89 c3                	mov    %eax,%ebx
  8022b0:	89 ca                	mov    %ecx,%edx
  8022b2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022b7:	29 de                	sub    %ebx,%esi
  8022b9:	19 fa                	sbb    %edi,%edx
  8022bb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8022bf:	89 d0                	mov    %edx,%eax
  8022c1:	d3 e0                	shl    %cl,%eax
  8022c3:	89 d9                	mov    %ebx,%ecx
  8022c5:	d3 ee                	shr    %cl,%esi
  8022c7:	d3 ea                	shr    %cl,%edx
  8022c9:	09 f0                	or     %esi,%eax
  8022cb:	83 c4 1c             	add    $0x1c,%esp
  8022ce:	5b                   	pop    %ebx
  8022cf:	5e                   	pop    %esi
  8022d0:	5f                   	pop    %edi
  8022d1:	5d                   	pop    %ebp
  8022d2:	c3                   	ret    
  8022d3:	90                   	nop
  8022d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022d8:	85 ff                	test   %edi,%edi
  8022da:	89 f9                	mov    %edi,%ecx
  8022dc:	75 0b                	jne    8022e9 <__umoddi3+0xe9>
  8022de:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e3:	31 d2                	xor    %edx,%edx
  8022e5:	f7 f7                	div    %edi
  8022e7:	89 c1                	mov    %eax,%ecx
  8022e9:	89 d8                	mov    %ebx,%eax
  8022eb:	31 d2                	xor    %edx,%edx
  8022ed:	f7 f1                	div    %ecx
  8022ef:	89 f0                	mov    %esi,%eax
  8022f1:	f7 f1                	div    %ecx
  8022f3:	e9 31 ff ff ff       	jmp    802229 <__umoddi3+0x29>
  8022f8:	90                   	nop
  8022f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802300:	39 dd                	cmp    %ebx,%ebp
  802302:	72 08                	jb     80230c <__umoddi3+0x10c>
  802304:	39 f7                	cmp    %esi,%edi
  802306:	0f 87 21 ff ff ff    	ja     80222d <__umoddi3+0x2d>
  80230c:	89 da                	mov    %ebx,%edx
  80230e:	89 f0                	mov    %esi,%eax
  802310:	29 f8                	sub    %edi,%eax
  802312:	19 ea                	sbb    %ebp,%edx
  802314:	e9 14 ff ff ff       	jmp    80222d <__umoddi3+0x2d>
