
obj/user/testshell.debug：     文件格式 elf32-i386


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
  80002c:	e8 5f 04 00 00       	call   800490 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 84 00 00 00    	sub    $0x84,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	53                   	push   %ebx
  800049:	56                   	push   %esi
  80004a:	e8 70 18 00 00       	call   8018bf <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 66 18 00 00       	call   8018bf <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 c0 29 80 00 	movl   $0x8029c0,(%esp)
  800060:	e8 5e 05 00 00       	call   8005c3 <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 2b 2a 80 00 	movl   $0x802a2b,(%esp)
  80006c:	e8 52 05 00 00       	call   8005c3 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	eb 0d                	jmp    800086 <wrong+0x53>
		sys_cputs(buf, n);
  800079:	83 ec 08             	sub    $0x8,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	e8 9c 0e 00 00       	call   800f1f <sys_cputs>
  800083:	83 c4 10             	add    $0x10,%esp
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 63                	push   $0x63
  80008b:	53                   	push   %ebx
  80008c:	57                   	push   %edi
  80008d:	e8 dd 16 00 00       	call   80176f <read>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	85 c0                	test   %eax,%eax
  800097:	7f e0                	jg     800079 <wrong+0x46>
	cprintf("===\ngot:\n===\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 3a 2a 80 00       	push   $0x802a3a
  8000a1:	e8 1d 05 00 00       	call   8005c3 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000ac:	eb 0d                	jmp    8000bb <wrong+0x88>
		sys_cputs(buf, n);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	50                   	push   %eax
  8000b2:	53                   	push   %ebx
  8000b3:	e8 67 0e 00 00       	call   800f1f <sys_cputs>
  8000b8:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	6a 63                	push   $0x63
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 a8 16 00 00       	call   80176f <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 35 2a 80 00       	push   $0x802a35
  8000d6:	e8 e8 04 00 00       	call   8005c3 <cprintf>
	exit();
  8000db:	e8 f6 03 00 00       	call   8004d6 <exit>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <umain>:
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 38             	sub    $0x38,%esp
	close(0);
  8000f4:	6a 00                	push   $0x0
  8000f6:	e8 38 15 00 00       	call   801633 <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 2c 15 00 00       	call   801633 <close>
	opencons();
  800107:	e8 32 03 00 00       	call   80043e <opencons>
	opencons();
  80010c:	e8 2d 03 00 00       	call   80043e <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 48 2a 80 00       	push   $0x802a48
  80011b:	e8 fd 1a 00 00       	call   801c1d <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e9 00 00 00    	js     800216 <umain+0x12b>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 c8 22 00 00       	call   802401 <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e4 00 00 00    	js     800228 <umain+0x13d>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 e4 29 80 00       	push   $0x8029e4
  80014f:	e8 6f 04 00 00       	call   8005c3 <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 43 11 00 00       	call   80129c <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d6 00 00 00    	js     80023a <umain+0x14f>
	if (r == 0) {
  800164:	85 c0                	test   %eax,%eax
  800166:	75 6f                	jne    8001d7 <umain+0xec>
		dup(rfd, 0);
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	6a 00                	push   $0x0
  80016d:	53                   	push   %ebx
  80016e:	e8 10 15 00 00       	call   801683 <dup>
		dup(wfd, 1);
  800173:	83 c4 08             	add    $0x8,%esp
  800176:	6a 01                	push   $0x1
  800178:	56                   	push   %esi
  800179:	e8 05 15 00 00       	call   801683 <dup>
		close(rfd);
  80017e:	89 1c 24             	mov    %ebx,(%esp)
  800181:	e8 ad 14 00 00       	call   801633 <close>
		close(wfd);
  800186:	89 34 24             	mov    %esi,(%esp)
  800189:	e8 a5 14 00 00       	call   801633 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018e:	6a 00                	push   $0x0
  800190:	68 85 2a 80 00       	push   $0x802a85
  800195:	68 52 2a 80 00       	push   $0x802a52
  80019a:	68 88 2a 80 00       	push   $0x802a88
  80019f:	e8 0f 20 00 00       	call   8021b3 <spawnl>
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	83 c4 20             	add    $0x20,%esp
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	0f 88 9b 00 00 00    	js     80024c <umain+0x161>
		close(0);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	6a 00                	push   $0x0
  8001b6:	e8 78 14 00 00       	call   801633 <close>
		close(1);
  8001bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c2:	e8 6c 14 00 00       	call   801633 <close>
		wait(r);
  8001c7:	89 3c 24             	mov    %edi,(%esp)
  8001ca:	e8 ae 23 00 00       	call   80257d <wait>
		exit();
  8001cf:	e8 02 03 00 00       	call   8004d6 <exit>
  8001d4:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	53                   	push   %ebx
  8001db:	e8 53 14 00 00       	call   801633 <close>
	close(wfd);
  8001e0:	89 34 24             	mov    %esi,(%esp)
  8001e3:	e8 4b 14 00 00       	call   801633 <close>
	rfd = pfds[0];
  8001e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001ee:	83 c4 08             	add    $0x8,%esp
  8001f1:	6a 00                	push   $0x0
  8001f3:	68 96 2a 80 00       	push   $0x802a96
  8001f8:	e8 20 1a 00 00       	call   801c1d <open>
  8001fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	85 c0                	test   %eax,%eax
  800205:	78 57                	js     80025e <umain+0x173>
  800207:	be 01 00 00 00       	mov    $0x1,%esi
	nloff = 0;
  80020c:	bf 00 00 00 00       	mov    $0x0,%edi
  800211:	e9 9a 00 00 00       	jmp    8002b0 <umain+0x1c5>
		panic("open testshell.sh: %e", rfd);
  800216:	50                   	push   %eax
  800217:	68 55 2a 80 00       	push   $0x802a55
  80021c:	6a 13                	push   $0x13
  80021e:	68 6b 2a 80 00       	push   $0x802a6b
  800223:	e8 c0 02 00 00       	call   8004e8 <_panic>
		panic("pipe: %e", wfd);
  800228:	50                   	push   %eax
  800229:	68 7c 2a 80 00       	push   $0x802a7c
  80022e:	6a 15                	push   $0x15
  800230:	68 6b 2a 80 00       	push   $0x802a6b
  800235:	e8 ae 02 00 00       	call   8004e8 <_panic>
		panic("fork: %e", r);
  80023a:	50                   	push   %eax
  80023b:	68 a5 2e 80 00       	push   $0x802ea5
  800240:	6a 1a                	push   $0x1a
  800242:	68 6b 2a 80 00       	push   $0x802a6b
  800247:	e8 9c 02 00 00       	call   8004e8 <_panic>
			panic("spawn: %e", r);
  80024c:	50                   	push   %eax
  80024d:	68 8c 2a 80 00       	push   $0x802a8c
  800252:	6a 21                	push   $0x21
  800254:	68 6b 2a 80 00       	push   $0x802a6b
  800259:	e8 8a 02 00 00       	call   8004e8 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025e:	50                   	push   %eax
  80025f:	68 08 2a 80 00       	push   $0x802a08
  800264:	6a 2c                	push   $0x2c
  800266:	68 6b 2a 80 00       	push   $0x802a6b
  80026b:	e8 78 02 00 00       	call   8004e8 <_panic>
			panic("reading testshell.out: %e", n1);
  800270:	53                   	push   %ebx
  800271:	68 a4 2a 80 00       	push   $0x802aa4
  800276:	6a 33                	push   $0x33
  800278:	68 6b 2a 80 00       	push   $0x802a6b
  80027d:	e8 66 02 00 00       	call   8004e8 <_panic>
			panic("reading testshell.key: %e", n2);
  800282:	50                   	push   %eax
  800283:	68 be 2a 80 00       	push   $0x802abe
  800288:	6a 35                	push   $0x35
  80028a:	68 6b 2a 80 00       	push   $0x802a6b
  80028f:	e8 54 02 00 00       	call   8004e8 <_panic>
			wrong(rfd, kfd, nloff);
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	57                   	push   %edi
  800298:	ff 75 d4             	pushl  -0x2c(%ebp)
  80029b:	ff 75 d0             	pushl  -0x30(%ebp)
  80029e:	e8 90 fd ff ff       	call   800033 <wrong>
  8002a3:	83 c4 10             	add    $0x10,%esp
			nloff = off+1;
  8002a6:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002aa:	0f 44 fe             	cmove  %esi,%edi
  8002ad:	83 c6 01             	add    $0x1,%esi
		n1 = read(rfd, &c1, 1);
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	6a 01                	push   $0x1
  8002b5:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002b8:	50                   	push   %eax
  8002b9:	ff 75 d0             	pushl  -0x30(%ebp)
  8002bc:	e8 ae 14 00 00       	call   80176f <read>
  8002c1:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c3:	83 c4 0c             	add    $0xc,%esp
  8002c6:	6a 01                	push   $0x1
  8002c8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002cb:	50                   	push   %eax
  8002cc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cf:	e8 9b 14 00 00       	call   80176f <read>
		if (n1 < 0)
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	85 db                	test   %ebx,%ebx
  8002d9:	78 95                	js     800270 <umain+0x185>
		if (n2 < 0)
  8002db:	85 c0                	test   %eax,%eax
  8002dd:	78 a3                	js     800282 <umain+0x197>
		if (n1 == 0 && n2 == 0)
  8002df:	89 da                	mov    %ebx,%edx
  8002e1:	09 c2                	or     %eax,%edx
  8002e3:	74 15                	je     8002fa <umain+0x20f>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8002e5:	83 fb 01             	cmp    $0x1,%ebx
  8002e8:	75 aa                	jne    800294 <umain+0x1a9>
  8002ea:	83 f8 01             	cmp    $0x1,%eax
  8002ed:	75 a5                	jne    800294 <umain+0x1a9>
  8002ef:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  8002f3:	38 45 e7             	cmp    %al,-0x19(%ebp)
  8002f6:	75 9c                	jne    800294 <umain+0x1a9>
  8002f8:	eb ac                	jmp    8002a6 <umain+0x1bb>
	cprintf("shell ran correctly\n");
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 d8 2a 80 00       	push   $0x802ad8
  800302:	e8 bc 02 00 00       	call   8005c3 <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800307:	cc                   	int3   
}
  800308:	83 c4 10             	add    $0x10,%esp
  80030b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030e:	5b                   	pop    %ebx
  80030f:	5e                   	pop    %esi
  800310:	5f                   	pop    %edi
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    

00800313 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	5d                   	pop    %ebp
  80031c:	c3                   	ret    

0080031d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800323:	68 ed 2a 80 00       	push   $0x802aed
  800328:	ff 75 0c             	pushl  0xc(%ebp)
  80032b:	e8 b2 08 00 00       	call   800be2 <strcpy>
	return 0;
}
  800330:	b8 00 00 00 00       	mov    $0x0,%eax
  800335:	c9                   	leave  
  800336:	c3                   	ret    

00800337 <devcons_write>:
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	57                   	push   %edi
  80033b:	56                   	push   %esi
  80033c:	53                   	push   %ebx
  80033d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800343:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800348:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80034e:	eb 2f                	jmp    80037f <devcons_write+0x48>
		m = n - tot;
  800350:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800353:	29 f3                	sub    %esi,%ebx
  800355:	83 fb 7f             	cmp    $0x7f,%ebx
  800358:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80035d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	53                   	push   %ebx
  800364:	89 f0                	mov    %esi,%eax
  800366:	03 45 0c             	add    0xc(%ebp),%eax
  800369:	50                   	push   %eax
  80036a:	57                   	push   %edi
  80036b:	e8 00 0a 00 00       	call   800d70 <memmove>
		sys_cputs(buf, m);
  800370:	83 c4 08             	add    $0x8,%esp
  800373:	53                   	push   %ebx
  800374:	57                   	push   %edi
  800375:	e8 a5 0b 00 00       	call   800f1f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80037a:	01 de                	add    %ebx,%esi
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	3b 75 10             	cmp    0x10(%ebp),%esi
  800382:	72 cc                	jb     800350 <devcons_write+0x19>
}
  800384:	89 f0                	mov    %esi,%eax
  800386:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800389:	5b                   	pop    %ebx
  80038a:	5e                   	pop    %esi
  80038b:	5f                   	pop    %edi
  80038c:	5d                   	pop    %ebp
  80038d:	c3                   	ret    

0080038e <devcons_read>:
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800399:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80039d:	75 07                	jne    8003a6 <devcons_read+0x18>
}
  80039f:	c9                   	leave  
  8003a0:	c3                   	ret    
		sys_yield();
  8003a1:	e8 16 0c 00 00       	call   800fbc <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8003a6:	e8 92 0b 00 00       	call   800f3d <sys_cgetc>
  8003ab:	85 c0                	test   %eax,%eax
  8003ad:	74 f2                	je     8003a1 <devcons_read+0x13>
	if (c < 0)
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	78 ec                	js     80039f <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8003b3:	83 f8 04             	cmp    $0x4,%eax
  8003b6:	74 0c                	je     8003c4 <devcons_read+0x36>
	*(char*)vbuf = c;
  8003b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bb:	88 02                	mov    %al,(%edx)
	return 1;
  8003bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8003c2:	eb db                	jmp    80039f <devcons_read+0x11>
		return 0;
  8003c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c9:	eb d4                	jmp    80039f <devcons_read+0x11>

008003cb <cputchar>:
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
  8003ce:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8003d7:	6a 01                	push   $0x1
  8003d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003dc:	50                   	push   %eax
  8003dd:	e8 3d 0b 00 00       	call   800f1f <sys_cputs>
}
  8003e2:	83 c4 10             	add    $0x10,%esp
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <getchar>:
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8003ed:	6a 01                	push   $0x1
  8003ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003f2:	50                   	push   %eax
  8003f3:	6a 00                	push   $0x0
  8003f5:	e8 75 13 00 00       	call   80176f <read>
	if (r < 0)
  8003fa:	83 c4 10             	add    $0x10,%esp
  8003fd:	85 c0                	test   %eax,%eax
  8003ff:	78 08                	js     800409 <getchar+0x22>
	if (r < 1)
  800401:	85 c0                	test   %eax,%eax
  800403:	7e 06                	jle    80040b <getchar+0x24>
	return c;
  800405:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800409:	c9                   	leave  
  80040a:	c3                   	ret    
		return -E_EOF;
  80040b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800410:	eb f7                	jmp    800409 <getchar+0x22>

00800412 <iscons>:
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800418:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80041b:	50                   	push   %eax
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	e8 da 10 00 00       	call   8014fe <fd_lookup>
  800424:	83 c4 10             	add    $0x10,%esp
  800427:	85 c0                	test   %eax,%eax
  800429:	78 11                	js     80043c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80042b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80042e:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800434:	39 10                	cmp    %edx,(%eax)
  800436:	0f 94 c0             	sete   %al
  800439:	0f b6 c0             	movzbl %al,%eax
}
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <opencons>:
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800444:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800447:	50                   	push   %eax
  800448:	e8 62 10 00 00       	call   8014af <fd_alloc>
  80044d:	83 c4 10             	add    $0x10,%esp
  800450:	85 c0                	test   %eax,%eax
  800452:	78 3a                	js     80048e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800454:	83 ec 04             	sub    $0x4,%esp
  800457:	68 07 04 00 00       	push   $0x407
  80045c:	ff 75 f4             	pushl  -0xc(%ebp)
  80045f:	6a 00                	push   $0x0
  800461:	e8 75 0b 00 00       	call   800fdb <sys_page_alloc>
  800466:	83 c4 10             	add    $0x10,%esp
  800469:	85 c0                	test   %eax,%eax
  80046b:	78 21                	js     80048e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80046d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800470:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800476:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800482:	83 ec 0c             	sub    $0xc,%esp
  800485:	50                   	push   %eax
  800486:	e8 fd 0f 00 00       	call   801488 <fd2num>
  80048b:	83 c4 10             	add    $0x10,%esp
}
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	56                   	push   %esi
  800494:	53                   	push   %ebx
  800495:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800498:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  80049b:	e8 fd 0a 00 00       	call   800f9d <sys_getenvid>
	thisenv = envs + ENVX(envid);
  8004a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004a5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004ad:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004b2:	85 db                	test   %ebx,%ebx
  8004b4:	7e 07                	jle    8004bd <libmain+0x2d>
		binaryname = argv[0];
  8004b6:	8b 06                	mov    (%esi),%eax
  8004b8:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	56                   	push   %esi
  8004c1:	53                   	push   %ebx
  8004c2:	e8 24 fc ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8004c7:	e8 0a 00 00 00       	call   8004d6 <exit>
}
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004d2:	5b                   	pop    %ebx
  8004d3:	5e                   	pop    %esi
  8004d4:	5d                   	pop    %ebp
  8004d5:	c3                   	ret    

008004d6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8004dc:	6a 00                	push   $0x0
  8004de:	e8 79 0a 00 00       	call   800f5c <sys_env_destroy>
}
  8004e3:	83 c4 10             	add    $0x10,%esp
  8004e6:	c9                   	leave  
  8004e7:	c3                   	ret    

008004e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
  8004eb:	56                   	push   %esi
  8004ec:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8004ed:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004f0:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  8004f6:	e8 a2 0a 00 00       	call   800f9d <sys_getenvid>
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	ff 75 0c             	pushl  0xc(%ebp)
  800501:	ff 75 08             	pushl  0x8(%ebp)
  800504:	56                   	push   %esi
  800505:	50                   	push   %eax
  800506:	68 04 2b 80 00       	push   $0x802b04
  80050b:	e8 b3 00 00 00       	call   8005c3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800510:	83 c4 18             	add    $0x18,%esp
  800513:	53                   	push   %ebx
  800514:	ff 75 10             	pushl  0x10(%ebp)
  800517:	e8 56 00 00 00       	call   800572 <vcprintf>
	cprintf("\n");
  80051c:	c7 04 24 38 2a 80 00 	movl   $0x802a38,(%esp)
  800523:	e8 9b 00 00 00       	call   8005c3 <cprintf>
  800528:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80052b:	cc                   	int3   
  80052c:	eb fd                	jmp    80052b <_panic+0x43>

0080052e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80052e:	55                   	push   %ebp
  80052f:	89 e5                	mov    %esp,%ebp
  800531:	53                   	push   %ebx
  800532:	83 ec 04             	sub    $0x4,%esp
  800535:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800538:	8b 13                	mov    (%ebx),%edx
  80053a:	8d 42 01             	lea    0x1(%edx),%eax
  80053d:	89 03                	mov    %eax,(%ebx)
  80053f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800542:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800546:	3d ff 00 00 00       	cmp    $0xff,%eax
  80054b:	74 09                	je     800556 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80054d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800551:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800554:	c9                   	leave  
  800555:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	68 ff 00 00 00       	push   $0xff
  80055e:	8d 43 08             	lea    0x8(%ebx),%eax
  800561:	50                   	push   %eax
  800562:	e8 b8 09 00 00       	call   800f1f <sys_cputs>
		b->idx = 0;
  800567:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	eb db                	jmp    80054d <putch+0x1f>

00800572 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800572:	55                   	push   %ebp
  800573:	89 e5                	mov    %esp,%ebp
  800575:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80057b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800582:	00 00 00 
	b.cnt = 0;
  800585:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80058c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80058f:	ff 75 0c             	pushl  0xc(%ebp)
  800592:	ff 75 08             	pushl  0x8(%ebp)
  800595:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059b:	50                   	push   %eax
  80059c:	68 2e 05 80 00       	push   $0x80052e
  8005a1:	e8 1a 01 00 00       	call   8006c0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005a6:	83 c4 08             	add    $0x8,%esp
  8005a9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005af:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005b5:	50                   	push   %eax
  8005b6:	e8 64 09 00 00       	call   800f1f <sys_cputs>

	return b.cnt;
}
  8005bb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005c9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005cc:	50                   	push   %eax
  8005cd:	ff 75 08             	pushl  0x8(%ebp)
  8005d0:	e8 9d ff ff ff       	call   800572 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005d5:	c9                   	leave  
  8005d6:	c3                   	ret    

008005d7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005d7:	55                   	push   %ebp
  8005d8:	89 e5                	mov    %esp,%ebp
  8005da:	57                   	push   %edi
  8005db:	56                   	push   %esi
  8005dc:	53                   	push   %ebx
  8005dd:	83 ec 1c             	sub    $0x1c,%esp
  8005e0:	89 c7                	mov    %eax,%edi
  8005e2:	89 d6                	mov    %edx,%esi
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005fb:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8005fe:	39 d3                	cmp    %edx,%ebx
  800600:	72 05                	jb     800607 <printnum+0x30>
  800602:	39 45 10             	cmp    %eax,0x10(%ebp)
  800605:	77 7a                	ja     800681 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800607:	83 ec 0c             	sub    $0xc,%esp
  80060a:	ff 75 18             	pushl  0x18(%ebp)
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800613:	53                   	push   %ebx
  800614:	ff 75 10             	pushl  0x10(%ebp)
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80061d:	ff 75 e0             	pushl  -0x20(%ebp)
  800620:	ff 75 dc             	pushl  -0x24(%ebp)
  800623:	ff 75 d8             	pushl  -0x28(%ebp)
  800626:	e8 55 21 00 00       	call   802780 <__udivdi3>
  80062b:	83 c4 18             	add    $0x18,%esp
  80062e:	52                   	push   %edx
  80062f:	50                   	push   %eax
  800630:	89 f2                	mov    %esi,%edx
  800632:	89 f8                	mov    %edi,%eax
  800634:	e8 9e ff ff ff       	call   8005d7 <printnum>
  800639:	83 c4 20             	add    $0x20,%esp
  80063c:	eb 13                	jmp    800651 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	56                   	push   %esi
  800642:	ff 75 18             	pushl  0x18(%ebp)
  800645:	ff d7                	call   *%edi
  800647:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80064a:	83 eb 01             	sub    $0x1,%ebx
  80064d:	85 db                	test   %ebx,%ebx
  80064f:	7f ed                	jg     80063e <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	56                   	push   %esi
  800655:	83 ec 04             	sub    $0x4,%esp
  800658:	ff 75 e4             	pushl  -0x1c(%ebp)
  80065b:	ff 75 e0             	pushl  -0x20(%ebp)
  80065e:	ff 75 dc             	pushl  -0x24(%ebp)
  800661:	ff 75 d8             	pushl  -0x28(%ebp)
  800664:	e8 37 22 00 00       	call   8028a0 <__umoddi3>
  800669:	83 c4 14             	add    $0x14,%esp
  80066c:	0f be 80 27 2b 80 00 	movsbl 0x802b27(%eax),%eax
  800673:	50                   	push   %eax
  800674:	ff d7                	call   *%edi
}
  800676:	83 c4 10             	add    $0x10,%esp
  800679:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80067c:	5b                   	pop    %ebx
  80067d:	5e                   	pop    %esi
  80067e:	5f                   	pop    %edi
  80067f:	5d                   	pop    %ebp
  800680:	c3                   	ret    
  800681:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800684:	eb c4                	jmp    80064a <printnum+0x73>

00800686 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800686:	55                   	push   %ebp
  800687:	89 e5                	mov    %esp,%ebp
  800689:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80068c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800690:	8b 10                	mov    (%eax),%edx
  800692:	3b 50 04             	cmp    0x4(%eax),%edx
  800695:	73 0a                	jae    8006a1 <sprintputch+0x1b>
		*b->buf++ = ch;
  800697:	8d 4a 01             	lea    0x1(%edx),%ecx
  80069a:	89 08                	mov    %ecx,(%eax)
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	88 02                	mov    %al,(%edx)
}
  8006a1:	5d                   	pop    %ebp
  8006a2:	c3                   	ret    

008006a3 <printfmt>:
{
  8006a3:	55                   	push   %ebp
  8006a4:	89 e5                	mov    %esp,%ebp
  8006a6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006a9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006ac:	50                   	push   %eax
  8006ad:	ff 75 10             	pushl  0x10(%ebp)
  8006b0:	ff 75 0c             	pushl  0xc(%ebp)
  8006b3:	ff 75 08             	pushl  0x8(%ebp)
  8006b6:	e8 05 00 00 00       	call   8006c0 <vprintfmt>
}
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	c9                   	leave  
  8006bf:	c3                   	ret    

008006c0 <vprintfmt>:
{
  8006c0:	55                   	push   %ebp
  8006c1:	89 e5                	mov    %esp,%ebp
  8006c3:	57                   	push   %edi
  8006c4:	56                   	push   %esi
  8006c5:	53                   	push   %ebx
  8006c6:	83 ec 2c             	sub    $0x2c,%esp
  8006c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8006cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006d2:	e9 c1 03 00 00       	jmp    800a98 <vprintfmt+0x3d8>
		padc = ' ';
  8006d7:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8006db:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8006e2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8006e9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006f0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006f5:	8d 47 01             	lea    0x1(%edi),%eax
  8006f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006fb:	0f b6 17             	movzbl (%edi),%edx
  8006fe:	8d 42 dd             	lea    -0x23(%edx),%eax
  800701:	3c 55                	cmp    $0x55,%al
  800703:	0f 87 12 04 00 00    	ja     800b1b <vprintfmt+0x45b>
  800709:	0f b6 c0             	movzbl %al,%eax
  80070c:	ff 24 85 60 2c 80 00 	jmp    *0x802c60(,%eax,4)
  800713:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800716:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80071a:	eb d9                	jmp    8006f5 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80071c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80071f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800723:	eb d0                	jmp    8006f5 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800725:	0f b6 d2             	movzbl %dl,%edx
  800728:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80072b:	b8 00 00 00 00       	mov    $0x0,%eax
  800730:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800733:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800736:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80073a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80073d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800740:	83 f9 09             	cmp    $0x9,%ecx
  800743:	77 55                	ja     80079a <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800745:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800748:	eb e9                	jmp    800733 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80074a:	8b 45 14             	mov    0x14(%ebp),%eax
  80074d:	8b 00                	mov    (%eax),%eax
  80074f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8d 40 04             	lea    0x4(%eax),%eax
  800758:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80075b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80075e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800762:	79 91                	jns    8006f5 <vprintfmt+0x35>
				width = precision, precision = -1;
  800764:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800767:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80076a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800771:	eb 82                	jmp    8006f5 <vprintfmt+0x35>
  800773:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800776:	85 c0                	test   %eax,%eax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	0f 49 d0             	cmovns %eax,%edx
  800780:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800783:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800786:	e9 6a ff ff ff       	jmp    8006f5 <vprintfmt+0x35>
  80078b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80078e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800795:	e9 5b ff ff ff       	jmp    8006f5 <vprintfmt+0x35>
  80079a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80079d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007a0:	eb bc                	jmp    80075e <vprintfmt+0x9e>
			lflag++;
  8007a2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007a8:	e9 48 ff ff ff       	jmp    8006f5 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8d 78 04             	lea    0x4(%eax),%edi
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	53                   	push   %ebx
  8007b7:	ff 30                	pushl  (%eax)
  8007b9:	ff d6                	call   *%esi
			break;
  8007bb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007be:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007c1:	e9 cf 02 00 00       	jmp    800a95 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8d 78 04             	lea    0x4(%eax),%edi
  8007cc:	8b 00                	mov    (%eax),%eax
  8007ce:	99                   	cltd   
  8007cf:	31 d0                	xor    %edx,%eax
  8007d1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007d3:	83 f8 0f             	cmp    $0xf,%eax
  8007d6:	7f 23                	jg     8007fb <vprintfmt+0x13b>
  8007d8:	8b 14 85 c0 2d 80 00 	mov    0x802dc0(,%eax,4),%edx
  8007df:	85 d2                	test   %edx,%edx
  8007e1:	74 18                	je     8007fb <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8007e3:	52                   	push   %edx
  8007e4:	68 95 2f 80 00       	push   $0x802f95
  8007e9:	53                   	push   %ebx
  8007ea:	56                   	push   %esi
  8007eb:	e8 b3 fe ff ff       	call   8006a3 <printfmt>
  8007f0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007f3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007f6:	e9 9a 02 00 00       	jmp    800a95 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8007fb:	50                   	push   %eax
  8007fc:	68 3f 2b 80 00       	push   $0x802b3f
  800801:	53                   	push   %ebx
  800802:	56                   	push   %esi
  800803:	e8 9b fe ff ff       	call   8006a3 <printfmt>
  800808:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80080b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80080e:	e9 82 02 00 00       	jmp    800a95 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	83 c0 04             	add    $0x4,%eax
  800819:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800821:	85 ff                	test   %edi,%edi
  800823:	b8 38 2b 80 00       	mov    $0x802b38,%eax
  800828:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80082b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80082f:	0f 8e bd 00 00 00    	jle    8008f2 <vprintfmt+0x232>
  800835:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800839:	75 0e                	jne    800849 <vprintfmt+0x189>
  80083b:	89 75 08             	mov    %esi,0x8(%ebp)
  80083e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800841:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800844:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800847:	eb 6d                	jmp    8008b6 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	ff 75 d0             	pushl  -0x30(%ebp)
  80084f:	57                   	push   %edi
  800850:	e8 6e 03 00 00       	call   800bc3 <strnlen>
  800855:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800858:	29 c1                	sub    %eax,%ecx
  80085a:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80085d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800860:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800864:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800867:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80086a:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80086c:	eb 0f                	jmp    80087d <vprintfmt+0x1bd>
					putch(padc, putdat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	53                   	push   %ebx
  800872:	ff 75 e0             	pushl  -0x20(%ebp)
  800875:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800877:	83 ef 01             	sub    $0x1,%edi
  80087a:	83 c4 10             	add    $0x10,%esp
  80087d:	85 ff                	test   %edi,%edi
  80087f:	7f ed                	jg     80086e <vprintfmt+0x1ae>
  800881:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800884:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800887:	85 c9                	test   %ecx,%ecx
  800889:	b8 00 00 00 00       	mov    $0x0,%eax
  80088e:	0f 49 c1             	cmovns %ecx,%eax
  800891:	29 c1                	sub    %eax,%ecx
  800893:	89 75 08             	mov    %esi,0x8(%ebp)
  800896:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800899:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80089c:	89 cb                	mov    %ecx,%ebx
  80089e:	eb 16                	jmp    8008b6 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8008a0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008a4:	75 31                	jne    8008d7 <vprintfmt+0x217>
					putch(ch, putdat);
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	50                   	push   %eax
  8008ad:	ff 55 08             	call   *0x8(%ebp)
  8008b0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008b3:	83 eb 01             	sub    $0x1,%ebx
  8008b6:	83 c7 01             	add    $0x1,%edi
  8008b9:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8008bd:	0f be c2             	movsbl %dl,%eax
  8008c0:	85 c0                	test   %eax,%eax
  8008c2:	74 59                	je     80091d <vprintfmt+0x25d>
  8008c4:	85 f6                	test   %esi,%esi
  8008c6:	78 d8                	js     8008a0 <vprintfmt+0x1e0>
  8008c8:	83 ee 01             	sub    $0x1,%esi
  8008cb:	79 d3                	jns    8008a0 <vprintfmt+0x1e0>
  8008cd:	89 df                	mov    %ebx,%edi
  8008cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008d5:	eb 37                	jmp    80090e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8008d7:	0f be d2             	movsbl %dl,%edx
  8008da:	83 ea 20             	sub    $0x20,%edx
  8008dd:	83 fa 5e             	cmp    $0x5e,%edx
  8008e0:	76 c4                	jbe    8008a6 <vprintfmt+0x1e6>
					putch('?', putdat);
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	ff 75 0c             	pushl  0xc(%ebp)
  8008e8:	6a 3f                	push   $0x3f
  8008ea:	ff 55 08             	call   *0x8(%ebp)
  8008ed:	83 c4 10             	add    $0x10,%esp
  8008f0:	eb c1                	jmp    8008b3 <vprintfmt+0x1f3>
  8008f2:	89 75 08             	mov    %esi,0x8(%ebp)
  8008f5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8008f8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8008fb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8008fe:	eb b6                	jmp    8008b6 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	53                   	push   %ebx
  800904:	6a 20                	push   $0x20
  800906:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800908:	83 ef 01             	sub    $0x1,%edi
  80090b:	83 c4 10             	add    $0x10,%esp
  80090e:	85 ff                	test   %edi,%edi
  800910:	7f ee                	jg     800900 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800912:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800915:	89 45 14             	mov    %eax,0x14(%ebp)
  800918:	e9 78 01 00 00       	jmp    800a95 <vprintfmt+0x3d5>
  80091d:	89 df                	mov    %ebx,%edi
  80091f:	8b 75 08             	mov    0x8(%ebp),%esi
  800922:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800925:	eb e7                	jmp    80090e <vprintfmt+0x24e>
	if (lflag >= 2)
  800927:	83 f9 01             	cmp    $0x1,%ecx
  80092a:	7e 3f                	jle    80096b <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	8b 50 04             	mov    0x4(%eax),%edx
  800932:	8b 00                	mov    (%eax),%eax
  800934:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800937:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	8d 40 08             	lea    0x8(%eax),%eax
  800940:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800943:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800947:	79 5c                	jns    8009a5 <vprintfmt+0x2e5>
				putch('-', putdat);
  800949:	83 ec 08             	sub    $0x8,%esp
  80094c:	53                   	push   %ebx
  80094d:	6a 2d                	push   $0x2d
  80094f:	ff d6                	call   *%esi
				num = -(long long) num;
  800951:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800954:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800957:	f7 da                	neg    %edx
  800959:	83 d1 00             	adc    $0x0,%ecx
  80095c:	f7 d9                	neg    %ecx
  80095e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800961:	b8 0a 00 00 00       	mov    $0xa,%eax
  800966:	e9 10 01 00 00       	jmp    800a7b <vprintfmt+0x3bb>
	else if (lflag)
  80096b:	85 c9                	test   %ecx,%ecx
  80096d:	75 1b                	jne    80098a <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80096f:	8b 45 14             	mov    0x14(%ebp),%eax
  800972:	8b 00                	mov    (%eax),%eax
  800974:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800977:	89 c1                	mov    %eax,%ecx
  800979:	c1 f9 1f             	sar    $0x1f,%ecx
  80097c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80097f:	8b 45 14             	mov    0x14(%ebp),%eax
  800982:	8d 40 04             	lea    0x4(%eax),%eax
  800985:	89 45 14             	mov    %eax,0x14(%ebp)
  800988:	eb b9                	jmp    800943 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80098a:	8b 45 14             	mov    0x14(%ebp),%eax
  80098d:	8b 00                	mov    (%eax),%eax
  80098f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800992:	89 c1                	mov    %eax,%ecx
  800994:	c1 f9 1f             	sar    $0x1f,%ecx
  800997:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80099a:	8b 45 14             	mov    0x14(%ebp),%eax
  80099d:	8d 40 04             	lea    0x4(%eax),%eax
  8009a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a3:	eb 9e                	jmp    800943 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8009a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8009a8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8009ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b0:	e9 c6 00 00 00       	jmp    800a7b <vprintfmt+0x3bb>
	if (lflag >= 2)
  8009b5:	83 f9 01             	cmp    $0x1,%ecx
  8009b8:	7e 18                	jle    8009d2 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8009ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bd:	8b 10                	mov    (%eax),%edx
  8009bf:	8b 48 04             	mov    0x4(%eax),%ecx
  8009c2:	8d 40 08             	lea    0x8(%eax),%eax
  8009c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009cd:	e9 a9 00 00 00       	jmp    800a7b <vprintfmt+0x3bb>
	else if (lflag)
  8009d2:	85 c9                	test   %ecx,%ecx
  8009d4:	75 1a                	jne    8009f0 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8009d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d9:	8b 10                	mov    (%eax),%edx
  8009db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009e0:	8d 40 04             	lea    0x4(%eax),%eax
  8009e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009e6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009eb:	e9 8b 00 00 00       	jmp    800a7b <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8009f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f3:	8b 10                	mov    (%eax),%edx
  8009f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009fa:	8d 40 04             	lea    0x4(%eax),%eax
  8009fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a00:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a05:	eb 74                	jmp    800a7b <vprintfmt+0x3bb>
	if (lflag >= 2)
  800a07:	83 f9 01             	cmp    $0x1,%ecx
  800a0a:	7e 15                	jle    800a21 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	8b 10                	mov    (%eax),%edx
  800a11:	8b 48 04             	mov    0x4(%eax),%ecx
  800a14:	8d 40 08             	lea    0x8(%eax),%eax
  800a17:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a1a:	b8 08 00 00 00       	mov    $0x8,%eax
  800a1f:	eb 5a                	jmp    800a7b <vprintfmt+0x3bb>
	else if (lflag)
  800a21:	85 c9                	test   %ecx,%ecx
  800a23:	75 17                	jne    800a3c <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	8b 10                	mov    (%eax),%edx
  800a2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a2f:	8d 40 04             	lea    0x4(%eax),%eax
  800a32:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a35:	b8 08 00 00 00       	mov    $0x8,%eax
  800a3a:	eb 3f                	jmp    800a7b <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	8b 10                	mov    (%eax),%edx
  800a41:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a46:	8d 40 04             	lea    0x4(%eax),%eax
  800a49:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a4c:	b8 08 00 00 00       	mov    $0x8,%eax
  800a51:	eb 28                	jmp    800a7b <vprintfmt+0x3bb>
			putch('0', putdat);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	53                   	push   %ebx
  800a57:	6a 30                	push   $0x30
  800a59:	ff d6                	call   *%esi
			putch('x', putdat);
  800a5b:	83 c4 08             	add    $0x8,%esp
  800a5e:	53                   	push   %ebx
  800a5f:	6a 78                	push   $0x78
  800a61:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	8b 10                	mov    (%eax),%edx
  800a68:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a6d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a70:	8d 40 04             	lea    0x4(%eax),%eax
  800a73:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a76:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a7b:	83 ec 0c             	sub    $0xc,%esp
  800a7e:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800a82:	57                   	push   %edi
  800a83:	ff 75 e0             	pushl  -0x20(%ebp)
  800a86:	50                   	push   %eax
  800a87:	51                   	push   %ecx
  800a88:	52                   	push   %edx
  800a89:	89 da                	mov    %ebx,%edx
  800a8b:	89 f0                	mov    %esi,%eax
  800a8d:	e8 45 fb ff ff       	call   8005d7 <printnum>
			break;
  800a92:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800a95:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  800a98:	83 c7 01             	add    $0x1,%edi
  800a9b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a9f:	83 f8 25             	cmp    $0x25,%eax
  800aa2:	0f 84 2f fc ff ff    	je     8006d7 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  800aa8:	85 c0                	test   %eax,%eax
  800aaa:	0f 84 8b 00 00 00    	je     800b3b <vprintfmt+0x47b>
			putch(ch, putdat);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	53                   	push   %ebx
  800ab4:	50                   	push   %eax
  800ab5:	ff d6                	call   *%esi
  800ab7:	83 c4 10             	add    $0x10,%esp
  800aba:	eb dc                	jmp    800a98 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800abc:	83 f9 01             	cmp    $0x1,%ecx
  800abf:	7e 15                	jle    800ad6 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800ac1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac4:	8b 10                	mov    (%eax),%edx
  800ac6:	8b 48 04             	mov    0x4(%eax),%ecx
  800ac9:	8d 40 08             	lea    0x8(%eax),%eax
  800acc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800acf:	b8 10 00 00 00       	mov    $0x10,%eax
  800ad4:	eb a5                	jmp    800a7b <vprintfmt+0x3bb>
	else if (lflag)
  800ad6:	85 c9                	test   %ecx,%ecx
  800ad8:	75 17                	jne    800af1 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800ada:	8b 45 14             	mov    0x14(%ebp),%eax
  800add:	8b 10                	mov    (%eax),%edx
  800adf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ae4:	8d 40 04             	lea    0x4(%eax),%eax
  800ae7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aea:	b8 10 00 00 00       	mov    $0x10,%eax
  800aef:	eb 8a                	jmp    800a7b <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800af1:	8b 45 14             	mov    0x14(%ebp),%eax
  800af4:	8b 10                	mov    (%eax),%edx
  800af6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800afb:	8d 40 04             	lea    0x4(%eax),%eax
  800afe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b01:	b8 10 00 00 00       	mov    $0x10,%eax
  800b06:	e9 70 ff ff ff       	jmp    800a7b <vprintfmt+0x3bb>
			putch(ch, putdat);
  800b0b:	83 ec 08             	sub    $0x8,%esp
  800b0e:	53                   	push   %ebx
  800b0f:	6a 25                	push   $0x25
  800b11:	ff d6                	call   *%esi
			break;
  800b13:	83 c4 10             	add    $0x10,%esp
  800b16:	e9 7a ff ff ff       	jmp    800a95 <vprintfmt+0x3d5>
			putch('%', putdat);
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	53                   	push   %ebx
  800b1f:	6a 25                	push   $0x25
  800b21:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	89 f8                	mov    %edi,%eax
  800b28:	eb 03                	jmp    800b2d <vprintfmt+0x46d>
  800b2a:	83 e8 01             	sub    $0x1,%eax
  800b2d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b31:	75 f7                	jne    800b2a <vprintfmt+0x46a>
  800b33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b36:	e9 5a ff ff ff       	jmp    800a95 <vprintfmt+0x3d5>
}
  800b3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b3e:	5b                   	pop    %ebx
  800b3f:	5e                   	pop    %esi
  800b40:	5f                   	pop    %edi
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	83 ec 18             	sub    $0x18,%esp
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b52:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b56:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b60:	85 c0                	test   %eax,%eax
  800b62:	74 26                	je     800b8a <vsnprintf+0x47>
  800b64:	85 d2                	test   %edx,%edx
  800b66:	7e 22                	jle    800b8a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b68:	ff 75 14             	pushl  0x14(%ebp)
  800b6b:	ff 75 10             	pushl  0x10(%ebp)
  800b6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b71:	50                   	push   %eax
  800b72:	68 86 06 80 00       	push   $0x800686
  800b77:	e8 44 fb ff ff       	call   8006c0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b7f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b85:	83 c4 10             	add    $0x10,%esp
}
  800b88:	c9                   	leave  
  800b89:	c3                   	ret    
		return -E_INVAL;
  800b8a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b8f:	eb f7                	jmp    800b88 <vsnprintf+0x45>

00800b91 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b97:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b9a:	50                   	push   %eax
  800b9b:	ff 75 10             	pushl  0x10(%ebp)
  800b9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ba1:	ff 75 08             	pushl  0x8(%ebp)
  800ba4:	e8 9a ff ff ff       	call   800b43 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb6:	eb 03                	jmp    800bbb <strlen+0x10>
		n++;
  800bb8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800bbb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bbf:	75 f7                	jne    800bb8 <strlen+0xd>
	return n;
}
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    

00800bc3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd1:	eb 03                	jmp    800bd6 <strnlen+0x13>
		n++;
  800bd3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd6:	39 d0                	cmp    %edx,%eax
  800bd8:	74 06                	je     800be0 <strnlen+0x1d>
  800bda:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800bde:	75 f3                	jne    800bd3 <strnlen+0x10>
	return n;
}
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    

00800be2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	53                   	push   %ebx
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bec:	89 c2                	mov    %eax,%edx
  800bee:	83 c1 01             	add    $0x1,%ecx
  800bf1:	83 c2 01             	add    $0x1,%edx
  800bf4:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800bf8:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bfb:	84 db                	test   %bl,%bl
  800bfd:	75 ef                	jne    800bee <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800bff:	5b                   	pop    %ebx
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    

00800c02 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	53                   	push   %ebx
  800c06:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c09:	53                   	push   %ebx
  800c0a:	e8 9c ff ff ff       	call   800bab <strlen>
  800c0f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800c12:	ff 75 0c             	pushl  0xc(%ebp)
  800c15:	01 d8                	add    %ebx,%eax
  800c17:	50                   	push   %eax
  800c18:	e8 c5 ff ff ff       	call   800be2 <strcpy>
	return dst;
}
  800c1d:	89 d8                	mov    %ebx,%eax
  800c1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	56                   	push   %esi
  800c28:	53                   	push   %ebx
  800c29:	8b 75 08             	mov    0x8(%ebp),%esi
  800c2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2f:	89 f3                	mov    %esi,%ebx
  800c31:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c34:	89 f2                	mov    %esi,%edx
  800c36:	eb 0f                	jmp    800c47 <strncpy+0x23>
		*dst++ = *src;
  800c38:	83 c2 01             	add    $0x1,%edx
  800c3b:	0f b6 01             	movzbl (%ecx),%eax
  800c3e:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c41:	80 39 01             	cmpb   $0x1,(%ecx)
  800c44:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800c47:	39 da                	cmp    %ebx,%edx
  800c49:	75 ed                	jne    800c38 <strncpy+0x14>
	}
	return ret;
}
  800c4b:	89 f0                	mov    %esi,%eax
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	56                   	push   %esi
  800c55:	53                   	push   %ebx
  800c56:	8b 75 08             	mov    0x8(%ebp),%esi
  800c59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c5f:	89 f0                	mov    %esi,%eax
  800c61:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c65:	85 c9                	test   %ecx,%ecx
  800c67:	75 0b                	jne    800c74 <strlcpy+0x23>
  800c69:	eb 17                	jmp    800c82 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c6b:	83 c2 01             	add    $0x1,%edx
  800c6e:	83 c0 01             	add    $0x1,%eax
  800c71:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800c74:	39 d8                	cmp    %ebx,%eax
  800c76:	74 07                	je     800c7f <strlcpy+0x2e>
  800c78:	0f b6 0a             	movzbl (%edx),%ecx
  800c7b:	84 c9                	test   %cl,%cl
  800c7d:	75 ec                	jne    800c6b <strlcpy+0x1a>
		*dst = '\0';
  800c7f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c82:	29 f0                	sub    %esi,%eax
}
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c91:	eb 06                	jmp    800c99 <strcmp+0x11>
		p++, q++;
  800c93:	83 c1 01             	add    $0x1,%ecx
  800c96:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800c99:	0f b6 01             	movzbl (%ecx),%eax
  800c9c:	84 c0                	test   %al,%al
  800c9e:	74 04                	je     800ca4 <strcmp+0x1c>
  800ca0:	3a 02                	cmp    (%edx),%al
  800ca2:	74 ef                	je     800c93 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca4:	0f b6 c0             	movzbl %al,%eax
  800ca7:	0f b6 12             	movzbl (%edx),%edx
  800caa:	29 d0                	sub    %edx,%eax
}
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    

00800cae <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	53                   	push   %ebx
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb8:	89 c3                	mov    %eax,%ebx
  800cba:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cbd:	eb 06                	jmp    800cc5 <strncmp+0x17>
		n--, p++, q++;
  800cbf:	83 c0 01             	add    $0x1,%eax
  800cc2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800cc5:	39 d8                	cmp    %ebx,%eax
  800cc7:	74 16                	je     800cdf <strncmp+0x31>
  800cc9:	0f b6 08             	movzbl (%eax),%ecx
  800ccc:	84 c9                	test   %cl,%cl
  800cce:	74 04                	je     800cd4 <strncmp+0x26>
  800cd0:	3a 0a                	cmp    (%edx),%cl
  800cd2:	74 eb                	je     800cbf <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd4:	0f b6 00             	movzbl (%eax),%eax
  800cd7:	0f b6 12             	movzbl (%edx),%edx
  800cda:	29 d0                	sub    %edx,%eax
}
  800cdc:	5b                   	pop    %ebx
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    
		return 0;
  800cdf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce4:	eb f6                	jmp    800cdc <strncmp+0x2e>

00800ce6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cf0:	0f b6 10             	movzbl (%eax),%edx
  800cf3:	84 d2                	test   %dl,%dl
  800cf5:	74 09                	je     800d00 <strchr+0x1a>
		if (*s == c)
  800cf7:	38 ca                	cmp    %cl,%dl
  800cf9:	74 0a                	je     800d05 <strchr+0x1f>
	for (; *s; s++)
  800cfb:	83 c0 01             	add    $0x1,%eax
  800cfe:	eb f0                	jmp    800cf0 <strchr+0xa>
			return (char *) s;
	return 0;
  800d00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d11:	eb 03                	jmp    800d16 <strfind+0xf>
  800d13:	83 c0 01             	add    $0x1,%eax
  800d16:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d19:	38 ca                	cmp    %cl,%dl
  800d1b:	74 04                	je     800d21 <strfind+0x1a>
  800d1d:	84 d2                	test   %dl,%dl
  800d1f:	75 f2                	jne    800d13 <strfind+0xc>
			break;
	return (char *) s;
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	53                   	push   %ebx
  800d29:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d2f:	85 c9                	test   %ecx,%ecx
  800d31:	74 13                	je     800d46 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d33:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d39:	75 05                	jne    800d40 <memset+0x1d>
  800d3b:	f6 c1 03             	test   $0x3,%cl
  800d3e:	74 0d                	je     800d4d <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	fc                   	cld    
  800d44:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d46:	89 f8                	mov    %edi,%eax
  800d48:	5b                   	pop    %ebx
  800d49:	5e                   	pop    %esi
  800d4a:	5f                   	pop    %edi
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    
		c &= 0xFF;
  800d4d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d51:	89 d3                	mov    %edx,%ebx
  800d53:	c1 e3 08             	shl    $0x8,%ebx
  800d56:	89 d0                	mov    %edx,%eax
  800d58:	c1 e0 18             	shl    $0x18,%eax
  800d5b:	89 d6                	mov    %edx,%esi
  800d5d:	c1 e6 10             	shl    $0x10,%esi
  800d60:	09 f0                	or     %esi,%eax
  800d62:	09 c2                	or     %eax,%edx
  800d64:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800d66:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d69:	89 d0                	mov    %edx,%eax
  800d6b:	fc                   	cld    
  800d6c:	f3 ab                	rep stos %eax,%es:(%edi)
  800d6e:	eb d6                	jmp    800d46 <memset+0x23>

00800d70 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d7e:	39 c6                	cmp    %eax,%esi
  800d80:	73 35                	jae    800db7 <memmove+0x47>
  800d82:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d85:	39 c2                	cmp    %eax,%edx
  800d87:	76 2e                	jbe    800db7 <memmove+0x47>
		s += n;
		d += n;
  800d89:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d8c:	89 d6                	mov    %edx,%esi
  800d8e:	09 fe                	or     %edi,%esi
  800d90:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d96:	74 0c                	je     800da4 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d98:	83 ef 01             	sub    $0x1,%edi
  800d9b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d9e:	fd                   	std    
  800d9f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800da1:	fc                   	cld    
  800da2:	eb 21                	jmp    800dc5 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800da4:	f6 c1 03             	test   $0x3,%cl
  800da7:	75 ef                	jne    800d98 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800da9:	83 ef 04             	sub    $0x4,%edi
  800dac:	8d 72 fc             	lea    -0x4(%edx),%esi
  800daf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800db2:	fd                   	std    
  800db3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800db5:	eb ea                	jmp    800da1 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800db7:	89 f2                	mov    %esi,%edx
  800db9:	09 c2                	or     %eax,%edx
  800dbb:	f6 c2 03             	test   $0x3,%dl
  800dbe:	74 09                	je     800dc9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800dc0:	89 c7                	mov    %eax,%edi
  800dc2:	fc                   	cld    
  800dc3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dc5:	5e                   	pop    %esi
  800dc6:	5f                   	pop    %edi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dc9:	f6 c1 03             	test   $0x3,%cl
  800dcc:	75 f2                	jne    800dc0 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dce:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800dd1:	89 c7                	mov    %eax,%edi
  800dd3:	fc                   	cld    
  800dd4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dd6:	eb ed                	jmp    800dc5 <memmove+0x55>

00800dd8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ddb:	ff 75 10             	pushl  0x10(%ebp)
  800dde:	ff 75 0c             	pushl  0xc(%ebp)
  800de1:	ff 75 08             	pushl  0x8(%ebp)
  800de4:	e8 87 ff ff ff       	call   800d70 <memmove>
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	56                   	push   %esi
  800def:	53                   	push   %ebx
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df6:	89 c6                	mov    %eax,%esi
  800df8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dfb:	39 f0                	cmp    %esi,%eax
  800dfd:	74 1c                	je     800e1b <memcmp+0x30>
		if (*s1 != *s2)
  800dff:	0f b6 08             	movzbl (%eax),%ecx
  800e02:	0f b6 1a             	movzbl (%edx),%ebx
  800e05:	38 d9                	cmp    %bl,%cl
  800e07:	75 08                	jne    800e11 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e09:	83 c0 01             	add    $0x1,%eax
  800e0c:	83 c2 01             	add    $0x1,%edx
  800e0f:	eb ea                	jmp    800dfb <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e11:	0f b6 c1             	movzbl %cl,%eax
  800e14:	0f b6 db             	movzbl %bl,%ebx
  800e17:	29 d8                	sub    %ebx,%eax
  800e19:	eb 05                	jmp    800e20 <memcmp+0x35>
	}

	return 0;
  800e1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e2d:	89 c2                	mov    %eax,%edx
  800e2f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e32:	39 d0                	cmp    %edx,%eax
  800e34:	73 09                	jae    800e3f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e36:	38 08                	cmp    %cl,(%eax)
  800e38:	74 05                	je     800e3f <memfind+0x1b>
	for (; s < ends; s++)
  800e3a:	83 c0 01             	add    $0x1,%eax
  800e3d:	eb f3                	jmp    800e32 <memfind+0xe>
			break;
	return (void *) s;
}
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    

00800e41 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	57                   	push   %edi
  800e45:	56                   	push   %esi
  800e46:	53                   	push   %ebx
  800e47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e4d:	eb 03                	jmp    800e52 <strtol+0x11>
		s++;
  800e4f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e52:	0f b6 01             	movzbl (%ecx),%eax
  800e55:	3c 20                	cmp    $0x20,%al
  800e57:	74 f6                	je     800e4f <strtol+0xe>
  800e59:	3c 09                	cmp    $0x9,%al
  800e5b:	74 f2                	je     800e4f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e5d:	3c 2b                	cmp    $0x2b,%al
  800e5f:	74 2e                	je     800e8f <strtol+0x4e>
	int neg = 0;
  800e61:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e66:	3c 2d                	cmp    $0x2d,%al
  800e68:	74 2f                	je     800e99 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e6a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e70:	75 05                	jne    800e77 <strtol+0x36>
  800e72:	80 39 30             	cmpb   $0x30,(%ecx)
  800e75:	74 2c                	je     800ea3 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e77:	85 db                	test   %ebx,%ebx
  800e79:	75 0a                	jne    800e85 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e7b:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800e80:	80 39 30             	cmpb   $0x30,(%ecx)
  800e83:	74 28                	je     800ead <strtol+0x6c>
		base = 10;
  800e85:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e8d:	eb 50                	jmp    800edf <strtol+0x9e>
		s++;
  800e8f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e92:	bf 00 00 00 00       	mov    $0x0,%edi
  800e97:	eb d1                	jmp    800e6a <strtol+0x29>
		s++, neg = 1;
  800e99:	83 c1 01             	add    $0x1,%ecx
  800e9c:	bf 01 00 00 00       	mov    $0x1,%edi
  800ea1:	eb c7                	jmp    800e6a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ea7:	74 0e                	je     800eb7 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ea9:	85 db                	test   %ebx,%ebx
  800eab:	75 d8                	jne    800e85 <strtol+0x44>
		s++, base = 8;
  800ead:	83 c1 01             	add    $0x1,%ecx
  800eb0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800eb5:	eb ce                	jmp    800e85 <strtol+0x44>
		s += 2, base = 16;
  800eb7:	83 c1 02             	add    $0x2,%ecx
  800eba:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ebf:	eb c4                	jmp    800e85 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ec1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ec4:	89 f3                	mov    %esi,%ebx
  800ec6:	80 fb 19             	cmp    $0x19,%bl
  800ec9:	77 29                	ja     800ef4 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ecb:	0f be d2             	movsbl %dl,%edx
  800ece:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ed1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ed4:	7d 30                	jge    800f06 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ed6:	83 c1 01             	add    $0x1,%ecx
  800ed9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800edd:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800edf:	0f b6 11             	movzbl (%ecx),%edx
  800ee2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ee5:	89 f3                	mov    %esi,%ebx
  800ee7:	80 fb 09             	cmp    $0x9,%bl
  800eea:	77 d5                	ja     800ec1 <strtol+0x80>
			dig = *s - '0';
  800eec:	0f be d2             	movsbl %dl,%edx
  800eef:	83 ea 30             	sub    $0x30,%edx
  800ef2:	eb dd                	jmp    800ed1 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ef4:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ef7:	89 f3                	mov    %esi,%ebx
  800ef9:	80 fb 19             	cmp    $0x19,%bl
  800efc:	77 08                	ja     800f06 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800efe:	0f be d2             	movsbl %dl,%edx
  800f01:	83 ea 37             	sub    $0x37,%edx
  800f04:	eb cb                	jmp    800ed1 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0a:	74 05                	je     800f11 <strtol+0xd0>
		*endptr = (char *) s;
  800f0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f0f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f11:	89 c2                	mov    %eax,%edx
  800f13:	f7 da                	neg    %edx
  800f15:	85 ff                	test   %edi,%edi
  800f17:	0f 45 c2             	cmovne %edx,%eax
}
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5f                   	pop    %edi
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    

00800f1f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	57                   	push   %edi
  800f23:	56                   	push   %esi
  800f24:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f30:	89 c3                	mov    %eax,%ebx
  800f32:	89 c7                	mov    %eax,%edi
  800f34:	89 c6                	mov    %eax,%esi
  800f36:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f38:	5b                   	pop    %ebx
  800f39:	5e                   	pop    %esi
  800f3a:	5f                   	pop    %edi
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    

00800f3d <sys_cgetc>:

int
sys_cgetc(void)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	57                   	push   %edi
  800f41:	56                   	push   %esi
  800f42:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800f43:	ba 00 00 00 00       	mov    $0x0,%edx
  800f48:	b8 01 00 00 00       	mov    $0x1,%eax
  800f4d:	89 d1                	mov    %edx,%ecx
  800f4f:	89 d3                	mov    %edx,%ebx
  800f51:	89 d7                	mov    %edx,%edi
  800f53:	89 d6                	mov    %edx,%esi
  800f55:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f57:	5b                   	pop    %ebx
  800f58:	5e                   	pop    %esi
  800f59:	5f                   	pop    %edi
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
  800f62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800f65:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6d:	b8 03 00 00 00       	mov    $0x3,%eax
  800f72:	89 cb                	mov    %ecx,%ebx
  800f74:	89 cf                	mov    %ecx,%edi
  800f76:	89 ce                	mov    %ecx,%esi
  800f78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	7f 08                	jg     800f86 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f86:	83 ec 0c             	sub    $0xc,%esp
  800f89:	50                   	push   %eax
  800f8a:	6a 03                	push   $0x3
  800f8c:	68 1f 2e 80 00       	push   $0x802e1f
  800f91:	6a 23                	push   $0x23
  800f93:	68 3c 2e 80 00       	push   $0x802e3c
  800f98:	e8 4b f5 ff ff       	call   8004e8 <_panic>

00800f9d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	57                   	push   %edi
  800fa1:	56                   	push   %esi
  800fa2:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800fa3:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa8:	b8 02 00 00 00       	mov    $0x2,%eax
  800fad:	89 d1                	mov    %edx,%ecx
  800faf:	89 d3                	mov    %edx,%ebx
  800fb1:	89 d7                	mov    %edx,%edi
  800fb3:	89 d6                	mov    %edx,%esi
  800fb5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fb7:	5b                   	pop    %ebx
  800fb8:	5e                   	pop    %esi
  800fb9:	5f                   	pop    %edi
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    

00800fbc <sys_yield>:

void
sys_yield(void)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	57                   	push   %edi
  800fc0:	56                   	push   %esi
  800fc1:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800fc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fcc:	89 d1                	mov    %edx,%ecx
  800fce:	89 d3                	mov    %edx,%ebx
  800fd0:	89 d7                	mov    %edx,%edi
  800fd2:	89 d6                	mov    %edx,%esi
  800fd4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fd6:	5b                   	pop    %ebx
  800fd7:	5e                   	pop    %esi
  800fd8:	5f                   	pop    %edi
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    

00800fdb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	57                   	push   %edi
  800fdf:	56                   	push   %esi
  800fe0:	53                   	push   %ebx
  800fe1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800fe4:	be 00 00 00 00       	mov    $0x0,%esi
  800fe9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fef:	b8 04 00 00 00       	mov    $0x4,%eax
  800ff4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff7:	89 f7                	mov    %esi,%edi
  800ff9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	7f 08                	jg     801007 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801007:	83 ec 0c             	sub    $0xc,%esp
  80100a:	50                   	push   %eax
  80100b:	6a 04                	push   $0x4
  80100d:	68 1f 2e 80 00       	push   $0x802e1f
  801012:	6a 23                	push   $0x23
  801014:	68 3c 2e 80 00       	push   $0x802e3c
  801019:	e8 ca f4 ff ff       	call   8004e8 <_panic>

0080101e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
  801024:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  801027:	8b 55 08             	mov    0x8(%ebp),%edx
  80102a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102d:	b8 05 00 00 00       	mov    $0x5,%eax
  801032:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801035:	8b 7d 14             	mov    0x14(%ebp),%edi
  801038:	8b 75 18             	mov    0x18(%ebp),%esi
  80103b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103d:	85 c0                	test   %eax,%eax
  80103f:	7f 08                	jg     801049 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801041:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801049:	83 ec 0c             	sub    $0xc,%esp
  80104c:	50                   	push   %eax
  80104d:	6a 05                	push   $0x5
  80104f:	68 1f 2e 80 00       	push   $0x802e1f
  801054:	6a 23                	push   $0x23
  801056:	68 3c 2e 80 00       	push   $0x802e3c
  80105b:	e8 88 f4 ff ff       	call   8004e8 <_panic>

00801060 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	57                   	push   %edi
  801064:	56                   	push   %esi
  801065:	53                   	push   %ebx
  801066:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  801069:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106e:	8b 55 08             	mov    0x8(%ebp),%edx
  801071:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801074:	b8 06 00 00 00       	mov    $0x6,%eax
  801079:	89 df                	mov    %ebx,%edi
  80107b:	89 de                	mov    %ebx,%esi
  80107d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80107f:	85 c0                	test   %eax,%eax
  801081:	7f 08                	jg     80108b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801083:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801086:	5b                   	pop    %ebx
  801087:	5e                   	pop    %esi
  801088:	5f                   	pop    %edi
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80108b:	83 ec 0c             	sub    $0xc,%esp
  80108e:	50                   	push   %eax
  80108f:	6a 06                	push   $0x6
  801091:	68 1f 2e 80 00       	push   $0x802e1f
  801096:	6a 23                	push   $0x23
  801098:	68 3c 2e 80 00       	push   $0x802e3c
  80109d:	e8 46 f4 ff ff       	call   8004e8 <_panic>

008010a2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	57                   	push   %edi
  8010a6:	56                   	push   %esi
  8010a7:	53                   	push   %ebx
  8010a8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8010ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b6:	b8 08 00 00 00       	mov    $0x8,%eax
  8010bb:	89 df                	mov    %ebx,%edi
  8010bd:	89 de                	mov    %ebx,%esi
  8010bf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	7f 08                	jg     8010cd <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c8:	5b                   	pop    %ebx
  8010c9:	5e                   	pop    %esi
  8010ca:	5f                   	pop    %edi
  8010cb:	5d                   	pop    %ebp
  8010cc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010cd:	83 ec 0c             	sub    $0xc,%esp
  8010d0:	50                   	push   %eax
  8010d1:	6a 08                	push   $0x8
  8010d3:	68 1f 2e 80 00       	push   $0x802e1f
  8010d8:	6a 23                	push   $0x23
  8010da:	68 3c 2e 80 00       	push   $0x802e3c
  8010df:	e8 04 f4 ff ff       	call   8004e8 <_panic>

008010e4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	57                   	push   %edi
  8010e8:	56                   	push   %esi
  8010e9:	53                   	push   %ebx
  8010ea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8010ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f8:	b8 09 00 00 00       	mov    $0x9,%eax
  8010fd:	89 df                	mov    %ebx,%edi
  8010ff:	89 de                	mov    %ebx,%esi
  801101:	cd 30                	int    $0x30
	if(check && ret > 0)
  801103:	85 c0                	test   %eax,%eax
  801105:	7f 08                	jg     80110f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801107:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110a:	5b                   	pop    %ebx
  80110b:	5e                   	pop    %esi
  80110c:	5f                   	pop    %edi
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110f:	83 ec 0c             	sub    $0xc,%esp
  801112:	50                   	push   %eax
  801113:	6a 09                	push   $0x9
  801115:	68 1f 2e 80 00       	push   $0x802e1f
  80111a:	6a 23                	push   $0x23
  80111c:	68 3c 2e 80 00       	push   $0x802e3c
  801121:	e8 c2 f3 ff ff       	call   8004e8 <_panic>

00801126 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	57                   	push   %edi
  80112a:	56                   	push   %esi
  80112b:	53                   	push   %ebx
  80112c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80112f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801134:	8b 55 08             	mov    0x8(%ebp),%edx
  801137:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80113f:	89 df                	mov    %ebx,%edi
  801141:	89 de                	mov    %ebx,%esi
  801143:	cd 30                	int    $0x30
	if(check && ret > 0)
  801145:	85 c0                	test   %eax,%eax
  801147:	7f 08                	jg     801151 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801149:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114c:	5b                   	pop    %ebx
  80114d:	5e                   	pop    %esi
  80114e:	5f                   	pop    %edi
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801151:	83 ec 0c             	sub    $0xc,%esp
  801154:	50                   	push   %eax
  801155:	6a 0a                	push   $0xa
  801157:	68 1f 2e 80 00       	push   $0x802e1f
  80115c:	6a 23                	push   $0x23
  80115e:	68 3c 2e 80 00       	push   $0x802e3c
  801163:	e8 80 f3 ff ff       	call   8004e8 <_panic>

00801168 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	57                   	push   %edi
  80116c:	56                   	push   %esi
  80116d:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80116e:	8b 55 08             	mov    0x8(%ebp),%edx
  801171:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801174:	b8 0c 00 00 00       	mov    $0xc,%eax
  801179:	be 00 00 00 00       	mov    $0x0,%esi
  80117e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801181:	8b 7d 14             	mov    0x14(%ebp),%edi
  801184:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801186:	5b                   	pop    %ebx
  801187:	5e                   	pop    %esi
  801188:	5f                   	pop    %edi
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    

0080118b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	57                   	push   %edi
  80118f:	56                   	push   %esi
  801190:	53                   	push   %ebx
  801191:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  801194:	b9 00 00 00 00       	mov    $0x0,%ecx
  801199:	8b 55 08             	mov    0x8(%ebp),%edx
  80119c:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011a1:	89 cb                	mov    %ecx,%ebx
  8011a3:	89 cf                	mov    %ecx,%edi
  8011a5:	89 ce                	mov    %ecx,%esi
  8011a7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	7f 08                	jg     8011b5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b0:	5b                   	pop    %ebx
  8011b1:	5e                   	pop    %esi
  8011b2:	5f                   	pop    %edi
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	50                   	push   %eax
  8011b9:	6a 0d                	push   $0xd
  8011bb:	68 1f 2e 80 00       	push   $0x802e1f
  8011c0:	6a 23                	push   $0x23
  8011c2:	68 3c 2e 80 00       	push   $0x802e3c
  8011c7:	e8 1c f3 ff ff       	call   8004e8 <_panic>

008011cc <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
  8011cf:	53                   	push   %ebx
  8011d0:	83 ec 04             	sub    $0x4,%esp
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8011d6:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) { //只有因为写操作写时拷贝的地址这中情况，才可以抢救。否则一律panic
  8011d8:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8011dc:	74 74                	je     801252 <pgfault+0x86>
  8011de:	89 d8                	mov    %ebx,%eax
  8011e0:	c1 e8 0c             	shr    $0xc,%eax
  8011e3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011ea:	f6 c4 08             	test   $0x8,%ah
  8011ed:	74 63                	je     801252 <pgfault+0x86>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  8011ef:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, PFTEMP, PTE_U|PTE_P)) < 0)		//将当前进程PFTEMP也映射到当前进程addr指向的物理页
  8011f5:	83 ec 0c             	sub    $0xc,%esp
  8011f8:	6a 05                	push   $0x5
  8011fa:	68 00 f0 7f 00       	push   $0x7ff000
  8011ff:	6a 00                	push   $0x0
  801201:	53                   	push   %ebx
  801202:	6a 00                	push   $0x0
  801204:	e8 15 fe ff ff       	call   80101e <sys_page_map>
  801209:	83 c4 20             	add    $0x20,%esp
  80120c:	85 c0                	test   %eax,%eax
  80120e:	78 56                	js     801266 <pgfault+0x9a>
		panic("sys_page_map: %e", r);
	if ((r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W)) < 0)	//令当前进程addr指向新分配的物理页
  801210:	83 ec 04             	sub    $0x4,%esp
  801213:	6a 07                	push   $0x7
  801215:	53                   	push   %ebx
  801216:	6a 00                	push   $0x0
  801218:	e8 be fd ff ff       	call   800fdb <sys_page_alloc>
  80121d:	83 c4 10             	add    $0x10,%esp
  801220:	85 c0                	test   %eax,%eax
  801222:	78 54                	js     801278 <pgfault+0xac>
		panic("sys_page_alloc: %e", r);
	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	68 00 10 00 00       	push   $0x1000
  80122c:	68 00 f0 7f 00       	push   $0x7ff000
  801231:	53                   	push   %ebx
  801232:	e8 39 fb ff ff       	call   800d70 <memmove>
	if ((r = sys_page_unmap(0, PFTEMP)) < 0)					//解除当前进程PFTEMP映射
  801237:	83 c4 08             	add    $0x8,%esp
  80123a:	68 00 f0 7f 00       	push   $0x7ff000
  80123f:	6a 00                	push   $0x0
  801241:	e8 1a fe ff ff       	call   801060 <sys_page_unmap>
  801246:	83 c4 10             	add    $0x10,%esp
  801249:	85 c0                	test   %eax,%eax
  80124b:	78 3d                	js     80128a <pgfault+0xbe>
		panic("sys_page_unmap: %e", r);
}
  80124d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801250:	c9                   	leave  
  801251:	c3                   	ret    
		panic("pgfault():not cow");
  801252:	83 ec 04             	sub    $0x4,%esp
  801255:	68 4a 2e 80 00       	push   $0x802e4a
  80125a:	6a 1d                	push   $0x1d
  80125c:	68 5c 2e 80 00       	push   $0x802e5c
  801261:	e8 82 f2 ff ff       	call   8004e8 <_panic>
		panic("sys_page_map: %e", r);
  801266:	50                   	push   %eax
  801267:	68 67 2e 80 00       	push   $0x802e67
  80126c:	6a 2a                	push   $0x2a
  80126e:	68 5c 2e 80 00       	push   $0x802e5c
  801273:	e8 70 f2 ff ff       	call   8004e8 <_panic>
		panic("sys_page_alloc: %e", r);
  801278:	50                   	push   %eax
  801279:	68 78 2e 80 00       	push   $0x802e78
  80127e:	6a 2c                	push   $0x2c
  801280:	68 5c 2e 80 00       	push   $0x802e5c
  801285:	e8 5e f2 ff ff       	call   8004e8 <_panic>
		panic("sys_page_unmap: %e", r);
  80128a:	50                   	push   %eax
  80128b:	68 8b 2e 80 00       	push   $0x802e8b
  801290:	6a 2f                	push   $0x2f
  801292:	68 5c 2e 80 00       	push   $0x802e5c
  801297:	e8 4c f2 ff ff       	call   8004e8 <_panic>

0080129c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	57                   	push   %edi
  8012a0:	56                   	push   %esi
  8012a1:	53                   	push   %ebx
  8012a2:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);	//设置缺页处理函数
  8012a5:	68 cc 11 80 00       	push   $0x8011cc
  8012aa:	e8 1d 13 00 00       	call   8025cc <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8012af:	b8 07 00 00 00       	mov    $0x7,%eax
  8012b4:	cd 30                	int    $0x30
  8012b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();	//系统调用，只是简单创建一个Env结构，复制当前用户环境寄存器状态，UTOP以下的页目录还没有建立
	if (envid == 0) {				//子进程将走这个逻辑
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	74 12                	je     8012d2 <fork+0x36>
  8012c0:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	if (envid < 0) {
  8012c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012c6:	78 26                	js     8012ee <fork+0x52>
		panic("sys_exofork: %e", envid);
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  8012c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012cd:	e9 94 00 00 00       	jmp    801366 <fork+0xca>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012d2:	e8 c6 fc ff ff       	call   800f9d <sys_getenvid>
  8012d7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012dc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012e4:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  8012e9:	e9 51 01 00 00       	jmp    80143f <fork+0x1a3>
		panic("sys_exofork: %e", envid);
  8012ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012f1:	68 9e 2e 80 00       	push   $0x802e9e
  8012f6:	6a 6d                	push   $0x6d
  8012f8:	68 5c 2e 80 00       	push   $0x802e5c
  8012fd:	e8 e6 f1 ff ff       	call   8004e8 <_panic>
		sys_page_map(0, addr, envid, addr, PTE_SYSCALL);		//对于表示为PTE_SHARE的页，拷贝映射关系，并且两个进程都有读写权限
  801302:	83 ec 0c             	sub    $0xc,%esp
  801305:	68 07 0e 00 00       	push   $0xe07
  80130a:	56                   	push   %esi
  80130b:	57                   	push   %edi
  80130c:	56                   	push   %esi
  80130d:	6a 00                	push   $0x0
  80130f:	e8 0a fd ff ff       	call   80101e <sys_page_map>
  801314:	83 c4 20             	add    $0x20,%esp
  801317:	eb 3b                	jmp    801354 <fork+0xb8>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  801319:	83 ec 0c             	sub    $0xc,%esp
  80131c:	68 05 08 00 00       	push   $0x805
  801321:	56                   	push   %esi
  801322:	57                   	push   %edi
  801323:	56                   	push   %esi
  801324:	6a 00                	push   $0x0
  801326:	e8 f3 fc ff ff       	call   80101e <sys_page_map>
  80132b:	83 c4 20             	add    $0x20,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	0f 88 a9 00 00 00    	js     8013df <fork+0x143>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	68 05 08 00 00       	push   $0x805
  80133e:	56                   	push   %esi
  80133f:	6a 00                	push   $0x0
  801341:	56                   	push   %esi
  801342:	6a 00                	push   $0x0
  801344:	e8 d5 fc ff ff       	call   80101e <sys_page_map>
  801349:	83 c4 20             	add    $0x20,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	0f 88 9d 00 00 00    	js     8013f1 <fork+0x155>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801354:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80135a:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801360:	0f 84 9d 00 00 00    	je     801403 <fork+0x167>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) //为什么uvpt[pagenumber]能访问到第pagenumber项页表条目：https://pdos.csail.mit.edu/6.828/2018/labs/lab4/uvpt.html
  801366:	89 d8                	mov    %ebx,%eax
  801368:	c1 e8 16             	shr    $0x16,%eax
  80136b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801372:	a8 01                	test   $0x1,%al
  801374:	74 de                	je     801354 <fork+0xb8>
  801376:	89 d8                	mov    %ebx,%eax
  801378:	c1 e8 0c             	shr    $0xc,%eax
  80137b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801382:	f6 c2 01             	test   $0x1,%dl
  801385:	74 cd                	je     801354 <fork+0xb8>
			&& (uvpt[PGNUM(addr)] & PTE_U)) {
  801387:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80138e:	f6 c2 04             	test   $0x4,%dl
  801391:	74 c1                	je     801354 <fork+0xb8>
	void *addr = (void*) (pn * PGSIZE);
  801393:	89 c6                	mov    %eax,%esi
  801395:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE) {
  801398:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80139f:	f6 c6 04             	test   $0x4,%dh
  8013a2:	0f 85 5a ff ff ff    	jne    801302 <fork+0x66>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) { //对于UTOP以下的可写的或者写时拷贝的页，拷贝映射关系的同时，需要同时标记当前进程和子进程的页表项为PTE_COW
  8013a8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013af:	f6 c2 02             	test   $0x2,%dl
  8013b2:	0f 85 61 ff ff ff    	jne    801319 <fork+0x7d>
  8013b8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013bf:	f6 c4 08             	test   $0x8,%ah
  8013c2:	0f 85 51 ff ff ff    	jne    801319 <fork+0x7d>
		sys_page_map(0, addr, envid, addr, PTE_U|PTE_P);	//对于只读的页，只需要拷贝映射关系即可
  8013c8:	83 ec 0c             	sub    $0xc,%esp
  8013cb:	6a 05                	push   $0x5
  8013cd:	56                   	push   %esi
  8013ce:	57                   	push   %edi
  8013cf:	56                   	push   %esi
  8013d0:	6a 00                	push   $0x0
  8013d2:	e8 47 fc ff ff       	call   80101e <sys_page_map>
  8013d7:	83 c4 20             	add    $0x20,%esp
  8013da:	e9 75 ff ff ff       	jmp    801354 <fork+0xb8>
			panic("sys_page_map：%e", r);
  8013df:	50                   	push   %eax
  8013e0:	68 ae 2e 80 00       	push   $0x802eae
  8013e5:	6a 48                	push   $0x48
  8013e7:	68 5c 2e 80 00       	push   $0x802e5c
  8013ec:	e8 f7 f0 ff ff       	call   8004e8 <_panic>
			panic("sys_page_map：%e", r);
  8013f1:	50                   	push   %eax
  8013f2:	68 ae 2e 80 00       	push   $0x802eae
  8013f7:	6a 4a                	push   $0x4a
  8013f9:	68 5c 2e 80 00       	push   $0x802e5c
  8013fe:	e8 e5 f0 ff ff       	call   8004e8 <_panic>
			duppage(envid, PGNUM(addr));	//拷贝当前进程映射关系到子进程
		}
	}
	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_W | PTE_U)) < 0)	//为子进程分配异常栈
  801403:	83 ec 04             	sub    $0x4,%esp
  801406:	6a 07                	push   $0x7
  801408:	68 00 f0 bf ee       	push   $0xeebff000
  80140d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801410:	e8 c6 fb ff ff       	call   800fdb <sys_page_alloc>
  801415:	83 c4 10             	add    $0x10,%esp
  801418:	85 c0                	test   %eax,%eax
  80141a:	78 2e                	js     80144a <fork+0x1ae>
		panic("sys_page_alloc: %e", r);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);		//为子进程设置_pgfault_upcall
  80141c:	83 ec 08             	sub    $0x8,%esp
  80141f:	68 25 26 80 00       	push   $0x802625
  801424:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801427:	57                   	push   %edi
  801428:	e8 f9 fc ff ff       	call   801126 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)	//设置子进程为ENV_RUNNABLE状态
  80142d:	83 c4 08             	add    $0x8,%esp
  801430:	6a 02                	push   $0x2
  801432:	57                   	push   %edi
  801433:	e8 6a fc ff ff       	call   8010a2 <sys_env_set_status>
  801438:	83 c4 10             	add    $0x10,%esp
  80143b:	85 c0                	test   %eax,%eax
  80143d:	78 1d                	js     80145c <fork+0x1c0>
		panic("sys_env_set_status: %e", r);
	return envid;
}
  80143f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801442:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801445:	5b                   	pop    %ebx
  801446:	5e                   	pop    %esi
  801447:	5f                   	pop    %edi
  801448:	5d                   	pop    %ebp
  801449:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80144a:	50                   	push   %eax
  80144b:	68 78 2e 80 00       	push   $0x802e78
  801450:	6a 79                	push   $0x79
  801452:	68 5c 2e 80 00       	push   $0x802e5c
  801457:	e8 8c f0 ff ff       	call   8004e8 <_panic>
		panic("sys_env_set_status: %e", r);
  80145c:	50                   	push   %eax
  80145d:	68 c0 2e 80 00       	push   $0x802ec0
  801462:	6a 7d                	push   $0x7d
  801464:	68 5c 2e 80 00       	push   $0x802e5c
  801469:	e8 7a f0 ff ff       	call   8004e8 <_panic>

0080146e <sfork>:

// Challenge!
int
sfork(void)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801474:	68 d7 2e 80 00       	push   $0x802ed7
  801479:	68 85 00 00 00       	push   $0x85
  80147e:	68 5c 2e 80 00       	push   $0x802e5c
  801483:	e8 60 f0 ff ff       	call   8004e8 <_panic>

00801488 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	05 00 00 00 30       	add    $0x30000000,%eax
  801493:	c1 e8 0c             	shr    $0xc,%eax
}
  801496:	5d                   	pop    %ebp
  801497:	c3                   	ret    

00801498 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8014a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014a8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014ad:	5d                   	pop    %ebp
  8014ae:	c3                   	ret    

008014af <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014b5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014ba:	89 c2                	mov    %eax,%edx
  8014bc:	c1 ea 16             	shr    $0x16,%edx
  8014bf:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014c6:	f6 c2 01             	test   $0x1,%dl
  8014c9:	74 2a                	je     8014f5 <fd_alloc+0x46>
  8014cb:	89 c2                	mov    %eax,%edx
  8014cd:	c1 ea 0c             	shr    $0xc,%edx
  8014d0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014d7:	f6 c2 01             	test   $0x1,%dl
  8014da:	74 19                	je     8014f5 <fd_alloc+0x46>
  8014dc:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014e1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014e6:	75 d2                	jne    8014ba <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014e8:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8014ee:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014f3:	eb 07                	jmp    8014fc <fd_alloc+0x4d>
			*fd_store = fd;
  8014f5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014fc:	5d                   	pop    %ebp
  8014fd:	c3                   	ret    

008014fe <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801504:	83 f8 1f             	cmp    $0x1f,%eax
  801507:	77 36                	ja     80153f <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801509:	c1 e0 0c             	shl    $0xc,%eax
  80150c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801511:	89 c2                	mov    %eax,%edx
  801513:	c1 ea 16             	shr    $0x16,%edx
  801516:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80151d:	f6 c2 01             	test   $0x1,%dl
  801520:	74 24                	je     801546 <fd_lookup+0x48>
  801522:	89 c2                	mov    %eax,%edx
  801524:	c1 ea 0c             	shr    $0xc,%edx
  801527:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80152e:	f6 c2 01             	test   $0x1,%dl
  801531:	74 1a                	je     80154d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801533:	8b 55 0c             	mov    0xc(%ebp),%edx
  801536:	89 02                	mov    %eax,(%edx)
	return 0;
  801538:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153d:	5d                   	pop    %ebp
  80153e:	c3                   	ret    
		return -E_INVAL;
  80153f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801544:	eb f7                	jmp    80153d <fd_lookup+0x3f>
		return -E_INVAL;
  801546:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80154b:	eb f0                	jmp    80153d <fd_lookup+0x3f>
  80154d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801552:	eb e9                	jmp    80153d <fd_lookup+0x3f>

00801554 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	83 ec 08             	sub    $0x8,%esp
  80155a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80155d:	ba 6c 2f 80 00       	mov    $0x802f6c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801562:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801567:	39 08                	cmp    %ecx,(%eax)
  801569:	74 33                	je     80159e <dev_lookup+0x4a>
  80156b:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80156e:	8b 02                	mov    (%edx),%eax
  801570:	85 c0                	test   %eax,%eax
  801572:	75 f3                	jne    801567 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801574:	a1 04 50 80 00       	mov    0x805004,%eax
  801579:	8b 40 48             	mov    0x48(%eax),%eax
  80157c:	83 ec 04             	sub    $0x4,%esp
  80157f:	51                   	push   %ecx
  801580:	50                   	push   %eax
  801581:	68 f0 2e 80 00       	push   $0x802ef0
  801586:	e8 38 f0 ff ff       	call   8005c3 <cprintf>
	*dev = 0;
  80158b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801594:	83 c4 10             	add    $0x10,%esp
  801597:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    
			*dev = devtab[i];
  80159e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015a1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a8:	eb f2                	jmp    80159c <dev_lookup+0x48>

008015aa <fd_close>:
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	57                   	push   %edi
  8015ae:	56                   	push   %esi
  8015af:	53                   	push   %ebx
  8015b0:	83 ec 1c             	sub    $0x1c,%esp
  8015b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8015b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015b9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015bc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015bd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015c3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015c6:	50                   	push   %eax
  8015c7:	e8 32 ff ff ff       	call   8014fe <fd_lookup>
  8015cc:	89 c3                	mov    %eax,%ebx
  8015ce:	83 c4 08             	add    $0x8,%esp
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	78 05                	js     8015da <fd_close+0x30>
	    || fd != fd2)
  8015d5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015d8:	74 16                	je     8015f0 <fd_close+0x46>
		return (must_exist ? r : 0);
  8015da:	89 f8                	mov    %edi,%eax
  8015dc:	84 c0                	test   %al,%al
  8015de:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e3:	0f 44 d8             	cmove  %eax,%ebx
}
  8015e6:	89 d8                	mov    %ebx,%eax
  8015e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015eb:	5b                   	pop    %ebx
  8015ec:	5e                   	pop    %esi
  8015ed:	5f                   	pop    %edi
  8015ee:	5d                   	pop    %ebp
  8015ef:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015f0:	83 ec 08             	sub    $0x8,%esp
  8015f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015f6:	50                   	push   %eax
  8015f7:	ff 36                	pushl  (%esi)
  8015f9:	e8 56 ff ff ff       	call   801554 <dev_lookup>
  8015fe:	89 c3                	mov    %eax,%ebx
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	85 c0                	test   %eax,%eax
  801605:	78 15                	js     80161c <fd_close+0x72>
		if (dev->dev_close)
  801607:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80160a:	8b 40 10             	mov    0x10(%eax),%eax
  80160d:	85 c0                	test   %eax,%eax
  80160f:	74 1b                	je     80162c <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801611:	83 ec 0c             	sub    $0xc,%esp
  801614:	56                   	push   %esi
  801615:	ff d0                	call   *%eax
  801617:	89 c3                	mov    %eax,%ebx
  801619:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80161c:	83 ec 08             	sub    $0x8,%esp
  80161f:	56                   	push   %esi
  801620:	6a 00                	push   $0x0
  801622:	e8 39 fa ff ff       	call   801060 <sys_page_unmap>
	return r;
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	eb ba                	jmp    8015e6 <fd_close+0x3c>
			r = 0;
  80162c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801631:	eb e9                	jmp    80161c <fd_close+0x72>

00801633 <close>:

int
close(int fdnum)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801639:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163c:	50                   	push   %eax
  80163d:	ff 75 08             	pushl  0x8(%ebp)
  801640:	e8 b9 fe ff ff       	call   8014fe <fd_lookup>
  801645:	83 c4 08             	add    $0x8,%esp
  801648:	85 c0                	test   %eax,%eax
  80164a:	78 10                	js     80165c <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	6a 01                	push   $0x1
  801651:	ff 75 f4             	pushl  -0xc(%ebp)
  801654:	e8 51 ff ff ff       	call   8015aa <fd_close>
  801659:	83 c4 10             	add    $0x10,%esp
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <close_all>:

void
close_all(void)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	53                   	push   %ebx
  801662:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801665:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80166a:	83 ec 0c             	sub    $0xc,%esp
  80166d:	53                   	push   %ebx
  80166e:	e8 c0 ff ff ff       	call   801633 <close>
	for (i = 0; i < MAXFD; i++)
  801673:	83 c3 01             	add    $0x1,%ebx
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	83 fb 20             	cmp    $0x20,%ebx
  80167c:	75 ec                	jne    80166a <close_all+0xc>
}
  80167e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	57                   	push   %edi
  801687:	56                   	push   %esi
  801688:	53                   	push   %ebx
  801689:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80168c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80168f:	50                   	push   %eax
  801690:	ff 75 08             	pushl  0x8(%ebp)
  801693:	e8 66 fe ff ff       	call   8014fe <fd_lookup>
  801698:	89 c3                	mov    %eax,%ebx
  80169a:	83 c4 08             	add    $0x8,%esp
  80169d:	85 c0                	test   %eax,%eax
  80169f:	0f 88 81 00 00 00    	js     801726 <dup+0xa3>
		return r;
	close(newfdnum);
  8016a5:	83 ec 0c             	sub    $0xc,%esp
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	e8 83 ff ff ff       	call   801633 <close>

	newfd = INDEX2FD(newfdnum);
  8016b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016b3:	c1 e6 0c             	shl    $0xc,%esi
  8016b6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016bc:	83 c4 04             	add    $0x4,%esp
  8016bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016c2:	e8 d1 fd ff ff       	call   801498 <fd2data>
  8016c7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016c9:	89 34 24             	mov    %esi,(%esp)
  8016cc:	e8 c7 fd ff ff       	call   801498 <fd2data>
  8016d1:	83 c4 10             	add    $0x10,%esp
  8016d4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016d6:	89 d8                	mov    %ebx,%eax
  8016d8:	c1 e8 16             	shr    $0x16,%eax
  8016db:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016e2:	a8 01                	test   $0x1,%al
  8016e4:	74 11                	je     8016f7 <dup+0x74>
  8016e6:	89 d8                	mov    %ebx,%eax
  8016e8:	c1 e8 0c             	shr    $0xc,%eax
  8016eb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016f2:	f6 c2 01             	test   $0x1,%dl
  8016f5:	75 39                	jne    801730 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016fa:	89 d0                	mov    %edx,%eax
  8016fc:	c1 e8 0c             	shr    $0xc,%eax
  8016ff:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801706:	83 ec 0c             	sub    $0xc,%esp
  801709:	25 07 0e 00 00       	and    $0xe07,%eax
  80170e:	50                   	push   %eax
  80170f:	56                   	push   %esi
  801710:	6a 00                	push   $0x0
  801712:	52                   	push   %edx
  801713:	6a 00                	push   $0x0
  801715:	e8 04 f9 ff ff       	call   80101e <sys_page_map>
  80171a:	89 c3                	mov    %eax,%ebx
  80171c:	83 c4 20             	add    $0x20,%esp
  80171f:	85 c0                	test   %eax,%eax
  801721:	78 31                	js     801754 <dup+0xd1>
		goto err;

	return newfdnum;
  801723:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801726:	89 d8                	mov    %ebx,%eax
  801728:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80172b:	5b                   	pop    %ebx
  80172c:	5e                   	pop    %esi
  80172d:	5f                   	pop    %edi
  80172e:	5d                   	pop    %ebp
  80172f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801730:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801737:	83 ec 0c             	sub    $0xc,%esp
  80173a:	25 07 0e 00 00       	and    $0xe07,%eax
  80173f:	50                   	push   %eax
  801740:	57                   	push   %edi
  801741:	6a 00                	push   $0x0
  801743:	53                   	push   %ebx
  801744:	6a 00                	push   $0x0
  801746:	e8 d3 f8 ff ff       	call   80101e <sys_page_map>
  80174b:	89 c3                	mov    %eax,%ebx
  80174d:	83 c4 20             	add    $0x20,%esp
  801750:	85 c0                	test   %eax,%eax
  801752:	79 a3                	jns    8016f7 <dup+0x74>
	sys_page_unmap(0, newfd);
  801754:	83 ec 08             	sub    $0x8,%esp
  801757:	56                   	push   %esi
  801758:	6a 00                	push   $0x0
  80175a:	e8 01 f9 ff ff       	call   801060 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80175f:	83 c4 08             	add    $0x8,%esp
  801762:	57                   	push   %edi
  801763:	6a 00                	push   $0x0
  801765:	e8 f6 f8 ff ff       	call   801060 <sys_page_unmap>
	return r;
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	eb b7                	jmp    801726 <dup+0xa3>

0080176f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	53                   	push   %ebx
  801773:	83 ec 14             	sub    $0x14,%esp
  801776:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801779:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80177c:	50                   	push   %eax
  80177d:	53                   	push   %ebx
  80177e:	e8 7b fd ff ff       	call   8014fe <fd_lookup>
  801783:	83 c4 08             	add    $0x8,%esp
  801786:	85 c0                	test   %eax,%eax
  801788:	78 3f                	js     8017c9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80178a:	83 ec 08             	sub    $0x8,%esp
  80178d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801790:	50                   	push   %eax
  801791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801794:	ff 30                	pushl  (%eax)
  801796:	e8 b9 fd ff ff       	call   801554 <dev_lookup>
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	85 c0                	test   %eax,%eax
  8017a0:	78 27                	js     8017c9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a5:	8b 42 08             	mov    0x8(%edx),%eax
  8017a8:	83 e0 03             	and    $0x3,%eax
  8017ab:	83 f8 01             	cmp    $0x1,%eax
  8017ae:	74 1e                	je     8017ce <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b3:	8b 40 08             	mov    0x8(%eax),%eax
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	74 35                	je     8017ef <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	ff 75 10             	pushl  0x10(%ebp)
  8017c0:	ff 75 0c             	pushl  0xc(%ebp)
  8017c3:	52                   	push   %edx
  8017c4:	ff d0                	call   *%eax
  8017c6:	83 c4 10             	add    $0x10,%esp
}
  8017c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ce:	a1 04 50 80 00       	mov    0x805004,%eax
  8017d3:	8b 40 48             	mov    0x48(%eax),%eax
  8017d6:	83 ec 04             	sub    $0x4,%esp
  8017d9:	53                   	push   %ebx
  8017da:	50                   	push   %eax
  8017db:	68 31 2f 80 00       	push   $0x802f31
  8017e0:	e8 de ed ff ff       	call   8005c3 <cprintf>
		return -E_INVAL;
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ed:	eb da                	jmp    8017c9 <read+0x5a>
		return -E_NOT_SUPP;
  8017ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f4:	eb d3                	jmp    8017c9 <read+0x5a>

008017f6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	57                   	push   %edi
  8017fa:	56                   	push   %esi
  8017fb:	53                   	push   %ebx
  8017fc:	83 ec 0c             	sub    $0xc,%esp
  8017ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  801802:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801805:	bb 00 00 00 00       	mov    $0x0,%ebx
  80180a:	39 f3                	cmp    %esi,%ebx
  80180c:	73 25                	jae    801833 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	89 f0                	mov    %esi,%eax
  801813:	29 d8                	sub    %ebx,%eax
  801815:	50                   	push   %eax
  801816:	89 d8                	mov    %ebx,%eax
  801818:	03 45 0c             	add    0xc(%ebp),%eax
  80181b:	50                   	push   %eax
  80181c:	57                   	push   %edi
  80181d:	e8 4d ff ff ff       	call   80176f <read>
		if (m < 0)
  801822:	83 c4 10             	add    $0x10,%esp
  801825:	85 c0                	test   %eax,%eax
  801827:	78 08                	js     801831 <readn+0x3b>
			return m;
		if (m == 0)
  801829:	85 c0                	test   %eax,%eax
  80182b:	74 06                	je     801833 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80182d:	01 c3                	add    %eax,%ebx
  80182f:	eb d9                	jmp    80180a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801831:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801833:	89 d8                	mov    %ebx,%eax
  801835:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801838:	5b                   	pop    %ebx
  801839:	5e                   	pop    %esi
  80183a:	5f                   	pop    %edi
  80183b:	5d                   	pop    %ebp
  80183c:	c3                   	ret    

0080183d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	53                   	push   %ebx
  801841:	83 ec 14             	sub    $0x14,%esp
  801844:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801847:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80184a:	50                   	push   %eax
  80184b:	53                   	push   %ebx
  80184c:	e8 ad fc ff ff       	call   8014fe <fd_lookup>
  801851:	83 c4 08             	add    $0x8,%esp
  801854:	85 c0                	test   %eax,%eax
  801856:	78 3a                	js     801892 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801858:	83 ec 08             	sub    $0x8,%esp
  80185b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80185e:	50                   	push   %eax
  80185f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801862:	ff 30                	pushl  (%eax)
  801864:	e8 eb fc ff ff       	call   801554 <dev_lookup>
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	85 c0                	test   %eax,%eax
  80186e:	78 22                	js     801892 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801873:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801877:	74 1e                	je     801897 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801879:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80187c:	8b 52 0c             	mov    0xc(%edx),%edx
  80187f:	85 d2                	test   %edx,%edx
  801881:	74 35                	je     8018b8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801883:	83 ec 04             	sub    $0x4,%esp
  801886:	ff 75 10             	pushl  0x10(%ebp)
  801889:	ff 75 0c             	pushl  0xc(%ebp)
  80188c:	50                   	push   %eax
  80188d:	ff d2                	call   *%edx
  80188f:	83 c4 10             	add    $0x10,%esp
}
  801892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801895:	c9                   	leave  
  801896:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801897:	a1 04 50 80 00       	mov    0x805004,%eax
  80189c:	8b 40 48             	mov    0x48(%eax),%eax
  80189f:	83 ec 04             	sub    $0x4,%esp
  8018a2:	53                   	push   %ebx
  8018a3:	50                   	push   %eax
  8018a4:	68 4d 2f 80 00       	push   $0x802f4d
  8018a9:	e8 15 ed ff ff       	call   8005c3 <cprintf>
		return -E_INVAL;
  8018ae:	83 c4 10             	add    $0x10,%esp
  8018b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018b6:	eb da                	jmp    801892 <write+0x55>
		return -E_NOT_SUPP;
  8018b8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018bd:	eb d3                	jmp    801892 <write+0x55>

008018bf <seek>:

int
seek(int fdnum, off_t offset)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018c5:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018c8:	50                   	push   %eax
  8018c9:	ff 75 08             	pushl  0x8(%ebp)
  8018cc:	e8 2d fc ff ff       	call   8014fe <fd_lookup>
  8018d1:	83 c4 08             	add    $0x8,%esp
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	78 0e                	js     8018e6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8018d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018de:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	53                   	push   %ebx
  8018ec:	83 ec 14             	sub    $0x14,%esp
  8018ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f5:	50                   	push   %eax
  8018f6:	53                   	push   %ebx
  8018f7:	e8 02 fc ff ff       	call   8014fe <fd_lookup>
  8018fc:	83 c4 08             	add    $0x8,%esp
  8018ff:	85 c0                	test   %eax,%eax
  801901:	78 37                	js     80193a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801903:	83 ec 08             	sub    $0x8,%esp
  801906:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801909:	50                   	push   %eax
  80190a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190d:	ff 30                	pushl  (%eax)
  80190f:	e8 40 fc ff ff       	call   801554 <dev_lookup>
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	85 c0                	test   %eax,%eax
  801919:	78 1f                	js     80193a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80191b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801922:	74 1b                	je     80193f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801924:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801927:	8b 52 18             	mov    0x18(%edx),%edx
  80192a:	85 d2                	test   %edx,%edx
  80192c:	74 32                	je     801960 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80192e:	83 ec 08             	sub    $0x8,%esp
  801931:	ff 75 0c             	pushl  0xc(%ebp)
  801934:	50                   	push   %eax
  801935:	ff d2                	call   *%edx
  801937:	83 c4 10             	add    $0x10,%esp
}
  80193a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80193f:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801944:	8b 40 48             	mov    0x48(%eax),%eax
  801947:	83 ec 04             	sub    $0x4,%esp
  80194a:	53                   	push   %ebx
  80194b:	50                   	push   %eax
  80194c:	68 10 2f 80 00       	push   $0x802f10
  801951:	e8 6d ec ff ff       	call   8005c3 <cprintf>
		return -E_INVAL;
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80195e:	eb da                	jmp    80193a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801960:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801965:	eb d3                	jmp    80193a <ftruncate+0x52>

00801967 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	53                   	push   %ebx
  80196b:	83 ec 14             	sub    $0x14,%esp
  80196e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801971:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801974:	50                   	push   %eax
  801975:	ff 75 08             	pushl  0x8(%ebp)
  801978:	e8 81 fb ff ff       	call   8014fe <fd_lookup>
  80197d:	83 c4 08             	add    $0x8,%esp
  801980:	85 c0                	test   %eax,%eax
  801982:	78 4b                	js     8019cf <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801984:	83 ec 08             	sub    $0x8,%esp
  801987:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198a:	50                   	push   %eax
  80198b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198e:	ff 30                	pushl  (%eax)
  801990:	e8 bf fb ff ff       	call   801554 <dev_lookup>
  801995:	83 c4 10             	add    $0x10,%esp
  801998:	85 c0                	test   %eax,%eax
  80199a:	78 33                	js     8019cf <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80199c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019a3:	74 2f                	je     8019d4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019a5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019a8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019af:	00 00 00 
	stat->st_isdir = 0;
  8019b2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019b9:	00 00 00 
	stat->st_dev = dev;
  8019bc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019c2:	83 ec 08             	sub    $0x8,%esp
  8019c5:	53                   	push   %ebx
  8019c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8019c9:	ff 50 14             	call   *0x14(%eax)
  8019cc:	83 c4 10             	add    $0x10,%esp
}
  8019cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    
		return -E_NOT_SUPP;
  8019d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019d9:	eb f4                	jmp    8019cf <fstat+0x68>

008019db <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	56                   	push   %esi
  8019df:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019e0:	83 ec 08             	sub    $0x8,%esp
  8019e3:	6a 00                	push   $0x0
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	e8 30 02 00 00       	call   801c1d <open>
  8019ed:	89 c3                	mov    %eax,%ebx
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	78 1b                	js     801a11 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8019f6:	83 ec 08             	sub    $0x8,%esp
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	50                   	push   %eax
  8019fd:	e8 65 ff ff ff       	call   801967 <fstat>
  801a02:	89 c6                	mov    %eax,%esi
	close(fd);
  801a04:	89 1c 24             	mov    %ebx,(%esp)
  801a07:	e8 27 fc ff ff       	call   801633 <close>
	return r;
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	89 f3                	mov    %esi,%ebx
}
  801a11:	89 d8                	mov    %ebx,%eax
  801a13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a16:	5b                   	pop    %ebx
  801a17:	5e                   	pop    %esi
  801a18:	5d                   	pop    %ebp
  801a19:	c3                   	ret    

00801a1a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	56                   	push   %esi
  801a1e:	53                   	push   %ebx
  801a1f:	89 c6                	mov    %eax,%esi
  801a21:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a23:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a2a:	74 27                	je     801a53 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a2c:	6a 07                	push   $0x7
  801a2e:	68 00 60 80 00       	push   $0x806000
  801a33:	56                   	push   %esi
  801a34:	ff 35 00 50 80 00    	pushl  0x805000
  801a3a:	e8 73 0c 00 00       	call   8026b2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a3f:	83 c4 0c             	add    $0xc,%esp
  801a42:	6a 00                	push   $0x0
  801a44:	53                   	push   %ebx
  801a45:	6a 00                	push   $0x0
  801a47:	e8 fd 0b 00 00       	call   802649 <ipc_recv>
}
  801a4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4f:	5b                   	pop    %ebx
  801a50:	5e                   	pop    %esi
  801a51:	5d                   	pop    %ebp
  801a52:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a53:	83 ec 0c             	sub    $0xc,%esp
  801a56:	6a 01                	push   $0x1
  801a58:	e8 a9 0c 00 00       	call   802706 <ipc_find_env>
  801a5d:	a3 00 50 80 00       	mov    %eax,0x805000
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	eb c5                	jmp    801a2c <fsipc+0x12>

00801a67 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	8b 40 0c             	mov    0xc(%eax),%eax
  801a73:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7b:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a80:	ba 00 00 00 00       	mov    $0x0,%edx
  801a85:	b8 02 00 00 00       	mov    $0x2,%eax
  801a8a:	e8 8b ff ff ff       	call   801a1a <fsipc>
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <devfile_flush>:
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801a9d:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801aa2:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa7:	b8 06 00 00 00       	mov    $0x6,%eax
  801aac:	e8 69 ff ff ff       	call   801a1a <fsipc>
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <devfile_stat>:
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	53                   	push   %ebx
  801ab7:	83 ec 04             	sub    $0x4,%esp
  801aba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac3:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ac8:	ba 00 00 00 00       	mov    $0x0,%edx
  801acd:	b8 05 00 00 00       	mov    $0x5,%eax
  801ad2:	e8 43 ff ff ff       	call   801a1a <fsipc>
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	78 2c                	js     801b07 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801adb:	83 ec 08             	sub    $0x8,%esp
  801ade:	68 00 60 80 00       	push   $0x806000
  801ae3:	53                   	push   %ebx
  801ae4:	e8 f9 f0 ff ff       	call   800be2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ae9:	a1 80 60 80 00       	mov    0x806080,%eax
  801aee:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801af4:	a1 84 60 80 00       	mov    0x806084,%eax
  801af9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801aff:	83 c4 10             	add    $0x10,%esp
  801b02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <devfile_write>:
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	53                   	push   %ebx
  801b10:	83 ec 08             	sub    $0x8,%esp
  801b13:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  801b16:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801b1c:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801b21:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	8b 40 0c             	mov    0xc(%eax),%eax
  801b2a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801b2f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801b35:	53                   	push   %ebx
  801b36:	ff 75 0c             	pushl  0xc(%ebp)
  801b39:	68 08 60 80 00       	push   $0x806008
  801b3e:	e8 2d f2 ff ff       	call   800d70 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b43:	ba 00 00 00 00       	mov    $0x0,%edx
  801b48:	b8 04 00 00 00       	mov    $0x4,%eax
  801b4d:	e8 c8 fe ff ff       	call   801a1a <fsipc>
  801b52:	83 c4 10             	add    $0x10,%esp
  801b55:	85 c0                	test   %eax,%eax
  801b57:	78 0b                	js     801b64 <devfile_write+0x58>
	assert(r <= n);
  801b59:	39 d8                	cmp    %ebx,%eax
  801b5b:	77 0c                	ja     801b69 <devfile_write+0x5d>
	assert(r <= PGSIZE);
  801b5d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b62:	7f 1e                	jg     801b82 <devfile_write+0x76>
}
  801b64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    
	assert(r <= n);
  801b69:	68 7c 2f 80 00       	push   $0x802f7c
  801b6e:	68 83 2f 80 00       	push   $0x802f83
  801b73:	68 98 00 00 00       	push   $0x98
  801b78:	68 98 2f 80 00       	push   $0x802f98
  801b7d:	e8 66 e9 ff ff       	call   8004e8 <_panic>
	assert(r <= PGSIZE);
  801b82:	68 a3 2f 80 00       	push   $0x802fa3
  801b87:	68 83 2f 80 00       	push   $0x802f83
  801b8c:	68 99 00 00 00       	push   $0x99
  801b91:	68 98 2f 80 00       	push   $0x802f98
  801b96:	e8 4d e9 ff ff       	call   8004e8 <_panic>

00801b9b <devfile_read>:
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	56                   	push   %esi
  801b9f:	53                   	push   %ebx
  801ba0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801bae:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bb4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb9:	b8 03 00 00 00       	mov    $0x3,%eax
  801bbe:	e8 57 fe ff ff       	call   801a1a <fsipc>
  801bc3:	89 c3                	mov    %eax,%ebx
  801bc5:	85 c0                	test   %eax,%eax
  801bc7:	78 1f                	js     801be8 <devfile_read+0x4d>
	assert(r <= n);
  801bc9:	39 f0                	cmp    %esi,%eax
  801bcb:	77 24                	ja     801bf1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801bcd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bd2:	7f 33                	jg     801c07 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bd4:	83 ec 04             	sub    $0x4,%esp
  801bd7:	50                   	push   %eax
  801bd8:	68 00 60 80 00       	push   $0x806000
  801bdd:	ff 75 0c             	pushl  0xc(%ebp)
  801be0:	e8 8b f1 ff ff       	call   800d70 <memmove>
	return r;
  801be5:	83 c4 10             	add    $0x10,%esp
}
  801be8:	89 d8                	mov    %ebx,%eax
  801bea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bed:	5b                   	pop    %ebx
  801bee:	5e                   	pop    %esi
  801bef:	5d                   	pop    %ebp
  801bf0:	c3                   	ret    
	assert(r <= n);
  801bf1:	68 7c 2f 80 00       	push   $0x802f7c
  801bf6:	68 83 2f 80 00       	push   $0x802f83
  801bfb:	6a 7c                	push   $0x7c
  801bfd:	68 98 2f 80 00       	push   $0x802f98
  801c02:	e8 e1 e8 ff ff       	call   8004e8 <_panic>
	assert(r <= PGSIZE);
  801c07:	68 a3 2f 80 00       	push   $0x802fa3
  801c0c:	68 83 2f 80 00       	push   $0x802f83
  801c11:	6a 7d                	push   $0x7d
  801c13:	68 98 2f 80 00       	push   $0x802f98
  801c18:	e8 cb e8 ff ff       	call   8004e8 <_panic>

00801c1d <open>:
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	56                   	push   %esi
  801c21:	53                   	push   %ebx
  801c22:	83 ec 1c             	sub    $0x1c,%esp
  801c25:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c28:	56                   	push   %esi
  801c29:	e8 7d ef ff ff       	call   800bab <strlen>
  801c2e:	83 c4 10             	add    $0x10,%esp
  801c31:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c36:	7f 6c                	jg     801ca4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c38:	83 ec 0c             	sub    $0xc,%esp
  801c3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c3e:	50                   	push   %eax
  801c3f:	e8 6b f8 ff ff       	call   8014af <fd_alloc>
  801c44:	89 c3                	mov    %eax,%ebx
  801c46:	83 c4 10             	add    $0x10,%esp
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	78 3c                	js     801c89 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c4d:	83 ec 08             	sub    $0x8,%esp
  801c50:	56                   	push   %esi
  801c51:	68 00 60 80 00       	push   $0x806000
  801c56:	e8 87 ef ff ff       	call   800be2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5e:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c66:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6b:	e8 aa fd ff ff       	call   801a1a <fsipc>
  801c70:	89 c3                	mov    %eax,%ebx
  801c72:	83 c4 10             	add    $0x10,%esp
  801c75:	85 c0                	test   %eax,%eax
  801c77:	78 19                	js     801c92 <open+0x75>
	return fd2num(fd);
  801c79:	83 ec 0c             	sub    $0xc,%esp
  801c7c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7f:	e8 04 f8 ff ff       	call   801488 <fd2num>
  801c84:	89 c3                	mov    %eax,%ebx
  801c86:	83 c4 10             	add    $0x10,%esp
}
  801c89:	89 d8                	mov    %ebx,%eax
  801c8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8e:	5b                   	pop    %ebx
  801c8f:	5e                   	pop    %esi
  801c90:	5d                   	pop    %ebp
  801c91:	c3                   	ret    
		fd_close(fd, 0);
  801c92:	83 ec 08             	sub    $0x8,%esp
  801c95:	6a 00                	push   $0x0
  801c97:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9a:	e8 0b f9 ff ff       	call   8015aa <fd_close>
		return r;
  801c9f:	83 c4 10             	add    $0x10,%esp
  801ca2:	eb e5                	jmp    801c89 <open+0x6c>
		return -E_BAD_PATH;
  801ca4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ca9:	eb de                	jmp    801c89 <open+0x6c>

00801cab <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cb1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb6:	b8 08 00 00 00       	mov    $0x8,%eax
  801cbb:	e8 5a fd ff ff       	call   801a1a <fsipc>
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	57                   	push   %edi
  801cc6:	56                   	push   %esi
  801cc7:	53                   	push   %ebx
  801cc8:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801cce:	6a 00                	push   $0x0
  801cd0:	ff 75 08             	pushl  0x8(%ebp)
  801cd3:	e8 45 ff ff ff       	call   801c1d <open>
  801cd8:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801cde:	83 c4 10             	add    $0x10,%esp
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	0f 88 40 03 00 00    	js     802029 <spawn+0x367>
  801ce9:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801ceb:	83 ec 04             	sub    $0x4,%esp
  801cee:	68 00 02 00 00       	push   $0x200
  801cf3:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801cf9:	50                   	push   %eax
  801cfa:	52                   	push   %edx
  801cfb:	e8 f6 fa ff ff       	call   8017f6 <readn>
  801d00:	83 c4 10             	add    $0x10,%esp
  801d03:	3d 00 02 00 00       	cmp    $0x200,%eax
  801d08:	75 5d                	jne    801d67 <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  801d0a:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801d11:	45 4c 46 
  801d14:	75 51                	jne    801d67 <spawn+0xa5>
  801d16:	b8 07 00 00 00       	mov    $0x7,%eax
  801d1b:	cd 30                	int    $0x30
  801d1d:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801d23:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	0f 88 2f 04 00 00    	js     802160 <spawn+0x49e>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801d31:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d36:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801d39:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801d3f:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801d45:	b9 11 00 00 00       	mov    $0x11,%ecx
  801d4a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801d4c:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801d52:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801d58:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801d5d:	be 00 00 00 00       	mov    $0x0,%esi
  801d62:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d65:	eb 4b                	jmp    801db2 <spawn+0xf0>
		close(fd);
  801d67:	83 ec 0c             	sub    $0xc,%esp
  801d6a:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801d70:	e8 be f8 ff ff       	call   801633 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801d75:	83 c4 0c             	add    $0xc,%esp
  801d78:	68 7f 45 4c 46       	push   $0x464c457f
  801d7d:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801d83:	68 af 2f 80 00       	push   $0x802faf
  801d88:	e8 36 e8 ff ff       	call   8005c3 <cprintf>
		return -E_NOT_EXEC;
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  801d97:	ff ff ff 
  801d9a:	e9 8a 02 00 00       	jmp    802029 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  801d9f:	83 ec 0c             	sub    $0xc,%esp
  801da2:	50                   	push   %eax
  801da3:	e8 03 ee ff ff       	call   800bab <strlen>
  801da8:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801dac:	83 c3 01             	add    $0x1,%ebx
  801daf:	83 c4 10             	add    $0x10,%esp
  801db2:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801db9:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	75 df                	jne    801d9f <spawn+0xdd>
  801dc0:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801dc6:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801dcc:	bf 00 10 40 00       	mov    $0x401000,%edi
  801dd1:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801dd3:	89 fa                	mov    %edi,%edx
  801dd5:	83 e2 fc             	and    $0xfffffffc,%edx
  801dd8:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801ddf:	29 c2                	sub    %eax,%edx
  801de1:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801de7:	8d 42 f8             	lea    -0x8(%edx),%eax
  801dea:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801def:	0f 86 7c 03 00 00    	jbe    802171 <spawn+0x4af>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801df5:	83 ec 04             	sub    $0x4,%esp
  801df8:	6a 07                	push   $0x7
  801dfa:	68 00 00 40 00       	push   $0x400000
  801dff:	6a 00                	push   $0x0
  801e01:	e8 d5 f1 ff ff       	call   800fdb <sys_page_alloc>
  801e06:	83 c4 10             	add    $0x10,%esp
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	0f 88 65 03 00 00    	js     802176 <spawn+0x4b4>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801e11:	be 00 00 00 00       	mov    $0x0,%esi
  801e16:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801e1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801e1f:	eb 30                	jmp    801e51 <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  801e21:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801e27:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801e2d:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  801e30:	83 ec 08             	sub    $0x8,%esp
  801e33:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801e36:	57                   	push   %edi
  801e37:	e8 a6 ed ff ff       	call   800be2 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801e3c:	83 c4 04             	add    $0x4,%esp
  801e3f:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801e42:	e8 64 ed ff ff       	call   800bab <strlen>
  801e47:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801e4b:	83 c6 01             	add    $0x1,%esi
  801e4e:	83 c4 10             	add    $0x10,%esp
  801e51:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801e57:	7f c8                	jg     801e21 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801e59:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e5f:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801e65:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801e6c:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801e72:	0f 85 8c 00 00 00    	jne    801f04 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801e78:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801e7e:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801e84:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801e87:	89 f8                	mov    %edi,%eax
  801e89:	8b 8d 88 fd ff ff    	mov    -0x278(%ebp),%ecx
  801e8f:	89 4f f8             	mov    %ecx,-0x8(%edi)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801e92:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801e97:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801e9d:	83 ec 0c             	sub    $0xc,%esp
  801ea0:	6a 07                	push   $0x7
  801ea2:	68 00 d0 bf ee       	push   $0xeebfd000
  801ea7:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ead:	68 00 00 40 00       	push   $0x400000
  801eb2:	6a 00                	push   $0x0
  801eb4:	e8 65 f1 ff ff       	call   80101e <sys_page_map>
  801eb9:	89 c3                	mov    %eax,%ebx
  801ebb:	83 c4 20             	add    $0x20,%esp
  801ebe:	85 c0                	test   %eax,%eax
  801ec0:	0f 88 d0 02 00 00    	js     802196 <spawn+0x4d4>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801ec6:	83 ec 08             	sub    $0x8,%esp
  801ec9:	68 00 00 40 00       	push   $0x400000
  801ece:	6a 00                	push   $0x0
  801ed0:	e8 8b f1 ff ff       	call   801060 <sys_page_unmap>
  801ed5:	89 c3                	mov    %eax,%ebx
  801ed7:	83 c4 10             	add    $0x10,%esp
  801eda:	85 c0                	test   %eax,%eax
  801edc:	0f 88 b4 02 00 00    	js     802196 <spawn+0x4d4>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801ee2:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801ee8:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801eef:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ef5:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801efc:	00 00 00 
  801eff:	e9 56 01 00 00       	jmp    80205a <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801f04:	68 0c 30 80 00       	push   $0x80300c
  801f09:	68 83 2f 80 00       	push   $0x802f83
  801f0e:	68 f2 00 00 00       	push   $0xf2
  801f13:	68 c9 2f 80 00       	push   $0x802fc9
  801f18:	e8 cb e5 ff ff       	call   8004e8 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f1d:	83 ec 04             	sub    $0x4,%esp
  801f20:	6a 07                	push   $0x7
  801f22:	68 00 00 40 00       	push   $0x400000
  801f27:	6a 00                	push   $0x0
  801f29:	e8 ad f0 ff ff       	call   800fdb <sys_page_alloc>
  801f2e:	83 c4 10             	add    $0x10,%esp
  801f31:	85 c0                	test   %eax,%eax
  801f33:	0f 88 48 02 00 00    	js     802181 <spawn+0x4bf>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801f39:	83 ec 08             	sub    $0x8,%esp
  801f3c:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801f42:	01 f0                	add    %esi,%eax
  801f44:	50                   	push   %eax
  801f45:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801f4b:	e8 6f f9 ff ff       	call   8018bf <seek>
  801f50:	83 c4 10             	add    $0x10,%esp
  801f53:	85 c0                	test   %eax,%eax
  801f55:	0f 88 2d 02 00 00    	js     802188 <spawn+0x4c6>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801f5b:	83 ec 04             	sub    $0x4,%esp
  801f5e:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801f64:	29 f0                	sub    %esi,%eax
  801f66:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f6b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f70:	0f 47 c2             	cmova  %edx,%eax
  801f73:	50                   	push   %eax
  801f74:	68 00 00 40 00       	push   $0x400000
  801f79:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801f7f:	e8 72 f8 ff ff       	call   8017f6 <readn>
  801f84:	83 c4 10             	add    $0x10,%esp
  801f87:	85 c0                	test   %eax,%eax
  801f89:	0f 88 00 02 00 00    	js     80218f <spawn+0x4cd>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801f8f:	83 ec 0c             	sub    $0xc,%esp
  801f92:	57                   	push   %edi
  801f93:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801f99:	56                   	push   %esi
  801f9a:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801fa0:	68 00 00 40 00       	push   $0x400000
  801fa5:	6a 00                	push   $0x0
  801fa7:	e8 72 f0 ff ff       	call   80101e <sys_page_map>
  801fac:	83 c4 20             	add    $0x20,%esp
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	0f 88 80 00 00 00    	js     802037 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801fb7:	83 ec 08             	sub    $0x8,%esp
  801fba:	68 00 00 40 00       	push   $0x400000
  801fbf:	6a 00                	push   $0x0
  801fc1:	e8 9a f0 ff ff       	call   801060 <sys_page_unmap>
  801fc6:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801fc9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801fcf:	89 de                	mov    %ebx,%esi
  801fd1:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801fd7:	76 73                	jbe    80204c <spawn+0x38a>
		if (i >= filesz) {
  801fd9:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801fdf:	0f 87 38 ff ff ff    	ja     801f1d <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801fe5:	83 ec 04             	sub    $0x4,%esp
  801fe8:	57                   	push   %edi
  801fe9:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801fef:	56                   	push   %esi
  801ff0:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801ff6:	e8 e0 ef ff ff       	call   800fdb <sys_page_alloc>
  801ffb:	83 c4 10             	add    $0x10,%esp
  801ffe:	85 c0                	test   %eax,%eax
  802000:	79 c7                	jns    801fc9 <spawn+0x307>
  802002:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802004:	83 ec 0c             	sub    $0xc,%esp
  802007:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80200d:	e8 4a ef ff ff       	call   800f5c <sys_env_destroy>
	close(fd);
  802012:	83 c4 04             	add    $0x4,%esp
  802015:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80201b:	e8 13 f6 ff ff       	call   801633 <close>
	return r;
  802020:	83 c4 10             	add    $0x10,%esp
  802023:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  802029:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80202f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802032:	5b                   	pop    %ebx
  802033:	5e                   	pop    %esi
  802034:	5f                   	pop    %edi
  802035:	5d                   	pop    %ebp
  802036:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  802037:	50                   	push   %eax
  802038:	68 d5 2f 80 00       	push   $0x802fd5
  80203d:	68 25 01 00 00       	push   $0x125
  802042:	68 c9 2f 80 00       	push   $0x802fc9
  802047:	e8 9c e4 ff ff       	call   8004e8 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80204c:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  802053:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  80205a:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802061:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  802067:	7e 71                	jle    8020da <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  802069:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  80206f:	83 39 01             	cmpl   $0x1,(%ecx)
  802072:	75 d8                	jne    80204c <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802074:	8b 41 18             	mov    0x18(%ecx),%eax
  802077:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  80207a:	83 f8 01             	cmp    $0x1,%eax
  80207d:	19 ff                	sbb    %edi,%edi
  80207f:	83 e7 fe             	and    $0xfffffffe,%edi
  802082:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802085:	8b 59 04             	mov    0x4(%ecx),%ebx
  802088:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
  80208e:	8b 71 10             	mov    0x10(%ecx),%esi
  802091:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
  802097:	8b 41 14             	mov    0x14(%ecx),%eax
  80209a:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  8020a0:	8b 51 08             	mov    0x8(%ecx),%edx
  8020a3:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
	if ((i = PGOFF(va))) {
  8020a9:	89 d0                	mov    %edx,%eax
  8020ab:	25 ff 0f 00 00       	and    $0xfff,%eax
  8020b0:	74 1e                	je     8020d0 <spawn+0x40e>
		va -= i;
  8020b2:	29 c2                	sub    %eax,%edx
  8020b4:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		memsz += i;
  8020ba:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  8020c0:	01 c6                	add    %eax,%esi
  8020c2:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
		fileoffset -= i;
  8020c8:	29 c3                	sub    %eax,%ebx
  8020ca:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  8020d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020d5:	e9 f5 fe ff ff       	jmp    801fcf <spawn+0x30d>
	close(fd);
  8020da:	83 ec 0c             	sub    $0xc,%esp
  8020dd:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8020e3:	e8 4b f5 ff ff       	call   801633 <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  8020e8:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  8020ef:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8020f2:	83 c4 08             	add    $0x8,%esp
  8020f5:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8020fb:	50                   	push   %eax
  8020fc:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802102:	e8 dd ef ff ff       	call   8010e4 <sys_env_set_trapframe>
  802107:	83 c4 10             	add    $0x10,%esp
  80210a:	85 c0                	test   %eax,%eax
  80210c:	78 28                	js     802136 <spawn+0x474>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80210e:	83 ec 08             	sub    $0x8,%esp
  802111:	6a 02                	push   $0x2
  802113:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802119:	e8 84 ef ff ff       	call   8010a2 <sys_env_set_status>
  80211e:	83 c4 10             	add    $0x10,%esp
  802121:	85 c0                	test   %eax,%eax
  802123:	78 26                	js     80214b <spawn+0x489>
	return child;
  802125:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80212b:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802131:	e9 f3 fe ff ff       	jmp    802029 <spawn+0x367>
		panic("sys_env_set_trapframe: %e", r);
  802136:	50                   	push   %eax
  802137:	68 f2 2f 80 00       	push   $0x802ff2
  80213c:	68 86 00 00 00       	push   $0x86
  802141:	68 c9 2f 80 00       	push   $0x802fc9
  802146:	e8 9d e3 ff ff       	call   8004e8 <_panic>
		panic("sys_env_set_status: %e", r);
  80214b:	50                   	push   %eax
  80214c:	68 c0 2e 80 00       	push   $0x802ec0
  802151:	68 89 00 00 00       	push   $0x89
  802156:	68 c9 2f 80 00       	push   $0x802fc9
  80215b:	e8 88 e3 ff ff       	call   8004e8 <_panic>
		return r;
  802160:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802166:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  80216c:	e9 b8 fe ff ff       	jmp    802029 <spawn+0x367>
		return -E_NO_MEM;
  802171:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  802176:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  80217c:	e9 a8 fe ff ff       	jmp    802029 <spawn+0x367>
  802181:	89 c7                	mov    %eax,%edi
  802183:	e9 7c fe ff ff       	jmp    802004 <spawn+0x342>
  802188:	89 c7                	mov    %eax,%edi
  80218a:	e9 75 fe ff ff       	jmp    802004 <spawn+0x342>
  80218f:	89 c7                	mov    %eax,%edi
  802191:	e9 6e fe ff ff       	jmp    802004 <spawn+0x342>
	sys_page_unmap(0, UTEMP);
  802196:	83 ec 08             	sub    $0x8,%esp
  802199:	68 00 00 40 00       	push   $0x400000
  80219e:	6a 00                	push   $0x0
  8021a0:	e8 bb ee ff ff       	call   801060 <sys_page_unmap>
  8021a5:	83 c4 10             	add    $0x10,%esp
  8021a8:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  8021ae:	e9 76 fe ff ff       	jmp    802029 <spawn+0x367>

008021b3 <spawnl>:
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	57                   	push   %edi
  8021b7:	56                   	push   %esi
  8021b8:	53                   	push   %ebx
  8021b9:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  8021bc:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  8021bf:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8021c4:	eb 05                	jmp    8021cb <spawnl+0x18>
		argc++;
  8021c6:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8021c9:	89 ca                	mov    %ecx,%edx
  8021cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8021ce:	83 3a 00             	cmpl   $0x0,(%edx)
  8021d1:	75 f3                	jne    8021c6 <spawnl+0x13>
	const char *argv[argc+2];
  8021d3:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  8021da:	83 e2 f0             	and    $0xfffffff0,%edx
  8021dd:	29 d4                	sub    %edx,%esp
  8021df:	8d 54 24 03          	lea    0x3(%esp),%edx
  8021e3:	c1 ea 02             	shr    $0x2,%edx
  8021e6:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8021ed:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8021ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021f2:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8021f9:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802200:	00 
	va_start(vl, arg0);
  802201:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802204:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802206:	b8 00 00 00 00       	mov    $0x0,%eax
  80220b:	eb 0b                	jmp    802218 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  80220d:	83 c0 01             	add    $0x1,%eax
  802210:	8b 39                	mov    (%ecx),%edi
  802212:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802215:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802218:	39 d0                	cmp    %edx,%eax
  80221a:	75 f1                	jne    80220d <spawnl+0x5a>
	return spawn(prog, argv);
  80221c:	83 ec 08             	sub    $0x8,%esp
  80221f:	56                   	push   %esi
  802220:	ff 75 08             	pushl  0x8(%ebp)
  802223:	e8 9a fa ff ff       	call   801cc2 <spawn>
}
  802228:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5e                   	pop    %esi
  80222d:	5f                   	pop    %edi
  80222e:	5d                   	pop    %ebp
  80222f:	c3                   	ret    

00802230 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	56                   	push   %esi
  802234:	53                   	push   %ebx
  802235:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802238:	83 ec 0c             	sub    $0xc,%esp
  80223b:	ff 75 08             	pushl  0x8(%ebp)
  80223e:	e8 55 f2 ff ff       	call   801498 <fd2data>
  802243:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802245:	83 c4 08             	add    $0x8,%esp
  802248:	68 32 30 80 00       	push   $0x803032
  80224d:	53                   	push   %ebx
  80224e:	e8 8f e9 ff ff       	call   800be2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802253:	8b 46 04             	mov    0x4(%esi),%eax
  802256:	2b 06                	sub    (%esi),%eax
  802258:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80225e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802265:	00 00 00 
	stat->st_dev = &devpipe;
  802268:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80226f:	40 80 00 
	return 0;
}
  802272:	b8 00 00 00 00       	mov    $0x0,%eax
  802277:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80227a:	5b                   	pop    %ebx
  80227b:	5e                   	pop    %esi
  80227c:	5d                   	pop    %ebp
  80227d:	c3                   	ret    

0080227e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	53                   	push   %ebx
  802282:	83 ec 0c             	sub    $0xc,%esp
  802285:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802288:	53                   	push   %ebx
  802289:	6a 00                	push   $0x0
  80228b:	e8 d0 ed ff ff       	call   801060 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802290:	89 1c 24             	mov    %ebx,(%esp)
  802293:	e8 00 f2 ff ff       	call   801498 <fd2data>
  802298:	83 c4 08             	add    $0x8,%esp
  80229b:	50                   	push   %eax
  80229c:	6a 00                	push   $0x0
  80229e:	e8 bd ed ff ff       	call   801060 <sys_page_unmap>
}
  8022a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <_pipeisclosed>:
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	57                   	push   %edi
  8022ac:	56                   	push   %esi
  8022ad:	53                   	push   %ebx
  8022ae:	83 ec 1c             	sub    $0x1c,%esp
  8022b1:	89 c7                	mov    %eax,%edi
  8022b3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8022b5:	a1 04 50 80 00       	mov    0x805004,%eax
  8022ba:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022bd:	83 ec 0c             	sub    $0xc,%esp
  8022c0:	57                   	push   %edi
  8022c1:	e8 79 04 00 00       	call   80273f <pageref>
  8022c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022c9:	89 34 24             	mov    %esi,(%esp)
  8022cc:	e8 6e 04 00 00       	call   80273f <pageref>
		nn = thisenv->env_runs;
  8022d1:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8022d7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022da:	83 c4 10             	add    $0x10,%esp
  8022dd:	39 cb                	cmp    %ecx,%ebx
  8022df:	74 1b                	je     8022fc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022e1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022e4:	75 cf                	jne    8022b5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022e6:	8b 42 58             	mov    0x58(%edx),%eax
  8022e9:	6a 01                	push   $0x1
  8022eb:	50                   	push   %eax
  8022ec:	53                   	push   %ebx
  8022ed:	68 39 30 80 00       	push   $0x803039
  8022f2:	e8 cc e2 ff ff       	call   8005c3 <cprintf>
  8022f7:	83 c4 10             	add    $0x10,%esp
  8022fa:	eb b9                	jmp    8022b5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022fc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022ff:	0f 94 c0             	sete   %al
  802302:	0f b6 c0             	movzbl %al,%eax
}
  802305:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802308:	5b                   	pop    %ebx
  802309:	5e                   	pop    %esi
  80230a:	5f                   	pop    %edi
  80230b:	5d                   	pop    %ebp
  80230c:	c3                   	ret    

0080230d <devpipe_write>:
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	57                   	push   %edi
  802311:	56                   	push   %esi
  802312:	53                   	push   %ebx
  802313:	83 ec 28             	sub    $0x28,%esp
  802316:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802319:	56                   	push   %esi
  80231a:	e8 79 f1 ff ff       	call   801498 <fd2data>
  80231f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802321:	83 c4 10             	add    $0x10,%esp
  802324:	bf 00 00 00 00       	mov    $0x0,%edi
  802329:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80232c:	74 4f                	je     80237d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80232e:	8b 43 04             	mov    0x4(%ebx),%eax
  802331:	8b 0b                	mov    (%ebx),%ecx
  802333:	8d 51 20             	lea    0x20(%ecx),%edx
  802336:	39 d0                	cmp    %edx,%eax
  802338:	72 14                	jb     80234e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80233a:	89 da                	mov    %ebx,%edx
  80233c:	89 f0                	mov    %esi,%eax
  80233e:	e8 65 ff ff ff       	call   8022a8 <_pipeisclosed>
  802343:	85 c0                	test   %eax,%eax
  802345:	75 3a                	jne    802381 <devpipe_write+0x74>
			sys_yield();
  802347:	e8 70 ec ff ff       	call   800fbc <sys_yield>
  80234c:	eb e0                	jmp    80232e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80234e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802351:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802355:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802358:	89 c2                	mov    %eax,%edx
  80235a:	c1 fa 1f             	sar    $0x1f,%edx
  80235d:	89 d1                	mov    %edx,%ecx
  80235f:	c1 e9 1b             	shr    $0x1b,%ecx
  802362:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802365:	83 e2 1f             	and    $0x1f,%edx
  802368:	29 ca                	sub    %ecx,%edx
  80236a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80236e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802372:	83 c0 01             	add    $0x1,%eax
  802375:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802378:	83 c7 01             	add    $0x1,%edi
  80237b:	eb ac                	jmp    802329 <devpipe_write+0x1c>
	return i;
  80237d:	89 f8                	mov    %edi,%eax
  80237f:	eb 05                	jmp    802386 <devpipe_write+0x79>
				return 0;
  802381:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802386:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802389:	5b                   	pop    %ebx
  80238a:	5e                   	pop    %esi
  80238b:	5f                   	pop    %edi
  80238c:	5d                   	pop    %ebp
  80238d:	c3                   	ret    

0080238e <devpipe_read>:
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	57                   	push   %edi
  802392:	56                   	push   %esi
  802393:	53                   	push   %ebx
  802394:	83 ec 18             	sub    $0x18,%esp
  802397:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80239a:	57                   	push   %edi
  80239b:	e8 f8 f0 ff ff       	call   801498 <fd2data>
  8023a0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023a2:	83 c4 10             	add    $0x10,%esp
  8023a5:	be 00 00 00 00       	mov    $0x0,%esi
  8023aa:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023ad:	74 47                	je     8023f6 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8023af:	8b 03                	mov    (%ebx),%eax
  8023b1:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023b4:	75 22                	jne    8023d8 <devpipe_read+0x4a>
			if (i > 0)
  8023b6:	85 f6                	test   %esi,%esi
  8023b8:	75 14                	jne    8023ce <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8023ba:	89 da                	mov    %ebx,%edx
  8023bc:	89 f8                	mov    %edi,%eax
  8023be:	e8 e5 fe ff ff       	call   8022a8 <_pipeisclosed>
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	75 33                	jne    8023fa <devpipe_read+0x6c>
			sys_yield();
  8023c7:	e8 f0 eb ff ff       	call   800fbc <sys_yield>
  8023cc:	eb e1                	jmp    8023af <devpipe_read+0x21>
				return i;
  8023ce:	89 f0                	mov    %esi,%eax
}
  8023d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023d3:	5b                   	pop    %ebx
  8023d4:	5e                   	pop    %esi
  8023d5:	5f                   	pop    %edi
  8023d6:	5d                   	pop    %ebp
  8023d7:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023d8:	99                   	cltd   
  8023d9:	c1 ea 1b             	shr    $0x1b,%edx
  8023dc:	01 d0                	add    %edx,%eax
  8023de:	83 e0 1f             	and    $0x1f,%eax
  8023e1:	29 d0                	sub    %edx,%eax
  8023e3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023eb:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023ee:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023f1:	83 c6 01             	add    $0x1,%esi
  8023f4:	eb b4                	jmp    8023aa <devpipe_read+0x1c>
	return i;
  8023f6:	89 f0                	mov    %esi,%eax
  8023f8:	eb d6                	jmp    8023d0 <devpipe_read+0x42>
				return 0;
  8023fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ff:	eb cf                	jmp    8023d0 <devpipe_read+0x42>

00802401 <pipe>:
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
  802404:	56                   	push   %esi
  802405:	53                   	push   %ebx
  802406:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802409:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80240c:	50                   	push   %eax
  80240d:	e8 9d f0 ff ff       	call   8014af <fd_alloc>
  802412:	89 c3                	mov    %eax,%ebx
  802414:	83 c4 10             	add    $0x10,%esp
  802417:	85 c0                	test   %eax,%eax
  802419:	78 5b                	js     802476 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80241b:	83 ec 04             	sub    $0x4,%esp
  80241e:	68 07 04 00 00       	push   $0x407
  802423:	ff 75 f4             	pushl  -0xc(%ebp)
  802426:	6a 00                	push   $0x0
  802428:	e8 ae eb ff ff       	call   800fdb <sys_page_alloc>
  80242d:	89 c3                	mov    %eax,%ebx
  80242f:	83 c4 10             	add    $0x10,%esp
  802432:	85 c0                	test   %eax,%eax
  802434:	78 40                	js     802476 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  802436:	83 ec 0c             	sub    $0xc,%esp
  802439:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80243c:	50                   	push   %eax
  80243d:	e8 6d f0 ff ff       	call   8014af <fd_alloc>
  802442:	89 c3                	mov    %eax,%ebx
  802444:	83 c4 10             	add    $0x10,%esp
  802447:	85 c0                	test   %eax,%eax
  802449:	78 1b                	js     802466 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80244b:	83 ec 04             	sub    $0x4,%esp
  80244e:	68 07 04 00 00       	push   $0x407
  802453:	ff 75 f0             	pushl  -0x10(%ebp)
  802456:	6a 00                	push   $0x0
  802458:	e8 7e eb ff ff       	call   800fdb <sys_page_alloc>
  80245d:	89 c3                	mov    %eax,%ebx
  80245f:	83 c4 10             	add    $0x10,%esp
  802462:	85 c0                	test   %eax,%eax
  802464:	79 19                	jns    80247f <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802466:	83 ec 08             	sub    $0x8,%esp
  802469:	ff 75 f4             	pushl  -0xc(%ebp)
  80246c:	6a 00                	push   $0x0
  80246e:	e8 ed eb ff ff       	call   801060 <sys_page_unmap>
  802473:	83 c4 10             	add    $0x10,%esp
}
  802476:	89 d8                	mov    %ebx,%eax
  802478:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80247b:	5b                   	pop    %ebx
  80247c:	5e                   	pop    %esi
  80247d:	5d                   	pop    %ebp
  80247e:	c3                   	ret    
	va = fd2data(fd0);
  80247f:	83 ec 0c             	sub    $0xc,%esp
  802482:	ff 75 f4             	pushl  -0xc(%ebp)
  802485:	e8 0e f0 ff ff       	call   801498 <fd2data>
  80248a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80248c:	83 c4 0c             	add    $0xc,%esp
  80248f:	68 07 04 00 00       	push   $0x407
  802494:	50                   	push   %eax
  802495:	6a 00                	push   $0x0
  802497:	e8 3f eb ff ff       	call   800fdb <sys_page_alloc>
  80249c:	89 c3                	mov    %eax,%ebx
  80249e:	83 c4 10             	add    $0x10,%esp
  8024a1:	85 c0                	test   %eax,%eax
  8024a3:	0f 88 8c 00 00 00    	js     802535 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024a9:	83 ec 0c             	sub    $0xc,%esp
  8024ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8024af:	e8 e4 ef ff ff       	call   801498 <fd2data>
  8024b4:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8024bb:	50                   	push   %eax
  8024bc:	6a 00                	push   $0x0
  8024be:	56                   	push   %esi
  8024bf:	6a 00                	push   $0x0
  8024c1:	e8 58 eb ff ff       	call   80101e <sys_page_map>
  8024c6:	89 c3                	mov    %eax,%ebx
  8024c8:	83 c4 20             	add    $0x20,%esp
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	78 58                	js     802527 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8024d8:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8024e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e7:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8024ed:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8024ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024f9:	83 ec 0c             	sub    $0xc,%esp
  8024fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8024ff:	e8 84 ef ff ff       	call   801488 <fd2num>
  802504:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802507:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802509:	83 c4 04             	add    $0x4,%esp
  80250c:	ff 75 f0             	pushl  -0x10(%ebp)
  80250f:	e8 74 ef ff ff       	call   801488 <fd2num>
  802514:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802517:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80251a:	83 c4 10             	add    $0x10,%esp
  80251d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802522:	e9 4f ff ff ff       	jmp    802476 <pipe+0x75>
	sys_page_unmap(0, va);
  802527:	83 ec 08             	sub    $0x8,%esp
  80252a:	56                   	push   %esi
  80252b:	6a 00                	push   $0x0
  80252d:	e8 2e eb ff ff       	call   801060 <sys_page_unmap>
  802532:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802535:	83 ec 08             	sub    $0x8,%esp
  802538:	ff 75 f0             	pushl  -0x10(%ebp)
  80253b:	6a 00                	push   $0x0
  80253d:	e8 1e eb ff ff       	call   801060 <sys_page_unmap>
  802542:	83 c4 10             	add    $0x10,%esp
  802545:	e9 1c ff ff ff       	jmp    802466 <pipe+0x65>

0080254a <pipeisclosed>:
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
  80254d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802550:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802553:	50                   	push   %eax
  802554:	ff 75 08             	pushl  0x8(%ebp)
  802557:	e8 a2 ef ff ff       	call   8014fe <fd_lookup>
  80255c:	83 c4 10             	add    $0x10,%esp
  80255f:	85 c0                	test   %eax,%eax
  802561:	78 18                	js     80257b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802563:	83 ec 0c             	sub    $0xc,%esp
  802566:	ff 75 f4             	pushl  -0xc(%ebp)
  802569:	e8 2a ef ff ff       	call   801498 <fd2data>
	return _pipeisclosed(fd, p);
  80256e:	89 c2                	mov    %eax,%edx
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	e8 30 fd ff ff       	call   8022a8 <_pipeisclosed>
  802578:	83 c4 10             	add    $0x10,%esp
}
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    

0080257d <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
  802580:	56                   	push   %esi
  802581:	53                   	push   %ebx
  802582:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802585:	85 f6                	test   %esi,%esi
  802587:	74 13                	je     80259c <wait+0x1f>
	e = &envs[ENVX(envid)];
  802589:	89 f3                	mov    %esi,%ebx
  80258b:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802591:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802594:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80259a:	eb 1b                	jmp    8025b7 <wait+0x3a>
	assert(envid != 0);
  80259c:	68 51 30 80 00       	push   $0x803051
  8025a1:	68 83 2f 80 00       	push   $0x802f83
  8025a6:	6a 09                	push   $0x9
  8025a8:	68 5c 30 80 00       	push   $0x80305c
  8025ad:	e8 36 df ff ff       	call   8004e8 <_panic>
		sys_yield();
  8025b2:	e8 05 ea ff ff       	call   800fbc <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8025b7:	8b 43 48             	mov    0x48(%ebx),%eax
  8025ba:	39 f0                	cmp    %esi,%eax
  8025bc:	75 07                	jne    8025c5 <wait+0x48>
  8025be:	8b 43 54             	mov    0x54(%ebx),%eax
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	75 ed                	jne    8025b2 <wait+0x35>
}
  8025c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025c8:	5b                   	pop    %ebx
  8025c9:	5e                   	pop    %esi
  8025ca:	5d                   	pop    %ebp
  8025cb:	c3                   	ret    

008025cc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
  8025cf:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8025d2:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8025d9:	74 0a                	je     8025e5 <set_pgfault_handler+0x19>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8025db:	8b 45 08             	mov    0x8(%ebp),%eax
  8025de:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8025e3:	c9                   	leave  
  8025e4:	c3                   	ret    
		int r = sys_page_alloc(0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P);	//为当前进程分配异常栈
  8025e5:	83 ec 04             	sub    $0x4,%esp
  8025e8:	6a 07                	push   $0x7
  8025ea:	68 00 f0 bf ee       	push   $0xeebff000
  8025ef:	6a 00                	push   $0x0
  8025f1:	e8 e5 e9 ff ff       	call   800fdb <sys_page_alloc>
		if (r < 0) {
  8025f6:	83 c4 10             	add    $0x10,%esp
  8025f9:	85 c0                	test   %eax,%eax
  8025fb:	78 14                	js     802611 <set_pgfault_handler+0x45>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
  8025fd:	83 ec 08             	sub    $0x8,%esp
  802600:	68 25 26 80 00       	push   $0x802625
  802605:	6a 00                	push   $0x0
  802607:	e8 1a eb ff ff       	call   801126 <sys_env_set_pgfault_upcall>
  80260c:	83 c4 10             	add    $0x10,%esp
  80260f:	eb ca                	jmp    8025db <set_pgfault_handler+0xf>
			panic("set_pgfault_handler:sys_page_alloc failed");;
  802611:	83 ec 04             	sub    $0x4,%esp
  802614:	68 68 30 80 00       	push   $0x803068
  802619:	6a 22                	push   $0x22
  80261b:	68 94 30 80 00       	push   $0x803094
  802620:	e8 c3 de ff ff       	call   8004e8 <_panic>

00802625 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802625:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802626:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax				//调用页处理函数
  80262b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80262d:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp			//跳过utf_fault_va和utf_err
  802630:	83 c4 08             	add    $0x8,%esp
	movl 40(%esp), %eax 	//保存中断发生时的esp到eax
  802633:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl 32(%esp), %ecx 	//保存终端发生时的eip到ecx
  802637:	8b 4c 24 20          	mov    0x20(%esp),%ecx
	movl %ecx, -4(%eax) 	//将中断发生时的esp值亚入到到原来的栈中
  80263b:	89 48 fc             	mov    %ecx,-0x4(%eax)
	popal
  80263e:	61                   	popa   
	addl $4, %esp			//跳过eip
  80263f:	83 c4 04             	add    $0x4,%esp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  802642:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802643:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	lea -4(%esp), %esp		//因为之前压入了eip的值但是没有减esp的值，所以现在需要将esp寄存器中的值减4
  802644:	8d 64 24 fc          	lea    -0x4(%esp),%esp
  802648:	c3                   	ret    

00802649 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802649:	55                   	push   %ebp
  80264a:	89 e5                	mov    %esp,%ebp
  80264c:	56                   	push   %esi
  80264d:	53                   	push   %ebx
  80264e:	8b 75 08             	mov    0x8(%ebp),%esi
  802651:	8b 45 0c             	mov    0xc(%ebp),%eax
  802654:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  802657:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  802659:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80265e:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  802661:	83 ec 0c             	sub    $0xc,%esp
  802664:	50                   	push   %eax
  802665:	e8 21 eb ff ff       	call   80118b <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  80266a:	83 c4 10             	add    $0x10,%esp
  80266d:	85 c0                	test   %eax,%eax
  80266f:	78 2b                	js     80269c <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  802671:	85 f6                	test   %esi,%esi
  802673:	74 0a                	je     80267f <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802675:	a1 04 50 80 00       	mov    0x805004,%eax
  80267a:	8b 40 74             	mov    0x74(%eax),%eax
  80267d:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  80267f:	85 db                	test   %ebx,%ebx
  802681:	74 0a                	je     80268d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802683:	a1 04 50 80 00       	mov    0x805004,%eax
  802688:	8b 40 78             	mov    0x78(%eax),%eax
  80268b:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  80268d:	a1 04 50 80 00       	mov    0x805004,%eax
  802692:	8b 40 70             	mov    0x70(%eax),%eax
}
  802695:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802698:	5b                   	pop    %ebx
  802699:	5e                   	pop    %esi
  80269a:	5d                   	pop    %ebp
  80269b:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80269c:	85 f6                	test   %esi,%esi
  80269e:	74 06                	je     8026a6 <ipc_recv+0x5d>
  8026a0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  8026a6:	85 db                	test   %ebx,%ebx
  8026a8:	74 eb                	je     802695 <ipc_recv+0x4c>
  8026aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8026b0:	eb e3                	jmp    802695 <ipc_recv+0x4c>

008026b2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026b2:	55                   	push   %ebp
  8026b3:	89 e5                	mov    %esp,%ebp
  8026b5:	57                   	push   %edi
  8026b6:	56                   	push   %esi
  8026b7:	53                   	push   %ebx
  8026b8:	83 ec 0c             	sub    $0xc,%esp
  8026bb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026be:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  8026c4:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  8026c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8026cb:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  8026ce:	ff 75 14             	pushl  0x14(%ebp)
  8026d1:	53                   	push   %ebx
  8026d2:	56                   	push   %esi
  8026d3:	57                   	push   %edi
  8026d4:	e8 8f ea ff ff       	call   801168 <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  8026d9:	83 c4 10             	add    $0x10,%esp
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	74 1e                	je     8026fe <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  8026e0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026e3:	75 07                	jne    8026ec <ipc_send+0x3a>
			sys_yield();
  8026e5:	e8 d2 e8 ff ff       	call   800fbc <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  8026ea:	eb e2                	jmp    8026ce <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  8026ec:	50                   	push   %eax
  8026ed:	68 a2 30 80 00       	push   $0x8030a2
  8026f2:	6a 41                	push   $0x41
  8026f4:	68 b0 30 80 00       	push   $0x8030b0
  8026f9:	e8 ea dd ff ff       	call   8004e8 <_panic>
		}
	}
}
  8026fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802701:	5b                   	pop    %ebx
  802702:	5e                   	pop    %esi
  802703:	5f                   	pop    %edi
  802704:	5d                   	pop    %ebp
  802705:	c3                   	ret    

00802706 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80270c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802711:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802714:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80271a:	8b 52 50             	mov    0x50(%edx),%edx
  80271d:	39 ca                	cmp    %ecx,%edx
  80271f:	74 11                	je     802732 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802721:	83 c0 01             	add    $0x1,%eax
  802724:	3d 00 04 00 00       	cmp    $0x400,%eax
  802729:	75 e6                	jne    802711 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80272b:	b8 00 00 00 00       	mov    $0x0,%eax
  802730:	eb 0b                	jmp    80273d <ipc_find_env+0x37>
			return envs[i].env_id;
  802732:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802735:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80273a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80273d:	5d                   	pop    %ebp
  80273e:	c3                   	ret    

0080273f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
  802742:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802745:	89 d0                	mov    %edx,%eax
  802747:	c1 e8 16             	shr    $0x16,%eax
  80274a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802751:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802756:	f6 c1 01             	test   $0x1,%cl
  802759:	74 1d                	je     802778 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80275b:	c1 ea 0c             	shr    $0xc,%edx
  80275e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802765:	f6 c2 01             	test   $0x1,%dl
  802768:	74 0e                	je     802778 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80276a:	c1 ea 0c             	shr    $0xc,%edx
  80276d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802774:	ef 
  802775:	0f b7 c0             	movzwl %ax,%eax
}
  802778:	5d                   	pop    %ebp
  802779:	c3                   	ret    
  80277a:	66 90                	xchg   %ax,%ax
  80277c:	66 90                	xchg   %ax,%ax
  80277e:	66 90                	xchg   %ax,%ax

00802780 <__udivdi3>:
  802780:	55                   	push   %ebp
  802781:	57                   	push   %edi
  802782:	56                   	push   %esi
  802783:	53                   	push   %ebx
  802784:	83 ec 1c             	sub    $0x1c,%esp
  802787:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80278b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80278f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802793:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802797:	85 d2                	test   %edx,%edx
  802799:	75 35                	jne    8027d0 <__udivdi3+0x50>
  80279b:	39 f3                	cmp    %esi,%ebx
  80279d:	0f 87 bd 00 00 00    	ja     802860 <__udivdi3+0xe0>
  8027a3:	85 db                	test   %ebx,%ebx
  8027a5:	89 d9                	mov    %ebx,%ecx
  8027a7:	75 0b                	jne    8027b4 <__udivdi3+0x34>
  8027a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ae:	31 d2                	xor    %edx,%edx
  8027b0:	f7 f3                	div    %ebx
  8027b2:	89 c1                	mov    %eax,%ecx
  8027b4:	31 d2                	xor    %edx,%edx
  8027b6:	89 f0                	mov    %esi,%eax
  8027b8:	f7 f1                	div    %ecx
  8027ba:	89 c6                	mov    %eax,%esi
  8027bc:	89 e8                	mov    %ebp,%eax
  8027be:	89 f7                	mov    %esi,%edi
  8027c0:	f7 f1                	div    %ecx
  8027c2:	89 fa                	mov    %edi,%edx
  8027c4:	83 c4 1c             	add    $0x1c,%esp
  8027c7:	5b                   	pop    %ebx
  8027c8:	5e                   	pop    %esi
  8027c9:	5f                   	pop    %edi
  8027ca:	5d                   	pop    %ebp
  8027cb:	c3                   	ret    
  8027cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027d0:	39 f2                	cmp    %esi,%edx
  8027d2:	77 7c                	ja     802850 <__udivdi3+0xd0>
  8027d4:	0f bd fa             	bsr    %edx,%edi
  8027d7:	83 f7 1f             	xor    $0x1f,%edi
  8027da:	0f 84 98 00 00 00    	je     802878 <__udivdi3+0xf8>
  8027e0:	89 f9                	mov    %edi,%ecx
  8027e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8027e7:	29 f8                	sub    %edi,%eax
  8027e9:	d3 e2                	shl    %cl,%edx
  8027eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027ef:	89 c1                	mov    %eax,%ecx
  8027f1:	89 da                	mov    %ebx,%edx
  8027f3:	d3 ea                	shr    %cl,%edx
  8027f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027f9:	09 d1                	or     %edx,%ecx
  8027fb:	89 f2                	mov    %esi,%edx
  8027fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802801:	89 f9                	mov    %edi,%ecx
  802803:	d3 e3                	shl    %cl,%ebx
  802805:	89 c1                	mov    %eax,%ecx
  802807:	d3 ea                	shr    %cl,%edx
  802809:	89 f9                	mov    %edi,%ecx
  80280b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80280f:	d3 e6                	shl    %cl,%esi
  802811:	89 eb                	mov    %ebp,%ebx
  802813:	89 c1                	mov    %eax,%ecx
  802815:	d3 eb                	shr    %cl,%ebx
  802817:	09 de                	or     %ebx,%esi
  802819:	89 f0                	mov    %esi,%eax
  80281b:	f7 74 24 08          	divl   0x8(%esp)
  80281f:	89 d6                	mov    %edx,%esi
  802821:	89 c3                	mov    %eax,%ebx
  802823:	f7 64 24 0c          	mull   0xc(%esp)
  802827:	39 d6                	cmp    %edx,%esi
  802829:	72 0c                	jb     802837 <__udivdi3+0xb7>
  80282b:	89 f9                	mov    %edi,%ecx
  80282d:	d3 e5                	shl    %cl,%ebp
  80282f:	39 c5                	cmp    %eax,%ebp
  802831:	73 5d                	jae    802890 <__udivdi3+0x110>
  802833:	39 d6                	cmp    %edx,%esi
  802835:	75 59                	jne    802890 <__udivdi3+0x110>
  802837:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80283a:	31 ff                	xor    %edi,%edi
  80283c:	89 fa                	mov    %edi,%edx
  80283e:	83 c4 1c             	add    $0x1c,%esp
  802841:	5b                   	pop    %ebx
  802842:	5e                   	pop    %esi
  802843:	5f                   	pop    %edi
  802844:	5d                   	pop    %ebp
  802845:	c3                   	ret    
  802846:	8d 76 00             	lea    0x0(%esi),%esi
  802849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802850:	31 ff                	xor    %edi,%edi
  802852:	31 c0                	xor    %eax,%eax
  802854:	89 fa                	mov    %edi,%edx
  802856:	83 c4 1c             	add    $0x1c,%esp
  802859:	5b                   	pop    %ebx
  80285a:	5e                   	pop    %esi
  80285b:	5f                   	pop    %edi
  80285c:	5d                   	pop    %ebp
  80285d:	c3                   	ret    
  80285e:	66 90                	xchg   %ax,%ax
  802860:	31 ff                	xor    %edi,%edi
  802862:	89 e8                	mov    %ebp,%eax
  802864:	89 f2                	mov    %esi,%edx
  802866:	f7 f3                	div    %ebx
  802868:	89 fa                	mov    %edi,%edx
  80286a:	83 c4 1c             	add    $0x1c,%esp
  80286d:	5b                   	pop    %ebx
  80286e:	5e                   	pop    %esi
  80286f:	5f                   	pop    %edi
  802870:	5d                   	pop    %ebp
  802871:	c3                   	ret    
  802872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802878:	39 f2                	cmp    %esi,%edx
  80287a:	72 06                	jb     802882 <__udivdi3+0x102>
  80287c:	31 c0                	xor    %eax,%eax
  80287e:	39 eb                	cmp    %ebp,%ebx
  802880:	77 d2                	ja     802854 <__udivdi3+0xd4>
  802882:	b8 01 00 00 00       	mov    $0x1,%eax
  802887:	eb cb                	jmp    802854 <__udivdi3+0xd4>
  802889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802890:	89 d8                	mov    %ebx,%eax
  802892:	31 ff                	xor    %edi,%edi
  802894:	eb be                	jmp    802854 <__udivdi3+0xd4>
  802896:	66 90                	xchg   %ax,%ax
  802898:	66 90                	xchg   %ax,%ax
  80289a:	66 90                	xchg   %ax,%ax
  80289c:	66 90                	xchg   %ax,%ax
  80289e:	66 90                	xchg   %ax,%ax

008028a0 <__umoddi3>:
  8028a0:	55                   	push   %ebp
  8028a1:	57                   	push   %edi
  8028a2:	56                   	push   %esi
  8028a3:	53                   	push   %ebx
  8028a4:	83 ec 1c             	sub    $0x1c,%esp
  8028a7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8028ab:	8b 74 24 30          	mov    0x30(%esp),%esi
  8028af:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8028b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028b7:	85 ed                	test   %ebp,%ebp
  8028b9:	89 f0                	mov    %esi,%eax
  8028bb:	89 da                	mov    %ebx,%edx
  8028bd:	75 19                	jne    8028d8 <__umoddi3+0x38>
  8028bf:	39 df                	cmp    %ebx,%edi
  8028c1:	0f 86 b1 00 00 00    	jbe    802978 <__umoddi3+0xd8>
  8028c7:	f7 f7                	div    %edi
  8028c9:	89 d0                	mov    %edx,%eax
  8028cb:	31 d2                	xor    %edx,%edx
  8028cd:	83 c4 1c             	add    $0x1c,%esp
  8028d0:	5b                   	pop    %ebx
  8028d1:	5e                   	pop    %esi
  8028d2:	5f                   	pop    %edi
  8028d3:	5d                   	pop    %ebp
  8028d4:	c3                   	ret    
  8028d5:	8d 76 00             	lea    0x0(%esi),%esi
  8028d8:	39 dd                	cmp    %ebx,%ebp
  8028da:	77 f1                	ja     8028cd <__umoddi3+0x2d>
  8028dc:	0f bd cd             	bsr    %ebp,%ecx
  8028df:	83 f1 1f             	xor    $0x1f,%ecx
  8028e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028e6:	0f 84 b4 00 00 00    	je     8029a0 <__umoddi3+0x100>
  8028ec:	b8 20 00 00 00       	mov    $0x20,%eax
  8028f1:	89 c2                	mov    %eax,%edx
  8028f3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8028f7:	29 c2                	sub    %eax,%edx
  8028f9:	89 c1                	mov    %eax,%ecx
  8028fb:	89 f8                	mov    %edi,%eax
  8028fd:	d3 e5                	shl    %cl,%ebp
  8028ff:	89 d1                	mov    %edx,%ecx
  802901:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802905:	d3 e8                	shr    %cl,%eax
  802907:	09 c5                	or     %eax,%ebp
  802909:	8b 44 24 04          	mov    0x4(%esp),%eax
  80290d:	89 c1                	mov    %eax,%ecx
  80290f:	d3 e7                	shl    %cl,%edi
  802911:	89 d1                	mov    %edx,%ecx
  802913:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802917:	89 df                	mov    %ebx,%edi
  802919:	d3 ef                	shr    %cl,%edi
  80291b:	89 c1                	mov    %eax,%ecx
  80291d:	89 f0                	mov    %esi,%eax
  80291f:	d3 e3                	shl    %cl,%ebx
  802921:	89 d1                	mov    %edx,%ecx
  802923:	89 fa                	mov    %edi,%edx
  802925:	d3 e8                	shr    %cl,%eax
  802927:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80292c:	09 d8                	or     %ebx,%eax
  80292e:	f7 f5                	div    %ebp
  802930:	d3 e6                	shl    %cl,%esi
  802932:	89 d1                	mov    %edx,%ecx
  802934:	f7 64 24 08          	mull   0x8(%esp)
  802938:	39 d1                	cmp    %edx,%ecx
  80293a:	89 c3                	mov    %eax,%ebx
  80293c:	89 d7                	mov    %edx,%edi
  80293e:	72 06                	jb     802946 <__umoddi3+0xa6>
  802940:	75 0e                	jne    802950 <__umoddi3+0xb0>
  802942:	39 c6                	cmp    %eax,%esi
  802944:	73 0a                	jae    802950 <__umoddi3+0xb0>
  802946:	2b 44 24 08          	sub    0x8(%esp),%eax
  80294a:	19 ea                	sbb    %ebp,%edx
  80294c:	89 d7                	mov    %edx,%edi
  80294e:	89 c3                	mov    %eax,%ebx
  802950:	89 ca                	mov    %ecx,%edx
  802952:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802957:	29 de                	sub    %ebx,%esi
  802959:	19 fa                	sbb    %edi,%edx
  80295b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80295f:	89 d0                	mov    %edx,%eax
  802961:	d3 e0                	shl    %cl,%eax
  802963:	89 d9                	mov    %ebx,%ecx
  802965:	d3 ee                	shr    %cl,%esi
  802967:	d3 ea                	shr    %cl,%edx
  802969:	09 f0                	or     %esi,%eax
  80296b:	83 c4 1c             	add    $0x1c,%esp
  80296e:	5b                   	pop    %ebx
  80296f:	5e                   	pop    %esi
  802970:	5f                   	pop    %edi
  802971:	5d                   	pop    %ebp
  802972:	c3                   	ret    
  802973:	90                   	nop
  802974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802978:	85 ff                	test   %edi,%edi
  80297a:	89 f9                	mov    %edi,%ecx
  80297c:	75 0b                	jne    802989 <__umoddi3+0xe9>
  80297e:	b8 01 00 00 00       	mov    $0x1,%eax
  802983:	31 d2                	xor    %edx,%edx
  802985:	f7 f7                	div    %edi
  802987:	89 c1                	mov    %eax,%ecx
  802989:	89 d8                	mov    %ebx,%eax
  80298b:	31 d2                	xor    %edx,%edx
  80298d:	f7 f1                	div    %ecx
  80298f:	89 f0                	mov    %esi,%eax
  802991:	f7 f1                	div    %ecx
  802993:	e9 31 ff ff ff       	jmp    8028c9 <__umoddi3+0x29>
  802998:	90                   	nop
  802999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029a0:	39 dd                	cmp    %ebx,%ebp
  8029a2:	72 08                	jb     8029ac <__umoddi3+0x10c>
  8029a4:	39 f7                	cmp    %esi,%edi
  8029a6:	0f 87 21 ff ff ff    	ja     8028cd <__umoddi3+0x2d>
  8029ac:	89 da                	mov    %ebx,%edx
  8029ae:	89 f0                	mov    %esi,%eax
  8029b0:	29 f8                	sub    %edi,%eax
  8029b2:	19 ea                	sbb    %ebp,%edx
  8029b4:	e9 14 ff ff ff       	jmp    8028cd <__umoddi3+0x2d>
