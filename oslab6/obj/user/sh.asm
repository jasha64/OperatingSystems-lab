
obj/user/sh.debug：     文件格式 elf32-i386


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
  80002c:	e8 aa 09 00 00       	call   8009db <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int t;

	if (s == 0) {
  80003b:	85 db                	test   %ebx,%ebx
  80003d:	74 1d                	je     80005c <_gettoken+0x29>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
  80003f:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800046:	7f 34                	jg     80007c <_gettoken+0x49>
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
  800048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80004b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*p2 = 0;
  800051:	8b 45 10             	mov    0x10(%ebp),%eax
  800054:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  80005a:	eb 3a                	jmp    800096 <_gettoken+0x63>
		return 0;
  80005c:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  800061:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800068:	7e 59                	jle    8000c3 <_gettoken+0x90>
			cprintf("GETTOKEN NULL\n");
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	68 60 32 80 00       	push   $0x803260
  800072:	e8 97 0a 00 00       	call   800b0e <cprintf>
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	eb 47                	jmp    8000c3 <_gettoken+0x90>
		cprintf("GETTOKEN: %s\n", s);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	53                   	push   %ebx
  800080:	68 6f 32 80 00       	push   $0x80326f
  800085:	e8 84 0a 00 00       	call   800b0e <cprintf>
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	eb b9                	jmp    800048 <_gettoken+0x15>
		*s++ = 0;
  80008f:	83 c3 01             	add    $0x1,%ebx
  800092:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
	while (strchr(WHITESPACE, *s))
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	0f be 03             	movsbl (%ebx),%eax
  80009c:	50                   	push   %eax
  80009d:	68 7d 32 80 00       	push   $0x80327d
  8000a2:	e8 7a 12 00 00       	call   801321 <strchr>
  8000a7:	83 c4 10             	add    $0x10,%esp
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	75 e1                	jne    80008f <_gettoken+0x5c>
	if (*s == 0) {
  8000ae:	0f b6 03             	movzbl (%ebx),%eax
  8000b1:	84 c0                	test   %al,%al
  8000b3:	75 29                	jne    8000de <_gettoken+0xab>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000b5:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  8000ba:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  8000c1:	7f 09                	jg     8000cc <_gettoken+0x99>
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}
  8000c3:	89 f0                	mov    %esi,%eax
  8000c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c8:	5b                   	pop    %ebx
  8000c9:	5e                   	pop    %esi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    
			cprintf("EOL\n");
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	68 82 32 80 00       	push   $0x803282
  8000d4:	e8 35 0a 00 00       	call   800b0e <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	eb e5                	jmp    8000c3 <_gettoken+0x90>
	if (strchr(SYMBOLS, *s)) {
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	0f be c0             	movsbl %al,%eax
  8000e4:	50                   	push   %eax
  8000e5:	68 93 32 80 00       	push   $0x803293
  8000ea:	e8 32 12 00 00       	call   801321 <strchr>
  8000ef:	83 c4 10             	add    $0x10,%esp
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	74 2f                	je     800125 <_gettoken+0xf2>
		t = *s;
  8000f6:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  8000f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000fc:	89 18                	mov    %ebx,(%eax)
		*s++ = 0;
  8000fe:	c6 03 00             	movb   $0x0,(%ebx)
  800101:	83 c3 01             	add    $0x1,%ebx
  800104:	8b 45 10             	mov    0x10(%ebp),%eax
  800107:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
  800109:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800110:	7e b1                	jle    8000c3 <_gettoken+0x90>
			cprintf("TOK %c\n", t);
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	56                   	push   %esi
  800116:	68 87 32 80 00       	push   $0x803287
  80011b:	e8 ee 09 00 00       	call   800b0e <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	eb 9e                	jmp    8000c3 <_gettoken+0x90>
	*p1 = s;
  800125:	8b 45 0c             	mov    0xc(%ebp),%eax
  800128:	89 18                	mov    %ebx,(%eax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012a:	eb 03                	jmp    80012f <_gettoken+0xfc>
		s++;
  80012c:	83 c3 01             	add    $0x1,%ebx
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012f:	0f b6 03             	movzbl (%ebx),%eax
  800132:	84 c0                	test   %al,%al
  800134:	74 18                	je     80014e <_gettoken+0x11b>
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	0f be c0             	movsbl %al,%eax
  80013c:	50                   	push   %eax
  80013d:	68 8f 32 80 00       	push   $0x80328f
  800142:	e8 da 11 00 00       	call   801321 <strchr>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	85 c0                	test   %eax,%eax
  80014c:	74 de                	je     80012c <_gettoken+0xf9>
	*p2 = s;
  80014e:	8b 45 10             	mov    0x10(%ebp),%eax
  800151:	89 18                	mov    %ebx,(%eax)
	return 'w';
  800153:	be 77 00 00 00       	mov    $0x77,%esi
	if (debug > 1) {
  800158:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80015f:	0f 8e 5e ff ff ff    	jle    8000c3 <_gettoken+0x90>
		t = **p2;
  800165:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  800168:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016b:	83 ec 08             	sub    $0x8,%esp
  80016e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800171:	ff 30                	pushl  (%eax)
  800173:	68 9b 32 80 00       	push   $0x80329b
  800178:	e8 91 09 00 00       	call   800b0e <cprintf>
		**p2 = t;
  80017d:	8b 45 10             	mov    0x10(%ebp),%eax
  800180:	8b 00                	mov    (%eax),%eax
  800182:	89 f2                	mov    %esi,%edx
  800184:	88 10                	mov    %dl,(%eax)
  800186:	83 c4 10             	add    $0x10,%esp
	return 'w';
  800189:	be 77 00 00 00       	mov    $0x77,%esi
  80018e:	e9 30 ff ff ff       	jmp    8000c3 <_gettoken+0x90>

00800193 <gettoken>:

int
gettoken(char *s, char **p1)
{
  800193:	55                   	push   %ebp
  800194:	89 e5                	mov    %esp,%ebp
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  80019c:	85 c0                	test   %eax,%eax
  80019e:	74 22                	je     8001c2 <gettoken+0x2f>
		nc = _gettoken(s, &np1, &np2);
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	68 0c 50 80 00       	push   $0x80500c
  8001a8:	68 10 50 80 00       	push   $0x805010
  8001ad:	50                   	push   %eax
  8001ae:	e8 80 fe ff ff       	call   800033 <_gettoken>
  8001b3:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8001b8:	83 c4 10             	add    $0x10,%esp
  8001bb:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    
	c = nc;
  8001c2:	a1 08 50 80 00       	mov    0x805008,%eax
  8001c7:	a3 04 50 80 00       	mov    %eax,0x805004
	*p1 = np1;
  8001cc:	8b 15 10 50 80 00    	mov    0x805010,%edx
  8001d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d5:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	68 0c 50 80 00       	push   $0x80500c
  8001df:	68 10 50 80 00       	push   $0x805010
  8001e4:	ff 35 0c 50 80 00    	pushl  0x80500c
  8001ea:	e8 44 fe ff ff       	call   800033 <_gettoken>
  8001ef:	a3 08 50 80 00       	mov    %eax,0x805008
	return c;
  8001f4:	a1 04 50 80 00       	mov    0x805004,%eax
  8001f9:	83 c4 10             	add    $0x10,%esp
  8001fc:	eb c2                	jmp    8001c0 <gettoken+0x2d>

008001fe <runcmd>:
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	57                   	push   %edi
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	81 ec 64 04 00 00    	sub    $0x464,%esp
	gettoken(s, 0);
  80020a:	6a 00                	push   $0x0
  80020c:	ff 75 08             	pushl  0x8(%ebp)
  80020f:	e8 7f ff ff ff       	call   800193 <gettoken>
  800214:	83 c4 10             	add    $0x10,%esp
		switch ((c = gettoken(0, &t))) {
  800217:	8d 7d a4             	lea    -0x5c(%ebp),%edi
	argc = 0;
  80021a:	be 00 00 00 00       	mov    $0x0,%esi
		switch ((c = gettoken(0, &t))) {
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	57                   	push   %edi
  800223:	6a 00                	push   $0x0
  800225:	e8 69 ff ff ff       	call   800193 <gettoken>
  80022a:	89 c3                	mov    %eax,%ebx
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	83 f8 3e             	cmp    $0x3e,%eax
  800232:	0f 84 1a 01 00 00    	je     800352 <runcmd+0x154>
  800238:	83 f8 3e             	cmp    $0x3e,%eax
  80023b:	7e 74                	jle    8002b1 <runcmd+0xb3>
  80023d:	83 f8 77             	cmp    $0x77,%eax
  800240:	0f 84 e1 00 00 00    	je     800327 <runcmd+0x129>
  800246:	83 f8 7c             	cmp    $0x7c,%eax
  800249:	0f 85 37 02 00 00    	jne    800486 <runcmd+0x288>
			if ((r = pipe(p)) < 0) {
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  800258:	50                   	push   %eax
  800259:	e8 47 2a 00 00       	call   802ca5 <pipe>
  80025e:	83 c4 10             	add    $0x10,%esp
  800261:	85 c0                	test   %eax,%eax
  800263:	0f 88 6b 01 00 00    	js     8003d4 <runcmd+0x1d6>
			if (debug)
  800269:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800270:	0f 85 79 01 00 00    	jne    8003ef <runcmd+0x1f1>
			if ((r = fork()) < 0) {
  800276:	e8 5c 16 00 00       	call   8018d7 <fork>
  80027b:	89 c3                	mov    %eax,%ebx
  80027d:	85 c0                	test   %eax,%eax
  80027f:	0f 88 8b 01 00 00    	js     800410 <runcmd+0x212>
			if (r == 0) {
  800285:	85 c0                	test   %eax,%eax
  800287:	0f 85 99 01 00 00    	jne    800426 <runcmd+0x228>
				if (p[0] != 0) {
  80028d:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800293:	85 c0                	test   %eax,%eax
  800295:	0f 85 ac 01 00 00    	jne    800447 <runcmd+0x249>
				close(p[1]);
  80029b:	83 ec 0c             	sub    $0xc,%esp
  80029e:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8002a4:	e8 19 1b 00 00       	call   801dc2 <close>
				goto again;
  8002a9:	83 c4 10             	add    $0x10,%esp
  8002ac:	e9 69 ff ff ff       	jmp    80021a <runcmd+0x1c>
		switch ((c = gettoken(0, &t))) {
  8002b1:	85 c0                	test   %eax,%eax
  8002b3:	75 2a                	jne    8002df <runcmd+0xe1>
	if(argc == 0) {
  8002b5:	85 f6                	test   %esi,%esi
  8002b7:	0f 85 db 01 00 00    	jne    800498 <runcmd+0x29a>
		if (debug)
  8002bd:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8002c4:	0f 84 58 02 00 00    	je     800522 <runcmd+0x324>
			cprintf("EMPTY COMMAND\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 29 33 80 00       	push   $0x803329
  8002d2:	e8 37 08 00 00       	call   800b0e <cprintf>
  8002d7:	83 c4 10             	add    $0x10,%esp
  8002da:	e9 43 02 00 00       	jmp    800522 <runcmd+0x324>
		switch ((c = gettoken(0, &t))) {
  8002df:	83 f8 3c             	cmp    $0x3c,%eax
  8002e2:	0f 85 9e 01 00 00    	jne    800486 <runcmd+0x288>
			if (gettoken(0, &t) != 'w') {
  8002e8:	83 ec 08             	sub    $0x8,%esp
  8002eb:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  8002ee:	50                   	push   %eax
  8002ef:	6a 00                	push   $0x0
  8002f1:	e8 9d fe ff ff       	call   800193 <gettoken>
  8002f6:	83 c4 10             	add    $0x10,%esp
  8002f9:	83 f8 77             	cmp    $0x77,%eax
  8002fc:	74 15                	je     800313 <runcmd+0x115>
				cprintf("syntax error: < not followed by word\n");
  8002fe:	83 ec 0c             	sub    $0xc,%esp
  800301:	68 f8 33 80 00       	push   $0x8033f8
  800306:	e8 03 08 00 00       	call   800b0e <cprintf>
				exit();
  80030b:	e8 11 07 00 00       	call   800a21 <exit>
  800310:	83 c4 10             	add    $0x10,%esp
			panic("< redirection not implemented");
  800313:	83 ec 04             	sub    $0x4,%esp
  800316:	68 b9 32 80 00       	push   $0x8032b9
  80031b:	6a 3a                	push   $0x3a
  80031d:	68 d7 32 80 00       	push   $0x8032d7
  800322:	e8 0c 07 00 00       	call   800a33 <_panic>
			if (argc == MAXARGS) {
  800327:	83 fe 10             	cmp    $0x10,%esi
  80032a:	74 0f                	je     80033b <runcmd+0x13d>
			argv[argc++] = t;
  80032c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80032f:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
  800333:	8d 76 01             	lea    0x1(%esi),%esi
			break;
  800336:	e9 e4 fe ff ff       	jmp    80021f <runcmd+0x21>
				cprintf("too many arguments\n");
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 a5 32 80 00       	push   $0x8032a5
  800343:	e8 c6 07 00 00       	call   800b0e <cprintf>
				exit();
  800348:	e8 d4 06 00 00       	call   800a21 <exit>
  80034d:	83 c4 10             	add    $0x10,%esp
  800350:	eb da                	jmp    80032c <runcmd+0x12e>
			if (gettoken(0, &t) != 'w') {
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	57                   	push   %edi
  800356:	6a 00                	push   $0x0
  800358:	e8 36 fe ff ff       	call   800193 <gettoken>
  80035d:	83 c4 10             	add    $0x10,%esp
  800360:	83 f8 77             	cmp    $0x77,%eax
  800363:	75 3d                	jne    8003a2 <runcmd+0x1a4>
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800365:	83 ec 08             	sub    $0x8,%esp
  800368:	68 01 03 00 00       	push   $0x301
  80036d:	ff 75 a4             	pushl  -0x5c(%ebp)
  800370:	e8 37 20 00 00       	call   8023ac <open>
  800375:	89 c3                	mov    %eax,%ebx
  800377:	83 c4 10             	add    $0x10,%esp
  80037a:	85 c0                	test   %eax,%eax
  80037c:	78 3b                	js     8003b9 <runcmd+0x1bb>
			if (fd != 1) {
  80037e:	83 fb 01             	cmp    $0x1,%ebx
  800381:	0f 84 98 fe ff ff    	je     80021f <runcmd+0x21>
				dup(fd, 1);
  800387:	83 ec 08             	sub    $0x8,%esp
  80038a:	6a 01                	push   $0x1
  80038c:	53                   	push   %ebx
  80038d:	e8 80 1a 00 00       	call   801e12 <dup>
				close(fd);
  800392:	89 1c 24             	mov    %ebx,(%esp)
  800395:	e8 28 1a 00 00       	call   801dc2 <close>
  80039a:	83 c4 10             	add    $0x10,%esp
  80039d:	e9 7d fe ff ff       	jmp    80021f <runcmd+0x21>
				cprintf("syntax error: > not followed by word\n");
  8003a2:	83 ec 0c             	sub    $0xc,%esp
  8003a5:	68 20 34 80 00       	push   $0x803420
  8003aa:	e8 5f 07 00 00       	call   800b0e <cprintf>
				exit();
  8003af:	e8 6d 06 00 00       	call   800a21 <exit>
  8003b4:	83 c4 10             	add    $0x10,%esp
  8003b7:	eb ac                	jmp    800365 <runcmd+0x167>
				cprintf("open %s for write: %e", t, fd);
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	50                   	push   %eax
  8003bd:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003c0:	68 e1 32 80 00       	push   $0x8032e1
  8003c5:	e8 44 07 00 00       	call   800b0e <cprintf>
				exit();
  8003ca:	e8 52 06 00 00       	call   800a21 <exit>
  8003cf:	83 c4 10             	add    $0x10,%esp
  8003d2:	eb aa                	jmp    80037e <runcmd+0x180>
				cprintf("pipe: %e", r);
  8003d4:	83 ec 08             	sub    $0x8,%esp
  8003d7:	50                   	push   %eax
  8003d8:	68 f7 32 80 00       	push   $0x8032f7
  8003dd:	e8 2c 07 00 00       	call   800b0e <cprintf>
				exit();
  8003e2:	e8 3a 06 00 00       	call   800a21 <exit>
  8003e7:	83 c4 10             	add    $0x10,%esp
  8003ea:	e9 7a fe ff ff       	jmp    800269 <runcmd+0x6b>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  8003ef:	83 ec 04             	sub    $0x4,%esp
  8003f2:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8003f8:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  8003fe:	68 00 33 80 00       	push   $0x803300
  800403:	e8 06 07 00 00       	call   800b0e <cprintf>
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	e9 66 fe ff ff       	jmp    800276 <runcmd+0x78>
				cprintf("fork: %e", r);
  800410:	83 ec 08             	sub    $0x8,%esp
  800413:	50                   	push   %eax
  800414:	68 35 38 80 00       	push   $0x803835
  800419:	e8 f0 06 00 00       	call   800b0e <cprintf>
				exit();
  80041e:	e8 fe 05 00 00       	call   800a21 <exit>
  800423:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  800426:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80042c:	83 f8 01             	cmp    $0x1,%eax
  80042f:	75 37                	jne    800468 <runcmd+0x26a>
				close(p[0]);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80043a:	e8 83 19 00 00       	call   801dc2 <close>
				goto runit;
  80043f:	83 c4 10             	add    $0x10,%esp
  800442:	e9 6e fe ff ff       	jmp    8002b5 <runcmd+0xb7>
					dup(p[0], 0);
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	6a 00                	push   $0x0
  80044c:	50                   	push   %eax
  80044d:	e8 c0 19 00 00       	call   801e12 <dup>
					close(p[0]);
  800452:	83 c4 04             	add    $0x4,%esp
  800455:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80045b:	e8 62 19 00 00       	call   801dc2 <close>
  800460:	83 c4 10             	add    $0x10,%esp
  800463:	e9 33 fe ff ff       	jmp    80029b <runcmd+0x9d>
					dup(p[1], 1);
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	6a 01                	push   $0x1
  80046d:	50                   	push   %eax
  80046e:	e8 9f 19 00 00       	call   801e12 <dup>
					close(p[1]);
  800473:	83 c4 04             	add    $0x4,%esp
  800476:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80047c:	e8 41 19 00 00       	call   801dc2 <close>
  800481:	83 c4 10             	add    $0x10,%esp
  800484:	eb ab                	jmp    800431 <runcmd+0x233>
			panic("bad return %d from gettoken", c);
  800486:	53                   	push   %ebx
  800487:	68 0d 33 80 00       	push   $0x80330d
  80048c:	6a 70                	push   $0x70
  80048e:	68 d7 32 80 00       	push   $0x8032d7
  800493:	e8 9b 05 00 00       	call   800a33 <_panic>
	if (argv[0][0] != '/') {
  800498:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80049b:	80 38 2f             	cmpb   $0x2f,(%eax)
  80049e:	0f 85 86 00 00 00    	jne    80052a <runcmd+0x32c>
	argv[argc] = 0;
  8004a4:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
  8004ab:	00 
	if (debug) {
  8004ac:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004b3:	0f 85 99 00 00 00    	jne    800552 <runcmd+0x354>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	8d 45 a8             	lea    -0x58(%ebp),%eax
  8004bf:	50                   	push   %eax
  8004c0:	ff 75 a8             	pushl  -0x58(%ebp)
  8004c3:	e8 9e 20 00 00       	call   802566 <spawn>
  8004c8:	89 c6                	mov    %eax,%esi
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	85 c0                	test   %eax,%eax
  8004cf:	0f 88 cb 00 00 00    	js     8005a0 <runcmd+0x3a2>
	close_all();
  8004d5:	e8 13 19 00 00       	call   801ded <close_all>
		if (debug)
  8004da:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004e1:	0f 85 06 01 00 00    	jne    8005ed <runcmd+0x3ef>
		wait(r);
  8004e7:	83 ec 0c             	sub    $0xc,%esp
  8004ea:	56                   	push   %esi
  8004eb:	e8 31 29 00 00       	call   802e21 <wait>
		if (debug)
  8004f0:	83 c4 10             	add    $0x10,%esp
  8004f3:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004fa:	0f 85 0c 01 00 00    	jne    80060c <runcmd+0x40e>
	if (pipe_child) {
  800500:	85 db                	test   %ebx,%ebx
  800502:	74 19                	je     80051d <runcmd+0x31f>
		wait(pipe_child);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	53                   	push   %ebx
  800508:	e8 14 29 00 00       	call   802e21 <wait>
		if (debug)
  80050d:	83 c4 10             	add    $0x10,%esp
  800510:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800517:	0f 85 0a 01 00 00    	jne    800627 <runcmd+0x429>
	exit();
  80051d:	e8 ff 04 00 00       	call   800a21 <exit>
}
  800522:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800525:	5b                   	pop    %ebx
  800526:	5e                   	pop    %esi
  800527:	5f                   	pop    %edi
  800528:	5d                   	pop    %ebp
  800529:	c3                   	ret    
		argv0buf[0] = '/';
  80052a:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	50                   	push   %eax
  800535:	8d bd a4 fb ff ff    	lea    -0x45c(%ebp),%edi
  80053b:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  800541:	50                   	push   %eax
  800542:	e8 d6 0c 00 00       	call   80121d <strcpy>
		argv[0] = argv0buf;
  800547:	89 7d a8             	mov    %edi,-0x58(%ebp)
  80054a:	83 c4 10             	add    $0x10,%esp
  80054d:	e9 52 ff ff ff       	jmp    8004a4 <runcmd+0x2a6>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  800552:	a1 24 54 80 00       	mov    0x805424,%eax
  800557:	8b 40 48             	mov    0x48(%eax),%eax
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	50                   	push   %eax
  80055e:	68 38 33 80 00       	push   $0x803338
  800563:	e8 a6 05 00 00       	call   800b0e <cprintf>
  800568:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  80056b:	83 c4 10             	add    $0x10,%esp
  80056e:	eb 11                	jmp    800581 <runcmd+0x383>
			cprintf(" %s", argv[i]);
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	50                   	push   %eax
  800574:	68 c0 33 80 00       	push   $0x8033c0
  800579:	e8 90 05 00 00       	call   800b0e <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
  800581:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  800584:	8b 46 fc             	mov    -0x4(%esi),%eax
  800587:	85 c0                	test   %eax,%eax
  800589:	75 e5                	jne    800570 <runcmd+0x372>
		cprintf("\n");
  80058b:	83 ec 0c             	sub    $0xc,%esp
  80058e:	68 80 32 80 00       	push   $0x803280
  800593:	e8 76 05 00 00       	call   800b0e <cprintf>
  800598:	83 c4 10             	add    $0x10,%esp
  80059b:	e9 19 ff ff ff       	jmp    8004b9 <runcmd+0x2bb>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005a0:	83 ec 04             	sub    $0x4,%esp
  8005a3:	50                   	push   %eax
  8005a4:	ff 75 a8             	pushl  -0x58(%ebp)
  8005a7:	68 46 33 80 00       	push   $0x803346
  8005ac:	e8 5d 05 00 00       	call   800b0e <cprintf>
	close_all();
  8005b1:	e8 37 18 00 00       	call   801ded <close_all>
  8005b6:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  8005b9:	85 db                	test   %ebx,%ebx
  8005bb:	0f 84 5c ff ff ff    	je     80051d <runcmd+0x31f>
		if (debug)
  8005c1:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8005c8:	0f 84 36 ff ff ff    	je     800504 <runcmd+0x306>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  8005ce:	a1 24 54 80 00       	mov    0x805424,%eax
  8005d3:	8b 40 48             	mov    0x48(%eax),%eax
  8005d6:	83 ec 04             	sub    $0x4,%esp
  8005d9:	53                   	push   %ebx
  8005da:	50                   	push   %eax
  8005db:	68 7f 33 80 00       	push   $0x80337f
  8005e0:	e8 29 05 00 00       	call   800b0e <cprintf>
  8005e5:	83 c4 10             	add    $0x10,%esp
  8005e8:	e9 17 ff ff ff       	jmp    800504 <runcmd+0x306>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8005ed:	a1 24 54 80 00       	mov    0x805424,%eax
  8005f2:	8b 40 48             	mov    0x48(%eax),%eax
  8005f5:	56                   	push   %esi
  8005f6:	ff 75 a8             	pushl  -0x58(%ebp)
  8005f9:	50                   	push   %eax
  8005fa:	68 54 33 80 00       	push   $0x803354
  8005ff:	e8 0a 05 00 00       	call   800b0e <cprintf>
  800604:	83 c4 10             	add    $0x10,%esp
  800607:	e9 db fe ff ff       	jmp    8004e7 <runcmd+0x2e9>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  80060c:	a1 24 54 80 00       	mov    0x805424,%eax
  800611:	8b 40 48             	mov    0x48(%eax),%eax
  800614:	83 ec 08             	sub    $0x8,%esp
  800617:	50                   	push   %eax
  800618:	68 69 33 80 00       	push   $0x803369
  80061d:	e8 ec 04 00 00       	call   800b0e <cprintf>
  800622:	83 c4 10             	add    $0x10,%esp
  800625:	eb 92                	jmp    8005b9 <runcmd+0x3bb>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800627:	a1 24 54 80 00       	mov    0x805424,%eax
  80062c:	8b 40 48             	mov    0x48(%eax),%eax
  80062f:	83 ec 08             	sub    $0x8,%esp
  800632:	50                   	push   %eax
  800633:	68 69 33 80 00       	push   $0x803369
  800638:	e8 d1 04 00 00       	call   800b0e <cprintf>
  80063d:	83 c4 10             	add    $0x10,%esp
  800640:	e9 d8 fe ff ff       	jmp    80051d <runcmd+0x31f>

00800645 <usage>:


void
usage(void)
{
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  80064b:	68 48 34 80 00       	push   $0x803448
  800650:	e8 b9 04 00 00       	call   800b0e <cprintf>
	exit();
  800655:	e8 c7 03 00 00       	call   800a21 <exit>
}
  80065a:	83 c4 10             	add    $0x10,%esp
  80065d:	c9                   	leave  
  80065e:	c3                   	ret    

0080065f <umain>:

void
umain(int argc, char **argv)
{
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	57                   	push   %edi
  800663:	56                   	push   %esi
  800664:	53                   	push   %ebx
  800665:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  800668:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80066b:	50                   	push   %eax
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	8d 45 08             	lea    0x8(%ebp),%eax
  800672:	50                   	push   %eax
  800673:	e8 4b 14 00 00       	call   801ac3 <argstart>
	while ((r = argnext(&args)) >= 0)
  800678:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  80067b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  800682:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  800687:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  80068a:	be 01 00 00 00       	mov    $0x1,%esi
	while ((r = argnext(&args)) >= 0)
  80068f:	eb 03                	jmp    800694 <umain+0x35>
			break;
		case 'x':
			echocmds = 1;
  800691:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  800694:	83 ec 0c             	sub    $0xc,%esp
  800697:	53                   	push   %ebx
  800698:	e8 56 14 00 00       	call   801af3 <argnext>
  80069d:	83 c4 10             	add    $0x10,%esp
  8006a0:	85 c0                	test   %eax,%eax
  8006a2:	78 23                	js     8006c7 <umain+0x68>
		switch (r) {
  8006a4:	83 f8 69             	cmp    $0x69,%eax
  8006a7:	74 1a                	je     8006c3 <umain+0x64>
  8006a9:	83 f8 78             	cmp    $0x78,%eax
  8006ac:	74 e3                	je     800691 <umain+0x32>
  8006ae:	83 f8 64             	cmp    $0x64,%eax
  8006b1:	74 07                	je     8006ba <umain+0x5b>
			break;
		default:
			usage();
  8006b3:	e8 8d ff ff ff       	call   800645 <usage>
  8006b8:	eb da                	jmp    800694 <umain+0x35>
			debug++;
  8006ba:	83 05 00 50 80 00 01 	addl   $0x1,0x805000
			break;
  8006c1:	eb d1                	jmp    800694 <umain+0x35>
			interactive = 1;
  8006c3:	89 f7                	mov    %esi,%edi
  8006c5:	eb cd                	jmp    800694 <umain+0x35>
		}

	if (argc > 2)
  8006c7:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006cb:	7f 1f                	jg     8006ec <umain+0x8d>
		usage();
	if (argc == 2) {
  8006cd:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006d1:	74 20                	je     8006f3 <umain+0x94>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  8006d3:	83 ff 3f             	cmp    $0x3f,%edi
  8006d6:	74 77                	je     80074f <umain+0xf0>
  8006d8:	85 ff                	test   %edi,%edi
  8006da:	bf c4 33 80 00       	mov    $0x8033c4,%edi
  8006df:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e4:	0f 44 f8             	cmove  %eax,%edi
  8006e7:	e9 08 01 00 00       	jmp    8007f4 <umain+0x195>
		usage();
  8006ec:	e8 54 ff ff ff       	call   800645 <usage>
  8006f1:	eb da                	jmp    8006cd <umain+0x6e>
		close(0);
  8006f3:	83 ec 0c             	sub    $0xc,%esp
  8006f6:	6a 00                	push   $0x0
  8006f8:	e8 c5 16 00 00       	call   801dc2 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  8006fd:	83 c4 08             	add    $0x8,%esp
  800700:	6a 00                	push   $0x0
  800702:	8b 45 0c             	mov    0xc(%ebp),%eax
  800705:	ff 70 04             	pushl  0x4(%eax)
  800708:	e8 9f 1c 00 00       	call   8023ac <open>
  80070d:	83 c4 10             	add    $0x10,%esp
  800710:	85 c0                	test   %eax,%eax
  800712:	78 1d                	js     800731 <umain+0xd2>
		assert(r == 0);
  800714:	85 c0                	test   %eax,%eax
  800716:	74 bb                	je     8006d3 <umain+0x74>
  800718:	68 a8 33 80 00       	push   $0x8033a8
  80071d:	68 af 33 80 00       	push   $0x8033af
  800722:	68 21 01 00 00       	push   $0x121
  800727:	68 d7 32 80 00       	push   $0x8032d7
  80072c:	e8 02 03 00 00       	call   800a33 <_panic>
			panic("open %s: %e", argv[1], r);
  800731:	83 ec 0c             	sub    $0xc,%esp
  800734:	50                   	push   %eax
  800735:	8b 45 0c             	mov    0xc(%ebp),%eax
  800738:	ff 70 04             	pushl  0x4(%eax)
  80073b:	68 9c 33 80 00       	push   $0x80339c
  800740:	68 20 01 00 00       	push   $0x120
  800745:	68 d7 32 80 00       	push   $0x8032d7
  80074a:	e8 e4 02 00 00       	call   800a33 <_panic>
		interactive = iscons(0);
  80074f:	83 ec 0c             	sub    $0xc,%esp
  800752:	6a 00                	push   $0x0
  800754:	e8 04 02 00 00       	call   80095d <iscons>
  800759:	89 c7                	mov    %eax,%edi
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	e9 75 ff ff ff       	jmp    8006d8 <umain+0x79>
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL) {
			if (debug)
  800763:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80076a:	75 0a                	jne    800776 <umain+0x117>
				cprintf("EXITING\n");
			exit();	// end of file
  80076c:	e8 b0 02 00 00       	call   800a21 <exit>
  800771:	e9 94 00 00 00       	jmp    80080a <umain+0x1ab>
				cprintf("EXITING\n");
  800776:	83 ec 0c             	sub    $0xc,%esp
  800779:	68 c7 33 80 00       	push   $0x8033c7
  80077e:	e8 8b 03 00 00       	call   800b0e <cprintf>
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	eb e4                	jmp    80076c <umain+0x10d>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	53                   	push   %ebx
  80078c:	68 d0 33 80 00       	push   $0x8033d0
  800791:	e8 78 03 00 00       	call   800b0e <cprintf>
  800796:	83 c4 10             	add    $0x10,%esp
  800799:	eb 7c                	jmp    800817 <umain+0x1b8>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	53                   	push   %ebx
  80079f:	68 da 33 80 00       	push   $0x8033da
  8007a4:	e8 a7 1d 00 00       	call   802550 <printf>
  8007a9:	83 c4 10             	add    $0x10,%esp
  8007ac:	eb 78                	jmp    800826 <umain+0x1c7>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007ae:	83 ec 0c             	sub    $0xc,%esp
  8007b1:	68 e0 33 80 00       	push   $0x8033e0
  8007b6:	e8 53 03 00 00       	call   800b0e <cprintf>
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	eb 73                	jmp    800833 <umain+0x1d4>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  8007c0:	50                   	push   %eax
  8007c1:	68 35 38 80 00       	push   $0x803835
  8007c6:	68 38 01 00 00       	push   $0x138
  8007cb:	68 d7 32 80 00       	push   $0x8032d7
  8007d0:	e8 5e 02 00 00       	call   800a33 <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	50                   	push   %eax
  8007d9:	68 ed 33 80 00       	push   $0x8033ed
  8007de:	e8 2b 03 00 00       	call   800b0e <cprintf>
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	eb 5f                	jmp    800847 <umain+0x1e8>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	56                   	push   %esi
  8007ec:	e8 30 26 00 00       	call   802e21 <wait>
  8007f1:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  8007f4:	83 ec 0c             	sub    $0xc,%esp
  8007f7:	57                   	push   %edi
  8007f8:	e8 f9 08 00 00       	call   8010f6 <readline>
  8007fd:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	85 c0                	test   %eax,%eax
  800804:	0f 84 59 ff ff ff    	je     800763 <umain+0x104>
		if (debug)
  80080a:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800811:	0f 85 71 ff ff ff    	jne    800788 <umain+0x129>
		if (buf[0] == '#')
  800817:	80 3b 23             	cmpb   $0x23,(%ebx)
  80081a:	74 d8                	je     8007f4 <umain+0x195>
		if (echocmds)
  80081c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800820:	0f 85 75 ff ff ff    	jne    80079b <umain+0x13c>
		if (debug)
  800826:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80082d:	0f 85 7b ff ff ff    	jne    8007ae <umain+0x14f>
		if ((r = fork()) < 0)
  800833:	e8 9f 10 00 00       	call   8018d7 <fork>
  800838:	89 c6                	mov    %eax,%esi
  80083a:	85 c0                	test   %eax,%eax
  80083c:	78 82                	js     8007c0 <umain+0x161>
		if (debug)
  80083e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800845:	75 8e                	jne    8007d5 <umain+0x176>
		if (r == 0) {
  800847:	85 f6                	test   %esi,%esi
  800849:	75 9d                	jne    8007e8 <umain+0x189>
			runcmd(buf);
  80084b:	83 ec 0c             	sub    $0xc,%esp
  80084e:	53                   	push   %ebx
  80084f:	e8 aa f9 ff ff       	call   8001fe <runcmd>
			exit();
  800854:	e8 c8 01 00 00       	call   800a21 <exit>
  800859:	83 c4 10             	add    $0x10,%esp
  80085c:	eb 96                	jmp    8007f4 <umain+0x195>

0080085e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80085e:	55                   	push   %ebp
  80085f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800861:	b8 00 00 00 00       	mov    $0x0,%eax
  800866:	5d                   	pop    %ebp
  800867:	c3                   	ret    

00800868 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80086e:	68 69 34 80 00       	push   $0x803469
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	e8 a2 09 00 00       	call   80121d <strcpy>
	return 0;
}
  80087b:	b8 00 00 00 00       	mov    $0x0,%eax
  800880:	c9                   	leave  
  800881:	c3                   	ret    

00800882 <devcons_write>:
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	57                   	push   %edi
  800886:	56                   	push   %esi
  800887:	53                   	push   %ebx
  800888:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80088e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800893:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800899:	eb 2f                	jmp    8008ca <devcons_write+0x48>
		m = n - tot;
  80089b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80089e:	29 f3                	sub    %esi,%ebx
  8008a0:	83 fb 7f             	cmp    $0x7f,%ebx
  8008a3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008a8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8008ab:	83 ec 04             	sub    $0x4,%esp
  8008ae:	53                   	push   %ebx
  8008af:	89 f0                	mov    %esi,%eax
  8008b1:	03 45 0c             	add    0xc(%ebp),%eax
  8008b4:	50                   	push   %eax
  8008b5:	57                   	push   %edi
  8008b6:	e8 f0 0a 00 00       	call   8013ab <memmove>
		sys_cputs(buf, m);
  8008bb:	83 c4 08             	add    $0x8,%esp
  8008be:	53                   	push   %ebx
  8008bf:	57                   	push   %edi
  8008c0:	e8 95 0c 00 00       	call   80155a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8008c5:	01 de                	add    %ebx,%esi
  8008c7:	83 c4 10             	add    $0x10,%esp
  8008ca:	3b 75 10             	cmp    0x10(%ebp),%esi
  8008cd:	72 cc                	jb     80089b <devcons_write+0x19>
}
  8008cf:	89 f0                	mov    %esi,%eax
  8008d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008d4:	5b                   	pop    %ebx
  8008d5:	5e                   	pop    %esi
  8008d6:	5f                   	pop    %edi
  8008d7:	5d                   	pop    %ebp
  8008d8:	c3                   	ret    

008008d9 <devcons_read>:
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8008e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8008e8:	75 07                	jne    8008f1 <devcons_read+0x18>
}
  8008ea:	c9                   	leave  
  8008eb:	c3                   	ret    
		sys_yield();
  8008ec:	e8 06 0d 00 00       	call   8015f7 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8008f1:	e8 82 0c 00 00       	call   801578 <sys_cgetc>
  8008f6:	85 c0                	test   %eax,%eax
  8008f8:	74 f2                	je     8008ec <devcons_read+0x13>
	if (c < 0)
  8008fa:	85 c0                	test   %eax,%eax
  8008fc:	78 ec                	js     8008ea <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8008fe:	83 f8 04             	cmp    $0x4,%eax
  800901:	74 0c                	je     80090f <devcons_read+0x36>
	*(char*)vbuf = c;
  800903:	8b 55 0c             	mov    0xc(%ebp),%edx
  800906:	88 02                	mov    %al,(%edx)
	return 1;
  800908:	b8 01 00 00 00       	mov    $0x1,%eax
  80090d:	eb db                	jmp    8008ea <devcons_read+0x11>
		return 0;
  80090f:	b8 00 00 00 00       	mov    $0x0,%eax
  800914:	eb d4                	jmp    8008ea <devcons_read+0x11>

00800916 <cputchar>:
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800922:	6a 01                	push   $0x1
  800924:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800927:	50                   	push   %eax
  800928:	e8 2d 0c 00 00       	call   80155a <sys_cputs>
}
  80092d:	83 c4 10             	add    $0x10,%esp
  800930:	c9                   	leave  
  800931:	c3                   	ret    

00800932 <getchar>:
{
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800938:	6a 01                	push   $0x1
  80093a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80093d:	50                   	push   %eax
  80093e:	6a 00                	push   $0x0
  800940:	e8 b9 15 00 00       	call   801efe <read>
	if (r < 0)
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	85 c0                	test   %eax,%eax
  80094a:	78 08                	js     800954 <getchar+0x22>
	if (r < 1)
  80094c:	85 c0                	test   %eax,%eax
  80094e:	7e 06                	jle    800956 <getchar+0x24>
	return c;
  800950:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800954:	c9                   	leave  
  800955:	c3                   	ret    
		return -E_EOF;
  800956:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80095b:	eb f7                	jmp    800954 <getchar+0x22>

0080095d <iscons>:
{
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
  800960:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800963:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800966:	50                   	push   %eax
  800967:	ff 75 08             	pushl  0x8(%ebp)
  80096a:	e8 1e 13 00 00       	call   801c8d <fd_lookup>
  80096f:	83 c4 10             	add    $0x10,%esp
  800972:	85 c0                	test   %eax,%eax
  800974:	78 11                	js     800987 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800979:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80097f:	39 10                	cmp    %edx,(%eax)
  800981:	0f 94 c0             	sete   %al
  800984:	0f b6 c0             	movzbl %al,%eax
}
  800987:	c9                   	leave  
  800988:	c3                   	ret    

00800989 <opencons>:
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80098f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800992:	50                   	push   %eax
  800993:	e8 a6 12 00 00       	call   801c3e <fd_alloc>
  800998:	83 c4 10             	add    $0x10,%esp
  80099b:	85 c0                	test   %eax,%eax
  80099d:	78 3a                	js     8009d9 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80099f:	83 ec 04             	sub    $0x4,%esp
  8009a2:	68 07 04 00 00       	push   $0x407
  8009a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009aa:	6a 00                	push   $0x0
  8009ac:	e8 65 0c 00 00       	call   801616 <sys_page_alloc>
  8009b1:	83 c4 10             	add    $0x10,%esp
  8009b4:	85 c0                	test   %eax,%eax
  8009b6:	78 21                	js     8009d9 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8009b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009bb:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8009c1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8009c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8009cd:	83 ec 0c             	sub    $0xc,%esp
  8009d0:	50                   	push   %eax
  8009d1:	e8 41 12 00 00       	call   801c17 <fd2num>
  8009d6:	83 c4 10             	add    $0x10,%esp
}
  8009d9:	c9                   	leave  
  8009da:	c3                   	ret    

008009db <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	56                   	push   %esi
  8009df:	53                   	push   %ebx
  8009e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009e3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  8009e6:	e8 ed 0b 00 00       	call   8015d8 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  8009eb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8009f0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8009f3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009f8:	a3 24 54 80 00       	mov    %eax,0x805424

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009fd:	85 db                	test   %ebx,%ebx
  8009ff:	7e 07                	jle    800a08 <libmain+0x2d>
		binaryname = argv[0];
  800a01:	8b 06                	mov    (%esi),%eax
  800a03:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  800a08:	83 ec 08             	sub    $0x8,%esp
  800a0b:	56                   	push   %esi
  800a0c:	53                   	push   %ebx
  800a0d:	e8 4d fc ff ff       	call   80065f <umain>

	// exit gracefully
	exit();
  800a12:	e8 0a 00 00 00       	call   800a21 <exit>
}
  800a17:	83 c4 10             	add    $0x10,%esp
  800a1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a1d:	5b                   	pop    %ebx
  800a1e:	5e                   	pop    %esi
  800a1f:	5d                   	pop    %ebp
  800a20:	c3                   	ret    

00800a21 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800a27:	6a 00                	push   $0x0
  800a29:	e8 69 0b 00 00       	call   801597 <sys_env_destroy>
}
  800a2e:	83 c4 10             	add    $0x10,%esp
  800a31:	c9                   	leave  
  800a32:	c3                   	ret    

00800a33 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	56                   	push   %esi
  800a37:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800a38:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a3b:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800a41:	e8 92 0b 00 00       	call   8015d8 <sys_getenvid>
  800a46:	83 ec 0c             	sub    $0xc,%esp
  800a49:	ff 75 0c             	pushl  0xc(%ebp)
  800a4c:	ff 75 08             	pushl  0x8(%ebp)
  800a4f:	56                   	push   %esi
  800a50:	50                   	push   %eax
  800a51:	68 80 34 80 00       	push   $0x803480
  800a56:	e8 b3 00 00 00       	call   800b0e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a5b:	83 c4 18             	add    $0x18,%esp
  800a5e:	53                   	push   %ebx
  800a5f:	ff 75 10             	pushl  0x10(%ebp)
  800a62:	e8 56 00 00 00       	call   800abd <vcprintf>
	cprintf("\n");
  800a67:	c7 04 24 80 32 80 00 	movl   $0x803280,(%esp)
  800a6e:	e8 9b 00 00 00       	call   800b0e <cprintf>
  800a73:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800a76:	cc                   	int3   
  800a77:	eb fd                	jmp    800a76 <_panic+0x43>

00800a79 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	53                   	push   %ebx
  800a7d:	83 ec 04             	sub    $0x4,%esp
  800a80:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800a83:	8b 13                	mov    (%ebx),%edx
  800a85:	8d 42 01             	lea    0x1(%edx),%eax
  800a88:	89 03                	mov    %eax,(%ebx)
  800a8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800a91:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a96:	74 09                	je     800aa1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800a98:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800a9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a9f:	c9                   	leave  
  800aa0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800aa1:	83 ec 08             	sub    $0x8,%esp
  800aa4:	68 ff 00 00 00       	push   $0xff
  800aa9:	8d 43 08             	lea    0x8(%ebx),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 a8 0a 00 00       	call   80155a <sys_cputs>
		b->idx = 0;
  800ab2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800ab8:	83 c4 10             	add    $0x10,%esp
  800abb:	eb db                	jmp    800a98 <putch+0x1f>

00800abd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ac6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800acd:	00 00 00 
	b.cnt = 0;
  800ad0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ad7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	ff 75 08             	pushl  0x8(%ebp)
  800ae0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ae6:	50                   	push   %eax
  800ae7:	68 79 0a 80 00       	push   $0x800a79
  800aec:	e8 1a 01 00 00       	call   800c0b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800af1:	83 c4 08             	add    $0x8,%esp
  800af4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800afa:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b00:	50                   	push   %eax
  800b01:	e8 54 0a 00 00       	call   80155a <sys_cputs>

	return b.cnt;
}
  800b06:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b14:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b17:	50                   	push   %eax
  800b18:	ff 75 08             	pushl  0x8(%ebp)
  800b1b:	e8 9d ff ff ff       	call   800abd <vcprintf>
	va_end(ap);

	return cnt;
}
  800b20:	c9                   	leave  
  800b21:	c3                   	ret    

00800b22 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	57                   	push   %edi
  800b26:	56                   	push   %esi
  800b27:	53                   	push   %ebx
  800b28:	83 ec 1c             	sub    $0x1c,%esp
  800b2b:	89 c7                	mov    %eax,%edi
  800b2d:	89 d6                	mov    %edx,%esi
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b35:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b38:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b43:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800b46:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800b49:	39 d3                	cmp    %edx,%ebx
  800b4b:	72 05                	jb     800b52 <printnum+0x30>
  800b4d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800b50:	77 7a                	ja     800bcc <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b52:	83 ec 0c             	sub    $0xc,%esp
  800b55:	ff 75 18             	pushl  0x18(%ebp)
  800b58:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b5e:	53                   	push   %ebx
  800b5f:	ff 75 10             	pushl  0x10(%ebp)
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b68:	ff 75 e0             	pushl  -0x20(%ebp)
  800b6b:	ff 75 dc             	pushl  -0x24(%ebp)
  800b6e:	ff 75 d8             	pushl  -0x28(%ebp)
  800b71:	e8 aa 24 00 00       	call   803020 <__udivdi3>
  800b76:	83 c4 18             	add    $0x18,%esp
  800b79:	52                   	push   %edx
  800b7a:	50                   	push   %eax
  800b7b:	89 f2                	mov    %esi,%edx
  800b7d:	89 f8                	mov    %edi,%eax
  800b7f:	e8 9e ff ff ff       	call   800b22 <printnum>
  800b84:	83 c4 20             	add    $0x20,%esp
  800b87:	eb 13                	jmp    800b9c <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b89:	83 ec 08             	sub    $0x8,%esp
  800b8c:	56                   	push   %esi
  800b8d:	ff 75 18             	pushl  0x18(%ebp)
  800b90:	ff d7                	call   *%edi
  800b92:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800b95:	83 eb 01             	sub    $0x1,%ebx
  800b98:	85 db                	test   %ebx,%ebx
  800b9a:	7f ed                	jg     800b89 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	56                   	push   %esi
  800ba0:	83 ec 04             	sub    $0x4,%esp
  800ba3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ba6:	ff 75 e0             	pushl  -0x20(%ebp)
  800ba9:	ff 75 dc             	pushl  -0x24(%ebp)
  800bac:	ff 75 d8             	pushl  -0x28(%ebp)
  800baf:	e8 8c 25 00 00       	call   803140 <__umoddi3>
  800bb4:	83 c4 14             	add    $0x14,%esp
  800bb7:	0f be 80 a3 34 80 00 	movsbl 0x8034a3(%eax),%eax
  800bbe:	50                   	push   %eax
  800bbf:	ff d7                	call   *%edi
}
  800bc1:	83 c4 10             	add    $0x10,%esp
  800bc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5f                   	pop    %edi
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    
  800bcc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800bcf:	eb c4                	jmp    800b95 <printnum+0x73>

00800bd1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800bd7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800bdb:	8b 10                	mov    (%eax),%edx
  800bdd:	3b 50 04             	cmp    0x4(%eax),%edx
  800be0:	73 0a                	jae    800bec <sprintputch+0x1b>
		*b->buf++ = ch;
  800be2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be5:	89 08                	mov    %ecx,(%eax)
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	88 02                	mov    %al,(%edx)
}
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    

00800bee <printfmt>:
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800bf4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800bf7:	50                   	push   %eax
  800bf8:	ff 75 10             	pushl  0x10(%ebp)
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	ff 75 08             	pushl  0x8(%ebp)
  800c01:	e8 05 00 00 00       	call   800c0b <vprintfmt>
}
  800c06:	83 c4 10             	add    $0x10,%esp
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <vprintfmt>:
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	57                   	push   %edi
  800c0f:	56                   	push   %esi
  800c10:	53                   	push   %ebx
  800c11:	83 ec 2c             	sub    $0x2c,%esp
  800c14:	8b 75 08             	mov    0x8(%ebp),%esi
  800c17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c1a:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c1d:	e9 c1 03 00 00       	jmp    800fe3 <vprintfmt+0x3d8>
		padc = ' ';
  800c22:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800c26:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800c2d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800c34:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c3b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800c40:	8d 47 01             	lea    0x1(%edi),%eax
  800c43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c46:	0f b6 17             	movzbl (%edi),%edx
  800c49:	8d 42 dd             	lea    -0x23(%edx),%eax
  800c4c:	3c 55                	cmp    $0x55,%al
  800c4e:	0f 87 12 04 00 00    	ja     801066 <vprintfmt+0x45b>
  800c54:	0f b6 c0             	movzbl %al,%eax
  800c57:	ff 24 85 e0 35 80 00 	jmp    *0x8035e0(,%eax,4)
  800c5e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800c61:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800c65:	eb d9                	jmp    800c40 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800c67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800c6a:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800c6e:	eb d0                	jmp    800c40 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800c70:	0f b6 d2             	movzbl %dl,%edx
  800c73:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800c76:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800c7e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800c81:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800c85:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800c88:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800c8b:	83 f9 09             	cmp    $0x9,%ecx
  800c8e:	77 55                	ja     800ce5 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800c90:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800c93:	eb e9                	jmp    800c7e <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800c95:	8b 45 14             	mov    0x14(%ebp),%eax
  800c98:	8b 00                	mov    (%eax),%eax
  800c9a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800c9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca0:	8d 40 04             	lea    0x4(%eax),%eax
  800ca3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800ca6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800ca9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cad:	79 91                	jns    800c40 <vprintfmt+0x35>
				width = precision, precision = -1;
  800caf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800cb2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800cb5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800cbc:	eb 82                	jmp    800c40 <vprintfmt+0x35>
  800cbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cc1:	85 c0                	test   %eax,%eax
  800cc3:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc8:	0f 49 d0             	cmovns %eax,%edx
  800ccb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800cce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800cd1:	e9 6a ff ff ff       	jmp    800c40 <vprintfmt+0x35>
  800cd6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800cd9:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800ce0:	e9 5b ff ff ff       	jmp    800c40 <vprintfmt+0x35>
  800ce5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800ce8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800ceb:	eb bc                	jmp    800ca9 <vprintfmt+0x9e>
			lflag++;
  800ced:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800cf0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800cf3:	e9 48 ff ff ff       	jmp    800c40 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfb:	8d 78 04             	lea    0x4(%eax),%edi
  800cfe:	83 ec 08             	sub    $0x8,%esp
  800d01:	53                   	push   %ebx
  800d02:	ff 30                	pushl  (%eax)
  800d04:	ff d6                	call   *%esi
			break;
  800d06:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800d09:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800d0c:	e9 cf 02 00 00       	jmp    800fe0 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800d11:	8b 45 14             	mov    0x14(%ebp),%eax
  800d14:	8d 78 04             	lea    0x4(%eax),%edi
  800d17:	8b 00                	mov    (%eax),%eax
  800d19:	99                   	cltd   
  800d1a:	31 d0                	xor    %edx,%eax
  800d1c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d1e:	83 f8 0f             	cmp    $0xf,%eax
  800d21:	7f 23                	jg     800d46 <vprintfmt+0x13b>
  800d23:	8b 14 85 40 37 80 00 	mov    0x803740(,%eax,4),%edx
  800d2a:	85 d2                	test   %edx,%edx
  800d2c:	74 18                	je     800d46 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800d2e:	52                   	push   %edx
  800d2f:	68 c1 33 80 00       	push   $0x8033c1
  800d34:	53                   	push   %ebx
  800d35:	56                   	push   %esi
  800d36:	e8 b3 fe ff ff       	call   800bee <printfmt>
  800d3b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800d3e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800d41:	e9 9a 02 00 00       	jmp    800fe0 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800d46:	50                   	push   %eax
  800d47:	68 bb 34 80 00       	push   $0x8034bb
  800d4c:	53                   	push   %ebx
  800d4d:	56                   	push   %esi
  800d4e:	e8 9b fe ff ff       	call   800bee <printfmt>
  800d53:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800d56:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800d59:	e9 82 02 00 00       	jmp    800fe0 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800d5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d61:	83 c0 04             	add    $0x4,%eax
  800d64:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800d67:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800d6c:	85 ff                	test   %edi,%edi
  800d6e:	b8 b4 34 80 00       	mov    $0x8034b4,%eax
  800d73:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800d76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d7a:	0f 8e bd 00 00 00    	jle    800e3d <vprintfmt+0x232>
  800d80:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800d84:	75 0e                	jne    800d94 <vprintfmt+0x189>
  800d86:	89 75 08             	mov    %esi,0x8(%ebp)
  800d89:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800d8c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800d8f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800d92:	eb 6d                	jmp    800e01 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d94:	83 ec 08             	sub    $0x8,%esp
  800d97:	ff 75 d0             	pushl  -0x30(%ebp)
  800d9a:	57                   	push   %edi
  800d9b:	e8 5e 04 00 00       	call   8011fe <strnlen>
  800da0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800da3:	29 c1                	sub    %eax,%ecx
  800da5:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800da8:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800dab:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800daf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800db2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800db5:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800db7:	eb 0f                	jmp    800dc8 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800db9:	83 ec 08             	sub    $0x8,%esp
  800dbc:	53                   	push   %ebx
  800dbd:	ff 75 e0             	pushl  -0x20(%ebp)
  800dc0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc2:	83 ef 01             	sub    $0x1,%edi
  800dc5:	83 c4 10             	add    $0x10,%esp
  800dc8:	85 ff                	test   %edi,%edi
  800dca:	7f ed                	jg     800db9 <vprintfmt+0x1ae>
  800dcc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800dcf:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800dd2:	85 c9                	test   %ecx,%ecx
  800dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd9:	0f 49 c1             	cmovns %ecx,%eax
  800ddc:	29 c1                	sub    %eax,%ecx
  800dde:	89 75 08             	mov    %esi,0x8(%ebp)
  800de1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800de4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800de7:	89 cb                	mov    %ecx,%ebx
  800de9:	eb 16                	jmp    800e01 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800deb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800def:	75 31                	jne    800e22 <vprintfmt+0x217>
					putch(ch, putdat);
  800df1:	83 ec 08             	sub    $0x8,%esp
  800df4:	ff 75 0c             	pushl  0xc(%ebp)
  800df7:	50                   	push   %eax
  800df8:	ff 55 08             	call   *0x8(%ebp)
  800dfb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dfe:	83 eb 01             	sub    $0x1,%ebx
  800e01:	83 c7 01             	add    $0x1,%edi
  800e04:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800e08:	0f be c2             	movsbl %dl,%eax
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	74 59                	je     800e68 <vprintfmt+0x25d>
  800e0f:	85 f6                	test   %esi,%esi
  800e11:	78 d8                	js     800deb <vprintfmt+0x1e0>
  800e13:	83 ee 01             	sub    $0x1,%esi
  800e16:	79 d3                	jns    800deb <vprintfmt+0x1e0>
  800e18:	89 df                	mov    %ebx,%edi
  800e1a:	8b 75 08             	mov    0x8(%ebp),%esi
  800e1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e20:	eb 37                	jmp    800e59 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800e22:	0f be d2             	movsbl %dl,%edx
  800e25:	83 ea 20             	sub    $0x20,%edx
  800e28:	83 fa 5e             	cmp    $0x5e,%edx
  800e2b:	76 c4                	jbe    800df1 <vprintfmt+0x1e6>
					putch('?', putdat);
  800e2d:	83 ec 08             	sub    $0x8,%esp
  800e30:	ff 75 0c             	pushl  0xc(%ebp)
  800e33:	6a 3f                	push   $0x3f
  800e35:	ff 55 08             	call   *0x8(%ebp)
  800e38:	83 c4 10             	add    $0x10,%esp
  800e3b:	eb c1                	jmp    800dfe <vprintfmt+0x1f3>
  800e3d:	89 75 08             	mov    %esi,0x8(%ebp)
  800e40:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800e43:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800e46:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800e49:	eb b6                	jmp    800e01 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800e4b:	83 ec 08             	sub    $0x8,%esp
  800e4e:	53                   	push   %ebx
  800e4f:	6a 20                	push   $0x20
  800e51:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800e53:	83 ef 01             	sub    $0x1,%edi
  800e56:	83 c4 10             	add    $0x10,%esp
  800e59:	85 ff                	test   %edi,%edi
  800e5b:	7f ee                	jg     800e4b <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800e5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800e60:	89 45 14             	mov    %eax,0x14(%ebp)
  800e63:	e9 78 01 00 00       	jmp    800fe0 <vprintfmt+0x3d5>
  800e68:	89 df                	mov    %ebx,%edi
  800e6a:	8b 75 08             	mov    0x8(%ebp),%esi
  800e6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e70:	eb e7                	jmp    800e59 <vprintfmt+0x24e>
	if (lflag >= 2)
  800e72:	83 f9 01             	cmp    $0x1,%ecx
  800e75:	7e 3f                	jle    800eb6 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800e77:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7a:	8b 50 04             	mov    0x4(%eax),%edx
  800e7d:	8b 00                	mov    (%eax),%eax
  800e7f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e82:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800e85:	8b 45 14             	mov    0x14(%ebp),%eax
  800e88:	8d 40 08             	lea    0x8(%eax),%eax
  800e8b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800e8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e92:	79 5c                	jns    800ef0 <vprintfmt+0x2e5>
				putch('-', putdat);
  800e94:	83 ec 08             	sub    $0x8,%esp
  800e97:	53                   	push   %ebx
  800e98:	6a 2d                	push   $0x2d
  800e9a:	ff d6                	call   *%esi
				num = -(long long) num;
  800e9c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800e9f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800ea2:	f7 da                	neg    %edx
  800ea4:	83 d1 00             	adc    $0x0,%ecx
  800ea7:	f7 d9                	neg    %ecx
  800ea9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800eac:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb1:	e9 10 01 00 00       	jmp    800fc6 <vprintfmt+0x3bb>
	else if (lflag)
  800eb6:	85 c9                	test   %ecx,%ecx
  800eb8:	75 1b                	jne    800ed5 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800eba:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebd:	8b 00                	mov    (%eax),%eax
  800ebf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ec2:	89 c1                	mov    %eax,%ecx
  800ec4:	c1 f9 1f             	sar    $0x1f,%ecx
  800ec7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800eca:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecd:	8d 40 04             	lea    0x4(%eax),%eax
  800ed0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed3:	eb b9                	jmp    800e8e <vprintfmt+0x283>
		return va_arg(*ap, long);
  800ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed8:	8b 00                	mov    (%eax),%eax
  800eda:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800edd:	89 c1                	mov    %eax,%ecx
  800edf:	c1 f9 1f             	sar    $0x1f,%ecx
  800ee2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ee5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee8:	8d 40 04             	lea    0x4(%eax),%eax
  800eeb:	89 45 14             	mov    %eax,0x14(%ebp)
  800eee:	eb 9e                	jmp    800e8e <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800ef0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ef3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800ef6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800efb:	e9 c6 00 00 00       	jmp    800fc6 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800f00:	83 f9 01             	cmp    $0x1,%ecx
  800f03:	7e 18                	jle    800f1d <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800f05:	8b 45 14             	mov    0x14(%ebp),%eax
  800f08:	8b 10                	mov    (%eax),%edx
  800f0a:	8b 48 04             	mov    0x4(%eax),%ecx
  800f0d:	8d 40 08             	lea    0x8(%eax),%eax
  800f10:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f13:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f18:	e9 a9 00 00 00       	jmp    800fc6 <vprintfmt+0x3bb>
	else if (lflag)
  800f1d:	85 c9                	test   %ecx,%ecx
  800f1f:	75 1a                	jne    800f3b <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800f21:	8b 45 14             	mov    0x14(%ebp),%eax
  800f24:	8b 10                	mov    (%eax),%edx
  800f26:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f2b:	8d 40 04             	lea    0x4(%eax),%eax
  800f2e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f36:	e9 8b 00 00 00       	jmp    800fc6 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800f3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3e:	8b 10                	mov    (%eax),%edx
  800f40:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f45:	8d 40 04             	lea    0x4(%eax),%eax
  800f48:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f4b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f50:	eb 74                	jmp    800fc6 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800f52:	83 f9 01             	cmp    $0x1,%ecx
  800f55:	7e 15                	jle    800f6c <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800f57:	8b 45 14             	mov    0x14(%ebp),%eax
  800f5a:	8b 10                	mov    (%eax),%edx
  800f5c:	8b 48 04             	mov    0x4(%eax),%ecx
  800f5f:	8d 40 08             	lea    0x8(%eax),%eax
  800f62:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f65:	b8 08 00 00 00       	mov    $0x8,%eax
  800f6a:	eb 5a                	jmp    800fc6 <vprintfmt+0x3bb>
	else if (lflag)
  800f6c:	85 c9                	test   %ecx,%ecx
  800f6e:	75 17                	jne    800f87 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800f70:	8b 45 14             	mov    0x14(%ebp),%eax
  800f73:	8b 10                	mov    (%eax),%edx
  800f75:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f7a:	8d 40 04             	lea    0x4(%eax),%eax
  800f7d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f80:	b8 08 00 00 00       	mov    $0x8,%eax
  800f85:	eb 3f                	jmp    800fc6 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800f87:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8a:	8b 10                	mov    (%eax),%edx
  800f8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f91:	8d 40 04             	lea    0x4(%eax),%eax
  800f94:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800f97:	b8 08 00 00 00       	mov    $0x8,%eax
  800f9c:	eb 28                	jmp    800fc6 <vprintfmt+0x3bb>
			putch('0', putdat);
  800f9e:	83 ec 08             	sub    $0x8,%esp
  800fa1:	53                   	push   %ebx
  800fa2:	6a 30                	push   $0x30
  800fa4:	ff d6                	call   *%esi
			putch('x', putdat);
  800fa6:	83 c4 08             	add    $0x8,%esp
  800fa9:	53                   	push   %ebx
  800faa:	6a 78                	push   $0x78
  800fac:	ff d6                	call   *%esi
			num = (unsigned long long)
  800fae:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb1:	8b 10                	mov    (%eax),%edx
  800fb3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800fb8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800fbb:	8d 40 04             	lea    0x4(%eax),%eax
  800fbe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800fc1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800fc6:	83 ec 0c             	sub    $0xc,%esp
  800fc9:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800fcd:	57                   	push   %edi
  800fce:	ff 75 e0             	pushl  -0x20(%ebp)
  800fd1:	50                   	push   %eax
  800fd2:	51                   	push   %ecx
  800fd3:	52                   	push   %edx
  800fd4:	89 da                	mov    %ebx,%edx
  800fd6:	89 f0                	mov    %esi,%eax
  800fd8:	e8 45 fb ff ff       	call   800b22 <printnum>
			break;
  800fdd:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800fe0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  800fe3:	83 c7 01             	add    $0x1,%edi
  800fe6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800fea:	83 f8 25             	cmp    $0x25,%eax
  800fed:	0f 84 2f fc ff ff    	je     800c22 <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  800ff3:	85 c0                	test   %eax,%eax
  800ff5:	0f 84 8b 00 00 00    	je     801086 <vprintfmt+0x47b>
			putch(ch, putdat);
  800ffb:	83 ec 08             	sub    $0x8,%esp
  800ffe:	53                   	push   %ebx
  800fff:	50                   	push   %eax
  801000:	ff d6                	call   *%esi
  801002:	83 c4 10             	add    $0x10,%esp
  801005:	eb dc                	jmp    800fe3 <vprintfmt+0x3d8>
	if (lflag >= 2)
  801007:	83 f9 01             	cmp    $0x1,%ecx
  80100a:	7e 15                	jle    801021 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  80100c:	8b 45 14             	mov    0x14(%ebp),%eax
  80100f:	8b 10                	mov    (%eax),%edx
  801011:	8b 48 04             	mov    0x4(%eax),%ecx
  801014:	8d 40 08             	lea    0x8(%eax),%eax
  801017:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80101a:	b8 10 00 00 00       	mov    $0x10,%eax
  80101f:	eb a5                	jmp    800fc6 <vprintfmt+0x3bb>
	else if (lflag)
  801021:	85 c9                	test   %ecx,%ecx
  801023:	75 17                	jne    80103c <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  801025:	8b 45 14             	mov    0x14(%ebp),%eax
  801028:	8b 10                	mov    (%eax),%edx
  80102a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80102f:	8d 40 04             	lea    0x4(%eax),%eax
  801032:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801035:	b8 10 00 00 00       	mov    $0x10,%eax
  80103a:	eb 8a                	jmp    800fc6 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80103c:	8b 45 14             	mov    0x14(%ebp),%eax
  80103f:	8b 10                	mov    (%eax),%edx
  801041:	b9 00 00 00 00       	mov    $0x0,%ecx
  801046:	8d 40 04             	lea    0x4(%eax),%eax
  801049:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80104c:	b8 10 00 00 00       	mov    $0x10,%eax
  801051:	e9 70 ff ff ff       	jmp    800fc6 <vprintfmt+0x3bb>
			putch(ch, putdat);
  801056:	83 ec 08             	sub    $0x8,%esp
  801059:	53                   	push   %ebx
  80105a:	6a 25                	push   $0x25
  80105c:	ff d6                	call   *%esi
			break;
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	e9 7a ff ff ff       	jmp    800fe0 <vprintfmt+0x3d5>
			putch('%', putdat);
  801066:	83 ec 08             	sub    $0x8,%esp
  801069:	53                   	push   %ebx
  80106a:	6a 25                	push   $0x25
  80106c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80106e:	83 c4 10             	add    $0x10,%esp
  801071:	89 f8                	mov    %edi,%eax
  801073:	eb 03                	jmp    801078 <vprintfmt+0x46d>
  801075:	83 e8 01             	sub    $0x1,%eax
  801078:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80107c:	75 f7                	jne    801075 <vprintfmt+0x46a>
  80107e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801081:	e9 5a ff ff ff       	jmp    800fe0 <vprintfmt+0x3d5>
}
  801086:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801089:	5b                   	pop    %ebx
  80108a:	5e                   	pop    %esi
  80108b:	5f                   	pop    %edi
  80108c:	5d                   	pop    %ebp
  80108d:	c3                   	ret    

0080108e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 18             	sub    $0x18,%esp
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80109a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80109d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8010a1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8010a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010ab:	85 c0                	test   %eax,%eax
  8010ad:	74 26                	je     8010d5 <vsnprintf+0x47>
  8010af:	85 d2                	test   %edx,%edx
  8010b1:	7e 22                	jle    8010d5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010b3:	ff 75 14             	pushl  0x14(%ebp)
  8010b6:	ff 75 10             	pushl  0x10(%ebp)
  8010b9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010bc:	50                   	push   %eax
  8010bd:	68 d1 0b 80 00       	push   $0x800bd1
  8010c2:	e8 44 fb ff ff       	call   800c0b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8010c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010ca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d0:	83 c4 10             	add    $0x10,%esp
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    
		return -E_INVAL;
  8010d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010da:	eb f7                	jmp    8010d3 <vsnprintf+0x45>

008010dc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010e2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8010e5:	50                   	push   %eax
  8010e6:	ff 75 10             	pushl  0x10(%ebp)
  8010e9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ec:	ff 75 08             	pushl  0x8(%ebp)
  8010ef:	e8 9a ff ff ff       	call   80108e <vsnprintf>
	va_end(ap);

	return rc;
}
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

008010f6 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	57                   	push   %edi
  8010fa:	56                   	push   %esi
  8010fb:	53                   	push   %ebx
  8010fc:	83 ec 0c             	sub    $0xc,%esp
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801102:	85 c0                	test   %eax,%eax
  801104:	74 13                	je     801119 <readline+0x23>
		fprintf(1, "%s", prompt);
  801106:	83 ec 04             	sub    $0x4,%esp
  801109:	50                   	push   %eax
  80110a:	68 c1 33 80 00       	push   $0x8033c1
  80110f:	6a 01                	push   $0x1
  801111:	e8 23 14 00 00       	call   802539 <fprintf>
  801116:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	6a 00                	push   $0x0
  80111e:	e8 3a f8 ff ff       	call   80095d <iscons>
  801123:	89 c7                	mov    %eax,%edi
  801125:	83 c4 10             	add    $0x10,%esp
	i = 0;
  801128:	be 00 00 00 00       	mov    $0x0,%esi
  80112d:	eb 4b                	jmp    80117a <readline+0x84>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  80112f:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  801134:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801137:	75 08                	jne    801141 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  801139:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113c:	5b                   	pop    %ebx
  80113d:	5e                   	pop    %esi
  80113e:	5f                   	pop    %edi
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    
				cprintf("read error: %e\n", c);
  801141:	83 ec 08             	sub    $0x8,%esp
  801144:	53                   	push   %ebx
  801145:	68 9f 37 80 00       	push   $0x80379f
  80114a:	e8 bf f9 ff ff       	call   800b0e <cprintf>
  80114f:	83 c4 10             	add    $0x10,%esp
			return NULL;
  801152:	b8 00 00 00 00       	mov    $0x0,%eax
  801157:	eb e0                	jmp    801139 <readline+0x43>
			if (echoing)
  801159:	85 ff                	test   %edi,%edi
  80115b:	75 05                	jne    801162 <readline+0x6c>
			i--;
  80115d:	83 ee 01             	sub    $0x1,%esi
  801160:	eb 18                	jmp    80117a <readline+0x84>
				cputchar('\b');
  801162:	83 ec 0c             	sub    $0xc,%esp
  801165:	6a 08                	push   $0x8
  801167:	e8 aa f7 ff ff       	call   800916 <cputchar>
  80116c:	83 c4 10             	add    $0x10,%esp
  80116f:	eb ec                	jmp    80115d <readline+0x67>
			buf[i++] = c;
  801171:	88 9e 20 50 80 00    	mov    %bl,0x805020(%esi)
  801177:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  80117a:	e8 b3 f7 ff ff       	call   800932 <getchar>
  80117f:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801181:	85 c0                	test   %eax,%eax
  801183:	78 aa                	js     80112f <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  801185:	83 f8 08             	cmp    $0x8,%eax
  801188:	0f 94 c2             	sete   %dl
  80118b:	83 f8 7f             	cmp    $0x7f,%eax
  80118e:	0f 94 c0             	sete   %al
  801191:	08 c2                	or     %al,%dl
  801193:	74 04                	je     801199 <readline+0xa3>
  801195:	85 f6                	test   %esi,%esi
  801197:	7f c0                	jg     801159 <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801199:	83 fb 1f             	cmp    $0x1f,%ebx
  80119c:	7e 1a                	jle    8011b8 <readline+0xc2>
  80119e:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8011a4:	7f 12                	jg     8011b8 <readline+0xc2>
			if (echoing)
  8011a6:	85 ff                	test   %edi,%edi
  8011a8:	74 c7                	je     801171 <readline+0x7b>
				cputchar(c);
  8011aa:	83 ec 0c             	sub    $0xc,%esp
  8011ad:	53                   	push   %ebx
  8011ae:	e8 63 f7 ff ff       	call   800916 <cputchar>
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	eb b9                	jmp    801171 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  8011b8:	83 fb 0a             	cmp    $0xa,%ebx
  8011bb:	74 05                	je     8011c2 <readline+0xcc>
  8011bd:	83 fb 0d             	cmp    $0xd,%ebx
  8011c0:	75 b8                	jne    80117a <readline+0x84>
			if (echoing)
  8011c2:	85 ff                	test   %edi,%edi
  8011c4:	75 11                	jne    8011d7 <readline+0xe1>
			buf[i] = 0;
  8011c6:	c6 86 20 50 80 00 00 	movb   $0x0,0x805020(%esi)
			return buf;
  8011cd:	b8 20 50 80 00       	mov    $0x805020,%eax
  8011d2:	e9 62 ff ff ff       	jmp    801139 <readline+0x43>
				cputchar('\n');
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	6a 0a                	push   $0xa
  8011dc:	e8 35 f7 ff ff       	call   800916 <cputchar>
  8011e1:	83 c4 10             	add    $0x10,%esp
  8011e4:	eb e0                	jmp    8011c6 <readline+0xd0>

008011e6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8011ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f1:	eb 03                	jmp    8011f6 <strlen+0x10>
		n++;
  8011f3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8011f6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8011fa:	75 f7                	jne    8011f3 <strlen+0xd>
	return n;
}
  8011fc:	5d                   	pop    %ebp
  8011fd:	c3                   	ret    

008011fe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801204:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801207:	b8 00 00 00 00       	mov    $0x0,%eax
  80120c:	eb 03                	jmp    801211 <strnlen+0x13>
		n++;
  80120e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801211:	39 d0                	cmp    %edx,%eax
  801213:	74 06                	je     80121b <strnlen+0x1d>
  801215:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801219:	75 f3                	jne    80120e <strnlen+0x10>
	return n;
}
  80121b:	5d                   	pop    %ebp
  80121c:	c3                   	ret    

0080121d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	53                   	push   %ebx
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801227:	89 c2                	mov    %eax,%edx
  801229:	83 c1 01             	add    $0x1,%ecx
  80122c:	83 c2 01             	add    $0x1,%edx
  80122f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801233:	88 5a ff             	mov    %bl,-0x1(%edx)
  801236:	84 db                	test   %bl,%bl
  801238:	75 ef                	jne    801229 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80123a:	5b                   	pop    %ebx
  80123b:	5d                   	pop    %ebp
  80123c:	c3                   	ret    

0080123d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	53                   	push   %ebx
  801241:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801244:	53                   	push   %ebx
  801245:	e8 9c ff ff ff       	call   8011e6 <strlen>
  80124a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80124d:	ff 75 0c             	pushl  0xc(%ebp)
  801250:	01 d8                	add    %ebx,%eax
  801252:	50                   	push   %eax
  801253:	e8 c5 ff ff ff       	call   80121d <strcpy>
	return dst;
}
  801258:	89 d8                	mov    %ebx,%eax
  80125a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	56                   	push   %esi
  801263:	53                   	push   %ebx
  801264:	8b 75 08             	mov    0x8(%ebp),%esi
  801267:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80126a:	89 f3                	mov    %esi,%ebx
  80126c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80126f:	89 f2                	mov    %esi,%edx
  801271:	eb 0f                	jmp    801282 <strncpy+0x23>
		*dst++ = *src;
  801273:	83 c2 01             	add    $0x1,%edx
  801276:	0f b6 01             	movzbl (%ecx),%eax
  801279:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80127c:	80 39 01             	cmpb   $0x1,(%ecx)
  80127f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801282:	39 da                	cmp    %ebx,%edx
  801284:	75 ed                	jne    801273 <strncpy+0x14>
	}
	return ret;
}
  801286:	89 f0                	mov    %esi,%eax
  801288:	5b                   	pop    %ebx
  801289:	5e                   	pop    %esi
  80128a:	5d                   	pop    %ebp
  80128b:	c3                   	ret    

0080128c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	56                   	push   %esi
  801290:	53                   	push   %ebx
  801291:	8b 75 08             	mov    0x8(%ebp),%esi
  801294:	8b 55 0c             	mov    0xc(%ebp),%edx
  801297:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80129a:	89 f0                	mov    %esi,%eax
  80129c:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8012a0:	85 c9                	test   %ecx,%ecx
  8012a2:	75 0b                	jne    8012af <strlcpy+0x23>
  8012a4:	eb 17                	jmp    8012bd <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8012a6:	83 c2 01             	add    $0x1,%edx
  8012a9:	83 c0 01             	add    $0x1,%eax
  8012ac:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8012af:	39 d8                	cmp    %ebx,%eax
  8012b1:	74 07                	je     8012ba <strlcpy+0x2e>
  8012b3:	0f b6 0a             	movzbl (%edx),%ecx
  8012b6:	84 c9                	test   %cl,%cl
  8012b8:	75 ec                	jne    8012a6 <strlcpy+0x1a>
		*dst = '\0';
  8012ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8012bd:	29 f0                	sub    %esi,%eax
}
  8012bf:	5b                   	pop    %ebx
  8012c0:	5e                   	pop    %esi
  8012c1:	5d                   	pop    %ebp
  8012c2:	c3                   	ret    

008012c3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8012cc:	eb 06                	jmp    8012d4 <strcmp+0x11>
		p++, q++;
  8012ce:	83 c1 01             	add    $0x1,%ecx
  8012d1:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8012d4:	0f b6 01             	movzbl (%ecx),%eax
  8012d7:	84 c0                	test   %al,%al
  8012d9:	74 04                	je     8012df <strcmp+0x1c>
  8012db:	3a 02                	cmp    (%edx),%al
  8012dd:	74 ef                	je     8012ce <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012df:	0f b6 c0             	movzbl %al,%eax
  8012e2:	0f b6 12             	movzbl (%edx),%edx
  8012e5:	29 d0                	sub    %edx,%eax
}
  8012e7:	5d                   	pop    %ebp
  8012e8:	c3                   	ret    

008012e9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	53                   	push   %ebx
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f3:	89 c3                	mov    %eax,%ebx
  8012f5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8012f8:	eb 06                	jmp    801300 <strncmp+0x17>
		n--, p++, q++;
  8012fa:	83 c0 01             	add    $0x1,%eax
  8012fd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801300:	39 d8                	cmp    %ebx,%eax
  801302:	74 16                	je     80131a <strncmp+0x31>
  801304:	0f b6 08             	movzbl (%eax),%ecx
  801307:	84 c9                	test   %cl,%cl
  801309:	74 04                	je     80130f <strncmp+0x26>
  80130b:	3a 0a                	cmp    (%edx),%cl
  80130d:	74 eb                	je     8012fa <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80130f:	0f b6 00             	movzbl (%eax),%eax
  801312:	0f b6 12             	movzbl (%edx),%edx
  801315:	29 d0                	sub    %edx,%eax
}
  801317:	5b                   	pop    %ebx
  801318:	5d                   	pop    %ebp
  801319:	c3                   	ret    
		return 0;
  80131a:	b8 00 00 00 00       	mov    $0x0,%eax
  80131f:	eb f6                	jmp    801317 <strncmp+0x2e>

00801321 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80132b:	0f b6 10             	movzbl (%eax),%edx
  80132e:	84 d2                	test   %dl,%dl
  801330:	74 09                	je     80133b <strchr+0x1a>
		if (*s == c)
  801332:	38 ca                	cmp    %cl,%dl
  801334:	74 0a                	je     801340 <strchr+0x1f>
	for (; *s; s++)
  801336:	83 c0 01             	add    $0x1,%eax
  801339:	eb f0                	jmp    80132b <strchr+0xa>
			return (char *) s;
	return 0;
  80133b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801340:	5d                   	pop    %ebp
  801341:	c3                   	ret    

00801342 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80134c:	eb 03                	jmp    801351 <strfind+0xf>
  80134e:	83 c0 01             	add    $0x1,%eax
  801351:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801354:	38 ca                	cmp    %cl,%dl
  801356:	74 04                	je     80135c <strfind+0x1a>
  801358:	84 d2                	test   %dl,%dl
  80135a:	75 f2                	jne    80134e <strfind+0xc>
			break;
	return (char *) s;
}
  80135c:	5d                   	pop    %ebp
  80135d:	c3                   	ret    

0080135e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	57                   	push   %edi
  801362:	56                   	push   %esi
  801363:	53                   	push   %ebx
  801364:	8b 7d 08             	mov    0x8(%ebp),%edi
  801367:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80136a:	85 c9                	test   %ecx,%ecx
  80136c:	74 13                	je     801381 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80136e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801374:	75 05                	jne    80137b <memset+0x1d>
  801376:	f6 c1 03             	test   $0x3,%cl
  801379:	74 0d                	je     801388 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80137b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137e:	fc                   	cld    
  80137f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801381:	89 f8                	mov    %edi,%eax
  801383:	5b                   	pop    %ebx
  801384:	5e                   	pop    %esi
  801385:	5f                   	pop    %edi
  801386:	5d                   	pop    %ebp
  801387:	c3                   	ret    
		c &= 0xFF;
  801388:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80138c:	89 d3                	mov    %edx,%ebx
  80138e:	c1 e3 08             	shl    $0x8,%ebx
  801391:	89 d0                	mov    %edx,%eax
  801393:	c1 e0 18             	shl    $0x18,%eax
  801396:	89 d6                	mov    %edx,%esi
  801398:	c1 e6 10             	shl    $0x10,%esi
  80139b:	09 f0                	or     %esi,%eax
  80139d:	09 c2                	or     %eax,%edx
  80139f:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8013a1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8013a4:	89 d0                	mov    %edx,%eax
  8013a6:	fc                   	cld    
  8013a7:	f3 ab                	rep stos %eax,%es:(%edi)
  8013a9:	eb d6                	jmp    801381 <memset+0x23>

008013ab <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	57                   	push   %edi
  8013af:	56                   	push   %esi
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013b9:	39 c6                	cmp    %eax,%esi
  8013bb:	73 35                	jae    8013f2 <memmove+0x47>
  8013bd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8013c0:	39 c2                	cmp    %eax,%edx
  8013c2:	76 2e                	jbe    8013f2 <memmove+0x47>
		s += n;
		d += n;
  8013c4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8013c7:	89 d6                	mov    %edx,%esi
  8013c9:	09 fe                	or     %edi,%esi
  8013cb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8013d1:	74 0c                	je     8013df <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013d3:	83 ef 01             	sub    $0x1,%edi
  8013d6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8013d9:	fd                   	std    
  8013da:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013dc:	fc                   	cld    
  8013dd:	eb 21                	jmp    801400 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8013df:	f6 c1 03             	test   $0x3,%cl
  8013e2:	75 ef                	jne    8013d3 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013e4:	83 ef 04             	sub    $0x4,%edi
  8013e7:	8d 72 fc             	lea    -0x4(%edx),%esi
  8013ea:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8013ed:	fd                   	std    
  8013ee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8013f0:	eb ea                	jmp    8013dc <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8013f2:	89 f2                	mov    %esi,%edx
  8013f4:	09 c2                	or     %eax,%edx
  8013f6:	f6 c2 03             	test   $0x3,%dl
  8013f9:	74 09                	je     801404 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013fb:	89 c7                	mov    %eax,%edi
  8013fd:	fc                   	cld    
  8013fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801400:	5e                   	pop    %esi
  801401:	5f                   	pop    %edi
  801402:	5d                   	pop    %ebp
  801403:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801404:	f6 c1 03             	test   $0x3,%cl
  801407:	75 f2                	jne    8013fb <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801409:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80140c:	89 c7                	mov    %eax,%edi
  80140e:	fc                   	cld    
  80140f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801411:	eb ed                	jmp    801400 <memmove+0x55>

00801413 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801416:	ff 75 10             	pushl  0x10(%ebp)
  801419:	ff 75 0c             	pushl  0xc(%ebp)
  80141c:	ff 75 08             	pushl  0x8(%ebp)
  80141f:	e8 87 ff ff ff       	call   8013ab <memmove>
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	56                   	push   %esi
  80142a:	53                   	push   %ebx
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801431:	89 c6                	mov    %eax,%esi
  801433:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801436:	39 f0                	cmp    %esi,%eax
  801438:	74 1c                	je     801456 <memcmp+0x30>
		if (*s1 != *s2)
  80143a:	0f b6 08             	movzbl (%eax),%ecx
  80143d:	0f b6 1a             	movzbl (%edx),%ebx
  801440:	38 d9                	cmp    %bl,%cl
  801442:	75 08                	jne    80144c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801444:	83 c0 01             	add    $0x1,%eax
  801447:	83 c2 01             	add    $0x1,%edx
  80144a:	eb ea                	jmp    801436 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80144c:	0f b6 c1             	movzbl %cl,%eax
  80144f:	0f b6 db             	movzbl %bl,%ebx
  801452:	29 d8                	sub    %ebx,%eax
  801454:	eb 05                	jmp    80145b <memcmp+0x35>
	}

	return 0;
  801456:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145b:	5b                   	pop    %ebx
  80145c:	5e                   	pop    %esi
  80145d:	5d                   	pop    %ebp
  80145e:	c3                   	ret    

0080145f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801468:	89 c2                	mov    %eax,%edx
  80146a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80146d:	39 d0                	cmp    %edx,%eax
  80146f:	73 09                	jae    80147a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801471:	38 08                	cmp    %cl,(%eax)
  801473:	74 05                	je     80147a <memfind+0x1b>
	for (; s < ends; s++)
  801475:	83 c0 01             	add    $0x1,%eax
  801478:	eb f3                	jmp    80146d <memfind+0xe>
			break;
	return (void *) s;
}
  80147a:	5d                   	pop    %ebp
  80147b:	c3                   	ret    

0080147c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	57                   	push   %edi
  801480:	56                   	push   %esi
  801481:	53                   	push   %ebx
  801482:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801485:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801488:	eb 03                	jmp    80148d <strtol+0x11>
		s++;
  80148a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80148d:	0f b6 01             	movzbl (%ecx),%eax
  801490:	3c 20                	cmp    $0x20,%al
  801492:	74 f6                	je     80148a <strtol+0xe>
  801494:	3c 09                	cmp    $0x9,%al
  801496:	74 f2                	je     80148a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801498:	3c 2b                	cmp    $0x2b,%al
  80149a:	74 2e                	je     8014ca <strtol+0x4e>
	int neg = 0;
  80149c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8014a1:	3c 2d                	cmp    $0x2d,%al
  8014a3:	74 2f                	je     8014d4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014a5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8014ab:	75 05                	jne    8014b2 <strtol+0x36>
  8014ad:	80 39 30             	cmpb   $0x30,(%ecx)
  8014b0:	74 2c                	je     8014de <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8014b2:	85 db                	test   %ebx,%ebx
  8014b4:	75 0a                	jne    8014c0 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8014b6:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8014bb:	80 39 30             	cmpb   $0x30,(%ecx)
  8014be:	74 28                	je     8014e8 <strtol+0x6c>
		base = 10;
  8014c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8014c8:	eb 50                	jmp    80151a <strtol+0x9e>
		s++;
  8014ca:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8014cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8014d2:	eb d1                	jmp    8014a5 <strtol+0x29>
		s++, neg = 1;
  8014d4:	83 c1 01             	add    $0x1,%ecx
  8014d7:	bf 01 00 00 00       	mov    $0x1,%edi
  8014dc:	eb c7                	jmp    8014a5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014de:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8014e2:	74 0e                	je     8014f2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8014e4:	85 db                	test   %ebx,%ebx
  8014e6:	75 d8                	jne    8014c0 <strtol+0x44>
		s++, base = 8;
  8014e8:	83 c1 01             	add    $0x1,%ecx
  8014eb:	bb 08 00 00 00       	mov    $0x8,%ebx
  8014f0:	eb ce                	jmp    8014c0 <strtol+0x44>
		s += 2, base = 16;
  8014f2:	83 c1 02             	add    $0x2,%ecx
  8014f5:	bb 10 00 00 00       	mov    $0x10,%ebx
  8014fa:	eb c4                	jmp    8014c0 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8014fc:	8d 72 9f             	lea    -0x61(%edx),%esi
  8014ff:	89 f3                	mov    %esi,%ebx
  801501:	80 fb 19             	cmp    $0x19,%bl
  801504:	77 29                	ja     80152f <strtol+0xb3>
			dig = *s - 'a' + 10;
  801506:	0f be d2             	movsbl %dl,%edx
  801509:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80150c:	3b 55 10             	cmp    0x10(%ebp),%edx
  80150f:	7d 30                	jge    801541 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801511:	83 c1 01             	add    $0x1,%ecx
  801514:	0f af 45 10          	imul   0x10(%ebp),%eax
  801518:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80151a:	0f b6 11             	movzbl (%ecx),%edx
  80151d:	8d 72 d0             	lea    -0x30(%edx),%esi
  801520:	89 f3                	mov    %esi,%ebx
  801522:	80 fb 09             	cmp    $0x9,%bl
  801525:	77 d5                	ja     8014fc <strtol+0x80>
			dig = *s - '0';
  801527:	0f be d2             	movsbl %dl,%edx
  80152a:	83 ea 30             	sub    $0x30,%edx
  80152d:	eb dd                	jmp    80150c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  80152f:	8d 72 bf             	lea    -0x41(%edx),%esi
  801532:	89 f3                	mov    %esi,%ebx
  801534:	80 fb 19             	cmp    $0x19,%bl
  801537:	77 08                	ja     801541 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801539:	0f be d2             	movsbl %dl,%edx
  80153c:	83 ea 37             	sub    $0x37,%edx
  80153f:	eb cb                	jmp    80150c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801541:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801545:	74 05                	je     80154c <strtol+0xd0>
		*endptr = (char *) s;
  801547:	8b 75 0c             	mov    0xc(%ebp),%esi
  80154a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80154c:	89 c2                	mov    %eax,%edx
  80154e:	f7 da                	neg    %edx
  801550:	85 ff                	test   %edi,%edi
  801552:	0f 45 c2             	cmovne %edx,%eax
}
  801555:	5b                   	pop    %ebx
  801556:	5e                   	pop    %esi
  801557:	5f                   	pop    %edi
  801558:	5d                   	pop    %ebp
  801559:	c3                   	ret    

0080155a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
  80155d:	57                   	push   %edi
  80155e:	56                   	push   %esi
  80155f:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	8b 55 08             	mov    0x8(%ebp),%edx
  801568:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80156b:	89 c3                	mov    %eax,%ebx
  80156d:	89 c7                	mov    %eax,%edi
  80156f:	89 c6                	mov    %eax,%esi
  801571:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801573:	5b                   	pop    %ebx
  801574:	5e                   	pop    %esi
  801575:	5f                   	pop    %edi
  801576:	5d                   	pop    %ebp
  801577:	c3                   	ret    

00801578 <sys_cgetc>:

int
sys_cgetc(void)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
  80157b:	57                   	push   %edi
  80157c:	56                   	push   %esi
  80157d:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80157e:	ba 00 00 00 00       	mov    $0x0,%edx
  801583:	b8 01 00 00 00       	mov    $0x1,%eax
  801588:	89 d1                	mov    %edx,%ecx
  80158a:	89 d3                	mov    %edx,%ebx
  80158c:	89 d7                	mov    %edx,%edi
  80158e:	89 d6                	mov    %edx,%esi
  801590:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801592:	5b                   	pop    %ebx
  801593:	5e                   	pop    %esi
  801594:	5f                   	pop    %edi
  801595:	5d                   	pop    %ebp
  801596:	c3                   	ret    

00801597 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	57                   	push   %edi
  80159b:	56                   	push   %esi
  80159c:	53                   	push   %ebx
  80159d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8015a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a8:	b8 03 00 00 00       	mov    $0x3,%eax
  8015ad:	89 cb                	mov    %ecx,%ebx
  8015af:	89 cf                	mov    %ecx,%edi
  8015b1:	89 ce                	mov    %ecx,%esi
  8015b3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	7f 08                	jg     8015c1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8015b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015bc:	5b                   	pop    %ebx
  8015bd:	5e                   	pop    %esi
  8015be:	5f                   	pop    %edi
  8015bf:	5d                   	pop    %ebp
  8015c0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015c1:	83 ec 0c             	sub    $0xc,%esp
  8015c4:	50                   	push   %eax
  8015c5:	6a 03                	push   $0x3
  8015c7:	68 af 37 80 00       	push   $0x8037af
  8015cc:	6a 23                	push   $0x23
  8015ce:	68 cc 37 80 00       	push   $0x8037cc
  8015d3:	e8 5b f4 ff ff       	call   800a33 <_panic>

008015d8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	57                   	push   %edi
  8015dc:	56                   	push   %esi
  8015dd:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8015de:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e3:	b8 02 00 00 00       	mov    $0x2,%eax
  8015e8:	89 d1                	mov    %edx,%ecx
  8015ea:	89 d3                	mov    %edx,%ebx
  8015ec:	89 d7                	mov    %edx,%edi
  8015ee:	89 d6                	mov    %edx,%esi
  8015f0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8015f2:	5b                   	pop    %ebx
  8015f3:	5e                   	pop    %esi
  8015f4:	5f                   	pop    %edi
  8015f5:	5d                   	pop    %ebp
  8015f6:	c3                   	ret    

008015f7 <sys_yield>:

void
sys_yield(void)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	57                   	push   %edi
  8015fb:	56                   	push   %esi
  8015fc:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8015fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801602:	b8 0b 00 00 00       	mov    $0xb,%eax
  801607:	89 d1                	mov    %edx,%ecx
  801609:	89 d3                	mov    %edx,%ebx
  80160b:	89 d7                	mov    %edx,%edi
  80160d:	89 d6                	mov    %edx,%esi
  80160f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801611:	5b                   	pop    %ebx
  801612:	5e                   	pop    %esi
  801613:	5f                   	pop    %edi
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    

00801616 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	57                   	push   %edi
  80161a:	56                   	push   %esi
  80161b:	53                   	push   %ebx
  80161c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80161f:	be 00 00 00 00       	mov    $0x0,%esi
  801624:	8b 55 08             	mov    0x8(%ebp),%edx
  801627:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80162a:	b8 04 00 00 00       	mov    $0x4,%eax
  80162f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801632:	89 f7                	mov    %esi,%edi
  801634:	cd 30                	int    $0x30
	if(check && ret > 0)
  801636:	85 c0                	test   %eax,%eax
  801638:	7f 08                	jg     801642 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80163a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5e                   	pop    %esi
  80163f:	5f                   	pop    %edi
  801640:	5d                   	pop    %ebp
  801641:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801642:	83 ec 0c             	sub    $0xc,%esp
  801645:	50                   	push   %eax
  801646:	6a 04                	push   $0x4
  801648:	68 af 37 80 00       	push   $0x8037af
  80164d:	6a 23                	push   $0x23
  80164f:	68 cc 37 80 00       	push   $0x8037cc
  801654:	e8 da f3 ff ff       	call   800a33 <_panic>

00801659 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	57                   	push   %edi
  80165d:	56                   	push   %esi
  80165e:	53                   	push   %ebx
  80165f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  801662:	8b 55 08             	mov    0x8(%ebp),%edx
  801665:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801668:	b8 05 00 00 00       	mov    $0x5,%eax
  80166d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801670:	8b 7d 14             	mov    0x14(%ebp),%edi
  801673:	8b 75 18             	mov    0x18(%ebp),%esi
  801676:	cd 30                	int    $0x30
	if(check && ret > 0)
  801678:	85 c0                	test   %eax,%eax
  80167a:	7f 08                	jg     801684 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80167c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80167f:	5b                   	pop    %ebx
  801680:	5e                   	pop    %esi
  801681:	5f                   	pop    %edi
  801682:	5d                   	pop    %ebp
  801683:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801684:	83 ec 0c             	sub    $0xc,%esp
  801687:	50                   	push   %eax
  801688:	6a 05                	push   $0x5
  80168a:	68 af 37 80 00       	push   $0x8037af
  80168f:	6a 23                	push   $0x23
  801691:	68 cc 37 80 00       	push   $0x8037cc
  801696:	e8 98 f3 ff ff       	call   800a33 <_panic>

0080169b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	57                   	push   %edi
  80169f:	56                   	push   %esi
  8016a0:	53                   	push   %ebx
  8016a1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8016a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016af:	b8 06 00 00 00       	mov    $0x6,%eax
  8016b4:	89 df                	mov    %ebx,%edi
  8016b6:	89 de                	mov    %ebx,%esi
  8016b8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	7f 08                	jg     8016c6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8016be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016c1:	5b                   	pop    %ebx
  8016c2:	5e                   	pop    %esi
  8016c3:	5f                   	pop    %edi
  8016c4:	5d                   	pop    %ebp
  8016c5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016c6:	83 ec 0c             	sub    $0xc,%esp
  8016c9:	50                   	push   %eax
  8016ca:	6a 06                	push   $0x6
  8016cc:	68 af 37 80 00       	push   $0x8037af
  8016d1:	6a 23                	push   $0x23
  8016d3:	68 cc 37 80 00       	push   $0x8037cc
  8016d8:	e8 56 f3 ff ff       	call   800a33 <_panic>

008016dd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	57                   	push   %edi
  8016e1:	56                   	push   %esi
  8016e2:	53                   	push   %ebx
  8016e3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8016e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016f1:	b8 08 00 00 00       	mov    $0x8,%eax
  8016f6:	89 df                	mov    %ebx,%edi
  8016f8:	89 de                	mov    %ebx,%esi
  8016fa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	7f 08                	jg     801708 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801700:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801703:	5b                   	pop    %ebx
  801704:	5e                   	pop    %esi
  801705:	5f                   	pop    %edi
  801706:	5d                   	pop    %ebp
  801707:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801708:	83 ec 0c             	sub    $0xc,%esp
  80170b:	50                   	push   %eax
  80170c:	6a 08                	push   $0x8
  80170e:	68 af 37 80 00       	push   $0x8037af
  801713:	6a 23                	push   $0x23
  801715:	68 cc 37 80 00       	push   $0x8037cc
  80171a:	e8 14 f3 ff ff       	call   800a33 <_panic>

0080171f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	57                   	push   %edi
  801723:	56                   	push   %esi
  801724:	53                   	push   %ebx
  801725:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  801728:	bb 00 00 00 00       	mov    $0x0,%ebx
  80172d:	8b 55 08             	mov    0x8(%ebp),%edx
  801730:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801733:	b8 09 00 00 00       	mov    $0x9,%eax
  801738:	89 df                	mov    %ebx,%edi
  80173a:	89 de                	mov    %ebx,%esi
  80173c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80173e:	85 c0                	test   %eax,%eax
  801740:	7f 08                	jg     80174a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801742:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801745:	5b                   	pop    %ebx
  801746:	5e                   	pop    %esi
  801747:	5f                   	pop    %edi
  801748:	5d                   	pop    %ebp
  801749:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80174a:	83 ec 0c             	sub    $0xc,%esp
  80174d:	50                   	push   %eax
  80174e:	6a 09                	push   $0x9
  801750:	68 af 37 80 00       	push   $0x8037af
  801755:	6a 23                	push   $0x23
  801757:	68 cc 37 80 00       	push   $0x8037cc
  80175c:	e8 d2 f2 ff ff       	call   800a33 <_panic>

00801761 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	57                   	push   %edi
  801765:	56                   	push   %esi
  801766:	53                   	push   %ebx
  801767:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80176a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80176f:	8b 55 08             	mov    0x8(%ebp),%edx
  801772:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801775:	b8 0a 00 00 00       	mov    $0xa,%eax
  80177a:	89 df                	mov    %ebx,%edi
  80177c:	89 de                	mov    %ebx,%esi
  80177e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801780:	85 c0                	test   %eax,%eax
  801782:	7f 08                	jg     80178c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801784:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801787:	5b                   	pop    %ebx
  801788:	5e                   	pop    %esi
  801789:	5f                   	pop    %edi
  80178a:	5d                   	pop    %ebp
  80178b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80178c:	83 ec 0c             	sub    $0xc,%esp
  80178f:	50                   	push   %eax
  801790:	6a 0a                	push   $0xa
  801792:	68 af 37 80 00       	push   $0x8037af
  801797:	6a 23                	push   $0x23
  801799:	68 cc 37 80 00       	push   $0x8037cc
  80179e:	e8 90 f2 ff ff       	call   800a33 <_panic>

008017a3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	57                   	push   %edi
  8017a7:	56                   	push   %esi
  8017a8:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8017a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017af:	b8 0c 00 00 00       	mov    $0xc,%eax
  8017b4:	be 00 00 00 00       	mov    $0x0,%esi
  8017b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017bc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8017bf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8017c1:	5b                   	pop    %ebx
  8017c2:	5e                   	pop    %esi
  8017c3:	5f                   	pop    %edi
  8017c4:	5d                   	pop    %ebp
  8017c5:	c3                   	ret    

008017c6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	57                   	push   %edi
  8017ca:	56                   	push   %esi
  8017cb:	53                   	push   %ebx
  8017cc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8017cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8017dc:	89 cb                	mov    %ecx,%ebx
  8017de:	89 cf                	mov    %ecx,%edi
  8017e0:	89 ce                	mov    %ecx,%esi
  8017e2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	7f 08                	jg     8017f0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8017e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017eb:	5b                   	pop    %ebx
  8017ec:	5e                   	pop    %esi
  8017ed:	5f                   	pop    %edi
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017f0:	83 ec 0c             	sub    $0xc,%esp
  8017f3:	50                   	push   %eax
  8017f4:	6a 0d                	push   $0xd
  8017f6:	68 af 37 80 00       	push   $0x8037af
  8017fb:	6a 23                	push   $0x23
  8017fd:	68 cc 37 80 00       	push   $0x8037cc
  801802:	e8 2c f2 ff ff       	call   800a33 <_panic>

00801807 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	53                   	push   %ebx
  80180b:	83 ec 04             	sub    $0x4,%esp
  80180e:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801811:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW))) { //只有因为写操作写时拷贝的地址这中情况，才可以抢救。否则一律panic
  801813:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801817:	74 74                	je     80188d <pgfault+0x86>
  801819:	89 d8                	mov    %ebx,%eax
  80181b:	c1 e8 0c             	shr    $0xc,%eax
  80181e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801825:	f6 c4 08             	test   $0x8,%ah
  801828:	74 63                	je     80188d <pgfault+0x86>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  80182a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_map(0, addr, 0, PFTEMP, PTE_U|PTE_P)) < 0)		//将当前进程PFTEMP也映射到当前进程addr指向的物理页
  801830:	83 ec 0c             	sub    $0xc,%esp
  801833:	6a 05                	push   $0x5
  801835:	68 00 f0 7f 00       	push   $0x7ff000
  80183a:	6a 00                	push   $0x0
  80183c:	53                   	push   %ebx
  80183d:	6a 00                	push   $0x0
  80183f:	e8 15 fe ff ff       	call   801659 <sys_page_map>
  801844:	83 c4 20             	add    $0x20,%esp
  801847:	85 c0                	test   %eax,%eax
  801849:	78 56                	js     8018a1 <pgfault+0x9a>
		panic("sys_page_map: %e", r);
	if ((r = sys_page_alloc(0, addr, PTE_P|PTE_U|PTE_W)) < 0)	//令当前进程addr指向新分配的物理页
  80184b:	83 ec 04             	sub    $0x4,%esp
  80184e:	6a 07                	push   $0x7
  801850:	53                   	push   %ebx
  801851:	6a 00                	push   $0x0
  801853:	e8 be fd ff ff       	call   801616 <sys_page_alloc>
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	85 c0                	test   %eax,%eax
  80185d:	78 54                	js     8018b3 <pgfault+0xac>
		panic("sys_page_alloc: %e", r);
	memmove(addr, PFTEMP, PGSIZE);								//将PFTEMP指向的物理页拷贝到addr指向的物理页
  80185f:	83 ec 04             	sub    $0x4,%esp
  801862:	68 00 10 00 00       	push   $0x1000
  801867:	68 00 f0 7f 00       	push   $0x7ff000
  80186c:	53                   	push   %ebx
  80186d:	e8 39 fb ff ff       	call   8013ab <memmove>
	if ((r = sys_page_unmap(0, PFTEMP)) < 0)					//解除当前进程PFTEMP映射
  801872:	83 c4 08             	add    $0x8,%esp
  801875:	68 00 f0 7f 00       	push   $0x7ff000
  80187a:	6a 00                	push   $0x0
  80187c:	e8 1a fe ff ff       	call   80169b <sys_page_unmap>
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	85 c0                	test   %eax,%eax
  801886:	78 3d                	js     8018c5 <pgfault+0xbe>
		panic("sys_page_unmap: %e", r);
}
  801888:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    
		panic("pgfault():not cow");
  80188d:	83 ec 04             	sub    $0x4,%esp
  801890:	68 da 37 80 00       	push   $0x8037da
  801895:	6a 1d                	push   $0x1d
  801897:	68 ec 37 80 00       	push   $0x8037ec
  80189c:	e8 92 f1 ff ff       	call   800a33 <_panic>
		panic("sys_page_map: %e", r);
  8018a1:	50                   	push   %eax
  8018a2:	68 f7 37 80 00       	push   $0x8037f7
  8018a7:	6a 2a                	push   $0x2a
  8018a9:	68 ec 37 80 00       	push   $0x8037ec
  8018ae:	e8 80 f1 ff ff       	call   800a33 <_panic>
		panic("sys_page_alloc: %e", r);
  8018b3:	50                   	push   %eax
  8018b4:	68 08 38 80 00       	push   $0x803808
  8018b9:	6a 2c                	push   $0x2c
  8018bb:	68 ec 37 80 00       	push   $0x8037ec
  8018c0:	e8 6e f1 ff ff       	call   800a33 <_panic>
		panic("sys_page_unmap: %e", r);
  8018c5:	50                   	push   %eax
  8018c6:	68 1b 38 80 00       	push   $0x80381b
  8018cb:	6a 2f                	push   $0x2f
  8018cd:	68 ec 37 80 00       	push   $0x8037ec
  8018d2:	e8 5c f1 ff ff       	call   800a33 <_panic>

008018d7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	57                   	push   %edi
  8018db:	56                   	push   %esi
  8018dc:	53                   	push   %ebx
  8018dd:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);	//设置缺页处理函数
  8018e0:	68 07 18 80 00       	push   $0x801807
  8018e5:	e8 86 15 00 00       	call   802e70 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8018ea:	b8 07 00 00 00       	mov    $0x7,%eax
  8018ef:	cd 30                	int    $0x30
  8018f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t envid = sys_exofork();	//系统调用，只是简单创建一个Env结构，复制当前用户环境寄存器状态，UTOP以下的页目录还没有建立
	if (envid == 0) {				//子进程将走这个逻辑
  8018f4:	83 c4 10             	add    $0x10,%esp
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	74 12                	je     80190d <fork+0x36>
  8018fb:	89 c7                	mov    %eax,%edi
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	if (envid < 0) {
  8018fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801901:	78 26                	js     801929 <fork+0x52>
		panic("sys_exofork: %e", envid);
	}

	uint32_t addr;
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  801903:	bb 00 00 00 00       	mov    $0x0,%ebx
  801908:	e9 94 00 00 00       	jmp    8019a1 <fork+0xca>
		thisenv = &envs[ENVX(sys_getenvid())];
  80190d:	e8 c6 fc ff ff       	call   8015d8 <sys_getenvid>
  801912:	25 ff 03 00 00       	and    $0x3ff,%eax
  801917:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80191a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80191f:	a3 24 54 80 00       	mov    %eax,0x805424
		return 0;
  801924:	e9 51 01 00 00       	jmp    801a7a <fork+0x1a3>
		panic("sys_exofork: %e", envid);
  801929:	ff 75 e4             	pushl  -0x1c(%ebp)
  80192c:	68 2e 38 80 00       	push   $0x80382e
  801931:	6a 6d                	push   $0x6d
  801933:	68 ec 37 80 00       	push   $0x8037ec
  801938:	e8 f6 f0 ff ff       	call   800a33 <_panic>
		sys_page_map(0, addr, envid, addr, PTE_SYSCALL);		//对于表示为PTE_SHARE的页，拷贝映射关系，并且两个进程都有读写权限
  80193d:	83 ec 0c             	sub    $0xc,%esp
  801940:	68 07 0e 00 00       	push   $0xe07
  801945:	56                   	push   %esi
  801946:	57                   	push   %edi
  801947:	56                   	push   %esi
  801948:	6a 00                	push   $0x0
  80194a:	e8 0a fd ff ff       	call   801659 <sys_page_map>
  80194f:	83 c4 20             	add    $0x20,%esp
  801952:	eb 3b                	jmp    80198f <fork+0xb8>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  801954:	83 ec 0c             	sub    $0xc,%esp
  801957:	68 05 08 00 00       	push   $0x805
  80195c:	56                   	push   %esi
  80195d:	57                   	push   %edi
  80195e:	56                   	push   %esi
  80195f:	6a 00                	push   $0x0
  801961:	e8 f3 fc ff ff       	call   801659 <sys_page_map>
  801966:	83 c4 20             	add    $0x20,%esp
  801969:	85 c0                	test   %eax,%eax
  80196b:	0f 88 a9 00 00 00    	js     801a1a <fork+0x143>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_COW|PTE_U|PTE_P)) < 0)
  801971:	83 ec 0c             	sub    $0xc,%esp
  801974:	68 05 08 00 00       	push   $0x805
  801979:	56                   	push   %esi
  80197a:	6a 00                	push   $0x0
  80197c:	56                   	push   %esi
  80197d:	6a 00                	push   $0x0
  80197f:	e8 d5 fc ff ff       	call   801659 <sys_page_map>
  801984:	83 c4 20             	add    $0x20,%esp
  801987:	85 c0                	test   %eax,%eax
  801989:	0f 88 9d 00 00 00    	js     801a2c <fork+0x155>
	for (addr = 0; addr < USTACKTOP; addr += PGSIZE) {
  80198f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801995:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80199b:	0f 84 9d 00 00 00    	je     801a3e <fork+0x167>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) //为什么uvpt[pagenumber]能访问到第pagenumber项页表条目：https://pdos.csail.mit.edu/6.828/2018/labs/lab4/uvpt.html
  8019a1:	89 d8                	mov    %ebx,%eax
  8019a3:	c1 e8 16             	shr    $0x16,%eax
  8019a6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019ad:	a8 01                	test   $0x1,%al
  8019af:	74 de                	je     80198f <fork+0xb8>
  8019b1:	89 d8                	mov    %ebx,%eax
  8019b3:	c1 e8 0c             	shr    $0xc,%eax
  8019b6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019bd:	f6 c2 01             	test   $0x1,%dl
  8019c0:	74 cd                	je     80198f <fork+0xb8>
			&& (uvpt[PGNUM(addr)] & PTE_U)) {
  8019c2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019c9:	f6 c2 04             	test   $0x4,%dl
  8019cc:	74 c1                	je     80198f <fork+0xb8>
	void *addr = (void*) (pn * PGSIZE);
  8019ce:	89 c6                	mov    %eax,%esi
  8019d0:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE) {
  8019d3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019da:	f6 c6 04             	test   $0x4,%dh
  8019dd:	0f 85 5a ff ff ff    	jne    80193d <fork+0x66>
	} else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW)) { //对于UTOP以下的可写的或者写时拷贝的页，拷贝映射关系的同时，需要同时标记当前进程和子进程的页表项为PTE_COW
  8019e3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019ea:	f6 c2 02             	test   $0x2,%dl
  8019ed:	0f 85 61 ff ff ff    	jne    801954 <fork+0x7d>
  8019f3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019fa:	f6 c4 08             	test   $0x8,%ah
  8019fd:	0f 85 51 ff ff ff    	jne    801954 <fork+0x7d>
		sys_page_map(0, addr, envid, addr, PTE_U|PTE_P);	//对于只读的页，只需要拷贝映射关系即可
  801a03:	83 ec 0c             	sub    $0xc,%esp
  801a06:	6a 05                	push   $0x5
  801a08:	56                   	push   %esi
  801a09:	57                   	push   %edi
  801a0a:	56                   	push   %esi
  801a0b:	6a 00                	push   $0x0
  801a0d:	e8 47 fc ff ff       	call   801659 <sys_page_map>
  801a12:	83 c4 20             	add    $0x20,%esp
  801a15:	e9 75 ff ff ff       	jmp    80198f <fork+0xb8>
			panic("sys_page_map：%e", r);
  801a1a:	50                   	push   %eax
  801a1b:	68 3e 38 80 00       	push   $0x80383e
  801a20:	6a 48                	push   $0x48
  801a22:	68 ec 37 80 00       	push   $0x8037ec
  801a27:	e8 07 f0 ff ff       	call   800a33 <_panic>
			panic("sys_page_map：%e", r);
  801a2c:	50                   	push   %eax
  801a2d:	68 3e 38 80 00       	push   $0x80383e
  801a32:	6a 4a                	push   $0x4a
  801a34:	68 ec 37 80 00       	push   $0x8037ec
  801a39:	e8 f5 ef ff ff       	call   800a33 <_panic>
			duppage(envid, PGNUM(addr));	//拷贝当前进程映射关系到子进程
		}
	}
	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP-PGSIZE), PTE_P | PTE_W | PTE_U)) < 0)	//为子进程分配异常栈
  801a3e:	83 ec 04             	sub    $0x4,%esp
  801a41:	6a 07                	push   $0x7
  801a43:	68 00 f0 bf ee       	push   $0xeebff000
  801a48:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a4b:	e8 c6 fb ff ff       	call   801616 <sys_page_alloc>
  801a50:	83 c4 10             	add    $0x10,%esp
  801a53:	85 c0                	test   %eax,%eax
  801a55:	78 2e                	js     801a85 <fork+0x1ae>
		panic("sys_page_alloc: %e", r);
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);		//为子进程设置_pgfault_upcall
  801a57:	83 ec 08             	sub    $0x8,%esp
  801a5a:	68 c9 2e 80 00       	push   $0x802ec9
  801a5f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801a62:	57                   	push   %edi
  801a63:	e8 f9 fc ff ff       	call   801761 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)	//设置子进程为ENV_RUNNABLE状态
  801a68:	83 c4 08             	add    $0x8,%esp
  801a6b:	6a 02                	push   $0x2
  801a6d:	57                   	push   %edi
  801a6e:	e8 6a fc ff ff       	call   8016dd <sys_env_set_status>
  801a73:	83 c4 10             	add    $0x10,%esp
  801a76:	85 c0                	test   %eax,%eax
  801a78:	78 1d                	js     801a97 <fork+0x1c0>
		panic("sys_env_set_status: %e", r);
	return envid;
}
  801a7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a80:	5b                   	pop    %ebx
  801a81:	5e                   	pop    %esi
  801a82:	5f                   	pop    %edi
  801a83:	5d                   	pop    %ebp
  801a84:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801a85:	50                   	push   %eax
  801a86:	68 08 38 80 00       	push   $0x803808
  801a8b:	6a 79                	push   $0x79
  801a8d:	68 ec 37 80 00       	push   $0x8037ec
  801a92:	e8 9c ef ff ff       	call   800a33 <_panic>
		panic("sys_env_set_status: %e", r);
  801a97:	50                   	push   %eax
  801a98:	68 50 38 80 00       	push   $0x803850
  801a9d:	6a 7d                	push   $0x7d
  801a9f:	68 ec 37 80 00       	push   $0x8037ec
  801aa4:	e8 8a ef ff ff       	call   800a33 <_panic>

00801aa9 <sfork>:

// Challenge!
int
sfork(void)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801aaf:	68 67 38 80 00       	push   $0x803867
  801ab4:	68 85 00 00 00       	push   $0x85
  801ab9:	68 ec 37 80 00       	push   $0x8037ec
  801abe:	e8 70 ef ff ff       	call   800a33 <_panic>

00801ac3 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	8b 55 08             	mov    0x8(%ebp),%edx
  801ac9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801acc:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801acf:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801ad1:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801ad4:	83 3a 01             	cmpl   $0x1,(%edx)
  801ad7:	7e 09                	jle    801ae2 <argstart+0x1f>
  801ad9:	ba 81 32 80 00       	mov    $0x803281,%edx
  801ade:	85 c9                	test   %ecx,%ecx
  801ae0:	75 05                	jne    801ae7 <argstart+0x24>
  801ae2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae7:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801aea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801af1:	5d                   	pop    %ebp
  801af2:	c3                   	ret    

00801af3 <argnext>:

int
argnext(struct Argstate *args)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	53                   	push   %ebx
  801af7:	83 ec 04             	sub    $0x4,%esp
  801afa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801afd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801b04:	8b 43 08             	mov    0x8(%ebx),%eax
  801b07:	85 c0                	test   %eax,%eax
  801b09:	74 72                	je     801b7d <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801b0b:	80 38 00             	cmpb   $0x0,(%eax)
  801b0e:	75 48                	jne    801b58 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801b10:	8b 0b                	mov    (%ebx),%ecx
  801b12:	83 39 01             	cmpl   $0x1,(%ecx)
  801b15:	74 58                	je     801b6f <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801b17:	8b 53 04             	mov    0x4(%ebx),%edx
  801b1a:	8b 42 04             	mov    0x4(%edx),%eax
  801b1d:	80 38 2d             	cmpb   $0x2d,(%eax)
  801b20:	75 4d                	jne    801b6f <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801b22:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801b26:	74 47                	je     801b6f <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801b28:	83 c0 01             	add    $0x1,%eax
  801b2b:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801b2e:	83 ec 04             	sub    $0x4,%esp
  801b31:	8b 01                	mov    (%ecx),%eax
  801b33:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801b3a:	50                   	push   %eax
  801b3b:	8d 42 08             	lea    0x8(%edx),%eax
  801b3e:	50                   	push   %eax
  801b3f:	83 c2 04             	add    $0x4,%edx
  801b42:	52                   	push   %edx
  801b43:	e8 63 f8 ff ff       	call   8013ab <memmove>
		(*args->argc)--;
  801b48:	8b 03                	mov    (%ebx),%eax
  801b4a:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801b4d:	8b 43 08             	mov    0x8(%ebx),%eax
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	80 38 2d             	cmpb   $0x2d,(%eax)
  801b56:	74 11                	je     801b69 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801b58:	8b 53 08             	mov    0x8(%ebx),%edx
  801b5b:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801b5e:	83 c2 01             	add    $0x1,%edx
  801b61:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801b64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801b69:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801b6d:	75 e9                	jne    801b58 <argnext+0x65>
	args->curarg = 0;
  801b6f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801b76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801b7b:	eb e7                	jmp    801b64 <argnext+0x71>
		return -1;
  801b7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801b82:	eb e0                	jmp    801b64 <argnext+0x71>

00801b84 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	53                   	push   %ebx
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801b8e:	8b 43 08             	mov    0x8(%ebx),%eax
  801b91:	85 c0                	test   %eax,%eax
  801b93:	74 5b                	je     801bf0 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  801b95:	80 38 00             	cmpb   $0x0,(%eax)
  801b98:	74 12                	je     801bac <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801b9a:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801b9d:	c7 43 08 81 32 80 00 	movl   $0x803281,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801ba4:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801ba7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    
	} else if (*args->argc > 1) {
  801bac:	8b 13                	mov    (%ebx),%edx
  801bae:	83 3a 01             	cmpl   $0x1,(%edx)
  801bb1:	7f 10                	jg     801bc3 <argnextvalue+0x3f>
		args->argvalue = 0;
  801bb3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801bba:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801bc1:	eb e1                	jmp    801ba4 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801bc3:	8b 43 04             	mov    0x4(%ebx),%eax
  801bc6:	8b 48 04             	mov    0x4(%eax),%ecx
  801bc9:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801bcc:	83 ec 04             	sub    $0x4,%esp
  801bcf:	8b 12                	mov    (%edx),%edx
  801bd1:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801bd8:	52                   	push   %edx
  801bd9:	8d 50 08             	lea    0x8(%eax),%edx
  801bdc:	52                   	push   %edx
  801bdd:	83 c0 04             	add    $0x4,%eax
  801be0:	50                   	push   %eax
  801be1:	e8 c5 f7 ff ff       	call   8013ab <memmove>
		(*args->argc)--;
  801be6:	8b 03                	mov    (%ebx),%eax
  801be8:	83 28 01             	subl   $0x1,(%eax)
  801beb:	83 c4 10             	add    $0x10,%esp
  801bee:	eb b4                	jmp    801ba4 <argnextvalue+0x20>
		return 0;
  801bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf5:	eb b0                	jmp    801ba7 <argnextvalue+0x23>

00801bf7 <argvalue>:
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 08             	sub    $0x8,%esp
  801bfd:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801c00:	8b 42 0c             	mov    0xc(%edx),%eax
  801c03:	85 c0                	test   %eax,%eax
  801c05:	74 02                	je     801c09 <argvalue+0x12>
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801c09:	83 ec 0c             	sub    $0xc,%esp
  801c0c:	52                   	push   %edx
  801c0d:	e8 72 ff ff ff       	call   801b84 <argnextvalue>
  801c12:	83 c4 10             	add    $0x10,%esp
  801c15:	eb f0                	jmp    801c07 <argvalue+0x10>

00801c17 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	05 00 00 00 30       	add    $0x30000000,%eax
  801c22:	c1 e8 0c             	shr    $0xc,%eax
}
  801c25:	5d                   	pop    %ebp
  801c26:	c3                   	ret    

00801c27 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801c32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c37:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801c3c:	5d                   	pop    %ebp
  801c3d:	c3                   	ret    

00801c3e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c44:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801c49:	89 c2                	mov    %eax,%edx
  801c4b:	c1 ea 16             	shr    $0x16,%edx
  801c4e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801c55:	f6 c2 01             	test   $0x1,%dl
  801c58:	74 2a                	je     801c84 <fd_alloc+0x46>
  801c5a:	89 c2                	mov    %eax,%edx
  801c5c:	c1 ea 0c             	shr    $0xc,%edx
  801c5f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c66:	f6 c2 01             	test   $0x1,%dl
  801c69:	74 19                	je     801c84 <fd_alloc+0x46>
  801c6b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801c70:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801c75:	75 d2                	jne    801c49 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801c77:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801c7d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801c82:	eb 07                	jmp    801c8b <fd_alloc+0x4d>
			*fd_store = fd;
  801c84:	89 01                	mov    %eax,(%ecx)
			return 0;
  801c86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    

00801c8d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801c93:	83 f8 1f             	cmp    $0x1f,%eax
  801c96:	77 36                	ja     801cce <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801c98:	c1 e0 0c             	shl    $0xc,%eax
  801c9b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ca0:	89 c2                	mov    %eax,%edx
  801ca2:	c1 ea 16             	shr    $0x16,%edx
  801ca5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801cac:	f6 c2 01             	test   $0x1,%dl
  801caf:	74 24                	je     801cd5 <fd_lookup+0x48>
  801cb1:	89 c2                	mov    %eax,%edx
  801cb3:	c1 ea 0c             	shr    $0xc,%edx
  801cb6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801cbd:	f6 c2 01             	test   $0x1,%dl
  801cc0:	74 1a                	je     801cdc <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801cc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc5:	89 02                	mov    %eax,(%edx)
	return 0;
  801cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccc:	5d                   	pop    %ebp
  801ccd:	c3                   	ret    
		return -E_INVAL;
  801cce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cd3:	eb f7                	jmp    801ccc <fd_lookup+0x3f>
		return -E_INVAL;
  801cd5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cda:	eb f0                	jmp    801ccc <fd_lookup+0x3f>
  801cdc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ce1:	eb e9                	jmp    801ccc <fd_lookup+0x3f>

00801ce3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 08             	sub    $0x8,%esp
  801ce9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cec:	ba fc 38 80 00       	mov    $0x8038fc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801cf1:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801cf6:	39 08                	cmp    %ecx,(%eax)
  801cf8:	74 33                	je     801d2d <dev_lookup+0x4a>
  801cfa:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801cfd:	8b 02                	mov    (%edx),%eax
  801cff:	85 c0                	test   %eax,%eax
  801d01:	75 f3                	jne    801cf6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801d03:	a1 24 54 80 00       	mov    0x805424,%eax
  801d08:	8b 40 48             	mov    0x48(%eax),%eax
  801d0b:	83 ec 04             	sub    $0x4,%esp
  801d0e:	51                   	push   %ecx
  801d0f:	50                   	push   %eax
  801d10:	68 80 38 80 00       	push   $0x803880
  801d15:	e8 f4 ed ff ff       	call   800b0e <cprintf>
	*dev = 0;
  801d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801d23:	83 c4 10             	add    $0x10,%esp
  801d26:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    
			*dev = devtab[i];
  801d2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d30:	89 01                	mov    %eax,(%ecx)
			return 0;
  801d32:	b8 00 00 00 00       	mov    $0x0,%eax
  801d37:	eb f2                	jmp    801d2b <dev_lookup+0x48>

00801d39 <fd_close>:
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	57                   	push   %edi
  801d3d:	56                   	push   %esi
  801d3e:	53                   	push   %ebx
  801d3f:	83 ec 1c             	sub    $0x1c,%esp
  801d42:	8b 75 08             	mov    0x8(%ebp),%esi
  801d45:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801d48:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801d4b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d4c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801d52:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801d55:	50                   	push   %eax
  801d56:	e8 32 ff ff ff       	call   801c8d <fd_lookup>
  801d5b:	89 c3                	mov    %eax,%ebx
  801d5d:	83 c4 08             	add    $0x8,%esp
  801d60:	85 c0                	test   %eax,%eax
  801d62:	78 05                	js     801d69 <fd_close+0x30>
	    || fd != fd2)
  801d64:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801d67:	74 16                	je     801d7f <fd_close+0x46>
		return (must_exist ? r : 0);
  801d69:	89 f8                	mov    %edi,%eax
  801d6b:	84 c0                	test   %al,%al
  801d6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d72:	0f 44 d8             	cmove  %eax,%ebx
}
  801d75:	89 d8                	mov    %ebx,%eax
  801d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d7a:	5b                   	pop    %ebx
  801d7b:	5e                   	pop    %esi
  801d7c:	5f                   	pop    %edi
  801d7d:	5d                   	pop    %ebp
  801d7e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801d7f:	83 ec 08             	sub    $0x8,%esp
  801d82:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801d85:	50                   	push   %eax
  801d86:	ff 36                	pushl  (%esi)
  801d88:	e8 56 ff ff ff       	call   801ce3 <dev_lookup>
  801d8d:	89 c3                	mov    %eax,%ebx
  801d8f:	83 c4 10             	add    $0x10,%esp
  801d92:	85 c0                	test   %eax,%eax
  801d94:	78 15                	js     801dab <fd_close+0x72>
		if (dev->dev_close)
  801d96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d99:	8b 40 10             	mov    0x10(%eax),%eax
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	74 1b                	je     801dbb <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801da0:	83 ec 0c             	sub    $0xc,%esp
  801da3:	56                   	push   %esi
  801da4:	ff d0                	call   *%eax
  801da6:	89 c3                	mov    %eax,%ebx
  801da8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801dab:	83 ec 08             	sub    $0x8,%esp
  801dae:	56                   	push   %esi
  801daf:	6a 00                	push   $0x0
  801db1:	e8 e5 f8 ff ff       	call   80169b <sys_page_unmap>
	return r;
  801db6:	83 c4 10             	add    $0x10,%esp
  801db9:	eb ba                	jmp    801d75 <fd_close+0x3c>
			r = 0;
  801dbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dc0:	eb e9                	jmp    801dab <fd_close+0x72>

00801dc2 <close>:

int
close(int fdnum)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dcb:	50                   	push   %eax
  801dcc:	ff 75 08             	pushl  0x8(%ebp)
  801dcf:	e8 b9 fe ff ff       	call   801c8d <fd_lookup>
  801dd4:	83 c4 08             	add    $0x8,%esp
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	78 10                	js     801deb <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801ddb:	83 ec 08             	sub    $0x8,%esp
  801dde:	6a 01                	push   $0x1
  801de0:	ff 75 f4             	pushl  -0xc(%ebp)
  801de3:	e8 51 ff ff ff       	call   801d39 <fd_close>
  801de8:	83 c4 10             	add    $0x10,%esp
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <close_all>:

void
close_all(void)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	53                   	push   %ebx
  801df1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801df4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801df9:	83 ec 0c             	sub    $0xc,%esp
  801dfc:	53                   	push   %ebx
  801dfd:	e8 c0 ff ff ff       	call   801dc2 <close>
	for (i = 0; i < MAXFD; i++)
  801e02:	83 c3 01             	add    $0x1,%ebx
  801e05:	83 c4 10             	add    $0x10,%esp
  801e08:	83 fb 20             	cmp    $0x20,%ebx
  801e0b:	75 ec                	jne    801df9 <close_all+0xc>
}
  801e0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	57                   	push   %edi
  801e16:	56                   	push   %esi
  801e17:	53                   	push   %ebx
  801e18:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801e1b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801e1e:	50                   	push   %eax
  801e1f:	ff 75 08             	pushl  0x8(%ebp)
  801e22:	e8 66 fe ff ff       	call   801c8d <fd_lookup>
  801e27:	89 c3                	mov    %eax,%ebx
  801e29:	83 c4 08             	add    $0x8,%esp
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	0f 88 81 00 00 00    	js     801eb5 <dup+0xa3>
		return r;
	close(newfdnum);
  801e34:	83 ec 0c             	sub    $0xc,%esp
  801e37:	ff 75 0c             	pushl  0xc(%ebp)
  801e3a:	e8 83 ff ff ff       	call   801dc2 <close>

	newfd = INDEX2FD(newfdnum);
  801e3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e42:	c1 e6 0c             	shl    $0xc,%esi
  801e45:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801e4b:	83 c4 04             	add    $0x4,%esp
  801e4e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e51:	e8 d1 fd ff ff       	call   801c27 <fd2data>
  801e56:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801e58:	89 34 24             	mov    %esi,(%esp)
  801e5b:	e8 c7 fd ff ff       	call   801c27 <fd2data>
  801e60:	83 c4 10             	add    $0x10,%esp
  801e63:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801e65:	89 d8                	mov    %ebx,%eax
  801e67:	c1 e8 16             	shr    $0x16,%eax
  801e6a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e71:	a8 01                	test   $0x1,%al
  801e73:	74 11                	je     801e86 <dup+0x74>
  801e75:	89 d8                	mov    %ebx,%eax
  801e77:	c1 e8 0c             	shr    $0xc,%eax
  801e7a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e81:	f6 c2 01             	test   $0x1,%dl
  801e84:	75 39                	jne    801ebf <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801e86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e89:	89 d0                	mov    %edx,%eax
  801e8b:	c1 e8 0c             	shr    $0xc,%eax
  801e8e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e95:	83 ec 0c             	sub    $0xc,%esp
  801e98:	25 07 0e 00 00       	and    $0xe07,%eax
  801e9d:	50                   	push   %eax
  801e9e:	56                   	push   %esi
  801e9f:	6a 00                	push   $0x0
  801ea1:	52                   	push   %edx
  801ea2:	6a 00                	push   $0x0
  801ea4:	e8 b0 f7 ff ff       	call   801659 <sys_page_map>
  801ea9:	89 c3                	mov    %eax,%ebx
  801eab:	83 c4 20             	add    $0x20,%esp
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	78 31                	js     801ee3 <dup+0xd1>
		goto err;

	return newfdnum;
  801eb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801eb5:	89 d8                	mov    %ebx,%eax
  801eb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eba:	5b                   	pop    %ebx
  801ebb:	5e                   	pop    %esi
  801ebc:	5f                   	pop    %edi
  801ebd:	5d                   	pop    %ebp
  801ebe:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801ebf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ec6:	83 ec 0c             	sub    $0xc,%esp
  801ec9:	25 07 0e 00 00       	and    $0xe07,%eax
  801ece:	50                   	push   %eax
  801ecf:	57                   	push   %edi
  801ed0:	6a 00                	push   $0x0
  801ed2:	53                   	push   %ebx
  801ed3:	6a 00                	push   $0x0
  801ed5:	e8 7f f7 ff ff       	call   801659 <sys_page_map>
  801eda:	89 c3                	mov    %eax,%ebx
  801edc:	83 c4 20             	add    $0x20,%esp
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	79 a3                	jns    801e86 <dup+0x74>
	sys_page_unmap(0, newfd);
  801ee3:	83 ec 08             	sub    $0x8,%esp
  801ee6:	56                   	push   %esi
  801ee7:	6a 00                	push   $0x0
  801ee9:	e8 ad f7 ff ff       	call   80169b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801eee:	83 c4 08             	add    $0x8,%esp
  801ef1:	57                   	push   %edi
  801ef2:	6a 00                	push   $0x0
  801ef4:	e8 a2 f7 ff ff       	call   80169b <sys_page_unmap>
	return r;
  801ef9:	83 c4 10             	add    $0x10,%esp
  801efc:	eb b7                	jmp    801eb5 <dup+0xa3>

00801efe <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	53                   	push   %ebx
  801f02:	83 ec 14             	sub    $0x14,%esp
  801f05:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f08:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f0b:	50                   	push   %eax
  801f0c:	53                   	push   %ebx
  801f0d:	e8 7b fd ff ff       	call   801c8d <fd_lookup>
  801f12:	83 c4 08             	add    $0x8,%esp
  801f15:	85 c0                	test   %eax,%eax
  801f17:	78 3f                	js     801f58 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f19:	83 ec 08             	sub    $0x8,%esp
  801f1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1f:	50                   	push   %eax
  801f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f23:	ff 30                	pushl  (%eax)
  801f25:	e8 b9 fd ff ff       	call   801ce3 <dev_lookup>
  801f2a:	83 c4 10             	add    $0x10,%esp
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	78 27                	js     801f58 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801f31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f34:	8b 42 08             	mov    0x8(%edx),%eax
  801f37:	83 e0 03             	and    $0x3,%eax
  801f3a:	83 f8 01             	cmp    $0x1,%eax
  801f3d:	74 1e                	je     801f5d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f42:	8b 40 08             	mov    0x8(%eax),%eax
  801f45:	85 c0                	test   %eax,%eax
  801f47:	74 35                	je     801f7e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801f49:	83 ec 04             	sub    $0x4,%esp
  801f4c:	ff 75 10             	pushl  0x10(%ebp)
  801f4f:	ff 75 0c             	pushl  0xc(%ebp)
  801f52:	52                   	push   %edx
  801f53:	ff d0                	call   *%eax
  801f55:	83 c4 10             	add    $0x10,%esp
}
  801f58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801f5d:	a1 24 54 80 00       	mov    0x805424,%eax
  801f62:	8b 40 48             	mov    0x48(%eax),%eax
  801f65:	83 ec 04             	sub    $0x4,%esp
  801f68:	53                   	push   %ebx
  801f69:	50                   	push   %eax
  801f6a:	68 c1 38 80 00       	push   $0x8038c1
  801f6f:	e8 9a eb ff ff       	call   800b0e <cprintf>
		return -E_INVAL;
  801f74:	83 c4 10             	add    $0x10,%esp
  801f77:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f7c:	eb da                	jmp    801f58 <read+0x5a>
		return -E_NOT_SUPP;
  801f7e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f83:	eb d3                	jmp    801f58 <read+0x5a>

00801f85 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	57                   	push   %edi
  801f89:	56                   	push   %esi
  801f8a:	53                   	push   %ebx
  801f8b:	83 ec 0c             	sub    $0xc,%esp
  801f8e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f91:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801f94:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f99:	39 f3                	cmp    %esi,%ebx
  801f9b:	73 25                	jae    801fc2 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801f9d:	83 ec 04             	sub    $0x4,%esp
  801fa0:	89 f0                	mov    %esi,%eax
  801fa2:	29 d8                	sub    %ebx,%eax
  801fa4:	50                   	push   %eax
  801fa5:	89 d8                	mov    %ebx,%eax
  801fa7:	03 45 0c             	add    0xc(%ebp),%eax
  801faa:	50                   	push   %eax
  801fab:	57                   	push   %edi
  801fac:	e8 4d ff ff ff       	call   801efe <read>
		if (m < 0)
  801fb1:	83 c4 10             	add    $0x10,%esp
  801fb4:	85 c0                	test   %eax,%eax
  801fb6:	78 08                	js     801fc0 <readn+0x3b>
			return m;
		if (m == 0)
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	74 06                	je     801fc2 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801fbc:	01 c3                	add    %eax,%ebx
  801fbe:	eb d9                	jmp    801f99 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801fc0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801fc2:	89 d8                	mov    %ebx,%eax
  801fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc7:	5b                   	pop    %ebx
  801fc8:	5e                   	pop    %esi
  801fc9:	5f                   	pop    %edi
  801fca:	5d                   	pop    %ebp
  801fcb:	c3                   	ret    

00801fcc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	53                   	push   %ebx
  801fd0:	83 ec 14             	sub    $0x14,%esp
  801fd3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801fd6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fd9:	50                   	push   %eax
  801fda:	53                   	push   %ebx
  801fdb:	e8 ad fc ff ff       	call   801c8d <fd_lookup>
  801fe0:	83 c4 08             	add    $0x8,%esp
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	78 3a                	js     802021 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801fe7:	83 ec 08             	sub    $0x8,%esp
  801fea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fed:	50                   	push   %eax
  801fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff1:	ff 30                	pushl  (%eax)
  801ff3:	e8 eb fc ff ff       	call   801ce3 <dev_lookup>
  801ff8:	83 c4 10             	add    $0x10,%esp
  801ffb:	85 c0                	test   %eax,%eax
  801ffd:	78 22                	js     802021 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802002:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802006:	74 1e                	je     802026 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802008:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200b:	8b 52 0c             	mov    0xc(%edx),%edx
  80200e:	85 d2                	test   %edx,%edx
  802010:	74 35                	je     802047 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802012:	83 ec 04             	sub    $0x4,%esp
  802015:	ff 75 10             	pushl  0x10(%ebp)
  802018:	ff 75 0c             	pushl  0xc(%ebp)
  80201b:	50                   	push   %eax
  80201c:	ff d2                	call   *%edx
  80201e:	83 c4 10             	add    $0x10,%esp
}
  802021:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802024:	c9                   	leave  
  802025:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802026:	a1 24 54 80 00       	mov    0x805424,%eax
  80202b:	8b 40 48             	mov    0x48(%eax),%eax
  80202e:	83 ec 04             	sub    $0x4,%esp
  802031:	53                   	push   %ebx
  802032:	50                   	push   %eax
  802033:	68 dd 38 80 00       	push   $0x8038dd
  802038:	e8 d1 ea ff ff       	call   800b0e <cprintf>
		return -E_INVAL;
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802045:	eb da                	jmp    802021 <write+0x55>
		return -E_NOT_SUPP;
  802047:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80204c:	eb d3                	jmp    802021 <write+0x55>

0080204e <seek>:

int
seek(int fdnum, off_t offset)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802054:	8d 45 fc             	lea    -0x4(%ebp),%eax
  802057:	50                   	push   %eax
  802058:	ff 75 08             	pushl  0x8(%ebp)
  80205b:	e8 2d fc ff ff       	call   801c8d <fd_lookup>
  802060:	83 c4 08             	add    $0x8,%esp
  802063:	85 c0                	test   %eax,%eax
  802065:	78 0e                	js     802075 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802067:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802070:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	53                   	push   %ebx
  80207b:	83 ec 14             	sub    $0x14,%esp
  80207e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802081:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802084:	50                   	push   %eax
  802085:	53                   	push   %ebx
  802086:	e8 02 fc ff ff       	call   801c8d <fd_lookup>
  80208b:	83 c4 08             	add    $0x8,%esp
  80208e:	85 c0                	test   %eax,%eax
  802090:	78 37                	js     8020c9 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802092:	83 ec 08             	sub    $0x8,%esp
  802095:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802098:	50                   	push   %eax
  802099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209c:	ff 30                	pushl  (%eax)
  80209e:	e8 40 fc ff ff       	call   801ce3 <dev_lookup>
  8020a3:	83 c4 10             	add    $0x10,%esp
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	78 1f                	js     8020c9 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ad:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8020b1:	74 1b                	je     8020ce <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8020b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b6:	8b 52 18             	mov    0x18(%edx),%edx
  8020b9:	85 d2                	test   %edx,%edx
  8020bb:	74 32                	je     8020ef <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8020bd:	83 ec 08             	sub    $0x8,%esp
  8020c0:	ff 75 0c             	pushl  0xc(%ebp)
  8020c3:	50                   	push   %eax
  8020c4:	ff d2                	call   *%edx
  8020c6:	83 c4 10             	add    $0x10,%esp
}
  8020c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    
			thisenv->env_id, fdnum);
  8020ce:	a1 24 54 80 00       	mov    0x805424,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8020d3:	8b 40 48             	mov    0x48(%eax),%eax
  8020d6:	83 ec 04             	sub    $0x4,%esp
  8020d9:	53                   	push   %ebx
  8020da:	50                   	push   %eax
  8020db:	68 a0 38 80 00       	push   $0x8038a0
  8020e0:	e8 29 ea ff ff       	call   800b0e <cprintf>
		return -E_INVAL;
  8020e5:	83 c4 10             	add    $0x10,%esp
  8020e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020ed:	eb da                	jmp    8020c9 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8020ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020f4:	eb d3                	jmp    8020c9 <ftruncate+0x52>

008020f6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	53                   	push   %ebx
  8020fa:	83 ec 14             	sub    $0x14,%esp
  8020fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802100:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802103:	50                   	push   %eax
  802104:	ff 75 08             	pushl  0x8(%ebp)
  802107:	e8 81 fb ff ff       	call   801c8d <fd_lookup>
  80210c:	83 c4 08             	add    $0x8,%esp
  80210f:	85 c0                	test   %eax,%eax
  802111:	78 4b                	js     80215e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802113:	83 ec 08             	sub    $0x8,%esp
  802116:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802119:	50                   	push   %eax
  80211a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211d:	ff 30                	pushl  (%eax)
  80211f:	e8 bf fb ff ff       	call   801ce3 <dev_lookup>
  802124:	83 c4 10             	add    $0x10,%esp
  802127:	85 c0                	test   %eax,%eax
  802129:	78 33                	js     80215e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80212b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802132:	74 2f                	je     802163 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802134:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802137:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80213e:	00 00 00 
	stat->st_isdir = 0;
  802141:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802148:	00 00 00 
	stat->st_dev = dev;
  80214b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802151:	83 ec 08             	sub    $0x8,%esp
  802154:	53                   	push   %ebx
  802155:	ff 75 f0             	pushl  -0x10(%ebp)
  802158:	ff 50 14             	call   *0x14(%eax)
  80215b:	83 c4 10             	add    $0x10,%esp
}
  80215e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802161:	c9                   	leave  
  802162:	c3                   	ret    
		return -E_NOT_SUPP;
  802163:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802168:	eb f4                	jmp    80215e <fstat+0x68>

0080216a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	56                   	push   %esi
  80216e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80216f:	83 ec 08             	sub    $0x8,%esp
  802172:	6a 00                	push   $0x0
  802174:	ff 75 08             	pushl  0x8(%ebp)
  802177:	e8 30 02 00 00       	call   8023ac <open>
  80217c:	89 c3                	mov    %eax,%ebx
  80217e:	83 c4 10             	add    $0x10,%esp
  802181:	85 c0                	test   %eax,%eax
  802183:	78 1b                	js     8021a0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802185:	83 ec 08             	sub    $0x8,%esp
  802188:	ff 75 0c             	pushl  0xc(%ebp)
  80218b:	50                   	push   %eax
  80218c:	e8 65 ff ff ff       	call   8020f6 <fstat>
  802191:	89 c6                	mov    %eax,%esi
	close(fd);
  802193:	89 1c 24             	mov    %ebx,(%esp)
  802196:	e8 27 fc ff ff       	call   801dc2 <close>
	return r;
  80219b:	83 c4 10             	add    $0x10,%esp
  80219e:	89 f3                	mov    %esi,%ebx
}
  8021a0:	89 d8                	mov    %ebx,%eax
  8021a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021a5:	5b                   	pop    %ebx
  8021a6:	5e                   	pop    %esi
  8021a7:	5d                   	pop    %ebp
  8021a8:	c3                   	ret    

008021a9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	56                   	push   %esi
  8021ad:	53                   	push   %ebx
  8021ae:	89 c6                	mov    %eax,%esi
  8021b0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8021b2:	83 3d 20 54 80 00 00 	cmpl   $0x0,0x805420
  8021b9:	74 27                	je     8021e2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8021bb:	6a 07                	push   $0x7
  8021bd:	68 00 60 80 00       	push   $0x806000
  8021c2:	56                   	push   %esi
  8021c3:	ff 35 20 54 80 00    	pushl  0x805420
  8021c9:	e8 88 0d 00 00       	call   802f56 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8021ce:	83 c4 0c             	add    $0xc,%esp
  8021d1:	6a 00                	push   $0x0
  8021d3:	53                   	push   %ebx
  8021d4:	6a 00                	push   $0x0
  8021d6:	e8 12 0d 00 00       	call   802eed <ipc_recv>
}
  8021db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021de:	5b                   	pop    %ebx
  8021df:	5e                   	pop    %esi
  8021e0:	5d                   	pop    %ebp
  8021e1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8021e2:	83 ec 0c             	sub    $0xc,%esp
  8021e5:	6a 01                	push   $0x1
  8021e7:	e8 be 0d 00 00       	call   802faa <ipc_find_env>
  8021ec:	a3 20 54 80 00       	mov    %eax,0x805420
  8021f1:	83 c4 10             	add    $0x10,%esp
  8021f4:	eb c5                	jmp    8021bb <fsipc+0x12>

008021f6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802202:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  802207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220a:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80220f:	ba 00 00 00 00       	mov    $0x0,%edx
  802214:	b8 02 00 00 00       	mov    $0x2,%eax
  802219:	e8 8b ff ff ff       	call   8021a9 <fsipc>
}
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <devfile_flush>:
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
  802223:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	8b 40 0c             	mov    0xc(%eax),%eax
  80222c:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  802231:	ba 00 00 00 00       	mov    $0x0,%edx
  802236:	b8 06 00 00 00       	mov    $0x6,%eax
  80223b:	e8 69 ff ff ff       	call   8021a9 <fsipc>
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <devfile_stat>:
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	53                   	push   %ebx
  802246:	83 ec 04             	sub    $0x4,%esp
  802249:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	8b 40 0c             	mov    0xc(%eax),%eax
  802252:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802257:	ba 00 00 00 00       	mov    $0x0,%edx
  80225c:	b8 05 00 00 00       	mov    $0x5,%eax
  802261:	e8 43 ff ff ff       	call   8021a9 <fsipc>
  802266:	85 c0                	test   %eax,%eax
  802268:	78 2c                	js     802296 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80226a:	83 ec 08             	sub    $0x8,%esp
  80226d:	68 00 60 80 00       	push   $0x806000
  802272:	53                   	push   %ebx
  802273:	e8 a5 ef ff ff       	call   80121d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802278:	a1 80 60 80 00       	mov    0x806080,%eax
  80227d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802283:	a1 84 60 80 00       	mov    0x806084,%eax
  802288:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80228e:	83 c4 10             	add    $0x10,%esp
  802291:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802296:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <devfile_write>:
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	53                   	push   %ebx
  80229f:	83 ec 08             	sub    $0x8,%esp
  8022a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  8022a5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8022ab:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8022b0:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  8022be:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8022c4:	53                   	push   %ebx
  8022c5:	ff 75 0c             	pushl  0xc(%ebp)
  8022c8:	68 08 60 80 00       	push   $0x806008
  8022cd:	e8 d9 f0 ff ff       	call   8013ab <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8022d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8022d7:	b8 04 00 00 00       	mov    $0x4,%eax
  8022dc:	e8 c8 fe ff ff       	call   8021a9 <fsipc>
  8022e1:	83 c4 10             	add    $0x10,%esp
  8022e4:	85 c0                	test   %eax,%eax
  8022e6:	78 0b                	js     8022f3 <devfile_write+0x58>
	assert(r <= n);
  8022e8:	39 d8                	cmp    %ebx,%eax
  8022ea:	77 0c                	ja     8022f8 <devfile_write+0x5d>
	assert(r <= PGSIZE);
  8022ec:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8022f1:	7f 1e                	jg     802311 <devfile_write+0x76>
}
  8022f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    
	assert(r <= n);
  8022f8:	68 0c 39 80 00       	push   $0x80390c
  8022fd:	68 af 33 80 00       	push   $0x8033af
  802302:	68 98 00 00 00       	push   $0x98
  802307:	68 13 39 80 00       	push   $0x803913
  80230c:	e8 22 e7 ff ff       	call   800a33 <_panic>
	assert(r <= PGSIZE);
  802311:	68 1e 39 80 00       	push   $0x80391e
  802316:	68 af 33 80 00       	push   $0x8033af
  80231b:	68 99 00 00 00       	push   $0x99
  802320:	68 13 39 80 00       	push   $0x803913
  802325:	e8 09 e7 ff ff       	call   800a33 <_panic>

0080232a <devfile_read>:
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	56                   	push   %esi
  80232e:	53                   	push   %ebx
  80232f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	8b 40 0c             	mov    0xc(%eax),%eax
  802338:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80233d:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802343:	ba 00 00 00 00       	mov    $0x0,%edx
  802348:	b8 03 00 00 00       	mov    $0x3,%eax
  80234d:	e8 57 fe ff ff       	call   8021a9 <fsipc>
  802352:	89 c3                	mov    %eax,%ebx
  802354:	85 c0                	test   %eax,%eax
  802356:	78 1f                	js     802377 <devfile_read+0x4d>
	assert(r <= n);
  802358:	39 f0                	cmp    %esi,%eax
  80235a:	77 24                	ja     802380 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80235c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802361:	7f 33                	jg     802396 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802363:	83 ec 04             	sub    $0x4,%esp
  802366:	50                   	push   %eax
  802367:	68 00 60 80 00       	push   $0x806000
  80236c:	ff 75 0c             	pushl  0xc(%ebp)
  80236f:	e8 37 f0 ff ff       	call   8013ab <memmove>
	return r;
  802374:	83 c4 10             	add    $0x10,%esp
}
  802377:	89 d8                	mov    %ebx,%eax
  802379:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80237c:	5b                   	pop    %ebx
  80237d:	5e                   	pop    %esi
  80237e:	5d                   	pop    %ebp
  80237f:	c3                   	ret    
	assert(r <= n);
  802380:	68 0c 39 80 00       	push   $0x80390c
  802385:	68 af 33 80 00       	push   $0x8033af
  80238a:	6a 7c                	push   $0x7c
  80238c:	68 13 39 80 00       	push   $0x803913
  802391:	e8 9d e6 ff ff       	call   800a33 <_panic>
	assert(r <= PGSIZE);
  802396:	68 1e 39 80 00       	push   $0x80391e
  80239b:	68 af 33 80 00       	push   $0x8033af
  8023a0:	6a 7d                	push   $0x7d
  8023a2:	68 13 39 80 00       	push   $0x803913
  8023a7:	e8 87 e6 ff ff       	call   800a33 <_panic>

008023ac <open>:
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
  8023af:	56                   	push   %esi
  8023b0:	53                   	push   %ebx
  8023b1:	83 ec 1c             	sub    $0x1c,%esp
  8023b4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8023b7:	56                   	push   %esi
  8023b8:	e8 29 ee ff ff       	call   8011e6 <strlen>
  8023bd:	83 c4 10             	add    $0x10,%esp
  8023c0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8023c5:	7f 6c                	jg     802433 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8023c7:	83 ec 0c             	sub    $0xc,%esp
  8023ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023cd:	50                   	push   %eax
  8023ce:	e8 6b f8 ff ff       	call   801c3e <fd_alloc>
  8023d3:	89 c3                	mov    %eax,%ebx
  8023d5:	83 c4 10             	add    $0x10,%esp
  8023d8:	85 c0                	test   %eax,%eax
  8023da:	78 3c                	js     802418 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8023dc:	83 ec 08             	sub    $0x8,%esp
  8023df:	56                   	push   %esi
  8023e0:	68 00 60 80 00       	push   $0x806000
  8023e5:	e8 33 ee ff ff       	call   80121d <strcpy>
	fsipcbuf.open.req_omode = mode;
  8023ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ed:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8023f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8023fa:	e8 aa fd ff ff       	call   8021a9 <fsipc>
  8023ff:	89 c3                	mov    %eax,%ebx
  802401:	83 c4 10             	add    $0x10,%esp
  802404:	85 c0                	test   %eax,%eax
  802406:	78 19                	js     802421 <open+0x75>
	return fd2num(fd);
  802408:	83 ec 0c             	sub    $0xc,%esp
  80240b:	ff 75 f4             	pushl  -0xc(%ebp)
  80240e:	e8 04 f8 ff ff       	call   801c17 <fd2num>
  802413:	89 c3                	mov    %eax,%ebx
  802415:	83 c4 10             	add    $0x10,%esp
}
  802418:	89 d8                	mov    %ebx,%eax
  80241a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80241d:	5b                   	pop    %ebx
  80241e:	5e                   	pop    %esi
  80241f:	5d                   	pop    %ebp
  802420:	c3                   	ret    
		fd_close(fd, 0);
  802421:	83 ec 08             	sub    $0x8,%esp
  802424:	6a 00                	push   $0x0
  802426:	ff 75 f4             	pushl  -0xc(%ebp)
  802429:	e8 0b f9 ff ff       	call   801d39 <fd_close>
		return r;
  80242e:	83 c4 10             	add    $0x10,%esp
  802431:	eb e5                	jmp    802418 <open+0x6c>
		return -E_BAD_PATH;
  802433:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802438:	eb de                	jmp    802418 <open+0x6c>

0080243a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
  80243d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802440:	ba 00 00 00 00       	mov    $0x0,%edx
  802445:	b8 08 00 00 00       	mov    $0x8,%eax
  80244a:	e8 5a fd ff ff       	call   8021a9 <fsipc>
}
  80244f:	c9                   	leave  
  802450:	c3                   	ret    

00802451 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  802451:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802455:	7e 38                	jle    80248f <writebuf+0x3e>
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
  80245a:	53                   	push   %ebx
  80245b:	83 ec 08             	sub    $0x8,%esp
  80245e:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  802460:	ff 70 04             	pushl  0x4(%eax)
  802463:	8d 40 10             	lea    0x10(%eax),%eax
  802466:	50                   	push   %eax
  802467:	ff 33                	pushl  (%ebx)
  802469:	e8 5e fb ff ff       	call   801fcc <write>
		if (result > 0)
  80246e:	83 c4 10             	add    $0x10,%esp
  802471:	85 c0                	test   %eax,%eax
  802473:	7e 03                	jle    802478 <writebuf+0x27>
			b->result += result;
  802475:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  802478:	39 43 04             	cmp    %eax,0x4(%ebx)
  80247b:	74 0d                	je     80248a <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  80247d:	85 c0                	test   %eax,%eax
  80247f:	ba 00 00 00 00       	mov    $0x0,%edx
  802484:	0f 4f c2             	cmovg  %edx,%eax
  802487:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80248a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    
  80248f:	f3 c3                	repz ret 

00802491 <putch>:

static void
putch(int ch, void *thunk)
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	53                   	push   %ebx
  802495:	83 ec 04             	sub    $0x4,%esp
  802498:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80249b:	8b 53 04             	mov    0x4(%ebx),%edx
  80249e:	8d 42 01             	lea    0x1(%edx),%eax
  8024a1:	89 43 04             	mov    %eax,0x4(%ebx)
  8024a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024a7:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8024ab:	3d 00 01 00 00       	cmp    $0x100,%eax
  8024b0:	74 06                	je     8024b8 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8024b2:	83 c4 04             	add    $0x4,%esp
  8024b5:	5b                   	pop    %ebx
  8024b6:	5d                   	pop    %ebp
  8024b7:	c3                   	ret    
		writebuf(b);
  8024b8:	89 d8                	mov    %ebx,%eax
  8024ba:	e8 92 ff ff ff       	call   802451 <writebuf>
		b->idx = 0;
  8024bf:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8024c6:	eb ea                	jmp    8024b2 <putch+0x21>

008024c8 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
  8024cb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8024d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d4:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8024da:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8024e1:	00 00 00 
	b.result = 0;
  8024e4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8024eb:	00 00 00 
	b.error = 1;
  8024ee:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8024f5:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8024f8:	ff 75 10             	pushl  0x10(%ebp)
  8024fb:	ff 75 0c             	pushl  0xc(%ebp)
  8024fe:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802504:	50                   	push   %eax
  802505:	68 91 24 80 00       	push   $0x802491
  80250a:	e8 fc e6 ff ff       	call   800c0b <vprintfmt>
	if (b.idx > 0)
  80250f:	83 c4 10             	add    $0x10,%esp
  802512:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802519:	7f 11                	jg     80252c <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80251b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802521:	85 c0                	test   %eax,%eax
  802523:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80252a:	c9                   	leave  
  80252b:	c3                   	ret    
		writebuf(&b);
  80252c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802532:	e8 1a ff ff ff       	call   802451 <writebuf>
  802537:	eb e2                	jmp    80251b <vfprintf+0x53>

00802539 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
  80253c:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80253f:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802542:	50                   	push   %eax
  802543:	ff 75 0c             	pushl  0xc(%ebp)
  802546:	ff 75 08             	pushl  0x8(%ebp)
  802549:	e8 7a ff ff ff       	call   8024c8 <vfprintf>
	va_end(ap);

	return cnt;
}
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <printf>:

int
printf(const char *fmt, ...)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802556:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802559:	50                   	push   %eax
  80255a:	ff 75 08             	pushl  0x8(%ebp)
  80255d:	6a 01                	push   $0x1
  80255f:	e8 64 ff ff ff       	call   8024c8 <vfprintf>
	va_end(ap);

	return cnt;
}
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
  802569:	57                   	push   %edi
  80256a:	56                   	push   %esi
  80256b:	53                   	push   %ebx
  80256c:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802572:	6a 00                	push   $0x0
  802574:	ff 75 08             	pushl  0x8(%ebp)
  802577:	e8 30 fe ff ff       	call   8023ac <open>
  80257c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802582:	83 c4 10             	add    $0x10,%esp
  802585:	85 c0                	test   %eax,%eax
  802587:	0f 88 40 03 00 00    	js     8028cd <spawn+0x367>
  80258d:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80258f:	83 ec 04             	sub    $0x4,%esp
  802592:	68 00 02 00 00       	push   $0x200
  802597:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80259d:	50                   	push   %eax
  80259e:	52                   	push   %edx
  80259f:	e8 e1 f9 ff ff       	call   801f85 <readn>
  8025a4:	83 c4 10             	add    $0x10,%esp
  8025a7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8025ac:	75 5d                	jne    80260b <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  8025ae:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8025b5:	45 4c 46 
  8025b8:	75 51                	jne    80260b <spawn+0xa5>
  8025ba:	b8 07 00 00 00       	mov    $0x7,%eax
  8025bf:	cd 30                	int    $0x30
  8025c1:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8025c7:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8025cd:	85 c0                	test   %eax,%eax
  8025cf:	0f 88 2f 04 00 00    	js     802a04 <spawn+0x49e>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8025d5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8025da:	6b f0 7c             	imul   $0x7c,%eax,%esi
  8025dd:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8025e3:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8025e9:	b9 11 00 00 00       	mov    $0x11,%ecx
  8025ee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8025f0:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8025f6:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8025fc:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802601:	be 00 00 00 00       	mov    $0x0,%esi
  802606:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802609:	eb 4b                	jmp    802656 <spawn+0xf0>
		close(fd);
  80260b:	83 ec 0c             	sub    $0xc,%esp
  80260e:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  802614:	e8 a9 f7 ff ff       	call   801dc2 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802619:	83 c4 0c             	add    $0xc,%esp
  80261c:	68 7f 45 4c 46       	push   $0x464c457f
  802621:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802627:	68 2a 39 80 00       	push   $0x80392a
  80262c:	e8 dd e4 ff ff       	call   800b0e <cprintf>
		return -E_NOT_EXEC;
  802631:	83 c4 10             	add    $0x10,%esp
  802634:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  80263b:	ff ff ff 
  80263e:	e9 8a 02 00 00       	jmp    8028cd <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  802643:	83 ec 0c             	sub    $0xc,%esp
  802646:	50                   	push   %eax
  802647:	e8 9a eb ff ff       	call   8011e6 <strlen>
  80264c:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  802650:	83 c3 01             	add    $0x1,%ebx
  802653:	83 c4 10             	add    $0x10,%esp
  802656:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80265d:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802660:	85 c0                	test   %eax,%eax
  802662:	75 df                	jne    802643 <spawn+0xdd>
  802664:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  80266a:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802670:	bf 00 10 40 00       	mov    $0x401000,%edi
  802675:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802677:	89 fa                	mov    %edi,%edx
  802679:	83 e2 fc             	and    $0xfffffffc,%edx
  80267c:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802683:	29 c2                	sub    %eax,%edx
  802685:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80268b:	8d 42 f8             	lea    -0x8(%edx),%eax
  80268e:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802693:	0f 86 7c 03 00 00    	jbe    802a15 <spawn+0x4af>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802699:	83 ec 04             	sub    $0x4,%esp
  80269c:	6a 07                	push   $0x7
  80269e:	68 00 00 40 00       	push   $0x400000
  8026a3:	6a 00                	push   $0x0
  8026a5:	e8 6c ef ff ff       	call   801616 <sys_page_alloc>
  8026aa:	83 c4 10             	add    $0x10,%esp
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	0f 88 65 03 00 00    	js     802a1a <spawn+0x4b4>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8026b5:	be 00 00 00 00       	mov    $0x0,%esi
  8026ba:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8026c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8026c3:	eb 30                	jmp    8026f5 <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  8026c5:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8026cb:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8026d1:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
  8026d4:	83 ec 08             	sub    $0x8,%esp
  8026d7:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8026da:	57                   	push   %edi
  8026db:	e8 3d eb ff ff       	call   80121d <strcpy>
		string_store += strlen(argv[i]) + 1;
  8026e0:	83 c4 04             	add    $0x4,%esp
  8026e3:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8026e6:	e8 fb ea ff ff       	call   8011e6 <strlen>
  8026eb:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8026ef:	83 c6 01             	add    $0x1,%esi
  8026f2:	83 c4 10             	add    $0x10,%esp
  8026f5:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8026fb:	7f c8                	jg     8026c5 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  8026fd:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802703:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802709:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802710:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802716:	0f 85 8c 00 00 00    	jne    8027a8 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80271c:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  802722:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802728:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  80272b:	89 f8                	mov    %edi,%eax
  80272d:	8b 8d 88 fd ff ff    	mov    -0x278(%ebp),%ecx
  802733:	89 4f f8             	mov    %ecx,-0x8(%edi)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802736:	2d 08 30 80 11       	sub    $0x11803008,%eax
  80273b:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802741:	83 ec 0c             	sub    $0xc,%esp
  802744:	6a 07                	push   $0x7
  802746:	68 00 d0 bf ee       	push   $0xeebfd000
  80274b:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802751:	68 00 00 40 00       	push   $0x400000
  802756:	6a 00                	push   $0x0
  802758:	e8 fc ee ff ff       	call   801659 <sys_page_map>
  80275d:	89 c3                	mov    %eax,%ebx
  80275f:	83 c4 20             	add    $0x20,%esp
  802762:	85 c0                	test   %eax,%eax
  802764:	0f 88 d0 02 00 00    	js     802a3a <spawn+0x4d4>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80276a:	83 ec 08             	sub    $0x8,%esp
  80276d:	68 00 00 40 00       	push   $0x400000
  802772:	6a 00                	push   $0x0
  802774:	e8 22 ef ff ff       	call   80169b <sys_page_unmap>
  802779:	89 c3                	mov    %eax,%ebx
  80277b:	83 c4 10             	add    $0x10,%esp
  80277e:	85 c0                	test   %eax,%eax
  802780:	0f 88 b4 02 00 00    	js     802a3a <spawn+0x4d4>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802786:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80278c:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802793:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802799:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8027a0:	00 00 00 
  8027a3:	e9 56 01 00 00       	jmp    8028fe <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8027a8:	68 88 39 80 00       	push   $0x803988
  8027ad:	68 af 33 80 00       	push   $0x8033af
  8027b2:	68 f2 00 00 00       	push   $0xf2
  8027b7:	68 44 39 80 00       	push   $0x803944
  8027bc:	e8 72 e2 ff ff       	call   800a33 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8027c1:	83 ec 04             	sub    $0x4,%esp
  8027c4:	6a 07                	push   $0x7
  8027c6:	68 00 00 40 00       	push   $0x400000
  8027cb:	6a 00                	push   $0x0
  8027cd:	e8 44 ee ff ff       	call   801616 <sys_page_alloc>
  8027d2:	83 c4 10             	add    $0x10,%esp
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	0f 88 48 02 00 00    	js     802a25 <spawn+0x4bf>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8027dd:	83 ec 08             	sub    $0x8,%esp
  8027e0:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8027e6:	01 f0                	add    %esi,%eax
  8027e8:	50                   	push   %eax
  8027e9:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8027ef:	e8 5a f8 ff ff       	call   80204e <seek>
  8027f4:	83 c4 10             	add    $0x10,%esp
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	0f 88 2d 02 00 00    	js     802a2c <spawn+0x4c6>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8027ff:	83 ec 04             	sub    $0x4,%esp
  802802:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802808:	29 f0                	sub    %esi,%eax
  80280a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80280f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802814:	0f 47 c2             	cmova  %edx,%eax
  802817:	50                   	push   %eax
  802818:	68 00 00 40 00       	push   $0x400000
  80281d:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  802823:	e8 5d f7 ff ff       	call   801f85 <readn>
  802828:	83 c4 10             	add    $0x10,%esp
  80282b:	85 c0                	test   %eax,%eax
  80282d:	0f 88 00 02 00 00    	js     802a33 <spawn+0x4cd>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802833:	83 ec 0c             	sub    $0xc,%esp
  802836:	57                   	push   %edi
  802837:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  80283d:	56                   	push   %esi
  80283e:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  802844:	68 00 00 40 00       	push   $0x400000
  802849:	6a 00                	push   $0x0
  80284b:	e8 09 ee ff ff       	call   801659 <sys_page_map>
  802850:	83 c4 20             	add    $0x20,%esp
  802853:	85 c0                	test   %eax,%eax
  802855:	0f 88 80 00 00 00    	js     8028db <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80285b:	83 ec 08             	sub    $0x8,%esp
  80285e:	68 00 00 40 00       	push   $0x400000
  802863:	6a 00                	push   $0x0
  802865:	e8 31 ee ff ff       	call   80169b <sys_page_unmap>
  80286a:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80286d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802873:	89 de                	mov    %ebx,%esi
  802875:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  80287b:	76 73                	jbe    8028f0 <spawn+0x38a>
		if (i >= filesz) {
  80287d:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  802883:	0f 87 38 ff ff ff    	ja     8027c1 <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802889:	83 ec 04             	sub    $0x4,%esp
  80288c:	57                   	push   %edi
  80288d:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  802893:	56                   	push   %esi
  802894:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  80289a:	e8 77 ed ff ff       	call   801616 <sys_page_alloc>
  80289f:	83 c4 10             	add    $0x10,%esp
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	79 c7                	jns    80286d <spawn+0x307>
  8028a6:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8028a8:	83 ec 0c             	sub    $0xc,%esp
  8028ab:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8028b1:	e8 e1 ec ff ff       	call   801597 <sys_env_destroy>
	close(fd);
  8028b6:	83 c4 04             	add    $0x4,%esp
  8028b9:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8028bf:	e8 fe f4 ff ff       	call   801dc2 <close>
	return r;
  8028c4:	83 c4 10             	add    $0x10,%esp
  8028c7:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  8028cd:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8028d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028d6:	5b                   	pop    %ebx
  8028d7:	5e                   	pop    %esi
  8028d8:	5f                   	pop    %edi
  8028d9:	5d                   	pop    %ebp
  8028da:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  8028db:	50                   	push   %eax
  8028dc:	68 50 39 80 00       	push   $0x803950
  8028e1:	68 25 01 00 00       	push   $0x125
  8028e6:	68 44 39 80 00       	push   $0x803944
  8028eb:	e8 43 e1 ff ff       	call   800a33 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8028f0:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  8028f7:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  8028fe:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802905:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  80290b:	7e 71                	jle    80297e <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  80290d:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  802913:	83 39 01             	cmpl   $0x1,(%ecx)
  802916:	75 d8                	jne    8028f0 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802918:	8b 41 18             	mov    0x18(%ecx),%eax
  80291b:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  80291e:	83 f8 01             	cmp    $0x1,%eax
  802921:	19 ff                	sbb    %edi,%edi
  802923:	83 e7 fe             	and    $0xfffffffe,%edi
  802926:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802929:	8b 59 04             	mov    0x4(%ecx),%ebx
  80292c:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
  802932:	8b 71 10             	mov    0x10(%ecx),%esi
  802935:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
  80293b:	8b 41 14             	mov    0x14(%ecx),%eax
  80293e:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802944:	8b 51 08             	mov    0x8(%ecx),%edx
  802947:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
	if ((i = PGOFF(va))) {
  80294d:	89 d0                	mov    %edx,%eax
  80294f:	25 ff 0f 00 00       	and    $0xfff,%eax
  802954:	74 1e                	je     802974 <spawn+0x40e>
		va -= i;
  802956:	29 c2                	sub    %eax,%edx
  802958:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		memsz += i;
  80295e:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  802964:	01 c6                	add    %eax,%esi
  802966:	89 b5 94 fd ff ff    	mov    %esi,-0x26c(%ebp)
		fileoffset -= i;
  80296c:	29 c3                	sub    %eax,%ebx
  80296e:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802974:	bb 00 00 00 00       	mov    $0x0,%ebx
  802979:	e9 f5 fe ff ff       	jmp    802873 <spawn+0x30d>
	close(fd);
  80297e:	83 ec 0c             	sub    $0xc,%esp
  802981:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  802987:	e8 36 f4 ff ff       	call   801dc2 <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  80298c:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802993:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802996:	83 c4 08             	add    $0x8,%esp
  802999:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80299f:	50                   	push   %eax
  8029a0:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8029a6:	e8 74 ed ff ff       	call   80171f <sys_env_set_trapframe>
  8029ab:	83 c4 10             	add    $0x10,%esp
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	78 28                	js     8029da <spawn+0x474>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8029b2:	83 ec 08             	sub    $0x8,%esp
  8029b5:	6a 02                	push   $0x2
  8029b7:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8029bd:	e8 1b ed ff ff       	call   8016dd <sys_env_set_status>
  8029c2:	83 c4 10             	add    $0x10,%esp
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	78 26                	js     8029ef <spawn+0x489>
	return child;
  8029c9:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8029cf:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8029d5:	e9 f3 fe ff ff       	jmp    8028cd <spawn+0x367>
		panic("sys_env_set_trapframe: %e", r);
  8029da:	50                   	push   %eax
  8029db:	68 6d 39 80 00       	push   $0x80396d
  8029e0:	68 86 00 00 00       	push   $0x86
  8029e5:	68 44 39 80 00       	push   $0x803944
  8029ea:	e8 44 e0 ff ff       	call   800a33 <_panic>
		panic("sys_env_set_status: %e", r);
  8029ef:	50                   	push   %eax
  8029f0:	68 50 38 80 00       	push   $0x803850
  8029f5:	68 89 00 00 00       	push   $0x89
  8029fa:	68 44 39 80 00       	push   $0x803944
  8029ff:	e8 2f e0 ff ff       	call   800a33 <_panic>
		return r;
  802a04:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802a0a:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802a10:	e9 b8 fe ff ff       	jmp    8028cd <spawn+0x367>
		return -E_NO_MEM;
  802a15:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  802a1a:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802a20:	e9 a8 fe ff ff       	jmp    8028cd <spawn+0x367>
  802a25:	89 c7                	mov    %eax,%edi
  802a27:	e9 7c fe ff ff       	jmp    8028a8 <spawn+0x342>
  802a2c:	89 c7                	mov    %eax,%edi
  802a2e:	e9 75 fe ff ff       	jmp    8028a8 <spawn+0x342>
  802a33:	89 c7                	mov    %eax,%edi
  802a35:	e9 6e fe ff ff       	jmp    8028a8 <spawn+0x342>
	sys_page_unmap(0, UTEMP);
  802a3a:	83 ec 08             	sub    $0x8,%esp
  802a3d:	68 00 00 40 00       	push   $0x400000
  802a42:	6a 00                	push   $0x0
  802a44:	e8 52 ec ff ff       	call   80169b <sys_page_unmap>
  802a49:	83 c4 10             	add    $0x10,%esp
  802a4c:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  802a52:	e9 76 fe ff ff       	jmp    8028cd <spawn+0x367>

00802a57 <spawnl>:
{
  802a57:	55                   	push   %ebp
  802a58:	89 e5                	mov    %esp,%ebp
  802a5a:	57                   	push   %edi
  802a5b:	56                   	push   %esi
  802a5c:	53                   	push   %ebx
  802a5d:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802a60:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802a63:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802a68:	eb 05                	jmp    802a6f <spawnl+0x18>
		argc++;
  802a6a:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802a6d:	89 ca                	mov    %ecx,%edx
  802a6f:	8d 4a 04             	lea    0x4(%edx),%ecx
  802a72:	83 3a 00             	cmpl   $0x0,(%edx)
  802a75:	75 f3                	jne    802a6a <spawnl+0x13>
	const char *argv[argc+2];
  802a77:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  802a7e:	83 e2 f0             	and    $0xfffffff0,%edx
  802a81:	29 d4                	sub    %edx,%esp
  802a83:	8d 54 24 03          	lea    0x3(%esp),%edx
  802a87:	c1 ea 02             	shr    $0x2,%edx
  802a8a:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802a91:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802a93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a96:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802a9d:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802aa4:	00 
	va_start(vl, arg0);
  802aa5:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802aa8:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802aaa:	b8 00 00 00 00       	mov    $0x0,%eax
  802aaf:	eb 0b                	jmp    802abc <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  802ab1:	83 c0 01             	add    $0x1,%eax
  802ab4:	8b 39                	mov    (%ecx),%edi
  802ab6:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802ab9:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802abc:	39 d0                	cmp    %edx,%eax
  802abe:	75 f1                	jne    802ab1 <spawnl+0x5a>
	return spawn(prog, argv);
  802ac0:	83 ec 08             	sub    $0x8,%esp
  802ac3:	56                   	push   %esi
  802ac4:	ff 75 08             	pushl  0x8(%ebp)
  802ac7:	e8 9a fa ff ff       	call   802566 <spawn>
}
  802acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802acf:	5b                   	pop    %ebx
  802ad0:	5e                   	pop    %esi
  802ad1:	5f                   	pop    %edi
  802ad2:	5d                   	pop    %ebp
  802ad3:	c3                   	ret    

00802ad4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802ad4:	55                   	push   %ebp
  802ad5:	89 e5                	mov    %esp,%ebp
  802ad7:	56                   	push   %esi
  802ad8:	53                   	push   %ebx
  802ad9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802adc:	83 ec 0c             	sub    $0xc,%esp
  802adf:	ff 75 08             	pushl  0x8(%ebp)
  802ae2:	e8 40 f1 ff ff       	call   801c27 <fd2data>
  802ae7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802ae9:	83 c4 08             	add    $0x8,%esp
  802aec:	68 ae 39 80 00       	push   $0x8039ae
  802af1:	53                   	push   %ebx
  802af2:	e8 26 e7 ff ff       	call   80121d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802af7:	8b 46 04             	mov    0x4(%esi),%eax
  802afa:	2b 06                	sub    (%esi),%eax
  802afc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802b02:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802b09:	00 00 00 
	stat->st_dev = &devpipe;
  802b0c:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802b13:	40 80 00 
	return 0;
}
  802b16:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b1e:	5b                   	pop    %ebx
  802b1f:	5e                   	pop    %esi
  802b20:	5d                   	pop    %ebp
  802b21:	c3                   	ret    

00802b22 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802b22:	55                   	push   %ebp
  802b23:	89 e5                	mov    %esp,%ebp
  802b25:	53                   	push   %ebx
  802b26:	83 ec 0c             	sub    $0xc,%esp
  802b29:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802b2c:	53                   	push   %ebx
  802b2d:	6a 00                	push   $0x0
  802b2f:	e8 67 eb ff ff       	call   80169b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802b34:	89 1c 24             	mov    %ebx,(%esp)
  802b37:	e8 eb f0 ff ff       	call   801c27 <fd2data>
  802b3c:	83 c4 08             	add    $0x8,%esp
  802b3f:	50                   	push   %eax
  802b40:	6a 00                	push   $0x0
  802b42:	e8 54 eb ff ff       	call   80169b <sys_page_unmap>
}
  802b47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b4a:	c9                   	leave  
  802b4b:	c3                   	ret    

00802b4c <_pipeisclosed>:
{
  802b4c:	55                   	push   %ebp
  802b4d:	89 e5                	mov    %esp,%ebp
  802b4f:	57                   	push   %edi
  802b50:	56                   	push   %esi
  802b51:	53                   	push   %ebx
  802b52:	83 ec 1c             	sub    $0x1c,%esp
  802b55:	89 c7                	mov    %eax,%edi
  802b57:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802b59:	a1 24 54 80 00       	mov    0x805424,%eax
  802b5e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802b61:	83 ec 0c             	sub    $0xc,%esp
  802b64:	57                   	push   %edi
  802b65:	e8 79 04 00 00       	call   802fe3 <pageref>
  802b6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802b6d:	89 34 24             	mov    %esi,(%esp)
  802b70:	e8 6e 04 00 00       	call   802fe3 <pageref>
		nn = thisenv->env_runs;
  802b75:	8b 15 24 54 80 00    	mov    0x805424,%edx
  802b7b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802b7e:	83 c4 10             	add    $0x10,%esp
  802b81:	39 cb                	cmp    %ecx,%ebx
  802b83:	74 1b                	je     802ba0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802b85:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802b88:	75 cf                	jne    802b59 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802b8a:	8b 42 58             	mov    0x58(%edx),%eax
  802b8d:	6a 01                	push   $0x1
  802b8f:	50                   	push   %eax
  802b90:	53                   	push   %ebx
  802b91:	68 b5 39 80 00       	push   $0x8039b5
  802b96:	e8 73 df ff ff       	call   800b0e <cprintf>
  802b9b:	83 c4 10             	add    $0x10,%esp
  802b9e:	eb b9                	jmp    802b59 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802ba0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802ba3:	0f 94 c0             	sete   %al
  802ba6:	0f b6 c0             	movzbl %al,%eax
}
  802ba9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802bac:	5b                   	pop    %ebx
  802bad:	5e                   	pop    %esi
  802bae:	5f                   	pop    %edi
  802baf:	5d                   	pop    %ebp
  802bb0:	c3                   	ret    

00802bb1 <devpipe_write>:
{
  802bb1:	55                   	push   %ebp
  802bb2:	89 e5                	mov    %esp,%ebp
  802bb4:	57                   	push   %edi
  802bb5:	56                   	push   %esi
  802bb6:	53                   	push   %ebx
  802bb7:	83 ec 28             	sub    $0x28,%esp
  802bba:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802bbd:	56                   	push   %esi
  802bbe:	e8 64 f0 ff ff       	call   801c27 <fd2data>
  802bc3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802bc5:	83 c4 10             	add    $0x10,%esp
  802bc8:	bf 00 00 00 00       	mov    $0x0,%edi
  802bcd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802bd0:	74 4f                	je     802c21 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802bd2:	8b 43 04             	mov    0x4(%ebx),%eax
  802bd5:	8b 0b                	mov    (%ebx),%ecx
  802bd7:	8d 51 20             	lea    0x20(%ecx),%edx
  802bda:	39 d0                	cmp    %edx,%eax
  802bdc:	72 14                	jb     802bf2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802bde:	89 da                	mov    %ebx,%edx
  802be0:	89 f0                	mov    %esi,%eax
  802be2:	e8 65 ff ff ff       	call   802b4c <_pipeisclosed>
  802be7:	85 c0                	test   %eax,%eax
  802be9:	75 3a                	jne    802c25 <devpipe_write+0x74>
			sys_yield();
  802beb:	e8 07 ea ff ff       	call   8015f7 <sys_yield>
  802bf0:	eb e0                	jmp    802bd2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802bf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802bf5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802bf9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802bfc:	89 c2                	mov    %eax,%edx
  802bfe:	c1 fa 1f             	sar    $0x1f,%edx
  802c01:	89 d1                	mov    %edx,%ecx
  802c03:	c1 e9 1b             	shr    $0x1b,%ecx
  802c06:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802c09:	83 e2 1f             	and    $0x1f,%edx
  802c0c:	29 ca                	sub    %ecx,%edx
  802c0e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802c12:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802c16:	83 c0 01             	add    $0x1,%eax
  802c19:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802c1c:	83 c7 01             	add    $0x1,%edi
  802c1f:	eb ac                	jmp    802bcd <devpipe_write+0x1c>
	return i;
  802c21:	89 f8                	mov    %edi,%eax
  802c23:	eb 05                	jmp    802c2a <devpipe_write+0x79>
				return 0;
  802c25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c2d:	5b                   	pop    %ebx
  802c2e:	5e                   	pop    %esi
  802c2f:	5f                   	pop    %edi
  802c30:	5d                   	pop    %ebp
  802c31:	c3                   	ret    

00802c32 <devpipe_read>:
{
  802c32:	55                   	push   %ebp
  802c33:	89 e5                	mov    %esp,%ebp
  802c35:	57                   	push   %edi
  802c36:	56                   	push   %esi
  802c37:	53                   	push   %ebx
  802c38:	83 ec 18             	sub    $0x18,%esp
  802c3b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802c3e:	57                   	push   %edi
  802c3f:	e8 e3 ef ff ff       	call   801c27 <fd2data>
  802c44:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802c46:	83 c4 10             	add    $0x10,%esp
  802c49:	be 00 00 00 00       	mov    $0x0,%esi
  802c4e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802c51:	74 47                	je     802c9a <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802c53:	8b 03                	mov    (%ebx),%eax
  802c55:	3b 43 04             	cmp    0x4(%ebx),%eax
  802c58:	75 22                	jne    802c7c <devpipe_read+0x4a>
			if (i > 0)
  802c5a:	85 f6                	test   %esi,%esi
  802c5c:	75 14                	jne    802c72 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  802c5e:	89 da                	mov    %ebx,%edx
  802c60:	89 f8                	mov    %edi,%eax
  802c62:	e8 e5 fe ff ff       	call   802b4c <_pipeisclosed>
  802c67:	85 c0                	test   %eax,%eax
  802c69:	75 33                	jne    802c9e <devpipe_read+0x6c>
			sys_yield();
  802c6b:	e8 87 e9 ff ff       	call   8015f7 <sys_yield>
  802c70:	eb e1                	jmp    802c53 <devpipe_read+0x21>
				return i;
  802c72:	89 f0                	mov    %esi,%eax
}
  802c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c77:	5b                   	pop    %ebx
  802c78:	5e                   	pop    %esi
  802c79:	5f                   	pop    %edi
  802c7a:	5d                   	pop    %ebp
  802c7b:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802c7c:	99                   	cltd   
  802c7d:	c1 ea 1b             	shr    $0x1b,%edx
  802c80:	01 d0                	add    %edx,%eax
  802c82:	83 e0 1f             	and    $0x1f,%eax
  802c85:	29 d0                	sub    %edx,%eax
  802c87:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802c8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c8f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802c92:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802c95:	83 c6 01             	add    $0x1,%esi
  802c98:	eb b4                	jmp    802c4e <devpipe_read+0x1c>
	return i;
  802c9a:	89 f0                	mov    %esi,%eax
  802c9c:	eb d6                	jmp    802c74 <devpipe_read+0x42>
				return 0;
  802c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca3:	eb cf                	jmp    802c74 <devpipe_read+0x42>

00802ca5 <pipe>:
{
  802ca5:	55                   	push   %ebp
  802ca6:	89 e5                	mov    %esp,%ebp
  802ca8:	56                   	push   %esi
  802ca9:	53                   	push   %ebx
  802caa:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802cad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802cb0:	50                   	push   %eax
  802cb1:	e8 88 ef ff ff       	call   801c3e <fd_alloc>
  802cb6:	89 c3                	mov    %eax,%ebx
  802cb8:	83 c4 10             	add    $0x10,%esp
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	78 5b                	js     802d1a <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cbf:	83 ec 04             	sub    $0x4,%esp
  802cc2:	68 07 04 00 00       	push   $0x407
  802cc7:	ff 75 f4             	pushl  -0xc(%ebp)
  802cca:	6a 00                	push   $0x0
  802ccc:	e8 45 e9 ff ff       	call   801616 <sys_page_alloc>
  802cd1:	89 c3                	mov    %eax,%ebx
  802cd3:	83 c4 10             	add    $0x10,%esp
  802cd6:	85 c0                	test   %eax,%eax
  802cd8:	78 40                	js     802d1a <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  802cda:	83 ec 0c             	sub    $0xc,%esp
  802cdd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802ce0:	50                   	push   %eax
  802ce1:	e8 58 ef ff ff       	call   801c3e <fd_alloc>
  802ce6:	89 c3                	mov    %eax,%ebx
  802ce8:	83 c4 10             	add    $0x10,%esp
  802ceb:	85 c0                	test   %eax,%eax
  802ced:	78 1b                	js     802d0a <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cef:	83 ec 04             	sub    $0x4,%esp
  802cf2:	68 07 04 00 00       	push   $0x407
  802cf7:	ff 75 f0             	pushl  -0x10(%ebp)
  802cfa:	6a 00                	push   $0x0
  802cfc:	e8 15 e9 ff ff       	call   801616 <sys_page_alloc>
  802d01:	89 c3                	mov    %eax,%ebx
  802d03:	83 c4 10             	add    $0x10,%esp
  802d06:	85 c0                	test   %eax,%eax
  802d08:	79 19                	jns    802d23 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802d0a:	83 ec 08             	sub    $0x8,%esp
  802d0d:	ff 75 f4             	pushl  -0xc(%ebp)
  802d10:	6a 00                	push   $0x0
  802d12:	e8 84 e9 ff ff       	call   80169b <sys_page_unmap>
  802d17:	83 c4 10             	add    $0x10,%esp
}
  802d1a:	89 d8                	mov    %ebx,%eax
  802d1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d1f:	5b                   	pop    %ebx
  802d20:	5e                   	pop    %esi
  802d21:	5d                   	pop    %ebp
  802d22:	c3                   	ret    
	va = fd2data(fd0);
  802d23:	83 ec 0c             	sub    $0xc,%esp
  802d26:	ff 75 f4             	pushl  -0xc(%ebp)
  802d29:	e8 f9 ee ff ff       	call   801c27 <fd2data>
  802d2e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d30:	83 c4 0c             	add    $0xc,%esp
  802d33:	68 07 04 00 00       	push   $0x407
  802d38:	50                   	push   %eax
  802d39:	6a 00                	push   $0x0
  802d3b:	e8 d6 e8 ff ff       	call   801616 <sys_page_alloc>
  802d40:	89 c3                	mov    %eax,%ebx
  802d42:	83 c4 10             	add    $0x10,%esp
  802d45:	85 c0                	test   %eax,%eax
  802d47:	0f 88 8c 00 00 00    	js     802dd9 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d4d:	83 ec 0c             	sub    $0xc,%esp
  802d50:	ff 75 f0             	pushl  -0x10(%ebp)
  802d53:	e8 cf ee ff ff       	call   801c27 <fd2data>
  802d58:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802d5f:	50                   	push   %eax
  802d60:	6a 00                	push   $0x0
  802d62:	56                   	push   %esi
  802d63:	6a 00                	push   $0x0
  802d65:	e8 ef e8 ff ff       	call   801659 <sys_page_map>
  802d6a:	89 c3                	mov    %eax,%ebx
  802d6c:	83 c4 20             	add    $0x20,%esp
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	78 58                	js     802dcb <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802d7c:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8b:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802d91:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d96:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802d9d:	83 ec 0c             	sub    $0xc,%esp
  802da0:	ff 75 f4             	pushl  -0xc(%ebp)
  802da3:	e8 6f ee ff ff       	call   801c17 <fd2num>
  802da8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dab:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802dad:	83 c4 04             	add    $0x4,%esp
  802db0:	ff 75 f0             	pushl  -0x10(%ebp)
  802db3:	e8 5f ee ff ff       	call   801c17 <fd2num>
  802db8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dbb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802dbe:	83 c4 10             	add    $0x10,%esp
  802dc1:	bb 00 00 00 00       	mov    $0x0,%ebx
  802dc6:	e9 4f ff ff ff       	jmp    802d1a <pipe+0x75>
	sys_page_unmap(0, va);
  802dcb:	83 ec 08             	sub    $0x8,%esp
  802dce:	56                   	push   %esi
  802dcf:	6a 00                	push   $0x0
  802dd1:	e8 c5 e8 ff ff       	call   80169b <sys_page_unmap>
  802dd6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802dd9:	83 ec 08             	sub    $0x8,%esp
  802ddc:	ff 75 f0             	pushl  -0x10(%ebp)
  802ddf:	6a 00                	push   $0x0
  802de1:	e8 b5 e8 ff ff       	call   80169b <sys_page_unmap>
  802de6:	83 c4 10             	add    $0x10,%esp
  802de9:	e9 1c ff ff ff       	jmp    802d0a <pipe+0x65>

00802dee <pipeisclosed>:
{
  802dee:	55                   	push   %ebp
  802def:	89 e5                	mov    %esp,%ebp
  802df1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802df7:	50                   	push   %eax
  802df8:	ff 75 08             	pushl  0x8(%ebp)
  802dfb:	e8 8d ee ff ff       	call   801c8d <fd_lookup>
  802e00:	83 c4 10             	add    $0x10,%esp
  802e03:	85 c0                	test   %eax,%eax
  802e05:	78 18                	js     802e1f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802e07:	83 ec 0c             	sub    $0xc,%esp
  802e0a:	ff 75 f4             	pushl  -0xc(%ebp)
  802e0d:	e8 15 ee ff ff       	call   801c27 <fd2data>
	return _pipeisclosed(fd, p);
  802e12:	89 c2                	mov    %eax,%edx
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	e8 30 fd ff ff       	call   802b4c <_pipeisclosed>
  802e1c:	83 c4 10             	add    $0x10,%esp
}
  802e1f:	c9                   	leave  
  802e20:	c3                   	ret    

00802e21 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802e21:	55                   	push   %ebp
  802e22:	89 e5                	mov    %esp,%ebp
  802e24:	56                   	push   %esi
  802e25:	53                   	push   %ebx
  802e26:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802e29:	85 f6                	test   %esi,%esi
  802e2b:	74 13                	je     802e40 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802e2d:	89 f3                	mov    %esi,%ebx
  802e2f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802e35:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802e38:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802e3e:	eb 1b                	jmp    802e5b <wait+0x3a>
	assert(envid != 0);
  802e40:	68 cd 39 80 00       	push   $0x8039cd
  802e45:	68 af 33 80 00       	push   $0x8033af
  802e4a:	6a 09                	push   $0x9
  802e4c:	68 d8 39 80 00       	push   $0x8039d8
  802e51:	e8 dd db ff ff       	call   800a33 <_panic>
		sys_yield();
  802e56:	e8 9c e7 ff ff       	call   8015f7 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802e5b:	8b 43 48             	mov    0x48(%ebx),%eax
  802e5e:	39 f0                	cmp    %esi,%eax
  802e60:	75 07                	jne    802e69 <wait+0x48>
  802e62:	8b 43 54             	mov    0x54(%ebx),%eax
  802e65:	85 c0                	test   %eax,%eax
  802e67:	75 ed                	jne    802e56 <wait+0x35>
}
  802e69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e6c:	5b                   	pop    %ebx
  802e6d:	5e                   	pop    %esi
  802e6e:	5d                   	pop    %ebp
  802e6f:	c3                   	ret    

00802e70 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802e70:	55                   	push   %ebp
  802e71:	89 e5                	mov    %esp,%ebp
  802e73:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802e76:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802e7d:	74 0a                	je     802e89 <set_pgfault_handler+0x19>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802e87:	c9                   	leave  
  802e88:	c3                   	ret    
		int r = sys_page_alloc(0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P);	//为当前进程分配异常栈
  802e89:	83 ec 04             	sub    $0x4,%esp
  802e8c:	6a 07                	push   $0x7
  802e8e:	68 00 f0 bf ee       	push   $0xeebff000
  802e93:	6a 00                	push   $0x0
  802e95:	e8 7c e7 ff ff       	call   801616 <sys_page_alloc>
		if (r < 0) {
  802e9a:	83 c4 10             	add    $0x10,%esp
  802e9d:	85 c0                	test   %eax,%eax
  802e9f:	78 14                	js     802eb5 <set_pgfault_handler+0x45>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
  802ea1:	83 ec 08             	sub    $0x8,%esp
  802ea4:	68 c9 2e 80 00       	push   $0x802ec9
  802ea9:	6a 00                	push   $0x0
  802eab:	e8 b1 e8 ff ff       	call   801761 <sys_env_set_pgfault_upcall>
  802eb0:	83 c4 10             	add    $0x10,%esp
  802eb3:	eb ca                	jmp    802e7f <set_pgfault_handler+0xf>
			panic("set_pgfault_handler:sys_page_alloc failed");;
  802eb5:	83 ec 04             	sub    $0x4,%esp
  802eb8:	68 e4 39 80 00       	push   $0x8039e4
  802ebd:	6a 22                	push   $0x22
  802ebf:	68 10 3a 80 00       	push   $0x803a10
  802ec4:	e8 6a db ff ff       	call   800a33 <_panic>

00802ec9 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802ec9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802eca:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax				//调用页处理函数
  802ecf:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802ed1:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp			//跳过utf_fault_va和utf_err
  802ed4:	83 c4 08             	add    $0x8,%esp
	movl 40(%esp), %eax 	//保存中断发生时的esp到eax
  802ed7:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl 32(%esp), %ecx 	//保存终端发生时的eip到ecx
  802edb:	8b 4c 24 20          	mov    0x20(%esp),%ecx
	movl %ecx, -4(%eax) 	//将中断发生时的esp值亚入到到原来的栈中
  802edf:	89 48 fc             	mov    %ecx,-0x4(%eax)
	popal
  802ee2:	61                   	popa   
	addl $4, %esp			//跳过eip
  802ee3:	83 c4 04             	add    $0x4,%esp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  802ee6:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802ee7:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	lea -4(%esp), %esp		//因为之前压入了eip的值但是没有减esp的值，所以现在需要将esp寄存器中的值减4
  802ee8:	8d 64 24 fc          	lea    -0x4(%esp),%esp
  802eec:	c3                   	ret    

00802eed <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802eed:	55                   	push   %ebp
  802eee:	89 e5                	mov    %esp,%ebp
  802ef0:	56                   	push   %esi
  802ef1:	53                   	push   %ebx
  802ef2:	8b 75 08             	mov    0x8(%ebp),%esi
  802ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  802efb:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  802efd:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  802f02:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  802f05:	83 ec 0c             	sub    $0xc,%esp
  802f08:	50                   	push   %eax
  802f09:	e8 b8 e8 ff ff       	call   8017c6 <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  802f0e:	83 c4 10             	add    $0x10,%esp
  802f11:	85 c0                	test   %eax,%eax
  802f13:	78 2b                	js     802f40 <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  802f15:	85 f6                	test   %esi,%esi
  802f17:	74 0a                	je     802f23 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802f19:	a1 24 54 80 00       	mov    0x805424,%eax
  802f1e:	8b 40 74             	mov    0x74(%eax),%eax
  802f21:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  802f23:	85 db                	test   %ebx,%ebx
  802f25:	74 0a                	je     802f31 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802f27:	a1 24 54 80 00       	mov    0x805424,%eax
  802f2c:	8b 40 78             	mov    0x78(%eax),%eax
  802f2f:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802f31:	a1 24 54 80 00       	mov    0x805424,%eax
  802f36:	8b 40 70             	mov    0x70(%eax),%eax
}
  802f39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f3c:	5b                   	pop    %ebx
  802f3d:	5e                   	pop    %esi
  802f3e:	5d                   	pop    %ebp
  802f3f:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802f40:	85 f6                	test   %esi,%esi
  802f42:	74 06                	je     802f4a <ipc_recv+0x5d>
  802f44:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802f4a:	85 db                	test   %ebx,%ebx
  802f4c:	74 eb                	je     802f39 <ipc_recv+0x4c>
  802f4e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802f54:	eb e3                	jmp    802f39 <ipc_recv+0x4c>

00802f56 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802f56:	55                   	push   %ebp
  802f57:	89 e5                	mov    %esp,%ebp
  802f59:	57                   	push   %edi
  802f5a:	56                   	push   %esi
  802f5b:	53                   	push   %ebx
  802f5c:	83 ec 0c             	sub    $0xc,%esp
  802f5f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802f62:	8b 75 0c             	mov    0xc(%ebp),%esi
  802f65:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  802f68:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  802f6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802f6f:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  802f72:	ff 75 14             	pushl  0x14(%ebp)
  802f75:	53                   	push   %ebx
  802f76:	56                   	push   %esi
  802f77:	57                   	push   %edi
  802f78:	e8 26 e8 ff ff       	call   8017a3 <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  802f7d:	83 c4 10             	add    $0x10,%esp
  802f80:	85 c0                	test   %eax,%eax
  802f82:	74 1e                	je     802fa2 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  802f84:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802f87:	75 07                	jne    802f90 <ipc_send+0x3a>
			sys_yield();
  802f89:	e8 69 e6 ff ff       	call   8015f7 <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  802f8e:	eb e2                	jmp    802f72 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  802f90:	50                   	push   %eax
  802f91:	68 1e 3a 80 00       	push   $0x803a1e
  802f96:	6a 41                	push   $0x41
  802f98:	68 2c 3a 80 00       	push   $0x803a2c
  802f9d:	e8 91 da ff ff       	call   800a33 <_panic>
		}
	}
}
  802fa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802fa5:	5b                   	pop    %ebx
  802fa6:	5e                   	pop    %esi
  802fa7:	5f                   	pop    %edi
  802fa8:	5d                   	pop    %ebp
  802fa9:	c3                   	ret    

00802faa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802faa:	55                   	push   %ebp
  802fab:	89 e5                	mov    %esp,%ebp
  802fad:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802fb0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802fb5:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802fb8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802fbe:	8b 52 50             	mov    0x50(%edx),%edx
  802fc1:	39 ca                	cmp    %ecx,%edx
  802fc3:	74 11                	je     802fd6 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802fc5:	83 c0 01             	add    $0x1,%eax
  802fc8:	3d 00 04 00 00       	cmp    $0x400,%eax
  802fcd:	75 e6                	jne    802fb5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd4:	eb 0b                	jmp    802fe1 <ipc_find_env+0x37>
			return envs[i].env_id;
  802fd6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802fd9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802fde:	8b 40 48             	mov    0x48(%eax),%eax
}
  802fe1:	5d                   	pop    %ebp
  802fe2:	c3                   	ret    

00802fe3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802fe3:	55                   	push   %ebp
  802fe4:	89 e5                	mov    %esp,%ebp
  802fe6:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802fe9:	89 d0                	mov    %edx,%eax
  802feb:	c1 e8 16             	shr    $0x16,%eax
  802fee:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802ff5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802ffa:	f6 c1 01             	test   $0x1,%cl
  802ffd:	74 1d                	je     80301c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802fff:	c1 ea 0c             	shr    $0xc,%edx
  803002:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803009:	f6 c2 01             	test   $0x1,%dl
  80300c:	74 0e                	je     80301c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80300e:	c1 ea 0c             	shr    $0xc,%edx
  803011:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803018:	ef 
  803019:	0f b7 c0             	movzwl %ax,%eax
}
  80301c:	5d                   	pop    %ebp
  80301d:	c3                   	ret    
  80301e:	66 90                	xchg   %ax,%ax

00803020 <__udivdi3>:
  803020:	55                   	push   %ebp
  803021:	57                   	push   %edi
  803022:	56                   	push   %esi
  803023:	53                   	push   %ebx
  803024:	83 ec 1c             	sub    $0x1c,%esp
  803027:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80302b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80302f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803033:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803037:	85 d2                	test   %edx,%edx
  803039:	75 35                	jne    803070 <__udivdi3+0x50>
  80303b:	39 f3                	cmp    %esi,%ebx
  80303d:	0f 87 bd 00 00 00    	ja     803100 <__udivdi3+0xe0>
  803043:	85 db                	test   %ebx,%ebx
  803045:	89 d9                	mov    %ebx,%ecx
  803047:	75 0b                	jne    803054 <__udivdi3+0x34>
  803049:	b8 01 00 00 00       	mov    $0x1,%eax
  80304e:	31 d2                	xor    %edx,%edx
  803050:	f7 f3                	div    %ebx
  803052:	89 c1                	mov    %eax,%ecx
  803054:	31 d2                	xor    %edx,%edx
  803056:	89 f0                	mov    %esi,%eax
  803058:	f7 f1                	div    %ecx
  80305a:	89 c6                	mov    %eax,%esi
  80305c:	89 e8                	mov    %ebp,%eax
  80305e:	89 f7                	mov    %esi,%edi
  803060:	f7 f1                	div    %ecx
  803062:	89 fa                	mov    %edi,%edx
  803064:	83 c4 1c             	add    $0x1c,%esp
  803067:	5b                   	pop    %ebx
  803068:	5e                   	pop    %esi
  803069:	5f                   	pop    %edi
  80306a:	5d                   	pop    %ebp
  80306b:	c3                   	ret    
  80306c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803070:	39 f2                	cmp    %esi,%edx
  803072:	77 7c                	ja     8030f0 <__udivdi3+0xd0>
  803074:	0f bd fa             	bsr    %edx,%edi
  803077:	83 f7 1f             	xor    $0x1f,%edi
  80307a:	0f 84 98 00 00 00    	je     803118 <__udivdi3+0xf8>
  803080:	89 f9                	mov    %edi,%ecx
  803082:	b8 20 00 00 00       	mov    $0x20,%eax
  803087:	29 f8                	sub    %edi,%eax
  803089:	d3 e2                	shl    %cl,%edx
  80308b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80308f:	89 c1                	mov    %eax,%ecx
  803091:	89 da                	mov    %ebx,%edx
  803093:	d3 ea                	shr    %cl,%edx
  803095:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803099:	09 d1                	or     %edx,%ecx
  80309b:	89 f2                	mov    %esi,%edx
  80309d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030a1:	89 f9                	mov    %edi,%ecx
  8030a3:	d3 e3                	shl    %cl,%ebx
  8030a5:	89 c1                	mov    %eax,%ecx
  8030a7:	d3 ea                	shr    %cl,%edx
  8030a9:	89 f9                	mov    %edi,%ecx
  8030ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8030af:	d3 e6                	shl    %cl,%esi
  8030b1:	89 eb                	mov    %ebp,%ebx
  8030b3:	89 c1                	mov    %eax,%ecx
  8030b5:	d3 eb                	shr    %cl,%ebx
  8030b7:	09 de                	or     %ebx,%esi
  8030b9:	89 f0                	mov    %esi,%eax
  8030bb:	f7 74 24 08          	divl   0x8(%esp)
  8030bf:	89 d6                	mov    %edx,%esi
  8030c1:	89 c3                	mov    %eax,%ebx
  8030c3:	f7 64 24 0c          	mull   0xc(%esp)
  8030c7:	39 d6                	cmp    %edx,%esi
  8030c9:	72 0c                	jb     8030d7 <__udivdi3+0xb7>
  8030cb:	89 f9                	mov    %edi,%ecx
  8030cd:	d3 e5                	shl    %cl,%ebp
  8030cf:	39 c5                	cmp    %eax,%ebp
  8030d1:	73 5d                	jae    803130 <__udivdi3+0x110>
  8030d3:	39 d6                	cmp    %edx,%esi
  8030d5:	75 59                	jne    803130 <__udivdi3+0x110>
  8030d7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8030da:	31 ff                	xor    %edi,%edi
  8030dc:	89 fa                	mov    %edi,%edx
  8030de:	83 c4 1c             	add    $0x1c,%esp
  8030e1:	5b                   	pop    %ebx
  8030e2:	5e                   	pop    %esi
  8030e3:	5f                   	pop    %edi
  8030e4:	5d                   	pop    %ebp
  8030e5:	c3                   	ret    
  8030e6:	8d 76 00             	lea    0x0(%esi),%esi
  8030e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8030f0:	31 ff                	xor    %edi,%edi
  8030f2:	31 c0                	xor    %eax,%eax
  8030f4:	89 fa                	mov    %edi,%edx
  8030f6:	83 c4 1c             	add    $0x1c,%esp
  8030f9:	5b                   	pop    %ebx
  8030fa:	5e                   	pop    %esi
  8030fb:	5f                   	pop    %edi
  8030fc:	5d                   	pop    %ebp
  8030fd:	c3                   	ret    
  8030fe:	66 90                	xchg   %ax,%ax
  803100:	31 ff                	xor    %edi,%edi
  803102:	89 e8                	mov    %ebp,%eax
  803104:	89 f2                	mov    %esi,%edx
  803106:	f7 f3                	div    %ebx
  803108:	89 fa                	mov    %edi,%edx
  80310a:	83 c4 1c             	add    $0x1c,%esp
  80310d:	5b                   	pop    %ebx
  80310e:	5e                   	pop    %esi
  80310f:	5f                   	pop    %edi
  803110:	5d                   	pop    %ebp
  803111:	c3                   	ret    
  803112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803118:	39 f2                	cmp    %esi,%edx
  80311a:	72 06                	jb     803122 <__udivdi3+0x102>
  80311c:	31 c0                	xor    %eax,%eax
  80311e:	39 eb                	cmp    %ebp,%ebx
  803120:	77 d2                	ja     8030f4 <__udivdi3+0xd4>
  803122:	b8 01 00 00 00       	mov    $0x1,%eax
  803127:	eb cb                	jmp    8030f4 <__udivdi3+0xd4>
  803129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803130:	89 d8                	mov    %ebx,%eax
  803132:	31 ff                	xor    %edi,%edi
  803134:	eb be                	jmp    8030f4 <__udivdi3+0xd4>
  803136:	66 90                	xchg   %ax,%ax
  803138:	66 90                	xchg   %ax,%ax
  80313a:	66 90                	xchg   %ax,%ax
  80313c:	66 90                	xchg   %ax,%ax
  80313e:	66 90                	xchg   %ax,%ax

00803140 <__umoddi3>:
  803140:	55                   	push   %ebp
  803141:	57                   	push   %edi
  803142:	56                   	push   %esi
  803143:	53                   	push   %ebx
  803144:	83 ec 1c             	sub    $0x1c,%esp
  803147:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80314b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80314f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803153:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803157:	85 ed                	test   %ebp,%ebp
  803159:	89 f0                	mov    %esi,%eax
  80315b:	89 da                	mov    %ebx,%edx
  80315d:	75 19                	jne    803178 <__umoddi3+0x38>
  80315f:	39 df                	cmp    %ebx,%edi
  803161:	0f 86 b1 00 00 00    	jbe    803218 <__umoddi3+0xd8>
  803167:	f7 f7                	div    %edi
  803169:	89 d0                	mov    %edx,%eax
  80316b:	31 d2                	xor    %edx,%edx
  80316d:	83 c4 1c             	add    $0x1c,%esp
  803170:	5b                   	pop    %ebx
  803171:	5e                   	pop    %esi
  803172:	5f                   	pop    %edi
  803173:	5d                   	pop    %ebp
  803174:	c3                   	ret    
  803175:	8d 76 00             	lea    0x0(%esi),%esi
  803178:	39 dd                	cmp    %ebx,%ebp
  80317a:	77 f1                	ja     80316d <__umoddi3+0x2d>
  80317c:	0f bd cd             	bsr    %ebp,%ecx
  80317f:	83 f1 1f             	xor    $0x1f,%ecx
  803182:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803186:	0f 84 b4 00 00 00    	je     803240 <__umoddi3+0x100>
  80318c:	b8 20 00 00 00       	mov    $0x20,%eax
  803191:	89 c2                	mov    %eax,%edx
  803193:	8b 44 24 04          	mov    0x4(%esp),%eax
  803197:	29 c2                	sub    %eax,%edx
  803199:	89 c1                	mov    %eax,%ecx
  80319b:	89 f8                	mov    %edi,%eax
  80319d:	d3 e5                	shl    %cl,%ebp
  80319f:	89 d1                	mov    %edx,%ecx
  8031a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8031a5:	d3 e8                	shr    %cl,%eax
  8031a7:	09 c5                	or     %eax,%ebp
  8031a9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031ad:	89 c1                	mov    %eax,%ecx
  8031af:	d3 e7                	shl    %cl,%edi
  8031b1:	89 d1                	mov    %edx,%ecx
  8031b3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8031b7:	89 df                	mov    %ebx,%edi
  8031b9:	d3 ef                	shr    %cl,%edi
  8031bb:	89 c1                	mov    %eax,%ecx
  8031bd:	89 f0                	mov    %esi,%eax
  8031bf:	d3 e3                	shl    %cl,%ebx
  8031c1:	89 d1                	mov    %edx,%ecx
  8031c3:	89 fa                	mov    %edi,%edx
  8031c5:	d3 e8                	shr    %cl,%eax
  8031c7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8031cc:	09 d8                	or     %ebx,%eax
  8031ce:	f7 f5                	div    %ebp
  8031d0:	d3 e6                	shl    %cl,%esi
  8031d2:	89 d1                	mov    %edx,%ecx
  8031d4:	f7 64 24 08          	mull   0x8(%esp)
  8031d8:	39 d1                	cmp    %edx,%ecx
  8031da:	89 c3                	mov    %eax,%ebx
  8031dc:	89 d7                	mov    %edx,%edi
  8031de:	72 06                	jb     8031e6 <__umoddi3+0xa6>
  8031e0:	75 0e                	jne    8031f0 <__umoddi3+0xb0>
  8031e2:	39 c6                	cmp    %eax,%esi
  8031e4:	73 0a                	jae    8031f0 <__umoddi3+0xb0>
  8031e6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8031ea:	19 ea                	sbb    %ebp,%edx
  8031ec:	89 d7                	mov    %edx,%edi
  8031ee:	89 c3                	mov    %eax,%ebx
  8031f0:	89 ca                	mov    %ecx,%edx
  8031f2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8031f7:	29 de                	sub    %ebx,%esi
  8031f9:	19 fa                	sbb    %edi,%edx
  8031fb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8031ff:	89 d0                	mov    %edx,%eax
  803201:	d3 e0                	shl    %cl,%eax
  803203:	89 d9                	mov    %ebx,%ecx
  803205:	d3 ee                	shr    %cl,%esi
  803207:	d3 ea                	shr    %cl,%edx
  803209:	09 f0                	or     %esi,%eax
  80320b:	83 c4 1c             	add    $0x1c,%esp
  80320e:	5b                   	pop    %ebx
  80320f:	5e                   	pop    %esi
  803210:	5f                   	pop    %edi
  803211:	5d                   	pop    %ebp
  803212:	c3                   	ret    
  803213:	90                   	nop
  803214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803218:	85 ff                	test   %edi,%edi
  80321a:	89 f9                	mov    %edi,%ecx
  80321c:	75 0b                	jne    803229 <__umoddi3+0xe9>
  80321e:	b8 01 00 00 00       	mov    $0x1,%eax
  803223:	31 d2                	xor    %edx,%edx
  803225:	f7 f7                	div    %edi
  803227:	89 c1                	mov    %eax,%ecx
  803229:	89 d8                	mov    %ebx,%eax
  80322b:	31 d2                	xor    %edx,%edx
  80322d:	f7 f1                	div    %ecx
  80322f:	89 f0                	mov    %esi,%eax
  803231:	f7 f1                	div    %ecx
  803233:	e9 31 ff ff ff       	jmp    803169 <__umoddi3+0x29>
  803238:	90                   	nop
  803239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803240:	39 dd                	cmp    %ebx,%ebp
  803242:	72 08                	jb     80324c <__umoddi3+0x10c>
  803244:	39 f7                	cmp    %esi,%edi
  803246:	0f 87 21 ff ff ff    	ja     80316d <__umoddi3+0x2d>
  80324c:	89 da                	mov    %ebx,%edx
  80324e:	89 f0                	mov    %esi,%eax
  803250:	29 f8                	sub    %edi,%eax
  803252:	19 ea                	sbb    %ebp,%edx
  803254:	e9 14 ff ff ff       	jmp    80316d <__umoddi3+0x2d>
