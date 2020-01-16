
obj/user/testpipe.debug：     文件格式 elf32-i386


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
  80002c:	e8 a5 02 00 00       	call   8002d6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 30 80 00 20 	movl   $0x802420,0x803004
  800042:	24 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 8b 1c 00 00       	call   801cd9 <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1f 01 00 00    	js     80017a <umain+0x147>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 82 10 00 00       	call   8010e2 <fork>
  800060:	89 c3                	mov    %eax,%ebx
  800062:	85 c0                	test   %eax,%eax
  800064:	0f 88 22 01 00 00    	js     80018c <umain+0x159>
		panic("fork: %e", i);

	if (pid == 0) {
  80006a:	85 c0                	test   %eax,%eax
  80006c:	0f 85 58 01 00 00    	jne    8001ca <umain+0x197>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800072:	a1 04 40 80 00       	mov    0x804004,%eax
  800077:	8b 40 48             	mov    0x48(%eax),%eax
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	ff 75 90             	pushl  -0x70(%ebp)
  800080:	50                   	push   %eax
  800081:	68 45 24 80 00       	push   $0x802445
  800086:	e8 7e 03 00 00       	call   800409 <cprintf>
		close(p[1]);
  80008b:	83 c4 04             	add    $0x4,%esp
  80008e:	ff 75 90             	pushl  -0x70(%ebp)
  800091:	e8 e3 13 00 00       	call   801479 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800096:	a1 04 40 80 00       	mov    0x804004,%eax
  80009b:	8b 40 48             	mov    0x48(%eax),%eax
  80009e:	83 c4 0c             	add    $0xc,%esp
  8000a1:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a4:	50                   	push   %eax
  8000a5:	68 62 24 80 00       	push   $0x802462
  8000aa:	e8 5a 03 00 00       	call   800409 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000af:	83 c4 0c             	add    $0xc,%esp
  8000b2:	6a 63                	push   $0x63
  8000b4:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b7:	50                   	push   %eax
  8000b8:	ff 75 8c             	pushl  -0x74(%ebp)
  8000bb:	e8 7c 15 00 00       	call   80163c <readn>
  8000c0:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	85 c0                	test   %eax,%eax
  8000c7:	0f 88 d1 00 00 00    	js     80019e <umain+0x16b>
			panic("read: %e", i);
		buf[i] = 0;
  8000cd:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	ff 35 00 30 80 00    	pushl  0x803000
  8000db:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000de:	50                   	push   %eax
  8000df:	e8 ea 09 00 00       	call   800ace <strcmp>
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	85 c0                	test   %eax,%eax
  8000e9:	0f 85 c1 00 00 00    	jne    8001b0 <umain+0x17d>
			cprintf("\npipe read closed properly\n");
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 88 24 80 00       	push   $0x802488
  8000f7:	e8 0d 03 00 00       	call   800409 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  8000ff:	e8 18 02 00 00       	call   80031c <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	53                   	push   %ebx
  800108:	e8 48 1d 00 00       	call   801e55 <wait>

	binaryname = "pipewriteeof";
  80010d:	c7 05 04 30 80 00 de 	movl   $0x8024de,0x803004
  800114:	24 80 00 
	if ((i = pipe(p)) < 0)
  800117:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80011a:	89 04 24             	mov    %eax,(%esp)
  80011d:	e8 b7 1b 00 00       	call   801cd9 <pipe>
  800122:	89 c6                	mov    %eax,%esi
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	85 c0                	test   %eax,%eax
  800129:	0f 88 34 01 00 00    	js     800263 <umain+0x230>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012f:	e8 ae 0f 00 00       	call   8010e2 <fork>
  800134:	89 c3                	mov    %eax,%ebx
  800136:	85 c0                	test   %eax,%eax
  800138:	0f 88 37 01 00 00    	js     800275 <umain+0x242>
		panic("fork: %e", i);

	if (pid == 0) {
  80013e:	85 c0                	test   %eax,%eax
  800140:	0f 84 41 01 00 00    	je     800287 <umain+0x254>
				break;
		}
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 8c             	pushl  -0x74(%ebp)
  80014c:	e8 28 13 00 00       	call   801479 <close>
	close(p[1]);
  800151:	83 c4 04             	add    $0x4,%esp
  800154:	ff 75 90             	pushl  -0x70(%ebp)
  800157:	e8 1d 13 00 00       	call   801479 <close>
	wait(pid);
  80015c:	89 1c 24             	mov    %ebx,(%esp)
  80015f:	e8 f1 1c 00 00       	call   801e55 <wait>

	cprintf("pipe tests passed\n");
  800164:	c7 04 24 0c 25 80 00 	movl   $0x80250c,(%esp)
  80016b:	e8 99 02 00 00       	call   800409 <cprintf>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    
		panic("pipe: %e", i);
  80017a:	50                   	push   %eax
  80017b:	68 2c 24 80 00       	push   $0x80242c
  800180:	6a 0e                	push   $0xe
  800182:	68 35 24 80 00       	push   $0x802435
  800187:	e8 a2 01 00 00       	call   80032e <_panic>
		panic("fork: %e", i);
  80018c:	56                   	push   %esi
  80018d:	68 25 29 80 00       	push   $0x802925
  800192:	6a 11                	push   $0x11
  800194:	68 35 24 80 00       	push   $0x802435
  800199:	e8 90 01 00 00       	call   80032e <_panic>
			panic("read: %e", i);
  80019e:	50                   	push   %eax
  80019f:	68 7f 24 80 00       	push   $0x80247f
  8001a4:	6a 19                	push   $0x19
  8001a6:	68 35 24 80 00       	push   $0x802435
  8001ab:	e8 7e 01 00 00       	call   80032e <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	56                   	push   %esi
  8001b8:	68 a4 24 80 00       	push   $0x8024a4
  8001bd:	e8 47 02 00 00       	call   800409 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	e9 35 ff ff ff       	jmp    8000ff <umain+0xcc>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001ca:	a1 04 40 80 00       	mov    0x804004,%eax
  8001cf:	8b 40 48             	mov    0x48(%eax),%eax
  8001d2:	83 ec 04             	sub    $0x4,%esp
  8001d5:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d8:	50                   	push   %eax
  8001d9:	68 45 24 80 00       	push   $0x802445
  8001de:	e8 26 02 00 00       	call   800409 <cprintf>
		close(p[0]);
  8001e3:	83 c4 04             	add    $0x4,%esp
  8001e6:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e9:	e8 8b 12 00 00       	call   801479 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8001f3:	8b 40 48             	mov    0x48(%eax),%eax
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	ff 75 90             	pushl  -0x70(%ebp)
  8001fc:	50                   	push   %eax
  8001fd:	68 b7 24 80 00       	push   $0x8024b7
  800202:	e8 02 02 00 00       	call   800409 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800207:	83 c4 04             	add    $0x4,%esp
  80020a:	ff 35 00 30 80 00    	pushl  0x803000
  800210:	e8 dc 07 00 00       	call   8009f1 <strlen>
  800215:	83 c4 0c             	add    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	ff 35 00 30 80 00    	pushl  0x803000
  80021f:	ff 75 90             	pushl  -0x70(%ebp)
  800222:	e8 5c 14 00 00       	call   801683 <write>
  800227:	89 c6                	mov    %eax,%esi
  800229:	83 c4 04             	add    $0x4,%esp
  80022c:	ff 35 00 30 80 00    	pushl  0x803000
  800232:	e8 ba 07 00 00       	call   8009f1 <strlen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	39 f0                	cmp    %esi,%eax
  80023c:	75 13                	jne    800251 <umain+0x21e>
		close(p[1]);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 90             	pushl  -0x70(%ebp)
  800244:	e8 30 12 00 00       	call   801479 <close>
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	e9 b3 fe ff ff       	jmp    800104 <umain+0xd1>
			panic("write: %e", i);
  800251:	56                   	push   %esi
  800252:	68 d4 24 80 00       	push   $0x8024d4
  800257:	6a 25                	push   $0x25
  800259:	68 35 24 80 00       	push   $0x802435
  80025e:	e8 cb 00 00 00       	call   80032e <_panic>
		panic("pipe: %e", i);
  800263:	50                   	push   %eax
  800264:	68 2c 24 80 00       	push   $0x80242c
  800269:	6a 2c                	push   $0x2c
  80026b:	68 35 24 80 00       	push   $0x802435
  800270:	e8 b9 00 00 00       	call   80032e <_panic>
		panic("fork: %e", i);
  800275:	56                   	push   %esi
  800276:	68 25 29 80 00       	push   $0x802925
  80027b:	6a 2f                	push   $0x2f
  80027d:	68 35 24 80 00       	push   $0x802435
  800282:	e8 a7 00 00 00       	call   80032e <_panic>
		close(p[0]);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	ff 75 8c             	pushl  -0x74(%ebp)
  80028d:	e8 e7 11 00 00       	call   801479 <close>
  800292:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 eb 24 80 00       	push   $0x8024eb
  80029d:	e8 67 01 00 00       	call   800409 <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002a2:	83 c4 0c             	add    $0xc,%esp
  8002a5:	6a 01                	push   $0x1
  8002a7:	68 ed 24 80 00       	push   $0x8024ed
  8002ac:	ff 75 90             	pushl  -0x70(%ebp)
  8002af:	e8 cf 13 00 00       	call   801683 <write>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	83 f8 01             	cmp    $0x1,%eax
  8002ba:	74 d9                	je     800295 <umain+0x262>
		cprintf("\npipe write closed properly\n");
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 ef 24 80 00       	push   $0x8024ef
  8002c4:	e8 40 01 00 00       	call   800409 <cprintf>
		exit();
  8002c9:	e8 4e 00 00 00       	call   80031c <exit>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	e9 70 fe ff ff       	jmp    800146 <umain+0x113>

008002d6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002de:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  8002e1:	e8 fd 0a 00 00       	call   800de3 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  8002e6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002eb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f3:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f8:	85 db                	test   %ebx,%ebx
  8002fa:	7e 07                	jle    800303 <libmain+0x2d>
		binaryname = argv[0];
  8002fc:	8b 06                	mov    (%esi),%eax
  8002fe:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	56                   	push   %esi
  800307:	53                   	push   %ebx
  800308:	e8 26 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80030d:	e8 0a 00 00 00       	call   80031c <exit>
}
  800312:	83 c4 10             	add    $0x10,%esp
  800315:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800318:	5b                   	pop    %ebx
  800319:	5e                   	pop    %esi
  80031a:	5d                   	pop    %ebp
  80031b:	c3                   	ret    

0080031c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800322:	6a 00                	push   $0x0
  800324:	e8 79 0a 00 00       	call   800da2 <sys_env_destroy>
}
  800329:	83 c4 10             	add    $0x10,%esp
  80032c:	c9                   	leave  
  80032d:	c3                   	ret    

0080032e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80032e:	55                   	push   %ebp
  80032f:	89 e5                	mov    %esp,%ebp
  800331:	56                   	push   %esi
  800332:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800333:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800336:	8b 35 04 30 80 00    	mov    0x803004,%esi
  80033c:	e8 a2 0a 00 00       	call   800de3 <sys_getenvid>
  800341:	83 ec 0c             	sub    $0xc,%esp
  800344:	ff 75 0c             	pushl  0xc(%ebp)
  800347:	ff 75 08             	pushl  0x8(%ebp)
  80034a:	56                   	push   %esi
  80034b:	50                   	push   %eax
  80034c:	68 70 25 80 00       	push   $0x802570
  800351:	e8 b3 00 00 00       	call   800409 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800356:	83 c4 18             	add    $0x18,%esp
  800359:	53                   	push   %ebx
  80035a:	ff 75 10             	pushl  0x10(%ebp)
  80035d:	e8 56 00 00 00       	call   8003b8 <vcprintf>
	cprintf("\n");
  800362:	c7 04 24 60 24 80 00 	movl   $0x802460,(%esp)
  800369:	e8 9b 00 00 00       	call   800409 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800371:	cc                   	int3   
  800372:	eb fd                	jmp    800371 <_panic+0x43>

00800374 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	53                   	push   %ebx
  800378:	83 ec 04             	sub    $0x4,%esp
  80037b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80037e:	8b 13                	mov    (%ebx),%edx
  800380:	8d 42 01             	lea    0x1(%edx),%eax
  800383:	89 03                	mov    %eax,(%ebx)
  800385:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800388:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80038c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800391:	74 09                	je     80039c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800393:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80039a:	c9                   	leave  
  80039b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80039c:	83 ec 08             	sub    $0x8,%esp
  80039f:	68 ff 00 00 00       	push   $0xff
  8003a4:	8d 43 08             	lea    0x8(%ebx),%eax
  8003a7:	50                   	push   %eax
  8003a8:	e8 b8 09 00 00       	call   800d65 <sys_cputs>
		b->idx = 0;
  8003ad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003b3:	83 c4 10             	add    $0x10,%esp
  8003b6:	eb db                	jmp    800393 <putch+0x1f>

008003b8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003c8:	00 00 00 
	b.cnt = 0;
  8003cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003d2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003d5:	ff 75 0c             	pushl  0xc(%ebp)
  8003d8:	ff 75 08             	pushl  0x8(%ebp)
  8003db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e1:	50                   	push   %eax
  8003e2:	68 74 03 80 00       	push   $0x800374
  8003e7:	e8 1a 01 00 00       	call   800506 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003ec:	83 c4 08             	add    $0x8,%esp
  8003ef:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003f5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003fb:	50                   	push   %eax
  8003fc:	e8 64 09 00 00       	call   800d65 <sys_cputs>

	return b.cnt;
}
  800401:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80040f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800412:	50                   	push   %eax
  800413:	ff 75 08             	pushl  0x8(%ebp)
  800416:	e8 9d ff ff ff       	call   8003b8 <vcprintf>
	va_end(ap);

	return cnt;
}
  80041b:	c9                   	leave  
  80041c:	c3                   	ret    

0080041d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80041d:	55                   	push   %ebp
  80041e:	89 e5                	mov    %esp,%ebp
  800420:	57                   	push   %edi
  800421:	56                   	push   %esi
  800422:	53                   	push   %ebx
  800423:	83 ec 1c             	sub    $0x1c,%esp
  800426:	89 c7                	mov    %eax,%edi
  800428:	89 d6                	mov    %edx,%esi
  80042a:	8b 45 08             	mov    0x8(%ebp),%eax
  80042d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800430:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800433:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800436:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800439:	bb 00 00 00 00       	mov    $0x0,%ebx
  80043e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800441:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800444:	39 d3                	cmp    %edx,%ebx
  800446:	72 05                	jb     80044d <printnum+0x30>
  800448:	39 45 10             	cmp    %eax,0x10(%ebp)
  80044b:	77 7a                	ja     8004c7 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80044d:	83 ec 0c             	sub    $0xc,%esp
  800450:	ff 75 18             	pushl  0x18(%ebp)
  800453:	8b 45 14             	mov    0x14(%ebp),%eax
  800456:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800459:	53                   	push   %ebx
  80045a:	ff 75 10             	pushl  0x10(%ebp)
  80045d:	83 ec 08             	sub    $0x8,%esp
  800460:	ff 75 e4             	pushl  -0x1c(%ebp)
  800463:	ff 75 e0             	pushl  -0x20(%ebp)
  800466:	ff 75 dc             	pushl  -0x24(%ebp)
  800469:	ff 75 d8             	pushl  -0x28(%ebp)
  80046c:	e8 5f 1d 00 00       	call   8021d0 <__udivdi3>
  800471:	83 c4 18             	add    $0x18,%esp
  800474:	52                   	push   %edx
  800475:	50                   	push   %eax
  800476:	89 f2                	mov    %esi,%edx
  800478:	89 f8                	mov    %edi,%eax
  80047a:	e8 9e ff ff ff       	call   80041d <printnum>
  80047f:	83 c4 20             	add    $0x20,%esp
  800482:	eb 13                	jmp    800497 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	56                   	push   %esi
  800488:	ff 75 18             	pushl  0x18(%ebp)
  80048b:	ff d7                	call   *%edi
  80048d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800490:	83 eb 01             	sub    $0x1,%ebx
  800493:	85 db                	test   %ebx,%ebx
  800495:	7f ed                	jg     800484 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800497:	83 ec 08             	sub    $0x8,%esp
  80049a:	56                   	push   %esi
  80049b:	83 ec 04             	sub    $0x4,%esp
  80049e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8004a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8004aa:	e8 41 1e 00 00       	call   8022f0 <__umoddi3>
  8004af:	83 c4 14             	add    $0x14,%esp
  8004b2:	0f be 80 93 25 80 00 	movsbl 0x802593(%eax),%eax
  8004b9:	50                   	push   %eax
  8004ba:	ff d7                	call   *%edi
}
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004c2:	5b                   	pop    %ebx
  8004c3:	5e                   	pop    %esi
  8004c4:	5f                   	pop    %edi
  8004c5:	5d                   	pop    %ebp
  8004c6:	c3                   	ret    
  8004c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004ca:	eb c4                	jmp    800490 <printnum+0x73>

008004cc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004d2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004d6:	8b 10                	mov    (%eax),%edx
  8004d8:	3b 50 04             	cmp    0x4(%eax),%edx
  8004db:	73 0a                	jae    8004e7 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004dd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004e0:	89 08                	mov    %ecx,(%eax)
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	88 02                	mov    %al,(%edx)
}
  8004e7:	5d                   	pop    %ebp
  8004e8:	c3                   	ret    

008004e9 <printfmt>:
{
  8004e9:	55                   	push   %ebp
  8004ea:	89 e5                	mov    %esp,%ebp
  8004ec:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004ef:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004f2:	50                   	push   %eax
  8004f3:	ff 75 10             	pushl  0x10(%ebp)
  8004f6:	ff 75 0c             	pushl  0xc(%ebp)
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	e8 05 00 00 00       	call   800506 <vprintfmt>
}
  800501:	83 c4 10             	add    $0x10,%esp
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <vprintfmt>:
{
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	57                   	push   %edi
  80050a:	56                   	push   %esi
  80050b:	53                   	push   %ebx
  80050c:	83 ec 2c             	sub    $0x2c,%esp
  80050f:	8b 75 08             	mov    0x8(%ebp),%esi
  800512:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800515:	8b 7d 10             	mov    0x10(%ebp),%edi
  800518:	e9 c1 03 00 00       	jmp    8008de <vprintfmt+0x3d8>
		padc = ' ';
  80051d:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800521:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800528:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80052f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800536:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80053b:	8d 47 01             	lea    0x1(%edi),%eax
  80053e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800541:	0f b6 17             	movzbl (%edi),%edx
  800544:	8d 42 dd             	lea    -0x23(%edx),%eax
  800547:	3c 55                	cmp    $0x55,%al
  800549:	0f 87 12 04 00 00    	ja     800961 <vprintfmt+0x45b>
  80054f:	0f b6 c0             	movzbl %al,%eax
  800552:	ff 24 85 e0 26 80 00 	jmp    *0x8026e0(,%eax,4)
  800559:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80055c:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800560:	eb d9                	jmp    80053b <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800562:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800565:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800569:	eb d0                	jmp    80053b <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80056b:	0f b6 d2             	movzbl %dl,%edx
  80056e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800571:	b8 00 00 00 00       	mov    $0x0,%eax
  800576:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800579:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80057c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800580:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800583:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800586:	83 f9 09             	cmp    $0x9,%ecx
  800589:	77 55                	ja     8005e0 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80058b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80058e:	eb e9                	jmp    800579 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	8b 00                	mov    (%eax),%eax
  800595:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8d 40 04             	lea    0x4(%eax),%eax
  80059e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a8:	79 91                	jns    80053b <vprintfmt+0x35>
				width = precision, precision = -1;
  8005aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b0:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005b7:	eb 82                	jmp    80053b <vprintfmt+0x35>
  8005b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005bc:	85 c0                	test   %eax,%eax
  8005be:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c3:	0f 49 d0             	cmovns %eax,%edx
  8005c6:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005cc:	e9 6a ff ff ff       	jmp    80053b <vprintfmt+0x35>
  8005d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005d4:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005db:	e9 5b ff ff ff       	jmp    80053b <vprintfmt+0x35>
  8005e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005e6:	eb bc                	jmp    8005a4 <vprintfmt+0x9e>
			lflag++;
  8005e8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005ee:	e9 48 ff ff ff       	jmp    80053b <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8d 78 04             	lea    0x4(%eax),%edi
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	53                   	push   %ebx
  8005fd:	ff 30                	pushl  (%eax)
  8005ff:	ff d6                	call   *%esi
			break;
  800601:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800604:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800607:	e9 cf 02 00 00       	jmp    8008db <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8d 78 04             	lea    0x4(%eax),%edi
  800612:	8b 00                	mov    (%eax),%eax
  800614:	99                   	cltd   
  800615:	31 d0                	xor    %edx,%eax
  800617:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800619:	83 f8 0f             	cmp    $0xf,%eax
  80061c:	7f 23                	jg     800641 <vprintfmt+0x13b>
  80061e:	8b 14 85 40 28 80 00 	mov    0x802840(,%eax,4),%edx
  800625:	85 d2                	test   %edx,%edx
  800627:	74 18                	je     800641 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800629:	52                   	push   %edx
  80062a:	68 15 2a 80 00       	push   $0x802a15
  80062f:	53                   	push   %ebx
  800630:	56                   	push   %esi
  800631:	e8 b3 fe ff ff       	call   8004e9 <printfmt>
  800636:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800639:	89 7d 14             	mov    %edi,0x14(%ebp)
  80063c:	e9 9a 02 00 00       	jmp    8008db <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800641:	50                   	push   %eax
  800642:	68 ab 25 80 00       	push   $0x8025ab
  800647:	53                   	push   %ebx
  800648:	56                   	push   %esi
  800649:	e8 9b fe ff ff       	call   8004e9 <printfmt>
  80064e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800651:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800654:	e9 82 02 00 00       	jmp    8008db <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	83 c0 04             	add    $0x4,%eax
  80065f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800667:	85 ff                	test   %edi,%edi
  800669:	b8 a4 25 80 00       	mov    $0x8025a4,%eax
  80066e:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800671:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800675:	0f 8e bd 00 00 00    	jle    800738 <vprintfmt+0x232>
  80067b:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80067f:	75 0e                	jne    80068f <vprintfmt+0x189>
  800681:	89 75 08             	mov    %esi,0x8(%ebp)
  800684:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800687:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80068a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80068d:	eb 6d                	jmp    8006fc <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	ff 75 d0             	pushl  -0x30(%ebp)
  800695:	57                   	push   %edi
  800696:	e8 6e 03 00 00       	call   800a09 <strnlen>
  80069b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80069e:	29 c1                	sub    %eax,%ecx
  8006a0:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8006a3:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006a6:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006ad:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006b0:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b2:	eb 0f                	jmp    8006c3 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8006bb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006bd:	83 ef 01             	sub    $0x1,%edi
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	85 ff                	test   %edi,%edi
  8006c5:	7f ed                	jg     8006b4 <vprintfmt+0x1ae>
  8006c7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006ca:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006cd:	85 c9                	test   %ecx,%ecx
  8006cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d4:	0f 49 c1             	cmovns %ecx,%eax
  8006d7:	29 c1                	sub    %eax,%ecx
  8006d9:	89 75 08             	mov    %esi,0x8(%ebp)
  8006dc:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006df:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006e2:	89 cb                	mov    %ecx,%ebx
  8006e4:	eb 16                	jmp    8006fc <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006e6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006ea:	75 31                	jne    80071d <vprintfmt+0x217>
					putch(ch, putdat);
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	ff 75 0c             	pushl  0xc(%ebp)
  8006f2:	50                   	push   %eax
  8006f3:	ff 55 08             	call   *0x8(%ebp)
  8006f6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f9:	83 eb 01             	sub    $0x1,%ebx
  8006fc:	83 c7 01             	add    $0x1,%edi
  8006ff:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800703:	0f be c2             	movsbl %dl,%eax
  800706:	85 c0                	test   %eax,%eax
  800708:	74 59                	je     800763 <vprintfmt+0x25d>
  80070a:	85 f6                	test   %esi,%esi
  80070c:	78 d8                	js     8006e6 <vprintfmt+0x1e0>
  80070e:	83 ee 01             	sub    $0x1,%esi
  800711:	79 d3                	jns    8006e6 <vprintfmt+0x1e0>
  800713:	89 df                	mov    %ebx,%edi
  800715:	8b 75 08             	mov    0x8(%ebp),%esi
  800718:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80071b:	eb 37                	jmp    800754 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80071d:	0f be d2             	movsbl %dl,%edx
  800720:	83 ea 20             	sub    $0x20,%edx
  800723:	83 fa 5e             	cmp    $0x5e,%edx
  800726:	76 c4                	jbe    8006ec <vprintfmt+0x1e6>
					putch('?', putdat);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	ff 75 0c             	pushl  0xc(%ebp)
  80072e:	6a 3f                	push   $0x3f
  800730:	ff 55 08             	call   *0x8(%ebp)
  800733:	83 c4 10             	add    $0x10,%esp
  800736:	eb c1                	jmp    8006f9 <vprintfmt+0x1f3>
  800738:	89 75 08             	mov    %esi,0x8(%ebp)
  80073b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80073e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800741:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800744:	eb b6                	jmp    8006fc <vprintfmt+0x1f6>
				putch(' ', putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	53                   	push   %ebx
  80074a:	6a 20                	push   $0x20
  80074c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80074e:	83 ef 01             	sub    $0x1,%edi
  800751:	83 c4 10             	add    $0x10,%esp
  800754:	85 ff                	test   %edi,%edi
  800756:	7f ee                	jg     800746 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800758:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80075b:	89 45 14             	mov    %eax,0x14(%ebp)
  80075e:	e9 78 01 00 00       	jmp    8008db <vprintfmt+0x3d5>
  800763:	89 df                	mov    %ebx,%edi
  800765:	8b 75 08             	mov    0x8(%ebp),%esi
  800768:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80076b:	eb e7                	jmp    800754 <vprintfmt+0x24e>
	if (lflag >= 2)
  80076d:	83 f9 01             	cmp    $0x1,%ecx
  800770:	7e 3f                	jle    8007b1 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8b 50 04             	mov    0x4(%eax),%edx
  800778:	8b 00                	mov    (%eax),%eax
  80077a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8d 40 08             	lea    0x8(%eax),%eax
  800786:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800789:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80078d:	79 5c                	jns    8007eb <vprintfmt+0x2e5>
				putch('-', putdat);
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	53                   	push   %ebx
  800793:	6a 2d                	push   $0x2d
  800795:	ff d6                	call   *%esi
				num = -(long long) num;
  800797:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80079a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80079d:	f7 da                	neg    %edx
  80079f:	83 d1 00             	adc    $0x0,%ecx
  8007a2:	f7 d9                	neg    %ecx
  8007a4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ac:	e9 10 01 00 00       	jmp    8008c1 <vprintfmt+0x3bb>
	else if (lflag)
  8007b1:	85 c9                	test   %ecx,%ecx
  8007b3:	75 1b                	jne    8007d0 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bd:	89 c1                	mov    %eax,%ecx
  8007bf:	c1 f9 1f             	sar    $0x1f,%ecx
  8007c2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8d 40 04             	lea    0x4(%eax),%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ce:	eb b9                	jmp    800789 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d8:	89 c1                	mov    %eax,%ecx
  8007da:	c1 f9 1f             	sar    $0x1f,%ecx
  8007dd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8d 40 04             	lea    0x4(%eax),%eax
  8007e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e9:	eb 9e                	jmp    800789 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007eb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007ee:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f6:	e9 c6 00 00 00       	jmp    8008c1 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8007fb:	83 f9 01             	cmp    $0x1,%ecx
  8007fe:	7e 18                	jle    800818 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8b 10                	mov    (%eax),%edx
  800805:	8b 48 04             	mov    0x4(%eax),%ecx
  800808:	8d 40 08             	lea    0x8(%eax),%eax
  80080b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80080e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800813:	e9 a9 00 00 00       	jmp    8008c1 <vprintfmt+0x3bb>
	else if (lflag)
  800818:	85 c9                	test   %ecx,%ecx
  80081a:	75 1a                	jne    800836 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8b 10                	mov    (%eax),%edx
  800821:	b9 00 00 00 00       	mov    $0x0,%ecx
  800826:	8d 40 04             	lea    0x4(%eax),%eax
  800829:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80082c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800831:	e9 8b 00 00 00       	jmp    8008c1 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8b 10                	mov    (%eax),%edx
  80083b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800840:	8d 40 04             	lea    0x4(%eax),%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800846:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084b:	eb 74                	jmp    8008c1 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80084d:	83 f9 01             	cmp    $0x1,%ecx
  800850:	7e 15                	jle    800867 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	8b 10                	mov    (%eax),%edx
  800857:	8b 48 04             	mov    0x4(%eax),%ecx
  80085a:	8d 40 08             	lea    0x8(%eax),%eax
  80085d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800860:	b8 08 00 00 00       	mov    $0x8,%eax
  800865:	eb 5a                	jmp    8008c1 <vprintfmt+0x3bb>
	else if (lflag)
  800867:	85 c9                	test   %ecx,%ecx
  800869:	75 17                	jne    800882 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8b 10                	mov    (%eax),%edx
  800870:	b9 00 00 00 00       	mov    $0x0,%ecx
  800875:	8d 40 04             	lea    0x4(%eax),%eax
  800878:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80087b:	b8 08 00 00 00       	mov    $0x8,%eax
  800880:	eb 3f                	jmp    8008c1 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800882:	8b 45 14             	mov    0x14(%ebp),%eax
  800885:	8b 10                	mov    (%eax),%edx
  800887:	b9 00 00 00 00       	mov    $0x0,%ecx
  80088c:	8d 40 04             	lea    0x4(%eax),%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800892:	b8 08 00 00 00       	mov    $0x8,%eax
  800897:	eb 28                	jmp    8008c1 <vprintfmt+0x3bb>
			putch('0', putdat);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	53                   	push   %ebx
  80089d:	6a 30                	push   $0x30
  80089f:	ff d6                	call   *%esi
			putch('x', putdat);
  8008a1:	83 c4 08             	add    $0x8,%esp
  8008a4:	53                   	push   %ebx
  8008a5:	6a 78                	push   $0x78
  8008a7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	8b 10                	mov    (%eax),%edx
  8008ae:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008b3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008b6:	8d 40 04             	lea    0x4(%eax),%eax
  8008b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008bc:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008c1:	83 ec 0c             	sub    $0xc,%esp
  8008c4:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008c8:	57                   	push   %edi
  8008c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8008cc:	50                   	push   %eax
  8008cd:	51                   	push   %ecx
  8008ce:	52                   	push   %edx
  8008cf:	89 da                	mov    %ebx,%edx
  8008d1:	89 f0                	mov    %esi,%eax
  8008d3:	e8 45 fb ff ff       	call   80041d <printnum>
			break;
  8008d8:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  8008de:	83 c7 01             	add    $0x1,%edi
  8008e1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008e5:	83 f8 25             	cmp    $0x25,%eax
  8008e8:	0f 84 2f fc ff ff    	je     80051d <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  8008ee:	85 c0                	test   %eax,%eax
  8008f0:	0f 84 8b 00 00 00    	je     800981 <vprintfmt+0x47b>
			putch(ch, putdat);
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	53                   	push   %ebx
  8008fa:	50                   	push   %eax
  8008fb:	ff d6                	call   *%esi
  8008fd:	83 c4 10             	add    $0x10,%esp
  800900:	eb dc                	jmp    8008de <vprintfmt+0x3d8>
	if (lflag >= 2)
  800902:	83 f9 01             	cmp    $0x1,%ecx
  800905:	7e 15                	jle    80091c <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	8b 10                	mov    (%eax),%edx
  80090c:	8b 48 04             	mov    0x4(%eax),%ecx
  80090f:	8d 40 08             	lea    0x8(%eax),%eax
  800912:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800915:	b8 10 00 00 00       	mov    $0x10,%eax
  80091a:	eb a5                	jmp    8008c1 <vprintfmt+0x3bb>
	else if (lflag)
  80091c:	85 c9                	test   %ecx,%ecx
  80091e:	75 17                	jne    800937 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	8b 10                	mov    (%eax),%edx
  800925:	b9 00 00 00 00       	mov    $0x0,%ecx
  80092a:	8d 40 04             	lea    0x4(%eax),%eax
  80092d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800930:	b8 10 00 00 00       	mov    $0x10,%eax
  800935:	eb 8a                	jmp    8008c1 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	8b 10                	mov    (%eax),%edx
  80093c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800941:	8d 40 04             	lea    0x4(%eax),%eax
  800944:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800947:	b8 10 00 00 00       	mov    $0x10,%eax
  80094c:	e9 70 ff ff ff       	jmp    8008c1 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	53                   	push   %ebx
  800955:	6a 25                	push   $0x25
  800957:	ff d6                	call   *%esi
			break;
  800959:	83 c4 10             	add    $0x10,%esp
  80095c:	e9 7a ff ff ff       	jmp    8008db <vprintfmt+0x3d5>
			putch('%', putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	53                   	push   %ebx
  800965:	6a 25                	push   $0x25
  800967:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800969:	83 c4 10             	add    $0x10,%esp
  80096c:	89 f8                	mov    %edi,%eax
  80096e:	eb 03                	jmp    800973 <vprintfmt+0x46d>
  800970:	83 e8 01             	sub    $0x1,%eax
  800973:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800977:	75 f7                	jne    800970 <vprintfmt+0x46a>
  800979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097c:	e9 5a ff ff ff       	jmp    8008db <vprintfmt+0x3d5>
}
  800981:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800984:	5b                   	pop    %ebx
  800985:	5e                   	pop    %esi
  800986:	5f                   	pop    %edi
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    

00800989 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	83 ec 18             	sub    $0x18,%esp
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800995:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800998:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80099c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80099f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a6:	85 c0                	test   %eax,%eax
  8009a8:	74 26                	je     8009d0 <vsnprintf+0x47>
  8009aa:	85 d2                	test   %edx,%edx
  8009ac:	7e 22                	jle    8009d0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ae:	ff 75 14             	pushl  0x14(%ebp)
  8009b1:	ff 75 10             	pushl  0x10(%ebp)
  8009b4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b7:	50                   	push   %eax
  8009b8:	68 cc 04 80 00       	push   $0x8004cc
  8009bd:	e8 44 fb ff ff       	call   800506 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009cb:	83 c4 10             	add    $0x10,%esp
}
  8009ce:	c9                   	leave  
  8009cf:	c3                   	ret    
		return -E_INVAL;
  8009d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d5:	eb f7                	jmp    8009ce <vsnprintf+0x45>

008009d7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009dd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e0:	50                   	push   %eax
  8009e1:	ff 75 10             	pushl  0x10(%ebp)
  8009e4:	ff 75 0c             	pushl  0xc(%ebp)
  8009e7:	ff 75 08             	pushl  0x8(%ebp)
  8009ea:	e8 9a ff ff ff       	call   800989 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ef:	c9                   	leave  
  8009f0:	c3                   	ret    

008009f1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fc:	eb 03                	jmp    800a01 <strlen+0x10>
		n++;
  8009fe:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a01:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a05:	75 f7                	jne    8009fe <strlen+0xd>
	return n;
}
  800a07:	5d                   	pop    %ebp
  800a08:	c3                   	ret    

00800a09 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a12:	b8 00 00 00 00       	mov    $0x0,%eax
  800a17:	eb 03                	jmp    800a1c <strnlen+0x13>
		n++;
  800a19:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a1c:	39 d0                	cmp    %edx,%eax
  800a1e:	74 06                	je     800a26 <strnlen+0x1d>
  800a20:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a24:	75 f3                	jne    800a19 <strnlen+0x10>
	return n;
}
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	53                   	push   %ebx
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a32:	89 c2                	mov    %eax,%edx
  800a34:	83 c1 01             	add    $0x1,%ecx
  800a37:	83 c2 01             	add    $0x1,%edx
  800a3a:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a3e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a41:	84 db                	test   %bl,%bl
  800a43:	75 ef                	jne    800a34 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a45:	5b                   	pop    %ebx
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    

00800a48 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	53                   	push   %ebx
  800a4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a4f:	53                   	push   %ebx
  800a50:	e8 9c ff ff ff       	call   8009f1 <strlen>
  800a55:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	01 d8                	add    %ebx,%eax
  800a5d:	50                   	push   %eax
  800a5e:	e8 c5 ff ff ff       	call   800a28 <strcpy>
	return dst;
}
  800a63:	89 d8                	mov    %ebx,%eax
  800a65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	56                   	push   %esi
  800a6e:	53                   	push   %ebx
  800a6f:	8b 75 08             	mov    0x8(%ebp),%esi
  800a72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a75:	89 f3                	mov    %esi,%ebx
  800a77:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a7a:	89 f2                	mov    %esi,%edx
  800a7c:	eb 0f                	jmp    800a8d <strncpy+0x23>
		*dst++ = *src;
  800a7e:	83 c2 01             	add    $0x1,%edx
  800a81:	0f b6 01             	movzbl (%ecx),%eax
  800a84:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a87:	80 39 01             	cmpb   $0x1,(%ecx)
  800a8a:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a8d:	39 da                	cmp    %ebx,%edx
  800a8f:	75 ed                	jne    800a7e <strncpy+0x14>
	}
	return ret;
}
  800a91:	89 f0                	mov    %esi,%eax
  800a93:	5b                   	pop    %ebx
  800a94:	5e                   	pop    %esi
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	56                   	push   %esi
  800a9b:	53                   	push   %ebx
  800a9c:	8b 75 08             	mov    0x8(%ebp),%esi
  800a9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800aa5:	89 f0                	mov    %esi,%eax
  800aa7:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800aab:	85 c9                	test   %ecx,%ecx
  800aad:	75 0b                	jne    800aba <strlcpy+0x23>
  800aaf:	eb 17                	jmp    800ac8 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ab1:	83 c2 01             	add    $0x1,%edx
  800ab4:	83 c0 01             	add    $0x1,%eax
  800ab7:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800aba:	39 d8                	cmp    %ebx,%eax
  800abc:	74 07                	je     800ac5 <strlcpy+0x2e>
  800abe:	0f b6 0a             	movzbl (%edx),%ecx
  800ac1:	84 c9                	test   %cl,%cl
  800ac3:	75 ec                	jne    800ab1 <strlcpy+0x1a>
		*dst = '\0';
  800ac5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ac8:	29 f0                	sub    %esi,%eax
}
  800aca:	5b                   	pop    %ebx
  800acb:	5e                   	pop    %esi
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    

00800ace <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ad7:	eb 06                	jmp    800adf <strcmp+0x11>
		p++, q++;
  800ad9:	83 c1 01             	add    $0x1,%ecx
  800adc:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800adf:	0f b6 01             	movzbl (%ecx),%eax
  800ae2:	84 c0                	test   %al,%al
  800ae4:	74 04                	je     800aea <strcmp+0x1c>
  800ae6:	3a 02                	cmp    (%edx),%al
  800ae8:	74 ef                	je     800ad9 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aea:	0f b6 c0             	movzbl %al,%eax
  800aed:	0f b6 12             	movzbl (%edx),%edx
  800af0:	29 d0                	sub    %edx,%eax
}
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	53                   	push   %ebx
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afe:	89 c3                	mov    %eax,%ebx
  800b00:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b03:	eb 06                	jmp    800b0b <strncmp+0x17>
		n--, p++, q++;
  800b05:	83 c0 01             	add    $0x1,%eax
  800b08:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b0b:	39 d8                	cmp    %ebx,%eax
  800b0d:	74 16                	je     800b25 <strncmp+0x31>
  800b0f:	0f b6 08             	movzbl (%eax),%ecx
  800b12:	84 c9                	test   %cl,%cl
  800b14:	74 04                	je     800b1a <strncmp+0x26>
  800b16:	3a 0a                	cmp    (%edx),%cl
  800b18:	74 eb                	je     800b05 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b1a:	0f b6 00             	movzbl (%eax),%eax
  800b1d:	0f b6 12             	movzbl (%edx),%edx
  800b20:	29 d0                	sub    %edx,%eax
}
  800b22:	5b                   	pop    %ebx
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    
		return 0;
  800b25:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2a:	eb f6                	jmp    800b22 <strncmp+0x2e>

00800b2c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b36:	0f b6 10             	movzbl (%eax),%edx
  800b39:	84 d2                	test   %dl,%dl
  800b3b:	74 09                	je     800b46 <strchr+0x1a>
		if (*s == c)
  800b3d:	38 ca                	cmp    %cl,%dl
  800b3f:	74 0a                	je     800b4b <strchr+0x1f>
	for (; *s; s++)
  800b41:	83 c0 01             	add    $0x1,%eax
  800b44:	eb f0                	jmp    800b36 <strchr+0xa>
			return (char *) s;
	return 0;
  800b46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b57:	eb 03                	jmp    800b5c <strfind+0xf>
  800b59:	83 c0 01             	add    $0x1,%eax
  800b5c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b5f:	38 ca                	cmp    %cl,%dl
  800b61:	74 04                	je     800b67 <strfind+0x1a>
  800b63:	84 d2                	test   %dl,%dl
  800b65:	75 f2                	jne    800b59 <strfind+0xc>
			break;
	return (char *) s;
}
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	57                   	push   %edi
  800b6d:	56                   	push   %esi
  800b6e:	53                   	push   %ebx
  800b6f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b72:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b75:	85 c9                	test   %ecx,%ecx
  800b77:	74 13                	je     800b8c <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b79:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b7f:	75 05                	jne    800b86 <memset+0x1d>
  800b81:	f6 c1 03             	test   $0x3,%cl
  800b84:	74 0d                	je     800b93 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b89:	fc                   	cld    
  800b8a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b8c:	89 f8                	mov    %edi,%eax
  800b8e:	5b                   	pop    %ebx
  800b8f:	5e                   	pop    %esi
  800b90:	5f                   	pop    %edi
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    
		c &= 0xFF;
  800b93:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b97:	89 d3                	mov    %edx,%ebx
  800b99:	c1 e3 08             	shl    $0x8,%ebx
  800b9c:	89 d0                	mov    %edx,%eax
  800b9e:	c1 e0 18             	shl    $0x18,%eax
  800ba1:	89 d6                	mov    %edx,%esi
  800ba3:	c1 e6 10             	shl    $0x10,%esi
  800ba6:	09 f0                	or     %esi,%eax
  800ba8:	09 c2                	or     %eax,%edx
  800baa:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800bac:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800baf:	89 d0                	mov    %edx,%eax
  800bb1:	fc                   	cld    
  800bb2:	f3 ab                	rep stos %eax,%es:(%edi)
  800bb4:	eb d6                	jmp    800b8c <memset+0x23>

00800bb6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	57                   	push   %edi
  800bba:	56                   	push   %esi
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bc4:	39 c6                	cmp    %eax,%esi
  800bc6:	73 35                	jae    800bfd <memmove+0x47>
  800bc8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bcb:	39 c2                	cmp    %eax,%edx
  800bcd:	76 2e                	jbe    800bfd <memmove+0x47>
		s += n;
		d += n;
  800bcf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd2:	89 d6                	mov    %edx,%esi
  800bd4:	09 fe                	or     %edi,%esi
  800bd6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bdc:	74 0c                	je     800bea <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bde:	83 ef 01             	sub    $0x1,%edi
  800be1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800be4:	fd                   	std    
  800be5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be7:	fc                   	cld    
  800be8:	eb 21                	jmp    800c0b <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bea:	f6 c1 03             	test   $0x3,%cl
  800bed:	75 ef                	jne    800bde <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bef:	83 ef 04             	sub    $0x4,%edi
  800bf2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bf5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bf8:	fd                   	std    
  800bf9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bfb:	eb ea                	jmp    800be7 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfd:	89 f2                	mov    %esi,%edx
  800bff:	09 c2                	or     %eax,%edx
  800c01:	f6 c2 03             	test   $0x3,%dl
  800c04:	74 09                	je     800c0f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c06:	89 c7                	mov    %eax,%edi
  800c08:	fc                   	cld    
  800c09:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c0b:	5e                   	pop    %esi
  800c0c:	5f                   	pop    %edi
  800c0d:	5d                   	pop    %ebp
  800c0e:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0f:	f6 c1 03             	test   $0x3,%cl
  800c12:	75 f2                	jne    800c06 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c14:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c17:	89 c7                	mov    %eax,%edi
  800c19:	fc                   	cld    
  800c1a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1c:	eb ed                	jmp    800c0b <memmove+0x55>

00800c1e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c21:	ff 75 10             	pushl  0x10(%ebp)
  800c24:	ff 75 0c             	pushl  0xc(%ebp)
  800c27:	ff 75 08             	pushl  0x8(%ebp)
  800c2a:	e8 87 ff ff ff       	call   800bb6 <memmove>
}
  800c2f:	c9                   	leave  
  800c30:	c3                   	ret    

00800c31 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	56                   	push   %esi
  800c35:	53                   	push   %ebx
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3c:	89 c6                	mov    %eax,%esi
  800c3e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c41:	39 f0                	cmp    %esi,%eax
  800c43:	74 1c                	je     800c61 <memcmp+0x30>
		if (*s1 != *s2)
  800c45:	0f b6 08             	movzbl (%eax),%ecx
  800c48:	0f b6 1a             	movzbl (%edx),%ebx
  800c4b:	38 d9                	cmp    %bl,%cl
  800c4d:	75 08                	jne    800c57 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c4f:	83 c0 01             	add    $0x1,%eax
  800c52:	83 c2 01             	add    $0x1,%edx
  800c55:	eb ea                	jmp    800c41 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c57:	0f b6 c1             	movzbl %cl,%eax
  800c5a:	0f b6 db             	movzbl %bl,%ebx
  800c5d:	29 d8                	sub    %ebx,%eax
  800c5f:	eb 05                	jmp    800c66 <memcmp+0x35>
	}

	return 0;
  800c61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c66:	5b                   	pop    %ebx
  800c67:	5e                   	pop    %esi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c73:	89 c2                	mov    %eax,%edx
  800c75:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c78:	39 d0                	cmp    %edx,%eax
  800c7a:	73 09                	jae    800c85 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c7c:	38 08                	cmp    %cl,(%eax)
  800c7e:	74 05                	je     800c85 <memfind+0x1b>
	for (; s < ends; s++)
  800c80:	83 c0 01             	add    $0x1,%eax
  800c83:	eb f3                	jmp    800c78 <memfind+0xe>
			break;
	return (void *) s;
}
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c90:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c93:	eb 03                	jmp    800c98 <strtol+0x11>
		s++;
  800c95:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c98:	0f b6 01             	movzbl (%ecx),%eax
  800c9b:	3c 20                	cmp    $0x20,%al
  800c9d:	74 f6                	je     800c95 <strtol+0xe>
  800c9f:	3c 09                	cmp    $0x9,%al
  800ca1:	74 f2                	je     800c95 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ca3:	3c 2b                	cmp    $0x2b,%al
  800ca5:	74 2e                	je     800cd5 <strtol+0x4e>
	int neg = 0;
  800ca7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cac:	3c 2d                	cmp    $0x2d,%al
  800cae:	74 2f                	je     800cdf <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cb6:	75 05                	jne    800cbd <strtol+0x36>
  800cb8:	80 39 30             	cmpb   $0x30,(%ecx)
  800cbb:	74 2c                	je     800ce9 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cbd:	85 db                	test   %ebx,%ebx
  800cbf:	75 0a                	jne    800ccb <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cc1:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cc6:	80 39 30             	cmpb   $0x30,(%ecx)
  800cc9:	74 28                	je     800cf3 <strtol+0x6c>
		base = 10;
  800ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cd3:	eb 50                	jmp    800d25 <strtol+0x9e>
		s++;
  800cd5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cd8:	bf 00 00 00 00       	mov    $0x0,%edi
  800cdd:	eb d1                	jmp    800cb0 <strtol+0x29>
		s++, neg = 1;
  800cdf:	83 c1 01             	add    $0x1,%ecx
  800ce2:	bf 01 00 00 00       	mov    $0x1,%edi
  800ce7:	eb c7                	jmp    800cb0 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ced:	74 0e                	je     800cfd <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800cef:	85 db                	test   %ebx,%ebx
  800cf1:	75 d8                	jne    800ccb <strtol+0x44>
		s++, base = 8;
  800cf3:	83 c1 01             	add    $0x1,%ecx
  800cf6:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cfb:	eb ce                	jmp    800ccb <strtol+0x44>
		s += 2, base = 16;
  800cfd:	83 c1 02             	add    $0x2,%ecx
  800d00:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d05:	eb c4                	jmp    800ccb <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d07:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d0a:	89 f3                	mov    %esi,%ebx
  800d0c:	80 fb 19             	cmp    $0x19,%bl
  800d0f:	77 29                	ja     800d3a <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d11:	0f be d2             	movsbl %dl,%edx
  800d14:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d17:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d1a:	7d 30                	jge    800d4c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d1c:	83 c1 01             	add    $0x1,%ecx
  800d1f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d23:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d25:	0f b6 11             	movzbl (%ecx),%edx
  800d28:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d2b:	89 f3                	mov    %esi,%ebx
  800d2d:	80 fb 09             	cmp    $0x9,%bl
  800d30:	77 d5                	ja     800d07 <strtol+0x80>
			dig = *s - '0';
  800d32:	0f be d2             	movsbl %dl,%edx
  800d35:	83 ea 30             	sub    $0x30,%edx
  800d38:	eb dd                	jmp    800d17 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d3a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d3d:	89 f3                	mov    %esi,%ebx
  800d3f:	80 fb 19             	cmp    $0x19,%bl
  800d42:	77 08                	ja     800d4c <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d44:	0f be d2             	movsbl %dl,%edx
  800d47:	83 ea 37             	sub    $0x37,%edx
  800d4a:	eb cb                	jmp    800d17 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d50:	74 05                	je     800d57 <strtol+0xd0>
		*endptr = (char *) s;
  800d52:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d55:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d57:	89 c2                	mov    %eax,%edx
  800d59:	f7 da                	neg    %edx
  800d5b:	85 ff                	test   %edi,%edi
  800d5d:	0f 45 c2             	cmovne %edx,%eax
}
  800d60:	5b                   	pop    %ebx
  800d61:	5e                   	pop    %esi
  800d62:	5f                   	pop    %edi
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	57                   	push   %edi
  800d69:	56                   	push   %esi
  800d6a:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d70:	8b 55 08             	mov    0x8(%ebp),%edx
  800d73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d76:	89 c3                	mov    %eax,%ebx
  800d78:	89 c7                	mov    %eax,%edi
  800d7a:	89 c6                	mov    %eax,%esi
  800d7c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	57                   	push   %edi
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d89:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8e:	b8 01 00 00 00       	mov    $0x1,%eax
  800d93:	89 d1                	mov    %edx,%ecx
  800d95:	89 d3                	mov    %edx,%ebx
  800d97:	89 d7                	mov    %edx,%edi
  800d99:	89 d6                	mov    %edx,%esi
  800d9b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	57                   	push   %edi
  800da6:	56                   	push   %esi
  800da7:	53                   	push   %ebx
  800da8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800dab:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	b8 03 00 00 00       	mov    $0x3,%eax
  800db8:	89 cb                	mov    %ecx,%ebx
  800dba:	89 cf                	mov    %ecx,%edi
  800dbc:	89 ce                	mov    %ecx,%esi
  800dbe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc0:	85 c0                	test   %eax,%eax
  800dc2:	7f 08                	jg     800dcc <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5f                   	pop    %edi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcc:	83 ec 0c             	sub    $0xc,%esp
  800dcf:	50                   	push   %eax
  800dd0:	6a 03                	push   $0x3
  800dd2:	68 9f 28 80 00       	push   $0x80289f
  800dd7:	6a 23                	push   $0x23
  800dd9:	68 bc 28 80 00       	push   $0x8028bc
  800dde:	e8 4b f5 ff ff       	call   80032e <_panic>

00800de3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800de9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dee:	b8 02 00 00 00       	mov    $0x2,%eax
  800df3:	89 d1                	mov    %edx,%ecx
  800df5:	89 d3                	mov    %edx,%ebx
  800df7:	89 d7                	mov    %edx,%edi
  800df9:	89 d6                	mov    %edx,%esi
  800dfb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5f                   	pop    %edi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    

00800e02 <sys_yield>:

void
sys_yield(void)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e08:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e12:	89 d1                	mov    %edx,%ecx
  800e14:	89 d3                	mov    %edx,%ebx
  800e16:	89 d7                	mov    %edx,%edi
  800e18:	89 d6                	mov    %edx,%esi
  800e1a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e1c:	5b                   	pop    %ebx
  800e1d:	5e                   	pop    %esi
  800e1e:	5f                   	pop    %edi
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	57                   	push   %edi
  800e25:	56                   	push   %esi
  800e26:	53                   	push   %ebx
  800e27:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e2a:	be 00 00 00 00       	mov    $0x0,%esi
  800e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e35:	b8 04 00 00 00       	mov    $0x4,%eax
  800e3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3d:	89 f7                	mov    %esi,%edi
  800e3f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e41:	85 c0                	test   %eax,%eax
  800e43:	7f 08                	jg     800e4d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4d:	83 ec 0c             	sub    $0xc,%esp
  800e50:	50                   	push   %eax
  800e51:	6a 04                	push   $0x4
  800e53:	68 9f 28 80 00       	push   $0x80289f
  800e58:	6a 23                	push   $0x23
  800e5a:	68 bc 28 80 00       	push   $0x8028bc
  800e5f:	e8 ca f4 ff ff       	call   80032e <_panic>

00800e64 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
  800e6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e73:	b8 05 00 00 00       	mov    $0x5,%eax
  800e78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e7e:	8b 75 18             	mov    0x18(%ebp),%esi
  800e81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e83:	85 c0                	test   %eax,%eax
  800e85:	7f 08                	jg     800e8f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8a:	5b                   	pop    %ebx
  800e8b:	5e                   	pop    %esi
  800e8c:	5f                   	pop    %edi
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8f:	83 ec 0c             	sub    $0xc,%esp
  800e92:	50                   	push   %eax
  800e93:	6a 05                	push   $0x5
  800e95:	68 9f 28 80 00       	push   $0x80289f
  800e9a:	6a 23                	push   $0x23
  800e9c:	68 bc 28 80 00       	push   $0x8028bc
  800ea1:	e8 88 f4 ff ff       	call   80032e <_panic>

00800ea6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	57                   	push   %edi
  800eaa:	56                   	push   %esi
  800eab:	53                   	push   %ebx
  800eac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800eaf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eba:	b8 06 00 00 00       	mov    $0x6,%eax
  800ebf:	89 df                	mov    %ebx,%edi
  800ec1:	89 de                	mov    %ebx,%esi
  800ec3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	7f 08                	jg     800ed1 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ec9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecc:	5b                   	pop    %ebx
  800ecd:	5e                   	pop    %esi
  800ece:	5f                   	pop    %edi
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed1:	83 ec 0c             	sub    $0xc,%esp
  800ed4:	50                   	push   %eax
  800ed5:	6a 06                	push   $0x6
  800ed7:	68 9f 28 80 00       	push   $0x80289f
  800edc:	6a 23                	push   $0x23
  800ede:	68 bc 28 80 00       	push   $0x8028bc
  800ee3:	e8 46 f4 ff ff       	call   80032e <_panic>

00800ee8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	57                   	push   %edi
  800eec:	56                   	push   %esi
  800eed:	53                   	push   %ebx
  800eee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ef1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efc:	b8 08 00 00 00       	mov    $0x8,%eax
  800f01:	89 df                	mov    %ebx,%edi
  800f03:	89 de                	mov    %ebx,%esi
  800f05:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f07:	85 c0                	test   %eax,%eax
  800f09:	7f 08                	jg     800f13 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0e:	5b                   	pop    %ebx
  800f0f:	5e                   	pop    %esi
  800f10:	5f                   	pop    %edi
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f13:	83 ec 0c             	sub    $0xc,%esp
  800f16:	50                   	push   %eax
  800f17:	6a 08                	push   $0x8
  800f19:	68 9f 28 80 00       	push   $0x80289f
  800f1e:	6a 23                	push   $0x23
  800f20:	68 bc 28 80 00       	push   $0x8028bc
  800f25:	e8 04 f4 ff ff       	call   80032e <_panic>

00800f2a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	57                   	push   %edi
  800f2e:	56                   	push   %esi
  800f2f:	53                   	push   %ebx
  800f30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800f33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f38:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f43:	89 df                	mov    %ebx,%edi
  800f45:	89 de                	mov    %ebx,%esi
  800f47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f49:	85 c0                	test   %eax,%eax
  800f4b:	7f 08                	jg     800f55 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f55:	83 ec 0c             	sub    $0xc,%esp
  800f58:	50                   	push   %eax
  800f59:	6a 09                	push   $0x9
  800f5b:	68 9f 28 80 00       	push   $0x80289f
  800f60:	6a 23                	push   $0x23
  800f62:	68 bc 28 80 00       	push   $0x8028bc
  800f67:	e8 c2 f3 ff ff       	call   80032e <_panic>

00800f6c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	57                   	push   %edi
  800f70:	56                   	push   %esi
  800f71:	53                   	push   %ebx
  800f72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800f75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f80:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f85:	89 df                	mov    %ebx,%edi
  800f87:	89 de                	mov    %ebx,%esi
  800f89:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	7f 08                	jg     800f97 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f92:	5b                   	pop    %ebx
  800f93:	5e                   	pop    %esi
  800f94:	5f                   	pop    %edi
  800f95:	5d                   	pop    %ebp
  800f96:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f97:	83 ec 0c             	sub    $0xc,%esp
  800f9a:	50                   	push   %eax
  800f9b:	6a 0a                	push   $0xa
  800f9d:	68 9f 28 80 00       	push   $0x80289f
  800fa2:	6a 23                	push   $0x23
  800fa4:	68 bc 28 80 00       	push   $0x8028bc
  800fa9:	e8 80 f3 ff ff       	call   80032e <_panic>

00800fae <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	57                   	push   %edi
  800fb2:	56                   	push   %esi
  800fb3:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fba:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fbf:	be 00 00 00 00       	mov    $0x0,%esi
  800fc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fca:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    

00800fd1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	57                   	push   %edi
  800fd5:	56                   	push   %esi
  800fd6:	53                   	push   %ebx
  800fd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800fda:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fe7:	89 cb                	mov    %ecx,%ebx
  800fe9:	89 cf                	mov    %ecx,%edi
  800feb:	89 ce                	mov    %ecx,%esi
  800fed:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	7f 08                	jg     800ffb <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff6:	5b                   	pop    %ebx
  800ff7:	5e                   	pop    %esi
  800ff8:	5f                   	pop    %edi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffb:	83 ec 0c             	sub    $0xc,%esp
  800ffe:	50                   	push   %eax
  800fff:	6a 0d                	push   $0xd
  801001:	68 9f 28 80 00       	push   $0x80289f
  801006:	6a 23                	push   $0x23
  801008:	68 bc 28 80 00       	push   $0x8028bc
  80100d:	e8 1c f3 ff ff       	call   80032e <_panic>

00801012 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	53                   	push   %ebx
  801016:	83 ec 04             	sub    $0x4,%esp
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80101c:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) { //只有因为写操作写时拷贝的地址这中情况，才可以抢救。否则一律panic
  80101e:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801022:	74 74                	je     801098 <pgfault+0x86>
  801024:	89 d8                	mov    %ebx,%eax
  801026:	c1 e8 0c             	shr    $0xc,%eax
  801029:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801030:	f6 c4 08             	test   $0x8,%ah
  801033:	74 63                	je     801098 <pgfault+0x86>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801035:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, PFTEMP, PTE_U|PTE_P)) < 0)		//将当前进程PFTEMP也映射到当前进程addr指向的物理页
  80103b:	83 ec 0c             	sub    $0xc,%esp
  80103e:	6a 05                	push   $0x5
  801040:	68 00 f0 7f 00       	push   $0x7ff000
  801045:	6a 00                	push   $0x0
  801047:	53                   	push   %ebx
  801048:	6a 00                	push   $0x0
  80104a:	e8 15 fe ff ff       	call   800e64 <sys_page_map>
  80104f:	83 c4 20             	add    $0x20,%esp
  801052:	85 c0                	test   %eax,%eax
  801054:	78 56                	js     8010ac <pgfault+0x9a>
		panic("sys_page_map: %e", r);
	if ((r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W)) < 0)	//令当前进程addr指向新分配的物理页
  801056:	83 ec 04             	sub    $0x4,%esp
  801059:	6a 07                	push   $0x7
  80105b:	53                   	push   %ebx
  80105c:	6a 00                	push   $0x0
  80105e:	e8 be fd ff ff       	call   800e21 <sys_page_alloc>
  801063:	83 c4 10             	add    $0x10,%esp
  801066:	85 c0                	test   %eax,%eax
  801068:	78 54                	js     8010be <pgfault+0xac>
		panic("sys_page_alloc: %e", r);
	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  80106a:	83 ec 04             	sub    $0x4,%esp
  80106d:	68 00 10 00 00       	push   $0x1000
  801072:	68 00 f0 7f 00       	push   $0x7ff000
  801077:	53                   	push   %ebx
  801078:	e8 39 fb ff ff       	call   800bb6 <memmove>
	if ((r = sys_page_unmap(0, PFTEMP)) < 0)					//解除当前进程PFTEMP映射
  80107d:	83 c4 08             	add    $0x8,%esp
  801080:	68 00 f0 7f 00       	push   $0x7ff000
  801085:	6a 00                	push   $0x0
  801087:	e8 1a fe ff ff       	call   800ea6 <sys_page_unmap>
  80108c:	83 c4 10             	add    $0x10,%esp
  80108f:	85 c0                	test   %eax,%eax
  801091:	78 3d                	js     8010d0 <pgfault+0xbe>
		panic("sys_page_unmap: %e", r);
}
  801093:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801096:	c9                   	leave  
  801097:	c3                   	ret    
		panic("pgfault():not cow");
  801098:	83 ec 04             	sub    $0x4,%esp
  80109b:	68 ca 28 80 00       	push   $0x8028ca
  8010a0:	6a 1d                	push   $0x1d
  8010a2:	68 dc 28 80 00       	push   $0x8028dc
  8010a7:	e8 82 f2 ff ff       	call   80032e <_panic>
		panic("sys_page_map: %e", r);
  8010ac:	50                   	push   %eax
  8010ad:	68 e7 28 80 00       	push   $0x8028e7
  8010b2:	6a 2a                	push   $0x2a
  8010b4:	68 dc 28 80 00       	push   $0x8028dc
  8010b9:	e8 70 f2 ff ff       	call   80032e <_panic>
		panic("sys_page_alloc: %e", r);
  8010be:	50                   	push   %eax
  8010bf:	68 f8 28 80 00       	push   $0x8028f8
  8010c4:	6a 2c                	push   $0x2c
  8010c6:	68 dc 28 80 00       	push   $0x8028dc
  8010cb:	e8 5e f2 ff ff       	call   80032e <_panic>
		panic("sys_page_unmap: %e", r);
  8010d0:	50                   	push   %eax
  8010d1:	68 0b 29 80 00       	push   $0x80290b
  8010d6:	6a 2f                	push   $0x2f
  8010d8:	68 dc 28 80 00       	push   $0x8028dc
  8010dd:	e8 4c f2 ff ff       	call   80032e <_panic>

008010e2 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	57                   	push   %edi
  8010e6:	56                   	push   %esi
  8010e7:	53                   	push   %ebx
  8010e8:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);	//设置缺页处理函数
  8010eb:	68 12 10 80 00       	push   $0x801012
  8010f0:	e8 2c 0f 00 00       	call   802021 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010f5:	b8 07 00 00 00       	mov    $0x7,%eax
  8010fa:	cd 30                	int    $0x30
  8010fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();	//系统调用，只是简单创建一个Env结构，复制当前用户环境寄存器状态，UTOP以下的页目录还没有建立
	if (envid == 0) {				//子进程将走这个逻辑
  8010ff:	83 c4 10             	add    $0x10,%esp
  801102:	85 c0                	test   %eax,%eax
  801104:	74 12                	je     801118 <fork+0x36>
  801106:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	if (envid < 0) {
  801108:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80110c:	78 26                	js     801134 <fork+0x52>
		panic("sys_exofork: %e", envid);
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80110e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801113:	e9 94 00 00 00       	jmp    8011ac <fork+0xca>
		thisenv = &envs[ENVX(sys_getenvid())];
  801118:	e8 c6 fc ff ff       	call   800de3 <sys_getenvid>
  80111d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801122:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801125:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80112a:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80112f:	e9 51 01 00 00       	jmp    801285 <fork+0x1a3>
		panic("sys_exofork: %e", envid);
  801134:	ff 75 e4             	pushl  -0x1c(%ebp)
  801137:	68 1e 29 80 00       	push   $0x80291e
  80113c:	6a 6d                	push   $0x6d
  80113e:	68 dc 28 80 00       	push   $0x8028dc
  801143:	e8 e6 f1 ff ff       	call   80032e <_panic>
		sys_page_map(0, addr, envid, addr, PTE_SYSCALL);		//对于表示为PTE_SHARE的页，拷贝映射关系，并且两个进程都有读写权限
  801148:	83 ec 0c             	sub    $0xc,%esp
  80114b:	68 07 0e 00 00       	push   $0xe07
  801150:	56                   	push   %esi
  801151:	57                   	push   %edi
  801152:	56                   	push   %esi
  801153:	6a 00                	push   $0x0
  801155:	e8 0a fd ff ff       	call   800e64 <sys_page_map>
  80115a:	83 c4 20             	add    $0x20,%esp
  80115d:	eb 3b                	jmp    80119a <fork+0xb8>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  80115f:	83 ec 0c             	sub    $0xc,%esp
  801162:	68 05 08 00 00       	push   $0x805
  801167:	56                   	push   %esi
  801168:	57                   	push   %edi
  801169:	56                   	push   %esi
  80116a:	6a 00                	push   $0x0
  80116c:	e8 f3 fc ff ff       	call   800e64 <sys_page_map>
  801171:	83 c4 20             	add    $0x20,%esp
  801174:	85 c0                	test   %eax,%eax
  801176:	0f 88 a9 00 00 00    	js     801225 <fork+0x143>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  80117c:	83 ec 0c             	sub    $0xc,%esp
  80117f:	68 05 08 00 00       	push   $0x805
  801184:	56                   	push   %esi
  801185:	6a 00                	push   $0x0
  801187:	56                   	push   %esi
  801188:	6a 00                	push   $0x0
  80118a:	e8 d5 fc ff ff       	call   800e64 <sys_page_map>
  80118f:	83 c4 20             	add    $0x20,%esp
  801192:	85 c0                	test   %eax,%eax
  801194:	0f 88 9d 00 00 00    	js     801237 <fork+0x155>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80119a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8011a0:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8011a6:	0f 84 9d 00 00 00    	je     801249 <fork+0x167>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) //为什么uvpt[pagenumber]能访问到第pagenumber项页表条目：https://pdos.csail.mit.edu/6.828/2018/labs/lab4/uvpt.html
  8011ac:	89 d8                	mov    %ebx,%eax
  8011ae:	c1 e8 16             	shr    $0x16,%eax
  8011b1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011b8:	a8 01                	test   $0x1,%al
  8011ba:	74 de                	je     80119a <fork+0xb8>
  8011bc:	89 d8                	mov    %ebx,%eax
  8011be:	c1 e8 0c             	shr    $0xc,%eax
  8011c1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011c8:	f6 c2 01             	test   $0x1,%dl
  8011cb:	74 cd                	je     80119a <fork+0xb8>
			&& (uvpt[PGNUM(addr)] & PTE_U)) {
  8011cd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011d4:	f6 c2 04             	test   $0x4,%dl
  8011d7:	74 c1                	je     80119a <fork+0xb8>
	void *addr = (void*) (pn * PGSIZE);
  8011d9:	89 c6                	mov    %eax,%esi
  8011db:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE) {
  8011de:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011e5:	f6 c6 04             	test   $0x4,%dh
  8011e8:	0f 85 5a ff ff ff    	jne    801148 <fork+0x66>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) { //对于UTOP以下的可写的或者写时拷贝的页，拷贝映射关系的同时，需要同时标记当前进程和子进程的页表项为PTE_COW
  8011ee:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011f5:	f6 c2 02             	test   $0x2,%dl
  8011f8:	0f 85 61 ff ff ff    	jne    80115f <fork+0x7d>
  8011fe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801205:	f6 c4 08             	test   $0x8,%ah
  801208:	0f 85 51 ff ff ff    	jne    80115f <fork+0x7d>
		sys_page_map(0, addr, envid, addr, PTE_U|PTE_P);	//对于只读的页，只需要拷贝映射关系即可
  80120e:	83 ec 0c             	sub    $0xc,%esp
  801211:	6a 05                	push   $0x5
  801213:	56                   	push   %esi
  801214:	57                   	push   %edi
  801215:	56                   	push   %esi
  801216:	6a 00                	push   $0x0
  801218:	e8 47 fc ff ff       	call   800e64 <sys_page_map>
  80121d:	83 c4 20             	add    $0x20,%esp
  801220:	e9 75 ff ff ff       	jmp    80119a <fork+0xb8>
			panic("sys_page_map：%e", r);
  801225:	50                   	push   %eax
  801226:	68 2e 29 80 00       	push   $0x80292e
  80122b:	6a 48                	push   $0x48
  80122d:	68 dc 28 80 00       	push   $0x8028dc
  801232:	e8 f7 f0 ff ff       	call   80032e <_panic>
			panic("sys_page_map：%e", r);
  801237:	50                   	push   %eax
  801238:	68 2e 29 80 00       	push   $0x80292e
  80123d:	6a 4a                	push   $0x4a
  80123f:	68 dc 28 80 00       	push   $0x8028dc
  801244:	e8 e5 f0 ff ff       	call   80032e <_panic>
			duppage(envid, PGNUM(addr));	//拷贝当前进程映射关系到子进程
		}
	}
	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_W | PTE_U)) < 0)	//为子进程分配异常栈
  801249:	83 ec 04             	sub    $0x4,%esp
  80124c:	6a 07                	push   $0x7
  80124e:	68 00 f0 bf ee       	push   $0xeebff000
  801253:	ff 75 e4             	pushl  -0x1c(%ebp)
  801256:	e8 c6 fb ff ff       	call   800e21 <sys_page_alloc>
  80125b:	83 c4 10             	add    $0x10,%esp
  80125e:	85 c0                	test   %eax,%eax
  801260:	78 2e                	js     801290 <fork+0x1ae>
		panic("sys_page_alloc: %e", r);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);		//为子进程设置_pgfault_upcall
  801262:	83 ec 08             	sub    $0x8,%esp
  801265:	68 7a 20 80 00       	push   $0x80207a
  80126a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80126d:	57                   	push   %edi
  80126e:	e8 f9 fc ff ff       	call   800f6c <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)	//设置子进程为ENV_RUNNABLE状态
  801273:	83 c4 08             	add    $0x8,%esp
  801276:	6a 02                	push   $0x2
  801278:	57                   	push   %edi
  801279:	e8 6a fc ff ff       	call   800ee8 <sys_env_set_status>
  80127e:	83 c4 10             	add    $0x10,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	78 1d                	js     8012a2 <fork+0x1c0>
		panic("sys_env_set_status: %e", r);
	return envid;
}
  801285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801288:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128b:	5b                   	pop    %ebx
  80128c:	5e                   	pop    %esi
  80128d:	5f                   	pop    %edi
  80128e:	5d                   	pop    %ebp
  80128f:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801290:	50                   	push   %eax
  801291:	68 f8 28 80 00       	push   $0x8028f8
  801296:	6a 79                	push   $0x79
  801298:	68 dc 28 80 00       	push   $0x8028dc
  80129d:	e8 8c f0 ff ff       	call   80032e <_panic>
		panic("sys_env_set_status: %e", r);
  8012a2:	50                   	push   %eax
  8012a3:	68 40 29 80 00       	push   $0x802940
  8012a8:	6a 7d                	push   $0x7d
  8012aa:	68 dc 28 80 00       	push   $0x8028dc
  8012af:	e8 7a f0 ff ff       	call   80032e <_panic>

008012b4 <sfork>:

// Challenge!
int
sfork(void)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012ba:	68 57 29 80 00       	push   $0x802957
  8012bf:	68 85 00 00 00       	push   $0x85
  8012c4:	68 dc 28 80 00       	push   $0x8028dc
  8012c9:	e8 60 f0 ff ff       	call   80032e <_panic>

008012ce <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	05 00 00 00 30       	add    $0x30000000,%eax
  8012d9:	c1 e8 0c             	shr    $0xc,%eax
}
  8012dc:	5d                   	pop    %ebp
  8012dd:	c3                   	ret    

008012de <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012ee:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012f3:	5d                   	pop    %ebp
  8012f4:	c3                   	ret    

008012f5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012fb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801300:	89 c2                	mov    %eax,%edx
  801302:	c1 ea 16             	shr    $0x16,%edx
  801305:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80130c:	f6 c2 01             	test   $0x1,%dl
  80130f:	74 2a                	je     80133b <fd_alloc+0x46>
  801311:	89 c2                	mov    %eax,%edx
  801313:	c1 ea 0c             	shr    $0xc,%edx
  801316:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80131d:	f6 c2 01             	test   $0x1,%dl
  801320:	74 19                	je     80133b <fd_alloc+0x46>
  801322:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801327:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80132c:	75 d2                	jne    801300 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80132e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801334:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801339:	eb 07                	jmp    801342 <fd_alloc+0x4d>
			*fd_store = fd;
  80133b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801342:	5d                   	pop    %ebp
  801343:	c3                   	ret    

00801344 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80134a:	83 f8 1f             	cmp    $0x1f,%eax
  80134d:	77 36                	ja     801385 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80134f:	c1 e0 0c             	shl    $0xc,%eax
  801352:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801357:	89 c2                	mov    %eax,%edx
  801359:	c1 ea 16             	shr    $0x16,%edx
  80135c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801363:	f6 c2 01             	test   $0x1,%dl
  801366:	74 24                	je     80138c <fd_lookup+0x48>
  801368:	89 c2                	mov    %eax,%edx
  80136a:	c1 ea 0c             	shr    $0xc,%edx
  80136d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801374:	f6 c2 01             	test   $0x1,%dl
  801377:	74 1a                	je     801393 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801379:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137c:	89 02                	mov    %eax,(%edx)
	return 0;
  80137e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801383:	5d                   	pop    %ebp
  801384:	c3                   	ret    
		return -E_INVAL;
  801385:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138a:	eb f7                	jmp    801383 <fd_lookup+0x3f>
		return -E_INVAL;
  80138c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801391:	eb f0                	jmp    801383 <fd_lookup+0x3f>
  801393:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801398:	eb e9                	jmp    801383 <fd_lookup+0x3f>

0080139a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	83 ec 08             	sub    $0x8,%esp
  8013a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a3:	ba ec 29 80 00       	mov    $0x8029ec,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013a8:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013ad:	39 08                	cmp    %ecx,(%eax)
  8013af:	74 33                	je     8013e4 <dev_lookup+0x4a>
  8013b1:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013b4:	8b 02                	mov    (%edx),%eax
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	75 f3                	jne    8013ad <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013ba:	a1 04 40 80 00       	mov    0x804004,%eax
  8013bf:	8b 40 48             	mov    0x48(%eax),%eax
  8013c2:	83 ec 04             	sub    $0x4,%esp
  8013c5:	51                   	push   %ecx
  8013c6:	50                   	push   %eax
  8013c7:	68 70 29 80 00       	push   $0x802970
  8013cc:	e8 38 f0 ff ff       	call   800409 <cprintf>
	*dev = 0;
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013da:	83 c4 10             	add    $0x10,%esp
  8013dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013e2:	c9                   	leave  
  8013e3:	c3                   	ret    
			*dev = devtab[i];
  8013e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ee:	eb f2                	jmp    8013e2 <dev_lookup+0x48>

008013f0 <fd_close>:
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	57                   	push   %edi
  8013f4:	56                   	push   %esi
  8013f5:	53                   	push   %ebx
  8013f6:	83 ec 1c             	sub    $0x1c,%esp
  8013f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8013fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801402:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801403:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801409:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80140c:	50                   	push   %eax
  80140d:	e8 32 ff ff ff       	call   801344 <fd_lookup>
  801412:	89 c3                	mov    %eax,%ebx
  801414:	83 c4 08             	add    $0x8,%esp
  801417:	85 c0                	test   %eax,%eax
  801419:	78 05                	js     801420 <fd_close+0x30>
	    || fd != fd2)
  80141b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80141e:	74 16                	je     801436 <fd_close+0x46>
		return (must_exist ? r : 0);
  801420:	89 f8                	mov    %edi,%eax
  801422:	84 c0                	test   %al,%al
  801424:	b8 00 00 00 00       	mov    $0x0,%eax
  801429:	0f 44 d8             	cmove  %eax,%ebx
}
  80142c:	89 d8                	mov    %ebx,%eax
  80142e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801431:	5b                   	pop    %ebx
  801432:	5e                   	pop    %esi
  801433:	5f                   	pop    %edi
  801434:	5d                   	pop    %ebp
  801435:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801436:	83 ec 08             	sub    $0x8,%esp
  801439:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80143c:	50                   	push   %eax
  80143d:	ff 36                	pushl  (%esi)
  80143f:	e8 56 ff ff ff       	call   80139a <dev_lookup>
  801444:	89 c3                	mov    %eax,%ebx
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	85 c0                	test   %eax,%eax
  80144b:	78 15                	js     801462 <fd_close+0x72>
		if (dev->dev_close)
  80144d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801450:	8b 40 10             	mov    0x10(%eax),%eax
  801453:	85 c0                	test   %eax,%eax
  801455:	74 1b                	je     801472 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801457:	83 ec 0c             	sub    $0xc,%esp
  80145a:	56                   	push   %esi
  80145b:	ff d0                	call   *%eax
  80145d:	89 c3                	mov    %eax,%ebx
  80145f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801462:	83 ec 08             	sub    $0x8,%esp
  801465:	56                   	push   %esi
  801466:	6a 00                	push   $0x0
  801468:	e8 39 fa ff ff       	call   800ea6 <sys_page_unmap>
	return r;
  80146d:	83 c4 10             	add    $0x10,%esp
  801470:	eb ba                	jmp    80142c <fd_close+0x3c>
			r = 0;
  801472:	bb 00 00 00 00       	mov    $0x0,%ebx
  801477:	eb e9                	jmp    801462 <fd_close+0x72>

00801479 <close>:

int
close(int fdnum)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80147f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801482:	50                   	push   %eax
  801483:	ff 75 08             	pushl  0x8(%ebp)
  801486:	e8 b9 fe ff ff       	call   801344 <fd_lookup>
  80148b:	83 c4 08             	add    $0x8,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	78 10                	js     8014a2 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801492:	83 ec 08             	sub    $0x8,%esp
  801495:	6a 01                	push   $0x1
  801497:	ff 75 f4             	pushl  -0xc(%ebp)
  80149a:	e8 51 ff ff ff       	call   8013f0 <fd_close>
  80149f:	83 c4 10             	add    $0x10,%esp
}
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <close_all>:

void
close_all(void)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	53                   	push   %ebx
  8014a8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014ab:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	53                   	push   %ebx
  8014b4:	e8 c0 ff ff ff       	call   801479 <close>
	for (i = 0; i < MAXFD; i++)
  8014b9:	83 c3 01             	add    $0x1,%ebx
  8014bc:	83 c4 10             	add    $0x10,%esp
  8014bf:	83 fb 20             	cmp    $0x20,%ebx
  8014c2:	75 ec                	jne    8014b0 <close_all+0xc>
}
  8014c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	57                   	push   %edi
  8014cd:	56                   	push   %esi
  8014ce:	53                   	push   %ebx
  8014cf:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014d5:	50                   	push   %eax
  8014d6:	ff 75 08             	pushl  0x8(%ebp)
  8014d9:	e8 66 fe ff ff       	call   801344 <fd_lookup>
  8014de:	89 c3                	mov    %eax,%ebx
  8014e0:	83 c4 08             	add    $0x8,%esp
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	0f 88 81 00 00 00    	js     80156c <dup+0xa3>
		return r;
	close(newfdnum);
  8014eb:	83 ec 0c             	sub    $0xc,%esp
  8014ee:	ff 75 0c             	pushl  0xc(%ebp)
  8014f1:	e8 83 ff ff ff       	call   801479 <close>

	newfd = INDEX2FD(newfdnum);
  8014f6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014f9:	c1 e6 0c             	shl    $0xc,%esi
  8014fc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801502:	83 c4 04             	add    $0x4,%esp
  801505:	ff 75 e4             	pushl  -0x1c(%ebp)
  801508:	e8 d1 fd ff ff       	call   8012de <fd2data>
  80150d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80150f:	89 34 24             	mov    %esi,(%esp)
  801512:	e8 c7 fd ff ff       	call   8012de <fd2data>
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80151c:	89 d8                	mov    %ebx,%eax
  80151e:	c1 e8 16             	shr    $0x16,%eax
  801521:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801528:	a8 01                	test   $0x1,%al
  80152a:	74 11                	je     80153d <dup+0x74>
  80152c:	89 d8                	mov    %ebx,%eax
  80152e:	c1 e8 0c             	shr    $0xc,%eax
  801531:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801538:	f6 c2 01             	test   $0x1,%dl
  80153b:	75 39                	jne    801576 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80153d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801540:	89 d0                	mov    %edx,%eax
  801542:	c1 e8 0c             	shr    $0xc,%eax
  801545:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80154c:	83 ec 0c             	sub    $0xc,%esp
  80154f:	25 07 0e 00 00       	and    $0xe07,%eax
  801554:	50                   	push   %eax
  801555:	56                   	push   %esi
  801556:	6a 00                	push   $0x0
  801558:	52                   	push   %edx
  801559:	6a 00                	push   $0x0
  80155b:	e8 04 f9 ff ff       	call   800e64 <sys_page_map>
  801560:	89 c3                	mov    %eax,%ebx
  801562:	83 c4 20             	add    $0x20,%esp
  801565:	85 c0                	test   %eax,%eax
  801567:	78 31                	js     80159a <dup+0xd1>
		goto err;

	return newfdnum;
  801569:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80156c:	89 d8                	mov    %ebx,%eax
  80156e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801571:	5b                   	pop    %ebx
  801572:	5e                   	pop    %esi
  801573:	5f                   	pop    %edi
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801576:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80157d:	83 ec 0c             	sub    $0xc,%esp
  801580:	25 07 0e 00 00       	and    $0xe07,%eax
  801585:	50                   	push   %eax
  801586:	57                   	push   %edi
  801587:	6a 00                	push   $0x0
  801589:	53                   	push   %ebx
  80158a:	6a 00                	push   $0x0
  80158c:	e8 d3 f8 ff ff       	call   800e64 <sys_page_map>
  801591:	89 c3                	mov    %eax,%ebx
  801593:	83 c4 20             	add    $0x20,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	79 a3                	jns    80153d <dup+0x74>
	sys_page_unmap(0, newfd);
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	56                   	push   %esi
  80159e:	6a 00                	push   $0x0
  8015a0:	e8 01 f9 ff ff       	call   800ea6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015a5:	83 c4 08             	add    $0x8,%esp
  8015a8:	57                   	push   %edi
  8015a9:	6a 00                	push   $0x0
  8015ab:	e8 f6 f8 ff ff       	call   800ea6 <sys_page_unmap>
	return r;
  8015b0:	83 c4 10             	add    $0x10,%esp
  8015b3:	eb b7                	jmp    80156c <dup+0xa3>

008015b5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	53                   	push   %ebx
  8015b9:	83 ec 14             	sub    $0x14,%esp
  8015bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c2:	50                   	push   %eax
  8015c3:	53                   	push   %ebx
  8015c4:	e8 7b fd ff ff       	call   801344 <fd_lookup>
  8015c9:	83 c4 08             	add    $0x8,%esp
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	78 3f                	js     80160f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015d0:	83 ec 08             	sub    $0x8,%esp
  8015d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d6:	50                   	push   %eax
  8015d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015da:	ff 30                	pushl  (%eax)
  8015dc:	e8 b9 fd ff ff       	call   80139a <dev_lookup>
  8015e1:	83 c4 10             	add    $0x10,%esp
  8015e4:	85 c0                	test   %eax,%eax
  8015e6:	78 27                	js     80160f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015eb:	8b 42 08             	mov    0x8(%edx),%eax
  8015ee:	83 e0 03             	and    $0x3,%eax
  8015f1:	83 f8 01             	cmp    $0x1,%eax
  8015f4:	74 1e                	je     801614 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f9:	8b 40 08             	mov    0x8(%eax),%eax
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	74 35                	je     801635 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	ff 75 10             	pushl  0x10(%ebp)
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	52                   	push   %edx
  80160a:	ff d0                	call   *%eax
  80160c:	83 c4 10             	add    $0x10,%esp
}
  80160f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801612:	c9                   	leave  
  801613:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801614:	a1 04 40 80 00       	mov    0x804004,%eax
  801619:	8b 40 48             	mov    0x48(%eax),%eax
  80161c:	83 ec 04             	sub    $0x4,%esp
  80161f:	53                   	push   %ebx
  801620:	50                   	push   %eax
  801621:	68 b1 29 80 00       	push   $0x8029b1
  801626:	e8 de ed ff ff       	call   800409 <cprintf>
		return -E_INVAL;
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801633:	eb da                	jmp    80160f <read+0x5a>
		return -E_NOT_SUPP;
  801635:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80163a:	eb d3                	jmp    80160f <read+0x5a>

0080163c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	57                   	push   %edi
  801640:	56                   	push   %esi
  801641:	53                   	push   %ebx
  801642:	83 ec 0c             	sub    $0xc,%esp
  801645:	8b 7d 08             	mov    0x8(%ebp),%edi
  801648:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80164b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801650:	39 f3                	cmp    %esi,%ebx
  801652:	73 25                	jae    801679 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801654:	83 ec 04             	sub    $0x4,%esp
  801657:	89 f0                	mov    %esi,%eax
  801659:	29 d8                	sub    %ebx,%eax
  80165b:	50                   	push   %eax
  80165c:	89 d8                	mov    %ebx,%eax
  80165e:	03 45 0c             	add    0xc(%ebp),%eax
  801661:	50                   	push   %eax
  801662:	57                   	push   %edi
  801663:	e8 4d ff ff ff       	call   8015b5 <read>
		if (m < 0)
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	85 c0                	test   %eax,%eax
  80166d:	78 08                	js     801677 <readn+0x3b>
			return m;
		if (m == 0)
  80166f:	85 c0                	test   %eax,%eax
  801671:	74 06                	je     801679 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801673:	01 c3                	add    %eax,%ebx
  801675:	eb d9                	jmp    801650 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801677:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801679:	89 d8                	mov    %ebx,%eax
  80167b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80167e:	5b                   	pop    %ebx
  80167f:	5e                   	pop    %esi
  801680:	5f                   	pop    %edi
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	53                   	push   %ebx
  801687:	83 ec 14             	sub    $0x14,%esp
  80168a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80168d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801690:	50                   	push   %eax
  801691:	53                   	push   %ebx
  801692:	e8 ad fc ff ff       	call   801344 <fd_lookup>
  801697:	83 c4 08             	add    $0x8,%esp
  80169a:	85 c0                	test   %eax,%eax
  80169c:	78 3a                	js     8016d8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80169e:	83 ec 08             	sub    $0x8,%esp
  8016a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a4:	50                   	push   %eax
  8016a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a8:	ff 30                	pushl  (%eax)
  8016aa:	e8 eb fc ff ff       	call   80139a <dev_lookup>
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	85 c0                	test   %eax,%eax
  8016b4:	78 22                	js     8016d8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016bd:	74 1e                	je     8016dd <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c2:	8b 52 0c             	mov    0xc(%edx),%edx
  8016c5:	85 d2                	test   %edx,%edx
  8016c7:	74 35                	je     8016fe <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016c9:	83 ec 04             	sub    $0x4,%esp
  8016cc:	ff 75 10             	pushl  0x10(%ebp)
  8016cf:	ff 75 0c             	pushl  0xc(%ebp)
  8016d2:	50                   	push   %eax
  8016d3:	ff d2                	call   *%edx
  8016d5:	83 c4 10             	add    $0x10,%esp
}
  8016d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016dd:	a1 04 40 80 00       	mov    0x804004,%eax
  8016e2:	8b 40 48             	mov    0x48(%eax),%eax
  8016e5:	83 ec 04             	sub    $0x4,%esp
  8016e8:	53                   	push   %ebx
  8016e9:	50                   	push   %eax
  8016ea:	68 cd 29 80 00       	push   $0x8029cd
  8016ef:	e8 15 ed ff ff       	call   800409 <cprintf>
		return -E_INVAL;
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016fc:	eb da                	jmp    8016d8 <write+0x55>
		return -E_NOT_SUPP;
  8016fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801703:	eb d3                	jmp    8016d8 <write+0x55>

00801705 <seek>:

int
seek(int fdnum, off_t offset)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80170b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80170e:	50                   	push   %eax
  80170f:	ff 75 08             	pushl  0x8(%ebp)
  801712:	e8 2d fc ff ff       	call   801344 <fd_lookup>
  801717:	83 c4 08             	add    $0x8,%esp
  80171a:	85 c0                	test   %eax,%eax
  80171c:	78 0e                	js     80172c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80171e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801721:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801724:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801727:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	53                   	push   %ebx
  801732:	83 ec 14             	sub    $0x14,%esp
  801735:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801738:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80173b:	50                   	push   %eax
  80173c:	53                   	push   %ebx
  80173d:	e8 02 fc ff ff       	call   801344 <fd_lookup>
  801742:	83 c4 08             	add    $0x8,%esp
  801745:	85 c0                	test   %eax,%eax
  801747:	78 37                	js     801780 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801749:	83 ec 08             	sub    $0x8,%esp
  80174c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174f:	50                   	push   %eax
  801750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801753:	ff 30                	pushl  (%eax)
  801755:	e8 40 fc ff ff       	call   80139a <dev_lookup>
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 1f                	js     801780 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801764:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801768:	74 1b                	je     801785 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80176a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80176d:	8b 52 18             	mov    0x18(%edx),%edx
  801770:	85 d2                	test   %edx,%edx
  801772:	74 32                	je     8017a6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801774:	83 ec 08             	sub    $0x8,%esp
  801777:	ff 75 0c             	pushl  0xc(%ebp)
  80177a:	50                   	push   %eax
  80177b:	ff d2                	call   *%edx
  80177d:	83 c4 10             	add    $0x10,%esp
}
  801780:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801783:	c9                   	leave  
  801784:	c3                   	ret    
			thisenv->env_id, fdnum);
  801785:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80178a:	8b 40 48             	mov    0x48(%eax),%eax
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	53                   	push   %ebx
  801791:	50                   	push   %eax
  801792:	68 90 29 80 00       	push   $0x802990
  801797:	e8 6d ec ff ff       	call   800409 <cprintf>
		return -E_INVAL;
  80179c:	83 c4 10             	add    $0x10,%esp
  80179f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a4:	eb da                	jmp    801780 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8017a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017ab:	eb d3                	jmp    801780 <ftruncate+0x52>

008017ad <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	53                   	push   %ebx
  8017b1:	83 ec 14             	sub    $0x14,%esp
  8017b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ba:	50                   	push   %eax
  8017bb:	ff 75 08             	pushl  0x8(%ebp)
  8017be:	e8 81 fb ff ff       	call   801344 <fd_lookup>
  8017c3:	83 c4 08             	add    $0x8,%esp
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	78 4b                	js     801815 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ca:	83 ec 08             	sub    $0x8,%esp
  8017cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d0:	50                   	push   %eax
  8017d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d4:	ff 30                	pushl  (%eax)
  8017d6:	e8 bf fb ff ff       	call   80139a <dev_lookup>
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	78 33                	js     801815 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017e9:	74 2f                	je     80181a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017eb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017ee:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017f5:	00 00 00 
	stat->st_isdir = 0;
  8017f8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017ff:	00 00 00 
	stat->st_dev = dev;
  801802:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801808:	83 ec 08             	sub    $0x8,%esp
  80180b:	53                   	push   %ebx
  80180c:	ff 75 f0             	pushl  -0x10(%ebp)
  80180f:	ff 50 14             	call   *0x14(%eax)
  801812:	83 c4 10             	add    $0x10,%esp
}
  801815:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801818:	c9                   	leave  
  801819:	c3                   	ret    
		return -E_NOT_SUPP;
  80181a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80181f:	eb f4                	jmp    801815 <fstat+0x68>

00801821 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	56                   	push   %esi
  801825:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801826:	83 ec 08             	sub    $0x8,%esp
  801829:	6a 00                	push   $0x0
  80182b:	ff 75 08             	pushl  0x8(%ebp)
  80182e:	e8 30 02 00 00       	call   801a63 <open>
  801833:	89 c3                	mov    %eax,%ebx
  801835:	83 c4 10             	add    $0x10,%esp
  801838:	85 c0                	test   %eax,%eax
  80183a:	78 1b                	js     801857 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80183c:	83 ec 08             	sub    $0x8,%esp
  80183f:	ff 75 0c             	pushl  0xc(%ebp)
  801842:	50                   	push   %eax
  801843:	e8 65 ff ff ff       	call   8017ad <fstat>
  801848:	89 c6                	mov    %eax,%esi
	close(fd);
  80184a:	89 1c 24             	mov    %ebx,(%esp)
  80184d:	e8 27 fc ff ff       	call   801479 <close>
	return r;
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	89 f3                	mov    %esi,%ebx
}
  801857:	89 d8                	mov    %ebx,%eax
  801859:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185c:	5b                   	pop    %ebx
  80185d:	5e                   	pop    %esi
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    

00801860 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	56                   	push   %esi
  801864:	53                   	push   %ebx
  801865:	89 c6                	mov    %eax,%esi
  801867:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801869:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801870:	74 27                	je     801899 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801872:	6a 07                	push   $0x7
  801874:	68 00 50 80 00       	push   $0x805000
  801879:	56                   	push   %esi
  80187a:	ff 35 00 40 80 00    	pushl  0x804000
  801880:	e8 82 08 00 00       	call   802107 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801885:	83 c4 0c             	add    $0xc,%esp
  801888:	6a 00                	push   $0x0
  80188a:	53                   	push   %ebx
  80188b:	6a 00                	push   $0x0
  80188d:	e8 0c 08 00 00       	call   80209e <ipc_recv>
}
  801892:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801895:	5b                   	pop    %ebx
  801896:	5e                   	pop    %esi
  801897:	5d                   	pop    %ebp
  801898:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801899:	83 ec 0c             	sub    $0xc,%esp
  80189c:	6a 01                	push   $0x1
  80189e:	e8 b8 08 00 00       	call   80215b <ipc_find_env>
  8018a3:	a3 00 40 80 00       	mov    %eax,0x804000
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	eb c5                	jmp    801872 <fsipc+0x12>

008018ad <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cb:	b8 02 00 00 00       	mov    $0x2,%eax
  8018d0:	e8 8b ff ff ff       	call   801860 <fsipc>
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <devfile_flush>:
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ed:	b8 06 00 00 00       	mov    $0x6,%eax
  8018f2:	e8 69 ff ff ff       	call   801860 <fsipc>
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <devfile_stat>:
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	53                   	push   %ebx
  8018fd:	83 ec 04             	sub    $0x4,%esp
  801900:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	8b 40 0c             	mov    0xc(%eax),%eax
  801909:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80190e:	ba 00 00 00 00       	mov    $0x0,%edx
  801913:	b8 05 00 00 00       	mov    $0x5,%eax
  801918:	e8 43 ff ff ff       	call   801860 <fsipc>
  80191d:	85 c0                	test   %eax,%eax
  80191f:	78 2c                	js     80194d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801921:	83 ec 08             	sub    $0x8,%esp
  801924:	68 00 50 80 00       	push   $0x805000
  801929:	53                   	push   %ebx
  80192a:	e8 f9 f0 ff ff       	call   800a28 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80192f:	a1 80 50 80 00       	mov    0x805080,%eax
  801934:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80193a:	a1 84 50 80 00       	mov    0x805084,%eax
  80193f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80194d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <devfile_write>:
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	53                   	push   %ebx
  801956:	83 ec 08             	sub    $0x8,%esp
  801959:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  80195c:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801962:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801967:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80196a:	8b 45 08             	mov    0x8(%ebp),%eax
  80196d:	8b 40 0c             	mov    0xc(%eax),%eax
  801970:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801975:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80197b:	53                   	push   %ebx
  80197c:	ff 75 0c             	pushl  0xc(%ebp)
  80197f:	68 08 50 80 00       	push   $0x805008
  801984:	e8 2d f2 ff ff       	call   800bb6 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801989:	ba 00 00 00 00       	mov    $0x0,%edx
  80198e:	b8 04 00 00 00       	mov    $0x4,%eax
  801993:	e8 c8 fe ff ff       	call   801860 <fsipc>
  801998:	83 c4 10             	add    $0x10,%esp
  80199b:	85 c0                	test   %eax,%eax
  80199d:	78 0b                	js     8019aa <devfile_write+0x58>
	assert(r <= n);
  80199f:	39 d8                	cmp    %ebx,%eax
  8019a1:	77 0c                	ja     8019af <devfile_write+0x5d>
	assert(r <= PGSIZE);
  8019a3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019a8:	7f 1e                	jg     8019c8 <devfile_write+0x76>
}
  8019aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    
	assert(r <= n);
  8019af:	68 fc 29 80 00       	push   $0x8029fc
  8019b4:	68 03 2a 80 00       	push   $0x802a03
  8019b9:	68 98 00 00 00       	push   $0x98
  8019be:	68 18 2a 80 00       	push   $0x802a18
  8019c3:	e8 66 e9 ff ff       	call   80032e <_panic>
	assert(r <= PGSIZE);
  8019c8:	68 23 2a 80 00       	push   $0x802a23
  8019cd:	68 03 2a 80 00       	push   $0x802a03
  8019d2:	68 99 00 00 00       	push   $0x99
  8019d7:	68 18 2a 80 00       	push   $0x802a18
  8019dc:	e8 4d e9 ff ff       	call   80032e <_panic>

008019e1 <devfile_read>:
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	56                   	push   %esi
  8019e5:	53                   	push   %ebx
  8019e6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ef:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019f4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ff:	b8 03 00 00 00       	mov    $0x3,%eax
  801a04:	e8 57 fe ff ff       	call   801860 <fsipc>
  801a09:	89 c3                	mov    %eax,%ebx
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	78 1f                	js     801a2e <devfile_read+0x4d>
	assert(r <= n);
  801a0f:	39 f0                	cmp    %esi,%eax
  801a11:	77 24                	ja     801a37 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a13:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a18:	7f 33                	jg     801a4d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a1a:	83 ec 04             	sub    $0x4,%esp
  801a1d:	50                   	push   %eax
  801a1e:	68 00 50 80 00       	push   $0x805000
  801a23:	ff 75 0c             	pushl  0xc(%ebp)
  801a26:	e8 8b f1 ff ff       	call   800bb6 <memmove>
	return r;
  801a2b:	83 c4 10             	add    $0x10,%esp
}
  801a2e:	89 d8                	mov    %ebx,%eax
  801a30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5e                   	pop    %esi
  801a35:	5d                   	pop    %ebp
  801a36:	c3                   	ret    
	assert(r <= n);
  801a37:	68 fc 29 80 00       	push   $0x8029fc
  801a3c:	68 03 2a 80 00       	push   $0x802a03
  801a41:	6a 7c                	push   $0x7c
  801a43:	68 18 2a 80 00       	push   $0x802a18
  801a48:	e8 e1 e8 ff ff       	call   80032e <_panic>
	assert(r <= PGSIZE);
  801a4d:	68 23 2a 80 00       	push   $0x802a23
  801a52:	68 03 2a 80 00       	push   $0x802a03
  801a57:	6a 7d                	push   $0x7d
  801a59:	68 18 2a 80 00       	push   $0x802a18
  801a5e:	e8 cb e8 ff ff       	call   80032e <_panic>

00801a63 <open>:
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	56                   	push   %esi
  801a67:	53                   	push   %ebx
  801a68:	83 ec 1c             	sub    $0x1c,%esp
  801a6b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a6e:	56                   	push   %esi
  801a6f:	e8 7d ef ff ff       	call   8009f1 <strlen>
  801a74:	83 c4 10             	add    $0x10,%esp
  801a77:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a7c:	7f 6c                	jg     801aea <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a7e:	83 ec 0c             	sub    $0xc,%esp
  801a81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a84:	50                   	push   %eax
  801a85:	e8 6b f8 ff ff       	call   8012f5 <fd_alloc>
  801a8a:	89 c3                	mov    %eax,%ebx
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	78 3c                	js     801acf <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a93:	83 ec 08             	sub    $0x8,%esp
  801a96:	56                   	push   %esi
  801a97:	68 00 50 80 00       	push   $0x805000
  801a9c:	e8 87 ef ff ff       	call   800a28 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa4:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aac:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab1:	e8 aa fd ff ff       	call   801860 <fsipc>
  801ab6:	89 c3                	mov    %eax,%ebx
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	85 c0                	test   %eax,%eax
  801abd:	78 19                	js     801ad8 <open+0x75>
	return fd2num(fd);
  801abf:	83 ec 0c             	sub    $0xc,%esp
  801ac2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac5:	e8 04 f8 ff ff       	call   8012ce <fd2num>
  801aca:	89 c3                	mov    %eax,%ebx
  801acc:	83 c4 10             	add    $0x10,%esp
}
  801acf:	89 d8                	mov    %ebx,%eax
  801ad1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad4:	5b                   	pop    %ebx
  801ad5:	5e                   	pop    %esi
  801ad6:	5d                   	pop    %ebp
  801ad7:	c3                   	ret    
		fd_close(fd, 0);
  801ad8:	83 ec 08             	sub    $0x8,%esp
  801adb:	6a 00                	push   $0x0
  801add:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae0:	e8 0b f9 ff ff       	call   8013f0 <fd_close>
		return r;
  801ae5:	83 c4 10             	add    $0x10,%esp
  801ae8:	eb e5                	jmp    801acf <open+0x6c>
		return -E_BAD_PATH;
  801aea:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aef:	eb de                	jmp    801acf <open+0x6c>

00801af1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801af7:	ba 00 00 00 00       	mov    $0x0,%edx
  801afc:	b8 08 00 00 00       	mov    $0x8,%eax
  801b01:	e8 5a fd ff ff       	call   801860 <fsipc>
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	56                   	push   %esi
  801b0c:	53                   	push   %ebx
  801b0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b10:	83 ec 0c             	sub    $0xc,%esp
  801b13:	ff 75 08             	pushl  0x8(%ebp)
  801b16:	e8 c3 f7 ff ff       	call   8012de <fd2data>
  801b1b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b1d:	83 c4 08             	add    $0x8,%esp
  801b20:	68 2f 2a 80 00       	push   $0x802a2f
  801b25:	53                   	push   %ebx
  801b26:	e8 fd ee ff ff       	call   800a28 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b2b:	8b 46 04             	mov    0x4(%esi),%eax
  801b2e:	2b 06                	sub    (%esi),%eax
  801b30:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b36:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b3d:	00 00 00 
	stat->st_dev = &devpipe;
  801b40:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801b47:	30 80 00 
	return 0;
}
  801b4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b52:	5b                   	pop    %ebx
  801b53:	5e                   	pop    %esi
  801b54:	5d                   	pop    %ebp
  801b55:	c3                   	ret    

00801b56 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	53                   	push   %ebx
  801b5a:	83 ec 0c             	sub    $0xc,%esp
  801b5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b60:	53                   	push   %ebx
  801b61:	6a 00                	push   $0x0
  801b63:	e8 3e f3 ff ff       	call   800ea6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b68:	89 1c 24             	mov    %ebx,(%esp)
  801b6b:	e8 6e f7 ff ff       	call   8012de <fd2data>
  801b70:	83 c4 08             	add    $0x8,%esp
  801b73:	50                   	push   %eax
  801b74:	6a 00                	push   $0x0
  801b76:	e8 2b f3 ff ff       	call   800ea6 <sys_page_unmap>
}
  801b7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <_pipeisclosed>:
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	57                   	push   %edi
  801b84:	56                   	push   %esi
  801b85:	53                   	push   %ebx
  801b86:	83 ec 1c             	sub    $0x1c,%esp
  801b89:	89 c7                	mov    %eax,%edi
  801b8b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b8d:	a1 04 40 80 00       	mov    0x804004,%eax
  801b92:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b95:	83 ec 0c             	sub    $0xc,%esp
  801b98:	57                   	push   %edi
  801b99:	e8 f6 05 00 00       	call   802194 <pageref>
  801b9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ba1:	89 34 24             	mov    %esi,(%esp)
  801ba4:	e8 eb 05 00 00       	call   802194 <pageref>
		nn = thisenv->env_runs;
  801ba9:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801baf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	39 cb                	cmp    %ecx,%ebx
  801bb7:	74 1b                	je     801bd4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801bb9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bbc:	75 cf                	jne    801b8d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bbe:	8b 42 58             	mov    0x58(%edx),%eax
  801bc1:	6a 01                	push   $0x1
  801bc3:	50                   	push   %eax
  801bc4:	53                   	push   %ebx
  801bc5:	68 36 2a 80 00       	push   $0x802a36
  801bca:	e8 3a e8 ff ff       	call   800409 <cprintf>
  801bcf:	83 c4 10             	add    $0x10,%esp
  801bd2:	eb b9                	jmp    801b8d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bd4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bd7:	0f 94 c0             	sete   %al
  801bda:	0f b6 c0             	movzbl %al,%eax
}
  801bdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be0:	5b                   	pop    %ebx
  801be1:	5e                   	pop    %esi
  801be2:	5f                   	pop    %edi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    

00801be5 <devpipe_write>:
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	57                   	push   %edi
  801be9:	56                   	push   %esi
  801bea:	53                   	push   %ebx
  801beb:	83 ec 28             	sub    $0x28,%esp
  801bee:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bf1:	56                   	push   %esi
  801bf2:	e8 e7 f6 ff ff       	call   8012de <fd2data>
  801bf7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bf9:	83 c4 10             	add    $0x10,%esp
  801bfc:	bf 00 00 00 00       	mov    $0x0,%edi
  801c01:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c04:	74 4f                	je     801c55 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c06:	8b 43 04             	mov    0x4(%ebx),%eax
  801c09:	8b 0b                	mov    (%ebx),%ecx
  801c0b:	8d 51 20             	lea    0x20(%ecx),%edx
  801c0e:	39 d0                	cmp    %edx,%eax
  801c10:	72 14                	jb     801c26 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c12:	89 da                	mov    %ebx,%edx
  801c14:	89 f0                	mov    %esi,%eax
  801c16:	e8 65 ff ff ff       	call   801b80 <_pipeisclosed>
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	75 3a                	jne    801c59 <devpipe_write+0x74>
			sys_yield();
  801c1f:	e8 de f1 ff ff       	call   800e02 <sys_yield>
  801c24:	eb e0                	jmp    801c06 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c29:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c2d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c30:	89 c2                	mov    %eax,%edx
  801c32:	c1 fa 1f             	sar    $0x1f,%edx
  801c35:	89 d1                	mov    %edx,%ecx
  801c37:	c1 e9 1b             	shr    $0x1b,%ecx
  801c3a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c3d:	83 e2 1f             	and    $0x1f,%edx
  801c40:	29 ca                	sub    %ecx,%edx
  801c42:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c46:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c4a:	83 c0 01             	add    $0x1,%eax
  801c4d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c50:	83 c7 01             	add    $0x1,%edi
  801c53:	eb ac                	jmp    801c01 <devpipe_write+0x1c>
	return i;
  801c55:	89 f8                	mov    %edi,%eax
  801c57:	eb 05                	jmp    801c5e <devpipe_write+0x79>
				return 0;
  801c59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c61:	5b                   	pop    %ebx
  801c62:	5e                   	pop    %esi
  801c63:	5f                   	pop    %edi
  801c64:	5d                   	pop    %ebp
  801c65:	c3                   	ret    

00801c66 <devpipe_read>:
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	57                   	push   %edi
  801c6a:	56                   	push   %esi
  801c6b:	53                   	push   %ebx
  801c6c:	83 ec 18             	sub    $0x18,%esp
  801c6f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c72:	57                   	push   %edi
  801c73:	e8 66 f6 ff ff       	call   8012de <fd2data>
  801c78:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c7a:	83 c4 10             	add    $0x10,%esp
  801c7d:	be 00 00 00 00       	mov    $0x0,%esi
  801c82:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c85:	74 47                	je     801cce <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801c87:	8b 03                	mov    (%ebx),%eax
  801c89:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c8c:	75 22                	jne    801cb0 <devpipe_read+0x4a>
			if (i > 0)
  801c8e:	85 f6                	test   %esi,%esi
  801c90:	75 14                	jne    801ca6 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c92:	89 da                	mov    %ebx,%edx
  801c94:	89 f8                	mov    %edi,%eax
  801c96:	e8 e5 fe ff ff       	call   801b80 <_pipeisclosed>
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	75 33                	jne    801cd2 <devpipe_read+0x6c>
			sys_yield();
  801c9f:	e8 5e f1 ff ff       	call   800e02 <sys_yield>
  801ca4:	eb e1                	jmp    801c87 <devpipe_read+0x21>
				return i;
  801ca6:	89 f0                	mov    %esi,%eax
}
  801ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5e                   	pop    %esi
  801cad:	5f                   	pop    %edi
  801cae:	5d                   	pop    %ebp
  801caf:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cb0:	99                   	cltd   
  801cb1:	c1 ea 1b             	shr    $0x1b,%edx
  801cb4:	01 d0                	add    %edx,%eax
  801cb6:	83 e0 1f             	and    $0x1f,%eax
  801cb9:	29 d0                	sub    %edx,%eax
  801cbb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cc3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cc6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cc9:	83 c6 01             	add    $0x1,%esi
  801ccc:	eb b4                	jmp    801c82 <devpipe_read+0x1c>
	return i;
  801cce:	89 f0                	mov    %esi,%eax
  801cd0:	eb d6                	jmp    801ca8 <devpipe_read+0x42>
				return 0;
  801cd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd7:	eb cf                	jmp    801ca8 <devpipe_read+0x42>

00801cd9 <pipe>:
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	56                   	push   %esi
  801cdd:	53                   	push   %ebx
  801cde:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ce1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce4:	50                   	push   %eax
  801ce5:	e8 0b f6 ff ff       	call   8012f5 <fd_alloc>
  801cea:	89 c3                	mov    %eax,%ebx
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	85 c0                	test   %eax,%eax
  801cf1:	78 5b                	js     801d4e <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	68 07 04 00 00       	push   $0x407
  801cfb:	ff 75 f4             	pushl  -0xc(%ebp)
  801cfe:	6a 00                	push   $0x0
  801d00:	e8 1c f1 ff ff       	call   800e21 <sys_page_alloc>
  801d05:	89 c3                	mov    %eax,%ebx
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	78 40                	js     801d4e <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801d0e:	83 ec 0c             	sub    $0xc,%esp
  801d11:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d14:	50                   	push   %eax
  801d15:	e8 db f5 ff ff       	call   8012f5 <fd_alloc>
  801d1a:	89 c3                	mov    %eax,%ebx
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	78 1b                	js     801d3e <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d23:	83 ec 04             	sub    $0x4,%esp
  801d26:	68 07 04 00 00       	push   $0x407
  801d2b:	ff 75 f0             	pushl  -0x10(%ebp)
  801d2e:	6a 00                	push   $0x0
  801d30:	e8 ec f0 ff ff       	call   800e21 <sys_page_alloc>
  801d35:	89 c3                	mov    %eax,%ebx
  801d37:	83 c4 10             	add    $0x10,%esp
  801d3a:	85 c0                	test   %eax,%eax
  801d3c:	79 19                	jns    801d57 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801d3e:	83 ec 08             	sub    $0x8,%esp
  801d41:	ff 75 f4             	pushl  -0xc(%ebp)
  801d44:	6a 00                	push   $0x0
  801d46:	e8 5b f1 ff ff       	call   800ea6 <sys_page_unmap>
  801d4b:	83 c4 10             	add    $0x10,%esp
}
  801d4e:	89 d8                	mov    %ebx,%eax
  801d50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d53:	5b                   	pop    %ebx
  801d54:	5e                   	pop    %esi
  801d55:	5d                   	pop    %ebp
  801d56:	c3                   	ret    
	va = fd2data(fd0);
  801d57:	83 ec 0c             	sub    $0xc,%esp
  801d5a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d5d:	e8 7c f5 ff ff       	call   8012de <fd2data>
  801d62:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d64:	83 c4 0c             	add    $0xc,%esp
  801d67:	68 07 04 00 00       	push   $0x407
  801d6c:	50                   	push   %eax
  801d6d:	6a 00                	push   $0x0
  801d6f:	e8 ad f0 ff ff       	call   800e21 <sys_page_alloc>
  801d74:	89 c3                	mov    %eax,%ebx
  801d76:	83 c4 10             	add    $0x10,%esp
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	0f 88 8c 00 00 00    	js     801e0d <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d81:	83 ec 0c             	sub    $0xc,%esp
  801d84:	ff 75 f0             	pushl  -0x10(%ebp)
  801d87:	e8 52 f5 ff ff       	call   8012de <fd2data>
  801d8c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d93:	50                   	push   %eax
  801d94:	6a 00                	push   $0x0
  801d96:	56                   	push   %esi
  801d97:	6a 00                	push   $0x0
  801d99:	e8 c6 f0 ff ff       	call   800e64 <sys_page_map>
  801d9e:	89 c3                	mov    %eax,%ebx
  801da0:	83 c4 20             	add    $0x20,%esp
  801da3:	85 c0                	test   %eax,%eax
  801da5:	78 58                	js     801dff <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daa:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801db0:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbf:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801dc5:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dca:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801dd1:	83 ec 0c             	sub    $0xc,%esp
  801dd4:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd7:	e8 f2 f4 ff ff       	call   8012ce <fd2num>
  801ddc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ddf:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801de1:	83 c4 04             	add    $0x4,%esp
  801de4:	ff 75 f0             	pushl  -0x10(%ebp)
  801de7:	e8 e2 f4 ff ff       	call   8012ce <fd2num>
  801dec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801def:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801df2:	83 c4 10             	add    $0x10,%esp
  801df5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dfa:	e9 4f ff ff ff       	jmp    801d4e <pipe+0x75>
	sys_page_unmap(0, va);
  801dff:	83 ec 08             	sub    $0x8,%esp
  801e02:	56                   	push   %esi
  801e03:	6a 00                	push   $0x0
  801e05:	e8 9c f0 ff ff       	call   800ea6 <sys_page_unmap>
  801e0a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e0d:	83 ec 08             	sub    $0x8,%esp
  801e10:	ff 75 f0             	pushl  -0x10(%ebp)
  801e13:	6a 00                	push   $0x0
  801e15:	e8 8c f0 ff ff       	call   800ea6 <sys_page_unmap>
  801e1a:	83 c4 10             	add    $0x10,%esp
  801e1d:	e9 1c ff ff ff       	jmp    801d3e <pipe+0x65>

00801e22 <pipeisclosed>:
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e2b:	50                   	push   %eax
  801e2c:	ff 75 08             	pushl  0x8(%ebp)
  801e2f:	e8 10 f5 ff ff       	call   801344 <fd_lookup>
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	85 c0                	test   %eax,%eax
  801e39:	78 18                	js     801e53 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e3b:	83 ec 0c             	sub    $0xc,%esp
  801e3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e41:	e8 98 f4 ff ff       	call   8012de <fd2data>
	return _pipeisclosed(fd, p);
  801e46:	89 c2                	mov    %eax,%edx
  801e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4b:	e8 30 fd ff ff       	call   801b80 <_pipeisclosed>
  801e50:	83 c4 10             	add    $0x10,%esp
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	56                   	push   %esi
  801e59:	53                   	push   %ebx
  801e5a:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801e5d:	85 f6                	test   %esi,%esi
  801e5f:	74 13                	je     801e74 <wait+0x1f>
	e = &envs[ENVX(envid)];
  801e61:	89 f3                	mov    %esi,%ebx
  801e63:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801e69:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801e6c:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801e72:	eb 1b                	jmp    801e8f <wait+0x3a>
	assert(envid != 0);
  801e74:	68 4e 2a 80 00       	push   $0x802a4e
  801e79:	68 03 2a 80 00       	push   $0x802a03
  801e7e:	6a 09                	push   $0x9
  801e80:	68 59 2a 80 00       	push   $0x802a59
  801e85:	e8 a4 e4 ff ff       	call   80032e <_panic>
		sys_yield();
  801e8a:	e8 73 ef ff ff       	call   800e02 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801e8f:	8b 43 48             	mov    0x48(%ebx),%eax
  801e92:	39 f0                	cmp    %esi,%eax
  801e94:	75 07                	jne    801e9d <wait+0x48>
  801e96:	8b 43 54             	mov    0x54(%ebx),%eax
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	75 ed                	jne    801e8a <wait+0x35>
}
  801e9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea0:	5b                   	pop    %ebx
  801ea1:	5e                   	pop    %esi
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    

00801ea4 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eac:	5d                   	pop    %ebp
  801ead:	c3                   	ret    

00801eae <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801eb4:	68 64 2a 80 00       	push   $0x802a64
  801eb9:	ff 75 0c             	pushl  0xc(%ebp)
  801ebc:	e8 67 eb ff ff       	call   800a28 <strcpy>
	return 0;
}
  801ec1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <devcons_write>:
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	57                   	push   %edi
  801ecc:	56                   	push   %esi
  801ecd:	53                   	push   %ebx
  801ece:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ed4:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ed9:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801edf:	eb 2f                	jmp    801f10 <devcons_write+0x48>
		m = n - tot;
  801ee1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ee4:	29 f3                	sub    %esi,%ebx
  801ee6:	83 fb 7f             	cmp    $0x7f,%ebx
  801ee9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801eee:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ef1:	83 ec 04             	sub    $0x4,%esp
  801ef4:	53                   	push   %ebx
  801ef5:	89 f0                	mov    %esi,%eax
  801ef7:	03 45 0c             	add    0xc(%ebp),%eax
  801efa:	50                   	push   %eax
  801efb:	57                   	push   %edi
  801efc:	e8 b5 ec ff ff       	call   800bb6 <memmove>
		sys_cputs(buf, m);
  801f01:	83 c4 08             	add    $0x8,%esp
  801f04:	53                   	push   %ebx
  801f05:	57                   	push   %edi
  801f06:	e8 5a ee ff ff       	call   800d65 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f0b:	01 de                	add    %ebx,%esi
  801f0d:	83 c4 10             	add    $0x10,%esp
  801f10:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f13:	72 cc                	jb     801ee1 <devcons_write+0x19>
}
  801f15:	89 f0                	mov    %esi,%eax
  801f17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f1a:	5b                   	pop    %ebx
  801f1b:	5e                   	pop    %esi
  801f1c:	5f                   	pop    %edi
  801f1d:	5d                   	pop    %ebp
  801f1e:	c3                   	ret    

00801f1f <devcons_read>:
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 08             	sub    $0x8,%esp
  801f25:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f2e:	75 07                	jne    801f37 <devcons_read+0x18>
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    
		sys_yield();
  801f32:	e8 cb ee ff ff       	call   800e02 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801f37:	e8 47 ee ff ff       	call   800d83 <sys_cgetc>
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	74 f2                	je     801f32 <devcons_read+0x13>
	if (c < 0)
  801f40:	85 c0                	test   %eax,%eax
  801f42:	78 ec                	js     801f30 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801f44:	83 f8 04             	cmp    $0x4,%eax
  801f47:	74 0c                	je     801f55 <devcons_read+0x36>
	*(char*)vbuf = c;
  801f49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4c:	88 02                	mov    %al,(%edx)
	return 1;
  801f4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f53:	eb db                	jmp    801f30 <devcons_read+0x11>
		return 0;
  801f55:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5a:	eb d4                	jmp    801f30 <devcons_read+0x11>

00801f5c <cputchar>:
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f68:	6a 01                	push   $0x1
  801f6a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f6d:	50                   	push   %eax
  801f6e:	e8 f2 ed ff ff       	call   800d65 <sys_cputs>
}
  801f73:	83 c4 10             	add    $0x10,%esp
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <getchar>:
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f7e:	6a 01                	push   $0x1
  801f80:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f83:	50                   	push   %eax
  801f84:	6a 00                	push   $0x0
  801f86:	e8 2a f6 ff ff       	call   8015b5 <read>
	if (r < 0)
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	78 08                	js     801f9a <getchar+0x22>
	if (r < 1)
  801f92:	85 c0                	test   %eax,%eax
  801f94:	7e 06                	jle    801f9c <getchar+0x24>
	return c;
  801f96:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    
		return -E_EOF;
  801f9c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fa1:	eb f7                	jmp    801f9a <getchar+0x22>

00801fa3 <iscons>:
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fa9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fac:	50                   	push   %eax
  801fad:	ff 75 08             	pushl  0x8(%ebp)
  801fb0:	e8 8f f3 ff ff       	call   801344 <fd_lookup>
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	78 11                	js     801fcd <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbf:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801fc5:	39 10                	cmp    %edx,(%eax)
  801fc7:	0f 94 c0             	sete   %al
  801fca:	0f b6 c0             	movzbl %al,%eax
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <opencons>:
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd8:	50                   	push   %eax
  801fd9:	e8 17 f3 ff ff       	call   8012f5 <fd_alloc>
  801fde:	83 c4 10             	add    $0x10,%esp
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	78 3a                	js     80201f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fe5:	83 ec 04             	sub    $0x4,%esp
  801fe8:	68 07 04 00 00       	push   $0x407
  801fed:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff0:	6a 00                	push   $0x0
  801ff2:	e8 2a ee ff ff       	call   800e21 <sys_page_alloc>
  801ff7:	83 c4 10             	add    $0x10,%esp
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	78 21                	js     80201f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802001:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802007:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802013:	83 ec 0c             	sub    $0xc,%esp
  802016:	50                   	push   %eax
  802017:	e8 b2 f2 ff ff       	call   8012ce <fd2num>
  80201c:	83 c4 10             	add    $0x10,%esp
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802027:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80202e:	74 0a                	je     80203a <set_pgfault_handler+0x19>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    
		int r = sys_page_alloc(0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P);	//为当前进程分配异常栈
  80203a:	83 ec 04             	sub    $0x4,%esp
  80203d:	6a 07                	push   $0x7
  80203f:	68 00 f0 bf ee       	push   $0xeebff000
  802044:	6a 00                	push   $0x0
  802046:	e8 d6 ed ff ff       	call   800e21 <sys_page_alloc>
		if (r < 0) {
  80204b:	83 c4 10             	add    $0x10,%esp
  80204e:	85 c0                	test   %eax,%eax
  802050:	78 14                	js     802066 <set_pgfault_handler+0x45>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
  802052:	83 ec 08             	sub    $0x8,%esp
  802055:	68 7a 20 80 00       	push   $0x80207a
  80205a:	6a 00                	push   $0x0
  80205c:	e8 0b ef ff ff       	call   800f6c <sys_env_set_pgfault_upcall>
  802061:	83 c4 10             	add    $0x10,%esp
  802064:	eb ca                	jmp    802030 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler:sys_page_alloc failed");;
  802066:	83 ec 04             	sub    $0x4,%esp
  802069:	68 70 2a 80 00       	push   $0x802a70
  80206e:	6a 22                	push   $0x22
  802070:	68 9c 2a 80 00       	push   $0x802a9c
  802075:	e8 b4 e2 ff ff       	call   80032e <_panic>

0080207a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80207a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80207b:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax				//调用页处理函数
  802080:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802082:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp			//跳过utf_fault_va和utf_err
  802085:	83 c4 08             	add    $0x8,%esp
	movl 40(%esp), %eax 	//保存中断发生时的esp到eax
  802088:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl 32(%esp), %ecx 	//保存终端发生时的eip到ecx
  80208c:	8b 4c 24 20          	mov    0x20(%esp),%ecx
	movl %ecx, -4(%eax) 	//将中断发生时的esp值亚入到到原来的栈中
  802090:	89 48 fc             	mov    %ecx,-0x4(%eax)
	popal
  802093:	61                   	popa   
	addl $4, %esp			//跳过eip
  802094:	83 c4 04             	add    $0x4,%esp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  802097:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802098:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	lea -4(%esp), %esp		//因为之前压入了eip的值但是没有减esp的值，所以现在需要将esp寄存器中的值减4
  802099:	8d 64 24 fc          	lea    -0x4(%esp),%esp
  80209d:	c3                   	ret    

0080209e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	56                   	push   %esi
  8020a2:	53                   	push   %ebx
  8020a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8020a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  8020ac:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  8020ae:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8020b3:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  8020b6:	83 ec 0c             	sub    $0xc,%esp
  8020b9:	50                   	push   %eax
  8020ba:	e8 12 ef ff ff       	call   800fd1 <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  8020bf:	83 c4 10             	add    $0x10,%esp
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	78 2b                	js     8020f1 <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  8020c6:	85 f6                	test   %esi,%esi
  8020c8:	74 0a                	je     8020d4 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8020ca:	a1 04 40 80 00       	mov    0x804004,%eax
  8020cf:	8b 40 74             	mov    0x74(%eax),%eax
  8020d2:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  8020d4:	85 db                	test   %ebx,%ebx
  8020d6:	74 0a                	je     8020e2 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8020d8:	a1 04 40 80 00       	mov    0x804004,%eax
  8020dd:	8b 40 78             	mov    0x78(%eax),%eax
  8020e0:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  8020e2:	a1 04 40 80 00       	mov    0x804004,%eax
  8020e7:	8b 40 70             	mov    0x70(%eax),%eax
}
  8020ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ed:	5b                   	pop    %ebx
  8020ee:	5e                   	pop    %esi
  8020ef:	5d                   	pop    %ebp
  8020f0:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8020f1:	85 f6                	test   %esi,%esi
  8020f3:	74 06                	je     8020fb <ipc_recv+0x5d>
  8020f5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  8020fb:	85 db                	test   %ebx,%ebx
  8020fd:	74 eb                	je     8020ea <ipc_recv+0x4c>
  8020ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802105:	eb e3                	jmp    8020ea <ipc_recv+0x4c>

00802107 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	57                   	push   %edi
  80210b:	56                   	push   %esi
  80210c:	53                   	push   %ebx
  80210d:	83 ec 0c             	sub    $0xc,%esp
  802110:	8b 7d 08             	mov    0x8(%ebp),%edi
  802113:	8b 75 0c             	mov    0xc(%ebp),%esi
  802116:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  802119:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  80211b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802120:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  802123:	ff 75 14             	pushl  0x14(%ebp)
  802126:	53                   	push   %ebx
  802127:	56                   	push   %esi
  802128:	57                   	push   %edi
  802129:	e8 80 ee ff ff       	call   800fae <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	85 c0                	test   %eax,%eax
  802133:	74 1e                	je     802153 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  802135:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802138:	75 07                	jne    802141 <ipc_send+0x3a>
			sys_yield();
  80213a:	e8 c3 ec ff ff       	call   800e02 <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  80213f:	eb e2                	jmp    802123 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  802141:	50                   	push   %eax
  802142:	68 aa 2a 80 00       	push   $0x802aaa
  802147:	6a 41                	push   $0x41
  802149:	68 b8 2a 80 00       	push   $0x802ab8
  80214e:	e8 db e1 ff ff       	call   80032e <_panic>
		}
	}
}
  802153:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802156:	5b                   	pop    %ebx
  802157:	5e                   	pop    %esi
  802158:	5f                   	pop    %edi
  802159:	5d                   	pop    %ebp
  80215a:	c3                   	ret    

0080215b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802161:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802166:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802169:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80216f:	8b 52 50             	mov    0x50(%edx),%edx
  802172:	39 ca                	cmp    %ecx,%edx
  802174:	74 11                	je     802187 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802176:	83 c0 01             	add    $0x1,%eax
  802179:	3d 00 04 00 00       	cmp    $0x400,%eax
  80217e:	75 e6                	jne    802166 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802180:	b8 00 00 00 00       	mov    $0x0,%eax
  802185:	eb 0b                	jmp    802192 <ipc_find_env+0x37>
			return envs[i].env_id;
  802187:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80218a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80218f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802192:	5d                   	pop    %ebp
  802193:	c3                   	ret    

00802194 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80219a:	89 d0                	mov    %edx,%eax
  80219c:	c1 e8 16             	shr    $0x16,%eax
  80219f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8021a6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8021ab:	f6 c1 01             	test   $0x1,%cl
  8021ae:	74 1d                	je     8021cd <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8021b0:	c1 ea 0c             	shr    $0xc,%edx
  8021b3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8021ba:	f6 c2 01             	test   $0x1,%dl
  8021bd:	74 0e                	je     8021cd <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021bf:	c1 ea 0c             	shr    $0xc,%edx
  8021c2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8021c9:	ef 
  8021ca:	0f b7 c0             	movzwl %ax,%eax
}
  8021cd:	5d                   	pop    %ebp
  8021ce:	c3                   	ret    
  8021cf:	90                   	nop

008021d0 <__udivdi3>:
  8021d0:	55                   	push   %ebp
  8021d1:	57                   	push   %edi
  8021d2:	56                   	push   %esi
  8021d3:	53                   	push   %ebx
  8021d4:	83 ec 1c             	sub    $0x1c,%esp
  8021d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021e7:	85 d2                	test   %edx,%edx
  8021e9:	75 35                	jne    802220 <__udivdi3+0x50>
  8021eb:	39 f3                	cmp    %esi,%ebx
  8021ed:	0f 87 bd 00 00 00    	ja     8022b0 <__udivdi3+0xe0>
  8021f3:	85 db                	test   %ebx,%ebx
  8021f5:	89 d9                	mov    %ebx,%ecx
  8021f7:	75 0b                	jne    802204 <__udivdi3+0x34>
  8021f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fe:	31 d2                	xor    %edx,%edx
  802200:	f7 f3                	div    %ebx
  802202:	89 c1                	mov    %eax,%ecx
  802204:	31 d2                	xor    %edx,%edx
  802206:	89 f0                	mov    %esi,%eax
  802208:	f7 f1                	div    %ecx
  80220a:	89 c6                	mov    %eax,%esi
  80220c:	89 e8                	mov    %ebp,%eax
  80220e:	89 f7                	mov    %esi,%edi
  802210:	f7 f1                	div    %ecx
  802212:	89 fa                	mov    %edi,%edx
  802214:	83 c4 1c             	add    $0x1c,%esp
  802217:	5b                   	pop    %ebx
  802218:	5e                   	pop    %esi
  802219:	5f                   	pop    %edi
  80221a:	5d                   	pop    %ebp
  80221b:	c3                   	ret    
  80221c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802220:	39 f2                	cmp    %esi,%edx
  802222:	77 7c                	ja     8022a0 <__udivdi3+0xd0>
  802224:	0f bd fa             	bsr    %edx,%edi
  802227:	83 f7 1f             	xor    $0x1f,%edi
  80222a:	0f 84 98 00 00 00    	je     8022c8 <__udivdi3+0xf8>
  802230:	89 f9                	mov    %edi,%ecx
  802232:	b8 20 00 00 00       	mov    $0x20,%eax
  802237:	29 f8                	sub    %edi,%eax
  802239:	d3 e2                	shl    %cl,%edx
  80223b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80223f:	89 c1                	mov    %eax,%ecx
  802241:	89 da                	mov    %ebx,%edx
  802243:	d3 ea                	shr    %cl,%edx
  802245:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802249:	09 d1                	or     %edx,%ecx
  80224b:	89 f2                	mov    %esi,%edx
  80224d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802251:	89 f9                	mov    %edi,%ecx
  802253:	d3 e3                	shl    %cl,%ebx
  802255:	89 c1                	mov    %eax,%ecx
  802257:	d3 ea                	shr    %cl,%edx
  802259:	89 f9                	mov    %edi,%ecx
  80225b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80225f:	d3 e6                	shl    %cl,%esi
  802261:	89 eb                	mov    %ebp,%ebx
  802263:	89 c1                	mov    %eax,%ecx
  802265:	d3 eb                	shr    %cl,%ebx
  802267:	09 de                	or     %ebx,%esi
  802269:	89 f0                	mov    %esi,%eax
  80226b:	f7 74 24 08          	divl   0x8(%esp)
  80226f:	89 d6                	mov    %edx,%esi
  802271:	89 c3                	mov    %eax,%ebx
  802273:	f7 64 24 0c          	mull   0xc(%esp)
  802277:	39 d6                	cmp    %edx,%esi
  802279:	72 0c                	jb     802287 <__udivdi3+0xb7>
  80227b:	89 f9                	mov    %edi,%ecx
  80227d:	d3 e5                	shl    %cl,%ebp
  80227f:	39 c5                	cmp    %eax,%ebp
  802281:	73 5d                	jae    8022e0 <__udivdi3+0x110>
  802283:	39 d6                	cmp    %edx,%esi
  802285:	75 59                	jne    8022e0 <__udivdi3+0x110>
  802287:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80228a:	31 ff                	xor    %edi,%edi
  80228c:	89 fa                	mov    %edi,%edx
  80228e:	83 c4 1c             	add    $0x1c,%esp
  802291:	5b                   	pop    %ebx
  802292:	5e                   	pop    %esi
  802293:	5f                   	pop    %edi
  802294:	5d                   	pop    %ebp
  802295:	c3                   	ret    
  802296:	8d 76 00             	lea    0x0(%esi),%esi
  802299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8022a0:	31 ff                	xor    %edi,%edi
  8022a2:	31 c0                	xor    %eax,%eax
  8022a4:	89 fa                	mov    %edi,%edx
  8022a6:	83 c4 1c             	add    $0x1c,%esp
  8022a9:	5b                   	pop    %ebx
  8022aa:	5e                   	pop    %esi
  8022ab:	5f                   	pop    %edi
  8022ac:	5d                   	pop    %ebp
  8022ad:	c3                   	ret    
  8022ae:	66 90                	xchg   %ax,%ax
  8022b0:	31 ff                	xor    %edi,%edi
  8022b2:	89 e8                	mov    %ebp,%eax
  8022b4:	89 f2                	mov    %esi,%edx
  8022b6:	f7 f3                	div    %ebx
  8022b8:	89 fa                	mov    %edi,%edx
  8022ba:	83 c4 1c             	add    $0x1c,%esp
  8022bd:	5b                   	pop    %ebx
  8022be:	5e                   	pop    %esi
  8022bf:	5f                   	pop    %edi
  8022c0:	5d                   	pop    %ebp
  8022c1:	c3                   	ret    
  8022c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022c8:	39 f2                	cmp    %esi,%edx
  8022ca:	72 06                	jb     8022d2 <__udivdi3+0x102>
  8022cc:	31 c0                	xor    %eax,%eax
  8022ce:	39 eb                	cmp    %ebp,%ebx
  8022d0:	77 d2                	ja     8022a4 <__udivdi3+0xd4>
  8022d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d7:	eb cb                	jmp    8022a4 <__udivdi3+0xd4>
  8022d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022e0:	89 d8                	mov    %ebx,%eax
  8022e2:	31 ff                	xor    %edi,%edi
  8022e4:	eb be                	jmp    8022a4 <__udivdi3+0xd4>
  8022e6:	66 90                	xchg   %ax,%ax
  8022e8:	66 90                	xchg   %ax,%ax
  8022ea:	66 90                	xchg   %ax,%ax
  8022ec:	66 90                	xchg   %ax,%ax
  8022ee:	66 90                	xchg   %ax,%ax

008022f0 <__umoddi3>:
  8022f0:	55                   	push   %ebp
  8022f1:	57                   	push   %edi
  8022f2:	56                   	push   %esi
  8022f3:	53                   	push   %ebx
  8022f4:	83 ec 1c             	sub    $0x1c,%esp
  8022f7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8022fb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022ff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802303:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802307:	85 ed                	test   %ebp,%ebp
  802309:	89 f0                	mov    %esi,%eax
  80230b:	89 da                	mov    %ebx,%edx
  80230d:	75 19                	jne    802328 <__umoddi3+0x38>
  80230f:	39 df                	cmp    %ebx,%edi
  802311:	0f 86 b1 00 00 00    	jbe    8023c8 <__umoddi3+0xd8>
  802317:	f7 f7                	div    %edi
  802319:	89 d0                	mov    %edx,%eax
  80231b:	31 d2                	xor    %edx,%edx
  80231d:	83 c4 1c             	add    $0x1c,%esp
  802320:	5b                   	pop    %ebx
  802321:	5e                   	pop    %esi
  802322:	5f                   	pop    %edi
  802323:	5d                   	pop    %ebp
  802324:	c3                   	ret    
  802325:	8d 76 00             	lea    0x0(%esi),%esi
  802328:	39 dd                	cmp    %ebx,%ebp
  80232a:	77 f1                	ja     80231d <__umoddi3+0x2d>
  80232c:	0f bd cd             	bsr    %ebp,%ecx
  80232f:	83 f1 1f             	xor    $0x1f,%ecx
  802332:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802336:	0f 84 b4 00 00 00    	je     8023f0 <__umoddi3+0x100>
  80233c:	b8 20 00 00 00       	mov    $0x20,%eax
  802341:	89 c2                	mov    %eax,%edx
  802343:	8b 44 24 04          	mov    0x4(%esp),%eax
  802347:	29 c2                	sub    %eax,%edx
  802349:	89 c1                	mov    %eax,%ecx
  80234b:	89 f8                	mov    %edi,%eax
  80234d:	d3 e5                	shl    %cl,%ebp
  80234f:	89 d1                	mov    %edx,%ecx
  802351:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802355:	d3 e8                	shr    %cl,%eax
  802357:	09 c5                	or     %eax,%ebp
  802359:	8b 44 24 04          	mov    0x4(%esp),%eax
  80235d:	89 c1                	mov    %eax,%ecx
  80235f:	d3 e7                	shl    %cl,%edi
  802361:	89 d1                	mov    %edx,%ecx
  802363:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802367:	89 df                	mov    %ebx,%edi
  802369:	d3 ef                	shr    %cl,%edi
  80236b:	89 c1                	mov    %eax,%ecx
  80236d:	89 f0                	mov    %esi,%eax
  80236f:	d3 e3                	shl    %cl,%ebx
  802371:	89 d1                	mov    %edx,%ecx
  802373:	89 fa                	mov    %edi,%edx
  802375:	d3 e8                	shr    %cl,%eax
  802377:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80237c:	09 d8                	or     %ebx,%eax
  80237e:	f7 f5                	div    %ebp
  802380:	d3 e6                	shl    %cl,%esi
  802382:	89 d1                	mov    %edx,%ecx
  802384:	f7 64 24 08          	mull   0x8(%esp)
  802388:	39 d1                	cmp    %edx,%ecx
  80238a:	89 c3                	mov    %eax,%ebx
  80238c:	89 d7                	mov    %edx,%edi
  80238e:	72 06                	jb     802396 <__umoddi3+0xa6>
  802390:	75 0e                	jne    8023a0 <__umoddi3+0xb0>
  802392:	39 c6                	cmp    %eax,%esi
  802394:	73 0a                	jae    8023a0 <__umoddi3+0xb0>
  802396:	2b 44 24 08          	sub    0x8(%esp),%eax
  80239a:	19 ea                	sbb    %ebp,%edx
  80239c:	89 d7                	mov    %edx,%edi
  80239e:	89 c3                	mov    %eax,%ebx
  8023a0:	89 ca                	mov    %ecx,%edx
  8023a2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8023a7:	29 de                	sub    %ebx,%esi
  8023a9:	19 fa                	sbb    %edi,%edx
  8023ab:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8023af:	89 d0                	mov    %edx,%eax
  8023b1:	d3 e0                	shl    %cl,%eax
  8023b3:	89 d9                	mov    %ebx,%ecx
  8023b5:	d3 ee                	shr    %cl,%esi
  8023b7:	d3 ea                	shr    %cl,%edx
  8023b9:	09 f0                	or     %esi,%eax
  8023bb:	83 c4 1c             	add    $0x1c,%esp
  8023be:	5b                   	pop    %ebx
  8023bf:	5e                   	pop    %esi
  8023c0:	5f                   	pop    %edi
  8023c1:	5d                   	pop    %ebp
  8023c2:	c3                   	ret    
  8023c3:	90                   	nop
  8023c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023c8:	85 ff                	test   %edi,%edi
  8023ca:	89 f9                	mov    %edi,%ecx
  8023cc:	75 0b                	jne    8023d9 <__umoddi3+0xe9>
  8023ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d3:	31 d2                	xor    %edx,%edx
  8023d5:	f7 f7                	div    %edi
  8023d7:	89 c1                	mov    %eax,%ecx
  8023d9:	89 d8                	mov    %ebx,%eax
  8023db:	31 d2                	xor    %edx,%edx
  8023dd:	f7 f1                	div    %ecx
  8023df:	89 f0                	mov    %esi,%eax
  8023e1:	f7 f1                	div    %ecx
  8023e3:	e9 31 ff ff ff       	jmp    802319 <__umoddi3+0x29>
  8023e8:	90                   	nop
  8023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023f0:	39 dd                	cmp    %ebx,%ebp
  8023f2:	72 08                	jb     8023fc <__umoddi3+0x10c>
  8023f4:	39 f7                	cmp    %esi,%edi
  8023f6:	0f 87 21 ff ff ff    	ja     80231d <__umoddi3+0x2d>
  8023fc:	89 da                	mov    %ebx,%edx
  8023fe:	89 f0                	mov    %esi,%eax
  802400:	29 f8                	sub    %edi,%eax
  802402:	19 ea                	sbb    %ebp,%edx
  802404:	e9 14 ff ff ff       	jmp    80231d <__umoddi3+0x2d>
