
obj/user/init.debug：     文件格式 elf32-i386


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
  80002c:	e8 6f 03 00 00       	call   8003a0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80003e:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800043:	ba 00 00 00 00       	mov    $0x0,%edx
  800048:	eb 0c                	jmp    800056 <sum+0x23>
		tot ^= i * s[i];
  80004a:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80004e:	0f af ca             	imul   %edx,%ecx
  800051:	31 c8                	xor    %ecx,%eax
	for (i = 0; i < n; i++)
  800053:	83 c2 01             	add    $0x1,%edx
  800056:	39 da                	cmp    %ebx,%edx
  800058:	7c f0                	jl     80004a <sum+0x17>
	return tot;
}
  80005a:	5b                   	pop    %ebx
  80005b:	5e                   	pop    %esi
  80005c:	5d                   	pop    %ebp
  80005d:	c3                   	ret    

0080005e <umain>:

void
umain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	57                   	push   %edi
  800062:	56                   	push   %esi
  800063:	53                   	push   %ebx
  800064:	81 ec 18 01 00 00    	sub    $0x118,%esp
  80006a:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80006d:	68 a0 25 80 00       	push   $0x8025a0
  800072:	e8 5c 04 00 00       	call   8004d3 <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800077:	83 c4 08             	add    $0x8,%esp
  80007a:	68 70 17 00 00       	push   $0x1770
  80007f:	68 00 30 80 00       	push   $0x803000
  800084:	e8 aa ff ff ff       	call   800033 <sum>
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  800091:	0f 84 99 00 00 00    	je     800130 <umain+0xd2>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 9e 98 0f 00       	push   $0xf989e
  80009f:	50                   	push   %eax
  8000a0:	68 68 26 80 00       	push   $0x802668
  8000a5:	e8 29 04 00 00       	call   8004d3 <cprintf>
  8000aa:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	68 70 17 00 00       	push   $0x1770
  8000b5:	68 20 50 80 00       	push   $0x805020
  8000ba:	e8 74 ff ff ff       	call   800033 <sum>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	74 7f                	je     800145 <umain+0xe7>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	50                   	push   %eax
  8000ca:	68 a4 26 80 00       	push   $0x8026a4
  8000cf:	e8 ff 03 00 00       	call   8004d3 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	68 dc 25 80 00       	push   $0x8025dc
  8000df:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000e5:	50                   	push   %eax
  8000e6:	e8 27 0a 00 00       	call   800b12 <strcat>
	for (i = 0; i < argc; i++) {
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  8000f3:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	for (i = 0; i < argc; i++) {
  8000f9:	39 fb                	cmp    %edi,%ebx
  8000fb:	7d 5a                	jge    800157 <umain+0xf9>
		strcat(args, " '");
  8000fd:	83 ec 08             	sub    $0x8,%esp
  800100:	68 e8 25 80 00       	push   $0x8025e8
  800105:	56                   	push   %esi
  800106:	e8 07 0a 00 00       	call   800b12 <strcat>
		strcat(args, argv[i]);
  80010b:	83 c4 08             	add    $0x8,%esp
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	ff 34 98             	pushl  (%eax,%ebx,4)
  800114:	56                   	push   %esi
  800115:	e8 f8 09 00 00       	call   800b12 <strcat>
		strcat(args, "'");
  80011a:	83 c4 08             	add    $0x8,%esp
  80011d:	68 e9 25 80 00       	push   $0x8025e9
  800122:	56                   	push   %esi
  800123:	e8 ea 09 00 00       	call   800b12 <strcat>
	for (i = 0; i < argc; i++) {
  800128:	83 c3 01             	add    $0x1,%ebx
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb c9                	jmp    8000f9 <umain+0x9b>
		cprintf("init: data seems okay\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 af 25 80 00       	push   $0x8025af
  800138:	e8 96 03 00 00       	call   8004d3 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	e9 68 ff ff ff       	jmp    8000ad <umain+0x4f>
		cprintf("init: bss seems okay\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 c6 25 80 00       	push   $0x8025c6
  80014d:	e8 81 03 00 00       	call   8004d3 <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	eb 80                	jmp    8000d7 <umain+0x79>
	}
	cprintf("%s\n", args);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800160:	50                   	push   %eax
  800161:	68 eb 25 80 00       	push   $0x8025eb
  800166:	e8 68 03 00 00       	call   8004d3 <cprintf>

	cprintf("init: running sh\n");
  80016b:	c7 04 24 ef 25 80 00 	movl   $0x8025ef,(%esp)
  800172:	e8 5c 03 00 00       	call   8004d3 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 04 11 00 00       	call   801287 <close>
	if ((r = opencons()) < 0)
  800183:	e8 c6 01 00 00       	call   80034e <opencons>
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	85 c0                	test   %eax,%eax
  80018d:	78 16                	js     8001a5 <umain+0x147>
		panic("opencons: %e", r);
	if (r != 0)
  80018f:	85 c0                	test   %eax,%eax
  800191:	74 24                	je     8001b7 <umain+0x159>
		panic("first opencons used fd %d", r);
  800193:	50                   	push   %eax
  800194:	68 1a 26 80 00       	push   $0x80261a
  800199:	6a 39                	push   $0x39
  80019b:	68 0e 26 80 00       	push   $0x80260e
  8001a0:	e8 53 02 00 00       	call   8003f8 <_panic>
		panic("opencons: %e", r);
  8001a5:	50                   	push   %eax
  8001a6:	68 01 26 80 00       	push   $0x802601
  8001ab:	6a 37                	push   $0x37
  8001ad:	68 0e 26 80 00       	push   $0x80260e
  8001b2:	e8 41 02 00 00       	call   8003f8 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	6a 01                	push   $0x1
  8001bc:	6a 00                	push   $0x0
  8001be:	e8 14 11 00 00       	call   8012d7 <dup>
  8001c3:	83 c4 10             	add    $0x10,%esp
  8001c6:	85 c0                	test   %eax,%eax
  8001c8:	79 23                	jns    8001ed <umain+0x18f>
		panic("dup: %e", r);
  8001ca:	50                   	push   %eax
  8001cb:	68 34 26 80 00       	push   $0x802634
  8001d0:	6a 3b                	push   $0x3b
  8001d2:	68 0e 26 80 00       	push   $0x80260e
  8001d7:	e8 1c 02 00 00       	call   8003f8 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	50                   	push   %eax
  8001e0:	68 53 26 80 00       	push   $0x802653
  8001e5:	e8 e9 02 00 00       	call   8004d3 <cprintf>
			continue;
  8001ea:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001ed:	83 ec 0c             	sub    $0xc,%esp
  8001f0:	68 3c 26 80 00       	push   $0x80263c
  8001f5:	e8 d9 02 00 00       	call   8004d3 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001fa:	83 c4 0c             	add    $0xc,%esp
  8001fd:	6a 00                	push   $0x0
  8001ff:	68 50 26 80 00       	push   $0x802650
  800204:	68 4f 26 80 00       	push   $0x80264f
  800209:	e8 f9 1b 00 00       	call   801e07 <spawnl>
		if (r < 0) {
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	85 c0                	test   %eax,%eax
  800213:	78 c7                	js     8001dc <umain+0x17e>
		}
		wait(r);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	e8 b3 1f 00 00       	call   8021d1 <wait>
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	eb ca                	jmp    8001ed <umain+0x18f>

00800223 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800226:	b8 00 00 00 00       	mov    $0x0,%eax
  80022b:	5d                   	pop    %ebp
  80022c:	c3                   	ret    

0080022d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800233:	68 d3 26 80 00       	push   $0x8026d3
  800238:	ff 75 0c             	pushl  0xc(%ebp)
  80023b:	e8 b2 08 00 00       	call   800af2 <strcpy>
	return 0;
}
  800240:	b8 00 00 00 00       	mov    $0x0,%eax
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <devcons_write>:
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	57                   	push   %edi
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
  80024d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800253:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800258:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80025e:	eb 2f                	jmp    80028f <devcons_write+0x48>
		m = n - tot;
  800260:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800263:	29 f3                	sub    %esi,%ebx
  800265:	83 fb 7f             	cmp    $0x7f,%ebx
  800268:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80026d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800270:	83 ec 04             	sub    $0x4,%esp
  800273:	53                   	push   %ebx
  800274:	89 f0                	mov    %esi,%eax
  800276:	03 45 0c             	add    0xc(%ebp),%eax
  800279:	50                   	push   %eax
  80027a:	57                   	push   %edi
  80027b:	e8 00 0a 00 00       	call   800c80 <memmove>
		sys_cputs(buf, m);
  800280:	83 c4 08             	add    $0x8,%esp
  800283:	53                   	push   %ebx
  800284:	57                   	push   %edi
  800285:	e8 a5 0b 00 00       	call   800e2f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80028a:	01 de                	add    %ebx,%esi
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	3b 75 10             	cmp    0x10(%ebp),%esi
  800292:	72 cc                	jb     800260 <devcons_write+0x19>
}
  800294:	89 f0                	mov    %esi,%eax
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    

0080029e <devcons_read>:
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	83 ec 08             	sub    $0x8,%esp
  8002a4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8002a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002ad:	75 07                	jne    8002b6 <devcons_read+0x18>
}
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    
		sys_yield();
  8002b1:	e8 16 0c 00 00       	call   800ecc <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8002b6:	e8 92 0b 00 00       	call   800e4d <sys_cgetc>
  8002bb:	85 c0                	test   %eax,%eax
  8002bd:	74 f2                	je     8002b1 <devcons_read+0x13>
	if (c < 0)
  8002bf:	85 c0                	test   %eax,%eax
  8002c1:	78 ec                	js     8002af <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8002c3:	83 f8 04             	cmp    $0x4,%eax
  8002c6:	74 0c                	je     8002d4 <devcons_read+0x36>
	*(char*)vbuf = c;
  8002c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cb:	88 02                	mov    %al,(%edx)
	return 1;
  8002cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8002d2:	eb db                	jmp    8002af <devcons_read+0x11>
		return 0;
  8002d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d9:	eb d4                	jmp    8002af <devcons_read+0x11>

008002db <cputchar>:
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8002e7:	6a 01                	push   $0x1
  8002e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002ec:	50                   	push   %eax
  8002ed:	e8 3d 0b 00 00       	call   800e2f <sys_cputs>
}
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	c9                   	leave  
  8002f6:	c3                   	ret    

008002f7 <getchar>:
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8002fd:	6a 01                	push   $0x1
  8002ff:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800302:	50                   	push   %eax
  800303:	6a 00                	push   $0x0
  800305:	e8 b9 10 00 00       	call   8013c3 <read>
	if (r < 0)
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	85 c0                	test   %eax,%eax
  80030f:	78 08                	js     800319 <getchar+0x22>
	if (r < 1)
  800311:	85 c0                	test   %eax,%eax
  800313:	7e 06                	jle    80031b <getchar+0x24>
	return c;
  800315:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    
		return -E_EOF;
  80031b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800320:	eb f7                	jmp    800319 <getchar+0x22>

00800322 <iscons>:
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800328:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80032b:	50                   	push   %eax
  80032c:	ff 75 08             	pushl  0x8(%ebp)
  80032f:	e8 1e 0e 00 00       	call   801152 <fd_lookup>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	85 c0                	test   %eax,%eax
  800339:	78 11                	js     80034c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80033b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80033e:	8b 15 70 47 80 00    	mov    0x804770,%edx
  800344:	39 10                	cmp    %edx,(%eax)
  800346:	0f 94 c0             	sete   %al
  800349:	0f b6 c0             	movzbl %al,%eax
}
  80034c:	c9                   	leave  
  80034d:	c3                   	ret    

0080034e <opencons>:
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800354:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800357:	50                   	push   %eax
  800358:	e8 a6 0d 00 00       	call   801103 <fd_alloc>
  80035d:	83 c4 10             	add    $0x10,%esp
  800360:	85 c0                	test   %eax,%eax
  800362:	78 3a                	js     80039e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800364:	83 ec 04             	sub    $0x4,%esp
  800367:	68 07 04 00 00       	push   $0x407
  80036c:	ff 75 f4             	pushl  -0xc(%ebp)
  80036f:	6a 00                	push   $0x0
  800371:	e8 75 0b 00 00       	call   800eeb <sys_page_alloc>
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	85 c0                	test   %eax,%eax
  80037b:	78 21                	js     80039e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80037d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800380:	8b 15 70 47 80 00    	mov    0x804770,%edx
  800386:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800392:	83 ec 0c             	sub    $0xc,%esp
  800395:	50                   	push   %eax
  800396:	e8 41 0d 00 00       	call   8010dc <fd2num>
  80039b:	83 c4 10             	add    $0x10,%esp
}
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	56                   	push   %esi
  8003a4:	53                   	push   %ebx
  8003a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003a8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  8003ab:	e8 fd 0a 00 00       	call   800ead <sys_getenvid>
	thisenv = envs + ENVX(envid);
  8003b0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8003b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003bd:	a3 90 67 80 00       	mov    %eax,0x806790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c2:	85 db                	test   %ebx,%ebx
  8003c4:	7e 07                	jle    8003cd <libmain+0x2d>
		binaryname = argv[0];
  8003c6:	8b 06                	mov    (%esi),%eax
  8003c8:	a3 8c 47 80 00       	mov    %eax,0x80478c

	// call user main routine
	umain(argc, argv);
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	56                   	push   %esi
  8003d1:	53                   	push   %ebx
  8003d2:	e8 87 fc ff ff       	call   80005e <umain>

	// exit gracefully
	exit();
  8003d7:	e8 0a 00 00 00       	call   8003e6 <exit>
}
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003e2:	5b                   	pop    %ebx
  8003e3:	5e                   	pop    %esi
  8003e4:	5d                   	pop    %ebp
  8003e5:	c3                   	ret    

008003e6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8003ec:	6a 00                	push   $0x0
  8003ee:	e8 79 0a 00 00       	call   800e6c <sys_env_destroy>
}
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	c9                   	leave  
  8003f7:	c3                   	ret    

008003f8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003f8:	55                   	push   %ebp
  8003f9:	89 e5                	mov    %esp,%ebp
  8003fb:	56                   	push   %esi
  8003fc:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8003fd:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800400:	8b 35 8c 47 80 00    	mov    0x80478c,%esi
  800406:	e8 a2 0a 00 00       	call   800ead <sys_getenvid>
  80040b:	83 ec 0c             	sub    $0xc,%esp
  80040e:	ff 75 0c             	pushl  0xc(%ebp)
  800411:	ff 75 08             	pushl  0x8(%ebp)
  800414:	56                   	push   %esi
  800415:	50                   	push   %eax
  800416:	68 ec 26 80 00       	push   $0x8026ec
  80041b:	e8 b3 00 00 00       	call   8004d3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800420:	83 c4 18             	add    $0x18,%esp
  800423:	53                   	push   %ebx
  800424:	ff 75 10             	pushl  0x10(%ebp)
  800427:	e8 56 00 00 00       	call   800482 <vcprintf>
	cprintf("\n");
  80042c:	c7 04 24 c0 2b 80 00 	movl   $0x802bc0,(%esp)
  800433:	e8 9b 00 00 00       	call   8004d3 <cprintf>
  800438:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80043b:	cc                   	int3   
  80043c:	eb fd                	jmp    80043b <_panic+0x43>

0080043e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	53                   	push   %ebx
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800448:	8b 13                	mov    (%ebx),%edx
  80044a:	8d 42 01             	lea    0x1(%edx),%eax
  80044d:	89 03                	mov    %eax,(%ebx)
  80044f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800452:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800456:	3d ff 00 00 00       	cmp    $0xff,%eax
  80045b:	74 09                	je     800466 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80045d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800461:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800464:	c9                   	leave  
  800465:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800466:	83 ec 08             	sub    $0x8,%esp
  800469:	68 ff 00 00 00       	push   $0xff
  80046e:	8d 43 08             	lea    0x8(%ebx),%eax
  800471:	50                   	push   %eax
  800472:	e8 b8 09 00 00       	call   800e2f <sys_cputs>
		b->idx = 0;
  800477:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	eb db                	jmp    80045d <putch+0x1f>

00800482 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80048b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800492:	00 00 00 
	b.cnt = 0;
  800495:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80049c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80049f:	ff 75 0c             	pushl  0xc(%ebp)
  8004a2:	ff 75 08             	pushl  0x8(%ebp)
  8004a5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004ab:	50                   	push   %eax
  8004ac:	68 3e 04 80 00       	push   $0x80043e
  8004b1:	e8 1a 01 00 00       	call   8005d0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004b6:	83 c4 08             	add    $0x8,%esp
  8004b9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004bf:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004c5:	50                   	push   %eax
  8004c6:	e8 64 09 00 00       	call   800e2f <sys_cputs>

	return b.cnt;
}
  8004cb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004d9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004dc:	50                   	push   %eax
  8004dd:	ff 75 08             	pushl  0x8(%ebp)
  8004e0:	e8 9d ff ff ff       	call   800482 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004e5:	c9                   	leave  
  8004e6:	c3                   	ret    

008004e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	57                   	push   %edi
  8004eb:	56                   	push   %esi
  8004ec:	53                   	push   %ebx
  8004ed:	83 ec 1c             	sub    $0x1c,%esp
  8004f0:	89 c7                	mov    %eax,%edi
  8004f2:	89 d6                	mov    %edx,%esi
  8004f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800500:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800503:	bb 00 00 00 00       	mov    $0x0,%ebx
  800508:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80050b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80050e:	39 d3                	cmp    %edx,%ebx
  800510:	72 05                	jb     800517 <printnum+0x30>
  800512:	39 45 10             	cmp    %eax,0x10(%ebp)
  800515:	77 7a                	ja     800591 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800517:	83 ec 0c             	sub    $0xc,%esp
  80051a:	ff 75 18             	pushl  0x18(%ebp)
  80051d:	8b 45 14             	mov    0x14(%ebp),%eax
  800520:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800523:	53                   	push   %ebx
  800524:	ff 75 10             	pushl  0x10(%ebp)
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80052d:	ff 75 e0             	pushl  -0x20(%ebp)
  800530:	ff 75 dc             	pushl  -0x24(%ebp)
  800533:	ff 75 d8             	pushl  -0x28(%ebp)
  800536:	e8 25 1e 00 00       	call   802360 <__udivdi3>
  80053b:	83 c4 18             	add    $0x18,%esp
  80053e:	52                   	push   %edx
  80053f:	50                   	push   %eax
  800540:	89 f2                	mov    %esi,%edx
  800542:	89 f8                	mov    %edi,%eax
  800544:	e8 9e ff ff ff       	call   8004e7 <printnum>
  800549:	83 c4 20             	add    $0x20,%esp
  80054c:	eb 13                	jmp    800561 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	56                   	push   %esi
  800552:	ff 75 18             	pushl  0x18(%ebp)
  800555:	ff d7                	call   *%edi
  800557:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80055a:	83 eb 01             	sub    $0x1,%ebx
  80055d:	85 db                	test   %ebx,%ebx
  80055f:	7f ed                	jg     80054e <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	56                   	push   %esi
  800565:	83 ec 04             	sub    $0x4,%esp
  800568:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056b:	ff 75 e0             	pushl  -0x20(%ebp)
  80056e:	ff 75 dc             	pushl  -0x24(%ebp)
  800571:	ff 75 d8             	pushl  -0x28(%ebp)
  800574:	e8 07 1f 00 00       	call   802480 <__umoddi3>
  800579:	83 c4 14             	add    $0x14,%esp
  80057c:	0f be 80 0f 27 80 00 	movsbl 0x80270f(%eax),%eax
  800583:	50                   	push   %eax
  800584:	ff d7                	call   *%edi
}
  800586:	83 c4 10             	add    $0x10,%esp
  800589:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80058c:	5b                   	pop    %ebx
  80058d:	5e                   	pop    %esi
  80058e:	5f                   	pop    %edi
  80058f:	5d                   	pop    %ebp
  800590:	c3                   	ret    
  800591:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800594:	eb c4                	jmp    80055a <printnum+0x73>

00800596 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800596:	55                   	push   %ebp
  800597:	89 e5                	mov    %esp,%ebp
  800599:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80059c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005a0:	8b 10                	mov    (%eax),%edx
  8005a2:	3b 50 04             	cmp    0x4(%eax),%edx
  8005a5:	73 0a                	jae    8005b1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005a7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005aa:	89 08                	mov    %ecx,(%eax)
  8005ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8005af:	88 02                	mov    %al,(%edx)
}
  8005b1:	5d                   	pop    %ebp
  8005b2:	c3                   	ret    

008005b3 <printfmt>:
{
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
  8005b6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005b9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005bc:	50                   	push   %eax
  8005bd:	ff 75 10             	pushl  0x10(%ebp)
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 05 00 00 00       	call   8005d0 <vprintfmt>
}
  8005cb:	83 c4 10             	add    $0x10,%esp
  8005ce:	c9                   	leave  
  8005cf:	c3                   	ret    

008005d0 <vprintfmt>:
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	57                   	push   %edi
  8005d4:	56                   	push   %esi
  8005d5:	53                   	push   %ebx
  8005d6:	83 ec 2c             	sub    $0x2c,%esp
  8005d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8005dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005df:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005e2:	e9 c1 03 00 00       	jmp    8009a8 <vprintfmt+0x3d8>
		padc = ' ';
  8005e7:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8005eb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8005f2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8005f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800600:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800605:	8d 47 01             	lea    0x1(%edi),%eax
  800608:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80060b:	0f b6 17             	movzbl (%edi),%edx
  80060e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800611:	3c 55                	cmp    $0x55,%al
  800613:	0f 87 12 04 00 00    	ja     800a2b <vprintfmt+0x45b>
  800619:	0f b6 c0             	movzbl %al,%eax
  80061c:	ff 24 85 60 28 80 00 	jmp    *0x802860(,%eax,4)
  800623:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800626:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80062a:	eb d9                	jmp    800605 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80062c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80062f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800633:	eb d0                	jmp    800605 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800635:	0f b6 d2             	movzbl %dl,%edx
  800638:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80063b:	b8 00 00 00 00       	mov    $0x0,%eax
  800640:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800643:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800646:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80064a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80064d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800650:	83 f9 09             	cmp    $0x9,%ecx
  800653:	77 55                	ja     8006aa <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800655:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800658:	eb e9                	jmp    800643 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 00                	mov    (%eax),%eax
  80065f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8d 40 04             	lea    0x4(%eax),%eax
  800668:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80066b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80066e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800672:	79 91                	jns    800605 <vprintfmt+0x35>
				width = precision, precision = -1;
  800674:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800677:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80067a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800681:	eb 82                	jmp    800605 <vprintfmt+0x35>
  800683:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800686:	85 c0                	test   %eax,%eax
  800688:	ba 00 00 00 00       	mov    $0x0,%edx
  80068d:	0f 49 d0             	cmovns %eax,%edx
  800690:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800693:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800696:	e9 6a ff ff ff       	jmp    800605 <vprintfmt+0x35>
  80069b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80069e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8006a5:	e9 5b ff ff ff       	jmp    800605 <vprintfmt+0x35>
  8006aa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006b0:	eb bc                	jmp    80066e <vprintfmt+0x9e>
			lflag++;
  8006b2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006b8:	e9 48 ff ff ff       	jmp    800605 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8d 78 04             	lea    0x4(%eax),%edi
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	53                   	push   %ebx
  8006c7:	ff 30                	pushl  (%eax)
  8006c9:	ff d6                	call   *%esi
			break;
  8006cb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006ce:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006d1:	e9 cf 02 00 00       	jmp    8009a5 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8d 78 04             	lea    0x4(%eax),%edi
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	99                   	cltd   
  8006df:	31 d0                	xor    %edx,%eax
  8006e1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006e3:	83 f8 0f             	cmp    $0xf,%eax
  8006e6:	7f 23                	jg     80070b <vprintfmt+0x13b>
  8006e8:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  8006ef:	85 d2                	test   %edx,%edx
  8006f1:	74 18                	je     80070b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8006f3:	52                   	push   %edx
  8006f4:	68 f1 2a 80 00       	push   $0x802af1
  8006f9:	53                   	push   %ebx
  8006fa:	56                   	push   %esi
  8006fb:	e8 b3 fe ff ff       	call   8005b3 <printfmt>
  800700:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800703:	89 7d 14             	mov    %edi,0x14(%ebp)
  800706:	e9 9a 02 00 00       	jmp    8009a5 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80070b:	50                   	push   %eax
  80070c:	68 27 27 80 00       	push   $0x802727
  800711:	53                   	push   %ebx
  800712:	56                   	push   %esi
  800713:	e8 9b fe ff ff       	call   8005b3 <printfmt>
  800718:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80071b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80071e:	e9 82 02 00 00       	jmp    8009a5 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	83 c0 04             	add    $0x4,%eax
  800729:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800731:	85 ff                	test   %edi,%edi
  800733:	b8 20 27 80 00       	mov    $0x802720,%eax
  800738:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80073b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80073f:	0f 8e bd 00 00 00    	jle    800802 <vprintfmt+0x232>
  800745:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800749:	75 0e                	jne    800759 <vprintfmt+0x189>
  80074b:	89 75 08             	mov    %esi,0x8(%ebp)
  80074e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800751:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800754:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800757:	eb 6d                	jmp    8007c6 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	ff 75 d0             	pushl  -0x30(%ebp)
  80075f:	57                   	push   %edi
  800760:	e8 6e 03 00 00       	call   800ad3 <strnlen>
  800765:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800768:	29 c1                	sub    %eax,%ecx
  80076a:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80076d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800770:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800774:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800777:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80077a:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80077c:	eb 0f                	jmp    80078d <vprintfmt+0x1bd>
					putch(padc, putdat);
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	53                   	push   %ebx
  800782:	ff 75 e0             	pushl  -0x20(%ebp)
  800785:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800787:	83 ef 01             	sub    $0x1,%edi
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	85 ff                	test   %edi,%edi
  80078f:	7f ed                	jg     80077e <vprintfmt+0x1ae>
  800791:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800794:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800797:	85 c9                	test   %ecx,%ecx
  800799:	b8 00 00 00 00       	mov    $0x0,%eax
  80079e:	0f 49 c1             	cmovns %ecx,%eax
  8007a1:	29 c1                	sub    %eax,%ecx
  8007a3:	89 75 08             	mov    %esi,0x8(%ebp)
  8007a6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8007a9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8007ac:	89 cb                	mov    %ecx,%ebx
  8007ae:	eb 16                	jmp    8007c6 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8007b0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007b4:	75 31                	jne    8007e7 <vprintfmt+0x217>
					putch(ch, putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 0c             	pushl  0xc(%ebp)
  8007bc:	50                   	push   %eax
  8007bd:	ff 55 08             	call   *0x8(%ebp)
  8007c0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007c3:	83 eb 01             	sub    $0x1,%ebx
  8007c6:	83 c7 01             	add    $0x1,%edi
  8007c9:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8007cd:	0f be c2             	movsbl %dl,%eax
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	74 59                	je     80082d <vprintfmt+0x25d>
  8007d4:	85 f6                	test   %esi,%esi
  8007d6:	78 d8                	js     8007b0 <vprintfmt+0x1e0>
  8007d8:	83 ee 01             	sub    $0x1,%esi
  8007db:	79 d3                	jns    8007b0 <vprintfmt+0x1e0>
  8007dd:	89 df                	mov    %ebx,%edi
  8007df:	8b 75 08             	mov    0x8(%ebp),%esi
  8007e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007e5:	eb 37                	jmp    80081e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8007e7:	0f be d2             	movsbl %dl,%edx
  8007ea:	83 ea 20             	sub    $0x20,%edx
  8007ed:	83 fa 5e             	cmp    $0x5e,%edx
  8007f0:	76 c4                	jbe    8007b6 <vprintfmt+0x1e6>
					putch('?', putdat);
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	ff 75 0c             	pushl  0xc(%ebp)
  8007f8:	6a 3f                	push   $0x3f
  8007fa:	ff 55 08             	call   *0x8(%ebp)
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	eb c1                	jmp    8007c3 <vprintfmt+0x1f3>
  800802:	89 75 08             	mov    %esi,0x8(%ebp)
  800805:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800808:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80080b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80080e:	eb b6                	jmp    8007c6 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	53                   	push   %ebx
  800814:	6a 20                	push   $0x20
  800816:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800818:	83 ef 01             	sub    $0x1,%edi
  80081b:	83 c4 10             	add    $0x10,%esp
  80081e:	85 ff                	test   %edi,%edi
  800820:	7f ee                	jg     800810 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800822:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800825:	89 45 14             	mov    %eax,0x14(%ebp)
  800828:	e9 78 01 00 00       	jmp    8009a5 <vprintfmt+0x3d5>
  80082d:	89 df                	mov    %ebx,%edi
  80082f:	8b 75 08             	mov    0x8(%ebp),%esi
  800832:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800835:	eb e7                	jmp    80081e <vprintfmt+0x24e>
	if (lflag >= 2)
  800837:	83 f9 01             	cmp    $0x1,%ecx
  80083a:	7e 3f                	jle    80087b <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80083c:	8b 45 14             	mov    0x14(%ebp),%eax
  80083f:	8b 50 04             	mov    0x4(%eax),%edx
  800842:	8b 00                	mov    (%eax),%eax
  800844:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800847:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084a:	8b 45 14             	mov    0x14(%ebp),%eax
  80084d:	8d 40 08             	lea    0x8(%eax),%eax
  800850:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800853:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800857:	79 5c                	jns    8008b5 <vprintfmt+0x2e5>
				putch('-', putdat);
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	53                   	push   %ebx
  80085d:	6a 2d                	push   $0x2d
  80085f:	ff d6                	call   *%esi
				num = -(long long) num;
  800861:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800864:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800867:	f7 da                	neg    %edx
  800869:	83 d1 00             	adc    $0x0,%ecx
  80086c:	f7 d9                	neg    %ecx
  80086e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800871:	b8 0a 00 00 00       	mov    $0xa,%eax
  800876:	e9 10 01 00 00       	jmp    80098b <vprintfmt+0x3bb>
	else if (lflag)
  80087b:	85 c9                	test   %ecx,%ecx
  80087d:	75 1b                	jne    80089a <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8b 00                	mov    (%eax),%eax
  800884:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800887:	89 c1                	mov    %eax,%ecx
  800889:	c1 f9 1f             	sar    $0x1f,%ecx
  80088c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8d 40 04             	lea    0x4(%eax),%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
  800898:	eb b9                	jmp    800853 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a2:	89 c1                	mov    %eax,%ecx
  8008a4:	c1 f9 1f             	sar    $0x1f,%ecx
  8008a7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	8d 40 04             	lea    0x4(%eax),%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	eb 9e                	jmp    800853 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8008b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008b8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8008bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c0:	e9 c6 00 00 00       	jmp    80098b <vprintfmt+0x3bb>
	if (lflag >= 2)
  8008c5:	83 f9 01             	cmp    $0x1,%ecx
  8008c8:	7e 18                	jle    8008e2 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	8b 10                	mov    (%eax),%edx
  8008cf:	8b 48 04             	mov    0x4(%eax),%ecx
  8008d2:	8d 40 08             	lea    0x8(%eax),%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008dd:	e9 a9 00 00 00       	jmp    80098b <vprintfmt+0x3bb>
	else if (lflag)
  8008e2:	85 c9                	test   %ecx,%ecx
  8008e4:	75 1a                	jne    800900 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8008e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e9:	8b 10                	mov    (%eax),%edx
  8008eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008f0:	8d 40 04             	lea    0x4(%eax),%eax
  8008f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008fb:	e9 8b 00 00 00       	jmp    80098b <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800900:	8b 45 14             	mov    0x14(%ebp),%eax
  800903:	8b 10                	mov    (%eax),%edx
  800905:	b9 00 00 00 00       	mov    $0x0,%ecx
  80090a:	8d 40 04             	lea    0x4(%eax),%eax
  80090d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800910:	b8 0a 00 00 00       	mov    $0xa,%eax
  800915:	eb 74                	jmp    80098b <vprintfmt+0x3bb>
	if (lflag >= 2)
  800917:	83 f9 01             	cmp    $0x1,%ecx
  80091a:	7e 15                	jle    800931 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80091c:	8b 45 14             	mov    0x14(%ebp),%eax
  80091f:	8b 10                	mov    (%eax),%edx
  800921:	8b 48 04             	mov    0x4(%eax),%ecx
  800924:	8d 40 08             	lea    0x8(%eax),%eax
  800927:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80092a:	b8 08 00 00 00       	mov    $0x8,%eax
  80092f:	eb 5a                	jmp    80098b <vprintfmt+0x3bb>
	else if (lflag)
  800931:	85 c9                	test   %ecx,%ecx
  800933:	75 17                	jne    80094c <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	8b 10                	mov    (%eax),%edx
  80093a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093f:	8d 40 04             	lea    0x4(%eax),%eax
  800942:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800945:	b8 08 00 00 00       	mov    $0x8,%eax
  80094a:	eb 3f                	jmp    80098b <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	8b 10                	mov    (%eax),%edx
  800951:	b9 00 00 00 00       	mov    $0x0,%ecx
  800956:	8d 40 04             	lea    0x4(%eax),%eax
  800959:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80095c:	b8 08 00 00 00       	mov    $0x8,%eax
  800961:	eb 28                	jmp    80098b <vprintfmt+0x3bb>
			putch('0', putdat);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	53                   	push   %ebx
  800967:	6a 30                	push   $0x30
  800969:	ff d6                	call   *%esi
			putch('x', putdat);
  80096b:	83 c4 08             	add    $0x8,%esp
  80096e:	53                   	push   %ebx
  80096f:	6a 78                	push   $0x78
  800971:	ff d6                	call   *%esi
			num = (unsigned long long)
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	8b 10                	mov    (%eax),%edx
  800978:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80097d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800980:	8d 40 04             	lea    0x4(%eax),%eax
  800983:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800986:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80098b:	83 ec 0c             	sub    $0xc,%esp
  80098e:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800992:	57                   	push   %edi
  800993:	ff 75 e0             	pushl  -0x20(%ebp)
  800996:	50                   	push   %eax
  800997:	51                   	push   %ecx
  800998:	52                   	push   %edx
  800999:	89 da                	mov    %ebx,%edx
  80099b:	89 f0                	mov    %esi,%eax
  80099d:	e8 45 fb ff ff       	call   8004e7 <printnum>
			break;
  8009a2:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8009a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  8009a8:	83 c7 01             	add    $0x1,%edi
  8009ab:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009af:	83 f8 25             	cmp    $0x25,%eax
  8009b2:	0f 84 2f fc ff ff    	je     8005e7 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  8009b8:	85 c0                	test   %eax,%eax
  8009ba:	0f 84 8b 00 00 00    	je     800a4b <vprintfmt+0x47b>
			putch(ch, putdat);
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	53                   	push   %ebx
  8009c4:	50                   	push   %eax
  8009c5:	ff d6                	call   *%esi
  8009c7:	83 c4 10             	add    $0x10,%esp
  8009ca:	eb dc                	jmp    8009a8 <vprintfmt+0x3d8>
	if (lflag >= 2)
  8009cc:	83 f9 01             	cmp    $0x1,%ecx
  8009cf:	7e 15                	jle    8009e6 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8009d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d4:	8b 10                	mov    (%eax),%edx
  8009d6:	8b 48 04             	mov    0x4(%eax),%ecx
  8009d9:	8d 40 08             	lea    0x8(%eax),%eax
  8009dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009df:	b8 10 00 00 00       	mov    $0x10,%eax
  8009e4:	eb a5                	jmp    80098b <vprintfmt+0x3bb>
	else if (lflag)
  8009e6:	85 c9                	test   %ecx,%ecx
  8009e8:	75 17                	jne    800a01 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	8b 10                	mov    (%eax),%edx
  8009ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009f4:	8d 40 04             	lea    0x4(%eax),%eax
  8009f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009fa:	b8 10 00 00 00       	mov    $0x10,%eax
  8009ff:	eb 8a                	jmp    80098b <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800a01:	8b 45 14             	mov    0x14(%ebp),%eax
  800a04:	8b 10                	mov    (%eax),%edx
  800a06:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a0b:	8d 40 04             	lea    0x4(%eax),%eax
  800a0e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a11:	b8 10 00 00 00       	mov    $0x10,%eax
  800a16:	e9 70 ff ff ff       	jmp    80098b <vprintfmt+0x3bb>
			putch(ch, putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	53                   	push   %ebx
  800a1f:	6a 25                	push   $0x25
  800a21:	ff d6                	call   *%esi
			break;
  800a23:	83 c4 10             	add    $0x10,%esp
  800a26:	e9 7a ff ff ff       	jmp    8009a5 <vprintfmt+0x3d5>
			putch('%', putdat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	53                   	push   %ebx
  800a2f:	6a 25                	push   $0x25
  800a31:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a33:	83 c4 10             	add    $0x10,%esp
  800a36:	89 f8                	mov    %edi,%eax
  800a38:	eb 03                	jmp    800a3d <vprintfmt+0x46d>
  800a3a:	83 e8 01             	sub    $0x1,%eax
  800a3d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a41:	75 f7                	jne    800a3a <vprintfmt+0x46a>
  800a43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a46:	e9 5a ff ff ff       	jmp    8009a5 <vprintfmt+0x3d5>
}
  800a4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a4e:	5b                   	pop    %ebx
  800a4f:	5e                   	pop    %esi
  800a50:	5f                   	pop    %edi
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	83 ec 18             	sub    $0x18,%esp
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a62:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a66:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a70:	85 c0                	test   %eax,%eax
  800a72:	74 26                	je     800a9a <vsnprintf+0x47>
  800a74:	85 d2                	test   %edx,%edx
  800a76:	7e 22                	jle    800a9a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a78:	ff 75 14             	pushl  0x14(%ebp)
  800a7b:	ff 75 10             	pushl  0x10(%ebp)
  800a7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a81:	50                   	push   %eax
  800a82:	68 96 05 80 00       	push   $0x800596
  800a87:	e8 44 fb ff ff       	call   8005d0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a8f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a95:	83 c4 10             	add    $0x10,%esp
}
  800a98:	c9                   	leave  
  800a99:	c3                   	ret    
		return -E_INVAL;
  800a9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a9f:	eb f7                	jmp    800a98 <vsnprintf+0x45>

00800aa1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aa7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800aaa:	50                   	push   %eax
  800aab:	ff 75 10             	pushl  0x10(%ebp)
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	ff 75 08             	pushl  0x8(%ebp)
  800ab4:	e8 9a ff ff ff       	call   800a53 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac6:	eb 03                	jmp    800acb <strlen+0x10>
		n++;
  800ac8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800acb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800acf:	75 f7                	jne    800ac8 <strlen+0xd>
	return n;
}
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800adc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae1:	eb 03                	jmp    800ae6 <strnlen+0x13>
		n++;
  800ae3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ae6:	39 d0                	cmp    %edx,%eax
  800ae8:	74 06                	je     800af0 <strnlen+0x1d>
  800aea:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800aee:	75 f3                	jne    800ae3 <strnlen+0x10>
	return n;
}
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	53                   	push   %ebx
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800afc:	89 c2                	mov    %eax,%edx
  800afe:	83 c1 01             	add    $0x1,%ecx
  800b01:	83 c2 01             	add    $0x1,%edx
  800b04:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b08:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b0b:	84 db                	test   %bl,%bl
  800b0d:	75 ef                	jne    800afe <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800b0f:	5b                   	pop    %ebx
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	53                   	push   %ebx
  800b16:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b19:	53                   	push   %ebx
  800b1a:	e8 9c ff ff ff       	call   800abb <strlen>
  800b1f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	01 d8                	add    %ebx,%eax
  800b27:	50                   	push   %eax
  800b28:	e8 c5 ff ff ff       	call   800af2 <strcpy>
	return dst;
}
  800b2d:	89 d8                	mov    %ebx,%eax
  800b2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	56                   	push   %esi
  800b38:	53                   	push   %ebx
  800b39:	8b 75 08             	mov    0x8(%ebp),%esi
  800b3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b3f:	89 f3                	mov    %esi,%ebx
  800b41:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b44:	89 f2                	mov    %esi,%edx
  800b46:	eb 0f                	jmp    800b57 <strncpy+0x23>
		*dst++ = *src;
  800b48:	83 c2 01             	add    $0x1,%edx
  800b4b:	0f b6 01             	movzbl (%ecx),%eax
  800b4e:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b51:	80 39 01             	cmpb   $0x1,(%ecx)
  800b54:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800b57:	39 da                	cmp    %ebx,%edx
  800b59:	75 ed                	jne    800b48 <strncpy+0x14>
	}
	return ret;
}
  800b5b:	89 f0                	mov    %esi,%eax
  800b5d:	5b                   	pop    %ebx
  800b5e:	5e                   	pop    %esi
  800b5f:	5d                   	pop    %ebp
  800b60:	c3                   	ret    

00800b61 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	56                   	push   %esi
  800b65:	53                   	push   %ebx
  800b66:	8b 75 08             	mov    0x8(%ebp),%esi
  800b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b6f:	89 f0                	mov    %esi,%eax
  800b71:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b75:	85 c9                	test   %ecx,%ecx
  800b77:	75 0b                	jne    800b84 <strlcpy+0x23>
  800b79:	eb 17                	jmp    800b92 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b7b:	83 c2 01             	add    $0x1,%edx
  800b7e:	83 c0 01             	add    $0x1,%eax
  800b81:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800b84:	39 d8                	cmp    %ebx,%eax
  800b86:	74 07                	je     800b8f <strlcpy+0x2e>
  800b88:	0f b6 0a             	movzbl (%edx),%ecx
  800b8b:	84 c9                	test   %cl,%cl
  800b8d:	75 ec                	jne    800b7b <strlcpy+0x1a>
		*dst = '\0';
  800b8f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b92:	29 f0                	sub    %esi,%eax
}
  800b94:	5b                   	pop    %ebx
  800b95:	5e                   	pop    %esi
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ba1:	eb 06                	jmp    800ba9 <strcmp+0x11>
		p++, q++;
  800ba3:	83 c1 01             	add    $0x1,%ecx
  800ba6:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800ba9:	0f b6 01             	movzbl (%ecx),%eax
  800bac:	84 c0                	test   %al,%al
  800bae:	74 04                	je     800bb4 <strcmp+0x1c>
  800bb0:	3a 02                	cmp    (%edx),%al
  800bb2:	74 ef                	je     800ba3 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb4:	0f b6 c0             	movzbl %al,%eax
  800bb7:	0f b6 12             	movzbl (%edx),%edx
  800bba:	29 d0                	sub    %edx,%eax
}
  800bbc:	5d                   	pop    %ebp
  800bbd:	c3                   	ret    

00800bbe <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	53                   	push   %ebx
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc8:	89 c3                	mov    %eax,%ebx
  800bca:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bcd:	eb 06                	jmp    800bd5 <strncmp+0x17>
		n--, p++, q++;
  800bcf:	83 c0 01             	add    $0x1,%eax
  800bd2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bd5:	39 d8                	cmp    %ebx,%eax
  800bd7:	74 16                	je     800bef <strncmp+0x31>
  800bd9:	0f b6 08             	movzbl (%eax),%ecx
  800bdc:	84 c9                	test   %cl,%cl
  800bde:	74 04                	je     800be4 <strncmp+0x26>
  800be0:	3a 0a                	cmp    (%edx),%cl
  800be2:	74 eb                	je     800bcf <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800be4:	0f b6 00             	movzbl (%eax),%eax
  800be7:	0f b6 12             	movzbl (%edx),%edx
  800bea:	29 d0                	sub    %edx,%eax
}
  800bec:	5b                   	pop    %ebx
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    
		return 0;
  800bef:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf4:	eb f6                	jmp    800bec <strncmp+0x2e>

00800bf6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c00:	0f b6 10             	movzbl (%eax),%edx
  800c03:	84 d2                	test   %dl,%dl
  800c05:	74 09                	je     800c10 <strchr+0x1a>
		if (*s == c)
  800c07:	38 ca                	cmp    %cl,%dl
  800c09:	74 0a                	je     800c15 <strchr+0x1f>
	for (; *s; s++)
  800c0b:	83 c0 01             	add    $0x1,%eax
  800c0e:	eb f0                	jmp    800c00 <strchr+0xa>
			return (char *) s;
	return 0;
  800c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c21:	eb 03                	jmp    800c26 <strfind+0xf>
  800c23:	83 c0 01             	add    $0x1,%eax
  800c26:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c29:	38 ca                	cmp    %cl,%dl
  800c2b:	74 04                	je     800c31 <strfind+0x1a>
  800c2d:	84 d2                	test   %dl,%dl
  800c2f:	75 f2                	jne    800c23 <strfind+0xc>
			break;
	return (char *) s;
}
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c3f:	85 c9                	test   %ecx,%ecx
  800c41:	74 13                	je     800c56 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c43:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c49:	75 05                	jne    800c50 <memset+0x1d>
  800c4b:	f6 c1 03             	test   $0x3,%cl
  800c4e:	74 0d                	je     800c5d <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	fc                   	cld    
  800c54:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c56:	89 f8                	mov    %edi,%eax
  800c58:	5b                   	pop    %ebx
  800c59:	5e                   	pop    %esi
  800c5a:	5f                   	pop    %edi
  800c5b:	5d                   	pop    %ebp
  800c5c:	c3                   	ret    
		c &= 0xFF;
  800c5d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c61:	89 d3                	mov    %edx,%ebx
  800c63:	c1 e3 08             	shl    $0x8,%ebx
  800c66:	89 d0                	mov    %edx,%eax
  800c68:	c1 e0 18             	shl    $0x18,%eax
  800c6b:	89 d6                	mov    %edx,%esi
  800c6d:	c1 e6 10             	shl    $0x10,%esi
  800c70:	09 f0                	or     %esi,%eax
  800c72:	09 c2                	or     %eax,%edx
  800c74:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800c76:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c79:	89 d0                	mov    %edx,%eax
  800c7b:	fc                   	cld    
  800c7c:	f3 ab                	rep stos %eax,%es:(%edi)
  800c7e:	eb d6                	jmp    800c56 <memset+0x23>

00800c80 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	57                   	push   %edi
  800c84:	56                   	push   %esi
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c8e:	39 c6                	cmp    %eax,%esi
  800c90:	73 35                	jae    800cc7 <memmove+0x47>
  800c92:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c95:	39 c2                	cmp    %eax,%edx
  800c97:	76 2e                	jbe    800cc7 <memmove+0x47>
		s += n;
		d += n;
  800c99:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c9c:	89 d6                	mov    %edx,%esi
  800c9e:	09 fe                	or     %edi,%esi
  800ca0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ca6:	74 0c                	je     800cb4 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ca8:	83 ef 01             	sub    $0x1,%edi
  800cab:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cae:	fd                   	std    
  800caf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cb1:	fc                   	cld    
  800cb2:	eb 21                	jmp    800cd5 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb4:	f6 c1 03             	test   $0x3,%cl
  800cb7:	75 ef                	jne    800ca8 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cb9:	83 ef 04             	sub    $0x4,%edi
  800cbc:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cbf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cc2:	fd                   	std    
  800cc3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cc5:	eb ea                	jmp    800cb1 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cc7:	89 f2                	mov    %esi,%edx
  800cc9:	09 c2                	or     %eax,%edx
  800ccb:	f6 c2 03             	test   $0x3,%dl
  800cce:	74 09                	je     800cd9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800cd0:	89 c7                	mov    %eax,%edi
  800cd2:	fc                   	cld    
  800cd3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cd5:	5e                   	pop    %esi
  800cd6:	5f                   	pop    %edi
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cd9:	f6 c1 03             	test   $0x3,%cl
  800cdc:	75 f2                	jne    800cd0 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cde:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ce1:	89 c7                	mov    %eax,%edi
  800ce3:	fc                   	cld    
  800ce4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ce6:	eb ed                	jmp    800cd5 <memmove+0x55>

00800ce8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ceb:	ff 75 10             	pushl  0x10(%ebp)
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	ff 75 08             	pushl  0x8(%ebp)
  800cf4:	e8 87 ff ff ff       	call   800c80 <memmove>
}
  800cf9:	c9                   	leave  
  800cfa:	c3                   	ret    

00800cfb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	56                   	push   %esi
  800cff:	53                   	push   %ebx
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d06:	89 c6                	mov    %eax,%esi
  800d08:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d0b:	39 f0                	cmp    %esi,%eax
  800d0d:	74 1c                	je     800d2b <memcmp+0x30>
		if (*s1 != *s2)
  800d0f:	0f b6 08             	movzbl (%eax),%ecx
  800d12:	0f b6 1a             	movzbl (%edx),%ebx
  800d15:	38 d9                	cmp    %bl,%cl
  800d17:	75 08                	jne    800d21 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d19:	83 c0 01             	add    $0x1,%eax
  800d1c:	83 c2 01             	add    $0x1,%edx
  800d1f:	eb ea                	jmp    800d0b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d21:	0f b6 c1             	movzbl %cl,%eax
  800d24:	0f b6 db             	movzbl %bl,%ebx
  800d27:	29 d8                	sub    %ebx,%eax
  800d29:	eb 05                	jmp    800d30 <memcmp+0x35>
	}

	return 0;
  800d2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d30:	5b                   	pop    %ebx
  800d31:	5e                   	pop    %esi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d3d:	89 c2                	mov    %eax,%edx
  800d3f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d42:	39 d0                	cmp    %edx,%eax
  800d44:	73 09                	jae    800d4f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d46:	38 08                	cmp    %cl,(%eax)
  800d48:	74 05                	je     800d4f <memfind+0x1b>
	for (; s < ends; s++)
  800d4a:	83 c0 01             	add    $0x1,%eax
  800d4d:	eb f3                	jmp    800d42 <memfind+0xe>
			break;
	return (void *) s;
}
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    

00800d51 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	57                   	push   %edi
  800d55:	56                   	push   %esi
  800d56:	53                   	push   %ebx
  800d57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d5d:	eb 03                	jmp    800d62 <strtol+0x11>
		s++;
  800d5f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d62:	0f b6 01             	movzbl (%ecx),%eax
  800d65:	3c 20                	cmp    $0x20,%al
  800d67:	74 f6                	je     800d5f <strtol+0xe>
  800d69:	3c 09                	cmp    $0x9,%al
  800d6b:	74 f2                	je     800d5f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d6d:	3c 2b                	cmp    $0x2b,%al
  800d6f:	74 2e                	je     800d9f <strtol+0x4e>
	int neg = 0;
  800d71:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d76:	3c 2d                	cmp    $0x2d,%al
  800d78:	74 2f                	je     800da9 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d7a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d80:	75 05                	jne    800d87 <strtol+0x36>
  800d82:	80 39 30             	cmpb   $0x30,(%ecx)
  800d85:	74 2c                	je     800db3 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d87:	85 db                	test   %ebx,%ebx
  800d89:	75 0a                	jne    800d95 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d8b:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800d90:	80 39 30             	cmpb   $0x30,(%ecx)
  800d93:	74 28                	je     800dbd <strtol+0x6c>
		base = 10;
  800d95:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d9d:	eb 50                	jmp    800def <strtol+0x9e>
		s++;
  800d9f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800da2:	bf 00 00 00 00       	mov    $0x0,%edi
  800da7:	eb d1                	jmp    800d7a <strtol+0x29>
		s++, neg = 1;
  800da9:	83 c1 01             	add    $0x1,%ecx
  800dac:	bf 01 00 00 00       	mov    $0x1,%edi
  800db1:	eb c7                	jmp    800d7a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800db7:	74 0e                	je     800dc7 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800db9:	85 db                	test   %ebx,%ebx
  800dbb:	75 d8                	jne    800d95 <strtol+0x44>
		s++, base = 8;
  800dbd:	83 c1 01             	add    $0x1,%ecx
  800dc0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dc5:	eb ce                	jmp    800d95 <strtol+0x44>
		s += 2, base = 16;
  800dc7:	83 c1 02             	add    $0x2,%ecx
  800dca:	bb 10 00 00 00       	mov    $0x10,%ebx
  800dcf:	eb c4                	jmp    800d95 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800dd1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800dd4:	89 f3                	mov    %esi,%ebx
  800dd6:	80 fb 19             	cmp    $0x19,%bl
  800dd9:	77 29                	ja     800e04 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ddb:	0f be d2             	movsbl %dl,%edx
  800dde:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800de1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800de4:	7d 30                	jge    800e16 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800de6:	83 c1 01             	add    $0x1,%ecx
  800de9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ded:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800def:	0f b6 11             	movzbl (%ecx),%edx
  800df2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800df5:	89 f3                	mov    %esi,%ebx
  800df7:	80 fb 09             	cmp    $0x9,%bl
  800dfa:	77 d5                	ja     800dd1 <strtol+0x80>
			dig = *s - '0';
  800dfc:	0f be d2             	movsbl %dl,%edx
  800dff:	83 ea 30             	sub    $0x30,%edx
  800e02:	eb dd                	jmp    800de1 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800e04:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e07:	89 f3                	mov    %esi,%ebx
  800e09:	80 fb 19             	cmp    $0x19,%bl
  800e0c:	77 08                	ja     800e16 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800e0e:	0f be d2             	movsbl %dl,%edx
  800e11:	83 ea 37             	sub    $0x37,%edx
  800e14:	eb cb                	jmp    800de1 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1a:	74 05                	je     800e21 <strtol+0xd0>
		*endptr = (char *) s;
  800e1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e1f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e21:	89 c2                	mov    %eax,%edx
  800e23:	f7 da                	neg    %edx
  800e25:	85 ff                	test   %edi,%edi
  800e27:	0f 45 c2             	cmovne %edx,%eax
}
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5f                   	pop    %edi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    

00800e2f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e35:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e40:	89 c3                	mov    %eax,%ebx
  800e42:	89 c7                	mov    %eax,%edi
  800e44:	89 c6                	mov    %eax,%esi
  800e46:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    

00800e4d <sys_cgetc>:

int
sys_cgetc(void)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	57                   	push   %edi
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e53:	ba 00 00 00 00       	mov    $0x0,%edx
  800e58:	b8 01 00 00 00       	mov    $0x1,%eax
  800e5d:	89 d1                	mov    %edx,%ecx
  800e5f:	89 d3                	mov    %edx,%ebx
  800e61:	89 d7                	mov    %edx,%edi
  800e63:	89 d6                	mov    %edx,%esi
  800e65:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e67:	5b                   	pop    %ebx
  800e68:	5e                   	pop    %esi
  800e69:	5f                   	pop    %edi
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    

00800e6c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	57                   	push   %edi
  800e70:	56                   	push   %esi
  800e71:	53                   	push   %ebx
  800e72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e75:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7d:	b8 03 00 00 00       	mov    $0x3,%eax
  800e82:	89 cb                	mov    %ecx,%ebx
  800e84:	89 cf                	mov    %ecx,%edi
  800e86:	89 ce                	mov    %ecx,%esi
  800e88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8a:	85 c0                	test   %eax,%eax
  800e8c:	7f 08                	jg     800e96 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e96:	83 ec 0c             	sub    $0xc,%esp
  800e99:	50                   	push   %eax
  800e9a:	6a 03                	push   $0x3
  800e9c:	68 1f 2a 80 00       	push   $0x802a1f
  800ea1:	6a 23                	push   $0x23
  800ea3:	68 3c 2a 80 00       	push   $0x802a3c
  800ea8:	e8 4b f5 ff ff       	call   8003f8 <_panic>

00800ead <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	57                   	push   %edi
  800eb1:	56                   	push   %esi
  800eb2:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800eb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb8:	b8 02 00 00 00       	mov    $0x2,%eax
  800ebd:	89 d1                	mov    %edx,%ecx
  800ebf:	89 d3                	mov    %edx,%ebx
  800ec1:	89 d7                	mov    %edx,%edi
  800ec3:	89 d6                	mov    %edx,%esi
  800ec5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5f                   	pop    %edi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <sys_yield>:

void
sys_yield(void)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ed2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800edc:	89 d1                	mov    %edx,%ecx
  800ede:	89 d3                	mov    %edx,%ebx
  800ee0:	89 d7                	mov    %edx,%edi
  800ee2:	89 d6                	mov    %edx,%esi
  800ee4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5f                   	pop    %edi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    

00800eeb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	57                   	push   %edi
  800eef:	56                   	push   %esi
  800ef0:	53                   	push   %ebx
  800ef1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ef4:	be 00 00 00 00       	mov    $0x0,%esi
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eff:	b8 04 00 00 00       	mov    $0x4,%eax
  800f04:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f07:	89 f7                	mov    %esi,%edi
  800f09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0b:	85 c0                	test   %eax,%eax
  800f0d:	7f 08                	jg     800f17 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f12:	5b                   	pop    %ebx
  800f13:	5e                   	pop    %esi
  800f14:	5f                   	pop    %edi
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f17:	83 ec 0c             	sub    $0xc,%esp
  800f1a:	50                   	push   %eax
  800f1b:	6a 04                	push   $0x4
  800f1d:	68 1f 2a 80 00       	push   $0x802a1f
  800f22:	6a 23                	push   $0x23
  800f24:	68 3c 2a 80 00       	push   $0x802a3c
  800f29:	e8 ca f4 ff ff       	call   8003f8 <_panic>

00800f2e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
  800f34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800f37:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3d:	b8 05 00 00 00       	mov    $0x5,%eax
  800f42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f45:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f48:	8b 75 18             	mov    0x18(%ebp),%esi
  800f4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4d:	85 c0                	test   %eax,%eax
  800f4f:	7f 08                	jg     800f59 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f54:	5b                   	pop    %ebx
  800f55:	5e                   	pop    %esi
  800f56:	5f                   	pop    %edi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f59:	83 ec 0c             	sub    $0xc,%esp
  800f5c:	50                   	push   %eax
  800f5d:	6a 05                	push   $0x5
  800f5f:	68 1f 2a 80 00       	push   $0x802a1f
  800f64:	6a 23                	push   $0x23
  800f66:	68 3c 2a 80 00       	push   $0x802a3c
  800f6b:	e8 88 f4 ff ff       	call   8003f8 <_panic>

00800f70 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	57                   	push   %edi
  800f74:	56                   	push   %esi
  800f75:	53                   	push   %ebx
  800f76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800f79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f84:	b8 06 00 00 00       	mov    $0x6,%eax
  800f89:	89 df                	mov    %ebx,%edi
  800f8b:	89 de                	mov    %ebx,%esi
  800f8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	7f 08                	jg     800f9b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f96:	5b                   	pop    %ebx
  800f97:	5e                   	pop    %esi
  800f98:	5f                   	pop    %edi
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9b:	83 ec 0c             	sub    $0xc,%esp
  800f9e:	50                   	push   %eax
  800f9f:	6a 06                	push   $0x6
  800fa1:	68 1f 2a 80 00       	push   $0x802a1f
  800fa6:	6a 23                	push   $0x23
  800fa8:	68 3c 2a 80 00       	push   $0x802a3c
  800fad:	e8 46 f4 ff ff       	call   8003f8 <_panic>

00800fb2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	57                   	push   %edi
  800fb6:	56                   	push   %esi
  800fb7:	53                   	push   %ebx
  800fb8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800fbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc6:	b8 08 00 00 00       	mov    $0x8,%eax
  800fcb:	89 df                	mov    %ebx,%edi
  800fcd:	89 de                	mov    %ebx,%esi
  800fcf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	7f 08                	jg     800fdd <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd8:	5b                   	pop    %ebx
  800fd9:	5e                   	pop    %esi
  800fda:	5f                   	pop    %edi
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdd:	83 ec 0c             	sub    $0xc,%esp
  800fe0:	50                   	push   %eax
  800fe1:	6a 08                	push   $0x8
  800fe3:	68 1f 2a 80 00       	push   $0x802a1f
  800fe8:	6a 23                	push   $0x23
  800fea:	68 3c 2a 80 00       	push   $0x802a3c
  800fef:	e8 04 f4 ff ff       	call   8003f8 <_panic>

00800ff4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	57                   	push   %edi
  800ff8:	56                   	push   %esi
  800ff9:	53                   	push   %ebx
  800ffa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ffd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801002:	8b 55 08             	mov    0x8(%ebp),%edx
  801005:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801008:	b8 09 00 00 00       	mov    $0x9,%eax
  80100d:	89 df                	mov    %ebx,%edi
  80100f:	89 de                	mov    %ebx,%esi
  801011:	cd 30                	int    $0x30
	if(check && ret > 0)
  801013:	85 c0                	test   %eax,%eax
  801015:	7f 08                	jg     80101f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801017:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101a:	5b                   	pop    %ebx
  80101b:	5e                   	pop    %esi
  80101c:	5f                   	pop    %edi
  80101d:	5d                   	pop    %ebp
  80101e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80101f:	83 ec 0c             	sub    $0xc,%esp
  801022:	50                   	push   %eax
  801023:	6a 09                	push   $0x9
  801025:	68 1f 2a 80 00       	push   $0x802a1f
  80102a:	6a 23                	push   $0x23
  80102c:	68 3c 2a 80 00       	push   $0x802a3c
  801031:	e8 c2 f3 ff ff       	call   8003f8 <_panic>

00801036 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	57                   	push   %edi
  80103a:	56                   	push   %esi
  80103b:	53                   	push   %ebx
  80103c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80103f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801044:	8b 55 08             	mov    0x8(%ebp),%edx
  801047:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80104f:	89 df                	mov    %ebx,%edi
  801051:	89 de                	mov    %ebx,%esi
  801053:	cd 30                	int    $0x30
	if(check && ret > 0)
  801055:	85 c0                	test   %eax,%eax
  801057:	7f 08                	jg     801061 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801059:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105c:	5b                   	pop    %ebx
  80105d:	5e                   	pop    %esi
  80105e:	5f                   	pop    %edi
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801061:	83 ec 0c             	sub    $0xc,%esp
  801064:	50                   	push   %eax
  801065:	6a 0a                	push   $0xa
  801067:	68 1f 2a 80 00       	push   $0x802a1f
  80106c:	6a 23                	push   $0x23
  80106e:	68 3c 2a 80 00       	push   $0x802a3c
  801073:	e8 80 f3 ff ff       	call   8003f8 <_panic>

00801078 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	57                   	push   %edi
  80107c:	56                   	push   %esi
  80107d:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80107e:	8b 55 08             	mov    0x8(%ebp),%edx
  801081:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801084:	b8 0c 00 00 00       	mov    $0xc,%eax
  801089:	be 00 00 00 00       	mov    $0x0,%esi
  80108e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801091:	8b 7d 14             	mov    0x14(%ebp),%edi
  801094:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801096:	5b                   	pop    %ebx
  801097:	5e                   	pop    %esi
  801098:	5f                   	pop    %edi
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    

0080109b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	57                   	push   %edi
  80109f:	56                   	push   %esi
  8010a0:	53                   	push   %ebx
  8010a1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8010a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ac:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010b1:	89 cb                	mov    %ecx,%ebx
  8010b3:	89 cf                	mov    %ecx,%edi
  8010b5:	89 ce                	mov    %ecx,%esi
  8010b7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	7f 08                	jg     8010c5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c0:	5b                   	pop    %ebx
  8010c1:	5e                   	pop    %esi
  8010c2:	5f                   	pop    %edi
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c5:	83 ec 0c             	sub    $0xc,%esp
  8010c8:	50                   	push   %eax
  8010c9:	6a 0d                	push   $0xd
  8010cb:	68 1f 2a 80 00       	push   $0x802a1f
  8010d0:	6a 23                	push   $0x23
  8010d2:	68 3c 2a 80 00       	push   $0x802a3c
  8010d7:	e8 1c f3 ff ff       	call   8003f8 <_panic>

008010dc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	05 00 00 00 30       	add    $0x30000000,%eax
  8010e7:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ea:	5d                   	pop    %ebp
  8010eb:	c3                   	ret    

008010ec <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010fc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801101:	5d                   	pop    %ebp
  801102:	c3                   	ret    

00801103 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801109:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80110e:	89 c2                	mov    %eax,%edx
  801110:	c1 ea 16             	shr    $0x16,%edx
  801113:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80111a:	f6 c2 01             	test   $0x1,%dl
  80111d:	74 2a                	je     801149 <fd_alloc+0x46>
  80111f:	89 c2                	mov    %eax,%edx
  801121:	c1 ea 0c             	shr    $0xc,%edx
  801124:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80112b:	f6 c2 01             	test   $0x1,%dl
  80112e:	74 19                	je     801149 <fd_alloc+0x46>
  801130:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801135:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80113a:	75 d2                	jne    80110e <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80113c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801142:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801147:	eb 07                	jmp    801150 <fd_alloc+0x4d>
			*fd_store = fd;
  801149:	89 01                	mov    %eax,(%ecx)
			return 0;
  80114b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801150:	5d                   	pop    %ebp
  801151:	c3                   	ret    

00801152 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801158:	83 f8 1f             	cmp    $0x1f,%eax
  80115b:	77 36                	ja     801193 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80115d:	c1 e0 0c             	shl    $0xc,%eax
  801160:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801165:	89 c2                	mov    %eax,%edx
  801167:	c1 ea 16             	shr    $0x16,%edx
  80116a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801171:	f6 c2 01             	test   $0x1,%dl
  801174:	74 24                	je     80119a <fd_lookup+0x48>
  801176:	89 c2                	mov    %eax,%edx
  801178:	c1 ea 0c             	shr    $0xc,%edx
  80117b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801182:	f6 c2 01             	test   $0x1,%dl
  801185:	74 1a                	je     8011a1 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80118a:	89 02                	mov    %eax,(%edx)
	return 0;
  80118c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801191:	5d                   	pop    %ebp
  801192:	c3                   	ret    
		return -E_INVAL;
  801193:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801198:	eb f7                	jmp    801191 <fd_lookup+0x3f>
		return -E_INVAL;
  80119a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80119f:	eb f0                	jmp    801191 <fd_lookup+0x3f>
  8011a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a6:	eb e9                	jmp    801191 <fd_lookup+0x3f>

008011a8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	83 ec 08             	sub    $0x8,%esp
  8011ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b1:	ba c8 2a 80 00       	mov    $0x802ac8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8011b6:	b8 90 47 80 00       	mov    $0x804790,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011bb:	39 08                	cmp    %ecx,(%eax)
  8011bd:	74 33                	je     8011f2 <dev_lookup+0x4a>
  8011bf:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8011c2:	8b 02                	mov    (%edx),%eax
  8011c4:	85 c0                	test   %eax,%eax
  8011c6:	75 f3                	jne    8011bb <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011c8:	a1 90 67 80 00       	mov    0x806790,%eax
  8011cd:	8b 40 48             	mov    0x48(%eax),%eax
  8011d0:	83 ec 04             	sub    $0x4,%esp
  8011d3:	51                   	push   %ecx
  8011d4:	50                   	push   %eax
  8011d5:	68 4c 2a 80 00       	push   $0x802a4c
  8011da:	e8 f4 f2 ff ff       	call   8004d3 <cprintf>
	*dev = 0;
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011e8:	83 c4 10             	add    $0x10,%esp
  8011eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011f0:	c9                   	leave  
  8011f1:	c3                   	ret    
			*dev = devtab[i];
  8011f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fc:	eb f2                	jmp    8011f0 <dev_lookup+0x48>

008011fe <fd_close>:
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	57                   	push   %edi
  801202:	56                   	push   %esi
  801203:	53                   	push   %ebx
  801204:	83 ec 1c             	sub    $0x1c,%esp
  801207:	8b 75 08             	mov    0x8(%ebp),%esi
  80120a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80120d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801210:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801211:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801217:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80121a:	50                   	push   %eax
  80121b:	e8 32 ff ff ff       	call   801152 <fd_lookup>
  801220:	89 c3                	mov    %eax,%ebx
  801222:	83 c4 08             	add    $0x8,%esp
  801225:	85 c0                	test   %eax,%eax
  801227:	78 05                	js     80122e <fd_close+0x30>
	    || fd != fd2)
  801229:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80122c:	74 16                	je     801244 <fd_close+0x46>
		return (must_exist ? r : 0);
  80122e:	89 f8                	mov    %edi,%eax
  801230:	84 c0                	test   %al,%al
  801232:	b8 00 00 00 00       	mov    $0x0,%eax
  801237:	0f 44 d8             	cmove  %eax,%ebx
}
  80123a:	89 d8                	mov    %ebx,%eax
  80123c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123f:	5b                   	pop    %ebx
  801240:	5e                   	pop    %esi
  801241:	5f                   	pop    %edi
  801242:	5d                   	pop    %ebp
  801243:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801244:	83 ec 08             	sub    $0x8,%esp
  801247:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80124a:	50                   	push   %eax
  80124b:	ff 36                	pushl  (%esi)
  80124d:	e8 56 ff ff ff       	call   8011a8 <dev_lookup>
  801252:	89 c3                	mov    %eax,%ebx
  801254:	83 c4 10             	add    $0x10,%esp
  801257:	85 c0                	test   %eax,%eax
  801259:	78 15                	js     801270 <fd_close+0x72>
		if (dev->dev_close)
  80125b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80125e:	8b 40 10             	mov    0x10(%eax),%eax
  801261:	85 c0                	test   %eax,%eax
  801263:	74 1b                	je     801280 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801265:	83 ec 0c             	sub    $0xc,%esp
  801268:	56                   	push   %esi
  801269:	ff d0                	call   *%eax
  80126b:	89 c3                	mov    %eax,%ebx
  80126d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801270:	83 ec 08             	sub    $0x8,%esp
  801273:	56                   	push   %esi
  801274:	6a 00                	push   $0x0
  801276:	e8 f5 fc ff ff       	call   800f70 <sys_page_unmap>
	return r;
  80127b:	83 c4 10             	add    $0x10,%esp
  80127e:	eb ba                	jmp    80123a <fd_close+0x3c>
			r = 0;
  801280:	bb 00 00 00 00       	mov    $0x0,%ebx
  801285:	eb e9                	jmp    801270 <fd_close+0x72>

00801287 <close>:

int
close(int fdnum)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
  80128a:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80128d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801290:	50                   	push   %eax
  801291:	ff 75 08             	pushl  0x8(%ebp)
  801294:	e8 b9 fe ff ff       	call   801152 <fd_lookup>
  801299:	83 c4 08             	add    $0x8,%esp
  80129c:	85 c0                	test   %eax,%eax
  80129e:	78 10                	js     8012b0 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8012a0:	83 ec 08             	sub    $0x8,%esp
  8012a3:	6a 01                	push   $0x1
  8012a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8012a8:	e8 51 ff ff ff       	call   8011fe <fd_close>
  8012ad:	83 c4 10             	add    $0x10,%esp
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <close_all>:

void
close_all(void)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	53                   	push   %ebx
  8012b6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012b9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012be:	83 ec 0c             	sub    $0xc,%esp
  8012c1:	53                   	push   %ebx
  8012c2:	e8 c0 ff ff ff       	call   801287 <close>
	for (i = 0; i < MAXFD; i++)
  8012c7:	83 c3 01             	add    $0x1,%ebx
  8012ca:	83 c4 10             	add    $0x10,%esp
  8012cd:	83 fb 20             	cmp    $0x20,%ebx
  8012d0:	75 ec                	jne    8012be <close_all+0xc>
}
  8012d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	57                   	push   %edi
  8012db:	56                   	push   %esi
  8012dc:	53                   	push   %ebx
  8012dd:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012e3:	50                   	push   %eax
  8012e4:	ff 75 08             	pushl  0x8(%ebp)
  8012e7:	e8 66 fe ff ff       	call   801152 <fd_lookup>
  8012ec:	89 c3                	mov    %eax,%ebx
  8012ee:	83 c4 08             	add    $0x8,%esp
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	0f 88 81 00 00 00    	js     80137a <dup+0xa3>
		return r;
	close(newfdnum);
  8012f9:	83 ec 0c             	sub    $0xc,%esp
  8012fc:	ff 75 0c             	pushl  0xc(%ebp)
  8012ff:	e8 83 ff ff ff       	call   801287 <close>

	newfd = INDEX2FD(newfdnum);
  801304:	8b 75 0c             	mov    0xc(%ebp),%esi
  801307:	c1 e6 0c             	shl    $0xc,%esi
  80130a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801310:	83 c4 04             	add    $0x4,%esp
  801313:	ff 75 e4             	pushl  -0x1c(%ebp)
  801316:	e8 d1 fd ff ff       	call   8010ec <fd2data>
  80131b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80131d:	89 34 24             	mov    %esi,(%esp)
  801320:	e8 c7 fd ff ff       	call   8010ec <fd2data>
  801325:	83 c4 10             	add    $0x10,%esp
  801328:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80132a:	89 d8                	mov    %ebx,%eax
  80132c:	c1 e8 16             	shr    $0x16,%eax
  80132f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801336:	a8 01                	test   $0x1,%al
  801338:	74 11                	je     80134b <dup+0x74>
  80133a:	89 d8                	mov    %ebx,%eax
  80133c:	c1 e8 0c             	shr    $0xc,%eax
  80133f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801346:	f6 c2 01             	test   $0x1,%dl
  801349:	75 39                	jne    801384 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80134b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80134e:	89 d0                	mov    %edx,%eax
  801350:	c1 e8 0c             	shr    $0xc,%eax
  801353:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80135a:	83 ec 0c             	sub    $0xc,%esp
  80135d:	25 07 0e 00 00       	and    $0xe07,%eax
  801362:	50                   	push   %eax
  801363:	56                   	push   %esi
  801364:	6a 00                	push   $0x0
  801366:	52                   	push   %edx
  801367:	6a 00                	push   $0x0
  801369:	e8 c0 fb ff ff       	call   800f2e <sys_page_map>
  80136e:	89 c3                	mov    %eax,%ebx
  801370:	83 c4 20             	add    $0x20,%esp
  801373:	85 c0                	test   %eax,%eax
  801375:	78 31                	js     8013a8 <dup+0xd1>
		goto err;

	return newfdnum;
  801377:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80137a:	89 d8                	mov    %ebx,%eax
  80137c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80137f:	5b                   	pop    %ebx
  801380:	5e                   	pop    %esi
  801381:	5f                   	pop    %edi
  801382:	5d                   	pop    %ebp
  801383:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801384:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80138b:	83 ec 0c             	sub    $0xc,%esp
  80138e:	25 07 0e 00 00       	and    $0xe07,%eax
  801393:	50                   	push   %eax
  801394:	57                   	push   %edi
  801395:	6a 00                	push   $0x0
  801397:	53                   	push   %ebx
  801398:	6a 00                	push   $0x0
  80139a:	e8 8f fb ff ff       	call   800f2e <sys_page_map>
  80139f:	89 c3                	mov    %eax,%ebx
  8013a1:	83 c4 20             	add    $0x20,%esp
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	79 a3                	jns    80134b <dup+0x74>
	sys_page_unmap(0, newfd);
  8013a8:	83 ec 08             	sub    $0x8,%esp
  8013ab:	56                   	push   %esi
  8013ac:	6a 00                	push   $0x0
  8013ae:	e8 bd fb ff ff       	call   800f70 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013b3:	83 c4 08             	add    $0x8,%esp
  8013b6:	57                   	push   %edi
  8013b7:	6a 00                	push   $0x0
  8013b9:	e8 b2 fb ff ff       	call   800f70 <sys_page_unmap>
	return r;
  8013be:	83 c4 10             	add    $0x10,%esp
  8013c1:	eb b7                	jmp    80137a <dup+0xa3>

008013c3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	53                   	push   %ebx
  8013c7:	83 ec 14             	sub    $0x14,%esp
  8013ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d0:	50                   	push   %eax
  8013d1:	53                   	push   %ebx
  8013d2:	e8 7b fd ff ff       	call   801152 <fd_lookup>
  8013d7:	83 c4 08             	add    $0x8,%esp
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	78 3f                	js     80141d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013de:	83 ec 08             	sub    $0x8,%esp
  8013e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e4:	50                   	push   %eax
  8013e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e8:	ff 30                	pushl  (%eax)
  8013ea:	e8 b9 fd ff ff       	call   8011a8 <dev_lookup>
  8013ef:	83 c4 10             	add    $0x10,%esp
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	78 27                	js     80141d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f9:	8b 42 08             	mov    0x8(%edx),%eax
  8013fc:	83 e0 03             	and    $0x3,%eax
  8013ff:	83 f8 01             	cmp    $0x1,%eax
  801402:	74 1e                	je     801422 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801407:	8b 40 08             	mov    0x8(%eax),%eax
  80140a:	85 c0                	test   %eax,%eax
  80140c:	74 35                	je     801443 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80140e:	83 ec 04             	sub    $0x4,%esp
  801411:	ff 75 10             	pushl  0x10(%ebp)
  801414:	ff 75 0c             	pushl  0xc(%ebp)
  801417:	52                   	push   %edx
  801418:	ff d0                	call   *%eax
  80141a:	83 c4 10             	add    $0x10,%esp
}
  80141d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801420:	c9                   	leave  
  801421:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801422:	a1 90 67 80 00       	mov    0x806790,%eax
  801427:	8b 40 48             	mov    0x48(%eax),%eax
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	53                   	push   %ebx
  80142e:	50                   	push   %eax
  80142f:	68 8d 2a 80 00       	push   $0x802a8d
  801434:	e8 9a f0 ff ff       	call   8004d3 <cprintf>
		return -E_INVAL;
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801441:	eb da                	jmp    80141d <read+0x5a>
		return -E_NOT_SUPP;
  801443:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801448:	eb d3                	jmp    80141d <read+0x5a>

0080144a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	57                   	push   %edi
  80144e:	56                   	push   %esi
  80144f:	53                   	push   %ebx
  801450:	83 ec 0c             	sub    $0xc,%esp
  801453:	8b 7d 08             	mov    0x8(%ebp),%edi
  801456:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801459:	bb 00 00 00 00       	mov    $0x0,%ebx
  80145e:	39 f3                	cmp    %esi,%ebx
  801460:	73 25                	jae    801487 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	89 f0                	mov    %esi,%eax
  801467:	29 d8                	sub    %ebx,%eax
  801469:	50                   	push   %eax
  80146a:	89 d8                	mov    %ebx,%eax
  80146c:	03 45 0c             	add    0xc(%ebp),%eax
  80146f:	50                   	push   %eax
  801470:	57                   	push   %edi
  801471:	e8 4d ff ff ff       	call   8013c3 <read>
		if (m < 0)
  801476:	83 c4 10             	add    $0x10,%esp
  801479:	85 c0                	test   %eax,%eax
  80147b:	78 08                	js     801485 <readn+0x3b>
			return m;
		if (m == 0)
  80147d:	85 c0                	test   %eax,%eax
  80147f:	74 06                	je     801487 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801481:	01 c3                	add    %eax,%ebx
  801483:	eb d9                	jmp    80145e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801485:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801487:	89 d8                	mov    %ebx,%eax
  801489:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80148c:	5b                   	pop    %ebx
  80148d:	5e                   	pop    %esi
  80148e:	5f                   	pop    %edi
  80148f:	5d                   	pop    %ebp
  801490:	c3                   	ret    

00801491 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	53                   	push   %ebx
  801495:	83 ec 14             	sub    $0x14,%esp
  801498:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149e:	50                   	push   %eax
  80149f:	53                   	push   %ebx
  8014a0:	e8 ad fc ff ff       	call   801152 <fd_lookup>
  8014a5:	83 c4 08             	add    $0x8,%esp
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	78 3a                	js     8014e6 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b2:	50                   	push   %eax
  8014b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b6:	ff 30                	pushl  (%eax)
  8014b8:	e8 eb fc ff ff       	call   8011a8 <dev_lookup>
  8014bd:	83 c4 10             	add    $0x10,%esp
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	78 22                	js     8014e6 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014cb:	74 1e                	je     8014eb <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d0:	8b 52 0c             	mov    0xc(%edx),%edx
  8014d3:	85 d2                	test   %edx,%edx
  8014d5:	74 35                	je     80150c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014d7:	83 ec 04             	sub    $0x4,%esp
  8014da:	ff 75 10             	pushl  0x10(%ebp)
  8014dd:	ff 75 0c             	pushl  0xc(%ebp)
  8014e0:	50                   	push   %eax
  8014e1:	ff d2                	call   *%edx
  8014e3:	83 c4 10             	add    $0x10,%esp
}
  8014e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014eb:	a1 90 67 80 00       	mov    0x806790,%eax
  8014f0:	8b 40 48             	mov    0x48(%eax),%eax
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	53                   	push   %ebx
  8014f7:	50                   	push   %eax
  8014f8:	68 a9 2a 80 00       	push   $0x802aa9
  8014fd:	e8 d1 ef ff ff       	call   8004d3 <cprintf>
		return -E_INVAL;
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150a:	eb da                	jmp    8014e6 <write+0x55>
		return -E_NOT_SUPP;
  80150c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801511:	eb d3                	jmp    8014e6 <write+0x55>

00801513 <seek>:

int
seek(int fdnum, off_t offset)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801519:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	ff 75 08             	pushl  0x8(%ebp)
  801520:	e8 2d fc ff ff       	call   801152 <fd_lookup>
  801525:	83 c4 08             	add    $0x8,%esp
  801528:	85 c0                	test   %eax,%eax
  80152a:	78 0e                	js     80153a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80152c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801532:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801535:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	53                   	push   %ebx
  801540:	83 ec 14             	sub    $0x14,%esp
  801543:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801546:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801549:	50                   	push   %eax
  80154a:	53                   	push   %ebx
  80154b:	e8 02 fc ff ff       	call   801152 <fd_lookup>
  801550:	83 c4 08             	add    $0x8,%esp
  801553:	85 c0                	test   %eax,%eax
  801555:	78 37                	js     80158e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801557:	83 ec 08             	sub    $0x8,%esp
  80155a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155d:	50                   	push   %eax
  80155e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801561:	ff 30                	pushl  (%eax)
  801563:	e8 40 fc ff ff       	call   8011a8 <dev_lookup>
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	85 c0                	test   %eax,%eax
  80156d:	78 1f                	js     80158e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80156f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801572:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801576:	74 1b                	je     801593 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157b:	8b 52 18             	mov    0x18(%edx),%edx
  80157e:	85 d2                	test   %edx,%edx
  801580:	74 32                	je     8015b4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801582:	83 ec 08             	sub    $0x8,%esp
  801585:	ff 75 0c             	pushl  0xc(%ebp)
  801588:	50                   	push   %eax
  801589:	ff d2                	call   *%edx
  80158b:	83 c4 10             	add    $0x10,%esp
}
  80158e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801591:	c9                   	leave  
  801592:	c3                   	ret    
			thisenv->env_id, fdnum);
  801593:	a1 90 67 80 00       	mov    0x806790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801598:	8b 40 48             	mov    0x48(%eax),%eax
  80159b:	83 ec 04             	sub    $0x4,%esp
  80159e:	53                   	push   %ebx
  80159f:	50                   	push   %eax
  8015a0:	68 6c 2a 80 00       	push   $0x802a6c
  8015a5:	e8 29 ef ff ff       	call   8004d3 <cprintf>
		return -E_INVAL;
  8015aa:	83 c4 10             	add    $0x10,%esp
  8015ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b2:	eb da                	jmp    80158e <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b9:	eb d3                	jmp    80158e <ftruncate+0x52>

008015bb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	53                   	push   %ebx
  8015bf:	83 ec 14             	sub    $0x14,%esp
  8015c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c8:	50                   	push   %eax
  8015c9:	ff 75 08             	pushl  0x8(%ebp)
  8015cc:	e8 81 fb ff ff       	call   801152 <fd_lookup>
  8015d1:	83 c4 08             	add    $0x8,%esp
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	78 4b                	js     801623 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015d8:	83 ec 08             	sub    $0x8,%esp
  8015db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015de:	50                   	push   %eax
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e2:	ff 30                	pushl  (%eax)
  8015e4:	e8 bf fb ff ff       	call   8011a8 <dev_lookup>
  8015e9:	83 c4 10             	add    $0x10,%esp
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	78 33                	js     801623 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015f7:	74 2f                	je     801628 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015f9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015fc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801603:	00 00 00 
	stat->st_isdir = 0;
  801606:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80160d:	00 00 00 
	stat->st_dev = dev;
  801610:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	53                   	push   %ebx
  80161a:	ff 75 f0             	pushl  -0x10(%ebp)
  80161d:	ff 50 14             	call   *0x14(%eax)
  801620:	83 c4 10             	add    $0x10,%esp
}
  801623:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801626:	c9                   	leave  
  801627:	c3                   	ret    
		return -E_NOT_SUPP;
  801628:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80162d:	eb f4                	jmp    801623 <fstat+0x68>

0080162f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	56                   	push   %esi
  801633:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801634:	83 ec 08             	sub    $0x8,%esp
  801637:	6a 00                	push   $0x0
  801639:	ff 75 08             	pushl  0x8(%ebp)
  80163c:	e8 30 02 00 00       	call   801871 <open>
  801641:	89 c3                	mov    %eax,%ebx
  801643:	83 c4 10             	add    $0x10,%esp
  801646:	85 c0                	test   %eax,%eax
  801648:	78 1b                	js     801665 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80164a:	83 ec 08             	sub    $0x8,%esp
  80164d:	ff 75 0c             	pushl  0xc(%ebp)
  801650:	50                   	push   %eax
  801651:	e8 65 ff ff ff       	call   8015bb <fstat>
  801656:	89 c6                	mov    %eax,%esi
	close(fd);
  801658:	89 1c 24             	mov    %ebx,(%esp)
  80165b:	e8 27 fc ff ff       	call   801287 <close>
	return r;
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	89 f3                	mov    %esi,%ebx
}
  801665:	89 d8                	mov    %ebx,%eax
  801667:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166a:	5b                   	pop    %ebx
  80166b:	5e                   	pop    %esi
  80166c:	5d                   	pop    %ebp
  80166d:	c3                   	ret    

0080166e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	56                   	push   %esi
  801672:	53                   	push   %ebx
  801673:	89 c6                	mov    %eax,%esi
  801675:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801677:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80167e:	74 27                	je     8016a7 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801680:	6a 07                	push   $0x7
  801682:	68 00 70 80 00       	push   $0x807000
  801687:	56                   	push   %esi
  801688:	ff 35 00 50 80 00    	pushl  0x805000
  80168e:	e8 f6 0b 00 00       	call   802289 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801693:	83 c4 0c             	add    $0xc,%esp
  801696:	6a 00                	push   $0x0
  801698:	53                   	push   %ebx
  801699:	6a 00                	push   $0x0
  80169b:	e8 80 0b 00 00       	call   802220 <ipc_recv>
}
  8016a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a3:	5b                   	pop    %ebx
  8016a4:	5e                   	pop    %esi
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016a7:	83 ec 0c             	sub    $0xc,%esp
  8016aa:	6a 01                	push   $0x1
  8016ac:	e8 2c 0c 00 00       	call   8022dd <ipc_find_env>
  8016b1:	a3 00 50 80 00       	mov    %eax,0x805000
  8016b6:	83 c4 10             	add    $0x10,%esp
  8016b9:	eb c5                	jmp    801680 <fsipc+0x12>

008016bb <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c7:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8016cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cf:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d9:	b8 02 00 00 00       	mov    $0x2,%eax
  8016de:	e8 8b ff ff ff       	call   80166e <fsipc>
}
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <devfile_flush>:
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f1:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8016f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fb:	b8 06 00 00 00       	mov    $0x6,%eax
  801700:	e8 69 ff ff ff       	call   80166e <fsipc>
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <devfile_stat>:
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	53                   	push   %ebx
  80170b:	83 ec 04             	sub    $0x4,%esp
  80170e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8b 40 0c             	mov    0xc(%eax),%eax
  801717:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80171c:	ba 00 00 00 00       	mov    $0x0,%edx
  801721:	b8 05 00 00 00       	mov    $0x5,%eax
  801726:	e8 43 ff ff ff       	call   80166e <fsipc>
  80172b:	85 c0                	test   %eax,%eax
  80172d:	78 2c                	js     80175b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80172f:	83 ec 08             	sub    $0x8,%esp
  801732:	68 00 70 80 00       	push   $0x807000
  801737:	53                   	push   %ebx
  801738:	e8 b5 f3 ff ff       	call   800af2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80173d:	a1 80 70 80 00       	mov    0x807080,%eax
  801742:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801748:	a1 84 70 80 00       	mov    0x807084,%eax
  80174d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <devfile_write>:
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	53                   	push   %ebx
  801764:	83 ec 08             	sub    $0x8,%esp
  801767:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  80176a:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801770:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801775:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8b 40 0c             	mov    0xc(%eax),%eax
  80177e:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  801783:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801789:	53                   	push   %ebx
  80178a:	ff 75 0c             	pushl  0xc(%ebp)
  80178d:	68 08 70 80 00       	push   $0x807008
  801792:	e8 e9 f4 ff ff       	call   800c80 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
  80179c:	b8 04 00 00 00       	mov    $0x4,%eax
  8017a1:	e8 c8 fe ff ff       	call   80166e <fsipc>
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	78 0b                	js     8017b8 <devfile_write+0x58>
	assert(r <= n);
  8017ad:	39 d8                	cmp    %ebx,%eax
  8017af:	77 0c                	ja     8017bd <devfile_write+0x5d>
	assert(r <= PGSIZE);
  8017b1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017b6:	7f 1e                	jg     8017d6 <devfile_write+0x76>
}
  8017b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    
	assert(r <= n);
  8017bd:	68 d8 2a 80 00       	push   $0x802ad8
  8017c2:	68 df 2a 80 00       	push   $0x802adf
  8017c7:	68 98 00 00 00       	push   $0x98
  8017cc:	68 f4 2a 80 00       	push   $0x802af4
  8017d1:	e8 22 ec ff ff       	call   8003f8 <_panic>
	assert(r <= PGSIZE);
  8017d6:	68 ff 2a 80 00       	push   $0x802aff
  8017db:	68 df 2a 80 00       	push   $0x802adf
  8017e0:	68 99 00 00 00       	push   $0x99
  8017e5:	68 f4 2a 80 00       	push   $0x802af4
  8017ea:	e8 09 ec ff ff       	call   8003f8 <_panic>

008017ef <devfile_read>:
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	56                   	push   %esi
  8017f3:	53                   	push   %ebx
  8017f4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8017fd:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801802:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801808:	ba 00 00 00 00       	mov    $0x0,%edx
  80180d:	b8 03 00 00 00       	mov    $0x3,%eax
  801812:	e8 57 fe ff ff       	call   80166e <fsipc>
  801817:	89 c3                	mov    %eax,%ebx
  801819:	85 c0                	test   %eax,%eax
  80181b:	78 1f                	js     80183c <devfile_read+0x4d>
	assert(r <= n);
  80181d:	39 f0                	cmp    %esi,%eax
  80181f:	77 24                	ja     801845 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801821:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801826:	7f 33                	jg     80185b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801828:	83 ec 04             	sub    $0x4,%esp
  80182b:	50                   	push   %eax
  80182c:	68 00 70 80 00       	push   $0x807000
  801831:	ff 75 0c             	pushl  0xc(%ebp)
  801834:	e8 47 f4 ff ff       	call   800c80 <memmove>
	return r;
  801839:	83 c4 10             	add    $0x10,%esp
}
  80183c:	89 d8                	mov    %ebx,%eax
  80183e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801841:	5b                   	pop    %ebx
  801842:	5e                   	pop    %esi
  801843:	5d                   	pop    %ebp
  801844:	c3                   	ret    
	assert(r <= n);
  801845:	68 d8 2a 80 00       	push   $0x802ad8
  80184a:	68 df 2a 80 00       	push   $0x802adf
  80184f:	6a 7c                	push   $0x7c
  801851:	68 f4 2a 80 00       	push   $0x802af4
  801856:	e8 9d eb ff ff       	call   8003f8 <_panic>
	assert(r <= PGSIZE);
  80185b:	68 ff 2a 80 00       	push   $0x802aff
  801860:	68 df 2a 80 00       	push   $0x802adf
  801865:	6a 7d                	push   $0x7d
  801867:	68 f4 2a 80 00       	push   $0x802af4
  80186c:	e8 87 eb ff ff       	call   8003f8 <_panic>

00801871 <open>:
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	56                   	push   %esi
  801875:	53                   	push   %ebx
  801876:	83 ec 1c             	sub    $0x1c,%esp
  801879:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80187c:	56                   	push   %esi
  80187d:	e8 39 f2 ff ff       	call   800abb <strlen>
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80188a:	7f 6c                	jg     8018f8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80188c:	83 ec 0c             	sub    $0xc,%esp
  80188f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801892:	50                   	push   %eax
  801893:	e8 6b f8 ff ff       	call   801103 <fd_alloc>
  801898:	89 c3                	mov    %eax,%ebx
  80189a:	83 c4 10             	add    $0x10,%esp
  80189d:	85 c0                	test   %eax,%eax
  80189f:	78 3c                	js     8018dd <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018a1:	83 ec 08             	sub    $0x8,%esp
  8018a4:	56                   	push   %esi
  8018a5:	68 00 70 80 00       	push   $0x807000
  8018aa:	e8 43 f2 ff ff       	call   800af2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b2:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8018bf:	e8 aa fd ff ff       	call   80166e <fsipc>
  8018c4:	89 c3                	mov    %eax,%ebx
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	78 19                	js     8018e6 <open+0x75>
	return fd2num(fd);
  8018cd:	83 ec 0c             	sub    $0xc,%esp
  8018d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d3:	e8 04 f8 ff ff       	call   8010dc <fd2num>
  8018d8:	89 c3                	mov    %eax,%ebx
  8018da:	83 c4 10             	add    $0x10,%esp
}
  8018dd:	89 d8                	mov    %ebx,%eax
  8018df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    
		fd_close(fd, 0);
  8018e6:	83 ec 08             	sub    $0x8,%esp
  8018e9:	6a 00                	push   $0x0
  8018eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ee:	e8 0b f9 ff ff       	call   8011fe <fd_close>
		return r;
  8018f3:	83 c4 10             	add    $0x10,%esp
  8018f6:	eb e5                	jmp    8018dd <open+0x6c>
		return -E_BAD_PATH;
  8018f8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018fd:	eb de                	jmp    8018dd <open+0x6c>

008018ff <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801905:	ba 00 00 00 00       	mov    $0x0,%edx
  80190a:	b8 08 00 00 00       	mov    $0x8,%eax
  80190f:	e8 5a fd ff ff       	call   80166e <fsipc>
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	57                   	push   %edi
  80191a:	56                   	push   %esi
  80191b:	53                   	push   %ebx
  80191c:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801922:	6a 00                	push   $0x0
  801924:	ff 75 08             	pushl  0x8(%ebp)
  801927:	e8 45 ff ff ff       	call   801871 <open>
  80192c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	85 c0                	test   %eax,%eax
  801937:	0f 88 40 03 00 00    	js     801c7d <spawn+0x367>
  80193d:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	68 00 02 00 00       	push   $0x200
  801947:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80194d:	50                   	push   %eax
  80194e:	52                   	push   %edx
  80194f:	e8 f6 fa ff ff       	call   80144a <readn>
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	3d 00 02 00 00       	cmp    $0x200,%eax
  80195c:	75 5d                	jne    8019bb <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  80195e:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801965:	45 4c 46 
  801968:	75 51                	jne    8019bb <spawn+0xa5>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80196a:	b8 07 00 00 00       	mov    $0x7,%eax
  80196f:	cd 30                	int    $0x30
  801971:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801977:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80197d:	85 c0                	test   %eax,%eax
  80197f:	0f 88 2f 04 00 00    	js     801db4 <spawn+0x49e>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801985:	25 ff 03 00 00       	and    $0x3ff,%eax
  80198a:	6b f0 7c             	imul   $0x7c,%eax,%esi
  80198d:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801993:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801999:	b9 11 00 00 00       	mov    $0x11,%ecx
  80199e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8019a0:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8019a6:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8019ac:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8019b1:	be 00 00 00 00       	mov    $0x0,%esi
  8019b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8019b9:	eb 4b                	jmp    801a06 <spawn+0xf0>
		close(fd);
  8019bb:	83 ec 0c             	sub    $0xc,%esp
  8019be:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8019c4:	e8 be f8 ff ff       	call   801287 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8019c9:	83 c4 0c             	add    $0xc,%esp
  8019cc:	68 7f 45 4c 46       	push   $0x464c457f
  8019d1:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8019d7:	68 0b 2b 80 00       	push   $0x802b0b
  8019dc:	e8 f2 ea ff ff       	call   8004d3 <cprintf>
		return -E_NOT_EXEC;
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  8019eb:	ff ff ff 
  8019ee:	e9 8a 02 00 00       	jmp    801c7d <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  8019f3:	83 ec 0c             	sub    $0xc,%esp
  8019f6:	50                   	push   %eax
  8019f7:	e8 bf f0 ff ff       	call   800abb <strlen>
  8019fc:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801a00:	83 c3 01             	add    $0x1,%ebx
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801a0d:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801a10:	85 c0                	test   %eax,%eax
  801a12:	75 df                	jne    8019f3 <spawn+0xdd>
  801a14:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801a1a:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801a20:	bf 00 10 40 00       	mov    $0x401000,%edi
  801a25:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801a27:	89 fa                	mov    %edi,%edx
  801a29:	83 e2 fc             	and    $0xfffffffc,%edx
  801a2c:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801a33:	29 c2                	sub    %eax,%edx
  801a35:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801a3b:	8d 42 f8             	lea    -0x8(%edx),%eax
  801a3e:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801a43:	0f 86 7c 03 00 00    	jbe    801dc5 <spawn+0x4af>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	6a 07                	push   $0x7
  801a4e:	68 00 00 40 00       	push   $0x400000
  801a53:	6a 00                	push   $0x0
  801a55:	e8 91 f4 ff ff       	call   800eeb <sys_page_alloc>
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	85 c0                	test   %eax,%eax
  801a5f:	0f 88 65 03 00 00    	js     801dca <spawn+0x4b4>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801a65:	be 00 00 00 00       	mov    $0x0,%esi
  801a6a:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801a70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a73:	eb 30                	jmp    801aa5 <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  801a75:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a7b:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801a81:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  801a84:	83 ec 08             	sub    $0x8,%esp
  801a87:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a8a:	57                   	push   %edi
  801a8b:	e8 62 f0 ff ff       	call   800af2 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801a90:	83 c4 04             	add    $0x4,%esp
  801a93:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a96:	e8 20 f0 ff ff       	call   800abb <strlen>
  801a9b:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801a9f:	83 c6 01             	add    $0x1,%esi
  801aa2:	83 c4 10             	add    $0x10,%esp
  801aa5:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801aab:	7f c8                	jg     801a75 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801aad:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801ab3:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801ab9:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801ac0:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801ac6:	0f 85 8c 00 00 00    	jne    801b58 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801acc:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801ad2:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801ad8:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801adb:	89 f8                	mov    %edi,%eax
  801add:	8b 8d 88 fd ff ff    	mov    -0x278(%ebp),%ecx
  801ae3:	89 4f f8             	mov    %ecx,-0x8(%edi)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801ae6:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801aeb:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801af1:	83 ec 0c             	sub    $0xc,%esp
  801af4:	6a 07                	push   $0x7
  801af6:	68 00 d0 bf ee       	push   $0xeebfd000
  801afb:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b01:	68 00 00 40 00       	push   $0x400000
  801b06:	6a 00                	push   $0x0
  801b08:	e8 21 f4 ff ff       	call   800f2e <sys_page_map>
  801b0d:	89 c3                	mov    %eax,%ebx
  801b0f:	83 c4 20             	add    $0x20,%esp
  801b12:	85 c0                	test   %eax,%eax
  801b14:	0f 88 d0 02 00 00    	js     801dea <spawn+0x4d4>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801b1a:	83 ec 08             	sub    $0x8,%esp
  801b1d:	68 00 00 40 00       	push   $0x400000
  801b22:	6a 00                	push   $0x0
  801b24:	e8 47 f4 ff ff       	call   800f70 <sys_page_unmap>
  801b29:	89 c3                	mov    %eax,%ebx
  801b2b:	83 c4 10             	add    $0x10,%esp
  801b2e:	85 c0                	test   %eax,%eax
  801b30:	0f 88 b4 02 00 00    	js     801dea <spawn+0x4d4>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801b36:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801b3c:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801b43:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b49:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801b50:	00 00 00 
  801b53:	e9 56 01 00 00       	jmp    801cae <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b58:	68 80 2b 80 00       	push   $0x802b80
  801b5d:	68 df 2a 80 00       	push   $0x802adf
  801b62:	68 f2 00 00 00       	push   $0xf2
  801b67:	68 25 2b 80 00       	push   $0x802b25
  801b6c:	e8 87 e8 ff ff       	call   8003f8 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b71:	83 ec 04             	sub    $0x4,%esp
  801b74:	6a 07                	push   $0x7
  801b76:	68 00 00 40 00       	push   $0x400000
  801b7b:	6a 00                	push   $0x0
  801b7d:	e8 69 f3 ff ff       	call   800eeb <sys_page_alloc>
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	85 c0                	test   %eax,%eax
  801b87:	0f 88 48 02 00 00    	js     801dd5 <spawn+0x4bf>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801b8d:	83 ec 08             	sub    $0x8,%esp
  801b90:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801b96:	01 f0                	add    %esi,%eax
  801b98:	50                   	push   %eax
  801b99:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801b9f:	e8 6f f9 ff ff       	call   801513 <seek>
  801ba4:	83 c4 10             	add    $0x10,%esp
  801ba7:	85 c0                	test   %eax,%eax
  801ba9:	0f 88 2d 02 00 00    	js     801ddc <spawn+0x4c6>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801bb8:	29 f0                	sub    %esi,%eax
  801bba:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bbf:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bc4:	0f 47 c2             	cmova  %edx,%eax
  801bc7:	50                   	push   %eax
  801bc8:	68 00 00 40 00       	push   $0x400000
  801bcd:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801bd3:	e8 72 f8 ff ff       	call   80144a <readn>
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	85 c0                	test   %eax,%eax
  801bdd:	0f 88 00 02 00 00    	js     801de3 <spawn+0x4cd>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801be3:	83 ec 0c             	sub    $0xc,%esp
  801be6:	57                   	push   %edi
  801be7:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801bed:	56                   	push   %esi
  801bee:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801bf4:	68 00 00 40 00       	push   $0x400000
  801bf9:	6a 00                	push   $0x0
  801bfb:	e8 2e f3 ff ff       	call   800f2e <sys_page_map>
  801c00:	83 c4 20             	add    $0x20,%esp
  801c03:	85 c0                	test   %eax,%eax
  801c05:	0f 88 80 00 00 00    	js     801c8b <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801c0b:	83 ec 08             	sub    $0x8,%esp
  801c0e:	68 00 00 40 00       	push   $0x400000
  801c13:	6a 00                	push   $0x0
  801c15:	e8 56 f3 ff ff       	call   800f70 <sys_page_unmap>
  801c1a:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801c1d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c23:	89 de                	mov    %ebx,%esi
  801c25:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801c2b:	76 73                	jbe    801ca0 <spawn+0x38a>
		if (i >= filesz) {
  801c2d:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801c33:	0f 87 38 ff ff ff    	ja     801b71 <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801c39:	83 ec 04             	sub    $0x4,%esp
  801c3c:	57                   	push   %edi
  801c3d:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801c43:	56                   	push   %esi
  801c44:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801c4a:	e8 9c f2 ff ff       	call   800eeb <sys_page_alloc>
  801c4f:	83 c4 10             	add    $0x10,%esp
  801c52:	85 c0                	test   %eax,%eax
  801c54:	79 c7                	jns    801c1d <spawn+0x307>
  801c56:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801c58:	83 ec 0c             	sub    $0xc,%esp
  801c5b:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c61:	e8 06 f2 ff ff       	call   800e6c <sys_env_destroy>
	close(fd);
  801c66:	83 c4 04             	add    $0x4,%esp
  801c69:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801c6f:	e8 13 f6 ff ff       	call   801287 <close>
	return r;
  801c74:	83 c4 10             	add    $0x10,%esp
  801c77:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  801c7d:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c86:	5b                   	pop    %ebx
  801c87:	5e                   	pop    %esi
  801c88:	5f                   	pop    %edi
  801c89:	5d                   	pop    %ebp
  801c8a:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801c8b:	50                   	push   %eax
  801c8c:	68 31 2b 80 00       	push   $0x802b31
  801c91:	68 25 01 00 00       	push   $0x125
  801c96:	68 25 2b 80 00       	push   $0x802b25
  801c9b:	e8 58 e7 ff ff       	call   8003f8 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ca0:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801ca7:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801cae:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801cb5:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801cbb:	7e 71                	jle    801d2e <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801cbd:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  801cc3:	83 39 01             	cmpl   $0x1,(%ecx)
  801cc6:	75 d8                	jne    801ca0 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801cc8:	8b 41 18             	mov    0x18(%ecx),%eax
  801ccb:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801cce:	83 f8 01             	cmp    $0x1,%eax
  801cd1:	19 ff                	sbb    %edi,%edi
  801cd3:	83 e7 fe             	and    $0xfffffffe,%edi
  801cd6:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801cd9:	8b 59 04             	mov    0x4(%ecx),%ebx
  801cdc:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
  801ce2:	8b 71 10             	mov    0x10(%ecx),%esi
  801ce5:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
  801ceb:	8b 41 14             	mov    0x14(%ecx),%eax
  801cee:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801cf4:	8b 51 08             	mov    0x8(%ecx),%edx
  801cf7:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
	if ((i = PGOFF(va))) {
  801cfd:	89 d0                	mov    %edx,%eax
  801cff:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d04:	74 1e                	je     801d24 <spawn+0x40e>
		va -= i;
  801d06:	29 c2                	sub    %eax,%edx
  801d08:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		memsz += i;
  801d0e:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801d14:	01 c6                	add    %eax,%esi
  801d16:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
		fileoffset -= i;
  801d1c:	29 c3                	sub    %eax,%ebx
  801d1e:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801d24:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d29:	e9 f5 fe ff ff       	jmp    801c23 <spawn+0x30d>
	close(fd);
  801d2e:	83 ec 0c             	sub    $0xc,%esp
  801d31:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801d37:	e8 4b f5 ff ff       	call   801287 <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801d3c:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801d43:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801d46:	83 c4 08             	add    $0x8,%esp
  801d49:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801d4f:	50                   	push   %eax
  801d50:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801d56:	e8 99 f2 ff ff       	call   800ff4 <sys_env_set_trapframe>
  801d5b:	83 c4 10             	add    $0x10,%esp
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	78 28                	js     801d8a <spawn+0x474>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801d62:	83 ec 08             	sub    $0x8,%esp
  801d65:	6a 02                	push   $0x2
  801d67:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801d6d:	e8 40 f2 ff ff       	call   800fb2 <sys_env_set_status>
  801d72:	83 c4 10             	add    $0x10,%esp
  801d75:	85 c0                	test   %eax,%eax
  801d77:	78 26                	js     801d9f <spawn+0x489>
	return child;
  801d79:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d7f:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801d85:	e9 f3 fe ff ff       	jmp    801c7d <spawn+0x367>
		panic("sys_env_set_trapframe: %e", r);
  801d8a:	50                   	push   %eax
  801d8b:	68 4e 2b 80 00       	push   $0x802b4e
  801d90:	68 86 00 00 00       	push   $0x86
  801d95:	68 25 2b 80 00       	push   $0x802b25
  801d9a:	e8 59 e6 ff ff       	call   8003f8 <_panic>
		panic("sys_env_set_status: %e", r);
  801d9f:	50                   	push   %eax
  801da0:	68 68 2b 80 00       	push   $0x802b68
  801da5:	68 89 00 00 00       	push   $0x89
  801daa:	68 25 2b 80 00       	push   $0x802b25
  801daf:	e8 44 e6 ff ff       	call   8003f8 <_panic>
		return r;
  801db4:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801dba:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801dc0:	e9 b8 fe ff ff       	jmp    801c7d <spawn+0x367>
		return -E_NO_MEM;
  801dc5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801dca:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801dd0:	e9 a8 fe ff ff       	jmp    801c7d <spawn+0x367>
  801dd5:	89 c7                	mov    %eax,%edi
  801dd7:	e9 7c fe ff ff       	jmp    801c58 <spawn+0x342>
  801ddc:	89 c7                	mov    %eax,%edi
  801dde:	e9 75 fe ff ff       	jmp    801c58 <spawn+0x342>
  801de3:	89 c7                	mov    %eax,%edi
  801de5:	e9 6e fe ff ff       	jmp    801c58 <spawn+0x342>
	sys_page_unmap(0, UTEMP);
  801dea:	83 ec 08             	sub    $0x8,%esp
  801ded:	68 00 00 40 00       	push   $0x400000
  801df2:	6a 00                	push   $0x0
  801df4:	e8 77 f1 ff ff       	call   800f70 <sys_page_unmap>
  801df9:	83 c4 10             	add    $0x10,%esp
  801dfc:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801e02:	e9 76 fe ff ff       	jmp    801c7d <spawn+0x367>

00801e07 <spawnl>:
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	57                   	push   %edi
  801e0b:	56                   	push   %esi
  801e0c:	53                   	push   %ebx
  801e0d:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801e10:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801e13:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801e18:	eb 05                	jmp    801e1f <spawnl+0x18>
		argc++;
  801e1a:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801e1d:	89 ca                	mov    %ecx,%edx
  801e1f:	8d 4a 04             	lea    0x4(%edx),%ecx
  801e22:	83 3a 00             	cmpl   $0x0,(%edx)
  801e25:	75 f3                	jne    801e1a <spawnl+0x13>
	const char *argv[argc+2];
  801e27:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801e2e:	83 e2 f0             	and    $0xfffffff0,%edx
  801e31:	29 d4                	sub    %edx,%esp
  801e33:	8d 54 24 03          	lea    0x3(%esp),%edx
  801e37:	c1 ea 02             	shr    $0x2,%edx
  801e3a:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801e41:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801e43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e46:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801e4d:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801e54:	00 
	va_start(vl, arg0);
  801e55:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801e58:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5f:	eb 0b                	jmp    801e6c <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801e61:	83 c0 01             	add    $0x1,%eax
  801e64:	8b 39                	mov    (%ecx),%edi
  801e66:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801e69:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801e6c:	39 d0                	cmp    %edx,%eax
  801e6e:	75 f1                	jne    801e61 <spawnl+0x5a>
	return spawn(prog, argv);
  801e70:	83 ec 08             	sub    $0x8,%esp
  801e73:	56                   	push   %esi
  801e74:	ff 75 08             	pushl  0x8(%ebp)
  801e77:	e8 9a fa ff ff       	call   801916 <spawn>
}
  801e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e7f:	5b                   	pop    %ebx
  801e80:	5e                   	pop    %esi
  801e81:	5f                   	pop    %edi
  801e82:	5d                   	pop    %ebp
  801e83:	c3                   	ret    

00801e84 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	56                   	push   %esi
  801e88:	53                   	push   %ebx
  801e89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e8c:	83 ec 0c             	sub    $0xc,%esp
  801e8f:	ff 75 08             	pushl  0x8(%ebp)
  801e92:	e8 55 f2 ff ff       	call   8010ec <fd2data>
  801e97:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e99:	83 c4 08             	add    $0x8,%esp
  801e9c:	68 a8 2b 80 00       	push   $0x802ba8
  801ea1:	53                   	push   %ebx
  801ea2:	e8 4b ec ff ff       	call   800af2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ea7:	8b 46 04             	mov    0x4(%esi),%eax
  801eaa:	2b 06                	sub    (%esi),%eax
  801eac:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801eb2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801eb9:	00 00 00 
	stat->st_dev = &devpipe;
  801ebc:	c7 83 88 00 00 00 ac 	movl   $0x8047ac,0x88(%ebx)
  801ec3:	47 80 00 
	return 0;
}
  801ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ece:	5b                   	pop    %ebx
  801ecf:	5e                   	pop    %esi
  801ed0:	5d                   	pop    %ebp
  801ed1:	c3                   	ret    

00801ed2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	53                   	push   %ebx
  801ed6:	83 ec 0c             	sub    $0xc,%esp
  801ed9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801edc:	53                   	push   %ebx
  801edd:	6a 00                	push   $0x0
  801edf:	e8 8c f0 ff ff       	call   800f70 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ee4:	89 1c 24             	mov    %ebx,(%esp)
  801ee7:	e8 00 f2 ff ff       	call   8010ec <fd2data>
  801eec:	83 c4 08             	add    $0x8,%esp
  801eef:	50                   	push   %eax
  801ef0:	6a 00                	push   $0x0
  801ef2:	e8 79 f0 ff ff       	call   800f70 <sys_page_unmap>
}
  801ef7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <_pipeisclosed>:
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	57                   	push   %edi
  801f00:	56                   	push   %esi
  801f01:	53                   	push   %ebx
  801f02:	83 ec 1c             	sub    $0x1c,%esp
  801f05:	89 c7                	mov    %eax,%edi
  801f07:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f09:	a1 90 67 80 00       	mov    0x806790,%eax
  801f0e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f11:	83 ec 0c             	sub    $0xc,%esp
  801f14:	57                   	push   %edi
  801f15:	e8 fc 03 00 00       	call   802316 <pageref>
  801f1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f1d:	89 34 24             	mov    %esi,(%esp)
  801f20:	e8 f1 03 00 00       	call   802316 <pageref>
		nn = thisenv->env_runs;
  801f25:	8b 15 90 67 80 00    	mov    0x806790,%edx
  801f2b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f2e:	83 c4 10             	add    $0x10,%esp
  801f31:	39 cb                	cmp    %ecx,%ebx
  801f33:	74 1b                	je     801f50 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f35:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f38:	75 cf                	jne    801f09 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f3a:	8b 42 58             	mov    0x58(%edx),%eax
  801f3d:	6a 01                	push   $0x1
  801f3f:	50                   	push   %eax
  801f40:	53                   	push   %ebx
  801f41:	68 af 2b 80 00       	push   $0x802baf
  801f46:	e8 88 e5 ff ff       	call   8004d3 <cprintf>
  801f4b:	83 c4 10             	add    $0x10,%esp
  801f4e:	eb b9                	jmp    801f09 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f50:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f53:	0f 94 c0             	sete   %al
  801f56:	0f b6 c0             	movzbl %al,%eax
}
  801f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f5c:	5b                   	pop    %ebx
  801f5d:	5e                   	pop    %esi
  801f5e:	5f                   	pop    %edi
  801f5f:	5d                   	pop    %ebp
  801f60:	c3                   	ret    

00801f61 <devpipe_write>:
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	57                   	push   %edi
  801f65:	56                   	push   %esi
  801f66:	53                   	push   %ebx
  801f67:	83 ec 28             	sub    $0x28,%esp
  801f6a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f6d:	56                   	push   %esi
  801f6e:	e8 79 f1 ff ff       	call   8010ec <fd2data>
  801f73:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f80:	74 4f                	je     801fd1 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f82:	8b 43 04             	mov    0x4(%ebx),%eax
  801f85:	8b 0b                	mov    (%ebx),%ecx
  801f87:	8d 51 20             	lea    0x20(%ecx),%edx
  801f8a:	39 d0                	cmp    %edx,%eax
  801f8c:	72 14                	jb     801fa2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f8e:	89 da                	mov    %ebx,%edx
  801f90:	89 f0                	mov    %esi,%eax
  801f92:	e8 65 ff ff ff       	call   801efc <_pipeisclosed>
  801f97:	85 c0                	test   %eax,%eax
  801f99:	75 3a                	jne    801fd5 <devpipe_write+0x74>
			sys_yield();
  801f9b:	e8 2c ef ff ff       	call   800ecc <sys_yield>
  801fa0:	eb e0                	jmp    801f82 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fa2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fa5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fa9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fac:	89 c2                	mov    %eax,%edx
  801fae:	c1 fa 1f             	sar    $0x1f,%edx
  801fb1:	89 d1                	mov    %edx,%ecx
  801fb3:	c1 e9 1b             	shr    $0x1b,%ecx
  801fb6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801fb9:	83 e2 1f             	and    $0x1f,%edx
  801fbc:	29 ca                	sub    %ecx,%edx
  801fbe:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801fc2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801fc6:	83 c0 01             	add    $0x1,%eax
  801fc9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801fcc:	83 c7 01             	add    $0x1,%edi
  801fcf:	eb ac                	jmp    801f7d <devpipe_write+0x1c>
	return i;
  801fd1:	89 f8                	mov    %edi,%eax
  801fd3:	eb 05                	jmp    801fda <devpipe_write+0x79>
				return 0;
  801fd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fdd:	5b                   	pop    %ebx
  801fde:	5e                   	pop    %esi
  801fdf:	5f                   	pop    %edi
  801fe0:	5d                   	pop    %ebp
  801fe1:	c3                   	ret    

00801fe2 <devpipe_read>:
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	57                   	push   %edi
  801fe6:	56                   	push   %esi
  801fe7:	53                   	push   %ebx
  801fe8:	83 ec 18             	sub    $0x18,%esp
  801feb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801fee:	57                   	push   %edi
  801fef:	e8 f8 f0 ff ff       	call   8010ec <fd2data>
  801ff4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ff6:	83 c4 10             	add    $0x10,%esp
  801ff9:	be 00 00 00 00       	mov    $0x0,%esi
  801ffe:	3b 75 10             	cmp    0x10(%ebp),%esi
  802001:	74 47                	je     80204a <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802003:	8b 03                	mov    (%ebx),%eax
  802005:	3b 43 04             	cmp    0x4(%ebx),%eax
  802008:	75 22                	jne    80202c <devpipe_read+0x4a>
			if (i > 0)
  80200a:	85 f6                	test   %esi,%esi
  80200c:	75 14                	jne    802022 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80200e:	89 da                	mov    %ebx,%edx
  802010:	89 f8                	mov    %edi,%eax
  802012:	e8 e5 fe ff ff       	call   801efc <_pipeisclosed>
  802017:	85 c0                	test   %eax,%eax
  802019:	75 33                	jne    80204e <devpipe_read+0x6c>
			sys_yield();
  80201b:	e8 ac ee ff ff       	call   800ecc <sys_yield>
  802020:	eb e1                	jmp    802003 <devpipe_read+0x21>
				return i;
  802022:	89 f0                	mov    %esi,%eax
}
  802024:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802027:	5b                   	pop    %ebx
  802028:	5e                   	pop    %esi
  802029:	5f                   	pop    %edi
  80202a:	5d                   	pop    %ebp
  80202b:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80202c:	99                   	cltd   
  80202d:	c1 ea 1b             	shr    $0x1b,%edx
  802030:	01 d0                	add    %edx,%eax
  802032:	83 e0 1f             	and    $0x1f,%eax
  802035:	29 d0                	sub    %edx,%eax
  802037:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80203c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80203f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802042:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802045:	83 c6 01             	add    $0x1,%esi
  802048:	eb b4                	jmp    801ffe <devpipe_read+0x1c>
	return i;
  80204a:	89 f0                	mov    %esi,%eax
  80204c:	eb d6                	jmp    802024 <devpipe_read+0x42>
				return 0;
  80204e:	b8 00 00 00 00       	mov    $0x0,%eax
  802053:	eb cf                	jmp    802024 <devpipe_read+0x42>

00802055 <pipe>:
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	56                   	push   %esi
  802059:	53                   	push   %ebx
  80205a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80205d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802060:	50                   	push   %eax
  802061:	e8 9d f0 ff ff       	call   801103 <fd_alloc>
  802066:	89 c3                	mov    %eax,%ebx
  802068:	83 c4 10             	add    $0x10,%esp
  80206b:	85 c0                	test   %eax,%eax
  80206d:	78 5b                	js     8020ca <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80206f:	83 ec 04             	sub    $0x4,%esp
  802072:	68 07 04 00 00       	push   $0x407
  802077:	ff 75 f4             	pushl  -0xc(%ebp)
  80207a:	6a 00                	push   $0x0
  80207c:	e8 6a ee ff ff       	call   800eeb <sys_page_alloc>
  802081:	89 c3                	mov    %eax,%ebx
  802083:	83 c4 10             	add    $0x10,%esp
  802086:	85 c0                	test   %eax,%eax
  802088:	78 40                	js     8020ca <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802090:	50                   	push   %eax
  802091:	e8 6d f0 ff ff       	call   801103 <fd_alloc>
  802096:	89 c3                	mov    %eax,%ebx
  802098:	83 c4 10             	add    $0x10,%esp
  80209b:	85 c0                	test   %eax,%eax
  80209d:	78 1b                	js     8020ba <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80209f:	83 ec 04             	sub    $0x4,%esp
  8020a2:	68 07 04 00 00       	push   $0x407
  8020a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8020aa:	6a 00                	push   $0x0
  8020ac:	e8 3a ee ff ff       	call   800eeb <sys_page_alloc>
  8020b1:	89 c3                	mov    %eax,%ebx
  8020b3:	83 c4 10             	add    $0x10,%esp
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	79 19                	jns    8020d3 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8020ba:	83 ec 08             	sub    $0x8,%esp
  8020bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c0:	6a 00                	push   $0x0
  8020c2:	e8 a9 ee ff ff       	call   800f70 <sys_page_unmap>
  8020c7:	83 c4 10             	add    $0x10,%esp
}
  8020ca:	89 d8                	mov    %ebx,%eax
  8020cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020cf:	5b                   	pop    %ebx
  8020d0:	5e                   	pop    %esi
  8020d1:	5d                   	pop    %ebp
  8020d2:	c3                   	ret    
	va = fd2data(fd0);
  8020d3:	83 ec 0c             	sub    $0xc,%esp
  8020d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d9:	e8 0e f0 ff ff       	call   8010ec <fd2data>
  8020de:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020e0:	83 c4 0c             	add    $0xc,%esp
  8020e3:	68 07 04 00 00       	push   $0x407
  8020e8:	50                   	push   %eax
  8020e9:	6a 00                	push   $0x0
  8020eb:	e8 fb ed ff ff       	call   800eeb <sys_page_alloc>
  8020f0:	89 c3                	mov    %eax,%ebx
  8020f2:	83 c4 10             	add    $0x10,%esp
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	0f 88 8c 00 00 00    	js     802189 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020fd:	83 ec 0c             	sub    $0xc,%esp
  802100:	ff 75 f0             	pushl  -0x10(%ebp)
  802103:	e8 e4 ef ff ff       	call   8010ec <fd2data>
  802108:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80210f:	50                   	push   %eax
  802110:	6a 00                	push   $0x0
  802112:	56                   	push   %esi
  802113:	6a 00                	push   $0x0
  802115:	e8 14 ee ff ff       	call   800f2e <sys_page_map>
  80211a:	89 c3                	mov    %eax,%ebx
  80211c:	83 c4 20             	add    $0x20,%esp
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 58                	js     80217b <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	8b 15 ac 47 80 00    	mov    0x8047ac,%edx
  80212c:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80212e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802131:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213b:	8b 15 ac 47 80 00    	mov    0x8047ac,%edx
  802141:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802146:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80214d:	83 ec 0c             	sub    $0xc,%esp
  802150:	ff 75 f4             	pushl  -0xc(%ebp)
  802153:	e8 84 ef ff ff       	call   8010dc <fd2num>
  802158:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80215b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80215d:	83 c4 04             	add    $0x4,%esp
  802160:	ff 75 f0             	pushl  -0x10(%ebp)
  802163:	e8 74 ef ff ff       	call   8010dc <fd2num>
  802168:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80216b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80216e:	83 c4 10             	add    $0x10,%esp
  802171:	bb 00 00 00 00       	mov    $0x0,%ebx
  802176:	e9 4f ff ff ff       	jmp    8020ca <pipe+0x75>
	sys_page_unmap(0, va);
  80217b:	83 ec 08             	sub    $0x8,%esp
  80217e:	56                   	push   %esi
  80217f:	6a 00                	push   $0x0
  802181:	e8 ea ed ff ff       	call   800f70 <sys_page_unmap>
  802186:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802189:	83 ec 08             	sub    $0x8,%esp
  80218c:	ff 75 f0             	pushl  -0x10(%ebp)
  80218f:	6a 00                	push   $0x0
  802191:	e8 da ed ff ff       	call   800f70 <sys_page_unmap>
  802196:	83 c4 10             	add    $0x10,%esp
  802199:	e9 1c ff ff ff       	jmp    8020ba <pipe+0x65>

0080219e <pipeisclosed>:
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021a7:	50                   	push   %eax
  8021a8:	ff 75 08             	pushl  0x8(%ebp)
  8021ab:	e8 a2 ef ff ff       	call   801152 <fd_lookup>
  8021b0:	83 c4 10             	add    $0x10,%esp
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	78 18                	js     8021cf <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8021b7:	83 ec 0c             	sub    $0xc,%esp
  8021ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8021bd:	e8 2a ef ff ff       	call   8010ec <fd2data>
	return _pipeisclosed(fd, p);
  8021c2:	89 c2                	mov    %eax,%edx
  8021c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c7:	e8 30 fd ff ff       	call   801efc <_pipeisclosed>
  8021cc:	83 c4 10             	add    $0x10,%esp
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	56                   	push   %esi
  8021d5:	53                   	push   %ebx
  8021d6:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8021d9:	85 f6                	test   %esi,%esi
  8021db:	74 13                	je     8021f0 <wait+0x1f>
	e = &envs[ENVX(envid)];
  8021dd:	89 f3                	mov    %esi,%ebx
  8021df:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8021e5:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8021e8:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8021ee:	eb 1b                	jmp    80220b <wait+0x3a>
	assert(envid != 0);
  8021f0:	68 c7 2b 80 00       	push   $0x802bc7
  8021f5:	68 df 2a 80 00       	push   $0x802adf
  8021fa:	6a 09                	push   $0x9
  8021fc:	68 d2 2b 80 00       	push   $0x802bd2
  802201:	e8 f2 e1 ff ff       	call   8003f8 <_panic>
		sys_yield();
  802206:	e8 c1 ec ff ff       	call   800ecc <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80220b:	8b 43 48             	mov    0x48(%ebx),%eax
  80220e:	39 f0                	cmp    %esi,%eax
  802210:	75 07                	jne    802219 <wait+0x48>
  802212:	8b 43 54             	mov    0x54(%ebx),%eax
  802215:	85 c0                	test   %eax,%eax
  802217:	75 ed                	jne    802206 <wait+0x35>
}
  802219:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80221c:	5b                   	pop    %ebx
  80221d:	5e                   	pop    %esi
  80221e:	5d                   	pop    %ebp
  80221f:	c3                   	ret    

00802220 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
  802223:	56                   	push   %esi
  802224:	53                   	push   %ebx
  802225:	8b 75 08             	mov    0x8(%ebp),%esi
  802228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  80222e:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  802230:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  802235:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  802238:	83 ec 0c             	sub    $0xc,%esp
  80223b:	50                   	push   %eax
  80223c:	e8 5a ee ff ff       	call   80109b <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  802241:	83 c4 10             	add    $0x10,%esp
  802244:	85 c0                	test   %eax,%eax
  802246:	78 2b                	js     802273 <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  802248:	85 f6                	test   %esi,%esi
  80224a:	74 0a                	je     802256 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80224c:	a1 90 67 80 00       	mov    0x806790,%eax
  802251:	8b 40 74             	mov    0x74(%eax),%eax
  802254:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  802256:	85 db                	test   %ebx,%ebx
  802258:	74 0a                	je     802264 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80225a:	a1 90 67 80 00       	mov    0x806790,%eax
  80225f:	8b 40 78             	mov    0x78(%eax),%eax
  802262:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802264:	a1 90 67 80 00       	mov    0x806790,%eax
  802269:	8b 40 70             	mov    0x70(%eax),%eax
}
  80226c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80226f:	5b                   	pop    %ebx
  802270:	5e                   	pop    %esi
  802271:	5d                   	pop    %ebp
  802272:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802273:	85 f6                	test   %esi,%esi
  802275:	74 06                	je     80227d <ipc_recv+0x5d>
  802277:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  80227d:	85 db                	test   %ebx,%ebx
  80227f:	74 eb                	je     80226c <ipc_recv+0x4c>
  802281:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802287:	eb e3                	jmp    80226c <ipc_recv+0x4c>

00802289 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	57                   	push   %edi
  80228d:	56                   	push   %esi
  80228e:	53                   	push   %ebx
  80228f:	83 ec 0c             	sub    $0xc,%esp
  802292:	8b 7d 08             	mov    0x8(%ebp),%edi
  802295:	8b 75 0c             	mov    0xc(%ebp),%esi
  802298:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  80229b:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  80229d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8022a2:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  8022a5:	ff 75 14             	pushl  0x14(%ebp)
  8022a8:	53                   	push   %ebx
  8022a9:	56                   	push   %esi
  8022aa:	57                   	push   %edi
  8022ab:	e8 c8 ed ff ff       	call   801078 <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  8022b0:	83 c4 10             	add    $0x10,%esp
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	74 1e                	je     8022d5 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  8022b7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022ba:	75 07                	jne    8022c3 <ipc_send+0x3a>
			sys_yield();
  8022bc:	e8 0b ec ff ff       	call   800ecc <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  8022c1:	eb e2                	jmp    8022a5 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  8022c3:	50                   	push   %eax
  8022c4:	68 dd 2b 80 00       	push   $0x802bdd
  8022c9:	6a 41                	push   $0x41
  8022cb:	68 eb 2b 80 00       	push   $0x802beb
  8022d0:	e8 23 e1 ff ff       	call   8003f8 <_panic>
		}
	}
}
  8022d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022d8:	5b                   	pop    %ebx
  8022d9:	5e                   	pop    %esi
  8022da:	5f                   	pop    %edi
  8022db:	5d                   	pop    %ebp
  8022dc:	c3                   	ret    

008022dd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022e3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022e8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8022eb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022f1:	8b 52 50             	mov    0x50(%edx),%edx
  8022f4:	39 ca                	cmp    %ecx,%edx
  8022f6:	74 11                	je     802309 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8022f8:	83 c0 01             	add    $0x1,%eax
  8022fb:	3d 00 04 00 00       	cmp    $0x400,%eax
  802300:	75 e6                	jne    8022e8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802302:	b8 00 00 00 00       	mov    $0x0,%eax
  802307:	eb 0b                	jmp    802314 <ipc_find_env+0x37>
			return envs[i].env_id;
  802309:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80230c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802311:	8b 40 48             	mov    0x48(%eax),%eax
}
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    

00802316 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80231c:	89 d0                	mov    %edx,%eax
  80231e:	c1 e8 16             	shr    $0x16,%eax
  802321:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802328:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80232d:	f6 c1 01             	test   $0x1,%cl
  802330:	74 1d                	je     80234f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802332:	c1 ea 0c             	shr    $0xc,%edx
  802335:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80233c:	f6 c2 01             	test   $0x1,%dl
  80233f:	74 0e                	je     80234f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802341:	c1 ea 0c             	shr    $0xc,%edx
  802344:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80234b:	ef 
  80234c:	0f b7 c0             	movzwl %ax,%eax
}
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	66 90                	xchg   %ax,%ax
  802353:	66 90                	xchg   %ax,%ax
  802355:	66 90                	xchg   %ax,%ax
  802357:	66 90                	xchg   %ax,%ax
  802359:	66 90                	xchg   %ax,%ax
  80235b:	66 90                	xchg   %ax,%ax
  80235d:	66 90                	xchg   %ax,%ax
  80235f:	90                   	nop

00802360 <__udivdi3>:
  802360:	55                   	push   %ebp
  802361:	57                   	push   %edi
  802362:	56                   	push   %esi
  802363:	53                   	push   %ebx
  802364:	83 ec 1c             	sub    $0x1c,%esp
  802367:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80236b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80236f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802373:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802377:	85 d2                	test   %edx,%edx
  802379:	75 35                	jne    8023b0 <__udivdi3+0x50>
  80237b:	39 f3                	cmp    %esi,%ebx
  80237d:	0f 87 bd 00 00 00    	ja     802440 <__udivdi3+0xe0>
  802383:	85 db                	test   %ebx,%ebx
  802385:	89 d9                	mov    %ebx,%ecx
  802387:	75 0b                	jne    802394 <__udivdi3+0x34>
  802389:	b8 01 00 00 00       	mov    $0x1,%eax
  80238e:	31 d2                	xor    %edx,%edx
  802390:	f7 f3                	div    %ebx
  802392:	89 c1                	mov    %eax,%ecx
  802394:	31 d2                	xor    %edx,%edx
  802396:	89 f0                	mov    %esi,%eax
  802398:	f7 f1                	div    %ecx
  80239a:	89 c6                	mov    %eax,%esi
  80239c:	89 e8                	mov    %ebp,%eax
  80239e:	89 f7                	mov    %esi,%edi
  8023a0:	f7 f1                	div    %ecx
  8023a2:	89 fa                	mov    %edi,%edx
  8023a4:	83 c4 1c             	add    $0x1c,%esp
  8023a7:	5b                   	pop    %ebx
  8023a8:	5e                   	pop    %esi
  8023a9:	5f                   	pop    %edi
  8023aa:	5d                   	pop    %ebp
  8023ab:	c3                   	ret    
  8023ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023b0:	39 f2                	cmp    %esi,%edx
  8023b2:	77 7c                	ja     802430 <__udivdi3+0xd0>
  8023b4:	0f bd fa             	bsr    %edx,%edi
  8023b7:	83 f7 1f             	xor    $0x1f,%edi
  8023ba:	0f 84 98 00 00 00    	je     802458 <__udivdi3+0xf8>
  8023c0:	89 f9                	mov    %edi,%ecx
  8023c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023c7:	29 f8                	sub    %edi,%eax
  8023c9:	d3 e2                	shl    %cl,%edx
  8023cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023cf:	89 c1                	mov    %eax,%ecx
  8023d1:	89 da                	mov    %ebx,%edx
  8023d3:	d3 ea                	shr    %cl,%edx
  8023d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023d9:	09 d1                	or     %edx,%ecx
  8023db:	89 f2                	mov    %esi,%edx
  8023dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023e1:	89 f9                	mov    %edi,%ecx
  8023e3:	d3 e3                	shl    %cl,%ebx
  8023e5:	89 c1                	mov    %eax,%ecx
  8023e7:	d3 ea                	shr    %cl,%edx
  8023e9:	89 f9                	mov    %edi,%ecx
  8023eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023ef:	d3 e6                	shl    %cl,%esi
  8023f1:	89 eb                	mov    %ebp,%ebx
  8023f3:	89 c1                	mov    %eax,%ecx
  8023f5:	d3 eb                	shr    %cl,%ebx
  8023f7:	09 de                	or     %ebx,%esi
  8023f9:	89 f0                	mov    %esi,%eax
  8023fb:	f7 74 24 08          	divl   0x8(%esp)
  8023ff:	89 d6                	mov    %edx,%esi
  802401:	89 c3                	mov    %eax,%ebx
  802403:	f7 64 24 0c          	mull   0xc(%esp)
  802407:	39 d6                	cmp    %edx,%esi
  802409:	72 0c                	jb     802417 <__udivdi3+0xb7>
  80240b:	89 f9                	mov    %edi,%ecx
  80240d:	d3 e5                	shl    %cl,%ebp
  80240f:	39 c5                	cmp    %eax,%ebp
  802411:	73 5d                	jae    802470 <__udivdi3+0x110>
  802413:	39 d6                	cmp    %edx,%esi
  802415:	75 59                	jne    802470 <__udivdi3+0x110>
  802417:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80241a:	31 ff                	xor    %edi,%edi
  80241c:	89 fa                	mov    %edi,%edx
  80241e:	83 c4 1c             	add    $0x1c,%esp
  802421:	5b                   	pop    %ebx
  802422:	5e                   	pop    %esi
  802423:	5f                   	pop    %edi
  802424:	5d                   	pop    %ebp
  802425:	c3                   	ret    
  802426:	8d 76 00             	lea    0x0(%esi),%esi
  802429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802430:	31 ff                	xor    %edi,%edi
  802432:	31 c0                	xor    %eax,%eax
  802434:	89 fa                	mov    %edi,%edx
  802436:	83 c4 1c             	add    $0x1c,%esp
  802439:	5b                   	pop    %ebx
  80243a:	5e                   	pop    %esi
  80243b:	5f                   	pop    %edi
  80243c:	5d                   	pop    %ebp
  80243d:	c3                   	ret    
  80243e:	66 90                	xchg   %ax,%ax
  802440:	31 ff                	xor    %edi,%edi
  802442:	89 e8                	mov    %ebp,%eax
  802444:	89 f2                	mov    %esi,%edx
  802446:	f7 f3                	div    %ebx
  802448:	89 fa                	mov    %edi,%edx
  80244a:	83 c4 1c             	add    $0x1c,%esp
  80244d:	5b                   	pop    %ebx
  80244e:	5e                   	pop    %esi
  80244f:	5f                   	pop    %edi
  802450:	5d                   	pop    %ebp
  802451:	c3                   	ret    
  802452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802458:	39 f2                	cmp    %esi,%edx
  80245a:	72 06                	jb     802462 <__udivdi3+0x102>
  80245c:	31 c0                	xor    %eax,%eax
  80245e:	39 eb                	cmp    %ebp,%ebx
  802460:	77 d2                	ja     802434 <__udivdi3+0xd4>
  802462:	b8 01 00 00 00       	mov    $0x1,%eax
  802467:	eb cb                	jmp    802434 <__udivdi3+0xd4>
  802469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802470:	89 d8                	mov    %ebx,%eax
  802472:	31 ff                	xor    %edi,%edi
  802474:	eb be                	jmp    802434 <__udivdi3+0xd4>
  802476:	66 90                	xchg   %ax,%ax
  802478:	66 90                	xchg   %ax,%ax
  80247a:	66 90                	xchg   %ax,%ax
  80247c:	66 90                	xchg   %ax,%ax
  80247e:	66 90                	xchg   %ax,%ax

00802480 <__umoddi3>:
  802480:	55                   	push   %ebp
  802481:	57                   	push   %edi
  802482:	56                   	push   %esi
  802483:	53                   	push   %ebx
  802484:	83 ec 1c             	sub    $0x1c,%esp
  802487:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80248b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80248f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802493:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802497:	85 ed                	test   %ebp,%ebp
  802499:	89 f0                	mov    %esi,%eax
  80249b:	89 da                	mov    %ebx,%edx
  80249d:	75 19                	jne    8024b8 <__umoddi3+0x38>
  80249f:	39 df                	cmp    %ebx,%edi
  8024a1:	0f 86 b1 00 00 00    	jbe    802558 <__umoddi3+0xd8>
  8024a7:	f7 f7                	div    %edi
  8024a9:	89 d0                	mov    %edx,%eax
  8024ab:	31 d2                	xor    %edx,%edx
  8024ad:	83 c4 1c             	add    $0x1c,%esp
  8024b0:	5b                   	pop    %ebx
  8024b1:	5e                   	pop    %esi
  8024b2:	5f                   	pop    %edi
  8024b3:	5d                   	pop    %ebp
  8024b4:	c3                   	ret    
  8024b5:	8d 76 00             	lea    0x0(%esi),%esi
  8024b8:	39 dd                	cmp    %ebx,%ebp
  8024ba:	77 f1                	ja     8024ad <__umoddi3+0x2d>
  8024bc:	0f bd cd             	bsr    %ebp,%ecx
  8024bf:	83 f1 1f             	xor    $0x1f,%ecx
  8024c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024c6:	0f 84 b4 00 00 00    	je     802580 <__umoddi3+0x100>
  8024cc:	b8 20 00 00 00       	mov    $0x20,%eax
  8024d1:	89 c2                	mov    %eax,%edx
  8024d3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024d7:	29 c2                	sub    %eax,%edx
  8024d9:	89 c1                	mov    %eax,%ecx
  8024db:	89 f8                	mov    %edi,%eax
  8024dd:	d3 e5                	shl    %cl,%ebp
  8024df:	89 d1                	mov    %edx,%ecx
  8024e1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8024e5:	d3 e8                	shr    %cl,%eax
  8024e7:	09 c5                	or     %eax,%ebp
  8024e9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024ed:	89 c1                	mov    %eax,%ecx
  8024ef:	d3 e7                	shl    %cl,%edi
  8024f1:	89 d1                	mov    %edx,%ecx
  8024f3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024f7:	89 df                	mov    %ebx,%edi
  8024f9:	d3 ef                	shr    %cl,%edi
  8024fb:	89 c1                	mov    %eax,%ecx
  8024fd:	89 f0                	mov    %esi,%eax
  8024ff:	d3 e3                	shl    %cl,%ebx
  802501:	89 d1                	mov    %edx,%ecx
  802503:	89 fa                	mov    %edi,%edx
  802505:	d3 e8                	shr    %cl,%eax
  802507:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80250c:	09 d8                	or     %ebx,%eax
  80250e:	f7 f5                	div    %ebp
  802510:	d3 e6                	shl    %cl,%esi
  802512:	89 d1                	mov    %edx,%ecx
  802514:	f7 64 24 08          	mull   0x8(%esp)
  802518:	39 d1                	cmp    %edx,%ecx
  80251a:	89 c3                	mov    %eax,%ebx
  80251c:	89 d7                	mov    %edx,%edi
  80251e:	72 06                	jb     802526 <__umoddi3+0xa6>
  802520:	75 0e                	jne    802530 <__umoddi3+0xb0>
  802522:	39 c6                	cmp    %eax,%esi
  802524:	73 0a                	jae    802530 <__umoddi3+0xb0>
  802526:	2b 44 24 08          	sub    0x8(%esp),%eax
  80252a:	19 ea                	sbb    %ebp,%edx
  80252c:	89 d7                	mov    %edx,%edi
  80252e:	89 c3                	mov    %eax,%ebx
  802530:	89 ca                	mov    %ecx,%edx
  802532:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802537:	29 de                	sub    %ebx,%esi
  802539:	19 fa                	sbb    %edi,%edx
  80253b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80253f:	89 d0                	mov    %edx,%eax
  802541:	d3 e0                	shl    %cl,%eax
  802543:	89 d9                	mov    %ebx,%ecx
  802545:	d3 ee                	shr    %cl,%esi
  802547:	d3 ea                	shr    %cl,%edx
  802549:	09 f0                	or     %esi,%eax
  80254b:	83 c4 1c             	add    $0x1c,%esp
  80254e:	5b                   	pop    %ebx
  80254f:	5e                   	pop    %esi
  802550:	5f                   	pop    %edi
  802551:	5d                   	pop    %ebp
  802552:	c3                   	ret    
  802553:	90                   	nop
  802554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802558:	85 ff                	test   %edi,%edi
  80255a:	89 f9                	mov    %edi,%ecx
  80255c:	75 0b                	jne    802569 <__umoddi3+0xe9>
  80255e:	b8 01 00 00 00       	mov    $0x1,%eax
  802563:	31 d2                	xor    %edx,%edx
  802565:	f7 f7                	div    %edi
  802567:	89 c1                	mov    %eax,%ecx
  802569:	89 d8                	mov    %ebx,%eax
  80256b:	31 d2                	xor    %edx,%edx
  80256d:	f7 f1                	div    %ecx
  80256f:	89 f0                	mov    %esi,%eax
  802571:	f7 f1                	div    %ecx
  802573:	e9 31 ff ff ff       	jmp    8024a9 <__umoddi3+0x29>
  802578:	90                   	nop
  802579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802580:	39 dd                	cmp    %ebx,%ebp
  802582:	72 08                	jb     80258c <__umoddi3+0x10c>
  802584:	39 f7                	cmp    %esi,%edi
  802586:	0f 87 21 ff ff ff    	ja     8024ad <__umoddi3+0x2d>
  80258c:	89 da                	mov    %ebx,%edx
  80258e:	89 f0                	mov    %esi,%eax
  802590:	29 f8                	sub    %edi,%eax
  802592:	19 ea                	sbb    %ebp,%edx
  802594:	e9 14 ff ff ff       	jmp    8024ad <__umoddi3+0x2d>
