
obj/user/testkbd.debug：     文件格式 elf32-i386


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
  80002c:	e8 33 02 00 00       	call   800264 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 3c 0e 00 00       	call   800e80 <sys_yield>
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>

	close(0);
  800049:	83 ec 0c             	sub    $0xc,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	e8 e8 11 00 00       	call   80123b <close>
	if ((r = opencons()) < 0)
  800053:	e8 ba 01 00 00       	call   800212 <opencons>
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	85 c0                	test   %eax,%eax
  80005d:	78 16                	js     800075 <umain+0x42>
		panic("opencons: %e", r);
	if (r != 0)
  80005f:	85 c0                	test   %eax,%eax
  800061:	74 24                	je     800087 <umain+0x54>
		panic("first opencons used fd %d", r);
  800063:	50                   	push   %eax
  800064:	68 bc 20 80 00       	push   $0x8020bc
  800069:	6a 11                	push   $0x11
  80006b:	68 ad 20 80 00       	push   $0x8020ad
  800070:	e8 47 02 00 00       	call   8002bc <_panic>
		panic("opencons: %e", r);
  800075:	50                   	push   %eax
  800076:	68 a0 20 80 00       	push   $0x8020a0
  80007b:	6a 0f                	push   $0xf
  80007d:	68 ad 20 80 00       	push   $0x8020ad
  800082:	e8 35 02 00 00       	call   8002bc <_panic>
	if ((r = dup(0, 1)) < 0)
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	6a 01                	push   $0x1
  80008c:	6a 00                	push   $0x0
  80008e:	e8 f8 11 00 00       	call   80128b <dup>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	85 c0                	test   %eax,%eax
  800098:	79 24                	jns    8000be <umain+0x8b>
		panic("dup: %e", r);
  80009a:	50                   	push   %eax
  80009b:	68 d6 20 80 00       	push   $0x8020d6
  8000a0:	6a 13                	push   $0x13
  8000a2:	68 ad 20 80 00       	push   $0x8020ad
  8000a7:	e8 10 02 00 00       	call   8002bc <_panic>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	68 f0 20 80 00       	push   $0x8020f0
  8000b4:	6a 01                	push   $0x1
  8000b6:	e8 f7 18 00 00       	call   8019b2 <fprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 de 20 80 00       	push   $0x8020de
  8000c6:	e8 b4 08 00 00       	call   80097f <readline>
		if (buf != NULL)
  8000cb:	83 c4 10             	add    $0x10,%esp
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	74 da                	je     8000ac <umain+0x79>
			fprintf(1, "%s\n", buf);
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	50                   	push   %eax
  8000d6:	68 ec 20 80 00       	push   $0x8020ec
  8000db:	6a 01                	push   $0x1
  8000dd:	e8 d0 18 00 00       	call   8019b2 <fprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb d7                	jmp    8000be <umain+0x8b>

008000e7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	5d                   	pop    %ebp
  8000f0:	c3                   	ret    

008000f1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8000f7:	68 08 21 80 00       	push   $0x802108
  8000fc:	ff 75 0c             	pushl  0xc(%ebp)
  8000ff:	e8 a2 09 00 00       	call   800aa6 <strcpy>
	return 0;
}
  800104:	b8 00 00 00 00       	mov    $0x0,%eax
  800109:	c9                   	leave  
  80010a:	c3                   	ret    

0080010b <devcons_write>:
{
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	57                   	push   %edi
  80010f:	56                   	push   %esi
  800110:	53                   	push   %ebx
  800111:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800117:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80011c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800122:	eb 2f                	jmp    800153 <devcons_write+0x48>
		m = n - tot;
  800124:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800127:	29 f3                	sub    %esi,%ebx
  800129:	83 fb 7f             	cmp    $0x7f,%ebx
  80012c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800131:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	53                   	push   %ebx
  800138:	89 f0                	mov    %esi,%eax
  80013a:	03 45 0c             	add    0xc(%ebp),%eax
  80013d:	50                   	push   %eax
  80013e:	57                   	push   %edi
  80013f:	e8 f0 0a 00 00       	call   800c34 <memmove>
		sys_cputs(buf, m);
  800144:	83 c4 08             	add    $0x8,%esp
  800147:	53                   	push   %ebx
  800148:	57                   	push   %edi
  800149:	e8 95 0c 00 00       	call   800de3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80014e:	01 de                	add    %ebx,%esi
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	3b 75 10             	cmp    0x10(%ebp),%esi
  800156:	72 cc                	jb     800124 <devcons_write+0x19>
}
  800158:	89 f0                	mov    %esi,%eax
  80015a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80015d:	5b                   	pop    %ebx
  80015e:	5e                   	pop    %esi
  80015f:	5f                   	pop    %edi
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    

00800162 <devcons_read>:
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	83 ec 08             	sub    $0x8,%esp
  800168:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80016d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800171:	75 07                	jne    80017a <devcons_read+0x18>
}
  800173:	c9                   	leave  
  800174:	c3                   	ret    
		sys_yield();
  800175:	e8 06 0d 00 00       	call   800e80 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80017a:	e8 82 0c 00 00       	call   800e01 <sys_cgetc>
  80017f:	85 c0                	test   %eax,%eax
  800181:	74 f2                	je     800175 <devcons_read+0x13>
	if (c < 0)
  800183:	85 c0                	test   %eax,%eax
  800185:	78 ec                	js     800173 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  800187:	83 f8 04             	cmp    $0x4,%eax
  80018a:	74 0c                	je     800198 <devcons_read+0x36>
	*(char*)vbuf = c;
  80018c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018f:	88 02                	mov    %al,(%edx)
	return 1;
  800191:	b8 01 00 00 00       	mov    $0x1,%eax
  800196:	eb db                	jmp    800173 <devcons_read+0x11>
		return 0;
  800198:	b8 00 00 00 00       	mov    $0x0,%eax
  80019d:	eb d4                	jmp    800173 <devcons_read+0x11>

0080019f <cputchar>:
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8001a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8001ab:	6a 01                	push   $0x1
  8001ad:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 2d 0c 00 00       	call   800de3 <sys_cputs>
}
  8001b6:	83 c4 10             	add    $0x10,%esp
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <getchar>:
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8001c1:	6a 01                	push   $0x1
  8001c3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	6a 00                	push   $0x0
  8001c9:	e8 a9 11 00 00       	call   801377 <read>
	if (r < 0)
  8001ce:	83 c4 10             	add    $0x10,%esp
  8001d1:	85 c0                	test   %eax,%eax
  8001d3:	78 08                	js     8001dd <getchar+0x22>
	if (r < 1)
  8001d5:	85 c0                	test   %eax,%eax
  8001d7:	7e 06                	jle    8001df <getchar+0x24>
	return c;
  8001d9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8001dd:	c9                   	leave  
  8001de:	c3                   	ret    
		return -E_EOF;
  8001df:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8001e4:	eb f7                	jmp    8001dd <getchar+0x22>

008001e6 <iscons>:
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8001ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	ff 75 08             	pushl  0x8(%ebp)
  8001f3:	e8 0e 0f 00 00       	call   801106 <fd_lookup>
  8001f8:	83 c4 10             	add    $0x10,%esp
  8001fb:	85 c0                	test   %eax,%eax
  8001fd:	78 11                	js     800210 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8001ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800202:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800208:	39 10                	cmp    %edx,(%eax)
  80020a:	0f 94 c0             	sete   %al
  80020d:	0f b6 c0             	movzbl %al,%eax
}
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <opencons>:
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800218:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80021b:	50                   	push   %eax
  80021c:	e8 96 0e 00 00       	call   8010b7 <fd_alloc>
  800221:	83 c4 10             	add    $0x10,%esp
  800224:	85 c0                	test   %eax,%eax
  800226:	78 3a                	js     800262 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800228:	83 ec 04             	sub    $0x4,%esp
  80022b:	68 07 04 00 00       	push   $0x407
  800230:	ff 75 f4             	pushl  -0xc(%ebp)
  800233:	6a 00                	push   $0x0
  800235:	e8 65 0c 00 00       	call   800e9f <sys_page_alloc>
  80023a:	83 c4 10             	add    $0x10,%esp
  80023d:	85 c0                	test   %eax,%eax
  80023f:	78 21                	js     800262 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800244:	8b 15 00 30 80 00    	mov    0x803000,%edx
  80024a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80024c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80024f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	e8 31 0e 00 00       	call   801090 <fd2num>
  80025f:	83 c4 10             	add    $0x10,%esp
}
  800262:	c9                   	leave  
  800263:	c3                   	ret    

00800264 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	56                   	push   %esi
  800268:	53                   	push   %ebx
  800269:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80026c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  80026f:	e8 ed 0b 00 00       	call   800e61 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  800274:	25 ff 03 00 00       	and    $0x3ff,%eax
  800279:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80027c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800281:	a3 04 44 80 00       	mov    %eax,0x804404

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800286:	85 db                	test   %ebx,%ebx
  800288:	7e 07                	jle    800291 <libmain+0x2d>
		binaryname = argv[0];
  80028a:	8b 06                	mov    (%esi),%eax
  80028c:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	e8 98 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80029b:	e8 0a 00 00 00       	call   8002aa <exit>
}
  8002a0:	83 c4 10             	add    $0x10,%esp
  8002a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002a6:	5b                   	pop    %ebx
  8002a7:	5e                   	pop    %esi
  8002a8:	5d                   	pop    %ebp
  8002a9:	c3                   	ret    

008002aa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8002b0:	6a 00                	push   $0x0
  8002b2:	e8 69 0b 00 00       	call   800e20 <sys_env_destroy>
}
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	56                   	push   %esi
  8002c0:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002c1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002c4:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  8002ca:	e8 92 0b 00 00       	call   800e61 <sys_getenvid>
  8002cf:	83 ec 0c             	sub    $0xc,%esp
  8002d2:	ff 75 0c             	pushl  0xc(%ebp)
  8002d5:	ff 75 08             	pushl  0x8(%ebp)
  8002d8:	56                   	push   %esi
  8002d9:	50                   	push   %eax
  8002da:	68 20 21 80 00       	push   $0x802120
  8002df:	e8 b3 00 00 00       	call   800397 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002e4:	83 c4 18             	add    $0x18,%esp
  8002e7:	53                   	push   %ebx
  8002e8:	ff 75 10             	pushl  0x10(%ebp)
  8002eb:	e8 56 00 00 00       	call   800346 <vcprintf>
	cprintf("\n");
  8002f0:	c7 04 24 06 21 80 00 	movl   $0x802106,(%esp)
  8002f7:	e8 9b 00 00 00       	call   800397 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ff:	cc                   	int3   
  800300:	eb fd                	jmp    8002ff <_panic+0x43>

00800302 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	53                   	push   %ebx
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80030c:	8b 13                	mov    (%ebx),%edx
  80030e:	8d 42 01             	lea    0x1(%edx),%eax
  800311:	89 03                	mov    %eax,(%ebx)
  800313:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800316:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80031a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80031f:	74 09                	je     80032a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800321:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800328:	c9                   	leave  
  800329:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80032a:	83 ec 08             	sub    $0x8,%esp
  80032d:	68 ff 00 00 00       	push   $0xff
  800332:	8d 43 08             	lea    0x8(%ebx),%eax
  800335:	50                   	push   %eax
  800336:	e8 a8 0a 00 00       	call   800de3 <sys_cputs>
		b->idx = 0;
  80033b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	eb db                	jmp    800321 <putch+0x1f>

00800346 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80034f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800356:	00 00 00 
	b.cnt = 0;
  800359:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800360:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800363:	ff 75 0c             	pushl  0xc(%ebp)
  800366:	ff 75 08             	pushl  0x8(%ebp)
  800369:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80036f:	50                   	push   %eax
  800370:	68 02 03 80 00       	push   $0x800302
  800375:	e8 1a 01 00 00       	call   800494 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80037a:	83 c4 08             	add    $0x8,%esp
  80037d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800383:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800389:	50                   	push   %eax
  80038a:	e8 54 0a 00 00       	call   800de3 <sys_cputs>

	return b.cnt;
}
  80038f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800395:	c9                   	leave  
  800396:	c3                   	ret    

00800397 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80039d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003a0:	50                   	push   %eax
  8003a1:	ff 75 08             	pushl  0x8(%ebp)
  8003a4:	e8 9d ff ff ff       	call   800346 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003a9:	c9                   	leave  
  8003aa:	c3                   	ret    

008003ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ab:	55                   	push   %ebp
  8003ac:	89 e5                	mov    %esp,%ebp
  8003ae:	57                   	push   %edi
  8003af:	56                   	push   %esi
  8003b0:	53                   	push   %ebx
  8003b1:	83 ec 1c             	sub    $0x1c,%esp
  8003b4:	89 c7                	mov    %eax,%edi
  8003b6:	89 d6                	mov    %edx,%esi
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003cc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003cf:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8003d2:	39 d3                	cmp    %edx,%ebx
  8003d4:	72 05                	jb     8003db <printnum+0x30>
  8003d6:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003d9:	77 7a                	ja     800455 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003db:	83 ec 0c             	sub    $0xc,%esp
  8003de:	ff 75 18             	pushl  0x18(%ebp)
  8003e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003e7:	53                   	push   %ebx
  8003e8:	ff 75 10             	pushl  0x10(%ebp)
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f1:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f4:	ff 75 dc             	pushl  -0x24(%ebp)
  8003f7:	ff 75 d8             	pushl  -0x28(%ebp)
  8003fa:	e8 61 1a 00 00       	call   801e60 <__udivdi3>
  8003ff:	83 c4 18             	add    $0x18,%esp
  800402:	52                   	push   %edx
  800403:	50                   	push   %eax
  800404:	89 f2                	mov    %esi,%edx
  800406:	89 f8                	mov    %edi,%eax
  800408:	e8 9e ff ff ff       	call   8003ab <printnum>
  80040d:	83 c4 20             	add    $0x20,%esp
  800410:	eb 13                	jmp    800425 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800412:	83 ec 08             	sub    $0x8,%esp
  800415:	56                   	push   %esi
  800416:	ff 75 18             	pushl  0x18(%ebp)
  800419:	ff d7                	call   *%edi
  80041b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80041e:	83 eb 01             	sub    $0x1,%ebx
  800421:	85 db                	test   %ebx,%ebx
  800423:	7f ed                	jg     800412 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	56                   	push   %esi
  800429:	83 ec 04             	sub    $0x4,%esp
  80042c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80042f:	ff 75 e0             	pushl  -0x20(%ebp)
  800432:	ff 75 dc             	pushl  -0x24(%ebp)
  800435:	ff 75 d8             	pushl  -0x28(%ebp)
  800438:	e8 43 1b 00 00       	call   801f80 <__umoddi3>
  80043d:	83 c4 14             	add    $0x14,%esp
  800440:	0f be 80 43 21 80 00 	movsbl 0x802143(%eax),%eax
  800447:	50                   	push   %eax
  800448:	ff d7                	call   *%edi
}
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800450:	5b                   	pop    %ebx
  800451:	5e                   	pop    %esi
  800452:	5f                   	pop    %edi
  800453:	5d                   	pop    %ebp
  800454:	c3                   	ret    
  800455:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800458:	eb c4                	jmp    80041e <printnum+0x73>

0080045a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800460:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800464:	8b 10                	mov    (%eax),%edx
  800466:	3b 50 04             	cmp    0x4(%eax),%edx
  800469:	73 0a                	jae    800475 <sprintputch+0x1b>
		*b->buf++ = ch;
  80046b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80046e:	89 08                	mov    %ecx,(%eax)
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	88 02                	mov    %al,(%edx)
}
  800475:	5d                   	pop    %ebp
  800476:	c3                   	ret    

00800477 <printfmt>:
{
  800477:	55                   	push   %ebp
  800478:	89 e5                	mov    %esp,%ebp
  80047a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80047d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800480:	50                   	push   %eax
  800481:	ff 75 10             	pushl  0x10(%ebp)
  800484:	ff 75 0c             	pushl  0xc(%ebp)
  800487:	ff 75 08             	pushl  0x8(%ebp)
  80048a:	e8 05 00 00 00       	call   800494 <vprintfmt>
}
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	c9                   	leave  
  800493:	c3                   	ret    

00800494 <vprintfmt>:
{
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	57                   	push   %edi
  800498:	56                   	push   %esi
  800499:	53                   	push   %ebx
  80049a:	83 ec 2c             	sub    $0x2c,%esp
  80049d:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004a6:	e9 c1 03 00 00       	jmp    80086c <vprintfmt+0x3d8>
		padc = ' ';
  8004ab:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8004af:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8004b6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8004bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004c4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004c9:	8d 47 01             	lea    0x1(%edi),%eax
  8004cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004cf:	0f b6 17             	movzbl (%edi),%edx
  8004d2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004d5:	3c 55                	cmp    $0x55,%al
  8004d7:	0f 87 12 04 00 00    	ja     8008ef <vprintfmt+0x45b>
  8004dd:	0f b6 c0             	movzbl %al,%eax
  8004e0:	ff 24 85 80 22 80 00 	jmp    *0x802280(,%eax,4)
  8004e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004ea:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8004ee:	eb d9                	jmp    8004c9 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004f3:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004f7:	eb d0                	jmp    8004c9 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004f9:	0f b6 d2             	movzbl %dl,%edx
  8004fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800504:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800507:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80050a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80050e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800511:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800514:	83 f9 09             	cmp    $0x9,%ecx
  800517:	77 55                	ja     80056e <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800519:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80051c:	eb e9                	jmp    800507 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	8b 00                	mov    (%eax),%eax
  800523:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800526:	8b 45 14             	mov    0x14(%ebp),%eax
  800529:	8d 40 04             	lea    0x4(%eax),%eax
  80052c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80052f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800532:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800536:	79 91                	jns    8004c9 <vprintfmt+0x35>
				width = precision, precision = -1;
  800538:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80053b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800545:	eb 82                	jmp    8004c9 <vprintfmt+0x35>
  800547:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054a:	85 c0                	test   %eax,%eax
  80054c:	ba 00 00 00 00       	mov    $0x0,%edx
  800551:	0f 49 d0             	cmovns %eax,%edx
  800554:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800557:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80055a:	e9 6a ff ff ff       	jmp    8004c9 <vprintfmt+0x35>
  80055f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800562:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800569:	e9 5b ff ff ff       	jmp    8004c9 <vprintfmt+0x35>
  80056e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800571:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800574:	eb bc                	jmp    800532 <vprintfmt+0x9e>
			lflag++;
  800576:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800579:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80057c:	e9 48 ff ff ff       	jmp    8004c9 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8d 78 04             	lea    0x4(%eax),%edi
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	53                   	push   %ebx
  80058b:	ff 30                	pushl  (%eax)
  80058d:	ff d6                	call   *%esi
			break;
  80058f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800592:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800595:	e9 cf 02 00 00       	jmp    800869 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8d 78 04             	lea    0x4(%eax),%edi
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	99                   	cltd   
  8005a3:	31 d0                	xor    %edx,%eax
  8005a5:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005a7:	83 f8 0f             	cmp    $0xf,%eax
  8005aa:	7f 23                	jg     8005cf <vprintfmt+0x13b>
  8005ac:	8b 14 85 e0 23 80 00 	mov    0x8023e0(,%eax,4),%edx
  8005b3:	85 d2                	test   %edx,%edx
  8005b5:	74 18                	je     8005cf <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8005b7:	52                   	push   %edx
  8005b8:	68 25 25 80 00       	push   $0x802525
  8005bd:	53                   	push   %ebx
  8005be:	56                   	push   %esi
  8005bf:	e8 b3 fe ff ff       	call   800477 <printfmt>
  8005c4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005c7:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005ca:	e9 9a 02 00 00       	jmp    800869 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8005cf:	50                   	push   %eax
  8005d0:	68 5b 21 80 00       	push   $0x80215b
  8005d5:	53                   	push   %ebx
  8005d6:	56                   	push   %esi
  8005d7:	e8 9b fe ff ff       	call   800477 <printfmt>
  8005dc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005df:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005e2:	e9 82 02 00 00       	jmp    800869 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	83 c0 04             	add    $0x4,%eax
  8005ed:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005f5:	85 ff                	test   %edi,%edi
  8005f7:	b8 54 21 80 00       	mov    $0x802154,%eax
  8005fc:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8005ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800603:	0f 8e bd 00 00 00    	jle    8006c6 <vprintfmt+0x232>
  800609:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80060d:	75 0e                	jne    80061d <vprintfmt+0x189>
  80060f:	89 75 08             	mov    %esi,0x8(%ebp)
  800612:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800615:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800618:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80061b:	eb 6d                	jmp    80068a <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80061d:	83 ec 08             	sub    $0x8,%esp
  800620:	ff 75 d0             	pushl  -0x30(%ebp)
  800623:	57                   	push   %edi
  800624:	e8 5e 04 00 00       	call   800a87 <strnlen>
  800629:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80062c:	29 c1                	sub    %eax,%ecx
  80062e:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800631:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800634:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800638:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80063b:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80063e:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800640:	eb 0f                	jmp    800651 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	53                   	push   %ebx
  800646:	ff 75 e0             	pushl  -0x20(%ebp)
  800649:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80064b:	83 ef 01             	sub    $0x1,%edi
  80064e:	83 c4 10             	add    $0x10,%esp
  800651:	85 ff                	test   %edi,%edi
  800653:	7f ed                	jg     800642 <vprintfmt+0x1ae>
  800655:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800658:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80065b:	85 c9                	test   %ecx,%ecx
  80065d:	b8 00 00 00 00       	mov    $0x0,%eax
  800662:	0f 49 c1             	cmovns %ecx,%eax
  800665:	29 c1                	sub    %eax,%ecx
  800667:	89 75 08             	mov    %esi,0x8(%ebp)
  80066a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80066d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800670:	89 cb                	mov    %ecx,%ebx
  800672:	eb 16                	jmp    80068a <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800674:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800678:	75 31                	jne    8006ab <vprintfmt+0x217>
					putch(ch, putdat);
  80067a:	83 ec 08             	sub    $0x8,%esp
  80067d:	ff 75 0c             	pushl  0xc(%ebp)
  800680:	50                   	push   %eax
  800681:	ff 55 08             	call   *0x8(%ebp)
  800684:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800687:	83 eb 01             	sub    $0x1,%ebx
  80068a:	83 c7 01             	add    $0x1,%edi
  80068d:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800691:	0f be c2             	movsbl %dl,%eax
  800694:	85 c0                	test   %eax,%eax
  800696:	74 59                	je     8006f1 <vprintfmt+0x25d>
  800698:	85 f6                	test   %esi,%esi
  80069a:	78 d8                	js     800674 <vprintfmt+0x1e0>
  80069c:	83 ee 01             	sub    $0x1,%esi
  80069f:	79 d3                	jns    800674 <vprintfmt+0x1e0>
  8006a1:	89 df                	mov    %ebx,%edi
  8006a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8006a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006a9:	eb 37                	jmp    8006e2 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006ab:	0f be d2             	movsbl %dl,%edx
  8006ae:	83 ea 20             	sub    $0x20,%edx
  8006b1:	83 fa 5e             	cmp    $0x5e,%edx
  8006b4:	76 c4                	jbe    80067a <vprintfmt+0x1e6>
					putch('?', putdat);
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	ff 75 0c             	pushl  0xc(%ebp)
  8006bc:	6a 3f                	push   $0x3f
  8006be:	ff 55 08             	call   *0x8(%ebp)
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	eb c1                	jmp    800687 <vprintfmt+0x1f3>
  8006c6:	89 75 08             	mov    %esi,0x8(%ebp)
  8006c9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006cc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006cf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006d2:	eb b6                	jmp    80068a <vprintfmt+0x1f6>
				putch(' ', putdat);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	53                   	push   %ebx
  8006d8:	6a 20                	push   $0x20
  8006da:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006dc:	83 ef 01             	sub    $0x1,%edi
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	85 ff                	test   %edi,%edi
  8006e4:	7f ee                	jg     8006d4 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8006e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ec:	e9 78 01 00 00       	jmp    800869 <vprintfmt+0x3d5>
  8006f1:	89 df                	mov    %ebx,%edi
  8006f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8006f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006f9:	eb e7                	jmp    8006e2 <vprintfmt+0x24e>
	if (lflag >= 2)
  8006fb:	83 f9 01             	cmp    $0x1,%ecx
  8006fe:	7e 3f                	jle    80073f <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8b 50 04             	mov    0x4(%eax),%edx
  800706:	8b 00                	mov    (%eax),%eax
  800708:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8d 40 08             	lea    0x8(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800717:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80071b:	79 5c                	jns    800779 <vprintfmt+0x2e5>
				putch('-', putdat);
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	53                   	push   %ebx
  800721:	6a 2d                	push   $0x2d
  800723:	ff d6                	call   *%esi
				num = -(long long) num;
  800725:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800728:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80072b:	f7 da                	neg    %edx
  80072d:	83 d1 00             	adc    $0x0,%ecx
  800730:	f7 d9                	neg    %ecx
  800732:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800735:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073a:	e9 10 01 00 00       	jmp    80084f <vprintfmt+0x3bb>
	else if (lflag)
  80073f:	85 c9                	test   %ecx,%ecx
  800741:	75 1b                	jne    80075e <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074b:	89 c1                	mov    %eax,%ecx
  80074d:	c1 f9 1f             	sar    $0x1f,%ecx
  800750:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8d 40 04             	lea    0x4(%eax),%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
  80075c:	eb b9                	jmp    800717 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800766:	89 c1                	mov    %eax,%ecx
  800768:	c1 f9 1f             	sar    $0x1f,%ecx
  80076b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8d 40 04             	lea    0x4(%eax),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
  800777:	eb 9e                	jmp    800717 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800779:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80077c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80077f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800784:	e9 c6 00 00 00       	jmp    80084f <vprintfmt+0x3bb>
	if (lflag >= 2)
  800789:	83 f9 01             	cmp    $0x1,%ecx
  80078c:	7e 18                	jle    8007a6 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8b 10                	mov    (%eax),%edx
  800793:	8b 48 04             	mov    0x4(%eax),%ecx
  800796:	8d 40 08             	lea    0x8(%eax),%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80079c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a1:	e9 a9 00 00 00       	jmp    80084f <vprintfmt+0x3bb>
	else if (lflag)
  8007a6:	85 c9                	test   %ecx,%ecx
  8007a8:	75 1a                	jne    8007c4 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8b 10                	mov    (%eax),%edx
  8007af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b4:	8d 40 04             	lea    0x4(%eax),%eax
  8007b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007bf:	e9 8b 00 00 00       	jmp    80084f <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8b 10                	mov    (%eax),%edx
  8007c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ce:	8d 40 04             	lea    0x4(%eax),%eax
  8007d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007d4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d9:	eb 74                	jmp    80084f <vprintfmt+0x3bb>
	if (lflag >= 2)
  8007db:	83 f9 01             	cmp    $0x1,%ecx
  8007de:	7e 15                	jle    8007f5 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8b 10                	mov    (%eax),%edx
  8007e5:	8b 48 04             	mov    0x4(%eax),%ecx
  8007e8:	8d 40 08             	lea    0x8(%eax),%eax
  8007eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8007f3:	eb 5a                	jmp    80084f <vprintfmt+0x3bb>
	else if (lflag)
  8007f5:	85 c9                	test   %ecx,%ecx
  8007f7:	75 17                	jne    800810 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8b 10                	mov    (%eax),%edx
  8007fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800803:	8d 40 04             	lea    0x4(%eax),%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800809:	b8 08 00 00 00       	mov    $0x8,%eax
  80080e:	eb 3f                	jmp    80084f <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	8b 10                	mov    (%eax),%edx
  800815:	b9 00 00 00 00       	mov    $0x0,%ecx
  80081a:	8d 40 04             	lea    0x4(%eax),%eax
  80081d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800820:	b8 08 00 00 00       	mov    $0x8,%eax
  800825:	eb 28                	jmp    80084f <vprintfmt+0x3bb>
			putch('0', putdat);
  800827:	83 ec 08             	sub    $0x8,%esp
  80082a:	53                   	push   %ebx
  80082b:	6a 30                	push   $0x30
  80082d:	ff d6                	call   *%esi
			putch('x', putdat);
  80082f:	83 c4 08             	add    $0x8,%esp
  800832:	53                   	push   %ebx
  800833:	6a 78                	push   $0x78
  800835:	ff d6                	call   *%esi
			num = (unsigned long long)
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	8b 10                	mov    (%eax),%edx
  80083c:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800841:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800844:	8d 40 04             	lea    0x4(%eax),%eax
  800847:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80084f:	83 ec 0c             	sub    $0xc,%esp
  800852:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800856:	57                   	push   %edi
  800857:	ff 75 e0             	pushl  -0x20(%ebp)
  80085a:	50                   	push   %eax
  80085b:	51                   	push   %ecx
  80085c:	52                   	push   %edx
  80085d:	89 da                	mov    %ebx,%edx
  80085f:	89 f0                	mov    %esi,%eax
  800861:	e8 45 fb ff ff       	call   8003ab <printnum>
			break;
  800866:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800869:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  80086c:	83 c7 01             	add    $0x1,%edi
  80086f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800873:	83 f8 25             	cmp    $0x25,%eax
  800876:	0f 84 2f fc ff ff    	je     8004ab <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  80087c:	85 c0                	test   %eax,%eax
  80087e:	0f 84 8b 00 00 00    	je     80090f <vprintfmt+0x47b>
			putch(ch, putdat);
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	53                   	push   %ebx
  800888:	50                   	push   %eax
  800889:	ff d6                	call   *%esi
  80088b:	83 c4 10             	add    $0x10,%esp
  80088e:	eb dc                	jmp    80086c <vprintfmt+0x3d8>
	if (lflag >= 2)
  800890:	83 f9 01             	cmp    $0x1,%ecx
  800893:	7e 15                	jle    8008aa <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8b 10                	mov    (%eax),%edx
  80089a:	8b 48 04             	mov    0x4(%eax),%ecx
  80089d:	8d 40 08             	lea    0x8(%eax),%eax
  8008a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a3:	b8 10 00 00 00       	mov    $0x10,%eax
  8008a8:	eb a5                	jmp    80084f <vprintfmt+0x3bb>
	else if (lflag)
  8008aa:	85 c9                	test   %ecx,%ecx
  8008ac:	75 17                	jne    8008c5 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8008ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b1:	8b 10                	mov    (%eax),%edx
  8008b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008b8:	8d 40 04             	lea    0x4(%eax),%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008be:	b8 10 00 00 00       	mov    $0x10,%eax
  8008c3:	eb 8a                	jmp    80084f <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	8b 10                	mov    (%eax),%edx
  8008ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008cf:	8d 40 04             	lea    0x4(%eax),%eax
  8008d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d5:	b8 10 00 00 00       	mov    $0x10,%eax
  8008da:	e9 70 ff ff ff       	jmp    80084f <vprintfmt+0x3bb>
			putch(ch, putdat);
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	53                   	push   %ebx
  8008e3:	6a 25                	push   $0x25
  8008e5:	ff d6                	call   *%esi
			break;
  8008e7:	83 c4 10             	add    $0x10,%esp
  8008ea:	e9 7a ff ff ff       	jmp    800869 <vprintfmt+0x3d5>
			putch('%', putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	53                   	push   %ebx
  8008f3:	6a 25                	push   $0x25
  8008f5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008f7:	83 c4 10             	add    $0x10,%esp
  8008fa:	89 f8                	mov    %edi,%eax
  8008fc:	eb 03                	jmp    800901 <vprintfmt+0x46d>
  8008fe:	83 e8 01             	sub    $0x1,%eax
  800901:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800905:	75 f7                	jne    8008fe <vprintfmt+0x46a>
  800907:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80090a:	e9 5a ff ff ff       	jmp    800869 <vprintfmt+0x3d5>
}
  80090f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800912:	5b                   	pop    %ebx
  800913:	5e                   	pop    %esi
  800914:	5f                   	pop    %edi
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	83 ec 18             	sub    $0x18,%esp
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800923:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800926:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80092a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80092d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800934:	85 c0                	test   %eax,%eax
  800936:	74 26                	je     80095e <vsnprintf+0x47>
  800938:	85 d2                	test   %edx,%edx
  80093a:	7e 22                	jle    80095e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80093c:	ff 75 14             	pushl  0x14(%ebp)
  80093f:	ff 75 10             	pushl  0x10(%ebp)
  800942:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800945:	50                   	push   %eax
  800946:	68 5a 04 80 00       	push   $0x80045a
  80094b:	e8 44 fb ff ff       	call   800494 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800953:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800959:	83 c4 10             	add    $0x10,%esp
}
  80095c:	c9                   	leave  
  80095d:	c3                   	ret    
		return -E_INVAL;
  80095e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800963:	eb f7                	jmp    80095c <vsnprintf+0x45>

00800965 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80096b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80096e:	50                   	push   %eax
  80096f:	ff 75 10             	pushl  0x10(%ebp)
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	ff 75 08             	pushl  0x8(%ebp)
  800978:	e8 9a ff ff ff       	call   800917 <vsnprintf>
	va_end(ap);

	return rc;
}
  80097d:	c9                   	leave  
  80097e:	c3                   	ret    

0080097f <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	57                   	push   %edi
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	83 ec 0c             	sub    $0xc,%esp
  800988:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80098b:	85 c0                	test   %eax,%eax
  80098d:	74 13                	je     8009a2 <readline+0x23>
		fprintf(1, "%s", prompt);
  80098f:	83 ec 04             	sub    $0x4,%esp
  800992:	50                   	push   %eax
  800993:	68 25 25 80 00       	push   $0x802525
  800998:	6a 01                	push   $0x1
  80099a:	e8 13 10 00 00       	call   8019b2 <fprintf>
  80099f:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  8009a2:	83 ec 0c             	sub    $0xc,%esp
  8009a5:	6a 00                	push   $0x0
  8009a7:	e8 3a f8 ff ff       	call   8001e6 <iscons>
  8009ac:	89 c7                	mov    %eax,%edi
  8009ae:	83 c4 10             	add    $0x10,%esp
	i = 0;
  8009b1:	be 00 00 00 00       	mov    $0x0,%esi
  8009b6:	eb 4b                	jmp    800a03 <readline+0x84>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  8009b8:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  8009bd:	83 fb f8             	cmp    $0xfffffff8,%ebx
  8009c0:	75 08                	jne    8009ca <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  8009c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009c5:	5b                   	pop    %ebx
  8009c6:	5e                   	pop    %esi
  8009c7:	5f                   	pop    %edi
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    
				cprintf("read error: %e\n", c);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	53                   	push   %ebx
  8009ce:	68 3f 24 80 00       	push   $0x80243f
  8009d3:	e8 bf f9 ff ff       	call   800397 <cprintf>
  8009d8:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8009db:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e0:	eb e0                	jmp    8009c2 <readline+0x43>
			if (echoing)
  8009e2:	85 ff                	test   %edi,%edi
  8009e4:	75 05                	jne    8009eb <readline+0x6c>
			i--;
  8009e6:	83 ee 01             	sub    $0x1,%esi
  8009e9:	eb 18                	jmp    800a03 <readline+0x84>
				cputchar('\b');
  8009eb:	83 ec 0c             	sub    $0xc,%esp
  8009ee:	6a 08                	push   $0x8
  8009f0:	e8 aa f7 ff ff       	call   80019f <cputchar>
  8009f5:	83 c4 10             	add    $0x10,%esp
  8009f8:	eb ec                	jmp    8009e6 <readline+0x67>
			buf[i++] = c;
  8009fa:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800a00:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  800a03:	e8 b3 f7 ff ff       	call   8001bb <getchar>
  800a08:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800a0a:	85 c0                	test   %eax,%eax
  800a0c:	78 aa                	js     8009b8 <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800a0e:	83 f8 08             	cmp    $0x8,%eax
  800a11:	0f 94 c2             	sete   %dl
  800a14:	83 f8 7f             	cmp    $0x7f,%eax
  800a17:	0f 94 c0             	sete   %al
  800a1a:	08 c2                	or     %al,%dl
  800a1c:	74 04                	je     800a22 <readline+0xa3>
  800a1e:	85 f6                	test   %esi,%esi
  800a20:	7f c0                	jg     8009e2 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a22:	83 fb 1f             	cmp    $0x1f,%ebx
  800a25:	7e 1a                	jle    800a41 <readline+0xc2>
  800a27:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800a2d:	7f 12                	jg     800a41 <readline+0xc2>
			if (echoing)
  800a2f:	85 ff                	test   %edi,%edi
  800a31:	74 c7                	je     8009fa <readline+0x7b>
				cputchar(c);
  800a33:	83 ec 0c             	sub    $0xc,%esp
  800a36:	53                   	push   %ebx
  800a37:	e8 63 f7 ff ff       	call   80019f <cputchar>
  800a3c:	83 c4 10             	add    $0x10,%esp
  800a3f:	eb b9                	jmp    8009fa <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  800a41:	83 fb 0a             	cmp    $0xa,%ebx
  800a44:	74 05                	je     800a4b <readline+0xcc>
  800a46:	83 fb 0d             	cmp    $0xd,%ebx
  800a49:	75 b8                	jne    800a03 <readline+0x84>
			if (echoing)
  800a4b:	85 ff                	test   %edi,%edi
  800a4d:	75 11                	jne    800a60 <readline+0xe1>
			buf[i] = 0;
  800a4f:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800a56:	b8 00 40 80 00       	mov    $0x804000,%eax
  800a5b:	e9 62 ff ff ff       	jmp    8009c2 <readline+0x43>
				cputchar('\n');
  800a60:	83 ec 0c             	sub    $0xc,%esp
  800a63:	6a 0a                	push   $0xa
  800a65:	e8 35 f7 ff ff       	call   80019f <cputchar>
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	eb e0                	jmp    800a4f <readline+0xd0>

00800a6f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a75:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7a:	eb 03                	jmp    800a7f <strlen+0x10>
		n++;
  800a7c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a7f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a83:	75 f7                	jne    800a7c <strlen+0xd>
	return n;
}
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    

00800a87 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a90:	b8 00 00 00 00       	mov    $0x0,%eax
  800a95:	eb 03                	jmp    800a9a <strnlen+0x13>
		n++;
  800a97:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a9a:	39 d0                	cmp    %edx,%eax
  800a9c:	74 06                	je     800aa4 <strnlen+0x1d>
  800a9e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800aa2:	75 f3                	jne    800a97 <strnlen+0x10>
	return n;
}
  800aa4:	5d                   	pop    %ebp
  800aa5:	c3                   	ret    

00800aa6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	53                   	push   %ebx
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ab0:	89 c2                	mov    %eax,%edx
  800ab2:	83 c1 01             	add    $0x1,%ecx
  800ab5:	83 c2 01             	add    $0x1,%edx
  800ab8:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800abc:	88 5a ff             	mov    %bl,-0x1(%edx)
  800abf:	84 db                	test   %bl,%bl
  800ac1:	75 ef                	jne    800ab2 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ac3:	5b                   	pop    %ebx
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	53                   	push   %ebx
  800aca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800acd:	53                   	push   %ebx
  800ace:	e8 9c ff ff ff       	call   800a6f <strlen>
  800ad3:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	01 d8                	add    %ebx,%eax
  800adb:	50                   	push   %eax
  800adc:	e8 c5 ff ff ff       	call   800aa6 <strcpy>
	return dst;
}
  800ae1:	89 d8                	mov    %ebx,%eax
  800ae3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae6:	c9                   	leave  
  800ae7:	c3                   	ret    

00800ae8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	56                   	push   %esi
  800aec:	53                   	push   %ebx
  800aed:	8b 75 08             	mov    0x8(%ebp),%esi
  800af0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af3:	89 f3                	mov    %esi,%ebx
  800af5:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800af8:	89 f2                	mov    %esi,%edx
  800afa:	eb 0f                	jmp    800b0b <strncpy+0x23>
		*dst++ = *src;
  800afc:	83 c2 01             	add    $0x1,%edx
  800aff:	0f b6 01             	movzbl (%ecx),%eax
  800b02:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b05:	80 39 01             	cmpb   $0x1,(%ecx)
  800b08:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800b0b:	39 da                	cmp    %ebx,%edx
  800b0d:	75 ed                	jne    800afc <strncpy+0x14>
	}
	return ret;
}
  800b0f:	89 f0                	mov    %esi,%eax
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	56                   	push   %esi
  800b19:	53                   	push   %ebx
  800b1a:	8b 75 08             	mov    0x8(%ebp),%esi
  800b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b20:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b23:	89 f0                	mov    %esi,%eax
  800b25:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b29:	85 c9                	test   %ecx,%ecx
  800b2b:	75 0b                	jne    800b38 <strlcpy+0x23>
  800b2d:	eb 17                	jmp    800b46 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b2f:	83 c2 01             	add    $0x1,%edx
  800b32:	83 c0 01             	add    $0x1,%eax
  800b35:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800b38:	39 d8                	cmp    %ebx,%eax
  800b3a:	74 07                	je     800b43 <strlcpy+0x2e>
  800b3c:	0f b6 0a             	movzbl (%edx),%ecx
  800b3f:	84 c9                	test   %cl,%cl
  800b41:	75 ec                	jne    800b2f <strlcpy+0x1a>
		*dst = '\0';
  800b43:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b46:	29 f0                	sub    %esi,%eax
}
  800b48:	5b                   	pop    %ebx
  800b49:	5e                   	pop    %esi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b52:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b55:	eb 06                	jmp    800b5d <strcmp+0x11>
		p++, q++;
  800b57:	83 c1 01             	add    $0x1,%ecx
  800b5a:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b5d:	0f b6 01             	movzbl (%ecx),%eax
  800b60:	84 c0                	test   %al,%al
  800b62:	74 04                	je     800b68 <strcmp+0x1c>
  800b64:	3a 02                	cmp    (%edx),%al
  800b66:	74 ef                	je     800b57 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b68:	0f b6 c0             	movzbl %al,%eax
  800b6b:	0f b6 12             	movzbl (%edx),%edx
  800b6e:	29 d0                	sub    %edx,%eax
}
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7c:	89 c3                	mov    %eax,%ebx
  800b7e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b81:	eb 06                	jmp    800b89 <strncmp+0x17>
		n--, p++, q++;
  800b83:	83 c0 01             	add    $0x1,%eax
  800b86:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b89:	39 d8                	cmp    %ebx,%eax
  800b8b:	74 16                	je     800ba3 <strncmp+0x31>
  800b8d:	0f b6 08             	movzbl (%eax),%ecx
  800b90:	84 c9                	test   %cl,%cl
  800b92:	74 04                	je     800b98 <strncmp+0x26>
  800b94:	3a 0a                	cmp    (%edx),%cl
  800b96:	74 eb                	je     800b83 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b98:	0f b6 00             	movzbl (%eax),%eax
  800b9b:	0f b6 12             	movzbl (%edx),%edx
  800b9e:	29 d0                	sub    %edx,%eax
}
  800ba0:	5b                   	pop    %ebx
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    
		return 0;
  800ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba8:	eb f6                	jmp    800ba0 <strncmp+0x2e>

00800baa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bb4:	0f b6 10             	movzbl (%eax),%edx
  800bb7:	84 d2                	test   %dl,%dl
  800bb9:	74 09                	je     800bc4 <strchr+0x1a>
		if (*s == c)
  800bbb:	38 ca                	cmp    %cl,%dl
  800bbd:	74 0a                	je     800bc9 <strchr+0x1f>
	for (; *s; s++)
  800bbf:	83 c0 01             	add    $0x1,%eax
  800bc2:	eb f0                	jmp    800bb4 <strchr+0xa>
			return (char *) s;
	return 0;
  800bc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bd5:	eb 03                	jmp    800bda <strfind+0xf>
  800bd7:	83 c0 01             	add    $0x1,%eax
  800bda:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bdd:	38 ca                	cmp    %cl,%dl
  800bdf:	74 04                	je     800be5 <strfind+0x1a>
  800be1:	84 d2                	test   %dl,%dl
  800be3:	75 f2                	jne    800bd7 <strfind+0xc>
			break;
	return (char *) s;
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	57                   	push   %edi
  800beb:	56                   	push   %esi
  800bec:	53                   	push   %ebx
  800bed:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bf0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bf3:	85 c9                	test   %ecx,%ecx
  800bf5:	74 13                	je     800c0a <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bf7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bfd:	75 05                	jne    800c04 <memset+0x1d>
  800bff:	f6 c1 03             	test   $0x3,%cl
  800c02:	74 0d                	je     800c11 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c07:	fc                   	cld    
  800c08:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c0a:	89 f8                	mov    %edi,%eax
  800c0c:	5b                   	pop    %ebx
  800c0d:	5e                   	pop    %esi
  800c0e:	5f                   	pop    %edi
  800c0f:	5d                   	pop    %ebp
  800c10:	c3                   	ret    
		c &= 0xFF;
  800c11:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c15:	89 d3                	mov    %edx,%ebx
  800c17:	c1 e3 08             	shl    $0x8,%ebx
  800c1a:	89 d0                	mov    %edx,%eax
  800c1c:	c1 e0 18             	shl    $0x18,%eax
  800c1f:	89 d6                	mov    %edx,%esi
  800c21:	c1 e6 10             	shl    $0x10,%esi
  800c24:	09 f0                	or     %esi,%eax
  800c26:	09 c2                	or     %eax,%edx
  800c28:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800c2a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c2d:	89 d0                	mov    %edx,%eax
  800c2f:	fc                   	cld    
  800c30:	f3 ab                	rep stos %eax,%es:(%edi)
  800c32:	eb d6                	jmp    800c0a <memset+0x23>

00800c34 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c42:	39 c6                	cmp    %eax,%esi
  800c44:	73 35                	jae    800c7b <memmove+0x47>
  800c46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c49:	39 c2                	cmp    %eax,%edx
  800c4b:	76 2e                	jbe    800c7b <memmove+0x47>
		s += n;
		d += n;
  800c4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c50:	89 d6                	mov    %edx,%esi
  800c52:	09 fe                	or     %edi,%esi
  800c54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c5a:	74 0c                	je     800c68 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c5c:	83 ef 01             	sub    $0x1,%edi
  800c5f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c62:	fd                   	std    
  800c63:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c65:	fc                   	cld    
  800c66:	eb 21                	jmp    800c89 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c68:	f6 c1 03             	test   $0x3,%cl
  800c6b:	75 ef                	jne    800c5c <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c6d:	83 ef 04             	sub    $0x4,%edi
  800c70:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c73:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c76:	fd                   	std    
  800c77:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c79:	eb ea                	jmp    800c65 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c7b:	89 f2                	mov    %esi,%edx
  800c7d:	09 c2                	or     %eax,%edx
  800c7f:	f6 c2 03             	test   $0x3,%dl
  800c82:	74 09                	je     800c8d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c84:	89 c7                	mov    %eax,%edi
  800c86:	fc                   	cld    
  800c87:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c89:	5e                   	pop    %esi
  800c8a:	5f                   	pop    %edi
  800c8b:	5d                   	pop    %ebp
  800c8c:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c8d:	f6 c1 03             	test   $0x3,%cl
  800c90:	75 f2                	jne    800c84 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c92:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c95:	89 c7                	mov    %eax,%edi
  800c97:	fc                   	cld    
  800c98:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c9a:	eb ed                	jmp    800c89 <memmove+0x55>

00800c9c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c9f:	ff 75 10             	pushl  0x10(%ebp)
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	ff 75 08             	pushl  0x8(%ebp)
  800ca8:	e8 87 ff ff ff       	call   800c34 <memmove>
}
  800cad:	c9                   	leave  
  800cae:	c3                   	ret    

00800caf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	56                   	push   %esi
  800cb3:	53                   	push   %ebx
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cba:	89 c6                	mov    %eax,%esi
  800cbc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cbf:	39 f0                	cmp    %esi,%eax
  800cc1:	74 1c                	je     800cdf <memcmp+0x30>
		if (*s1 != *s2)
  800cc3:	0f b6 08             	movzbl (%eax),%ecx
  800cc6:	0f b6 1a             	movzbl (%edx),%ebx
  800cc9:	38 d9                	cmp    %bl,%cl
  800ccb:	75 08                	jne    800cd5 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ccd:	83 c0 01             	add    $0x1,%eax
  800cd0:	83 c2 01             	add    $0x1,%edx
  800cd3:	eb ea                	jmp    800cbf <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cd5:	0f b6 c1             	movzbl %cl,%eax
  800cd8:	0f b6 db             	movzbl %bl,%ebx
  800cdb:	29 d8                	sub    %ebx,%eax
  800cdd:	eb 05                	jmp    800ce4 <memcmp+0x35>
	}

	return 0;
  800cdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce4:	5b                   	pop    %ebx
  800ce5:	5e                   	pop    %esi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cf1:	89 c2                	mov    %eax,%edx
  800cf3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cf6:	39 d0                	cmp    %edx,%eax
  800cf8:	73 09                	jae    800d03 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cfa:	38 08                	cmp    %cl,(%eax)
  800cfc:	74 05                	je     800d03 <memfind+0x1b>
	for (; s < ends; s++)
  800cfe:	83 c0 01             	add    $0x1,%eax
  800d01:	eb f3                	jmp    800cf6 <memfind+0xe>
			break;
	return (void *) s;
}
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	57                   	push   %edi
  800d09:	56                   	push   %esi
  800d0a:	53                   	push   %ebx
  800d0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d11:	eb 03                	jmp    800d16 <strtol+0x11>
		s++;
  800d13:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d16:	0f b6 01             	movzbl (%ecx),%eax
  800d19:	3c 20                	cmp    $0x20,%al
  800d1b:	74 f6                	je     800d13 <strtol+0xe>
  800d1d:	3c 09                	cmp    $0x9,%al
  800d1f:	74 f2                	je     800d13 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d21:	3c 2b                	cmp    $0x2b,%al
  800d23:	74 2e                	je     800d53 <strtol+0x4e>
	int neg = 0;
  800d25:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d2a:	3c 2d                	cmp    $0x2d,%al
  800d2c:	74 2f                	je     800d5d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d2e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d34:	75 05                	jne    800d3b <strtol+0x36>
  800d36:	80 39 30             	cmpb   $0x30,(%ecx)
  800d39:	74 2c                	je     800d67 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d3b:	85 db                	test   %ebx,%ebx
  800d3d:	75 0a                	jne    800d49 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d3f:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800d44:	80 39 30             	cmpb   $0x30,(%ecx)
  800d47:	74 28                	je     800d71 <strtol+0x6c>
		base = 10;
  800d49:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d51:	eb 50                	jmp    800da3 <strtol+0x9e>
		s++;
  800d53:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d56:	bf 00 00 00 00       	mov    $0x0,%edi
  800d5b:	eb d1                	jmp    800d2e <strtol+0x29>
		s++, neg = 1;
  800d5d:	83 c1 01             	add    $0x1,%ecx
  800d60:	bf 01 00 00 00       	mov    $0x1,%edi
  800d65:	eb c7                	jmp    800d2e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d67:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d6b:	74 0e                	je     800d7b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d6d:	85 db                	test   %ebx,%ebx
  800d6f:	75 d8                	jne    800d49 <strtol+0x44>
		s++, base = 8;
  800d71:	83 c1 01             	add    $0x1,%ecx
  800d74:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d79:	eb ce                	jmp    800d49 <strtol+0x44>
		s += 2, base = 16;
  800d7b:	83 c1 02             	add    $0x2,%ecx
  800d7e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d83:	eb c4                	jmp    800d49 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d85:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d88:	89 f3                	mov    %esi,%ebx
  800d8a:	80 fb 19             	cmp    $0x19,%bl
  800d8d:	77 29                	ja     800db8 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d8f:	0f be d2             	movsbl %dl,%edx
  800d92:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d95:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d98:	7d 30                	jge    800dca <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d9a:	83 c1 01             	add    $0x1,%ecx
  800d9d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800da1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800da3:	0f b6 11             	movzbl (%ecx),%edx
  800da6:	8d 72 d0             	lea    -0x30(%edx),%esi
  800da9:	89 f3                	mov    %esi,%ebx
  800dab:	80 fb 09             	cmp    $0x9,%bl
  800dae:	77 d5                	ja     800d85 <strtol+0x80>
			dig = *s - '0';
  800db0:	0f be d2             	movsbl %dl,%edx
  800db3:	83 ea 30             	sub    $0x30,%edx
  800db6:	eb dd                	jmp    800d95 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800db8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800dbb:	89 f3                	mov    %esi,%ebx
  800dbd:	80 fb 19             	cmp    $0x19,%bl
  800dc0:	77 08                	ja     800dca <strtol+0xc5>
			dig = *s - 'A' + 10;
  800dc2:	0f be d2             	movsbl %dl,%edx
  800dc5:	83 ea 37             	sub    $0x37,%edx
  800dc8:	eb cb                	jmp    800d95 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dce:	74 05                	je     800dd5 <strtol+0xd0>
		*endptr = (char *) s;
  800dd0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dd3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dd5:	89 c2                	mov    %eax,%edx
  800dd7:	f7 da                	neg    %edx
  800dd9:	85 ff                	test   %edi,%edi
  800ddb:	0f 45 c2             	cmovne %edx,%eax
}
  800dde:	5b                   	pop    %ebx
  800ddf:	5e                   	pop    %esi
  800de0:	5f                   	pop    %edi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800de9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dee:	8b 55 08             	mov    0x8(%ebp),%edx
  800df1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df4:	89 c3                	mov    %eax,%ebx
  800df6:	89 c7                	mov    %eax,%edi
  800df8:	89 c6                	mov    %eax,%esi
  800dfa:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dfc:	5b                   	pop    %ebx
  800dfd:	5e                   	pop    %esi
  800dfe:	5f                   	pop    %edi
  800dff:	5d                   	pop    %ebp
  800e00:	c3                   	ret    

00800e01 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	57                   	push   %edi
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e07:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0c:	b8 01 00 00 00       	mov    $0x1,%eax
  800e11:	89 d1                	mov    %edx,%ecx
  800e13:	89 d3                	mov    %edx,%ebx
  800e15:	89 d7                	mov    %edx,%edi
  800e17:	89 d6                	mov    %edx,%esi
  800e19:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	57                   	push   %edi
  800e24:	56                   	push   %esi
  800e25:	53                   	push   %ebx
  800e26:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e29:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e31:	b8 03 00 00 00       	mov    $0x3,%eax
  800e36:	89 cb                	mov    %ecx,%ebx
  800e38:	89 cf                	mov    %ecx,%edi
  800e3a:	89 ce                	mov    %ecx,%esi
  800e3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3e:	85 c0                	test   %eax,%eax
  800e40:	7f 08                	jg     800e4a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e45:	5b                   	pop    %ebx
  800e46:	5e                   	pop    %esi
  800e47:	5f                   	pop    %edi
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4a:	83 ec 0c             	sub    $0xc,%esp
  800e4d:	50                   	push   %eax
  800e4e:	6a 03                	push   $0x3
  800e50:	68 4f 24 80 00       	push   $0x80244f
  800e55:	6a 23                	push   $0x23
  800e57:	68 6c 24 80 00       	push   $0x80246c
  800e5c:	e8 5b f4 ff ff       	call   8002bc <_panic>

00800e61 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	57                   	push   %edi
  800e65:	56                   	push   %esi
  800e66:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e67:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6c:	b8 02 00 00 00       	mov    $0x2,%eax
  800e71:	89 d1                	mov    %edx,%ecx
  800e73:	89 d3                	mov    %edx,%ebx
  800e75:	89 d7                	mov    %edx,%edi
  800e77:	89 d6                	mov    %edx,%esi
  800e79:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e7b:	5b                   	pop    %ebx
  800e7c:	5e                   	pop    %esi
  800e7d:	5f                   	pop    %edi
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <sys_yield>:

void
sys_yield(void)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	57                   	push   %edi
  800e84:	56                   	push   %esi
  800e85:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e86:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e90:	89 d1                	mov    %edx,%ecx
  800e92:	89 d3                	mov    %edx,%ebx
  800e94:	89 d7                	mov    %edx,%edi
  800e96:	89 d6                	mov    %edx,%esi
  800e98:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
  800ea5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ea8:	be 00 00 00 00       	mov    $0x0,%esi
  800ead:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb3:	b8 04 00 00 00       	mov    $0x4,%eax
  800eb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebb:	89 f7                	mov    %esi,%edi
  800ebd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7f 08                	jg     800ecb <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	83 ec 0c             	sub    $0xc,%esp
  800ece:	50                   	push   %eax
  800ecf:	6a 04                	push   $0x4
  800ed1:	68 4f 24 80 00       	push   $0x80244f
  800ed6:	6a 23                	push   $0x23
  800ed8:	68 6c 24 80 00       	push   $0x80246c
  800edd:	e8 da f3 ff ff       	call   8002bc <_panic>

00800ee2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	57                   	push   %edi
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
  800ee8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800eeb:	8b 55 08             	mov    0x8(%ebp),%edx
  800eee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef1:	b8 05 00 00 00       	mov    $0x5,%eax
  800ef6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efc:	8b 75 18             	mov    0x18(%ebp),%esi
  800eff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f01:	85 c0                	test   %eax,%eax
  800f03:	7f 08                	jg     800f0d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0d:	83 ec 0c             	sub    $0xc,%esp
  800f10:	50                   	push   %eax
  800f11:	6a 05                	push   $0x5
  800f13:	68 4f 24 80 00       	push   $0x80244f
  800f18:	6a 23                	push   $0x23
  800f1a:	68 6c 24 80 00       	push   $0x80246c
  800f1f:	e8 98 f3 ff ff       	call   8002bc <_panic>

00800f24 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	57                   	push   %edi
  800f28:	56                   	push   %esi
  800f29:	53                   	push   %ebx
  800f2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800f2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f38:	b8 06 00 00 00       	mov    $0x6,%eax
  800f3d:	89 df                	mov    %ebx,%edi
  800f3f:	89 de                	mov    %ebx,%esi
  800f41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f43:	85 c0                	test   %eax,%eax
  800f45:	7f 08                	jg     800f4f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4f:	83 ec 0c             	sub    $0xc,%esp
  800f52:	50                   	push   %eax
  800f53:	6a 06                	push   $0x6
  800f55:	68 4f 24 80 00       	push   $0x80244f
  800f5a:	6a 23                	push   $0x23
  800f5c:	68 6c 24 80 00       	push   $0x80246c
  800f61:	e8 56 f3 ff ff       	call   8002bc <_panic>

00800f66 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	57                   	push   %edi
  800f6a:	56                   	push   %esi
  800f6b:	53                   	push   %ebx
  800f6c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800f6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f74:	8b 55 08             	mov    0x8(%ebp),%edx
  800f77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7a:	b8 08 00 00 00       	mov    $0x8,%eax
  800f7f:	89 df                	mov    %ebx,%edi
  800f81:	89 de                	mov    %ebx,%esi
  800f83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f85:	85 c0                	test   %eax,%eax
  800f87:	7f 08                	jg     800f91 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5f                   	pop    %edi
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f91:	83 ec 0c             	sub    $0xc,%esp
  800f94:	50                   	push   %eax
  800f95:	6a 08                	push   $0x8
  800f97:	68 4f 24 80 00       	push   $0x80244f
  800f9c:	6a 23                	push   $0x23
  800f9e:	68 6c 24 80 00       	push   $0x80246c
  800fa3:	e8 14 f3 ff ff       	call   8002bc <_panic>

00800fa8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	57                   	push   %edi
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
  800fae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800fb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbc:	b8 09 00 00 00       	mov    $0x9,%eax
  800fc1:	89 df                	mov    %ebx,%edi
  800fc3:	89 de                	mov    %ebx,%esi
  800fc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc7:	85 c0                	test   %eax,%eax
  800fc9:	7f 08                	jg     800fd3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fce:	5b                   	pop    %ebx
  800fcf:	5e                   	pop    %esi
  800fd0:	5f                   	pop    %edi
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd3:	83 ec 0c             	sub    $0xc,%esp
  800fd6:	50                   	push   %eax
  800fd7:	6a 09                	push   $0x9
  800fd9:	68 4f 24 80 00       	push   $0x80244f
  800fde:	6a 23                	push   $0x23
  800fe0:	68 6c 24 80 00       	push   $0x80246c
  800fe5:	e8 d2 f2 ff ff       	call   8002bc <_panic>

00800fea <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	57                   	push   %edi
  800fee:	56                   	push   %esi
  800fef:	53                   	push   %ebx
  800ff0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ff3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffe:	b8 0a 00 00 00       	mov    $0xa,%eax
  801003:	89 df                	mov    %ebx,%edi
  801005:	89 de                	mov    %ebx,%esi
  801007:	cd 30                	int    $0x30
	if(check && ret > 0)
  801009:	85 c0                	test   %eax,%eax
  80100b:	7f 08                	jg     801015 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80100d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801010:	5b                   	pop    %ebx
  801011:	5e                   	pop    %esi
  801012:	5f                   	pop    %edi
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801015:	83 ec 0c             	sub    $0xc,%esp
  801018:	50                   	push   %eax
  801019:	6a 0a                	push   $0xa
  80101b:	68 4f 24 80 00       	push   $0x80244f
  801020:	6a 23                	push   $0x23
  801022:	68 6c 24 80 00       	push   $0x80246c
  801027:	e8 90 f2 ff ff       	call   8002bc <_panic>

0080102c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	57                   	push   %edi
  801030:	56                   	push   %esi
  801031:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  801032:	8b 55 08             	mov    0x8(%ebp),%edx
  801035:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801038:	b8 0c 00 00 00       	mov    $0xc,%eax
  80103d:	be 00 00 00 00       	mov    $0x0,%esi
  801042:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801045:	8b 7d 14             	mov    0x14(%ebp),%edi
  801048:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80104a:	5b                   	pop    %ebx
  80104b:	5e                   	pop    %esi
  80104c:	5f                   	pop    %edi
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	57                   	push   %edi
  801053:	56                   	push   %esi
  801054:	53                   	push   %ebx
  801055:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  801058:	b9 00 00 00 00       	mov    $0x0,%ecx
  80105d:	8b 55 08             	mov    0x8(%ebp),%edx
  801060:	b8 0d 00 00 00       	mov    $0xd,%eax
  801065:	89 cb                	mov    %ecx,%ebx
  801067:	89 cf                	mov    %ecx,%edi
  801069:	89 ce                	mov    %ecx,%esi
  80106b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80106d:	85 c0                	test   %eax,%eax
  80106f:	7f 08                	jg     801079 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801071:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5f                   	pop    %edi
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	50                   	push   %eax
  80107d:	6a 0d                	push   $0xd
  80107f:	68 4f 24 80 00       	push   $0x80244f
  801084:	6a 23                	push   $0x23
  801086:	68 6c 24 80 00       	push   $0x80246c
  80108b:	e8 2c f2 ff ff       	call   8002bc <_panic>

00801090 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	05 00 00 00 30       	add    $0x30000000,%eax
  80109b:	c1 e8 0c             	shr    $0xc,%eax
}
  80109e:	5d                   	pop    %ebp
  80109f:	c3                   	ret    

008010a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010b0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    

008010b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010c2:	89 c2                	mov    %eax,%edx
  8010c4:	c1 ea 16             	shr    $0x16,%edx
  8010c7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ce:	f6 c2 01             	test   $0x1,%dl
  8010d1:	74 2a                	je     8010fd <fd_alloc+0x46>
  8010d3:	89 c2                	mov    %eax,%edx
  8010d5:	c1 ea 0c             	shr    $0xc,%edx
  8010d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010df:	f6 c2 01             	test   $0x1,%dl
  8010e2:	74 19                	je     8010fd <fd_alloc+0x46>
  8010e4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010e9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010ee:	75 d2                	jne    8010c2 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010f0:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010f6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010fb:	eb 07                	jmp    801104 <fd_alloc+0x4d>
			*fd_store = fd;
  8010fd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801104:	5d                   	pop    %ebp
  801105:	c3                   	ret    

00801106 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80110c:	83 f8 1f             	cmp    $0x1f,%eax
  80110f:	77 36                	ja     801147 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801111:	c1 e0 0c             	shl    $0xc,%eax
  801114:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801119:	89 c2                	mov    %eax,%edx
  80111b:	c1 ea 16             	shr    $0x16,%edx
  80111e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801125:	f6 c2 01             	test   $0x1,%dl
  801128:	74 24                	je     80114e <fd_lookup+0x48>
  80112a:	89 c2                	mov    %eax,%edx
  80112c:	c1 ea 0c             	shr    $0xc,%edx
  80112f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801136:	f6 c2 01             	test   $0x1,%dl
  801139:	74 1a                	je     801155 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80113b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80113e:	89 02                	mov    %eax,(%edx)
	return 0;
  801140:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801145:	5d                   	pop    %ebp
  801146:	c3                   	ret    
		return -E_INVAL;
  801147:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80114c:	eb f7                	jmp    801145 <fd_lookup+0x3f>
		return -E_INVAL;
  80114e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801153:	eb f0                	jmp    801145 <fd_lookup+0x3f>
  801155:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115a:	eb e9                	jmp    801145 <fd_lookup+0x3f>

0080115c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	83 ec 08             	sub    $0x8,%esp
  801162:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801165:	ba fc 24 80 00       	mov    $0x8024fc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80116a:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  80116f:	39 08                	cmp    %ecx,(%eax)
  801171:	74 33                	je     8011a6 <dev_lookup+0x4a>
  801173:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801176:	8b 02                	mov    (%edx),%eax
  801178:	85 c0                	test   %eax,%eax
  80117a:	75 f3                	jne    80116f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80117c:	a1 04 44 80 00       	mov    0x804404,%eax
  801181:	8b 40 48             	mov    0x48(%eax),%eax
  801184:	83 ec 04             	sub    $0x4,%esp
  801187:	51                   	push   %ecx
  801188:	50                   	push   %eax
  801189:	68 7c 24 80 00       	push   $0x80247c
  80118e:	e8 04 f2 ff ff       	call   800397 <cprintf>
	*dev = 0;
  801193:	8b 45 0c             	mov    0xc(%ebp),%eax
  801196:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80119c:	83 c4 10             	add    $0x10,%esp
  80119f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    
			*dev = devtab[i];
  8011a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b0:	eb f2                	jmp    8011a4 <dev_lookup+0x48>

008011b2 <fd_close>:
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
  8011b5:	57                   	push   %edi
  8011b6:	56                   	push   %esi
  8011b7:	53                   	push   %ebx
  8011b8:	83 ec 1c             	sub    $0x1c,%esp
  8011bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8011be:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011c4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011c5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011cb:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011ce:	50                   	push   %eax
  8011cf:	e8 32 ff ff ff       	call   801106 <fd_lookup>
  8011d4:	89 c3                	mov    %eax,%ebx
  8011d6:	83 c4 08             	add    $0x8,%esp
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	78 05                	js     8011e2 <fd_close+0x30>
	    || fd != fd2)
  8011dd:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011e0:	74 16                	je     8011f8 <fd_close+0x46>
		return (must_exist ? r : 0);
  8011e2:	89 f8                	mov    %edi,%eax
  8011e4:	84 c0                	test   %al,%al
  8011e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011eb:	0f 44 d8             	cmove  %eax,%ebx
}
  8011ee:	89 d8                	mov    %ebx,%eax
  8011f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f3:	5b                   	pop    %ebx
  8011f4:	5e                   	pop    %esi
  8011f5:	5f                   	pop    %edi
  8011f6:	5d                   	pop    %ebp
  8011f7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011f8:	83 ec 08             	sub    $0x8,%esp
  8011fb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011fe:	50                   	push   %eax
  8011ff:	ff 36                	pushl  (%esi)
  801201:	e8 56 ff ff ff       	call   80115c <dev_lookup>
  801206:	89 c3                	mov    %eax,%ebx
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	85 c0                	test   %eax,%eax
  80120d:	78 15                	js     801224 <fd_close+0x72>
		if (dev->dev_close)
  80120f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801212:	8b 40 10             	mov    0x10(%eax),%eax
  801215:	85 c0                	test   %eax,%eax
  801217:	74 1b                	je     801234 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801219:	83 ec 0c             	sub    $0xc,%esp
  80121c:	56                   	push   %esi
  80121d:	ff d0                	call   *%eax
  80121f:	89 c3                	mov    %eax,%ebx
  801221:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801224:	83 ec 08             	sub    $0x8,%esp
  801227:	56                   	push   %esi
  801228:	6a 00                	push   $0x0
  80122a:	e8 f5 fc ff ff       	call   800f24 <sys_page_unmap>
	return r;
  80122f:	83 c4 10             	add    $0x10,%esp
  801232:	eb ba                	jmp    8011ee <fd_close+0x3c>
			r = 0;
  801234:	bb 00 00 00 00       	mov    $0x0,%ebx
  801239:	eb e9                	jmp    801224 <fd_close+0x72>

0080123b <close>:

int
close(int fdnum)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801241:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801244:	50                   	push   %eax
  801245:	ff 75 08             	pushl  0x8(%ebp)
  801248:	e8 b9 fe ff ff       	call   801106 <fd_lookup>
  80124d:	83 c4 08             	add    $0x8,%esp
  801250:	85 c0                	test   %eax,%eax
  801252:	78 10                	js     801264 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801254:	83 ec 08             	sub    $0x8,%esp
  801257:	6a 01                	push   $0x1
  801259:	ff 75 f4             	pushl  -0xc(%ebp)
  80125c:	e8 51 ff ff ff       	call   8011b2 <fd_close>
  801261:	83 c4 10             	add    $0x10,%esp
}
  801264:	c9                   	leave  
  801265:	c3                   	ret    

00801266 <close_all>:

void
close_all(void)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	53                   	push   %ebx
  80126a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80126d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801272:	83 ec 0c             	sub    $0xc,%esp
  801275:	53                   	push   %ebx
  801276:	e8 c0 ff ff ff       	call   80123b <close>
	for (i = 0; i < MAXFD; i++)
  80127b:	83 c3 01             	add    $0x1,%ebx
  80127e:	83 c4 10             	add    $0x10,%esp
  801281:	83 fb 20             	cmp    $0x20,%ebx
  801284:	75 ec                	jne    801272 <close_all+0xc>
}
  801286:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	57                   	push   %edi
  80128f:	56                   	push   %esi
  801290:	53                   	push   %ebx
  801291:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801294:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801297:	50                   	push   %eax
  801298:	ff 75 08             	pushl  0x8(%ebp)
  80129b:	e8 66 fe ff ff       	call   801106 <fd_lookup>
  8012a0:	89 c3                	mov    %eax,%ebx
  8012a2:	83 c4 08             	add    $0x8,%esp
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	0f 88 81 00 00 00    	js     80132e <dup+0xa3>
		return r;
	close(newfdnum);
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	ff 75 0c             	pushl  0xc(%ebp)
  8012b3:	e8 83 ff ff ff       	call   80123b <close>

	newfd = INDEX2FD(newfdnum);
  8012b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012bb:	c1 e6 0c             	shl    $0xc,%esi
  8012be:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012c4:	83 c4 04             	add    $0x4,%esp
  8012c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012ca:	e8 d1 fd ff ff       	call   8010a0 <fd2data>
  8012cf:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012d1:	89 34 24             	mov    %esi,(%esp)
  8012d4:	e8 c7 fd ff ff       	call   8010a0 <fd2data>
  8012d9:	83 c4 10             	add    $0x10,%esp
  8012dc:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012de:	89 d8                	mov    %ebx,%eax
  8012e0:	c1 e8 16             	shr    $0x16,%eax
  8012e3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ea:	a8 01                	test   $0x1,%al
  8012ec:	74 11                	je     8012ff <dup+0x74>
  8012ee:	89 d8                	mov    %ebx,%eax
  8012f0:	c1 e8 0c             	shr    $0xc,%eax
  8012f3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012fa:	f6 c2 01             	test   $0x1,%dl
  8012fd:	75 39                	jne    801338 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801302:	89 d0                	mov    %edx,%eax
  801304:	c1 e8 0c             	shr    $0xc,%eax
  801307:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80130e:	83 ec 0c             	sub    $0xc,%esp
  801311:	25 07 0e 00 00       	and    $0xe07,%eax
  801316:	50                   	push   %eax
  801317:	56                   	push   %esi
  801318:	6a 00                	push   $0x0
  80131a:	52                   	push   %edx
  80131b:	6a 00                	push   $0x0
  80131d:	e8 c0 fb ff ff       	call   800ee2 <sys_page_map>
  801322:	89 c3                	mov    %eax,%ebx
  801324:	83 c4 20             	add    $0x20,%esp
  801327:	85 c0                	test   %eax,%eax
  801329:	78 31                	js     80135c <dup+0xd1>
		goto err;

	return newfdnum;
  80132b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80132e:	89 d8                	mov    %ebx,%eax
  801330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801333:	5b                   	pop    %ebx
  801334:	5e                   	pop    %esi
  801335:	5f                   	pop    %edi
  801336:	5d                   	pop    %ebp
  801337:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801338:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80133f:	83 ec 0c             	sub    $0xc,%esp
  801342:	25 07 0e 00 00       	and    $0xe07,%eax
  801347:	50                   	push   %eax
  801348:	57                   	push   %edi
  801349:	6a 00                	push   $0x0
  80134b:	53                   	push   %ebx
  80134c:	6a 00                	push   $0x0
  80134e:	e8 8f fb ff ff       	call   800ee2 <sys_page_map>
  801353:	89 c3                	mov    %eax,%ebx
  801355:	83 c4 20             	add    $0x20,%esp
  801358:	85 c0                	test   %eax,%eax
  80135a:	79 a3                	jns    8012ff <dup+0x74>
	sys_page_unmap(0, newfd);
  80135c:	83 ec 08             	sub    $0x8,%esp
  80135f:	56                   	push   %esi
  801360:	6a 00                	push   $0x0
  801362:	e8 bd fb ff ff       	call   800f24 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801367:	83 c4 08             	add    $0x8,%esp
  80136a:	57                   	push   %edi
  80136b:	6a 00                	push   $0x0
  80136d:	e8 b2 fb ff ff       	call   800f24 <sys_page_unmap>
	return r;
  801372:	83 c4 10             	add    $0x10,%esp
  801375:	eb b7                	jmp    80132e <dup+0xa3>

00801377 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	53                   	push   %ebx
  80137b:	83 ec 14             	sub    $0x14,%esp
  80137e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801381:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801384:	50                   	push   %eax
  801385:	53                   	push   %ebx
  801386:	e8 7b fd ff ff       	call   801106 <fd_lookup>
  80138b:	83 c4 08             	add    $0x8,%esp
  80138e:	85 c0                	test   %eax,%eax
  801390:	78 3f                	js     8013d1 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801392:	83 ec 08             	sub    $0x8,%esp
  801395:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801398:	50                   	push   %eax
  801399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139c:	ff 30                	pushl  (%eax)
  80139e:	e8 b9 fd ff ff       	call   80115c <dev_lookup>
  8013a3:	83 c4 10             	add    $0x10,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	78 27                	js     8013d1 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ad:	8b 42 08             	mov    0x8(%edx),%eax
  8013b0:	83 e0 03             	and    $0x3,%eax
  8013b3:	83 f8 01             	cmp    $0x1,%eax
  8013b6:	74 1e                	je     8013d6 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013bb:	8b 40 08             	mov    0x8(%eax),%eax
  8013be:	85 c0                	test   %eax,%eax
  8013c0:	74 35                	je     8013f7 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013c2:	83 ec 04             	sub    $0x4,%esp
  8013c5:	ff 75 10             	pushl  0x10(%ebp)
  8013c8:	ff 75 0c             	pushl  0xc(%ebp)
  8013cb:	52                   	push   %edx
  8013cc:	ff d0                	call   *%eax
  8013ce:	83 c4 10             	add    $0x10,%esp
}
  8013d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013d6:	a1 04 44 80 00       	mov    0x804404,%eax
  8013db:	8b 40 48             	mov    0x48(%eax),%eax
  8013de:	83 ec 04             	sub    $0x4,%esp
  8013e1:	53                   	push   %ebx
  8013e2:	50                   	push   %eax
  8013e3:	68 c0 24 80 00       	push   $0x8024c0
  8013e8:	e8 aa ef ff ff       	call   800397 <cprintf>
		return -E_INVAL;
  8013ed:	83 c4 10             	add    $0x10,%esp
  8013f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f5:	eb da                	jmp    8013d1 <read+0x5a>
		return -E_NOT_SUPP;
  8013f7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013fc:	eb d3                	jmp    8013d1 <read+0x5a>

008013fe <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	57                   	push   %edi
  801402:	56                   	push   %esi
  801403:	53                   	push   %ebx
  801404:	83 ec 0c             	sub    $0xc,%esp
  801407:	8b 7d 08             	mov    0x8(%ebp),%edi
  80140a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80140d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801412:	39 f3                	cmp    %esi,%ebx
  801414:	73 25                	jae    80143b <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801416:	83 ec 04             	sub    $0x4,%esp
  801419:	89 f0                	mov    %esi,%eax
  80141b:	29 d8                	sub    %ebx,%eax
  80141d:	50                   	push   %eax
  80141e:	89 d8                	mov    %ebx,%eax
  801420:	03 45 0c             	add    0xc(%ebp),%eax
  801423:	50                   	push   %eax
  801424:	57                   	push   %edi
  801425:	e8 4d ff ff ff       	call   801377 <read>
		if (m < 0)
  80142a:	83 c4 10             	add    $0x10,%esp
  80142d:	85 c0                	test   %eax,%eax
  80142f:	78 08                	js     801439 <readn+0x3b>
			return m;
		if (m == 0)
  801431:	85 c0                	test   %eax,%eax
  801433:	74 06                	je     80143b <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801435:	01 c3                	add    %eax,%ebx
  801437:	eb d9                	jmp    801412 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801439:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80143b:	89 d8                	mov    %ebx,%eax
  80143d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801440:	5b                   	pop    %ebx
  801441:	5e                   	pop    %esi
  801442:	5f                   	pop    %edi
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    

00801445 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	53                   	push   %ebx
  801449:	83 ec 14             	sub    $0x14,%esp
  80144c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80144f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801452:	50                   	push   %eax
  801453:	53                   	push   %ebx
  801454:	e8 ad fc ff ff       	call   801106 <fd_lookup>
  801459:	83 c4 08             	add    $0x8,%esp
  80145c:	85 c0                	test   %eax,%eax
  80145e:	78 3a                	js     80149a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801460:	83 ec 08             	sub    $0x8,%esp
  801463:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801466:	50                   	push   %eax
  801467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146a:	ff 30                	pushl  (%eax)
  80146c:	e8 eb fc ff ff       	call   80115c <dev_lookup>
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	85 c0                	test   %eax,%eax
  801476:	78 22                	js     80149a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80147f:	74 1e                	je     80149f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801484:	8b 52 0c             	mov    0xc(%edx),%edx
  801487:	85 d2                	test   %edx,%edx
  801489:	74 35                	je     8014c0 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80148b:	83 ec 04             	sub    $0x4,%esp
  80148e:	ff 75 10             	pushl  0x10(%ebp)
  801491:	ff 75 0c             	pushl  0xc(%ebp)
  801494:	50                   	push   %eax
  801495:	ff d2                	call   *%edx
  801497:	83 c4 10             	add    $0x10,%esp
}
  80149a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80149f:	a1 04 44 80 00       	mov    0x804404,%eax
  8014a4:	8b 40 48             	mov    0x48(%eax),%eax
  8014a7:	83 ec 04             	sub    $0x4,%esp
  8014aa:	53                   	push   %ebx
  8014ab:	50                   	push   %eax
  8014ac:	68 dc 24 80 00       	push   $0x8024dc
  8014b1:	e8 e1 ee ff ff       	call   800397 <cprintf>
		return -E_INVAL;
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014be:	eb da                	jmp    80149a <write+0x55>
		return -E_NOT_SUPP;
  8014c0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014c5:	eb d3                	jmp    80149a <write+0x55>

008014c7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014cd:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014d0:	50                   	push   %eax
  8014d1:	ff 75 08             	pushl  0x8(%ebp)
  8014d4:	e8 2d fc ff ff       	call   801106 <fd_lookup>
  8014d9:	83 c4 08             	add    $0x8,%esp
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 0e                	js     8014ee <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	53                   	push   %ebx
  8014f4:	83 ec 14             	sub    $0x14,%esp
  8014f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014fd:	50                   	push   %eax
  8014fe:	53                   	push   %ebx
  8014ff:	e8 02 fc ff ff       	call   801106 <fd_lookup>
  801504:	83 c4 08             	add    $0x8,%esp
  801507:	85 c0                	test   %eax,%eax
  801509:	78 37                	js     801542 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150b:	83 ec 08             	sub    $0x8,%esp
  80150e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801511:	50                   	push   %eax
  801512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801515:	ff 30                	pushl  (%eax)
  801517:	e8 40 fc ff ff       	call   80115c <dev_lookup>
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 1f                	js     801542 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801526:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80152a:	74 1b                	je     801547 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80152c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80152f:	8b 52 18             	mov    0x18(%edx),%edx
  801532:	85 d2                	test   %edx,%edx
  801534:	74 32                	je     801568 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801536:	83 ec 08             	sub    $0x8,%esp
  801539:	ff 75 0c             	pushl  0xc(%ebp)
  80153c:	50                   	push   %eax
  80153d:	ff d2                	call   *%edx
  80153f:	83 c4 10             	add    $0x10,%esp
}
  801542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801545:	c9                   	leave  
  801546:	c3                   	ret    
			thisenv->env_id, fdnum);
  801547:	a1 04 44 80 00       	mov    0x804404,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80154c:	8b 40 48             	mov    0x48(%eax),%eax
  80154f:	83 ec 04             	sub    $0x4,%esp
  801552:	53                   	push   %ebx
  801553:	50                   	push   %eax
  801554:	68 9c 24 80 00       	push   $0x80249c
  801559:	e8 39 ee ff ff       	call   800397 <cprintf>
		return -E_INVAL;
  80155e:	83 c4 10             	add    $0x10,%esp
  801561:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801566:	eb da                	jmp    801542 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801568:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80156d:	eb d3                	jmp    801542 <ftruncate+0x52>

0080156f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	53                   	push   %ebx
  801573:	83 ec 14             	sub    $0x14,%esp
  801576:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801579:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80157c:	50                   	push   %eax
  80157d:	ff 75 08             	pushl  0x8(%ebp)
  801580:	e8 81 fb ff ff       	call   801106 <fd_lookup>
  801585:	83 c4 08             	add    $0x8,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	78 4b                	js     8015d7 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80158c:	83 ec 08             	sub    $0x8,%esp
  80158f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801592:	50                   	push   %eax
  801593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801596:	ff 30                	pushl  (%eax)
  801598:	e8 bf fb ff ff       	call   80115c <dev_lookup>
  80159d:	83 c4 10             	add    $0x10,%esp
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	78 33                	js     8015d7 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a7:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015ab:	74 2f                	je     8015dc <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015ad:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015b0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015b7:	00 00 00 
	stat->st_isdir = 0;
  8015ba:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015c1:	00 00 00 
	stat->st_dev = dev;
  8015c4:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015ca:	83 ec 08             	sub    $0x8,%esp
  8015cd:	53                   	push   %ebx
  8015ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8015d1:	ff 50 14             	call   *0x14(%eax)
  8015d4:	83 c4 10             	add    $0x10,%esp
}
  8015d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    
		return -E_NOT_SUPP;
  8015dc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015e1:	eb f4                	jmp    8015d7 <fstat+0x68>

008015e3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	56                   	push   %esi
  8015e7:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015e8:	83 ec 08             	sub    $0x8,%esp
  8015eb:	6a 00                	push   $0x0
  8015ed:	ff 75 08             	pushl  0x8(%ebp)
  8015f0:	e8 30 02 00 00       	call   801825 <open>
  8015f5:	89 c3                	mov    %eax,%ebx
  8015f7:	83 c4 10             	add    $0x10,%esp
  8015fa:	85 c0                	test   %eax,%eax
  8015fc:	78 1b                	js     801619 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015fe:	83 ec 08             	sub    $0x8,%esp
  801601:	ff 75 0c             	pushl  0xc(%ebp)
  801604:	50                   	push   %eax
  801605:	e8 65 ff ff ff       	call   80156f <fstat>
  80160a:	89 c6                	mov    %eax,%esi
	close(fd);
  80160c:	89 1c 24             	mov    %ebx,(%esp)
  80160f:	e8 27 fc ff ff       	call   80123b <close>
	return r;
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	89 f3                	mov    %esi,%ebx
}
  801619:	89 d8                	mov    %ebx,%eax
  80161b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80161e:	5b                   	pop    %ebx
  80161f:	5e                   	pop    %esi
  801620:	5d                   	pop    %ebp
  801621:	c3                   	ret    

00801622 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	56                   	push   %esi
  801626:	53                   	push   %ebx
  801627:	89 c6                	mov    %eax,%esi
  801629:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80162b:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801632:	74 27                	je     80165b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801634:	6a 07                	push   $0x7
  801636:	68 00 50 80 00       	push   $0x805000
  80163b:	56                   	push   %esi
  80163c:	ff 35 00 44 80 00    	pushl  0x804400
  801642:	e8 4e 07 00 00       	call   801d95 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801647:	83 c4 0c             	add    $0xc,%esp
  80164a:	6a 00                	push   $0x0
  80164c:	53                   	push   %ebx
  80164d:	6a 00                	push   $0x0
  80164f:	e8 d8 06 00 00       	call   801d2c <ipc_recv>
}
  801654:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801657:	5b                   	pop    %ebx
  801658:	5e                   	pop    %esi
  801659:	5d                   	pop    %ebp
  80165a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80165b:	83 ec 0c             	sub    $0xc,%esp
  80165e:	6a 01                	push   $0x1
  801660:	e8 84 07 00 00       	call   801de9 <ipc_find_env>
  801665:	a3 00 44 80 00       	mov    %eax,0x804400
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	eb c5                	jmp    801634 <fsipc+0x12>

0080166f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	8b 40 0c             	mov    0xc(%eax),%eax
  80167b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801680:	8b 45 0c             	mov    0xc(%ebp),%eax
  801683:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801688:	ba 00 00 00 00       	mov    $0x0,%edx
  80168d:	b8 02 00 00 00       	mov    $0x2,%eax
  801692:	e8 8b ff ff ff       	call   801622 <fsipc>
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <devfile_flush>:
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a5:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016af:	b8 06 00 00 00       	mov    $0x6,%eax
  8016b4:	e8 69 ff ff ff       	call   801622 <fsipc>
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <devfile_stat>:
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	53                   	push   %ebx
  8016bf:	83 ec 04             	sub    $0x4,%esp
  8016c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8016cb:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d5:	b8 05 00 00 00       	mov    $0x5,%eax
  8016da:	e8 43 ff ff ff       	call   801622 <fsipc>
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	78 2c                	js     80170f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016e3:	83 ec 08             	sub    $0x8,%esp
  8016e6:	68 00 50 80 00       	push   $0x805000
  8016eb:	53                   	push   %ebx
  8016ec:	e8 b5 f3 ff ff       	call   800aa6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016f1:	a1 80 50 80 00       	mov    0x805080,%eax
  8016f6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016fc:	a1 84 50 80 00       	mov    0x805084,%eax
  801701:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <devfile_write>:
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	53                   	push   %ebx
  801718:	83 ec 08             	sub    $0x8,%esp
  80171b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  80171e:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801724:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801729:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8b 40 0c             	mov    0xc(%eax),%eax
  801732:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801737:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80173d:	53                   	push   %ebx
  80173e:	ff 75 0c             	pushl  0xc(%ebp)
  801741:	68 08 50 80 00       	push   $0x805008
  801746:	e8 e9 f4 ff ff       	call   800c34 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80174b:	ba 00 00 00 00       	mov    $0x0,%edx
  801750:	b8 04 00 00 00       	mov    $0x4,%eax
  801755:	e8 c8 fe ff ff       	call   801622 <fsipc>
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 0b                	js     80176c <devfile_write+0x58>
	assert(r <= n);
  801761:	39 d8                	cmp    %ebx,%eax
  801763:	77 0c                	ja     801771 <devfile_write+0x5d>
	assert(r <= PGSIZE);
  801765:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80176a:	7f 1e                	jg     80178a <devfile_write+0x76>
}
  80176c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80176f:	c9                   	leave  
  801770:	c3                   	ret    
	assert(r <= n);
  801771:	68 0c 25 80 00       	push   $0x80250c
  801776:	68 13 25 80 00       	push   $0x802513
  80177b:	68 98 00 00 00       	push   $0x98
  801780:	68 28 25 80 00       	push   $0x802528
  801785:	e8 32 eb ff ff       	call   8002bc <_panic>
	assert(r <= PGSIZE);
  80178a:	68 33 25 80 00       	push   $0x802533
  80178f:	68 13 25 80 00       	push   $0x802513
  801794:	68 99 00 00 00       	push   $0x99
  801799:	68 28 25 80 00       	push   $0x802528
  80179e:	e8 19 eb ff ff       	call   8002bc <_panic>

008017a3 <devfile_read>:
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	56                   	push   %esi
  8017a7:	53                   	push   %ebx
  8017a8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017b6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c1:	b8 03 00 00 00       	mov    $0x3,%eax
  8017c6:	e8 57 fe ff ff       	call   801622 <fsipc>
  8017cb:	89 c3                	mov    %eax,%ebx
  8017cd:	85 c0                	test   %eax,%eax
  8017cf:	78 1f                	js     8017f0 <devfile_read+0x4d>
	assert(r <= n);
  8017d1:	39 f0                	cmp    %esi,%eax
  8017d3:	77 24                	ja     8017f9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017da:	7f 33                	jg     80180f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	50                   	push   %eax
  8017e0:	68 00 50 80 00       	push   $0x805000
  8017e5:	ff 75 0c             	pushl  0xc(%ebp)
  8017e8:	e8 47 f4 ff ff       	call   800c34 <memmove>
	return r;
  8017ed:	83 c4 10             	add    $0x10,%esp
}
  8017f0:	89 d8                	mov    %ebx,%eax
  8017f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f5:	5b                   	pop    %ebx
  8017f6:	5e                   	pop    %esi
  8017f7:	5d                   	pop    %ebp
  8017f8:	c3                   	ret    
	assert(r <= n);
  8017f9:	68 0c 25 80 00       	push   $0x80250c
  8017fe:	68 13 25 80 00       	push   $0x802513
  801803:	6a 7c                	push   $0x7c
  801805:	68 28 25 80 00       	push   $0x802528
  80180a:	e8 ad ea ff ff       	call   8002bc <_panic>
	assert(r <= PGSIZE);
  80180f:	68 33 25 80 00       	push   $0x802533
  801814:	68 13 25 80 00       	push   $0x802513
  801819:	6a 7d                	push   $0x7d
  80181b:	68 28 25 80 00       	push   $0x802528
  801820:	e8 97 ea ff ff       	call   8002bc <_panic>

00801825 <open>:
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	56                   	push   %esi
  801829:	53                   	push   %ebx
  80182a:	83 ec 1c             	sub    $0x1c,%esp
  80182d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801830:	56                   	push   %esi
  801831:	e8 39 f2 ff ff       	call   800a6f <strlen>
  801836:	83 c4 10             	add    $0x10,%esp
  801839:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80183e:	7f 6c                	jg     8018ac <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801840:	83 ec 0c             	sub    $0xc,%esp
  801843:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801846:	50                   	push   %eax
  801847:	e8 6b f8 ff ff       	call   8010b7 <fd_alloc>
  80184c:	89 c3                	mov    %eax,%ebx
  80184e:	83 c4 10             	add    $0x10,%esp
  801851:	85 c0                	test   %eax,%eax
  801853:	78 3c                	js     801891 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801855:	83 ec 08             	sub    $0x8,%esp
  801858:	56                   	push   %esi
  801859:	68 00 50 80 00       	push   $0x805000
  80185e:	e8 43 f2 ff ff       	call   800aa6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801863:	8b 45 0c             	mov    0xc(%ebp),%eax
  801866:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80186b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186e:	b8 01 00 00 00       	mov    $0x1,%eax
  801873:	e8 aa fd ff ff       	call   801622 <fsipc>
  801878:	89 c3                	mov    %eax,%ebx
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	85 c0                	test   %eax,%eax
  80187f:	78 19                	js     80189a <open+0x75>
	return fd2num(fd);
  801881:	83 ec 0c             	sub    $0xc,%esp
  801884:	ff 75 f4             	pushl  -0xc(%ebp)
  801887:	e8 04 f8 ff ff       	call   801090 <fd2num>
  80188c:	89 c3                	mov    %eax,%ebx
  80188e:	83 c4 10             	add    $0x10,%esp
}
  801891:	89 d8                	mov    %ebx,%eax
  801893:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801896:	5b                   	pop    %ebx
  801897:	5e                   	pop    %esi
  801898:	5d                   	pop    %ebp
  801899:	c3                   	ret    
		fd_close(fd, 0);
  80189a:	83 ec 08             	sub    $0x8,%esp
  80189d:	6a 00                	push   $0x0
  80189f:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a2:	e8 0b f9 ff ff       	call   8011b2 <fd_close>
		return r;
  8018a7:	83 c4 10             	add    $0x10,%esp
  8018aa:	eb e5                	jmp    801891 <open+0x6c>
		return -E_BAD_PATH;
  8018ac:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018b1:	eb de                	jmp    801891 <open+0x6c>

008018b3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018be:	b8 08 00 00 00       	mov    $0x8,%eax
  8018c3:	e8 5a fd ff ff       	call   801622 <fsipc>
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8018ca:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8018ce:	7e 38                	jle    801908 <writebuf+0x3e>
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	53                   	push   %ebx
  8018d4:	83 ec 08             	sub    $0x8,%esp
  8018d7:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8018d9:	ff 70 04             	pushl  0x4(%eax)
  8018dc:	8d 40 10             	lea    0x10(%eax),%eax
  8018df:	50                   	push   %eax
  8018e0:	ff 33                	pushl  (%ebx)
  8018e2:	e8 5e fb ff ff       	call   801445 <write>
		if (result > 0)
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	7e 03                	jle    8018f1 <writebuf+0x27>
			b->result += result;
  8018ee:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8018f1:	39 43 04             	cmp    %eax,0x4(%ebx)
  8018f4:	74 0d                	je     801903 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fd:	0f 4f c2             	cmovg  %edx,%eax
  801900:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801903:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801906:	c9                   	leave  
  801907:	c3                   	ret    
  801908:	f3 c3                	repz ret 

0080190a <putch>:

static void
putch(int ch, void *thunk)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	53                   	push   %ebx
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801914:	8b 53 04             	mov    0x4(%ebx),%edx
  801917:	8d 42 01             	lea    0x1(%edx),%eax
  80191a:	89 43 04             	mov    %eax,0x4(%ebx)
  80191d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801920:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801924:	3d 00 01 00 00       	cmp    $0x100,%eax
  801929:	74 06                	je     801931 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  80192b:	83 c4 04             	add    $0x4,%esp
  80192e:	5b                   	pop    %ebx
  80192f:	5d                   	pop    %ebp
  801930:	c3                   	ret    
		writebuf(b);
  801931:	89 d8                	mov    %ebx,%eax
  801933:	e8 92 ff ff ff       	call   8018ca <writebuf>
		b->idx = 0;
  801938:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  80193f:	eb ea                	jmp    80192b <putch+0x21>

00801941 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801953:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80195a:	00 00 00 
	b.result = 0;
  80195d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801964:	00 00 00 
	b.error = 1;
  801967:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  80196e:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801971:	ff 75 10             	pushl  0x10(%ebp)
  801974:	ff 75 0c             	pushl  0xc(%ebp)
  801977:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80197d:	50                   	push   %eax
  80197e:	68 0a 19 80 00       	push   $0x80190a
  801983:	e8 0c eb ff ff       	call   800494 <vprintfmt>
	if (b.idx > 0)
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801992:	7f 11                	jg     8019a5 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801994:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80199a:	85 c0                	test   %eax,%eax
  80199c:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    
		writebuf(&b);
  8019a5:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019ab:	e8 1a ff ff ff       	call   8018ca <writebuf>
  8019b0:	eb e2                	jmp    801994 <vfprintf+0x53>

008019b2 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019b8:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8019bb:	50                   	push   %eax
  8019bc:	ff 75 0c             	pushl  0xc(%ebp)
  8019bf:	ff 75 08             	pushl  0x8(%ebp)
  8019c2:	e8 7a ff ff ff       	call   801941 <vfprintf>
	va_end(ap);

	return cnt;
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <printf>:

int
printf(const char *fmt, ...)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019cf:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8019d2:	50                   	push   %eax
  8019d3:	ff 75 08             	pushl  0x8(%ebp)
  8019d6:	6a 01                	push   $0x1
  8019d8:	e8 64 ff ff ff       	call   801941 <vfprintf>
	va_end(ap);

	return cnt;
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	56                   	push   %esi
  8019e3:	53                   	push   %ebx
  8019e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019e7:	83 ec 0c             	sub    $0xc,%esp
  8019ea:	ff 75 08             	pushl  0x8(%ebp)
  8019ed:	e8 ae f6 ff ff       	call   8010a0 <fd2data>
  8019f2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019f4:	83 c4 08             	add    $0x8,%esp
  8019f7:	68 3f 25 80 00       	push   $0x80253f
  8019fc:	53                   	push   %ebx
  8019fd:	e8 a4 f0 ff ff       	call   800aa6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a02:	8b 46 04             	mov    0x4(%esi),%eax
  801a05:	2b 06                	sub    (%esi),%eax
  801a07:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a0d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a14:	00 00 00 
	stat->st_dev = &devpipe;
  801a17:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801a1e:	30 80 00 
	return 0;
}
  801a21:	b8 00 00 00 00       	mov    $0x0,%eax
  801a26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a29:	5b                   	pop    %ebx
  801a2a:	5e                   	pop    %esi
  801a2b:	5d                   	pop    %ebp
  801a2c:	c3                   	ret    

00801a2d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	53                   	push   %ebx
  801a31:	83 ec 0c             	sub    $0xc,%esp
  801a34:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a37:	53                   	push   %ebx
  801a38:	6a 00                	push   $0x0
  801a3a:	e8 e5 f4 ff ff       	call   800f24 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a3f:	89 1c 24             	mov    %ebx,(%esp)
  801a42:	e8 59 f6 ff ff       	call   8010a0 <fd2data>
  801a47:	83 c4 08             	add    $0x8,%esp
  801a4a:	50                   	push   %eax
  801a4b:	6a 00                	push   $0x0
  801a4d:	e8 d2 f4 ff ff       	call   800f24 <sys_page_unmap>
}
  801a52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <_pipeisclosed>:
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	57                   	push   %edi
  801a5b:	56                   	push   %esi
  801a5c:	53                   	push   %ebx
  801a5d:	83 ec 1c             	sub    $0x1c,%esp
  801a60:	89 c7                	mov    %eax,%edi
  801a62:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a64:	a1 04 44 80 00       	mov    0x804404,%eax
  801a69:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a6c:	83 ec 0c             	sub    $0xc,%esp
  801a6f:	57                   	push   %edi
  801a70:	e8 ad 03 00 00       	call   801e22 <pageref>
  801a75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a78:	89 34 24             	mov    %esi,(%esp)
  801a7b:	e8 a2 03 00 00       	call   801e22 <pageref>
		nn = thisenv->env_runs;
  801a80:	8b 15 04 44 80 00    	mov    0x804404,%edx
  801a86:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	39 cb                	cmp    %ecx,%ebx
  801a8e:	74 1b                	je     801aab <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a90:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a93:	75 cf                	jne    801a64 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a95:	8b 42 58             	mov    0x58(%edx),%eax
  801a98:	6a 01                	push   $0x1
  801a9a:	50                   	push   %eax
  801a9b:	53                   	push   %ebx
  801a9c:	68 46 25 80 00       	push   $0x802546
  801aa1:	e8 f1 e8 ff ff       	call   800397 <cprintf>
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	eb b9                	jmp    801a64 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801aab:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801aae:	0f 94 c0             	sete   %al
  801ab1:	0f b6 c0             	movzbl %al,%eax
}
  801ab4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5f                   	pop    %edi
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    

00801abc <devpipe_write>:
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	57                   	push   %edi
  801ac0:	56                   	push   %esi
  801ac1:	53                   	push   %ebx
  801ac2:	83 ec 28             	sub    $0x28,%esp
  801ac5:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ac8:	56                   	push   %esi
  801ac9:	e8 d2 f5 ff ff       	call   8010a0 <fd2data>
  801ace:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ad0:	83 c4 10             	add    $0x10,%esp
  801ad3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ad8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801adb:	74 4f                	je     801b2c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801add:	8b 43 04             	mov    0x4(%ebx),%eax
  801ae0:	8b 0b                	mov    (%ebx),%ecx
  801ae2:	8d 51 20             	lea    0x20(%ecx),%edx
  801ae5:	39 d0                	cmp    %edx,%eax
  801ae7:	72 14                	jb     801afd <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ae9:	89 da                	mov    %ebx,%edx
  801aeb:	89 f0                	mov    %esi,%eax
  801aed:	e8 65 ff ff ff       	call   801a57 <_pipeisclosed>
  801af2:	85 c0                	test   %eax,%eax
  801af4:	75 3a                	jne    801b30 <devpipe_write+0x74>
			sys_yield();
  801af6:	e8 85 f3 ff ff       	call   800e80 <sys_yield>
  801afb:	eb e0                	jmp    801add <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801afd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b00:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b04:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b07:	89 c2                	mov    %eax,%edx
  801b09:	c1 fa 1f             	sar    $0x1f,%edx
  801b0c:	89 d1                	mov    %edx,%ecx
  801b0e:	c1 e9 1b             	shr    $0x1b,%ecx
  801b11:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b14:	83 e2 1f             	and    $0x1f,%edx
  801b17:	29 ca                	sub    %ecx,%edx
  801b19:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b1d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b21:	83 c0 01             	add    $0x1,%eax
  801b24:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b27:	83 c7 01             	add    $0x1,%edi
  801b2a:	eb ac                	jmp    801ad8 <devpipe_write+0x1c>
	return i;
  801b2c:	89 f8                	mov    %edi,%eax
  801b2e:	eb 05                	jmp    801b35 <devpipe_write+0x79>
				return 0;
  801b30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b38:	5b                   	pop    %ebx
  801b39:	5e                   	pop    %esi
  801b3a:	5f                   	pop    %edi
  801b3b:	5d                   	pop    %ebp
  801b3c:	c3                   	ret    

00801b3d <devpipe_read>:
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	57                   	push   %edi
  801b41:	56                   	push   %esi
  801b42:	53                   	push   %ebx
  801b43:	83 ec 18             	sub    $0x18,%esp
  801b46:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b49:	57                   	push   %edi
  801b4a:	e8 51 f5 ff ff       	call   8010a0 <fd2data>
  801b4f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b51:	83 c4 10             	add    $0x10,%esp
  801b54:	be 00 00 00 00       	mov    $0x0,%esi
  801b59:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b5c:	74 47                	je     801ba5 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801b5e:	8b 03                	mov    (%ebx),%eax
  801b60:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b63:	75 22                	jne    801b87 <devpipe_read+0x4a>
			if (i > 0)
  801b65:	85 f6                	test   %esi,%esi
  801b67:	75 14                	jne    801b7d <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801b69:	89 da                	mov    %ebx,%edx
  801b6b:	89 f8                	mov    %edi,%eax
  801b6d:	e8 e5 fe ff ff       	call   801a57 <_pipeisclosed>
  801b72:	85 c0                	test   %eax,%eax
  801b74:	75 33                	jne    801ba9 <devpipe_read+0x6c>
			sys_yield();
  801b76:	e8 05 f3 ff ff       	call   800e80 <sys_yield>
  801b7b:	eb e1                	jmp    801b5e <devpipe_read+0x21>
				return i;
  801b7d:	89 f0                	mov    %esi,%eax
}
  801b7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b82:	5b                   	pop    %ebx
  801b83:	5e                   	pop    %esi
  801b84:	5f                   	pop    %edi
  801b85:	5d                   	pop    %ebp
  801b86:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b87:	99                   	cltd   
  801b88:	c1 ea 1b             	shr    $0x1b,%edx
  801b8b:	01 d0                	add    %edx,%eax
  801b8d:	83 e0 1f             	and    $0x1f,%eax
  801b90:	29 d0                	sub    %edx,%eax
  801b92:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b9a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b9d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ba0:	83 c6 01             	add    $0x1,%esi
  801ba3:	eb b4                	jmp    801b59 <devpipe_read+0x1c>
	return i;
  801ba5:	89 f0                	mov    %esi,%eax
  801ba7:	eb d6                	jmp    801b7f <devpipe_read+0x42>
				return 0;
  801ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bae:	eb cf                	jmp    801b7f <devpipe_read+0x42>

00801bb0 <pipe>:
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	56                   	push   %esi
  801bb4:	53                   	push   %ebx
  801bb5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801bb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bbb:	50                   	push   %eax
  801bbc:	e8 f6 f4 ff ff       	call   8010b7 <fd_alloc>
  801bc1:	89 c3                	mov    %eax,%ebx
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	78 5b                	js     801c25 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bca:	83 ec 04             	sub    $0x4,%esp
  801bcd:	68 07 04 00 00       	push   $0x407
  801bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd5:	6a 00                	push   $0x0
  801bd7:	e8 c3 f2 ff ff       	call   800e9f <sys_page_alloc>
  801bdc:	89 c3                	mov    %eax,%ebx
  801bde:	83 c4 10             	add    $0x10,%esp
  801be1:	85 c0                	test   %eax,%eax
  801be3:	78 40                	js     801c25 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801be5:	83 ec 0c             	sub    $0xc,%esp
  801be8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801beb:	50                   	push   %eax
  801bec:	e8 c6 f4 ff ff       	call   8010b7 <fd_alloc>
  801bf1:	89 c3                	mov    %eax,%ebx
  801bf3:	83 c4 10             	add    $0x10,%esp
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	78 1b                	js     801c15 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bfa:	83 ec 04             	sub    $0x4,%esp
  801bfd:	68 07 04 00 00       	push   $0x407
  801c02:	ff 75 f0             	pushl  -0x10(%ebp)
  801c05:	6a 00                	push   $0x0
  801c07:	e8 93 f2 ff ff       	call   800e9f <sys_page_alloc>
  801c0c:	89 c3                	mov    %eax,%ebx
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	85 c0                	test   %eax,%eax
  801c13:	79 19                	jns    801c2e <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801c15:	83 ec 08             	sub    $0x8,%esp
  801c18:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1b:	6a 00                	push   $0x0
  801c1d:	e8 02 f3 ff ff       	call   800f24 <sys_page_unmap>
  801c22:	83 c4 10             	add    $0x10,%esp
}
  801c25:	89 d8                	mov    %ebx,%eax
  801c27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2a:	5b                   	pop    %ebx
  801c2b:	5e                   	pop    %esi
  801c2c:	5d                   	pop    %ebp
  801c2d:	c3                   	ret    
	va = fd2data(fd0);
  801c2e:	83 ec 0c             	sub    $0xc,%esp
  801c31:	ff 75 f4             	pushl  -0xc(%ebp)
  801c34:	e8 67 f4 ff ff       	call   8010a0 <fd2data>
  801c39:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c3b:	83 c4 0c             	add    $0xc,%esp
  801c3e:	68 07 04 00 00       	push   $0x407
  801c43:	50                   	push   %eax
  801c44:	6a 00                	push   $0x0
  801c46:	e8 54 f2 ff ff       	call   800e9f <sys_page_alloc>
  801c4b:	89 c3                	mov    %eax,%ebx
  801c4d:	83 c4 10             	add    $0x10,%esp
  801c50:	85 c0                	test   %eax,%eax
  801c52:	0f 88 8c 00 00 00    	js     801ce4 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c58:	83 ec 0c             	sub    $0xc,%esp
  801c5b:	ff 75 f0             	pushl  -0x10(%ebp)
  801c5e:	e8 3d f4 ff ff       	call   8010a0 <fd2data>
  801c63:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c6a:	50                   	push   %eax
  801c6b:	6a 00                	push   $0x0
  801c6d:	56                   	push   %esi
  801c6e:	6a 00                	push   $0x0
  801c70:	e8 6d f2 ff ff       	call   800ee2 <sys_page_map>
  801c75:	89 c3                	mov    %eax,%ebx
  801c77:	83 c4 20             	add    $0x20,%esp
  801c7a:	85 c0                	test   %eax,%eax
  801c7c:	78 58                	js     801cd6 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c81:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c87:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c96:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c9c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ca8:	83 ec 0c             	sub    $0xc,%esp
  801cab:	ff 75 f4             	pushl  -0xc(%ebp)
  801cae:	e8 dd f3 ff ff       	call   801090 <fd2num>
  801cb3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801cb8:	83 c4 04             	add    $0x4,%esp
  801cbb:	ff 75 f0             	pushl  -0x10(%ebp)
  801cbe:	e8 cd f3 ff ff       	call   801090 <fd2num>
  801cc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801cc9:	83 c4 10             	add    $0x10,%esp
  801ccc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cd1:	e9 4f ff ff ff       	jmp    801c25 <pipe+0x75>
	sys_page_unmap(0, va);
  801cd6:	83 ec 08             	sub    $0x8,%esp
  801cd9:	56                   	push   %esi
  801cda:	6a 00                	push   $0x0
  801cdc:	e8 43 f2 ff ff       	call   800f24 <sys_page_unmap>
  801ce1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ce4:	83 ec 08             	sub    $0x8,%esp
  801ce7:	ff 75 f0             	pushl  -0x10(%ebp)
  801cea:	6a 00                	push   $0x0
  801cec:	e8 33 f2 ff ff       	call   800f24 <sys_page_unmap>
  801cf1:	83 c4 10             	add    $0x10,%esp
  801cf4:	e9 1c ff ff ff       	jmp    801c15 <pipe+0x65>

00801cf9 <pipeisclosed>:
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d02:	50                   	push   %eax
  801d03:	ff 75 08             	pushl  0x8(%ebp)
  801d06:	e8 fb f3 ff ff       	call   801106 <fd_lookup>
  801d0b:	83 c4 10             	add    $0x10,%esp
  801d0e:	85 c0                	test   %eax,%eax
  801d10:	78 18                	js     801d2a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d12:	83 ec 0c             	sub    $0xc,%esp
  801d15:	ff 75 f4             	pushl  -0xc(%ebp)
  801d18:	e8 83 f3 ff ff       	call   8010a0 <fd2data>
	return _pipeisclosed(fd, p);
  801d1d:	89 c2                	mov    %eax,%edx
  801d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d22:	e8 30 fd ff ff       	call   801a57 <_pipeisclosed>
  801d27:	83 c4 10             	add    $0x10,%esp
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	56                   	push   %esi
  801d30:	53                   	push   %ebx
  801d31:	8b 75 08             	mov    0x8(%ebp),%esi
  801d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d37:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801d3a:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  801d3c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801d41:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  801d44:	83 ec 0c             	sub    $0xc,%esp
  801d47:	50                   	push   %eax
  801d48:	e8 02 f3 ff ff       	call   80104f <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  801d4d:	83 c4 10             	add    $0x10,%esp
  801d50:	85 c0                	test   %eax,%eax
  801d52:	78 2b                	js     801d7f <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  801d54:	85 f6                	test   %esi,%esi
  801d56:	74 0a                	je     801d62 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801d58:	a1 04 44 80 00       	mov    0x804404,%eax
  801d5d:	8b 40 74             	mov    0x74(%eax),%eax
  801d60:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  801d62:	85 db                	test   %ebx,%ebx
  801d64:	74 0a                	je     801d70 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801d66:	a1 04 44 80 00       	mov    0x804404,%eax
  801d6b:	8b 40 78             	mov    0x78(%eax),%eax
  801d6e:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801d70:	a1 04 44 80 00       	mov    0x804404,%eax
  801d75:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7b:	5b                   	pop    %ebx
  801d7c:	5e                   	pop    %esi
  801d7d:	5d                   	pop    %ebp
  801d7e:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  801d7f:	85 f6                	test   %esi,%esi
  801d81:	74 06                	je     801d89 <ipc_recv+0x5d>
  801d83:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801d89:	85 db                	test   %ebx,%ebx
  801d8b:	74 eb                	je     801d78 <ipc_recv+0x4c>
  801d8d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d93:	eb e3                	jmp    801d78 <ipc_recv+0x4c>

00801d95 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	57                   	push   %edi
  801d99:	56                   	push   %esi
  801d9a:	53                   	push   %ebx
  801d9b:	83 ec 0c             	sub    $0xc,%esp
  801d9e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801da1:	8b 75 0c             	mov    0xc(%ebp),%esi
  801da4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801da7:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  801da9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801dae:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801db1:	ff 75 14             	pushl  0x14(%ebp)
  801db4:	53                   	push   %ebx
  801db5:	56                   	push   %esi
  801db6:	57                   	push   %edi
  801db7:	e8 70 f2 ff ff       	call   80102c <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	74 1e                	je     801de1 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  801dc3:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801dc6:	75 07                	jne    801dcf <ipc_send+0x3a>
			sys_yield();
  801dc8:	e8 b3 f0 ff ff       	call   800e80 <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801dcd:	eb e2                	jmp    801db1 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  801dcf:	50                   	push   %eax
  801dd0:	68 5e 25 80 00       	push   $0x80255e
  801dd5:	6a 41                	push   $0x41
  801dd7:	68 6c 25 80 00       	push   $0x80256c
  801ddc:	e8 db e4 ff ff       	call   8002bc <_panic>
		}
	}
}
  801de1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de4:	5b                   	pop    %ebx
  801de5:	5e                   	pop    %esi
  801de6:	5f                   	pop    %edi
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    

00801de9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801def:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801df4:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801df7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801dfd:	8b 52 50             	mov    0x50(%edx),%edx
  801e00:	39 ca                	cmp    %ecx,%edx
  801e02:	74 11                	je     801e15 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801e04:	83 c0 01             	add    $0x1,%eax
  801e07:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e0c:	75 e6                	jne    801df4 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801e0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e13:	eb 0b                	jmp    801e20 <ipc_find_env+0x37>
			return envs[i].env_id;
  801e15:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e18:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801e1d:	8b 40 48             	mov    0x48(%eax),%eax
}
  801e20:	5d                   	pop    %ebp
  801e21:	c3                   	ret    

00801e22 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e28:	89 d0                	mov    %edx,%eax
  801e2a:	c1 e8 16             	shr    $0x16,%eax
  801e2d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e34:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801e39:	f6 c1 01             	test   $0x1,%cl
  801e3c:	74 1d                	je     801e5b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801e3e:	c1 ea 0c             	shr    $0xc,%edx
  801e41:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e48:	f6 c2 01             	test   $0x1,%dl
  801e4b:	74 0e                	je     801e5b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e4d:	c1 ea 0c             	shr    $0xc,%edx
  801e50:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e57:	ef 
  801e58:	0f b7 c0             	movzwl %ax,%eax
}
  801e5b:	5d                   	pop    %ebp
  801e5c:	c3                   	ret    
  801e5d:	66 90                	xchg   %ax,%ax
  801e5f:	90                   	nop

00801e60 <__udivdi3>:
  801e60:	55                   	push   %ebp
  801e61:	57                   	push   %edi
  801e62:	56                   	push   %esi
  801e63:	53                   	push   %ebx
  801e64:	83 ec 1c             	sub    $0x1c,%esp
  801e67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801e6b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801e6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e73:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801e77:	85 d2                	test   %edx,%edx
  801e79:	75 35                	jne    801eb0 <__udivdi3+0x50>
  801e7b:	39 f3                	cmp    %esi,%ebx
  801e7d:	0f 87 bd 00 00 00    	ja     801f40 <__udivdi3+0xe0>
  801e83:	85 db                	test   %ebx,%ebx
  801e85:	89 d9                	mov    %ebx,%ecx
  801e87:	75 0b                	jne    801e94 <__udivdi3+0x34>
  801e89:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8e:	31 d2                	xor    %edx,%edx
  801e90:	f7 f3                	div    %ebx
  801e92:	89 c1                	mov    %eax,%ecx
  801e94:	31 d2                	xor    %edx,%edx
  801e96:	89 f0                	mov    %esi,%eax
  801e98:	f7 f1                	div    %ecx
  801e9a:	89 c6                	mov    %eax,%esi
  801e9c:	89 e8                	mov    %ebp,%eax
  801e9e:	89 f7                	mov    %esi,%edi
  801ea0:	f7 f1                	div    %ecx
  801ea2:	89 fa                	mov    %edi,%edx
  801ea4:	83 c4 1c             	add    $0x1c,%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5f                   	pop    %edi
  801eaa:	5d                   	pop    %ebp
  801eab:	c3                   	ret    
  801eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801eb0:	39 f2                	cmp    %esi,%edx
  801eb2:	77 7c                	ja     801f30 <__udivdi3+0xd0>
  801eb4:	0f bd fa             	bsr    %edx,%edi
  801eb7:	83 f7 1f             	xor    $0x1f,%edi
  801eba:	0f 84 98 00 00 00    	je     801f58 <__udivdi3+0xf8>
  801ec0:	89 f9                	mov    %edi,%ecx
  801ec2:	b8 20 00 00 00       	mov    $0x20,%eax
  801ec7:	29 f8                	sub    %edi,%eax
  801ec9:	d3 e2                	shl    %cl,%edx
  801ecb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ecf:	89 c1                	mov    %eax,%ecx
  801ed1:	89 da                	mov    %ebx,%edx
  801ed3:	d3 ea                	shr    %cl,%edx
  801ed5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801ed9:	09 d1                	or     %edx,%ecx
  801edb:	89 f2                	mov    %esi,%edx
  801edd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ee1:	89 f9                	mov    %edi,%ecx
  801ee3:	d3 e3                	shl    %cl,%ebx
  801ee5:	89 c1                	mov    %eax,%ecx
  801ee7:	d3 ea                	shr    %cl,%edx
  801ee9:	89 f9                	mov    %edi,%ecx
  801eeb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801eef:	d3 e6                	shl    %cl,%esi
  801ef1:	89 eb                	mov    %ebp,%ebx
  801ef3:	89 c1                	mov    %eax,%ecx
  801ef5:	d3 eb                	shr    %cl,%ebx
  801ef7:	09 de                	or     %ebx,%esi
  801ef9:	89 f0                	mov    %esi,%eax
  801efb:	f7 74 24 08          	divl   0x8(%esp)
  801eff:	89 d6                	mov    %edx,%esi
  801f01:	89 c3                	mov    %eax,%ebx
  801f03:	f7 64 24 0c          	mull   0xc(%esp)
  801f07:	39 d6                	cmp    %edx,%esi
  801f09:	72 0c                	jb     801f17 <__udivdi3+0xb7>
  801f0b:	89 f9                	mov    %edi,%ecx
  801f0d:	d3 e5                	shl    %cl,%ebp
  801f0f:	39 c5                	cmp    %eax,%ebp
  801f11:	73 5d                	jae    801f70 <__udivdi3+0x110>
  801f13:	39 d6                	cmp    %edx,%esi
  801f15:	75 59                	jne    801f70 <__udivdi3+0x110>
  801f17:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f1a:	31 ff                	xor    %edi,%edi
  801f1c:	89 fa                	mov    %edi,%edx
  801f1e:	83 c4 1c             	add    $0x1c,%esp
  801f21:	5b                   	pop    %ebx
  801f22:	5e                   	pop    %esi
  801f23:	5f                   	pop    %edi
  801f24:	5d                   	pop    %ebp
  801f25:	c3                   	ret    
  801f26:	8d 76 00             	lea    0x0(%esi),%esi
  801f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801f30:	31 ff                	xor    %edi,%edi
  801f32:	31 c0                	xor    %eax,%eax
  801f34:	89 fa                	mov    %edi,%edx
  801f36:	83 c4 1c             	add    $0x1c,%esp
  801f39:	5b                   	pop    %ebx
  801f3a:	5e                   	pop    %esi
  801f3b:	5f                   	pop    %edi
  801f3c:	5d                   	pop    %ebp
  801f3d:	c3                   	ret    
  801f3e:	66 90                	xchg   %ax,%ax
  801f40:	31 ff                	xor    %edi,%edi
  801f42:	89 e8                	mov    %ebp,%eax
  801f44:	89 f2                	mov    %esi,%edx
  801f46:	f7 f3                	div    %ebx
  801f48:	89 fa                	mov    %edi,%edx
  801f4a:	83 c4 1c             	add    $0x1c,%esp
  801f4d:	5b                   	pop    %ebx
  801f4e:	5e                   	pop    %esi
  801f4f:	5f                   	pop    %edi
  801f50:	5d                   	pop    %ebp
  801f51:	c3                   	ret    
  801f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f58:	39 f2                	cmp    %esi,%edx
  801f5a:	72 06                	jb     801f62 <__udivdi3+0x102>
  801f5c:	31 c0                	xor    %eax,%eax
  801f5e:	39 eb                	cmp    %ebp,%ebx
  801f60:	77 d2                	ja     801f34 <__udivdi3+0xd4>
  801f62:	b8 01 00 00 00       	mov    $0x1,%eax
  801f67:	eb cb                	jmp    801f34 <__udivdi3+0xd4>
  801f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f70:	89 d8                	mov    %ebx,%eax
  801f72:	31 ff                	xor    %edi,%edi
  801f74:	eb be                	jmp    801f34 <__udivdi3+0xd4>
  801f76:	66 90                	xchg   %ax,%ax
  801f78:	66 90                	xchg   %ax,%ax
  801f7a:	66 90                	xchg   %ax,%ax
  801f7c:	66 90                	xchg   %ax,%ax
  801f7e:	66 90                	xchg   %ax,%ax

00801f80 <__umoddi3>:
  801f80:	55                   	push   %ebp
  801f81:	57                   	push   %edi
  801f82:	56                   	push   %esi
  801f83:	53                   	push   %ebx
  801f84:	83 ec 1c             	sub    $0x1c,%esp
  801f87:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801f8b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801f8f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801f93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f97:	85 ed                	test   %ebp,%ebp
  801f99:	89 f0                	mov    %esi,%eax
  801f9b:	89 da                	mov    %ebx,%edx
  801f9d:	75 19                	jne    801fb8 <__umoddi3+0x38>
  801f9f:	39 df                	cmp    %ebx,%edi
  801fa1:	0f 86 b1 00 00 00    	jbe    802058 <__umoddi3+0xd8>
  801fa7:	f7 f7                	div    %edi
  801fa9:	89 d0                	mov    %edx,%eax
  801fab:	31 d2                	xor    %edx,%edx
  801fad:	83 c4 1c             	add    $0x1c,%esp
  801fb0:	5b                   	pop    %ebx
  801fb1:	5e                   	pop    %esi
  801fb2:	5f                   	pop    %edi
  801fb3:	5d                   	pop    %ebp
  801fb4:	c3                   	ret    
  801fb5:	8d 76 00             	lea    0x0(%esi),%esi
  801fb8:	39 dd                	cmp    %ebx,%ebp
  801fba:	77 f1                	ja     801fad <__umoddi3+0x2d>
  801fbc:	0f bd cd             	bsr    %ebp,%ecx
  801fbf:	83 f1 1f             	xor    $0x1f,%ecx
  801fc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fc6:	0f 84 b4 00 00 00    	je     802080 <__umoddi3+0x100>
  801fcc:	b8 20 00 00 00       	mov    $0x20,%eax
  801fd1:	89 c2                	mov    %eax,%edx
  801fd3:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fd7:	29 c2                	sub    %eax,%edx
  801fd9:	89 c1                	mov    %eax,%ecx
  801fdb:	89 f8                	mov    %edi,%eax
  801fdd:	d3 e5                	shl    %cl,%ebp
  801fdf:	89 d1                	mov    %edx,%ecx
  801fe1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fe5:	d3 e8                	shr    %cl,%eax
  801fe7:	09 c5                	or     %eax,%ebp
  801fe9:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fed:	89 c1                	mov    %eax,%ecx
  801fef:	d3 e7                	shl    %cl,%edi
  801ff1:	89 d1                	mov    %edx,%ecx
  801ff3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801ff7:	89 df                	mov    %ebx,%edi
  801ff9:	d3 ef                	shr    %cl,%edi
  801ffb:	89 c1                	mov    %eax,%ecx
  801ffd:	89 f0                	mov    %esi,%eax
  801fff:	d3 e3                	shl    %cl,%ebx
  802001:	89 d1                	mov    %edx,%ecx
  802003:	89 fa                	mov    %edi,%edx
  802005:	d3 e8                	shr    %cl,%eax
  802007:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80200c:	09 d8                	or     %ebx,%eax
  80200e:	f7 f5                	div    %ebp
  802010:	d3 e6                	shl    %cl,%esi
  802012:	89 d1                	mov    %edx,%ecx
  802014:	f7 64 24 08          	mull   0x8(%esp)
  802018:	39 d1                	cmp    %edx,%ecx
  80201a:	89 c3                	mov    %eax,%ebx
  80201c:	89 d7                	mov    %edx,%edi
  80201e:	72 06                	jb     802026 <__umoddi3+0xa6>
  802020:	75 0e                	jne    802030 <__umoddi3+0xb0>
  802022:	39 c6                	cmp    %eax,%esi
  802024:	73 0a                	jae    802030 <__umoddi3+0xb0>
  802026:	2b 44 24 08          	sub    0x8(%esp),%eax
  80202a:	19 ea                	sbb    %ebp,%edx
  80202c:	89 d7                	mov    %edx,%edi
  80202e:	89 c3                	mov    %eax,%ebx
  802030:	89 ca                	mov    %ecx,%edx
  802032:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802037:	29 de                	sub    %ebx,%esi
  802039:	19 fa                	sbb    %edi,%edx
  80203b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80203f:	89 d0                	mov    %edx,%eax
  802041:	d3 e0                	shl    %cl,%eax
  802043:	89 d9                	mov    %ebx,%ecx
  802045:	d3 ee                	shr    %cl,%esi
  802047:	d3 ea                	shr    %cl,%edx
  802049:	09 f0                	or     %esi,%eax
  80204b:	83 c4 1c             	add    $0x1c,%esp
  80204e:	5b                   	pop    %ebx
  80204f:	5e                   	pop    %esi
  802050:	5f                   	pop    %edi
  802051:	5d                   	pop    %ebp
  802052:	c3                   	ret    
  802053:	90                   	nop
  802054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802058:	85 ff                	test   %edi,%edi
  80205a:	89 f9                	mov    %edi,%ecx
  80205c:	75 0b                	jne    802069 <__umoddi3+0xe9>
  80205e:	b8 01 00 00 00       	mov    $0x1,%eax
  802063:	31 d2                	xor    %edx,%edx
  802065:	f7 f7                	div    %edi
  802067:	89 c1                	mov    %eax,%ecx
  802069:	89 d8                	mov    %ebx,%eax
  80206b:	31 d2                	xor    %edx,%edx
  80206d:	f7 f1                	div    %ecx
  80206f:	89 f0                	mov    %esi,%eax
  802071:	f7 f1                	div    %ecx
  802073:	e9 31 ff ff ff       	jmp    801fa9 <__umoddi3+0x29>
  802078:	90                   	nop
  802079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802080:	39 dd                	cmp    %ebx,%ebp
  802082:	72 08                	jb     80208c <__umoddi3+0x10c>
  802084:	39 f7                	cmp    %esi,%edi
  802086:	0f 87 21 ff ff ff    	ja     801fad <__umoddi3+0x2d>
  80208c:	89 da                	mov    %ebx,%edx
  80208e:	89 f0                	mov    %esi,%eax
  802090:	29 f8                	sub    %edi,%eax
  802092:	19 ea                	sbb    %ebp,%edx
  802094:	e9 14 ff ff ff       	jmp    801fad <__umoddi3+0x2d>
