
obj/user/testfile.debug：     文件格式 elf32-i386


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
  80002c:	e8 54 06 00 00       	call   800685 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	50                   	push   %eax
  80003d:	68 00 50 80 00       	push   $0x805000
  800042:	e8 90 0d 00 00       	call   800dd7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 54 80 00    	mov    %ebx,0x805400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 25 14 00 00       	call   80147e <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 50 80 00       	push   $0x805000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 c2 13 00 00       	call   80142a <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 48 13 00 00       	call   8013c1 <ipc_recv>
}
  800079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007c:	c9                   	leave  
  80007d:	c3                   	ret    

0080007e <umain>:

void
umain(int argc, char **argv)
{
  80007e:	55                   	push   %ebp
  80007f:	89 e5                	mov    %esp,%ebp
  800081:	57                   	push   %edi
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80008a:	ba 00 00 00 00       	mov    $0x0,%edx
  80008f:	b8 40 24 80 00       	mov    $0x802440,%eax
  800094:	e8 9a ff ff ff       	call   800033 <xopen>
  800099:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80009c:	74 08                	je     8000a6 <umain+0x28>
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	0f 88 e9 03 00 00    	js     80048f <umain+0x411>
		panic("serve_open /not-found: %e", r);
	else if (r >= 0)
  8000a6:	85 c0                	test   %eax,%eax
  8000a8:	0f 89 f3 03 00 00    	jns    8004a1 <umain+0x423>
		panic("serve_open /not-found succeeded!");

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  8000ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b3:	b8 75 24 80 00       	mov    $0x802475,%eax
  8000b8:	e8 76 ff ff ff       	call   800033 <xopen>
  8000bd:	85 c0                	test   %eax,%eax
  8000bf:	0f 88 f0 03 00 00    	js     8004b5 <umain+0x437>
		panic("serve_open /newmotd: %e", r);
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8000c5:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  8000cc:	0f 85 f5 03 00 00    	jne    8004c7 <umain+0x449>
  8000d2:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  8000d9:	0f 85 e8 03 00 00    	jne    8004c7 <umain+0x449>
  8000df:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  8000e6:	0f 85 db 03 00 00    	jne    8004c7 <umain+0x449>
		panic("serve_open did not fill struct Fd correctly\n");
	cprintf("serve_open is good\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 96 24 80 00       	push   $0x802496
  8000f4:	e8 bf 06 00 00       	call   8007b8 <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  8000f9:	83 c4 08             	add    $0x8,%esp
  8000fc:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800102:	50                   	push   %eax
  800103:	68 00 c0 cc cc       	push   $0xccccc000
  800108:	ff 15 1c 30 80 00    	call   *0x80301c
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	0f 88 c2 03 00 00    	js     8004db <umain+0x45d>
		panic("file_stat: %e", r);
	if (strlen(msg) != st.st_size)
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 35 00 30 80 00    	pushl  0x803000
  800122:	e8 79 0c 00 00       	call   800da0 <strlen>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80012d:	0f 85 ba 03 00 00    	jne    8004ed <umain+0x46f>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 b8 24 80 00       	push   $0x8024b8
  80013b:	e8 78 06 00 00       	call   8007b8 <cprintf>

	memset(buf, 0, sizeof buf);
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	68 00 02 00 00       	push   $0x200
  800148:	6a 00                	push   $0x0
  80014a:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800150:	53                   	push   %ebx
  800151:	e8 c2 0d 00 00       	call   800f18 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800156:	83 c4 0c             	add    $0xc,%esp
  800159:	68 00 02 00 00       	push   $0x200
  80015e:	53                   	push   %ebx
  80015f:	68 00 c0 cc cc       	push   $0xccccc000
  800164:	ff 15 10 30 80 00    	call   *0x803010
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	85 c0                	test   %eax,%eax
  80016f:	0f 88 9d 03 00 00    	js     800512 <umain+0x494>
		panic("file_read: %e", r);
	if (strcmp(buf, msg) != 0)
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 35 00 30 80 00    	pushl  0x803000
  80017e:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	e8 f3 0c 00 00       	call   800e7d <strcmp>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	85 c0                	test   %eax,%eax
  80018f:	0f 85 8f 03 00 00    	jne    800524 <umain+0x4a6>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 f7 24 80 00       	push   $0x8024f7
  80019d:	e8 16 06 00 00       	call   8007b8 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a2:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001a9:	ff 15 18 30 80 00    	call   *0x803018
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	0f 88 7e 03 00 00    	js     800538 <umain+0x4ba>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 19 25 80 00       	push   $0x802519
  8001c2:	e8 f1 05 00 00       	call   8007b8 <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8001c7:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001cf:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8001d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001d7:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8001dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001df:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8001e7:	83 c4 08             	add    $0x8,%esp
  8001ea:	68 00 c0 cc cc       	push   $0xccccc000
  8001ef:	6a 00                	push   $0x0
  8001f1:	e8 5f 10 00 00       	call   801255 <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	68 00 02 00 00       	push   $0x200
  8001fe:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800208:	50                   	push   %eax
  800209:	ff 15 10 30 80 00    	call   *0x803010
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800215:	0f 85 2f 03 00 00    	jne    80054a <umain+0x4cc>
		panic("serve_read does not handle stale fileids correctly: %e", r);
	cprintf("stale fileid is good\n");
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	68 2d 25 80 00       	push   $0x80252d
  800223:	e8 90 05 00 00       	call   8007b8 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800228:	ba 02 01 00 00       	mov    $0x102,%edx
  80022d:	b8 43 25 80 00       	mov    $0x802543,%eax
  800232:	e8 fc fd ff ff       	call   800033 <xopen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	85 c0                	test   %eax,%eax
  80023c:	0f 88 1a 03 00 00    	js     80055c <umain+0x4de>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800242:	8b 1d 14 30 80 00    	mov    0x803014,%ebx
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 35 00 30 80 00    	pushl  0x803000
  800251:	e8 4a 0b 00 00       	call   800da0 <strlen>
  800256:	83 c4 0c             	add    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	ff 35 00 30 80 00    	pushl  0x803000
  800260:	68 00 c0 cc cc       	push   $0xccccc000
  800265:	ff d3                	call   *%ebx
  800267:	89 c3                	mov    %eax,%ebx
  800269:	83 c4 04             	add    $0x4,%esp
  80026c:	ff 35 00 30 80 00    	pushl  0x803000
  800272:	e8 29 0b 00 00       	call   800da0 <strlen>
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	39 d8                	cmp    %ebx,%eax
  80027c:	0f 85 ec 02 00 00    	jne    80056e <umain+0x4f0>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	68 75 25 80 00       	push   $0x802575
  80028a:	e8 29 05 00 00       	call   8007b8 <cprintf>

	FVA->fd_offset = 0;
  80028f:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800296:	00 00 00 
	memset(buf, 0, sizeof buf);
  800299:	83 c4 0c             	add    $0xc,%esp
  80029c:	68 00 02 00 00       	push   $0x200
  8002a1:	6a 00                	push   $0x0
  8002a3:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002a9:	53                   	push   %ebx
  8002aa:	e8 69 0c 00 00       	call   800f18 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8002af:	83 c4 0c             	add    $0xc,%esp
  8002b2:	68 00 02 00 00       	push   $0x200
  8002b7:	53                   	push   %ebx
  8002b8:	68 00 c0 cc cc       	push   $0xccccc000
  8002bd:	ff 15 10 30 80 00    	call   *0x803010
  8002c3:	89 c3                	mov    %eax,%ebx
  8002c5:	83 c4 10             	add    $0x10,%esp
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	0f 88 b0 02 00 00    	js     800580 <umain+0x502>
		panic("file_read after file_write: %e", r);
	if (r != strlen(msg))
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 35 00 30 80 00    	pushl  0x803000
  8002d9:	e8 c2 0a 00 00       	call   800da0 <strlen>
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	39 d8                	cmp    %ebx,%eax
  8002e3:	0f 85 a9 02 00 00    	jne    800592 <umain+0x514>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	ff 35 00 30 80 00    	pushl  0x803000
  8002f2:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8002f8:	50                   	push   %eax
  8002f9:	e8 7f 0b 00 00       	call   800e7d <strcmp>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	85 c0                	test   %eax,%eax
  800303:	0f 85 9b 02 00 00    	jne    8005a4 <umain+0x526>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	68 3c 27 80 00       	push   $0x80273c
  800311:	e8 a2 04 00 00       	call   8007b8 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800316:	83 c4 08             	add    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 40 24 80 00       	push   $0x802440
  800320:	e8 27 19 00 00       	call   801c4c <open>
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80032b:	74 08                	je     800335 <umain+0x2b7>
  80032d:	85 c0                	test   %eax,%eax
  80032f:	0f 88 83 02 00 00    	js     8005b8 <umain+0x53a>
		panic("open /not-found: %e", r);
	else if (r >= 0)
  800335:	85 c0                	test   %eax,%eax
  800337:	0f 89 8d 02 00 00    	jns    8005ca <umain+0x54c>
		panic("open /not-found succeeded!");

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	6a 00                	push   $0x0
  800342:	68 75 24 80 00       	push   $0x802475
  800347:	e8 00 19 00 00       	call   801c4c <open>
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	85 c0                	test   %eax,%eax
  800351:	0f 88 87 02 00 00    	js     8005de <umain+0x560>
		panic("open /newmotd: %e", r);
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800357:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80035a:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800361:	0f 85 89 02 00 00    	jne    8005f0 <umain+0x572>
  800367:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  80036e:	0f 85 7c 02 00 00    	jne    8005f0 <umain+0x572>
  800374:	8b 98 08 00 00 d0    	mov    -0x2ffffff8(%eax),%ebx
  80037a:	85 db                	test   %ebx,%ebx
  80037c:	0f 85 6e 02 00 00    	jne    8005f0 <umain+0x572>
		panic("open did not fill struct Fd correctly\n");
	cprintf("open is good\n");
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	68 9c 24 80 00       	push   $0x80249c
  80038a:	e8 29 04 00 00       	call   8007b8 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	68 01 01 00 00       	push   $0x101
  800397:	68 a4 25 80 00       	push   $0x8025a4
  80039c:	e8 ab 18 00 00       	call   801c4c <open>
  8003a1:	89 c7                	mov    %eax,%edi
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	85 c0                	test   %eax,%eax
  8003a8:	0f 88 56 02 00 00    	js     800604 <umain+0x586>
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
  8003ae:	83 ec 04             	sub    $0x4,%esp
  8003b1:	68 00 02 00 00       	push   $0x200
  8003b6:	6a 00                	push   $0x0
  8003b8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003be:	50                   	push   %eax
  8003bf:	e8 54 0b 00 00       	call   800f18 <memset>
  8003c4:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003c7:	89 de                	mov    %ebx,%esi
		*(int*)buf = i;
  8003c9:	89 b5 4c fd ff ff    	mov    %esi,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 00 02 00 00       	push   $0x200
  8003d7:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003dd:	50                   	push   %eax
  8003de:	57                   	push   %edi
  8003df:	e8 88 14 00 00       	call   80186c <write>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	85 c0                	test   %eax,%eax
  8003e9:	0f 88 27 02 00 00    	js     800616 <umain+0x598>
  8003ef:	81 c6 00 02 00 00    	add    $0x200,%esi
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003f5:	81 fe 00 e0 01 00    	cmp    $0x1e000,%esi
  8003fb:	75 cc                	jne    8003c9 <umain+0x34b>
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  8003fd:	83 ec 0c             	sub    $0xc,%esp
  800400:	57                   	push   %edi
  800401:	e8 5c 12 00 00       	call   801662 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  800406:	83 c4 08             	add    $0x8,%esp
  800409:	6a 00                	push   $0x0
  80040b:	68 a4 25 80 00       	push   $0x8025a4
  800410:	e8 37 18 00 00       	call   801c4c <open>
  800415:	89 c6                	mov    %eax,%esi
  800417:	83 c4 10             	add    $0x10,%esp
  80041a:	85 c0                	test   %eax,%eax
  80041c:	0f 88 0a 02 00 00    	js     80062c <umain+0x5ae>
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800422:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
		*(int*)buf = i;
  800428:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	68 00 02 00 00       	push   $0x200
  800436:	57                   	push   %edi
  800437:	56                   	push   %esi
  800438:	e8 e8 13 00 00       	call   801825 <readn>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	85 c0                	test   %eax,%eax
  800442:	0f 88 f6 01 00 00    	js     80063e <umain+0x5c0>
			panic("read /big@%d: %e", i, r);
		if (r != sizeof(buf))
  800448:	3d 00 02 00 00       	cmp    $0x200,%eax
  80044d:	0f 85 01 02 00 00    	jne    800654 <umain+0x5d6>
			panic("read /big from %d returned %d < %d bytes",
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800453:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  800459:	39 d8                	cmp    %ebx,%eax
  80045b:	0f 85 0e 02 00 00    	jne    80066f <umain+0x5f1>
  800461:	81 c3 00 02 00 00    	add    $0x200,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800467:	81 fb 00 e0 01 00    	cmp    $0x1e000,%ebx
  80046d:	75 b9                	jne    800428 <umain+0x3aa>
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  80046f:	83 ec 0c             	sub    $0xc,%esp
  800472:	56                   	push   %esi
  800473:	e8 ea 11 00 00       	call   801662 <close>
	cprintf("large file is good\n");
  800478:	c7 04 24 e9 25 80 00 	movl   $0x8025e9,(%esp)
  80047f:	e8 34 03 00 00       	call   8007b8 <cprintf>
}
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80048a:	5b                   	pop    %ebx
  80048b:	5e                   	pop    %esi
  80048c:	5f                   	pop    %edi
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    
		panic("serve_open /not-found: %e", r);
  80048f:	50                   	push   %eax
  800490:	68 4b 24 80 00       	push   $0x80244b
  800495:	6a 20                	push   $0x20
  800497:	68 65 24 80 00       	push   $0x802465
  80049c:	e8 3c 02 00 00       	call   8006dd <_panic>
		panic("serve_open /not-found succeeded!");
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	68 00 26 80 00       	push   $0x802600
  8004a9:	6a 22                	push   $0x22
  8004ab:	68 65 24 80 00       	push   $0x802465
  8004b0:	e8 28 02 00 00       	call   8006dd <_panic>
		panic("serve_open /newmotd: %e", r);
  8004b5:	50                   	push   %eax
  8004b6:	68 7e 24 80 00       	push   $0x80247e
  8004bb:	6a 25                	push   $0x25
  8004bd:	68 65 24 80 00       	push   $0x802465
  8004c2:	e8 16 02 00 00       	call   8006dd <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004c7:	83 ec 04             	sub    $0x4,%esp
  8004ca:	68 24 26 80 00       	push   $0x802624
  8004cf:	6a 27                	push   $0x27
  8004d1:	68 65 24 80 00       	push   $0x802465
  8004d6:	e8 02 02 00 00       	call   8006dd <_panic>
		panic("file_stat: %e", r);
  8004db:	50                   	push   %eax
  8004dc:	68 aa 24 80 00       	push   $0x8024aa
  8004e1:	6a 2b                	push   $0x2b
  8004e3:	68 65 24 80 00       	push   $0x802465
  8004e8:	e8 f0 01 00 00       	call   8006dd <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8004ed:	83 ec 0c             	sub    $0xc,%esp
  8004f0:	ff 35 00 30 80 00    	pushl  0x803000
  8004f6:	e8 a5 08 00 00       	call   800da0 <strlen>
  8004fb:	89 04 24             	mov    %eax,(%esp)
  8004fe:	ff 75 cc             	pushl  -0x34(%ebp)
  800501:	68 54 26 80 00       	push   $0x802654
  800506:	6a 2d                	push   $0x2d
  800508:	68 65 24 80 00       	push   $0x802465
  80050d:	e8 cb 01 00 00       	call   8006dd <_panic>
		panic("file_read: %e", r);
  800512:	50                   	push   %eax
  800513:	68 cb 24 80 00       	push   $0x8024cb
  800518:	6a 32                	push   $0x32
  80051a:	68 65 24 80 00       	push   $0x802465
  80051f:	e8 b9 01 00 00       	call   8006dd <_panic>
		panic("file_read returned wrong data");
  800524:	83 ec 04             	sub    $0x4,%esp
  800527:	68 d9 24 80 00       	push   $0x8024d9
  80052c:	6a 34                	push   $0x34
  80052e:	68 65 24 80 00       	push   $0x802465
  800533:	e8 a5 01 00 00       	call   8006dd <_panic>
		panic("file_close: %e", r);
  800538:	50                   	push   %eax
  800539:	68 0a 25 80 00       	push   $0x80250a
  80053e:	6a 38                	push   $0x38
  800540:	68 65 24 80 00       	push   $0x802465
  800545:	e8 93 01 00 00       	call   8006dd <_panic>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  80054a:	50                   	push   %eax
  80054b:	68 7c 26 80 00       	push   $0x80267c
  800550:	6a 43                	push   $0x43
  800552:	68 65 24 80 00       	push   $0x802465
  800557:	e8 81 01 00 00       	call   8006dd <_panic>
		panic("serve_open /new-file: %e", r);
  80055c:	50                   	push   %eax
  80055d:	68 4d 25 80 00       	push   $0x80254d
  800562:	6a 48                	push   $0x48
  800564:	68 65 24 80 00       	push   $0x802465
  800569:	e8 6f 01 00 00       	call   8006dd <_panic>
		panic("file_write: %e", r);
  80056e:	53                   	push   %ebx
  80056f:	68 66 25 80 00       	push   $0x802566
  800574:	6a 4b                	push   $0x4b
  800576:	68 65 24 80 00       	push   $0x802465
  80057b:	e8 5d 01 00 00       	call   8006dd <_panic>
		panic("file_read after file_write: %e", r);
  800580:	50                   	push   %eax
  800581:	68 b4 26 80 00       	push   $0x8026b4
  800586:	6a 51                	push   $0x51
  800588:	68 65 24 80 00       	push   $0x802465
  80058d:	e8 4b 01 00 00       	call   8006dd <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  800592:	53                   	push   %ebx
  800593:	68 d4 26 80 00       	push   $0x8026d4
  800598:	6a 53                	push   $0x53
  80059a:	68 65 24 80 00       	push   $0x802465
  80059f:	e8 39 01 00 00       	call   8006dd <_panic>
		panic("file_read after file_write returned wrong data");
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	68 0c 27 80 00       	push   $0x80270c
  8005ac:	6a 55                	push   $0x55
  8005ae:	68 65 24 80 00       	push   $0x802465
  8005b3:	e8 25 01 00 00       	call   8006dd <_panic>
		panic("open /not-found: %e", r);
  8005b8:	50                   	push   %eax
  8005b9:	68 51 24 80 00       	push   $0x802451
  8005be:	6a 5a                	push   $0x5a
  8005c0:	68 65 24 80 00       	push   $0x802465
  8005c5:	e8 13 01 00 00       	call   8006dd <_panic>
		panic("open /not-found succeeded!");
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	68 89 25 80 00       	push   $0x802589
  8005d2:	6a 5c                	push   $0x5c
  8005d4:	68 65 24 80 00       	push   $0x802465
  8005d9:	e8 ff 00 00 00       	call   8006dd <_panic>
		panic("open /newmotd: %e", r);
  8005de:	50                   	push   %eax
  8005df:	68 84 24 80 00       	push   $0x802484
  8005e4:	6a 5f                	push   $0x5f
  8005e6:	68 65 24 80 00       	push   $0x802465
  8005eb:	e8 ed 00 00 00       	call   8006dd <_panic>
		panic("open did not fill struct Fd correctly\n");
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	68 60 27 80 00       	push   $0x802760
  8005f8:	6a 62                	push   $0x62
  8005fa:	68 65 24 80 00       	push   $0x802465
  8005ff:	e8 d9 00 00 00       	call   8006dd <_panic>
		panic("creat /big: %e", f);
  800604:	50                   	push   %eax
  800605:	68 a9 25 80 00       	push   $0x8025a9
  80060a:	6a 67                	push   $0x67
  80060c:	68 65 24 80 00       	push   $0x802465
  800611:	e8 c7 00 00 00       	call   8006dd <_panic>
			panic("write /big@%d: %e", i, r);
  800616:	83 ec 0c             	sub    $0xc,%esp
  800619:	50                   	push   %eax
  80061a:	56                   	push   %esi
  80061b:	68 b8 25 80 00       	push   $0x8025b8
  800620:	6a 6c                	push   $0x6c
  800622:	68 65 24 80 00       	push   $0x802465
  800627:	e8 b1 00 00 00       	call   8006dd <_panic>
		panic("open /big: %e", f);
  80062c:	50                   	push   %eax
  80062d:	68 ca 25 80 00       	push   $0x8025ca
  800632:	6a 71                	push   $0x71
  800634:	68 65 24 80 00       	push   $0x802465
  800639:	e8 9f 00 00 00       	call   8006dd <_panic>
			panic("read /big@%d: %e", i, r);
  80063e:	83 ec 0c             	sub    $0xc,%esp
  800641:	50                   	push   %eax
  800642:	53                   	push   %ebx
  800643:	68 d8 25 80 00       	push   $0x8025d8
  800648:	6a 75                	push   $0x75
  80064a:	68 65 24 80 00       	push   $0x802465
  80064f:	e8 89 00 00 00       	call   8006dd <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	68 00 02 00 00       	push   $0x200
  80065c:	50                   	push   %eax
  80065d:	53                   	push   %ebx
  80065e:	68 88 27 80 00       	push   $0x802788
  800663:	6a 78                	push   $0x78
  800665:	68 65 24 80 00       	push   $0x802465
  80066a:	e8 6e 00 00 00       	call   8006dd <_panic>
			panic("read /big from %d returned bad data %d",
  80066f:	83 ec 0c             	sub    $0xc,%esp
  800672:	50                   	push   %eax
  800673:	53                   	push   %ebx
  800674:	68 b4 27 80 00       	push   $0x8027b4
  800679:	6a 7b                	push   $0x7b
  80067b:	68 65 24 80 00       	push   $0x802465
  800680:	e8 58 00 00 00       	call   8006dd <_panic>

00800685 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	56                   	push   %esi
  800689:	53                   	push   %ebx
  80068a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80068d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  800690:	e8 fd 0a 00 00       	call   801192 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  800695:	25 ff 03 00 00       	and    $0x3ff,%eax
  80069a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80069d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a2:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a7:	85 db                	test   %ebx,%ebx
  8006a9:	7e 07                	jle    8006b2 <libmain+0x2d>
		binaryname = argv[0];
  8006ab:	8b 06                	mov    (%esi),%eax
  8006ad:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	56                   	push   %esi
  8006b6:	53                   	push   %ebx
  8006b7:	e8 c2 f9 ff ff       	call   80007e <umain>

	// exit gracefully
	exit();
  8006bc:	e8 0a 00 00 00       	call   8006cb <exit>
}
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8006c7:	5b                   	pop    %ebx
  8006c8:	5e                   	pop    %esi
  8006c9:	5d                   	pop    %ebp
  8006ca:	c3                   	ret    

008006cb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8006d1:	6a 00                	push   $0x0
  8006d3:	e8 79 0a 00 00       	call   801151 <sys_env_destroy>
}
  8006d8:	83 c4 10             	add    $0x10,%esp
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	56                   	push   %esi
  8006e1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8006e2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006e5:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8006eb:	e8 a2 0a 00 00       	call   801192 <sys_getenvid>
  8006f0:	83 ec 0c             	sub    $0xc,%esp
  8006f3:	ff 75 0c             	pushl  0xc(%ebp)
  8006f6:	ff 75 08             	pushl  0x8(%ebp)
  8006f9:	56                   	push   %esi
  8006fa:	50                   	push   %eax
  8006fb:	68 0c 28 80 00       	push   $0x80280c
  800700:	e8 b3 00 00 00       	call   8007b8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800705:	83 c4 18             	add    $0x18,%esp
  800708:	53                   	push   %ebx
  800709:	ff 75 10             	pushl  0x10(%ebp)
  80070c:	e8 56 00 00 00       	call   800767 <vcprintf>
	cprintf("\n");
  800711:	c7 04 24 5f 2c 80 00 	movl   $0x802c5f,(%esp)
  800718:	e8 9b 00 00 00       	call   8007b8 <cprintf>
  80071d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800720:	cc                   	int3   
  800721:	eb fd                	jmp    800720 <_panic+0x43>

00800723 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800723:	55                   	push   %ebp
  800724:	89 e5                	mov    %esp,%ebp
  800726:	53                   	push   %ebx
  800727:	83 ec 04             	sub    $0x4,%esp
  80072a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80072d:	8b 13                	mov    (%ebx),%edx
  80072f:	8d 42 01             	lea    0x1(%edx),%eax
  800732:	89 03                	mov    %eax,(%ebx)
  800734:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800737:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80073b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800740:	74 09                	je     80074b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800742:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800746:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800749:	c9                   	leave  
  80074a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	68 ff 00 00 00       	push   $0xff
  800753:	8d 43 08             	lea    0x8(%ebx),%eax
  800756:	50                   	push   %eax
  800757:	e8 b8 09 00 00       	call   801114 <sys_cputs>
		b->idx = 0;
  80075c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800762:	83 c4 10             	add    $0x10,%esp
  800765:	eb db                	jmp    800742 <putch+0x1f>

00800767 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800770:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800777:	00 00 00 
	b.cnt = 0;
  80077a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800781:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800784:	ff 75 0c             	pushl  0xc(%ebp)
  800787:	ff 75 08             	pushl  0x8(%ebp)
  80078a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800790:	50                   	push   %eax
  800791:	68 23 07 80 00       	push   $0x800723
  800796:	e8 1a 01 00 00       	call   8008b5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80079b:	83 c4 08             	add    $0x8,%esp
  80079e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8007a4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8007aa:	50                   	push   %eax
  8007ab:	e8 64 09 00 00       	call   801114 <sys_cputs>

	return b.cnt;
}
  8007b0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007be:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8007c1:	50                   	push   %eax
  8007c2:	ff 75 08             	pushl  0x8(%ebp)
  8007c5:	e8 9d ff ff ff       	call   800767 <vcprintf>
	va_end(ap);

	return cnt;
}
  8007ca:	c9                   	leave  
  8007cb:	c3                   	ret    

008007cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	57                   	push   %edi
  8007d0:	56                   	push   %esi
  8007d1:	53                   	push   %ebx
  8007d2:	83 ec 1c             	sub    $0x1c,%esp
  8007d5:	89 c7                	mov    %eax,%edi
  8007d7:	89 d6                	mov    %edx,%esi
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007ed:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8007f3:	39 d3                	cmp    %edx,%ebx
  8007f5:	72 05                	jb     8007fc <printnum+0x30>
  8007f7:	39 45 10             	cmp    %eax,0x10(%ebp)
  8007fa:	77 7a                	ja     800876 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007fc:	83 ec 0c             	sub    $0xc,%esp
  8007ff:	ff 75 18             	pushl  0x18(%ebp)
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800808:	53                   	push   %ebx
  800809:	ff 75 10             	pushl  0x10(%ebp)
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800812:	ff 75 e0             	pushl  -0x20(%ebp)
  800815:	ff 75 dc             	pushl  -0x24(%ebp)
  800818:	ff 75 d8             	pushl  -0x28(%ebp)
  80081b:	e8 e0 19 00 00       	call   802200 <__udivdi3>
  800820:	83 c4 18             	add    $0x18,%esp
  800823:	52                   	push   %edx
  800824:	50                   	push   %eax
  800825:	89 f2                	mov    %esi,%edx
  800827:	89 f8                	mov    %edi,%eax
  800829:	e8 9e ff ff ff       	call   8007cc <printnum>
  80082e:	83 c4 20             	add    $0x20,%esp
  800831:	eb 13                	jmp    800846 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	56                   	push   %esi
  800837:	ff 75 18             	pushl  0x18(%ebp)
  80083a:	ff d7                	call   *%edi
  80083c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80083f:	83 eb 01             	sub    $0x1,%ebx
  800842:	85 db                	test   %ebx,%ebx
  800844:	7f ed                	jg     800833 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	56                   	push   %esi
  80084a:	83 ec 04             	sub    $0x4,%esp
  80084d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800850:	ff 75 e0             	pushl  -0x20(%ebp)
  800853:	ff 75 dc             	pushl  -0x24(%ebp)
  800856:	ff 75 d8             	pushl  -0x28(%ebp)
  800859:	e8 c2 1a 00 00       	call   802320 <__umoddi3>
  80085e:	83 c4 14             	add    $0x14,%esp
  800861:	0f be 80 2f 28 80 00 	movsbl 0x80282f(%eax),%eax
  800868:	50                   	push   %eax
  800869:	ff d7                	call   *%edi
}
  80086b:	83 c4 10             	add    $0x10,%esp
  80086e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800871:	5b                   	pop    %ebx
  800872:	5e                   	pop    %esi
  800873:	5f                   	pop    %edi
  800874:	5d                   	pop    %ebp
  800875:	c3                   	ret    
  800876:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800879:	eb c4                	jmp    80083f <printnum+0x73>

0080087b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800881:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800885:	8b 10                	mov    (%eax),%edx
  800887:	3b 50 04             	cmp    0x4(%eax),%edx
  80088a:	73 0a                	jae    800896 <sprintputch+0x1b>
		*b->buf++ = ch;
  80088c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80088f:	89 08                	mov    %ecx,(%eax)
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	88 02                	mov    %al,(%edx)
}
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <printfmt>:
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80089e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008a1:	50                   	push   %eax
  8008a2:	ff 75 10             	pushl  0x10(%ebp)
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	ff 75 08             	pushl  0x8(%ebp)
  8008ab:	e8 05 00 00 00       	call   8008b5 <vprintfmt>
}
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	c9                   	leave  
  8008b4:	c3                   	ret    

008008b5 <vprintfmt>:
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	57                   	push   %edi
  8008b9:	56                   	push   %esi
  8008ba:	53                   	push   %ebx
  8008bb:	83 ec 2c             	sub    $0x2c,%esp
  8008be:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008c4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008c7:	e9 c1 03 00 00       	jmp    800c8d <vprintfmt+0x3d8>
		padc = ' ';
  8008cc:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8008d0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8008d7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8008de:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008e5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008ea:	8d 47 01             	lea    0x1(%edi),%eax
  8008ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f0:	0f b6 17             	movzbl (%edi),%edx
  8008f3:	8d 42 dd             	lea    -0x23(%edx),%eax
  8008f6:	3c 55                	cmp    $0x55,%al
  8008f8:	0f 87 12 04 00 00    	ja     800d10 <vprintfmt+0x45b>
  8008fe:	0f b6 c0             	movzbl %al,%eax
  800901:	ff 24 85 80 29 80 00 	jmp    *0x802980(,%eax,4)
  800908:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80090b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80090f:	eb d9                	jmp    8008ea <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800911:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800914:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800918:	eb d0                	jmp    8008ea <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80091a:	0f b6 d2             	movzbl %dl,%edx
  80091d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800920:	b8 00 00 00 00       	mov    $0x0,%eax
  800925:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800928:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80092b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80092f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800932:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800935:	83 f9 09             	cmp    $0x9,%ecx
  800938:	77 55                	ja     80098f <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80093a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80093d:	eb e9                	jmp    800928 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	8d 40 04             	lea    0x4(%eax),%eax
  80094d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800950:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800953:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800957:	79 91                	jns    8008ea <vprintfmt+0x35>
				width = precision, precision = -1;
  800959:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80095c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80095f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800966:	eb 82                	jmp    8008ea <vprintfmt+0x35>
  800968:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80096b:	85 c0                	test   %eax,%eax
  80096d:	ba 00 00 00 00       	mov    $0x0,%edx
  800972:	0f 49 d0             	cmovns %eax,%edx
  800975:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800978:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80097b:	e9 6a ff ff ff       	jmp    8008ea <vprintfmt+0x35>
  800980:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800983:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80098a:	e9 5b ff ff ff       	jmp    8008ea <vprintfmt+0x35>
  80098f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800992:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800995:	eb bc                	jmp    800953 <vprintfmt+0x9e>
			lflag++;
  800997:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80099a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80099d:	e9 48 ff ff ff       	jmp    8008ea <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8009a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a5:	8d 78 04             	lea    0x4(%eax),%edi
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	53                   	push   %ebx
  8009ac:	ff 30                	pushl  (%eax)
  8009ae:	ff d6                	call   *%esi
			break;
  8009b0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8009b3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8009b6:	e9 cf 02 00 00       	jmp    800c8a <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	8d 78 04             	lea    0x4(%eax),%edi
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	99                   	cltd   
  8009c4:	31 d0                	xor    %edx,%eax
  8009c6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009c8:	83 f8 0f             	cmp    $0xf,%eax
  8009cb:	7f 23                	jg     8009f0 <vprintfmt+0x13b>
  8009cd:	8b 14 85 e0 2a 80 00 	mov    0x802ae0(,%eax,4),%edx
  8009d4:	85 d2                	test   %edx,%edx
  8009d6:	74 18                	je     8009f0 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8009d8:	52                   	push   %edx
  8009d9:	68 2d 2c 80 00       	push   $0x802c2d
  8009de:	53                   	push   %ebx
  8009df:	56                   	push   %esi
  8009e0:	e8 b3 fe ff ff       	call   800898 <printfmt>
  8009e5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8009e8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8009eb:	e9 9a 02 00 00       	jmp    800c8a <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8009f0:	50                   	push   %eax
  8009f1:	68 47 28 80 00       	push   $0x802847
  8009f6:	53                   	push   %ebx
  8009f7:	56                   	push   %esi
  8009f8:	e8 9b fe ff ff       	call   800898 <printfmt>
  8009fd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a00:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a03:	e9 82 02 00 00       	jmp    800c8a <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800a08:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0b:	83 c0 04             	add    $0x4,%eax
  800a0e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800a11:	8b 45 14             	mov    0x14(%ebp),%eax
  800a14:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800a16:	85 ff                	test   %edi,%edi
  800a18:	b8 40 28 80 00       	mov    $0x802840,%eax
  800a1d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800a20:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a24:	0f 8e bd 00 00 00    	jle    800ae7 <vprintfmt+0x232>
  800a2a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800a2e:	75 0e                	jne    800a3e <vprintfmt+0x189>
  800a30:	89 75 08             	mov    %esi,0x8(%ebp)
  800a33:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a36:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a39:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a3c:	eb 6d                	jmp    800aab <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3e:	83 ec 08             	sub    $0x8,%esp
  800a41:	ff 75 d0             	pushl  -0x30(%ebp)
  800a44:	57                   	push   %edi
  800a45:	e8 6e 03 00 00       	call   800db8 <strnlen>
  800a4a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a4d:	29 c1                	sub    %eax,%ecx
  800a4f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800a52:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800a55:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800a59:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a5c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800a5f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a61:	eb 0f                	jmp    800a72 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	53                   	push   %ebx
  800a67:	ff 75 e0             	pushl  -0x20(%ebp)
  800a6a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a6c:	83 ef 01             	sub    $0x1,%edi
  800a6f:	83 c4 10             	add    $0x10,%esp
  800a72:	85 ff                	test   %edi,%edi
  800a74:	7f ed                	jg     800a63 <vprintfmt+0x1ae>
  800a76:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800a79:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800a7c:	85 c9                	test   %ecx,%ecx
  800a7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a83:	0f 49 c1             	cmovns %ecx,%eax
  800a86:	29 c1                	sub    %eax,%ecx
  800a88:	89 75 08             	mov    %esi,0x8(%ebp)
  800a8b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a8e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a91:	89 cb                	mov    %ecx,%ebx
  800a93:	eb 16                	jmp    800aab <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800a95:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a99:	75 31                	jne    800acc <vprintfmt+0x217>
					putch(ch, putdat);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	50                   	push   %eax
  800aa2:	ff 55 08             	call   *0x8(%ebp)
  800aa5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa8:	83 eb 01             	sub    $0x1,%ebx
  800aab:	83 c7 01             	add    $0x1,%edi
  800aae:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800ab2:	0f be c2             	movsbl %dl,%eax
  800ab5:	85 c0                	test   %eax,%eax
  800ab7:	74 59                	je     800b12 <vprintfmt+0x25d>
  800ab9:	85 f6                	test   %esi,%esi
  800abb:	78 d8                	js     800a95 <vprintfmt+0x1e0>
  800abd:	83 ee 01             	sub    $0x1,%esi
  800ac0:	79 d3                	jns    800a95 <vprintfmt+0x1e0>
  800ac2:	89 df                	mov    %ebx,%edi
  800ac4:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800aca:	eb 37                	jmp    800b03 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800acc:	0f be d2             	movsbl %dl,%edx
  800acf:	83 ea 20             	sub    $0x20,%edx
  800ad2:	83 fa 5e             	cmp    $0x5e,%edx
  800ad5:	76 c4                	jbe    800a9b <vprintfmt+0x1e6>
					putch('?', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 3f                	push   $0x3f
  800adf:	ff 55 08             	call   *0x8(%ebp)
  800ae2:	83 c4 10             	add    $0x10,%esp
  800ae5:	eb c1                	jmp    800aa8 <vprintfmt+0x1f3>
  800ae7:	89 75 08             	mov    %esi,0x8(%ebp)
  800aea:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800aed:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800af0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800af3:	eb b6                	jmp    800aab <vprintfmt+0x1f6>
				putch(' ', putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	53                   	push   %ebx
  800af9:	6a 20                	push   $0x20
  800afb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800afd:	83 ef 01             	sub    $0x1,%edi
  800b00:	83 c4 10             	add    $0x10,%esp
  800b03:	85 ff                	test   %edi,%edi
  800b05:	7f ee                	jg     800af5 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800b07:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b0a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0d:	e9 78 01 00 00       	jmp    800c8a <vprintfmt+0x3d5>
  800b12:	89 df                	mov    %ebx,%edi
  800b14:	8b 75 08             	mov    0x8(%ebp),%esi
  800b17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b1a:	eb e7                	jmp    800b03 <vprintfmt+0x24e>
	if (lflag >= 2)
  800b1c:	83 f9 01             	cmp    $0x1,%ecx
  800b1f:	7e 3f                	jle    800b60 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	8b 50 04             	mov    0x4(%eax),%edx
  800b27:	8b 00                	mov    (%eax),%eax
  800b29:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b2c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b32:	8d 40 08             	lea    0x8(%eax),%eax
  800b35:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800b38:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b3c:	79 5c                	jns    800b9a <vprintfmt+0x2e5>
				putch('-', putdat);
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	53                   	push   %ebx
  800b42:	6a 2d                	push   $0x2d
  800b44:	ff d6                	call   *%esi
				num = -(long long) num;
  800b46:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b49:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800b4c:	f7 da                	neg    %edx
  800b4e:	83 d1 00             	adc    $0x0,%ecx
  800b51:	f7 d9                	neg    %ecx
  800b53:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b56:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b5b:	e9 10 01 00 00       	jmp    800c70 <vprintfmt+0x3bb>
	else if (lflag)
  800b60:	85 c9                	test   %ecx,%ecx
  800b62:	75 1b                	jne    800b7f <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800b64:	8b 45 14             	mov    0x14(%ebp),%eax
  800b67:	8b 00                	mov    (%eax),%eax
  800b69:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b6c:	89 c1                	mov    %eax,%ecx
  800b6e:	c1 f9 1f             	sar    $0x1f,%ecx
  800b71:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b74:	8b 45 14             	mov    0x14(%ebp),%eax
  800b77:	8d 40 04             	lea    0x4(%eax),%eax
  800b7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b7d:	eb b9                	jmp    800b38 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800b7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b82:	8b 00                	mov    (%eax),%eax
  800b84:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b87:	89 c1                	mov    %eax,%ecx
  800b89:	c1 f9 1f             	sar    $0x1f,%ecx
  800b8c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b92:	8d 40 04             	lea    0x4(%eax),%eax
  800b95:	89 45 14             	mov    %eax,0x14(%ebp)
  800b98:	eb 9e                	jmp    800b38 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800b9a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b9d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800ba0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ba5:	e9 c6 00 00 00       	jmp    800c70 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800baa:	83 f9 01             	cmp    $0x1,%ecx
  800bad:	7e 18                	jle    800bc7 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800baf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb2:	8b 10                	mov    (%eax),%edx
  800bb4:	8b 48 04             	mov    0x4(%eax),%ecx
  800bb7:	8d 40 08             	lea    0x8(%eax),%eax
  800bba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bbd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bc2:	e9 a9 00 00 00       	jmp    800c70 <vprintfmt+0x3bb>
	else if (lflag)
  800bc7:	85 c9                	test   %ecx,%ecx
  800bc9:	75 1a                	jne    800be5 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800bcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bce:	8b 10                	mov    (%eax),%edx
  800bd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd5:	8d 40 04             	lea    0x4(%eax),%eax
  800bd8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bdb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be0:	e9 8b 00 00 00       	jmp    800c70 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800be5:	8b 45 14             	mov    0x14(%ebp),%eax
  800be8:	8b 10                	mov    (%eax),%edx
  800bea:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bef:	8d 40 04             	lea    0x4(%eax),%eax
  800bf2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bf5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfa:	eb 74                	jmp    800c70 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800bfc:	83 f9 01             	cmp    $0x1,%ecx
  800bff:	7e 15                	jle    800c16 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800c01:	8b 45 14             	mov    0x14(%ebp),%eax
  800c04:	8b 10                	mov    (%eax),%edx
  800c06:	8b 48 04             	mov    0x4(%eax),%ecx
  800c09:	8d 40 08             	lea    0x8(%eax),%eax
  800c0c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c0f:	b8 08 00 00 00       	mov    $0x8,%eax
  800c14:	eb 5a                	jmp    800c70 <vprintfmt+0x3bb>
	else if (lflag)
  800c16:	85 c9                	test   %ecx,%ecx
  800c18:	75 17                	jne    800c31 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1d:	8b 10                	mov    (%eax),%edx
  800c1f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c24:	8d 40 04             	lea    0x4(%eax),%eax
  800c27:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c2a:	b8 08 00 00 00       	mov    $0x8,%eax
  800c2f:	eb 3f                	jmp    800c70 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800c31:	8b 45 14             	mov    0x14(%ebp),%eax
  800c34:	8b 10                	mov    (%eax),%edx
  800c36:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c3b:	8d 40 04             	lea    0x4(%eax),%eax
  800c3e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c41:	b8 08 00 00 00       	mov    $0x8,%eax
  800c46:	eb 28                	jmp    800c70 <vprintfmt+0x3bb>
			putch('0', putdat);
  800c48:	83 ec 08             	sub    $0x8,%esp
  800c4b:	53                   	push   %ebx
  800c4c:	6a 30                	push   $0x30
  800c4e:	ff d6                	call   *%esi
			putch('x', putdat);
  800c50:	83 c4 08             	add    $0x8,%esp
  800c53:	53                   	push   %ebx
  800c54:	6a 78                	push   $0x78
  800c56:	ff d6                	call   *%esi
			num = (unsigned long long)
  800c58:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5b:	8b 10                	mov    (%eax),%edx
  800c5d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800c62:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800c65:	8d 40 04             	lea    0x4(%eax),%eax
  800c68:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c6b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800c70:	83 ec 0c             	sub    $0xc,%esp
  800c73:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800c77:	57                   	push   %edi
  800c78:	ff 75 e0             	pushl  -0x20(%ebp)
  800c7b:	50                   	push   %eax
  800c7c:	51                   	push   %ecx
  800c7d:	52                   	push   %edx
  800c7e:	89 da                	mov    %ebx,%edx
  800c80:	89 f0                	mov    %esi,%eax
  800c82:	e8 45 fb ff ff       	call   8007cc <printnum>
			break;
  800c87:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800c8a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  800c8d:	83 c7 01             	add    $0x1,%edi
  800c90:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c94:	83 f8 25             	cmp    $0x25,%eax
  800c97:	0f 84 2f fc ff ff    	je     8008cc <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  800c9d:	85 c0                	test   %eax,%eax
  800c9f:	0f 84 8b 00 00 00    	je     800d30 <vprintfmt+0x47b>
			putch(ch, putdat);
  800ca5:	83 ec 08             	sub    $0x8,%esp
  800ca8:	53                   	push   %ebx
  800ca9:	50                   	push   %eax
  800caa:	ff d6                	call   *%esi
  800cac:	83 c4 10             	add    $0x10,%esp
  800caf:	eb dc                	jmp    800c8d <vprintfmt+0x3d8>
	if (lflag >= 2)
  800cb1:	83 f9 01             	cmp    $0x1,%ecx
  800cb4:	7e 15                	jle    800ccb <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800cb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb9:	8b 10                	mov    (%eax),%edx
  800cbb:	8b 48 04             	mov    0x4(%eax),%ecx
  800cbe:	8d 40 08             	lea    0x8(%eax),%eax
  800cc1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cc4:	b8 10 00 00 00       	mov    $0x10,%eax
  800cc9:	eb a5                	jmp    800c70 <vprintfmt+0x3bb>
	else if (lflag)
  800ccb:	85 c9                	test   %ecx,%ecx
  800ccd:	75 17                	jne    800ce6 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800ccf:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd2:	8b 10                	mov    (%eax),%edx
  800cd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd9:	8d 40 04             	lea    0x4(%eax),%eax
  800cdc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cdf:	b8 10 00 00 00       	mov    $0x10,%eax
  800ce4:	eb 8a                	jmp    800c70 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800ce6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce9:	8b 10                	mov    (%eax),%edx
  800ceb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf0:	8d 40 04             	lea    0x4(%eax),%eax
  800cf3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cf6:	b8 10 00 00 00       	mov    $0x10,%eax
  800cfb:	e9 70 ff ff ff       	jmp    800c70 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800d00:	83 ec 08             	sub    $0x8,%esp
  800d03:	53                   	push   %ebx
  800d04:	6a 25                	push   $0x25
  800d06:	ff d6                	call   *%esi
			break;
  800d08:	83 c4 10             	add    $0x10,%esp
  800d0b:	e9 7a ff ff ff       	jmp    800c8a <vprintfmt+0x3d5>
			putch('%', putdat);
  800d10:	83 ec 08             	sub    $0x8,%esp
  800d13:	53                   	push   %ebx
  800d14:	6a 25                	push   $0x25
  800d16:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d18:	83 c4 10             	add    $0x10,%esp
  800d1b:	89 f8                	mov    %edi,%eax
  800d1d:	eb 03                	jmp    800d22 <vprintfmt+0x46d>
  800d1f:	83 e8 01             	sub    $0x1,%eax
  800d22:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800d26:	75 f7                	jne    800d1f <vprintfmt+0x46a>
  800d28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d2b:	e9 5a ff ff ff       	jmp    800c8a <vprintfmt+0x3d5>
}
  800d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d33:	5b                   	pop    %ebx
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    

00800d38 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	83 ec 18             	sub    $0x18,%esp
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d44:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d47:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d4b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d55:	85 c0                	test   %eax,%eax
  800d57:	74 26                	je     800d7f <vsnprintf+0x47>
  800d59:	85 d2                	test   %edx,%edx
  800d5b:	7e 22                	jle    800d7f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d5d:	ff 75 14             	pushl  0x14(%ebp)
  800d60:	ff 75 10             	pushl  0x10(%ebp)
  800d63:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d66:	50                   	push   %eax
  800d67:	68 7b 08 80 00       	push   $0x80087b
  800d6c:	e8 44 fb ff ff       	call   8008b5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d74:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d7a:	83 c4 10             	add    $0x10,%esp
}
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    
		return -E_INVAL;
  800d7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d84:	eb f7                	jmp    800d7d <vsnprintf+0x45>

00800d86 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d8c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d8f:	50                   	push   %eax
  800d90:	ff 75 10             	pushl  0x10(%ebp)
  800d93:	ff 75 0c             	pushl  0xc(%ebp)
  800d96:	ff 75 08             	pushl  0x8(%ebp)
  800d99:	e8 9a ff ff ff       	call   800d38 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800da6:	b8 00 00 00 00       	mov    $0x0,%eax
  800dab:	eb 03                	jmp    800db0 <strlen+0x10>
		n++;
  800dad:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800db0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800db4:	75 f7                	jne    800dad <strlen+0xd>
	return n;
}
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dbe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc6:	eb 03                	jmp    800dcb <strnlen+0x13>
		n++;
  800dc8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dcb:	39 d0                	cmp    %edx,%eax
  800dcd:	74 06                	je     800dd5 <strnlen+0x1d>
  800dcf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800dd3:	75 f3                	jne    800dc8 <strnlen+0x10>
	return n;
}
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    

00800dd7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	53                   	push   %ebx
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800de1:	89 c2                	mov    %eax,%edx
  800de3:	83 c1 01             	add    $0x1,%ecx
  800de6:	83 c2 01             	add    $0x1,%edx
  800de9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800ded:	88 5a ff             	mov    %bl,-0x1(%edx)
  800df0:	84 db                	test   %bl,%bl
  800df2:	75 ef                	jne    800de3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800df4:	5b                   	pop    %ebx
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    

00800df7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	53                   	push   %ebx
  800dfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800dfe:	53                   	push   %ebx
  800dff:	e8 9c ff ff ff       	call   800da0 <strlen>
  800e04:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800e07:	ff 75 0c             	pushl  0xc(%ebp)
  800e0a:	01 d8                	add    %ebx,%eax
  800e0c:	50                   	push   %eax
  800e0d:	e8 c5 ff ff ff       	call   800dd7 <strcpy>
	return dst;
}
  800e12:	89 d8                	mov    %ebx,%eax
  800e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e17:	c9                   	leave  
  800e18:	c3                   	ret    

00800e19 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	56                   	push   %esi
  800e1d:	53                   	push   %ebx
  800e1e:	8b 75 08             	mov    0x8(%ebp),%esi
  800e21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e24:	89 f3                	mov    %esi,%ebx
  800e26:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e29:	89 f2                	mov    %esi,%edx
  800e2b:	eb 0f                	jmp    800e3c <strncpy+0x23>
		*dst++ = *src;
  800e2d:	83 c2 01             	add    $0x1,%edx
  800e30:	0f b6 01             	movzbl (%ecx),%eax
  800e33:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e36:	80 39 01             	cmpb   $0x1,(%ecx)
  800e39:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800e3c:	39 da                	cmp    %ebx,%edx
  800e3e:	75 ed                	jne    800e2d <strncpy+0x14>
	}
	return ret;
}
  800e40:	89 f0                	mov    %esi,%eax
  800e42:	5b                   	pop    %ebx
  800e43:	5e                   	pop    %esi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	56                   	push   %esi
  800e4a:	53                   	push   %ebx
  800e4b:	8b 75 08             	mov    0x8(%ebp),%esi
  800e4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800e54:	89 f0                	mov    %esi,%eax
  800e56:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e5a:	85 c9                	test   %ecx,%ecx
  800e5c:	75 0b                	jne    800e69 <strlcpy+0x23>
  800e5e:	eb 17                	jmp    800e77 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800e60:	83 c2 01             	add    $0x1,%edx
  800e63:	83 c0 01             	add    $0x1,%eax
  800e66:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800e69:	39 d8                	cmp    %ebx,%eax
  800e6b:	74 07                	je     800e74 <strlcpy+0x2e>
  800e6d:	0f b6 0a             	movzbl (%edx),%ecx
  800e70:	84 c9                	test   %cl,%cl
  800e72:	75 ec                	jne    800e60 <strlcpy+0x1a>
		*dst = '\0';
  800e74:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e77:	29 f0                	sub    %esi,%eax
}
  800e79:	5b                   	pop    %ebx
  800e7a:	5e                   	pop    %esi
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    

00800e7d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e83:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e86:	eb 06                	jmp    800e8e <strcmp+0x11>
		p++, q++;
  800e88:	83 c1 01             	add    $0x1,%ecx
  800e8b:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800e8e:	0f b6 01             	movzbl (%ecx),%eax
  800e91:	84 c0                	test   %al,%al
  800e93:	74 04                	je     800e99 <strcmp+0x1c>
  800e95:	3a 02                	cmp    (%edx),%al
  800e97:	74 ef                	je     800e88 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e99:	0f b6 c0             	movzbl %al,%eax
  800e9c:	0f b6 12             	movzbl (%edx),%edx
  800e9f:	29 d0                	sub    %edx,%eax
}
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    

00800ea3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	53                   	push   %ebx
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ead:	89 c3                	mov    %eax,%ebx
  800eaf:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800eb2:	eb 06                	jmp    800eba <strncmp+0x17>
		n--, p++, q++;
  800eb4:	83 c0 01             	add    $0x1,%eax
  800eb7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800eba:	39 d8                	cmp    %ebx,%eax
  800ebc:	74 16                	je     800ed4 <strncmp+0x31>
  800ebe:	0f b6 08             	movzbl (%eax),%ecx
  800ec1:	84 c9                	test   %cl,%cl
  800ec3:	74 04                	je     800ec9 <strncmp+0x26>
  800ec5:	3a 0a                	cmp    (%edx),%cl
  800ec7:	74 eb                	je     800eb4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ec9:	0f b6 00             	movzbl (%eax),%eax
  800ecc:	0f b6 12             	movzbl (%edx),%edx
  800ecf:	29 d0                	sub    %edx,%eax
}
  800ed1:	5b                   	pop    %ebx
  800ed2:	5d                   	pop    %ebp
  800ed3:	c3                   	ret    
		return 0;
  800ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed9:	eb f6                	jmp    800ed1 <strncmp+0x2e>

00800edb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ee5:	0f b6 10             	movzbl (%eax),%edx
  800ee8:	84 d2                	test   %dl,%dl
  800eea:	74 09                	je     800ef5 <strchr+0x1a>
		if (*s == c)
  800eec:	38 ca                	cmp    %cl,%dl
  800eee:	74 0a                	je     800efa <strchr+0x1f>
	for (; *s; s++)
  800ef0:	83 c0 01             	add    $0x1,%eax
  800ef3:	eb f0                	jmp    800ee5 <strchr+0xa>
			return (char *) s;
	return 0;
  800ef5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    

00800efc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f06:	eb 03                	jmp    800f0b <strfind+0xf>
  800f08:	83 c0 01             	add    $0x1,%eax
  800f0b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800f0e:	38 ca                	cmp    %cl,%dl
  800f10:	74 04                	je     800f16 <strfind+0x1a>
  800f12:	84 d2                	test   %dl,%dl
  800f14:	75 f2                	jne    800f08 <strfind+0xc>
			break;
	return (char *) s;
}
  800f16:	5d                   	pop    %ebp
  800f17:	c3                   	ret    

00800f18 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	57                   	push   %edi
  800f1c:	56                   	push   %esi
  800f1d:	53                   	push   %ebx
  800f1e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f21:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f24:	85 c9                	test   %ecx,%ecx
  800f26:	74 13                	je     800f3b <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f28:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f2e:	75 05                	jne    800f35 <memset+0x1d>
  800f30:	f6 c1 03             	test   $0x3,%cl
  800f33:	74 0d                	je     800f42 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	fc                   	cld    
  800f39:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f3b:	89 f8                	mov    %edi,%eax
  800f3d:	5b                   	pop    %ebx
  800f3e:	5e                   	pop    %esi
  800f3f:	5f                   	pop    %edi
  800f40:	5d                   	pop    %ebp
  800f41:	c3                   	ret    
		c &= 0xFF;
  800f42:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f46:	89 d3                	mov    %edx,%ebx
  800f48:	c1 e3 08             	shl    $0x8,%ebx
  800f4b:	89 d0                	mov    %edx,%eax
  800f4d:	c1 e0 18             	shl    $0x18,%eax
  800f50:	89 d6                	mov    %edx,%esi
  800f52:	c1 e6 10             	shl    $0x10,%esi
  800f55:	09 f0                	or     %esi,%eax
  800f57:	09 c2                	or     %eax,%edx
  800f59:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800f5b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f5e:	89 d0                	mov    %edx,%eax
  800f60:	fc                   	cld    
  800f61:	f3 ab                	rep stos %eax,%es:(%edi)
  800f63:	eb d6                	jmp    800f3b <memset+0x23>

00800f65 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f70:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f73:	39 c6                	cmp    %eax,%esi
  800f75:	73 35                	jae    800fac <memmove+0x47>
  800f77:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f7a:	39 c2                	cmp    %eax,%edx
  800f7c:	76 2e                	jbe    800fac <memmove+0x47>
		s += n;
		d += n;
  800f7e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f81:	89 d6                	mov    %edx,%esi
  800f83:	09 fe                	or     %edi,%esi
  800f85:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f8b:	74 0c                	je     800f99 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f8d:	83 ef 01             	sub    $0x1,%edi
  800f90:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f93:	fd                   	std    
  800f94:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f96:	fc                   	cld    
  800f97:	eb 21                	jmp    800fba <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f99:	f6 c1 03             	test   $0x3,%cl
  800f9c:	75 ef                	jne    800f8d <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f9e:	83 ef 04             	sub    $0x4,%edi
  800fa1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800fa4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800fa7:	fd                   	std    
  800fa8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800faa:	eb ea                	jmp    800f96 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fac:	89 f2                	mov    %esi,%edx
  800fae:	09 c2                	or     %eax,%edx
  800fb0:	f6 c2 03             	test   $0x3,%dl
  800fb3:	74 09                	je     800fbe <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800fb5:	89 c7                	mov    %eax,%edi
  800fb7:	fc                   	cld    
  800fb8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800fba:	5e                   	pop    %esi
  800fbb:	5f                   	pop    %edi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fbe:	f6 c1 03             	test   $0x3,%cl
  800fc1:	75 f2                	jne    800fb5 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800fc3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800fc6:	89 c7                	mov    %eax,%edi
  800fc8:	fc                   	cld    
  800fc9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fcb:	eb ed                	jmp    800fba <memmove+0x55>

00800fcd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800fd0:	ff 75 10             	pushl  0x10(%ebp)
  800fd3:	ff 75 0c             	pushl  0xc(%ebp)
  800fd6:	ff 75 08             	pushl  0x8(%ebp)
  800fd9:	e8 87 ff ff ff       	call   800f65 <memmove>
}
  800fde:	c9                   	leave  
  800fdf:	c3                   	ret    

00800fe0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	56                   	push   %esi
  800fe4:	53                   	push   %ebx
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800feb:	89 c6                	mov    %eax,%esi
  800fed:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ff0:	39 f0                	cmp    %esi,%eax
  800ff2:	74 1c                	je     801010 <memcmp+0x30>
		if (*s1 != *s2)
  800ff4:	0f b6 08             	movzbl (%eax),%ecx
  800ff7:	0f b6 1a             	movzbl (%edx),%ebx
  800ffa:	38 d9                	cmp    %bl,%cl
  800ffc:	75 08                	jne    801006 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ffe:	83 c0 01             	add    $0x1,%eax
  801001:	83 c2 01             	add    $0x1,%edx
  801004:	eb ea                	jmp    800ff0 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801006:	0f b6 c1             	movzbl %cl,%eax
  801009:	0f b6 db             	movzbl %bl,%ebx
  80100c:	29 d8                	sub    %ebx,%eax
  80100e:	eb 05                	jmp    801015 <memcmp+0x35>
	}

	return 0;
  801010:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801015:	5b                   	pop    %ebx
  801016:	5e                   	pop    %esi
  801017:	5d                   	pop    %ebp
  801018:	c3                   	ret    

00801019 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801022:	89 c2                	mov    %eax,%edx
  801024:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801027:	39 d0                	cmp    %edx,%eax
  801029:	73 09                	jae    801034 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80102b:	38 08                	cmp    %cl,(%eax)
  80102d:	74 05                	je     801034 <memfind+0x1b>
	for (; s < ends; s++)
  80102f:	83 c0 01             	add    $0x1,%eax
  801032:	eb f3                	jmp    801027 <memfind+0xe>
			break;
	return (void *) s;
}
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    

00801036 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	57                   	push   %edi
  80103a:	56                   	push   %esi
  80103b:	53                   	push   %ebx
  80103c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80103f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801042:	eb 03                	jmp    801047 <strtol+0x11>
		s++;
  801044:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801047:	0f b6 01             	movzbl (%ecx),%eax
  80104a:	3c 20                	cmp    $0x20,%al
  80104c:	74 f6                	je     801044 <strtol+0xe>
  80104e:	3c 09                	cmp    $0x9,%al
  801050:	74 f2                	je     801044 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801052:	3c 2b                	cmp    $0x2b,%al
  801054:	74 2e                	je     801084 <strtol+0x4e>
	int neg = 0;
  801056:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80105b:	3c 2d                	cmp    $0x2d,%al
  80105d:	74 2f                	je     80108e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80105f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801065:	75 05                	jne    80106c <strtol+0x36>
  801067:	80 39 30             	cmpb   $0x30,(%ecx)
  80106a:	74 2c                	je     801098 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80106c:	85 db                	test   %ebx,%ebx
  80106e:	75 0a                	jne    80107a <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801070:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801075:	80 39 30             	cmpb   $0x30,(%ecx)
  801078:	74 28                	je     8010a2 <strtol+0x6c>
		base = 10;
  80107a:	b8 00 00 00 00       	mov    $0x0,%eax
  80107f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801082:	eb 50                	jmp    8010d4 <strtol+0x9e>
		s++;
  801084:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801087:	bf 00 00 00 00       	mov    $0x0,%edi
  80108c:	eb d1                	jmp    80105f <strtol+0x29>
		s++, neg = 1;
  80108e:	83 c1 01             	add    $0x1,%ecx
  801091:	bf 01 00 00 00       	mov    $0x1,%edi
  801096:	eb c7                	jmp    80105f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801098:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80109c:	74 0e                	je     8010ac <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  80109e:	85 db                	test   %ebx,%ebx
  8010a0:	75 d8                	jne    80107a <strtol+0x44>
		s++, base = 8;
  8010a2:	83 c1 01             	add    $0x1,%ecx
  8010a5:	bb 08 00 00 00       	mov    $0x8,%ebx
  8010aa:	eb ce                	jmp    80107a <strtol+0x44>
		s += 2, base = 16;
  8010ac:	83 c1 02             	add    $0x2,%ecx
  8010af:	bb 10 00 00 00       	mov    $0x10,%ebx
  8010b4:	eb c4                	jmp    80107a <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8010b6:	8d 72 9f             	lea    -0x61(%edx),%esi
  8010b9:	89 f3                	mov    %esi,%ebx
  8010bb:	80 fb 19             	cmp    $0x19,%bl
  8010be:	77 29                	ja     8010e9 <strtol+0xb3>
			dig = *s - 'a' + 10;
  8010c0:	0f be d2             	movsbl %dl,%edx
  8010c3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010c6:	3b 55 10             	cmp    0x10(%ebp),%edx
  8010c9:	7d 30                	jge    8010fb <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8010cb:	83 c1 01             	add    $0x1,%ecx
  8010ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8010d4:	0f b6 11             	movzbl (%ecx),%edx
  8010d7:	8d 72 d0             	lea    -0x30(%edx),%esi
  8010da:	89 f3                	mov    %esi,%ebx
  8010dc:	80 fb 09             	cmp    $0x9,%bl
  8010df:	77 d5                	ja     8010b6 <strtol+0x80>
			dig = *s - '0';
  8010e1:	0f be d2             	movsbl %dl,%edx
  8010e4:	83 ea 30             	sub    $0x30,%edx
  8010e7:	eb dd                	jmp    8010c6 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  8010e9:	8d 72 bf             	lea    -0x41(%edx),%esi
  8010ec:	89 f3                	mov    %esi,%ebx
  8010ee:	80 fb 19             	cmp    $0x19,%bl
  8010f1:	77 08                	ja     8010fb <strtol+0xc5>
			dig = *s - 'A' + 10;
  8010f3:	0f be d2             	movsbl %dl,%edx
  8010f6:	83 ea 37             	sub    $0x37,%edx
  8010f9:	eb cb                	jmp    8010c6 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  8010fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ff:	74 05                	je     801106 <strtol+0xd0>
		*endptr = (char *) s;
  801101:	8b 75 0c             	mov    0xc(%ebp),%esi
  801104:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801106:	89 c2                	mov    %eax,%edx
  801108:	f7 da                	neg    %edx
  80110a:	85 ff                	test   %edi,%edi
  80110c:	0f 45 c2             	cmovne %edx,%eax
}
  80110f:	5b                   	pop    %ebx
  801110:	5e                   	pop    %esi
  801111:	5f                   	pop    %edi
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	57                   	push   %edi
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80111a:	b8 00 00 00 00       	mov    $0x0,%eax
  80111f:	8b 55 08             	mov    0x8(%ebp),%edx
  801122:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801125:	89 c3                	mov    %eax,%ebx
  801127:	89 c7                	mov    %eax,%edi
  801129:	89 c6                	mov    %eax,%esi
  80112b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80112d:	5b                   	pop    %ebx
  80112e:	5e                   	pop    %esi
  80112f:	5f                   	pop    %edi
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    

00801132 <sys_cgetc>:

int
sys_cgetc(void)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	57                   	push   %edi
  801136:	56                   	push   %esi
  801137:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  801138:	ba 00 00 00 00       	mov    $0x0,%edx
  80113d:	b8 01 00 00 00       	mov    $0x1,%eax
  801142:	89 d1                	mov    %edx,%ecx
  801144:	89 d3                	mov    %edx,%ebx
  801146:	89 d7                	mov    %edx,%edi
  801148:	89 d6                	mov    %edx,%esi
  80114a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80114c:	5b                   	pop    %ebx
  80114d:	5e                   	pop    %esi
  80114e:	5f                   	pop    %edi
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    

00801151 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	57                   	push   %edi
  801155:	56                   	push   %esi
  801156:	53                   	push   %ebx
  801157:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80115a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80115f:	8b 55 08             	mov    0x8(%ebp),%edx
  801162:	b8 03 00 00 00       	mov    $0x3,%eax
  801167:	89 cb                	mov    %ecx,%ebx
  801169:	89 cf                	mov    %ecx,%edi
  80116b:	89 ce                	mov    %ecx,%esi
  80116d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80116f:	85 c0                	test   %eax,%eax
  801171:	7f 08                	jg     80117b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801173:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801176:	5b                   	pop    %ebx
  801177:	5e                   	pop    %esi
  801178:	5f                   	pop    %edi
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80117b:	83 ec 0c             	sub    $0xc,%esp
  80117e:	50                   	push   %eax
  80117f:	6a 03                	push   $0x3
  801181:	68 3f 2b 80 00       	push   $0x802b3f
  801186:	6a 23                	push   $0x23
  801188:	68 5c 2b 80 00       	push   $0x802b5c
  80118d:	e8 4b f5 ff ff       	call   8006dd <_panic>

00801192 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	57                   	push   %edi
  801196:	56                   	push   %esi
  801197:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  801198:	ba 00 00 00 00       	mov    $0x0,%edx
  80119d:	b8 02 00 00 00       	mov    $0x2,%eax
  8011a2:	89 d1                	mov    %edx,%ecx
  8011a4:	89 d3                	mov    %edx,%ebx
  8011a6:	89 d7                	mov    %edx,%edi
  8011a8:	89 d6                	mov    %edx,%esi
  8011aa:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011ac:	5b                   	pop    %ebx
  8011ad:	5e                   	pop    %esi
  8011ae:	5f                   	pop    %edi
  8011af:	5d                   	pop    %ebp
  8011b0:	c3                   	ret    

008011b1 <sys_yield>:

void
sys_yield(void)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	57                   	push   %edi
  8011b5:	56                   	push   %esi
  8011b6:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8011b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011bc:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011c1:	89 d1                	mov    %edx,%ecx
  8011c3:	89 d3                	mov    %edx,%ebx
  8011c5:	89 d7                	mov    %edx,%edi
  8011c7:	89 d6                	mov    %edx,%esi
  8011c9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011cb:	5b                   	pop    %ebx
  8011cc:	5e                   	pop    %esi
  8011cd:	5f                   	pop    %edi
  8011ce:	5d                   	pop    %ebp
  8011cf:	c3                   	ret    

008011d0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	57                   	push   %edi
  8011d4:	56                   	push   %esi
  8011d5:	53                   	push   %ebx
  8011d6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8011d9:	be 00 00 00 00       	mov    $0x0,%esi
  8011de:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e4:	b8 04 00 00 00       	mov    $0x4,%eax
  8011e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011ec:	89 f7                	mov    %esi,%edi
  8011ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	7f 08                	jg     8011fc <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f7:	5b                   	pop    %ebx
  8011f8:	5e                   	pop    %esi
  8011f9:	5f                   	pop    %edi
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fc:	83 ec 0c             	sub    $0xc,%esp
  8011ff:	50                   	push   %eax
  801200:	6a 04                	push   $0x4
  801202:	68 3f 2b 80 00       	push   $0x802b3f
  801207:	6a 23                	push   $0x23
  801209:	68 5c 2b 80 00       	push   $0x802b5c
  80120e:	e8 ca f4 ff ff       	call   8006dd <_panic>

00801213 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	57                   	push   %edi
  801217:	56                   	push   %esi
  801218:	53                   	push   %ebx
  801219:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80121c:	8b 55 08             	mov    0x8(%ebp),%edx
  80121f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801222:	b8 05 00 00 00       	mov    $0x5,%eax
  801227:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80122a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80122d:	8b 75 18             	mov    0x18(%ebp),%esi
  801230:	cd 30                	int    $0x30
	if(check && ret > 0)
  801232:	85 c0                	test   %eax,%eax
  801234:	7f 08                	jg     80123e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801236:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801239:	5b                   	pop    %ebx
  80123a:	5e                   	pop    %esi
  80123b:	5f                   	pop    %edi
  80123c:	5d                   	pop    %ebp
  80123d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80123e:	83 ec 0c             	sub    $0xc,%esp
  801241:	50                   	push   %eax
  801242:	6a 05                	push   $0x5
  801244:	68 3f 2b 80 00       	push   $0x802b3f
  801249:	6a 23                	push   $0x23
  80124b:	68 5c 2b 80 00       	push   $0x802b5c
  801250:	e8 88 f4 ff ff       	call   8006dd <_panic>

00801255 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	57                   	push   %edi
  801259:	56                   	push   %esi
  80125a:	53                   	push   %ebx
  80125b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80125e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801263:	8b 55 08             	mov    0x8(%ebp),%edx
  801266:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801269:	b8 06 00 00 00       	mov    $0x6,%eax
  80126e:	89 df                	mov    %ebx,%edi
  801270:	89 de                	mov    %ebx,%esi
  801272:	cd 30                	int    $0x30
	if(check && ret > 0)
  801274:	85 c0                	test   %eax,%eax
  801276:	7f 08                	jg     801280 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801278:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127b:	5b                   	pop    %ebx
  80127c:	5e                   	pop    %esi
  80127d:	5f                   	pop    %edi
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801280:	83 ec 0c             	sub    $0xc,%esp
  801283:	50                   	push   %eax
  801284:	6a 06                	push   $0x6
  801286:	68 3f 2b 80 00       	push   $0x802b3f
  80128b:	6a 23                	push   $0x23
  80128d:	68 5c 2b 80 00       	push   $0x802b5c
  801292:	e8 46 f4 ff ff       	call   8006dd <_panic>

00801297 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	57                   	push   %edi
  80129b:	56                   	push   %esi
  80129c:	53                   	push   %ebx
  80129d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8012a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ab:	b8 08 00 00 00       	mov    $0x8,%eax
  8012b0:	89 df                	mov    %ebx,%edi
  8012b2:	89 de                	mov    %ebx,%esi
  8012b4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	7f 08                	jg     8012c2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8012ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012bd:	5b                   	pop    %ebx
  8012be:	5e                   	pop    %esi
  8012bf:	5f                   	pop    %edi
  8012c0:	5d                   	pop    %ebp
  8012c1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c2:	83 ec 0c             	sub    $0xc,%esp
  8012c5:	50                   	push   %eax
  8012c6:	6a 08                	push   $0x8
  8012c8:	68 3f 2b 80 00       	push   $0x802b3f
  8012cd:	6a 23                	push   $0x23
  8012cf:	68 5c 2b 80 00       	push   $0x802b5c
  8012d4:	e8 04 f4 ff ff       	call   8006dd <_panic>

008012d9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	57                   	push   %edi
  8012dd:	56                   	push   %esi
  8012de:	53                   	push   %ebx
  8012df:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8012e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ed:	b8 09 00 00 00       	mov    $0x9,%eax
  8012f2:	89 df                	mov    %ebx,%edi
  8012f4:	89 de                	mov    %ebx,%esi
  8012f6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	7f 08                	jg     801304 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ff:	5b                   	pop    %ebx
  801300:	5e                   	pop    %esi
  801301:	5f                   	pop    %edi
  801302:	5d                   	pop    %ebp
  801303:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801304:	83 ec 0c             	sub    $0xc,%esp
  801307:	50                   	push   %eax
  801308:	6a 09                	push   $0x9
  80130a:	68 3f 2b 80 00       	push   $0x802b3f
  80130f:	6a 23                	push   $0x23
  801311:	68 5c 2b 80 00       	push   $0x802b5c
  801316:	e8 c2 f3 ff ff       	call   8006dd <_panic>

0080131b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	57                   	push   %edi
  80131f:	56                   	push   %esi
  801320:	53                   	push   %ebx
  801321:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  801324:	bb 00 00 00 00       	mov    $0x0,%ebx
  801329:	8b 55 08             	mov    0x8(%ebp),%edx
  80132c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80132f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801334:	89 df                	mov    %ebx,%edi
  801336:	89 de                	mov    %ebx,%esi
  801338:	cd 30                	int    $0x30
	if(check && ret > 0)
  80133a:	85 c0                	test   %eax,%eax
  80133c:	7f 08                	jg     801346 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80133e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801341:	5b                   	pop    %ebx
  801342:	5e                   	pop    %esi
  801343:	5f                   	pop    %edi
  801344:	5d                   	pop    %ebp
  801345:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801346:	83 ec 0c             	sub    $0xc,%esp
  801349:	50                   	push   %eax
  80134a:	6a 0a                	push   $0xa
  80134c:	68 3f 2b 80 00       	push   $0x802b3f
  801351:	6a 23                	push   $0x23
  801353:	68 5c 2b 80 00       	push   $0x802b5c
  801358:	e8 80 f3 ff ff       	call   8006dd <_panic>

0080135d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	57                   	push   %edi
  801361:	56                   	push   %esi
  801362:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  801363:	8b 55 08             	mov    0x8(%ebp),%edx
  801366:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801369:	b8 0c 00 00 00       	mov    $0xc,%eax
  80136e:	be 00 00 00 00       	mov    $0x0,%esi
  801373:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801376:	8b 7d 14             	mov    0x14(%ebp),%edi
  801379:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80137b:	5b                   	pop    %ebx
  80137c:	5e                   	pop    %esi
  80137d:	5f                   	pop    %edi
  80137e:	5d                   	pop    %ebp
  80137f:	c3                   	ret    

00801380 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	57                   	push   %edi
  801384:	56                   	push   %esi
  801385:	53                   	push   %ebx
  801386:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  801389:	b9 00 00 00 00       	mov    $0x0,%ecx
  80138e:	8b 55 08             	mov    0x8(%ebp),%edx
  801391:	b8 0d 00 00 00       	mov    $0xd,%eax
  801396:	89 cb                	mov    %ecx,%ebx
  801398:	89 cf                	mov    %ecx,%edi
  80139a:	89 ce                	mov    %ecx,%esi
  80139c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	7f 08                	jg     8013aa <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8013a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a5:	5b                   	pop    %ebx
  8013a6:	5e                   	pop    %esi
  8013a7:	5f                   	pop    %edi
  8013a8:	5d                   	pop    %ebp
  8013a9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013aa:	83 ec 0c             	sub    $0xc,%esp
  8013ad:	50                   	push   %eax
  8013ae:	6a 0d                	push   $0xd
  8013b0:	68 3f 2b 80 00       	push   $0x802b3f
  8013b5:	6a 23                	push   $0x23
  8013b7:	68 5c 2b 80 00       	push   $0x802b5c
  8013bc:	e8 1c f3 ff ff       	call   8006dd <_panic>

008013c1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	56                   	push   %esi
  8013c5:	53                   	push   %ebx
  8013c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  8013cf:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  8013d1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8013d6:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  8013d9:	83 ec 0c             	sub    $0xc,%esp
  8013dc:	50                   	push   %eax
  8013dd:	e8 9e ff ff ff       	call   801380 <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	78 2b                	js     801414 <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  8013e9:	85 f6                	test   %esi,%esi
  8013eb:	74 0a                	je     8013f7 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8013ed:	a1 04 40 80 00       	mov    0x804004,%eax
  8013f2:	8b 40 74             	mov    0x74(%eax),%eax
  8013f5:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  8013f7:	85 db                	test   %ebx,%ebx
  8013f9:	74 0a                	je     801405 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8013fb:	a1 04 40 80 00       	mov    0x804004,%eax
  801400:	8b 40 78             	mov    0x78(%eax),%eax
  801403:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  801405:	a1 04 40 80 00       	mov    0x804004,%eax
  80140a:	8b 40 70             	mov    0x70(%eax),%eax
}
  80140d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801410:	5b                   	pop    %ebx
  801411:	5e                   	pop    %esi
  801412:	5d                   	pop    %ebp
  801413:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  801414:	85 f6                	test   %esi,%esi
  801416:	74 06                	je     80141e <ipc_recv+0x5d>
  801418:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  80141e:	85 db                	test   %ebx,%ebx
  801420:	74 eb                	je     80140d <ipc_recv+0x4c>
  801422:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801428:	eb e3                	jmp    80140d <ipc_recv+0x4c>

0080142a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	57                   	push   %edi
  80142e:	56                   	push   %esi
  80142f:	53                   	push   %ebx
  801430:	83 ec 0c             	sub    $0xc,%esp
  801433:	8b 7d 08             	mov    0x8(%ebp),%edi
  801436:	8b 75 0c             	mov    0xc(%ebp),%esi
  801439:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  80143c:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  80143e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801443:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801446:	ff 75 14             	pushl  0x14(%ebp)
  801449:	53                   	push   %ebx
  80144a:	56                   	push   %esi
  80144b:	57                   	push   %edi
  80144c:	e8 0c ff ff ff       	call   80135d <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  801451:	83 c4 10             	add    $0x10,%esp
  801454:	85 c0                	test   %eax,%eax
  801456:	74 1e                	je     801476 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  801458:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80145b:	75 07                	jne    801464 <ipc_send+0x3a>
			sys_yield();
  80145d:	e8 4f fd ff ff       	call   8011b1 <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  801462:	eb e2                	jmp    801446 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  801464:	50                   	push   %eax
  801465:	68 6a 2b 80 00       	push   $0x802b6a
  80146a:	6a 41                	push   $0x41
  80146c:	68 78 2b 80 00       	push   $0x802b78
  801471:	e8 67 f2 ff ff       	call   8006dd <_panic>
		}
	}
}
  801476:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801479:	5b                   	pop    %ebx
  80147a:	5e                   	pop    %esi
  80147b:	5f                   	pop    %edi
  80147c:	5d                   	pop    %ebp
  80147d:	c3                   	ret    

0080147e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801484:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801489:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80148c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801492:	8b 52 50             	mov    0x50(%edx),%edx
  801495:	39 ca                	cmp    %ecx,%edx
  801497:	74 11                	je     8014aa <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801499:	83 c0 01             	add    $0x1,%eax
  80149c:	3d 00 04 00 00       	cmp    $0x400,%eax
  8014a1:	75 e6                	jne    801489 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8014a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a8:	eb 0b                	jmp    8014b5 <ipc_find_env+0x37>
			return envs[i].env_id;
  8014aa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8014ad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014b2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8014b5:	5d                   	pop    %ebp
  8014b6:	c3                   	ret    

008014b7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	05 00 00 00 30       	add    $0x30000000,%eax
  8014c2:	c1 e8 0c             	shr    $0xc,%eax
}
  8014c5:	5d                   	pop    %ebp
  8014c6:	c3                   	ret    

008014c7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8014d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014d7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014dc:	5d                   	pop    %ebp
  8014dd:	c3                   	ret    

008014de <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014e9:	89 c2                	mov    %eax,%edx
  8014eb:	c1 ea 16             	shr    $0x16,%edx
  8014ee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014f5:	f6 c2 01             	test   $0x1,%dl
  8014f8:	74 2a                	je     801524 <fd_alloc+0x46>
  8014fa:	89 c2                	mov    %eax,%edx
  8014fc:	c1 ea 0c             	shr    $0xc,%edx
  8014ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801506:	f6 c2 01             	test   $0x1,%dl
  801509:	74 19                	je     801524 <fd_alloc+0x46>
  80150b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801510:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801515:	75 d2                	jne    8014e9 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801517:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80151d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801522:	eb 07                	jmp    80152b <fd_alloc+0x4d>
			*fd_store = fd;
  801524:	89 01                	mov    %eax,(%ecx)
			return 0;
  801526:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152b:	5d                   	pop    %ebp
  80152c:	c3                   	ret    

0080152d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801533:	83 f8 1f             	cmp    $0x1f,%eax
  801536:	77 36                	ja     80156e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801538:	c1 e0 0c             	shl    $0xc,%eax
  80153b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801540:	89 c2                	mov    %eax,%edx
  801542:	c1 ea 16             	shr    $0x16,%edx
  801545:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80154c:	f6 c2 01             	test   $0x1,%dl
  80154f:	74 24                	je     801575 <fd_lookup+0x48>
  801551:	89 c2                	mov    %eax,%edx
  801553:	c1 ea 0c             	shr    $0xc,%edx
  801556:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80155d:	f6 c2 01             	test   $0x1,%dl
  801560:	74 1a                	je     80157c <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801562:	8b 55 0c             	mov    0xc(%ebp),%edx
  801565:	89 02                	mov    %eax,(%edx)
	return 0;
  801567:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156c:	5d                   	pop    %ebp
  80156d:	c3                   	ret    
		return -E_INVAL;
  80156e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801573:	eb f7                	jmp    80156c <fd_lookup+0x3f>
		return -E_INVAL;
  801575:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80157a:	eb f0                	jmp    80156c <fd_lookup+0x3f>
  80157c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801581:	eb e9                	jmp    80156c <fd_lookup+0x3f>

00801583 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	83 ec 08             	sub    $0x8,%esp
  801589:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158c:	ba 04 2c 80 00       	mov    $0x802c04,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801591:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801596:	39 08                	cmp    %ecx,(%eax)
  801598:	74 33                	je     8015cd <dev_lookup+0x4a>
  80159a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80159d:	8b 02                	mov    (%edx),%eax
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	75 f3                	jne    801596 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015a3:	a1 04 40 80 00       	mov    0x804004,%eax
  8015a8:	8b 40 48             	mov    0x48(%eax),%eax
  8015ab:	83 ec 04             	sub    $0x4,%esp
  8015ae:	51                   	push   %ecx
  8015af:	50                   	push   %eax
  8015b0:	68 84 2b 80 00       	push   $0x802b84
  8015b5:	e8 fe f1 ff ff       	call   8007b8 <cprintf>
	*dev = 0;
  8015ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    
			*dev = devtab[i];
  8015cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015d0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d7:	eb f2                	jmp    8015cb <dev_lookup+0x48>

008015d9 <fd_close>:
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	57                   	push   %edi
  8015dd:	56                   	push   %esi
  8015de:	53                   	push   %ebx
  8015df:	83 ec 1c             	sub    $0x1c,%esp
  8015e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8015e5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015e8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015eb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015ec:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015f2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015f5:	50                   	push   %eax
  8015f6:	e8 32 ff ff ff       	call   80152d <fd_lookup>
  8015fb:	89 c3                	mov    %eax,%ebx
  8015fd:	83 c4 08             	add    $0x8,%esp
  801600:	85 c0                	test   %eax,%eax
  801602:	78 05                	js     801609 <fd_close+0x30>
	    || fd != fd2)
  801604:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801607:	74 16                	je     80161f <fd_close+0x46>
		return (must_exist ? r : 0);
  801609:	89 f8                	mov    %edi,%eax
  80160b:	84 c0                	test   %al,%al
  80160d:	b8 00 00 00 00       	mov    $0x0,%eax
  801612:	0f 44 d8             	cmove  %eax,%ebx
}
  801615:	89 d8                	mov    %ebx,%eax
  801617:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80161a:	5b                   	pop    %ebx
  80161b:	5e                   	pop    %esi
  80161c:	5f                   	pop    %edi
  80161d:	5d                   	pop    %ebp
  80161e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801625:	50                   	push   %eax
  801626:	ff 36                	pushl  (%esi)
  801628:	e8 56 ff ff ff       	call   801583 <dev_lookup>
  80162d:	89 c3                	mov    %eax,%ebx
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	85 c0                	test   %eax,%eax
  801634:	78 15                	js     80164b <fd_close+0x72>
		if (dev->dev_close)
  801636:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801639:	8b 40 10             	mov    0x10(%eax),%eax
  80163c:	85 c0                	test   %eax,%eax
  80163e:	74 1b                	je     80165b <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801640:	83 ec 0c             	sub    $0xc,%esp
  801643:	56                   	push   %esi
  801644:	ff d0                	call   *%eax
  801646:	89 c3                	mov    %eax,%ebx
  801648:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80164b:	83 ec 08             	sub    $0x8,%esp
  80164e:	56                   	push   %esi
  80164f:	6a 00                	push   $0x0
  801651:	e8 ff fb ff ff       	call   801255 <sys_page_unmap>
	return r;
  801656:	83 c4 10             	add    $0x10,%esp
  801659:	eb ba                	jmp    801615 <fd_close+0x3c>
			r = 0;
  80165b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801660:	eb e9                	jmp    80164b <fd_close+0x72>

00801662 <close>:

int
close(int fdnum)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801668:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166b:	50                   	push   %eax
  80166c:	ff 75 08             	pushl  0x8(%ebp)
  80166f:	e8 b9 fe ff ff       	call   80152d <fd_lookup>
  801674:	83 c4 08             	add    $0x8,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	78 10                	js     80168b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	6a 01                	push   $0x1
  801680:	ff 75 f4             	pushl  -0xc(%ebp)
  801683:	e8 51 ff ff ff       	call   8015d9 <fd_close>
  801688:	83 c4 10             	add    $0x10,%esp
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <close_all>:

void
close_all(void)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	53                   	push   %ebx
  801691:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801694:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801699:	83 ec 0c             	sub    $0xc,%esp
  80169c:	53                   	push   %ebx
  80169d:	e8 c0 ff ff ff       	call   801662 <close>
	for (i = 0; i < MAXFD; i++)
  8016a2:	83 c3 01             	add    $0x1,%ebx
  8016a5:	83 c4 10             	add    $0x10,%esp
  8016a8:	83 fb 20             	cmp    $0x20,%ebx
  8016ab:	75 ec                	jne    801699 <close_all+0xc>
}
  8016ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	57                   	push   %edi
  8016b6:	56                   	push   %esi
  8016b7:	53                   	push   %ebx
  8016b8:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016be:	50                   	push   %eax
  8016bf:	ff 75 08             	pushl  0x8(%ebp)
  8016c2:	e8 66 fe ff ff       	call   80152d <fd_lookup>
  8016c7:	89 c3                	mov    %eax,%ebx
  8016c9:	83 c4 08             	add    $0x8,%esp
  8016cc:	85 c0                	test   %eax,%eax
  8016ce:	0f 88 81 00 00 00    	js     801755 <dup+0xa3>
		return r;
	close(newfdnum);
  8016d4:	83 ec 0c             	sub    $0xc,%esp
  8016d7:	ff 75 0c             	pushl  0xc(%ebp)
  8016da:	e8 83 ff ff ff       	call   801662 <close>

	newfd = INDEX2FD(newfdnum);
  8016df:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016e2:	c1 e6 0c             	shl    $0xc,%esi
  8016e5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016eb:	83 c4 04             	add    $0x4,%esp
  8016ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016f1:	e8 d1 fd ff ff       	call   8014c7 <fd2data>
  8016f6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016f8:	89 34 24             	mov    %esi,(%esp)
  8016fb:	e8 c7 fd ff ff       	call   8014c7 <fd2data>
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801705:	89 d8                	mov    %ebx,%eax
  801707:	c1 e8 16             	shr    $0x16,%eax
  80170a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801711:	a8 01                	test   $0x1,%al
  801713:	74 11                	je     801726 <dup+0x74>
  801715:	89 d8                	mov    %ebx,%eax
  801717:	c1 e8 0c             	shr    $0xc,%eax
  80171a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801721:	f6 c2 01             	test   $0x1,%dl
  801724:	75 39                	jne    80175f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801726:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801729:	89 d0                	mov    %edx,%eax
  80172b:	c1 e8 0c             	shr    $0xc,%eax
  80172e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801735:	83 ec 0c             	sub    $0xc,%esp
  801738:	25 07 0e 00 00       	and    $0xe07,%eax
  80173d:	50                   	push   %eax
  80173e:	56                   	push   %esi
  80173f:	6a 00                	push   $0x0
  801741:	52                   	push   %edx
  801742:	6a 00                	push   $0x0
  801744:	e8 ca fa ff ff       	call   801213 <sys_page_map>
  801749:	89 c3                	mov    %eax,%ebx
  80174b:	83 c4 20             	add    $0x20,%esp
  80174e:	85 c0                	test   %eax,%eax
  801750:	78 31                	js     801783 <dup+0xd1>
		goto err;

	return newfdnum;
  801752:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801755:	89 d8                	mov    %ebx,%eax
  801757:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80175a:	5b                   	pop    %ebx
  80175b:	5e                   	pop    %esi
  80175c:	5f                   	pop    %edi
  80175d:	5d                   	pop    %ebp
  80175e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80175f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801766:	83 ec 0c             	sub    $0xc,%esp
  801769:	25 07 0e 00 00       	and    $0xe07,%eax
  80176e:	50                   	push   %eax
  80176f:	57                   	push   %edi
  801770:	6a 00                	push   $0x0
  801772:	53                   	push   %ebx
  801773:	6a 00                	push   $0x0
  801775:	e8 99 fa ff ff       	call   801213 <sys_page_map>
  80177a:	89 c3                	mov    %eax,%ebx
  80177c:	83 c4 20             	add    $0x20,%esp
  80177f:	85 c0                	test   %eax,%eax
  801781:	79 a3                	jns    801726 <dup+0x74>
	sys_page_unmap(0, newfd);
  801783:	83 ec 08             	sub    $0x8,%esp
  801786:	56                   	push   %esi
  801787:	6a 00                	push   $0x0
  801789:	e8 c7 fa ff ff       	call   801255 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80178e:	83 c4 08             	add    $0x8,%esp
  801791:	57                   	push   %edi
  801792:	6a 00                	push   $0x0
  801794:	e8 bc fa ff ff       	call   801255 <sys_page_unmap>
	return r;
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	eb b7                	jmp    801755 <dup+0xa3>

0080179e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	53                   	push   %ebx
  8017a2:	83 ec 14             	sub    $0x14,%esp
  8017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ab:	50                   	push   %eax
  8017ac:	53                   	push   %ebx
  8017ad:	e8 7b fd ff ff       	call   80152d <fd_lookup>
  8017b2:	83 c4 08             	add    $0x8,%esp
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	78 3f                	js     8017f8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017b9:	83 ec 08             	sub    $0x8,%esp
  8017bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017bf:	50                   	push   %eax
  8017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c3:	ff 30                	pushl  (%eax)
  8017c5:	e8 b9 fd ff ff       	call   801583 <dev_lookup>
  8017ca:	83 c4 10             	add    $0x10,%esp
  8017cd:	85 c0                	test   %eax,%eax
  8017cf:	78 27                	js     8017f8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d4:	8b 42 08             	mov    0x8(%edx),%eax
  8017d7:	83 e0 03             	and    $0x3,%eax
  8017da:	83 f8 01             	cmp    $0x1,%eax
  8017dd:	74 1e                	je     8017fd <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e2:	8b 40 08             	mov    0x8(%eax),%eax
  8017e5:	85 c0                	test   %eax,%eax
  8017e7:	74 35                	je     80181e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017e9:	83 ec 04             	sub    $0x4,%esp
  8017ec:	ff 75 10             	pushl  0x10(%ebp)
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	52                   	push   %edx
  8017f3:	ff d0                	call   *%eax
  8017f5:	83 c4 10             	add    $0x10,%esp
}
  8017f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017fd:	a1 04 40 80 00       	mov    0x804004,%eax
  801802:	8b 40 48             	mov    0x48(%eax),%eax
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	53                   	push   %ebx
  801809:	50                   	push   %eax
  80180a:	68 c8 2b 80 00       	push   $0x802bc8
  80180f:	e8 a4 ef ff ff       	call   8007b8 <cprintf>
		return -E_INVAL;
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80181c:	eb da                	jmp    8017f8 <read+0x5a>
		return -E_NOT_SUPP;
  80181e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801823:	eb d3                	jmp    8017f8 <read+0x5a>

00801825 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	57                   	push   %edi
  801829:	56                   	push   %esi
  80182a:	53                   	push   %ebx
  80182b:	83 ec 0c             	sub    $0xc,%esp
  80182e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801831:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801834:	bb 00 00 00 00       	mov    $0x0,%ebx
  801839:	39 f3                	cmp    %esi,%ebx
  80183b:	73 25                	jae    801862 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80183d:	83 ec 04             	sub    $0x4,%esp
  801840:	89 f0                	mov    %esi,%eax
  801842:	29 d8                	sub    %ebx,%eax
  801844:	50                   	push   %eax
  801845:	89 d8                	mov    %ebx,%eax
  801847:	03 45 0c             	add    0xc(%ebp),%eax
  80184a:	50                   	push   %eax
  80184b:	57                   	push   %edi
  80184c:	e8 4d ff ff ff       	call   80179e <read>
		if (m < 0)
  801851:	83 c4 10             	add    $0x10,%esp
  801854:	85 c0                	test   %eax,%eax
  801856:	78 08                	js     801860 <readn+0x3b>
			return m;
		if (m == 0)
  801858:	85 c0                	test   %eax,%eax
  80185a:	74 06                	je     801862 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80185c:	01 c3                	add    %eax,%ebx
  80185e:	eb d9                	jmp    801839 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801860:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801862:	89 d8                	mov    %ebx,%eax
  801864:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801867:	5b                   	pop    %ebx
  801868:	5e                   	pop    %esi
  801869:	5f                   	pop    %edi
  80186a:	5d                   	pop    %ebp
  80186b:	c3                   	ret    

0080186c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	53                   	push   %ebx
  801870:	83 ec 14             	sub    $0x14,%esp
  801873:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801876:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801879:	50                   	push   %eax
  80187a:	53                   	push   %ebx
  80187b:	e8 ad fc ff ff       	call   80152d <fd_lookup>
  801880:	83 c4 08             	add    $0x8,%esp
  801883:	85 c0                	test   %eax,%eax
  801885:	78 3a                	js     8018c1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801887:	83 ec 08             	sub    $0x8,%esp
  80188a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188d:	50                   	push   %eax
  80188e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801891:	ff 30                	pushl  (%eax)
  801893:	e8 eb fc ff ff       	call   801583 <dev_lookup>
  801898:	83 c4 10             	add    $0x10,%esp
  80189b:	85 c0                	test   %eax,%eax
  80189d:	78 22                	js     8018c1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018a6:	74 1e                	je     8018c6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ab:	8b 52 0c             	mov    0xc(%edx),%edx
  8018ae:	85 d2                	test   %edx,%edx
  8018b0:	74 35                	je     8018e7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018b2:	83 ec 04             	sub    $0x4,%esp
  8018b5:	ff 75 10             	pushl  0x10(%ebp)
  8018b8:	ff 75 0c             	pushl  0xc(%ebp)
  8018bb:	50                   	push   %eax
  8018bc:	ff d2                	call   *%edx
  8018be:	83 c4 10             	add    $0x10,%esp
}
  8018c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8018cb:	8b 40 48             	mov    0x48(%eax),%eax
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	53                   	push   %ebx
  8018d2:	50                   	push   %eax
  8018d3:	68 e4 2b 80 00       	push   $0x802be4
  8018d8:	e8 db ee ff ff       	call   8007b8 <cprintf>
		return -E_INVAL;
  8018dd:	83 c4 10             	add    $0x10,%esp
  8018e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018e5:	eb da                	jmp    8018c1 <write+0x55>
		return -E_NOT_SUPP;
  8018e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018ec:	eb d3                	jmp    8018c1 <write+0x55>

008018ee <seek>:

int
seek(int fdnum, off_t offset)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018f4:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018f7:	50                   	push   %eax
  8018f8:	ff 75 08             	pushl  0x8(%ebp)
  8018fb:	e8 2d fc ff ff       	call   80152d <fd_lookup>
  801900:	83 c4 08             	add    $0x8,%esp
  801903:	85 c0                	test   %eax,%eax
  801905:	78 0e                	js     801915 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801907:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80190d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801910:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	53                   	push   %ebx
  80191b:	83 ec 14             	sub    $0x14,%esp
  80191e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801921:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801924:	50                   	push   %eax
  801925:	53                   	push   %ebx
  801926:	e8 02 fc ff ff       	call   80152d <fd_lookup>
  80192b:	83 c4 08             	add    $0x8,%esp
  80192e:	85 c0                	test   %eax,%eax
  801930:	78 37                	js     801969 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801932:	83 ec 08             	sub    $0x8,%esp
  801935:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801938:	50                   	push   %eax
  801939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193c:	ff 30                	pushl  (%eax)
  80193e:	e8 40 fc ff ff       	call   801583 <dev_lookup>
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	85 c0                	test   %eax,%eax
  801948:	78 1f                	js     801969 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80194a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801951:	74 1b                	je     80196e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801953:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801956:	8b 52 18             	mov    0x18(%edx),%edx
  801959:	85 d2                	test   %edx,%edx
  80195b:	74 32                	je     80198f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80195d:	83 ec 08             	sub    $0x8,%esp
  801960:	ff 75 0c             	pushl  0xc(%ebp)
  801963:	50                   	push   %eax
  801964:	ff d2                	call   *%edx
  801966:	83 c4 10             	add    $0x10,%esp
}
  801969:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80196e:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801973:	8b 40 48             	mov    0x48(%eax),%eax
  801976:	83 ec 04             	sub    $0x4,%esp
  801979:	53                   	push   %ebx
  80197a:	50                   	push   %eax
  80197b:	68 a4 2b 80 00       	push   $0x802ba4
  801980:	e8 33 ee ff ff       	call   8007b8 <cprintf>
		return -E_INVAL;
  801985:	83 c4 10             	add    $0x10,%esp
  801988:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80198d:	eb da                	jmp    801969 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80198f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801994:	eb d3                	jmp    801969 <ftruncate+0x52>

00801996 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	53                   	push   %ebx
  80199a:	83 ec 14             	sub    $0x14,%esp
  80199d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a3:	50                   	push   %eax
  8019a4:	ff 75 08             	pushl  0x8(%ebp)
  8019a7:	e8 81 fb ff ff       	call   80152d <fd_lookup>
  8019ac:	83 c4 08             	add    $0x8,%esp
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	78 4b                	js     8019fe <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b3:	83 ec 08             	sub    $0x8,%esp
  8019b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b9:	50                   	push   %eax
  8019ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bd:	ff 30                	pushl  (%eax)
  8019bf:	e8 bf fb ff ff       	call   801583 <dev_lookup>
  8019c4:	83 c4 10             	add    $0x10,%esp
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	78 33                	js     8019fe <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8019cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ce:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019d2:	74 2f                	je     801a03 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019d4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019d7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019de:	00 00 00 
	stat->st_isdir = 0;
  8019e1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019e8:	00 00 00 
	stat->st_dev = dev;
  8019eb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019f1:	83 ec 08             	sub    $0x8,%esp
  8019f4:	53                   	push   %ebx
  8019f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8019f8:	ff 50 14             	call   *0x14(%eax)
  8019fb:	83 c4 10             	add    $0x10,%esp
}
  8019fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    
		return -E_NOT_SUPP;
  801a03:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a08:	eb f4                	jmp    8019fe <fstat+0x68>

00801a0a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	56                   	push   %esi
  801a0e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a0f:	83 ec 08             	sub    $0x8,%esp
  801a12:	6a 00                	push   $0x0
  801a14:	ff 75 08             	pushl  0x8(%ebp)
  801a17:	e8 30 02 00 00       	call   801c4c <open>
  801a1c:	89 c3                	mov    %eax,%ebx
  801a1e:	83 c4 10             	add    $0x10,%esp
  801a21:	85 c0                	test   %eax,%eax
  801a23:	78 1b                	js     801a40 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a25:	83 ec 08             	sub    $0x8,%esp
  801a28:	ff 75 0c             	pushl  0xc(%ebp)
  801a2b:	50                   	push   %eax
  801a2c:	e8 65 ff ff ff       	call   801996 <fstat>
  801a31:	89 c6                	mov    %eax,%esi
	close(fd);
  801a33:	89 1c 24             	mov    %ebx,(%esp)
  801a36:	e8 27 fc ff ff       	call   801662 <close>
	return r;
  801a3b:	83 c4 10             	add    $0x10,%esp
  801a3e:	89 f3                	mov    %esi,%ebx
}
  801a40:	89 d8                	mov    %ebx,%eax
  801a42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a45:	5b                   	pop    %ebx
  801a46:	5e                   	pop    %esi
  801a47:	5d                   	pop    %ebp
  801a48:	c3                   	ret    

00801a49 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	56                   	push   %esi
  801a4d:	53                   	push   %ebx
  801a4e:	89 c6                	mov    %eax,%esi
  801a50:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a52:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801a59:	74 27                	je     801a82 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a5b:	6a 07                	push   $0x7
  801a5d:	68 00 50 80 00       	push   $0x805000
  801a62:	56                   	push   %esi
  801a63:	ff 35 00 40 80 00    	pushl  0x804000
  801a69:	e8 bc f9 ff ff       	call   80142a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a6e:	83 c4 0c             	add    $0xc,%esp
  801a71:	6a 00                	push   $0x0
  801a73:	53                   	push   %ebx
  801a74:	6a 00                	push   $0x0
  801a76:	e8 46 f9 ff ff       	call   8013c1 <ipc_recv>
}
  801a7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a7e:	5b                   	pop    %ebx
  801a7f:	5e                   	pop    %esi
  801a80:	5d                   	pop    %ebp
  801a81:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a82:	83 ec 0c             	sub    $0xc,%esp
  801a85:	6a 01                	push   $0x1
  801a87:	e8 f2 f9 ff ff       	call   80147e <ipc_find_env>
  801a8c:	a3 00 40 80 00       	mov    %eax,0x804000
  801a91:	83 c4 10             	add    $0x10,%esp
  801a94:	eb c5                	jmp    801a5b <fsipc+0x12>

00801a96 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801aaf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab4:	b8 02 00 00 00       	mov    $0x2,%eax
  801ab9:	e8 8b ff ff ff       	call   801a49 <fsipc>
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <devfile_flush>:
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	8b 40 0c             	mov    0xc(%eax),%eax
  801acc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801ad1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad6:	b8 06 00 00 00       	mov    $0x6,%eax
  801adb:	e8 69 ff ff ff       	call   801a49 <fsipc>
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <devfile_stat>:
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	53                   	push   %ebx
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	8b 40 0c             	mov    0xc(%eax),%eax
  801af2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801af7:	ba 00 00 00 00       	mov    $0x0,%edx
  801afc:	b8 05 00 00 00       	mov    $0x5,%eax
  801b01:	e8 43 ff ff ff       	call   801a49 <fsipc>
  801b06:	85 c0                	test   %eax,%eax
  801b08:	78 2c                	js     801b36 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b0a:	83 ec 08             	sub    $0x8,%esp
  801b0d:	68 00 50 80 00       	push   $0x805000
  801b12:	53                   	push   %ebx
  801b13:	e8 bf f2 ff ff       	call   800dd7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b18:	a1 80 50 80 00       	mov    0x805080,%eax
  801b1d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b23:	a1 84 50 80 00       	mov    0x805084,%eax
  801b28:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b2e:	83 c4 10             	add    $0x10,%esp
  801b31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <devfile_write>:
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	53                   	push   %ebx
  801b3f:	83 ec 08             	sub    $0x8,%esp
  801b42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  801b45:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801b4b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801b50:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	8b 40 0c             	mov    0xc(%eax),%eax
  801b59:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801b5e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801b64:	53                   	push   %ebx
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	68 08 50 80 00       	push   $0x805008
  801b6d:	e8 f3 f3 ff ff       	call   800f65 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b72:	ba 00 00 00 00       	mov    $0x0,%edx
  801b77:	b8 04 00 00 00       	mov    $0x4,%eax
  801b7c:	e8 c8 fe ff ff       	call   801a49 <fsipc>
  801b81:	83 c4 10             	add    $0x10,%esp
  801b84:	85 c0                	test   %eax,%eax
  801b86:	78 0b                	js     801b93 <devfile_write+0x58>
	assert(r <= n);
  801b88:	39 d8                	cmp    %ebx,%eax
  801b8a:	77 0c                	ja     801b98 <devfile_write+0x5d>
	assert(r <= PGSIZE);
  801b8c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b91:	7f 1e                	jg     801bb1 <devfile_write+0x76>
}
  801b93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    
	assert(r <= n);
  801b98:	68 14 2c 80 00       	push   $0x802c14
  801b9d:	68 1b 2c 80 00       	push   $0x802c1b
  801ba2:	68 98 00 00 00       	push   $0x98
  801ba7:	68 30 2c 80 00       	push   $0x802c30
  801bac:	e8 2c eb ff ff       	call   8006dd <_panic>
	assert(r <= PGSIZE);
  801bb1:	68 3b 2c 80 00       	push   $0x802c3b
  801bb6:	68 1b 2c 80 00       	push   $0x802c1b
  801bbb:	68 99 00 00 00       	push   $0x99
  801bc0:	68 30 2c 80 00       	push   $0x802c30
  801bc5:	e8 13 eb ff ff       	call   8006dd <_panic>

00801bca <devfile_read>:
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	56                   	push   %esi
  801bce:	53                   	push   %ebx
  801bcf:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801bdd:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801be3:	ba 00 00 00 00       	mov    $0x0,%edx
  801be8:	b8 03 00 00 00       	mov    $0x3,%eax
  801bed:	e8 57 fe ff ff       	call   801a49 <fsipc>
  801bf2:	89 c3                	mov    %eax,%ebx
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	78 1f                	js     801c17 <devfile_read+0x4d>
	assert(r <= n);
  801bf8:	39 f0                	cmp    %esi,%eax
  801bfa:	77 24                	ja     801c20 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801bfc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c01:	7f 33                	jg     801c36 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c03:	83 ec 04             	sub    $0x4,%esp
  801c06:	50                   	push   %eax
  801c07:	68 00 50 80 00       	push   $0x805000
  801c0c:	ff 75 0c             	pushl  0xc(%ebp)
  801c0f:	e8 51 f3 ff ff       	call   800f65 <memmove>
	return r;
  801c14:	83 c4 10             	add    $0x10,%esp
}
  801c17:	89 d8                	mov    %ebx,%eax
  801c19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1c:	5b                   	pop    %ebx
  801c1d:	5e                   	pop    %esi
  801c1e:	5d                   	pop    %ebp
  801c1f:	c3                   	ret    
	assert(r <= n);
  801c20:	68 14 2c 80 00       	push   $0x802c14
  801c25:	68 1b 2c 80 00       	push   $0x802c1b
  801c2a:	6a 7c                	push   $0x7c
  801c2c:	68 30 2c 80 00       	push   $0x802c30
  801c31:	e8 a7 ea ff ff       	call   8006dd <_panic>
	assert(r <= PGSIZE);
  801c36:	68 3b 2c 80 00       	push   $0x802c3b
  801c3b:	68 1b 2c 80 00       	push   $0x802c1b
  801c40:	6a 7d                	push   $0x7d
  801c42:	68 30 2c 80 00       	push   $0x802c30
  801c47:	e8 91 ea ff ff       	call   8006dd <_panic>

00801c4c <open>:
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	56                   	push   %esi
  801c50:	53                   	push   %ebx
  801c51:	83 ec 1c             	sub    $0x1c,%esp
  801c54:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c57:	56                   	push   %esi
  801c58:	e8 43 f1 ff ff       	call   800da0 <strlen>
  801c5d:	83 c4 10             	add    $0x10,%esp
  801c60:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c65:	7f 6c                	jg     801cd3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801c67:	83 ec 0c             	sub    $0xc,%esp
  801c6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c6d:	50                   	push   %eax
  801c6e:	e8 6b f8 ff ff       	call   8014de <fd_alloc>
  801c73:	89 c3                	mov    %eax,%ebx
  801c75:	83 c4 10             	add    $0x10,%esp
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	78 3c                	js     801cb8 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801c7c:	83 ec 08             	sub    $0x8,%esp
  801c7f:	56                   	push   %esi
  801c80:	68 00 50 80 00       	push   $0x805000
  801c85:	e8 4d f1 ff ff       	call   800dd7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c95:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9a:	e8 aa fd ff ff       	call   801a49 <fsipc>
  801c9f:	89 c3                	mov    %eax,%ebx
  801ca1:	83 c4 10             	add    $0x10,%esp
  801ca4:	85 c0                	test   %eax,%eax
  801ca6:	78 19                	js     801cc1 <open+0x75>
	return fd2num(fd);
  801ca8:	83 ec 0c             	sub    $0xc,%esp
  801cab:	ff 75 f4             	pushl  -0xc(%ebp)
  801cae:	e8 04 f8 ff ff       	call   8014b7 <fd2num>
  801cb3:	89 c3                	mov    %eax,%ebx
  801cb5:	83 c4 10             	add    $0x10,%esp
}
  801cb8:	89 d8                	mov    %ebx,%eax
  801cba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cbd:	5b                   	pop    %ebx
  801cbe:	5e                   	pop    %esi
  801cbf:	5d                   	pop    %ebp
  801cc0:	c3                   	ret    
		fd_close(fd, 0);
  801cc1:	83 ec 08             	sub    $0x8,%esp
  801cc4:	6a 00                	push   $0x0
  801cc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc9:	e8 0b f9 ff ff       	call   8015d9 <fd_close>
		return r;
  801cce:	83 c4 10             	add    $0x10,%esp
  801cd1:	eb e5                	jmp    801cb8 <open+0x6c>
		return -E_BAD_PATH;
  801cd3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cd8:	eb de                	jmp    801cb8 <open+0x6c>

00801cda <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ce0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce5:	b8 08 00 00 00       	mov    $0x8,%eax
  801cea:	e8 5a fd ff ff       	call   801a49 <fsipc>
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	56                   	push   %esi
  801cf5:	53                   	push   %ebx
  801cf6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cf9:	83 ec 0c             	sub    $0xc,%esp
  801cfc:	ff 75 08             	pushl  0x8(%ebp)
  801cff:	e8 c3 f7 ff ff       	call   8014c7 <fd2data>
  801d04:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d06:	83 c4 08             	add    $0x8,%esp
  801d09:	68 47 2c 80 00       	push   $0x802c47
  801d0e:	53                   	push   %ebx
  801d0f:	e8 c3 f0 ff ff       	call   800dd7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d14:	8b 46 04             	mov    0x4(%esi),%eax
  801d17:	2b 06                	sub    (%esi),%eax
  801d19:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d1f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d26:	00 00 00 
	stat->st_dev = &devpipe;
  801d29:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801d30:	30 80 00 
	return 0;
}
  801d33:	b8 00 00 00 00       	mov    $0x0,%eax
  801d38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5e                   	pop    %esi
  801d3d:	5d                   	pop    %ebp
  801d3e:	c3                   	ret    

00801d3f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	53                   	push   %ebx
  801d43:	83 ec 0c             	sub    $0xc,%esp
  801d46:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d49:	53                   	push   %ebx
  801d4a:	6a 00                	push   $0x0
  801d4c:	e8 04 f5 ff ff       	call   801255 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d51:	89 1c 24             	mov    %ebx,(%esp)
  801d54:	e8 6e f7 ff ff       	call   8014c7 <fd2data>
  801d59:	83 c4 08             	add    $0x8,%esp
  801d5c:	50                   	push   %eax
  801d5d:	6a 00                	push   $0x0
  801d5f:	e8 f1 f4 ff ff       	call   801255 <sys_page_unmap>
}
  801d64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <_pipeisclosed>:
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	57                   	push   %edi
  801d6d:	56                   	push   %esi
  801d6e:	53                   	push   %ebx
  801d6f:	83 ec 1c             	sub    $0x1c,%esp
  801d72:	89 c7                	mov    %eax,%edi
  801d74:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d76:	a1 04 40 80 00       	mov    0x804004,%eax
  801d7b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d7e:	83 ec 0c             	sub    $0xc,%esp
  801d81:	57                   	push   %edi
  801d82:	e8 34 04 00 00       	call   8021bb <pageref>
  801d87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d8a:	89 34 24             	mov    %esi,(%esp)
  801d8d:	e8 29 04 00 00       	call   8021bb <pageref>
		nn = thisenv->env_runs;
  801d92:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801d98:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	39 cb                	cmp    %ecx,%ebx
  801da0:	74 1b                	je     801dbd <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801da2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801da5:	75 cf                	jne    801d76 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801da7:	8b 42 58             	mov    0x58(%edx),%eax
  801daa:	6a 01                	push   $0x1
  801dac:	50                   	push   %eax
  801dad:	53                   	push   %ebx
  801dae:	68 4e 2c 80 00       	push   $0x802c4e
  801db3:	e8 00 ea ff ff       	call   8007b8 <cprintf>
  801db8:	83 c4 10             	add    $0x10,%esp
  801dbb:	eb b9                	jmp    801d76 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dbd:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dc0:	0f 94 c0             	sete   %al
  801dc3:	0f b6 c0             	movzbl %al,%eax
}
  801dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc9:	5b                   	pop    %ebx
  801dca:	5e                   	pop    %esi
  801dcb:	5f                   	pop    %edi
  801dcc:	5d                   	pop    %ebp
  801dcd:	c3                   	ret    

00801dce <devpipe_write>:
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	57                   	push   %edi
  801dd2:	56                   	push   %esi
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 28             	sub    $0x28,%esp
  801dd7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dda:	56                   	push   %esi
  801ddb:	e8 e7 f6 ff ff       	call   8014c7 <fd2data>
  801de0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801de2:	83 c4 10             	add    $0x10,%esp
  801de5:	bf 00 00 00 00       	mov    $0x0,%edi
  801dea:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ded:	74 4f                	je     801e3e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801def:	8b 43 04             	mov    0x4(%ebx),%eax
  801df2:	8b 0b                	mov    (%ebx),%ecx
  801df4:	8d 51 20             	lea    0x20(%ecx),%edx
  801df7:	39 d0                	cmp    %edx,%eax
  801df9:	72 14                	jb     801e0f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dfb:	89 da                	mov    %ebx,%edx
  801dfd:	89 f0                	mov    %esi,%eax
  801dff:	e8 65 ff ff ff       	call   801d69 <_pipeisclosed>
  801e04:	85 c0                	test   %eax,%eax
  801e06:	75 3a                	jne    801e42 <devpipe_write+0x74>
			sys_yield();
  801e08:	e8 a4 f3 ff ff       	call   8011b1 <sys_yield>
  801e0d:	eb e0                	jmp    801def <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e12:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e16:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e19:	89 c2                	mov    %eax,%edx
  801e1b:	c1 fa 1f             	sar    $0x1f,%edx
  801e1e:	89 d1                	mov    %edx,%ecx
  801e20:	c1 e9 1b             	shr    $0x1b,%ecx
  801e23:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e26:	83 e2 1f             	and    $0x1f,%edx
  801e29:	29 ca                	sub    %ecx,%edx
  801e2b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e2f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e33:	83 c0 01             	add    $0x1,%eax
  801e36:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e39:	83 c7 01             	add    $0x1,%edi
  801e3c:	eb ac                	jmp    801dea <devpipe_write+0x1c>
	return i;
  801e3e:	89 f8                	mov    %edi,%eax
  801e40:	eb 05                	jmp    801e47 <devpipe_write+0x79>
				return 0;
  801e42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4a:	5b                   	pop    %ebx
  801e4b:	5e                   	pop    %esi
  801e4c:	5f                   	pop    %edi
  801e4d:	5d                   	pop    %ebp
  801e4e:	c3                   	ret    

00801e4f <devpipe_read>:
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	57                   	push   %edi
  801e53:	56                   	push   %esi
  801e54:	53                   	push   %ebx
  801e55:	83 ec 18             	sub    $0x18,%esp
  801e58:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e5b:	57                   	push   %edi
  801e5c:	e8 66 f6 ff ff       	call   8014c7 <fd2data>
  801e61:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e63:	83 c4 10             	add    $0x10,%esp
  801e66:	be 00 00 00 00       	mov    $0x0,%esi
  801e6b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e6e:	74 47                	je     801eb7 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801e70:	8b 03                	mov    (%ebx),%eax
  801e72:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e75:	75 22                	jne    801e99 <devpipe_read+0x4a>
			if (i > 0)
  801e77:	85 f6                	test   %esi,%esi
  801e79:	75 14                	jne    801e8f <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801e7b:	89 da                	mov    %ebx,%edx
  801e7d:	89 f8                	mov    %edi,%eax
  801e7f:	e8 e5 fe ff ff       	call   801d69 <_pipeisclosed>
  801e84:	85 c0                	test   %eax,%eax
  801e86:	75 33                	jne    801ebb <devpipe_read+0x6c>
			sys_yield();
  801e88:	e8 24 f3 ff ff       	call   8011b1 <sys_yield>
  801e8d:	eb e1                	jmp    801e70 <devpipe_read+0x21>
				return i;
  801e8f:	89 f0                	mov    %esi,%eax
}
  801e91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e94:	5b                   	pop    %ebx
  801e95:	5e                   	pop    %esi
  801e96:	5f                   	pop    %edi
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e99:	99                   	cltd   
  801e9a:	c1 ea 1b             	shr    $0x1b,%edx
  801e9d:	01 d0                	add    %edx,%eax
  801e9f:	83 e0 1f             	and    $0x1f,%eax
  801ea2:	29 d0                	sub    %edx,%eax
  801ea4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ea9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eac:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801eaf:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801eb2:	83 c6 01             	add    $0x1,%esi
  801eb5:	eb b4                	jmp    801e6b <devpipe_read+0x1c>
	return i;
  801eb7:	89 f0                	mov    %esi,%eax
  801eb9:	eb d6                	jmp    801e91 <devpipe_read+0x42>
				return 0;
  801ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec0:	eb cf                	jmp    801e91 <devpipe_read+0x42>

00801ec2 <pipe>:
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	56                   	push   %esi
  801ec6:	53                   	push   %ebx
  801ec7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801eca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ecd:	50                   	push   %eax
  801ece:	e8 0b f6 ff ff       	call   8014de <fd_alloc>
  801ed3:	89 c3                	mov    %eax,%ebx
  801ed5:	83 c4 10             	add    $0x10,%esp
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	78 5b                	js     801f37 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801edc:	83 ec 04             	sub    $0x4,%esp
  801edf:	68 07 04 00 00       	push   $0x407
  801ee4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee7:	6a 00                	push   $0x0
  801ee9:	e8 e2 f2 ff ff       	call   8011d0 <sys_page_alloc>
  801eee:	89 c3                	mov    %eax,%ebx
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	78 40                	js     801f37 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801ef7:	83 ec 0c             	sub    $0xc,%esp
  801efa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801efd:	50                   	push   %eax
  801efe:	e8 db f5 ff ff       	call   8014de <fd_alloc>
  801f03:	89 c3                	mov    %eax,%ebx
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	78 1b                	js     801f27 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f0c:	83 ec 04             	sub    $0x4,%esp
  801f0f:	68 07 04 00 00       	push   $0x407
  801f14:	ff 75 f0             	pushl  -0x10(%ebp)
  801f17:	6a 00                	push   $0x0
  801f19:	e8 b2 f2 ff ff       	call   8011d0 <sys_page_alloc>
  801f1e:	89 c3                	mov    %eax,%ebx
  801f20:	83 c4 10             	add    $0x10,%esp
  801f23:	85 c0                	test   %eax,%eax
  801f25:	79 19                	jns    801f40 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801f27:	83 ec 08             	sub    $0x8,%esp
  801f2a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f2d:	6a 00                	push   $0x0
  801f2f:	e8 21 f3 ff ff       	call   801255 <sys_page_unmap>
  801f34:	83 c4 10             	add    $0x10,%esp
}
  801f37:	89 d8                	mov    %ebx,%eax
  801f39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f3c:	5b                   	pop    %ebx
  801f3d:	5e                   	pop    %esi
  801f3e:	5d                   	pop    %ebp
  801f3f:	c3                   	ret    
	va = fd2data(fd0);
  801f40:	83 ec 0c             	sub    $0xc,%esp
  801f43:	ff 75 f4             	pushl  -0xc(%ebp)
  801f46:	e8 7c f5 ff ff       	call   8014c7 <fd2data>
  801f4b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f4d:	83 c4 0c             	add    $0xc,%esp
  801f50:	68 07 04 00 00       	push   $0x407
  801f55:	50                   	push   %eax
  801f56:	6a 00                	push   $0x0
  801f58:	e8 73 f2 ff ff       	call   8011d0 <sys_page_alloc>
  801f5d:	89 c3                	mov    %eax,%ebx
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	85 c0                	test   %eax,%eax
  801f64:	0f 88 8c 00 00 00    	js     801ff6 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f6a:	83 ec 0c             	sub    $0xc,%esp
  801f6d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f70:	e8 52 f5 ff ff       	call   8014c7 <fd2data>
  801f75:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f7c:	50                   	push   %eax
  801f7d:	6a 00                	push   $0x0
  801f7f:	56                   	push   %esi
  801f80:	6a 00                	push   $0x0
  801f82:	e8 8c f2 ff ff       	call   801213 <sys_page_map>
  801f87:	89 c3                	mov    %eax,%ebx
  801f89:	83 c4 20             	add    $0x20,%esp
  801f8c:	85 c0                	test   %eax,%eax
  801f8e:	78 58                	js     801fe8 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f93:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801f99:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa8:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801fae:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc0:	e8 f2 f4 ff ff       	call   8014b7 <fd2num>
  801fc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fc8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fca:	83 c4 04             	add    $0x4,%esp
  801fcd:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd0:	e8 e2 f4 ff ff       	call   8014b7 <fd2num>
  801fd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fd8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fdb:	83 c4 10             	add    $0x10,%esp
  801fde:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fe3:	e9 4f ff ff ff       	jmp    801f37 <pipe+0x75>
	sys_page_unmap(0, va);
  801fe8:	83 ec 08             	sub    $0x8,%esp
  801feb:	56                   	push   %esi
  801fec:	6a 00                	push   $0x0
  801fee:	e8 62 f2 ff ff       	call   801255 <sys_page_unmap>
  801ff3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ff6:	83 ec 08             	sub    $0x8,%esp
  801ff9:	ff 75 f0             	pushl  -0x10(%ebp)
  801ffc:	6a 00                	push   $0x0
  801ffe:	e8 52 f2 ff ff       	call   801255 <sys_page_unmap>
  802003:	83 c4 10             	add    $0x10,%esp
  802006:	e9 1c ff ff ff       	jmp    801f27 <pipe+0x65>

0080200b <pipeisclosed>:
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802011:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802014:	50                   	push   %eax
  802015:	ff 75 08             	pushl  0x8(%ebp)
  802018:	e8 10 f5 ff ff       	call   80152d <fd_lookup>
  80201d:	83 c4 10             	add    $0x10,%esp
  802020:	85 c0                	test   %eax,%eax
  802022:	78 18                	js     80203c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802024:	83 ec 0c             	sub    $0xc,%esp
  802027:	ff 75 f4             	pushl  -0xc(%ebp)
  80202a:	e8 98 f4 ff ff       	call   8014c7 <fd2data>
	return _pipeisclosed(fd, p);
  80202f:	89 c2                	mov    %eax,%edx
  802031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802034:	e8 30 fd ff ff       	call   801d69 <_pipeisclosed>
  802039:	83 c4 10             	add    $0x10,%esp
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
  802046:	5d                   	pop    %ebp
  802047:	c3                   	ret    

00802048 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80204e:	68 66 2c 80 00       	push   $0x802c66
  802053:	ff 75 0c             	pushl  0xc(%ebp)
  802056:	e8 7c ed ff ff       	call   800dd7 <strcpy>
	return 0;
}
  80205b:	b8 00 00 00 00       	mov    $0x0,%eax
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <devcons_write>:
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	57                   	push   %edi
  802066:	56                   	push   %esi
  802067:	53                   	push   %ebx
  802068:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80206e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802073:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802079:	eb 2f                	jmp    8020aa <devcons_write+0x48>
		m = n - tot;
  80207b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80207e:	29 f3                	sub    %esi,%ebx
  802080:	83 fb 7f             	cmp    $0x7f,%ebx
  802083:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802088:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80208b:	83 ec 04             	sub    $0x4,%esp
  80208e:	53                   	push   %ebx
  80208f:	89 f0                	mov    %esi,%eax
  802091:	03 45 0c             	add    0xc(%ebp),%eax
  802094:	50                   	push   %eax
  802095:	57                   	push   %edi
  802096:	e8 ca ee ff ff       	call   800f65 <memmove>
		sys_cputs(buf, m);
  80209b:	83 c4 08             	add    $0x8,%esp
  80209e:	53                   	push   %ebx
  80209f:	57                   	push   %edi
  8020a0:	e8 6f f0 ff ff       	call   801114 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020a5:	01 de                	add    %ebx,%esi
  8020a7:	83 c4 10             	add    $0x10,%esp
  8020aa:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020ad:	72 cc                	jb     80207b <devcons_write+0x19>
}
  8020af:	89 f0                	mov    %esi,%eax
  8020b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020b4:	5b                   	pop    %ebx
  8020b5:	5e                   	pop    %esi
  8020b6:	5f                   	pop    %edi
  8020b7:	5d                   	pop    %ebp
  8020b8:	c3                   	ret    

008020b9 <devcons_read>:
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 08             	sub    $0x8,%esp
  8020bf:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020c8:	75 07                	jne    8020d1 <devcons_read+0x18>
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    
		sys_yield();
  8020cc:	e8 e0 f0 ff ff       	call   8011b1 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8020d1:	e8 5c f0 ff ff       	call   801132 <sys_cgetc>
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	74 f2                	je     8020cc <devcons_read+0x13>
	if (c < 0)
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	78 ec                	js     8020ca <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8020de:	83 f8 04             	cmp    $0x4,%eax
  8020e1:	74 0c                	je     8020ef <devcons_read+0x36>
	*(char*)vbuf = c;
  8020e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e6:	88 02                	mov    %al,(%edx)
	return 1;
  8020e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ed:	eb db                	jmp    8020ca <devcons_read+0x11>
		return 0;
  8020ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f4:	eb d4                	jmp    8020ca <devcons_read+0x11>

008020f6 <cputchar>:
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802102:	6a 01                	push   $0x1
  802104:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802107:	50                   	push   %eax
  802108:	e8 07 f0 ff ff       	call   801114 <sys_cputs>
}
  80210d:	83 c4 10             	add    $0x10,%esp
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <getchar>:
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802118:	6a 01                	push   $0x1
  80211a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80211d:	50                   	push   %eax
  80211e:	6a 00                	push   $0x0
  802120:	e8 79 f6 ff ff       	call   80179e <read>
	if (r < 0)
  802125:	83 c4 10             	add    $0x10,%esp
  802128:	85 c0                	test   %eax,%eax
  80212a:	78 08                	js     802134 <getchar+0x22>
	if (r < 1)
  80212c:	85 c0                	test   %eax,%eax
  80212e:	7e 06                	jle    802136 <getchar+0x24>
	return c;
  802130:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    
		return -E_EOF;
  802136:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80213b:	eb f7                	jmp    802134 <getchar+0x22>

0080213d <iscons>:
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
  802140:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802143:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802146:	50                   	push   %eax
  802147:	ff 75 08             	pushl  0x8(%ebp)
  80214a:	e8 de f3 ff ff       	call   80152d <fd_lookup>
  80214f:	83 c4 10             	add    $0x10,%esp
  802152:	85 c0                	test   %eax,%eax
  802154:	78 11                	js     802167 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802159:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80215f:	39 10                	cmp    %edx,(%eax)
  802161:	0f 94 c0             	sete   %al
  802164:	0f b6 c0             	movzbl %al,%eax
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <opencons>:
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80216f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802172:	50                   	push   %eax
  802173:	e8 66 f3 ff ff       	call   8014de <fd_alloc>
  802178:	83 c4 10             	add    $0x10,%esp
  80217b:	85 c0                	test   %eax,%eax
  80217d:	78 3a                	js     8021b9 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80217f:	83 ec 04             	sub    $0x4,%esp
  802182:	68 07 04 00 00       	push   $0x407
  802187:	ff 75 f4             	pushl  -0xc(%ebp)
  80218a:	6a 00                	push   $0x0
  80218c:	e8 3f f0 ff ff       	call   8011d0 <sys_page_alloc>
  802191:	83 c4 10             	add    $0x10,%esp
  802194:	85 c0                	test   %eax,%eax
  802196:	78 21                	js     8021b9 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8021a1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021ad:	83 ec 0c             	sub    $0xc,%esp
  8021b0:	50                   	push   %eax
  8021b1:	e8 01 f3 ff ff       	call   8014b7 <fd2num>
  8021b6:	83 c4 10             	add    $0x10,%esp
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021c1:	89 d0                	mov    %edx,%eax
  8021c3:	c1 e8 16             	shr    $0x16,%eax
  8021c6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8021cd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8021d2:	f6 c1 01             	test   $0x1,%cl
  8021d5:	74 1d                	je     8021f4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8021d7:	c1 ea 0c             	shr    $0xc,%edx
  8021da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8021e1:	f6 c2 01             	test   $0x1,%dl
  8021e4:	74 0e                	je     8021f4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021e6:	c1 ea 0c             	shr    $0xc,%edx
  8021e9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8021f0:	ef 
  8021f1:	0f b7 c0             	movzwl %ax,%eax
}
  8021f4:	5d                   	pop    %ebp
  8021f5:	c3                   	ret    
  8021f6:	66 90                	xchg   %ax,%ax
  8021f8:	66 90                	xchg   %ax,%ax
  8021fa:	66 90                	xchg   %ax,%ax
  8021fc:	66 90                	xchg   %ax,%ax
  8021fe:	66 90                	xchg   %ax,%ax

00802200 <__udivdi3>:
  802200:	55                   	push   %ebp
  802201:	57                   	push   %edi
  802202:	56                   	push   %esi
  802203:	53                   	push   %ebx
  802204:	83 ec 1c             	sub    $0x1c,%esp
  802207:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80220b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80220f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802213:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802217:	85 d2                	test   %edx,%edx
  802219:	75 35                	jne    802250 <__udivdi3+0x50>
  80221b:	39 f3                	cmp    %esi,%ebx
  80221d:	0f 87 bd 00 00 00    	ja     8022e0 <__udivdi3+0xe0>
  802223:	85 db                	test   %ebx,%ebx
  802225:	89 d9                	mov    %ebx,%ecx
  802227:	75 0b                	jne    802234 <__udivdi3+0x34>
  802229:	b8 01 00 00 00       	mov    $0x1,%eax
  80222e:	31 d2                	xor    %edx,%edx
  802230:	f7 f3                	div    %ebx
  802232:	89 c1                	mov    %eax,%ecx
  802234:	31 d2                	xor    %edx,%edx
  802236:	89 f0                	mov    %esi,%eax
  802238:	f7 f1                	div    %ecx
  80223a:	89 c6                	mov    %eax,%esi
  80223c:	89 e8                	mov    %ebp,%eax
  80223e:	89 f7                	mov    %esi,%edi
  802240:	f7 f1                	div    %ecx
  802242:	89 fa                	mov    %edi,%edx
  802244:	83 c4 1c             	add    $0x1c,%esp
  802247:	5b                   	pop    %ebx
  802248:	5e                   	pop    %esi
  802249:	5f                   	pop    %edi
  80224a:	5d                   	pop    %ebp
  80224b:	c3                   	ret    
  80224c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802250:	39 f2                	cmp    %esi,%edx
  802252:	77 7c                	ja     8022d0 <__udivdi3+0xd0>
  802254:	0f bd fa             	bsr    %edx,%edi
  802257:	83 f7 1f             	xor    $0x1f,%edi
  80225a:	0f 84 98 00 00 00    	je     8022f8 <__udivdi3+0xf8>
  802260:	89 f9                	mov    %edi,%ecx
  802262:	b8 20 00 00 00       	mov    $0x20,%eax
  802267:	29 f8                	sub    %edi,%eax
  802269:	d3 e2                	shl    %cl,%edx
  80226b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80226f:	89 c1                	mov    %eax,%ecx
  802271:	89 da                	mov    %ebx,%edx
  802273:	d3 ea                	shr    %cl,%edx
  802275:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802279:	09 d1                	or     %edx,%ecx
  80227b:	89 f2                	mov    %esi,%edx
  80227d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802281:	89 f9                	mov    %edi,%ecx
  802283:	d3 e3                	shl    %cl,%ebx
  802285:	89 c1                	mov    %eax,%ecx
  802287:	d3 ea                	shr    %cl,%edx
  802289:	89 f9                	mov    %edi,%ecx
  80228b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80228f:	d3 e6                	shl    %cl,%esi
  802291:	89 eb                	mov    %ebp,%ebx
  802293:	89 c1                	mov    %eax,%ecx
  802295:	d3 eb                	shr    %cl,%ebx
  802297:	09 de                	or     %ebx,%esi
  802299:	89 f0                	mov    %esi,%eax
  80229b:	f7 74 24 08          	divl   0x8(%esp)
  80229f:	89 d6                	mov    %edx,%esi
  8022a1:	89 c3                	mov    %eax,%ebx
  8022a3:	f7 64 24 0c          	mull   0xc(%esp)
  8022a7:	39 d6                	cmp    %edx,%esi
  8022a9:	72 0c                	jb     8022b7 <__udivdi3+0xb7>
  8022ab:	89 f9                	mov    %edi,%ecx
  8022ad:	d3 e5                	shl    %cl,%ebp
  8022af:	39 c5                	cmp    %eax,%ebp
  8022b1:	73 5d                	jae    802310 <__udivdi3+0x110>
  8022b3:	39 d6                	cmp    %edx,%esi
  8022b5:	75 59                	jne    802310 <__udivdi3+0x110>
  8022b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022ba:	31 ff                	xor    %edi,%edi
  8022bc:	89 fa                	mov    %edi,%edx
  8022be:	83 c4 1c             	add    $0x1c,%esp
  8022c1:	5b                   	pop    %ebx
  8022c2:	5e                   	pop    %esi
  8022c3:	5f                   	pop    %edi
  8022c4:	5d                   	pop    %ebp
  8022c5:	c3                   	ret    
  8022c6:	8d 76 00             	lea    0x0(%esi),%esi
  8022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8022d0:	31 ff                	xor    %edi,%edi
  8022d2:	31 c0                	xor    %eax,%eax
  8022d4:	89 fa                	mov    %edi,%edx
  8022d6:	83 c4 1c             	add    $0x1c,%esp
  8022d9:	5b                   	pop    %ebx
  8022da:	5e                   	pop    %esi
  8022db:	5f                   	pop    %edi
  8022dc:	5d                   	pop    %ebp
  8022dd:	c3                   	ret    
  8022de:	66 90                	xchg   %ax,%ax
  8022e0:	31 ff                	xor    %edi,%edi
  8022e2:	89 e8                	mov    %ebp,%eax
  8022e4:	89 f2                	mov    %esi,%edx
  8022e6:	f7 f3                	div    %ebx
  8022e8:	89 fa                	mov    %edi,%edx
  8022ea:	83 c4 1c             	add    $0x1c,%esp
  8022ed:	5b                   	pop    %ebx
  8022ee:	5e                   	pop    %esi
  8022ef:	5f                   	pop    %edi
  8022f0:	5d                   	pop    %ebp
  8022f1:	c3                   	ret    
  8022f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022f8:	39 f2                	cmp    %esi,%edx
  8022fa:	72 06                	jb     802302 <__udivdi3+0x102>
  8022fc:	31 c0                	xor    %eax,%eax
  8022fe:	39 eb                	cmp    %ebp,%ebx
  802300:	77 d2                	ja     8022d4 <__udivdi3+0xd4>
  802302:	b8 01 00 00 00       	mov    $0x1,%eax
  802307:	eb cb                	jmp    8022d4 <__udivdi3+0xd4>
  802309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802310:	89 d8                	mov    %ebx,%eax
  802312:	31 ff                	xor    %edi,%edi
  802314:	eb be                	jmp    8022d4 <__udivdi3+0xd4>
  802316:	66 90                	xchg   %ax,%ax
  802318:	66 90                	xchg   %ax,%ax
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <__umoddi3>:
  802320:	55                   	push   %ebp
  802321:	57                   	push   %edi
  802322:	56                   	push   %esi
  802323:	53                   	push   %ebx
  802324:	83 ec 1c             	sub    $0x1c,%esp
  802327:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80232b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80232f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802333:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802337:	85 ed                	test   %ebp,%ebp
  802339:	89 f0                	mov    %esi,%eax
  80233b:	89 da                	mov    %ebx,%edx
  80233d:	75 19                	jne    802358 <__umoddi3+0x38>
  80233f:	39 df                	cmp    %ebx,%edi
  802341:	0f 86 b1 00 00 00    	jbe    8023f8 <__umoddi3+0xd8>
  802347:	f7 f7                	div    %edi
  802349:	89 d0                	mov    %edx,%eax
  80234b:	31 d2                	xor    %edx,%edx
  80234d:	83 c4 1c             	add    $0x1c,%esp
  802350:	5b                   	pop    %ebx
  802351:	5e                   	pop    %esi
  802352:	5f                   	pop    %edi
  802353:	5d                   	pop    %ebp
  802354:	c3                   	ret    
  802355:	8d 76 00             	lea    0x0(%esi),%esi
  802358:	39 dd                	cmp    %ebx,%ebp
  80235a:	77 f1                	ja     80234d <__umoddi3+0x2d>
  80235c:	0f bd cd             	bsr    %ebp,%ecx
  80235f:	83 f1 1f             	xor    $0x1f,%ecx
  802362:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802366:	0f 84 b4 00 00 00    	je     802420 <__umoddi3+0x100>
  80236c:	b8 20 00 00 00       	mov    $0x20,%eax
  802371:	89 c2                	mov    %eax,%edx
  802373:	8b 44 24 04          	mov    0x4(%esp),%eax
  802377:	29 c2                	sub    %eax,%edx
  802379:	89 c1                	mov    %eax,%ecx
  80237b:	89 f8                	mov    %edi,%eax
  80237d:	d3 e5                	shl    %cl,%ebp
  80237f:	89 d1                	mov    %edx,%ecx
  802381:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802385:	d3 e8                	shr    %cl,%eax
  802387:	09 c5                	or     %eax,%ebp
  802389:	8b 44 24 04          	mov    0x4(%esp),%eax
  80238d:	89 c1                	mov    %eax,%ecx
  80238f:	d3 e7                	shl    %cl,%edi
  802391:	89 d1                	mov    %edx,%ecx
  802393:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802397:	89 df                	mov    %ebx,%edi
  802399:	d3 ef                	shr    %cl,%edi
  80239b:	89 c1                	mov    %eax,%ecx
  80239d:	89 f0                	mov    %esi,%eax
  80239f:	d3 e3                	shl    %cl,%ebx
  8023a1:	89 d1                	mov    %edx,%ecx
  8023a3:	89 fa                	mov    %edi,%edx
  8023a5:	d3 e8                	shr    %cl,%eax
  8023a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023ac:	09 d8                	or     %ebx,%eax
  8023ae:	f7 f5                	div    %ebp
  8023b0:	d3 e6                	shl    %cl,%esi
  8023b2:	89 d1                	mov    %edx,%ecx
  8023b4:	f7 64 24 08          	mull   0x8(%esp)
  8023b8:	39 d1                	cmp    %edx,%ecx
  8023ba:	89 c3                	mov    %eax,%ebx
  8023bc:	89 d7                	mov    %edx,%edi
  8023be:	72 06                	jb     8023c6 <__umoddi3+0xa6>
  8023c0:	75 0e                	jne    8023d0 <__umoddi3+0xb0>
  8023c2:	39 c6                	cmp    %eax,%esi
  8023c4:	73 0a                	jae    8023d0 <__umoddi3+0xb0>
  8023c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8023ca:	19 ea                	sbb    %ebp,%edx
  8023cc:	89 d7                	mov    %edx,%edi
  8023ce:	89 c3                	mov    %eax,%ebx
  8023d0:	89 ca                	mov    %ecx,%edx
  8023d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8023d7:	29 de                	sub    %ebx,%esi
  8023d9:	19 fa                	sbb    %edi,%edx
  8023db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8023df:	89 d0                	mov    %edx,%eax
  8023e1:	d3 e0                	shl    %cl,%eax
  8023e3:	89 d9                	mov    %ebx,%ecx
  8023e5:	d3 ee                	shr    %cl,%esi
  8023e7:	d3 ea                	shr    %cl,%edx
  8023e9:	09 f0                	or     %esi,%eax
  8023eb:	83 c4 1c             	add    $0x1c,%esp
  8023ee:	5b                   	pop    %ebx
  8023ef:	5e                   	pop    %esi
  8023f0:	5f                   	pop    %edi
  8023f1:	5d                   	pop    %ebp
  8023f2:	c3                   	ret    
  8023f3:	90                   	nop
  8023f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023f8:	85 ff                	test   %edi,%edi
  8023fa:	89 f9                	mov    %edi,%ecx
  8023fc:	75 0b                	jne    802409 <__umoddi3+0xe9>
  8023fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802403:	31 d2                	xor    %edx,%edx
  802405:	f7 f7                	div    %edi
  802407:	89 c1                	mov    %eax,%ecx
  802409:	89 d8                	mov    %ebx,%eax
  80240b:	31 d2                	xor    %edx,%edx
  80240d:	f7 f1                	div    %ecx
  80240f:	89 f0                	mov    %esi,%eax
  802411:	f7 f1                	div    %ecx
  802413:	e9 31 ff ff ff       	jmp    802349 <__umoddi3+0x29>
  802418:	90                   	nop
  802419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802420:	39 dd                	cmp    %ebx,%ebp
  802422:	72 08                	jb     80242c <__umoddi3+0x10c>
  802424:	39 f7                	cmp    %esi,%edi
  802426:	0f 87 21 ff ff ff    	ja     80234d <__umoddi3+0x2d>
  80242c:	89 da                	mov    %ebx,%edx
  80242e:	89 f0                	mov    %esi,%eax
  802430:	29 f8                	sub    %edi,%eax
  802432:	19 ea                	sbb    %ebp,%edx
  802434:	e9 14 ff ff ff       	jmp    80234d <__umoddi3+0x2d>
