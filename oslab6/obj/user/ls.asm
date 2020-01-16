
obj/user/ls.debug：     文件格式 elf32-i386


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
  80002c:	e8 97 02 00 00       	call   8002c8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80003e:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  800045:	74 20                	je     800067 <ls1+0x34>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800047:	89 f0                	mov    %esi,%eax
  800049:	3c 01                	cmp    $0x1,%al
  80004b:	19 c0                	sbb    %eax,%eax
  80004d:	83 e0 c9             	and    $0xffffffc9,%eax
  800050:	83 c0 64             	add    $0x64,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	ff 75 10             	pushl  0x10(%ebp)
  80005a:	68 02 23 80 00       	push   $0x802302
  80005f:	e8 2d 1a 00 00       	call   801a91 <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 1c                	je     800087 <ls1+0x54>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 68 23 80 00       	mov    $0x802368,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	75 4b                	jne    8000c0 <ls1+0x8d>
		printf("%s%s", prefix, sep);
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	50                   	push   %eax
  800079:	53                   	push   %ebx
  80007a:	68 0b 23 80 00       	push   $0x80230b
  80007f:	e8 0d 1a 00 00       	call   801a91 <printf>
  800084:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 14             	pushl  0x14(%ebp)
  80008d:	68 95 27 80 00       	push   $0x802795
  800092:	e8 fa 19 00 00       	call   801a91 <printf>
	if(flag['F'] && isdir)
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000a1:	74 06                	je     8000a9 <ls1+0x76>
  8000a3:	89 f0                	mov    %esi,%eax
  8000a5:	84 c0                	test   %al,%al
  8000a7:	75 37                	jne    8000e0 <ls1+0xad>
		printf("/");
	printf("\n");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 67 23 80 00       	push   $0x802367
  8000b1:	e8 db 19 00 00       	call   801a91 <printf>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5e                   	pop    %esi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	53                   	push   %ebx
  8000c4:	e8 1a 09 00 00       	call   8009e3 <strlen>
  8000c9:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000cc:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d1:	b8 00 23 80 00       	mov    $0x802300,%eax
  8000d6:	ba 68 23 80 00       	mov    $0x802368,%edx
  8000db:	0f 44 c2             	cmove  %edx,%eax
  8000de:	eb 95                	jmp    800075 <ls1+0x42>
		printf("/");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 00 23 80 00       	push   $0x802300
  8000e8:	e8 a4 19 00 00       	call   801a91 <printf>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	eb b7                	jmp    8000a9 <ls1+0x76>

008000f2 <lsdir>:
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000fe:	8b 7d 08             	mov    0x8(%ebp),%edi
	if ((fd = open(path, O_RDONLY)) < 0)
  800101:	6a 00                	push   $0x0
  800103:	57                   	push   %edi
  800104:	e8 e4 17 00 00       	call   8018ed <open>
  800109:	89 c3                	mov    %eax,%ebx
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	85 c0                	test   %eax,%eax
  800110:	78 4a                	js     80015c <lsdir+0x6a>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  800112:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	68 00 01 00 00       	push   $0x100
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
  800122:	e8 9f 13 00 00       	call   8014c6 <readn>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80012f:	75 41                	jne    800172 <lsdir+0x80>
		if (f.f_name[0])
  800131:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  800138:	74 de                	je     800118 <lsdir+0x26>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  80013a:	56                   	push   %esi
  80013b:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800141:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800148:	0f 94 c0             	sete   %al
  80014b:	0f b6 c0             	movzbl %al,%eax
  80014e:	50                   	push   %eax
  80014f:	ff 75 0c             	pushl  0xc(%ebp)
  800152:	e8 dc fe ff ff       	call   800033 <ls1>
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	eb bc                	jmp    800118 <lsdir+0x26>
		panic("open %s: %e", path, fd);
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	50                   	push   %eax
  800160:	57                   	push   %edi
  800161:	68 10 23 80 00       	push   $0x802310
  800166:	6a 1d                	push   $0x1d
  800168:	68 1c 23 80 00       	push   $0x80231c
  80016d:	e8 ae 01 00 00       	call   800320 <_panic>
	if (n > 0)
  800172:	85 c0                	test   %eax,%eax
  800174:	7f 0c                	jg     800182 <lsdir+0x90>
	if (n < 0)
  800176:	85 c0                	test   %eax,%eax
  800178:	78 1a                	js     800194 <lsdir+0xa2>
}
  80017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017d:	5b                   	pop    %ebx
  80017e:	5e                   	pop    %esi
  80017f:	5f                   	pop    %edi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    
		panic("short read in directory %s", path);
  800182:	57                   	push   %edi
  800183:	68 26 23 80 00       	push   $0x802326
  800188:	6a 22                	push   $0x22
  80018a:	68 1c 23 80 00       	push   $0x80231c
  80018f:	e8 8c 01 00 00       	call   800320 <_panic>
		panic("error reading directory %s: %e", path, n);
  800194:	83 ec 0c             	sub    $0xc,%esp
  800197:	50                   	push   %eax
  800198:	57                   	push   %edi
  800199:	68 6c 23 80 00       	push   $0x80236c
  80019e:	6a 24                	push   $0x24
  8001a0:	68 1c 23 80 00       	push   $0x80231c
  8001a5:	e8 76 01 00 00       	call   800320 <_panic>

008001aa <ls>:
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	53                   	push   %ebx
  8001ae:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8001b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((r = stat(path, &st)) < 0)
  8001b7:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001bd:	50                   	push   %eax
  8001be:	53                   	push   %ebx
  8001bf:	e8 e7 14 00 00       	call   8016ab <stat>
  8001c4:	83 c4 10             	add    $0x10,%esp
  8001c7:	85 c0                	test   %eax,%eax
  8001c9:	78 2c                	js     8001f7 <ls+0x4d>
	if (st.st_isdir && !flag['d'])
  8001cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	74 09                	je     8001db <ls+0x31>
  8001d2:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  8001d9:	74 32                	je     80020d <ls+0x63>
		ls1(0, st.st_isdir, st.st_size, path);
  8001db:	53                   	push   %ebx
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	85 c0                	test   %eax,%eax
  8001e1:	0f 95 c0             	setne  %al
  8001e4:	0f b6 c0             	movzbl %al,%eax
  8001e7:	50                   	push   %eax
  8001e8:	6a 00                	push   $0x0
  8001ea:	e8 44 fe ff ff       	call   800033 <ls1>
  8001ef:	83 c4 10             	add    $0x10,%esp
}
  8001f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    
		panic("stat %s: %e", path, r);
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	50                   	push   %eax
  8001fb:	53                   	push   %ebx
  8001fc:	68 41 23 80 00       	push   $0x802341
  800201:	6a 0f                	push   $0xf
  800203:	68 1c 23 80 00       	push   $0x80231c
  800208:	e8 13 01 00 00       	call   800320 <_panic>
		lsdir(path, prefix);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	ff 75 0c             	pushl  0xc(%ebp)
  800213:	53                   	push   %ebx
  800214:	e8 d9 fe ff ff       	call   8000f2 <lsdir>
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	eb d4                	jmp    8001f2 <ls+0x48>

0080021e <usage>:

void
usage(void)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800224:	68 4d 23 80 00       	push   $0x80234d
  800229:	e8 63 18 00 00       	call   801a91 <printf>
	exit();
  80022e:	e8 db 00 00 00       	call   80030e <exit>
}
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	c9                   	leave  
  800237:	c3                   	ret    

00800238 <umain>:

void
umain(int argc, char **argv)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	83 ec 14             	sub    $0x14,%esp
  800240:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800243:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800246:	50                   	push   %eax
  800247:	56                   	push   %esi
  800248:	8d 45 08             	lea    0x8(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	e8 b3 0d 00 00       	call   801004 <argstart>
	while ((i = argnext(&args)) >= 0)
  800251:	83 c4 10             	add    $0x10,%esp
  800254:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800257:	eb 08                	jmp    800261 <umain+0x29>
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800259:	83 04 85 20 40 80 00 	addl   $0x1,0x804020(,%eax,4)
  800260:	01 
	while ((i = argnext(&args)) >= 0)
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	53                   	push   %ebx
  800265:	e8 ca 0d 00 00       	call   801034 <argnext>
  80026a:	83 c4 10             	add    $0x10,%esp
  80026d:	85 c0                	test   %eax,%eax
  80026f:	78 16                	js     800287 <umain+0x4f>
		switch (i) {
  800271:	83 f8 64             	cmp    $0x64,%eax
  800274:	74 e3                	je     800259 <umain+0x21>
  800276:	83 f8 6c             	cmp    $0x6c,%eax
  800279:	74 de                	je     800259 <umain+0x21>
  80027b:	83 f8 46             	cmp    $0x46,%eax
  80027e:	74 d9                	je     800259 <umain+0x21>
			break;
		default:
			usage();
  800280:	e8 99 ff ff ff       	call   80021e <usage>
  800285:	eb da                	jmp    800261 <umain+0x29>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800287:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  80028c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800290:	75 2a                	jne    8002bc <umain+0x84>
		ls("/", "");
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	68 68 23 80 00       	push   $0x802368
  80029a:	68 00 23 80 00       	push   $0x802300
  80029f:	e8 06 ff ff ff       	call   8001aa <ls>
  8002a4:	83 c4 10             	add    $0x10,%esp
  8002a7:	eb 18                	jmp    8002c1 <umain+0x89>
			ls(argv[i], argv[i]);
  8002a9:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	50                   	push   %eax
  8002b0:	50                   	push   %eax
  8002b1:	e8 f4 fe ff ff       	call   8001aa <ls>
		for (i = 1; i < argc; i++)
  8002b6:	83 c3 01             	add    $0x1,%ebx
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  8002bf:	7f e8                	jg     8002a9 <umain+0x71>
	}
}
  8002c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002c4:	5b                   	pop    %ebx
  8002c5:	5e                   	pop    %esi
  8002c6:	5d                   	pop    %ebp
  8002c7:	c3                   	ret    

008002c8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	56                   	push   %esi
  8002cc:	53                   	push   %ebx
  8002cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002d0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  8002d3:	e8 fd 0a 00 00       	call   800dd5 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  8002d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002dd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e5:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ea:	85 db                	test   %ebx,%ebx
  8002ec:	7e 07                	jle    8002f5 <libmain+0x2d>
		binaryname = argv[0];
  8002ee:	8b 06                	mov    (%esi),%eax
  8002f0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8002f5:	83 ec 08             	sub    $0x8,%esp
  8002f8:	56                   	push   %esi
  8002f9:	53                   	push   %ebx
  8002fa:	e8 39 ff ff ff       	call   800238 <umain>

	// exit gracefully
	exit();
  8002ff:	e8 0a 00 00 00       	call   80030e <exit>
}
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800314:	6a 00                	push   $0x0
  800316:	e8 79 0a 00 00       	call   800d94 <sys_env_destroy>
}
  80031b:	83 c4 10             	add    $0x10,%esp
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	56                   	push   %esi
  800324:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800325:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800328:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80032e:	e8 a2 0a 00 00       	call   800dd5 <sys_getenvid>
  800333:	83 ec 0c             	sub    $0xc,%esp
  800336:	ff 75 0c             	pushl  0xc(%ebp)
  800339:	ff 75 08             	pushl  0x8(%ebp)
  80033c:	56                   	push   %esi
  80033d:	50                   	push   %eax
  80033e:	68 98 23 80 00       	push   $0x802398
  800343:	e8 b3 00 00 00       	call   8003fb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800348:	83 c4 18             	add    $0x18,%esp
  80034b:	53                   	push   %ebx
  80034c:	ff 75 10             	pushl  0x10(%ebp)
  80034f:	e8 56 00 00 00       	call   8003aa <vcprintf>
	cprintf("\n");
  800354:	c7 04 24 67 23 80 00 	movl   $0x802367,(%esp)
  80035b:	e8 9b 00 00 00       	call   8003fb <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800363:	cc                   	int3   
  800364:	eb fd                	jmp    800363 <_panic+0x43>

00800366 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800366:	55                   	push   %ebp
  800367:	89 e5                	mov    %esp,%ebp
  800369:	53                   	push   %ebx
  80036a:	83 ec 04             	sub    $0x4,%esp
  80036d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800370:	8b 13                	mov    (%ebx),%edx
  800372:	8d 42 01             	lea    0x1(%edx),%eax
  800375:	89 03                	mov    %eax,(%ebx)
  800377:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80037a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80037e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800383:	74 09                	je     80038e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800385:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800389:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80038c:	c9                   	leave  
  80038d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	68 ff 00 00 00       	push   $0xff
  800396:	8d 43 08             	lea    0x8(%ebx),%eax
  800399:	50                   	push   %eax
  80039a:	e8 b8 09 00 00       	call   800d57 <sys_cputs>
		b->idx = 0;
  80039f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	eb db                	jmp    800385 <putch+0x1f>

008003aa <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003b3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ba:	00 00 00 
	b.cnt = 0;
  8003bd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003c4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003c7:	ff 75 0c             	pushl  0xc(%ebp)
  8003ca:	ff 75 08             	pushl  0x8(%ebp)
  8003cd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003d3:	50                   	push   %eax
  8003d4:	68 66 03 80 00       	push   $0x800366
  8003d9:	e8 1a 01 00 00       	call   8004f8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003de:	83 c4 08             	add    $0x8,%esp
  8003e1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003e7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003ed:	50                   	push   %eax
  8003ee:	e8 64 09 00 00       	call   800d57 <sys_cputs>

	return b.cnt;
}
  8003f3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003f9:	c9                   	leave  
  8003fa:	c3                   	ret    

008003fb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
  8003fe:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800401:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800404:	50                   	push   %eax
  800405:	ff 75 08             	pushl  0x8(%ebp)
  800408:	e8 9d ff ff ff       	call   8003aa <vcprintf>
	va_end(ap);

	return cnt;
}
  80040d:	c9                   	leave  
  80040e:	c3                   	ret    

0080040f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
  800412:	57                   	push   %edi
  800413:	56                   	push   %esi
  800414:	53                   	push   %ebx
  800415:	83 ec 1c             	sub    $0x1c,%esp
  800418:	89 c7                	mov    %eax,%edi
  80041a:	89 d6                	mov    %edx,%esi
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800422:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800425:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800428:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80042b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800430:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800433:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800436:	39 d3                	cmp    %edx,%ebx
  800438:	72 05                	jb     80043f <printnum+0x30>
  80043a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80043d:	77 7a                	ja     8004b9 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	ff 75 18             	pushl  0x18(%ebp)
  800445:	8b 45 14             	mov    0x14(%ebp),%eax
  800448:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80044b:	53                   	push   %ebx
  80044c:	ff 75 10             	pushl  0x10(%ebp)
  80044f:	83 ec 08             	sub    $0x8,%esp
  800452:	ff 75 e4             	pushl  -0x1c(%ebp)
  800455:	ff 75 e0             	pushl  -0x20(%ebp)
  800458:	ff 75 dc             	pushl  -0x24(%ebp)
  80045b:	ff 75 d8             	pushl  -0x28(%ebp)
  80045e:	e8 4d 1c 00 00       	call   8020b0 <__udivdi3>
  800463:	83 c4 18             	add    $0x18,%esp
  800466:	52                   	push   %edx
  800467:	50                   	push   %eax
  800468:	89 f2                	mov    %esi,%edx
  80046a:	89 f8                	mov    %edi,%eax
  80046c:	e8 9e ff ff ff       	call   80040f <printnum>
  800471:	83 c4 20             	add    $0x20,%esp
  800474:	eb 13                	jmp    800489 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	56                   	push   %esi
  80047a:	ff 75 18             	pushl  0x18(%ebp)
  80047d:	ff d7                	call   *%edi
  80047f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800482:	83 eb 01             	sub    $0x1,%ebx
  800485:	85 db                	test   %ebx,%ebx
  800487:	7f ed                	jg     800476 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800489:	83 ec 08             	sub    $0x8,%esp
  80048c:	56                   	push   %esi
  80048d:	83 ec 04             	sub    $0x4,%esp
  800490:	ff 75 e4             	pushl  -0x1c(%ebp)
  800493:	ff 75 e0             	pushl  -0x20(%ebp)
  800496:	ff 75 dc             	pushl  -0x24(%ebp)
  800499:	ff 75 d8             	pushl  -0x28(%ebp)
  80049c:	e8 2f 1d 00 00       	call   8021d0 <__umoddi3>
  8004a1:	83 c4 14             	add    $0x14,%esp
  8004a4:	0f be 80 bb 23 80 00 	movsbl 0x8023bb(%eax),%eax
  8004ab:	50                   	push   %eax
  8004ac:	ff d7                	call   *%edi
}
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004b4:	5b                   	pop    %ebx
  8004b5:	5e                   	pop    %esi
  8004b6:	5f                   	pop    %edi
  8004b7:	5d                   	pop    %ebp
  8004b8:	c3                   	ret    
  8004b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004bc:	eb c4                	jmp    800482 <printnum+0x73>

008004be <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
  8004c1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004c4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004c8:	8b 10                	mov    (%eax),%edx
  8004ca:	3b 50 04             	cmp    0x4(%eax),%edx
  8004cd:	73 0a                	jae    8004d9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004d2:	89 08                	mov    %ecx,(%eax)
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	88 02                	mov    %al,(%edx)
}
  8004d9:	5d                   	pop    %ebp
  8004da:	c3                   	ret    

008004db <printfmt>:
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004e1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004e4:	50                   	push   %eax
  8004e5:	ff 75 10             	pushl  0x10(%ebp)
  8004e8:	ff 75 0c             	pushl  0xc(%ebp)
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	e8 05 00 00 00       	call   8004f8 <vprintfmt>
}
  8004f3:	83 c4 10             	add    $0x10,%esp
  8004f6:	c9                   	leave  
  8004f7:	c3                   	ret    

008004f8 <vprintfmt>:
{
  8004f8:	55                   	push   %ebp
  8004f9:	89 e5                	mov    %esp,%ebp
  8004fb:	57                   	push   %edi
  8004fc:	56                   	push   %esi
  8004fd:	53                   	push   %ebx
  8004fe:	83 ec 2c             	sub    $0x2c,%esp
  800501:	8b 75 08             	mov    0x8(%ebp),%esi
  800504:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800507:	8b 7d 10             	mov    0x10(%ebp),%edi
  80050a:	e9 c1 03 00 00       	jmp    8008d0 <vprintfmt+0x3d8>
		padc = ' ';
  80050f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800513:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80051a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800521:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800528:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80052d:	8d 47 01             	lea    0x1(%edi),%eax
  800530:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800533:	0f b6 17             	movzbl (%edi),%edx
  800536:	8d 42 dd             	lea    -0x23(%edx),%eax
  800539:	3c 55                	cmp    $0x55,%al
  80053b:	0f 87 12 04 00 00    	ja     800953 <vprintfmt+0x45b>
  800541:	0f b6 c0             	movzbl %al,%eax
  800544:	ff 24 85 00 25 80 00 	jmp    *0x802500(,%eax,4)
  80054b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80054e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800552:	eb d9                	jmp    80052d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800554:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800557:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80055b:	eb d0                	jmp    80052d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80055d:	0f b6 d2             	movzbl %dl,%edx
  800560:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800563:	b8 00 00 00 00       	mov    $0x0,%eax
  800568:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80056b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80056e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800572:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800575:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800578:	83 f9 09             	cmp    $0x9,%ecx
  80057b:	77 55                	ja     8005d2 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80057d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800580:	eb e9                	jmp    80056b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	8b 00                	mov    (%eax),%eax
  800587:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8d 40 04             	lea    0x4(%eax),%eax
  800590:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800593:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800596:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80059a:	79 91                	jns    80052d <vprintfmt+0x35>
				width = precision, precision = -1;
  80059c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005a9:	eb 82                	jmp    80052d <vprintfmt+0x35>
  8005ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ae:	85 c0                	test   %eax,%eax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	0f 49 d0             	cmovns %eax,%edx
  8005b8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005be:	e9 6a ff ff ff       	jmp    80052d <vprintfmt+0x35>
  8005c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005c6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005cd:	e9 5b ff ff ff       	jmp    80052d <vprintfmt+0x35>
  8005d2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005d5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d8:	eb bc                	jmp    800596 <vprintfmt+0x9e>
			lflag++;
  8005da:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005e0:	e9 48 ff ff ff       	jmp    80052d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8d 78 04             	lea    0x4(%eax),%edi
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	53                   	push   %ebx
  8005ef:	ff 30                	pushl  (%eax)
  8005f1:	ff d6                	call   *%esi
			break;
  8005f3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005f6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005f9:	e9 cf 02 00 00       	jmp    8008cd <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	8d 78 04             	lea    0x4(%eax),%edi
  800604:	8b 00                	mov    (%eax),%eax
  800606:	99                   	cltd   
  800607:	31 d0                	xor    %edx,%eax
  800609:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80060b:	83 f8 0f             	cmp    $0xf,%eax
  80060e:	7f 23                	jg     800633 <vprintfmt+0x13b>
  800610:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  800617:	85 d2                	test   %edx,%edx
  800619:	74 18                	je     800633 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80061b:	52                   	push   %edx
  80061c:	68 95 27 80 00       	push   $0x802795
  800621:	53                   	push   %ebx
  800622:	56                   	push   %esi
  800623:	e8 b3 fe ff ff       	call   8004db <printfmt>
  800628:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80062b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80062e:	e9 9a 02 00 00       	jmp    8008cd <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800633:	50                   	push   %eax
  800634:	68 d3 23 80 00       	push   $0x8023d3
  800639:	53                   	push   %ebx
  80063a:	56                   	push   %esi
  80063b:	e8 9b fe ff ff       	call   8004db <printfmt>
  800640:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800643:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800646:	e9 82 02 00 00       	jmp    8008cd <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	83 c0 04             	add    $0x4,%eax
  800651:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800659:	85 ff                	test   %edi,%edi
  80065b:	b8 cc 23 80 00       	mov    $0x8023cc,%eax
  800660:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800663:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800667:	0f 8e bd 00 00 00    	jle    80072a <vprintfmt+0x232>
  80066d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800671:	75 0e                	jne    800681 <vprintfmt+0x189>
  800673:	89 75 08             	mov    %esi,0x8(%ebp)
  800676:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800679:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80067c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80067f:	eb 6d                	jmp    8006ee <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	ff 75 d0             	pushl  -0x30(%ebp)
  800687:	57                   	push   %edi
  800688:	e8 6e 03 00 00       	call   8009fb <strnlen>
  80068d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800690:	29 c1                	sub    %eax,%ecx
  800692:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800695:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800698:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80069c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80069f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006a2:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a4:	eb 0f                	jmp    8006b5 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006a6:	83 ec 08             	sub    $0x8,%esp
  8006a9:	53                   	push   %ebx
  8006aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ad:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006af:	83 ef 01             	sub    $0x1,%edi
  8006b2:	83 c4 10             	add    $0x10,%esp
  8006b5:	85 ff                	test   %edi,%edi
  8006b7:	7f ed                	jg     8006a6 <vprintfmt+0x1ae>
  8006b9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006bc:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006bf:	85 c9                	test   %ecx,%ecx
  8006c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c6:	0f 49 c1             	cmovns %ecx,%eax
  8006c9:	29 c1                	sub    %eax,%ecx
  8006cb:	89 75 08             	mov    %esi,0x8(%ebp)
  8006ce:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006d1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006d4:	89 cb                	mov    %ecx,%ebx
  8006d6:	eb 16                	jmp    8006ee <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006d8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006dc:	75 31                	jne    80070f <vprintfmt+0x217>
					putch(ch, putdat);
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	ff 75 0c             	pushl  0xc(%ebp)
  8006e4:	50                   	push   %eax
  8006e5:	ff 55 08             	call   *0x8(%ebp)
  8006e8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006eb:	83 eb 01             	sub    $0x1,%ebx
  8006ee:	83 c7 01             	add    $0x1,%edi
  8006f1:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006f5:	0f be c2             	movsbl %dl,%eax
  8006f8:	85 c0                	test   %eax,%eax
  8006fa:	74 59                	je     800755 <vprintfmt+0x25d>
  8006fc:	85 f6                	test   %esi,%esi
  8006fe:	78 d8                	js     8006d8 <vprintfmt+0x1e0>
  800700:	83 ee 01             	sub    $0x1,%esi
  800703:	79 d3                	jns    8006d8 <vprintfmt+0x1e0>
  800705:	89 df                	mov    %ebx,%edi
  800707:	8b 75 08             	mov    0x8(%ebp),%esi
  80070a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80070d:	eb 37                	jmp    800746 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80070f:	0f be d2             	movsbl %dl,%edx
  800712:	83 ea 20             	sub    $0x20,%edx
  800715:	83 fa 5e             	cmp    $0x5e,%edx
  800718:	76 c4                	jbe    8006de <vprintfmt+0x1e6>
					putch('?', putdat);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	ff 75 0c             	pushl  0xc(%ebp)
  800720:	6a 3f                	push   $0x3f
  800722:	ff 55 08             	call   *0x8(%ebp)
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	eb c1                	jmp    8006eb <vprintfmt+0x1f3>
  80072a:	89 75 08             	mov    %esi,0x8(%ebp)
  80072d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800730:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800733:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800736:	eb b6                	jmp    8006ee <vprintfmt+0x1f6>
				putch(' ', putdat);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	53                   	push   %ebx
  80073c:	6a 20                	push   $0x20
  80073e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800740:	83 ef 01             	sub    $0x1,%edi
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	85 ff                	test   %edi,%edi
  800748:	7f ee                	jg     800738 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80074a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80074d:	89 45 14             	mov    %eax,0x14(%ebp)
  800750:	e9 78 01 00 00       	jmp    8008cd <vprintfmt+0x3d5>
  800755:	89 df                	mov    %ebx,%edi
  800757:	8b 75 08             	mov    0x8(%ebp),%esi
  80075a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80075d:	eb e7                	jmp    800746 <vprintfmt+0x24e>
	if (lflag >= 2)
  80075f:	83 f9 01             	cmp    $0x1,%ecx
  800762:	7e 3f                	jle    8007a3 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8b 50 04             	mov    0x4(%eax),%edx
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8d 40 08             	lea    0x8(%eax),%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80077b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80077f:	79 5c                	jns    8007dd <vprintfmt+0x2e5>
				putch('-', putdat);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	53                   	push   %ebx
  800785:	6a 2d                	push   $0x2d
  800787:	ff d6                	call   *%esi
				num = -(long long) num;
  800789:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80078c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80078f:	f7 da                	neg    %edx
  800791:	83 d1 00             	adc    $0x0,%ecx
  800794:	f7 d9                	neg    %ecx
  800796:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800799:	b8 0a 00 00 00       	mov    $0xa,%eax
  80079e:	e9 10 01 00 00       	jmp    8008b3 <vprintfmt+0x3bb>
	else if (lflag)
  8007a3:	85 c9                	test   %ecx,%ecx
  8007a5:	75 1b                	jne    8007c2 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007af:	89 c1                	mov    %eax,%ecx
  8007b1:	c1 f9 1f             	sar    $0x1f,%ecx
  8007b4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8d 40 04             	lea    0x4(%eax),%eax
  8007bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c0:	eb b9                	jmp    80077b <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ca:	89 c1                	mov    %eax,%ecx
  8007cc:	c1 f9 1f             	sar    $0x1f,%ecx
  8007cf:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	8d 40 04             	lea    0x4(%eax),%eax
  8007d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007db:	eb 9e                	jmp    80077b <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007e0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e8:	e9 c6 00 00 00       	jmp    8008b3 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8007ed:	83 f9 01             	cmp    $0x1,%ecx
  8007f0:	7e 18                	jle    80080a <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8b 10                	mov    (%eax),%edx
  8007f7:	8b 48 04             	mov    0x4(%eax),%ecx
  8007fa:	8d 40 08             	lea    0x8(%eax),%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800800:	b8 0a 00 00 00       	mov    $0xa,%eax
  800805:	e9 a9 00 00 00       	jmp    8008b3 <vprintfmt+0x3bb>
	else if (lflag)
  80080a:	85 c9                	test   %ecx,%ecx
  80080c:	75 1a                	jne    800828 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80080e:	8b 45 14             	mov    0x14(%ebp),%eax
  800811:	8b 10                	mov    (%eax),%edx
  800813:	b9 00 00 00 00       	mov    $0x0,%ecx
  800818:	8d 40 04             	lea    0x4(%eax),%eax
  80081b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80081e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800823:	e9 8b 00 00 00       	jmp    8008b3 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	8b 10                	mov    (%eax),%edx
  80082d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800832:	8d 40 04             	lea    0x4(%eax),%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800838:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083d:	eb 74                	jmp    8008b3 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80083f:	83 f9 01             	cmp    $0x1,%ecx
  800842:	7e 15                	jle    800859 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8b 10                	mov    (%eax),%edx
  800849:	8b 48 04             	mov    0x4(%eax),%ecx
  80084c:	8d 40 08             	lea    0x8(%eax),%eax
  80084f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800852:	b8 08 00 00 00       	mov    $0x8,%eax
  800857:	eb 5a                	jmp    8008b3 <vprintfmt+0x3bb>
	else if (lflag)
  800859:	85 c9                	test   %ecx,%ecx
  80085b:	75 17                	jne    800874 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80085d:	8b 45 14             	mov    0x14(%ebp),%eax
  800860:	8b 10                	mov    (%eax),%edx
  800862:	b9 00 00 00 00       	mov    $0x0,%ecx
  800867:	8d 40 04             	lea    0x4(%eax),%eax
  80086a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80086d:	b8 08 00 00 00       	mov    $0x8,%eax
  800872:	eb 3f                	jmp    8008b3 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8b 10                	mov    (%eax),%edx
  800879:	b9 00 00 00 00       	mov    $0x0,%ecx
  80087e:	8d 40 04             	lea    0x4(%eax),%eax
  800881:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800884:	b8 08 00 00 00       	mov    $0x8,%eax
  800889:	eb 28                	jmp    8008b3 <vprintfmt+0x3bb>
			putch('0', putdat);
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	53                   	push   %ebx
  80088f:	6a 30                	push   $0x30
  800891:	ff d6                	call   *%esi
			putch('x', putdat);
  800893:	83 c4 08             	add    $0x8,%esp
  800896:	53                   	push   %ebx
  800897:	6a 78                	push   $0x78
  800899:	ff d6                	call   *%esi
			num = (unsigned long long)
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	8b 10                	mov    (%eax),%edx
  8008a0:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008a5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008a8:	8d 40 04             	lea    0x4(%eax),%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ae:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008b3:	83 ec 0c             	sub    $0xc,%esp
  8008b6:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8008ba:	57                   	push   %edi
  8008bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8008be:	50                   	push   %eax
  8008bf:	51                   	push   %ecx
  8008c0:	52                   	push   %edx
  8008c1:	89 da                	mov    %ebx,%edx
  8008c3:	89 f0                	mov    %esi,%eax
  8008c5:	e8 45 fb ff ff       	call   80040f <printnum>
			break;
  8008ca:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  8008d0:	83 c7 01             	add    $0x1,%edi
  8008d3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008d7:	83 f8 25             	cmp    $0x25,%eax
  8008da:	0f 84 2f fc ff ff    	je     80050f <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  8008e0:	85 c0                	test   %eax,%eax
  8008e2:	0f 84 8b 00 00 00    	je     800973 <vprintfmt+0x47b>
			putch(ch, putdat);
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	53                   	push   %ebx
  8008ec:	50                   	push   %eax
  8008ed:	ff d6                	call   *%esi
  8008ef:	83 c4 10             	add    $0x10,%esp
  8008f2:	eb dc                	jmp    8008d0 <vprintfmt+0x3d8>
	if (lflag >= 2)
  8008f4:	83 f9 01             	cmp    $0x1,%ecx
  8008f7:	7e 15                	jle    80090e <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8008f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fc:	8b 10                	mov    (%eax),%edx
  8008fe:	8b 48 04             	mov    0x4(%eax),%ecx
  800901:	8d 40 08             	lea    0x8(%eax),%eax
  800904:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800907:	b8 10 00 00 00       	mov    $0x10,%eax
  80090c:	eb a5                	jmp    8008b3 <vprintfmt+0x3bb>
	else if (lflag)
  80090e:	85 c9                	test   %ecx,%ecx
  800910:	75 17                	jne    800929 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	8b 10                	mov    (%eax),%edx
  800917:	b9 00 00 00 00       	mov    $0x0,%ecx
  80091c:	8d 40 04             	lea    0x4(%eax),%eax
  80091f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800922:	b8 10 00 00 00       	mov    $0x10,%eax
  800927:	eb 8a                	jmp    8008b3 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800929:	8b 45 14             	mov    0x14(%ebp),%eax
  80092c:	8b 10                	mov    (%eax),%edx
  80092e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800933:	8d 40 04             	lea    0x4(%eax),%eax
  800936:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800939:	b8 10 00 00 00       	mov    $0x10,%eax
  80093e:	e9 70 ff ff ff       	jmp    8008b3 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800943:	83 ec 08             	sub    $0x8,%esp
  800946:	53                   	push   %ebx
  800947:	6a 25                	push   $0x25
  800949:	ff d6                	call   *%esi
			break;
  80094b:	83 c4 10             	add    $0x10,%esp
  80094e:	e9 7a ff ff ff       	jmp    8008cd <vprintfmt+0x3d5>
			putch('%', putdat);
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	53                   	push   %ebx
  800957:	6a 25                	push   $0x25
  800959:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80095b:	83 c4 10             	add    $0x10,%esp
  80095e:	89 f8                	mov    %edi,%eax
  800960:	eb 03                	jmp    800965 <vprintfmt+0x46d>
  800962:	83 e8 01             	sub    $0x1,%eax
  800965:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800969:	75 f7                	jne    800962 <vprintfmt+0x46a>
  80096b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80096e:	e9 5a ff ff ff       	jmp    8008cd <vprintfmt+0x3d5>
}
  800973:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800976:	5b                   	pop    %ebx
  800977:	5e                   	pop    %esi
  800978:	5f                   	pop    %edi
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 18             	sub    $0x18,%esp
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800987:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80098a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80098e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800991:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800998:	85 c0                	test   %eax,%eax
  80099a:	74 26                	je     8009c2 <vsnprintf+0x47>
  80099c:	85 d2                	test   %edx,%edx
  80099e:	7e 22                	jle    8009c2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a0:	ff 75 14             	pushl  0x14(%ebp)
  8009a3:	ff 75 10             	pushl  0x10(%ebp)
  8009a6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	68 be 04 80 00       	push   $0x8004be
  8009af:	e8 44 fb ff ff       	call   8004f8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009bd:	83 c4 10             	add    $0x10,%esp
}
  8009c0:	c9                   	leave  
  8009c1:	c3                   	ret    
		return -E_INVAL;
  8009c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009c7:	eb f7                	jmp    8009c0 <vsnprintf+0x45>

008009c9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009cf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009d2:	50                   	push   %eax
  8009d3:	ff 75 10             	pushl  0x10(%ebp)
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	ff 75 08             	pushl  0x8(%ebp)
  8009dc:	e8 9a ff ff ff       	call   80097b <vsnprintf>
	va_end(ap);

	return rc;
}
  8009e1:	c9                   	leave  
  8009e2:	c3                   	ret    

008009e3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ee:	eb 03                	jmp    8009f3 <strlen+0x10>
		n++;
  8009f0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8009f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009f7:	75 f7                	jne    8009f0 <strlen+0xd>
	return n;
}
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a01:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
  800a09:	eb 03                	jmp    800a0e <strnlen+0x13>
		n++;
  800a0b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0e:	39 d0                	cmp    %edx,%eax
  800a10:	74 06                	je     800a18 <strnlen+0x1d>
  800a12:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a16:	75 f3                	jne    800a0b <strnlen+0x10>
	return n;
}
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	53                   	push   %ebx
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a24:	89 c2                	mov    %eax,%edx
  800a26:	83 c1 01             	add    $0x1,%ecx
  800a29:	83 c2 01             	add    $0x1,%edx
  800a2c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a30:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a33:	84 db                	test   %bl,%bl
  800a35:	75 ef                	jne    800a26 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a37:	5b                   	pop    %ebx
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	53                   	push   %ebx
  800a3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a41:	53                   	push   %ebx
  800a42:	e8 9c ff ff ff       	call   8009e3 <strlen>
  800a47:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	01 d8                	add    %ebx,%eax
  800a4f:	50                   	push   %eax
  800a50:	e8 c5 ff ff ff       	call   800a1a <strcpy>
	return dst;
}
  800a55:	89 d8                	mov    %ebx,%eax
  800a57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a5a:	c9                   	leave  
  800a5b:	c3                   	ret    

00800a5c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	56                   	push   %esi
  800a60:	53                   	push   %ebx
  800a61:	8b 75 08             	mov    0x8(%ebp),%esi
  800a64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a67:	89 f3                	mov    %esi,%ebx
  800a69:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a6c:	89 f2                	mov    %esi,%edx
  800a6e:	eb 0f                	jmp    800a7f <strncpy+0x23>
		*dst++ = *src;
  800a70:	83 c2 01             	add    $0x1,%edx
  800a73:	0f b6 01             	movzbl (%ecx),%eax
  800a76:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a79:	80 39 01             	cmpb   $0x1,(%ecx)
  800a7c:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a7f:	39 da                	cmp    %ebx,%edx
  800a81:	75 ed                	jne    800a70 <strncpy+0x14>
	}
	return ret;
}
  800a83:	89 f0                	mov    %esi,%eax
  800a85:	5b                   	pop    %ebx
  800a86:	5e                   	pop    %esi
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	56                   	push   %esi
  800a8d:	53                   	push   %ebx
  800a8e:	8b 75 08             	mov    0x8(%ebp),%esi
  800a91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a94:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a97:	89 f0                	mov    %esi,%eax
  800a99:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a9d:	85 c9                	test   %ecx,%ecx
  800a9f:	75 0b                	jne    800aac <strlcpy+0x23>
  800aa1:	eb 17                	jmp    800aba <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800aa3:	83 c2 01             	add    $0x1,%edx
  800aa6:	83 c0 01             	add    $0x1,%eax
  800aa9:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800aac:	39 d8                	cmp    %ebx,%eax
  800aae:	74 07                	je     800ab7 <strlcpy+0x2e>
  800ab0:	0f b6 0a             	movzbl (%edx),%ecx
  800ab3:	84 c9                	test   %cl,%cl
  800ab5:	75 ec                	jne    800aa3 <strlcpy+0x1a>
		*dst = '\0';
  800ab7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aba:	29 f0                	sub    %esi,%eax
}
  800abc:	5b                   	pop    %ebx
  800abd:	5e                   	pop    %esi
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    

00800ac0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ac9:	eb 06                	jmp    800ad1 <strcmp+0x11>
		p++, q++;
  800acb:	83 c1 01             	add    $0x1,%ecx
  800ace:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800ad1:	0f b6 01             	movzbl (%ecx),%eax
  800ad4:	84 c0                	test   %al,%al
  800ad6:	74 04                	je     800adc <strcmp+0x1c>
  800ad8:	3a 02                	cmp    (%edx),%al
  800ada:	74 ef                	je     800acb <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800adc:	0f b6 c0             	movzbl %al,%eax
  800adf:	0f b6 12             	movzbl (%edx),%edx
  800ae2:	29 d0                	sub    %edx,%eax
}
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	53                   	push   %ebx
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af0:	89 c3                	mov    %eax,%ebx
  800af2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800af5:	eb 06                	jmp    800afd <strncmp+0x17>
		n--, p++, q++;
  800af7:	83 c0 01             	add    $0x1,%eax
  800afa:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800afd:	39 d8                	cmp    %ebx,%eax
  800aff:	74 16                	je     800b17 <strncmp+0x31>
  800b01:	0f b6 08             	movzbl (%eax),%ecx
  800b04:	84 c9                	test   %cl,%cl
  800b06:	74 04                	je     800b0c <strncmp+0x26>
  800b08:	3a 0a                	cmp    (%edx),%cl
  800b0a:	74 eb                	je     800af7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0c:	0f b6 00             	movzbl (%eax),%eax
  800b0f:	0f b6 12             	movzbl (%edx),%edx
  800b12:	29 d0                	sub    %edx,%eax
}
  800b14:	5b                   	pop    %ebx
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    
		return 0;
  800b17:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1c:	eb f6                	jmp    800b14 <strncmp+0x2e>

00800b1e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b28:	0f b6 10             	movzbl (%eax),%edx
  800b2b:	84 d2                	test   %dl,%dl
  800b2d:	74 09                	je     800b38 <strchr+0x1a>
		if (*s == c)
  800b2f:	38 ca                	cmp    %cl,%dl
  800b31:	74 0a                	je     800b3d <strchr+0x1f>
	for (; *s; s++)
  800b33:	83 c0 01             	add    $0x1,%eax
  800b36:	eb f0                	jmp    800b28 <strchr+0xa>
			return (char *) s;
	return 0;
  800b38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b49:	eb 03                	jmp    800b4e <strfind+0xf>
  800b4b:	83 c0 01             	add    $0x1,%eax
  800b4e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b51:	38 ca                	cmp    %cl,%dl
  800b53:	74 04                	je     800b59 <strfind+0x1a>
  800b55:	84 d2                	test   %dl,%dl
  800b57:	75 f2                	jne    800b4b <strfind+0xc>
			break;
	return (char *) s;
}
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	57                   	push   %edi
  800b5f:	56                   	push   %esi
  800b60:	53                   	push   %ebx
  800b61:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b64:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b67:	85 c9                	test   %ecx,%ecx
  800b69:	74 13                	je     800b7e <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b6b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b71:	75 05                	jne    800b78 <memset+0x1d>
  800b73:	f6 c1 03             	test   $0x3,%cl
  800b76:	74 0d                	je     800b85 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7b:	fc                   	cld    
  800b7c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b7e:	89 f8                	mov    %edi,%eax
  800b80:	5b                   	pop    %ebx
  800b81:	5e                   	pop    %esi
  800b82:	5f                   	pop    %edi
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    
		c &= 0xFF;
  800b85:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b89:	89 d3                	mov    %edx,%ebx
  800b8b:	c1 e3 08             	shl    $0x8,%ebx
  800b8e:	89 d0                	mov    %edx,%eax
  800b90:	c1 e0 18             	shl    $0x18,%eax
  800b93:	89 d6                	mov    %edx,%esi
  800b95:	c1 e6 10             	shl    $0x10,%esi
  800b98:	09 f0                	or     %esi,%eax
  800b9a:	09 c2                	or     %eax,%edx
  800b9c:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800b9e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ba1:	89 d0                	mov    %edx,%eax
  800ba3:	fc                   	cld    
  800ba4:	f3 ab                	rep stos %eax,%es:(%edi)
  800ba6:	eb d6                	jmp    800b7e <memset+0x23>

00800ba8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	57                   	push   %edi
  800bac:	56                   	push   %esi
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb6:	39 c6                	cmp    %eax,%esi
  800bb8:	73 35                	jae    800bef <memmove+0x47>
  800bba:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bbd:	39 c2                	cmp    %eax,%edx
  800bbf:	76 2e                	jbe    800bef <memmove+0x47>
		s += n;
		d += n;
  800bc1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bc4:	89 d6                	mov    %edx,%esi
  800bc6:	09 fe                	or     %edi,%esi
  800bc8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bce:	74 0c                	je     800bdc <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bd0:	83 ef 01             	sub    $0x1,%edi
  800bd3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bd6:	fd                   	std    
  800bd7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bd9:	fc                   	cld    
  800bda:	eb 21                	jmp    800bfd <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bdc:	f6 c1 03             	test   $0x3,%cl
  800bdf:	75 ef                	jne    800bd0 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800be1:	83 ef 04             	sub    $0x4,%edi
  800be4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800be7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bea:	fd                   	std    
  800beb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bed:	eb ea                	jmp    800bd9 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bef:	89 f2                	mov    %esi,%edx
  800bf1:	09 c2                	or     %eax,%edx
  800bf3:	f6 c2 03             	test   $0x3,%dl
  800bf6:	74 09                	je     800c01 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bf8:	89 c7                	mov    %eax,%edi
  800bfa:	fc                   	cld    
  800bfb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bfd:	5e                   	pop    %esi
  800bfe:	5f                   	pop    %edi
  800bff:	5d                   	pop    %ebp
  800c00:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c01:	f6 c1 03             	test   $0x3,%cl
  800c04:	75 f2                	jne    800bf8 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c06:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c09:	89 c7                	mov    %eax,%edi
  800c0b:	fc                   	cld    
  800c0c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c0e:	eb ed                	jmp    800bfd <memmove+0x55>

00800c10 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800c13:	ff 75 10             	pushl  0x10(%ebp)
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	ff 75 08             	pushl  0x8(%ebp)
  800c1c:	e8 87 ff ff ff       	call   800ba8 <memmove>
}
  800c21:	c9                   	leave  
  800c22:	c3                   	ret    

00800c23 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	56                   	push   %esi
  800c27:	53                   	push   %ebx
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2e:	89 c6                	mov    %eax,%esi
  800c30:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c33:	39 f0                	cmp    %esi,%eax
  800c35:	74 1c                	je     800c53 <memcmp+0x30>
		if (*s1 != *s2)
  800c37:	0f b6 08             	movzbl (%eax),%ecx
  800c3a:	0f b6 1a             	movzbl (%edx),%ebx
  800c3d:	38 d9                	cmp    %bl,%cl
  800c3f:	75 08                	jne    800c49 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c41:	83 c0 01             	add    $0x1,%eax
  800c44:	83 c2 01             	add    $0x1,%edx
  800c47:	eb ea                	jmp    800c33 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c49:	0f b6 c1             	movzbl %cl,%eax
  800c4c:	0f b6 db             	movzbl %bl,%ebx
  800c4f:	29 d8                	sub    %ebx,%eax
  800c51:	eb 05                	jmp    800c58 <memcmp+0x35>
	}

	return 0;
  800c53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c58:	5b                   	pop    %ebx
  800c59:	5e                   	pop    %esi
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c65:	89 c2                	mov    %eax,%edx
  800c67:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c6a:	39 d0                	cmp    %edx,%eax
  800c6c:	73 09                	jae    800c77 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c6e:	38 08                	cmp    %cl,(%eax)
  800c70:	74 05                	je     800c77 <memfind+0x1b>
	for (; s < ends; s++)
  800c72:	83 c0 01             	add    $0x1,%eax
  800c75:	eb f3                	jmp    800c6a <memfind+0xe>
			break;
	return (void *) s;
}
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    

00800c79 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	57                   	push   %edi
  800c7d:	56                   	push   %esi
  800c7e:	53                   	push   %ebx
  800c7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c82:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c85:	eb 03                	jmp    800c8a <strtol+0x11>
		s++;
  800c87:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c8a:	0f b6 01             	movzbl (%ecx),%eax
  800c8d:	3c 20                	cmp    $0x20,%al
  800c8f:	74 f6                	je     800c87 <strtol+0xe>
  800c91:	3c 09                	cmp    $0x9,%al
  800c93:	74 f2                	je     800c87 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c95:	3c 2b                	cmp    $0x2b,%al
  800c97:	74 2e                	je     800cc7 <strtol+0x4e>
	int neg = 0;
  800c99:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c9e:	3c 2d                	cmp    $0x2d,%al
  800ca0:	74 2f                	je     800cd1 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ca8:	75 05                	jne    800caf <strtol+0x36>
  800caa:	80 39 30             	cmpb   $0x30,(%ecx)
  800cad:	74 2c                	je     800cdb <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800caf:	85 db                	test   %ebx,%ebx
  800cb1:	75 0a                	jne    800cbd <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cb3:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800cb8:	80 39 30             	cmpb   $0x30,(%ecx)
  800cbb:	74 28                	je     800ce5 <strtol+0x6c>
		base = 10;
  800cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cc5:	eb 50                	jmp    800d17 <strtol+0x9e>
		s++;
  800cc7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cca:	bf 00 00 00 00       	mov    $0x0,%edi
  800ccf:	eb d1                	jmp    800ca2 <strtol+0x29>
		s++, neg = 1;
  800cd1:	83 c1 01             	add    $0x1,%ecx
  800cd4:	bf 01 00 00 00       	mov    $0x1,%edi
  800cd9:	eb c7                	jmp    800ca2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cdb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cdf:	74 0e                	je     800cef <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ce1:	85 db                	test   %ebx,%ebx
  800ce3:	75 d8                	jne    800cbd <strtol+0x44>
		s++, base = 8;
  800ce5:	83 c1 01             	add    $0x1,%ecx
  800ce8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ced:	eb ce                	jmp    800cbd <strtol+0x44>
		s += 2, base = 16;
  800cef:	83 c1 02             	add    $0x2,%ecx
  800cf2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cf7:	eb c4                	jmp    800cbd <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cf9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cfc:	89 f3                	mov    %esi,%ebx
  800cfe:	80 fb 19             	cmp    $0x19,%bl
  800d01:	77 29                	ja     800d2c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d03:	0f be d2             	movsbl %dl,%edx
  800d06:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d09:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d0c:	7d 30                	jge    800d3e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d0e:	83 c1 01             	add    $0x1,%ecx
  800d11:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d15:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d17:	0f b6 11             	movzbl (%ecx),%edx
  800d1a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d1d:	89 f3                	mov    %esi,%ebx
  800d1f:	80 fb 09             	cmp    $0x9,%bl
  800d22:	77 d5                	ja     800cf9 <strtol+0x80>
			dig = *s - '0';
  800d24:	0f be d2             	movsbl %dl,%edx
  800d27:	83 ea 30             	sub    $0x30,%edx
  800d2a:	eb dd                	jmp    800d09 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d2c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d2f:	89 f3                	mov    %esi,%ebx
  800d31:	80 fb 19             	cmp    $0x19,%bl
  800d34:	77 08                	ja     800d3e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d36:	0f be d2             	movsbl %dl,%edx
  800d39:	83 ea 37             	sub    $0x37,%edx
  800d3c:	eb cb                	jmp    800d09 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d3e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d42:	74 05                	je     800d49 <strtol+0xd0>
		*endptr = (char *) s;
  800d44:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d47:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d49:	89 c2                	mov    %eax,%edx
  800d4b:	f7 da                	neg    %edx
  800d4d:	85 ff                	test   %edi,%edi
  800d4f:	0f 45 c2             	cmovne %edx,%eax
}
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	57                   	push   %edi
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d68:	89 c3                	mov    %eax,%ebx
  800d6a:	89 c7                	mov    %eax,%edi
  800d6c:	89 c6                	mov    %eax,%esi
  800d6e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d80:	b8 01 00 00 00       	mov    $0x1,%eax
  800d85:	89 d1                	mov    %edx,%ecx
  800d87:	89 d3                	mov    %edx,%ebx
  800d89:	89 d7                	mov    %edx,%edi
  800d8b:	89 d6                	mov    %edx,%esi
  800d8d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d8f:	5b                   	pop    %ebx
  800d90:	5e                   	pop    %esi
  800d91:	5f                   	pop    %edi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	57                   	push   %edi
  800d98:	56                   	push   %esi
  800d99:	53                   	push   %ebx
  800d9a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800d9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da2:	8b 55 08             	mov    0x8(%ebp),%edx
  800da5:	b8 03 00 00 00       	mov    $0x3,%eax
  800daa:	89 cb                	mov    %ecx,%ebx
  800dac:	89 cf                	mov    %ecx,%edi
  800dae:	89 ce                	mov    %ecx,%esi
  800db0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db2:	85 c0                	test   %eax,%eax
  800db4:	7f 08                	jg     800dbe <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db9:	5b                   	pop    %ebx
  800dba:	5e                   	pop    %esi
  800dbb:	5f                   	pop    %edi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbe:	83 ec 0c             	sub    $0xc,%esp
  800dc1:	50                   	push   %eax
  800dc2:	6a 03                	push   $0x3
  800dc4:	68 bf 26 80 00       	push   $0x8026bf
  800dc9:	6a 23                	push   $0x23
  800dcb:	68 dc 26 80 00       	push   $0x8026dc
  800dd0:	e8 4b f5 ff ff       	call   800320 <_panic>

00800dd5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	57                   	push   %edi
  800dd9:	56                   	push   %esi
  800dda:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ddb:	ba 00 00 00 00       	mov    $0x0,%edx
  800de0:	b8 02 00 00 00       	mov    $0x2,%eax
  800de5:	89 d1                	mov    %edx,%ecx
  800de7:	89 d3                	mov    %edx,%ebx
  800de9:	89 d7                	mov    %edx,%edi
  800deb:	89 d6                	mov    %edx,%esi
  800ded:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800def:	5b                   	pop    %ebx
  800df0:	5e                   	pop    %esi
  800df1:	5f                   	pop    %edi
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <sys_yield>:

void
sys_yield(void)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	57                   	push   %edi
  800df8:	56                   	push   %esi
  800df9:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800dfa:	ba 00 00 00 00       	mov    $0x0,%edx
  800dff:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e04:	89 d1                	mov    %edx,%ecx
  800e06:	89 d3                	mov    %edx,%ebx
  800e08:	89 d7                	mov    %edx,%edi
  800e0a:	89 d6                	mov    %edx,%esi
  800e0c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e0e:	5b                   	pop    %ebx
  800e0f:	5e                   	pop    %esi
  800e10:	5f                   	pop    %edi
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    

00800e13 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	57                   	push   %edi
  800e17:	56                   	push   %esi
  800e18:	53                   	push   %ebx
  800e19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e1c:	be 00 00 00 00       	mov    $0x0,%esi
  800e21:	8b 55 08             	mov    0x8(%ebp),%edx
  800e24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e27:	b8 04 00 00 00       	mov    $0x4,%eax
  800e2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2f:	89 f7                	mov    %esi,%edi
  800e31:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e33:	85 c0                	test   %eax,%eax
  800e35:	7f 08                	jg     800e3f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3f:	83 ec 0c             	sub    $0xc,%esp
  800e42:	50                   	push   %eax
  800e43:	6a 04                	push   $0x4
  800e45:	68 bf 26 80 00       	push   $0x8026bf
  800e4a:	6a 23                	push   $0x23
  800e4c:	68 dc 26 80 00       	push   $0x8026dc
  800e51:	e8 ca f4 ff ff       	call   800320 <_panic>

00800e56 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	57                   	push   %edi
  800e5a:	56                   	push   %esi
  800e5b:	53                   	push   %ebx
  800e5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e65:	b8 05 00 00 00       	mov    $0x5,%eax
  800e6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e6d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e70:	8b 75 18             	mov    0x18(%ebp),%esi
  800e73:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e75:	85 c0                	test   %eax,%eax
  800e77:	7f 08                	jg     800e81 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7c:	5b                   	pop    %ebx
  800e7d:	5e                   	pop    %esi
  800e7e:	5f                   	pop    %edi
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	6a 05                	push   $0x5
  800e87:	68 bf 26 80 00       	push   $0x8026bf
  800e8c:	6a 23                	push   $0x23
  800e8e:	68 dc 26 80 00       	push   $0x8026dc
  800e93:	e8 88 f4 ff ff       	call   800320 <_panic>

00800e98 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	57                   	push   %edi
  800e9c:	56                   	push   %esi
  800e9d:	53                   	push   %ebx
  800e9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ea1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eac:	b8 06 00 00 00       	mov    $0x6,%eax
  800eb1:	89 df                	mov    %ebx,%edi
  800eb3:	89 de                	mov    %ebx,%esi
  800eb5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	7f 08                	jg     800ec3 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ebb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec3:	83 ec 0c             	sub    $0xc,%esp
  800ec6:	50                   	push   %eax
  800ec7:	6a 06                	push   $0x6
  800ec9:	68 bf 26 80 00       	push   $0x8026bf
  800ece:	6a 23                	push   $0x23
  800ed0:	68 dc 26 80 00       	push   $0x8026dc
  800ed5:	e8 46 f4 ff ff       	call   800320 <_panic>

00800eda <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
  800ee0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800ee3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eee:	b8 08 00 00 00       	mov    $0x8,%eax
  800ef3:	89 df                	mov    %ebx,%edi
  800ef5:	89 de                	mov    %ebx,%esi
  800ef7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	7f 08                	jg     800f05 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f05:	83 ec 0c             	sub    $0xc,%esp
  800f08:	50                   	push   %eax
  800f09:	6a 08                	push   $0x8
  800f0b:	68 bf 26 80 00       	push   $0x8026bf
  800f10:	6a 23                	push   $0x23
  800f12:	68 dc 26 80 00       	push   $0x8026dc
  800f17:	e8 04 f4 ff ff       	call   800320 <_panic>

00800f1c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	57                   	push   %edi
  800f20:	56                   	push   %esi
  800f21:	53                   	push   %ebx
  800f22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800f25:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f30:	b8 09 00 00 00       	mov    $0x9,%eax
  800f35:	89 df                	mov    %ebx,%edi
  800f37:	89 de                	mov    %ebx,%esi
  800f39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	7f 08                	jg     800f47 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f42:	5b                   	pop    %ebx
  800f43:	5e                   	pop    %esi
  800f44:	5f                   	pop    %edi
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f47:	83 ec 0c             	sub    $0xc,%esp
  800f4a:	50                   	push   %eax
  800f4b:	6a 09                	push   $0x9
  800f4d:	68 bf 26 80 00       	push   $0x8026bf
  800f52:	6a 23                	push   $0x23
  800f54:	68 dc 26 80 00       	push   $0x8026dc
  800f59:	e8 c2 f3 ff ff       	call   800320 <_panic>

00800f5e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
  800f64:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800f67:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f72:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f77:	89 df                	mov    %ebx,%edi
  800f79:	89 de                	mov    %ebx,%esi
  800f7b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	7f 08                	jg     800f89 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5f                   	pop    %edi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f89:	83 ec 0c             	sub    $0xc,%esp
  800f8c:	50                   	push   %eax
  800f8d:	6a 0a                	push   $0xa
  800f8f:	68 bf 26 80 00       	push   $0x8026bf
  800f94:	6a 23                	push   $0x23
  800f96:	68 dc 26 80 00       	push   $0x8026dc
  800f9b:	e8 80 f3 ff ff       	call   800320 <_panic>

00800fa0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	57                   	push   %edi
  800fa4:	56                   	push   %esi
  800fa5:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fac:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fb1:	be 00 00 00 00       	mov    $0x0,%esi
  800fb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fb9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fbc:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fbe:	5b                   	pop    %ebx
  800fbf:	5e                   	pop    %esi
  800fc0:	5f                   	pop    %edi
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    

00800fc3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	57                   	push   %edi
  800fc7:	56                   	push   %esi
  800fc8:	53                   	push   %ebx
  800fc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  800fcc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fd9:	89 cb                	mov    %ecx,%ebx
  800fdb:	89 cf                	mov    %ecx,%edi
  800fdd:	89 ce                	mov    %ecx,%esi
  800fdf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	7f 08                	jg     800fed <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fe5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe8:	5b                   	pop    %ebx
  800fe9:	5e                   	pop    %esi
  800fea:	5f                   	pop    %edi
  800feb:	5d                   	pop    %ebp
  800fec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fed:	83 ec 0c             	sub    $0xc,%esp
  800ff0:	50                   	push   %eax
  800ff1:	6a 0d                	push   $0xd
  800ff3:	68 bf 26 80 00       	push   $0x8026bf
  800ff8:	6a 23                	push   $0x23
  800ffa:	68 dc 26 80 00       	push   $0x8026dc
  800fff:	e8 1c f3 ff ff       	call   800320 <_panic>

00801004 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	8b 55 08             	mov    0x8(%ebp),%edx
  80100a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100d:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801010:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801012:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801015:	83 3a 01             	cmpl   $0x1,(%edx)
  801018:	7e 09                	jle    801023 <argstart+0x1f>
  80101a:	ba 68 23 80 00       	mov    $0x802368,%edx
  80101f:	85 c9                	test   %ecx,%ecx
  801021:	75 05                	jne    801028 <argstart+0x24>
  801023:	ba 00 00 00 00       	mov    $0x0,%edx
  801028:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  80102b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <argnext>:

int
argnext(struct Argstate *args)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	53                   	push   %ebx
  801038:	83 ec 04             	sub    $0x4,%esp
  80103b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  80103e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801045:	8b 43 08             	mov    0x8(%ebx),%eax
  801048:	85 c0                	test   %eax,%eax
  80104a:	74 72                	je     8010be <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  80104c:	80 38 00             	cmpb   $0x0,(%eax)
  80104f:	75 48                	jne    801099 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801051:	8b 0b                	mov    (%ebx),%ecx
  801053:	83 39 01             	cmpl   $0x1,(%ecx)
  801056:	74 58                	je     8010b0 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801058:	8b 53 04             	mov    0x4(%ebx),%edx
  80105b:	8b 42 04             	mov    0x4(%edx),%eax
  80105e:	80 38 2d             	cmpb   $0x2d,(%eax)
  801061:	75 4d                	jne    8010b0 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801063:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801067:	74 47                	je     8010b0 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801069:	83 c0 01             	add    $0x1,%eax
  80106c:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80106f:	83 ec 04             	sub    $0x4,%esp
  801072:	8b 01                	mov    (%ecx),%eax
  801074:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  80107b:	50                   	push   %eax
  80107c:	8d 42 08             	lea    0x8(%edx),%eax
  80107f:	50                   	push   %eax
  801080:	83 c2 04             	add    $0x4,%edx
  801083:	52                   	push   %edx
  801084:	e8 1f fb ff ff       	call   800ba8 <memmove>
		(*args->argc)--;
  801089:	8b 03                	mov    (%ebx),%eax
  80108b:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80108e:	8b 43 08             	mov    0x8(%ebx),%eax
  801091:	83 c4 10             	add    $0x10,%esp
  801094:	80 38 2d             	cmpb   $0x2d,(%eax)
  801097:	74 11                	je     8010aa <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801099:	8b 53 08             	mov    0x8(%ebx),%edx
  80109c:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  80109f:	83 c2 01             	add    $0x1,%edx
  8010a2:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8010a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8010aa:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8010ae:	75 e9                	jne    801099 <argnext+0x65>
	args->curarg = 0;
  8010b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8010b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8010bc:	eb e7                	jmp    8010a5 <argnext+0x71>
		return -1;
  8010be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8010c3:	eb e0                	jmp    8010a5 <argnext+0x71>

008010c5 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	53                   	push   %ebx
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8010cf:	8b 43 08             	mov    0x8(%ebx),%eax
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	74 5b                	je     801131 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  8010d6:	80 38 00             	cmpb   $0x0,(%eax)
  8010d9:	74 12                	je     8010ed <argnextvalue+0x28>
		args->argvalue = args->curarg;
  8010db:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8010de:	c7 43 08 68 23 80 00 	movl   $0x802368,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  8010e5:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8010e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010eb:	c9                   	leave  
  8010ec:	c3                   	ret    
	} else if (*args->argc > 1) {
  8010ed:	8b 13                	mov    (%ebx),%edx
  8010ef:	83 3a 01             	cmpl   $0x1,(%edx)
  8010f2:	7f 10                	jg     801104 <argnextvalue+0x3f>
		args->argvalue = 0;
  8010f4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8010fb:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801102:	eb e1                	jmp    8010e5 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801104:	8b 43 04             	mov    0x4(%ebx),%eax
  801107:	8b 48 04             	mov    0x4(%eax),%ecx
  80110a:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80110d:	83 ec 04             	sub    $0x4,%esp
  801110:	8b 12                	mov    (%edx),%edx
  801112:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801119:	52                   	push   %edx
  80111a:	8d 50 08             	lea    0x8(%eax),%edx
  80111d:	52                   	push   %edx
  80111e:	83 c0 04             	add    $0x4,%eax
  801121:	50                   	push   %eax
  801122:	e8 81 fa ff ff       	call   800ba8 <memmove>
		(*args->argc)--;
  801127:	8b 03                	mov    (%ebx),%eax
  801129:	83 28 01             	subl   $0x1,(%eax)
  80112c:	83 c4 10             	add    $0x10,%esp
  80112f:	eb b4                	jmp    8010e5 <argnextvalue+0x20>
		return 0;
  801131:	b8 00 00 00 00       	mov    $0x0,%eax
  801136:	eb b0                	jmp    8010e8 <argnextvalue+0x23>

00801138 <argvalue>:
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	83 ec 08             	sub    $0x8,%esp
  80113e:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801141:	8b 42 0c             	mov    0xc(%edx),%eax
  801144:	85 c0                	test   %eax,%eax
  801146:	74 02                	je     80114a <argvalue+0x12>
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80114a:	83 ec 0c             	sub    $0xc,%esp
  80114d:	52                   	push   %edx
  80114e:	e8 72 ff ff ff       	call   8010c5 <argnextvalue>
  801153:	83 c4 10             	add    $0x10,%esp
  801156:	eb f0                	jmp    801148 <argvalue+0x10>

00801158 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	05 00 00 00 30       	add    $0x30000000,%eax
  801163:	c1 e8 0c             	shr    $0xc,%eax
}
  801166:	5d                   	pop    %ebp
  801167:	c3                   	ret    

00801168 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801173:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801178:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80117d:	5d                   	pop    %ebp
  80117e:	c3                   	ret    

0080117f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801185:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	c1 ea 16             	shr    $0x16,%edx
  80118f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801196:	f6 c2 01             	test   $0x1,%dl
  801199:	74 2a                	je     8011c5 <fd_alloc+0x46>
  80119b:	89 c2                	mov    %eax,%edx
  80119d:	c1 ea 0c             	shr    $0xc,%edx
  8011a0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a7:	f6 c2 01             	test   $0x1,%dl
  8011aa:	74 19                	je     8011c5 <fd_alloc+0x46>
  8011ac:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011b1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011b6:	75 d2                	jne    80118a <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011b8:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011be:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011c3:	eb 07                	jmp    8011cc <fd_alloc+0x4d>
			*fd_store = fd;
  8011c5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011cc:	5d                   	pop    %ebp
  8011cd:	c3                   	ret    

008011ce <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011d4:	83 f8 1f             	cmp    $0x1f,%eax
  8011d7:	77 36                	ja     80120f <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011d9:	c1 e0 0c             	shl    $0xc,%eax
  8011dc:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011e1:	89 c2                	mov    %eax,%edx
  8011e3:	c1 ea 16             	shr    $0x16,%edx
  8011e6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011ed:	f6 c2 01             	test   $0x1,%dl
  8011f0:	74 24                	je     801216 <fd_lookup+0x48>
  8011f2:	89 c2                	mov    %eax,%edx
  8011f4:	c1 ea 0c             	shr    $0xc,%edx
  8011f7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011fe:	f6 c2 01             	test   $0x1,%dl
  801201:	74 1a                	je     80121d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801203:	8b 55 0c             	mov    0xc(%ebp),%edx
  801206:	89 02                	mov    %eax,(%edx)
	return 0;
  801208:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120d:	5d                   	pop    %ebp
  80120e:	c3                   	ret    
		return -E_INVAL;
  80120f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801214:	eb f7                	jmp    80120d <fd_lookup+0x3f>
		return -E_INVAL;
  801216:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80121b:	eb f0                	jmp    80120d <fd_lookup+0x3f>
  80121d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801222:	eb e9                	jmp    80120d <fd_lookup+0x3f>

00801224 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	83 ec 08             	sub    $0x8,%esp
  80122a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122d:	ba 6c 27 80 00       	mov    $0x80276c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801232:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801237:	39 08                	cmp    %ecx,(%eax)
  801239:	74 33                	je     80126e <dev_lookup+0x4a>
  80123b:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80123e:	8b 02                	mov    (%edx),%eax
  801240:	85 c0                	test   %eax,%eax
  801242:	75 f3                	jne    801237 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801244:	a1 20 44 80 00       	mov    0x804420,%eax
  801249:	8b 40 48             	mov    0x48(%eax),%eax
  80124c:	83 ec 04             	sub    $0x4,%esp
  80124f:	51                   	push   %ecx
  801250:	50                   	push   %eax
  801251:	68 ec 26 80 00       	push   $0x8026ec
  801256:	e8 a0 f1 ff ff       	call   8003fb <cprintf>
	*dev = 0;
  80125b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801264:	83 c4 10             	add    $0x10,%esp
  801267:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    
			*dev = devtab[i];
  80126e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801271:	89 01                	mov    %eax,(%ecx)
			return 0;
  801273:	b8 00 00 00 00       	mov    $0x0,%eax
  801278:	eb f2                	jmp    80126c <dev_lookup+0x48>

0080127a <fd_close>:
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	57                   	push   %edi
  80127e:	56                   	push   %esi
  80127f:	53                   	push   %ebx
  801280:	83 ec 1c             	sub    $0x1c,%esp
  801283:	8b 75 08             	mov    0x8(%ebp),%esi
  801286:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801289:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80128c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80128d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801293:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801296:	50                   	push   %eax
  801297:	e8 32 ff ff ff       	call   8011ce <fd_lookup>
  80129c:	89 c3                	mov    %eax,%ebx
  80129e:	83 c4 08             	add    $0x8,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	78 05                	js     8012aa <fd_close+0x30>
	    || fd != fd2)
  8012a5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012a8:	74 16                	je     8012c0 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012aa:	89 f8                	mov    %edi,%eax
  8012ac:	84 c0                	test   %al,%al
  8012ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b3:	0f 44 d8             	cmove  %eax,%ebx
}
  8012b6:	89 d8                	mov    %ebx,%eax
  8012b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012bb:	5b                   	pop    %ebx
  8012bc:	5e                   	pop    %esi
  8012bd:	5f                   	pop    %edi
  8012be:	5d                   	pop    %ebp
  8012bf:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012c0:	83 ec 08             	sub    $0x8,%esp
  8012c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012c6:	50                   	push   %eax
  8012c7:	ff 36                	pushl  (%esi)
  8012c9:	e8 56 ff ff ff       	call   801224 <dev_lookup>
  8012ce:	89 c3                	mov    %eax,%ebx
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	78 15                	js     8012ec <fd_close+0x72>
		if (dev->dev_close)
  8012d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012da:	8b 40 10             	mov    0x10(%eax),%eax
  8012dd:	85 c0                	test   %eax,%eax
  8012df:	74 1b                	je     8012fc <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8012e1:	83 ec 0c             	sub    $0xc,%esp
  8012e4:	56                   	push   %esi
  8012e5:	ff d0                	call   *%eax
  8012e7:	89 c3                	mov    %eax,%ebx
  8012e9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012ec:	83 ec 08             	sub    $0x8,%esp
  8012ef:	56                   	push   %esi
  8012f0:	6a 00                	push   $0x0
  8012f2:	e8 a1 fb ff ff       	call   800e98 <sys_page_unmap>
	return r;
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	eb ba                	jmp    8012b6 <fd_close+0x3c>
			r = 0;
  8012fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801301:	eb e9                	jmp    8012ec <fd_close+0x72>

00801303 <close>:

int
close(int fdnum)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801309:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130c:	50                   	push   %eax
  80130d:	ff 75 08             	pushl  0x8(%ebp)
  801310:	e8 b9 fe ff ff       	call   8011ce <fd_lookup>
  801315:	83 c4 08             	add    $0x8,%esp
  801318:	85 c0                	test   %eax,%eax
  80131a:	78 10                	js     80132c <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	6a 01                	push   $0x1
  801321:	ff 75 f4             	pushl  -0xc(%ebp)
  801324:	e8 51 ff ff ff       	call   80127a <fd_close>
  801329:	83 c4 10             	add    $0x10,%esp
}
  80132c:	c9                   	leave  
  80132d:	c3                   	ret    

0080132e <close_all>:

void
close_all(void)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	53                   	push   %ebx
  801332:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801335:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80133a:	83 ec 0c             	sub    $0xc,%esp
  80133d:	53                   	push   %ebx
  80133e:	e8 c0 ff ff ff       	call   801303 <close>
	for (i = 0; i < MAXFD; i++)
  801343:	83 c3 01             	add    $0x1,%ebx
  801346:	83 c4 10             	add    $0x10,%esp
  801349:	83 fb 20             	cmp    $0x20,%ebx
  80134c:	75 ec                	jne    80133a <close_all+0xc>
}
  80134e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	57                   	push   %edi
  801357:	56                   	push   %esi
  801358:	53                   	push   %ebx
  801359:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80135c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80135f:	50                   	push   %eax
  801360:	ff 75 08             	pushl  0x8(%ebp)
  801363:	e8 66 fe ff ff       	call   8011ce <fd_lookup>
  801368:	89 c3                	mov    %eax,%ebx
  80136a:	83 c4 08             	add    $0x8,%esp
  80136d:	85 c0                	test   %eax,%eax
  80136f:	0f 88 81 00 00 00    	js     8013f6 <dup+0xa3>
		return r;
	close(newfdnum);
  801375:	83 ec 0c             	sub    $0xc,%esp
  801378:	ff 75 0c             	pushl  0xc(%ebp)
  80137b:	e8 83 ff ff ff       	call   801303 <close>

	newfd = INDEX2FD(newfdnum);
  801380:	8b 75 0c             	mov    0xc(%ebp),%esi
  801383:	c1 e6 0c             	shl    $0xc,%esi
  801386:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80138c:	83 c4 04             	add    $0x4,%esp
  80138f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801392:	e8 d1 fd ff ff       	call   801168 <fd2data>
  801397:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801399:	89 34 24             	mov    %esi,(%esp)
  80139c:	e8 c7 fd ff ff       	call   801168 <fd2data>
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013a6:	89 d8                	mov    %ebx,%eax
  8013a8:	c1 e8 16             	shr    $0x16,%eax
  8013ab:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013b2:	a8 01                	test   $0x1,%al
  8013b4:	74 11                	je     8013c7 <dup+0x74>
  8013b6:	89 d8                	mov    %ebx,%eax
  8013b8:	c1 e8 0c             	shr    $0xc,%eax
  8013bb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013c2:	f6 c2 01             	test   $0x1,%dl
  8013c5:	75 39                	jne    801400 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ca:	89 d0                	mov    %edx,%eax
  8013cc:	c1 e8 0c             	shr    $0xc,%eax
  8013cf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013d6:	83 ec 0c             	sub    $0xc,%esp
  8013d9:	25 07 0e 00 00       	and    $0xe07,%eax
  8013de:	50                   	push   %eax
  8013df:	56                   	push   %esi
  8013e0:	6a 00                	push   $0x0
  8013e2:	52                   	push   %edx
  8013e3:	6a 00                	push   $0x0
  8013e5:	e8 6c fa ff ff       	call   800e56 <sys_page_map>
  8013ea:	89 c3                	mov    %eax,%ebx
  8013ec:	83 c4 20             	add    $0x20,%esp
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	78 31                	js     801424 <dup+0xd1>
		goto err;

	return newfdnum;
  8013f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013f6:	89 d8                	mov    %ebx,%eax
  8013f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013fb:	5b                   	pop    %ebx
  8013fc:	5e                   	pop    %esi
  8013fd:	5f                   	pop    %edi
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801400:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801407:	83 ec 0c             	sub    $0xc,%esp
  80140a:	25 07 0e 00 00       	and    $0xe07,%eax
  80140f:	50                   	push   %eax
  801410:	57                   	push   %edi
  801411:	6a 00                	push   $0x0
  801413:	53                   	push   %ebx
  801414:	6a 00                	push   $0x0
  801416:	e8 3b fa ff ff       	call   800e56 <sys_page_map>
  80141b:	89 c3                	mov    %eax,%ebx
  80141d:	83 c4 20             	add    $0x20,%esp
  801420:	85 c0                	test   %eax,%eax
  801422:	79 a3                	jns    8013c7 <dup+0x74>
	sys_page_unmap(0, newfd);
  801424:	83 ec 08             	sub    $0x8,%esp
  801427:	56                   	push   %esi
  801428:	6a 00                	push   $0x0
  80142a:	e8 69 fa ff ff       	call   800e98 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80142f:	83 c4 08             	add    $0x8,%esp
  801432:	57                   	push   %edi
  801433:	6a 00                	push   $0x0
  801435:	e8 5e fa ff ff       	call   800e98 <sys_page_unmap>
	return r;
  80143a:	83 c4 10             	add    $0x10,%esp
  80143d:	eb b7                	jmp    8013f6 <dup+0xa3>

0080143f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	53                   	push   %ebx
  801443:	83 ec 14             	sub    $0x14,%esp
  801446:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801449:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80144c:	50                   	push   %eax
  80144d:	53                   	push   %ebx
  80144e:	e8 7b fd ff ff       	call   8011ce <fd_lookup>
  801453:	83 c4 08             	add    $0x8,%esp
  801456:	85 c0                	test   %eax,%eax
  801458:	78 3f                	js     801499 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80145a:	83 ec 08             	sub    $0x8,%esp
  80145d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801460:	50                   	push   %eax
  801461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801464:	ff 30                	pushl  (%eax)
  801466:	e8 b9 fd ff ff       	call   801224 <dev_lookup>
  80146b:	83 c4 10             	add    $0x10,%esp
  80146e:	85 c0                	test   %eax,%eax
  801470:	78 27                	js     801499 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801472:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801475:	8b 42 08             	mov    0x8(%edx),%eax
  801478:	83 e0 03             	and    $0x3,%eax
  80147b:	83 f8 01             	cmp    $0x1,%eax
  80147e:	74 1e                	je     80149e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801483:	8b 40 08             	mov    0x8(%eax),%eax
  801486:	85 c0                	test   %eax,%eax
  801488:	74 35                	je     8014bf <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	ff 75 10             	pushl  0x10(%ebp)
  801490:	ff 75 0c             	pushl  0xc(%ebp)
  801493:	52                   	push   %edx
  801494:	ff d0                	call   *%eax
  801496:	83 c4 10             	add    $0x10,%esp
}
  801499:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80149e:	a1 20 44 80 00       	mov    0x804420,%eax
  8014a3:	8b 40 48             	mov    0x48(%eax),%eax
  8014a6:	83 ec 04             	sub    $0x4,%esp
  8014a9:	53                   	push   %ebx
  8014aa:	50                   	push   %eax
  8014ab:	68 30 27 80 00       	push   $0x802730
  8014b0:	e8 46 ef ff ff       	call   8003fb <cprintf>
		return -E_INVAL;
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014bd:	eb da                	jmp    801499 <read+0x5a>
		return -E_NOT_SUPP;
  8014bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014c4:	eb d3                	jmp    801499 <read+0x5a>

008014c6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	57                   	push   %edi
  8014ca:	56                   	push   %esi
  8014cb:	53                   	push   %ebx
  8014cc:	83 ec 0c             	sub    $0xc,%esp
  8014cf:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014d2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014da:	39 f3                	cmp    %esi,%ebx
  8014dc:	73 25                	jae    801503 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014de:	83 ec 04             	sub    $0x4,%esp
  8014e1:	89 f0                	mov    %esi,%eax
  8014e3:	29 d8                	sub    %ebx,%eax
  8014e5:	50                   	push   %eax
  8014e6:	89 d8                	mov    %ebx,%eax
  8014e8:	03 45 0c             	add    0xc(%ebp),%eax
  8014eb:	50                   	push   %eax
  8014ec:	57                   	push   %edi
  8014ed:	e8 4d ff ff ff       	call   80143f <read>
		if (m < 0)
  8014f2:	83 c4 10             	add    $0x10,%esp
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	78 08                	js     801501 <readn+0x3b>
			return m;
		if (m == 0)
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	74 06                	je     801503 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8014fd:	01 c3                	add    %eax,%ebx
  8014ff:	eb d9                	jmp    8014da <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801501:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801503:	89 d8                	mov    %ebx,%eax
  801505:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801508:	5b                   	pop    %ebx
  801509:	5e                   	pop    %esi
  80150a:	5f                   	pop    %edi
  80150b:	5d                   	pop    %ebp
  80150c:	c3                   	ret    

0080150d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	53                   	push   %ebx
  801511:	83 ec 14             	sub    $0x14,%esp
  801514:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801517:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151a:	50                   	push   %eax
  80151b:	53                   	push   %ebx
  80151c:	e8 ad fc ff ff       	call   8011ce <fd_lookup>
  801521:	83 c4 08             	add    $0x8,%esp
  801524:	85 c0                	test   %eax,%eax
  801526:	78 3a                	js     801562 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152e:	50                   	push   %eax
  80152f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801532:	ff 30                	pushl  (%eax)
  801534:	e8 eb fc ff ff       	call   801224 <dev_lookup>
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 22                	js     801562 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801543:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801547:	74 1e                	je     801567 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801549:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154c:	8b 52 0c             	mov    0xc(%edx),%edx
  80154f:	85 d2                	test   %edx,%edx
  801551:	74 35                	je     801588 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801553:	83 ec 04             	sub    $0x4,%esp
  801556:	ff 75 10             	pushl  0x10(%ebp)
  801559:	ff 75 0c             	pushl  0xc(%ebp)
  80155c:	50                   	push   %eax
  80155d:	ff d2                	call   *%edx
  80155f:	83 c4 10             	add    $0x10,%esp
}
  801562:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801565:	c9                   	leave  
  801566:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801567:	a1 20 44 80 00       	mov    0x804420,%eax
  80156c:	8b 40 48             	mov    0x48(%eax),%eax
  80156f:	83 ec 04             	sub    $0x4,%esp
  801572:	53                   	push   %ebx
  801573:	50                   	push   %eax
  801574:	68 4c 27 80 00       	push   $0x80274c
  801579:	e8 7d ee ff ff       	call   8003fb <cprintf>
		return -E_INVAL;
  80157e:	83 c4 10             	add    $0x10,%esp
  801581:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801586:	eb da                	jmp    801562 <write+0x55>
		return -E_NOT_SUPP;
  801588:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80158d:	eb d3                	jmp    801562 <write+0x55>

0080158f <seek>:

int
seek(int fdnum, off_t offset)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801595:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801598:	50                   	push   %eax
  801599:	ff 75 08             	pushl  0x8(%ebp)
  80159c:	e8 2d fc ff ff       	call   8011ce <fd_lookup>
  8015a1:	83 c4 08             	add    $0x8,%esp
  8015a4:	85 c0                	test   %eax,%eax
  8015a6:	78 0e                	js     8015b6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ae:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	53                   	push   %ebx
  8015bc:	83 ec 14             	sub    $0x14,%esp
  8015bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c5:	50                   	push   %eax
  8015c6:	53                   	push   %ebx
  8015c7:	e8 02 fc ff ff       	call   8011ce <fd_lookup>
  8015cc:	83 c4 08             	add    $0x8,%esp
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	78 37                	js     80160a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015d3:	83 ec 08             	sub    $0x8,%esp
  8015d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d9:	50                   	push   %eax
  8015da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015dd:	ff 30                	pushl  (%eax)
  8015df:	e8 40 fc ff ff       	call   801224 <dev_lookup>
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	78 1f                	js     80160a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ee:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015f2:	74 1b                	je     80160f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f7:	8b 52 18             	mov    0x18(%edx),%edx
  8015fa:	85 d2                	test   %edx,%edx
  8015fc:	74 32                	je     801630 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015fe:	83 ec 08             	sub    $0x8,%esp
  801601:	ff 75 0c             	pushl  0xc(%ebp)
  801604:	50                   	push   %eax
  801605:	ff d2                	call   *%edx
  801607:	83 c4 10             	add    $0x10,%esp
}
  80160a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80160f:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801614:	8b 40 48             	mov    0x48(%eax),%eax
  801617:	83 ec 04             	sub    $0x4,%esp
  80161a:	53                   	push   %ebx
  80161b:	50                   	push   %eax
  80161c:	68 0c 27 80 00       	push   $0x80270c
  801621:	e8 d5 ed ff ff       	call   8003fb <cprintf>
		return -E_INVAL;
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162e:	eb da                	jmp    80160a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801630:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801635:	eb d3                	jmp    80160a <ftruncate+0x52>

00801637 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	53                   	push   %ebx
  80163b:	83 ec 14             	sub    $0x14,%esp
  80163e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801641:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801644:	50                   	push   %eax
  801645:	ff 75 08             	pushl  0x8(%ebp)
  801648:	e8 81 fb ff ff       	call   8011ce <fd_lookup>
  80164d:	83 c4 08             	add    $0x8,%esp
  801650:	85 c0                	test   %eax,%eax
  801652:	78 4b                	js     80169f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801654:	83 ec 08             	sub    $0x8,%esp
  801657:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165a:	50                   	push   %eax
  80165b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165e:	ff 30                	pushl  (%eax)
  801660:	e8 bf fb ff ff       	call   801224 <dev_lookup>
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	85 c0                	test   %eax,%eax
  80166a:	78 33                	js     80169f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80166c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801673:	74 2f                	je     8016a4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801675:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801678:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80167f:	00 00 00 
	stat->st_isdir = 0;
  801682:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801689:	00 00 00 
	stat->st_dev = dev;
  80168c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801692:	83 ec 08             	sub    $0x8,%esp
  801695:	53                   	push   %ebx
  801696:	ff 75 f0             	pushl  -0x10(%ebp)
  801699:	ff 50 14             	call   *0x14(%eax)
  80169c:	83 c4 10             	add    $0x10,%esp
}
  80169f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    
		return -E_NOT_SUPP;
  8016a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a9:	eb f4                	jmp    80169f <fstat+0x68>

008016ab <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	56                   	push   %esi
  8016af:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016b0:	83 ec 08             	sub    $0x8,%esp
  8016b3:	6a 00                	push   $0x0
  8016b5:	ff 75 08             	pushl  0x8(%ebp)
  8016b8:	e8 30 02 00 00       	call   8018ed <open>
  8016bd:	89 c3                	mov    %eax,%ebx
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	78 1b                	js     8016e1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016c6:	83 ec 08             	sub    $0x8,%esp
  8016c9:	ff 75 0c             	pushl  0xc(%ebp)
  8016cc:	50                   	push   %eax
  8016cd:	e8 65 ff ff ff       	call   801637 <fstat>
  8016d2:	89 c6                	mov    %eax,%esi
	close(fd);
  8016d4:	89 1c 24             	mov    %ebx,(%esp)
  8016d7:	e8 27 fc ff ff       	call   801303 <close>
	return r;
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	89 f3                	mov    %esi,%ebx
}
  8016e1:	89 d8                	mov    %ebx,%eax
  8016e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e6:	5b                   	pop    %ebx
  8016e7:	5e                   	pop    %esi
  8016e8:	5d                   	pop    %ebp
  8016e9:	c3                   	ret    

008016ea <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	56                   	push   %esi
  8016ee:	53                   	push   %ebx
  8016ef:	89 c6                	mov    %eax,%esi
  8016f1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016f3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016fa:	74 27                	je     801723 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016fc:	6a 07                	push   $0x7
  8016fe:	68 00 50 80 00       	push   $0x805000
  801703:	56                   	push   %esi
  801704:	ff 35 00 40 80 00    	pushl  0x804000
  80170a:	e8 cb 08 00 00       	call   801fda <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80170f:	83 c4 0c             	add    $0xc,%esp
  801712:	6a 00                	push   $0x0
  801714:	53                   	push   %ebx
  801715:	6a 00                	push   $0x0
  801717:	e8 55 08 00 00       	call   801f71 <ipc_recv>
}
  80171c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80171f:	5b                   	pop    %ebx
  801720:	5e                   	pop    %esi
  801721:	5d                   	pop    %ebp
  801722:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801723:	83 ec 0c             	sub    $0xc,%esp
  801726:	6a 01                	push   $0x1
  801728:	e8 01 09 00 00       	call   80202e <ipc_find_env>
  80172d:	a3 00 40 80 00       	mov    %eax,0x804000
  801732:	83 c4 10             	add    $0x10,%esp
  801735:	eb c5                	jmp    8016fc <fsipc+0x12>

00801737 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	8b 40 0c             	mov    0xc(%eax),%eax
  801743:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801750:	ba 00 00 00 00       	mov    $0x0,%edx
  801755:	b8 02 00 00 00       	mov    $0x2,%eax
  80175a:	e8 8b ff ff ff       	call   8016ea <fsipc>
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <devfile_flush>:
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	8b 40 0c             	mov    0xc(%eax),%eax
  80176d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801772:	ba 00 00 00 00       	mov    $0x0,%edx
  801777:	b8 06 00 00 00       	mov    $0x6,%eax
  80177c:	e8 69 ff ff ff       	call   8016ea <fsipc>
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <devfile_stat>:
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	53                   	push   %ebx
  801787:	83 ec 04             	sub    $0x4,%esp
  80178a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8b 40 0c             	mov    0xc(%eax),%eax
  801793:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801798:	ba 00 00 00 00       	mov    $0x0,%edx
  80179d:	b8 05 00 00 00       	mov    $0x5,%eax
  8017a2:	e8 43 ff ff ff       	call   8016ea <fsipc>
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	78 2c                	js     8017d7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017ab:	83 ec 08             	sub    $0x8,%esp
  8017ae:	68 00 50 80 00       	push   $0x805000
  8017b3:	53                   	push   %ebx
  8017b4:	e8 61 f2 ff ff       	call   800a1a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017b9:	a1 80 50 80 00       	mov    0x805080,%eax
  8017be:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017c4:	a1 84 50 80 00       	mov    0x805084,%eax
  8017c9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <devfile_write>:
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	53                   	push   %ebx
  8017e0:	83 ec 08             	sub    $0x8,%esp
  8017e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  8017e6:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8017ec:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8017f1:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8017fa:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017ff:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801805:	53                   	push   %ebx
  801806:	ff 75 0c             	pushl  0xc(%ebp)
  801809:	68 08 50 80 00       	push   $0x805008
  80180e:	e8 95 f3 ff ff       	call   800ba8 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801813:	ba 00 00 00 00       	mov    $0x0,%edx
  801818:	b8 04 00 00 00       	mov    $0x4,%eax
  80181d:	e8 c8 fe ff ff       	call   8016ea <fsipc>
  801822:	83 c4 10             	add    $0x10,%esp
  801825:	85 c0                	test   %eax,%eax
  801827:	78 0b                	js     801834 <devfile_write+0x58>
	assert(r <= n);
  801829:	39 d8                	cmp    %ebx,%eax
  80182b:	77 0c                	ja     801839 <devfile_write+0x5d>
	assert(r <= PGSIZE);
  80182d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801832:	7f 1e                	jg     801852 <devfile_write+0x76>
}
  801834:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801837:	c9                   	leave  
  801838:	c3                   	ret    
	assert(r <= n);
  801839:	68 7c 27 80 00       	push   $0x80277c
  80183e:	68 83 27 80 00       	push   $0x802783
  801843:	68 98 00 00 00       	push   $0x98
  801848:	68 98 27 80 00       	push   $0x802798
  80184d:	e8 ce ea ff ff       	call   800320 <_panic>
	assert(r <= PGSIZE);
  801852:	68 a3 27 80 00       	push   $0x8027a3
  801857:	68 83 27 80 00       	push   $0x802783
  80185c:	68 99 00 00 00       	push   $0x99
  801861:	68 98 27 80 00       	push   $0x802798
  801866:	e8 b5 ea ff ff       	call   800320 <_panic>

0080186b <devfile_read>:
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	56                   	push   %esi
  80186f:	53                   	push   %ebx
  801870:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	8b 40 0c             	mov    0xc(%eax),%eax
  801879:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80187e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801884:	ba 00 00 00 00       	mov    $0x0,%edx
  801889:	b8 03 00 00 00       	mov    $0x3,%eax
  80188e:	e8 57 fe ff ff       	call   8016ea <fsipc>
  801893:	89 c3                	mov    %eax,%ebx
  801895:	85 c0                	test   %eax,%eax
  801897:	78 1f                	js     8018b8 <devfile_read+0x4d>
	assert(r <= n);
  801899:	39 f0                	cmp    %esi,%eax
  80189b:	77 24                	ja     8018c1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80189d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018a2:	7f 33                	jg     8018d7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018a4:	83 ec 04             	sub    $0x4,%esp
  8018a7:	50                   	push   %eax
  8018a8:	68 00 50 80 00       	push   $0x805000
  8018ad:	ff 75 0c             	pushl  0xc(%ebp)
  8018b0:	e8 f3 f2 ff ff       	call   800ba8 <memmove>
	return r;
  8018b5:	83 c4 10             	add    $0x10,%esp
}
  8018b8:	89 d8                	mov    %ebx,%eax
  8018ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018bd:	5b                   	pop    %ebx
  8018be:	5e                   	pop    %esi
  8018bf:	5d                   	pop    %ebp
  8018c0:	c3                   	ret    
	assert(r <= n);
  8018c1:	68 7c 27 80 00       	push   $0x80277c
  8018c6:	68 83 27 80 00       	push   $0x802783
  8018cb:	6a 7c                	push   $0x7c
  8018cd:	68 98 27 80 00       	push   $0x802798
  8018d2:	e8 49 ea ff ff       	call   800320 <_panic>
	assert(r <= PGSIZE);
  8018d7:	68 a3 27 80 00       	push   $0x8027a3
  8018dc:	68 83 27 80 00       	push   $0x802783
  8018e1:	6a 7d                	push   $0x7d
  8018e3:	68 98 27 80 00       	push   $0x802798
  8018e8:	e8 33 ea ff ff       	call   800320 <_panic>

008018ed <open>:
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	56                   	push   %esi
  8018f1:	53                   	push   %ebx
  8018f2:	83 ec 1c             	sub    $0x1c,%esp
  8018f5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018f8:	56                   	push   %esi
  8018f9:	e8 e5 f0 ff ff       	call   8009e3 <strlen>
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801906:	7f 6c                	jg     801974 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190e:	50                   	push   %eax
  80190f:	e8 6b f8 ff ff       	call   80117f <fd_alloc>
  801914:	89 c3                	mov    %eax,%ebx
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	85 c0                	test   %eax,%eax
  80191b:	78 3c                	js     801959 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80191d:	83 ec 08             	sub    $0x8,%esp
  801920:	56                   	push   %esi
  801921:	68 00 50 80 00       	push   $0x805000
  801926:	e8 ef f0 ff ff       	call   800a1a <strcpy>
	fsipcbuf.open.req_omode = mode;
  80192b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801933:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801936:	b8 01 00 00 00       	mov    $0x1,%eax
  80193b:	e8 aa fd ff ff       	call   8016ea <fsipc>
  801940:	89 c3                	mov    %eax,%ebx
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	85 c0                	test   %eax,%eax
  801947:	78 19                	js     801962 <open+0x75>
	return fd2num(fd);
  801949:	83 ec 0c             	sub    $0xc,%esp
  80194c:	ff 75 f4             	pushl  -0xc(%ebp)
  80194f:	e8 04 f8 ff ff       	call   801158 <fd2num>
  801954:	89 c3                	mov    %eax,%ebx
  801956:	83 c4 10             	add    $0x10,%esp
}
  801959:	89 d8                	mov    %ebx,%eax
  80195b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195e:	5b                   	pop    %ebx
  80195f:	5e                   	pop    %esi
  801960:	5d                   	pop    %ebp
  801961:	c3                   	ret    
		fd_close(fd, 0);
  801962:	83 ec 08             	sub    $0x8,%esp
  801965:	6a 00                	push   $0x0
  801967:	ff 75 f4             	pushl  -0xc(%ebp)
  80196a:	e8 0b f9 ff ff       	call   80127a <fd_close>
		return r;
  80196f:	83 c4 10             	add    $0x10,%esp
  801972:	eb e5                	jmp    801959 <open+0x6c>
		return -E_BAD_PATH;
  801974:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801979:	eb de                	jmp    801959 <open+0x6c>

0080197b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801981:	ba 00 00 00 00       	mov    $0x0,%edx
  801986:	b8 08 00 00 00       	mov    $0x8,%eax
  80198b:	e8 5a fd ff ff       	call   8016ea <fsipc>
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801992:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801996:	7e 38                	jle    8019d0 <writebuf+0x3e>
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	53                   	push   %ebx
  80199c:	83 ec 08             	sub    $0x8,%esp
  80199f:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8019a1:	ff 70 04             	pushl  0x4(%eax)
  8019a4:	8d 40 10             	lea    0x10(%eax),%eax
  8019a7:	50                   	push   %eax
  8019a8:	ff 33                	pushl  (%ebx)
  8019aa:	e8 5e fb ff ff       	call   80150d <write>
		if (result > 0)
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	7e 03                	jle    8019b9 <writebuf+0x27>
			b->result += result;
  8019b6:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8019b9:	39 43 04             	cmp    %eax,0x4(%ebx)
  8019bc:	74 0d                	je     8019cb <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  8019be:	85 c0                	test   %eax,%eax
  8019c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c5:	0f 4f c2             	cmovg  %edx,%eax
  8019c8:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    
  8019d0:	f3 c3                	repz ret 

008019d2 <putch>:

static void
putch(int ch, void *thunk)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	53                   	push   %ebx
  8019d6:	83 ec 04             	sub    $0x4,%esp
  8019d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019dc:	8b 53 04             	mov    0x4(%ebx),%edx
  8019df:	8d 42 01             	lea    0x1(%edx),%eax
  8019e2:	89 43 04             	mov    %eax,0x4(%ebx)
  8019e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019e8:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019ec:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019f1:	74 06                	je     8019f9 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8019f3:	83 c4 04             	add    $0x4,%esp
  8019f6:	5b                   	pop    %ebx
  8019f7:	5d                   	pop    %ebp
  8019f8:	c3                   	ret    
		writebuf(b);
  8019f9:	89 d8                	mov    %ebx,%eax
  8019fb:	e8 92 ff ff ff       	call   801992 <writebuf>
		b->idx = 0;
  801a00:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801a07:	eb ea                	jmp    8019f3 <putch+0x21>

00801a09 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a1b:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a22:	00 00 00 
	b.result = 0;
  801a25:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a2c:	00 00 00 
	b.error = 1;
  801a2f:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a36:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a39:	ff 75 10             	pushl  0x10(%ebp)
  801a3c:	ff 75 0c             	pushl  0xc(%ebp)
  801a3f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a45:	50                   	push   %eax
  801a46:	68 d2 19 80 00       	push   $0x8019d2
  801a4b:	e8 a8 ea ff ff       	call   8004f8 <vprintfmt>
	if (b.idx > 0)
  801a50:	83 c4 10             	add    $0x10,%esp
  801a53:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a5a:	7f 11                	jg     801a6d <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a5c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a62:	85 c0                	test   %eax,%eax
  801a64:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    
		writebuf(&b);
  801a6d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a73:	e8 1a ff ff ff       	call   801992 <writebuf>
  801a78:	eb e2                	jmp    801a5c <vfprintf+0x53>

00801a7a <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a80:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a83:	50                   	push   %eax
  801a84:	ff 75 0c             	pushl  0xc(%ebp)
  801a87:	ff 75 08             	pushl  0x8(%ebp)
  801a8a:	e8 7a ff ff ff       	call   801a09 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <printf>:

int
printf(const char *fmt, ...)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a97:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a9a:	50                   	push   %eax
  801a9b:	ff 75 08             	pushl  0x8(%ebp)
  801a9e:	6a 01                	push   $0x1
  801aa0:	e8 64 ff ff ff       	call   801a09 <vfprintf>
	va_end(ap);

	return cnt;
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	56                   	push   %esi
  801aab:	53                   	push   %ebx
  801aac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801aaf:	83 ec 0c             	sub    $0xc,%esp
  801ab2:	ff 75 08             	pushl  0x8(%ebp)
  801ab5:	e8 ae f6 ff ff       	call   801168 <fd2data>
  801aba:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801abc:	83 c4 08             	add    $0x8,%esp
  801abf:	68 af 27 80 00       	push   $0x8027af
  801ac4:	53                   	push   %ebx
  801ac5:	e8 50 ef ff ff       	call   800a1a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801aca:	8b 46 04             	mov    0x4(%esi),%eax
  801acd:	2b 06                	sub    (%esi),%eax
  801acf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ad5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801adc:	00 00 00 
	stat->st_dev = &devpipe;
  801adf:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ae6:	30 80 00 
	return 0;
}
  801ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  801aee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af1:	5b                   	pop    %ebx
  801af2:	5e                   	pop    %esi
  801af3:	5d                   	pop    %ebp
  801af4:	c3                   	ret    

00801af5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	53                   	push   %ebx
  801af9:	83 ec 0c             	sub    $0xc,%esp
  801afc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801aff:	53                   	push   %ebx
  801b00:	6a 00                	push   $0x0
  801b02:	e8 91 f3 ff ff       	call   800e98 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b07:	89 1c 24             	mov    %ebx,(%esp)
  801b0a:	e8 59 f6 ff ff       	call   801168 <fd2data>
  801b0f:	83 c4 08             	add    $0x8,%esp
  801b12:	50                   	push   %eax
  801b13:	6a 00                	push   $0x0
  801b15:	e8 7e f3 ff ff       	call   800e98 <sys_page_unmap>
}
  801b1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <_pipeisclosed>:
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	57                   	push   %edi
  801b23:	56                   	push   %esi
  801b24:	53                   	push   %ebx
  801b25:	83 ec 1c             	sub    $0x1c,%esp
  801b28:	89 c7                	mov    %eax,%edi
  801b2a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b2c:	a1 20 44 80 00       	mov    0x804420,%eax
  801b31:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b34:	83 ec 0c             	sub    $0xc,%esp
  801b37:	57                   	push   %edi
  801b38:	e8 2a 05 00 00       	call   802067 <pageref>
  801b3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b40:	89 34 24             	mov    %esi,(%esp)
  801b43:	e8 1f 05 00 00       	call   802067 <pageref>
		nn = thisenv->env_runs;
  801b48:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801b4e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b51:	83 c4 10             	add    $0x10,%esp
  801b54:	39 cb                	cmp    %ecx,%ebx
  801b56:	74 1b                	je     801b73 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b58:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b5b:	75 cf                	jne    801b2c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b5d:	8b 42 58             	mov    0x58(%edx),%eax
  801b60:	6a 01                	push   $0x1
  801b62:	50                   	push   %eax
  801b63:	53                   	push   %ebx
  801b64:	68 b6 27 80 00       	push   $0x8027b6
  801b69:	e8 8d e8 ff ff       	call   8003fb <cprintf>
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	eb b9                	jmp    801b2c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b73:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b76:	0f 94 c0             	sete   %al
  801b79:	0f b6 c0             	movzbl %al,%eax
}
  801b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5f                   	pop    %edi
  801b82:	5d                   	pop    %ebp
  801b83:	c3                   	ret    

00801b84 <devpipe_write>:
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	57                   	push   %edi
  801b88:	56                   	push   %esi
  801b89:	53                   	push   %ebx
  801b8a:	83 ec 28             	sub    $0x28,%esp
  801b8d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b90:	56                   	push   %esi
  801b91:	e8 d2 f5 ff ff       	call   801168 <fd2data>
  801b96:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ba3:	74 4f                	je     801bf4 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ba5:	8b 43 04             	mov    0x4(%ebx),%eax
  801ba8:	8b 0b                	mov    (%ebx),%ecx
  801baa:	8d 51 20             	lea    0x20(%ecx),%edx
  801bad:	39 d0                	cmp    %edx,%eax
  801baf:	72 14                	jb     801bc5 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801bb1:	89 da                	mov    %ebx,%edx
  801bb3:	89 f0                	mov    %esi,%eax
  801bb5:	e8 65 ff ff ff       	call   801b1f <_pipeisclosed>
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	75 3a                	jne    801bf8 <devpipe_write+0x74>
			sys_yield();
  801bbe:	e8 31 f2 ff ff       	call   800df4 <sys_yield>
  801bc3:	eb e0                	jmp    801ba5 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bc8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bcc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bcf:	89 c2                	mov    %eax,%edx
  801bd1:	c1 fa 1f             	sar    $0x1f,%edx
  801bd4:	89 d1                	mov    %edx,%ecx
  801bd6:	c1 e9 1b             	shr    $0x1b,%ecx
  801bd9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bdc:	83 e2 1f             	and    $0x1f,%edx
  801bdf:	29 ca                	sub    %ecx,%edx
  801be1:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801be5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801be9:	83 c0 01             	add    $0x1,%eax
  801bec:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bef:	83 c7 01             	add    $0x1,%edi
  801bf2:	eb ac                	jmp    801ba0 <devpipe_write+0x1c>
	return i;
  801bf4:	89 f8                	mov    %edi,%eax
  801bf6:	eb 05                	jmp    801bfd <devpipe_write+0x79>
				return 0;
  801bf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c00:	5b                   	pop    %ebx
  801c01:	5e                   	pop    %esi
  801c02:	5f                   	pop    %edi
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    

00801c05 <devpipe_read>:
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	57                   	push   %edi
  801c09:	56                   	push   %esi
  801c0a:	53                   	push   %ebx
  801c0b:	83 ec 18             	sub    $0x18,%esp
  801c0e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c11:	57                   	push   %edi
  801c12:	e8 51 f5 ff ff       	call   801168 <fd2data>
  801c17:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c19:	83 c4 10             	add    $0x10,%esp
  801c1c:	be 00 00 00 00       	mov    $0x0,%esi
  801c21:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c24:	74 47                	je     801c6d <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801c26:	8b 03                	mov    (%ebx),%eax
  801c28:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c2b:	75 22                	jne    801c4f <devpipe_read+0x4a>
			if (i > 0)
  801c2d:	85 f6                	test   %esi,%esi
  801c2f:	75 14                	jne    801c45 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c31:	89 da                	mov    %ebx,%edx
  801c33:	89 f8                	mov    %edi,%eax
  801c35:	e8 e5 fe ff ff       	call   801b1f <_pipeisclosed>
  801c3a:	85 c0                	test   %eax,%eax
  801c3c:	75 33                	jne    801c71 <devpipe_read+0x6c>
			sys_yield();
  801c3e:	e8 b1 f1 ff ff       	call   800df4 <sys_yield>
  801c43:	eb e1                	jmp    801c26 <devpipe_read+0x21>
				return i;
  801c45:	89 f0                	mov    %esi,%eax
}
  801c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c4a:	5b                   	pop    %ebx
  801c4b:	5e                   	pop    %esi
  801c4c:	5f                   	pop    %edi
  801c4d:	5d                   	pop    %ebp
  801c4e:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c4f:	99                   	cltd   
  801c50:	c1 ea 1b             	shr    $0x1b,%edx
  801c53:	01 d0                	add    %edx,%eax
  801c55:	83 e0 1f             	and    $0x1f,%eax
  801c58:	29 d0                	sub    %edx,%eax
  801c5a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c62:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c65:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c68:	83 c6 01             	add    $0x1,%esi
  801c6b:	eb b4                	jmp    801c21 <devpipe_read+0x1c>
	return i;
  801c6d:	89 f0                	mov    %esi,%eax
  801c6f:	eb d6                	jmp    801c47 <devpipe_read+0x42>
				return 0;
  801c71:	b8 00 00 00 00       	mov    $0x0,%eax
  801c76:	eb cf                	jmp    801c47 <devpipe_read+0x42>

00801c78 <pipe>:
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	56                   	push   %esi
  801c7c:	53                   	push   %ebx
  801c7d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c80:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c83:	50                   	push   %eax
  801c84:	e8 f6 f4 ff ff       	call   80117f <fd_alloc>
  801c89:	89 c3                	mov    %eax,%ebx
  801c8b:	83 c4 10             	add    $0x10,%esp
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	78 5b                	js     801ced <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c92:	83 ec 04             	sub    $0x4,%esp
  801c95:	68 07 04 00 00       	push   $0x407
  801c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9d:	6a 00                	push   $0x0
  801c9f:	e8 6f f1 ff ff       	call   800e13 <sys_page_alloc>
  801ca4:	89 c3                	mov    %eax,%ebx
  801ca6:	83 c4 10             	add    $0x10,%esp
  801ca9:	85 c0                	test   %eax,%eax
  801cab:	78 40                	js     801ced <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801cad:	83 ec 0c             	sub    $0xc,%esp
  801cb0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cb3:	50                   	push   %eax
  801cb4:	e8 c6 f4 ff ff       	call   80117f <fd_alloc>
  801cb9:	89 c3                	mov    %eax,%ebx
  801cbb:	83 c4 10             	add    $0x10,%esp
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	78 1b                	js     801cdd <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc2:	83 ec 04             	sub    $0x4,%esp
  801cc5:	68 07 04 00 00       	push   $0x407
  801cca:	ff 75 f0             	pushl  -0x10(%ebp)
  801ccd:	6a 00                	push   $0x0
  801ccf:	e8 3f f1 ff ff       	call   800e13 <sys_page_alloc>
  801cd4:	89 c3                	mov    %eax,%ebx
  801cd6:	83 c4 10             	add    $0x10,%esp
  801cd9:	85 c0                	test   %eax,%eax
  801cdb:	79 19                	jns    801cf6 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801cdd:	83 ec 08             	sub    $0x8,%esp
  801ce0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce3:	6a 00                	push   $0x0
  801ce5:	e8 ae f1 ff ff       	call   800e98 <sys_page_unmap>
  801cea:	83 c4 10             	add    $0x10,%esp
}
  801ced:	89 d8                	mov    %ebx,%eax
  801cef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf2:	5b                   	pop    %ebx
  801cf3:	5e                   	pop    %esi
  801cf4:	5d                   	pop    %ebp
  801cf5:	c3                   	ret    
	va = fd2data(fd0);
  801cf6:	83 ec 0c             	sub    $0xc,%esp
  801cf9:	ff 75 f4             	pushl  -0xc(%ebp)
  801cfc:	e8 67 f4 ff ff       	call   801168 <fd2data>
  801d01:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d03:	83 c4 0c             	add    $0xc,%esp
  801d06:	68 07 04 00 00       	push   $0x407
  801d0b:	50                   	push   %eax
  801d0c:	6a 00                	push   $0x0
  801d0e:	e8 00 f1 ff ff       	call   800e13 <sys_page_alloc>
  801d13:	89 c3                	mov    %eax,%ebx
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	0f 88 8c 00 00 00    	js     801dac <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d20:	83 ec 0c             	sub    $0xc,%esp
  801d23:	ff 75 f0             	pushl  -0x10(%ebp)
  801d26:	e8 3d f4 ff ff       	call   801168 <fd2data>
  801d2b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d32:	50                   	push   %eax
  801d33:	6a 00                	push   $0x0
  801d35:	56                   	push   %esi
  801d36:	6a 00                	push   $0x0
  801d38:	e8 19 f1 ff ff       	call   800e56 <sys_page_map>
  801d3d:	89 c3                	mov    %eax,%ebx
  801d3f:	83 c4 20             	add    $0x20,%esp
  801d42:	85 c0                	test   %eax,%eax
  801d44:	78 58                	js     801d9e <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d49:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d4f:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d54:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d64:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d69:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d70:	83 ec 0c             	sub    $0xc,%esp
  801d73:	ff 75 f4             	pushl  -0xc(%ebp)
  801d76:	e8 dd f3 ff ff       	call   801158 <fd2num>
  801d7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d7e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d80:	83 c4 04             	add    $0x4,%esp
  801d83:	ff 75 f0             	pushl  -0x10(%ebp)
  801d86:	e8 cd f3 ff ff       	call   801158 <fd2num>
  801d8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d8e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d91:	83 c4 10             	add    $0x10,%esp
  801d94:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d99:	e9 4f ff ff ff       	jmp    801ced <pipe+0x75>
	sys_page_unmap(0, va);
  801d9e:	83 ec 08             	sub    $0x8,%esp
  801da1:	56                   	push   %esi
  801da2:	6a 00                	push   $0x0
  801da4:	e8 ef f0 ff ff       	call   800e98 <sys_page_unmap>
  801da9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801dac:	83 ec 08             	sub    $0x8,%esp
  801daf:	ff 75 f0             	pushl  -0x10(%ebp)
  801db2:	6a 00                	push   $0x0
  801db4:	e8 df f0 ff ff       	call   800e98 <sys_page_unmap>
  801db9:	83 c4 10             	add    $0x10,%esp
  801dbc:	e9 1c ff ff ff       	jmp    801cdd <pipe+0x65>

00801dc1 <pipeisclosed>:
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dca:	50                   	push   %eax
  801dcb:	ff 75 08             	pushl  0x8(%ebp)
  801dce:	e8 fb f3 ff ff       	call   8011ce <fd_lookup>
  801dd3:	83 c4 10             	add    $0x10,%esp
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	78 18                	js     801df2 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801dda:	83 ec 0c             	sub    $0xc,%esp
  801ddd:	ff 75 f4             	pushl  -0xc(%ebp)
  801de0:	e8 83 f3 ff ff       	call   801168 <fd2data>
	return _pipeisclosed(fd, p);
  801de5:	89 c2                	mov    %eax,%edx
  801de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dea:	e8 30 fd ff ff       	call   801b1f <_pipeisclosed>
  801def:	83 c4 10             	add    $0x10,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfc:	5d                   	pop    %ebp
  801dfd:	c3                   	ret    

00801dfe <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e04:	68 ce 27 80 00       	push   $0x8027ce
  801e09:	ff 75 0c             	pushl  0xc(%ebp)
  801e0c:	e8 09 ec ff ff       	call   800a1a <strcpy>
	return 0;
}
  801e11:	b8 00 00 00 00       	mov    $0x0,%eax
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <devcons_write>:
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	57                   	push   %edi
  801e1c:	56                   	push   %esi
  801e1d:	53                   	push   %ebx
  801e1e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e24:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e29:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e2f:	eb 2f                	jmp    801e60 <devcons_write+0x48>
		m = n - tot;
  801e31:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e34:	29 f3                	sub    %esi,%ebx
  801e36:	83 fb 7f             	cmp    $0x7f,%ebx
  801e39:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e3e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e41:	83 ec 04             	sub    $0x4,%esp
  801e44:	53                   	push   %ebx
  801e45:	89 f0                	mov    %esi,%eax
  801e47:	03 45 0c             	add    0xc(%ebp),%eax
  801e4a:	50                   	push   %eax
  801e4b:	57                   	push   %edi
  801e4c:	e8 57 ed ff ff       	call   800ba8 <memmove>
		sys_cputs(buf, m);
  801e51:	83 c4 08             	add    $0x8,%esp
  801e54:	53                   	push   %ebx
  801e55:	57                   	push   %edi
  801e56:	e8 fc ee ff ff       	call   800d57 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e5b:	01 de                	add    %ebx,%esi
  801e5d:	83 c4 10             	add    $0x10,%esp
  801e60:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e63:	72 cc                	jb     801e31 <devcons_write+0x19>
}
  801e65:	89 f0                	mov    %esi,%eax
  801e67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e6a:	5b                   	pop    %ebx
  801e6b:	5e                   	pop    %esi
  801e6c:	5f                   	pop    %edi
  801e6d:	5d                   	pop    %ebp
  801e6e:	c3                   	ret    

00801e6f <devcons_read>:
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 08             	sub    $0x8,%esp
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e7e:	75 07                	jne    801e87 <devcons_read+0x18>
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    
		sys_yield();
  801e82:	e8 6d ef ff ff       	call   800df4 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e87:	e8 e9 ee ff ff       	call   800d75 <sys_cgetc>
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	74 f2                	je     801e82 <devcons_read+0x13>
	if (c < 0)
  801e90:	85 c0                	test   %eax,%eax
  801e92:	78 ec                	js     801e80 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801e94:	83 f8 04             	cmp    $0x4,%eax
  801e97:	74 0c                	je     801ea5 <devcons_read+0x36>
	*(char*)vbuf = c;
  801e99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9c:	88 02                	mov    %al,(%edx)
	return 1;
  801e9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea3:	eb db                	jmp    801e80 <devcons_read+0x11>
		return 0;
  801ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eaa:	eb d4                	jmp    801e80 <devcons_read+0x11>

00801eac <cputchar>:
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801eb8:	6a 01                	push   $0x1
  801eba:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ebd:	50                   	push   %eax
  801ebe:	e8 94 ee ff ff       	call   800d57 <sys_cputs>
}
  801ec3:	83 c4 10             	add    $0x10,%esp
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <getchar>:
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ece:	6a 01                	push   $0x1
  801ed0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ed3:	50                   	push   %eax
  801ed4:	6a 00                	push   $0x0
  801ed6:	e8 64 f5 ff ff       	call   80143f <read>
	if (r < 0)
  801edb:	83 c4 10             	add    $0x10,%esp
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	78 08                	js     801eea <getchar+0x22>
	if (r < 1)
  801ee2:	85 c0                	test   %eax,%eax
  801ee4:	7e 06                	jle    801eec <getchar+0x24>
	return c;
  801ee6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    
		return -E_EOF;
  801eec:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ef1:	eb f7                	jmp    801eea <getchar+0x22>

00801ef3 <iscons>:
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ef9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801efc:	50                   	push   %eax
  801efd:	ff 75 08             	pushl  0x8(%ebp)
  801f00:	e8 c9 f2 ff ff       	call   8011ce <fd_lookup>
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	78 11                	js     801f1d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f15:	39 10                	cmp    %edx,(%eax)
  801f17:	0f 94 c0             	sete   %al
  801f1a:	0f b6 c0             	movzbl %al,%eax
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <opencons>:
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f28:	50                   	push   %eax
  801f29:	e8 51 f2 ff ff       	call   80117f <fd_alloc>
  801f2e:	83 c4 10             	add    $0x10,%esp
  801f31:	85 c0                	test   %eax,%eax
  801f33:	78 3a                	js     801f6f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f35:	83 ec 04             	sub    $0x4,%esp
  801f38:	68 07 04 00 00       	push   $0x407
  801f3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f40:	6a 00                	push   $0x0
  801f42:	e8 cc ee ff ff       	call   800e13 <sys_page_alloc>
  801f47:	83 c4 10             	add    $0x10,%esp
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	78 21                	js     801f6f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f51:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f57:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f63:	83 ec 0c             	sub    $0xc,%esp
  801f66:	50                   	push   %eax
  801f67:	e8 ec f1 ff ff       	call   801158 <fd2num>
  801f6c:	83 c4 10             	add    $0x10,%esp
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	56                   	push   %esi
  801f75:	53                   	push   %ebx
  801f76:	8b 75 08             	mov    0x8(%ebp),%esi
  801f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801f7f:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  801f81:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801f86:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  801f89:	83 ec 0c             	sub    $0xc,%esp
  801f8c:	50                   	push   %eax
  801f8d:	e8 31 f0 ff ff       	call   800fc3 <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  801f92:	83 c4 10             	add    $0x10,%esp
  801f95:	85 c0                	test   %eax,%eax
  801f97:	78 2b                	js     801fc4 <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  801f99:	85 f6                	test   %esi,%esi
  801f9b:	74 0a                	je     801fa7 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801f9d:	a1 20 44 80 00       	mov    0x804420,%eax
  801fa2:	8b 40 74             	mov    0x74(%eax),%eax
  801fa5:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  801fa7:	85 db                	test   %ebx,%ebx
  801fa9:	74 0a                	je     801fb5 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801fab:	a1 20 44 80 00       	mov    0x804420,%eax
  801fb0:	8b 40 78             	mov    0x78(%eax),%eax
  801fb3:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801fb5:	a1 20 44 80 00       	mov    0x804420,%eax
  801fba:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc0:	5b                   	pop    %ebx
  801fc1:	5e                   	pop    %esi
  801fc2:	5d                   	pop    %ebp
  801fc3:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  801fc4:	85 f6                	test   %esi,%esi
  801fc6:	74 06                	je     801fce <ipc_recv+0x5d>
  801fc8:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801fce:	85 db                	test   %ebx,%ebx
  801fd0:	74 eb                	je     801fbd <ipc_recv+0x4c>
  801fd2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801fd8:	eb e3                	jmp    801fbd <ipc_recv+0x4c>

00801fda <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	57                   	push   %edi
  801fde:	56                   	push   %esi
  801fdf:	53                   	push   %ebx
  801fe0:	83 ec 0c             	sub    $0xc,%esp
  801fe3:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fe6:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fe9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  801fec:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  801fee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801ff3:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801ff6:	ff 75 14             	pushl  0x14(%ebp)
  801ff9:	53                   	push   %ebx
  801ffa:	56                   	push   %esi
  801ffb:	57                   	push   %edi
  801ffc:	e8 9f ef ff ff       	call   800fa0 <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	85 c0                	test   %eax,%eax
  802006:	74 1e                	je     802026 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  802008:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80200b:	75 07                	jne    802014 <ipc_send+0x3a>
			sys_yield();
  80200d:	e8 e2 ed ff ff       	call   800df4 <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  802012:	eb e2                	jmp    801ff6 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  802014:	50                   	push   %eax
  802015:	68 da 27 80 00       	push   $0x8027da
  80201a:	6a 41                	push   $0x41
  80201c:	68 e8 27 80 00       	push   $0x8027e8
  802021:	e8 fa e2 ff ff       	call   800320 <_panic>
		}
	}
}
  802026:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802029:	5b                   	pop    %ebx
  80202a:	5e                   	pop    %esi
  80202b:	5f                   	pop    %edi
  80202c:	5d                   	pop    %ebp
  80202d:	c3                   	ret    

0080202e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802034:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802039:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80203c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802042:	8b 52 50             	mov    0x50(%edx),%edx
  802045:	39 ca                	cmp    %ecx,%edx
  802047:	74 11                	je     80205a <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802049:	83 c0 01             	add    $0x1,%eax
  80204c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802051:	75 e6                	jne    802039 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802053:	b8 00 00 00 00       	mov    $0x0,%eax
  802058:	eb 0b                	jmp    802065 <ipc_find_env+0x37>
			return envs[i].env_id;
  80205a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80205d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802062:	8b 40 48             	mov    0x48(%eax),%eax
}
  802065:	5d                   	pop    %ebp
  802066:	c3                   	ret    

00802067 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80206d:	89 d0                	mov    %edx,%eax
  80206f:	c1 e8 16             	shr    $0x16,%eax
  802072:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802079:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80207e:	f6 c1 01             	test   $0x1,%cl
  802081:	74 1d                	je     8020a0 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802083:	c1 ea 0c             	shr    $0xc,%edx
  802086:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80208d:	f6 c2 01             	test   $0x1,%dl
  802090:	74 0e                	je     8020a0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802092:	c1 ea 0c             	shr    $0xc,%edx
  802095:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80209c:	ef 
  80209d:	0f b7 c0             	movzwl %ax,%eax
}
  8020a0:	5d                   	pop    %ebp
  8020a1:	c3                   	ret    
  8020a2:	66 90                	xchg   %ax,%ax
  8020a4:	66 90                	xchg   %ax,%ax
  8020a6:	66 90                	xchg   %ax,%ax
  8020a8:	66 90                	xchg   %ax,%ax
  8020aa:	66 90                	xchg   %ax,%ax
  8020ac:	66 90                	xchg   %ax,%ax
  8020ae:	66 90                	xchg   %ax,%ax

008020b0 <__udivdi3>:
  8020b0:	55                   	push   %ebp
  8020b1:	57                   	push   %edi
  8020b2:	56                   	push   %esi
  8020b3:	53                   	push   %ebx
  8020b4:	83 ec 1c             	sub    $0x1c,%esp
  8020b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020c7:	85 d2                	test   %edx,%edx
  8020c9:	75 35                	jne    802100 <__udivdi3+0x50>
  8020cb:	39 f3                	cmp    %esi,%ebx
  8020cd:	0f 87 bd 00 00 00    	ja     802190 <__udivdi3+0xe0>
  8020d3:	85 db                	test   %ebx,%ebx
  8020d5:	89 d9                	mov    %ebx,%ecx
  8020d7:	75 0b                	jne    8020e4 <__udivdi3+0x34>
  8020d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020de:	31 d2                	xor    %edx,%edx
  8020e0:	f7 f3                	div    %ebx
  8020e2:	89 c1                	mov    %eax,%ecx
  8020e4:	31 d2                	xor    %edx,%edx
  8020e6:	89 f0                	mov    %esi,%eax
  8020e8:	f7 f1                	div    %ecx
  8020ea:	89 c6                	mov    %eax,%esi
  8020ec:	89 e8                	mov    %ebp,%eax
  8020ee:	89 f7                	mov    %esi,%edi
  8020f0:	f7 f1                	div    %ecx
  8020f2:	89 fa                	mov    %edi,%edx
  8020f4:	83 c4 1c             	add    $0x1c,%esp
  8020f7:	5b                   	pop    %ebx
  8020f8:	5e                   	pop    %esi
  8020f9:	5f                   	pop    %edi
  8020fa:	5d                   	pop    %ebp
  8020fb:	c3                   	ret    
  8020fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802100:	39 f2                	cmp    %esi,%edx
  802102:	77 7c                	ja     802180 <__udivdi3+0xd0>
  802104:	0f bd fa             	bsr    %edx,%edi
  802107:	83 f7 1f             	xor    $0x1f,%edi
  80210a:	0f 84 98 00 00 00    	je     8021a8 <__udivdi3+0xf8>
  802110:	89 f9                	mov    %edi,%ecx
  802112:	b8 20 00 00 00       	mov    $0x20,%eax
  802117:	29 f8                	sub    %edi,%eax
  802119:	d3 e2                	shl    %cl,%edx
  80211b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80211f:	89 c1                	mov    %eax,%ecx
  802121:	89 da                	mov    %ebx,%edx
  802123:	d3 ea                	shr    %cl,%edx
  802125:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802129:	09 d1                	or     %edx,%ecx
  80212b:	89 f2                	mov    %esi,%edx
  80212d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802131:	89 f9                	mov    %edi,%ecx
  802133:	d3 e3                	shl    %cl,%ebx
  802135:	89 c1                	mov    %eax,%ecx
  802137:	d3 ea                	shr    %cl,%edx
  802139:	89 f9                	mov    %edi,%ecx
  80213b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80213f:	d3 e6                	shl    %cl,%esi
  802141:	89 eb                	mov    %ebp,%ebx
  802143:	89 c1                	mov    %eax,%ecx
  802145:	d3 eb                	shr    %cl,%ebx
  802147:	09 de                	or     %ebx,%esi
  802149:	89 f0                	mov    %esi,%eax
  80214b:	f7 74 24 08          	divl   0x8(%esp)
  80214f:	89 d6                	mov    %edx,%esi
  802151:	89 c3                	mov    %eax,%ebx
  802153:	f7 64 24 0c          	mull   0xc(%esp)
  802157:	39 d6                	cmp    %edx,%esi
  802159:	72 0c                	jb     802167 <__udivdi3+0xb7>
  80215b:	89 f9                	mov    %edi,%ecx
  80215d:	d3 e5                	shl    %cl,%ebp
  80215f:	39 c5                	cmp    %eax,%ebp
  802161:	73 5d                	jae    8021c0 <__udivdi3+0x110>
  802163:	39 d6                	cmp    %edx,%esi
  802165:	75 59                	jne    8021c0 <__udivdi3+0x110>
  802167:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80216a:	31 ff                	xor    %edi,%edi
  80216c:	89 fa                	mov    %edi,%edx
  80216e:	83 c4 1c             	add    $0x1c,%esp
  802171:	5b                   	pop    %ebx
  802172:	5e                   	pop    %esi
  802173:	5f                   	pop    %edi
  802174:	5d                   	pop    %ebp
  802175:	c3                   	ret    
  802176:	8d 76 00             	lea    0x0(%esi),%esi
  802179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802180:	31 ff                	xor    %edi,%edi
  802182:	31 c0                	xor    %eax,%eax
  802184:	89 fa                	mov    %edi,%edx
  802186:	83 c4 1c             	add    $0x1c,%esp
  802189:	5b                   	pop    %ebx
  80218a:	5e                   	pop    %esi
  80218b:	5f                   	pop    %edi
  80218c:	5d                   	pop    %ebp
  80218d:	c3                   	ret    
  80218e:	66 90                	xchg   %ax,%ax
  802190:	31 ff                	xor    %edi,%edi
  802192:	89 e8                	mov    %ebp,%eax
  802194:	89 f2                	mov    %esi,%edx
  802196:	f7 f3                	div    %ebx
  802198:	89 fa                	mov    %edi,%edx
  80219a:	83 c4 1c             	add    $0x1c,%esp
  80219d:	5b                   	pop    %ebx
  80219e:	5e                   	pop    %esi
  80219f:	5f                   	pop    %edi
  8021a0:	5d                   	pop    %ebp
  8021a1:	c3                   	ret    
  8021a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021a8:	39 f2                	cmp    %esi,%edx
  8021aa:	72 06                	jb     8021b2 <__udivdi3+0x102>
  8021ac:	31 c0                	xor    %eax,%eax
  8021ae:	39 eb                	cmp    %ebp,%ebx
  8021b0:	77 d2                	ja     802184 <__udivdi3+0xd4>
  8021b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b7:	eb cb                	jmp    802184 <__udivdi3+0xd4>
  8021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021c0:	89 d8                	mov    %ebx,%eax
  8021c2:	31 ff                	xor    %edi,%edi
  8021c4:	eb be                	jmp    802184 <__udivdi3+0xd4>
  8021c6:	66 90                	xchg   %ax,%ax
  8021c8:	66 90                	xchg   %ax,%ax
  8021ca:	66 90                	xchg   %ax,%ax
  8021cc:	66 90                	xchg   %ax,%ax
  8021ce:	66 90                	xchg   %ax,%ax

008021d0 <__umoddi3>:
  8021d0:	55                   	push   %ebp
  8021d1:	57                   	push   %edi
  8021d2:	56                   	push   %esi
  8021d3:	53                   	push   %ebx
  8021d4:	83 ec 1c             	sub    $0x1c,%esp
  8021d7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8021db:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021df:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021e7:	85 ed                	test   %ebp,%ebp
  8021e9:	89 f0                	mov    %esi,%eax
  8021eb:	89 da                	mov    %ebx,%edx
  8021ed:	75 19                	jne    802208 <__umoddi3+0x38>
  8021ef:	39 df                	cmp    %ebx,%edi
  8021f1:	0f 86 b1 00 00 00    	jbe    8022a8 <__umoddi3+0xd8>
  8021f7:	f7 f7                	div    %edi
  8021f9:	89 d0                	mov    %edx,%eax
  8021fb:	31 d2                	xor    %edx,%edx
  8021fd:	83 c4 1c             	add    $0x1c,%esp
  802200:	5b                   	pop    %ebx
  802201:	5e                   	pop    %esi
  802202:	5f                   	pop    %edi
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    
  802205:	8d 76 00             	lea    0x0(%esi),%esi
  802208:	39 dd                	cmp    %ebx,%ebp
  80220a:	77 f1                	ja     8021fd <__umoddi3+0x2d>
  80220c:	0f bd cd             	bsr    %ebp,%ecx
  80220f:	83 f1 1f             	xor    $0x1f,%ecx
  802212:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802216:	0f 84 b4 00 00 00    	je     8022d0 <__umoddi3+0x100>
  80221c:	b8 20 00 00 00       	mov    $0x20,%eax
  802221:	89 c2                	mov    %eax,%edx
  802223:	8b 44 24 04          	mov    0x4(%esp),%eax
  802227:	29 c2                	sub    %eax,%edx
  802229:	89 c1                	mov    %eax,%ecx
  80222b:	89 f8                	mov    %edi,%eax
  80222d:	d3 e5                	shl    %cl,%ebp
  80222f:	89 d1                	mov    %edx,%ecx
  802231:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802235:	d3 e8                	shr    %cl,%eax
  802237:	09 c5                	or     %eax,%ebp
  802239:	8b 44 24 04          	mov    0x4(%esp),%eax
  80223d:	89 c1                	mov    %eax,%ecx
  80223f:	d3 e7                	shl    %cl,%edi
  802241:	89 d1                	mov    %edx,%ecx
  802243:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802247:	89 df                	mov    %ebx,%edi
  802249:	d3 ef                	shr    %cl,%edi
  80224b:	89 c1                	mov    %eax,%ecx
  80224d:	89 f0                	mov    %esi,%eax
  80224f:	d3 e3                	shl    %cl,%ebx
  802251:	89 d1                	mov    %edx,%ecx
  802253:	89 fa                	mov    %edi,%edx
  802255:	d3 e8                	shr    %cl,%eax
  802257:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80225c:	09 d8                	or     %ebx,%eax
  80225e:	f7 f5                	div    %ebp
  802260:	d3 e6                	shl    %cl,%esi
  802262:	89 d1                	mov    %edx,%ecx
  802264:	f7 64 24 08          	mull   0x8(%esp)
  802268:	39 d1                	cmp    %edx,%ecx
  80226a:	89 c3                	mov    %eax,%ebx
  80226c:	89 d7                	mov    %edx,%edi
  80226e:	72 06                	jb     802276 <__umoddi3+0xa6>
  802270:	75 0e                	jne    802280 <__umoddi3+0xb0>
  802272:	39 c6                	cmp    %eax,%esi
  802274:	73 0a                	jae    802280 <__umoddi3+0xb0>
  802276:	2b 44 24 08          	sub    0x8(%esp),%eax
  80227a:	19 ea                	sbb    %ebp,%edx
  80227c:	89 d7                	mov    %edx,%edi
  80227e:	89 c3                	mov    %eax,%ebx
  802280:	89 ca                	mov    %ecx,%edx
  802282:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802287:	29 de                	sub    %ebx,%esi
  802289:	19 fa                	sbb    %edi,%edx
  80228b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80228f:	89 d0                	mov    %edx,%eax
  802291:	d3 e0                	shl    %cl,%eax
  802293:	89 d9                	mov    %ebx,%ecx
  802295:	d3 ee                	shr    %cl,%esi
  802297:	d3 ea                	shr    %cl,%edx
  802299:	09 f0                	or     %esi,%eax
  80229b:	83 c4 1c             	add    $0x1c,%esp
  80229e:	5b                   	pop    %ebx
  80229f:	5e                   	pop    %esi
  8022a0:	5f                   	pop    %edi
  8022a1:	5d                   	pop    %ebp
  8022a2:	c3                   	ret    
  8022a3:	90                   	nop
  8022a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022a8:	85 ff                	test   %edi,%edi
  8022aa:	89 f9                	mov    %edi,%ecx
  8022ac:	75 0b                	jne    8022b9 <__umoddi3+0xe9>
  8022ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b3:	31 d2                	xor    %edx,%edx
  8022b5:	f7 f7                	div    %edi
  8022b7:	89 c1                	mov    %eax,%ecx
  8022b9:	89 d8                	mov    %ebx,%eax
  8022bb:	31 d2                	xor    %edx,%edx
  8022bd:	f7 f1                	div    %ecx
  8022bf:	89 f0                	mov    %esi,%eax
  8022c1:	f7 f1                	div    %ecx
  8022c3:	e9 31 ff ff ff       	jmp    8021f9 <__umoddi3+0x29>
  8022c8:	90                   	nop
  8022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022d0:	39 dd                	cmp    %ebx,%ebp
  8022d2:	72 08                	jb     8022dc <__umoddi3+0x10c>
  8022d4:	39 f7                	cmp    %esi,%edi
  8022d6:	0f 87 21 ff ff ff    	ja     8021fd <__umoddi3+0x2d>
  8022dc:	89 da                	mov    %ebx,%edx
  8022de:	89 f0                	mov    %esi,%eax
  8022e0:	29 f8                	sub    %edi,%eax
  8022e2:	19 ea                	sbb    %ebp,%edx
  8022e4:	e9 14 ff ff ff       	jmp    8021fd <__umoddi3+0x2d>
