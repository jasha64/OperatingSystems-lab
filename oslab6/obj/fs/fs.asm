
obj/fs/fs：     文件格式 elf32-i386


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
  80002c:	e8 d2 1a 00 00       	call   801b03 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	53                   	push   %ebx
  800063:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	e8 c3 ff ff ff       	call   800033 <ide_wait_ready>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800070:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800075:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80007a:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007b:	b9 00 00 00 00       	mov    $0x0,%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800080:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800085:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800086:	a8 a1                	test   $0xa1,%al
  800088:	74 0b                	je     800095 <ide_probe_disk1+0x36>
	     x++)
  80008a:	83 c1 01             	add    $0x1,%ecx
	for (x = 0;
  80008d:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800093:	75 f0                	jne    800085 <ide_probe_disk1+0x26>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800095:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009a:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80009f:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a0:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000a6:	0f 9e c3             	setle  %bl
  8000a9:	83 ec 08             	sub    $0x8,%esp
  8000ac:	0f b6 c3             	movzbl %bl,%eax
  8000af:	50                   	push   %eax
  8000b0:	68 40 39 80 00       	push   $0x803940
  8000b5:	e8 7c 1b 00 00       	call   801c36 <cprintf>
	return (x < 1000);
}
  8000ba:	89 d8                	mov    %ebx,%eax
  8000bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000bf:	c9                   	leave  
  8000c0:	c3                   	ret    

008000c1 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 08             	sub    $0x8,%esp
  8000c7:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000ca:	83 f8 01             	cmp    $0x1,%eax
  8000cd:	77 07                	ja     8000d6 <ide_set_disk+0x15>
		panic("bad disk number");
	diskno = d;
  8000cf:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    
		panic("bad disk number");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 57 39 80 00       	push   $0x803957
  8000de:	6a 3a                	push   $0x3a
  8000e0:	68 67 39 80 00       	push   $0x803967
  8000e5:	e8 71 1a 00 00       	call   801b5b <_panic>

008000ea <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	57                   	push   %edi
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8000f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  8000fc:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  800102:	0f 87 87 00 00 00    	ja     80018f <ide_read+0xa5>

	ide_wait_ready(0);
  800108:	b8 00 00 00 00       	mov    $0x0,%eax
  80010d:	e8 21 ff ff ff       	call   800033 <ide_wait_ready>
  800112:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800117:	89 f0                	mov    %esi,%eax
  800119:	ee                   	out    %al,(%dx)
  80011a:	ba f3 01 00 00       	mov    $0x1f3,%edx
  80011f:	89 f8                	mov    %edi,%eax
  800121:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  800122:	89 f8                	mov    %edi,%eax
  800124:	c1 e8 08             	shr    $0x8,%eax
  800127:	ba f4 01 00 00       	mov    $0x1f4,%edx
  80012c:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  80012d:	89 f8                	mov    %edi,%eax
  80012f:	c1 e8 10             	shr    $0x10,%eax
  800132:	ba f5 01 00 00       	mov    $0x1f5,%edx
  800137:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800138:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  80013f:	c1 e0 04             	shl    $0x4,%eax
  800142:	83 e0 10             	and    $0x10,%eax
  800145:	83 c8 e0             	or     $0xffffffe0,%eax
  800148:	c1 ef 18             	shr    $0x18,%edi
  80014b:	83 e7 0f             	and    $0xf,%edi
  80014e:	09 f8                	or     %edi,%eax
  800150:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800155:	ee                   	out    %al,(%dx)
  800156:	b8 20 00 00 00       	mov    $0x20,%eax
  80015b:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800160:	ee                   	out    %al,(%dx)
  800161:	c1 e6 09             	shl    $0x9,%esi
  800164:	01 de                	add    %ebx,%esi
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800166:	39 f3                	cmp    %esi,%ebx
  800168:	74 3b                	je     8001a5 <ide_read+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  80016a:	b8 01 00 00 00       	mov    $0x1,%eax
  80016f:	e8 bf fe ff ff       	call   800033 <ide_wait_ready>
  800174:	85 c0                	test   %eax,%eax
  800176:	78 32                	js     8001aa <ide_read+0xc0>
	asm volatile("cld\n\trepne\n\tinsl"
  800178:	89 df                	mov    %ebx,%edi
  80017a:	b9 80 00 00 00       	mov    $0x80,%ecx
  80017f:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800184:	fc                   	cld    
  800185:	f2 6d                	repnz insl (%dx),%es:(%edi)
	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800187:	81 c3 00 02 00 00    	add    $0x200,%ebx
  80018d:	eb d7                	jmp    800166 <ide_read+0x7c>
	assert(nsecs <= 256);
  80018f:	68 70 39 80 00       	push   $0x803970
  800194:	68 7d 39 80 00       	push   $0x80397d
  800199:	6a 44                	push   $0x44
  80019b:	68 67 39 80 00       	push   $0x803967
  8001a0:	e8 b6 19 00 00       	call   801b5b <_panic>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ad:	5b                   	pop    %ebx
  8001ae:	5e                   	pop    %esi
  8001af:	5f                   	pop    %edi
  8001b0:	5d                   	pop    %ebp
  8001b1:	c3                   	ret    

008001b2 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	57                   	push   %edi
  8001b6:	56                   	push   %esi
  8001b7:	53                   	push   %ebx
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8001be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001c1:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001c4:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001ca:	0f 87 87 00 00 00    	ja     800257 <ide_write+0xa5>

	ide_wait_ready(0);
  8001d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d5:	e8 59 fe ff ff       	call   800033 <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001da:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8001df:	89 f8                	mov    %edi,%eax
  8001e1:	ee                   	out    %al,(%dx)
  8001e2:	ba f3 01 00 00       	mov    $0x1f3,%edx
  8001e7:	89 f0                	mov    %esi,%eax
  8001e9:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  8001ea:	89 f0                	mov    %esi,%eax
  8001ec:	c1 e8 08             	shr    $0x8,%eax
  8001ef:	ba f4 01 00 00       	mov    $0x1f4,%edx
  8001f4:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8001f5:	89 f0                	mov    %esi,%eax
  8001f7:	c1 e8 10             	shr    $0x10,%eax
  8001fa:	ba f5 01 00 00       	mov    $0x1f5,%edx
  8001ff:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800200:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800207:	c1 e0 04             	shl    $0x4,%eax
  80020a:	83 e0 10             	and    $0x10,%eax
  80020d:	83 c8 e0             	or     $0xffffffe0,%eax
  800210:	c1 ee 18             	shr    $0x18,%esi
  800213:	83 e6 0f             	and    $0xf,%esi
  800216:	09 f0                	or     %esi,%eax
  800218:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80021d:	ee                   	out    %al,(%dx)
  80021e:	b8 30 00 00 00       	mov    $0x30,%eax
  800223:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800228:	ee                   	out    %al,(%dx)
  800229:	c1 e7 09             	shl    $0x9,%edi
  80022c:	01 df                	add    %ebx,%edi
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80022e:	39 fb                	cmp    %edi,%ebx
  800230:	74 3b                	je     80026d <ide_write+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  800232:	b8 01 00 00 00       	mov    $0x1,%eax
  800237:	e8 f7 fd ff ff       	call   800033 <ide_wait_ready>
  80023c:	85 c0                	test   %eax,%eax
  80023e:	78 32                	js     800272 <ide_write+0xc0>
}

static inline void
outsl(int port, const void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\toutsl"
  800240:	89 de                	mov    %ebx,%esi
  800242:	b9 80 00 00 00       	mov    $0x80,%ecx
  800247:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80024c:	fc                   	cld    
  80024d:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80024f:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800255:	eb d7                	jmp    80022e <ide_write+0x7c>
	assert(nsecs <= 256);
  800257:	68 70 39 80 00       	push   $0x803970
  80025c:	68 7d 39 80 00       	push   $0x80397d
  800261:	6a 5d                	push   $0x5d
  800263:	68 67 39 80 00       	push   $0x803967
  800268:	e8 ee 18 00 00       	call   801b5b <_panic>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80026d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800272:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	56                   	push   %esi
  80027e:	53                   	push   %ebx
  80027f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  800282:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800284:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80028a:	89 c6                	mov    %eax,%esi
  80028c:	c1 ee 0c             	shr    $0xc,%esi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80028f:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800294:	0f 87 95 00 00 00    	ja     80032f <bc_pgfault+0xb5>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80029a:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	74 09                	je     8002ac <bc_pgfault+0x32>
  8002a3:	39 70 04             	cmp    %esi,0x4(%eax)
  8002a6:	0f 86 9e 00 00 00    	jbe    80034a <bc_pgfault+0xd0>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	addr = ROUNDDOWN(addr, PGSIZE);
  8002ac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_alloc(0, addr, PTE_W | PTE_P | PTE_U)) < 0)
  8002b2:	83 ec 04             	sub    $0x4,%esp
  8002b5:	6a 07                	push   $0x7
  8002b7:	53                   	push   %ebx
  8002b8:	6a 00                	push   $0x0
  8002ba:	e8 8f 23 00 00       	call   80264e <sys_page_alloc>
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	85 c0                	test   %eax,%eax
  8002c4:	0f 88 92 00 00 00    	js     80035c <bc_pgfault+0xe2>
		panic("page alloc failed: %e, va %08x", r, addr);
	if ((r = ide_read(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	6a 08                	push   $0x8
  8002cf:	53                   	push   %ebx
  8002d0:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  8002d7:	50                   	push   %eax
  8002d8:	e8 0d fe ff ff       	call   8000ea <ide_read>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	85 c0                	test   %eax,%eax
  8002e2:	0f 88 8a 00 00 00    	js     800372 <bc_pgfault+0xf8>
		panic("ide read failed: %e, va %08x", r, addr);

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8002e8:	89 d8                	mov    %ebx,%eax
  8002ea:	c1 e8 0c             	shr    $0xc,%eax
  8002ed:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8002fc:	50                   	push   %eax
  8002fd:	53                   	push   %ebx
  8002fe:	6a 00                	push   $0x0
  800300:	53                   	push   %ebx
  800301:	6a 00                	push   $0x0
  800303:	e8 89 23 00 00       	call   802691 <sys_page_map>
  800308:	83 c4 20             	add    $0x20,%esp
  80030b:	85 c0                	test   %eax,%eax
  80030d:	78 79                	js     800388 <bc_pgfault+0x10e>
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  80030f:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  800316:	74 10                	je     800328 <bc_pgfault+0xae>
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	56                   	push   %esi
  80031c:	e8 19 05 00 00       	call   80083a <block_is_free>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	84 c0                	test   %al,%al
  800326:	75 72                	jne    80039a <bc_pgfault+0x120>
		panic("reading free block %08x\n", blockno);
}
  800328:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80032b:	5b                   	pop    %ebx
  80032c:	5e                   	pop    %esi
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	ff 72 04             	pushl  0x4(%edx)
  800335:	53                   	push   %ebx
  800336:	ff 72 28             	pushl  0x28(%edx)
  800339:	68 94 39 80 00       	push   $0x803994
  80033e:	6a 27                	push   $0x27
  800340:	68 94 3a 80 00       	push   $0x803a94
  800345:	e8 11 18 00 00       	call   801b5b <_panic>
		panic("reading non-existent block %08x\n", blockno);
  80034a:	56                   	push   %esi
  80034b:	68 c4 39 80 00       	push   $0x8039c4
  800350:	6a 2b                	push   $0x2b
  800352:	68 94 3a 80 00       	push   $0x803a94
  800357:	e8 ff 17 00 00       	call   801b5b <_panic>
		panic("page alloc failed: %e, va %08x", r, addr);
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	53                   	push   %ebx
  800360:	50                   	push   %eax
  800361:	68 e8 39 80 00       	push   $0x8039e8
  800366:	6a 35                	push   $0x35
  800368:	68 94 3a 80 00       	push   $0x803a94
  80036d:	e8 e9 17 00 00       	call   801b5b <_panic>
		panic("ide read failed: %e, va %08x", r, addr);
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	53                   	push   %ebx
  800376:	50                   	push   %eax
  800377:	68 9c 3a 80 00       	push   $0x803a9c
  80037c:	6a 37                	push   $0x37
  80037e:	68 94 3a 80 00       	push   $0x803a94
  800383:	e8 d3 17 00 00       	call   801b5b <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  800388:	50                   	push   %eax
  800389:	68 08 3a 80 00       	push   $0x803a08
  80038e:	6a 3c                	push   $0x3c
  800390:	68 94 3a 80 00       	push   $0x803a94
  800395:	e8 c1 17 00 00       	call   801b5b <_panic>
		panic("reading free block %08x\n", blockno);
  80039a:	56                   	push   %esi
  80039b:	68 b9 3a 80 00       	push   $0x803ab9
  8003a0:	6a 42                	push   $0x42
  8003a2:	68 94 3a 80 00       	push   $0x803a94
  8003a7:	e8 af 17 00 00       	call   801b5b <_panic>

008003ac <diskaddr>:
{
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	83 ec 08             	sub    $0x8,%esp
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8003b5:	85 c0                	test   %eax,%eax
  8003b7:	74 19                	je     8003d2 <diskaddr+0x26>
  8003b9:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  8003bf:	85 d2                	test   %edx,%edx
  8003c1:	74 05                	je     8003c8 <diskaddr+0x1c>
  8003c3:	39 42 04             	cmp    %eax,0x4(%edx)
  8003c6:	76 0a                	jbe    8003d2 <diskaddr+0x26>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  8003c8:	05 00 00 01 00       	add    $0x10000,%eax
  8003cd:	c1 e0 0c             	shl    $0xc,%eax
}
  8003d0:	c9                   	leave  
  8003d1:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  8003d2:	50                   	push   %eax
  8003d3:	68 28 3a 80 00       	push   $0x803a28
  8003d8:	6a 09                	push   $0x9
  8003da:	68 94 3a 80 00       	push   $0x803a94
  8003df:	e8 77 17 00 00       	call   801b5b <_panic>

008003e4 <va_is_mapped>:
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  8003ea:	89 d0                	mov    %edx,%eax
  8003ec:	c1 e8 16             	shr    $0x16,%eax
  8003ef:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  8003f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fb:	f6 c1 01             	test   $0x1,%cl
  8003fe:	74 0d                	je     80040d <va_is_mapped+0x29>
  800400:	c1 ea 0c             	shr    $0xc,%edx
  800403:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80040a:	83 e0 01             	and    $0x1,%eax
  80040d:	83 e0 01             	and    $0x1,%eax
}
  800410:	5d                   	pop    %ebp
  800411:	c3                   	ret    

00800412 <va_is_dirty>:
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	c1 e8 0c             	shr    $0xc,%eax
  80041b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800422:	c1 e8 06             	shr    $0x6,%eax
  800425:	83 e0 01             	and    $0x1,%eax
}
  800428:	5d                   	pop    %ebp
  800429:	c3                   	ret    

0080042a <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	56                   	push   %esi
  80042e:	53                   	push   %ebx
  80042f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800432:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  800438:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  80043d:	77 1f                	ja     80045e <flush_block+0x34>
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	int r;

	addr = ROUNDDOWN(addr, PGSIZE);
  80043f:	89 de                	mov    %ebx,%esi
  800441:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (!va_is_mapped(addr) || !va_is_dirty(addr)) return;
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	56                   	push   %esi
  80044b:	e8 94 ff ff ff       	call   8003e4 <va_is_mapped>
  800450:	83 c4 10             	add    $0x10,%esp
  800453:	84 c0                	test   %al,%al
  800455:	75 19                	jne    800470 <flush_block+0x46>
	if ((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
		panic("ide write failed: %e, va %08x", r, addr);
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
		panic("in flush_block, sys_page_map: %e", r);
}
  800457:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80045a:	5b                   	pop    %ebx
  80045b:	5e                   	pop    %esi
  80045c:	5d                   	pop    %ebp
  80045d:	c3                   	ret    
		panic("flush_block of bad va %08x", addr);
  80045e:	53                   	push   %ebx
  80045f:	68 d2 3a 80 00       	push   $0x803ad2
  800464:	6a 52                	push   $0x52
  800466:	68 94 3a 80 00       	push   $0x803a94
  80046b:	e8 eb 16 00 00       	call   801b5b <_panic>
	if (!va_is_mapped(addr) || !va_is_dirty(addr)) return;
  800470:	83 ec 0c             	sub    $0xc,%esp
  800473:	56                   	push   %esi
  800474:	e8 99 ff ff ff       	call   800412 <va_is_dirty>
  800479:	83 c4 10             	add    $0x10,%esp
  80047c:	84 c0                	test   %al,%al
  80047e:	74 d7                	je     800457 <flush_block+0x2d>
	if ((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	6a 08                	push   $0x8
  800485:	56                   	push   %esi
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800486:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
  80048c:	c1 eb 0c             	shr    $0xc,%ebx
	if ((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  80048f:	c1 e3 03             	shl    $0x3,%ebx
  800492:	53                   	push   %ebx
  800493:	e8 1a fd ff ff       	call   8001b2 <ide_write>
  800498:	83 c4 10             	add    $0x10,%esp
  80049b:	85 c0                	test   %eax,%eax
  80049d:	78 39                	js     8004d8 <flush_block+0xae>
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  80049f:	89 f0                	mov    %esi,%eax
  8004a1:	c1 e8 0c             	shr    $0xc,%eax
  8004a4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8004ab:	83 ec 0c             	sub    $0xc,%esp
  8004ae:	25 07 0e 00 00       	and    $0xe07,%eax
  8004b3:	50                   	push   %eax
  8004b4:	56                   	push   %esi
  8004b5:	6a 00                	push   $0x0
  8004b7:	56                   	push   %esi
  8004b8:	6a 00                	push   $0x0
  8004ba:	e8 d2 21 00 00       	call   802691 <sys_page_map>
  8004bf:	83 c4 20             	add    $0x20,%esp
  8004c2:	85 c0                	test   %eax,%eax
  8004c4:	79 91                	jns    800457 <flush_block+0x2d>
		panic("in flush_block, sys_page_map: %e", r);
  8004c6:	50                   	push   %eax
  8004c7:	68 4c 3a 80 00       	push   $0x803a4c
  8004cc:	6a 5c                	push   $0x5c
  8004ce:	68 94 3a 80 00       	push   $0x803a94
  8004d3:	e8 83 16 00 00       	call   801b5b <_panic>
		panic("ide write failed: %e, va %08x", r, addr);
  8004d8:	83 ec 0c             	sub    $0xc,%esp
  8004db:	56                   	push   %esi
  8004dc:	50                   	push   %eax
  8004dd:	68 ed 3a 80 00       	push   $0x803aed
  8004e2:	6a 5a                	push   $0x5a
  8004e4:	68 94 3a 80 00       	push   $0x803a94
  8004e9:	e8 6d 16 00 00       	call   801b5b <_panic>

008004ee <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  8004ee:	55                   	push   %ebp
  8004ef:	89 e5                	mov    %esp,%ebp
  8004f1:	53                   	push   %ebx
  8004f2:	81 ec 20 02 00 00    	sub    $0x220,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  8004f8:	68 7a 02 80 00       	push   $0x80027a
  8004fd:	e8 3d 23 00 00       	call   80283f <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  800502:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800509:	e8 9e fe ff ff       	call   8003ac <diskaddr>
  80050e:	83 c4 0c             	add    $0xc,%esp
  800511:	68 08 01 00 00       	push   $0x108
  800516:	50                   	push   %eax
  800517:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80051d:	50                   	push   %eax
  80051e:	e8 c0 1e 00 00       	call   8023e3 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  800523:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80052a:	e8 7d fe ff ff       	call   8003ac <diskaddr>
  80052f:	83 c4 08             	add    $0x8,%esp
  800532:	68 0b 3b 80 00       	push   $0x803b0b
  800537:	50                   	push   %eax
  800538:	e8 18 1d 00 00       	call   802255 <strcpy>
	flush_block(diskaddr(1));
  80053d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800544:	e8 63 fe ff ff       	call   8003ac <diskaddr>
  800549:	89 04 24             	mov    %eax,(%esp)
  80054c:	e8 d9 fe ff ff       	call   80042a <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800551:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800558:	e8 4f fe ff ff       	call   8003ac <diskaddr>
  80055d:	89 04 24             	mov    %eax,(%esp)
  800560:	e8 7f fe ff ff       	call   8003e4 <va_is_mapped>
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	84 c0                	test   %al,%al
  80056a:	0f 84 d1 01 00 00    	je     800741 <bc_init+0x253>
	assert(!va_is_dirty(diskaddr(1)));
  800570:	83 ec 0c             	sub    $0xc,%esp
  800573:	6a 01                	push   $0x1
  800575:	e8 32 fe ff ff       	call   8003ac <diskaddr>
  80057a:	89 04 24             	mov    %eax,(%esp)
  80057d:	e8 90 fe ff ff       	call   800412 <va_is_dirty>
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	84 c0                	test   %al,%al
  800587:	0f 85 ca 01 00 00    	jne    800757 <bc_init+0x269>
	sys_page_unmap(0, diskaddr(1));
  80058d:	83 ec 0c             	sub    $0xc,%esp
  800590:	6a 01                	push   $0x1
  800592:	e8 15 fe ff ff       	call   8003ac <diskaddr>
  800597:	83 c4 08             	add    $0x8,%esp
  80059a:	50                   	push   %eax
  80059b:	6a 00                	push   $0x0
  80059d:	e8 31 21 00 00       	call   8026d3 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  8005a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005a9:	e8 fe fd ff ff       	call   8003ac <diskaddr>
  8005ae:	89 04 24             	mov    %eax,(%esp)
  8005b1:	e8 2e fe ff ff       	call   8003e4 <va_is_mapped>
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	84 c0                	test   %al,%al
  8005bb:	0f 85 ac 01 00 00    	jne    80076d <bc_init+0x27f>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8005c1:	83 ec 0c             	sub    $0xc,%esp
  8005c4:	6a 01                	push   $0x1
  8005c6:	e8 e1 fd ff ff       	call   8003ac <diskaddr>
  8005cb:	83 c4 08             	add    $0x8,%esp
  8005ce:	68 0b 3b 80 00       	push   $0x803b0b
  8005d3:	50                   	push   %eax
  8005d4:	e8 22 1d 00 00       	call   8022fb <strcmp>
  8005d9:	83 c4 10             	add    $0x10,%esp
  8005dc:	85 c0                	test   %eax,%eax
  8005de:	0f 85 9f 01 00 00    	jne    800783 <bc_init+0x295>
	memmove(diskaddr(1), &backup, sizeof backup);
  8005e4:	83 ec 0c             	sub    $0xc,%esp
  8005e7:	6a 01                	push   $0x1
  8005e9:	e8 be fd ff ff       	call   8003ac <diskaddr>
  8005ee:	83 c4 0c             	add    $0xc,%esp
  8005f1:	68 08 01 00 00       	push   $0x108
  8005f6:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  8005fc:	53                   	push   %ebx
  8005fd:	50                   	push   %eax
  8005fe:	e8 e0 1d 00 00       	call   8023e3 <memmove>
	flush_block(diskaddr(1));
  800603:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80060a:	e8 9d fd ff ff       	call   8003ac <diskaddr>
  80060f:	89 04 24             	mov    %eax,(%esp)
  800612:	e8 13 fe ff ff       	call   80042a <flush_block>
	memmove(&backup, diskaddr(1), sizeof backup);
  800617:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80061e:	e8 89 fd ff ff       	call   8003ac <diskaddr>
  800623:	83 c4 0c             	add    $0xc,%esp
  800626:	68 08 01 00 00       	push   $0x108
  80062b:	50                   	push   %eax
  80062c:	53                   	push   %ebx
  80062d:	e8 b1 1d 00 00       	call   8023e3 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  800632:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800639:	e8 6e fd ff ff       	call   8003ac <diskaddr>
  80063e:	83 c4 08             	add    $0x8,%esp
  800641:	68 0b 3b 80 00       	push   $0x803b0b
  800646:	50                   	push   %eax
  800647:	e8 09 1c 00 00       	call   802255 <strcpy>
	flush_block(diskaddr(1) + 20);
  80064c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800653:	e8 54 fd ff ff       	call   8003ac <diskaddr>
  800658:	83 c0 14             	add    $0x14,%eax
  80065b:	89 04 24             	mov    %eax,(%esp)
  80065e:	e8 c7 fd ff ff       	call   80042a <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800663:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80066a:	e8 3d fd ff ff       	call   8003ac <diskaddr>
  80066f:	89 04 24             	mov    %eax,(%esp)
  800672:	e8 6d fd ff ff       	call   8003e4 <va_is_mapped>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	84 c0                	test   %al,%al
  80067c:	0f 84 17 01 00 00    	je     800799 <bc_init+0x2ab>
	sys_page_unmap(0, diskaddr(1));
  800682:	83 ec 0c             	sub    $0xc,%esp
  800685:	6a 01                	push   $0x1
  800687:	e8 20 fd ff ff       	call   8003ac <diskaddr>
  80068c:	83 c4 08             	add    $0x8,%esp
  80068f:	50                   	push   %eax
  800690:	6a 00                	push   $0x0
  800692:	e8 3c 20 00 00       	call   8026d3 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800697:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80069e:	e8 09 fd ff ff       	call   8003ac <diskaddr>
  8006a3:	89 04 24             	mov    %eax,(%esp)
  8006a6:	e8 39 fd ff ff       	call   8003e4 <va_is_mapped>
  8006ab:	83 c4 10             	add    $0x10,%esp
  8006ae:	84 c0                	test   %al,%al
  8006b0:	0f 85 fc 00 00 00    	jne    8007b2 <bc_init+0x2c4>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006b6:	83 ec 0c             	sub    $0xc,%esp
  8006b9:	6a 01                	push   $0x1
  8006bb:	e8 ec fc ff ff       	call   8003ac <diskaddr>
  8006c0:	83 c4 08             	add    $0x8,%esp
  8006c3:	68 0b 3b 80 00       	push   $0x803b0b
  8006c8:	50                   	push   %eax
  8006c9:	e8 2d 1c 00 00       	call   8022fb <strcmp>
  8006ce:	83 c4 10             	add    $0x10,%esp
  8006d1:	85 c0                	test   %eax,%eax
  8006d3:	0f 85 f2 00 00 00    	jne    8007cb <bc_init+0x2dd>
	memmove(diskaddr(1), &backup, sizeof backup);
  8006d9:	83 ec 0c             	sub    $0xc,%esp
  8006dc:	6a 01                	push   $0x1
  8006de:	e8 c9 fc ff ff       	call   8003ac <diskaddr>
  8006e3:	83 c4 0c             	add    $0xc,%esp
  8006e6:	68 08 01 00 00       	push   $0x108
  8006eb:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  8006f1:	52                   	push   %edx
  8006f2:	50                   	push   %eax
  8006f3:	e8 eb 1c 00 00       	call   8023e3 <memmove>
	flush_block(diskaddr(1));
  8006f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006ff:	e8 a8 fc ff ff       	call   8003ac <diskaddr>
  800704:	89 04 24             	mov    %eax,(%esp)
  800707:	e8 1e fd ff ff       	call   80042a <flush_block>
	cprintf("block cache is good\n");
  80070c:	c7 04 24 47 3b 80 00 	movl   $0x803b47,(%esp)
  800713:	e8 1e 15 00 00       	call   801c36 <cprintf>
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800718:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80071f:	e8 88 fc ff ff       	call   8003ac <diskaddr>
  800724:	83 c4 0c             	add    $0xc,%esp
  800727:	68 08 01 00 00       	push   $0x108
  80072c:	50                   	push   %eax
  80072d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800733:	50                   	push   %eax
  800734:	e8 aa 1c 00 00       	call   8023e3 <memmove>
}
  800739:	83 c4 10             	add    $0x10,%esp
  80073c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80073f:	c9                   	leave  
  800740:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  800741:	68 2d 3b 80 00       	push   $0x803b2d
  800746:	68 7d 39 80 00       	push   $0x80397d
  80074b:	6a 6c                	push   $0x6c
  80074d:	68 94 3a 80 00       	push   $0x803a94
  800752:	e8 04 14 00 00       	call   801b5b <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  800757:	68 12 3b 80 00       	push   $0x803b12
  80075c:	68 7d 39 80 00       	push   $0x80397d
  800761:	6a 6d                	push   $0x6d
  800763:	68 94 3a 80 00       	push   $0x803a94
  800768:	e8 ee 13 00 00       	call   801b5b <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  80076d:	68 2c 3b 80 00       	push   $0x803b2c
  800772:	68 7d 39 80 00       	push   $0x80397d
  800777:	6a 71                	push   $0x71
  800779:	68 94 3a 80 00       	push   $0x803a94
  80077e:	e8 d8 13 00 00       	call   801b5b <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800783:	68 70 3a 80 00       	push   $0x803a70
  800788:	68 7d 39 80 00       	push   $0x80397d
  80078d:	6a 74                	push   $0x74
  80078f:	68 94 3a 80 00       	push   $0x803a94
  800794:	e8 c2 13 00 00       	call   801b5b <_panic>
	assert(va_is_mapped(diskaddr(1)));
  800799:	68 2d 3b 80 00       	push   $0x803b2d
  80079e:	68 7d 39 80 00       	push   $0x80397d
  8007a3:	68 85 00 00 00       	push   $0x85
  8007a8:	68 94 3a 80 00       	push   $0x803a94
  8007ad:	e8 a9 13 00 00       	call   801b5b <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  8007b2:	68 2c 3b 80 00       	push   $0x803b2c
  8007b7:	68 7d 39 80 00       	push   $0x80397d
  8007bc:	68 8d 00 00 00       	push   $0x8d
  8007c1:	68 94 3a 80 00       	push   $0x803a94
  8007c6:	e8 90 13 00 00       	call   801b5b <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8007cb:	68 70 3a 80 00       	push   $0x803a70
  8007d0:	68 7d 39 80 00       	push   $0x80397d
  8007d5:	68 90 00 00 00       	push   $0x90
  8007da:	68 94 3a 80 00       	push   $0x803a94
  8007df:	e8 77 13 00 00       	call   801b5b <_panic>

008007e4 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  8007e4:	55                   	push   %ebp
  8007e5:	89 e5                	mov    %esp,%ebp
  8007e7:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  8007ea:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8007ef:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  8007f5:	75 1b                	jne    800812 <check_super+0x2e>
		panic("bad file system magic number");

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  8007f7:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  8007fe:	77 26                	ja     800826 <check_super+0x42>
		panic("file system is too large");

	cprintf("superblock is good\n");
  800800:	83 ec 0c             	sub    $0xc,%esp
  800803:	68 9a 3b 80 00       	push   $0x803b9a
  800808:	e8 29 14 00 00       	call   801c36 <cprintf>
}
  80080d:	83 c4 10             	add    $0x10,%esp
  800810:	c9                   	leave  
  800811:	c3                   	ret    
		panic("bad file system magic number");
  800812:	83 ec 04             	sub    $0x4,%esp
  800815:	68 5c 3b 80 00       	push   $0x803b5c
  80081a:	6a 0f                	push   $0xf
  80081c:	68 79 3b 80 00       	push   $0x803b79
  800821:	e8 35 13 00 00       	call   801b5b <_panic>
		panic("file system is too large");
  800826:	83 ec 04             	sub    $0x4,%esp
  800829:	68 81 3b 80 00       	push   $0x803b81
  80082e:	6a 12                	push   $0x12
  800830:	68 79 3b 80 00       	push   $0x803b79
  800835:	e8 21 13 00 00       	call   801b5b <_panic>

0080083a <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	53                   	push   %ebx
  80083e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  800841:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
		return 0;
  800847:	b8 00 00 00 00       	mov    $0x0,%eax
	if (super == 0 || blockno >= super->s_nblocks)
  80084c:	85 d2                	test   %edx,%edx
  80084e:	74 1d                	je     80086d <block_is_free+0x33>
  800850:	39 4a 04             	cmp    %ecx,0x4(%edx)
  800853:	76 18                	jbe    80086d <block_is_free+0x33>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800855:	89 cb                	mov    %ecx,%ebx
  800857:	c1 eb 05             	shr    $0x5,%ebx
  80085a:	b8 01 00 00 00       	mov    $0x1,%eax
  80085f:	d3 e0                	shl    %cl,%eax
  800861:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  800867:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  80086a:	0f 95 c0             	setne  %al
		return 1;
	return 0;
}
  80086d:	5b                   	pop    %ebx
  80086e:	5d                   	pop    %ebp
  80086f:	c3                   	ret    

00800870 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	53                   	push   %ebx
  800874:	83 ec 04             	sub    $0x4,%esp
  800877:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  80087a:	85 c9                	test   %ecx,%ecx
  80087c:	74 1a                	je     800898 <free_block+0x28>
		panic("attempt to free zero block");
	bitmap[blockno/32] |= 1<<(blockno%32);
  80087e:	89 cb                	mov    %ecx,%ebx
  800880:	c1 eb 05             	shr    $0x5,%ebx
  800883:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  800889:	b8 01 00 00 00       	mov    $0x1,%eax
  80088e:	d3 e0                	shl    %cl,%eax
  800890:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  800893:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800896:	c9                   	leave  
  800897:	c3                   	ret    
		panic("attempt to free zero block");
  800898:	83 ec 04             	sub    $0x4,%esp
  80089b:	68 ae 3b 80 00       	push   $0x803bae
  8008a0:	6a 2d                	push   $0x2d
  8008a2:	68 79 3b 80 00       	push   $0x803b79
  8008a7:	e8 af 12 00 00       	call   801b5b <_panic>

008008ac <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	56                   	push   %esi
  8008b0:	53                   	push   %ebx
	// The bitmap consists of one or more blocks.  A single bitmap block
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	int nblock_bitmap = (super->s_nblocks + BLKBITSIZE - 1) / BLKBITSIZE;
  8008b1:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8008b6:	8b 70 04             	mov    0x4(%eax),%esi
  8008b9:	8d 9e ff 7f 00 00    	lea    0x7fff(%esi),%ebx
  8008bf:	c1 eb 0f             	shr    $0xf,%ebx

	for (uint32_t i = 2 + nblock_bitmap; i < super->s_nblocks; i++)
  8008c2:	83 c3 02             	add    $0x2,%ebx
  8008c5:	39 de                	cmp    %ebx,%esi
  8008c7:	76 45                	jbe    80090e <alloc_block+0x62>
		if (block_is_free(i))
  8008c9:	53                   	push   %ebx
  8008ca:	e8 6b ff ff ff       	call   80083a <block_is_free>
  8008cf:	83 c4 04             	add    $0x4,%esp
  8008d2:	84 c0                	test   %al,%al
  8008d4:	75 05                	jne    8008db <alloc_block+0x2f>
	for (uint32_t i = 2 + nblock_bitmap; i < super->s_nblocks; i++)
  8008d6:	83 c3 01             	add    $0x1,%ebx
  8008d9:	eb ea                	jmp    8008c5 <alloc_block+0x19>
		{
			bitmap[i/32] &= ~(1 << (i%32));
  8008db:	89 d8                	mov    %ebx,%eax
  8008dd:	c1 e8 05             	shr    $0x5,%eax
  8008e0:	c1 e0 02             	shl    $0x2,%eax
  8008e3:	89 c6                	mov    %eax,%esi
  8008e5:	03 35 04 a0 80 00    	add    0x80a004,%esi
  8008eb:	ba 01 00 00 00       	mov    $0x1,%edx
  8008f0:	89 d9                	mov    %ebx,%ecx
  8008f2:	d3 e2                	shl    %cl,%edx
  8008f4:	f7 d2                	not    %edx
  8008f6:	21 16                	and    %edx,(%esi)
			flush_block(bitmap + i/32);
  8008f8:	83 ec 0c             	sub    $0xc,%esp
  8008fb:	03 05 04 a0 80 00    	add    0x80a004,%eax
  800901:	50                   	push   %eax
  800902:	e8 23 fb ff ff       	call   80042a <flush_block>
			return i;
  800907:	89 d8                	mov    %ebx,%eax
  800909:	83 c4 10             	add    $0x10,%esp
  80090c:	eb 05                	jmp    800913 <alloc_block+0x67>
		}
	
	return -E_NO_DISK;
  80090e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
}
  800913:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800916:	5b                   	pop    %ebx
  800917:	5e                   	pop    %esi
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	57                   	push   %edi
  80091e:	56                   	push   %esi
  80091f:	53                   	push   %ebx
  800920:	83 ec 1c             	sub    $0x1c,%esp
  800923:	8b 7d 08             	mov    0x8(%ebp),%edi
       // LAB 5: Your code here.
       if (filebno >= NDIRECT + NINDIRECT) return -E_INVAL;
  800926:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  80092c:	0f 87 8f 00 00 00    	ja     8009c1 <file_block_walk+0xa7>
       if (filebno < NDIRECT)
  800932:	83 fa 09             	cmp    $0x9,%edx
  800935:	76 7a                	jbe    8009b1 <file_block_walk+0x97>
  800937:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80093a:	89 d3                	mov    %edx,%ebx
  80093c:	89 c6                	mov    %eax,%esi
       {
       		*ppdiskbno = f->f_direct + filebno;
       		return 0;
       }
       if (f->f_indirect == 0)
  80093e:	83 b8 b0 00 00 00 00 	cmpl   $0x0,0xb0(%eax)
  800945:	75 43                	jne    80098a <file_block_walk+0x70>
       {
       		if (!alloc) return -E_NOT_FOUND;
  800947:	89 f8                	mov    %edi,%eax
  800949:	84 c0                	test   %al,%al
  80094b:	74 7b                	je     8009c8 <file_block_walk+0xae>
       		int r;
       		if ((r = alloc_block()) < 0) return -E_NO_DISK;
  80094d:	e8 5a ff ff ff       	call   8008ac <alloc_block>
  800952:	89 c7                	mov    %eax,%edi
  800954:	85 c0                	test   %eax,%eax
  800956:	78 77                	js     8009cf <file_block_walk+0xb5>
       		f->f_indirect = r;
  800958:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
       		memset(diskaddr(r), 0, BLKSIZE);
  80095e:	83 ec 0c             	sub    $0xc,%esp
  800961:	50                   	push   %eax
  800962:	e8 45 fa ff ff       	call   8003ac <diskaddr>
  800967:	83 c4 0c             	add    $0xc,%esp
  80096a:	68 00 10 00 00       	push   $0x1000
  80096f:	6a 00                	push   $0x0
  800971:	50                   	push   %eax
  800972:	e8 1f 1a 00 00       	call   802396 <memset>
       		flush_block(diskaddr(r));
  800977:	89 3c 24             	mov    %edi,(%esp)
  80097a:	e8 2d fa ff ff       	call   8003ac <diskaddr>
  80097f:	89 04 24             	mov    %eax,(%esp)
  800982:	e8 a3 fa ff ff       	call   80042a <flush_block>
  800987:	83 c4 10             	add    $0x10,%esp
       }
       *ppdiskbno = (uint32_t*)diskaddr(f->f_indirect) + (filebno - NDIRECT);
  80098a:	83 ec 0c             	sub    $0xc,%esp
  80098d:	ff b6 b0 00 00 00    	pushl  0xb0(%esi)
  800993:	e8 14 fa ff ff       	call   8003ac <diskaddr>
  800998:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  80099c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80099f:	89 03                	mov    %eax,(%ebx)
       return 0;
  8009a1:	83 c4 10             	add    $0x10,%esp
  8009a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009ac:	5b                   	pop    %ebx
  8009ad:	5e                   	pop    %esi
  8009ae:	5f                   	pop    %edi
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    
       		*ppdiskbno = f->f_direct + filebno;
  8009b1:	8d 84 90 88 00 00 00 	lea    0x88(%eax,%edx,4),%eax
  8009b8:	89 01                	mov    %eax,(%ecx)
       		return 0;
  8009ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bf:	eb e8                	jmp    8009a9 <file_block_walk+0x8f>
       if (filebno >= NDIRECT + NINDIRECT) return -E_INVAL;
  8009c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009c6:	eb e1                	jmp    8009a9 <file_block_walk+0x8f>
       		if (!alloc) return -E_NOT_FOUND;
  8009c8:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8009cd:	eb da                	jmp    8009a9 <file_block_walk+0x8f>
       		if ((r = alloc_block()) < 0) return -E_NO_DISK;
  8009cf:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8009d4:	eb d3                	jmp    8009a9 <file_block_walk+0x8f>

008009d6 <check_bitmap>:
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	56                   	push   %esi
  8009da:	53                   	push   %ebx
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8009db:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8009e0:	8b 70 04             	mov    0x4(%eax),%esi
  8009e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009e8:	89 d8                	mov    %ebx,%eax
  8009ea:	c1 e0 0f             	shl    $0xf,%eax
  8009ed:	39 c6                	cmp    %eax,%esi
  8009ef:	76 2b                	jbe    800a1c <check_bitmap+0x46>
		assert(!block_is_free(2+i));
  8009f1:	8d 43 02             	lea    0x2(%ebx),%eax
  8009f4:	50                   	push   %eax
  8009f5:	e8 40 fe ff ff       	call   80083a <block_is_free>
  8009fa:	83 c4 04             	add    $0x4,%esp
  8009fd:	84 c0                	test   %al,%al
  8009ff:	75 05                	jne    800a06 <check_bitmap+0x30>
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800a01:	83 c3 01             	add    $0x1,%ebx
  800a04:	eb e2                	jmp    8009e8 <check_bitmap+0x12>
		assert(!block_is_free(2+i));
  800a06:	68 c9 3b 80 00       	push   $0x803bc9
  800a0b:	68 7d 39 80 00       	push   $0x80397d
  800a10:	6a 59                	push   $0x59
  800a12:	68 79 3b 80 00       	push   $0x803b79
  800a17:	e8 3f 11 00 00       	call   801b5b <_panic>
	assert(!block_is_free(0));
  800a1c:	83 ec 0c             	sub    $0xc,%esp
  800a1f:	6a 00                	push   $0x0
  800a21:	e8 14 fe ff ff       	call   80083a <block_is_free>
  800a26:	83 c4 10             	add    $0x10,%esp
  800a29:	84 c0                	test   %al,%al
  800a2b:	75 28                	jne    800a55 <check_bitmap+0x7f>
	assert(!block_is_free(1));
  800a2d:	83 ec 0c             	sub    $0xc,%esp
  800a30:	6a 01                	push   $0x1
  800a32:	e8 03 fe ff ff       	call   80083a <block_is_free>
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	84 c0                	test   %al,%al
  800a3c:	75 2d                	jne    800a6b <check_bitmap+0x95>
	cprintf("bitmap is good\n");
  800a3e:	83 ec 0c             	sub    $0xc,%esp
  800a41:	68 01 3c 80 00       	push   $0x803c01
  800a46:	e8 eb 11 00 00       	call   801c36 <cprintf>
}
  800a4b:	83 c4 10             	add    $0x10,%esp
  800a4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a51:	5b                   	pop    %ebx
  800a52:	5e                   	pop    %esi
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    
	assert(!block_is_free(0));
  800a55:	68 dd 3b 80 00       	push   $0x803bdd
  800a5a:	68 7d 39 80 00       	push   $0x80397d
  800a5f:	6a 5c                	push   $0x5c
  800a61:	68 79 3b 80 00       	push   $0x803b79
  800a66:	e8 f0 10 00 00       	call   801b5b <_panic>
	assert(!block_is_free(1));
  800a6b:	68 ef 3b 80 00       	push   $0x803bef
  800a70:	68 7d 39 80 00       	push   $0x80397d
  800a75:	6a 5d                	push   $0x5d
  800a77:	68 79 3b 80 00       	push   $0x803b79
  800a7c:	e8 da 10 00 00       	call   801b5b <_panic>

00800a81 <fs_init>:
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	83 ec 08             	sub    $0x8,%esp
	if (ide_probe_disk1())
  800a87:	e8 d3 f5 ff ff       	call   80005f <ide_probe_disk1>
  800a8c:	84 c0                	test   %al,%al
  800a8e:	75 41                	jne    800ad1 <fs_init+0x50>
		ide_set_disk(0);
  800a90:	83 ec 0c             	sub    $0xc,%esp
  800a93:	6a 00                	push   $0x0
  800a95:	e8 27 f6 ff ff       	call   8000c1 <ide_set_disk>
  800a9a:	83 c4 10             	add    $0x10,%esp
	bc_init();
  800a9d:	e8 4c fa ff ff       	call   8004ee <bc_init>
	super = diskaddr(1);
  800aa2:	83 ec 0c             	sub    $0xc,%esp
  800aa5:	6a 01                	push   $0x1
  800aa7:	e8 00 f9 ff ff       	call   8003ac <diskaddr>
  800aac:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_super();
  800ab1:	e8 2e fd ff ff       	call   8007e4 <check_super>
	bitmap = diskaddr(2);
  800ab6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800abd:	e8 ea f8 ff ff       	call   8003ac <diskaddr>
  800ac2:	a3 04 a0 80 00       	mov    %eax,0x80a004
	check_bitmap();
  800ac7:	e8 0a ff ff ff       	call   8009d6 <check_bitmap>
}
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	c9                   	leave  
  800ad0:	c3                   	ret    
		ide_set_disk(1);
  800ad1:	83 ec 0c             	sub    $0xc,%esp
  800ad4:	6a 01                	push   $0x1
  800ad6:	e8 e6 f5 ff ff       	call   8000c1 <ide_set_disk>
  800adb:	83 c4 10             	add    $0x10,%esp
  800ade:	eb bd                	jmp    800a9d <fs_init+0x1c>

00800ae0 <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	53                   	push   %ebx
  800ae4:	83 ec 20             	sub    $0x20,%esp
       // LAB 5: Your code here.
       int r;
       uint32_t* pdiskbno;

       if ((r = file_block_walk(f, filebno, &pdiskbno, 1)) < 0) return r;
  800ae7:	6a 01                	push   $0x1
  800ae9:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	e8 23 fe ff ff       	call   80091a <file_block_walk>
  800af7:	89 c3                	mov    %eax,%ebx
  800af9:	83 c4 10             	add    $0x10,%esp
  800afc:	85 c0                	test   %eax,%eax
  800afe:	78 5e                	js     800b5e <file_get_block+0x7e>
       if (*pdiskbno == 0)
  800b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b03:	83 38 00             	cmpl   $0x0,(%eax)
  800b06:	75 3c                	jne    800b44 <file_get_block+0x64>
       {
       		if ((r = alloc_block()) < 0) return r;
  800b08:	e8 9f fd ff ff       	call   8008ac <alloc_block>
  800b0d:	89 c3                	mov    %eax,%ebx
  800b0f:	85 c0                	test   %eax,%eax
  800b11:	78 4b                	js     800b5e <file_get_block+0x7e>
       		*pdiskbno = r;
  800b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b16:	89 18                	mov    %ebx,(%eax)
       		memset(diskaddr(r), 0, BLKSIZE);
  800b18:	83 ec 0c             	sub    $0xc,%esp
  800b1b:	53                   	push   %ebx
  800b1c:	e8 8b f8 ff ff       	call   8003ac <diskaddr>
  800b21:	83 c4 0c             	add    $0xc,%esp
  800b24:	68 00 10 00 00       	push   $0x1000
  800b29:	6a 00                	push   $0x0
  800b2b:	50                   	push   %eax
  800b2c:	e8 65 18 00 00       	call   802396 <memset>
       		flush_block(diskaddr(r));
  800b31:	89 1c 24             	mov    %ebx,(%esp)
  800b34:	e8 73 f8 ff ff       	call   8003ac <diskaddr>
  800b39:	89 04 24             	mov    %eax,(%esp)
  800b3c:	e8 e9 f8 ff ff       	call   80042a <flush_block>
  800b41:	83 c4 10             	add    $0x10,%esp
       }

       *blk = diskaddr(*pdiskbno);
  800b44:	83 ec 0c             	sub    $0xc,%esp
  800b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b4a:	ff 30                	pushl  (%eax)
  800b4c:	e8 5b f8 ff ff       	call   8003ac <diskaddr>
  800b51:	8b 55 10             	mov    0x10(%ebp),%edx
  800b54:	89 02                	mov    %eax,(%edx)
       return 0;
  800b56:	83 c4 10             	add    $0x10,%esp
  800b59:	bb 00 00 00 00       	mov    $0x0,%ebx
}
  800b5e:	89 d8                	mov    %ebx,%eax
  800b60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	57                   	push   %edi
  800b69:	56                   	push   %esi
  800b6a:	53                   	push   %ebx
  800b6b:	81 ec bc 00 00 00    	sub    $0xbc,%esp
  800b71:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  800b77:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
  800b7d:	eb 03                	jmp    800b82 <walk_path+0x1d>
		p++;
  800b7f:	83 c0 01             	add    $0x1,%eax
	while (*p == '/')
  800b82:	80 38 2f             	cmpb   $0x2f,(%eax)
  800b85:	74 f8                	je     800b7f <walk_path+0x1a>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800b87:	8b 0d 08 a0 80 00    	mov    0x80a008,%ecx
  800b8d:	83 c1 08             	add    $0x8,%ecx
  800b90:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;
  800b96:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800b9d:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800ba3:	85 c9                	test   %ecx,%ecx
  800ba5:	74 06                	je     800bad <walk_path+0x48>
		*pdir = 0;
  800ba7:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800bad:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  800bb3:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	dir = 0;
  800bb9:	ba 00 00 00 00       	mov    $0x0,%edx
	while (*path != '\0') {
  800bbe:	e9 b4 01 00 00       	jmp    800d77 <walk_path+0x212>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800bc3:	83 c7 01             	add    $0x1,%edi
		while (*path != '/' && *path != '\0')
  800bc6:	0f b6 17             	movzbl (%edi),%edx
  800bc9:	80 fa 2f             	cmp    $0x2f,%dl
  800bcc:	74 04                	je     800bd2 <walk_path+0x6d>
  800bce:	84 d2                	test   %dl,%dl
  800bd0:	75 f1                	jne    800bc3 <walk_path+0x5e>
		if (path - p >= MAXNAMELEN)
  800bd2:	89 fb                	mov    %edi,%ebx
  800bd4:	29 c3                	sub    %eax,%ebx
  800bd6:	83 fb 7f             	cmp    $0x7f,%ebx
  800bd9:	0f 8f 70 01 00 00    	jg     800d4f <walk_path+0x1ea>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800bdf:	83 ec 04             	sub    $0x4,%esp
  800be2:	53                   	push   %ebx
  800be3:	50                   	push   %eax
  800be4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800bea:	50                   	push   %eax
  800beb:	e8 f3 17 00 00       	call   8023e3 <memmove>
		name[path - p] = '\0';
  800bf0:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800bf7:	00 
  800bf8:	83 c4 10             	add    $0x10,%esp
  800bfb:	eb 03                	jmp    800c00 <walk_path+0x9b>
		p++;
  800bfd:	83 c7 01             	add    $0x1,%edi
	while (*p == '/')
  800c00:	80 3f 2f             	cmpb   $0x2f,(%edi)
  800c03:	74 f8                	je     800bfd <walk_path+0x98>
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800c05:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c0b:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800c12:	0f 85 3e 01 00 00    	jne    800d56 <walk_path+0x1f1>
	assert((dir->f_size % BLKSIZE) == 0);
  800c18:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800c1e:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800c23:	0f 85 98 00 00 00    	jne    800cc1 <walk_path+0x15c>
	nblock = dir->f_size / BLKSIZE;
  800c29:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800c2f:	85 c0                	test   %eax,%eax
  800c31:	0f 48 c2             	cmovs  %edx,%eax
  800c34:	c1 f8 0c             	sar    $0xc,%eax
  800c37:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	for (i = 0; i < nblock; i++) {
  800c3d:	c7 85 50 ff ff ff 00 	movl   $0x0,-0xb0(%ebp)
  800c44:	00 00 00 
			if (strcmp(f[j].f_name, name) == 0) {
  800c47:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  800c4d:	89 bd 44 ff ff ff    	mov    %edi,-0xbc(%ebp)
	for (i = 0; i < nblock; i++) {
  800c53:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800c59:	39 8d 48 ff ff ff    	cmp    %ecx,-0xb8(%ebp)
  800c5f:	74 79                	je     800cda <walk_path+0x175>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800c61:	83 ec 04             	sub    $0x4,%esp
  800c64:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800c6a:	50                   	push   %eax
  800c6b:	ff b5 50 ff ff ff    	pushl  -0xb0(%ebp)
  800c71:	ff b5 4c ff ff ff    	pushl  -0xb4(%ebp)
  800c77:	e8 64 fe ff ff       	call   800ae0 <file_get_block>
  800c7c:	83 c4 10             	add    $0x10,%esp
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	0f 88 fc 00 00 00    	js     800d83 <walk_path+0x21e>
  800c87:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  800c8d:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
			if (strcmp(f[j].f_name, name) == 0) {
  800c93:	89 9d 54 ff ff ff    	mov    %ebx,-0xac(%ebp)
  800c99:	83 ec 08             	sub    $0x8,%esp
  800c9c:	56                   	push   %esi
  800c9d:	53                   	push   %ebx
  800c9e:	e8 58 16 00 00       	call   8022fb <strcmp>
  800ca3:	83 c4 10             	add    $0x10,%esp
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	0f 84 af 00 00 00    	je     800d5d <walk_path+0x1f8>
  800cae:	81 c3 00 01 00 00    	add    $0x100,%ebx
		for (j = 0; j < BLKFILES; j++)
  800cb4:	39 fb                	cmp    %edi,%ebx
  800cb6:	75 db                	jne    800c93 <walk_path+0x12e>
	for (i = 0; i < nblock; i++) {
  800cb8:	83 85 50 ff ff ff 01 	addl   $0x1,-0xb0(%ebp)
  800cbf:	eb 92                	jmp    800c53 <walk_path+0xee>
	assert((dir->f_size % BLKSIZE) == 0);
  800cc1:	68 11 3c 80 00       	push   $0x803c11
  800cc6:	68 7d 39 80 00       	push   $0x80397d
  800ccb:	68 d1 00 00 00       	push   $0xd1
  800cd0:	68 79 3b 80 00       	push   $0x803b79
  800cd5:	e8 81 0e 00 00       	call   801b5b <_panic>
  800cda:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800ce0:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
			if (r == -E_NOT_FOUND && *path == '\0') {
  800ce5:	80 3f 00             	cmpb   $0x0,(%edi)
  800ce8:	0f 85 a4 00 00 00    	jne    800d92 <walk_path+0x22d>
				if (pdir)
  800cee:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	74 08                	je     800d00 <walk_path+0x19b>
					*pdir = dir;
  800cf8:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800cfe:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800d00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d04:	74 15                	je     800d1b <walk_path+0x1b6>
					strcpy(lastelem, name);
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800d0f:	50                   	push   %eax
  800d10:	ff 75 08             	pushl  0x8(%ebp)
  800d13:	e8 3d 15 00 00       	call   802255 <strcpy>
  800d18:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  800d1b:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			return r;
  800d27:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d2c:	eb 64                	jmp    800d92 <walk_path+0x22d>
		}
	}

	if (pdir)
  800d2e:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d34:	85 c0                	test   %eax,%eax
  800d36:	74 02                	je     800d3a <walk_path+0x1d5>
		*pdir = dir;
  800d38:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800d3a:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d40:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800d46:	89 08                	mov    %ecx,(%eax)
	return 0;
  800d48:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4d:	eb 43                	jmp    800d92 <walk_path+0x22d>
			return -E_BAD_PATH;
  800d4f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800d54:	eb 3c                	jmp    800d92 <walk_path+0x22d>
			return -E_NOT_FOUND;
  800d56:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d5b:	eb 35                	jmp    800d92 <walk_path+0x22d>
  800d5d:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
  800d63:	89 f8                	mov    %edi,%eax
  800d65:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
			if (strcmp(f[j].f_name, name) == 0) {
  800d6b:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  800d71:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	while (*path != '\0') {
  800d77:	80 38 00             	cmpb   $0x0,(%eax)
  800d7a:	74 b2                	je     800d2e <walk_path+0x1c9>
  800d7c:	89 c7                	mov    %eax,%edi
  800d7e:	e9 43 fe ff ff       	jmp    800bc6 <walk_path+0x61>
  800d83:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
			if (r == -E_NOT_FOUND && *path == '\0') {
  800d89:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800d8c:	0f 84 4e ff ff ff    	je     800ce0 <walk_path+0x17b>
}
  800d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  800da0:	6a 00                	push   $0x0
  800da2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da5:	ba 00 00 00 00       	mov    $0x0,%edx
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	e8 b3 fd ff ff       	call   800b65 <walk_path>
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	57                   	push   %edi
  800db8:	56                   	push   %esi
  800db9:	53                   	push   %ebx
  800dba:	83 ec 2c             	sub    $0x2c,%esp
  800dbd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800dc0:	8b 4d 14             	mov    0x14(%ebp),%ecx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  800dcc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (offset >= f->f_size)
  800dd1:	39 ca                	cmp    %ecx,%edx
  800dd3:	0f 8e 80 00 00 00    	jle    800e59 <file_read+0xa5>

	count = MIN(count, f->f_size - offset);
  800dd9:	29 ca                	sub    %ecx,%edx
  800ddb:	3b 55 10             	cmp    0x10(%ebp),%edx
  800dde:	89 d0                	mov    %edx,%eax
  800de0:	0f 47 45 10          	cmova  0x10(%ebp),%eax
  800de4:	89 45 d0             	mov    %eax,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800de7:	89 ce                	mov    %ecx,%esi
  800de9:	01 c1                	add    %eax,%ecx
  800deb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800dee:	89 f3                	mov    %esi,%ebx
  800df0:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  800df3:	76 61                	jbe    800e56 <file_read+0xa2>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800df5:	83 ec 04             	sub    $0x4,%esp
  800df8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800dfb:	50                   	push   %eax
  800dfc:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
  800e02:	85 f6                	test   %esi,%esi
  800e04:	0f 49 c6             	cmovns %esi,%eax
  800e07:	c1 f8 0c             	sar    $0xc,%eax
  800e0a:	50                   	push   %eax
  800e0b:	ff 75 08             	pushl  0x8(%ebp)
  800e0e:	e8 cd fc ff ff       	call   800ae0 <file_get_block>
  800e13:	83 c4 10             	add    $0x10,%esp
  800e16:	85 c0                	test   %eax,%eax
  800e18:	78 3f                	js     800e59 <file_read+0xa5>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800e1a:	89 f2                	mov    %esi,%edx
  800e1c:	c1 fa 1f             	sar    $0x1f,%edx
  800e1f:	c1 ea 14             	shr    $0x14,%edx
  800e22:	8d 04 16             	lea    (%esi,%edx,1),%eax
  800e25:	25 ff 0f 00 00       	and    $0xfff,%eax
  800e2a:	29 d0                	sub    %edx,%eax
  800e2c:	ba 00 10 00 00       	mov    $0x1000,%edx
  800e31:	29 c2                	sub    %eax,%edx
  800e33:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800e36:	29 d9                	sub    %ebx,%ecx
  800e38:	89 cb                	mov    %ecx,%ebx
  800e3a:	39 ca                	cmp    %ecx,%edx
  800e3c:	0f 46 da             	cmovbe %edx,%ebx
		memmove(buf, blk + pos % BLKSIZE, bn);
  800e3f:	83 ec 04             	sub    $0x4,%esp
  800e42:	53                   	push   %ebx
  800e43:	03 45 e4             	add    -0x1c(%ebp),%eax
  800e46:	50                   	push   %eax
  800e47:	57                   	push   %edi
  800e48:	e8 96 15 00 00       	call   8023e3 <memmove>
		pos += bn;
  800e4d:	01 de                	add    %ebx,%esi
		buf += bn;
  800e4f:	01 df                	add    %ebx,%edi
  800e51:	83 c4 10             	add    $0x10,%esp
  800e54:	eb 98                	jmp    800dee <file_read+0x3a>
	}

	return count;
  800e56:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800e59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    

00800e61 <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	57                   	push   %edi
  800e65:	56                   	push   %esi
  800e66:	53                   	push   %ebx
  800e67:	83 ec 2c             	sub    $0x2c,%esp
  800e6a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (f->f_size > newsize)
  800e6d:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  800e73:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e76:	7f 1f                	jg     800e97 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7b:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	flush_block(f);
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	56                   	push   %esi
  800e85:	e8 a0 f5 ff ff       	call   80042a <flush_block>
	return 0;
}
  800e8a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e92:	5b                   	pop    %ebx
  800e93:	5e                   	pop    %esi
  800e94:	5f                   	pop    %edi
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800e97:	8d b8 fe 1f 00 00    	lea    0x1ffe(%eax),%edi
  800e9d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ea2:	0f 49 f8             	cmovns %eax,%edi
  800ea5:	c1 ff 0c             	sar    $0xc,%edi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	05 fe 1f 00 00       	add    $0x1ffe,%eax
  800eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb3:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800eb9:	0f 49 c2             	cmovns %edx,%eax
  800ebc:	c1 f8 0c             	sar    $0xc,%eax
  800ebf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800ec2:	89 c3                	mov    %eax,%ebx
  800ec4:	eb 3c                	jmp    800f02 <file_set_size+0xa1>
	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800ec6:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
  800eca:	77 ac                	ja     800e78 <file_set_size+0x17>
  800ecc:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	74 a2                	je     800e78 <file_set_size+0x17>
		free_block(f->f_indirect);
  800ed6:	83 ec 0c             	sub    $0xc,%esp
  800ed9:	50                   	push   %eax
  800eda:	e8 91 f9 ff ff       	call   800870 <free_block>
		f->f_indirect = 0;
  800edf:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
  800ee6:	00 00 00 
  800ee9:	83 c4 10             	add    $0x10,%esp
  800eec:	eb 8a                	jmp    800e78 <file_set_size+0x17>
			cprintf("warning: file_free_block: %e", r);
  800eee:	83 ec 08             	sub    $0x8,%esp
  800ef1:	50                   	push   %eax
  800ef2:	68 2e 3c 80 00       	push   $0x803c2e
  800ef7:	e8 3a 0d 00 00       	call   801c36 <cprintf>
  800efc:	83 c4 10             	add    $0x10,%esp
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800eff:	83 c3 01             	add    $0x1,%ebx
  800f02:	39 df                	cmp    %ebx,%edi
  800f04:	76 c0                	jbe    800ec6 <file_set_size+0x65>
	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800f06:	83 ec 0c             	sub    $0xc,%esp
  800f09:	6a 00                	push   $0x0
  800f0b:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800f0e:	89 da                	mov    %ebx,%edx
  800f10:	89 f0                	mov    %esi,%eax
  800f12:	e8 03 fa ff ff       	call   80091a <file_block_walk>
  800f17:	83 c4 10             	add    $0x10,%esp
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	78 d0                	js     800eee <file_set_size+0x8d>
	if (*ptr) {
  800f1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f21:	8b 00                	mov    (%eax),%eax
  800f23:	85 c0                	test   %eax,%eax
  800f25:	74 d8                	je     800eff <file_set_size+0x9e>
		free_block(*ptr);
  800f27:	83 ec 0c             	sub    $0xc,%esp
  800f2a:	50                   	push   %eax
  800f2b:	e8 40 f9 ff ff       	call   800870 <free_block>
		*ptr = 0;
  800f30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800f39:	83 c4 10             	add    $0x10,%esp
  800f3c:	eb c1                	jmp    800eff <file_set_size+0x9e>

00800f3e <file_write>:
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	57                   	push   %edi
  800f42:	56                   	push   %esi
  800f43:	53                   	push   %ebx
  800f44:	83 ec 2c             	sub    $0x2c,%esp
  800f47:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f4a:	8b 75 14             	mov    0x14(%ebp),%esi
	if (offset + count > f->f_size)
  800f4d:	89 f0                	mov    %esi,%eax
  800f4f:	03 45 10             	add    0x10(%ebp),%eax
  800f52:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800f55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f58:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  800f5e:	77 68                	ja     800fc8 <file_write+0x8a>
	for (pos = offset; pos < offset + count; ) {
  800f60:	89 f3                	mov    %esi,%ebx
  800f62:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  800f65:	76 74                	jbe    800fdb <file_write+0x9d>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800f67:	83 ec 04             	sub    $0x4,%esp
  800f6a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f6d:	50                   	push   %eax
  800f6e:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
  800f74:	85 f6                	test   %esi,%esi
  800f76:	0f 49 c6             	cmovns %esi,%eax
  800f79:	c1 f8 0c             	sar    $0xc,%eax
  800f7c:	50                   	push   %eax
  800f7d:	ff 75 08             	pushl  0x8(%ebp)
  800f80:	e8 5b fb ff ff       	call   800ae0 <file_get_block>
  800f85:	83 c4 10             	add    $0x10,%esp
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	78 52                	js     800fde <file_write+0xa0>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800f8c:	89 f2                	mov    %esi,%edx
  800f8e:	c1 fa 1f             	sar    $0x1f,%edx
  800f91:	c1 ea 14             	shr    $0x14,%edx
  800f94:	8d 04 16             	lea    (%esi,%edx,1),%eax
  800f97:	25 ff 0f 00 00       	and    $0xfff,%eax
  800f9c:	29 d0                	sub    %edx,%eax
  800f9e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800fa3:	29 c1                	sub    %eax,%ecx
  800fa5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fa8:	29 da                	sub    %ebx,%edx
  800faa:	39 d1                	cmp    %edx,%ecx
  800fac:	89 d3                	mov    %edx,%ebx
  800fae:	0f 46 d9             	cmovbe %ecx,%ebx
		memmove(blk + pos % BLKSIZE, buf, bn);
  800fb1:	83 ec 04             	sub    $0x4,%esp
  800fb4:	53                   	push   %ebx
  800fb5:	57                   	push   %edi
  800fb6:	03 45 e4             	add    -0x1c(%ebp),%eax
  800fb9:	50                   	push   %eax
  800fba:	e8 24 14 00 00       	call   8023e3 <memmove>
		pos += bn;
  800fbf:	01 de                	add    %ebx,%esi
		buf += bn;
  800fc1:	01 df                	add    %ebx,%edi
  800fc3:	83 c4 10             	add    $0x10,%esp
  800fc6:	eb 98                	jmp    800f60 <file_write+0x22>
		if ((r = file_set_size(f, offset + count)) < 0)
  800fc8:	83 ec 08             	sub    $0x8,%esp
  800fcb:	50                   	push   %eax
  800fcc:	51                   	push   %ecx
  800fcd:	e8 8f fe ff ff       	call   800e61 <file_set_size>
  800fd2:	83 c4 10             	add    $0x10,%esp
  800fd5:	85 c0                	test   %eax,%eax
  800fd7:	79 87                	jns    800f60 <file_write+0x22>
  800fd9:	eb 03                	jmp    800fde <file_write+0xa0>
	return count;
  800fdb:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe1:	5b                   	pop    %ebx
  800fe2:	5e                   	pop    %esi
  800fe3:	5f                   	pop    %edi
  800fe4:	5d                   	pop    %ebp
  800fe5:	c3                   	ret    

00800fe6 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	56                   	push   %esi
  800fea:	53                   	push   %ebx
  800feb:	83 ec 10             	sub    $0x10,%esp
  800fee:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800ff1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff6:	eb 03                	jmp    800ffb <file_flush+0x15>
  800ff8:	83 c3 01             	add    $0x1,%ebx
  800ffb:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  801001:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801007:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  80100d:	85 c9                	test   %ecx,%ecx
  80100f:	0f 49 c1             	cmovns %ecx,%eax
  801012:	c1 f8 0c             	sar    $0xc,%eax
  801015:	39 d8                	cmp    %ebx,%eax
  801017:	7e 3b                	jle    801054 <file_flush+0x6e>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801019:	83 ec 0c             	sub    $0xc,%esp
  80101c:	6a 00                	push   $0x0
  80101e:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  801021:	89 da                	mov    %ebx,%edx
  801023:	89 f0                	mov    %esi,%eax
  801025:	e8 f0 f8 ff ff       	call   80091a <file_block_walk>
  80102a:	83 c4 10             	add    $0x10,%esp
  80102d:	85 c0                	test   %eax,%eax
  80102f:	78 c7                	js     800ff8 <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  801031:	8b 45 f4             	mov    -0xc(%ebp),%eax
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801034:	85 c0                	test   %eax,%eax
  801036:	74 c0                	je     800ff8 <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  801038:	8b 00                	mov    (%eax),%eax
  80103a:	85 c0                	test   %eax,%eax
  80103c:	74 ba                	je     800ff8 <file_flush+0x12>
			continue;
		flush_block(diskaddr(*pdiskbno));
  80103e:	83 ec 0c             	sub    $0xc,%esp
  801041:	50                   	push   %eax
  801042:	e8 65 f3 ff ff       	call   8003ac <diskaddr>
  801047:	89 04 24             	mov    %eax,(%esp)
  80104a:	e8 db f3 ff ff       	call   80042a <flush_block>
  80104f:	83 c4 10             	add    $0x10,%esp
  801052:	eb a4                	jmp    800ff8 <file_flush+0x12>
	}
	flush_block(f);
  801054:	83 ec 0c             	sub    $0xc,%esp
  801057:	56                   	push   %esi
  801058:	e8 cd f3 ff ff       	call   80042a <flush_block>
	if (f->f_indirect)
  80105d:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  801063:	83 c4 10             	add    $0x10,%esp
  801066:	85 c0                	test   %eax,%eax
  801068:	75 07                	jne    801071 <file_flush+0x8b>
		flush_block(diskaddr(f->f_indirect));
}
  80106a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80106d:	5b                   	pop    %ebx
  80106e:	5e                   	pop    %esi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
		flush_block(diskaddr(f->f_indirect));
  801071:	83 ec 0c             	sub    $0xc,%esp
  801074:	50                   	push   %eax
  801075:	e8 32 f3 ff ff       	call   8003ac <diskaddr>
  80107a:	89 04 24             	mov    %eax,(%esp)
  80107d:	e8 a8 f3 ff ff       	call   80042a <flush_block>
  801082:	83 c4 10             	add    $0x10,%esp
}
  801085:	eb e3                	jmp    80106a <file_flush+0x84>

00801087 <file_create>:
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	57                   	push   %edi
  80108b:	56                   	push   %esi
  80108c:	53                   	push   %ebx
  80108d:	81 ec b8 00 00 00    	sub    $0xb8,%esp
	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801093:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801099:	50                   	push   %eax
  80109a:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  8010a0:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	e8 b7 fa ff ff       	call   800b65 <walk_path>
  8010ae:	83 c4 10             	add    $0x10,%esp
  8010b1:	85 c0                	test   %eax,%eax
  8010b3:	0f 84 0e 01 00 00    	je     8011c7 <file_create+0x140>
	if (r != -E_NOT_FOUND || dir == 0)
  8010b9:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8010bc:	74 08                	je     8010c6 <file_create+0x3f>
}
  8010be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c1:	5b                   	pop    %ebx
  8010c2:	5e                   	pop    %esi
  8010c3:	5f                   	pop    %edi
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    
	if (r != -E_NOT_FOUND || dir == 0)
  8010c6:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  8010cc:	85 db                	test   %ebx,%ebx
  8010ce:	74 ee                	je     8010be <file_create+0x37>
	assert((dir->f_size % BLKSIZE) == 0);
  8010d0:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  8010d6:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8010db:	75 5c                	jne    801139 <file_create+0xb2>
	nblock = dir->f_size / BLKSIZE;
  8010dd:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	0f 48 c2             	cmovs  %edx,%eax
  8010e8:	c1 f8 0c             	sar    $0xc,%eax
  8010eb:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
	for (i = 0; i < nblock; i++) {
  8010f1:	be 00 00 00 00       	mov    $0x0,%esi
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8010f6:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
	for (i = 0; i < nblock; i++) {
  8010fc:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  801102:	0f 84 8b 00 00 00    	je     801193 <file_create+0x10c>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801108:	83 ec 04             	sub    $0x4,%esp
  80110b:	57                   	push   %edi
  80110c:	56                   	push   %esi
  80110d:	53                   	push   %ebx
  80110e:	e8 cd f9 ff ff       	call   800ae0 <file_get_block>
  801113:	83 c4 10             	add    $0x10,%esp
  801116:	85 c0                	test   %eax,%eax
  801118:	78 a4                	js     8010be <file_create+0x37>
  80111a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801120:	8d 88 00 10 00 00    	lea    0x1000(%eax),%ecx
			if (f[j].f_name[0] == '\0') {
  801126:	80 38 00             	cmpb   $0x0,(%eax)
  801129:	74 27                	je     801152 <file_create+0xcb>
  80112b:	05 00 01 00 00       	add    $0x100,%eax
		for (j = 0; j < BLKFILES; j++)
  801130:	39 c8                	cmp    %ecx,%eax
  801132:	75 f2                	jne    801126 <file_create+0x9f>
	for (i = 0; i < nblock; i++) {
  801134:	83 c6 01             	add    $0x1,%esi
  801137:	eb c3                	jmp    8010fc <file_create+0x75>
	assert((dir->f_size % BLKSIZE) == 0);
  801139:	68 11 3c 80 00       	push   $0x803c11
  80113e:	68 7d 39 80 00       	push   $0x80397d
  801143:	68 ea 00 00 00       	push   $0xea
  801148:	68 79 3b 80 00       	push   $0x803b79
  80114d:	e8 09 0a 00 00       	call   801b5b <_panic>
				*file = &f[j];
  801152:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  801158:	83 ec 08             	sub    $0x8,%esp
  80115b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801161:	50                   	push   %eax
  801162:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  801168:	e8 e8 10 00 00       	call   802255 <strcpy>
	*pf = f;
  80116d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801170:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  801176:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  801178:	83 c4 04             	add    $0x4,%esp
  80117b:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
  801181:	e8 60 fe ff ff       	call   800fe6 <file_flush>
	return 0;
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	b8 00 00 00 00       	mov    $0x0,%eax
  80118e:	e9 2b ff ff ff       	jmp    8010be <file_create+0x37>
	dir->f_size += BLKSIZE;
  801193:	81 83 80 00 00 00 00 	addl   $0x1000,0x80(%ebx)
  80119a:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  80119d:	83 ec 04             	sub    $0x4,%esp
  8011a0:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  8011a6:	50                   	push   %eax
  8011a7:	56                   	push   %esi
  8011a8:	53                   	push   %ebx
  8011a9:	e8 32 f9 ff ff       	call   800ae0 <file_get_block>
  8011ae:	83 c4 10             	add    $0x10,%esp
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	0f 88 05 ff ff ff    	js     8010be <file_create+0x37>
	*file = &f[0];
  8011b9:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8011bf:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  8011c5:	eb 91                	jmp    801158 <file_create+0xd1>
		return -E_FILE_EXISTS;
  8011c7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8011cc:	e9 ed fe ff ff       	jmp    8010be <file_create+0x37>

008011d1 <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	53                   	push   %ebx
  8011d5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  8011d8:	bb 01 00 00 00       	mov    $0x1,%ebx
  8011dd:	eb 17                	jmp    8011f6 <fs_sync+0x25>
		flush_block(diskaddr(i));
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	53                   	push   %ebx
  8011e3:	e8 c4 f1 ff ff       	call   8003ac <diskaddr>
  8011e8:	89 04 24             	mov    %eax,(%esp)
  8011eb:	e8 3a f2 ff ff       	call   80042a <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  8011f0:	83 c3 01             	add    $0x1,%ebx
  8011f3:	83 c4 10             	add    $0x10,%esp
  8011f6:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8011fb:	39 58 04             	cmp    %ebx,0x4(%eax)
  8011fe:	77 df                	ja     8011df <fs_sync+0xe>
}
  801200:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  80120b:	e8 c1 ff ff ff       	call   8011d1 <fs_sync>
	return 0;
}
  801210:	b8 00 00 00 00       	mov    $0x0,%eax
  801215:	c9                   	leave  
  801216:	c3                   	ret    

00801217 <serve_init>:
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	ba 60 50 80 00       	mov    $0x805060,%edx
	uintptr_t va = FILEVA;
  80121f:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  801224:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  801229:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  80122b:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  80122e:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  801234:	83 c0 01             	add    $0x1,%eax
  801237:	83 c2 10             	add    $0x10,%edx
  80123a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80123f:	75 e8                	jne    801229 <serve_init+0x12>
}
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    

00801243 <openfile_alloc>:
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	57                   	push   %edi
  801247:	56                   	push   %esi
  801248:	53                   	push   %ebx
  801249:	83 ec 0c             	sub    $0xc,%esp
  80124c:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++) {
  80124f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801254:	89 de                	mov    %ebx,%esi
  801256:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd)) {
  801259:	83 ec 0c             	sub    $0xc,%esp
  80125c:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
  801262:	e8 f3 19 00 00       	call   802c5a <pageref>
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	74 17                	je     801285 <openfile_alloc+0x42>
  80126e:	83 f8 01             	cmp    $0x1,%eax
  801271:	74 30                	je     8012a3 <openfile_alloc+0x60>
	for (i = 0; i < MAXOPEN; i++) {
  801273:	83 c3 01             	add    $0x1,%ebx
  801276:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  80127c:	75 d6                	jne    801254 <openfile_alloc+0x11>
	return -E_MAX_OPEN;
  80127e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801283:	eb 4f                	jmp    8012d4 <openfile_alloc+0x91>
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801285:	83 ec 04             	sub    $0x4,%esp
  801288:	6a 07                	push   $0x7
  80128a:	89 d8                	mov    %ebx,%eax
  80128c:	c1 e0 04             	shl    $0x4,%eax
  80128f:	ff b0 6c 50 80 00    	pushl  0x80506c(%eax)
  801295:	6a 00                	push   $0x0
  801297:	e8 b2 13 00 00       	call   80264e <sys_page_alloc>
  80129c:	83 c4 10             	add    $0x10,%esp
  80129f:	85 c0                	test   %eax,%eax
  8012a1:	78 31                	js     8012d4 <openfile_alloc+0x91>
			opentab[i].o_fileid += MAXOPEN;
  8012a3:	c1 e3 04             	shl    $0x4,%ebx
  8012a6:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  8012ad:	04 00 00 
			*o = &opentab[i];
  8012b0:	81 c6 60 50 80 00    	add    $0x805060,%esi
  8012b6:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8012b8:	83 ec 04             	sub    $0x4,%esp
  8012bb:	68 00 10 00 00       	push   $0x1000
  8012c0:	6a 00                	push   $0x0
  8012c2:	ff b3 6c 50 80 00    	pushl  0x80506c(%ebx)
  8012c8:	e8 c9 10 00 00       	call   802396 <memset>
			return (*o)->o_fileid;
  8012cd:	8b 07                	mov    (%edi),%eax
  8012cf:	8b 00                	mov    (%eax),%eax
  8012d1:	83 c4 10             	add    $0x10,%esp
}
  8012d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d7:	5b                   	pop    %ebx
  8012d8:	5e                   	pop    %esi
  8012d9:	5f                   	pop    %edi
  8012da:	5d                   	pop    %ebp
  8012db:	c3                   	ret    

008012dc <openfile_lookup>:
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	57                   	push   %edi
  8012e0:	56                   	push   %esi
  8012e1:	53                   	push   %ebx
  8012e2:	83 ec 18             	sub    $0x18,%esp
  8012e5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  8012e8:	89 fb                	mov    %edi,%ebx
  8012ea:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8012f0:	89 de                	mov    %ebx,%esi
  8012f2:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8012f5:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
	o = &opentab[fileid % MAXOPEN];
  8012fb:	81 c6 60 50 80 00    	add    $0x805060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  801301:	e8 54 19 00 00       	call   802c5a <pageref>
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	83 f8 01             	cmp    $0x1,%eax
  80130c:	7e 1d                	jle    80132b <openfile_lookup+0x4f>
  80130e:	c1 e3 04             	shl    $0x4,%ebx
  801311:	39 bb 60 50 80 00    	cmp    %edi,0x805060(%ebx)
  801317:	75 19                	jne    801332 <openfile_lookup+0x56>
	*po = o;
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	89 30                	mov    %esi,(%eax)
	return 0;
  80131e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801323:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801326:	5b                   	pop    %ebx
  801327:	5e                   	pop    %esi
  801328:	5f                   	pop    %edi
  801329:	5d                   	pop    %ebp
  80132a:	c3                   	ret    
		return -E_INVAL;
  80132b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801330:	eb f1                	jmp    801323 <openfile_lookup+0x47>
  801332:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801337:	eb ea                	jmp    801323 <openfile_lookup+0x47>

00801339 <serve_set_size>:
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	53                   	push   %ebx
  80133d:	83 ec 18             	sub    $0x18,%esp
  801340:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801343:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801346:	50                   	push   %eax
  801347:	ff 33                	pushl  (%ebx)
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	e8 8b ff ff ff       	call   8012dc <openfile_lookup>
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	85 c0                	test   %eax,%eax
  801356:	78 14                	js     80136c <serve_set_size+0x33>
	return file_set_size(o->o_file, req->req_size);
  801358:	83 ec 08             	sub    $0x8,%esp
  80135b:	ff 73 04             	pushl  0x4(%ebx)
  80135e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801361:	ff 70 04             	pushl  0x4(%eax)
  801364:	e8 f8 fa ff ff       	call   800e61 <file_set_size>
  801369:	83 c4 10             	add    $0x10,%esp
}
  80136c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <serve_read>:
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	53                   	push   %ebx
  801375:	83 ec 18             	sub    $0x18,%esp
  801378:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80137b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80137e:	50                   	push   %eax
  80137f:	ff 33                	pushl  (%ebx)
  801381:	ff 75 08             	pushl  0x8(%ebp)
  801384:	e8 53 ff ff ff       	call   8012dc <openfile_lookup>
  801389:	83 c4 10             	add    $0x10,%esp
  80138c:	85 c0                	test   %eax,%eax
  80138e:	78 25                	js     8013b5 <serve_read+0x44>
	if ((r = file_read(o->o_file, ret->ret_buf, req->req_n, o->o_fd->fd_offset)) < 0)
  801390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801393:	8b 50 0c             	mov    0xc(%eax),%edx
  801396:	ff 72 04             	pushl  0x4(%edx)
  801399:	ff 73 04             	pushl  0x4(%ebx)
  80139c:	53                   	push   %ebx
  80139d:	ff 70 04             	pushl  0x4(%eax)
  8013a0:	e8 0f fa ff ff       	call   800db4 <file_read>
  8013a5:	83 c4 10             	add    $0x10,%esp
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	78 09                	js     8013b5 <serve_read+0x44>
	o->o_fd->fd_offset += r;
  8013ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013af:	8b 52 0c             	mov    0xc(%edx),%edx
  8013b2:	01 42 04             	add    %eax,0x4(%edx)
}
  8013b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <serve_write>:
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	53                   	push   %ebx
  8013be:	83 ec 18             	sub    $0x18,%esp
  8013c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8013c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c7:	50                   	push   %eax
  8013c8:	ff 33                	pushl  (%ebx)
  8013ca:	ff 75 08             	pushl  0x8(%ebp)
  8013cd:	e8 0a ff ff ff       	call   8012dc <openfile_lookup>
  8013d2:	83 c4 10             	add    $0x10,%esp
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	78 28                	js     801401 <serve_write+0x47>
	if ((r = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset)) < 0)
  8013d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013dc:	8b 50 0c             	mov    0xc(%eax),%edx
  8013df:	ff 72 04             	pushl  0x4(%edx)
  8013e2:	ff 73 04             	pushl  0x4(%ebx)
  8013e5:	83 c3 08             	add    $0x8,%ebx
  8013e8:	53                   	push   %ebx
  8013e9:	ff 70 04             	pushl  0x4(%eax)
  8013ec:	e8 4d fb ff ff       	call   800f3e <file_write>
  8013f1:	83 c4 10             	add    $0x10,%esp
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	78 09                	js     801401 <serve_write+0x47>
	o->o_fd->fd_offset += r;
  8013f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fb:	8b 52 0c             	mov    0xc(%edx),%edx
  8013fe:	01 42 04             	add    %eax,0x4(%edx)
}
  801401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <serve_stat>:
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	53                   	push   %ebx
  80140a:	83 ec 18             	sub    $0x18,%esp
  80140d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801410:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801413:	50                   	push   %eax
  801414:	ff 33                	pushl  (%ebx)
  801416:	ff 75 08             	pushl  0x8(%ebp)
  801419:	e8 be fe ff ff       	call   8012dc <openfile_lookup>
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	78 3f                	js     801464 <serve_stat+0x5e>
	strcpy(ret->ret_name, o->o_file->f_name);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142b:	ff 70 04             	pushl  0x4(%eax)
  80142e:	53                   	push   %ebx
  80142f:	e8 21 0e 00 00       	call   802255 <strcpy>
	ret->ret_size = o->o_file->f_size;
  801434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801437:	8b 50 04             	mov    0x4(%eax),%edx
  80143a:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  801440:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  801446:	8b 40 04             	mov    0x4(%eax),%eax
  801449:	83 c4 10             	add    $0x10,%esp
  80144c:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  801453:	0f 94 c0             	sete   %al
  801456:	0f b6 c0             	movzbl %al,%eax
  801459:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80145f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801464:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <serve_flush>:
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
  80146c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80146f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801472:	50                   	push   %eax
  801473:	8b 45 0c             	mov    0xc(%ebp),%eax
  801476:	ff 30                	pushl  (%eax)
  801478:	ff 75 08             	pushl  0x8(%ebp)
  80147b:	e8 5c fe ff ff       	call   8012dc <openfile_lookup>
  801480:	83 c4 10             	add    $0x10,%esp
  801483:	85 c0                	test   %eax,%eax
  801485:	78 16                	js     80149d <serve_flush+0x34>
	file_flush(o->o_file);
  801487:	83 ec 0c             	sub    $0xc,%esp
  80148a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148d:	ff 70 04             	pushl  0x4(%eax)
  801490:	e8 51 fb ff ff       	call   800fe6 <file_flush>
	return 0;
  801495:	83 c4 10             	add    $0x10,%esp
  801498:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <serve_open>:
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	53                   	push   %ebx
  8014a3:	81 ec 18 04 00 00    	sub    $0x418,%esp
  8014a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  8014ac:	68 00 04 00 00       	push   $0x400
  8014b1:	53                   	push   %ebx
  8014b2:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014b8:	50                   	push   %eax
  8014b9:	e8 25 0f 00 00       	call   8023e3 <memmove>
	path[MAXPATHLEN-1] = 0;
  8014be:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0) {
  8014c2:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8014c8:	89 04 24             	mov    %eax,(%esp)
  8014cb:	e8 73 fd ff ff       	call   801243 <openfile_alloc>
  8014d0:	83 c4 10             	add    $0x10,%esp
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	0f 88 f0 00 00 00    	js     8015cb <serve_open+0x12c>
	if (req->req_omode & O_CREAT) {
  8014db:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  8014e2:	74 33                	je     801517 <serve_open+0x78>
		if ((r = file_create(path, &f)) < 0) {
  8014e4:	83 ec 08             	sub    $0x8,%esp
  8014e7:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8014ed:	50                   	push   %eax
  8014ee:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014f4:	50                   	push   %eax
  8014f5:	e8 8d fb ff ff       	call   801087 <file_create>
  8014fa:	83 c4 10             	add    $0x10,%esp
  8014fd:	85 c0                	test   %eax,%eax
  8014ff:	79 37                	jns    801538 <serve_open+0x99>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  801501:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  801508:	0f 85 bd 00 00 00    	jne    8015cb <serve_open+0x12c>
  80150e:	83 f8 f3             	cmp    $0xfffffff3,%eax
  801511:	0f 85 b4 00 00 00    	jne    8015cb <serve_open+0x12c>
		if ((r = file_open(path, &f)) < 0) {
  801517:	83 ec 08             	sub    $0x8,%esp
  80151a:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801520:	50                   	push   %eax
  801521:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801527:	50                   	push   %eax
  801528:	e8 6d f8 ff ff       	call   800d9a <file_open>
  80152d:	83 c4 10             	add    $0x10,%esp
  801530:	85 c0                	test   %eax,%eax
  801532:	0f 88 93 00 00 00    	js     8015cb <serve_open+0x12c>
	if (req->req_omode & O_TRUNC) {
  801538:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  80153f:	74 17                	je     801558 <serve_open+0xb9>
		if ((r = file_set_size(f, 0)) < 0) {
  801541:	83 ec 08             	sub    $0x8,%esp
  801544:	6a 00                	push   $0x0
  801546:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  80154c:	e8 10 f9 ff ff       	call   800e61 <file_set_size>
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	85 c0                	test   %eax,%eax
  801556:	78 73                	js     8015cb <serve_open+0x12c>
	if ((r = file_open(path, &f)) < 0) {
  801558:	83 ec 08             	sub    $0x8,%esp
  80155b:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801561:	50                   	push   %eax
  801562:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801568:	50                   	push   %eax
  801569:	e8 2c f8 ff ff       	call   800d9a <file_open>
  80156e:	83 c4 10             	add    $0x10,%esp
  801571:	85 c0                	test   %eax,%eax
  801573:	78 56                	js     8015cb <serve_open+0x12c>
	o->o_file = f;
  801575:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  80157b:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  801581:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  801584:	8b 50 0c             	mov    0xc(%eax),%edx
  801587:	8b 08                	mov    (%eax),%ecx
  801589:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  80158c:	8b 48 0c             	mov    0xc(%eax),%ecx
  80158f:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801595:	83 e2 03             	and    $0x3,%edx
  801598:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  80159b:	8b 40 0c             	mov    0xc(%eax),%eax
  80159e:	8b 15 64 90 80 00    	mov    0x809064,%edx
  8015a4:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  8015a6:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8015ac:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  8015b2:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  8015b5:	8b 50 0c             	mov    0xc(%eax),%edx
  8015b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bb:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  8015bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c0:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  8015c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <serve>:
	[FSREQ_SYNC] =		serve_sync
};

void
serve(void)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	56                   	push   %esi
  8015d4:	53                   	push   %ebx
  8015d5:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8015d8:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  8015db:	8d 75 f4             	lea    -0xc(%ebp),%esi
  8015de:	eb 68                	jmp    801648 <serve+0x78>
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
			cprintf("Invalid request from %08x: no argument page\n",
  8015e0:	83 ec 08             	sub    $0x8,%esp
  8015e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e6:	68 4c 3c 80 00       	push   $0x803c4c
  8015eb:	e8 46 06 00 00       	call   801c36 <cprintf>
				whom);
			continue; // just leave it hanging...
  8015f0:	83 c4 10             	add    $0x10,%esp
  8015f3:	eb 53                	jmp    801648 <serve+0x78>
		}

		pg = NULL;
		if (req == FSREQ_OPEN) {
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8015f5:	53                   	push   %ebx
  8015f6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015f9:	50                   	push   %eax
  8015fa:	ff 35 44 50 80 00    	pushl  0x805044
  801600:	ff 75 f4             	pushl  -0xc(%ebp)
  801603:	e8 97 fe ff ff       	call   80149f <serve_open>
  801608:	83 c4 10             	add    $0x10,%esp
  80160b:	eb 19                	jmp    801626 <serve+0x56>
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
			r = handlers[req](whom, fsreq);
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  80160d:	83 ec 04             	sub    $0x4,%esp
  801610:	ff 75 f4             	pushl  -0xc(%ebp)
  801613:	50                   	push   %eax
  801614:	68 7c 3c 80 00       	push   $0x803c7c
  801619:	e8 18 06 00 00       	call   801c36 <cprintf>
  80161e:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  801621:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  801626:	ff 75 f0             	pushl  -0x10(%ebp)
  801629:	ff 75 ec             	pushl  -0x14(%ebp)
  80162c:	50                   	push   %eax
  80162d:	ff 75 f4             	pushl  -0xc(%ebp)
  801630:	e8 f0 12 00 00       	call   802925 <ipc_send>
		sys_page_unmap(0, fsreq);
  801635:	83 c4 08             	add    $0x8,%esp
  801638:	ff 35 44 50 80 00    	pushl  0x805044
  80163e:	6a 00                	push   $0x0
  801640:	e8 8e 10 00 00       	call   8026d3 <sys_page_unmap>
  801645:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  801648:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  80164f:	83 ec 04             	sub    $0x4,%esp
  801652:	53                   	push   %ebx
  801653:	ff 35 44 50 80 00    	pushl  0x805044
  801659:	56                   	push   %esi
  80165a:	e8 5d 12 00 00       	call   8028bc <ipc_recv>
		if (!(perm & PTE_P)) {
  80165f:	83 c4 10             	add    $0x10,%esp
  801662:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  801666:	0f 84 74 ff ff ff    	je     8015e0 <serve+0x10>
		pg = NULL;
  80166c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  801673:	83 f8 01             	cmp    $0x1,%eax
  801676:	0f 84 79 ff ff ff    	je     8015f5 <serve+0x25>
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  80167c:	83 f8 08             	cmp    $0x8,%eax
  80167f:	77 8c                	ja     80160d <serve+0x3d>
  801681:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  801688:	85 d2                	test   %edx,%edx
  80168a:	74 81                	je     80160d <serve+0x3d>
			r = handlers[req](whom, fsreq);
  80168c:	83 ec 08             	sub    $0x8,%esp
  80168f:	ff 35 44 50 80 00    	pushl  0x805044
  801695:	ff 75 f4             	pushl  -0xc(%ebp)
  801698:	ff d2                	call   *%edx
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	eb 87                	jmp    801626 <serve+0x56>

0080169f <umain>:
	}
}

void
umain(int argc, char **argv)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  8016a5:	c7 05 60 90 80 00 9f 	movl   $0x803c9f,0x809060
  8016ac:	3c 80 00 
	cprintf("FS is running\n");
  8016af:	68 a2 3c 80 00       	push   $0x803ca2
  8016b4:	e8 7d 05 00 00       	call   801c36 <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  8016b9:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  8016be:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  8016c3:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  8016c5:	c7 04 24 b1 3c 80 00 	movl   $0x803cb1,(%esp)
  8016cc:	e8 65 05 00 00       	call   801c36 <cprintf>

	serve_init();
  8016d1:	e8 41 fb ff ff       	call   801217 <serve_init>
	fs_init();
  8016d6:	e8 a6 f3 ff ff       	call   800a81 <fs_init>
        fs_test();
  8016db:	e8 05 00 00 00       	call   8016e5 <fs_test>
	serve();
  8016e0:	e8 eb fe ff ff       	call   8015d0 <serve>

008016e5 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	53                   	push   %ebx
  8016e9:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8016ec:	6a 07                	push   $0x7
  8016ee:	68 00 10 00 00       	push   $0x1000
  8016f3:	6a 00                	push   $0x0
  8016f5:	e8 54 0f 00 00       	call   80264e <sys_page_alloc>
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	85 c0                	test   %eax,%eax
  8016ff:	0f 88 6a 02 00 00    	js     80196f <fs_test+0x28a>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	68 00 10 00 00       	push   $0x1000
  80170d:	ff 35 04 a0 80 00    	pushl  0x80a004
  801713:	68 00 10 00 00       	push   $0x1000
  801718:	e8 c6 0c 00 00       	call   8023e3 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  80171d:	e8 8a f1 ff ff       	call   8008ac <alloc_block>
  801722:	83 c4 10             	add    $0x10,%esp
  801725:	85 c0                	test   %eax,%eax
  801727:	0f 88 54 02 00 00    	js     801981 <fs_test+0x29c>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  80172d:	8d 50 1f             	lea    0x1f(%eax),%edx
  801730:	85 c0                	test   %eax,%eax
  801732:	0f 49 d0             	cmovns %eax,%edx
  801735:	c1 fa 05             	sar    $0x5,%edx
  801738:	89 c3                	mov    %eax,%ebx
  80173a:	c1 fb 1f             	sar    $0x1f,%ebx
  80173d:	c1 eb 1b             	shr    $0x1b,%ebx
  801740:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  801743:	83 e1 1f             	and    $0x1f,%ecx
  801746:	29 d9                	sub    %ebx,%ecx
  801748:	b8 01 00 00 00       	mov    $0x1,%eax
  80174d:	d3 e0                	shl    %cl,%eax
  80174f:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  801756:	0f 84 37 02 00 00    	je     801993 <fs_test+0x2ae>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  80175c:	8b 0d 04 a0 80 00    	mov    0x80a004,%ecx
  801762:	85 04 91             	test   %eax,(%ecx,%edx,4)
  801765:	0f 85 3e 02 00 00    	jne    8019a9 <fs_test+0x2c4>
	cprintf("alloc_block is good\n");
  80176b:	83 ec 0c             	sub    $0xc,%esp
  80176e:	68 08 3d 80 00       	push   $0x803d08
  801773:	e8 be 04 00 00       	call   801c36 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  801778:	83 c4 08             	add    $0x8,%esp
  80177b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177e:	50                   	push   %eax
  80177f:	68 1d 3d 80 00       	push   $0x803d1d
  801784:	e8 11 f6 ff ff       	call   800d9a <file_open>
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80178f:	74 08                	je     801799 <fs_test+0xb4>
  801791:	85 c0                	test   %eax,%eax
  801793:	0f 88 26 02 00 00    	js     8019bf <fs_test+0x2da>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  801799:	85 c0                	test   %eax,%eax
  80179b:	0f 84 30 02 00 00    	je     8019d1 <fs_test+0x2ec>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a7:	50                   	push   %eax
  8017a8:	68 41 3d 80 00       	push   $0x803d41
  8017ad:	e8 e8 f5 ff ff       	call   800d9a <file_open>
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	0f 88 28 02 00 00    	js     8019e5 <fs_test+0x300>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  8017bd:	83 ec 0c             	sub    $0xc,%esp
  8017c0:	68 61 3d 80 00       	push   $0x803d61
  8017c5:	e8 6c 04 00 00       	call   801c36 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  8017ca:	83 c4 0c             	add    $0xc,%esp
  8017cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d0:	50                   	push   %eax
  8017d1:	6a 00                	push   $0x0
  8017d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d6:	e8 05 f3 ff ff       	call   800ae0 <file_get_block>
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	0f 88 11 02 00 00    	js     8019f7 <fs_test+0x312>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	68 a8 3e 80 00       	push   $0x803ea8
  8017ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8017f1:	e8 05 0b 00 00       	call   8022fb <strcmp>
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	0f 85 08 02 00 00    	jne    801a09 <fs_test+0x324>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  801801:	83 ec 0c             	sub    $0xc,%esp
  801804:	68 87 3d 80 00       	push   $0x803d87
  801809:	e8 28 04 00 00       	call   801c36 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  80180e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801811:	0f b6 10             	movzbl (%eax),%edx
  801814:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801819:	c1 e8 0c             	shr    $0xc,%eax
  80181c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	a8 40                	test   $0x40,%al
  801828:	0f 84 ef 01 00 00    	je     801a1d <fs_test+0x338>
	file_flush(f);
  80182e:	83 ec 0c             	sub    $0xc,%esp
  801831:	ff 75 f4             	pushl  -0xc(%ebp)
  801834:	e8 ad f7 ff ff       	call   800fe6 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183c:	c1 e8 0c             	shr    $0xc,%eax
  80183f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	a8 40                	test   $0x40,%al
  80184b:	0f 85 e2 01 00 00    	jne    801a33 <fs_test+0x34e>
	cprintf("file_flush is good\n");
  801851:	83 ec 0c             	sub    $0xc,%esp
  801854:	68 bb 3d 80 00       	push   $0x803dbb
  801859:	e8 d8 03 00 00       	call   801c36 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  80185e:	83 c4 08             	add    $0x8,%esp
  801861:	6a 00                	push   $0x0
  801863:	ff 75 f4             	pushl  -0xc(%ebp)
  801866:	e8 f6 f5 ff ff       	call   800e61 <file_set_size>
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	85 c0                	test   %eax,%eax
  801870:	0f 88 d3 01 00 00    	js     801a49 <fs_test+0x364>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  801876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801879:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801880:	0f 85 d5 01 00 00    	jne    801a5b <fs_test+0x376>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801886:	c1 e8 0c             	shr    $0xc,%eax
  801889:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801890:	a8 40                	test   $0x40,%al
  801892:	0f 85 d9 01 00 00    	jne    801a71 <fs_test+0x38c>
	cprintf("file_truncate is good\n");
  801898:	83 ec 0c             	sub    $0xc,%esp
  80189b:	68 0f 3e 80 00       	push   $0x803e0f
  8018a0:	e8 91 03 00 00       	call   801c36 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  8018a5:	c7 04 24 a8 3e 80 00 	movl   $0x803ea8,(%esp)
  8018ac:	e8 6d 09 00 00       	call   80221e <strlen>
  8018b1:	83 c4 08             	add    $0x8,%esp
  8018b4:	50                   	push   %eax
  8018b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b8:	e8 a4 f5 ff ff       	call   800e61 <file_set_size>
  8018bd:	83 c4 10             	add    $0x10,%esp
  8018c0:	85 c0                	test   %eax,%eax
  8018c2:	0f 88 bf 01 00 00    	js     801a87 <fs_test+0x3a2>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8018c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cb:	89 c2                	mov    %eax,%edx
  8018cd:	c1 ea 0c             	shr    $0xc,%edx
  8018d0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018d7:	f6 c2 40             	test   $0x40,%dl
  8018da:	0f 85 b9 01 00 00    	jne    801a99 <fs_test+0x3b4>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  8018e0:	83 ec 04             	sub    $0x4,%esp
  8018e3:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8018e6:	52                   	push   %edx
  8018e7:	6a 00                	push   $0x0
  8018e9:	50                   	push   %eax
  8018ea:	e8 f1 f1 ff ff       	call   800ae0 <file_get_block>
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	0f 88 b5 01 00 00    	js     801aaf <fs_test+0x3ca>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  8018fa:	83 ec 08             	sub    $0x8,%esp
  8018fd:	68 a8 3e 80 00       	push   $0x803ea8
  801902:	ff 75 f0             	pushl  -0x10(%ebp)
  801905:	e8 4b 09 00 00       	call   802255 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80190a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190d:	c1 e8 0c             	shr    $0xc,%eax
  801910:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801917:	83 c4 10             	add    $0x10,%esp
  80191a:	a8 40                	test   $0x40,%al
  80191c:	0f 84 9f 01 00 00    	je     801ac1 <fs_test+0x3dc>
	file_flush(f);
  801922:	83 ec 0c             	sub    $0xc,%esp
  801925:	ff 75 f4             	pushl  -0xc(%ebp)
  801928:	e8 b9 f6 ff ff       	call   800fe6 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  80192d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801930:	c1 e8 0c             	shr    $0xc,%eax
  801933:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	a8 40                	test   $0x40,%al
  80193f:	0f 85 92 01 00 00    	jne    801ad7 <fs_test+0x3f2>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801948:	c1 e8 0c             	shr    $0xc,%eax
  80194b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801952:	a8 40                	test   $0x40,%al
  801954:	0f 85 93 01 00 00    	jne    801aed <fs_test+0x408>
	cprintf("file rewrite is good\n");
  80195a:	83 ec 0c             	sub    $0xc,%esp
  80195d:	68 4f 3e 80 00       	push   $0x803e4f
  801962:	e8 cf 02 00 00       	call   801c36 <cprintf>
}
  801967:	83 c4 10             	add    $0x10,%esp
  80196a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80196f:	50                   	push   %eax
  801970:	68 c0 3c 80 00       	push   $0x803cc0
  801975:	6a 12                	push   $0x12
  801977:	68 d3 3c 80 00       	push   $0x803cd3
  80197c:	e8 da 01 00 00       	call   801b5b <_panic>
		panic("alloc_block: %e", r);
  801981:	50                   	push   %eax
  801982:	68 dd 3c 80 00       	push   $0x803cdd
  801987:	6a 17                	push   $0x17
  801989:	68 d3 3c 80 00       	push   $0x803cd3
  80198e:	e8 c8 01 00 00       	call   801b5b <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  801993:	68 ed 3c 80 00       	push   $0x803ced
  801998:	68 7d 39 80 00       	push   $0x80397d
  80199d:	6a 19                	push   $0x19
  80199f:	68 d3 3c 80 00       	push   $0x803cd3
  8019a4:	e8 b2 01 00 00       	call   801b5b <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8019a9:	68 68 3e 80 00       	push   $0x803e68
  8019ae:	68 7d 39 80 00       	push   $0x80397d
  8019b3:	6a 1b                	push   $0x1b
  8019b5:	68 d3 3c 80 00       	push   $0x803cd3
  8019ba:	e8 9c 01 00 00       	call   801b5b <_panic>
		panic("file_open /not-found: %e", r);
  8019bf:	50                   	push   %eax
  8019c0:	68 28 3d 80 00       	push   $0x803d28
  8019c5:	6a 1f                	push   $0x1f
  8019c7:	68 d3 3c 80 00       	push   $0x803cd3
  8019cc:	e8 8a 01 00 00       	call   801b5b <_panic>
		panic("file_open /not-found succeeded!");
  8019d1:	83 ec 04             	sub    $0x4,%esp
  8019d4:	68 88 3e 80 00       	push   $0x803e88
  8019d9:	6a 21                	push   $0x21
  8019db:	68 d3 3c 80 00       	push   $0x803cd3
  8019e0:	e8 76 01 00 00       	call   801b5b <_panic>
		panic("file_open /newmotd: %e", r);
  8019e5:	50                   	push   %eax
  8019e6:	68 4a 3d 80 00       	push   $0x803d4a
  8019eb:	6a 23                	push   $0x23
  8019ed:	68 d3 3c 80 00       	push   $0x803cd3
  8019f2:	e8 64 01 00 00       	call   801b5b <_panic>
		panic("file_get_block: %e", r);
  8019f7:	50                   	push   %eax
  8019f8:	68 74 3d 80 00       	push   $0x803d74
  8019fd:	6a 27                	push   $0x27
  8019ff:	68 d3 3c 80 00       	push   $0x803cd3
  801a04:	e8 52 01 00 00       	call   801b5b <_panic>
		panic("file_get_block returned wrong data");
  801a09:	83 ec 04             	sub    $0x4,%esp
  801a0c:	68 d0 3e 80 00       	push   $0x803ed0
  801a11:	6a 29                	push   $0x29
  801a13:	68 d3 3c 80 00       	push   $0x803cd3
  801a18:	e8 3e 01 00 00       	call   801b5b <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801a1d:	68 a0 3d 80 00       	push   $0x803da0
  801a22:	68 7d 39 80 00       	push   $0x80397d
  801a27:	6a 2d                	push   $0x2d
  801a29:	68 d3 3c 80 00       	push   $0x803cd3
  801a2e:	e8 28 01 00 00       	call   801b5b <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801a33:	68 9f 3d 80 00       	push   $0x803d9f
  801a38:	68 7d 39 80 00       	push   $0x80397d
  801a3d:	6a 2f                	push   $0x2f
  801a3f:	68 d3 3c 80 00       	push   $0x803cd3
  801a44:	e8 12 01 00 00       	call   801b5b <_panic>
		panic("file_set_size: %e", r);
  801a49:	50                   	push   %eax
  801a4a:	68 cf 3d 80 00       	push   $0x803dcf
  801a4f:	6a 33                	push   $0x33
  801a51:	68 d3 3c 80 00       	push   $0x803cd3
  801a56:	e8 00 01 00 00       	call   801b5b <_panic>
	assert(f->f_direct[0] == 0);
  801a5b:	68 e1 3d 80 00       	push   $0x803de1
  801a60:	68 7d 39 80 00       	push   $0x80397d
  801a65:	6a 34                	push   $0x34
  801a67:	68 d3 3c 80 00       	push   $0x803cd3
  801a6c:	e8 ea 00 00 00       	call   801b5b <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a71:	68 f5 3d 80 00       	push   $0x803df5
  801a76:	68 7d 39 80 00       	push   $0x80397d
  801a7b:	6a 35                	push   $0x35
  801a7d:	68 d3 3c 80 00       	push   $0x803cd3
  801a82:	e8 d4 00 00 00       	call   801b5b <_panic>
		panic("file_set_size 2: %e", r);
  801a87:	50                   	push   %eax
  801a88:	68 26 3e 80 00       	push   $0x803e26
  801a8d:	6a 39                	push   $0x39
  801a8f:	68 d3 3c 80 00       	push   $0x803cd3
  801a94:	e8 c2 00 00 00       	call   801b5b <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a99:	68 f5 3d 80 00       	push   $0x803df5
  801a9e:	68 7d 39 80 00       	push   $0x80397d
  801aa3:	6a 3a                	push   $0x3a
  801aa5:	68 d3 3c 80 00       	push   $0x803cd3
  801aaa:	e8 ac 00 00 00       	call   801b5b <_panic>
		panic("file_get_block 2: %e", r);
  801aaf:	50                   	push   %eax
  801ab0:	68 3a 3e 80 00       	push   $0x803e3a
  801ab5:	6a 3c                	push   $0x3c
  801ab7:	68 d3 3c 80 00       	push   $0x803cd3
  801abc:	e8 9a 00 00 00       	call   801b5b <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801ac1:	68 a0 3d 80 00       	push   $0x803da0
  801ac6:	68 7d 39 80 00       	push   $0x80397d
  801acb:	6a 3e                	push   $0x3e
  801acd:	68 d3 3c 80 00       	push   $0x803cd3
  801ad2:	e8 84 00 00 00       	call   801b5b <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801ad7:	68 9f 3d 80 00       	push   $0x803d9f
  801adc:	68 7d 39 80 00       	push   $0x80397d
  801ae1:	6a 40                	push   $0x40
  801ae3:	68 d3 3c 80 00       	push   $0x803cd3
  801ae8:	e8 6e 00 00 00       	call   801b5b <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801aed:	68 f5 3d 80 00       	push   $0x803df5
  801af2:	68 7d 39 80 00       	push   $0x80397d
  801af7:	6a 41                	push   $0x41
  801af9:	68 d3 3c 80 00       	push   $0x803cd3
  801afe:	e8 58 00 00 00       	call   801b5b <_panic>

00801b03 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	56                   	push   %esi
  801b07:	53                   	push   %ebx
  801b08:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b0b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	envid_t envid = sys_getenvid();
  801b0e:	e8 fd 0a 00 00       	call   802610 <sys_getenvid>
	thisenv = envs + ENVX(envid);
  801b13:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b18:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b1b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b20:	a3 0c a0 80 00       	mov    %eax,0x80a00c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801b25:	85 db                	test   %ebx,%ebx
  801b27:	7e 07                	jle    801b30 <libmain+0x2d>
		binaryname = argv[0];
  801b29:	8b 06                	mov    (%esi),%eax
  801b2b:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801b30:	83 ec 08             	sub    $0x8,%esp
  801b33:	56                   	push   %esi
  801b34:	53                   	push   %ebx
  801b35:	e8 65 fb ff ff       	call   80169f <umain>

	// exit gracefully
	exit();
  801b3a:	e8 0a 00 00 00       	call   801b49 <exit>
}
  801b3f:	83 c4 10             	add    $0x10,%esp
  801b42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b45:	5b                   	pop    %ebx
  801b46:	5e                   	pop    %esi
  801b47:	5d                   	pop    %ebp
  801b48:	c3                   	ret    

00801b49 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  801b4f:	6a 00                	push   $0x0
  801b51:	e8 79 0a 00 00       	call   8025cf <sys_env_destroy>
}
  801b56:	83 c4 10             	add    $0x10,%esp
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	56                   	push   %esi
  801b5f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801b60:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801b63:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801b69:	e8 a2 0a 00 00       	call   802610 <sys_getenvid>
  801b6e:	83 ec 0c             	sub    $0xc,%esp
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	ff 75 08             	pushl  0x8(%ebp)
  801b77:	56                   	push   %esi
  801b78:	50                   	push   %eax
  801b79:	68 00 3f 80 00       	push   $0x803f00
  801b7e:	e8 b3 00 00 00       	call   801c36 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801b83:	83 c4 18             	add    $0x18,%esp
  801b86:	53                   	push   %ebx
  801b87:	ff 75 10             	pushl  0x10(%ebp)
  801b8a:	e8 56 00 00 00       	call   801be5 <vcprintf>
	cprintf("\n");
  801b8f:	c7 04 24 10 3b 80 00 	movl   $0x803b10,(%esp)
  801b96:	e8 9b 00 00 00       	call   801c36 <cprintf>
  801b9b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b9e:	cc                   	int3   
  801b9f:	eb fd                	jmp    801b9e <_panic+0x43>

00801ba1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	53                   	push   %ebx
  801ba5:	83 ec 04             	sub    $0x4,%esp
  801ba8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801bab:	8b 13                	mov    (%ebx),%edx
  801bad:	8d 42 01             	lea    0x1(%edx),%eax
  801bb0:	89 03                	mov    %eax,(%ebx)
  801bb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bb5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801bb9:	3d ff 00 00 00       	cmp    $0xff,%eax
  801bbe:	74 09                	je     801bc9 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801bc0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801bc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801bc9:	83 ec 08             	sub    $0x8,%esp
  801bcc:	68 ff 00 00 00       	push   $0xff
  801bd1:	8d 43 08             	lea    0x8(%ebx),%eax
  801bd4:	50                   	push   %eax
  801bd5:	e8 b8 09 00 00       	call   802592 <sys_cputs>
		b->idx = 0;
  801bda:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	eb db                	jmp    801bc0 <putch+0x1f>

00801be5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801bee:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801bf5:	00 00 00 
	b.cnt = 0;
  801bf8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801bff:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801c02:	ff 75 0c             	pushl  0xc(%ebp)
  801c05:	ff 75 08             	pushl  0x8(%ebp)
  801c08:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801c0e:	50                   	push   %eax
  801c0f:	68 a1 1b 80 00       	push   $0x801ba1
  801c14:	e8 1a 01 00 00       	call   801d33 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801c19:	83 c4 08             	add    $0x8,%esp
  801c1c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801c22:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801c28:	50                   	push   %eax
  801c29:	e8 64 09 00 00       	call   802592 <sys_cputs>

	return b.cnt;
}
  801c2e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c3c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801c3f:	50                   	push   %eax
  801c40:	ff 75 08             	pushl  0x8(%ebp)
  801c43:	e8 9d ff ff ff       	call   801be5 <vcprintf>
	va_end(ap);

	return cnt;
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	57                   	push   %edi
  801c4e:	56                   	push   %esi
  801c4f:	53                   	push   %ebx
  801c50:	83 ec 1c             	sub    $0x1c,%esp
  801c53:	89 c7                	mov    %eax,%edi
  801c55:	89 d6                	mov    %edx,%esi
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c60:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801c63:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c66:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c6b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801c6e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801c71:	39 d3                	cmp    %edx,%ebx
  801c73:	72 05                	jb     801c7a <printnum+0x30>
  801c75:	39 45 10             	cmp    %eax,0x10(%ebp)
  801c78:	77 7a                	ja     801cf4 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801c7a:	83 ec 0c             	sub    $0xc,%esp
  801c7d:	ff 75 18             	pushl  0x18(%ebp)
  801c80:	8b 45 14             	mov    0x14(%ebp),%eax
  801c83:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801c86:	53                   	push   %ebx
  801c87:	ff 75 10             	pushl  0x10(%ebp)
  801c8a:	83 ec 08             	sub    $0x8,%esp
  801c8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c90:	ff 75 e0             	pushl  -0x20(%ebp)
  801c93:	ff 75 dc             	pushl  -0x24(%ebp)
  801c96:	ff 75 d8             	pushl  -0x28(%ebp)
  801c99:	e8 62 1a 00 00       	call   803700 <__udivdi3>
  801c9e:	83 c4 18             	add    $0x18,%esp
  801ca1:	52                   	push   %edx
  801ca2:	50                   	push   %eax
  801ca3:	89 f2                	mov    %esi,%edx
  801ca5:	89 f8                	mov    %edi,%eax
  801ca7:	e8 9e ff ff ff       	call   801c4a <printnum>
  801cac:	83 c4 20             	add    $0x20,%esp
  801caf:	eb 13                	jmp    801cc4 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801cb1:	83 ec 08             	sub    $0x8,%esp
  801cb4:	56                   	push   %esi
  801cb5:	ff 75 18             	pushl  0x18(%ebp)
  801cb8:	ff d7                	call   *%edi
  801cba:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801cbd:	83 eb 01             	sub    $0x1,%ebx
  801cc0:	85 db                	test   %ebx,%ebx
  801cc2:	7f ed                	jg     801cb1 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801cc4:	83 ec 08             	sub    $0x8,%esp
  801cc7:	56                   	push   %esi
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cce:	ff 75 e0             	pushl  -0x20(%ebp)
  801cd1:	ff 75 dc             	pushl  -0x24(%ebp)
  801cd4:	ff 75 d8             	pushl  -0x28(%ebp)
  801cd7:	e8 44 1b 00 00       	call   803820 <__umoddi3>
  801cdc:	83 c4 14             	add    $0x14,%esp
  801cdf:	0f be 80 23 3f 80 00 	movsbl 0x803f23(%eax),%eax
  801ce6:	50                   	push   %eax
  801ce7:	ff d7                	call   *%edi
}
  801ce9:	83 c4 10             	add    $0x10,%esp
  801cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5f                   	pop    %edi
  801cf2:	5d                   	pop    %ebp
  801cf3:	c3                   	ret    
  801cf4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf7:	eb c4                	jmp    801cbd <printnum+0x73>

00801cf9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801cff:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801d03:	8b 10                	mov    (%eax),%edx
  801d05:	3b 50 04             	cmp    0x4(%eax),%edx
  801d08:	73 0a                	jae    801d14 <sprintputch+0x1b>
		*b->buf++ = ch;
  801d0a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d0d:	89 08                	mov    %ecx,(%eax)
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	88 02                	mov    %al,(%edx)
}
  801d14:	5d                   	pop    %ebp
  801d15:	c3                   	ret    

00801d16 <printfmt>:
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801d1c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801d1f:	50                   	push   %eax
  801d20:	ff 75 10             	pushl  0x10(%ebp)
  801d23:	ff 75 0c             	pushl  0xc(%ebp)
  801d26:	ff 75 08             	pushl  0x8(%ebp)
  801d29:	e8 05 00 00 00       	call   801d33 <vprintfmt>
}
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <vprintfmt>:
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	57                   	push   %edi
  801d37:	56                   	push   %esi
  801d38:	53                   	push   %ebx
  801d39:	83 ec 2c             	sub    $0x2c,%esp
  801d3c:	8b 75 08             	mov    0x8(%ebp),%esi
  801d3f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d42:	8b 7d 10             	mov    0x10(%ebp),%edi
  801d45:	e9 c1 03 00 00       	jmp    80210b <vprintfmt+0x3d8>
		padc = ' ';
  801d4a:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  801d4e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801d55:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801d5c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801d63:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801d68:	8d 47 01             	lea    0x1(%edi),%eax
  801d6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d6e:	0f b6 17             	movzbl (%edi),%edx
  801d71:	8d 42 dd             	lea    -0x23(%edx),%eax
  801d74:	3c 55                	cmp    $0x55,%al
  801d76:	0f 87 12 04 00 00    	ja     80218e <vprintfmt+0x45b>
  801d7c:	0f b6 c0             	movzbl %al,%eax
  801d7f:	ff 24 85 60 40 80 00 	jmp    *0x804060(,%eax,4)
  801d86:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801d89:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801d8d:	eb d9                	jmp    801d68 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801d8f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801d92:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801d96:	eb d0                	jmp    801d68 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801d98:	0f b6 d2             	movzbl %dl,%edx
  801d9b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801d9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801da3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801da6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801da9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801dad:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801db0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801db3:	83 f9 09             	cmp    $0x9,%ecx
  801db6:	77 55                	ja     801e0d <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801db8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801dbb:	eb e9                	jmp    801da6 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801dbd:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc0:	8b 00                	mov    (%eax),%eax
  801dc2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801dc5:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc8:	8d 40 04             	lea    0x4(%eax),%eax
  801dcb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801dce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801dd1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dd5:	79 91                	jns    801d68 <vprintfmt+0x35>
				width = precision, precision = -1;
  801dd7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801dda:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801ddd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801de4:	eb 82                	jmp    801d68 <vprintfmt+0x35>
  801de6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de9:	85 c0                	test   %eax,%eax
  801deb:	ba 00 00 00 00       	mov    $0x0,%edx
  801df0:	0f 49 d0             	cmovns %eax,%edx
  801df3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801df6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801df9:	e9 6a ff ff ff       	jmp    801d68 <vprintfmt+0x35>
  801dfe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801e01:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801e08:	e9 5b ff ff ff       	jmp    801d68 <vprintfmt+0x35>
  801e0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801e10:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e13:	eb bc                	jmp    801dd1 <vprintfmt+0x9e>
			lflag++;
  801e15:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801e18:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801e1b:	e9 48 ff ff ff       	jmp    801d68 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801e20:	8b 45 14             	mov    0x14(%ebp),%eax
  801e23:	8d 78 04             	lea    0x4(%eax),%edi
  801e26:	83 ec 08             	sub    $0x8,%esp
  801e29:	53                   	push   %ebx
  801e2a:	ff 30                	pushl  (%eax)
  801e2c:	ff d6                	call   *%esi
			break;
  801e2e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801e31:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801e34:	e9 cf 02 00 00       	jmp    802108 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  801e39:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3c:	8d 78 04             	lea    0x4(%eax),%edi
  801e3f:	8b 00                	mov    (%eax),%eax
  801e41:	99                   	cltd   
  801e42:	31 d0                	xor    %edx,%eax
  801e44:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801e46:	83 f8 0f             	cmp    $0xf,%eax
  801e49:	7f 23                	jg     801e6e <vprintfmt+0x13b>
  801e4b:	8b 14 85 c0 41 80 00 	mov    0x8041c0(,%eax,4),%edx
  801e52:	85 d2                	test   %edx,%edx
  801e54:	74 18                	je     801e6e <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801e56:	52                   	push   %edx
  801e57:	68 8f 39 80 00       	push   $0x80398f
  801e5c:	53                   	push   %ebx
  801e5d:	56                   	push   %esi
  801e5e:	e8 b3 fe ff ff       	call   801d16 <printfmt>
  801e63:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801e66:	89 7d 14             	mov    %edi,0x14(%ebp)
  801e69:	e9 9a 02 00 00       	jmp    802108 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  801e6e:	50                   	push   %eax
  801e6f:	68 3b 3f 80 00       	push   $0x803f3b
  801e74:	53                   	push   %ebx
  801e75:	56                   	push   %esi
  801e76:	e8 9b fe ff ff       	call   801d16 <printfmt>
  801e7b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801e7e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801e81:	e9 82 02 00 00       	jmp    802108 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  801e86:	8b 45 14             	mov    0x14(%ebp),%eax
  801e89:	83 c0 04             	add    $0x4,%eax
  801e8c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e92:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801e94:	85 ff                	test   %edi,%edi
  801e96:	b8 34 3f 80 00       	mov    $0x803f34,%eax
  801e9b:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801e9e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ea2:	0f 8e bd 00 00 00    	jle    801f65 <vprintfmt+0x232>
  801ea8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801eac:	75 0e                	jne    801ebc <vprintfmt+0x189>
  801eae:	89 75 08             	mov    %esi,0x8(%ebp)
  801eb1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801eb4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801eb7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801eba:	eb 6d                	jmp    801f29 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801ebc:	83 ec 08             	sub    $0x8,%esp
  801ebf:	ff 75 d0             	pushl  -0x30(%ebp)
  801ec2:	57                   	push   %edi
  801ec3:	e8 6e 03 00 00       	call   802236 <strnlen>
  801ec8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801ecb:	29 c1                	sub    %eax,%ecx
  801ecd:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801ed0:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801ed3:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801ed7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801eda:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801edd:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801edf:	eb 0f                	jmp    801ef0 <vprintfmt+0x1bd>
					putch(padc, putdat);
  801ee1:	83 ec 08             	sub    $0x8,%esp
  801ee4:	53                   	push   %ebx
  801ee5:	ff 75 e0             	pushl  -0x20(%ebp)
  801ee8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801eea:	83 ef 01             	sub    $0x1,%edi
  801eed:	83 c4 10             	add    $0x10,%esp
  801ef0:	85 ff                	test   %edi,%edi
  801ef2:	7f ed                	jg     801ee1 <vprintfmt+0x1ae>
  801ef4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801ef7:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801efa:	85 c9                	test   %ecx,%ecx
  801efc:	b8 00 00 00 00       	mov    $0x0,%eax
  801f01:	0f 49 c1             	cmovns %ecx,%eax
  801f04:	29 c1                	sub    %eax,%ecx
  801f06:	89 75 08             	mov    %esi,0x8(%ebp)
  801f09:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801f0c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801f0f:	89 cb                	mov    %ecx,%ebx
  801f11:	eb 16                	jmp    801f29 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  801f13:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801f17:	75 31                	jne    801f4a <vprintfmt+0x217>
					putch(ch, putdat);
  801f19:	83 ec 08             	sub    $0x8,%esp
  801f1c:	ff 75 0c             	pushl  0xc(%ebp)
  801f1f:	50                   	push   %eax
  801f20:	ff 55 08             	call   *0x8(%ebp)
  801f23:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801f26:	83 eb 01             	sub    $0x1,%ebx
  801f29:	83 c7 01             	add    $0x1,%edi
  801f2c:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801f30:	0f be c2             	movsbl %dl,%eax
  801f33:	85 c0                	test   %eax,%eax
  801f35:	74 59                	je     801f90 <vprintfmt+0x25d>
  801f37:	85 f6                	test   %esi,%esi
  801f39:	78 d8                	js     801f13 <vprintfmt+0x1e0>
  801f3b:	83 ee 01             	sub    $0x1,%esi
  801f3e:	79 d3                	jns    801f13 <vprintfmt+0x1e0>
  801f40:	89 df                	mov    %ebx,%edi
  801f42:	8b 75 08             	mov    0x8(%ebp),%esi
  801f45:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f48:	eb 37                	jmp    801f81 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  801f4a:	0f be d2             	movsbl %dl,%edx
  801f4d:	83 ea 20             	sub    $0x20,%edx
  801f50:	83 fa 5e             	cmp    $0x5e,%edx
  801f53:	76 c4                	jbe    801f19 <vprintfmt+0x1e6>
					putch('?', putdat);
  801f55:	83 ec 08             	sub    $0x8,%esp
  801f58:	ff 75 0c             	pushl  0xc(%ebp)
  801f5b:	6a 3f                	push   $0x3f
  801f5d:	ff 55 08             	call   *0x8(%ebp)
  801f60:	83 c4 10             	add    $0x10,%esp
  801f63:	eb c1                	jmp    801f26 <vprintfmt+0x1f3>
  801f65:	89 75 08             	mov    %esi,0x8(%ebp)
  801f68:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801f6b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801f6e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801f71:	eb b6                	jmp    801f29 <vprintfmt+0x1f6>
				putch(' ', putdat);
  801f73:	83 ec 08             	sub    $0x8,%esp
  801f76:	53                   	push   %ebx
  801f77:	6a 20                	push   $0x20
  801f79:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801f7b:	83 ef 01             	sub    $0x1,%edi
  801f7e:	83 c4 10             	add    $0x10,%esp
  801f81:	85 ff                	test   %edi,%edi
  801f83:	7f ee                	jg     801f73 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  801f85:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f88:	89 45 14             	mov    %eax,0x14(%ebp)
  801f8b:	e9 78 01 00 00       	jmp    802108 <vprintfmt+0x3d5>
  801f90:	89 df                	mov    %ebx,%edi
  801f92:	8b 75 08             	mov    0x8(%ebp),%esi
  801f95:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f98:	eb e7                	jmp    801f81 <vprintfmt+0x24e>
	if (lflag >= 2)
  801f9a:	83 f9 01             	cmp    $0x1,%ecx
  801f9d:	7e 3f                	jle    801fde <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  801f9f:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa2:	8b 50 04             	mov    0x4(%eax),%edx
  801fa5:	8b 00                	mov    (%eax),%eax
  801fa7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801faa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801fad:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb0:	8d 40 08             	lea    0x8(%eax),%eax
  801fb3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801fb6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801fba:	79 5c                	jns    802018 <vprintfmt+0x2e5>
				putch('-', putdat);
  801fbc:	83 ec 08             	sub    $0x8,%esp
  801fbf:	53                   	push   %ebx
  801fc0:	6a 2d                	push   $0x2d
  801fc2:	ff d6                	call   *%esi
				num = -(long long) num;
  801fc4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fc7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801fca:	f7 da                	neg    %edx
  801fcc:	83 d1 00             	adc    $0x0,%ecx
  801fcf:	f7 d9                	neg    %ecx
  801fd1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801fd4:	b8 0a 00 00 00       	mov    $0xa,%eax
  801fd9:	e9 10 01 00 00       	jmp    8020ee <vprintfmt+0x3bb>
	else if (lflag)
  801fde:	85 c9                	test   %ecx,%ecx
  801fe0:	75 1b                	jne    801ffd <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  801fe2:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe5:	8b 00                	mov    (%eax),%eax
  801fe7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801fea:	89 c1                	mov    %eax,%ecx
  801fec:	c1 f9 1f             	sar    $0x1f,%ecx
  801fef:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801ff2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff5:	8d 40 04             	lea    0x4(%eax),%eax
  801ff8:	89 45 14             	mov    %eax,0x14(%ebp)
  801ffb:	eb b9                	jmp    801fb6 <vprintfmt+0x283>
		return va_arg(*ap, long);
  801ffd:	8b 45 14             	mov    0x14(%ebp),%eax
  802000:	8b 00                	mov    (%eax),%eax
  802002:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802005:	89 c1                	mov    %eax,%ecx
  802007:	c1 f9 1f             	sar    $0x1f,%ecx
  80200a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80200d:	8b 45 14             	mov    0x14(%ebp),%eax
  802010:	8d 40 04             	lea    0x4(%eax),%eax
  802013:	89 45 14             	mov    %eax,0x14(%ebp)
  802016:	eb 9e                	jmp    801fb6 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  802018:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80201b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80201e:	b8 0a 00 00 00       	mov    $0xa,%eax
  802023:	e9 c6 00 00 00       	jmp    8020ee <vprintfmt+0x3bb>
	if (lflag >= 2)
  802028:	83 f9 01             	cmp    $0x1,%ecx
  80202b:	7e 18                	jle    802045 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80202d:	8b 45 14             	mov    0x14(%ebp),%eax
  802030:	8b 10                	mov    (%eax),%edx
  802032:	8b 48 04             	mov    0x4(%eax),%ecx
  802035:	8d 40 08             	lea    0x8(%eax),%eax
  802038:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80203b:	b8 0a 00 00 00       	mov    $0xa,%eax
  802040:	e9 a9 00 00 00       	jmp    8020ee <vprintfmt+0x3bb>
	else if (lflag)
  802045:	85 c9                	test   %ecx,%ecx
  802047:	75 1a                	jne    802063 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  802049:	8b 45 14             	mov    0x14(%ebp),%eax
  80204c:	8b 10                	mov    (%eax),%edx
  80204e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802053:	8d 40 04             	lea    0x4(%eax),%eax
  802056:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  802059:	b8 0a 00 00 00       	mov    $0xa,%eax
  80205e:	e9 8b 00 00 00       	jmp    8020ee <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  802063:	8b 45 14             	mov    0x14(%ebp),%eax
  802066:	8b 10                	mov    (%eax),%edx
  802068:	b9 00 00 00 00       	mov    $0x0,%ecx
  80206d:	8d 40 04             	lea    0x4(%eax),%eax
  802070:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  802073:	b8 0a 00 00 00       	mov    $0xa,%eax
  802078:	eb 74                	jmp    8020ee <vprintfmt+0x3bb>
	if (lflag >= 2)
  80207a:	83 f9 01             	cmp    $0x1,%ecx
  80207d:	7e 15                	jle    802094 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80207f:	8b 45 14             	mov    0x14(%ebp),%eax
  802082:	8b 10                	mov    (%eax),%edx
  802084:	8b 48 04             	mov    0x4(%eax),%ecx
  802087:	8d 40 08             	lea    0x8(%eax),%eax
  80208a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80208d:	b8 08 00 00 00       	mov    $0x8,%eax
  802092:	eb 5a                	jmp    8020ee <vprintfmt+0x3bb>
	else if (lflag)
  802094:	85 c9                	test   %ecx,%ecx
  802096:	75 17                	jne    8020af <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  802098:	8b 45 14             	mov    0x14(%ebp),%eax
  80209b:	8b 10                	mov    (%eax),%edx
  80209d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020a2:	8d 40 04             	lea    0x4(%eax),%eax
  8020a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8020a8:	b8 08 00 00 00       	mov    $0x8,%eax
  8020ad:	eb 3f                	jmp    8020ee <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8020af:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b2:	8b 10                	mov    (%eax),%edx
  8020b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020b9:	8d 40 04             	lea    0x4(%eax),%eax
  8020bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8020bf:	b8 08 00 00 00       	mov    $0x8,%eax
  8020c4:	eb 28                	jmp    8020ee <vprintfmt+0x3bb>
			putch('0', putdat);
  8020c6:	83 ec 08             	sub    $0x8,%esp
  8020c9:	53                   	push   %ebx
  8020ca:	6a 30                	push   $0x30
  8020cc:	ff d6                	call   *%esi
			putch('x', putdat);
  8020ce:	83 c4 08             	add    $0x8,%esp
  8020d1:	53                   	push   %ebx
  8020d2:	6a 78                	push   $0x78
  8020d4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8020d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020d9:	8b 10                	mov    (%eax),%edx
  8020db:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8020e0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8020e3:	8d 40 04             	lea    0x4(%eax),%eax
  8020e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8020e9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8020ee:	83 ec 0c             	sub    $0xc,%esp
  8020f1:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8020f5:	57                   	push   %edi
  8020f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8020f9:	50                   	push   %eax
  8020fa:	51                   	push   %ecx
  8020fb:	52                   	push   %edx
  8020fc:	89 da                	mov    %ebx,%edx
  8020fe:	89 f0                	mov    %esi,%eax
  802100:	e8 45 fb ff ff       	call   801c4a <printnum>
			break;
  802105:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  802108:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {		//先将非格式化字符输出到控制台。
  80210b:	83 c7 01             	add    $0x1,%edi
  80210e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  802112:	83 f8 25             	cmp    $0x25,%eax
  802115:	0f 84 2f fc ff ff    	je     801d4a <vprintfmt+0x17>
			if (ch == '\0')										//如果没有格式化字符直接返回
  80211b:	85 c0                	test   %eax,%eax
  80211d:	0f 84 8b 00 00 00    	je     8021ae <vprintfmt+0x47b>
			putch(ch, putdat);
  802123:	83 ec 08             	sub    $0x8,%esp
  802126:	53                   	push   %ebx
  802127:	50                   	push   %eax
  802128:	ff d6                	call   *%esi
  80212a:	83 c4 10             	add    $0x10,%esp
  80212d:	eb dc                	jmp    80210b <vprintfmt+0x3d8>
	if (lflag >= 2)
  80212f:	83 f9 01             	cmp    $0x1,%ecx
  802132:	7e 15                	jle    802149 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  802134:	8b 45 14             	mov    0x14(%ebp),%eax
  802137:	8b 10                	mov    (%eax),%edx
  802139:	8b 48 04             	mov    0x4(%eax),%ecx
  80213c:	8d 40 08             	lea    0x8(%eax),%eax
  80213f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802142:	b8 10 00 00 00       	mov    $0x10,%eax
  802147:	eb a5                	jmp    8020ee <vprintfmt+0x3bb>
	else if (lflag)
  802149:	85 c9                	test   %ecx,%ecx
  80214b:	75 17                	jne    802164 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80214d:	8b 45 14             	mov    0x14(%ebp),%eax
  802150:	8b 10                	mov    (%eax),%edx
  802152:	b9 00 00 00 00       	mov    $0x0,%ecx
  802157:	8d 40 04             	lea    0x4(%eax),%eax
  80215a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80215d:	b8 10 00 00 00       	mov    $0x10,%eax
  802162:	eb 8a                	jmp    8020ee <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  802164:	8b 45 14             	mov    0x14(%ebp),%eax
  802167:	8b 10                	mov    (%eax),%edx
  802169:	b9 00 00 00 00       	mov    $0x0,%ecx
  80216e:	8d 40 04             	lea    0x4(%eax),%eax
  802171:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802174:	b8 10 00 00 00       	mov    $0x10,%eax
  802179:	e9 70 ff ff ff       	jmp    8020ee <vprintfmt+0x3bb>
			putch(ch, putdat);
  80217e:	83 ec 08             	sub    $0x8,%esp
  802181:	53                   	push   %ebx
  802182:	6a 25                	push   $0x25
  802184:	ff d6                	call   *%esi
			break;
  802186:	83 c4 10             	add    $0x10,%esp
  802189:	e9 7a ff ff ff       	jmp    802108 <vprintfmt+0x3d5>
			putch('%', putdat);
  80218e:	83 ec 08             	sub    $0x8,%esp
  802191:	53                   	push   %ebx
  802192:	6a 25                	push   $0x25
  802194:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  802196:	83 c4 10             	add    $0x10,%esp
  802199:	89 f8                	mov    %edi,%eax
  80219b:	eb 03                	jmp    8021a0 <vprintfmt+0x46d>
  80219d:	83 e8 01             	sub    $0x1,%eax
  8021a0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8021a4:	75 f7                	jne    80219d <vprintfmt+0x46a>
  8021a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021a9:	e9 5a ff ff ff       	jmp    802108 <vprintfmt+0x3d5>
}
  8021ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021b1:	5b                   	pop    %ebx
  8021b2:	5e                   	pop    %esi
  8021b3:	5f                   	pop    %edi
  8021b4:	5d                   	pop    %ebp
  8021b5:	c3                   	ret    

008021b6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	83 ec 18             	sub    $0x18,%esp
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8021c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021c5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8021c9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8021cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	74 26                	je     8021fd <vsnprintf+0x47>
  8021d7:	85 d2                	test   %edx,%edx
  8021d9:	7e 22                	jle    8021fd <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8021db:	ff 75 14             	pushl  0x14(%ebp)
  8021de:	ff 75 10             	pushl  0x10(%ebp)
  8021e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8021e4:	50                   	push   %eax
  8021e5:	68 f9 1c 80 00       	push   $0x801cf9
  8021ea:	e8 44 fb ff ff       	call   801d33 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8021ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8021f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f8:	83 c4 10             	add    $0x10,%esp
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    
		return -E_INVAL;
  8021fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802202:	eb f7                	jmp    8021fb <vsnprintf+0x45>

00802204 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80220a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80220d:	50                   	push   %eax
  80220e:	ff 75 10             	pushl  0x10(%ebp)
  802211:	ff 75 0c             	pushl  0xc(%ebp)
  802214:	ff 75 08             	pushl  0x8(%ebp)
  802217:	e8 9a ff ff ff       	call   8021b6 <vsnprintf>
	va_end(ap);

	return rc;
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802224:	b8 00 00 00 00       	mov    $0x0,%eax
  802229:	eb 03                	jmp    80222e <strlen+0x10>
		n++;
  80222b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80222e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802232:	75 f7                	jne    80222b <strlen+0xd>
	return n;
}
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    

00802236 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80223c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
  802244:	eb 03                	jmp    802249 <strnlen+0x13>
		n++;
  802246:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802249:	39 d0                	cmp    %edx,%eax
  80224b:	74 06                	je     802253 <strnlen+0x1d>
  80224d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  802251:	75 f3                	jne    802246 <strnlen+0x10>
	return n;
}
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    

00802255 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	53                   	push   %ebx
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80225f:	89 c2                	mov    %eax,%edx
  802261:	83 c1 01             	add    $0x1,%ecx
  802264:	83 c2 01             	add    $0x1,%edx
  802267:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80226b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80226e:	84 db                	test   %bl,%bl
  802270:	75 ef                	jne    802261 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  802272:	5b                   	pop    %ebx
  802273:	5d                   	pop    %ebp
  802274:	c3                   	ret    

00802275 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	53                   	push   %ebx
  802279:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80227c:	53                   	push   %ebx
  80227d:	e8 9c ff ff ff       	call   80221e <strlen>
  802282:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  802285:	ff 75 0c             	pushl  0xc(%ebp)
  802288:	01 d8                	add    %ebx,%eax
  80228a:	50                   	push   %eax
  80228b:	e8 c5 ff ff ff       	call   802255 <strcpy>
	return dst;
}
  802290:	89 d8                	mov    %ebx,%eax
  802292:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	56                   	push   %esi
  80229b:	53                   	push   %ebx
  80229c:	8b 75 08             	mov    0x8(%ebp),%esi
  80229f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022a2:	89 f3                	mov    %esi,%ebx
  8022a4:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8022a7:	89 f2                	mov    %esi,%edx
  8022a9:	eb 0f                	jmp    8022ba <strncpy+0x23>
		*dst++ = *src;
  8022ab:	83 c2 01             	add    $0x1,%edx
  8022ae:	0f b6 01             	movzbl (%ecx),%eax
  8022b1:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8022b4:	80 39 01             	cmpb   $0x1,(%ecx)
  8022b7:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8022ba:	39 da                	cmp    %ebx,%edx
  8022bc:	75 ed                	jne    8022ab <strncpy+0x14>
	}
	return ret;
}
  8022be:	89 f0                	mov    %esi,%eax
  8022c0:	5b                   	pop    %ebx
  8022c1:	5e                   	pop    %esi
  8022c2:	5d                   	pop    %ebp
  8022c3:	c3                   	ret    

008022c4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
  8022c7:	56                   	push   %esi
  8022c8:	53                   	push   %ebx
  8022c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8022cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022d2:	89 f0                	mov    %esi,%eax
  8022d4:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8022d8:	85 c9                	test   %ecx,%ecx
  8022da:	75 0b                	jne    8022e7 <strlcpy+0x23>
  8022dc:	eb 17                	jmp    8022f5 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8022de:	83 c2 01             	add    $0x1,%edx
  8022e1:	83 c0 01             	add    $0x1,%eax
  8022e4:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8022e7:	39 d8                	cmp    %ebx,%eax
  8022e9:	74 07                	je     8022f2 <strlcpy+0x2e>
  8022eb:	0f b6 0a             	movzbl (%edx),%ecx
  8022ee:	84 c9                	test   %cl,%cl
  8022f0:	75 ec                	jne    8022de <strlcpy+0x1a>
		*dst = '\0';
  8022f2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8022f5:	29 f0                	sub    %esi,%eax
}
  8022f7:	5b                   	pop    %ebx
  8022f8:	5e                   	pop    %esi
  8022f9:	5d                   	pop    %ebp
  8022fa:	c3                   	ret    

008022fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802301:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802304:	eb 06                	jmp    80230c <strcmp+0x11>
		p++, q++;
  802306:	83 c1 01             	add    $0x1,%ecx
  802309:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80230c:	0f b6 01             	movzbl (%ecx),%eax
  80230f:	84 c0                	test   %al,%al
  802311:	74 04                	je     802317 <strcmp+0x1c>
  802313:	3a 02                	cmp    (%edx),%al
  802315:	74 ef                	je     802306 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802317:	0f b6 c0             	movzbl %al,%eax
  80231a:	0f b6 12             	movzbl (%edx),%edx
  80231d:	29 d0                	sub    %edx,%eax
}
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    

00802321 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	53                   	push   %ebx
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232b:	89 c3                	mov    %eax,%ebx
  80232d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802330:	eb 06                	jmp    802338 <strncmp+0x17>
		n--, p++, q++;
  802332:	83 c0 01             	add    $0x1,%eax
  802335:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  802338:	39 d8                	cmp    %ebx,%eax
  80233a:	74 16                	je     802352 <strncmp+0x31>
  80233c:	0f b6 08             	movzbl (%eax),%ecx
  80233f:	84 c9                	test   %cl,%cl
  802341:	74 04                	je     802347 <strncmp+0x26>
  802343:	3a 0a                	cmp    (%edx),%cl
  802345:	74 eb                	je     802332 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802347:	0f b6 00             	movzbl (%eax),%eax
  80234a:	0f b6 12             	movzbl (%edx),%edx
  80234d:	29 d0                	sub    %edx,%eax
}
  80234f:	5b                   	pop    %ebx
  802350:	5d                   	pop    %ebp
  802351:	c3                   	ret    
		return 0;
  802352:	b8 00 00 00 00       	mov    $0x0,%eax
  802357:	eb f6                	jmp    80234f <strncmp+0x2e>

00802359 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802363:	0f b6 10             	movzbl (%eax),%edx
  802366:	84 d2                	test   %dl,%dl
  802368:	74 09                	je     802373 <strchr+0x1a>
		if (*s == c)
  80236a:	38 ca                	cmp    %cl,%dl
  80236c:	74 0a                	je     802378 <strchr+0x1f>
	for (; *s; s++)
  80236e:	83 c0 01             	add    $0x1,%eax
  802371:	eb f0                	jmp    802363 <strchr+0xa>
			return (char *) s;
	return 0;
  802373:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802378:	5d                   	pop    %ebp
  802379:	c3                   	ret    

0080237a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802384:	eb 03                	jmp    802389 <strfind+0xf>
  802386:	83 c0 01             	add    $0x1,%eax
  802389:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80238c:	38 ca                	cmp    %cl,%dl
  80238e:	74 04                	je     802394 <strfind+0x1a>
  802390:	84 d2                	test   %dl,%dl
  802392:	75 f2                	jne    802386 <strfind+0xc>
			break;
	return (char *) s;
}
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    

00802396 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	57                   	push   %edi
  80239a:	56                   	push   %esi
  80239b:	53                   	push   %ebx
  80239c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80239f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8023a2:	85 c9                	test   %ecx,%ecx
  8023a4:	74 13                	je     8023b9 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8023a6:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8023ac:	75 05                	jne    8023b3 <memset+0x1d>
  8023ae:	f6 c1 03             	test   $0x3,%cl
  8023b1:	74 0d                	je     8023c0 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8023b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b6:	fc                   	cld    
  8023b7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8023b9:	89 f8                	mov    %edi,%eax
  8023bb:	5b                   	pop    %ebx
  8023bc:	5e                   	pop    %esi
  8023bd:	5f                   	pop    %edi
  8023be:	5d                   	pop    %ebp
  8023bf:	c3                   	ret    
		c &= 0xFF;
  8023c0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8023c4:	89 d3                	mov    %edx,%ebx
  8023c6:	c1 e3 08             	shl    $0x8,%ebx
  8023c9:	89 d0                	mov    %edx,%eax
  8023cb:	c1 e0 18             	shl    $0x18,%eax
  8023ce:	89 d6                	mov    %edx,%esi
  8023d0:	c1 e6 10             	shl    $0x10,%esi
  8023d3:	09 f0                	or     %esi,%eax
  8023d5:	09 c2                	or     %eax,%edx
  8023d7:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8023d9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8023dc:	89 d0                	mov    %edx,%eax
  8023de:	fc                   	cld    
  8023df:	f3 ab                	rep stos %eax,%es:(%edi)
  8023e1:	eb d6                	jmp    8023b9 <memset+0x23>

008023e3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8023e3:	55                   	push   %ebp
  8023e4:	89 e5                	mov    %esp,%ebp
  8023e6:	57                   	push   %edi
  8023e7:	56                   	push   %esi
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8023f1:	39 c6                	cmp    %eax,%esi
  8023f3:	73 35                	jae    80242a <memmove+0x47>
  8023f5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8023f8:	39 c2                	cmp    %eax,%edx
  8023fa:	76 2e                	jbe    80242a <memmove+0x47>
		s += n;
		d += n;
  8023fc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8023ff:	89 d6                	mov    %edx,%esi
  802401:	09 fe                	or     %edi,%esi
  802403:	f7 c6 03 00 00 00    	test   $0x3,%esi
  802409:	74 0c                	je     802417 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80240b:	83 ef 01             	sub    $0x1,%edi
  80240e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  802411:	fd                   	std    
  802412:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802414:	fc                   	cld    
  802415:	eb 21                	jmp    802438 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802417:	f6 c1 03             	test   $0x3,%cl
  80241a:	75 ef                	jne    80240b <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80241c:	83 ef 04             	sub    $0x4,%edi
  80241f:	8d 72 fc             	lea    -0x4(%edx),%esi
  802422:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  802425:	fd                   	std    
  802426:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802428:	eb ea                	jmp    802414 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80242a:	89 f2                	mov    %esi,%edx
  80242c:	09 c2                	or     %eax,%edx
  80242e:	f6 c2 03             	test   $0x3,%dl
  802431:	74 09                	je     80243c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802433:	89 c7                	mov    %eax,%edi
  802435:	fc                   	cld    
  802436:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802438:	5e                   	pop    %esi
  802439:	5f                   	pop    %edi
  80243a:	5d                   	pop    %ebp
  80243b:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80243c:	f6 c1 03             	test   $0x3,%cl
  80243f:	75 f2                	jne    802433 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802441:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  802444:	89 c7                	mov    %eax,%edi
  802446:	fc                   	cld    
  802447:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802449:	eb ed                	jmp    802438 <memmove+0x55>

0080244b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80244e:	ff 75 10             	pushl  0x10(%ebp)
  802451:	ff 75 0c             	pushl  0xc(%ebp)
  802454:	ff 75 08             	pushl  0x8(%ebp)
  802457:	e8 87 ff ff ff       	call   8023e3 <memmove>
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	56                   	push   %esi
  802462:	53                   	push   %ebx
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	8b 55 0c             	mov    0xc(%ebp),%edx
  802469:	89 c6                	mov    %eax,%esi
  80246b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80246e:	39 f0                	cmp    %esi,%eax
  802470:	74 1c                	je     80248e <memcmp+0x30>
		if (*s1 != *s2)
  802472:	0f b6 08             	movzbl (%eax),%ecx
  802475:	0f b6 1a             	movzbl (%edx),%ebx
  802478:	38 d9                	cmp    %bl,%cl
  80247a:	75 08                	jne    802484 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80247c:	83 c0 01             	add    $0x1,%eax
  80247f:	83 c2 01             	add    $0x1,%edx
  802482:	eb ea                	jmp    80246e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  802484:	0f b6 c1             	movzbl %cl,%eax
  802487:	0f b6 db             	movzbl %bl,%ebx
  80248a:	29 d8                	sub    %ebx,%eax
  80248c:	eb 05                	jmp    802493 <memcmp+0x35>
	}

	return 0;
  80248e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802493:	5b                   	pop    %ebx
  802494:	5e                   	pop    %esi
  802495:	5d                   	pop    %ebp
  802496:	c3                   	ret    

00802497 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8024a0:	89 c2                	mov    %eax,%edx
  8024a2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8024a5:	39 d0                	cmp    %edx,%eax
  8024a7:	73 09                	jae    8024b2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8024a9:	38 08                	cmp    %cl,(%eax)
  8024ab:	74 05                	je     8024b2 <memfind+0x1b>
	for (; s < ends; s++)
  8024ad:	83 c0 01             	add    $0x1,%eax
  8024b0:	eb f3                	jmp    8024a5 <memfind+0xe>
			break;
	return (void *) s;
}
  8024b2:	5d                   	pop    %ebp
  8024b3:	c3                   	ret    

008024b4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
  8024b7:	57                   	push   %edi
  8024b8:	56                   	push   %esi
  8024b9:	53                   	push   %ebx
  8024ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8024c0:	eb 03                	jmp    8024c5 <strtol+0x11>
		s++;
  8024c2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8024c5:	0f b6 01             	movzbl (%ecx),%eax
  8024c8:	3c 20                	cmp    $0x20,%al
  8024ca:	74 f6                	je     8024c2 <strtol+0xe>
  8024cc:	3c 09                	cmp    $0x9,%al
  8024ce:	74 f2                	je     8024c2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8024d0:	3c 2b                	cmp    $0x2b,%al
  8024d2:	74 2e                	je     802502 <strtol+0x4e>
	int neg = 0;
  8024d4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8024d9:	3c 2d                	cmp    $0x2d,%al
  8024db:	74 2f                	je     80250c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8024dd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8024e3:	75 05                	jne    8024ea <strtol+0x36>
  8024e5:	80 39 30             	cmpb   $0x30,(%ecx)
  8024e8:	74 2c                	je     802516 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8024ea:	85 db                	test   %ebx,%ebx
  8024ec:	75 0a                	jne    8024f8 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8024ee:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8024f3:	80 39 30             	cmpb   $0x30,(%ecx)
  8024f6:	74 28                	je     802520 <strtol+0x6c>
		base = 10;
  8024f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802500:	eb 50                	jmp    802552 <strtol+0x9e>
		s++;
  802502:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  802505:	bf 00 00 00 00       	mov    $0x0,%edi
  80250a:	eb d1                	jmp    8024dd <strtol+0x29>
		s++, neg = 1;
  80250c:	83 c1 01             	add    $0x1,%ecx
  80250f:	bf 01 00 00 00       	mov    $0x1,%edi
  802514:	eb c7                	jmp    8024dd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802516:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80251a:	74 0e                	je     80252a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  80251c:	85 db                	test   %ebx,%ebx
  80251e:	75 d8                	jne    8024f8 <strtol+0x44>
		s++, base = 8;
  802520:	83 c1 01             	add    $0x1,%ecx
  802523:	bb 08 00 00 00       	mov    $0x8,%ebx
  802528:	eb ce                	jmp    8024f8 <strtol+0x44>
		s += 2, base = 16;
  80252a:	83 c1 02             	add    $0x2,%ecx
  80252d:	bb 10 00 00 00       	mov    $0x10,%ebx
  802532:	eb c4                	jmp    8024f8 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  802534:	8d 72 9f             	lea    -0x61(%edx),%esi
  802537:	89 f3                	mov    %esi,%ebx
  802539:	80 fb 19             	cmp    $0x19,%bl
  80253c:	77 29                	ja     802567 <strtol+0xb3>
			dig = *s - 'a' + 10;
  80253e:	0f be d2             	movsbl %dl,%edx
  802541:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  802544:	3b 55 10             	cmp    0x10(%ebp),%edx
  802547:	7d 30                	jge    802579 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  802549:	83 c1 01             	add    $0x1,%ecx
  80254c:	0f af 45 10          	imul   0x10(%ebp),%eax
  802550:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802552:	0f b6 11             	movzbl (%ecx),%edx
  802555:	8d 72 d0             	lea    -0x30(%edx),%esi
  802558:	89 f3                	mov    %esi,%ebx
  80255a:	80 fb 09             	cmp    $0x9,%bl
  80255d:	77 d5                	ja     802534 <strtol+0x80>
			dig = *s - '0';
  80255f:	0f be d2             	movsbl %dl,%edx
  802562:	83 ea 30             	sub    $0x30,%edx
  802565:	eb dd                	jmp    802544 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  802567:	8d 72 bf             	lea    -0x41(%edx),%esi
  80256a:	89 f3                	mov    %esi,%ebx
  80256c:	80 fb 19             	cmp    $0x19,%bl
  80256f:	77 08                	ja     802579 <strtol+0xc5>
			dig = *s - 'A' + 10;
  802571:	0f be d2             	movsbl %dl,%edx
  802574:	83 ea 37             	sub    $0x37,%edx
  802577:	eb cb                	jmp    802544 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  802579:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80257d:	74 05                	je     802584 <strtol+0xd0>
		*endptr = (char *) s;
  80257f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802582:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802584:	89 c2                	mov    %eax,%edx
  802586:	f7 da                	neg    %edx
  802588:	85 ff                	test   %edi,%edi
  80258a:	0f 45 c2             	cmovne %edx,%eax
}
  80258d:	5b                   	pop    %ebx
  80258e:	5e                   	pop    %esi
  80258f:	5f                   	pop    %edi
  802590:	5d                   	pop    %ebp
  802591:	c3                   	ret    

00802592 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
  802595:	57                   	push   %edi
  802596:	56                   	push   %esi
  802597:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  802598:	b8 00 00 00 00       	mov    $0x0,%eax
  80259d:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025a3:	89 c3                	mov    %eax,%ebx
  8025a5:	89 c7                	mov    %eax,%edi
  8025a7:	89 c6                	mov    %eax,%esi
  8025a9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8025ab:	5b                   	pop    %ebx
  8025ac:	5e                   	pop    %esi
  8025ad:	5f                   	pop    %edi
  8025ae:	5d                   	pop    %ebp
  8025af:	c3                   	ret    

008025b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	57                   	push   %edi
  8025b4:	56                   	push   %esi
  8025b5:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8025b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8025bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c0:	89 d1                	mov    %edx,%ecx
  8025c2:	89 d3                	mov    %edx,%ebx
  8025c4:	89 d7                	mov    %edx,%edi
  8025c6:	89 d6                	mov    %edx,%esi
  8025c8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8025ca:	5b                   	pop    %ebx
  8025cb:	5e                   	pop    %esi
  8025cc:	5f                   	pop    %edi
  8025cd:	5d                   	pop    %ebp
  8025ce:	c3                   	ret    

008025cf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
  8025d2:	57                   	push   %edi
  8025d3:	56                   	push   %esi
  8025d4:	53                   	push   %ebx
  8025d5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8025d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8025dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e0:	b8 03 00 00 00       	mov    $0x3,%eax
  8025e5:	89 cb                	mov    %ecx,%ebx
  8025e7:	89 cf                	mov    %ecx,%edi
  8025e9:	89 ce                	mov    %ecx,%esi
  8025eb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	7f 08                	jg     8025f9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8025f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025f4:	5b                   	pop    %ebx
  8025f5:	5e                   	pop    %esi
  8025f6:	5f                   	pop    %edi
  8025f7:	5d                   	pop    %ebp
  8025f8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8025f9:	83 ec 0c             	sub    $0xc,%esp
  8025fc:	50                   	push   %eax
  8025fd:	6a 03                	push   $0x3
  8025ff:	68 1f 42 80 00       	push   $0x80421f
  802604:	6a 23                	push   $0x23
  802606:	68 3c 42 80 00       	push   $0x80423c
  80260b:	e8 4b f5 ff ff       	call   801b5b <_panic>

00802610 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
  802613:	57                   	push   %edi
  802614:	56                   	push   %esi
  802615:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  802616:	ba 00 00 00 00       	mov    $0x0,%edx
  80261b:	b8 02 00 00 00       	mov    $0x2,%eax
  802620:	89 d1                	mov    %edx,%ecx
  802622:	89 d3                	mov    %edx,%ebx
  802624:	89 d7                	mov    %edx,%edi
  802626:	89 d6                	mov    %edx,%esi
  802628:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80262a:	5b                   	pop    %ebx
  80262b:	5e                   	pop    %esi
  80262c:	5f                   	pop    %edi
  80262d:	5d                   	pop    %ebp
  80262e:	c3                   	ret    

0080262f <sys_yield>:

void
sys_yield(void)
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
  802632:	57                   	push   %edi
  802633:	56                   	push   %esi
  802634:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  802635:	ba 00 00 00 00       	mov    $0x0,%edx
  80263a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80263f:	89 d1                	mov    %edx,%ecx
  802641:	89 d3                	mov    %edx,%ebx
  802643:	89 d7                	mov    %edx,%edi
  802645:	89 d6                	mov    %edx,%esi
  802647:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  802649:	5b                   	pop    %ebx
  80264a:	5e                   	pop    %esi
  80264b:	5f                   	pop    %edi
  80264c:	5d                   	pop    %ebp
  80264d:	c3                   	ret    

0080264e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80264e:	55                   	push   %ebp
  80264f:	89 e5                	mov    %esp,%ebp
  802651:	57                   	push   %edi
  802652:	56                   	push   %esi
  802653:	53                   	push   %ebx
  802654:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  802657:	be 00 00 00 00       	mov    $0x0,%esi
  80265c:	8b 55 08             	mov    0x8(%ebp),%edx
  80265f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802662:	b8 04 00 00 00       	mov    $0x4,%eax
  802667:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80266a:	89 f7                	mov    %esi,%edi
  80266c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80266e:	85 c0                	test   %eax,%eax
  802670:	7f 08                	jg     80267a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  802672:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802675:	5b                   	pop    %ebx
  802676:	5e                   	pop    %esi
  802677:	5f                   	pop    %edi
  802678:	5d                   	pop    %ebp
  802679:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80267a:	83 ec 0c             	sub    $0xc,%esp
  80267d:	50                   	push   %eax
  80267e:	6a 04                	push   $0x4
  802680:	68 1f 42 80 00       	push   $0x80421f
  802685:	6a 23                	push   $0x23
  802687:	68 3c 42 80 00       	push   $0x80423c
  80268c:	e8 ca f4 ff ff       	call   801b5b <_panic>

00802691 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
  802694:	57                   	push   %edi
  802695:	56                   	push   %esi
  802696:	53                   	push   %ebx
  802697:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80269a:	8b 55 08             	mov    0x8(%ebp),%edx
  80269d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8026a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026a8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8026ab:	8b 75 18             	mov    0x18(%ebp),%esi
  8026ae:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	7f 08                	jg     8026bc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8026b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026b7:	5b                   	pop    %ebx
  8026b8:	5e                   	pop    %esi
  8026b9:	5f                   	pop    %edi
  8026ba:	5d                   	pop    %ebp
  8026bb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026bc:	83 ec 0c             	sub    $0xc,%esp
  8026bf:	50                   	push   %eax
  8026c0:	6a 05                	push   $0x5
  8026c2:	68 1f 42 80 00       	push   $0x80421f
  8026c7:	6a 23                	push   $0x23
  8026c9:	68 3c 42 80 00       	push   $0x80423c
  8026ce:	e8 88 f4 ff ff       	call   801b5b <_panic>

008026d3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8026d3:	55                   	push   %ebp
  8026d4:	89 e5                	mov    %esp,%ebp
  8026d6:	57                   	push   %edi
  8026d7:	56                   	push   %esi
  8026d8:	53                   	push   %ebx
  8026d9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8026dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026e7:	b8 06 00 00 00       	mov    $0x6,%eax
  8026ec:	89 df                	mov    %ebx,%edi
  8026ee:	89 de                	mov    %ebx,%esi
  8026f0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	7f 08                	jg     8026fe <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8026f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026f9:	5b                   	pop    %ebx
  8026fa:	5e                   	pop    %esi
  8026fb:	5f                   	pop    %edi
  8026fc:	5d                   	pop    %ebp
  8026fd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026fe:	83 ec 0c             	sub    $0xc,%esp
  802701:	50                   	push   %eax
  802702:	6a 06                	push   $0x6
  802704:	68 1f 42 80 00       	push   $0x80421f
  802709:	6a 23                	push   $0x23
  80270b:	68 3c 42 80 00       	push   $0x80423c
  802710:	e8 46 f4 ff ff       	call   801b5b <_panic>

00802715 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
  802718:	57                   	push   %edi
  802719:	56                   	push   %esi
  80271a:	53                   	push   %ebx
  80271b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  80271e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802723:	8b 55 08             	mov    0x8(%ebp),%edx
  802726:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802729:	b8 08 00 00 00       	mov    $0x8,%eax
  80272e:	89 df                	mov    %ebx,%edi
  802730:	89 de                	mov    %ebx,%esi
  802732:	cd 30                	int    $0x30
	if(check && ret > 0)
  802734:	85 c0                	test   %eax,%eax
  802736:	7f 08                	jg     802740 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802738:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80273b:	5b                   	pop    %ebx
  80273c:	5e                   	pop    %esi
  80273d:	5f                   	pop    %edi
  80273e:	5d                   	pop    %ebp
  80273f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802740:	83 ec 0c             	sub    $0xc,%esp
  802743:	50                   	push   %eax
  802744:	6a 08                	push   $0x8
  802746:	68 1f 42 80 00       	push   $0x80421f
  80274b:	6a 23                	push   $0x23
  80274d:	68 3c 42 80 00       	push   $0x80423c
  802752:	e8 04 f4 ff ff       	call   801b5b <_panic>

00802757 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
  80275a:	57                   	push   %edi
  80275b:	56                   	push   %esi
  80275c:	53                   	push   %ebx
  80275d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  802760:	bb 00 00 00 00       	mov    $0x0,%ebx
  802765:	8b 55 08             	mov    0x8(%ebp),%edx
  802768:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80276b:	b8 09 00 00 00       	mov    $0x9,%eax
  802770:	89 df                	mov    %ebx,%edi
  802772:	89 de                	mov    %ebx,%esi
  802774:	cd 30                	int    $0x30
	if(check && ret > 0)
  802776:	85 c0                	test   %eax,%eax
  802778:	7f 08                	jg     802782 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80277a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80277d:	5b                   	pop    %ebx
  80277e:	5e                   	pop    %esi
  80277f:	5f                   	pop    %edi
  802780:	5d                   	pop    %ebp
  802781:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802782:	83 ec 0c             	sub    $0xc,%esp
  802785:	50                   	push   %eax
  802786:	6a 09                	push   $0x9
  802788:	68 1f 42 80 00       	push   $0x80421f
  80278d:	6a 23                	push   $0x23
  80278f:	68 3c 42 80 00       	push   $0x80423c
  802794:	e8 c2 f3 ff ff       	call   801b5b <_panic>

00802799 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
  80279c:	57                   	push   %edi
  80279d:	56                   	push   %esi
  80279e:	53                   	push   %ebx
  80279f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8027a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8027b2:	89 df                	mov    %ebx,%edi
  8027b4:	89 de                	mov    %ebx,%esi
  8027b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8027b8:	85 c0                	test   %eax,%eax
  8027ba:	7f 08                	jg     8027c4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8027bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027bf:	5b                   	pop    %ebx
  8027c0:	5e                   	pop    %esi
  8027c1:	5f                   	pop    %edi
  8027c2:	5d                   	pop    %ebp
  8027c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8027c4:	83 ec 0c             	sub    $0xc,%esp
  8027c7:	50                   	push   %eax
  8027c8:	6a 0a                	push   $0xa
  8027ca:	68 1f 42 80 00       	push   $0x80421f
  8027cf:	6a 23                	push   $0x23
  8027d1:	68 3c 42 80 00       	push   $0x80423c
  8027d6:	e8 80 f3 ff ff       	call   801b5b <_panic>

008027db <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	57                   	push   %edi
  8027df:	56                   	push   %esi
  8027e0:	53                   	push   %ebx
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  8027e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027e7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8027ec:	be 00 00 00 00       	mov    $0x0,%esi
  8027f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027f4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8027f7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8027f9:	5b                   	pop    %ebx
  8027fa:	5e                   	pop    %esi
  8027fb:	5f                   	pop    %edi
  8027fc:	5d                   	pop    %ebp
  8027fd:	c3                   	ret    

008027fe <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	57                   	push   %edi
  802802:	56                   	push   %esi
  802803:	53                   	push   %ebx
  802804:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"							//执行int T_SYSCALL指令
  802807:	b9 00 00 00 00       	mov    $0x0,%ecx
  80280c:	8b 55 08             	mov    0x8(%ebp),%edx
  80280f:	b8 0d 00 00 00       	mov    $0xd,%eax
  802814:	89 cb                	mov    %ecx,%ebx
  802816:	89 cf                	mov    %ecx,%edi
  802818:	89 ce                	mov    %ecx,%esi
  80281a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80281c:	85 c0                	test   %eax,%eax
  80281e:	7f 08                	jg     802828 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802820:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802823:	5b                   	pop    %ebx
  802824:	5e                   	pop    %esi
  802825:	5f                   	pop    %edi
  802826:	5d                   	pop    %ebp
  802827:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802828:	83 ec 0c             	sub    $0xc,%esp
  80282b:	50                   	push   %eax
  80282c:	6a 0d                	push   $0xd
  80282e:	68 1f 42 80 00       	push   $0x80421f
  802833:	6a 23                	push   $0x23
  802835:	68 3c 42 80 00       	push   $0x80423c
  80283a:	e8 1c f3 ff ff       	call   801b5b <_panic>

0080283f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
  802842:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802845:	83 3d 10 a0 80 00 00 	cmpl   $0x0,0x80a010
  80284c:	74 0a                	je     802858 <set_pgfault_handler+0x19>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80284e:	8b 45 08             	mov    0x8(%ebp),%eax
  802851:	a3 10 a0 80 00       	mov    %eax,0x80a010
}
  802856:	c9                   	leave  
  802857:	c3                   	ret    
		int r = sys_page_alloc(0, (void *)(UXSTACKTOP-PGSIZE), PTE_W | PTE_U | PTE_P);	//为当前进程分配异常栈
  802858:	83 ec 04             	sub    $0x4,%esp
  80285b:	6a 07                	push   $0x7
  80285d:	68 00 f0 bf ee       	push   $0xeebff000
  802862:	6a 00                	push   $0x0
  802864:	e8 e5 fd ff ff       	call   80264e <sys_page_alloc>
		if (r < 0) {
  802869:	83 c4 10             	add    $0x10,%esp
  80286c:	85 c0                	test   %eax,%eax
  80286e:	78 14                	js     802884 <set_pgfault_handler+0x45>
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);		//系统调用，设置进程的env_pgfault_upcall属性
  802870:	83 ec 08             	sub    $0x8,%esp
  802873:	68 98 28 80 00       	push   $0x802898
  802878:	6a 00                	push   $0x0
  80287a:	e8 1a ff ff ff       	call   802799 <sys_env_set_pgfault_upcall>
  80287f:	83 c4 10             	add    $0x10,%esp
  802882:	eb ca                	jmp    80284e <set_pgfault_handler+0xf>
			panic("set_pgfault_handler:sys_page_alloc failed");;
  802884:	83 ec 04             	sub    $0x4,%esp
  802887:	68 4c 42 80 00       	push   $0x80424c
  80288c:	6a 22                	push   $0x22
  80288e:	68 76 42 80 00       	push   $0x804276
  802893:	e8 c3 f2 ff ff       	call   801b5b <_panic>

00802898 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802898:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802899:	a1 10 a0 80 00       	mov    0x80a010,%eax
	call *%eax				//调用页处理函数
  80289e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028a0:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp			//跳过utf_fault_va和utf_err
  8028a3:	83 c4 08             	add    $0x8,%esp
	movl 40(%esp), %eax 	//保存中断发生时的esp到eax
  8028a6:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl 32(%esp), %ecx 	//保存终端发生时的eip到ecx
  8028aa:	8b 4c 24 20          	mov    0x20(%esp),%ecx
	movl %ecx, -4(%eax) 	//将中断发生时的esp值亚入到到原来的栈中
  8028ae:	89 48 fc             	mov    %ecx,-0x4(%eax)
	popal
  8028b1:	61                   	popa   
	addl $4, %esp			//跳过eip
  8028b2:	83 c4 04             	add    $0x4,%esp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  8028b5:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8028b6:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	lea -4(%esp), %esp		//因为之前压入了eip的值但是没有减esp的值，所以现在需要将esp寄存器中的值减4
  8028b7:	8d 64 24 fc          	lea    -0x4(%esp),%esp
  8028bb:	c3                   	ret    

008028bc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028bc:	55                   	push   %ebp
  8028bd:	89 e5                	mov    %esp,%ebp
  8028bf:	56                   	push   %esi
  8028c0:	53                   	push   %ebx
  8028c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8028c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  8028ca:	85 c0                	test   %eax,%eax
		pg = (void *)-1;
  8028cc:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8028d1:	0f 44 c2             	cmove  %edx,%eax
	}
	int r = sys_ipc_recv(pg);
  8028d4:	83 ec 0c             	sub    $0xc,%esp
  8028d7:	50                   	push   %eax
  8028d8:	e8 21 ff ff ff       	call   8027fe <sys_ipc_recv>
	if (r < 0) {				//系统调用失败
  8028dd:	83 c4 10             	add    $0x10,%esp
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	78 2b                	js     80290f <ipc_recv+0x53>
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0;
		return r;
	}
	if (from_env_store)
  8028e4:	85 f6                	test   %esi,%esi
  8028e6:	74 0a                	je     8028f2 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8028e8:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8028ed:	8b 40 74             	mov    0x74(%eax),%eax
  8028f0:	89 06                	mov    %eax,(%esi)
	if (perm_store)
  8028f2:	85 db                	test   %ebx,%ebx
  8028f4:	74 0a                	je     802900 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8028f6:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8028fb:	8b 40 78             	mov    0x78(%eax),%eax
  8028fe:	89 03                	mov    %eax,(%ebx)
	return thisenv->env_ipc_value;
  802900:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802905:	8b 40 70             	mov    0x70(%eax),%eax
}
  802908:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80290b:	5b                   	pop    %ebx
  80290c:	5e                   	pop    %esi
  80290d:	5d                   	pop    %ebp
  80290e:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80290f:	85 f6                	test   %esi,%esi
  802911:	74 06                	je     802919 <ipc_recv+0x5d>
  802913:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802919:	85 db                	test   %ebx,%ebx
  80291b:	74 eb                	je     802908 <ipc_recv+0x4c>
  80291d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802923:	eb e3                	jmp    802908 <ipc_recv+0x4c>

00802925 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802925:	55                   	push   %ebp
  802926:	89 e5                	mov    %esp,%ebp
  802928:	57                   	push   %edi
  802929:	56                   	push   %esi
  80292a:	53                   	push   %ebx
  80292b:	83 ec 0c             	sub    $0xc,%esp
  80292e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802931:	8b 75 0c             	mov    0xc(%ebp),%esi
  802934:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL) {
  802937:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;
  802939:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80293e:	0f 44 d8             	cmove  %eax,%ebx
	}
	int r;
	while(1) {
		r = sys_ipc_try_send(to_env, val, pg, perm);
  802941:	ff 75 14             	pushl  0x14(%ebp)
  802944:	53                   	push   %ebx
  802945:	56                   	push   %esi
  802946:	57                   	push   %edi
  802947:	e8 8f fe ff ff       	call   8027db <sys_ipc_try_send>
		if (r == 0) {		//发送成功
  80294c:	83 c4 10             	add    $0x10,%esp
  80294f:	85 c0                	test   %eax,%eax
  802951:	74 1e                	je     802971 <ipc_send+0x4c>
			return;
		} else if (r == -E_IPC_NOT_RECV) {	//接收进程没有准备好
  802953:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802956:	75 07                	jne    80295f <ipc_send+0x3a>
			sys_yield();
  802958:	e8 d2 fc ff ff       	call   80262f <sys_yield>
		r = sys_ipc_try_send(to_env, val, pg, perm);
  80295d:	eb e2                	jmp    802941 <ipc_send+0x1c>
		} else {			//其它错误
			panic("ipc_send():%e", r);
  80295f:	50                   	push   %eax
  802960:	68 84 42 80 00       	push   $0x804284
  802965:	6a 41                	push   $0x41
  802967:	68 92 42 80 00       	push   $0x804292
  80296c:	e8 ea f1 ff ff       	call   801b5b <_panic>
		}
	}
}
  802971:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802974:	5b                   	pop    %ebx
  802975:	5e                   	pop    %esi
  802976:	5f                   	pop    %edi
  802977:	5d                   	pop    %ebp
  802978:	c3                   	ret    

00802979 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802979:	55                   	push   %ebp
  80297a:	89 e5                	mov    %esp,%ebp
  80297c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80297f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802984:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802987:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80298d:	8b 52 50             	mov    0x50(%edx),%edx
  802990:	39 ca                	cmp    %ecx,%edx
  802992:	74 11                	je     8029a5 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802994:	83 c0 01             	add    $0x1,%eax
  802997:	3d 00 04 00 00       	cmp    $0x400,%eax
  80299c:	75 e6                	jne    802984 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80299e:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a3:	eb 0b                	jmp    8029b0 <ipc_find_env+0x37>
			return envs[i].env_id;
  8029a5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8029a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8029ad:	8b 40 48             	mov    0x48(%eax),%eax
}
  8029b0:	5d                   	pop    %ebp
  8029b1:	c3                   	ret    

008029b2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8029b2:	55                   	push   %ebp
  8029b3:	89 e5                	mov    %esp,%ebp
  8029b5:	56                   	push   %esi
  8029b6:	53                   	push   %ebx
  8029b7:	89 c6                	mov    %eax,%esi
  8029b9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8029bb:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  8029c2:	74 27                	je     8029eb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8029c4:	6a 07                	push   $0x7
  8029c6:	68 00 b0 80 00       	push   $0x80b000
  8029cb:	56                   	push   %esi
  8029cc:	ff 35 00 a0 80 00    	pushl  0x80a000
  8029d2:	e8 4e ff ff ff       	call   802925 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8029d7:	83 c4 0c             	add    $0xc,%esp
  8029da:	6a 00                	push   $0x0
  8029dc:	53                   	push   %ebx
  8029dd:	6a 00                	push   $0x0
  8029df:	e8 d8 fe ff ff       	call   8028bc <ipc_recv>
}
  8029e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029e7:	5b                   	pop    %ebx
  8029e8:	5e                   	pop    %esi
  8029e9:	5d                   	pop    %ebp
  8029ea:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8029eb:	83 ec 0c             	sub    $0xc,%esp
  8029ee:	6a 01                	push   $0x1
  8029f0:	e8 84 ff ff ff       	call   802979 <ipc_find_env>
  8029f5:	a3 00 a0 80 00       	mov    %eax,0x80a000
  8029fa:	83 c4 10             	add    $0x10,%esp
  8029fd:	eb c5                	jmp    8029c4 <fsipc+0x12>

008029ff <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8029ff:	55                   	push   %ebp
  802a00:	89 e5                	mov    %esp,%ebp
  802a02:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0b:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  802a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a13:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a18:	ba 00 00 00 00       	mov    $0x0,%edx
  802a1d:	b8 02 00 00 00       	mov    $0x2,%eax
  802a22:	e8 8b ff ff ff       	call   8029b2 <fsipc>
}
  802a27:	c9                   	leave  
  802a28:	c3                   	ret    

00802a29 <devfile_flush>:
{
  802a29:	55                   	push   %ebp
  802a2a:	89 e5                	mov    %esp,%ebp
  802a2c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	8b 40 0c             	mov    0xc(%eax),%eax
  802a35:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  802a3a:	ba 00 00 00 00       	mov    $0x0,%edx
  802a3f:	b8 06 00 00 00       	mov    $0x6,%eax
  802a44:	e8 69 ff ff ff       	call   8029b2 <fsipc>
}
  802a49:	c9                   	leave  
  802a4a:	c3                   	ret    

00802a4b <devfile_stat>:
{
  802a4b:	55                   	push   %ebp
  802a4c:	89 e5                	mov    %esp,%ebp
  802a4e:	53                   	push   %ebx
  802a4f:	83 ec 04             	sub    $0x4,%esp
  802a52:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5b:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a60:	ba 00 00 00 00       	mov    $0x0,%edx
  802a65:	b8 05 00 00 00       	mov    $0x5,%eax
  802a6a:	e8 43 ff ff ff       	call   8029b2 <fsipc>
  802a6f:	85 c0                	test   %eax,%eax
  802a71:	78 2c                	js     802a9f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a73:	83 ec 08             	sub    $0x8,%esp
  802a76:	68 00 b0 80 00       	push   $0x80b000
  802a7b:	53                   	push   %ebx
  802a7c:	e8 d4 f7 ff ff       	call   802255 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802a81:	a1 80 b0 80 00       	mov    0x80b080,%eax
  802a86:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a8c:	a1 84 b0 80 00       	mov    0x80b084,%eax
  802a91:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802a97:	83 c4 10             	add    $0x10,%esp
  802a9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802aa2:	c9                   	leave  
  802aa3:	c3                   	ret    

00802aa4 <devfile_write>:
{
  802aa4:	55                   	push   %ebp
  802aa5:	89 e5                	mov    %esp,%ebp
  802aa7:	53                   	push   %ebx
  802aa8:	83 ec 08             	sub    $0x8,%esp
  802aab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	n = sizeof(fsipcbuf.write.req_buf) > n ? n : sizeof(fsipcbuf.write.req_buf);
  802aae:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  802ab4:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  802ab9:	0f 47 d8             	cmova  %eax,%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac2:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.write.req_n = n;
  802ac7:	89 1d 04 b0 80 00    	mov    %ebx,0x80b004
	memmove(fsipcbuf.write.req_buf, buf, n);
  802acd:	53                   	push   %ebx
  802ace:	ff 75 0c             	pushl  0xc(%ebp)
  802ad1:	68 08 b0 80 00       	push   $0x80b008
  802ad6:	e8 08 f9 ff ff       	call   8023e3 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802adb:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae0:	b8 04 00 00 00       	mov    $0x4,%eax
  802ae5:	e8 c8 fe ff ff       	call   8029b2 <fsipc>
  802aea:	83 c4 10             	add    $0x10,%esp
  802aed:	85 c0                	test   %eax,%eax
  802aef:	78 0b                	js     802afc <devfile_write+0x58>
	assert(r <= n);
  802af1:	39 d8                	cmp    %ebx,%eax
  802af3:	77 0c                	ja     802b01 <devfile_write+0x5d>
	assert(r <= PGSIZE);
  802af5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802afa:	7f 1e                	jg     802b1a <devfile_write+0x76>
}
  802afc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802aff:	c9                   	leave  
  802b00:	c3                   	ret    
	assert(r <= n);
  802b01:	68 9c 42 80 00       	push   $0x80429c
  802b06:	68 7d 39 80 00       	push   $0x80397d
  802b0b:	68 98 00 00 00       	push   $0x98
  802b10:	68 a3 42 80 00       	push   $0x8042a3
  802b15:	e8 41 f0 ff ff       	call   801b5b <_panic>
	assert(r <= PGSIZE);
  802b1a:	68 ae 42 80 00       	push   $0x8042ae
  802b1f:	68 7d 39 80 00       	push   $0x80397d
  802b24:	68 99 00 00 00       	push   $0x99
  802b29:	68 a3 42 80 00       	push   $0x8042a3
  802b2e:	e8 28 f0 ff ff       	call   801b5b <_panic>

00802b33 <devfile_read>:
{
  802b33:	55                   	push   %ebp
  802b34:	89 e5                	mov    %esp,%ebp
  802b36:	56                   	push   %esi
  802b37:	53                   	push   %ebx
  802b38:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b41:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  802b46:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802b4c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b51:	b8 03 00 00 00       	mov    $0x3,%eax
  802b56:	e8 57 fe ff ff       	call   8029b2 <fsipc>
  802b5b:	89 c3                	mov    %eax,%ebx
  802b5d:	85 c0                	test   %eax,%eax
  802b5f:	78 1f                	js     802b80 <devfile_read+0x4d>
	assert(r <= n);
  802b61:	39 f0                	cmp    %esi,%eax
  802b63:	77 24                	ja     802b89 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802b65:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802b6a:	7f 33                	jg     802b9f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802b6c:	83 ec 04             	sub    $0x4,%esp
  802b6f:	50                   	push   %eax
  802b70:	68 00 b0 80 00       	push   $0x80b000
  802b75:	ff 75 0c             	pushl  0xc(%ebp)
  802b78:	e8 66 f8 ff ff       	call   8023e3 <memmove>
	return r;
  802b7d:	83 c4 10             	add    $0x10,%esp
}
  802b80:	89 d8                	mov    %ebx,%eax
  802b82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b85:	5b                   	pop    %ebx
  802b86:	5e                   	pop    %esi
  802b87:	5d                   	pop    %ebp
  802b88:	c3                   	ret    
	assert(r <= n);
  802b89:	68 9c 42 80 00       	push   $0x80429c
  802b8e:	68 7d 39 80 00       	push   $0x80397d
  802b93:	6a 7c                	push   $0x7c
  802b95:	68 a3 42 80 00       	push   $0x8042a3
  802b9a:	e8 bc ef ff ff       	call   801b5b <_panic>
	assert(r <= PGSIZE);
  802b9f:	68 ae 42 80 00       	push   $0x8042ae
  802ba4:	68 7d 39 80 00       	push   $0x80397d
  802ba9:	6a 7d                	push   $0x7d
  802bab:	68 a3 42 80 00       	push   $0x8042a3
  802bb0:	e8 a6 ef ff ff       	call   801b5b <_panic>

00802bb5 <open>:
{
  802bb5:	55                   	push   %ebp
  802bb6:	89 e5                	mov    %esp,%ebp
  802bb8:	56                   	push   %esi
  802bb9:	53                   	push   %ebx
  802bba:	83 ec 1c             	sub    $0x1c,%esp
  802bbd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802bc0:	56                   	push   %esi
  802bc1:	e8 58 f6 ff ff       	call   80221e <strlen>
  802bc6:	83 c4 10             	add    $0x10,%esp
  802bc9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bce:	7f 6c                	jg     802c3c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802bd0:	83 ec 0c             	sub    $0xc,%esp
  802bd3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802bd6:	50                   	push   %eax
  802bd7:	e8 e0 00 00 00       	call   802cbc <fd_alloc>
  802bdc:	89 c3                	mov    %eax,%ebx
  802bde:	83 c4 10             	add    $0x10,%esp
  802be1:	85 c0                	test   %eax,%eax
  802be3:	78 3c                	js     802c21 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802be5:	83 ec 08             	sub    $0x8,%esp
  802be8:	56                   	push   %esi
  802be9:	68 00 b0 80 00       	push   $0x80b000
  802bee:	e8 62 f6 ff ff       	call   802255 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bf6:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802bfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  802c03:	e8 aa fd ff ff       	call   8029b2 <fsipc>
  802c08:	89 c3                	mov    %eax,%ebx
  802c0a:	83 c4 10             	add    $0x10,%esp
  802c0d:	85 c0                	test   %eax,%eax
  802c0f:	78 19                	js     802c2a <open+0x75>
	return fd2num(fd);
  802c11:	83 ec 0c             	sub    $0xc,%esp
  802c14:	ff 75 f4             	pushl  -0xc(%ebp)
  802c17:	e8 79 00 00 00       	call   802c95 <fd2num>
  802c1c:	89 c3                	mov    %eax,%ebx
  802c1e:	83 c4 10             	add    $0x10,%esp
}
  802c21:	89 d8                	mov    %ebx,%eax
  802c23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c26:	5b                   	pop    %ebx
  802c27:	5e                   	pop    %esi
  802c28:	5d                   	pop    %ebp
  802c29:	c3                   	ret    
		fd_close(fd, 0);
  802c2a:	83 ec 08             	sub    $0x8,%esp
  802c2d:	6a 00                	push   $0x0
  802c2f:	ff 75 f4             	pushl  -0xc(%ebp)
  802c32:	e8 80 01 00 00       	call   802db7 <fd_close>
		return r;
  802c37:	83 c4 10             	add    $0x10,%esp
  802c3a:	eb e5                	jmp    802c21 <open+0x6c>
		return -E_BAD_PATH;
  802c3c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802c41:	eb de                	jmp    802c21 <open+0x6c>

00802c43 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802c43:	55                   	push   %ebp
  802c44:	89 e5                	mov    %esp,%ebp
  802c46:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c49:	ba 00 00 00 00       	mov    $0x0,%edx
  802c4e:	b8 08 00 00 00       	mov    $0x8,%eax
  802c53:	e8 5a fd ff ff       	call   8029b2 <fsipc>
}
  802c58:	c9                   	leave  
  802c59:	c3                   	ret    

00802c5a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c5a:	55                   	push   %ebp
  802c5b:	89 e5                	mov    %esp,%ebp
  802c5d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802c60:	89 d0                	mov    %edx,%eax
  802c62:	c1 e8 16             	shr    $0x16,%eax
  802c65:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802c6c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802c71:	f6 c1 01             	test   $0x1,%cl
  802c74:	74 1d                	je     802c93 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802c76:	c1 ea 0c             	shr    $0xc,%edx
  802c79:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802c80:	f6 c2 01             	test   $0x1,%dl
  802c83:	74 0e                	je     802c93 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802c85:	c1 ea 0c             	shr    $0xc,%edx
  802c88:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802c8f:	ef 
  802c90:	0f b7 c0             	movzwl %ax,%eax
}
  802c93:	5d                   	pop    %ebp
  802c94:	c3                   	ret    

00802c95 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802c95:	55                   	push   %ebp
  802c96:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	05 00 00 00 30       	add    $0x30000000,%eax
  802ca0:	c1 e8 0c             	shr    $0xc,%eax
}
  802ca3:	5d                   	pop    %ebp
  802ca4:	c3                   	ret    

00802ca5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802ca5:	55                   	push   %ebp
  802ca6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802cb0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802cb5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802cba:	5d                   	pop    %ebp
  802cbb:	c3                   	ret    

00802cbc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802cbc:	55                   	push   %ebp
  802cbd:	89 e5                	mov    %esp,%ebp
  802cbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802cc2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802cc7:	89 c2                	mov    %eax,%edx
  802cc9:	c1 ea 16             	shr    $0x16,%edx
  802ccc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802cd3:	f6 c2 01             	test   $0x1,%dl
  802cd6:	74 2a                	je     802d02 <fd_alloc+0x46>
  802cd8:	89 c2                	mov    %eax,%edx
  802cda:	c1 ea 0c             	shr    $0xc,%edx
  802cdd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802ce4:	f6 c2 01             	test   $0x1,%dl
  802ce7:	74 19                	je     802d02 <fd_alloc+0x46>
  802ce9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802cee:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802cf3:	75 d2                	jne    802cc7 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802cf5:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  802cfb:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802d00:	eb 07                	jmp    802d09 <fd_alloc+0x4d>
			*fd_store = fd;
  802d02:	89 01                	mov    %eax,(%ecx)
			return 0;
  802d04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d09:	5d                   	pop    %ebp
  802d0a:	c3                   	ret    

00802d0b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802d0b:	55                   	push   %ebp
  802d0c:	89 e5                	mov    %esp,%ebp
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802d11:	83 f8 1f             	cmp    $0x1f,%eax
  802d14:	77 36                	ja     802d4c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802d16:	c1 e0 0c             	shl    $0xc,%eax
  802d19:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802d1e:	89 c2                	mov    %eax,%edx
  802d20:	c1 ea 16             	shr    $0x16,%edx
  802d23:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802d2a:	f6 c2 01             	test   $0x1,%dl
  802d2d:	74 24                	je     802d53 <fd_lookup+0x48>
  802d2f:	89 c2                	mov    %eax,%edx
  802d31:	c1 ea 0c             	shr    $0xc,%edx
  802d34:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802d3b:	f6 c2 01             	test   $0x1,%dl
  802d3e:	74 1a                	je     802d5a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d43:	89 02                	mov    %eax,(%edx)
	return 0;
  802d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d4a:	5d                   	pop    %ebp
  802d4b:	c3                   	ret    
		return -E_INVAL;
  802d4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d51:	eb f7                	jmp    802d4a <fd_lookup+0x3f>
		return -E_INVAL;
  802d53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d58:	eb f0                	jmp    802d4a <fd_lookup+0x3f>
  802d5a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d5f:	eb e9                	jmp    802d4a <fd_lookup+0x3f>

00802d61 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802d61:	55                   	push   %ebp
  802d62:	89 e5                	mov    %esp,%ebp
  802d64:	83 ec 08             	sub    $0x8,%esp
  802d67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d6a:	ba 3c 43 80 00       	mov    $0x80433c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  802d6f:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802d74:	39 08                	cmp    %ecx,(%eax)
  802d76:	74 33                	je     802dab <dev_lookup+0x4a>
  802d78:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  802d7b:	8b 02                	mov    (%edx),%eax
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	75 f3                	jne    802d74 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802d81:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802d86:	8b 40 48             	mov    0x48(%eax),%eax
  802d89:	83 ec 04             	sub    $0x4,%esp
  802d8c:	51                   	push   %ecx
  802d8d:	50                   	push   %eax
  802d8e:	68 bc 42 80 00       	push   $0x8042bc
  802d93:	e8 9e ee ff ff       	call   801c36 <cprintf>
	*dev = 0;
  802d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802da1:	83 c4 10             	add    $0x10,%esp
  802da4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802da9:	c9                   	leave  
  802daa:	c3                   	ret    
			*dev = devtab[i];
  802dab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802dae:	89 01                	mov    %eax,(%ecx)
			return 0;
  802db0:	b8 00 00 00 00       	mov    $0x0,%eax
  802db5:	eb f2                	jmp    802da9 <dev_lookup+0x48>

00802db7 <fd_close>:
{
  802db7:	55                   	push   %ebp
  802db8:	89 e5                	mov    %esp,%ebp
  802dba:	57                   	push   %edi
  802dbb:	56                   	push   %esi
  802dbc:	53                   	push   %ebx
  802dbd:	83 ec 1c             	sub    $0x1c,%esp
  802dc0:	8b 75 08             	mov    0x8(%ebp),%esi
  802dc3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802dc6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802dc9:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802dca:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802dd0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802dd3:	50                   	push   %eax
  802dd4:	e8 32 ff ff ff       	call   802d0b <fd_lookup>
  802dd9:	89 c3                	mov    %eax,%ebx
  802ddb:	83 c4 08             	add    $0x8,%esp
  802dde:	85 c0                	test   %eax,%eax
  802de0:	78 05                	js     802de7 <fd_close+0x30>
	    || fd != fd2)
  802de2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802de5:	74 16                	je     802dfd <fd_close+0x46>
		return (must_exist ? r : 0);
  802de7:	89 f8                	mov    %edi,%eax
  802de9:	84 c0                	test   %al,%al
  802deb:	b8 00 00 00 00       	mov    $0x0,%eax
  802df0:	0f 44 d8             	cmove  %eax,%ebx
}
  802df3:	89 d8                	mov    %ebx,%eax
  802df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802df8:	5b                   	pop    %ebx
  802df9:	5e                   	pop    %esi
  802dfa:	5f                   	pop    %edi
  802dfb:	5d                   	pop    %ebp
  802dfc:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802dfd:	83 ec 08             	sub    $0x8,%esp
  802e00:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802e03:	50                   	push   %eax
  802e04:	ff 36                	pushl  (%esi)
  802e06:	e8 56 ff ff ff       	call   802d61 <dev_lookup>
  802e0b:	89 c3                	mov    %eax,%ebx
  802e0d:	83 c4 10             	add    $0x10,%esp
  802e10:	85 c0                	test   %eax,%eax
  802e12:	78 15                	js     802e29 <fd_close+0x72>
		if (dev->dev_close)
  802e14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e17:	8b 40 10             	mov    0x10(%eax),%eax
  802e1a:	85 c0                	test   %eax,%eax
  802e1c:	74 1b                	je     802e39 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  802e1e:	83 ec 0c             	sub    $0xc,%esp
  802e21:	56                   	push   %esi
  802e22:	ff d0                	call   *%eax
  802e24:	89 c3                	mov    %eax,%ebx
  802e26:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802e29:	83 ec 08             	sub    $0x8,%esp
  802e2c:	56                   	push   %esi
  802e2d:	6a 00                	push   $0x0
  802e2f:	e8 9f f8 ff ff       	call   8026d3 <sys_page_unmap>
	return r;
  802e34:	83 c4 10             	add    $0x10,%esp
  802e37:	eb ba                	jmp    802df3 <fd_close+0x3c>
			r = 0;
  802e39:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e3e:	eb e9                	jmp    802e29 <fd_close+0x72>

00802e40 <close>:

int
close(int fdnum)
{
  802e40:	55                   	push   %ebp
  802e41:	89 e5                	mov    %esp,%ebp
  802e43:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e49:	50                   	push   %eax
  802e4a:	ff 75 08             	pushl  0x8(%ebp)
  802e4d:	e8 b9 fe ff ff       	call   802d0b <fd_lookup>
  802e52:	83 c4 08             	add    $0x8,%esp
  802e55:	85 c0                	test   %eax,%eax
  802e57:	78 10                	js     802e69 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  802e59:	83 ec 08             	sub    $0x8,%esp
  802e5c:	6a 01                	push   $0x1
  802e5e:	ff 75 f4             	pushl  -0xc(%ebp)
  802e61:	e8 51 ff ff ff       	call   802db7 <fd_close>
  802e66:	83 c4 10             	add    $0x10,%esp
}
  802e69:	c9                   	leave  
  802e6a:	c3                   	ret    

00802e6b <close_all>:

void
close_all(void)
{
  802e6b:	55                   	push   %ebp
  802e6c:	89 e5                	mov    %esp,%ebp
  802e6e:	53                   	push   %ebx
  802e6f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802e72:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802e77:	83 ec 0c             	sub    $0xc,%esp
  802e7a:	53                   	push   %ebx
  802e7b:	e8 c0 ff ff ff       	call   802e40 <close>
	for (i = 0; i < MAXFD; i++)
  802e80:	83 c3 01             	add    $0x1,%ebx
  802e83:	83 c4 10             	add    $0x10,%esp
  802e86:	83 fb 20             	cmp    $0x20,%ebx
  802e89:	75 ec                	jne    802e77 <close_all+0xc>
}
  802e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e8e:	c9                   	leave  
  802e8f:	c3                   	ret    

00802e90 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802e90:	55                   	push   %ebp
  802e91:	89 e5                	mov    %esp,%ebp
  802e93:	57                   	push   %edi
  802e94:	56                   	push   %esi
  802e95:	53                   	push   %ebx
  802e96:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802e99:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802e9c:	50                   	push   %eax
  802e9d:	ff 75 08             	pushl  0x8(%ebp)
  802ea0:	e8 66 fe ff ff       	call   802d0b <fd_lookup>
  802ea5:	89 c3                	mov    %eax,%ebx
  802ea7:	83 c4 08             	add    $0x8,%esp
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	0f 88 81 00 00 00    	js     802f33 <dup+0xa3>
		return r;
	close(newfdnum);
  802eb2:	83 ec 0c             	sub    $0xc,%esp
  802eb5:	ff 75 0c             	pushl  0xc(%ebp)
  802eb8:	e8 83 ff ff ff       	call   802e40 <close>

	newfd = INDEX2FD(newfdnum);
  802ebd:	8b 75 0c             	mov    0xc(%ebp),%esi
  802ec0:	c1 e6 0c             	shl    $0xc,%esi
  802ec3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802ec9:	83 c4 04             	add    $0x4,%esp
  802ecc:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ecf:	e8 d1 fd ff ff       	call   802ca5 <fd2data>
  802ed4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802ed6:	89 34 24             	mov    %esi,(%esp)
  802ed9:	e8 c7 fd ff ff       	call   802ca5 <fd2data>
  802ede:	83 c4 10             	add    $0x10,%esp
  802ee1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802ee3:	89 d8                	mov    %ebx,%eax
  802ee5:	c1 e8 16             	shr    $0x16,%eax
  802ee8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802eef:	a8 01                	test   $0x1,%al
  802ef1:	74 11                	je     802f04 <dup+0x74>
  802ef3:	89 d8                	mov    %ebx,%eax
  802ef5:	c1 e8 0c             	shr    $0xc,%eax
  802ef8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802eff:	f6 c2 01             	test   $0x1,%dl
  802f02:	75 39                	jne    802f3d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802f04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f07:	89 d0                	mov    %edx,%eax
  802f09:	c1 e8 0c             	shr    $0xc,%eax
  802f0c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802f13:	83 ec 0c             	sub    $0xc,%esp
  802f16:	25 07 0e 00 00       	and    $0xe07,%eax
  802f1b:	50                   	push   %eax
  802f1c:	56                   	push   %esi
  802f1d:	6a 00                	push   $0x0
  802f1f:	52                   	push   %edx
  802f20:	6a 00                	push   $0x0
  802f22:	e8 6a f7 ff ff       	call   802691 <sys_page_map>
  802f27:	89 c3                	mov    %eax,%ebx
  802f29:	83 c4 20             	add    $0x20,%esp
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	78 31                	js     802f61 <dup+0xd1>
		goto err;

	return newfdnum;
  802f30:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802f33:	89 d8                	mov    %ebx,%eax
  802f35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f38:	5b                   	pop    %ebx
  802f39:	5e                   	pop    %esi
  802f3a:	5f                   	pop    %edi
  802f3b:	5d                   	pop    %ebp
  802f3c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802f3d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802f44:	83 ec 0c             	sub    $0xc,%esp
  802f47:	25 07 0e 00 00       	and    $0xe07,%eax
  802f4c:	50                   	push   %eax
  802f4d:	57                   	push   %edi
  802f4e:	6a 00                	push   $0x0
  802f50:	53                   	push   %ebx
  802f51:	6a 00                	push   $0x0
  802f53:	e8 39 f7 ff ff       	call   802691 <sys_page_map>
  802f58:	89 c3                	mov    %eax,%ebx
  802f5a:	83 c4 20             	add    $0x20,%esp
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	79 a3                	jns    802f04 <dup+0x74>
	sys_page_unmap(0, newfd);
  802f61:	83 ec 08             	sub    $0x8,%esp
  802f64:	56                   	push   %esi
  802f65:	6a 00                	push   $0x0
  802f67:	e8 67 f7 ff ff       	call   8026d3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802f6c:	83 c4 08             	add    $0x8,%esp
  802f6f:	57                   	push   %edi
  802f70:	6a 00                	push   $0x0
  802f72:	e8 5c f7 ff ff       	call   8026d3 <sys_page_unmap>
	return r;
  802f77:	83 c4 10             	add    $0x10,%esp
  802f7a:	eb b7                	jmp    802f33 <dup+0xa3>

00802f7c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802f7c:	55                   	push   %ebp
  802f7d:	89 e5                	mov    %esp,%ebp
  802f7f:	53                   	push   %ebx
  802f80:	83 ec 14             	sub    $0x14,%esp
  802f83:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f89:	50                   	push   %eax
  802f8a:	53                   	push   %ebx
  802f8b:	e8 7b fd ff ff       	call   802d0b <fd_lookup>
  802f90:	83 c4 08             	add    $0x8,%esp
  802f93:	85 c0                	test   %eax,%eax
  802f95:	78 3f                	js     802fd6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f97:	83 ec 08             	sub    $0x8,%esp
  802f9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f9d:	50                   	push   %eax
  802f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa1:	ff 30                	pushl  (%eax)
  802fa3:	e8 b9 fd ff ff       	call   802d61 <dev_lookup>
  802fa8:	83 c4 10             	add    $0x10,%esp
  802fab:	85 c0                	test   %eax,%eax
  802fad:	78 27                	js     802fd6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802faf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fb2:	8b 42 08             	mov    0x8(%edx),%eax
  802fb5:	83 e0 03             	and    $0x3,%eax
  802fb8:	83 f8 01             	cmp    $0x1,%eax
  802fbb:	74 1e                	je     802fdb <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	8b 40 08             	mov    0x8(%eax),%eax
  802fc3:	85 c0                	test   %eax,%eax
  802fc5:	74 35                	je     802ffc <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802fc7:	83 ec 04             	sub    $0x4,%esp
  802fca:	ff 75 10             	pushl  0x10(%ebp)
  802fcd:	ff 75 0c             	pushl  0xc(%ebp)
  802fd0:	52                   	push   %edx
  802fd1:	ff d0                	call   *%eax
  802fd3:	83 c4 10             	add    $0x10,%esp
}
  802fd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fd9:	c9                   	leave  
  802fda:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802fdb:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802fe0:	8b 40 48             	mov    0x48(%eax),%eax
  802fe3:	83 ec 04             	sub    $0x4,%esp
  802fe6:	53                   	push   %ebx
  802fe7:	50                   	push   %eax
  802fe8:	68 00 43 80 00       	push   $0x804300
  802fed:	e8 44 ec ff ff       	call   801c36 <cprintf>
		return -E_INVAL;
  802ff2:	83 c4 10             	add    $0x10,%esp
  802ff5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ffa:	eb da                	jmp    802fd6 <read+0x5a>
		return -E_NOT_SUPP;
  802ffc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803001:	eb d3                	jmp    802fd6 <read+0x5a>

00803003 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803003:	55                   	push   %ebp
  803004:	89 e5                	mov    %esp,%ebp
  803006:	57                   	push   %edi
  803007:	56                   	push   %esi
  803008:	53                   	push   %ebx
  803009:	83 ec 0c             	sub    $0xc,%esp
  80300c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80300f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803012:	bb 00 00 00 00       	mov    $0x0,%ebx
  803017:	39 f3                	cmp    %esi,%ebx
  803019:	73 25                	jae    803040 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80301b:	83 ec 04             	sub    $0x4,%esp
  80301e:	89 f0                	mov    %esi,%eax
  803020:	29 d8                	sub    %ebx,%eax
  803022:	50                   	push   %eax
  803023:	89 d8                	mov    %ebx,%eax
  803025:	03 45 0c             	add    0xc(%ebp),%eax
  803028:	50                   	push   %eax
  803029:	57                   	push   %edi
  80302a:	e8 4d ff ff ff       	call   802f7c <read>
		if (m < 0)
  80302f:	83 c4 10             	add    $0x10,%esp
  803032:	85 c0                	test   %eax,%eax
  803034:	78 08                	js     80303e <readn+0x3b>
			return m;
		if (m == 0)
  803036:	85 c0                	test   %eax,%eax
  803038:	74 06                	je     803040 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80303a:	01 c3                	add    %eax,%ebx
  80303c:	eb d9                	jmp    803017 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80303e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  803040:	89 d8                	mov    %ebx,%eax
  803042:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803045:	5b                   	pop    %ebx
  803046:	5e                   	pop    %esi
  803047:	5f                   	pop    %edi
  803048:	5d                   	pop    %ebp
  803049:	c3                   	ret    

0080304a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80304a:	55                   	push   %ebp
  80304b:	89 e5                	mov    %esp,%ebp
  80304d:	53                   	push   %ebx
  80304e:	83 ec 14             	sub    $0x14,%esp
  803051:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803054:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803057:	50                   	push   %eax
  803058:	53                   	push   %ebx
  803059:	e8 ad fc ff ff       	call   802d0b <fd_lookup>
  80305e:	83 c4 08             	add    $0x8,%esp
  803061:	85 c0                	test   %eax,%eax
  803063:	78 3a                	js     80309f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803065:	83 ec 08             	sub    $0x8,%esp
  803068:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80306b:	50                   	push   %eax
  80306c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306f:	ff 30                	pushl  (%eax)
  803071:	e8 eb fc ff ff       	call   802d61 <dev_lookup>
  803076:	83 c4 10             	add    $0x10,%esp
  803079:	85 c0                	test   %eax,%eax
  80307b:	78 22                	js     80309f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80307d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803080:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  803084:	74 1e                	je     8030a4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803086:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803089:	8b 52 0c             	mov    0xc(%edx),%edx
  80308c:	85 d2                	test   %edx,%edx
  80308e:	74 35                	je     8030c5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  803090:	83 ec 04             	sub    $0x4,%esp
  803093:	ff 75 10             	pushl  0x10(%ebp)
  803096:	ff 75 0c             	pushl  0xc(%ebp)
  803099:	50                   	push   %eax
  80309a:	ff d2                	call   *%edx
  80309c:	83 c4 10             	add    $0x10,%esp
}
  80309f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030a2:	c9                   	leave  
  8030a3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8030a4:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8030a9:	8b 40 48             	mov    0x48(%eax),%eax
  8030ac:	83 ec 04             	sub    $0x4,%esp
  8030af:	53                   	push   %ebx
  8030b0:	50                   	push   %eax
  8030b1:	68 1c 43 80 00       	push   $0x80431c
  8030b6:	e8 7b eb ff ff       	call   801c36 <cprintf>
		return -E_INVAL;
  8030bb:	83 c4 10             	add    $0x10,%esp
  8030be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030c3:	eb da                	jmp    80309f <write+0x55>
		return -E_NOT_SUPP;
  8030c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8030ca:	eb d3                	jmp    80309f <write+0x55>

008030cc <seek>:

int
seek(int fdnum, off_t offset)
{
  8030cc:	55                   	push   %ebp
  8030cd:	89 e5                	mov    %esp,%ebp
  8030cf:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030d2:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8030d5:	50                   	push   %eax
  8030d6:	ff 75 08             	pushl  0x8(%ebp)
  8030d9:	e8 2d fc ff ff       	call   802d0b <fd_lookup>
  8030de:	83 c4 08             	add    $0x8,%esp
  8030e1:	85 c0                	test   %eax,%eax
  8030e3:	78 0e                	js     8030f3 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8030e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030eb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8030ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030f3:	c9                   	leave  
  8030f4:	c3                   	ret    

008030f5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8030f5:	55                   	push   %ebp
  8030f6:	89 e5                	mov    %esp,%ebp
  8030f8:	53                   	push   %ebx
  8030f9:	83 ec 14             	sub    $0x14,%esp
  8030fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803102:	50                   	push   %eax
  803103:	53                   	push   %ebx
  803104:	e8 02 fc ff ff       	call   802d0b <fd_lookup>
  803109:	83 c4 08             	add    $0x8,%esp
  80310c:	85 c0                	test   %eax,%eax
  80310e:	78 37                	js     803147 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803110:	83 ec 08             	sub    $0x8,%esp
  803113:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803116:	50                   	push   %eax
  803117:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311a:	ff 30                	pushl  (%eax)
  80311c:	e8 40 fc ff ff       	call   802d61 <dev_lookup>
  803121:	83 c4 10             	add    $0x10,%esp
  803124:	85 c0                	test   %eax,%eax
  803126:	78 1f                	js     803147 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80312f:	74 1b                	je     80314c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  803131:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803134:	8b 52 18             	mov    0x18(%edx),%edx
  803137:	85 d2                	test   %edx,%edx
  803139:	74 32                	je     80316d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80313b:	83 ec 08             	sub    $0x8,%esp
  80313e:	ff 75 0c             	pushl  0xc(%ebp)
  803141:	50                   	push   %eax
  803142:	ff d2                	call   *%edx
  803144:	83 c4 10             	add    $0x10,%esp
}
  803147:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80314a:	c9                   	leave  
  80314b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80314c:	a1 0c a0 80 00       	mov    0x80a00c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803151:	8b 40 48             	mov    0x48(%eax),%eax
  803154:	83 ec 04             	sub    $0x4,%esp
  803157:	53                   	push   %ebx
  803158:	50                   	push   %eax
  803159:	68 dc 42 80 00       	push   $0x8042dc
  80315e:	e8 d3 ea ff ff       	call   801c36 <cprintf>
		return -E_INVAL;
  803163:	83 c4 10             	add    $0x10,%esp
  803166:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80316b:	eb da                	jmp    803147 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80316d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803172:	eb d3                	jmp    803147 <ftruncate+0x52>

00803174 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803174:	55                   	push   %ebp
  803175:	89 e5                	mov    %esp,%ebp
  803177:	53                   	push   %ebx
  803178:	83 ec 14             	sub    $0x14,%esp
  80317b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80317e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803181:	50                   	push   %eax
  803182:	ff 75 08             	pushl  0x8(%ebp)
  803185:	e8 81 fb ff ff       	call   802d0b <fd_lookup>
  80318a:	83 c4 08             	add    $0x8,%esp
  80318d:	85 c0                	test   %eax,%eax
  80318f:	78 4b                	js     8031dc <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803191:	83 ec 08             	sub    $0x8,%esp
  803194:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803197:	50                   	push   %eax
  803198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319b:	ff 30                	pushl  (%eax)
  80319d:	e8 bf fb ff ff       	call   802d61 <dev_lookup>
  8031a2:	83 c4 10             	add    $0x10,%esp
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	78 33                	js     8031dc <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8031a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ac:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8031b0:	74 2f                	je     8031e1 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8031b2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8031b5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8031bc:	00 00 00 
	stat->st_isdir = 0;
  8031bf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8031c6:	00 00 00 
	stat->st_dev = dev;
  8031c9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8031cf:	83 ec 08             	sub    $0x8,%esp
  8031d2:	53                   	push   %ebx
  8031d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8031d6:	ff 50 14             	call   *0x14(%eax)
  8031d9:	83 c4 10             	add    $0x10,%esp
}
  8031dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031df:	c9                   	leave  
  8031e0:	c3                   	ret    
		return -E_NOT_SUPP;
  8031e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8031e6:	eb f4                	jmp    8031dc <fstat+0x68>

008031e8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8031e8:	55                   	push   %ebp
  8031e9:	89 e5                	mov    %esp,%ebp
  8031eb:	56                   	push   %esi
  8031ec:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8031ed:	83 ec 08             	sub    $0x8,%esp
  8031f0:	6a 00                	push   $0x0
  8031f2:	ff 75 08             	pushl  0x8(%ebp)
  8031f5:	e8 bb f9 ff ff       	call   802bb5 <open>
  8031fa:	89 c3                	mov    %eax,%ebx
  8031fc:	83 c4 10             	add    $0x10,%esp
  8031ff:	85 c0                	test   %eax,%eax
  803201:	78 1b                	js     80321e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  803203:	83 ec 08             	sub    $0x8,%esp
  803206:	ff 75 0c             	pushl  0xc(%ebp)
  803209:	50                   	push   %eax
  80320a:	e8 65 ff ff ff       	call   803174 <fstat>
  80320f:	89 c6                	mov    %eax,%esi
	close(fd);
  803211:	89 1c 24             	mov    %ebx,(%esp)
  803214:	e8 27 fc ff ff       	call   802e40 <close>
	return r;
  803219:	83 c4 10             	add    $0x10,%esp
  80321c:	89 f3                	mov    %esi,%ebx
}
  80321e:	89 d8                	mov    %ebx,%eax
  803220:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803223:	5b                   	pop    %ebx
  803224:	5e                   	pop    %esi
  803225:	5d                   	pop    %ebp
  803226:	c3                   	ret    

00803227 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803227:	55                   	push   %ebp
  803228:	89 e5                	mov    %esp,%ebp
  80322a:	56                   	push   %esi
  80322b:	53                   	push   %ebx
  80322c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80322f:	83 ec 0c             	sub    $0xc,%esp
  803232:	ff 75 08             	pushl  0x8(%ebp)
  803235:	e8 6b fa ff ff       	call   802ca5 <fd2data>
  80323a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80323c:	83 c4 08             	add    $0x8,%esp
  80323f:	68 4c 43 80 00       	push   $0x80434c
  803244:	53                   	push   %ebx
  803245:	e8 0b f0 ff ff       	call   802255 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80324a:	8b 46 04             	mov    0x4(%esi),%eax
  80324d:	2b 06                	sub    (%esi),%eax
  80324f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803255:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80325c:	00 00 00 
	stat->st_dev = &devpipe;
  80325f:	c7 83 88 00 00 00 80 	movl   $0x809080,0x88(%ebx)
  803266:	90 80 00 
	return 0;
}
  803269:	b8 00 00 00 00       	mov    $0x0,%eax
  80326e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803271:	5b                   	pop    %ebx
  803272:	5e                   	pop    %esi
  803273:	5d                   	pop    %ebp
  803274:	c3                   	ret    

00803275 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803275:	55                   	push   %ebp
  803276:	89 e5                	mov    %esp,%ebp
  803278:	53                   	push   %ebx
  803279:	83 ec 0c             	sub    $0xc,%esp
  80327c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80327f:	53                   	push   %ebx
  803280:	6a 00                	push   $0x0
  803282:	e8 4c f4 ff ff       	call   8026d3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803287:	89 1c 24             	mov    %ebx,(%esp)
  80328a:	e8 16 fa ff ff       	call   802ca5 <fd2data>
  80328f:	83 c4 08             	add    $0x8,%esp
  803292:	50                   	push   %eax
  803293:	6a 00                	push   $0x0
  803295:	e8 39 f4 ff ff       	call   8026d3 <sys_page_unmap>
}
  80329a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80329d:	c9                   	leave  
  80329e:	c3                   	ret    

0080329f <_pipeisclosed>:
{
  80329f:	55                   	push   %ebp
  8032a0:	89 e5                	mov    %esp,%ebp
  8032a2:	57                   	push   %edi
  8032a3:	56                   	push   %esi
  8032a4:	53                   	push   %ebx
  8032a5:	83 ec 1c             	sub    $0x1c,%esp
  8032a8:	89 c7                	mov    %eax,%edi
  8032aa:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8032ac:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8032b1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8032b4:	83 ec 0c             	sub    $0xc,%esp
  8032b7:	57                   	push   %edi
  8032b8:	e8 9d f9 ff ff       	call   802c5a <pageref>
  8032bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8032c0:	89 34 24             	mov    %esi,(%esp)
  8032c3:	e8 92 f9 ff ff       	call   802c5a <pageref>
		nn = thisenv->env_runs;
  8032c8:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8032ce:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8032d1:	83 c4 10             	add    $0x10,%esp
  8032d4:	39 cb                	cmp    %ecx,%ebx
  8032d6:	74 1b                	je     8032f3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8032d8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8032db:	75 cf                	jne    8032ac <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8032dd:	8b 42 58             	mov    0x58(%edx),%eax
  8032e0:	6a 01                	push   $0x1
  8032e2:	50                   	push   %eax
  8032e3:	53                   	push   %ebx
  8032e4:	68 53 43 80 00       	push   $0x804353
  8032e9:	e8 48 e9 ff ff       	call   801c36 <cprintf>
  8032ee:	83 c4 10             	add    $0x10,%esp
  8032f1:	eb b9                	jmp    8032ac <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8032f3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8032f6:	0f 94 c0             	sete   %al
  8032f9:	0f b6 c0             	movzbl %al,%eax
}
  8032fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8032ff:	5b                   	pop    %ebx
  803300:	5e                   	pop    %esi
  803301:	5f                   	pop    %edi
  803302:	5d                   	pop    %ebp
  803303:	c3                   	ret    

00803304 <devpipe_write>:
{
  803304:	55                   	push   %ebp
  803305:	89 e5                	mov    %esp,%ebp
  803307:	57                   	push   %edi
  803308:	56                   	push   %esi
  803309:	53                   	push   %ebx
  80330a:	83 ec 28             	sub    $0x28,%esp
  80330d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803310:	56                   	push   %esi
  803311:	e8 8f f9 ff ff       	call   802ca5 <fd2data>
  803316:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803318:	83 c4 10             	add    $0x10,%esp
  80331b:	bf 00 00 00 00       	mov    $0x0,%edi
  803320:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803323:	74 4f                	je     803374 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803325:	8b 43 04             	mov    0x4(%ebx),%eax
  803328:	8b 0b                	mov    (%ebx),%ecx
  80332a:	8d 51 20             	lea    0x20(%ecx),%edx
  80332d:	39 d0                	cmp    %edx,%eax
  80332f:	72 14                	jb     803345 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  803331:	89 da                	mov    %ebx,%edx
  803333:	89 f0                	mov    %esi,%eax
  803335:	e8 65 ff ff ff       	call   80329f <_pipeisclosed>
  80333a:	85 c0                	test   %eax,%eax
  80333c:	75 3a                	jne    803378 <devpipe_write+0x74>
			sys_yield();
  80333e:	e8 ec f2 ff ff       	call   80262f <sys_yield>
  803343:	eb e0                	jmp    803325 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803345:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803348:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80334c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80334f:	89 c2                	mov    %eax,%edx
  803351:	c1 fa 1f             	sar    $0x1f,%edx
  803354:	89 d1                	mov    %edx,%ecx
  803356:	c1 e9 1b             	shr    $0x1b,%ecx
  803359:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80335c:	83 e2 1f             	and    $0x1f,%edx
  80335f:	29 ca                	sub    %ecx,%edx
  803361:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  803365:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803369:	83 c0 01             	add    $0x1,%eax
  80336c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80336f:	83 c7 01             	add    $0x1,%edi
  803372:	eb ac                	jmp    803320 <devpipe_write+0x1c>
	return i;
  803374:	89 f8                	mov    %edi,%eax
  803376:	eb 05                	jmp    80337d <devpipe_write+0x79>
				return 0;
  803378:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80337d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803380:	5b                   	pop    %ebx
  803381:	5e                   	pop    %esi
  803382:	5f                   	pop    %edi
  803383:	5d                   	pop    %ebp
  803384:	c3                   	ret    

00803385 <devpipe_read>:
{
  803385:	55                   	push   %ebp
  803386:	89 e5                	mov    %esp,%ebp
  803388:	57                   	push   %edi
  803389:	56                   	push   %esi
  80338a:	53                   	push   %ebx
  80338b:	83 ec 18             	sub    $0x18,%esp
  80338e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  803391:	57                   	push   %edi
  803392:	e8 0e f9 ff ff       	call   802ca5 <fd2data>
  803397:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803399:	83 c4 10             	add    $0x10,%esp
  80339c:	be 00 00 00 00       	mov    $0x0,%esi
  8033a1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8033a4:	74 47                	je     8033ed <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8033a6:	8b 03                	mov    (%ebx),%eax
  8033a8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8033ab:	75 22                	jne    8033cf <devpipe_read+0x4a>
			if (i > 0)
  8033ad:	85 f6                	test   %esi,%esi
  8033af:	75 14                	jne    8033c5 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8033b1:	89 da                	mov    %ebx,%edx
  8033b3:	89 f8                	mov    %edi,%eax
  8033b5:	e8 e5 fe ff ff       	call   80329f <_pipeisclosed>
  8033ba:	85 c0                	test   %eax,%eax
  8033bc:	75 33                	jne    8033f1 <devpipe_read+0x6c>
			sys_yield();
  8033be:	e8 6c f2 ff ff       	call   80262f <sys_yield>
  8033c3:	eb e1                	jmp    8033a6 <devpipe_read+0x21>
				return i;
  8033c5:	89 f0                	mov    %esi,%eax
}
  8033c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8033ca:	5b                   	pop    %ebx
  8033cb:	5e                   	pop    %esi
  8033cc:	5f                   	pop    %edi
  8033cd:	5d                   	pop    %ebp
  8033ce:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8033cf:	99                   	cltd   
  8033d0:	c1 ea 1b             	shr    $0x1b,%edx
  8033d3:	01 d0                	add    %edx,%eax
  8033d5:	83 e0 1f             	and    $0x1f,%eax
  8033d8:	29 d0                	sub    %edx,%eax
  8033da:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8033df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8033e2:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8033e5:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8033e8:	83 c6 01             	add    $0x1,%esi
  8033eb:	eb b4                	jmp    8033a1 <devpipe_read+0x1c>
	return i;
  8033ed:	89 f0                	mov    %esi,%eax
  8033ef:	eb d6                	jmp    8033c7 <devpipe_read+0x42>
				return 0;
  8033f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f6:	eb cf                	jmp    8033c7 <devpipe_read+0x42>

008033f8 <pipe>:
{
  8033f8:	55                   	push   %ebp
  8033f9:	89 e5                	mov    %esp,%ebp
  8033fb:	56                   	push   %esi
  8033fc:	53                   	push   %ebx
  8033fd:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  803400:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803403:	50                   	push   %eax
  803404:	e8 b3 f8 ff ff       	call   802cbc <fd_alloc>
  803409:	89 c3                	mov    %eax,%ebx
  80340b:	83 c4 10             	add    $0x10,%esp
  80340e:	85 c0                	test   %eax,%eax
  803410:	78 5b                	js     80346d <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803412:	83 ec 04             	sub    $0x4,%esp
  803415:	68 07 04 00 00       	push   $0x407
  80341a:	ff 75 f4             	pushl  -0xc(%ebp)
  80341d:	6a 00                	push   $0x0
  80341f:	e8 2a f2 ff ff       	call   80264e <sys_page_alloc>
  803424:	89 c3                	mov    %eax,%ebx
  803426:	83 c4 10             	add    $0x10,%esp
  803429:	85 c0                	test   %eax,%eax
  80342b:	78 40                	js     80346d <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80342d:	83 ec 0c             	sub    $0xc,%esp
  803430:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803433:	50                   	push   %eax
  803434:	e8 83 f8 ff ff       	call   802cbc <fd_alloc>
  803439:	89 c3                	mov    %eax,%ebx
  80343b:	83 c4 10             	add    $0x10,%esp
  80343e:	85 c0                	test   %eax,%eax
  803440:	78 1b                	js     80345d <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803442:	83 ec 04             	sub    $0x4,%esp
  803445:	68 07 04 00 00       	push   $0x407
  80344a:	ff 75 f0             	pushl  -0x10(%ebp)
  80344d:	6a 00                	push   $0x0
  80344f:	e8 fa f1 ff ff       	call   80264e <sys_page_alloc>
  803454:	89 c3                	mov    %eax,%ebx
  803456:	83 c4 10             	add    $0x10,%esp
  803459:	85 c0                	test   %eax,%eax
  80345b:	79 19                	jns    803476 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80345d:	83 ec 08             	sub    $0x8,%esp
  803460:	ff 75 f4             	pushl  -0xc(%ebp)
  803463:	6a 00                	push   $0x0
  803465:	e8 69 f2 ff ff       	call   8026d3 <sys_page_unmap>
  80346a:	83 c4 10             	add    $0x10,%esp
}
  80346d:	89 d8                	mov    %ebx,%eax
  80346f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803472:	5b                   	pop    %ebx
  803473:	5e                   	pop    %esi
  803474:	5d                   	pop    %ebp
  803475:	c3                   	ret    
	va = fd2data(fd0);
  803476:	83 ec 0c             	sub    $0xc,%esp
  803479:	ff 75 f4             	pushl  -0xc(%ebp)
  80347c:	e8 24 f8 ff ff       	call   802ca5 <fd2data>
  803481:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803483:	83 c4 0c             	add    $0xc,%esp
  803486:	68 07 04 00 00       	push   $0x407
  80348b:	50                   	push   %eax
  80348c:	6a 00                	push   $0x0
  80348e:	e8 bb f1 ff ff       	call   80264e <sys_page_alloc>
  803493:	89 c3                	mov    %eax,%ebx
  803495:	83 c4 10             	add    $0x10,%esp
  803498:	85 c0                	test   %eax,%eax
  80349a:	0f 88 8c 00 00 00    	js     80352c <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034a0:	83 ec 0c             	sub    $0xc,%esp
  8034a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8034a6:	e8 fa f7 ff ff       	call   802ca5 <fd2data>
  8034ab:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8034b2:	50                   	push   %eax
  8034b3:	6a 00                	push   $0x0
  8034b5:	56                   	push   %esi
  8034b6:	6a 00                	push   $0x0
  8034b8:	e8 d4 f1 ff ff       	call   802691 <sys_page_map>
  8034bd:	89 c3                	mov    %eax,%ebx
  8034bf:	83 c4 20             	add    $0x20,%esp
  8034c2:	85 c0                	test   %eax,%eax
  8034c4:	78 58                	js     80351e <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8034c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c9:	8b 15 80 90 80 00    	mov    0x809080,%edx
  8034cf:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8034d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8034db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034de:	8b 15 80 90 80 00    	mov    0x809080,%edx
  8034e4:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8034e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8034f0:	83 ec 0c             	sub    $0xc,%esp
  8034f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8034f6:	e8 9a f7 ff ff       	call   802c95 <fd2num>
  8034fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8034fe:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803500:	83 c4 04             	add    $0x4,%esp
  803503:	ff 75 f0             	pushl  -0x10(%ebp)
  803506:	e8 8a f7 ff ff       	call   802c95 <fd2num>
  80350b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80350e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803511:	83 c4 10             	add    $0x10,%esp
  803514:	bb 00 00 00 00       	mov    $0x0,%ebx
  803519:	e9 4f ff ff ff       	jmp    80346d <pipe+0x75>
	sys_page_unmap(0, va);
  80351e:	83 ec 08             	sub    $0x8,%esp
  803521:	56                   	push   %esi
  803522:	6a 00                	push   $0x0
  803524:	e8 aa f1 ff ff       	call   8026d3 <sys_page_unmap>
  803529:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80352c:	83 ec 08             	sub    $0x8,%esp
  80352f:	ff 75 f0             	pushl  -0x10(%ebp)
  803532:	6a 00                	push   $0x0
  803534:	e8 9a f1 ff ff       	call   8026d3 <sys_page_unmap>
  803539:	83 c4 10             	add    $0x10,%esp
  80353c:	e9 1c ff ff ff       	jmp    80345d <pipe+0x65>

00803541 <pipeisclosed>:
{
  803541:	55                   	push   %ebp
  803542:	89 e5                	mov    %esp,%ebp
  803544:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803547:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80354a:	50                   	push   %eax
  80354b:	ff 75 08             	pushl  0x8(%ebp)
  80354e:	e8 b8 f7 ff ff       	call   802d0b <fd_lookup>
  803553:	83 c4 10             	add    $0x10,%esp
  803556:	85 c0                	test   %eax,%eax
  803558:	78 18                	js     803572 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80355a:	83 ec 0c             	sub    $0xc,%esp
  80355d:	ff 75 f4             	pushl  -0xc(%ebp)
  803560:	e8 40 f7 ff ff       	call   802ca5 <fd2data>
	return _pipeisclosed(fd, p);
  803565:	89 c2                	mov    %eax,%edx
  803567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356a:	e8 30 fd ff ff       	call   80329f <_pipeisclosed>
  80356f:	83 c4 10             	add    $0x10,%esp
}
  803572:	c9                   	leave  
  803573:	c3                   	ret    

00803574 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803574:	55                   	push   %ebp
  803575:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803577:	b8 00 00 00 00       	mov    $0x0,%eax
  80357c:	5d                   	pop    %ebp
  80357d:	c3                   	ret    

0080357e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80357e:	55                   	push   %ebp
  80357f:	89 e5                	mov    %esp,%ebp
  803581:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  803584:	68 6b 43 80 00       	push   $0x80436b
  803589:	ff 75 0c             	pushl  0xc(%ebp)
  80358c:	e8 c4 ec ff ff       	call   802255 <strcpy>
	return 0;
}
  803591:	b8 00 00 00 00       	mov    $0x0,%eax
  803596:	c9                   	leave  
  803597:	c3                   	ret    

00803598 <devcons_write>:
{
  803598:	55                   	push   %ebp
  803599:	89 e5                	mov    %esp,%ebp
  80359b:	57                   	push   %edi
  80359c:	56                   	push   %esi
  80359d:	53                   	push   %ebx
  80359e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8035a4:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8035a9:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8035af:	eb 2f                	jmp    8035e0 <devcons_write+0x48>
		m = n - tot;
  8035b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8035b4:	29 f3                	sub    %esi,%ebx
  8035b6:	83 fb 7f             	cmp    $0x7f,%ebx
  8035b9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8035be:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8035c1:	83 ec 04             	sub    $0x4,%esp
  8035c4:	53                   	push   %ebx
  8035c5:	89 f0                	mov    %esi,%eax
  8035c7:	03 45 0c             	add    0xc(%ebp),%eax
  8035ca:	50                   	push   %eax
  8035cb:	57                   	push   %edi
  8035cc:	e8 12 ee ff ff       	call   8023e3 <memmove>
		sys_cputs(buf, m);
  8035d1:	83 c4 08             	add    $0x8,%esp
  8035d4:	53                   	push   %ebx
  8035d5:	57                   	push   %edi
  8035d6:	e8 b7 ef ff ff       	call   802592 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8035db:	01 de                	add    %ebx,%esi
  8035dd:	83 c4 10             	add    $0x10,%esp
  8035e0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8035e3:	72 cc                	jb     8035b1 <devcons_write+0x19>
}
  8035e5:	89 f0                	mov    %esi,%eax
  8035e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8035ea:	5b                   	pop    %ebx
  8035eb:	5e                   	pop    %esi
  8035ec:	5f                   	pop    %edi
  8035ed:	5d                   	pop    %ebp
  8035ee:	c3                   	ret    

008035ef <devcons_read>:
{
  8035ef:	55                   	push   %ebp
  8035f0:	89 e5                	mov    %esp,%ebp
  8035f2:	83 ec 08             	sub    $0x8,%esp
  8035f5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8035fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8035fe:	75 07                	jne    803607 <devcons_read+0x18>
}
  803600:	c9                   	leave  
  803601:	c3                   	ret    
		sys_yield();
  803602:	e8 28 f0 ff ff       	call   80262f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  803607:	e8 a4 ef ff ff       	call   8025b0 <sys_cgetc>
  80360c:	85 c0                	test   %eax,%eax
  80360e:	74 f2                	je     803602 <devcons_read+0x13>
	if (c < 0)
  803610:	85 c0                	test   %eax,%eax
  803612:	78 ec                	js     803600 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  803614:	83 f8 04             	cmp    $0x4,%eax
  803617:	74 0c                	je     803625 <devcons_read+0x36>
	*(char*)vbuf = c;
  803619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80361c:	88 02                	mov    %al,(%edx)
	return 1;
  80361e:	b8 01 00 00 00       	mov    $0x1,%eax
  803623:	eb db                	jmp    803600 <devcons_read+0x11>
		return 0;
  803625:	b8 00 00 00 00       	mov    $0x0,%eax
  80362a:	eb d4                	jmp    803600 <devcons_read+0x11>

0080362c <cputchar>:
{
  80362c:	55                   	push   %ebp
  80362d:	89 e5                	mov    %esp,%ebp
  80362f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  803632:	8b 45 08             	mov    0x8(%ebp),%eax
  803635:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  803638:	6a 01                	push   $0x1
  80363a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80363d:	50                   	push   %eax
  80363e:	e8 4f ef ff ff       	call   802592 <sys_cputs>
}
  803643:	83 c4 10             	add    $0x10,%esp
  803646:	c9                   	leave  
  803647:	c3                   	ret    

00803648 <getchar>:
{
  803648:	55                   	push   %ebp
  803649:	89 e5                	mov    %esp,%ebp
  80364b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80364e:	6a 01                	push   $0x1
  803650:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803653:	50                   	push   %eax
  803654:	6a 00                	push   $0x0
  803656:	e8 21 f9 ff ff       	call   802f7c <read>
	if (r < 0)
  80365b:	83 c4 10             	add    $0x10,%esp
  80365e:	85 c0                	test   %eax,%eax
  803660:	78 08                	js     80366a <getchar+0x22>
	if (r < 1)
  803662:	85 c0                	test   %eax,%eax
  803664:	7e 06                	jle    80366c <getchar+0x24>
	return c;
  803666:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80366a:	c9                   	leave  
  80366b:	c3                   	ret    
		return -E_EOF;
  80366c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  803671:	eb f7                	jmp    80366a <getchar+0x22>

00803673 <iscons>:
{
  803673:	55                   	push   %ebp
  803674:	89 e5                	mov    %esp,%ebp
  803676:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803679:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80367c:	50                   	push   %eax
  80367d:	ff 75 08             	pushl  0x8(%ebp)
  803680:	e8 86 f6 ff ff       	call   802d0b <fd_lookup>
  803685:	83 c4 10             	add    $0x10,%esp
  803688:	85 c0                	test   %eax,%eax
  80368a:	78 11                	js     80369d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80368c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368f:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803695:	39 10                	cmp    %edx,(%eax)
  803697:	0f 94 c0             	sete   %al
  80369a:	0f b6 c0             	movzbl %al,%eax
}
  80369d:	c9                   	leave  
  80369e:	c3                   	ret    

0080369f <opencons>:
{
  80369f:	55                   	push   %ebp
  8036a0:	89 e5                	mov    %esp,%ebp
  8036a2:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8036a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8036a8:	50                   	push   %eax
  8036a9:	e8 0e f6 ff ff       	call   802cbc <fd_alloc>
  8036ae:	83 c4 10             	add    $0x10,%esp
  8036b1:	85 c0                	test   %eax,%eax
  8036b3:	78 3a                	js     8036ef <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8036b5:	83 ec 04             	sub    $0x4,%esp
  8036b8:	68 07 04 00 00       	push   $0x407
  8036bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8036c0:	6a 00                	push   $0x0
  8036c2:	e8 87 ef ff ff       	call   80264e <sys_page_alloc>
  8036c7:	83 c4 10             	add    $0x10,%esp
  8036ca:	85 c0                	test   %eax,%eax
  8036cc:	78 21                	js     8036ef <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8036ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d1:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  8036d7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8036d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036dc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8036e3:	83 ec 0c             	sub    $0xc,%esp
  8036e6:	50                   	push   %eax
  8036e7:	e8 a9 f5 ff ff       	call   802c95 <fd2num>
  8036ec:	83 c4 10             	add    $0x10,%esp
}
  8036ef:	c9                   	leave  
  8036f0:	c3                   	ret    
  8036f1:	66 90                	xchg   %ax,%ax
  8036f3:	66 90                	xchg   %ax,%ax
  8036f5:	66 90                	xchg   %ax,%ax
  8036f7:	66 90                	xchg   %ax,%ax
  8036f9:	66 90                	xchg   %ax,%ax
  8036fb:	66 90                	xchg   %ax,%ax
  8036fd:	66 90                	xchg   %ax,%ax
  8036ff:	90                   	nop

00803700 <__udivdi3>:
  803700:	55                   	push   %ebp
  803701:	57                   	push   %edi
  803702:	56                   	push   %esi
  803703:	53                   	push   %ebx
  803704:	83 ec 1c             	sub    $0x1c,%esp
  803707:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80370b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80370f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803713:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803717:	85 d2                	test   %edx,%edx
  803719:	75 35                	jne    803750 <__udivdi3+0x50>
  80371b:	39 f3                	cmp    %esi,%ebx
  80371d:	0f 87 bd 00 00 00    	ja     8037e0 <__udivdi3+0xe0>
  803723:	85 db                	test   %ebx,%ebx
  803725:	89 d9                	mov    %ebx,%ecx
  803727:	75 0b                	jne    803734 <__udivdi3+0x34>
  803729:	b8 01 00 00 00       	mov    $0x1,%eax
  80372e:	31 d2                	xor    %edx,%edx
  803730:	f7 f3                	div    %ebx
  803732:	89 c1                	mov    %eax,%ecx
  803734:	31 d2                	xor    %edx,%edx
  803736:	89 f0                	mov    %esi,%eax
  803738:	f7 f1                	div    %ecx
  80373a:	89 c6                	mov    %eax,%esi
  80373c:	89 e8                	mov    %ebp,%eax
  80373e:	89 f7                	mov    %esi,%edi
  803740:	f7 f1                	div    %ecx
  803742:	89 fa                	mov    %edi,%edx
  803744:	83 c4 1c             	add    $0x1c,%esp
  803747:	5b                   	pop    %ebx
  803748:	5e                   	pop    %esi
  803749:	5f                   	pop    %edi
  80374a:	5d                   	pop    %ebp
  80374b:	c3                   	ret    
  80374c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803750:	39 f2                	cmp    %esi,%edx
  803752:	77 7c                	ja     8037d0 <__udivdi3+0xd0>
  803754:	0f bd fa             	bsr    %edx,%edi
  803757:	83 f7 1f             	xor    $0x1f,%edi
  80375a:	0f 84 98 00 00 00    	je     8037f8 <__udivdi3+0xf8>
  803760:	89 f9                	mov    %edi,%ecx
  803762:	b8 20 00 00 00       	mov    $0x20,%eax
  803767:	29 f8                	sub    %edi,%eax
  803769:	d3 e2                	shl    %cl,%edx
  80376b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80376f:	89 c1                	mov    %eax,%ecx
  803771:	89 da                	mov    %ebx,%edx
  803773:	d3 ea                	shr    %cl,%edx
  803775:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803779:	09 d1                	or     %edx,%ecx
  80377b:	89 f2                	mov    %esi,%edx
  80377d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803781:	89 f9                	mov    %edi,%ecx
  803783:	d3 e3                	shl    %cl,%ebx
  803785:	89 c1                	mov    %eax,%ecx
  803787:	d3 ea                	shr    %cl,%edx
  803789:	89 f9                	mov    %edi,%ecx
  80378b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80378f:	d3 e6                	shl    %cl,%esi
  803791:	89 eb                	mov    %ebp,%ebx
  803793:	89 c1                	mov    %eax,%ecx
  803795:	d3 eb                	shr    %cl,%ebx
  803797:	09 de                	or     %ebx,%esi
  803799:	89 f0                	mov    %esi,%eax
  80379b:	f7 74 24 08          	divl   0x8(%esp)
  80379f:	89 d6                	mov    %edx,%esi
  8037a1:	89 c3                	mov    %eax,%ebx
  8037a3:	f7 64 24 0c          	mull   0xc(%esp)
  8037a7:	39 d6                	cmp    %edx,%esi
  8037a9:	72 0c                	jb     8037b7 <__udivdi3+0xb7>
  8037ab:	89 f9                	mov    %edi,%ecx
  8037ad:	d3 e5                	shl    %cl,%ebp
  8037af:	39 c5                	cmp    %eax,%ebp
  8037b1:	73 5d                	jae    803810 <__udivdi3+0x110>
  8037b3:	39 d6                	cmp    %edx,%esi
  8037b5:	75 59                	jne    803810 <__udivdi3+0x110>
  8037b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037ba:	31 ff                	xor    %edi,%edi
  8037bc:	89 fa                	mov    %edi,%edx
  8037be:	83 c4 1c             	add    $0x1c,%esp
  8037c1:	5b                   	pop    %ebx
  8037c2:	5e                   	pop    %esi
  8037c3:	5f                   	pop    %edi
  8037c4:	5d                   	pop    %ebp
  8037c5:	c3                   	ret    
  8037c6:	8d 76 00             	lea    0x0(%esi),%esi
  8037c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8037d0:	31 ff                	xor    %edi,%edi
  8037d2:	31 c0                	xor    %eax,%eax
  8037d4:	89 fa                	mov    %edi,%edx
  8037d6:	83 c4 1c             	add    $0x1c,%esp
  8037d9:	5b                   	pop    %ebx
  8037da:	5e                   	pop    %esi
  8037db:	5f                   	pop    %edi
  8037dc:	5d                   	pop    %ebp
  8037dd:	c3                   	ret    
  8037de:	66 90                	xchg   %ax,%ax
  8037e0:	31 ff                	xor    %edi,%edi
  8037e2:	89 e8                	mov    %ebp,%eax
  8037e4:	89 f2                	mov    %esi,%edx
  8037e6:	f7 f3                	div    %ebx
  8037e8:	89 fa                	mov    %edi,%edx
  8037ea:	83 c4 1c             	add    $0x1c,%esp
  8037ed:	5b                   	pop    %ebx
  8037ee:	5e                   	pop    %esi
  8037ef:	5f                   	pop    %edi
  8037f0:	5d                   	pop    %ebp
  8037f1:	c3                   	ret    
  8037f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8037f8:	39 f2                	cmp    %esi,%edx
  8037fa:	72 06                	jb     803802 <__udivdi3+0x102>
  8037fc:	31 c0                	xor    %eax,%eax
  8037fe:	39 eb                	cmp    %ebp,%ebx
  803800:	77 d2                	ja     8037d4 <__udivdi3+0xd4>
  803802:	b8 01 00 00 00       	mov    $0x1,%eax
  803807:	eb cb                	jmp    8037d4 <__udivdi3+0xd4>
  803809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803810:	89 d8                	mov    %ebx,%eax
  803812:	31 ff                	xor    %edi,%edi
  803814:	eb be                	jmp    8037d4 <__udivdi3+0xd4>
  803816:	66 90                	xchg   %ax,%ax
  803818:	66 90                	xchg   %ax,%ax
  80381a:	66 90                	xchg   %ax,%ax
  80381c:	66 90                	xchg   %ax,%ax
  80381e:	66 90                	xchg   %ax,%ax

00803820 <__umoddi3>:
  803820:	55                   	push   %ebp
  803821:	57                   	push   %edi
  803822:	56                   	push   %esi
  803823:	53                   	push   %ebx
  803824:	83 ec 1c             	sub    $0x1c,%esp
  803827:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80382b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80382f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803833:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803837:	85 ed                	test   %ebp,%ebp
  803839:	89 f0                	mov    %esi,%eax
  80383b:	89 da                	mov    %ebx,%edx
  80383d:	75 19                	jne    803858 <__umoddi3+0x38>
  80383f:	39 df                	cmp    %ebx,%edi
  803841:	0f 86 b1 00 00 00    	jbe    8038f8 <__umoddi3+0xd8>
  803847:	f7 f7                	div    %edi
  803849:	89 d0                	mov    %edx,%eax
  80384b:	31 d2                	xor    %edx,%edx
  80384d:	83 c4 1c             	add    $0x1c,%esp
  803850:	5b                   	pop    %ebx
  803851:	5e                   	pop    %esi
  803852:	5f                   	pop    %edi
  803853:	5d                   	pop    %ebp
  803854:	c3                   	ret    
  803855:	8d 76 00             	lea    0x0(%esi),%esi
  803858:	39 dd                	cmp    %ebx,%ebp
  80385a:	77 f1                	ja     80384d <__umoddi3+0x2d>
  80385c:	0f bd cd             	bsr    %ebp,%ecx
  80385f:	83 f1 1f             	xor    $0x1f,%ecx
  803862:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803866:	0f 84 b4 00 00 00    	je     803920 <__umoddi3+0x100>
  80386c:	b8 20 00 00 00       	mov    $0x20,%eax
  803871:	89 c2                	mov    %eax,%edx
  803873:	8b 44 24 04          	mov    0x4(%esp),%eax
  803877:	29 c2                	sub    %eax,%edx
  803879:	89 c1                	mov    %eax,%ecx
  80387b:	89 f8                	mov    %edi,%eax
  80387d:	d3 e5                	shl    %cl,%ebp
  80387f:	89 d1                	mov    %edx,%ecx
  803881:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803885:	d3 e8                	shr    %cl,%eax
  803887:	09 c5                	or     %eax,%ebp
  803889:	8b 44 24 04          	mov    0x4(%esp),%eax
  80388d:	89 c1                	mov    %eax,%ecx
  80388f:	d3 e7                	shl    %cl,%edi
  803891:	89 d1                	mov    %edx,%ecx
  803893:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803897:	89 df                	mov    %ebx,%edi
  803899:	d3 ef                	shr    %cl,%edi
  80389b:	89 c1                	mov    %eax,%ecx
  80389d:	89 f0                	mov    %esi,%eax
  80389f:	d3 e3                	shl    %cl,%ebx
  8038a1:	89 d1                	mov    %edx,%ecx
  8038a3:	89 fa                	mov    %edi,%edx
  8038a5:	d3 e8                	shr    %cl,%eax
  8038a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8038ac:	09 d8                	or     %ebx,%eax
  8038ae:	f7 f5                	div    %ebp
  8038b0:	d3 e6                	shl    %cl,%esi
  8038b2:	89 d1                	mov    %edx,%ecx
  8038b4:	f7 64 24 08          	mull   0x8(%esp)
  8038b8:	39 d1                	cmp    %edx,%ecx
  8038ba:	89 c3                	mov    %eax,%ebx
  8038bc:	89 d7                	mov    %edx,%edi
  8038be:	72 06                	jb     8038c6 <__umoddi3+0xa6>
  8038c0:	75 0e                	jne    8038d0 <__umoddi3+0xb0>
  8038c2:	39 c6                	cmp    %eax,%esi
  8038c4:	73 0a                	jae    8038d0 <__umoddi3+0xb0>
  8038c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8038ca:	19 ea                	sbb    %ebp,%edx
  8038cc:	89 d7                	mov    %edx,%edi
  8038ce:	89 c3                	mov    %eax,%ebx
  8038d0:	89 ca                	mov    %ecx,%edx
  8038d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8038d7:	29 de                	sub    %ebx,%esi
  8038d9:	19 fa                	sbb    %edi,%edx
  8038db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8038df:	89 d0                	mov    %edx,%eax
  8038e1:	d3 e0                	shl    %cl,%eax
  8038e3:	89 d9                	mov    %ebx,%ecx
  8038e5:	d3 ee                	shr    %cl,%esi
  8038e7:	d3 ea                	shr    %cl,%edx
  8038e9:	09 f0                	or     %esi,%eax
  8038eb:	83 c4 1c             	add    $0x1c,%esp
  8038ee:	5b                   	pop    %ebx
  8038ef:	5e                   	pop    %esi
  8038f0:	5f                   	pop    %edi
  8038f1:	5d                   	pop    %ebp
  8038f2:	c3                   	ret    
  8038f3:	90                   	nop
  8038f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8038f8:	85 ff                	test   %edi,%edi
  8038fa:	89 f9                	mov    %edi,%ecx
  8038fc:	75 0b                	jne    803909 <__umoddi3+0xe9>
  8038fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803903:	31 d2                	xor    %edx,%edx
  803905:	f7 f7                	div    %edi
  803907:	89 c1                	mov    %eax,%ecx
  803909:	89 d8                	mov    %ebx,%eax
  80390b:	31 d2                	xor    %edx,%edx
  80390d:	f7 f1                	div    %ecx
  80390f:	89 f0                	mov    %esi,%eax
  803911:	f7 f1                	div    %ecx
  803913:	e9 31 ff ff ff       	jmp    803849 <__umoddi3+0x29>
  803918:	90                   	nop
  803919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803920:	39 dd                	cmp    %ebx,%ebp
  803922:	72 08                	jb     80392c <__umoddi3+0x10c>
  803924:	39 f7                	cmp    %esi,%edi
  803926:	0f 87 21 ff ff ff    	ja     80384d <__umoddi3+0x2d>
  80392c:	89 da                	mov    %ebx,%edx
  80392e:	89 f0                	mov    %esi,%eax
  803930:	29 f8                	sub    %edi,%eax
  803932:	19 ea                	sbb    %ebp,%edx
  803934:	e9 14 ff ff ff       	jmp    80384d <__umoddi3+0x2d>
